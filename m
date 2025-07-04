Return-Path: <kvm+bounces-51602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A77AF9676
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D09245426D0
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FEE28F94E;
	Fri,  4 Jul 2025 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JIrV9LD3"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECCE2BEC28
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751641988; cv=none; b=Wdr1O7oe1prUCoOkYQXA9Jnb7pvTQbWVOSjTv+kvjqQDJFNBxQci8sNrUR50zoB1I1J7n6NEyyBxnYSx5elUWJlwOuAEx9vr/Vxp/a4dQ1HPXUNWnM+lLckix0vwPQ4P0pz9I0WCPDHSyiiBPBPeJK1R7mqagejjIhuOS1pFk8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751641988; c=relaxed/simple;
	bh=bzI7Tai3l9TLzKRn3N4xRUR52eJxvsTEppulQ4AotCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgrHrVI7bnKRK3m006Jwd48obW8RnL2yMdAItmwBooBiorB/iPrzBTgRRDsY3PDJYD3a2DbvZQzq9nCR6T7NuKDkqAeJ7gEWA4t9SRsevhT622jIKm3dYCRr4/Ym8SIe9ph9zeJnx1zQjvwQKMnAm5kYTsmeAtUSLEnkRtU82Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JIrV9LD3; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751641982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1y+Z5PV652LCi65zufILOsYpFuTzL8mqv6TnG3C5fUI=;
	b=JIrV9LD3rrpyypEQ2EwSBaQjl0m04QoiNn3v42obfyVhTelO+0MbTeEgq5QXav0xpy2DOE
	RUwb+SL0QRprowb+7MY8dNQt7ypNWP9oC6HGebqu84bez7Gted/ged/EbySZjIraqfy4SV
	fE2zaHxb5w+0bUM7Qf+SN3/OAusLk4M=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	cleger@rivosinc.com,
	jesse@rivosinc.com,
	jamestiotio@gmail.com,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH 2/2] riscv: Add kvmtool support
Date: Fri,  4 Jul 2025 17:12:57 +0200
Message-ID: <20250704151254.100351-6-andrew.jones@linux.dev>
In-Reply-To: <20250704151254.100351-4-andrew.jones@linux.dev>
References: <20250704151254.100351-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

arm/arm64 supports running tests with kvmtool as a first class citizen.
Most the code to do that is in the common scripts, so just add the riscv
specific bits needed to allow riscv to use kvmtool as a first class
citizen too.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 README.md     |   7 ++--
 configure     |  12 ++++--
 riscv/efi/run |   6 +++
 riscv/run     | 110 +++++++++++++++++++++++++++++++++++---------------
 4 files changed, 96 insertions(+), 39 deletions(-)

diff --git a/README.md b/README.md
index 723ce04cd978..cbd8a9940ec4 100644
--- a/README.md
+++ b/README.md
@@ -65,8 +65,8 @@ or:
 
 to run them all.
 
-All tests can be run using QEMU. On arm and arm64, tests can also be run using
-kvmtool.
+All tests can be run using QEMU. On arm, arm64, riscv32, and riscv64 tests can
+also be run using kvmtool.
 
 By default the runner script searches for a suitable QEMU binary in the system.
 To select a specific QEMU binary though, specify the QEMU=path/to/binary
@@ -97,8 +97,7 @@ variable. kvmtool supports only kvm as the accelerator.
 
 Check [x86/efi/README.md](./x86/efi/README.md).
 
-On arm and arm64, this is only supported with QEMU; kvmtool cannot run the
-tests under UEFI.
+This is only supported with QEMU; kvmtool cannot run the tests under UEFI.
 
 # Tests configuration file
 
