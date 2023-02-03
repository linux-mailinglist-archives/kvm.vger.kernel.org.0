Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B1168A2F8
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 20:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjBCT2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 14:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbjBCT2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 14:28:35 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E96A9D72
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 11:28:31 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id jp14-20020a17090ae44e00b0022a03158ec6so2759332pjb.9
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 11:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JnRekf2u9xlodJ6kWv+4sMoTYGQkhV0MHFbmGB0K31Y=;
        b=Zi6H4ARQow0EtXg0mUHG9UGNsiViGbeZO/GDNJqScT1LjoaHQG/12s0iu9hLuYReeH
         t9C1ND+dlehha7qxQlRIP3e3fttV6FiwBMPowHok+6ipPXZJMeqYAk3AS0hnbk34FRk4
         GRrc3WZIrvEOJAtBfEjk3pbqjV7T/JZXj4XsXMpgodFXBxvGflCKR88pCDoLsqjU9Hx/
         rfdTnpdHymBjyFU2lVEsP8hzxnLaRnQo2GLObrDxfiv76bQJlDJkKVrHOsVRhEQ1xoLC
         bwd49pgcBDx5UlmZRnmSn4IJ/BG8CEufoOwm2BZvpbAUTAPsciIep4wD/BTUu7bR74p4
         2ASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JnRekf2u9xlodJ6kWv+4sMoTYGQkhV0MHFbmGB0K31Y=;
        b=T36Zp6WcIL1ii5pF4wPzTMrdW+kmjrCU0BoEyj9t6dCX4MRw47gi7KU6nutbnZHFQ7
         RahCwUKR3EG+x9hORCkjlUClDCWFyGGPtMMotcxWrnCoVNBpJKAepTNTCwxD8K0V71wc
         Fw3pNFin+SRwePtDGa56bfZ+yDGpwSnv1IMRtc23WaOq8A0of7GAkMGzWL43x8AUc7ZI
         guPJMSjHr09ARI3Icd5C8YRdJXVHo5bHKAGXtMsVb53/28nm5ymxklKWL9h8y3vayroL
         2DW8TKuIKZRXwrIyyBLLgabY6ExKmp+IYMlFSQonkcFoOfzcGvqm3n2qIBrkYDXWpaqo
         0mtw==
X-Gm-Message-State: AO0yUKUX/lep5O128OSd+2tMRFq3aGcacG6CD430TVVIJzLs6x8OILIH
        53x2/Qm/fkYXKqNzAEY+vr4K7v/7UBJC
X-Google-Smtp-Source: AK7set8HEhb/WKin9Nzbz6yw2PsRWv4cp1+q/7AvpsPGthF1dn8lqEjA/0CohysFBe0L9jS/JynJ3Po43EN5
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:b10f:b0:22c:6d9e:10f3 with SMTP id
 z15-20020a17090ab10f00b0022c6d9e10f3mr1496364pjq.57.1675452510817; Fri, 03
 Feb 2023 11:28:30 -0800 (PST)
Date:   Fri,  3 Feb 2023 11:28:20 -0800
In-Reply-To: <20230203192822.106773-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203192822.106773-4-vipinsh@google.com>
Subject: [Patch v2 3/5] KVM: x86/mmu: Optimize SPTE change for aging gfn range
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

No need to check all of the conditions in __handle_changed_spte(). Aging
a gfn range implies resetting access bit or marking spte for access
tracking.

Use atomic operation to only reset those bits. This avoids checking many
conditions in __handle_changed_spte() API. Also, clean up code by
removing dead code and API parameters.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++------------------------
 1 file changed, 25 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 83f15052aa6c..18630a06fa1f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -697,7 +697,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 
 
 /*
- * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
+ * _tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
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
+static u64 _tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+			     u64 old_spte, u64 new_spte, gfn_t gfn, int level)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -732,37 +726,20 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
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
-{
-	WARN_ON_ONCE(iter->yielded);
-
-	iter->old_spte = __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
-					    iter->old_spte, new_spte,
-					    iter->gfn, iter->level,
-					    record_acc_track);
-}
-
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true);
-}
+	WARN_ON_ONCE(iter->yielded);
 
-static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
-						 struct tdp_iter *iter,
-						 u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, false);
+	iter->old_spte = _tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
+					   iter->old_spte, new_spte,
+					   iter->gfn, iter->level);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
@@ -911,8 +888,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
 		return false;
 
-	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true);
+	_tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
+			  sp->gfn, sp->role.level + 1);
 
 	return true;
 }
@@ -1251,32 +1228,37 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
+ *
+ * No need to mark corresponding PFN as accessed as this call is coming from
+ * MMU notifier for that page via HVA.
  */
 static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 			  struct kvm_gfn_range *range)
 {
-	u64 new_spte = 0;
+	u64 new_spte;
 
 	/* If we have a non-accessed entry we don't need to change the pte. */
 	if (!is_accessed_spte(iter->old_spte))
 		return false;
 
-	new_spte = iter->old_spte;
-
-	if (spte_ad_enabled(new_spte)) {
-		new_spte &= ~shadow_accessed_mask;
+	if (spte_ad_enabled(iter->old_spte)) {
+		iter->old_spte = kvm_tdp_mmu_clear_spte_bit(iter,
+							    shadow_accessed_mask);
+		new_spte = iter->old_spte & ~shadow_accessed_mask;
 	} else {
+		new_spte = mark_spte_for_access_track(iter->old_spte);
+		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte,
+							new_spte, iter->level);
 		/*
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(new_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(new_spte));
-
-		new_spte = mark_spte_for_access_track(new_spte);
+		if (is_writable_pte(iter->old_spte))
+			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
 	}
 
-	tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
+	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
+				       iter->old_spte, new_spte);
 
 	return true;
 }
-- 
2.39.1.519.gcb327c4b5f-goog

