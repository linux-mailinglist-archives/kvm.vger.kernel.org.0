Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922A247382F
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244065AbhLMW72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244059AbhLMW71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:27 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368EDC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:27 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k11-20020a63d84b000000b003252e72da7eso9687204pgj.23
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9BHI/mobmlpPhu8DAqt3Cjhleh/JUHkhj3UVTpYC7Qo=;
        b=Tydtockk7dWRR2uLeiPyQoQfTCpoN26GVQ+IjYUt0TSV148yw/H08wBBoWGgAtE8M3
         bkEwTT4kNDgAbwxeFOr+JQDNymcfTXeyoihlBY9l6AGlyXrGyzE3F1nOe5CrlVOz+giD
         rB4A1U4hqjPTnMwDdYBdLGmvpazhd1u/fj3vcMWagi6JPictAQT9y0LJNS/GcvpCJzIH
         F1SYj8tXLmjPY8fsea3VTIXv7BvaUjcPqEPZRDvMIkXgpPcY70x+MZAGkrPY+Nj8+QzI
         9supmF0/c2P9gtrPx0X5njCVyhTjBdKGlEFcGhtQDLmZcDSVFt1Shlo7BxPjrYXpkAl8
         8Gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9BHI/mobmlpPhu8DAqt3Cjhleh/JUHkhj3UVTpYC7Qo=;
        b=VWUYKKhXssbYr6ZzWxnKIz/zK7swmx3bdbdQcNuBJ3R1di6uWRiJszaR13rw03viW/
         k58o3Lx38OeLYiFznudiHGhs7oDcWR/8x7GYfYzoghI6GyeOq81scL3qNt4t96gMA121
         B8XrWFSBLmzIt5yXBg3RxgrhmXB7M0OBhcV7mcGm1GOmwRpaynRaJH9Mbo//LPXLdYdm
         oqJynsNTT/P7bjoIfga1UcVaqz1RRqr2HFsNCz83Fu4a+AnCVNS8gdHymJt3rkPCYpy5
         i+4X/TIqpgVV467u4MYlY5lYfSIgyOIiFzqkP5s6Moih30MNGVGoTIR15iVIuhI3nk3M
         XbNg==
X-Gm-Message-State: AOAM531eE6Zu2Qmt4ht7cjyrPJ05bbNADis5XxyG2Moo3V5MbniocUNq
        57bSVlSov+bEuLUnZpyFR5UmN0KlXeKxRg==
X-Google-Smtp-Source: ABdhPJx2fyZCvqWmZyyqRKneoB+xXbF/HSrFUSyDoLLZR1CuuDxpNCdnrIF2rWFyhkbfEOOgVz4VPjRdJk7b+Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:6b8c:b0:148:8a86:a01c with SMTP
 id p12-20020a1709026b8c00b001488a86a01cmr1209381plk.50.1639436366709; Mon, 13
 Dec 2021 14:59:26 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:08 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 03/13] KVM: x86/mmu: Automatically update iter->old_spte if
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
cmpxchg fails. There is no extra cost of doing this because we already
have the spte value as a result of the cmpxchg (and in fact this
eliminates re-reading the spte), and none of the call sites depend on
iter->old_spte retaining the stale spte value.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b69e47e68307..656ebf5b20dc 100644
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
@@ -515,9 +521,15 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
 	 * does not hold the mmu_lock.
 	 */
-	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
-		      new_spte) != iter->old_spte)
+	old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);
+	if (old_spte != iter->old_spte) {
+		/*
+		 * The cmpxchg failed because the spte was updated by another
+		 * thread so record the updated spte in old_spte.
+		 */
+		iter->old_spte = old_spte;
 		return false;
+	}
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, true);
@@ -748,11 +760,6 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -985,6 +992,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			 * path below.
 			 */
 			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
@@ -1190,14 +1198,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
 
@@ -1258,14 +1261,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
 
@@ -1389,14 +1387,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
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
2.34.1.173.g76aa8bc2d0-goog

