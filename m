Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514D7365CF0
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 18:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhDTQNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 12:13:43 -0400
Received: from foss.arm.com ([217.140.110.172]:37754 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232901AbhDTQNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 12:13:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAC3214BF;
        Tue, 20 Apr 2021 09:13:10 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 280633F73B;
        Tue, 20 Apr 2021 09:13:10 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests RFC PATCH 1/1] configure: arm: Replace --vmm with --target
Date:   Tue, 20 Apr 2021 17:13:38 +0100
Message-Id: <20210420161338.70914-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420161338.70914-1-alexandru.elisei@arm.com>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The --vmm configure option was added to distinguish between the two virtual
machine managers that kvm-unit-tests supports, qemu or kvmtool. There are
plans to make kvm-unit-tests work as an EFI app, which will require changes
to the way tests are compiled. Instead of adding a new configure option
specifically for EFI and have it coexist with --vmm, or overloading the
semantics of the existing --vmm option, let's replace --vmm with the more
generic name --target.

--vmm has been kept for now as to avoid breaking existing users, but it has
been modified to shadow value of --target and a message will be displayed
to notify users that it will be removed at some point in the future.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 01a0b262a9f2..71d6dc9490df 100755
--- a/configure
+++ b/configure
@@ -21,7 +21,8 @@ pretty_print_stacks=yes
 environ_default=yes
 u32_long=
 wa_divide=
-vmm="qemu"
+vmm=
+target="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
@@ -35,8 +36,11 @@ usage() {
 	Options include:
 	    --arch=ARCH            architecture to compile for ($arch)
 	    --processor=PROCESSOR  processor to compile for ($arch)
-	    --vmm=VMM              virtual machine monitor to compile for (qemu
-	                           or kvmtool, default is qemu) (arm/arm64 only)
+	    --target=TARGET        target platform that the tests will be running on (qemu or
+	                           kvmtool, default is qemu) (arm/arm64 only)
+	    --vmm=VMM              virtual machine monitor to compile for (qemu or kvmtool).
+	                           If specified, it must have the same value as the --target
+	                           option (arm/arm64 only) (deprecated)
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC		   c compiler to use ($cc)
 	    --ld=LD		   ld linker to use ($ld)
@@ -58,7 +62,7 @@ usage() {
 	    --earlycon=EARLYCON
 	                           Specify the UART name, type and address (optional, arm and
 	                           arm64 only). The specified address will overwrite the UART
-	                           address set by the --vmm option. EARLYCON can be one of
+	                           address set by the --target option. EARLYCON can be one of
 	                           (case sensitive):
 	               uart[8250],mmio,ADDR
 	                           Specify an 8250 compatible UART at address ADDR. Supported
@@ -91,6 +95,9 @@ while [[ "$1" = -* ]]; do
 	--vmm)
 	    vmm="$arg"
 	    ;;
+	--target)
+	    target="$arg"
+	    ;;
 	--cross-prefix)
 	    cross_prefix="$arg"
 	    ;;
@@ -177,16 +184,24 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
-    if [ "$vmm" = "qemu" ]; then
+    if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
-    elif [ "$vmm" = "kvmtool" ]; then
+    elif [ "$target" = "kvmtool" ]; then
         arm_uart_early_addr=0x3f8
         errata_force=1
     else
-        echo '--vmm must be one of "qemu" or "kvmtool"!'
+        echo '--target must be one of "qemu" or "kvmtool"!'
         usage
     fi
 
+    if [ -n "$vmm" ]; then
+        echo "INFO: --vmm is deprecated and will be removed in future versions"
+        if [  "$vmm" != "$target" ]; then
+            echo "--vmm must have the same value as --target ($target)"
+            usage
+        fi
+    fi
+
     if [ "$earlycon" ]; then
         IFS=, read -r name type_addr addr <<<"$earlycon"
         if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
@@ -317,6 +332,7 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
+TARGET=$target
 EOF
 
 cat <<EOF > lib/config.h
-- 
2.31.1

