Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0987786BB
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjHKEwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbjHKEvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:51:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AC32D52
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c647150c254so3174794276.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729502; x=1692334302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b8Ihb497LpuMIgM0TiiBODXNuX0ZiHa7Y+wfWyh7fKg=;
        b=GBv+6JjPWHDQgAZ9CQtQ6Gsgjb+DLspTKR+wRzk0n4Kw1z3V6nDVNWmzqUqqoukAg1
         1OlMEvUj8LrRWVXNysqG95jpTH8CChKkSCXz9apVTe5JeuZb6gqUegnorgzVhdK9S7IL
         oXKpr/ShUufm+B4pk8Ws4+HuIT6nXUq9e5H5XX1gGqdIFF/78t+yezXNaoo588QxYUh/
         c+FwwEuzFq0HTnIlwaWXmrqFOviHEebfM+P2e4EX/BA6adX59jK0oApE1mVLs3HMzHmR
         tA8dMni1QXHRJO/9x+FD5u/Y+wTdEXf2oG6z5XOPlVqxE/D+oQ2jxzr5IaXwOsRB1HO+
         caTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729502; x=1692334302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b8Ihb497LpuMIgM0TiiBODXNuX0ZiHa7Y+wfWyh7fKg=;
        b=GxtNdWUtprMpNmSnIR5sZFfQPc19DqCdN8ElPtDp45KrKNayKCtz8IO/jWZXYd8IRF
         60oD/RX5Jh1gJqq9akU2F3KDMb7w6JEXFW6SS1EfixfT2y+xRM4rK0b/w9xFejpIsoHN
         pq/7WKdoP2GTGB4RrKKjw9K8aJZW+85FKz+w973V2HNeYrZuLOGf0fRCzZyR5CFYveq/
         VXdh5U0nVGoFy7gP+ka0uuC17yKfWayTwyjztXiaNkeDouS/20ZwaxBg+VGxjLIKCoO+
         05JFh+w6BL/H1Zo4qIPe4iihoD3oTxfpiN5PZ6wc3IjBvLUKqTrnqQBCZWQY9Hoduxy7
         2L9g==
X-Gm-Message-State: AOJu0YxW/bXzwNkr0qMhKDL9OyVbGsgOCQI1qXVPZ4+/qGOtzYTxx6AZ
        tly1gYwNyQGhNj51UlAtqfG2vErIKNG7
X-Google-Smtp-Source: AGHT+IGrUmmFojlnNP1SsmNVGsoM061TpbAAPYUCbWDsvJBoCc9vnu1LZ+i0L7Joo7w2+TUqeRyfvhq6mEYk
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:c508:0:b0:d29:958c:e431 with SMTP id
 v8-20020a25c508000000b00d29958ce431mr79924ybe.1.1691729502582; Thu, 10 Aug
 2023 21:51:42 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:20 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-8-rananta@google.com>
Subject: [PATCH v9 07/14] arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/tlbflush.h | 121 +++++++++++++++++-------------
 1 file changed, 68 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 412a3b9a3c25d..b9475a852d5be 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -278,14 +278,74 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
  */
 #define MAX_TLBI_OPS	PTRS_PER_PTE
 
+/*
+ * __flush_tlb_range_op - Perform TLBI operation upon a range
+ *
+ * @op:	TLBI instruction that operates on a range (has 'r' prefix)
+ * @start:	The start address of the range
+ * @pages:	Range as the number of pages from 'start'
+ * @stride:	Flush granularity
+ * @asid:	The ASID of the task (0 for IPA instructions)
+ * @tlb_level:	Translation Table level hint, if known
+ * @tlbi_user:	If 'true', call an additional __tlbi_user()
+ *              (typically for user ASIDs). 'flase' for IPA instructions
+ *
+ * When the CPU does not support TLB range operations, flush the TLB
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
+				asid, tlb_level, tlbi_user)		\
+do {									\
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
@@ -307,56 +367,11 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
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
2.41.0.640.ga95def55d0-goog

