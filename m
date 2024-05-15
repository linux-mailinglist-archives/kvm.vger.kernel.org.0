Return-Path: <kvm+bounces-17406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7818C5E94
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FBB31F214A8
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4604739ACC;
	Wed, 15 May 2024 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OR6iHeN3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28712B9C4;
	Wed, 15 May 2024 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734813; cv=none; b=SEVEQBg08uT0QgIxWfwTADqIWRrMynMQNZNlHL7d1KWya1sflfu3oQWR5k0D3idwaAa4IfO322WuYADA94iwV0i+9dbPCClVNlOaMHn9ertJt6Je1P+cVNkRKec4Kyq/PKpYwH3vKDOp6czO8tbMfmHissafAOSpBnasg5li8cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734813; c=relaxed/simple;
	bh=Ts0Q7br9qwoNR0tYNUlPsMXwR1VYg0z28EqH1RigXkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s/ReA4XD5LKmE6ThF6OsgnBRDG3siD//d3PlS4EMzcini7aZE1zDjid/1gIcEYGQZKYwfYizCCLfQhRWA5NdyLP4r6lWnptcR5IpuUEhM0dP3xfVF5YRY21jxCHjBtedaUnAtyjND5cNCjL/kAx4D06AjgcQoEl6Ms7KWVu3nDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OR6iHeN3; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734811; x=1747270811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ts0Q7br9qwoNR0tYNUlPsMXwR1VYg0z28EqH1RigXkg=;
  b=OR6iHeN3gP1WEX/VcXP9ABpboyDmJbOZejxPDEALNseXeuDwwVhCILHO
   16rChk3c+HXt6QH5dhLGwN8L+CQ0uC/X39UWPp698YhaXAW0dyulfxgQX
   M20YOCgDG7kIRk83lRm4BFf3XtGiP437J15W/DmX74g1XmfRtFclaoAyU
   mv75byGK202tS4uS6T6vamsfu6jdBN+4W42as7bKWzwIWezZMIKCkx8GU
   2jdq9gC6baSPFClKOaHqVA5xTiEDS/q01Av56oUPUtEUWxwRYywpX6e4l
   hrw3/5HPZn0Fs+PSBTrqcMsxsbzRzlP+mkYFquFJbiLsVXt56SmGJ/qUv
   g==;
X-CSE-ConnectionGUID: E8uWYvgARoCFGu++sO2ANg==
X-CSE-MsgGUID: VBgeHVCbTPCEhJgJLg86Jg==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613973"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613973"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:06 -0700
X-CSE-ConnectionGUID: Ub/KEAqETpSJu78Qo3L98w==
X-CSE-MsgGUID: 2Fpj+nkiQiqzX5Isi6cI8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942788"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:05 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
Date: Tue, 14 May 2024 17:59:46 -0700
Message-Id: <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Allocate mirrored page table for the private page table and implement MMU
hooks to operate on the private page table.

To handle page fault to a private GPA, KVM walks the mirrored page table in
unencrypted memory and then uses MMU hooks in kvm_x86_ops to propagate
changes from the mirrored page table to private page table.

  private KVM page fault   |
      |                    |
      V                    |
 private GPA               |     CPU protected EPTP
      |                    |           |
      V                    |           V
 mirrored PT root          |     private PT root
      |                    |           |
      V                    |           V
   mirrored PT --hook to propagate-->private PT
      |                    |           |
      \--------------------+------\    |
                           |      |    |
                           |      V    V
                           |    private guest page
                           |
                           |
     non-encrypted memory  |    encrypted memory
                           |

PT:         page table
Private PT: the CPU uses it, but it is invisible to KVM. TDX module manages
            this table to map private guest pages.
Mirrored PT:It is visible to KVM, but the CPU doesn't use it. KVM uses it
            to propagate PT change to the actual private PT.

SPTEs in mirrored page table (refer to them as mirrored SPTEs hereafter)
can be modified atomically with mmu_lock held for read, however, the MMU
hooks to private page table are not atomical operations.

To address it, a special REMOVED_SPTE is introduced and below sequence is
used when mirrored SPTEs are updated atomically.

1. Mirrored SPTE is first atomically written to REMOVED_SPTE.
2. The successful updater of the mirrored SPTE in step 1 proceeds with the
   following steps.
