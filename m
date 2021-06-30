Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755A03B8A35
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 23:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhF3Vu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 17:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhF3Vuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 17:50:55 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4691BC061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:26 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x7-20020a63db470000b029022199758419so2571718pgi.11
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qhds78sLytz0NDmqseIIdT2KolYiSOyxHvyuNC8rmzc=;
        b=aEbI1MkbLTQQS1YNxtiBWLfIibs00RAC+i8k4bpp0AJ6FESuKxPJMchdoxI4zVOnp7
         2NjErx7+rJbJZ8AYTgjv5k/hEflaKQjfh7SL1W4Iglb8XwtEv0zHD8PTizNfDeP9rqYV
         3eV8tLUhWKefqI8GXGcsxzyNHMHPOlyWaSrqyHSJzpa7r61BxhqGghow9ebG1bDXkyph
         c/9uk9r2tvfFA0Jbhu0VeZyS5roIaPeaIvcdO/tPOFY4EUHXC4OdSJ4KuHPQ+7o1pvUF
         EK94I10SQBExq8y6kkN0E0Svvo+MvlLCrOCTCFwA4+scxDAHSdxeRLMKKPdWUxccyIHs
         7yxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qhds78sLytz0NDmqseIIdT2KolYiSOyxHvyuNC8rmzc=;
        b=LKhEx02ogpwQO6ZLmyPAirgzG/HF8c1VU8z6Ocs2ZNEY7XfidTbFFlOuG2+aGHrjpa
         mNpCHkJSAOY5g531DcaBqLCi0imf5JTlyFiGQy5QsAhblI+gv2R0jQtZndWXameZCMmk
         JzCFJg4YsMqHf1QHGu3l/qlRkko9HL8exwm6B9tWFmSyt15qr1a8Ya4E+lE1wOS799b8
         2QD21QH3uAPwKTrX7Lrixii3goEP70EwmuEv/QqVCZtsC6wCi2We0dCqqQnn6H0kSg8F
         y+KgDJhmtBKAHMFjcrdwNx3vvqSZ/Swi3aqAyqOpsPiSYPjP4fxZwf+Jyw7k0t0sjdkM
         6xXg==
X-Gm-Message-State: AOAM532hSc/HS05bAUoR/kchw+Of3sWhaO0YdvxKxJQ99DGRDyx2gpSr
        Cs3JxZSUtoSXQWHfduSm8NOtCF0d7JD0pu40buR2O5vcBcJ70mZxYIK6tlTLZJXOC+3JrwJ0YQA
        DkC8t5GP3peKn3bwDfhCX3ha6M6V2MTgZ8RvQermywqVdq9u5pvYBEzQh5w0NUgs=
X-Google-Smtp-Source: ABdhPJwq3GA75LkHv4v9akGqohzTIuxtEfhxL1oHRMxrF2J/TM5vNmUmHJVdzeQQtbdsJ5mbdxSuBQJl9a1xKA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:9ed1:0:b029:2f2:fb20:bac3 with SMTP
 id r17-20020aa79ed10000b02902f2fb20bac3mr22739375pfq.6.1625089705578; Wed, 30
 Jun 2021 14:48:25 -0700 (PDT)
Date:   Wed, 30 Jun 2021 21:48:00 +0000
In-Reply-To: <20210630214802.1902448-1-dmatlack@google.com>
Message-Id: <20210630214802.1902448-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 4/6] KVM: x86/mmu: fast_page_fault support for the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make fast_page_fault interoperate with the TDP MMU by leveraging
walk_shadow_page_lockless_{begin,end} to acquire the RCU read lock and
introducing a new helper function kvm_tdp_mmu_get_last_sptep_lockless to
grab the lowest level sptep.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 55 +++++++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
 3 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 88c71a8a55f1..1d410278a4cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3105,15 +3105,45 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
 	return spte & PT_PRESENT_MASK;
 }
 
