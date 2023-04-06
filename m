Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7166D8DBB
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbjDFCw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbjDFCwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:52:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB0944A7
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:51:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bs190-20020a6328c7000000b00513efd36285so3755903pgb.17
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680749488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=268DvV9NvAzgMn9UxTptYI9rfij2DGpJfXuhVhDPeaI=;
        b=QH7g1WeiSxyI6QzmZlZVArBXYzoLVpttjDePbn45wx37f8mFwQ7enwc4SDrAgjTa51
         ySH7+MPE4HdKVTh+QaQdqgmSmnzeinbKj5LoA6Km1NznBG28QOiAIp8KCmiAmdjQuTv2
         rpDYA071f3pmxk6Ts+dJJpcc8vA/RaEMZ27wf3vnz8ic+TSOb9GoJrSRHGUfftGlPkiA
         pIJlZ5B903kZvvrekDjdJLeNI22QSqrOiZm9EUO9bIMLKtND8sl65AxT/cxn7ktMUPdB
         sKShf2adxInZA01oIXXlHB5kbQIjawxZtzyo/XwQwxkDJMdEbn14zlJIkzjE7lzs8jNK
         556g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=268DvV9NvAzgMn9UxTptYI9rfij2DGpJfXuhVhDPeaI=;
        b=cd2UfnYN2lOuqzUHrzSIo5tDEVZ4GnxHzN2jennUGlQ6MJaUzPxwstTtCwDL+Oycic
         FkdLcYdObdS4S054+UEZ8+SVwDEz+S/byzTJDOZrRZIdBGViFqjAbojtp+lfJIiVpPwi
         VV0sKJ5OY5xWaIVAlFqC2whKrRpWzWTPYu8KOlpfPYrlTSD3ixYBfYGvPe0ke6TTBAax
         I6VDW6g9glBhDcDBQmg1ClnZRiDfwoDyRqcxLSWn66+J938gsD4xMNqCBg3fmLDCnkzl
         B/oWR8GEm9lwQKjZksaoTrwNjs5lXGzYR+Xq5wK5wM3r5xnQ4iH3m/zARxpyzCtixACc
         PSIA==
X-Gm-Message-State: AAQBX9enIiQ+rLerSeOFY/gC4doIwItePF/RzmsmXoU81a24Omo9815k
        NKSX96pHtbiOq04m/tWeKNKfrWzSCZU=
X-Google-Smtp-Source: AKy350aRn6WidBsz06LhLxx+E5NZs6Nz3gV+RhfG7pKrtpK/OLd20WtfKz2HjwciM2KYe6Bg3N84n12aWr0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:47c1:0:b0:4fc:27c2:840d with SMTP id
 f1-20020a6547c1000000b004fc27c2840dmr2710895pgs.12.1680749488403; Wed, 05 Apr
 2023 19:51:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 19:51:17 -0700
In-Reply-To: <20230406025117.738014-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230406025117.738014-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406025117.738014-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 5/5] x86: Move XSETBV and XGETBV "safe" helpers
 to processor.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the "safe" helpers for XSETBV and XGETBV to processor.h, and convert
them to use asm_safe() and other common macros as appropriate.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 22 +++++++++++++++++++---
 x86/xsave.c         | 31 +++----------------------------
 2 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 243eacde..54f3bdbb 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -430,6 +430,14 @@ static inline void wrmsr(u32 index, u64 val)
 	vector;								\
 })
 
+#define wrreg64_safe(insn, index, val)					\
+({									\
+	uint32_t eax = (val), edx = (val) >> 32;			\
+									\
+	asm_safe(insn, "a" (eax), "d" (edx), "c" (index));		\
+})
+
+
 static inline int rdmsr_safe(u32 index, uint64_t *val)
 {
 	return rdreg64_safe("rdmsr", index, val);
@@ -437,9 +445,7 @@ static inline int rdmsr_safe(u32 index, uint64_t *val)
 
 static inline int wrmsr_safe(u32 index, u64 val)
 {
-	u32 a = val, d = val >> 32;
-
-	return asm_safe("wrmsr", "a"(a), "d"(d), "c"(index));
+	return wrreg64_safe("wrmsr", index, val);
 }
 
 static inline int rdpmc_safe(u32 index, uint64_t *val)
@@ -457,6 +463,16 @@ static inline uint64_t rdpmc(uint32_t index)
 	return val;
 }
 
+static inline int xgetbv_safe(u32 index, u64 *result)
+{
+	return rdreg64_safe(".byte 0x0f,0x01,0xd0", index, result);
+}
+
+static inline int xsetbv_safe(u32 index, u64 value)
+{
+	return wrreg64_safe(".byte 0x0f,0x01,0xd1", index, value);
+}
+
 static inline int write_cr0_safe(ulong val)
 {
 	return asm_safe("mov %0,%%cr0", "r" (val));
diff --git a/x86/xsave.c b/x86/xsave.c
index 39a55d66..5d80f245 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -8,31 +8,6 @@
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
 static uint64_t get_supported_xcr0(void)
 {
     struct cpuid r;
@@ -78,7 +53,7 @@ static void test_xsave(void)
     test_bits = XSTATE_FP | XSTATE_SSE;
     report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
-    report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
+    report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
            "        xgetbv(XCR_XFEATURE_ENABLED_MASK)");
 
     printf("\tIllegal tests\n");
@@ -123,7 +98,7 @@ static void test_xsave(void)
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE) - expect #UD");
 
     printf("\tIllegal tests:\n");
-    report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
+    report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
            "\txgetbv(XCR_XFEATURE_ENABLED_MASK) - expect #UD");
 }
 
@@ -141,7 +116,7 @@ static void test_no_xsave(void)
     report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
            "Set OSXSAVE in CR4 - expect #GP");
 
-    report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
+    report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
            "Execute xgetbv - expect #UD");
 
     report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
-- 
2.40.0.348.gf938b09366-goog

