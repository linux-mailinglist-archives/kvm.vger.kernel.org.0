Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87A5774F2F
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjHHXOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbjHHXOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:14:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B84212A
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:13:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d4df4a2c5dcso4105673276.2
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536429; x=1692141229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRhPhhyCVrvwh8HFH9MoQf2shI38NIr8PShGiYFRBxo=;
        b=Zc3XMNBSUBa7GJhE2tyVMoUFP74xH5x2uC+RObeuMypOT4zBfhNjgfLsgmCF/VIUL/
         c3YFkKJLvbJ6noh+FEA5EU6B4Y8bvu62qUzHsuhleSUfz8cH5tQ1h2wfzfwa++wsDdyt
         FdRoKf2t/zrH8Qz4fT0OA2Kl3es/jcoD04x+E+eEDzWE42d8etHaIXAOrwOpk5u/mKfh
         SD5EM0YbNXhL7Ht7OKRuV/ykqM5iiJ9AioVsAY1rEO1cFvrWt6QecQuf0sR7bTSV6B5Y
         5rkKiGP8xtgnes8eLdl7Hzw4R6tX27rsB7R7EcqhdtJaraNhkYwbavnno/QAT62FPCbn
         dJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536429; x=1692141229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRhPhhyCVrvwh8HFH9MoQf2shI38NIr8PShGiYFRBxo=;
        b=RqHAsN+WgqfsTS1zA9Vw5jpQbDfLZXSV1vvzjT5nUp/H4L46vo+KWEykqynl5XtxOv
         AflPvD11SB1GmS0eFWi2WrqzKmQ3JOC1ZIT572wTSttb9AUhQbXoopaFj8fQGU4MAHW1
         hxLwnKX019ogNUaKV54FD8VIWnZVgz4FDogYPiwRo0BBp34qfArpumDaZLRUyCQKwRV0
         pgLv7RSLLcG05I65xU8RgZsOdj21LMTP1a9HWYe2r4yj9uxNUDQnjmkctwmzzG36Uw98
         ayWnX3GK08laoPFHeVQ2LTkRhmY6kwQjk5vnIKIvPf+sCikViUiedY8kv/xhIjPsE6rE
         6OqA==
X-Gm-Message-State: AOJu0YxHh8bF5qSgC5BhQQ2h6PlP7cxWvfUtruVQmVTWuuY9HG8WFKUP
        HTmGeEpxM7FS18qdjgETE/rUgDjmpiuw
X-Google-Smtp-Source: AGHT+IEDJhl5pfGMsCT/iI4kA7cKyLhi3xdcFmiU1wBNjxnpzamybXY7e3K9E1XS3MNVQtxNcdIYmyqlwdlH
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5b:88c:0:b0:d1e:721b:469d with SMTP id
 e12-20020a5b088c000000b00d1e721b469dmr20600ybq.7.1691536429525; Tue, 08 Aug
 2023 16:13:49 -0700 (PDT)
Date:   Tue,  8 Aug 2023 23:13:30 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-15-rananta@google.com>
Subject: [PATCH v8 14/14] KVM: arm64: Use TLBI range-based intructions for unmap
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
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
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
 arch/arm64/kvm/hyp/pgtable.c | 40 +++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5ef098af17362..eaaae76481fa9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -831,16 +831,36 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 	smp_store_release(ctx->ptep, new);
 }
 
-static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
-			   struct kvm_pgtable_mm_ops *mm_ops)
+static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
 {
 	/*
-	 * Clear the existing PTE, and perform break-before-make with
-	 * TLB maintenance if it was valid.
+	 * If FEAT_TLBIRANGE is implemented, defer the individual
+	 * TLB invalidations until the entire walk is finished, and
+	 * then use the range-based TLBI instructions to do the
+	 * invalidations. Condition deferred TLB invalidation on the
+	 * system supporting FWB as the optimization is entirely
+	 * pointless when the unmap walker needs to perform CMOs.
+	 */
+	return system_supports_tlb_range() && stage2_has_fwb(pgt);
+}
+
+static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
+				struct kvm_s2_mmu *mmu,
+				struct kvm_pgtable_mm_ops *mm_ops)
+{
+	struct kvm_pgtable *pgt = ctx->arg;
+
+	/*
+	 * Clear the existing PTE, and perform break-before-make if it was
+	 * valid. Depending on the system support, defer the TLB maintenance
+	 * for the same until the entire unmap walk is completed.
 	 */
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+
+		if (!stage2_unmap_defer_tlb_flush(pgt))
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
+					ctx->addr, ctx->level);
 	}
 
 	mm_ops->put_page(ctx->ptep);
@@ -1098,7 +1118,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ctx, mmu, mm_ops);
+	stage2_unmap_put_pte(ctx, mmu, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
@@ -1112,13 +1132,19 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
+	int ret;
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
 		.arg	= pgt,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	if (stage2_unmap_defer_tlb_flush(pgt))
+		/* Perform the deferred TLB invalidations */
+		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
+
+	return ret;
 }
 
 struct stage2_attr_data {
-- 
2.41.0.640.ga95def55d0-goog