3. Invoke MMU hooks to modify private page table with the target value.
4. (a) On hook succeeds, update mirrored SPTE to target value.
   (b) On hook failure, restore mirrored SPTE to original value.

KVM TDP MMU ensures other threads will not overrite REMOVED_SPTE.

This sequence also applies when SPTEs are atomiclly updated from
non-present to present in order to prevent potential conflicts when
multiple vCPUs attempt to set private SPTEs to a different page size
simultaneously, though 4K page size is only supported for private page
table currently.

2M page support can be done in future patches.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - Remove unnecessary gfn, access twist in
   tdp_mmu_map_handle_target_level(). (Chao Gao)
 - Open code call to kvm_mmu_alloc_private_spt() instead oCf doing it in
   tdp_mmu_alloc_sp()
 - Update comment in set_private_spte_present() (Yan)
 - Open code call to kvm_mmu_init_private_spt() (Yan)
 - Add comments on TDX MMU hooks (Yan)
 - Fix various whitespace alignment (Yan)
 - Remove pointless warnings and conditionals in
   handle_removed_private_spte() (Yan)
 - Remove redundant lockdep assert in tdp_mmu_set_spte() (Yan)
 - Remove incorrect comment in handle_changed_spte() (Yan)
 - Remove unneeded kvm_pfn_to_refcounted_page() and
   is_error_noslot_pfn() check in kvm_tdp_mmu_map() (Yan)
 - Do kvm_gfn_for_root() branchless (Rick)
 - Update kvm_tdp_mmu_alloc_root() callers to not check error code (Rick)
 - Add comment for stripping shared bit for fault.gfn (Chao)

v19:
- drop CONFIG_KVM_MMU_PRIVATE

v18:
- Rename freezed => frozen

v14 -> v15:
- Refined is_private condition check in kvm_tdp_mmu_map().
  Add kvm_gfn_shared_mask() check.
- catch up for struct kvm_range change
---
 arch/x86/include/asm/kvm-x86-ops.h |   5 +
 arch/x86/include/asm/kvm_host.h    |  25 +++
 arch/x86/kvm/mmu/mmu.c             |  13 +-
 arch/x86/kvm/mmu/mmu_internal.h    |  19 +-
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 269 +++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
 7 files changed, 293 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 566d19b02483..d13cb4b8fce6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -95,6 +95,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL(link_private_spt)
+KVM_X86_OP_OPTIONAL(free_private_spt)
+KVM_X86_OP_OPTIONAL(set_private_spte)
+KVM_X86_OP_OPTIONAL(remove_private_spte)
+KVM_X86_OP_OPTIONAL(zap_private_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d010ca5c7f44..20fa8fa58692 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -470,6 +470,7 @@ struct kvm_mmu {
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
 	struct kvm_mmu_root_info root;
+	hpa_t private_root_hpa;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 
@@ -1747,6 +1748,30 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	/* Add a page as page table page into private page table */
+	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *private_spt);
+	/*
+	 * Free a page table page of private page table.
+	 * Only expected to be called when guest is not active, specifically
+	 * during VM destruction phase.
+	 */
+	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *private_spt);
+
+	/* Add a guest private page into private page table */
+	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				kvm_pfn_t pfn);
+
+	/* Remove a guest private page from private page table*/
+	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				   kvm_pfn_t pfn);
+	/*
+	 * Keep a guest private page mapped in private page table, but clear its
+	 * present bit
+	 */
+	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76f92cb37a96..2506d6277818 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3701,7 +3701,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	int r;
 
 	if (tdp_mmu_enabled) {
-		kvm_tdp_mmu_alloc_root(vcpu);
+		if (kvm_gfn_shared_mask(vcpu->kvm))
+			kvm_tdp_mmu_alloc_root(vcpu, true);
+		kvm_tdp_mmu_alloc_root(vcpu, false);
 		return 0;
 	}
 
@@ -4685,7 +4687,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-			gfn_t base = gfn_round_for_level(fault->gfn,
+			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
 							 fault->max_level);
 
 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
@@ -6245,6 +6247,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
+	mmu->private_root_hpa = INVALID_PAGE;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -7263,6 +7266,12 @@ int kvm_mmu_vendor_module_init(void)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
+	if (tdp_mmu_enabled) {
+		read_lock(&vcpu->kvm->mmu_lock);
+		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
+				   NULL);
+		read_unlock(&vcpu->kvm->mmu_lock);
+	}
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0f1a9d733d9e..3a7fe9261e23 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,6 +6,8 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
+#include "mmu.h"
+
 #ifdef CONFIG_KVM_PROVE_MMU
 #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
 #else
