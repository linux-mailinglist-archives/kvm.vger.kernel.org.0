Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BED379C4B
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 03:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhEKBv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 21:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhEKBv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 21:51:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9B4C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 18:50:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s10-20020a252c0a0000b02904f8e566d0f2so5241598ybs.3
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 18:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wltQklr1vvKAD1oLJp4HCNiiDRXnJusVk0dhzmUFIDQ=;
        b=PXJV9Cy5DyeRd8DWpsO8uoCCVEQ7dn3NaEAeoMOfG3EGM3mb6YYfJrcBP/6GuZTaLL
         9z7EA5zeTWXZ9FCLDxqHmb+K73cd0G+qn6hXHpQukZdvoWlaUPvDLQ72d0IfI/9YL/0t
         AI+RdeRGF/ytQ17YQZJbBHFUlHG+LJ9rlK3mZpZhM0LZN6eBRkS4ZPk51o1704ZhfCtf
         JnqQhu8VQj08LEMd3hV328mTbqTHI6dECNzXftV/DoDkMcHm/HKkMY3DAjYKqoYFKUkq
         mDyu1ktlWDJdL0L30lDhf1NK9u0fX52v1FX6MscD1tNABdI821MBBbJ0ZEB2w27LDyuR
         TzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wltQklr1vvKAD1oLJp4HCNiiDRXnJusVk0dhzmUFIDQ=;
        b=Alma8NWn1DtKHCXPnfP3h8nzlFDQJ8/jtl7+Juftmf4nvj6ZyHYKYkBHxcT2QiEoPP
         M0ZXVQUpLyirvldOhwUeuDoZL4GvIaOQacLXhQFnivTEbZ9jKQsdDOV5y4ls92gmKShx
         EgfAsKyw7A40DlYwcTzMw4Jk8Iom0R7YBo3TVvjrJ8dEAxJx9G/ciKIr5xngexxyCZCr
         /PGHmOzlaooIm5XcWeU+W6TFYMpHN/1gLZQrp0uhJr2L2N1Afb1ubScj94pXAdht32P7
         6h9iAM21Etow8d7OjjRp8ALW/NV4lAeXDkqic3azXw729B7Lb7JbGEzsEytmnzrdG8qk
         2gzQ==
X-Gm-Message-State: AOAM530ZjE/klQTTirMa3P8b+KBsoaRUF/bzTK5jtiCJYMXBQsI59uR0
        pka6NEI31SLWEepCGxI7fQ4bxkczrfvWiw==
X-Google-Smtp-Source: ABdhPJyev/Wm8x/2coUBl6gFqvJqrZEaQszS60FIOyiOxjROsDy5GpY1ZYnLjFU2BoxmyaVyfVRzEn20QF9L9A==
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:da9d:6257:8f5f:1bcc])
 (user=jacobhxu job=sendgmr) by 2002:a25:cac7:: with SMTP id
 a190mr37045252ybg.144.1620697820410; Mon, 10 May 2021 18:50:20 -0700 (PDT)
Date:   Mon, 10 May 2021 18:50:15 -0700
Message-Id: <20210511015016.815461-1-jacobhxu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [kvm-unit-tests PATCH 1/2] x86: Do not assign values to unaligned
 pointer to 128 bits
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiled with clang, the following statement gets converted into a
movaps instructions.
mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;

Since mem is an unaligned pointer to sse_union, we get a GP when
running. Let's avoid using a pointer to sse_union at all, since doing so
implies that the pointer is aligned to 128 bits.

