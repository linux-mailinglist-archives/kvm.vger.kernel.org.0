Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E05F813A
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 01:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJGXbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 19:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGXbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 19:31:33 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EA36479
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 16:31:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665185490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gw933/Di7yX9BWM/P1YEigqUewJ71aWBeoHtyoGkz40=;
        b=CX3/B3ivk6nvblL8ZC82ekydGfiRqj1SNaXDjaXipJcV6neMnczAfYC6HF+31K+QD97c89
        KakldG9Il7wo3iQtPVU5j8dpYuO1JMClDXCjxyji2YoA/wYwALu1d8TIx+o0FGrtGCbFnC
        NW731jtBMsITLZN0MBxwu2P/sJ1hFoE=
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
Subject: [PATCH v2 12/15] KVM: arm64: Make block->table PTE changes parallel-aware
Date:   Fri,  7 Oct 2022 23:31:13 +0000
Message-Id: <20221007233113.459974-1-oliver.upton@linux.dev>
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

In order to service stage-2 faults in parallel, stage-2 table walkers
must take exclusive ownership of the PTE being worked on. An additional
requirement of the architecture is that software must perform a
'break-before-make' operation when changing the block size used for
mapping memory.

Roll these two concepts together into helpers for performing a
'break-before-make' sequence. Use a special PTE value to indicate a PTE
has been locked by a software walker. Additionally, use an atomic
compare-exchange to 'break' the PTE when the stage-2 page tables are
possibly shared with another software walker. Elide the DSB + TLBI if
the evicted PTE was invalid (and thus not subject to break-before-make).

All of the atomics do nothing for now, as the stage-2 walker isn't fully
ready to perform parallel walks.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 82 +++++++++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f649a2251a35..932134f0d359 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -49,6 +49,12 @@
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
+/*
+ * Used to indicate a pte for which a 'break-before-make' sequence is in
+ * progress.
+ */
+#define KVM_INVALID_PTE_LOCKED		BIT(10)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
@@ -671,6 +677,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	return !!pte;
 }
 
+static bool stage2_pte_is_locked(kvm_pte_t pte)
+{
+	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
+}
+
 static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
 {
 	if (!kvm_pgtable_walk_shared(ctx)) {
@@ -681,6 +692,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
 	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
 }
 
+/**
+ * stage2_try_break_pte() - Invalidates a pte according to the
+ *			    'break-before-make' requirements of the
+ *			    architecture.
+ *
+ * @ctx: context of the visited pte.
+ * @data: stage-2 map data
+ *
+ * Returns: true if the pte was successfully broken.
+ *
+ * If the removed pte was valid, performs the necessary serialization and TLB
+ * invalidation for the old value. For counted ptes, drops the reference count
+ * on the containing table page.
+ */
+static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
+				 struct stage2_map_data *data)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+
+	if (stage2_pte_is_locked(ctx->old)) {
+		/*
+		 * Should never occur if this walker has exclusive access to the
+		 * page tables.
+		 */
+		WARN_ON(!kvm_pgtable_walk_shared(ctx));
+		return false;
+	}
+
+	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
+		return false;
+
+	/*
+	 * Perform the appropriate TLB invalidation based on the evicted pte
+	 * value (if any).
+	 */
+	if (kvm_pte_table(ctx->old, ctx->level))
+		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+	else if (kvm_pte_valid(ctx->old))
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, ctx->addr, ctx->level);
+
+	if (stage2_pte_is_counted(ctx->old))
+		mm_ops->put_page(ctx->ptep);
+
+	return true;
+}
+
+static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+
+	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
+
+	if (stage2_pte_is_counted(new))
+		mm_ops->get_page(ctx->ptep);
+
+	smp_store_release(ctx->ptep, new);
+}
+
 static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
 			   struct kvm_pgtable_mm_ops *mm_ops)
 {
@@ -795,7 +864,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, new;
 	int ret;
 
 	ret = stage2_map_walker_try_leaf(ctx, data);
@@ -812,17 +881,18 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
+	if (!stage2_try_break_pte(ctx, data)) {
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
+
 	/*
 	 * If we've run into an existing block mapping then replace it with
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	if (stage2_pte_is_counted(ctx->old))
-		stage2_put_pte(ctx, data->mmu, mm_ops);
-
 	new = kvm_init_table_pte(childp, mm_ops);
-	mm_ops->get_page(ctx->ptep);
-	smp_store_release(ctx->ptep, new);
+	stage2_make_pte(ctx, new);
 
 	return 0;
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

