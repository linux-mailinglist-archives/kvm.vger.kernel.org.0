Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E40342284
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhCSQyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:54:06 -0400
Received: from foss.arm.com ([217.140.110.172]:56786 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhCSQxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:53:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64399ED1;
        Fri, 19 Mar 2021 09:53:42 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97D1F3FA00;
        Fri, 19 Mar 2021 09:53:41 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3] configure: arm/arm64: Add --earlycon option to set UART type and address
Date:   Fri, 19 Mar 2021 16:53:59 +0000
Message-Id: <20210319165359.58498-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the UART early address is set indirectly with the --vmm option
and there are only two possible values: if the VMM is qemu (the default),
then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
UART address is set to 0x3f8.

The upstream kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO
at higher addresses") changed the UART address to 0x1000000, and
kvm-unit-tests so far hasn't had mechanism to let the user set a specific
address, which means that for recent versions of kvmtool the early UART
won't be available.

This situation will only become worse as kvm-unit-tests gains support to
run as an EFI app, as each platform will have their own UART type and
address.

To address both issues, a new configure option is added, --earlycon. The
syntax and semantics are identical to the kernel parameter with the same
name. For example, for kvmtool, --earlycon=uart,mmio,0x1000000 will set the
correct UART address. Specifying this option will overwrite the UART
address set by --vmm.

At the moment, the UART type and register width parameters are ignored
since both qemu's and kvmtool's UART emulation use the same offset for the
TX register and no other registers are used by kvm-unit-tests, but the
parameters will become relevant once EFI support is added.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Besides working with current versions of kvmtool, this will also make early
console work if the user specifies a custom memory layout [1] (patches are
old, but I plan to pick them up at some point in the future).

Changes in v3:
* Switched to using IFS and read instead of cut.
* Fixed typo in option description.
* Added check that $addr is a valid number.

Changes in v2:
* kvmtool patches were merged, so I reworked the commit message to point to
  the corresponding kvmtool commit.
* Restricted pl011 register size to 32 bits, as per Arm Base System
  Architecture 1.0 (DEN0094A), and to match Linux.
* Reworked the way the fields are extracted to make it more precise
  (without the -s argument, the entire string is echo'ed when no delimiter
  is found).
* The changes are not trivial, so I dropped Drew's Reviewed-by.

[1] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/

 configure | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/configure b/configure
index cdcd34e94030..01a0b262a9f2 100755
--- a/configure
+++ b/configure
@@ -26,6 +26,7 @@ errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
 page_size=
+earlycon=
 
 usage() {
     cat <<-EOF
@@ -54,6 +55,18 @@ usage() {
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
 	                           64k, default is 64k, arm64 only)
+	    --earlycon=EARLYCON
+	                           Specify the UART name, type and address (optional, arm and
+	                           arm64 only). The specified address will overwrite the UART
+	                           address set by the --vmm option. EARLYCON can be one of
+	                           (case sensitive):
+	               uart[8250],mmio,ADDR
+	                           Specify an 8250 compatible UART at address ADDR. Supported
+	                           register stride is 8 bit only.
+	               pl011,ADDR
+	               pl011,mmio32,ADDR
+	                           Specify a PL011 compatible UART at address ADDR. Supported
+	                           register stride is 32 bit only.
 EOF
     exit 1
 }
@@ -112,6 +125,9 @@ while [[ "$1" = -* ]]; do
 	--page-size)
 	    page_size="$arg"
 	    ;;
+	--earlycon)
+	    earlycon="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -170,6 +186,43 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
         echo '--vmm must be one of "qemu" or "kvmtool"!'
         usage
     fi
+
+    if [ "$earlycon" ]; then
+        IFS=, read -r name type_addr addr <<<"$earlycon"
+        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
+                [ "$name" != "pl011" ]; then
+            echo "unknown earlycon name: $name"
+            usage
+        fi
+
+        if [ "$name" = "pl011" ]; then
+            if [ -z "$addr" ]; then
+                addr=$type_addr
+            else
+                if [ "$type_addr" != "mmio32" ]; then
+                    echo "unknown $name earlycon type: $type_addr"
+                    usage
+                fi
+            fi
+        else
+            if [ "$type_addr" != "mmio" ]; then
+                echo "unknown $name earlycon type: $type_addr"
+                usage
+            fi
+        fi
+
+        if [ -z "$addr" ]; then
+            echo "missing $name earlycon address"
+            usage
+        fi
+        if [[ $addr =~ ^0(x|X)[0-9a-fA-F]+$ ]] ||
+                [[ $addr =~ ^[0-9]+$ ]]; then
+            arm_uart_early_addr=$addr
+        else
+            echo "invalid $name earlycon address: $addr"
+            usage
+        fi
+    fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
     firmware="$testdir/boot_rom.bin"
-- 
2.31.0

