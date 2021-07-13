Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D79F3C796A
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 00:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhGMWNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 18:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbhGMWNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 18:13:00 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F59C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:08 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id c5-20020a0562141465b02902e2f9404330so57893qvy.9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mEd5XGUc9YVxgKVGYoPAl8d0y0CLe+qD7UfUb+0I8lY=;
        b=Cfv6Al1RPmZeRlvPCWxt63lWCSxWHCP2GfsnN3iHWgPX/3rWU3esxo/4j3nzLPbtCo
         +um9qzyaC4vF4yfvTllTYjrokgBy9+tlKHG5lVV2093AmzCU2d0d1GI6qFaAspUy2IG3
         yhUMFDqMSL+zTHbSX30lo7FrteI3G7j2AREVP58Z/UBS+D2lBwNar7z7mrMiHSkeQwdu
         5JUeikk/2CJ1jMztyLiiDhLaYdGIUwPnrv6An83ZDzt211isS7QLPIWL8bxEjCqrpu5w
         aLUQjD6vq5P/t+Z2jh/gB0fVt2vKBu7jGY+HR2gJ/v05hkQwlWZjFYxR5ebB0InC0VP2
         3HSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mEd5XGUc9YVxgKVGYoPAl8d0y0CLe+qD7UfUb+0I8lY=;
        b=qafbcFhbOT+29BH53b3HnWWad7bkFdK12qC1Oxd6iRnCr9gz33vvZ720Fz0+GGoG3Q
         +5eT/MmPaTgYHxZ6Pe4pGCUC9sDGsrnwjY8fghTXFTZf6LW7gZHoOBkJTXNR8NYOym9z
         ca3MKOzIfSHo3jst7xjZJxnQmbZPaKU1qxCNjnOYqXWyoRGQNaNULHq96xlZqvG3q8bH
         tLtZAmRU0wFeGiE1zZNkDRcxEAz4zoTURKwcspINReILpUwQmZq6w9TaESFF09vTW4Rr
         z7Bkb0Vkl1tlbu82cu9n8OM5xU6KmgYw2kVfr3ss8AJ9iVkrZNO84Af/OR99vK6relZ2
         hYAw==
X-Gm-Message-State: AOAM531Tlmz7gSgbBCLu90m4037lg0EkY98w8gfH8bnt+7fre/fKjpxY
        u4MIXrBa5Qvn3AbQQht+gOEZK7op1uXpRq7NubDn7lP+YX/4OT3eh0hL9lJT/gmx4rrvnzWbWWa
        auDDsljQXZZoAM+tMftKgZnwhzrMXGGi0JL9xPkFXghr7sbrZyZdaMrXtj1OQpxg=
X-Google-Smtp-Source: ABdhPJx08UcMmWYBYvhMJmAMYUQ1Fya9TfFDxxB8HHo0Nm5z6H1FXINmBWKQwYM5vx0irff8OTPhUR7VIrPpoQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a0c:a997:: with SMTP id
 a23mr7304306qvb.48.1626214207839; Tue, 13 Jul 2021 15:10:07 -0700 (PDT)
Date:   Tue, 13 Jul 2021 22:09:55 +0000
In-Reply-To: <20210713220957.3493520-1-dmatlack@google.com>
Message-Id: <20210713220957.3493520-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20210713220957.3493520-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 4/6] KVM: x86/mmu: fast_page_fault support for the TDP MMU
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
introducing a new helper function kvm_tdp_mmu_fast_pf_get_last_sptep to
grab the lowest level sptep.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 50 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.c | 41 +++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
 3 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e3d99853b962..dedde4105adb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3105,15 +3105,41 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
 	return spte & PT_PRESENT_MASK;
 }
 
+/*
+ * Returns the last level spte pointer of the shadow page walk for the given
+ * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
+ * walk could be performed, returns NULL and *spte does not contain valid data.
+ *
+ * Contract:
+ *  - Must be called between walk_shadow_page_lockless_{begin,end}.
+ *  - The returned sptep must not be used after walk_shadow_page_lockless_end.
+ */
+static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	u64 old_spte;
+	u64 *sptep = NULL;
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
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
 	u64 spte = 0ull;
+	u64 *sptep = NULL;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(error_code))
@@ -3124,14 +3150,15 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 	do {
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
-			if (!is_shadow_present_pte(spte))
-				break;
+		if (is_tdp_mmu(vcpu->arch.mmu))
+			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, gpa, &spte);
+		else
+			sptep = fast_pf_get_last_sptep(vcpu, gpa, &spte);
 
 		if (!is_shadow_present_pte(spte))
 			break;
 
-		sp = sptep_to_sp(iterator.sptep);
+		sp = sptep_to_sp(sptep);
 		if (!is_last_spte(spte, sp->role.level))
 			break;
 
@@ -3189,8 +3216,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.rst to get more detail.
 		 */
-		if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
-					    new_spte)) {
+		if (fast_pf_fix_direct_spte(vcpu, sp, sptep, spte, new_spte)) {
 			ret = RET_PF_FIXED;
 			break;
 		}
@@ -3203,7 +3229,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
+	trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
@@ -3838,11 +3864,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
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
index 98ffd1ba556e..313999c462d1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -527,6 +527,10 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
 	if (is_removed_spte(iter->old_spte))
 		return false;
 
+	/*
+	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
+	 * does not hold the mmu_lock.
+	 */
 	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
 		      new_spte) != iter->old_spte)
 		return false;
@@ -1536,3 +1540,40 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	return leaf;
 }
+
+/*
+ * Returns the last level spte pointer of the shadow page walk for the given
+ * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
+ * walk could be performed, returns NULL and *spte does not contain valid data.
+ *
+ * Contract:
+ *  - Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
+ *  - The returned sptep must not be used after kvm_tdp_mmu_walk_lockless_end.
+ *
+ * WARNING: This function is only intended to be called during fast_page_fault.
+ */
+u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
+					u64 *spte)
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
+	/*
+	 * Perform the rcu_dereference to get the raw spte pointer value since
+	 * we are passing it up to fast_page_fault, which is shared with the
+	 * legacy MMU and thus does not retain the TDP MMU-specific __rcu
+	 * annotation.
+	 *
+	 * This is safe since fast_page_fault obeys the contracts of this
+	 * function as well as all TDP MMU contracts around modifying SPTEs
+	 * outside of mmu_lock.
+	 */
+	return rcu_dereference(sptep);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 93e1bf5089c4..361b47f98cc5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -89,6 +89,8 @@ static inline void kvm_tdp_mmu_walk_lockless_end(void)
 
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
+u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
+					u64 *spte);
 
 #ifdef CONFIG_X86_64
 bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
-- 
2.32.0.93.g670b81a890-goog

