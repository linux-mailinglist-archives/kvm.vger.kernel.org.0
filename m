Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D68692CA7
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjBKBrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBKBqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:46:53 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2AC84F58
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:45 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id t3-20020a170902e1c300b0019a84b88f70so150098pla.19
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LQavnvPA7sTuc9JB1orqdV5Xojq0c/KlFgV3VwSeK0k=;
        b=icmDPkGL44J2kqQwV1RYnsD2fVzMq1tDWbJdeuolq0tIfvmvcyAgR3mvlsuZ0H6PSp
         XFxgo7b+BhE+x73Qz71vIt8UnQba+Y1xvdSJUh2T8z3+iRarDp2n6ZlFkO13JS8UC+QX
         tmh9QJdHEh5YTxZVvQbw1/eV24cBMlusEhDV+xi7JyIXvLZGPr9gYWsDUDxZw/b2ELGH
         EwPotRyQi+Tc7RwkasEKUeF3Jul+fL+otCjmhdZXsZs880/yCSmGAsMhcdwXxxlTsG6V
         M2da1299K16+NoVxLp0adPTY0g0lYM2etXmhW+xSz8GeSF/ZSxqSFRWkWIa7qJnJ5bS3
         dRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQavnvPA7sTuc9JB1orqdV5Xojq0c/KlFgV3VwSeK0k=;
        b=pOxAjMMuVLUcDroJdtumieM8SCmvLtTKY9907kPKUso++5NIPTV+V3ourkch+TKhiN
         lvcGS87TovfgFXo+FmzKHZolnzMHgNnPs1/cphWupWeeAfDNFEKn9dzIgTEfNpWZWytj
         DM6HtLDQoKx77qet7MNnLox47dgmnzF9k1exUEcKzHThC4d9yjMQOkopqo8eZQhji5ps
         mh3ldSBAJ51NbKfMQzYOm+xFzh75OTiKzKhoZ+1fZC1CWEUfQnxD6WucG6yHdduV6WNg
         2IvWE4fkMMr8KFbTGf2bxFHsPq+/mvfgX7ymJN+aZDtInoKhHxMyNeUIfOSCcV6QXzYh
         yiVA==
X-Gm-Message-State: AO0yUKWCkbA1dqzy3ht0fpy/hQnJeaIG3/flxVY+3IkFfxkGREJTDTh7
        BHzJ4D9v7HeEemuGn4K541LMsRmwDvUG
X-Google-Smtp-Source: AK7set/eG1ZlNuQSoJZEd5WvqmwTqycjbs629sGD/uywCliUkSpNTY+oyNqP12ndtyXlzxB00C9kiPCFkQjl
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:dd:b0:5a8:189d:b53f with SMTP id
 e29-20020a056a0000dd00b005a8189db53fmr2515330pfj.6.1676080004721; Fri, 10 Feb
 2023 17:46:44 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:46:26 -0800
In-Reply-To: <20230211014626.3659152-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211014626.3659152-8-vipinsh@google.com>
Subject: [Patch v3 7/7] KVM: x86/mmu: Merge all handle_changed_pte* functions.
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

__handle_changed_pte() and handle_changed_spte_acc_track() are always
used together. Merge these two functions and name the new function
handle_changed_pte(). Remove the existing handle_changed_pte() function
which just calls __handle_changed_pte and
handle_changed_spte_acc_track().

This converges SPTEs change handling code to a single place.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++---------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0c031319e901..67538ec48ce5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -334,17 +334,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
 
-static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
-{
-	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
-		return;
-
-	if (is_accessed_spte(old_spte) &&
-	    (!is_shadow_present_pte(new_spte) || !is_accessed_spte(new_spte) ||
-	     spte_to_pfn(old_spte) != spte_to_pfn(new_spte)))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
-}
-
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
@@ -487,7 +476,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 }
 
 /**
- * __handle_changed_spte - handle bookkeeping associated with an SPTE change
+ * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
  * @as_id: the address space of the paging structure the SPTE was a part of
  * @gfn: the base GFN that was mapped by the SPTE
@@ -501,9 +490,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
-static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 old_spte, u64 new_spte, int level,
-				  bool shared)
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level,
+				bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -587,15 +576,10 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-}
 
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
-{
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
-			      shared);
-	handle_changed_spte_acc_track(old_spte, new_spte, level);
+	if (was_leaf && is_accessed_spte(old_spte) &&
+	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
+		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
 /*
@@ -638,9 +622,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
 		return -EBUSY;
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, true);
-	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    new_spte, iter->level, true);
 
 	return 0;
 }
@@ -705,8 +688,7 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
-	handle_changed_spte_acc_track(old_spte, new_spte, level);
+	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 	return old_spte;
 }
 
@@ -1276,7 +1258,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * Note, when changing a read-only SPTE, it's not strictly necessary to
 	 * zero the SPTE before setting the new PFN, but doing so preserves the
 	 * invariant that the PFN of a present * leaf SPTE can never change.
-	 * See __handle_changed_spte().
+	 * See handle_changed_spte().
 	 */
 	tdp_mmu_iter_set_spte(kvm, iter, 0);
 
@@ -1301,7 +1283,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	/*
 	 * No need to handle the remote TLB flush under RCU protection, the
 	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
-	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
+	 * shadow page. See the WARN on pfn_changed in handle_changed_spte().
 	 */
 	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
 }
-- 
2.39.1.581.gbfd45094c4-goog

