Return-Path: <kvm+bounces-45725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90CBDAAE425
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E6F4520955
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF9C28A73E;
	Wed,  7 May 2025 15:13:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4971728A702;
	Wed,  7 May 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630828; cv=none; b=C0U+Zs/HceXj0IfOr9tA/6+TRfGHswpXyT+o1Jrer63wyqjKexWfdJkufHmiN0zxqEmf1fBNnoffvW9Lat7og5ogq9S8DnGa2FXhCEHToD0zhFqKkLzq0Yy+n7HMpgtlMeMyMhxpdtw0NVixwbE9sBWupRQyzugzwoD0KPGGZ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630828; c=relaxed/simple;
	bh=QBJei4dxIMQ0cdDs/ZdOJVAA9jA5Ka2kQMIJp5gt7NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsEaivc6/1S7thKdxPJvBMSqtSTYTW0u08E3mMIe2My2VLfKWQvxeJ4K1rhDXJTdZuX5tTgBVGTymDOox5k2yryr07w00EM5zmMviiRRhIYFWlxKoJ26gW7O6QPMAIpxiEDMs/7nARf09Shz82rJO9XA8ln3PHjcU3rz3E04WQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75E4922C7;
	Wed,  7 May 2025 08:13:35 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E0C53F58B;
	Wed,  7 May 2025 08:13:42 -0700 (PDT)
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
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v3 09/16] scripts: Add support for kvmtool
Date: Wed,  7 May 2025 16:12:49 +0100
Message-ID: <20250507151256.167769-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507151256.167769-1-alexandru.elisei@arm.com>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/run               | 161 ++++++++++++++++++++++++++----------------
 powerpc/run           |   4 +-
 riscv/run             |   4 +-
 s390x/run             |   2 +-
 scripts/arch-run.bash | 112 +++++++++++------------------
 scripts/vmm.bash      |  89 +++++++++++++++++++++++
 x86/run               |   4 +-
 7 files changed, 236 insertions(+), 140 deletions(-)

diff --git a/arm/run b/arm/run
index 56562ed1628f..e3c4ffc49136 100755
--- a/arm/run
+++ b/arm/run
@@ -12,80 +12,117 @@ fi
 
 check_vmm_supported
 
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
+case $TARGET in
+qemu)
+	arch_run_qemu "$@"
+	;;
+kvmtool)
+	arch_run_kvmtool "$@"
+	;;
+esac
diff --git a/powerpc/run b/powerpc/run
index 27abf1ef6a4d..0b25a227429a 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -59,8 +59,8 @@ command+=" -display none -serial stdio -kernel"
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
index 3b2fc36f2afb..562347e8bea2 100755
--- a/riscv/run
+++ b/riscv/run
@@ -36,8 +36,8 @@ command+=" $mach $acc $firmware -cpu $qemu_cpu "
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
index 34552c2747d4..9ecfaf983a3d 100755
--- a/s390x/run
+++ b/s390x/run
@@ -47,4 +47,4 @@ command+=" -kernel"
 command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
 
 # We return the exit code via stdout, not via the QEMU return code
-run_qemu_status $command "$@"
+run_test_status $command "$@"
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 8643bab3b252..8cf67e4f3b51 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -1,30 +1,7 @@
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
+source config.mak
+source scripts/vmm.bash
+
+run_test ()
 {
 	local stdout errors ret sig
 
@@ -39,48 +16,17 @@ run_qemu ()
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
+	ret=$(${vmm_opts[$TARGET:fixup_return_code]} $ret $errors)
 
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
 
@@ -422,6 +368,25 @@ search_qemu_binary ()
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
@@ -447,7 +412,7 @@ initrd_create ()
 	fi
 
 	unset INITRD
-	[ -f "$KVM_UNIT_TESTS_ENV" ] && INITRD="-initrd $KVM_UNIT_TESTS_ENV"
+	[ -f "$KVM_UNIT_TESTS_ENV" ] && INITRD="${vmm_opts[$TARGET:initrd]} $KVM_UNIT_TESTS_ENV"
 
 	return 0
 }
@@ -471,18 +436,23 @@ env_params ()
 	local qemu have_qemu
 	local _ rest
 
-	qemu=$(search_qemu_binary) && have_qemu=1
+	env_add_params TARGET
 
-	if [ "$have_qemu" ]; then
-		if [ -n "$ACCEL" ] || [ -n "$QEMU_ACCEL" ]; then
-			[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
+	# kvmtool's versioning has been broken since it was split from the
+	# kernel source.
+	if [ $TARGET = "qemu" ]; then
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
index b02055a5c0b6..20968f2e6b10 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -1,10 +1,99 @@
 source config.mak
 
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
+qemu_fixup_return_code()
+{
+	local ret=$1
+	# Remove $ret from the list of arguments
+	shift 1
+	local errors="$@"
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
+kvmtool_fixup_return_code()
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
 declare -A vmm_opts=(
 	[qemu:nr_cpus]='-smp'
 	[qemu:kernel]='-kernel'
 	[qemu:args]='-append'
 	[qemu:initrd]='-initrd'
+	[qemu:fixup_return_code]=qemu_fixup_return_code
+
+	[kvmtool:nr_cpus]='--cpus'
+	[kvmtool:kernel]='--kernel'
+	[kvmtool:args]='--params'
+	[kvmtool:initrd]='--initrd'
+	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
 )
 
 function check_vmm_supported()
diff --git a/x86/run b/x86/run
index a3d3e7db8891..91bcd0b9ae41 100755
--- a/x86/run
+++ b/x86/run
@@ -49,7 +49,7 @@ if [ "${CONFIG_EFI}" = y ]; then
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
2.49.0


