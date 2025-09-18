Return-Path: <kvm+bounces-58066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D47B875E6
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D8D26238A3
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFFA31DD98;
	Thu, 18 Sep 2025 23:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PY3ZTpzZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E279F3019A7;
	Thu, 18 Sep 2025 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237790; cv=none; b=nbwmjFaN79sYpwRFw+FAr8yy5IKWXajWsBUGBvaUnTMUaVu9WFmDyMGiNsmxBaMTQVtjgGBEe5T0dgsyXFYCY3fr2ZTHPb1fTnapm+0lPpqRYrV+339qQFecneWlfvcEX7I0tgrN/KXDFeFbWkYY0UGNRDjFzIbibD01TvRmxhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237790; c=relaxed/simple;
	bh=DSr6fTyYuysH9hJwn77BstgQhrTxKWtbcIie9DXpleQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRSpUuo8NZ+PvBOD6tILQVvY4zkCcQ6Gh9sCnsSXv2W9LjOYun8vu/UyMVkrEXpUxzfuF0Y3oHjrocm/OK2HOzyjpD9/TJhcWvck5G4cAG9YL6181nbxrnIvVw+MPhl4YEgeCM3/PPaOeD8aPFPPFrBs3/pNr/r3Df8qU4LpjhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PY3ZTpzZ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237788; x=1789773788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DSr6fTyYuysH9hJwn77BstgQhrTxKWtbcIie9DXpleQ=;
  b=PY3ZTpzZsN2qBuKDR26a8+ITFwFxNiwDGX55GEXD74SBPggWdZU1ZI10
   nJoL50RI+O0l7Ll/p9MR35yW0BjbIYkpvJb30ANQbi4laBbZYZo09UvMm
   prjVFKc4ckHKiXEGRH/XNAaKyBcCFMWDM0r+FhmsUEK+u2I6SfkCy4eBR
   enB4z0zmuQHLEg9OdpRFCSQB97sgGrXmuAF9jOo6Qx0hMjwsZpuieaQXm
   yTl/4NxB5LSQpot65FP48FDH8Lq4RRFrcKeC6jqJ9By3Ot3onYbtd5NdE
   bce6gPEDS6YlLtAiAl4Om5LuWrLleE2DvLZCsTZKg81fSC0LR8/U1bF57
   g==;
X-CSE-ConnectionGUID: 86wuHAzSSa+t2N1xVYjIfw==
X-CSE-MsgGUID: X8IUTTGgTpKzpbOkA2DDiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735441"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735441"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:05 -0700
X-CSE-ConnectionGUID: 3ocJ6AEqT3+mj8vbtQABVQ==
X-CSE-MsgGUID: Jx7JCgMjQhSn/ZwJvgf1bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491442"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:04 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kas@kernel.org,
	bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	vannapurve@google.com
Cc: rick.p.edgecombe@intel.com
Subject: [PATCH v3 11/16] KVM: TDX: Add x86 ops for external spt cache
Date: Thu, 18 Sep 2025 16:22:19 -0700
Message-ID: <20250918232224.2202592-12-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Move mmu_external_spt_cache behind x86 ops.

In the mirror/external MMU concept, the KVM MMU manages a non-active EPT
tree for private memory (the mirror). The actual active EPT tree the
private memory is protected inside the TDX module. Whenever the mirror EPT
is changed, it needs to call out into one of a set of x86 opts that
implement various update operation with TDX specific SEAMCALLs and other
tricks. These implementations operate on the TDX S-EPT (the external).

In reality these external operations are designed narrowly with respect to
TDX particulars. On the surface, what TDX specific things are happening to
fulfill these update operations are mostly hidden from the MMU, but there
is one particular area of interest where some details leak through.

The S-EPT needs pages to use for the S-EPT page tables. These page tables
need to be allocated before taking the mmu lock, like all the rest. So the
KVM MMU pre-allocates pages for TDX to use for the S-EPT in the same place
where it pre-allocates the other page tables. It’s not too bad and fits
nicely with the others.

