Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAE875D914
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 04:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjGVCXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 22:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjGVCXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 22:23:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0721FCD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:23:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d05e334f436so1281372276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 19:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992587; x=1690597387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CAxgFYrkZ9qbsDUo1uJQpSTW39yNyw7CK8s0M5hY5O0=;
        b=3iFGmjsCWI0cSr6R+O6VEjCyfW9zvlMHhWJhG+l839P3FsYO4gL1EVp1Zvl8J5KBZm
         gWDHLZwbR5T/RsdaSMNr+PWsaXoHdcJclYOVj00Ryvz0JXZ4BYS8/+hx3pK8yUTJJeTo
         a5/Y/WZRJ+Cpgl2754cfdsBfDPMsEJuS4tz3ZfnIVNX/gGU28fvxGMohv8fTo1VivHM+
         k5v3mRdaKw/ow8ksLRSjR5aq5SfbYF/x22thzHDkHXkkUesujuRvwYduBTk7tl7yPQ2N
         TmTvFyIwsFPUtv4YYKm+MwQFY8Nm7KPPVkWXEVgsNp0Pql6llfmedndioi5rKnBNAGiA
         xZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992587; x=1690597387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CAxgFYrkZ9qbsDUo1uJQpSTW39yNyw7CK8s0M5hY5O0=;
        b=SIO7CKasiAejmwhJ4hZMWKF7+AhgVFWixyIhHoNbazWT0j4GFAyKVHDFVacvDhE++c
         WdpG1falrz9/DpRO8/CdSP6tBGBRMJUHd8dgANi65ElN/Vrg54NFlptkMKBxUZO+XjBy
         cDEYqAe9T7gfqnrNni5/kW4MtFlcUqMF5/7K7OZlSuQIfRoX/9i2cmZtlHr382du3JVH
         o76CHfu/0s2q9OFZA2g8Qh9bFbI51Pek4BuUs/Qbg5WPfuQVsbaldH9PikvoNFEAJOk5
         hwKqPB4rbS3yh1SEnJ0ooxgZCsqsmo6LGaC3j/IHNtoM27aBbJbCIheDMp9CuBw+D9Vz
         yYcw==
X-Gm-Message-State: ABy/qLY59LwE2IoC6w9e0WRXudiej6E3MlSFDGpORY3DCe2fgoKQvQDj
        Q6Dj4yD6yjUlH1mH2w/GOtwqH5fuKisP
X-Google-Smtp-Source: APBJJlGMDpIVJqpXTTAq2sIMW6qbt+e8DqurrZE8mbv8BJ0pkJpydFhWPniYpjZ4KSuFNcWAmdJj1syWWRwO
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:2fd5:0:b0:cb0:e4d4:f4ff with SMTP id
 v204-20020a252fd5000000b00cb0e4d4f4ffmr22044ybv.3.1689992586869; Fri, 21 Jul
 2023 19:23:06 -0700 (PDT)
Date:   Sat, 22 Jul 2023 02:22:51 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-13-rananta@google.com>
Subject: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for unmap
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
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current implementation of the stage-2 unmap walker traverses
the given range and, as a part of break-before-make, performs
TLB invalidations with a DSB for every PTE. A multitude of this
combination could cause a performance bottleneck on some systems.

Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
invalidations until the entire walk is finished, and then
use range-based instructions to invalidate the TLBs in one go.
Condition deferred TLB invalidation on the system supporting FWB,
as the optimization is entirely pointless when the unmap walker
needs to perform CMOs.

Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
now serves the stage-2 unmap walker specifically, rather than
acting generic.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5ef098af1736..cf88933a2ea0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 	smp_store_release(ctx->ptep, new);
 }
 
-static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
-			   struct kvm_pgtable_mm_ops *mm_ops)
+struct stage2_unmap_data {
+	struct kvm_pgtable *pgt;
+	bool defer_tlb_flush_init;
+};
+
+static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
+{
+	/*
+	 * If FEAT_TLBIRANGE is implemented, defer the individual
+	 * TLB invalidations until the entire walk is finished, and
+	 * then use the range-based TLBI instructions to do the
+	 * invalidations. Condition deferred TLB invalidation on the
+	 * system supporting FWB, as the optimization is entirely
+	 * pointless when the unmap walker needs to perform CMOs.
+	 */
+	return system_supports_tlb_range() && stage2_has_fwb(pgt);
+}
+
+static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data *unmap_data)
+{
+	bool defer_tlb_flush = __stage2_unmap_defer_tlb_flush(unmap_data->pgt);
+
+	/*
+	 * Since __stage2_unmap_defer_tlb_flush() is based on alternative
+	 * patching and the TLBIs' operations behavior depend on this,
+	 * track if there's any change in the state during the unmap sequence.
+	 */
+	WARN_ON(unmap_data->defer_tlb_flush_init != defer_tlb_flush);
+	return defer_tlb_flush;
+}
+
+static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
+				struct kvm_s2_mmu *mmu,
+				struct kvm_pgtable_mm_ops *mm_ops)
 {
+	struct stage2_unmap_data *unmap_data = ctx->arg;
+
 	/*
-	 * Clear the existing PTE, and perform break-before-make with
-	 * TLB maintenance if it was valid.
+	 * Clear the existing PTE, and perform break-before-make if it was
+	 * valid. Depending on the system support, the TLB maintenance for
+	 * the same can be deferred until the entire unmap is completed.
 	 */
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+
+		if (!stage2_unmap_defer_tlb_flush(unmap_data))
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
+					ctx->addr, ctx->level);
 	}
 
 	mm_ops->put_page(ctx->ptep);
@@ -1070,7 +1108,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable *pgt = ctx->arg;
+	struct stage2_unmap_data *unmap_data = ctx->arg;
+	struct kvm_pgtable *pgt = unmap_data->pgt;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 	kvm_pte_t *childp = NULL;
@@ -1098,7 +1137,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ctx, mmu, mm_ops);
+	stage2_unmap_put_pte(ctx, mmu, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
@@ -1112,13 +1151,23 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
+	int ret;
+	struct stage2_unmap_data unmap_data = {
+		.pgt = pgt,
+		.defer_tlb_flush_init = __stage2_unmap_defer_tlb_flush(pgt),
+	};
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
-		.arg	= pgt,
+		.arg	= &unmap_data,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	if (stage2_unmap_defer_tlb_flush(&unmap_data))
+		/* Perform the deferred TLB invalidations */
+		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
+
+	return ret;
 }
 
 struct stage2_attr_data {
-- 
2.41.0.487.g6d72f3e995-goog

