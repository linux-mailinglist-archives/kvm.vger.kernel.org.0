Return-Path: <kvm+bounces-50720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F26EAE88AE
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83C104A6280
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F387229C32C;
	Wed, 25 Jun 2025 15:48:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E7927FD74;
	Wed, 25 Jun 2025 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866538; cv=none; b=LcSlyR07VQb8Oztzf30KBr8thktsYlw7l+tNGCSmPFwX9QepkwsawzzQF5Z42ngU56LWlPMj7dcZeemkGb6Z6QSE5dD0W0TsI63kvF+fYu0ZyDRJuS3oHtnnbv7yKlO6r3wTjrIJL4xz9Yg7pYgfviZMVzpzYWQISWyPl4/ibnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866538; c=relaxed/simple;
	bh=LEqvcx2VMZqqFGOWOhpUvd5rNuDUtvn2gUl4dcSF+yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7grHt92/k2IGW0WOXL0SKV6Y2eYuB4eizhBchOp5e5N4u6PH/3E2xsMxf4VDIMNy1cTkySfu1JENvwYX5nB95q4IDjWMFb0JF74GyCzC3Au+vU5nyybALvpyb6gTALeTpTNp+A4fEOCivM1mmw97hGWM8c7FCa/DIw2EgzsuTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1A4922C8;
	Wed, 25 Jun 2025 08:48:36 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 503E43F58B;
	Wed, 25 Jun 2025 08:48:50 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v4 06/13] scripts: Add support for kvmtool
Date: Wed, 25 Jun 2025 16:48:06 +0100
Message-ID: <20250625154813.27254-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250625154813.27254-1-alexandru.elisei@arm.com>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Teach the arm runner to use kvmtool when kvm-unit-tests has been configured
appropriately.

The test is ran using run_test_status(), and a 0 return code (which means
success) is converted to 1, because kvmtool does not have a testdev device
to return the test exit code, so kvm-unit-tests must always parse the
"EXIT: STATUS" line for the exit code.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes v3->v4:

* Use vmm_get_target() in $arch/run instead of testing $TARGET directly.
* Do not source scripts/vmm.bash and config.mak in scripts/arch-run.bash because
that will fail when running standalone tests.
* Source scripts/vmm.bash in $arch/run when not making standalone tests to make
the needed functions available for scripts/arch-run.bash.
* Dropped local variable sig in run_test (shellcheck).
* Use vmm_fixup_return_code(), vmm_optname_initrd() and vmm_get_target() in
scripts/arch-run.bash.

 arm/run               | 161 ++++++++++++++++++++++++++----------------
 powerpc/run           |   5 +-
 riscv/run             |   5 +-
 s390x/run             |   3 +-
 scripts/arch-run.bash | 111 ++++++++++-------------------
 scripts/vmm.bash      | 102 ++++++++++++++++++++++++++
 x86/run               |   5 +-
 7 files changed, 251 insertions(+), 141 deletions(-)

diff --git a/arm/run b/arm/run
index edf0c1dd1b41..9ee795ae424c 100755
--- a/arm/run
+++ b/arm/run
@@ -12,80 +12,117 @@ fi
 
 vmm_check_supported
 
