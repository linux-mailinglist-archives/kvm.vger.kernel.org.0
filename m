Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342476942B0
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjBMKUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjBMKT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:19:59 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F26B17CCB
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:19:35 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94EE21FC7;
        Mon, 13 Feb 2023 02:19:21 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20EBE3F703;
        Mon, 13 Feb 2023 02:18:38 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 30/30] arm64: Add an efi/run script
Date:   Mon, 13 Feb 2023 10:17:59 +0000
Message-Id: <20230213101759.2577077-31-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds a efi/run script inspired by the one in x86. This
script will setup a folder with the test compiled as an EFI app and a
startup.nsh script. The script launches QEMU providing an image with
EDKII and the path to the folder with the test which is executed
automatically.

For example:

$> ./arm/efi/run ./arm/selftest.efi setup smp=2 mem=256

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 arm/Makefile.common  |  1 +
 arm/dummy.c          | 12 +++++++++
 arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
 arm/run              | 14 +++++++---
 scripts/runtime.bash | 13 +++++++---
 5 files changed, 94 insertions(+), 7 deletions(-)
 create mode 100644 arm/dummy.c
 create mode 100755 arm/efi/run

diff --git a/arm/Makefile.common b/arm/Makefile.common
index e251f6a8..90a6ff3a 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -12,6 +12,7 @@ tests-common += $(TEST_DIR)/gic.$(exe)
 tests-common += $(TEST_DIR)/psci.$(exe)
 tests-common += $(TEST_DIR)/sieve.$(exe)
 tests-common += $(TEST_DIR)/pl031.$(exe)
+tests-common += $(TEST_DIR)/dummy.$(exe)
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/dummy.c b/arm/dummy.c
new file mode 100644
index 00000000..7033bb7c
--- /dev/null
+++ b/arm/dummy.c
@@ -0,0 +1,12 @@
+#include "libcflat.h"
+
+int main(int argc, char **argv)
+{
+	/*
+	 * scripts/runtime.bash uses this test as a canary to determine if the
+	 * basic setup is functional.  Print a magic string to let runtime.bash
+	 * know that all is well.
+	 */
+	printf("Dummy Hello World!");
+	return 0;
+}
diff --git a/arm/efi/run b/arm/efi/run
new file mode 100755
index 00000000..dfff717a
--- /dev/null
+++ b/arm/efi/run
@@ -0,0 +1,61 @@
+#!/bin/bash
+
+set -e
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
+source scripts/common.bash
+
+: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
+: "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
+: "${EFI_TEST:=efi-tests}"
+: "${EFI_CASE:=$(basename $1 .efi)}"
+
+if [ ! -f "$EFI_UEFI" ]; then
+	echo "UEFI firmware not found: $EFI_UEFI"
+	echo "Please install the UEFI firmware to this path"
+	echo "Or specify the correct path with the env variable EFI_UEFI"
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
+	EFI_CASE=dummy
+fi
+
+: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
+mkdir -p "$EFI_CASE_DIR"
+
+cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
+echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
+echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
+
+EFI_RUN=y $TEST_DIR/run \
+       -bios "$EFI_UEFI" \
+       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+       "${qemu_args[@]}"
diff --git a/arm/run b/arm/run
index 12848912..62f845b3 100755
--- a/arm/run
+++ b/arm/run
@@ -65,8 +65,10 @@ if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
 	exit 2
 fi
 
-chr_testdev='-device virtio-serial-device'
-chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
+if [ "$EFI_RUN" != "y" ]; then
+	chr_testdev='-device virtio-serial-device'
+	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
+fi
 
 pci_testdev=
 if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
@@ -75,7 +77,11 @@ fi
 
 A="-accel $ACCEL"
 command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
-command+=" -display none -serial stdio -kernel"
+command+=" -display none -serial stdio"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
-run_qemu $command "$@"
+if [ "$EFI_RUN" = "y" ]; then
+	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
+else
+	run_qemu $command -kernel "$@"
+fi
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9a..13eade26 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -130,11 +130,18 @@ function run()
         done
     fi
 
-    last_line=$(premature_failure > >(tail -1)) && {
+    log=$(premature_failure) && {
         skip=true
-        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "Dummy Hello World!" ]]; then
-            skip=false
+        if [ "${CONFIG_EFI}" == "y" ]; then
+            if [ "$ARCH" == "x86_64" ] &&
+               [[ "$(tail -1 <<<"$log")" =~ "Dummy Hello World!" ]]; then
+                   skip=false
+            elif [ "$ARCH" == "arm64" ] &&
+               [[ "$(tail -2 <<<"$log" | head -1)" =~ "Dummy Hello World!" ]]; then
+                   skip=false
+            fi
         fi
+
         if [ ${skip} == true ]; then
             print_result "SKIP" $testname "" "$last_line"
             return 77
-- 
2.25.1

