Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4B831FD38
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 17:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhBSQiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 11:38:00 -0500
Received: from foss.arm.com ([217.140.110.172]:40128 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229734AbhBSQhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 11:37:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8734ED1;
        Fri, 19 Feb 2021 08:37:07 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 144FE3F73B;
        Fri, 19 Feb 2021 08:37:06 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH] configure: arm/arm64: Add --earlycon option to set UART type and address
Date:   Fri, 19 Feb 2021 16:37:18 +0000
Message-Id: <20210219163718.109101-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the UART early address is set indirectly with the --vmm option
and there are only two possible values: if the VMM is qemu (the default),
then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
UART address is set to 0x3f8.

There several efforts under way to change the kvmtool UART address, and
kvm-unit-tests so far hasn't had mechanism to let the user set a specific
address, which means that the early UART won't be available.

This situation will only become worse as kvm-unit-tests gains support to
run as an EFI app, as each platform will have their own UART type and
address.

To address both issues, a new configure option is added, --earlycon. The
syntax and semantics are identical to the kernel parameter with the same
name. Specifying this option will overwrite the UART address set by --vmm.

At the moment, the UART type and register width parameters are ignored
since both qemu's and kvmtool's UART emulation use the same offset for the
TX register and no other registers are used by kvm-unit-tests, but the
parameters will become relevant once EFI support is added.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
The kvmtool patches I was referring to are the patches to unify ioport and
MMIO emulation [1] and to allow the user to specify a custom memory layout
for the VM [2] (these patches are very old, but I plan to revive them after
the ioport and MMIO unification series are merged).

[1] https://lore.kernel.org/kvm/20201210142908.169597-1-andre.przywara@arm.com/T/#t
[2] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/

 configure | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/configure b/configure
index cdcd34e94030..d94b92255088 100755
--- a/configure
+++ b/configure
@@ -26,6 +26,7 @@ errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
 page_size=
+earlycon=
 
 usage() {
     cat <<-EOF
@@ -54,6 +55,17 @@ usage() {
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
 	                           64k, default is 64k, arm64 only)
+	    --earlycon=EARLYCON
+	                           Specify the UART name, type and address (optional, arm and
+	                           arm64 only). The specified address will overwrite the UART
+	                           address set by the --vmm option. EARLYCON can be on of (case
+	                           sensitive):
+	               uart[8250],mmio,ADDR
+	                           Specify an 8250 compatible UART at address ADDR. Supported
+	                           register stride is 8 bit only.
+	               pl011,mmio,ADDR
+	                           Specify a PL011 compatible UART at address ADDR. Supported
+	                           register stride is 8 bit only.
 EOF
     exit 1
 }
@@ -112,6 +124,9 @@ while [[ "$1" = -* ]]; do
 	--page-size)
 	    page_size="$arg"
 	    ;;
+	--earlycon)
+	    earlycon="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -170,6 +185,26 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
         echo '--vmm must be one of "qemu" or "kvmtool"!'
         usage
     fi
+
+    if [ "$earlycon" ]; then
+        name=$(echo $earlycon|cut -d',' -f1)
+        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
+                [ "$name" != "pl011" ]; then
+            echo "unknown earlycon name: $name"
+            usage
+        fi
+        type=$(echo $earlycon|cut -d',' -f2)
+        if [ "$type" != "mmio" ]; then
+            echo "unknown earlycon type: $type"
+            usage
+        fi
+        addr=$(echo $earlycon|cut -d',' -f3)
+        if [ -z "$addr" ]; then
+            echo "missing earlycon address"
+            usage
+        fi
+        arm_uart_early_addr=$addr
+    fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
     firmware="$testdir/boot_rom.bin"
-- 
2.30.1

