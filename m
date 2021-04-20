Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265B8365663
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhDTKmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:34977 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231686AbhDTKmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:16 -0400
IronPort-SDR: nFmwmUOHo4IMDiPqPCUZDCJqX7YzuLQitJTHUeIz7xNAbervJNBzQvoj5YK6XWmD0zkl8HqiWb
 sqnlzbNWVuzA==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590760"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590760"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:44 -0700
IronPort-SDR: yRD8rx4JwO1QkHOwJR9wZvirKH9XZOShOFXvYllljYYJHtpjVakglboNIKmcYXKF4lRRaIr0VD
 d6YQ35l58sjA==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872773"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:44 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 04/10] KVM: x86/mmu: make try_async_pf() receive single argument
Date:   Tue, 20 Apr 2021 03:39:14 -0700
Message-Id: <20c3f7e7d7214b8fdff6d7882ad49e6ae07a41e7.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert try_async_pf() to receive single struct kvm_page_fault instead of
many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h             |  9 +++++++
 arch/x86/kvm/mmu/mmu.c         | 45 +++++++++++++++++-----------------
 arch/x86/kvm/mmu/paging_tmpl.h | 23 +++++++++--------
 3 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index fa3b1df502e7..b60fcad7279c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -111,12 +111,17 @@ struct kvm_page_fault {
 	struct kvm_vcpu *vcpu;
 	gpa_t cr2_or_gpa;
 	u32 error_code;
+	bool write_fault;
 	bool prefault;
 
 	/* internal state */
 	gfn_t gfn;
 	bool is_tdp;
 	int max_level;
+
+	kvm_pfn_t pfn;
+	hva_t hva;
+	bool map_writable;
 };
 
 static inline void kvm_page_fault_init(
@@ -126,12 +131,16 @@ static inline void kvm_page_fault_init(
 	kpf->vcpu = vcpu;
 	kpf->cr2_or_gpa = cr2_or_gpa;
 	kpf->error_code = error_code;
+	kpf->write_fault = error_code & PFERR_WRITE_MASK;
 	kpf->prefault = prefault;
 
 	/* default value */
 	kpf->is_tdp = false;
 	kpf->gfn = cr2_or_gpa >> PAGE_SHIFT;
 	kpf->max_level = PG_LEVEL_4K;
+	kpf->pfn = KVM_PFN_NOSLOT;
+	kpf->hva = KVM_HVA_ERR_BAD;
+	kpf->map_writable = false;
 }
 
 int kvm_tdp_page_fault(struct kvm_page_fault *kpf);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cb90148f90af..a2422bd9f59b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3646,27 +3646,29 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
-static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
-			 bool write, bool *writable)
+static bool try_async_pf(struct kvm_page_fault *kpf)
 {
+	struct kvm_vcpu *vcpu = kpf->vcpu;
+	gfn_t gfn = kpf->gfn;
+	gpa_t cr2_or_gpa = kpf->cr2_or_gpa;
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
 
 	/* Don't expose private memslots to L2. */
 	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
-		*pfn = KVM_PFN_NOSLOT;
-		*writable = false;
+		kpf->pfn = KVM_PFN_NOSLOT;
+		kpf->map_writable = false;
 		return false;
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
-				    write, writable, hva);
+	kpf->pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
+					kpf->write_fault, &kpf->map_writable,
+					&kpf->hva);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
-	if (!prefault && kvm_can_do_async_pf(vcpu)) {
+	if (!kpf->prefault && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
 			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
@@ -3676,8 +3678,9 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
-				    write, writable, hva);
+	kpf->pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
+					kpf->write_fault, &kpf->map_writable,
+					&kpf->hva);
 	return false;
 }
 
@@ -3689,13 +3692,9 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 	bool prefault = kpf->prefault;
 	int max_level = kpf->max_level;
 	bool is_tdp = kpf->is_tdp;
-	bool write = error_code & PFERR_WRITE_MASK;
-	bool map_writable;
 
 	gfn_t gfn = kpf->gfn;
 	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
-	hva_t hva;
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
@@ -3714,11 +3713,10 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
-			 write, &map_writable))
+	if (try_async_pf(kpf))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, kpf->pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
@@ -3728,25 +3726,26 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
+	if (!is_noslot_pfn(kpf->pfn) &&
+	    mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, kpf->hva))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 
 	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
-		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
-				    pfn, prefault);
+		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, kpf->map_writable,
+				    max_level, kpf->pfn, prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-				 prefault, is_tdp);
+		r = __direct_map(vcpu, gpa, error_code, kpf->map_writable,
+				 max_level, kpf->pfn, prefault, is_tdp);
 
 out_unlock:
 	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_clean(kpf->pfn);
 	return r;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index dc814463a8df..f2beb7f7c378 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -795,14 +795,12 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	gpa_t addr = kpf->cr2_or_gpa;
 	u32 error_code = kpf->error_code;
 	bool prefault = kpf->prefault;
-	bool write_fault = error_code & PFERR_WRITE_MASK;
+	bool write_fault = kpf->write_fault;
 	bool user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
 	int r;
-	kvm_pfn_t pfn;
-	hva_t hva;
 	unsigned long mmu_seq;
-	bool map_writable, is_self_change_mapping;
+	bool is_self_change_mapping;
 	int max_level;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
@@ -851,11 +849,11 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
-			 write_fault, &map_writable))
+	kpf->gfn = walker.gfn;
+	if (try_async_pf(kpf))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
+	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, kpf->pfn, walker.pte_access, &r))
 		return r;
 
 	/*
@@ -864,7 +862,7 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	 */
 	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
 	     !is_write_protection(vcpu) && !user_fault &&
-	      !is_noslot_pfn(pfn)) {
+	      !is_noslot_pfn(kpf->pfn)) {
 		walker.pte_access |= ACC_WRITE_MASK;
 		walker.pte_access &= ~ACC_USER_MASK;
 
@@ -880,20 +878,21 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
+	if (!is_noslot_pfn(kpf->pfn) &&
+	    mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, kpf->hva))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn,
-			 map_writable, prefault);
+	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, kpf->pfn,
+			 kpf->map_writable, prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_clean(kpf->pfn);
 	return r;
 }
 
-- 
2.25.1