However, Dynamic PAMT will need even more pages for the same operations.
Further, these pages will need to be handed to the arch/86 side which used
them for DPAMT updates, which is hard for the existing KVM based cache.
The details living in core MMU code start to add up.

So in preparation to make it more complicated, move the external page
table cache into TDX code by putting it behind some x86 ops. Have one for
topping up and one for allocation. Don’t go so far to try to hide the
existence of external page tables completely from the generic MMU, as they
are currently stores in their mirror struct kvm_mmu_page and it’s quite
handy.

To plumb the memory cache operations through tdx.c, export some of
the functions temporarily. This will be removed in future changes.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - New patch
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    | 11 ++++++-----
 arch/x86/kvm/mmu/mmu.c             |  4 +---
 arch/x86/kvm/mmu/mmu_internal.h    |  2 +-
 arch/x86/kvm/vmx/tdx.c             | 17 +++++++++++++++++
 arch/x86/kvm/vmx/tdx.h             |  2 ++
 virt/kvm/kvm_main.c                |  2 ++
 7 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 62c3e4de3303..a4e4c1333224 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,6 +98,8 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP_OPTIONAL(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(alloc_external_fault_cache)
+KVM_X86_OP_OPTIONAL(topup_external_fault_cache)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cb86f3cca3e9..e4cf0f40c757 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -855,11 +855,6 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
-	/*
-	 * This cache is to allocate external page table. E.g. private EPT used
-	 * by the TDX module.
-	 */
-	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
@@ -1856,6 +1851,12 @@ struct kvm_x86_ops {
 	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				    kvm_pfn_t pfn_for_gfn);
 
+	/* Allocation a pages from the external page cache. */
+	void *(*alloc_external_fault_cache)(struct kvm_vcpu *vcpu);
+
+	/* Top up extra pages needed for faulting in external page tables. */
+	int (*topup_external_fault_cache)(struct kvm_vcpu *vcpu);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 55335dbd70ce..b3feaee893b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -601,8 +601,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 	if (kvm_has_mirrored_tdp(vcpu->kvm)) {
-		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_external_spt_cache,
-					       PT64_ROOT_MAX_LEVEL);
+		r = kvm_x86_call(topup_external_fault_cache)(vcpu);
 		if (r)
 			return r;
 	}
@@ -625,7 +624,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ed5c01df21ba..1fa94ab100be 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -175,7 +175,7 @@ static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_
 	 * Therefore, KVM does not need to initialize or access external_spt.
 	 * KVM only interacts with sp->spt for private EPT operations.
 	 */
-	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
+	sp->external_spt = kvm_x86_call(alloc_external_fault_cache)(vcpu);
 }
 
 static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mmu_page *root)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dd2be7bedd48..6c9e11be9705 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1590,6 +1590,21 @@ static void tdx_unpin(struct kvm *kvm, struct page *page)
 	put_page(page);
 }
 
+static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	return kvm_mmu_memory_cache_alloc(&tdx->mmu_external_spt_cache);
+}
+
+static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache,
+					  PT64_ROOT_MAX_LEVEL);
+}
+
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 			    enum pg_level level, struct page *page)
 {
@@ -3647,4 +3662,6 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
 	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
+	vt_x86_ops.topup_external_fault_cache = tdx_topup_external_fault_cache;
+	vt_x86_ops.alloc_external_fault_cache = tdx_alloc_external_fault_cache;
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index f4e609a745ee..cd7993ef056e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -70,6 +70,8 @@ struct vcpu_tdx {
 
 	u64 map_gpa_next;
 	u64 map_gpa_end;
+
+	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 };
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fee108988028..f05e6d43184b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -404,6 +404,7 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
 	return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_topup_memory_cache);
 
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
@@ -436,6 +437,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	BUG_ON(!p);
 	return p;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
 #endif
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
-- 
2.51.0


