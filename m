Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5C617982
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 10:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiKCJM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 05:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiKCJMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 05:12:37 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AC9DF7F
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 02:12:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667466749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NnlF+MJraE90sqR7tMYMZ++c/YDTuLtZzFs7m6Cb4P0=;
        b=Whw/hkx10VVCisocf2q6PuZ5bPtLh5o5CaUR7j+7pb9mPbX+YWwAdw7OPXqXKwbH/qa5Ar
        McVmfl7n/evcJ/Cg57h8VbaGCkvXf/07rLK2UodR3s1tkGGZVMNi27sSI2byI/tVnnVxrc
        BRePEB7rLN5vq69pHUpfZYZJ4fcFVmg=
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
Subject: [PATCH v4 10/14] KVM: arm64: Split init and set for table PTE
Date:   Thu,  3 Nov 2022 09:11:36 +0000
Message-Id: <20221103091140.1040433-11-oliver.upton@linux.dev>
In-Reply-To: <20221103091140.1040433-1-oliver.upton@linux.dev>
References: <20221103091140.1040433-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a helper to initialize a table and directly call
smp_store_release() to install it (for now). Prepare for a subsequent
change that generalizes PTE writes with a helper.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2950058a2069..0f1e11ac4273 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -136,16 +136,13 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
 	WRITE_ONCE(*ptep, 0);
 }
 
-static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
-			      struct kvm_pgtable_mm_ops *mm_ops)
+static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
+	kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
 
 	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
 	pte |= KVM_PTE_VALID;
-
-	WARN_ON(kvm_pte_valid(old));
-	smp_store_release(ptep, pte);
+	return pte;
 }
 
 static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
@@ -413,7 +410,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			  enum kvm_pgtable_walk_flags visit)
 {
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, new;
 	struct hyp_map_data *data = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
@@ -427,8 +424,10 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
-	kvm_set_table_pte(ctx->ptep, childp, mm_ops);
+	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ctx->ptep);
+	smp_store_release(ctx->ptep, new);
+
 	return 0;
 }
 
@@ -796,7 +795,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, new;
 	int ret;
 
 	ret = stage2_map_walker_try_leaf(ctx, data);
@@ -821,8 +820,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (stage2_pte_is_counted(ctx->old))
 		stage2_put_pte(ctx, data->mmu, mm_ops);
 
-	kvm_set_table_pte(ctx->ptep, childp, mm_ops);
+	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ctx->ptep);
+	smp_store_release(ctx->ptep, new);
 
 	return 0;
 }
-- 
2.38.1.431.g37b22c650d-goog

