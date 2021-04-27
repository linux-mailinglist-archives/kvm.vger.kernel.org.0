Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC3736C981
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhD0QfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:35:06 -0400
Received: from foss.arm.com ([217.140.110.172]:54822 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238335AbhD0Qet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 12:34:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65150D6E;
        Tue, 27 Apr 2021 09:34:05 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CDE13F73B;
        Tue, 27 Apr 2021 09:34:04 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v2] configure: arm: Replace --vmm with --target
Date:   Tue, 27 Apr 2021 17:34:37 +0100
Message-Id: <20210427163437.243839-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes in v2:

* Removed the RFC tag and cover letter.
* Removed --vmm entirely.

 configure | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/configure b/configure
index 01a0b262a9f2..08c6afdf952c 100755
--- a/configure
+++ b/configure
@@ -21,7 +21,7 @@ pretty_print_stacks=yes
 environ_default=yes
 u32_long=
 wa_divide=
-vmm="qemu"
+target="qemu"
 errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
@@ -35,8 +35,8 @@ usage() {
 	Options include:
 	    --arch=ARCH            architecture to compile for ($arch)
 	    --processor=PROCESSOR  processor to compile for ($arch)
-	    --vmm=VMM              virtual machine monitor to compile for (qemu
-	                           or kvmtool, default is qemu) (arm/arm64 only)
+	    --target=TARGET        target platform that the tests will be running on (qemu or
+	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC		   c compiler to use ($cc)
 	    --ld=LD		   ld linker to use ($ld)
@@ -58,7 +58,7 @@ usage() {
 	    --earlycon=EARLYCON
 	                           Specify the UART name, type and address (optional, arm and
 	                           arm64 only). The specified address will overwrite the UART
-	                           address set by the --vmm option. EARLYCON can be one of
+	                           address set by the --target option. EARLYCON can be one of
 	                           (case sensitive):
 	               uart[8250],mmio,ADDR
 	                           Specify an 8250 compatible UART at address ADDR. Supported
@@ -88,8 +88,8 @@ while [[ "$1" = -* ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
-	--vmm)
-	    vmm="$arg"
+	--target)
+	    target="$arg"
 	    ;;
 	--cross-prefix)
 	    cross_prefix="$arg"
@@ -177,13 +177,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
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
 
@@ -317,6 +317,7 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
+TARGET=$target
 EOF
 
 cat <<EOF > lib/config.h
-- 
2.31.1

