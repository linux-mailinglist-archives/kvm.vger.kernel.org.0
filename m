Return-Path: <kvm+bounces-9691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7076866CF0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D326B25CD9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE98B633FC;
	Mon, 26 Feb 2024 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RbNM9isi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B35612CC;
	Mon, 26 Feb 2024 08:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936108; cv=none; b=BDuoIDci2g2zwIPdb/kaa4SRNay5dhhiPq7W7Jr/iDAwicuJdQykFdvsDxxD72TbxsiJd8R8LF3p5jziDMOGjjjFy7l465JvYks15WN5Z3c8z2evh3He2RUHepZbW8pXdpugNFD/SAJfHseefLAellm08b6SFziZQuNjHpkTaZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936108; c=relaxed/simple;
	bh=aLZoC63A3uu0TZNttub3PZIIePoiXtGMeP+dT2lN9PE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xc9fiwhRMVTyfcBKscGA4tgN8wQJ9J3ySAdq0U4sHICTooknKLEDmReGshIN/gx4ZV4Ieu+RCjHJJHDmZUhsB+6OSJ4j04S0OFZUB5cphOq2CnRQ3nuMfhh0bWJOoBfLCzFlw0+GONrQHwOZeh4YmrzaLn5I1KqZZG+Tw7YOJ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RbNM9isi; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936105; x=1740472105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aLZoC63A3uu0TZNttub3PZIIePoiXtGMeP+dT2lN9PE=;
  b=RbNM9isiXMcluXj+h8EpIKzSpkXgKnEExoJP6KCpiMiEheYGplTO3p0I
   Q4xircZP2rgYBUmJGILfaRg2Z8nf9MbSN6vs4DUwWcoihE9g+QJP7ViAL
   TPcD2gJcxitXFDnNMATzImAfHI9eqwjwS4uRF6Q5xg+AqGtIhCK+JJMsU
   zbDY7NOMybPOe3+LETwZNDVZLFgdR7egwjhop9oh9Yv0rv6SEnsBY5v1A
   RKsl+uGB5Kl6shjrNib3heRCNQ3q22irnwSs2EOF/GKiQFUydzMGDAfjQ
   xxHNmI8m+Yqul6SikR5c0D00mX0MFUtSb1ClY6puY5n/rCP4cJvAEoU6n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155455"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155455"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615922"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:19 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
Date: Mon, 26 Feb 2024 00:26:04 -0800
Message-Id: <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Allocate protected page table for private page table, and add hooks to
operate on protected page table.  This patch adds allocation/free of
protected page tables and hooks.  When calling hooks to update SPTE entry,
freeze the entry, call hooks and unfreeze the entry to allow concurrent
updates on page tables.  Which is the advantage of TDP MMU.  As
kvm_gfn_shared_mask() returns false always, those hooks aren't called yet
with this patch.

When the faulting GPA is private, the KVM fault is called private.  When
resolving private KVM fault, allocate protected page table and call hooks
to operate on protected page table. On the change of the private PTE entry,
invoke kvm_x86_ops hook in __handle_changed_spte() to propagate the change
to protected page table. The following depicts the relationship.

  private KVM page fault   |
      |                    |
      V                    |
 private GPA               |     CPU protected EPTP
      |                    |           |
      V                    |           V
 private PT root           |     protected PT root
      |                    |           |
      V                    |           V
   private PT --hook to propagate-->protected PT
      |                    |           |
      \--------------------+------\    |
                           |      |    |
                           |      V    V
                           |    private guest page
                           |
                           |
     non-encrypted memory  |    encrypted memory
                           |
PT: page table

The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
the EPT entry, atomically set the entry.  However, it requires TLB
shootdown to zap SPTE.  To address it, the entry is frozen with the special
SPTE value that clears the present bit. After the TLB shootdown, the entry
is set to the eventual value (unfreeze).

For protected page table, hooks are called to update protected page table
in addition to direct access to the private SPTE. For the zapping case, it
works to freeze the SPTE. It can call hooks in addition to TLB shootdown.
For populating the private SPTE entry, there can be a race condition
without further protection

  vcpu 1: populating 2M private SPTE
  vcpu 2: populating 4K private SPTE
  vcpu 2: TDX SEAMCALL to update 4K protected SPTE => error
  vcpu 1: TDX SEAMCALL to update 2M protected SPTE

To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
of the private entry, freeze the entry, call the hook that update protected
SPTE, set the entry to the final value.

Support 4K page only at this stage.  2M page support can be done in future
patches.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v19:
- drop CONFIG_KVM_MMU_PRIVATE

v18:
- Rename freezed => frozen

v14 -> v15:
- Refined is_private condition check in kvm_tdp_mmu_map().
  Add kvm_gfn_shared_mask() check.