@@ -178,6 +180,16 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
 	sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
 }
 
+static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
+				     gfn_t gfn)
+{
+	gfn_t gfn_for_root = kvm_gfn_to_private(kvm, gfn);
+
+	/* Set shared bit if not private */
+	gfn_for_root |= -(gfn_t)!is_private_sp(root) & kvm_gfn_shared_mask(kvm);
+	return gfn_for_root;
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
@@ -348,7 +360,12 @@ static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gp
 	int r;
 
 	if (vcpu->arch.mmu->root_role.direct) {
-		fault.gfn = fault.addr >> PAGE_SHIFT;
+		/*
+		 * Things like memslots don't understand the concept of a shared
+		 * bit. Strip it so that the GFN can be used like normal, and the
+		 * fault.addr can be used when the shared bit is needed.
+		 */
+		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..8a64bcef9deb 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -91,7 +91,7 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN mapped by the current SPTE */
+	/* The lowest GFN (shared bits included) mapped by the current SPTE */
 	gfn_t gfn;
 	/* The level of the root page given to the iterator */
 	int root_level;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0d6d96d86703..810d552e9bf6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -224,7 +224,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool private)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
@@ -232,6 +232,9 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
+	if (private)
+		kvm_mmu_page_role_set_private(&role);
+
 	/*
 	 * Check for an existing root before acquiring the pages lock to avoid
 	 * unnecessary serialization if multiple vCPUs are loading a new root.
@@ -283,13 +286,17 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	 * and actually consuming the root if it's invalidated after dropping
 	 * mmu_lock, and the root can't be freed as this vCPU holds a reference.
 	 */
-	mmu->root.hpa = __pa(root->spt);
-	mmu->root.pgd = 0;
+	if (private) {
+		mmu->private_root_hpa = __pa(root->spt);
+	} else {
+		mmu->root.hpa = __pa(root->spt);
+		mmu->root.pgd = 0;
+	}
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared);
 
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -416,12 +423,124 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 							  REMOVED_SPTE, level);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_spte, REMOVED_SPTE, level, shared);
+				    old_spte, REMOVED_SPTE, sp->role,
+				    shared);
+	}
+
+	if (is_private_sp(sp) &&
+	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,
+							  kvm_mmu_private_spt(sp)))) {
+		/*
+		 * Failed to free page table page in private page table and
+		 * there is nothing to do further.
+		 * Intentionally leak the page to prevent the kernel from
+		 * accessing the encrypted page.
+		 */
+		sp->private_spt = NULL;
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
+static void *get_private_spt(gfn_t gfn, u64 new_spte, int level)
+{
+	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
+		struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(spte_to_pfn(new_spte)));
+		void *private_spt = kvm_mmu_private_spt(sp);
+
+		WARN_ON_ONCE(!private_spt);
+		WARN_ON_ONCE(sp->role.level + 1 != level);
+		WARN_ON_ONCE(sp->gfn != gfn);
+		return private_spt;
+	}
+
+	return NULL;
+}
+
+static void handle_removed_private_spte(struct kvm *kvm, gfn_t gfn,
+					u64 old_spte, u64 new_spte,
+					int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	int ret;
+
+	/*
+	 * Allow only leaf page to be zapped. Reclaim non-leaf page tables page
+	 * at destroying VM.
+	 */
+	if (!was_leaf)
+		return;
+
+	/* Zapping leaf spte is allowed only when write lock is held. */
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+	/* Because write lock is held, operation should success. */
+	if (KVM_BUG_ON(ret, kvm))
+		return;
+
+	ret = static_call(kvm_x86_remove_private_spte)(kvm, gfn, level, old_pfn);
+	KVM_BUG_ON(ret, kvm);
+}
+
+static int __must_check __set_private_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
+						   gfn_t gfn, u64 old_spte,
+						   u64 new_spte, int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	int ret = 0;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	/* TDP MMU doesn't change present -> present */
+	KVM_BUG_ON(was_present, kvm);
+
+	/*
+	 * Use different call to either set up middle level
+	 * private page table, or leaf.
+	 */
+	if (is_leaf) {
+		ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
+	} else {
+		void *private_spt = get_private_spt(gfn, new_spte, level);
+
+		KVM_BUG_ON(!private_spt, kvm);
+		ret = static_call(kvm_x86_link_private_spt)(kvm, gfn, level, private_spt);
+	}
+
+	return ret;
+}
+
+static int __must_check set_private_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
+						 gfn_t gfn, u64 old_spte,
+						 u64 new_spte, int level)
+{
+	int ret;
+
+	/*
+	 * For private page table, callbacks are needed to propagate SPTE
+	 * change into the private page table. In order to atomically update
+	 * both the SPTE and the private page tables with callbacks, utilize
+	 * freezing SPTE.
+	 * - Freeze the SPTE. Set entry to REMOVED_SPTE.
+	 * - Trigger callbacks for private page tables.
+	 * - Unfreeze the SPTE.  Set the entry to new_spte.
+	 */
+	lockdep_assert_held(&kvm->mmu_lock);
+	if (!try_cmpxchg64(sptep, &old_spte, REMOVED_SPTE))
+		return -EBUSY;
+
+	ret = __set_private_spte_present(kvm, sptep, gfn, old_spte, new_spte, level);
+	if (ret)
+		__kvm_tdp_mmu_write_spte(sptep, old_spte);
+	else
+		__kvm_tdp_mmu_write_spte(sptep, new_spte);
+	return ret;
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -429,7 +548,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * @gfn: the base GFN that was mapped by the SPTE
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
- * @level: the level of the PT the SPTE is part of in the paging structure
+ * @role: the role of the PT the SPTE is part of in the paging structure
  * @shared: This operation may not be running under the exclusive use of
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be modifying SPTEs.
@@ -439,14 +558,18 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * and fast_pf_fix_direct_spte()).
  */
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared)
 {
+	bool is_private = kvm_mmu_page_role_is_private(role);
+	int level = role.level;
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
-	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	bool pfn_changed = old_pfn != new_pfn;
 
 	WARN_ON_ONCE(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON_ONCE(level < PG_LEVEL_4K);
@@ -513,7 +636,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		kvm_set_pfn_dirty(old_pfn);
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -522,15 +645,21 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 * pages are kernel allocations and should never be migrated.
 	 */
 	if (was_present && !was_leaf &&
-	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
+	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed))) {
+		KVM_BUG_ON(is_private != is_private_sptep(spte_to_child_pt(old_spte, level)),
+			   kvm);
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
+	}
+
+	if (is_private && !is_present)
+		handle_removed_private_spte(kvm, gfn, old_spte, new_spte, role.level);
 
 	if (was_leaf && is_accessed_spte(old_spte) &&
 	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
-static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
+static inline int __tdp_mmu_set_spte_atomic(struct kvm *kvm, struct tdp_iter *iter, u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 
@@ -542,15 +671,42 @@ static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
 	 */
 	WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
 
-	/*
-	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
-	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
-	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
-	 * the current value, so the caller operates on fresh data, e.g. if it
-	 * retries tdp_mmu_set_spte_atomic()
-	 */
-	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
-		return -EBUSY;
+	if (is_private_sptep(iter->sptep) && !is_removed_spte(new_spte)) {
+		int ret;
+
+		if (is_shadow_present_pte(new_spte)) {
+			/*
+			 * Populating case.
+			 * - set_private_spte_present() implements
+			 *   1) Freeze SPTE
+			 *   2) call hooks to update private page table,
+			 *   3) update SPTE to new_spte
+			 * - handle_changed_spte() only updates stats.
+			 */
+			ret = set_private_spte_present(kvm, iter->sptep, iter->gfn,
+						       iter->old_spte, new_spte, iter->level);
+			if (ret)
+				return ret;
+		} else {
+			/*
+			 * Zapping case.
+			 * Zap is only allowed when write lock is held
+			 */
+			if (WARN_ON_ONCE(!is_shadow_present_pte(new_spte)))
+				return -EBUSY;
+		}
+	} else {
+		/*
+		 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs
+		 * and does not hold the mmu_lock.  On failure, i.e. if a
+		 * different logical CPU modified the SPTE, try_cmpxchg64()
+		 * updates iter->old_spte with the current value, so the caller
+		 * operates on fresh data, e.g. if it retries
+		 * tdp_mmu_set_spte_atomic()
+		 */
+		if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
+			return -EBUSY;
+	}
 
 	return 0;
 }
@@ -576,23 +732,24 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					  struct tdp_iter *iter,
 					  u64 new_spte)
 {
+	u64 *sptep = rcu_dereference(iter->sptep);
 	int ret;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	ret = __tdp_mmu_set_spte_atomic(iter, new_spte);
+	ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
 	if (ret)
 		return ret;
 
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    new_spte, iter->level, true);
-
+			    new_spte, sptep_to_sp(sptep)->role, true);
 	return 0;
 }
 
 static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					  struct tdp_iter *iter)
 {
+	union kvm_mmu_page_role role;
 	int ret;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
@@ -605,7 +762,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * Delay processing of the zapped SPTE until after TLBs are flushed and
 	 * the REMOVED_SPTE is replaced (see below).
 	 */
-	ret = __tdp_mmu_set_spte_atomic(iter, REMOVED_SPTE);
+	ret = __tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE);
 	if (ret)
 		return ret;
 
