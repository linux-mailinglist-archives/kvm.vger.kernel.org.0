Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D29692C9E
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjBKBq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjBKBqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:46:51 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8606E84F72
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:42 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id u18-20020a62ed12000000b00593cc641da4so3431042pfh.0
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ilQD1ZwfOZ+d2+O+AXt7dFLjcZcLaA1r/kAp0uBR7mU=;
        b=PdwRuNZr5qWt72w20yZfAeNVSTn+Uwkm5WaseLyWoj7zvwCv5tBjeMIQQwybX4veDF
         006bGVjCu6QI8eRjrg32Xec+RnDfgzWKAiq6UcM6h8DUFq5IEkcMpD++bzRF4nC56zP+
         LO7TiApbuF2VCN52PILf2eZ9f2dAanYCU+9Ki7zwdjTUUIF1cdpPCCZ1H+Q9riLM3c/K
         AknD+8fIbtUCg10CXhbQYiPpxBErkWPZDfpuCGjwX8y1NB7XClNWsirwkeCsiUfnUhqu
         0Koth+qR6OIxRElg/2asJa+iK7/rpmoDuuS6qX9m9hA7rNk3qJ9C6mIQqrnKckRs8E8U
         6LUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ilQD1ZwfOZ+d2+O+AXt7dFLjcZcLaA1r/kAp0uBR7mU=;
        b=fSt21F2t1VVuWf0IsUgFAMnx35+d+LfiFfqfYkAJZG67qaC5LFsl+IqNWXvqsIpfGm
         fSaTCeLzZratRa9W3JbcRaMLzVb8pzDGdxbfu0d9p0FU5jI8Fo9tQwWjPB7zosdy+iS2
         rIUWDt71/3zAAVUlQWXV/OT9B+qoYOA2cdUJS3D8v0zMKcykJ6+jjJlhEBDJBsgd8i5Q
         lkQgYDX9sf5GBi9hIM1su28bqDfm8pKn5Ul6u2VLOlIJhqRA7zvkuTqQlfMbrPjUnDjT
         0TTqrZSnx2GivNXau9ZAm4Uvki1TRb3uqBEtrhDvglmrXOFGy5Z/OY6907wbXLy6vmLh
         Wd7g==
X-Gm-Message-State: AO0yUKUEDznXAxGUQxZpHG5W6d9AMgYf21xJvJocZaBITBwDQtttcQyN
        IQWfwNyVXuTC/yQPB6Wz94VeeCublsev
X-Google-Smtp-Source: AK7set9U4Yaa0zpTFVx5Wxa0jeIjgqiyiZa13NAhHdcyUs62NVEkjx/lJfvzmjwiNtL4FFIrziz6y4YeF4qv
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:e806:b0:198:eeb5:637b with SMTP id
 u6-20020a170902e80600b00198eeb5637bmr4391689plg.23.1676080000973; Fri, 10 Feb
 2023 17:46:40 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:46:24 -0800
In-Reply-To: <20230211014626.3659152-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211014626.3659152-6-vipinsh@google.com>
Subject: [Patch v3 5/7] KVM: x86/mmu: Remove "record_acc_track" in __tdp_mmu_set_spte()
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove bool parameter "record_acc_track" from __tdp_mmu_set_spte() and
refactor the code. This variable is always set to true by its caller.

Remove single and double underscore prefix from tdp_mmu_set_spte()
related APIs:
1. Change __tdp_mmu_set_spte() to tdp_mmu_set_spte()
2. Change _tdp_mmu_set_spte() to tdp_mmu_iter_set_spte()

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++-------------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5d6e77554797..e50e869bf879 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -697,7 +697,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 
 
 /*
- * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
+ * tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
  * @kvm:	      KVM instance
  * @as_id:	      Address space ID, i.e. regular vs. SMM
  * @sptep:	      Pointer to the SPTE
@@ -705,18 +705,12 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  * @new_spte:	      The new value that will be set for the SPTE
  * @gfn:	      The base GFN that was (or will be) mapped by the SPTE
  * @level:	      The level _containing_ the SPTE (its parent PT's level)
- * @record_acc_track: Notify the MM subsystem of changes to the accessed state
- *		      of the page. Should be set unless handling an MMU
- *		      notifier for access tracking. Leaving record_acc_track
- *		      unset in that case prevents page accesses from being
- *		      double counted.
  *
  * Returns the old SPTE value, which _may_ be different than @old_spte if the
  * SPTE had voldatile bits.
  */
-static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
-			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
-			      bool record_acc_track)
+static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+			    u64 old_spte, u64 new_spte, gfn_t gfn, int level)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -732,30 +726,19 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
-
-	if (record_acc_track)
-		handle_changed_spte_acc_track(old_spte, new_spte, level);
-
+	handle_changed_spte_acc_track(old_spte, new_spte, level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte, new_spte,
 				      level);
 	return old_spte;
 }
 
-static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				     u64 new_spte, bool record_acc_track)
+static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+					 u64 new_spte)
 {
 	WARN_ON_ONCE(iter->yielded);
-
-	iter->old_spte = __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
-					    iter->old_spte, new_spte,
-					    iter->gfn, iter->level,
-					    record_acc_track);
-}
-
-static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				    u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true);
+	iter->old_spte = tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
+					  iter->old_spte, new_spte,
+					  iter->gfn, iter->level);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
@@ -847,7 +830,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared)
-			tdp_mmu_set_spte(kvm, &iter, 0);
+			tdp_mmu_iter_set_spte(kvm, &iter, 0);
 		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
 			goto retry;
 	}
@@ -904,8 +887,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
 		return false;
 
-	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true);
+	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
+			 sp->gfn, sp->role.level + 1);
 
 	return true;
 }
@@ -939,7 +922,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
+		tdp_mmu_iter_set_spte(kvm, &iter, 0);
 		flush = true;
 	}
 
@@ -1110,7 +1093,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		if (ret)
 			return ret;
 	} else {
-		tdp_mmu_set_spte(kvm, iter, spte);
+		tdp_mmu_iter_set_spte(kvm, iter, spte);
 	}
 
 	tdp_account_mmu_page(kvm, sp);
@@ -1317,13 +1300,13 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * invariant that the PFN of a present * leaf SPTE can never change.
 	 * See __handle_changed_spte().
 	 */
-	tdp_mmu_set_spte(kvm, iter, 0);
+	tdp_mmu_iter_set_spte(kvm, iter, 0);
 
 	if (!pte_write(range->pte)) {
 		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
 								  pte_pfn(range->pte));
 
-		tdp_mmu_set_spte(kvm, iter, new_spte);
+		tdp_mmu_iter_set_spte(kvm, iter, new_spte);
 	}
 
 	return true;
@@ -1814,7 +1797,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (new_spte == iter.old_spte)
 			break;
 
-		tdp_mmu_set_spte(kvm, &iter, new_spte);
+		tdp_mmu_iter_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
 	}
 
-- 
2.39.1.581.gbfd45094c4-goog

