Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDEB36EC27
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 16:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhD2OMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 10:12:14 -0400
Received: from foss.arm.com ([217.140.110.172]:51400 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235277AbhD2OMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 10:12:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B3C01FB;
        Thu, 29 Apr 2021 07:11:26 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC8BC3F73B;
        Thu, 29 Apr 2021 07:11:25 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3] configure: arm: Replace --vmm with --target
Date:   Thu, 29 Apr 2021 15:12:04 +0100
Message-Id: <20210429141204.51848-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The --vmm configure option was added to distinguish between the two virtual
machine managers that kvm-unit-tests supports for the arm and arm64
architectures, qemu or kvmtool. There are plans to make kvm-unit-tests work
as an EFI app, which will require changes to the way tests are compiled.
Instead of adding a new configure option specifically for EFI and have it
coexist with --vmm, or overloading the semantics of the existing --vmm
option, let's replace --vmm with the more generic name --target.

Since --target is only valid for arm and arm64, reject the option when it's
specified for another architecture, which is how --vmm should have behaved
from the start.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes in v3:

* Using --target for any architecture other than arm and arm64 generates an
  error.
* Don't generate the TARGET variable in config.mak for other architectures.
* Cosmetic changes to the commit message.

Changes in v2:

* Removed the RFC tag and cover letter.
* Removed --vmm entirely.

 configure | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/configure b/configure
index 01a0b262a9f2..d5d223fe3a90 100755
--- a/configure
+++ b/configure
@@ -21,7 +21,7 @@ pretty_print_stacks=yes
 environ_default=yes
 u32_long=
 wa_divide=
-vmm="qemu"
+target=
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
@@ -146,6 +146,15 @@ arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
 
+if [ -z "$target" ]; then
+    target="qemu"
+else
+    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
+        echo "--target is not supported for $arch"
+        usage
+    fi
+fi
+
 if [ -z "$page_size" ]; then
     [ "$arch" = "arm64" ] && page_size="65536"
     [ "$arch" = "arm" ] && page_size="4096"
@@ -177,13 +186,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
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
 
@@ -318,6 +327,11 @@ WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 EOF
+if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
+cat <<EOF >> config.mak
+TARGET=$target
+EOF
+fi
 
 cat <<EOF > lib/config.h
 #ifndef CONFIG_H
-- 
2.31.1

