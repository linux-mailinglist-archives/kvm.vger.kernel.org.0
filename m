Return-Path: <kvm+bounces-11053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0154B872558
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:11:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8604FB2751C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8146B1B5A0;
	Tue,  5 Mar 2024 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Av1EMCoO"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1B16415
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658573; cv=none; b=Vdpy/pINk5UWyuxrlpGpvUTivUkWypiJLKvFGCFCSKl/WsNszPM2NEc5dd2f8wd2KSveJMdNoRFpgM9NKo0nPRypKbkyQ9Xzr01dRvT8rf6jp+wthgnykvnGBMuxzgJZeBQbfmOZ4F8AA/FInPfkSkZhVFhPvpEgjYshH1AGSCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658573; c=relaxed/simple;
	bh=PAP8eNpKywWl13DELhdevw11zewy3p4Iiw3v1n8ivG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=m0erWWVrM/EaRaWaoYfCdiLqWdsYLbAU1Jz5OiAJ+PeXFeL27POPxJogc3sVtq3uNYehWrrvSTMa8Y213cOHNTBc2cviHkAVF1JUC576vaMA+dpGanQ0JdDgird9z86YNhPLsEhrfws/GrpGJhzgQPOXm8Xgylmkt3lia3pTCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Av1EMCoO; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JY9grXapR998eBsxB/B/DVCqHbvzZICu4UvuQ2ASXSg=;
	b=Av1EMCoOkkrguIRUQbcTg7HR0IcDUEPBZv2srSC4W+e7Zx5W8gEz9Q503caNeYZGJbU20U
	8hheil8RkrQ+L0kzTud+XMtw69ETaQo8wVxy7AjruzTjva2PsReJ/m042A4t+snbubqjP8
	lylVpYXhoLF9oa8N7t1+FHf66QunQJo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 12/13] riscv: efi: Add run script
Date: Tue,  5 Mar 2024 18:09:11 +0100
Message-ID: <20240305170858.395836-27-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Adapt Arm's efi run script to riscv. We can now run efi tests with
run_tests.sh.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure     |   2 +-
 riscv/efi/run | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++
 riscv/run     |   2 +-
 3 files changed, 108 insertions(+), 2 deletions(-)
 create mode 100755 riscv/efi/run

diff --git a/configure b/configure
index c1d0fe4adbb0..14d2569e9e0d 100755
--- a/configure
+++ b/configure
@@ -95,7 +95,7 @@ usage() {
 	                           Select whether to run EFI tests directly with QEMU's -kernel
 	                           option. When not enabled, tests will be placed in an EFI file
 	                           system and run from the UEFI shell. Ignored when efi isn't enabled.
-	                           (arm64 only)
+	                           (arm64 and riscv64 only)
 EOF
     exit 1
 }
diff --git a/riscv/efi/run b/riscv/efi/run
new file mode 100755
index 000000000000..982b8b9c455a
--- /dev/null
+++ b/riscv/efi/run
@@ -0,0 +1,106 @@
+#!/bin/bash
+
+if [ $# -eq 0 ]; then
+	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
+	exit 2
+fi
+
+if [ ! -f config.mak ]; then
+	echo "run './configure --enable-efi && make' first. See ./configure -h"
+	exit 2
+fi
+source config.mak
+source scripts/arch-run.bash
+
+if [ -f RISCV_VIRT_CODE.fd ]; then
+	DEFAULT_UEFI=RISCV_VIRT_CODE.fd
+fi
+
+KERNEL_NAME=$1
+
+: "${EFI_SRC:=$TEST_DIR}"
+: "${EFI_UEFI:=$DEFAULT_UEFI}"
+: "${EFI_TEST:=efi-tests}"
+: "${EFI_CASE:=$(basename $KERNEL_NAME .efi)}"
+: "${EFI_TESTNAME:=$TESTNAME}"
+: "${EFI_TESTNAME:=$EFI_CASE}"
+: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
+: "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
+
+if [ ! -f "$EFI_UEFI" ]; then
+	echo "UEFI firmware not found."
+	echo "Please specify the path with the env variable EFI_UEFI"
+	exit 2
+fi
+
+if [ "$EFI_USE_ACPI" = "y" ]; then
+	echo "ACPI not available"
+	exit 2
+fi
+
+# Remove the TEST_CASE from $@
+shift 1
+
+# Fish out the arguments for the test, they should be the next string
+# after the "-append" option
+qemu_args=()
+cmd_args=()
+while (( "$#" )); do
+	if [ "$1" = "-append" ]; then
+		cmd_args=$2
+		shift 2
+	else
+		qemu_args+=("$1")
+		shift 1
+	fi
+done
+
+if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
+	EFI_CASE_DIR="$EFI_TEST/dummy"
+	mkdir -p "$EFI_CASE_DIR"
+	$TEST_DIR/run \
+		$EFI_CASE \
+		-machine pflash0=pflash0 \
+		-blockdev node-name=pflash0,driver=file,read-only=on,filename="$EFI_UEFI" \
+		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		"${qemu_args[@]}"
+	exit
+fi
+
+uefi_shell_run()
+{
+	mkdir -p "$EFI_CASE_DIR"
+	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
+	echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
+	if [ "$EFI_USE_ACPI" != "y" ]; then
+		qemu_args+=(-machine acpi=off)
+		FDT_BASENAME="dtb"
+		UEFI_SHELL_RUN=y $TEST_DIR/run \
+			-machine pflash0=pflash0 \
+			-blockdev node-name=pflash0,driver=file,read-only=on,filename="$EFI_UEFI" \
+			-machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" \
+			"${qemu_args[@]}"
+		echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
+	fi
+	echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
+
+	UEFI_SHELL_RUN=y $TEST_DIR/run \
+		-machine pflash0=pflash0 \
+		-blockdev node-name=pflash0,driver=file,read-only=on,filename="$EFI_UEFI" \
+		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		"${qemu_args[@]}"
+}
+
+if [ "$EFI_DIRECT" = "y" ]; then
+	if [ "$EFI_USE_ACPI" != "y" ]; then
+		qemu_args+=(-machine acpi=off)
+	fi
+	$TEST_DIR/run \
+		$KERNEL_NAME \
+		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
+		-machine pflash0=pflash0 \
+		-blockdev node-name=pflash0,driver=file,read-only=on,filename="$EFI_UEFI" \
+		"${qemu_args[@]}"
+else
+	uefi_shell_run
+fi
diff --git a/riscv/run b/riscv/run
index cbe5dd792dcd..73f2bf54dc32 100755
--- a/riscv/run
+++ b/riscv/run
@@ -33,7 +33,7 @@ command="$qemu -nodefaults -nographic -serial mon:stdio"
 command+=" $mach $acc $firmware -cpu $processor "
 command="$(migration_cmd) $(timeout_cmd) $command"
 
-if [ "$EFI_RUN" = "y" ]; then
+if [ "$UEFI_SHELL_RUN" = "y" ]; then
 	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
 else
 	# We return the exit code via stdout, not via the QEMU return code
-- 
2.44.0


