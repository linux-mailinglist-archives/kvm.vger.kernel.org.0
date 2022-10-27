Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5CD61059A
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiJ0WTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiJ0WT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:19:26 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712F0B40FE
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:19:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666909161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMn6AHcjiWyP4ioexcdAM5wEU4lDY1Vx2mX8rDQtI6s=;
        b=YdrJPBNnxemSovCI42lfGaBN3tIYXIbW2E8ticVsPuTVX26xxlovSzlqiwBWBaiZwND6QZ
        OLOmBCX+HtXvkqHpCDp14ZqhJGcXgRXPR55IHiA2L7GBUS9pKDXSAKPks4wusr4tFeQF3A
        ZBz5fjUNxGAnI1TJD8HFfz98n7H2EtM=
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
Subject: [PATCH v3 07/15] KVM: arm64: Use an opaque type for pteps
Date:   Thu, 27 Oct 2022 22:17:44 +0000
Message-Id: <20221027221752.1683510-8-oliver.upton@linux.dev>
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
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
index 7a8af3b686e8..e70cf57b719e 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
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
@@ -178,7 +185,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
 struct kvm_pgtable {
 	u32					ia_bits;
 	u32					start_level;
-	kvm_pte_t				*pgd;
+	kvm_pteref_t				pgd;
 	struct kvm_pgtable_mm_ops		*mm_ops;
 
 	/* Stage-2 only */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 167777b42890..c4d103889a62 100644
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
 
@@ -1116,7 +1117,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
-	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
+	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
-- 
2.38.1.273.g43a17bfeac-goog