Fixes: e5e76263b5 ("x86: add additional test cases for sse exceptions to
emulator.c")

Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 x86/emulator.c | 67 +++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 9705073..1d5c172 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -645,37 +645,34 @@ static void test_muldiv(long *mem)
 
 typedef unsigned __attribute__((vector_size(16))) sse128;
 
-typedef union {
-    sse128 sse;
-    unsigned u[4];
-} sse_union;
-
-static bool sseeq(sse_union *v1, sse_union *v2)
+static bool sseeq(uint32_t *v1, uint32_t *v2)
 {
     bool ok = true;
     int i;
 
     for (i = 0; i < 4; ++i) {
-	ok &= v1->u[i] == v2->u[i];
+	ok &= v1[i] == v2[i];
     }
 
     return ok;
 }
 
-static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
+static __attribute__((target("sse2"))) void test_sse(uint32_t *mem)
 {
-	sse_union v;
+	sse128 vv;
+	uint32_t *v = (uint32_t *)&vv;
 
 	write_cr0(read_cr0() & ~6); /* EM, TS */
 	write_cr4(read_cr4() | 0x200); /* OSFXSR */
+	memset(&vv, 0, sizeof(vv));
 
 #define TEST_RW_SSE(insn) do { \
-		v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4; \
-		asm(insn " %1, %0" : "=m"(*mem) : "x"(v.sse)); \
-		report(sseeq(&v, mem), insn " (read)"); \
-		mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8; \
-		asm(insn " %1, %0" : "=x"(v.sse) : "m"(*mem)); \
-		report(sseeq(&v, mem), insn " (write)"); \
+		v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4; \
+		asm(insn " %1, %0" : "=m"(*mem) : "x"(vv) : "memory"); \
+		report(sseeq(v, mem), insn " (read)"); \
+		mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8; \
+		asm(insn " %1, %0" : "=x"(vv) : "m"(*mem) : "memory"); \
+		report(sseeq(v, mem), insn " (write)"); \
 } while (0)
 
 	TEST_RW_SSE("movdqu");
@@ -704,40 +701,41 @@ static void cross_movups_handler(struct ex_regs *regs)
 
 static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 {
-	sse_union v;
-	sse_union *mem;
+	sse128 vv;
+	uint32_t *v = (uint32_t *)&vv;
+	uint32_t *mem;
 	uint8_t *bytes = cross_mem; // aligned on PAGE_SIZE*2
 	void *page2 = (void *)(&bytes[4096]);
 	struct pte_search search;
 	pteval_t orig_pte;
 
 	// setup memory for unaligned access
-	mem = (sse_union *)(&bytes[8]);
+	mem = (uint32_t *)(&bytes[8]);
 
 	// test unaligned access for movups, movupd and movaps
-	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
-	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
-	report(sseeq(&v, mem), "movups unaligned");
-
-	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
-	asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
-	report(sseeq(&v, mem), "movupd unaligned");
+	v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
+	mem[0] = 5; mem[1] = 6; mem[2] = 8; mem[3] = 9;
+	asm("movups %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
+	report(sseeq(v, mem), "movups unaligned");
+
+	v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
+	mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8;
+	asm("movupd %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
+	report(sseeq(v, mem), "movupd unaligned");
 	exceptions = 0;
 	handle_exception(GP_VECTOR, unaligned_movaps_handler);
 	asm("movaps %1, %0\n\t unaligned_movaps_cont:"
-			: "=m"(*mem) : "x"(v.sse));
+			: "=m"(*mem) : "x"(vv));
 	handle_exception(GP_VECTOR, 0);
 	report(exceptions == 1, "unaligned movaps exception");
 
 	// setup memory for cross page access
-	mem = (sse_union *)(&bytes[4096-8]);
-	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
-	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	mem = (uint32_t *)(&bytes[4096-8]);
+	v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
+	mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8;
 
-	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
-	report(sseeq(&v, mem), "movups unaligned crosspage");
+	asm("movups %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
+	report(sseeq(v, mem), "movups unaligned crosspage");
 
 	// invalidate second page
 	search = find_pte_level(current_page_table(), page2, 1);
@@ -747,7 +745,8 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 
 	exceptions = 0;
 	handle_exception(PF_VECTOR, cross_movups_handler);
-	asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(v.sse));
+	asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(vv) :
+			"memory");
 	handle_exception(PF_VECTOR, 0);
 	report(exceptions == 1, "movups crosspage exception");
 
-- 
2.31.1.607.g51e8a6a459-goog

