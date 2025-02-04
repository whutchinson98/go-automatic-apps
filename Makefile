SHELL=/bin/bash -e -o pipefail
PWD = $(shell pwd)

## help: Print this help message
.PHONY: help
help:
	@echo "Usage:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' |  sed -e 's/^/ /'

## test: Run tests
.PHONY: test
test:
	go test -race -v ./...

## cover: Run tests and show coverage result
.PHONY: cover
cover:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -func=coverage.out

## tidy: Cleanup and download missing dependencies
.PHONY: tidy
tidy:
	go mod tidy
	go mod verify

## vet: Examine Go source code and reports suspicious constructs
.PHONY: vet
vet:
	go vet ./...

## fmt: Format all go source files
.PHONY: fmt
fmt:
	go fmt ./...

## protoc: Generate code from proto files
.PHONY: protoc
protoc:
	protoc -I=./proto --go_out=. --go-grpc_out=. ./proto/*.proto

## build: Build binary into bin/ directory
.PHONY: build
build:
	yarn --cwd ./server/web install
	yarn --cwd ./server/web build
	go build -ldflags="-w -s" -o bin/ ./cmd/...