-qemu_cpu="$TARGET_CPU"
-
-if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
-   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
-   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
-	ACCEL="tcg"
-fi
+function arch_run_qemu()
+{
+	qemu_cpu="$TARGET_CPU"
+
+	if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
+	   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
+	   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
+		ACCEL="tcg"
+	fi
 
-set_qemu_accelerator || exit $?
-if [ "$ACCEL" = "kvm" ]; then
-	QEMU_ARCH=$HOST
-fi
+	set_qemu_accelerator || exit $?
+	if [ "$ACCEL" = "kvm" ]; then
+		QEMU_ARCH=$HOST
+	fi
 
-qemu=$(search_qemu_binary) ||
-	exit $?
+	qemu=$(search_qemu_binary) ||
+		exit $?
 
-if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
-	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
-	exit 2
-fi
+	if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
+		echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
+		exit 2
+	fi
 
-M='-machine virt'
+	M='-machine virt'
 
-if [ "$ACCEL" = "kvm" ]; then
-	if $qemu $M,\? | grep -q gic-version; then
-		M+=',gic-version=host'
+	if [ "$ACCEL" = "kvm" ]; then
+		if $qemu $M,\? | grep -q gic-version; then
+			M+=',gic-version=host'
+		fi
 	fi
-fi
 
-if [ -z "$qemu_cpu" ]; then
-	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
-	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
-		qemu_cpu="host"
-		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
-			qemu_cpu+=",aarch64=off"
+	if [ -z "$qemu_cpu" ]; then
+		if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
+		   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
+			qemu_cpu="host"
+			if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
+				qemu_cpu+=",aarch64=off"
+			fi
+		else
+			qemu_cpu="$DEFAULT_QEMU_CPU"
 		fi
-	else
-		qemu_cpu="$DEFAULT_QEMU_CPU"
 	fi
-fi
 
-if [ "$ARCH" = "arm" ]; then
-	M+=",highmem=off"
-fi
+	if [ "$ARCH" = "arm" ]; then
+		M+=",highmem=off"
+	fi
 
-if ! $qemu $M -device '?' | grep -q virtconsole; then
-	echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
-	exit 2
-fi
+	if ! $qemu $M -device '?' | grep -q virtconsole; then
+		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
+		exit 2
+	fi
 
-if ! $qemu $M -chardev '?' | grep -q testdev; then
-	echo "$qemu doesn't support chr-testdev. Exiting."
-	exit 2
-fi
+	if ! $qemu $M -chardev '?' | grep -q testdev; then
+		echo "$qemu doesn't support chr-testdev. Exiting."
+		exit 2
+	fi
 
-if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
-	chr_testdev='-device virtio-serial-device'
-	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
-fi
+	if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
+		chr_testdev='-device virtio-serial-device'
+		chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
+	fi
 
-pci_testdev=
-if $qemu $M -device '?' | grep -q pci-testdev; then
-	pci_testdev="-device pci-testdev"
-fi
+	pci_testdev=
+	if $qemu $M -device '?' | grep -q pci-testdev; then
+		pci_testdev="-device pci-testdev"
+	fi
 
-A="-accel $ACCEL$ACCEL_PROPS"
-command="$qemu -nodefaults $M $A -cpu $qemu_cpu $chr_testdev $pci_testdev"
-command+=" -display none -serial stdio"
-command="$(migration_cmd) $(timeout_cmd) $command"
-
-if [ "$UEFI_SHELL_RUN" = "y" ]; then
-	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
-elif [ "$EFI_USE_ACPI" = "y" ]; then
-	run_qemu_status $command -kernel "$@"
-else
-	run_qemu $command -kernel "$@"
-fi
+	A="-accel $ACCEL$ACCEL_PROPS"
+	command="$qemu -nodefaults $M $A -cpu $qemu_cpu $chr_testdev $pci_testdev"
+	command+=" -display none -serial stdio"
+	command="$(migration_cmd) $(timeout_cmd) $command"
+
+	if [ "$UEFI_SHELL_RUN" = "y" ]; then
+		ENVIRON_DEFAULT=n run_test_status $command "$@"
+	elif [ "$EFI_USE_ACPI" = "y" ]; then
+		run_test_status $command -kernel "$@"
+	else
+		run_test $command -kernel "$@"
+	fi
+}
+
+function arch_run_kvmtool()
+{
+	local command
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
+	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
+		run_test_status $command --kernel "$@" --aarch32
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
diff --git a/powerpc/run b/powerpc/run
index 27abf1ef6a4d..0665776448eb 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -16,6 +16,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	fi
 	source config.mak
 	source scripts/arch-run.bash
+	source scripts/vmm.bash
 fi
 
 set_qemu_accelerator || exit $?
@@ -59,8 +60,8 @@ command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
 # powerpc tests currently exit with rtas-poweroff, which exits with 0.
-# run_qemu treats that as a failure exit and returns 1, so we need
+# run_test treats that as a failure exit and returns 1, so we need
 # to fixup the fixup below by parsing the true exit code from the output.
 # The second fixup is also a FIXME, because once we add chr-testdev
 # support for powerpc, we won't need the second fixup.
-run_qemu_status $command "$@"
+run_test_status $command "$@"
diff --git a/riscv/run b/riscv/run
index 3b2fc36f2afb..0f000f0d82c6 100755
--- a/riscv/run
+++ b/riscv/run
@@ -7,6 +7,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	fi
 	source config.mak
 	source scripts/arch-run.bash
+	source scripts/vmm.bash
 fi
 
 # Allow user overrides of some config.mak variables
@@ -36,8 +37,8 @@ command+=" $mach $acc $firmware -cpu $qemu_cpu "
 command="$(migration_cmd) $(timeout_cmd) $command"
 
 if [ "$UEFI_SHELL_RUN" = "y" ]; then
-	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
+	ENVIRON_DEFAULT=n run_test_status $command "$@"
 else
 	# We return the exit code via stdout, not via the QEMU return code
-	run_qemu_status $command -kernel "$@"
+	run_test_status $command -kernel "$@"
 fi
diff --git a/s390x/run b/s390x/run
index 34552c2747d4..c9ca38cd9d0c 100755
--- a/s390x/run
+++ b/s390x/run
@@ -7,6 +7,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	fi
 	source config.mak
 	source scripts/arch-run.bash
+	source scripts/vmm.bash
 fi
 
 set_qemu_accelerator || exit $?
@@ -47,4 +48,4 @@ command+=" -kernel"
 command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
 
 # We return the exit code via stdout, not via the QEMU return code
-run_qemu_status $command "$@"
+run_test_status $command "$@"
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 8643bab3b252..354ce80fe3fa 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -1,32 +1,6 @@
-##############################################################################
-# run_qemu translates the ambiguous exit status in Table1 to that in Table2.
-# Table3 simply documents the complete status table.
-#
-# Table1: Before fixup
-# --------------------
-# 0      - Unexpected exit from QEMU (possible signal), or the unittest did
-#          not use debug-exit
-# 1      - most likely unittest succeeded, or QEMU failed
-#
-# Table2: After fixup
-# -------------------
-# 0      - Everything succeeded
-# 1      - most likely QEMU failed
-#
-# Table3: Complete table
-# ----------------------
-# 0      - SUCCESS
-# 1      - most likely QEMU failed
-# 2      - most likely a run script failed
-# 3      - most likely the unittest failed
-# 124    - most likely the unittest timed out
-# 127    - most likely the unittest called abort()
-# 1..127 - FAILURE (could be QEMU, a run script, or the unittest)
-# >= 128 - Signal (signum = status - 128)
-##############################################################################
-run_qemu ()
+run_test ()
 {
-	local stdout errors ret sig
+	local stdout errors ret
 
 	initrd_create || return $?
 	echo -n "$@"
@@ -39,48 +13,17 @@ run_qemu ()
 	ret=$?
 	exec {stdout}>&-
 
-	[ $ret -eq 134 ] && echo "QEMU Aborted" >&2
-
-	if [ "$errors" ]; then
-		sig=$(grep 'terminating on signal' <<<"$errors")
-		if [ "$sig" ]; then
-			# This is too complex for ${var/search/replace}
-			# shellcheck disable=SC2001
-			sig=$(sed 's/.*terminating on signal \([0-9][0-9]*\).*/\1/' <<<"$sig")
-		fi
-	fi
-
-	if [ $ret -eq 0 ]; then
-		# Some signals result in a zero return status, but the
-		# error log tells the truth.
-		if [ "$sig" ]; then
-			((ret=sig+128))
-		else
-			# Exiting with zero (non-debugexit) is an error
-			ret=1
-		fi
-	elif [ $ret -eq 1 ]; then
-		# Even when ret==1 (unittest success) if we also got stderr
-		# logs, then we assume a QEMU failure. Otherwise we translate
-		# status of 1 to 0 (SUCCESS)
-	        if [ "$errors" ]; then
-			if ! grep -qvi warning <<<"$errors" ; then
-				ret=0
-			fi
-		else
-			ret=0
-		fi
-	fi
+	ret=$(vmm_fixup_return_code $ret $errors)
 
 	return $ret
 }
 
-run_qemu_status ()
+run_test_status ()
 {
 	local stdout ret
 
 	exec {stdout}>&1
-	lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
+	lines=$(run_test "$@" > >(tee /dev/fd/$stdout))
 	ret=$?
 	exec {stdout}>&-
 
@@ -422,6 +365,25 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+search_kvmtool_binary ()
+{
+	local kvmtoolcmd kvmtool
+
+	for kvmtoolcmd in lkvm vm lkvm-static; do
+		if "$kvmtoolcmd" --help 2>/dev/null| grep -q 'The most commonly used'; then
+			kvmtool="$kvmtoolcmd"
+			break
+		fi
+	done
+
+	if [ -z "$kvmtool" ]; then
+		echo "A kvmtool binary was not found." >&2
+		return 2
+	fi
+
+	command -v $kvmtool
+}
+
 initrd_cleanup ()
 {
 	rm -f $KVM_UNIT_TESTS_ENV
@@ -447,7 +409,7 @@ initrd_create ()
 	fi
 
 	unset INITRD
-	[ -f "$KVM_UNIT_TESTS_ENV" ] && INITRD="-initrd $KVM_UNIT_TESTS_ENV"
+	[ -f "$KVM_UNIT_TESTS_ENV" ] && INITRD="$(vmm_optname_initrd) $KVM_UNIT_TESTS_ENV"
 
 	return 0
 }
@@ -471,18 +433,23 @@ env_params ()
 	local qemu have_qemu
 	local _ rest
 
-	qemu=$(search_qemu_binary) && have_qemu=1
+	env_add_params TARGET
 
-	if [ "$have_qemu" ]; then
-		if [ -n "$ACCEL" ] || [ -n "$QEMU_ACCEL" ]; then
-			[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
+	# kvmtool's versioning has been broken since it was split from the
+	# kernel source.
+	if [ "$(vmm_get_target)" = "qemu" ]; then
+		qemu=$(search_qemu_binary) && have_qemu=1
+		if [ "$have_qemu" ]; then
+			if [ -n "$ACCEL" ] || [ -n "$QEMU_ACCEL" ]; then
+				[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
+			fi
+			QEMU_VERSION_STRING="$($qemu -h | head -1)"
+			# Shellcheck does not see QEMU_MAJOR|MINOR|MICRO are used
+			# shellcheck disable=SC2034
+			IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
 		fi
-		QEMU_VERSION_STRING="$($qemu -h | head -1)"
-		# Shellcheck does not see QEMU_MAJOR|MINOR|MICRO are used
-		# shellcheck disable=SC2034
-		IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
+		env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
 	fi
-	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
 
 	KERNEL_VERSION_STRING=$(uname -r)
 	IFS=. read -r KERNEL_VERSION KERNEL_PATCHLEVEL rest <<<"$KERNEL_VERSION_STRING"
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 9a2608eb3fd4..0dd3f971ecdf 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -1,6 +1,95 @@
+##############################################################################
+# qemu_fixup_return_code translates the ambiguous exit status in Table1 to that
+# in Table2.  Table3 simply documents the complete status table.
+#
+# Table1: Before fixup
+# --------------------
+# 0      - Unexpected exit from QEMU (possible signal), or the unittest did
+#          not use debug-exit
+# 1      - most likely unittest succeeded, or QEMU failed
+#
+# Table2: After fixup
+# -------------------
+# 0      - Everything succeeded
+# 1      - most likely QEMU failed
+#
+# Table3: Complete table
+# ----------------------
+# 0      - SUCCESS
+# 1      - most likely QEMU failed
+# 2      - most likely a run script failed
+# 3      - most likely the unittest failed
+# 124    - most likely the unittest timed out
+# 127    - most likely the unittest called abort()
+# 1..127 - FAILURE (could be QEMU, a run script, or the unittest)
+# >= 128 - Signal (signum = status - 128)
+##############################################################################
+function qemu_fixup_return_code()
+{
+	local ret=$1
+	# Remove $ret from the list of arguments
+	shift 1
+	local errors=$*
+	local sig
+
+	[ $ret -eq 134 ] && echo "QEMU Aborted" >&2
+
+	if [ "$errors" ]; then
+		sig=$(grep 'terminating on signal' <<<"$errors")
+		if [ "$sig" ]; then
+			# This is too complex for ${var/search/replace}
+			# shellcheck disable=SC2001
+			sig=$(sed 's/.*terminating on signal \([0-9][0-9]*\).*/\1/' <<<"$sig")
+		fi
+	fi
+
+	if [ $ret -eq 0 ]; then
+		# Some signals result in a zero return status, but the
+		# error log tells the truth.
+		if [ "$sig" ]; then
+			((ret=sig+128))
+		else
+			# Exiting with zero (non-debugexit) is an error
+			ret=1
+		fi
+	elif [ $ret -eq 1 ]; then
+		# Even when ret==1 (unittest success) if we also got stderr
+		# logs, then we assume a QEMU failure. Otherwise we translate
+		# status of 1 to 0 (SUCCESS)
+	        if [ "$errors" ]; then
+			if ! grep -qvi warning <<<"$errors" ; then
+				ret=0
+			fi
+		else
+			ret=0
+		fi
+	fi
+
+	echo $ret
+}
+
+function kvmtool_fixup_return_code()
+{
+	local ret=$1
+
+	# Force run_test_status() to interpret the STATUS line.
+	if [ $ret -eq 0 ]; then
+		ret=1
+	fi
+
+	echo $ret
+}
+
 declare -A vmm_optname=(
 	[qemu,args]='-append'
+	[qemu,fixup_return_code]=qemu_fixup_return_code
+	[qemu,initrd]='-initrd'
 	[qemu,nr_cpus]='-smp'
+
+	[kvmtool,args]='--params'
+	[kvmtool,fixup_return_code]=kvmtool_fixup_return_code
+	[kvmtool,initrd]='--initrd'
+	[kvmtool,nr_cpus]='--cpus'
 )
 
 function vmm_optname_args()
@@ -8,6 +97,16 @@ function vmm_optname_args()
 	echo ${vmm_optname[$(vmm_get_target),args]}
 }
 
+function vmm_fixup_return_code()
+{
+	${vmm_optname[$(vmm_get_target),fixup_return_code]} "$@"
+}
+
+function vmm_optname_initrd()
+{
+	echo ${vmm_optname[$(vmm_get_target),initrd]}
+}
+
 function vmm_optname_nr_cpus()
 {
 	echo ${vmm_optname[$(vmm_get_target),nr_cpus]}
@@ -48,6 +147,9 @@ function vmm_unittest_params_name()
 	qemu)
 		echo "extra_params|qemu_params"
 		;;
+	kvmtool)
+		echo "kvmtool_params"
+		;;
 	*)
 		echo "$0 does not support '$target'"
 		exit 2
diff --git a/x86/run b/x86/run
index a3d3e7db8891..9d21cf3e188d 100755
--- a/x86/run
+++ b/x86/run
@@ -7,6 +7,7 @@ if [ -z "$KUT_STANDALONE" ]; then
 	fi
 	source config.mak
 	source scripts/arch-run.bash
+	source scripts/vmm.bash
 fi
 
 set_qemu_accelerator || exit $?
@@ -49,7 +50,7 @@ if [ "${CONFIG_EFI}" = y ]; then
 	# UEFI, the test case binaries are passed to QEMU through the disk
 	# image, not through the '-kernel' flag. And QEMU reports an error if it
 	# gets '-initrd' without a '-kernel'
-	ENVIRON_DEFAULT=n run_qemu ${command} "$@"
+	ENVIRON_DEFAULT=n run_test ${command} "$@"
 else
-	run_qemu ${command} "$@"
+	run_test ${command} "$@"
 fi
-- 
2.50.0


