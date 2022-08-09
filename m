Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AAA58D612
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbiHIJPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiHIJP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 964C413D74
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B5B1ED1;
        Tue,  9 Aug 2022 02:15:29 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 386313F67D;
        Tue,  9 Aug 2022 02:15:27 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 01/19] Makefile: Define __ASSEMBLY__ for assembly files
Date:   Tue,  9 Aug 2022 10:15:40 +0100
Message-Id: <20220809091558.14379-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
with functionality relies on the __ASSEMBLY__ prepocessor constant being
correctly defined to work correctly. So far, kvm-unit-tests has relied on
the assembly files to define the constant before including any header
files which depend on it.

Let's make sure that nobody gets this wrong and define it as a compiler
constant when compiling assembly files. __ASSEMBLY__ is now defined for all
.S files, even those that didn't set it explicitely before.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile           | 5 ++++-
 arm/cstart.S       | 1 -
 arm/cstart64.S     | 1 -
 powerpc/cstart64.S | 1 -
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6ed5deaccb41..42c61aa45d50 100644
--- a/Makefile
+++ b/Makefile
@@ -94,6 +94,9 @@ CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
 CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
+AFLAGS  = $(CFLAGS)
+AFLAGS += -D__ASSEMBLY__
+
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
 LDFLAGS += $(CFLAGS)
@@ -117,7 +120,7 @@ directories:
 	@mkdir -p $(OBJDIRS)
 
 %.o: %.S
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
 
 -include */.*.d */*/.*.d
 
diff --git a/arm/cstart.S b/arm/cstart.S
index 7036e67fc0d8..39260e0fa470 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-#define __ASSEMBLY__
 #include <auxinfo.h>
 #include <asm/assembler.h>
 #include <asm/thread_info.h>
diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d06251e..d62360cf3859 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
-#define __ASSEMBLY__
 #include <auxinfo.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 972851f9ed65..1a823385fd0f 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -5,7 +5,6 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-#define __ASSEMBLY__
 #include <asm/hcall.h>
 #include <asm/ppc_asm.h>
 #include <asm/rtas.h>
-- 
2.37.1

