Return-Path: <kvm+bounces-10125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D437686A05A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B595B31BD7
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF171487D1;
	Tue, 27 Feb 2024 19:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ocF1YLtd"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB1451C4C
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061717; cv=none; b=etX1wsK/ZyftSr0GBu1kpyYzogGgdD8ugsVx52K4YoEIXG8u8gIPMp+Q1dgXF+y0e0PN9JX19cp7+r8/c/Cs5O3QRgsQ8Hn0aa7sTqDYZkyAze04et5zqFYsr8gELrQglPbjhOJxj3Yk1k/2bv5wPCNn4JirvtRS/Oh3siutRpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061717; c=relaxed/simple;
	bh=+87A1CLuPYmWQv1oUGPFcYv3qb+kFj+nzjulbjt00DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=GJsKoFQYD1ABdU6FLqIfg69kbws5sA9ezHOSRLfp2UvAMV0U1VhAgDUbOrWOjvEHR1SijgRaAEEpDWMTCHQETd1ndb0Jk1RNpUDkKRDF8Mrkt5lGIjKpvgVyERLMmBmpfd7EizFYh0frLs1nnfc9FfAPscUe+IrcxQGgXIPoERs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ocF1YLtd; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYIGX75dQSVnqZLE7dR9AMY2g18MgSVcQmfFU0atTE4=;
	b=ocF1YLtdHZW7DoF7gYiErUsRABFl0/HntJy6vnKdt6/q5cYM+/zTE4421DL3qzyejFWcPV
	D8NoZi8KQuD7iIjhzEPKsuTfV/BfvPWtELJXjiPAsB8CfSYu7Uty6DrbIunU4bLZJFVCas
	zcCH2DIPXsupYsoPlUQvl+1aPzeD0QA=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 10/18] arm64: efi: Allow running tests directly
Date: Tue, 27 Feb 2024 20:21:20 +0100
Message-ID: <20240227192109.487402-30-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since it's possible to run tests with UEFI and the QEMU -kernel
option (and now the DTB will be found and even the environ will
be set up from an initrd if given with the -initrd option), then
we can skip the loading of EFI tests into a file system and booting
to the shell to run them. Just run them directly. Running directly
is waaaaaay faster than booting the shell first. We keep the UEFI
shell as the default behavior, though, and provide a new configure
option to enable the direct running.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 17 +++++++++++++++--
 arm/run     |  4 +++-
 configure   | 17 +++++++++++++++++
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index b7a8418a07f8..af7b593c2bb8 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -18,10 +18,12 @@ elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
 	DEFAULT_UEFI=/usr/share/edk2/aarch64/QEMU_EFI.silent.fd
 fi
 
+KERNEL_NAME=$1
+
 : "${EFI_SRC:=$TEST_DIR}"
 : "${EFI_UEFI:=$DEFAULT_UEFI}"
 : "${EFI_TEST:=efi-tests}"
-: "${EFI_CASE:=$(basename $1 .efi)}"
+: "${EFI_CASE:=$(basename $KERNEL_NAME .efi)}"
 : "${EFI_TESTNAME:=$TESTNAME}"
 : "${EFI_TESTNAME:=$EFI_CASE}"
 : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
@@ -80,4 +82,15 @@ uefi_shell_run()
 		"${qemu_args[@]}"
 }
 
-uefi_shell_run
+if [ "$EFI_DIRECT" = "y" ]; then
+	if [ "$EFI_USE_ACPI" != "y" ]; then
+		qemu_args+=(-machine acpi=off)
+	fi
+	$TEST_DIR/run \
+		$KERNEL_NAME \
+		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
+		-bios "$EFI_UEFI" \
+		"${qemu_args[@]}"
+else
+	uefi_shell_run
+fi
diff --git a/arm/run b/arm/run
index 40c2ca66ba7e..efdd44ce86a7 100755
--- a/arm/run
+++ b/arm/run
@@ -60,7 +60,7 @@ if ! $qemu $M -chardev '?' | grep -q testdev; then
 	exit 2
 fi
 
-if [ "$UEFI_SHELL_RUN" != "y" ]; then
+if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
 	chr_testdev='-device virtio-serial-device'
 	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
 fi
@@ -77,6 +77,8 @@ command="$(migration_cmd) $(timeout_cmd) $command"
 
 if [ "$UEFI_SHELL_RUN" = "y" ]; then
 	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
+elif [ "$EFI_USE_ACPI" = "y" ]; then
+	run_qemu_status $command -kernel "$@"
 else
 	run_qemu $command -kernel "$@"
 fi
diff --git a/configure b/configure
index 05e6702eab06..283c959973fd 100755
--- a/configure
+++ b/configure
@@ -32,6 +32,7 @@ enable_dump=no
 page_size=
 earlycon=
 efi=
+efi_direct=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -89,6 +90,11 @@ usage() {
 	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)
 	    --[enable|disable]-werror
 	                           Select whether to compile with the -Werror compiler flag
+	    --[enable|disable]-efi-direct
+	                           Select whether to run EFI tests directly with QEMU's -kernel
+	                           option. When not enabled, tests will be placed in an EFI file
+	                           system and run from the UEFI shell. Ignored when efi isn't enabled.
+	                           (arm64 only)
 EOF
     exit 1
 }
@@ -168,6 +174,12 @@ while [[ "$1" = -* ]]; do
 	--disable-efi)
 	    efi=n
 	    ;;
+	--enable-efi-direct)
+	    efi_direct=y
+	    ;;
+	--disable-efi-direct)
+	    efi_direct=n
+	    ;;
 	--enable-werror)
 	    werror=-Werror
 	    ;;
@@ -185,6 +197,10 @@ while [[ "$1" = -* ]]; do
     esac
 done
 
+if [ -z "$efi" ] || [ "$efi" = "n" ]; then
+    [ "$efi_direct" = "y" ] && efi_direct=
+fi
+
 if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
     echo "Host key document doesn't exist at the specified location."
     exit 1
@@ -423,6 +439,7 @@ GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 CONFIG_DUMP=$enable_dump
 CONFIG_EFI=$efi
+EFI_DIRECT=$efi_direct
 CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
 EOF
-- 
2.43.0


