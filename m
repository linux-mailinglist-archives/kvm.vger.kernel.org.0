Return-Path: <kvm+bounces-3249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A838801C04
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30138B20F34
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78770156C8;
	Sat,  2 Dec 2023 10:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ejFyGcms"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9E1E3;
	Sat,  2 Dec 2023 02:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511250; x=1733047250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=cQ/PBVpj7VdBPsR5uXHKk49rWc/LsdPwooGhW6lyHNs=;
  b=ejFyGcmsSgnKkdEkzBy7J5CqQhofODqM52qRnWmpWtRTqLicvdusE/UL
   OGXkJyfGkuBRjQotDagPyCcjsXZxx6/FiRkB0rSO/6MAeRtDHqvAi7CaX
   u6EZhrOgRE1i8aaC0DkDEfbO/mWPwzh+OD/CmmYHBi5yf6H/7ZJYfMLAK
   nikAnxovFRhpSR+Bf3eCDMUs0PfjgDT7jgzNcKo55qfvZMOPTGeQce25k
   e+rhcVZW4Iexa8TOS4m24XMbgLm/Zkps8XhUa2J8yKCaTo0VzajTKdAND
   mYCNP2oC/o98MXvEizEk7wctaopMgLXPoAMiEB3NKdy5M86zEkZuK91bq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="372983418"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="372983418"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:00:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="773709825"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="773709825"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:00:46 -0800
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
Subject: [RFC PATCH 33/42] KVM: x86/mmu: add extra param "kvm" to make_spte()
Date: Sat,  2 Dec 2023 17:31:46 +0800
Message-Id: <20231202093146.15477-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add an extra param "kvm" to make_spte() to allow param "vcpu" to be NULL in
future to allow generating spte in non-vcpu context.

"vcpu" is only used in make_spte() to get memory type mask if
shadow_memtype_mask is true, which applies only to VMX when EPT is enabled.
VMX only requires param "vcpu" when non-coherent DMA devices are attached
to check vcpu's CR0.CD and guest MTRRs.
So, if non-coherent DMAs are not attached, make_spte() can call
kvm_x86_get_default_mt_mask() to get default memory type for non-vCPU
context.

This is a preparation patch for later KVM MMU to export TDP.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/spte.c        | 18 ++++++++++++------
 arch/x86/kvm/mmu/spte.h        |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c     |  2 +-
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e4cae4ff20770..c9b587b30dae3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2939,7 +2939,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			was_rmapped = 1;
 	}
 
-	wrprot = make_spte(vcpu, &vcpu->arch.mmu->common,
+	wrprot = make_spte(vcpu->kvm, vcpu, &vcpu->arch.mmu->common,
 			   sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
 			   true, host_writable, &spte);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 054d1a203f0ca..fb4767a9e966e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -960,7 +960,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	spte = *sptep;
 	host_writable = spte & shadow_host_writable_mask;
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	make_spte(vcpu, &vcpu->arch.mmu->common, sp, slot, pte_access,
+	make_spte(vcpu->kvm, vcpu, &vcpu->arch.mmu->common, sp, slot, pte_access,
 		  gfn, spte_to_pfn(spte), spte, true, false, host_writable, &spte);
 
 	return mmu_spte_update(sptep, spte);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index daeab3b9eee1e..5e73a679464c0 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -138,7 +138,7 @@ bool spte_has_volatile_bits(u64 spte)
 	return false;
 }
 
-bool make_spte(struct kvm_vcpu *vcpu,
+bool make_spte(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	       struct kvm_mmu_common *mmu_common, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
@@ -179,7 +179,7 @@ bool make_spte(struct kvm_vcpu *vcpu,
 	 * just to optimize a mode that is anything but performance critical.
 	 */
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
-	    is_nx_huge_page_enabled(vcpu->kvm)) {
+	    is_nx_huge_page_enabled(kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
 	}
 
@@ -194,9 +194,15 @@ bool make_spte(struct kvm_vcpu *vcpu,
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 
-	if (shadow_memtype_mask)
-		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
+	if (shadow_memtype_mask) {
+		if (vcpu)
+			spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
 							 kvm_is_mmio_pfn(pfn));
+		else
+			spte |= static_call(kvm_x86_get_default_mt_mask)(kvm,
+							kvm_is_mmio_pfn(pfn));
+	}
+
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
 	else
@@ -225,7 +231,7 @@ bool make_spte(struct kvm_vcpu *vcpu,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
+		if (mmu_try_to_unsync_pages(kvm, slot, gfn, can_unsync, prefetch)) {
 			wrprot = true;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
@@ -246,7 +252,7 @@ bool make_spte(struct kvm_vcpu *vcpu,
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON_ONCE(level > PG_LEVEL_4K);
-		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
+		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
 
 	*new_spte = spte;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 4ad19c469bd73..f1532589b7083 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -530,7 +530,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 
 bool spte_has_volatile_bits(u64 spte);
 
-bool make_spte(struct kvm_vcpu *vcpu,
+bool make_spte(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	       struct kvm_mmu_common *mmu_common, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 892cf1f5b57a8..a45d1b71cd62a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -964,7 +964,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu->kvm, vcpu, iter->gfn, ACC_ALL);
 	else
-		wrprot = make_spte(vcpu, &vcpu->arch.mmu->common, sp, fault->slot,
+		wrprot = make_spte(vcpu->kvm, vcpu, &vcpu->arch.mmu->common, sp, fault->slot,
 				   ACC_ALL, iter->gfn, fault->pfn, iter->old_spte,
 				   fault->prefetch, true, fault->map_writable,
 				   &new_spte);
-- 
2.17.1


