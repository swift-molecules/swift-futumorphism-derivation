// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-futumorphism-derivation",
    products: [
        .library(name: "Futumorphism Derivation", targets: ["Futumorphism Derivation"]),
        .library(name: "Futumorphism Derivation Core", targets: ["Futumorphism Derivation Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-corecursive-derivation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-free-derivation.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Futumorphism Derivation Core", dependencies: [
            .product(name: "Corecursive Derivation Core", package: "swift-corecursive-derivation"),
            .product(name: "Free Derivation Core", package: "swift-free-derivation"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .macro(name: "Futumorphism Derivation Macros", dependencies: [
            "Futumorphism Derivation Core",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),
        .target(name: "Futumorphism Derivation", dependencies: ["Futumorphism Derivation Macros"]),
        .testTarget(
            name: "Futumorphism Derivation Tests",
            dependencies: ["Futumorphism Derivation"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
