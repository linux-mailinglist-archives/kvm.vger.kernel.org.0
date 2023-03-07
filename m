Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630A96AD5D4
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCGDqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjCGDqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:46:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942584C6D6
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 19:46:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id r13-20020a25760d000000b0096c886848c9so12717921ybc.3
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 19:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPheaVcCbjSmROjElANCHCHz5AMlJCBRQkCYrvmfbqU=;
        b=WxzFs7JxxYImFM2eogjaHHE3j/Guhz9RteJOE6Yvo7foersk17L159zhAsf4Hl+8lY
         jFtVvvVjqAN7eNKo33ysvgKJwUM6BMy9eIY4+GxYTZOGw/1DSrEFFzaejk3b+WWNioEe
         cBMlBKvP4bVfnq+vkpz7X8Eh7Du8Drg1dneZ8iDhU11sVoSri2X+lOPUvYvzg5Ht2DFa
         pllMqbUjBGeYeIka/V26CHJwAWMu1jYccDW8xgi4vIpy5Tv3aYswT2kkmPH9ZuPJl55t
         YAMozr7wag+WtHBlGWqRb1/KyiljV0FW/nQi/Ma5A9V6LCWNuMXzi8W2Ez5sf7tZeFRG
         +isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPheaVcCbjSmROjElANCHCHz5AMlJCBRQkCYrvmfbqU=;
        b=UHr6436FlAUoUKcaiQLGW3BVMCHlAlMI57MgA9ElVWMu7q6kmgbuRbu9YOQTnwBpru
         S/RM0h4iYI5q5I6sYItA/qqLzjQTpIckgZb/8Htr5syw2cRdJ+cdjy7rC6PnOcp2ymRH
         nVqTk8UTTUCvQWo6v8H0dxWczMrFQ1OOtCc4ONxpodWbQEkIhwGylTlES/jN60BBZKJx
         NyAsiPoC9x42xGTb0QmirrTUZqxh2lC/ejQTyAIIpFdH/1iR4JUk+UiN+/KIF2yMImf8
         x8GtegLesNNbWOh2MH0KodNbSMcOK6MyQ1VhUyUQAtUr7tPqRDpOIH9NBXtqepYBazFJ
         DT/g==
X-Gm-Message-State: AO0yUKVT2xkHlWySMc5gZb9PA5KjOshX6weciqQmiubuIvReMjb1zwF0
        uqII7snLGB4UxgC6hvpaqLlDJpfo867ehQ==
X-Google-Smtp-Source: AK7set+fqoEuVvKk0bd9tdokqq3ZyjFzf4QWcHC3PLM/mqaktQFkzCCnuiuJqqWCxnmTxHxJKjfAP6JD3e8ADQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:5b54:0:b0:52b:e47f:8a00 with SMTP id
 p81-20020a815b54000000b0052be47f8a00mr1ywb.22.1678160761453; Mon, 06 Mar 2023
 19:46:01 -0800 (PST)
Date:   Tue,  7 Mar 2023 03:45:45 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-3-ricarkol@google.com>
Subject: [PATCH v6 02/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
perform break-before-make (BBM) nor cache maintenance operations
(CMO). This will by a future commit to create unlinked tables not
accessible to the HW page-table walker.  This is safe as these
unlinked tables are not visible to the HW page-table walker.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 26a4293726c1..c7a269cad053 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -195,6 +195,12 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					with other software walkers.
  * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
  *					invoked from a fault handler.
+ * @KVM_PGTABLE_WALK_SKIP_BBM:		Visit and update table entries
+ *					without Break-before-make
+ *					requirements.
+ * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
+ *					without Cache maintenance
+ *					operations required.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
@@ -202,6 +208,8 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
 	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
+	KVM_PGTABLE_WALK_SKIP_BBM		= BIT(5),
+	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -223,6 +231,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
 	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
 }
 
+static inline bool kvm_pgtable_walk_skip_bbm(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM;
+}
+
+static inline bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO;
+}
+
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
  * @cb:		Callback function to invoke during the walk.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a3246d6cddec..4f703cc4cb03 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -741,14 +741,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
 		return false;
 
-	/*
-	 * Perform the appropriate TLB invalidation based on the evicted pte
-	 * value (if any).
-	 */
-	if (kvm_pte_table(ctx->old, ctx->level))
-		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
-	else if (kvm_pte_valid(ctx->old))
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+	if (!kvm_pgtable_walk_skip_bbm(ctx)) {
+		/*
+		 * Perform the appropriate TLB invalidation based on the
+		 * evicted pte value (if any).
+		 */
+		if (kvm_pte_table(ctx->old, ctx->level))
+			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+		else if (kvm_pte_valid(ctx->old))
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
+				     ctx->addr, ctx->level);
+	}
 
 	if (stage2_pte_is_counted(ctx->old))
 		mm_ops->put_page(ctx->ptep);
@@ -832,11 +835,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
-	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
+	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->dcache_clean_inval_poc &&
+	    stage2_pte_cacheable(pgt, new))
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
+					       granule);
 
-	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
+	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->icache_inval_pou &&
+	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
 	stage2_make_pte(ctx, new);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

