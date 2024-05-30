Return-Path: <kvm+bounces-18447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 739B88D543F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A104C1C24ABB
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1BF199EB8;
	Thu, 30 May 2024 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HV0ucpZQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C47186E4F;
	Thu, 30 May 2024 21:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103260; cv=none; b=nYlImJV8Fzl2LB3cdWZYz/hDFw3FR2AjpyYFbp/1sdsIrOAu5fXseLCMwH0x2Qs4ZxJZYavOk0RNGoMvuP3S8kjo5eAgT1whubBZq73CM2cmR03H4CVZ7N2g5nbR12T003F1FD93sw3L0b+bSdCjz3jZA0KTvAWobxbywp3FEYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103260; c=relaxed/simple;
	bh=lkKw5QGwP1xD827L59ruymQNe3fJb4KhZXTVBKZJPoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t32ssnRP5slFc6hiwzjxSYZeLtjbofpTzG1waBCRIQcc1VOOdnnPt2v7NsOSUjQMEyHs4acLRSQZ/+ZUGdxepzO8h8lWW0JO+MYgJ2QJvQZo8x/rxSgY0Tm1MpYY96rH8Ec8YIeWiyoLcfYkZP1cKRPlri3VL+7yulLFD7b1tBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HV0ucpZQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103258; x=1748639258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lkKw5QGwP1xD827L59ruymQNe3fJb4KhZXTVBKZJPoA=;
  b=HV0ucpZQ1pz+hmR1I2TCicHc7pdgjD2xnkZtPeLeC4iRWg0DO1CKvdHC
   WEvQ702Qv5tLml8AfMwLkMY+np84HeDi7nm17UQy7N0D9qfCEgVPkLBvy
   Lj34AOuYmLK2ItxjRTDp8HQKDRV/kIb8gC/zJcmieoeYKk1CHqmAiNUhi
   kiW0L3g1bEt3JeYG+B5/X1VpkhNu5AcJj+IKuTUUD5gvwBxKxQ5lCm4iA
   wu5AI0tmD1+hjl5DDNiKjRdYUnuvJAKnEEZojvuHKag8mQieRwar0m8jc
   vYn2Y+Shb1v36nGKK0Gp8lwGxK44neJw076G2DauMUOaKwpjdE9XCE8F6
   Q==;
X-CSE-ConnectionGUID: vFuIbxORSBavocGjKMO3jw==
X-CSE-MsgGUID: a2x1BOPwQ4+WgL30s9gp8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117130"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117130"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:38 -0700
X-CSE-ConnectionGUID: j0X6frnzRd6+PR+PWy+MFA==
X-CSE-MsgGUID: ePPLKhbjTvSD8KEDpQwzRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874449"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:38 -0700
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
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 10/15] KVM: x86/tdp_mmu: Reflect building mirror page tables
Date: Thu, 30 May 2024 14:07:09 -0700
Message-Id: <20240530210714.364118-11-rick.p.edgecombe@intel.com>
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

Integrate hooks for mirroring page table operations for cases where TDX
will set PTEs or link page tables.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

Since calls into the TDX module are relatively slow, walking private page
tables by making calls into the TDX module would not be efficient. Because
of this, previous changes have taught the TDP MMU to keep a mirror root,
which is separate, unmapped TDP root that private operations can be
directed to. Currently this root is disconnected from any actual guest
mapping. Now add plumbing to "reflect" changes to the mirror to the page
tables being mirrored. Just create the x86_ops for now, leave plumbing the
operations into the TDX module for future patches.

Add two operations for setting up mirrored page tables, one for linking
new page tables and one for setting leaf PTEs. Don't add any op for
configuring the root PFN, as TDX handles this itself. Don't provide a
way to set permissions on the PTEs also, as TDX doesn't support it.

This results is MMU "mirroring" support that is very targeted towards TDX.
Since it is likely there will be no other user, the main benefit of making
the support generic is to keep TDX specific *looking* code outside of the
MMU. As a generic feature it will make enough sense from TDX's
perspective. For developers unfamiliar with TDX arch it can express the
general concepts such that they can continue to work in the code.

TDX MMU support will exclude certain MMU operations, so only plug in the
mirroring x86 ops where they will be needed. For setting/linking, only
hook tdp_mmu_set_spte_atomic() which is use used for mapping and linking
PTs. Don't bother hooking tdp_mmu_iter_set_spte() as it is only used for
setting PTEs in operations unsupported by TDX: splitting huge pages and
write protecting. Sprinkle a KVM_BUG_ON()s to document as code that these
paths are not supported for mirrored page tables. For zapping operations,
leave those for near future changes.

Many operations in the TDP MMU depend on atomicity of the PTE update.
While the mirror PTE on KVM's side can be updated atomically, the update
that happens inside the reflect operations (S-EPT updates via TDX module
call) can't happen atomically with the mirror update. The following race
could result during two vCPU's populating private memory:

* vcpu 1: atomically update 2M level mirror EPT entry to be present
* vcpu 2: read 2M level EPT entry that is present
* vcpu 2: walk down into 4K level EPT
* vcpu 2: atomically update 4K level mirror EPT entry to be present
* vcpu 2: reflect_set_spte() to update 4K secure EPT entry => error
          because 2M secure EPT entry is not populated yet
* vcpu 1: reflect_link_spt() to update 2M secure EPT entry

