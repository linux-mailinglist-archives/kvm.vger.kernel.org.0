Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18671738715
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 16:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjFUOeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 10:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjFUOd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 10:33:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C7C11C
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:33:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 87F6221E0B;
        Wed, 21 Jun 2023 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1687358035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rF7i4IloRLCoVmUTLpQGt36jkO8fjLr5SVGvstyKfxM=;
        b=HRTXCeu9o5/8Q8cB5nU9nUDOkwbgpvca8n4vGdqZWwYioPQEKHH8poUXFSUObu5pT4XWTf
        z6u8rcMwfIPfOpF5CNy8t1hi/deNuq70qTmRckZ+xpXtBi5jQZf3oWtoIaL3B3oEHfW961
        8D/DGHHgvFMEftK/i5/AeonOVeqU2bw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1687358035;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rF7i4IloRLCoVmUTLpQGt36jkO8fjLr5SVGvstyKfxM=;
        b=G71STGdLiyt6ufLGbJN70JwtcrppXzZgC5PNVnrbjM96pWkHgeNF24p4KYr8gwWyTL7utO
        e1qGsejMV6pg07Bw==
Received: from vasant-suse.fritz.box (unknown [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id 10A412C141;
        Wed, 21 Jun 2023 14:33:55 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        marcorr@google.com, rientjes@google.com, seanjc@google.com,
        zxwang42@gmail.com, papaluri@amd.com,
        Vasant Karasulli <vkarasulli@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v4 07/11] lib/x86: Move xsave helpers to lib/
Date:   Wed, 21 Jun 2023 16:33:21 +0200
Message-Id: <20230621143325.25933-8-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621143325.25933-1-vkarasulli@suse.de>
References: <20230621143325.25933-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
Move the xsave read/write helpers used by xsave testcase to lib/x86
to share as common code.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 lib/x86/xsave.c     | 40 ++++++++++++++++++++++++++++++++++++++++
 lib/x86/xsave.h     | 16 ++++++++++++++++
 x86/Makefile.common |  1 +
 x86/xsave.c         | 42 +-----------------------------------------
 4 files changed, 58 insertions(+), 41 deletions(-)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h

diff --git a/lib/x86/xsave.c b/lib/x86/xsave.c
new file mode 100644
index 0000000..5f05f88
--- /dev/null
+++ b/lib/x86/xsave.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "libcflat.h"
+#include "xsave.h"
+#include "processor.h"
+
+int xgetbv_checking(u32 index, u64 *result)
+{
+	u32 eax, edx;
+
+	asm volatile(ASM_TRY("1f")
+		".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
+		"1:"
+		: "=a" (eax), "=d" (edx)
+		: "c" (index));
+	*result = eax + ((u64)edx << 32);
+	return exception_vector();
+}
+
+int xsetbv_safe(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	asm volatile(ASM_TRY("1f")
+		".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
+		"1:"
+		: : "a" (eax), "d" (edx), "c" (index));
+	return exception_vector();
+}
+
+uint64_t get_supported_xcr0(void)
+{
+	struct cpuid r;
+
+	r = cpuid_indexed(0xd, 0);
+	printf("eax %x, ebx %x, ecx %x, edx %x\n",
+		r.a, r.b, r.c, r.d);
+	return r.a + ((u64)r.d << 32);
+}
diff --git a/lib/x86/xsave.h b/lib/x86/xsave.h
new file mode 100644
index 0000000..12757c1
--- /dev/null
+++ b/lib/x86/xsave.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_XSAVE_H_
+#define _X86_XSAVE_H_
+
+#define XCR_XFEATURE_ENABLED_MASK       0x00000000
+#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
+
+#define XSTATE_FP       0x1
+#define XSTATE_SSE      0x2
+#define XSTATE_YMM      0x4
+
+int xgetbv_checking(u32 index, u64 *result);
+int xsetbv_safe(u32 index, u64 value);
+uint64_t get_supported_xcr0(void);
+
+#endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ca45ae8..e755c7e 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,6 +22,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
+cflatobjs += lib/x86/xsave.o
 cflatobjs += lib/x86/pmu.o
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
diff --git a/x86/xsave.c b/x86/xsave.c
index 39a55d6..d44f9ff 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -1,6 +1,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "processor.h"
+#include "xsave.h"

 #ifdef __x86_64__
 #define uint64_t unsigned long
@@ -8,47 +9,6 @@
 #define uint64_t unsigned long long
 #endif

-static int xgetbv_checking(u32 index, u64 *result)
-{
-    u32 eax, edx;
-
-    asm volatile(ASM_TRY("1f")
-            ".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
-            "1:"
-            : "=a" (eax), "=d" (edx)
-            : "c" (index));
-    *result = eax + ((u64)edx << 32);
-    return exception_vector();
-}
-
-static int xsetbv_safe(u32 index, u64 value)
-{
-    u32 eax = value;
-    u32 edx = value >> 32;
-
-    asm volatile(ASM_TRY("1f")
-            ".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
-            "1:"
-            : : "a" (eax), "d" (edx), "c" (index));
-    return exception_vector();
-}
-
-static uint64_t get_supported_xcr0(void)
-{
-    struct cpuid r;
-    r = cpuid_indexed(0xd, 0);
-    printf("eax %x, ebx %x, ecx %x, edx %x\n",
-            r.a, r.b, r.c, r.d);
-    return r.a + ((u64)r.d << 32);
-}
-
-#define XCR_XFEATURE_ENABLED_MASK       0x00000000
-#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
-
-#define XSTATE_FP       0x1
-#define XSTATE_SSE      0x2
-#define XSTATE_YMM      0x4
-
 static void test_xsave(void)
 {
     unsigned long cr4;
--
2.34.1

