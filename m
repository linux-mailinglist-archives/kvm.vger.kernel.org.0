Return-Path: <kvm+bounces-3247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21564801C00
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:00:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C130B1F211E0
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1149E1549E;
	Sat,  2 Dec 2023 09:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jt/wD5QU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4A8E3;
	Sat,  2 Dec 2023 01:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511192; x=1733047192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=BB3oVFRCJKuJwn2fpuBKAK+sq6q4cIt28G0VfFVlmdc=;
  b=Jt/wD5QUYehfDm9wIlqvtSpVlHoBtUUDS2RwK9li/6MaqrZlSDOxwGDR
   TqM5Fj2JLGqrURwezVfFS2dveQVyLB30E72MVG1D9v0CjK/jdjDXGaUmx
   xYoa+HUAcDw8O3II53hLYMnDSDoZZ9VcXbKERzOW3ctnMn3HtiZkKdy3T
   IdTnQMq71ggJO5H60Ul92MlGy8dDmLQOWZ1Nl12WkQAQ2ncqWJgfXZIsl
   XjG6gq7cUEVclZrwnDBtptf/zXnnnHnRuHd409voG5PmKH8dd3J6EExUh
   CFGOYSi1+y9TRi6iD4VR5bK5J/a0ib7me+IthXvrwCx1hWunzZJMbwDWE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="424756329"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="424756329"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:59:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="836022446"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="836022446"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:59:48 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 31/42] KVM: x86/mmu: add extra param "kvm" to kvm_faultin_pfn()
Date: Sat,  2 Dec 2023 17:30:49 +0800
Message-Id: <20231202093049.15341-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add an extra param "kvm" to kvm_faultin_pfn() to allow param "vcpu" to be
NULL in future to allow page faults in non-vcpu context.

It is a preparation for later KVM MMU to export TDP.

No-slot mapping (for emulated MMIO cache), async pf, sig pending PFN are
not compatible to page fault in non-vcpu context.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 35 +++++++++++++++++++---------------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bcf17aef29119..df5651ea99139 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3266,9 +3266,10 @@ static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SHIFT, current);
 }
 
-static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_handle_error_pfn(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				struct kvm_page_fault *fault)
 {
-	if (is_sigpending_pfn(fault->pfn)) {
+	if (is_sigpending_pfn(fault->pfn) && vcpu) {
 		kvm_handle_signal_exit(vcpu);
 		return -EINTR;
 	}
@@ -3289,12 +3290,15 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 	return -EFAULT;
 }
 
-static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
+static int kvm_handle_noslot_fault(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault,
 				   unsigned int access)
 {
 	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
+	if (!vcpu)
+		return -EFAULT;
+
 	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
 			     access & shadow_mmio_access_mask);
 
@@ -4260,7 +4264,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
 }
 
-static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int __kvm_faultin_pfn(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			     struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -4275,7 +4280,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	if (!kvm_is_visible_memslot(slot)) {
 		/* Don't expose private memslots to L2. */
-		if (is_guest_mode(vcpu)) {
+		if (vcpu && is_guest_mode(vcpu)) {
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
@@ -4288,7 +4293,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		 * when the AVIC is re-enabled.
 		 */
 		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm))
+		    !kvm_apicv_activated(kvm))
 			return RET_PF_EMULATE;
 	}
 
@@ -4299,7 +4304,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
-	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
+	if (!fault->prefetch && vcpu && kvm_can_do_async_pf(vcpu)) {
 		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
 		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
 			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
@@ -4321,23 +4326,23 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	return RET_PF_CONTINUE;
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			   unsigned int access)
+static int kvm_faultin_pfn(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			   struct kvm_page_fault *fault, unsigned int access)
 {
 	int ret;
 
-	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	fault->mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = __kvm_faultin_pfn(vcpu, fault);
+	ret = __kvm_faultin_pfn(kvm, vcpu, fault);
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
 	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_error_pfn(vcpu, fault);
+		return kvm_handle_error_pfn(kvm, vcpu, fault);
 
 	if (unlikely(!fault->slot))
-		return kvm_handle_noslot_fault(vcpu, fault, access);
+		return kvm_handle_noslot_fault(kvm, vcpu, fault, access);
 
 	return RET_PF_CONTINUE;
 }
@@ -4389,7 +4394,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
+	r = kvm_faultin_pfn(vcpu->kvm, vcpu, fault, ACC_ALL);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
@@ -4469,7 +4474,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
+	r = kvm_faultin_pfn(vcpu->kvm, vcpu, fault, ACC_ALL);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f685b036f6637..054d1a203f0ca 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -812,7 +812,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	r = kvm_faultin_pfn(vcpu, fault, walker.pte_access);
+	r = kvm_faultin_pfn(vcpu->kvm, vcpu, fault, walker.pte_access);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
-- 
2.17.1


