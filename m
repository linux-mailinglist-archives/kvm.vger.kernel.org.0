Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC026E2970
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 19:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjDNRaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 13:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjDNR3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 13:29:47 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E9D7ED0
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 10:29:33 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id r12-20020a056602234c00b00760a20a99e8so4360579iot.7
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 10:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681493372; x=1684085372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B/zMNPvsJ76QjkM1FVDxX2x1kCiWFrXUv8piHTPNmKE=;
        b=Nx6yKI3EIRZ1j9gTwptzX9+uokMoja8+/mQJmU3Rbml7atU0NoaDLBGoC2ADYzVIzd
         7aha5aGITbsGDsKM1l7NfS0DEzKHMH2NeeQayQA6VslRgzCarBgdYEG+PUEtCAER1UXf
         fyrUxrpkNjxH5oSb49dS7Rfk+7CWIo2gqojXOL8s9xSwDoxq+npACrZokCS2ovl6fOzW
         8l09mW/ccEk4oAdZg2MnlEm5WTsX7ut19ZEDWM18wpQZ6t2WzsLVdUB3PkYURffuJxRY
         g+aUVAE5+Yw98jqRcnug+ZTFUE+1aDOhSwxOp+NtIoyMuMlVf2eoWotUhma2O9uNKFW9
         +UAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493372; x=1684085372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/zMNPvsJ76QjkM1FVDxX2x1kCiWFrXUv8piHTPNmKE=;
        b=NBQac5mPG3PmNa6Mh9aiT7XPRSvmilo6U8yGvlMjlhEZBlb1K0E/rBQGEMMeZwh/30
         8EZtwuKC99BtsrrNW0n2Bz9Ep1PfaeMM8cznqYiRKMm/ZDKpwx+jUibRmVACnfcAtyNz
         S2tIYnTSgfq+MOq1syFXwExz+mHsTNRf2V0kymq1b5ujcL8Wycldjb90DcxVTGWGAMI2
         ETtekIu5aEoqkiyY2UA/6cZ5QQeddyGHQ2d7PBEb+yOMuTQ4CNtQ/XQq5X/buqpgZE3W
         UsB+SLjHQZYeViFP5SZDpH5LXjKNVl/gSUmDj8AYEhJlGgFWHkS0VHC6hz6jvwnjCsPX
         wmfA==
X-Gm-Message-State: AAQBX9f0RzQ+1ByKL7fsLUv+b0+0oVAr3xhVYuHN3vGTvVDICiW6Jhmj
        yKrPlhOwuH/1/Tdn5g0biwtS/JjEyFXg
X-Google-Smtp-Source: AKy350Z4dUZKdVtn0ngicjL45vSsU+MnN2dqL/cSY7ktGGKCk03DL47Ioacf0/CM1+w6Tkn33IoibTV1wujW
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:85ed:0:b0:40b:bd17:3c31 with SMTP id
 d100-20020a0285ed000000b0040bbd173c31mr2482742jai.0.1681493372447; Fri, 14
 Apr 2023 10:29:32 -0700 (PDT)
Date:   Fri, 14 Apr 2023 17:29:22 +0000
In-Reply-To: <20230414172922.812640-1-rananta@google.com>
Mime-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230414172922.812640-8-rananta@google.com>
Subject: [PATCH v3 7/7] KVM: arm64: Use TLBI range-based intructions for unmap
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
combination could cause a performance bottleneck.

Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
invalidations until the entire walk is finished, and then
use range-based instructions to invalidate the TLBs in one go.
Condition this upon S2FWB in order to avoid walking the page-table
again to perform the CMOs after issuing the TLBI.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3f136e35feb5e..bcb748e3566c7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -987,10 +987,16 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
+struct stage2_unmap_data {
+	struct kvm_pgtable *pgt;
+	bool skip_pte_tlbis;
+};
+
 static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable *pgt = ctx->arg;
+	struct stage2_unmap_data *unmap_data = ctx->arg;
+	struct kvm_pgtable *pgt = unmap_data->pgt;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 	kvm_pte_t *childp = NULL;
@@ -1018,7 +1024,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ctx, mmu, mm_ops, false);
+	stage2_put_pte(ctx, mmu, mm_ops, unmap_data->skip_pte_tlbis);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
@@ -1032,13 +1038,32 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
+	int ret;
+	struct stage2_unmap_data unmap_data = {
+		.pgt = pgt,
+		/*
+		 * If FEAT_TLBIRANGE is implemented, defer the individial PTE
+		 * TLB invalidations until the entire walk is finished, and
+		 * then use the range-based TLBI instructions to do the
+		 * invalidations. Condition this upon S2FWB in order to avoid
+		 * a page-table walk again to perform the CMOs after TLBI.
+		 */
+		.skip_pte_tlbis = system_supports_tlb_range() &&
+					stage2_has_fwb(pgt),
+	};
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
-		.arg	= pgt,
+		.arg	= &unmap_data,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	if (unmap_data.skip_pte_tlbis)
+		/* Perform the deferred TLB invalidations */
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
+				addr, addr + size);
+
+	return ret;
 }
 
 struct stage2_attr_data {
-- 
2.40.0.634.g4ca3ef3211-goog

