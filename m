Return-Path: <kvm+bounces-64039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D84AC76D40
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id F3D283254A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BEC2BE7CD;
	Fri, 21 Nov 2025 00:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Izwj7q3D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C2729BD90;
	Fri, 21 Nov 2025 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686312; cv=none; b=s2cQpe4gK+Vv/Z7a9iw7mV88aPGt939HFR+3NU8oTqMeq58thdb4HNISk32WRSInwNSEnMLwaJdRV6bqFguMzBoDkVKN48XZgFOj4dB4jQi0jSl7yNrBzt1b20pJlBYlzmSNvpVpFsM2Og8PouX3I1ohwCNJR9ShOPXG0J+SxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686312; c=relaxed/simple;
	bh=ELLlKlOkXSqIMdZizc3XTy57t3K+ZF4u7E3bcOZObY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQEgZDCmt4mCvNcVc4i3+xiQecJHPKrDRk9jVkG2q9awZ0DLhmy1LnW1kGeYtnnQqkb+/Y1N8E4oP7Xf9mhT/xIkFP1yKiEe37mxW0+pM+k6dfPEzAvR2I8cg2LhjR0EDM05Na1FqwYxjyd81kqFxJ0pcoGwI3m1q9AmsTA4CK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Izwj7q3D; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686310; x=1795222310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ELLlKlOkXSqIMdZizc3XTy57t3K+ZF4u7E3bcOZObY4=;
  b=Izwj7q3Drwkv0KFSa1BraPXSdxzoVOaMIDAgOZKIloF09PtKBf1gGjEv
   yfbcphrTBfcGrcO3TPPJckPpusH/ODP8h3E4OkYYbQxlMIatFxqo8faSx
   OJ0/ZhxQ1+R9C3LJJ2SZroXAlnGvoXL8ChdyJ2lxTaBcUPqdVAhqnyZ3m
   x7pub1+etOfjochpLfCH26m2ZBOzky4H/AzPhSMlM07uhn4FOIHLfiz80
   WjBrP/Cx5CvsNV+ZaCFJZVKm05kx0zc23SosmTq9575nbqnxGBSdIm2S8
   MzYR0760LmOugemzGKcEonI7embLShLSg7LBjbm/kIQYddlh/O370+WdT
   Q==;
X-CSE-ConnectionGUID: otJilz1jR7qI0brS3/Khpw==
X-CSE-MsgGUID: LqEzyFmMTTOUhUMbSK8caQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780796"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780796"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:45 -0800
X-CSE-ConnectionGUID: dK34Dj9YQUyZdM3pnL7Oig==
X-CSE-MsgGUID: rUHRkon1TsWEJngGKGN/UA==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:45 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com
Subject: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Date: Thu, 20 Nov 2025 16:51:20 -0800
Message-ID: <20251121005125.417831-12-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
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
Further, these pages will need to be handed to the arch/x86 side which used
them for DPAMT updates, which is hard for the existing KVM based cache.
The details living in core MMU code start to add up.

So in preparation to make it more complicated, move the external page
table cache into TDX code by putting it behind some x86 ops. Have one for
topping up and one for allocation. Don’t go so far to try to hide the
existence of external page tables completely from the generic MMU, as they
are currently stored in their mirror struct kvm_mmu_page and it’s quite
handy.

To plumb the memory cache operations through tdx.c, export some of
the functions temporarily. This will be removed in future changes.

Acked-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Add Kiryl ack
 - Log typo (Binbin)
 - Add pages arg to topup_external_fault_cache() (Yan)
 - After more consideration, create free_external_fault_cache()
   as suggest by (Yan)

v3:
 - New patch
---
 arch/x86/include/asm/kvm-x86-ops.h |  3 +++
 arch/x86/include/asm/kvm_host.h    | 14 +++++++++-----
 arch/x86/kvm/mmu/mmu.c             |  6 +++---
 arch/x86/kvm/mmu/mmu_internal.h    |  2 +-
 arch/x86/kvm/vmx/tdx.c             | 24 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h             |  2 ++
 virt/kvm/kvm_main.c                |  3 +++
 7 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..58c5c9b082ca 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,6 +98,9 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP_OPTIONAL(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(alloc_external_fault_cache)
+KVM_X86_OP_OPTIONAL(topup_external_fault_cache)
+KVM_X86_OP_OPTIONAL(free_external_fault_cache)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8d8cc059fed6..dde94b84610c 100644
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
@@ -1856,6 +1851,15 @@ struct kvm_x86_ops {
 	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				     u64 mirror_spte);
 
+	/* Allocation a pages from the external page cache. */
+	void *(*alloc_external_fault_cache)(struct kvm_vcpu *vcpu);
+
+	/* Top up extra pages needed for faulting in external page tables. */
+	int (*topup_external_fault_cache)(struct kvm_vcpu *vcpu, unsigned int cnt);
+
+	/* Free in external page fault cache. */
+	void (*free_external_fault_cache)(struct kvm_vcpu *vcpu);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3cfabfbdd843..3b1b91fd37dd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -601,8 +601,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 	if (kvm_has_mirrored_tdp(vcpu->kvm)) {
-		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_external_spt_cache,
-					       PT64_ROOT_MAX_LEVEL);
+		r = kvm_x86_call(topup_external_fault_cache)(vcpu, PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
 	}
@@ -625,8 +624,9 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	if (kvm_has_mirrored_tdp(vcpu->kvm))
+		kvm_x86_call(free_external_fault_cache)(vcpu);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 73cdcbccc89e..12234ee468ce 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -165,7 +165,7 @@ static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_
 	 * Therefore, KVM does not need to initialize or access external_spt.
 	 * KVM only interacts with sp->spt for private EPT operations.
 	 */
-	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
+	sp->external_spt = kvm_x86_call(alloc_external_fault_cache)(vcpu);
 }
 
 static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mmu_page *root)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b6d7f4b5f40f..260bb0e6eb44 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1642,6 +1642,27 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 	return 0;
 }
 
+static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	return kvm_mmu_memory_cache_alloc(&tdx->mmu_external_spt_cache);
+}
+
+static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu, unsigned int cnt)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache, cnt);
+}
+
+static void tdx_free_external_fault_cache(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	kvm_mmu_free_memory_cache(&tdx->mmu_external_spt_cache);
+}
+
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 			    enum pg_level level, kvm_pfn_t pfn)
 {
@@ -3602,4 +3623,7 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
 	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
+	vt_x86_ops.alloc_external_fault_cache = tdx_alloc_external_fault_cache;
+	vt_x86_ops.topup_external_fault_cache = tdx_topup_external_fault_cache;
+	vt_x86_ops.free_external_fault_cache = tdx_free_external_fault_cache;
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ce2720a028ad..1eefa1b0df5e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -73,6 +73,8 @@ struct vcpu_tdx {
 
 	u64 map_gpa_next;
 	u64 map_gpa_end;
+
+	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 };
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9eca084bdcbe..cff24b950baa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -404,6 +404,7 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
 	return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_topup_memory_cache);
 
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
@@ -424,6 +425,7 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 	mc->objects = NULL;
 	mc->capacity = 0;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_free_memory_cache);
 
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 {
@@ -436,6 +438,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	BUG_ON(!p);
 	return p;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
 #endif
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
-- 
2.51.2