- catch up for struct kvm_range change

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   5 +
 arch/x86/include/asm/kvm_host.h    |  11 ++
 arch/x86/kvm/mmu/mmu.c             |  17 +-
 arch/x86/kvm/mmu/mmu_internal.h    |  13 +-
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 308 +++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
 virt/kvm/kvm_main.c                |   1 +
 8 files changed, 320 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a8e96804a252..e1c75f8c1b25 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -101,6 +101,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
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
index efd3fda1c177..bc0767c884f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -468,6 +468,7 @@ struct kvm_mmu {
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
 	struct kvm_mmu_root_info root;
+	hpa_t private_root_hpa;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 
@@ -1740,6 +1741,16 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *private_spt);
+	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *private_spt);
+	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 kvm_pfn_t pfn);
+	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				    kvm_pfn_t pfn);
+	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 30c86e858ae4..0e0321ad9ca2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3717,7 +3717,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 
 	if (tdp_mmu_enabled) {
-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+		if (kvm_gfn_shared_mask(vcpu->kvm) &&
+		    !VALID_PAGE(mmu->private_root_hpa)) {
+			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
+			mmu->private_root_hpa = root;
+		}
+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
@@ -4627,7 +4632,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-			gfn_t base = gfn_round_for_level(fault->gfn,
+			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
 							 fault->max_level);
 
 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
@@ -4662,6 +4667,7 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
 	};
 
 	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
+	fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
 	fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 
 	r = mmu_topup_memory_caches(vcpu, false);
@@ -6166,6 +6172,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
+	mmu->private_root_hpa = INVALID_PAGE;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -7211,6 +7218,12 @@ int kvm_mmu_vendor_module_init(void)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
+	if (tdp_mmu_enabled) {
+		write_lock(&vcpu->kvm->mmu_lock);
+		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
+				NULL);
+		write_unlock(&vcpu->kvm->mmu_lock);
+	}
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 002f3f80bf3b..9e2c7c6d85bf 100644
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
@@ -205,6 +207,15 @@ static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
 		free_page((unsigned long)sp->private_spt);
 }
 
+static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
+				     gfn_t gfn)
+{
+	if (is_private_sp(root))
+		return kvm_gfn_to_private(kvm, gfn);
+	else
+		return kvm_gfn_to_shared(kvm, gfn);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
@@ -363,7 +374,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	int r;
 
 	if (vcpu->arch.mmu->root_role.direct) {
-		fault.gfn = fault.addr >> PAGE_SHIFT;
+		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index e1e40e3f5eb7..a9c9cd0db20a 100644
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
index a90907b31c54..1a0e4baa8311 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -187,6 +187,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	sp->role = role;
 
+	if (kvm_mmu_page_role_is_private(role))
+		kvm_mmu_alloc_private_spt(vcpu, sp);
+
 	return sp;
 }
 
@@ -209,7 +212,8 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	trace_kvm_mmu_get_page(sp, true);
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
+						      bool private)
 {
 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm *kvm = vcpu->kvm;
@@ -221,6 +225,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	 * Check for an existing root before allocating a new one.  Note, the
 	 * role check prevents consuming an invalid root.
 	 */
+	if (private)
+		kvm_mmu_page_role_set_private(&role);
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
 		    kvm_tdp_mmu_get_root(root))
