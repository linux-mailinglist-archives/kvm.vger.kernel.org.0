Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5939C4C136A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbiBWM6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240700AbiBWM5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:57:46 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DD16DFDD
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 04:57:18 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FA4CED1;
        Wed, 23 Feb 2022 04:57:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E7273F70D;
        Wed, 23 Feb 2022 04:57:16 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 2/3] configure: Restrict --target-efi to x86_64
Date:   Wed, 23 Feb 2022 12:55:36 +0000
Message-Id: <20220223125537.41529-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223125537.41529-1-alexandru.elisei@arm.com>
References: <20220223125537.41529-1-alexandru.elisei@arm.com>
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

Setting the --target-efi option for any architecture but x86_64 results in
an error while trying to compile the tests:

$ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --target-efi
$ make clean && make
Makefile:46: *** Cannot build aarch64 tests as EFI apps.  Stop.

Which might come as a surprise for users, as the help message for the
configure script makes no mention of an architecture being incompatible
with the option.

Document that --target-efi applies only to the x86_64 architecture and
check for illegal usage in the configure script, instead of failing later,
at compile time.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile  | 4 ----
 configure | 7 ++++++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 4f4ad235fe0c..5af17f129ced 100644
--- a/Makefile
+++ b/Makefile
@@ -40,11 +40,7 @@ OBJDIRS += $(LIBFDT_objdir)
 
 # EFI App
 ifeq ($(TARGET_EFI),y)
-ifeq ($(ARCH_NAME),x86_64)
 EFI_ARCH = x86_64
-else
-$(error Cannot build $(ARCH_NAME) tests as EFI apps)
-endif
 EFI_CFLAGS := -DTARGET_EFI
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
diff --git a/configure b/configure
index 0ac9c85502ff..6620e78ec09c 100755
--- a/configure
+++ b/configure
@@ -74,7 +74,7 @@ usage() {
 	               pl011,mmio32,ADDR
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
-	    --target-efi           Boot and run from UEFI
+	    --target-efi           Boot and run from UEFI (x86_64 only)
 EOF
     exit 1
 }
@@ -177,6 +177,11 @@ else
     fi
 fi
 
+if [ "$target_efi" ] && [ "$arch" != "x86_64" ]; then
+    echo "--target-efi is not supported for $arch"
+    usage
+fi
+
 if [ -z "$page_size" ]; then
     [ "$arch" = "arm64" ] && page_size="65536"
     [ "$arch" = "arm" ] && page_size="4096"
-- 
2.35.1

