Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB8D708D0E
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 02:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjESAwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 20:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjESAwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 20:52:38 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD8610C9
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:37 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id ca18e2360f4ac-763c3442563so208606139f.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457556; x=1687049556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1BCTijk0qbakQetFWj3/kUngjgg7qU/t2LH2AytbwyA=;
        b=eE5te6zoFAK2wnSpxBZQ8/GvCVM/YU5q8XLGMd7hL2YzwpknB+5DitnUAkizbYbh1n
         IY8Bkrk8FDzrSE2EN9Tahdj4W/aVn5jI+L/enmtskNyQOEGmxcjB3GKrd5yq0n3O8xvF
         Dl+tkUsHET+v3dVcKShodU8sBuCVZR5cl4QhZ2Ow8/gr5Jxb7fafGSMf/DV80tJ1zxlL
         lsHpt4BVrtsw5TOlgwRbkkp1PGQhssx6eiqt+Iy+8S4Su3kHt5p/AcyZK1nXWVxsKqhL
         tJPjhJ21dseJrn4qx41zMbONsEifZviXGrzV1yfD3veI7kV0zyT79kgeTSev08o1M9lD
         +FDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457556; x=1687049556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BCTijk0qbakQetFWj3/kUngjgg7qU/t2LH2AytbwyA=;
        b=CKt2svc7dztejc8aMtQFZnc2JZhViF8gj30AmxTploaEDR2vgZr3VxUYmo+9+dDJvS
         hsEYGkivsaas4y7lIvbrsco+1Sz2f01mqhTUSLd1uqmQgJpLijDDdpDDkWaFLjluSM3Q
         KRvTx6vhi3S7VQTCkGTnTA2qrnd/B1iLu4XheyJBo9wSZCBZhId5ChaZeIwKg+rbLV3b
         Tdd4DUi/POUEM4AGwZGkrit3zROyuRcy5gGXgQ8nwgDz06IHAc4Br0Gtr8sfhoPcq5pb
         e/uFBc/8JBXW1OQGkg6KOOXBT6pIDDCudmY/ay5XBDFLgoCeCYKm34RojH8+Y24Oe6H3
         zf/g==
X-Gm-Message-State: AC+VfDytY++8699Y8QyrLTt/1v2oHaw1NSXkb7AXDK7f4MYbOj523Kq9
        hav//IECoMlHA2xqzBWRc7THGWsID5hS
X-Google-Smtp-Source: ACHHUZ581E6RpVMDY5203uPsCEyRhBUbBRGNjHjBc8BerIRAb1q/rKHdq3qeP58gIFJtWoY+BNvHyKVGxYvL
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:95c3:0:b0:41a:9030:981 with SMTP id
 b61-20020a0295c3000000b0041a90300981mr4875jai.0.1684457556756; Thu, 18 May
 2023 17:52:36 -0700 (PDT)
Date:   Fri, 19 May 2023 00:52:26 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-2-rananta@google.com>
Subject: [PATCH v4 1/6] arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the core TLB flush functionality of __flush_tlb_range()
hardcodes vae1is (and variants) for the flush operation. In the
upcoming patches, the KVM code reuses this core algorithm with
ipas2e1is for range based TLB invalidations based on the IPA.
Hence, extract the core flush functionality of __flush_tlb_range()
into its own macro that accepts an 'op' argument to pass any
TLBI operation, such that other callers (KVM) can benefit.

No functional changes intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 108 +++++++++++++++---------------
 1 file changed, 55 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 412a3b9a3c25d..4775378b6da1b 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -278,14 +278,61 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
  */
 #define MAX_TLBI_OPS	PTRS_PER_PTE
 
