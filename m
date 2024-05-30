Return-Path: <kvm+bounces-18440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 096358D542F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1BCC1F2148D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF2F183095;
	Thu, 30 May 2024 21:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yg7oohMj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E41145B3C;
	Thu, 30 May 2024 21:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103254; cv=none; b=FRKYELPl1a8InQCfIz7k99LSIlihdrFuZof0g5sKHa0UnM1ckmGVC5LbcEMy40Al4OOzMjFNm6a/BPXX1GFGGm7jcUw/myjd49dSYjKUoHudTOxrvIomvL6D1OeCCsxJlzU4w9MMo0hjhKO/gjimFcC1Ja7mhCgEyIV65GMcKcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103254; c=relaxed/simple;
	bh=7U0SzC+0VJbZW7G9Hw/9CPBMuT+xf2n/PYTatFosYQo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qg8GLbAcg4M/ER3QQ+iBfJxsrCNq7ybGlBcznKmLaoqOYYwU8gIfKT4yAfEAzKyftWkHZAvtRxm6PttIJX2h4Xo3py0BTfIRYaj55WzlkLvNtBvNJESlAEeADn/VE5+0dOVrpcXs/IDdCONHEUkzou86Ykg2YfJhaDEUjfSjM0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yg7oohMj; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103253; x=1748639253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7U0SzC+0VJbZW7G9Hw/9CPBMuT+xf2n/PYTatFosYQo=;
  b=Yg7oohMjGnEONpQkavtmyk7F7jKOY0kzLyWYKwX3Vfw2ZcfgkRsk6GVG
   /VzWFLq2MVfK3ODwNJGU+jsmQaxUumoww9f+3tx4TrWoYwFzZck+aePFr
   Yp+5ubx9CMEvTlqrzqmcmgronkoBA8K6repTpazY187+UFtLT46Ss8sfs
   uCKIQtM0e4f7vo0q/tljhd0KEemG5RP+Kk7c85kb2z/IQ6GyUmc7TIB5b
   8z7j0QH4sTjtcFdgkWkvL+ZgODvviaplq6SK9nNivd2ksSujPBdpKrFi6
   xrl/mtbcE7yRkbi1gBHEmOTeEOFInMUgEYOTFBbZ0B6+7TuWFNKR4C2Rf
   Q==;
X-CSE-ConnectionGUID: cRHm4LRaTcWtlztTjbnx0g==
X-CSE-MsgGUID: +/oqGSJAQM+PxUh2Ayaaow==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117091"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117091"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:31 -0700
X-CSE-ConnectionGUID: HjfSbgAKTlKrvoZQWTftRQ==
X-CSE-MsgGUID: 2n+f8llPTAevYsNHkzn44A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874409"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:31 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v2 03/15] KVM: x86/mmu: Add a mirrored pointer to struct kvm_mmu_page
Date: Thu, 30 May 2024 14:07:02 -0700
Message-Id: <20240530210714.364118-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a mirrored pointer to struct kvm_mmu_page for the private page table and
add helper functions to allocate/initialize/free a private page table page.
Because KVM TDP MMU doesn't use unsync_children and write_flooding_count,
pack them to have room for a pointer and use a union to avoid memory
overhead.

For private GPA, CPU refers to a private page table whose contents are
encrypted. The dedicated APIs to operate on it (e.g. updating/reading its
PTE entry) are used, and their cost is expensive.

When KVM resolves the KVM page fault, it walks the page tables. To reuse
the existing KVM MMU code and mitigate the heavy cost of directly walking
the private page table, allocate one more page for the mirrored page table
for the KVM MMU code to directly walk. Resolve the KVM page fault with
the existing code, and do additional operations necessary for the private
page table. To distinguish such cases, the existing KVM page table is
called a shared page table (i.e., not associated with a private page
table), and the page table with a private page table is called a mirrored
page table. The relationship is depicted below.

              KVM page fault                     |
                     |                           |
                     V                           |
        -------------+----------                 |
        |                      |                 |
        V                      V                 |
     shared GPA           private GPA            |
        |                      |                 |
        V                      V                 |
    shared PT root      mirror PT root           |    private PT root
        |                      |                 |           |
        V                      V                 |           V
     shared PT           mirror PT     --propagate-->  private/mirrored PT
        |                      |                 |           |
        |                      \-----------------+------\    |
        |                                        |      |    |
        V                                        |      V    V
  shared guest page                              |    private guest page
                                                 |
                           non-encrypted memory  |    encrypted memory
                                                 |