diff --git a/configure b/configure
index 470f9d7cdb3b..6d549d1ecb5b 100755
--- a/configure
+++ b/configure
@@ -90,7 +90,7 @@ usage() {
 	                           selects the best value based on the host system and the
 	                           test configuration.
 	    --target=TARGET        target platform that the tests will be running on (qemu or
-	                           kvmtool, default is qemu) (arm/arm64 only)
+	                           kvmtool, default is qemu) (arm/arm64 and riscv32/riscv64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC                c compiler to use ($cc)
 	    --cflags=FLAGS         extra options to be passed to the c compiler
@@ -284,7 +284,8 @@ fi
 if [ -z "$target" ]; then
     target="qemu"
 else
-    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
+    if [ "$arch" != "arm" ] && [ "$arch" != "arm64" ] &&
+       [ "$arch" != "riscv32" ] && [ "$arch" != "riscv64" ]; then
         echo "--target is not supported for $arch"
         usage
     fi
@@ -393,6 +394,10 @@ elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     testdir=riscv
     arch_libdir=riscv
     : "${uart_early_addr:=0x10000000}"
+    if [ "$target" != "qemu" ] && [ "$target" != "kvmtool" ]; then
+        echo "--target must be one of 'qemu' or 'kvmtool'!"
+        usage
+    fi
 elif [ "$arch" = "s390x" ]; then
     testdir=s390x
 else
@@ -519,7 +524,8 @@ EFI_DIRECT=$efi_direct
 CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
 EOF
-if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
+if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ] ||
+   [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     echo "TARGET=$target" >> config.mak
 fi
 
diff --git a/riscv/efi/run b/riscv/efi/run
index 5a72683a6ef5..b9b75440c659 100755
--- a/riscv/efi/run
+++ b/riscv/efi/run
@@ -11,6 +11,12 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 source scripts/arch-run.bash
+source scripts/vmm.bash
+
+if [[ $(vmm_get_target) == "kvmtool" ]]; then
+	echo "kvmtool does not support EFI tests."
+	exit 2
+fi
 
 if [ -f RISCV_VIRT_CODE.fd ]; then
 	DEFAULT_UEFI=RISCV_VIRT_CODE.fd
diff --git a/riscv/run b/riscv/run
index 0f000f0d82c6..7bcf235fb645 100755
--- a/riscv/run
+++ b/riscv/run
@@ -10,35 +10,81 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source scripts/vmm.bash
 fi
 
-# Allow user overrides of some config.mak variables
-mach=$MACHINE_OVERRIDE
-qemu_cpu=$TARGET_CPU_OVERRIDE
-firmware=$FIRMWARE_OVERRIDE
-
-: "${mach:=virt}"
-: "${qemu_cpu:=$TARGET_CPU}"
-: "${qemu_cpu:=$DEFAULT_QEMU_CPU}"
-: "${firmware:=$FIRMWARE}"
-[ "$firmware" ] && firmware="-bios $firmware"
-
-set_qemu_accelerator || exit $?
-[ "$ACCEL" = "kvm" ] && QEMU_ARCH=$HOST
-acc="-accel $ACCEL$ACCEL_PROPS"
-
-qemu=$(search_qemu_binary) || exit $?
-if [ "$mach" = 'virt' ] && ! $qemu -machine '?' | grep -q 'RISC-V VirtIO board'; then
-	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
-	exit 2
-fi
-mach="-machine $mach"
-
-command="$qemu -nodefaults -nographic -serial mon:stdio"
-command+=" $mach $acc $firmware -cpu $qemu_cpu "
-command="$(migration_cmd) $(timeout_cmd) $command"
-
-if [ "$UEFI_SHELL_RUN" = "y" ]; then
-	ENVIRON_DEFAULT=n run_test_status $command "$@"
-else
-	# We return the exit code via stdout, not via the QEMU return code
-	run_test_status $command -kernel "$@"
-fi
+vmm_check_supported
+
+function arch_run_qemu()
+{
+	# Allow user overrides of some config.mak variables
+	mach=$MACHINE_OVERRIDE
+	qemu_cpu=$TARGET_CPU_OVERRIDE
+	firmware=$FIRMWARE_OVERRIDE
+
+	: "${mach:=virt}"
+	: "${qemu_cpu:=$TARGET_CPU}"
+	: "${qemu_cpu:=$DEFAULT_QEMU_CPU}"
+	: "${firmware:=$FIRMWARE}"
+	[ "$firmware" ] && firmware="-bios $firmware"
+
+	set_qemu_accelerator || exit $?
+	[ "$ACCEL" = "kvm" ] && QEMU_ARCH=$HOST
+	acc="-accel $ACCEL$ACCEL_PROPS"
+
+	qemu=$(search_qemu_binary) || exit $?
+	if [ "$mach" = 'virt' ] && ! $qemu -machine '?' | grep -q 'RISC-V VirtIO board'; then
+		echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
+		exit 2
+	fi
+	mach="-machine $mach"
+
+	command="$qemu -nodefaults -nographic -serial mon:stdio"
+	command+=" $mach $acc $firmware -cpu $qemu_cpu "
+	command="$(migration_cmd) $(timeout_cmd) $command"
+
+	if [ "$UEFI_SHELL_RUN" = "y" ]; then
+		ENVIRON_DEFAULT=n run_test_status $command "$@"
+	else
+		# We return the exit code via stdout, not via the QEMU return code
+		run_test_status $command -kernel "$@"
+	fi
+}
+
+function arch_run_kvmtool()
+{
+	local command
+
+	if [ "$HOST" != "riscv32" ] && [ "$HOST" != "riscv64" ]; then
+		echo "kvmtool requires KVM but the host ('$HOST') is not riscv" >&2
+		exit 2
+	fi
+
+	kvmtool=$(search_kvmtool_binary) ||
+		exit $?
+
+	if [ "$ACCEL" ] && [ "$ACCEL" != "kvm" ]; then
+		echo "kvmtool does not support $ACCEL" >&2
+		exit 2
+	fi
+
+	if ! kvm_available; then
+		echo "kvmtool requires KVM but not available on the host" >&2
+		exit 2
+	fi
+
+	command="$(timeout_cmd) $kvmtool run"
+	if ( [ "$HOST" = "riscv64" ] && [ "$ARCH" = "riscv32" ] ) ||
+	   ( [ "$HOST" = "riscv32" ] && [ "$ARCH" = "riscv64" ] ); then
+		echo "Cannot run guests with a different xlen than the host" >&2
+		exit 2
+	else
+		run_test_status $command --kernel "$@"
+	fi
+}
+
+case $(vmm_get_target) in
+qemu)
+	arch_run_qemu "$@"
+	;;
+kvmtool)
+	arch_run_kvmtool "$@"
+	;;
+esac
-- 
2.49.0


