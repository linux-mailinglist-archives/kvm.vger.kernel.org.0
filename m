Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC6E47E967
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350668AbhLWWZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350428AbhLWWYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:13 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCFAC061397
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:07 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l8-20020a17090b078800b001b1ea649932so4205819pjz.7
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=m2NUt0YQCUbB2JSkCtN1Bl6Y1QWFIXMkBLahtwZY7/s=;
        b=YzqzLnyXRuM6L7Ffw/8wI5A6X5zjaE1QmoPkdckCRZTXk1468EB4TaUutLC870JEs/
         D2Er9gFljcJcQBnyqhvmzhzqdmQtV3UWUJhR1rgxSdCLR4tz4JX0KCXjJN+4j3zpxeRL
         n4eHMhMLfeYsEplYJ+7t8hZCtXbsU7hjl+fpOGd7VoCD1pXrPS8ppka7xNM0MQxlz+KA
         1Xy0YiasqIqrhLK4f/H+l7yna5qImJj3G0QfRgBoN6CNchvmQ39ixo518o2hm78MaeXp
         bDOELzlSCJviu8pEIENxRBS1cFqUzUv3gyJ1OwHZvxCPzvrZB4O3+p4hNB2JXqfgT798
         IRsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=m2NUt0YQCUbB2JSkCtN1Bl6Y1QWFIXMkBLahtwZY7/s=;
        b=sfOZxZiE6UrzaFQ/fo3dnY6i+ZhV+4VfYdmhW+cPMVgXm3OI0BvQT6O7m3/On/sZzq
         jkJ1smi8x4S6tIfma5blfJloR1tv0eBx7fJvA24R/tLO8DT8RKsdsVFVGhupJD2dF0mR
         I3HxF/ODH0jbOpnbhvu0I5EAhvy5J/5sCnqTyTF5zV3R0wbz2kz8LXLPv945mPnlPPop
         ZuDpF6N0qfXamAYXUTmsu1ejKrBocb7nc3xsTxQnVGm+b7auYWK7du1ivBkxh2yE2DDk
         bUbGy0wX8RhSMY+E0g3tIMLMfU7l9FUPPNLUssnI6NDTTA1GM9pFBK/f1Aego3D3Uftv
         QSQQ==
X-Gm-Message-State: AOAM531PVyzUmo+PpTJEJQK/Zj/lPc6DHtAo2orjKfAVSAaXLy9zeshA
        kanMeRpuTHwCUcQ992DRq6I3gxOZFyA=
X-Google-Smtp-Source: ABdhPJx9IZfY2Dm8iZbhUgNO0BdBxPrFsSThO9N46OLB36o1pCnkUbXN7kAMnazK+1FxngDXepUoZx/Njoc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:22c3:b0:4ba:f0a1:a9b6 with SMTP id
 f3-20020a056a0022c300b004baf0a1a9b6mr4266028pfj.36.1640298247335; Thu, 23 Dec
 2021 14:24:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:04 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 16/30] KVM: x86/mmu: Refactor low-level TDP MMU set SPTE
 helper to take raw vals
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor __tdp_mmu_set_spte() to work with raw values instead of a
tdp_iter objects so that a future patch can modify SPTEs without doing a
walk, and without having to synthesize a tdp_iter.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e2d217cbeca3..61596b4a8121 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -611,9 +611,13 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
- * @kvm: kvm instance
- * @iter: a tdp_iter instance currently on the SPTE that should be set
- * @new_spte: The value the SPTE should be set to
+ * @kvm:	      KVM instance
+ * @as_id:	      Address space ID, i.e. regular vs. SMM
+ * @sptep:	      Pointer to the SPTE
+ * @old_spte:	      The current value of the SPTE
+ * @new_spte:	      The new value that will be set for the SPTE
+ * @gfn:	      The base GFN that was (or will be) mapped by the SPTE
+ * @level:	      The level _containing_ the SPTE (its parent PT's level)
  * @record_acc_track: Notify the MM subsystem of changes to the accessed state
  *		      of the page. Should be set unless handling an MMU
  *		      notifier for access tracking. Leaving record_acc_track
@@ -625,12 +629,10 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  *		      Leaving record_dirty_log unset in that case prevents page
  *		      writes from being double counted.
  */
-static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				      u64 new_spte, bool record_acc_track,
-				      bool record_dirty_log)
+static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
+			       bool record_acc_track, bool record_dirty_log)
 {
-	WARN_ON_ONCE(iter->yielded);
-
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -640,39 +642,48 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
+	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
-	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+	kvm_tdp_mmu_write_spte(sptep, new_spte);
+
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false);
 	if (record_acc_track)
-		handle_changed_spte_acc_track(iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_acc_track(old_spte, new_spte, level);
 	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
-					      iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
+					      new_spte, level);
+}
+
+static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				     u64 new_spte, bool record_acc_track,
+				     bool record_dirty_log)
+{
+	WARN_ON_ONCE(iter->yielded);
+
+	__tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep, iter->old_spte,
+			   new_spte, iter->gfn, iter->level,
+			   record_acc_track, record_dirty_log);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
 }
 
 static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-- 
2.34.1.448.ga2b2bfdf31-goog

