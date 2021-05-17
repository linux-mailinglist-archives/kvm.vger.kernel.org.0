Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EF738324E
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbhEQOrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:47:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240152AbhEQOlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9L3g3g1Sx+I4MEP7LsP3h+zYRpkAOZj41Z4y7VlGuuU=;
        b=eV+ovan0JQd6vokeKBB0GQxE6iSHA9iqRrfwfWoYiSOL/vZqH5Wm6LYKjIR5XyBYFtAMLz
        uuLsJzEkxdYRllWb+/wWkC7N90urWeBEXsC3QcJmItnVlg84XzBTMRYV+3Ci6TI3YF/yOD
        mP83HlfMa9Xhzs1MquHXcVyum/S8lGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-9v0jaNvoMBSP88oauL-vRQ-1; Mon, 17 May 2021 10:39:51 -0400
X-MC-Unique: 9v0jaNvoMBSP88oauL-vRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBB95C73A4;
        Mon, 17 May 2021 14:39:04 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 940255D6D7;
        Mon, 17 May 2021 14:39:03 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 01/10] configure: arm: Replace --vmm with --target
Date:   Mon, 17 May 2021 16:38:51 +0200
Message-Id: <20210517143900.747013-2-drjones@redhat.com>
In-Reply-To: <20210517143900.747013-1-drjones@redhat.com>
References: <20210517143900.747013-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

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
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 configure | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/configure b/configure
index 01a0b262a9f2..4ad5a4bcd782 100755
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
+        echo "--target must be one of 'qemu' or 'kvmtool'!"
         usage
     fi
 
@@ -318,6 +327,9 @@ WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 EOF
+if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
+    echo "TARGET=$target" >> config.mak
+fi
 
 cat <<EOF > lib/config.h
 #ifndef CONFIG_H
-- 
2.30.2

