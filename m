Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1224B1165
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbiBJPJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 10:09:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243443AbiBJPJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:09:44 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0FA6D4
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 07:09:45 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A011DD6E;
        Thu, 10 Feb 2022 07:09:45 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51F963F718;
        Thu, 10 Feb 2022 07:09:44 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 3/4] configure: Make the --target option available to all architectures
Date:   Thu, 10 Feb 2022 15:09:42 +0000
Message-Id: <20220210150943.1280146-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220210150943.1280146-1-alexandru.elisei@arm.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The arm and arm64 architectures got the --target option to support running
with either qemu or kvmtool as the virtual machine manager. Make --target
valid for the other architectures, in which case qemu will be the only
valid target.

Generating the $TARGET variable in config.mak regardless of the
architecture will make adding support for another VMM to run_tests.sh
easier.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/configure b/configure
index 6620e78ec09c..2720b7efd64a 100755
--- a/configure
+++ b/configure
@@ -22,7 +22,7 @@ pretty_print_stacks=yes
 environ_default=yes
 u32_long=
 wa_divide=
-target=
+target=qemu
 errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
@@ -38,8 +38,8 @@ usage() {
 	Options include:
 	    --arch=ARCH            architecture to compile for ($arch)
 	    --processor=PROCESSOR  processor to compile for ($arch)
-	    --target=TARGET        target platform that the tests will be running on (qemu or
-	                           kvmtool, default is qemu) (arm/arm64 only)
+	    --target=TARGET        target platform that the tests will be running on (default is qemu)
+	                           (qemu or kvmtool for arm and arm64, qemu for all other architectures)
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC                c compiler to use ($cc)
 	    --cflags=FLAGS         extra options to be passed to the c compiler
@@ -168,14 +168,22 @@ arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
 
-if [ -z "$target" ]; then
-    target="qemu"
-else
+case "$target" in
+qemu)
+    # All architectures support qemu as the target.
+    ;;
+kvmtool)
+    # Only arm and arm64 support running under kvmtool.
     if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
-        echo "--target is not supported for $arch"
+        echo "--target=$target is not supported for $arch"
         usage
     fi
-fi
+    ;;
+*)
+    echo "--target=$target is not supported for $arch"
+    usage
+    ;;
+esac
 
 if [ "$target_efi" ] && [ "$arch" != "x86_64" ]; then
     echo "--target-efi is not supported for $arch"
@@ -369,10 +377,8 @@ GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 TARGET_EFI=$target_efi
 GEN_SE_HEADER=$gen_se_header
+TARGET=$target
 EOF
-if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
-    echo "TARGET=$target" >> config.mak
-fi
 
 cat <<EOF > lib/config.h
 #ifndef _CONFIG_H_
-- 
2.35.1

