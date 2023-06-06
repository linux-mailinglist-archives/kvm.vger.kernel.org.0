Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6571B724D0F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 21:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbjFFT3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 15:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239356AbjFFT3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 15:29:16 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3651732
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 12:29:10 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id ca18e2360f4ac-774efe8c0cfso409472539f.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 12:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686079749; x=1688671749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VhTidRsQ7M0B21RWWeLYKjL/CqqK7Lwi7zT2NAAb1NY=;
        b=xRdfPtc42t3tWbTgM9ApieV/cDRl7yttpemwXRGTQ29qIVK/7EzJsoDi1w7500YQxK
         VkZroFYdAFjD4L8oeQoYclUdM3xt/ovyCUAsu5x/j9Pe6iUmDMSfCEArYp2QxzAQ5O6Z
         A/hHw65k++MQ3lkHpkZeObv/86BZddej7Q6Owxqr+0GDTHWYhA8Ekyxm69emOOf0VJXJ
         r1yUFL1fTbbmeDyUpxa5IqlBqW2Q9ZuwWKmdPrY9jzAqk7eMKbPnTCqjzQ6g6gu6Rezb
         Qs6bqyRlTvej95KtDkRzujhhevLRfzsMlKJ3gKk5lfozadujZQAR7894f9QC/T7/hDpu
         E4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686079749; x=1688671749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VhTidRsQ7M0B21RWWeLYKjL/CqqK7Lwi7zT2NAAb1NY=;
        b=ceHhcMpFYHbpAStiQzD9C+AhH9lIViAlbE6Woh1DU5pZSD/tdLY1wJtKlLVwHObODK
         2vnt601jAThdosykIcBEiInczid9hrGZQflndDITz4JvyaZZdbiNfjjsgguukH2GGhpN
         5nOweaCuq92gpWTKRmproLxaRPUGSf0Mjb1gQTriIj0gP4PBmahMkgX/OiPuLO3JNjfQ
         KszTFenNK7Q5NMVgGCqqwjD5Dt9yOofRVtKyyJO1xdNTFzfOd3XTrmsqQ9yYoKsElXVT
         UMn22fqNQ7RIQRKpDfAkoe8kkZmD/b+GFkNbyciZYA3MrcavLWLwjrG4kdwtwE2ZSFIc
         dojA==
X-Gm-Message-State: AC+VfDxGtChE8J0U6x3n3YPbFiHAgvFw9ugKSeQ+Rk04dCMfNGIrG0sx
        0FDNcgRrhmgZ53/hKs6PDCmjMTTvOIrk
X-Google-Smtp-Source: ACHHUZ7QCQzpJGrZKqBh5n3es8NB7ieKOI67W6rTPhyCwNnbXcHk5AAG6ZdYbhJ9YFPUUVxtemi/vNZ/436T
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5e:8345:0:b0:777:b726:3e17 with SMTP id
 y5-20020a5e8345000000b00777b7263e17mr1513935iom.3.1686079749368; Tue, 06 Jun
 2023 12:29:09 -0700 (PDT)
Date:   Tue,  6 Jun 2023 19:28:58 +0000
In-Reply-To: <20230606192858.3600174-1-rananta@google.com>
Mime-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606192858.3600174-8-rananta@google.com>
Subject: [PATCH v5 7/7] KVM: arm64: Use TLBI range-based intructions for unmap
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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
index 50ef7623c54db..c6e080867919d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -789,16 +789,54 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
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
@@ -1005,7 +1043,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable *pgt = ctx->arg;
+	struct stage2_unmap_data *unmap_data = ctx->arg;
+	struct kvm_pgtable *pgt = unmap_data->pgt;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 	kvm_pte_t *childp = NULL;
@@ -1033,7 +1072,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ctx, mmu, mm_ops);
+	stage2_unmap_put_pte(ctx, mmu, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
@@ -1047,13 +1086,23 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
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
2.41.0.rc0.172.g3f132b7071-goog

