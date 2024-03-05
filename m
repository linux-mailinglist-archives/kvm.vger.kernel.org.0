Return-Path: <kvm+bounces-11031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6218724B1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25A4A286436
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9281429F;
	Tue,  5 Mar 2024 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ibPNOD7M"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8868ADDAE
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657221; cv=none; b=nxbwuRXvFWp4FXYhynHPRsKuJW8q8v87eW+8e5gaIH2NuFUJseXt0mcilQI2NOp3Dhn19+tJGkkrKLZGQvZdvlqjmLZBXEjcVK6LFh57ipj/twWe4I6/WB9kfkG6bmTRYLsLFfOzCb6wGQ8lUnCoy7D5TPpKNezAZf33SwpmSho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657221; c=relaxed/simple;
	bh=yJc3tu6HHxziGlp2mMFCYKnmg2pzvSM8uqQWe6HEnfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=By6afTUgCfa9h/C1q3jmzzYiPpiRctQWfCfs6dePKMfMoetssJip/Fmvj/dUUjXKz3nHcRNXxwbIUKtDM3Vx8ipxcbPlGAeD/o25O3BJVuLjekEcqvepoAjjK2yKSvFCcHwtYftN9cdX0+9dQm2OjXYahARrjswQquYGW7R6Z7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ibPNOD7M; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMFQJachdD4MGpLHrdXbqKLfNhIFHRyDk1y7TwCZKgY=;
	b=ibPNOD7M0rOQYi59nh+3ApFjDyWl20Gs91qWH6XUlo3TI4OnI4bHL9lWzI0vCxkvm6svzH
	lH0MTIUAcfhvbm/gnJhTfFIpayCF1/TGs7AdD6YX5p7hVJCiL7Y1fUESaxbUrZ6DdxHrMQ
	CjNaq1E/4UtSAO8iaGypSE8muE/bvpc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 10/18] arm64: efi: Allow running tests directly
Date: Tue,  5 Mar 2024 17:46:34 +0100
Message-ID: <20240305164623.379149-30-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
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

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 18 +++++++++++++++---
 arm/run     |  4 +++-
 configure   | 17 +++++++++++++++++
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index b7a8418a07f8..f07a6e55c381 100755
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
@@ -49,6 +51,9 @@ while (( "$#" )); do
 		shift 1
 	fi
 done
+if [ "$EFI_USE_ACPI" != "y" ]; then
+	qemu_args+=(-machine acpi=off)
+fi
 
 if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	EFI_CASE_DIR="$EFI_TEST/dummy"
@@ -67,7 +72,6 @@ uefi_shell_run()
 	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
 	echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
 	if [ "$EFI_USE_ACPI" != "y" ]; then
-		qemu_args+=(-machine acpi=off)
 		FDT_BASENAME="dtb"
 		UEFI_SHELL_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
 		echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
@@ -80,4 +84,12 @@ uefi_shell_run()
 		"${qemu_args[@]}"
 }
 
-uefi_shell_run
+if [ "$EFI_DIRECT" = "y" ]; then
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
index 4a00bdfeb8fd..51edee8cd21b 100755
--- a/configure
+++ b/configure
@@ -32,6 +32,7 @@ enable_dump=no
 page_size=
 earlycon=
 efi=
+efi_direct=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -90,6 +91,11 @@ usage() {
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
@@ -169,6 +175,12 @@ while [[ "$1" = -* ]]; do
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
@@ -186,6 +198,10 @@ while [[ "$1" = -* ]]; do
     esac
 done
 
+if [ -z "$efi" ] || [ "$efi" = "n" ]; then
+    [ "$efi_direct" = "y" ] && efi_direct=
+fi
+
 if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
     echo "Host key document doesn't exist at the specified location."
     exit 1
@@ -428,6 +444,7 @@ GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 CONFIG_DUMP=$enable_dump
 CONFIG_EFI=$efi
+EFI_DIRECT=$efi_direct
 CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
 EOF
-- 
2.44.0


