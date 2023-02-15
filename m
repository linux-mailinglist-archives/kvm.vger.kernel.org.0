Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1969825E
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjBORky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjBORkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:40:52 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8CE39BB5
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:40:51 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-517f8be4b00so225258507b3.3
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B/KCp/Z4FTyIB9CQJtKq6N3+noLJ91OFnIUVo6bQFck=;
        b=nJs7cQBabi7g3RZOx2pbm3SvNKnvqUsfzyVdTA/gUP0ZKRQO7TTYexYE9aEjQiruQ6
         fbK6oNOS7G1xVsOV2Udht6P9vsiLi9hmBO7UGd1jogqmp740hqo9DbzZuNsOjzLpU5R7
         ajMrZW2+v2vvslix7TIbGhq1c6tMqMpxVDrCQwNNDgL+9pY4n1Asw/9KzibLhUW6t9A0
         ztGJMSYazbqkw54nwFGe6qsvoT1SCnRoNLXM3pXHnoiL+8WaUWQHak0R7vk2N+fv2pV4
         Q5NXs+4D7bFPF17ohkvBbrwXKjeRLqsISRJtI1wXP/C1b1RUWVzUMe15Z36k591t8Kjg
         TWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/KCp/Z4FTyIB9CQJtKq6N3+noLJ91OFnIUVo6bQFck=;
        b=zf0OqPUd1XV8Sp68qxVqfJ2OnqXlkYNdCC8UWnH75ZMvMF2m8CY59m+/FibJ19O0Iz
         vr6JLMjdlsDx1cdrt0O9VcTsInT7HFviOLsjsxFhRCEEqt47dSg8HYz0KSm2fu119see
         x3lx6P/04b30gTbUpPER5OqYM4D7pGy/WZ1hPRFQiXiDgBhb7Wu94EaxaU8OOb9QwrKv
         I0q8RknJvrp1DdF2drxboMXkA2Z83QiXnsSc7GqAWao1RAc7XUezvjIdsELNzKR9hlRs
         ntQbql+Dm0Ahr1Ls9FedxTy3qI2afwso9uFMdiBFIhC1hi/lLPqWoqC93VbrVmCqFzv+
         6/zw==
X-Gm-Message-State: AO0yUKVpdZ+J/uvYoxkCFgJkivdf+ysRo9cp/GWqaVBPkz3pnwLK2Vjg
        WmeZotDI6kK6jrnuSYzMj797MwkTpGs7lw==
X-Google-Smtp-Source: AK7set+bgWijZpJZs3bDh4hkYfkbATLgzpivaSg/+p9yVA9hd4Von3l4zJ2X/6ZQ6ZzNq/xoAlM7jJ2xlXZ/lQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:828f:0:b0:86f:8ba9:9474 with SMTP id
 r15-20020a25828f000000b0086f8ba99474mr378251ybk.302.1676482851162; Wed, 15
 Feb 2023 09:40:51 -0800 (PST)
Date:   Wed, 15 Feb 2023 17:40:35 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-2-ricarkol@google.com>
Subject: [PATCH v3 01/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
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
accessible to the HW page-table walker.  This is safe as these removed
tables are not visible to the HW page-table walker.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..3339192a97a9 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -188,12 +188,20 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
+ * @KVM_PGTABLE_WALK_SKIP_BBM:		Visit and update table entries
+ *					without Break-before-make
+ *					requirements.
+ * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
+ *					without Cache maintenance
+ *					operations required.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
+	KVM_PGTABLE_WALK_SKIP_BBM		= BIT(4),
+	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(4),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -215,6 +223,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
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
index b11cf2c618a6..e093e222daf3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -717,14 +717,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
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
@@ -808,11 +811,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
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
2.39.1.637.g21b0678d19-goog

