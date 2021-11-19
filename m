Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7843D4579CC
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbhKTABd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbhKTABR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:17 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65170C06173E
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:15 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m15-20020a170902bb8f00b0014382b67873so5338379pls.19
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+5FkbEhx1+9GLVuvk8L93fKbVlYearXqDKwYBbqQGyM=;
        b=J47SqzCVE674c+S+p5XhPXNPtiUpiobr5ZLjHVmBMWqoDbo7Lo/B8LgRidDs4r/Lf8
         3VbgHm3sqq3B6iQYOcnOGYLdQQkS0mvaGY18DUt5nFkSClyk+dvy3ZyuPtVyUSWeDyWC
         f+KP84lqd29GRxChGs0+5a5vG4aEyBHn+mFBf1G3zVB9O2Fr9Lkwz5nfjRmi1Ejbv9k9
         dAtmDiTGvTJf7rpXpkS0qpGbMPMrMGe3W3hg+RGszAtpZaUjTOuSX+k+nZ382eYwNcTW
         kUUSSVkaOknfJZY9mD1DQWWQN2+PrRR9/b75tTcdvZ7Sgy6X3j5Amf9chVez/hruJxte
         UM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+5FkbEhx1+9GLVuvk8L93fKbVlYearXqDKwYBbqQGyM=;
        b=RCLjszOOn9S2gp4DwkCb2YRBIhCJEZufJjtjjLcMpLne687brqdkDZYJCfn/+ggZ0U
         Eg4QowP6+vr60dx8YY3tFzCBaJ5C0WlAhI/H8TfWLwqHg0KEenJaHwujIN71uRAd9Cpb
         1ZH+aNT6iOs7EvkQ8/m0DRGO4j/8sDe1mfeMrwRiGkTEanfuwZgyrdfmc4uPtVlrACPn
         1pYiApCKHWQXUuRwxiT2QDLshokh30xFvpC4sOc4TRY+uIqofZvwmYPYWHWEOFOR3mb2
         Tg/EcUknTLTB6A2eYjudop1zdKpRFxoz7k6G+wNwECVUCpahLrfSxhfRN/3uMKGIdz+1
         i6xw==
X-Gm-Message-State: AOAM531lATvV2iXgTevApOrSvP39ZujB9UCvzTNAgnuyA84BFyF97hEl
        Afz625VokTpTEPMiv1L1EQBkV/Ts/jSoMg==
X-Google-Smtp-Source: ABdhPJxxYB6OpokHiTIXOsuahJdGdcZ/cwDyR5jXqj8GkgVPFTmZ6RbpEcJdgasomqfuV7TJM5DMuIunJ0wKIw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:714f:b0:142:892d:a46 with SMTP id
 u15-20020a170902714f00b00142892d0a46mr80956847plm.39.1637366294873; Fri, 19
 Nov 2021 15:58:14 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:47 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 03/15] KVM: x86/mmu: Automatically update iter->old_spte
 if cmpxchg fails
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate a bunch of code that was manually re-reading the spte if the
cmpxchg fails. There is no extra cost of doing this because we already
have the spte value as a result of the cmpxchg (and in fact this
eliminates re-reading the spte), and none of the call sites depend on
iter->old_spte retaining the stale spte value.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 56 ++++++++++++--------------------------
 1 file changed, 18 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 377a96718a2e..cc9fe33c9b36 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -492,16 +492,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * and handle the associated bookkeeping.  Do not mark the page dirty
  * in KVM's dirty bitmaps.
  *
+ * If setting the SPTE fails because it has changed, iter->old_spte will be
+ * updated with the updated value of the spte.
+ *
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @new_spte: The value the SPTE should be set to
  * Returns: true if the SPTE was set, false if it was not. If false is returned,
- *	    this function will have no side-effects.
+ *          this function will have no side-effects other than updating
+ *          iter->old_spte to the latest value of spte.
  */
 static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter,
 					   u64 new_spte)
 {
+	u64 old_spte;
+
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	/*
@@ -515,9 +521,11 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
 	 * does not hold the mmu_lock.
 	 */
-	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
-		      new_spte) != iter->old_spte)
+	old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);
+	if (old_spte != iter->old_spte) {
+		iter->old_spte = old_spte;
 		return false;
+	}
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, true);
@@ -747,14 +755,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!shared) {
 			tdp_mmu_set_spte(kvm, &iter, 0);
 			flush = true;
-		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
-			/*
-			 * The iter must explicitly re-read the SPTE because
-			 * the atomic cmpxchg failed.
-			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
 			goto retry;
-		}
 	}
 
 	rcu_read_unlock();
@@ -978,13 +980,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		    is_large_pte(iter.old_spte)) {
 			if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
 				break;
-
-			/*
-			 * The iter must explicitly re-read the spte here
-			 * because the new value informs the !present
-			 * path below.
-			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
@@ -1190,14 +1185,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
 
-		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
-			/*
-			 * The iter must explicitly re-read the SPTE because
-			 * the atomic cmpxchg failed.
-			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
 			goto retry;
-		}
+
 		spte_set = true;
 	}
 
@@ -1258,14 +1248,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 				continue;
 		}
 
-		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
-			/*
-			 * The iter must explicitly re-read the SPTE because
-			 * the atomic cmpxchg failed.
-			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
 			goto retry;
-		}
+
 		spte_set = true;
 	}
 
@@ -1391,14 +1376,9 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 							    pfn, PG_LEVEL_NUM))
 			continue;
 
-		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
-			/*
-			 * The iter must explicitly re-read the SPTE because
-			 * the atomic cmpxchg failed.
-			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+		if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
 			goto retry;
-		}
+
 		flush = true;
 	}
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