@@ -619,6 +776,8 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 */
 	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
 
+
+	role = sptep_to_sp(iter->sptep)->role;
 	/*
 	 * Process the zapped SPTE after flushing TLBs, and after replacing
 	 * REMOVED_SPTE with 0. This minimizes the amount of time vCPUs are
@@ -626,7 +785,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * SPTEs.
 	 */
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    0, iter->level, true);
+			    SHADOW_NONPRESENT_VALUE, role, true);
 
 	return 0;
 }
@@ -648,6 +807,8 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			    u64 old_spte, u64 new_spte, gfn_t gfn, int level)
 {
+	union kvm_mmu_page_role role;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -660,8 +821,16 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	WARN_ON_ONCE(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
+	if (is_private_sptep(sptep) && !is_removed_spte(new_spte) &&
+	    is_shadow_present_pte(new_spte)) {
+		/* Because write spin lock is held, no race.  It should success. */
+		KVM_BUG_ON(__set_private_spte_present(kvm, sptep, gfn, old_spte,
+						      new_spte, level), kvm);
+	}
 
-	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+	role = sptep_to_sp(sptep)->role;
+	role.level = level;
+	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
 	return old_spte;
 }
 
@@ -684,8 +853,11 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _mmu, _private, _start, _end)	\
+	for_each_tdp_pte(_iter,						\
+		 root_to_sp((_private) ? _mmu->private_root_hpa :	\
+				_mmu->root.hpa),			\
+		_start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -853,6 +1025,14 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	/*
+	 * start and end doesn't have GFN shared bit.  This function zaps
+	 * a region including alias.  Adjust shared bit of [start, end) if the
+	 * root is shared.
+	 */
+	start = kvm_gfn_for_root(kvm, root, start);
+	end = kvm_gfn_for_root(kvm, root, end);
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
@@ -1029,8 +1209,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+					fault->pfn, iter->old_spte, fault->prefetch, true,
+					fault->map_writable, &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1108,6 +1288,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
+	gfn_t raw_gfn;
+	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
 	int ret = RET_PF_RETRY;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1116,7 +1298,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	raw_gfn = gpa_to_gfn(fault->addr);
+
+	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1142,14 +1326,22 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * needs to be split.
 		 */
 		sp = tdp_mmu_alloc_sp(vcpu);
+		if (kvm_is_private_gpa(kvm, raw_gfn << PAGE_SHIFT))
+			kvm_mmu_alloc_private_spt(vcpu, sp);
 		tdp_mmu_init_child_sp(sp, &iter);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte))
+		if (is_shadow_present_pte(iter.old_spte)) {
+			/*
+			 * TODO: large page support.
+			 * Doesn't support large page for TDX now
+			 */
+			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		else
+		} else {
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
+		}
 
 		/*
 		 * Force the guest to retry if installing an upper level SPTE
@@ -1780,7 +1972,7 @@ static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, mmu, is_private, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1838,7 +2030,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	/* fast page fault for private GPA isn't supported. */
+	WARN_ON_ONCE(kvm_is_private_gpa(vcpu->kvm, addr));
+
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 437ddd4937a9..ac350c51bc18 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool private);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.34.1


