Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63754494396
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357724AbiASXJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiASXHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:53 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40FEC061759
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:52 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id n203-20020a628fd4000000b004be3d8ec115so2482461pfd.0
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q370c26UHWHufnByiPvqbiDjuZrFLKjArAf8vKj7cww=;
        b=j5J0G6zwiPPCOxXNTGikOijBUS3vUC0uLsRrVNMWf54iB/6xrOSAkGh0wVqLbKftUl
         Y5pqd27leWvM2Na5my/DLuNlDob/9LehjdApD+mQiaWzqCa/H0vWc+jPpawO4Qo3m1zs
         LGo8YGqZEc7mvw3Ydk0azkYJfk4GjWDXEqDjKfK4ap6NqeCXRSR86QN0TnT2Qp0Sc6j6
         iDj/AzuQKeziecfO3Rxn2mbmvBImMh8FB7tjZB+6KiYVJF7BAgvVz1FULKdEgJCOoyhr
         ZpT70aD+RP+SwH+3tF3vBqMSATJCUJksnlHcP+uVSheUFdt/bqzsWzcQZ0rU8A3w1rut
         vDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q370c26UHWHufnByiPvqbiDjuZrFLKjArAf8vKj7cww=;
        b=JPTkd//kItL0exMnPRUMY3ZnOapT88io6niVFZiX2Uq8bqmdvFxpjZA2N/qVIKq+yp
         RKVX+KQZ8S3iRhsLVLHuuYoPI8bpBUWLS3PpI8rtWVHLPPWNv8C5huon7TgSLyWCHw8E
         mSHLFmPXWNxB/62qk+fEoqTUDxun54gX6z229o7NMqcosyRi3/K2X/wNjIeb9o/zdXG5
         2wBO6gsMobixKTXQIesJ4EU+qzhsjiumuLDI4J+tIWTgUNsv/eiyJpkQICBzVh3Z35zr
         wDByAGaiHMgSC0kXOeplKEFJCCoUabchihLuVJhvemsAnONytbdrLpa03LmSI7fS640m
         OdXw==
X-Gm-Message-State: AOAM531wlyixoIdr/5LMGoWUeB3GCTMpbjxZQlSSwP/GiaFWQ+cJjMVB
        UoutoU28ucqcedwCxZUjYvpUdVh7sqAWiw==
X-Google-Smtp-Source: ABdhPJx853GHJeu0GL84+krVXeoSbSJq9cD3emKtyCI63mrZEG+hEoGCcbVkev/XDbExROp5SBWbbI3fLv/5Bg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:120a:b0:149:8dd5:f0e1 with SMTP
 id l10-20020a170903120a00b001498dd5f0e1mr35008348plh.71.1642633672349; Wed,
 19 Jan 2022 15:07:52 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:24 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 03/18] KVM: x86/mmu: Automatically update iter->old_spte if
 cmpxchg fails
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
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate a bunch of code that was manually re-reading the spte if the
cmpxchg failed. There is no extra cost of doing this because we already
have the spte value as a result of the cmpxchg (and in fact this
eliminates re-reading the spte), and none of the call sites depend on
iter->old_spte retaining the stale spte value.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 52 +++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc9e3553fba2..cb7c4e3e9001 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -492,16 +492,23 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * and handle the associated bookkeeping.  Do not mark the page dirty
  * in KVM's dirty bitmaps.
  *
+ * If setting the SPTE fails because it has changed, iter->old_spte will be
+ * refreshed to the current value of the spte.
+ *
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @new_spte: The value the SPTE should be set to
  * Returns: true if the SPTE was set, false if it was not. If false is returned,
- *	    this function will have no side-effects.
+ *          this function will have no side-effects other than setting
+ *          iter->old_spte to the last known value of spte.
  */
 static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter,
 					   u64 new_spte)
 {
+	u64 *sptep = rcu_dereference(iter->sptep);
+	u64 old_spte;
+
 	WARN_ON_ONCE(iter->yielded);
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
@@ -517,9 +524,17 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
 	 * does not hold the mmu_lock.
 	 */
-	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
-		      new_spte) != iter->old_spte)
+	old_spte = cmpxchg64(sptep, iter->old_spte, new_spte);
+	if (old_spte != iter->old_spte) {
+		/*
+		 * The page table entry was modified by a different logical
+		 * CPU. Refresh iter->old_spte with the current value so the
+		 * caller operates on fresh data, e.g. if it retries
+		 * tdp_mmu_set_spte_atomic().
+		 */
+		iter->old_spte = old_spte;
 		return false;
+	}
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, true);
@@ -751,11 +766,6 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			tdp_mmu_set_spte(kvm, &iter, 0);
 			flush = true;
 		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
-			/*
-			 * The iter must explicitly re-read the SPTE because
-			 * the atomic cmpxchg failed.
-			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 			goto retry;
 		}
 	}
@@ -1193,14 +1203,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
 
@@ -1261,14 +1266,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
 
@@ -1392,14 +1392,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		/* Note, a successful atomic zap also does a remote TLB flush. */
-		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
-			/*
-			 * The iter must explicitly re-read the SPTE because
-			 * the atomic cmpxchg failed.
-			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+		if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
 			goto retry;
-		}
 	}
 
 	rcu_read_unlock();
-- 
2.35.0.rc0.227.g00780c9af4-goog

