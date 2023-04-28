Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305896F173D
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346042AbjD1MFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346041AbjD1MFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:05:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED2DB618B
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:05:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCC3C1596;
        Fri, 28 Apr 2023 05:06:05 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB2323F5A1;
        Fri, 28 Apr 2023 05:05:20 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 29/29] arm64: Add an efi/run script
Date:   Fri, 28 Apr 2023 13:04:05 +0100
Message-Id: <20230428120405.3770496-30-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

$> ./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 scripts/runtime.bash | 13 +++++++---
 arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
 arm/run              | 14 +++++++---
 arm/Makefile.common  |  1 +
 arm/dummy.c          | 12 +++++++++
 5 files changed, 94 insertions(+), 7 deletions(-)
 create mode 100755 arm/efi/run
 create mode 100644 arm/dummy.c

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 07b62b0e..785a7b62 100644
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
index c6f25b8c..de520c11 100755
--- a/arm/run
+++ b/arm/run
@@ -64,8 +64,10 @@ if ! $qemu $M -chardev '?' | grep -q testdev; then
 	exit 2
 fi
 
-chr_testdev='-device virtio-serial-device'
-chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
+if [ "$EFI_RUN" != "y" ]; then
+	chr_testdev='-device virtio-serial-device'
+	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
+fi
 
 pci_testdev=
 if $qemu $M -device '?' | grep -q pci-testdev; then
@@ -74,7 +76,11 @@ fi
 
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
diff --git a/arm/Makefile.common b/arm/Makefile.common
index a133309d..d60cf8cd 100644
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
-- 
2.25.1

