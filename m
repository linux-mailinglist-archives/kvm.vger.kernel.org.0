Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1DA708D12
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 02:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjESAwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 20:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjESAwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 20:52:45 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8A510DF
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:42 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id ca18e2360f4ac-76c63aadc10so27405539f.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457562; x=1687049562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGsmPoc/T4Ss3kfVhJrmlF6LuTv5aUCcul/iCKRGGfw=;
        b=xW05sinAfw8C44WTP/9vyg4AsrI69Imj2ZmwYQLJZF8kEHkqon5WhJrYk6DNXK7Gw6
         ORpvYUQiCd6GWx/VkoJW+RFSdfhvlRh0N9mjXQWCD6GhGofxw22goCURFVI2zQtlWjI3
         q40Px7tzzEXTuwbuR/ZiN0k40rk4wWlizlUEyM3BENmLsLioAlGtY649VgAWbXD8mNoT
         jqpj50br7Y7C26Wwzs7ZYrY5XUZtlZuQUEmP94MjpBLWtfJKC0Hj0gvsmYFqFZ6EU0/5
         BTWcttwAOtqDV1LAtO7UFkbUjq6YDBOiaJ3QlnQPpYOq6lbHz3ZzDuYKfXJ/7nDGH2YH
         /vSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457562; x=1687049562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGsmPoc/T4Ss3kfVhJrmlF6LuTv5aUCcul/iCKRGGfw=;
        b=dsyVcpTOktB4ccot3dl9/XEh1C1JgL5sAF722egZzWTedLqAeEVtp0y1LYm6w+TvBJ
         otgVhNH1yeYHDB4+Xn49qNb1E81XsIp29qvhJhXpge35GqVVBFmaIP83E5a+KOANxKLd
         9IqWZNH+Lba7Pm1KA+rINqBJyraLRAFnvOKzmLHLwuIpqw9OA5vRhck+G5sx0KQWxUnX
         wMjALZwWd0uqTH1GH3ci2dAl3NiOeXQW9TWqgYkdZMCRFPvXItUZnZePmwn3Qwuqtpf+
         9NccVpS+ituYFEwIwcQEKFa7HojvF5e3TJ1Kvq8QRxdR7IEV/cjMZJUwyim/Y9cL/iqU
         oBbQ==
X-Gm-Message-State: AC+VfDz3zVNhenYMVyW1pC2WADkx6FALZVhMNbktZeaLHG0qT47k6flC
        s9Y5c98aRX19tMeRWW1HkfEDrH4noZ7R
X-Google-Smtp-Source: ACHHUZ6TXO388gzfHLwp1jHRgCji0izRBrbXcyR7uAZvijYpyuzGsSLXba63Usu2McZd5g1WZCldx8ML+Rhn
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6602:2ac4:b0:763:b184:fe92 with SMTP
 id m4-20020a0566022ac400b00763b184fe92mr5060981iov.0.1684457562041; Thu, 18
 May 2023 17:52:42 -0700 (PDT)
Date:   Fri, 19 May 2023 00:52:31 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-7-rananta@google.com>
Subject: [PATCH v4 6/6] KVM: arm64: Use TLBI range-based intructions for unmap
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

Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
now serves the stage-2 unmap walker specifically, rather than
acting generic.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b8f0dbd12f773..5832ee3418fb0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -771,16 +771,34 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 	smp_store_release(ctx->ptep, new);
 }
 
-static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
-			   struct kvm_pgtable_mm_ops *mm_ops)
+static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
 {
+	/*
+	 * If FEAT_TLBIRANGE is implemented, defer the individial PTE
+	 * TLB invalidations until the entire walk is finished, and
+	 * then use the range-based TLBI instructions to do the
+	 * invalidations. Condition this upon S2FWB in order to avoid
+	 * a page-table walk again to perform the CMOs after TLBI.
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
 	/*
 	 * Clear the existing PTE, and perform break-before-make with
 	 * TLB maintenance if it was valid.
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
@@ -1015,7 +1033,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ctx, mmu, mm_ops);
+	stage2_unmap_put_pte(ctx, mmu, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
@@ -1029,13 +1047,20 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
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
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
+				addr, addr + size);
+
+	return ret;
 }
 
 struct stage2_attr_data {
-- 
2.40.1.698.g37aff9b760-goog