+/* When the CPU does not support TLB range operations, flush the TLB
+ * entries one by one at the granularity of 'stride'. If the TLB
+ * range ops are supported, then:
+ *
+ * 1. If 'pages' is odd, flush the first page through non-range
+ *    operations;
+ *
+ * 2. For remaining pages: the minimum range granularity is decided
+ *    by 'scale', so multiple range TLBI operations may be required.
+ *    Start from scale = 0, flush the corresponding number of pages
+ *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
+ *    until no pages left.
+ *
+ * Note that certain ranges can be represented by either num = 31 and
+ * scale or num = 0 and scale + 1. The loop below favours the latter
+ * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
+ */
+#define __flush_tlb_range_op(op, start, pages, stride,			\
+				asid, tlb_level, tlbi_user) do {	\
+	int num = 0;							\
+	int scale = 0;							\
+	unsigned long addr;						\
+									\
+	while (pages > 0) {						\
+		if (!system_supports_tlb_range() ||			\
+		    pages % 2 == 1) {					\
+			addr = __TLBI_VADDR(start, asid);		\
+			__tlbi_level(op, addr, tlb_level);		\
+			if (tlbi_user)					\
+				__tlbi_user_level(op, addr, tlb_level);	\
+			start += stride;				\
+			pages -= stride >> PAGE_SHIFT;			\
+			continue;					\
+		}							\
+									\
+		num = __TLBI_RANGE_NUM(pages, scale);			\
+		if (num >= 0) {						\
+			addr = __TLBI_VADDR_RANGE(start, asid, scale,	\
+						  num, tlb_level);	\
+			__tlbi(r##op, addr);				\
+			if (tlbi_user)					\
+				__tlbi_user(r##op, addr);		\
+			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
+			pages -= __TLBI_RANGE_PAGES(num, scale);	\
+		}							\
+		scale++;						\
+	}								\
+} while (0)
+
 static inline void __flush_tlb_range(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end,
 				     unsigned long stride, bool last_level,
 				     int tlb_level)
 {
-	int num = 0;
-	int scale = 0;
-	unsigned long asid, addr, pages;
+	unsigned long asid, pages;
 
 	start = round_down(start, stride);
 	end = round_up(end, stride);
@@ -307,56 +354,11 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	dsb(ishst);
 	asid = ASID(vma->vm_mm);
 
-	/*
-	 * When the CPU does not support TLB range operations, flush the TLB
-	 * entries one by one at the granularity of 'stride'. If the TLB
-	 * range ops are supported, then:
-	 *
-	 * 1. If 'pages' is odd, flush the first page through non-range
-	 *    operations;
-	 *
-	 * 2. For remaining pages: the minimum range granularity is decided
-	 *    by 'scale', so multiple range TLBI operations may be required.
-	 *    Start from scale = 0, flush the corresponding number of pages
-	 *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
-	 *    until no pages left.
-	 *
-	 * Note that certain ranges can be represented by either num = 31 and
-	 * scale or num = 0 and scale + 1. The loop below favours the latter
-	 * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
-	 */
-	while (pages > 0) {
-		if (!system_supports_tlb_range() ||
-		    pages % 2 == 1) {
-			addr = __TLBI_VADDR(start, asid);
-			if (last_level) {
-				__tlbi_level(vale1is, addr, tlb_level);
-				__tlbi_user_level(vale1is, addr, tlb_level);
-			} else {
-				__tlbi_level(vae1is, addr, tlb_level);
-				__tlbi_user_level(vae1is, addr, tlb_level);
-			}
-			start += stride;
-			pages -= stride >> PAGE_SHIFT;
-			continue;
-		}
-
-		num = __TLBI_RANGE_NUM(pages, scale);
-		if (num >= 0) {
-			addr = __TLBI_VADDR_RANGE(start, asid, scale,
-						  num, tlb_level);
-			if (last_level) {
-				__tlbi(rvale1is, addr);
-				__tlbi_user(rvale1is, addr);
-			} else {
-				__tlbi(rvae1is, addr);
-				__tlbi_user(rvae1is, addr);
-			}
-			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT;
-			pages -= __TLBI_RANGE_PAGES(num, scale);
-		}
-		scale++;
-	}
+	if (last_level)
+		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true);
+	else
+		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true);
+
 	dsb(ish);
 }
 
-- 
2.40.1.698.g37aff9b760-goog