PT: Page table
Shared PT: visible to KVM, and the CPU uses it for shared mappings.
Private/mirrored PT: the CPU uses it, but it is invisible to KVM.  TDX
                     module updates this table to map private guest pages.
Mirror PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
             to propagate PT change to the actual private PT.

Add a helper kvm_has_mirrored_tdp() to trigger this behavior and wire it
to the TDX vm type.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX MMU Prep v2:
 - Rename private->mirror
 - Don't trigger off of shared mask

TDX MMU Prep:
- Rename terminology, dummy PT => mirror PT. and updated the commit message
  By Rick and Kai.
- Added a comment on union of private_spt by Rick.
- Don't handle the root case in kvm_mmu_alloc_private_spt(), it will not
  be needed in future patches. (Rick)
- Update comments (Yan)
- Remove kvm_mmu_init_private_spt(), open code it in later patches (Yan)

v19:
- typo in the comment in kvm_mmu_alloc_private_spt()
- drop CONFIG_KVM_MMU_PRIVATE
---
 arch/x86/include/asm/kvm_host.h |  5 ++++
 arch/x86/kvm/mmu.h              |  5 ++++
 arch/x86/kvm/mmu/mmu.c          |  7 +++++
 arch/x86/kvm/mmu/mmu_internal.h | 47 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
 5 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aabf1648a56a..250899a0239b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -817,6 +817,11 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	/*
+	 * This cache is to allocate private page table. E.g. private EPT used
+	 * by the TDX module.
+	 */
+	struct kvm_mmu_memory_cache mmu_mirrored_spt_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index dc80e72e4848..0c3bf89cf7db 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -318,4 +318,9 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 		return gpa;
 	return translate_nested_gpa(vcpu, gpa, access, exception);
 }
+
+static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b97241945596..5070ba7c6e89 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -685,6 +685,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
+	if (kvm_has_mirrored_tdp(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_mirrored_spt_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
 	if (r)
@@ -704,6 +710,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_mirrored_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 706f0ce8784c..faef40a561f9 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -101,7 +101,22 @@ struct kvm_mmu_page {
 		int root_count;
 		refcount_t tdp_mmu_root_count;
 	};
-	unsigned int unsync_children;
+	union {
+		/* Those two members aren't used for TDP MMU */
+		struct {
+			unsigned int unsync_children;
+			/*
+			 * Number of writes since the last time traversal
+			 * visited this page.
+			 */
+			atomic_t write_flooding_count;
+		};
+		/*
+		 * Page table page of private PT.
+		 * Passed to TDX module, not accessed by KVM.
+		 */
+		void *mirrored_spt;
+	};
 	union {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 		tdp_ptep_t ptep;
@@ -124,9 +139,6 @@ struct kvm_mmu_page {
 	int clear_spte_count;
 #endif
 
-	/* Number of writes since the last time traversal visited this page.  */
-	atomic_t write_flooding_count;
-
 #ifdef CONFIG_X86_64
 	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
@@ -145,6 +157,33 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline void *kvm_mmu_mirrored_spt(struct kvm_mmu_page *sp)
+{
+	return sp->mirrored_spt;
+}
+
+static inline void kvm_mmu_alloc_mirrored_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	/*
+	 * mirrored_spt is allocated for TDX module to hold private EPT mappings,
+	 * TDX module will initialize the page by itself.
+	 * Therefore, KVM does not need to initialize or access mirrored_spt.
+	 * KVM only interacts with sp->spt for mirrored EPT operations.
+	 */
+	sp->mirrored_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_mirrored_spt_cache);
+}
+
+static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	/*
+	 * private_spt is allocated for TDX module to hold private EPT mappings,
+	 * TDX module will initialize the page by itself.
+	 * Therefore, KVM does not need to initialize or access private_spt.
+	 * KVM only interacts with sp->spt for mirrored EPT operations.
+	 */
+	sp->mirrored_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_mirrored_spt_cache);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1259dd63defc..e7cd4921afe7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,6 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	free_page((unsigned long)sp->mirrored_spt);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
-- 
2.34.1