Prevent this by setting the mirror PTE to REMOVED_SPTE while the reflect
operations are performed. Only write the actual mirror PTE value once the
reflect operations has completed. When trying to set a PTE to present and
encountering a removed SPTE, retry the fault.

By doing this the race is prevented as follows:
* vcpu 1: atomically update 2M level EPT entry to be REMOVED_SPTE (freeze)
* vcpu 2: read 2M level EPT entry that is REMOVED_SPTE
* vcpu 2: find that the EPT entry is frozen
          abandon page table walk to resume guest execution
* vcpu 1: reflect_link_spt() to update 2M secure EPT entry
* vcpu 1: atomically update 2M level EPT entry to be present (unfreeze)
* vcpu 2: resume guest execution
          Depending on vcpu 1 state, vcpu 2 may result in EPT violation
          again or make progress on guest execution

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v2:
 - Split from "KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU"
 - Rename x86_ops from "private" to "reflect"
 - In response to "sp->mirrored_spt" rename helpers to "mirrored"
 - Drop unused old_pfn and new_pfn in handle_changed_spte()
 - Drop redundant is_shadow_present_pte() check in __tdp_mmu_set_spte_atomic
 - Adjust some warnings and KVM_BUG_ONs
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |   7 ++
 arch/x86/kvm/mmu/tdp_mmu.c         | 108 +++++++++++++++++++++++++----
 3 files changed, 105 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 566d19b02483..1877d6a77525 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -95,6 +95,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL(reflect_link_spt)
+KVM_X86_OP_OPTIONAL(reflect_set_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d4446dde0ace..20bb10f22ca6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1748,6 +1748,13 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	/* Update mirrored mapping with page table link */
+	int (*reflect_link_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *mirrored_spt);
+	/* Update the mirrored page table from spte getting set */
+	int (*reflect_set_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				kvm_pfn_t pfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0fc168a3fff1..41b1d3f26597 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -446,6 +446,64 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
+static void *get_mirrored_spt(gfn_t gfn, u64 new_spte, int level)
+{
+	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
+		struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(spte_to_pfn(new_spte)));
+		void *mirrored_spt = kvm_mmu_mirrored_spt(sp);
+
+		WARN_ON_ONCE(sp->role.level + 1 != level);
+		WARN_ON_ONCE(sp->gfn != gfn);
+		return mirrored_spt;
+	}
+
+	return NULL;
+}
+
+static int __must_check reflect_set_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
+						 gfn_t gfn, u64 old_spte,
+						 u64 new_spte, int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	int ret = 0;
+
+	KVM_BUG_ON(was_present, kvm);
+
+	/*
+	 * For mirrored page table, callbacks are needed to propagate SPTE
+	 * change into the mirrored page table. In order to atomically update
+	 * both the SPTE and the mirrored page tables with callbacks, utilize
+	 * freezing SPTE.
+	 * - Freeze the SPTE. Set entry to REMOVED_SPTE.
+	 * - Trigger callbacks for mirrored page tables.
+	 * - Unfreeze the SPTE.  Set the entry to new_spte.
+	 */
+	lockdep_assert_held(&kvm->mmu_lock);
+	if (!try_cmpxchg64(sptep, &old_spte, REMOVED_SPTE))
+		return -EBUSY;
+
+	/*
+	 * Use different call to either set up middle level
+	 * mirrored page table, or leaf.
+	 */
+	if (is_leaf) {
+		ret = static_call(kvm_x86_reflect_set_spte)(kvm, gfn, level, new_pfn);
+	} else {
+		void *mirrored_spt = get_mirrored_spt(gfn, new_spte, level);
+
+		KVM_BUG_ON(!mirrored_spt, kvm);
+		ret = static_call(kvm_x86_reflect_link_spt)(kvm, gfn, level, mirrored_spt);
+	}
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
@@ -559,7 +617,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
-static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
+static inline int __tdp_mmu_set_spte_atomic(struct kvm *kvm, struct tdp_iter *iter, u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 
@@ -571,15 +629,36 @@ static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
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
+	if (is_mirror_sptep(iter->sptep) && !is_removed_spte(new_spte)) {
+		int ret;
+
+		/* Don't support atomic zapping for mirrored roots */
+		if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
+			return -EBUSY;
+		/*
+		 * Populating case.
+		 * - reflect_set_spte_present() implements
+		 *   1) Freeze SPTE
+		 *   2) call hooks to update mirrored page table,
+		 *   3) update SPTE to new_spte
+		 * - handle_changed_spte() only updates stats.
+		 */
+		ret = reflect_set_spte_present(kvm, iter->sptep, iter->gfn,
+					       iter->old_spte, new_spte, iter->level);
+		if (ret)
+			return ret;
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
@@ -610,7 +689,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	ret = __tdp_mmu_set_spte_atomic(iter, new_spte);
+	ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
 	if (ret)
 		return ret;
 
@@ -636,7 +715,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * Delay processing of the zapped SPTE until after TLBs are flushed and
 	 * the REMOVED_SPTE is replaced (see below).
 	 */
-	ret = __tdp_mmu_set_spte_atomic(iter, REMOVED_SPTE);
+	ret = __tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE);
 	if (ret)
 		return ret;
 
@@ -698,6 +777,11 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	role = sptep_to_sp(sptep)->role;
 	role.level = level;
 	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
+
+	/* Don't support setting for the non-atomic case */
+	if (is_mirror_sptep(sptep))
+		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
+
 	return old_spte;
 }
 
-- 
2.34.1


