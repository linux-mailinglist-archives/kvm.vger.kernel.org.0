Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CCF5F812C
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 01:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJGX30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 19:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJGX3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 19:29:21 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5D57B2B1
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 16:29:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665185356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zRDnfE8MrO2md4vCZFTL1X74N6NmDyu55jEQQUMLRs=;
        b=JOw740yCJOjZqxjhTLrF0+XldA3sRQOTos7aLlIsktRXv5uMwFZ2ZKT8tFxguqRRqwAgu0
        9wwj9tHcxG6vAtnmNmV509wGKkcfaM8ZKJJ6EWaY1MQuxcdy+QOQpm33a4vAtGjJ7WXNUb
        ZX4uEi3kj43zkHqMc8IZ4HjdfCVGr7E=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 07/15] KVM: arm64: Use an opaque type for pteps
Date:   Fri,  7 Oct 2022 23:28:10 +0000
Message-Id: <20221007232818.459650-8-oliver.upton@linux.dev>
In-Reply-To: <20221007232818.459650-1-oliver.upton@linux.dev>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an opaque type for pteps and require visitors explicitly dereference
the pointer before using. Protecting page table memory with RCU requires
that KVM dereferences RCU-annotated pointers before using. However, RCU
is not available for use in the nVHE hypervisor and the opaque type can
be conditionally annotated with RCU for the stage-2 MMU.

Call the type a 'pteref' to avoid a naming collision with raw pteps. No
functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  9 ++++++++-
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++-----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c33edcf36b5b..beb89eac155c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,6 +25,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
 typedef u64 kvm_pte_t;
 
+typedef kvm_pte_t *kvm_pteref_t;
+
+static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
+{
+	return pteref;
+}
+
 #define KVM_PTE_VALID			BIT(0)
 
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
@@ -170,7 +177,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
 struct kvm_pgtable {
 	u32					ia_bits;
 	u32					start_level;
-	kvm_pte_t				*pgd;
+	kvm_pteref_t				pgd;
 	struct kvm_pgtable_mm_ops		*mm_ops;
 
 	/* Stage-2 only */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 02c33fccb178..6b6e1ed7ee2f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -175,13 +175,14 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
+			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
 
 static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 				      struct kvm_pgtable_mm_ops *mm_ops,
-				      kvm_pte_t *ptep, u32 level)
+				      kvm_pteref_t pteref, u32 level)
 {
 	enum kvm_pgtable_walk_flags flags = data->walker->flags;
+	kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
 	struct kvm_pgtable_visit_ctx ctx = {
 		.ptep	= ptep,
 		.old	= READ_ONCE(*ptep),
@@ -193,7 +194,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		.flags	= flags,
 	};
 	int ret = 0;
-	kvm_pte_t *childp;
+	kvm_pteref_t childp;
 	bool table = kvm_pte_table(ctx.old, level);
 
 	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
@@ -214,7 +215,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 	}
 
-	childp = kvm_pte_follow(ctx.old, mm_ops);
+	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
 	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
 	if (ret)
 		goto out;
@@ -227,7 +228,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level)
+			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level)
 {
 	u32 idx;
 	int ret = 0;
@@ -236,12 +237,12 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 		return -EINVAL;
 
 	for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
-		kvm_pte_t *ptep = &pgtable[idx];
+		kvm_pteref_t pteref = &pgtable[idx];
 
 		if (data->addr >= data->end)
 			break;
 
-		ret = __kvm_pgtable_visit(data, mm_ops, ptep, level);
+		ret = __kvm_pgtable_visit(data, mm_ops, pteref, level);
 		if (ret)
 			break;
 	}
@@ -262,9 +263,9 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
 		return -EINVAL;
 
 	for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
-		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
+		kvm_pteref_t pteref = &pgt->pgd[idx * PTRS_PER_PTE];
 
-		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
+		ret = __kvm_pgtable_walk(data, pgt->mm_ops, pteref, pgt->start_level);
 		if (ret)
 			break;
 	}
@@ -507,7 +508,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 {
 	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
 
-	pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
+	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_page(NULL);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
@@ -1119,7 +1120,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
-	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
+	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