+/*
+ * Returns the last level spte pointer of the shadow page walk for the given
+ * gpa, and sets *spte to the spte value. This spte may be non-preset.
+ *
+ * If no walk could be performed, returns NULL and *spte does not contain valid
+ * data.
+ *
+ * Constraints:
+ *  - Must be called between walk_shadow_page_lockless_{begin,end}.
+ *  - The returned sptep must not be used after walk_shadow_page_lockless_end.
+ */
+u64 *get_last_sptep_lockless(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	u64 old_spte;
+	u64 *sptep = NULL;
+
+	if (is_tdp_mmu(vcpu->arch.mmu))
+		return kvm_tdp_mmu_get_last_sptep_lockless(vcpu, gpa, spte);
+
+	for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
+		sptep = iterator.sptep;
+		*spte = old_spte;
+
+		if (!is_shadow_present_pte(old_spte))
+			break;
+	}
+
+	return sptep;
+}
+
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
 static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 {
-	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
 	u64 spte = 0ull;
+	u64 *sptep = NULL;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(error_code))
@@ -3122,16 +3152,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 	walk_shadow_page_lockless_begin(vcpu);
 
 	do {
+		struct kvm_mmu_page *sp;
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
-			if (!is_shadow_present_pte(spte))
-				break;
-
+		sptep = get_last_sptep_lockless(vcpu, gpa, &spte);
 		if (!is_shadow_present_pte(spte))
 			break;
 
-		sp = sptep_to_sp(iterator.sptep);
+		sp = sptep_to_sp(sptep);
 		if (!is_last_spte(spte, sp->role.level))
 			break;
 
@@ -3189,8 +3217,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.rst to get more detail.
 		 */
-		if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
-					    new_spte)) {
+		if (fast_pf_fix_direct_spte(vcpu, sp, sptep, spte, new_spte)) {
 			ret = RET_PF_FIXED;
 			break;
 		}
@@ -3203,7 +3230,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
+	trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
@@ -3838,11 +3865,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	if (!is_tdp_mmu_fault) {
-		r = fast_page_fault(vcpu, gpa, error_code);
-		if (r != RET_PF_INVALID)
-			return r;
-	}
+	r = fast_page_fault(vcpu, gpa, error_code);
+	if (r != RET_PF_INVALID)
+		return r;
 
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c6fa8d00bf9f..2c9e0ed71fa0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -527,6 +527,10 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
 	if (is_removed_spte(iter->old_spte))
 		return false;
 
+	/*
+	 * TDP MMU sptes can also be concurrently cmpxchg'd in
+	 * fast_pf_fix_direct_spte as part of fast_page_fault.
+	 */
 	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
 		      new_spte) != iter->old_spte)
 		return false;
@@ -1546,3 +1550,35 @@ int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	return leaf;
 }
+
+/*
+ * Must be called between kvm_tdp_mmu_walk_shadow_page_lockless_{begin,end}.
+ *
+ * The returned sptep must not be used after
+ * kvm_tdp_mmu_walk_shadow_page_lockless_end.
+ */
+u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
+					 u64 *spte)
+{
+	struct tdp_iter iter;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	gfn_t gfn = addr >> PAGE_SHIFT;
+	tdp_ptep_t sptep = NULL;
+
+	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+		*spte = iter.old_spte;
+		sptep = iter.sptep;
+	}
+
+	if (sptep)
+		/*
+		 * Perform the rcu dereference here since we are passing the
+		 * sptep up to the generic MMU code which does not know the
+		 * synchronization details of the TDP MMU. This is safe as long
+		 * as the caller obeys the contract that the sptep is not used
+		 * after kvm_tdp_mmu_walk_shadow_page_lockless_end.
+		 */
+		return rcu_dereference(sptep);
+
+	return NULL;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index e9dde5f9c0ef..508a23bdf7da 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -81,6 +81,8 @@ void kvm_tdp_mmu_walk_lockless_begin(void);
 void kvm_tdp_mmu_walk_lockless_end(void);
 int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 				  int *root_level);
+u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
+					 u64 *spte);
 
 #ifdef CONFIG_X86_64
 bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
-- 
2.32.0.93.g670b81a890-goog