@@ -244,12 +250,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 out:
-	return __pa(root->spt);
+	return root;
+}
+
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
+{
+	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared);
 
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -376,12 +387,78 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
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
+		 * Failed to unlink Secure EPT page and there is nothing to do
+		 * further.  Intentionally leak the page to prevent the kernel
+		 * from accessing the encrypted page.
+		 */
+		kvm_mmu_init_private_spt(sp, NULL);
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
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	int ret;
+
+	/* Ignore change of software only bits. e.g. host_writable */
+	if (was_leaf == is_leaf && was_present == is_present)
+		return;
+
+	/*
+	 * Allow only leaf page to be zapped.  Reclaim Non-leaf page tables at
+	 * destroying VM.
+	 */
+	WARN_ON_ONCE(is_present);
+	if (!was_leaf)
+		return;
+
+	/* non-present -> non-present doesn't make sense. */
+	KVM_BUG_ON(!was_present, kvm);
+	KVM_BUG_ON(new_pfn, kvm);
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
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -389,7 +466,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * @gfn: the base GFN that was mapped by the SPTE
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
- * @level: the level of the PT the SPTE is part of in the paging structure
+ * @role: the role of the PT the SPTE is part of in the paging structure
  * @shared: This operation may not be running under the exclusive use of
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be modifying SPTEs.
@@ -399,14 +476,18 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
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
@@ -473,7 +554,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		kvm_set_pfn_dirty(old_pfn);
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -482,14 +563,82 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
+	/*
+	 * Secure-EPT requires to remove Secure-EPT tables after removing
+	 * children.  hooks after handling lower page table by above
+	 * handle_remove_pt().
+	 */
+	if (is_private && !is_present)
+		handle_removed_private_spte(kvm, gfn, old_spte, new_spte, role.level);
 
 	if (was_leaf && is_accessed_spte(old_spte) &&
 	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
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
+	if (is_leaf)
+		ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
+	else {
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
+	 * change into the protected page table.  In order to atomically update
+	 * both the SPTE and the protected page tables with callbacks, utilize
+	 * freezing SPTE.
+	 * - Freeze the SPTE. Set entry to REMOVED_SPTE.
+	 * - Trigger callbacks for protected page tables.
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
 /*
  * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
  * and handle the associated bookkeeping.  Do not mark the page dirty
@@ -512,6 +661,7 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 						       u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
+	bool frozen = false;
 
 	/*
 	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
@@ -523,19 +673,45 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
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
 
-	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    new_spte, iter->level, true);
+		if (is_shadow_present_pte(new_spte)) {
+			/*
+			 * Populating case. handle_changed_spte() can
+			 * process without freezing because it only updates
+			 * stats.
+			 */
+			ret = set_private_spte_present(kvm, iter->sptep, iter->gfn,
+						       iter->old_spte, new_spte, iter->level);
+			if (ret)
+				return ret;
+		} else {
+			/*
+			 * Zapping case. handle_changed_spte() calls Secure-EPT
+			 * blocking or removal.  Freeze the entry.
+			 */
+			if (!try_cmpxchg64(sptep, &iter->old_spte, REMOVED_SPTE))
+				return -EBUSY;
+			frozen = true;
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
 
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    new_spte, sptep_to_sp(sptep)->role, true);
+	if (frozen)
+		__kvm_tdp_mmu_write_spte(sptep, new_spte);
 	return 0;
 }
 
@@ -585,6 +761,8 @@ static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			    u64 old_spte, u64 new_spte, gfn_t gfn, int level)
 {
+	union kvm_mmu_page_role role;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -597,8 +775,17 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	WARN_ON_ONCE(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
+	if (is_private_sptep(sptep) && !is_removed_spte(new_spte) &&
+	    is_shadow_present_pte(new_spte)) {
+		lockdep_assert_held_write(&kvm->mmu_lock);
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
 
@@ -621,8 +808,11 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
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
@@ -784,6 +974,14 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	if (!zap_private && is_private_sp(root))
 		return false;
 
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
@@ -960,10 +1158,26 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+	else {
+		unsigned long pte_access = ACC_ALL;
+		gfn_t gfn = iter->gfn;
+
+		if (kvm_gfn_shared_mask(vcpu->kvm)) {
+			if (fault->is_private)
+				gfn |= kvm_gfn_shared_mask(vcpu->kvm);
+			else
+				/*
+				 * TDX shared GPAs are no executable, enforce
+				 * this for the SDV.
+				 */
+				pte_access &= ~ACC_EXEC_MASK;
+		}
+
+		wrprot = make_spte(vcpu, sp, fault->slot, pte_access, gfn,
+				   fault->pfn, iter->old_spte,
+				   fault->prefetch, true, fault->map_writable,
+				   &new_spte);
+	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1041,6 +1255,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
+	gfn_t raw_gfn;
+	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
 	int ret = RET_PF_RETRY;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1049,7 +1265,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	raw_gfn = gpa_to_gfn(fault->addr);
+
+	if (is_error_noslot_pfn(fault->pfn) ||
+	    !kvm_pfn_to_refcounted_page(fault->pfn)) {
+		if (is_private) {
+			rcu_read_unlock();
+			return -EFAULT;
+		}
+	}
+
+	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1079,9 +1305,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
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
+		} else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
@@ -1362,6 +1593,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mm
 
 	sp->role = role;
 	sp->spt = (void *)__get_free_page(gfp);
+	/* TODO: large page support for private GPA. */
+	WARN_ON_ONCE(kvm_mmu_page_role_is_private(role));
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1378,6 +1611,10 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	struct kvm_mmu_page *sp;
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
+		   is_private_sptep(iter->sptep), kvm);
+	/* TODO: Large page isn't supported for private SPTE yet. */
+	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
@@ -1802,7 +2039,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1829,7 +2066,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
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
index b3cf58a50357..bc9124737142 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d399009ef1d7..e27c22449d85 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -201,6 +201,7 @@ struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_pfn_to_refcounted_page);
 
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
-- 
2.25.1


