Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079C7668A66
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjAMDuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjAMDuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:05 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C015C12D3C
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:04 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id k18-20020a170902c41200b001896d523dc8so13955423plk.19
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZjRhXEPC2vsb7WOpKphyVNmOEayhCKVSagTVwK+CXE=;
        b=m0sCAioIytK8Y3KnJTXLfxMbnYEWFn9cqCWm4fEsmelo+c3j2aBzy5U+Srm/7J3Bt6
         7HNsFb2BcI0WNv8cK3vppN0msHyojYVdHgzULoN31bKA8B5tEnToC8eGP6CYreBkBhjt
         geVKTpc6aLxPnRSaSOL47CGD0R0Pj6wNyTHmYSjfC1NVIW3iS09Vo65AhxnbPdNLDMT+
         gWbGWtwt5X8ACHTVsHyOpnPCPIMkGISCbyq5xHHf+YblxzRcsnkQSMzWcfNtkKkRIJcq
         69Z5J6VKaKOS7IOrxLbCZT9Ipmh9liXBvuUNxavLsYraYBOFGWn8AKuaiZqR6RWBvD1v
         uiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZjRhXEPC2vsb7WOpKphyVNmOEayhCKVSagTVwK+CXE=;
        b=iEbpzK8a2HPNvaXCwjOAmffpjQntCyukuTpJvhrlwJrDGkVyU6WtwDu+OdoTBy6jzE
         0Kem1irT6oDx+RRyrYz9llbQh7cGiM60frYTLXoJycI0tqbQAUwY2buodQxAG416o0+m
         VBxu7RHFx3DDXynPIBCp4x8Mfi+aV4yqn5S2C00w+E84ZdiDZ+uyH2hmtJZsKxgUNcVE
         pzvMGFciNFMm+j9CLGrFNQ2hvcmIQbWPLwTkOfqUi4+JErfMchHfyrRTsXAOw7k+xEQl
         Df6qR9S52vBx+SgyTlWXl2hilWjaQEOTCmcqDWjC2RoUg10Gs/Lguehc9F931zvL8RBz
         jxdA==
X-Gm-Message-State: AFqh2koic2tqCTaBemR6iEQWONH4iT2xPTxTa/5TgrLjPfPThnXyNciH
        32jvs5Zn2/WEVPLCmmhKATB3wpR1IT/3vA==
X-Google-Smtp-Source: AMrXdXtxEz6Q4oQ8SbH1Gxz2JkQI2nFkBflO+n+bZU0IuqUE0eXpfIbxeGj5xYpYgoxqVygDgol01k7lU6kBeA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:8d95:0:b0:582:9b37:2600 with SMTP id
 i21-20020aa78d95000000b005829b372600mr3186912pfr.57.1673581804224; Thu, 12
 Jan 2023 19:50:04 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:52 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-2-ricarkol@google.com>
Subject: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
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

Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
indicate that the walk is on a removed table not accesible to the HW
page-table walker. Then use it to avoid doing break-before-make or
performing CMOs (Cache Maintenance Operations) when mapping a removed
table. This is safe as these removed tables are not visible to the HW
page-table walker. This will be used in a subsequent commit for
replacing huge-page block PTEs into tables of 4K PTEs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..84a271647007 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -188,12 +188,15 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
+ * @KVM_PGTABLE_WALK_REMOVED:		Indicates the page-tables are
+ *					removed: not visible to the HW walker.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
+	KVM_PGTABLE_WALK_REMOVED		= BIT(4),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -215,6 +218,11 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
 	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
 }
 
+static inline bool kvm_pgtable_walk_removed(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_REMOVED;
+}
+
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
  * @cb:		Callback function to invoke during the walk.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11cf2c618a6..87fd40d09056 100644
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
+	if (!kvm_pgtable_walk_removed(ctx)) {
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
+	if (!kvm_pgtable_walk_removed(ctx) && mm_ops->dcache_clean_inval_poc &&
+	    stage2_pte_cacheable(pgt, new))
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
+					       granule);
 
-	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
+	if (!kvm_pgtable_walk_removed(ctx) && mm_ops->icache_inval_pou &&
+	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
 	stage2_make_pte(ctx, new);
-- 
2.39.0.314.g84b9a713c41-goog

