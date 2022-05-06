Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE57F51E089
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444303AbiEFVBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444296AbiEFVBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:01:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C25406EC4A
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:57:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9484E152B;
        Fri,  6 May 2022 13:57:17 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF2343F800;
        Fri,  6 May 2022 13:57:16 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 23/23] arm64: Add an efi/run script
Date:   Fri,  6 May 2022 21:56:05 +0100
Message-Id: <20220506205605.359830-24-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506205605.359830-1-nikos.nikoleris@arm.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

$> ./arm/efi/run ./arm/selftest.efi setup smp=2 mem=256

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 scripts/runtime.bash | 14 +++++-----
 arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
 arm/run              |  8 ++++--
 arm/Makefile.common  |  1 +
 arm/dummy.c          |  4 +++
 5 files changed, 78 insertions(+), 10 deletions(-)
 create mode 100755 arm/efi/run
 create mode 100644 arm/dummy.c

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 7d0180b..dc28f24 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -131,14 +131,12 @@ function run()
     fi
 
     last_line=$(premature_failure > >(tail -1)) && {
-        skip=true
-        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
-            skip=false
-        fi
-        if [ ${skip} == true ]; then
-            print_result "SKIP" $testname "" "$last_line"
-            return 77
-        fi
+        if [ "${CONFIG_EFI}" == "y" ] && [ "${ARCH}" = x86_64 ]; then
+		if ! [[ "${last_line}" =~ "enabling apic" ]]; then
+			print_result "SKIP" $testname "" "$last_line"
+			return 77
+		fi
+	fi
     }
 
     cmdline=$(get_cmdline $kernel)
diff --git a/arm/efi/run b/arm/efi/run
new file mode 100755
index 0000000..dfff717
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
index 28a0b4a..e96875e 100755
--- a/arm/run
+++ b/arm/run
@@ -67,7 +67,11 @@ fi
 
 A="-accel $ACCEL"
 command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
-command+=" -display none -serial stdio -kernel"
+command+=" -display none -serial stdio"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
-run_qemu $command "$@"
+if [ "$EFI_RUN" = "y" ]; then
+	ENVIRON_DEFAULT=n run_qemu $command "$@"
+else
+	run_qemu $command -kernel "$@"
+fi
diff --git a/arm/Makefile.common b/arm/Makefile.common
index a8007f4..aabd335 100644
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
index 0000000..5019e79
--- /dev/null
+++ b/arm/dummy.c
@@ -0,0 +1,4 @@
+int main(int argc, char **argv)
+{
+	return 0;
+}
-- 
2.25.1

