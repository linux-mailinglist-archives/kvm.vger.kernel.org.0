Return-Path: <kvm+bounces-20031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EFFC90F92B
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A67C41C21C11
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF9915FA96;
	Wed, 19 Jun 2024 22:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1JMdO69"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E34E1741D3;
	Wed, 19 Jun 2024 22:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836596; cv=none; b=u4zRspcOzpmHoYimta8qbJJAHhSuMElkxrwi4EJes/YYep7DeC88jeR01MWXaPFSlP0PYxu79NKChxAhsfCT4LHCOHFQG08Uu61rSRH67p0o04ljPtFKVQG/OJ4ekH42rmpe9pnmi1usuE7liIK7kRLMY+mBTatxky1VxkMedGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836596; c=relaxed/simple;
	bh=TetSbo2yV/unLujQkPcUQDzegmU+VGwsRxY7S/o/XrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z85odlG64Nh/1uM02pacyiZ6s+0EpNo3oR5Nx31bKAvS3XeV1EJPKFOz5FbnkFejE0re0HQ+pDRRAuA1p+CpxZgT0Mgg5q+z3MHuj60JpylaI9/pQ9mEZwWjJFBx51XlxOIwi9lKXBd48mIETHm+78ED6glIO+RVAECnpirCSXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1JMdO69; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836594; x=1750372594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TetSbo2yV/unLujQkPcUQDzegmU+VGwsRxY7S/o/XrQ=;
  b=V1JMdO69wiVR3rGoiIO+JiY8no3Xs+338alnrL1e6kSI5IK3rnZdK6jM
   ZEKp6lMDosPMogSykonMycyRt6MPw5o+NGOs/hoyMom0TLOvcgxXJZvpY
   v1EZ9FZlbiDkI6+9eLdX6rhz0dlojmMxBp+uvC1n0rmZ/i+iTeedrdqme
   awfzlV5c0age1965/cud7aYXT/mfXX1t8PcJYA0VB9sBgMP/ukNdIdEDn
   EYUgHL67otQPx0TSSe8+iaCeLCxrCxaxtYvtG2d9B/9yc5fyQ55k7f/r2
   rRf2igFZO8ACUpf1cfVPE3Yw13TfHmnC6hdE11nTKVcOmOa9XhyTzNkoj
   A==;
X-CSE-ConnectionGUID: qw2hZ6ZMQGeIRWlgnPGIJA==
X-CSE-MsgGUID: legjCEB5Q/i7nAsOT9BYCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931996"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931996"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:24 -0700
X-CSE-ConnectionGUID: T7053+CGT0S4tK6va8idFw==
X-CSE-MsgGUID: K56O8va4QSKkrlz99PGolA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793373"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:24 -0700
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
Subject: [PATCH v3 15/17] KVM: x86/tdp_mmu: Propagate building mirror page tables
Date: Wed, 19 Jun 2024 15:36:12 -0700
Message-Id: <20240619223614.290657-16-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
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
mapping. Now add plumbing to propagate changes to the "external" page
tables being mirrored. Just create the x86_ops for now, leave plumbing the
operations into the TDX module for future patches.

Add two operations for setting up external page tables, one for linking
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
that happens inside the external operations (S-EPT updates via TDX module
call) can't happen atomically with the mirror update. The following race
could result during two vCPU's populating private memory:

* vcpu 1: atomically update 2M level mirror EPT entry to be present
* vcpu 2: read 2M level EPT entry that is present
* vcpu 2: walk down into 4K level EPT
* vcpu 2: atomically update 4K level mirror EPT entry to be present
* vcpu 2: set_exterma;_spte() to update 4K secure EPT entry => error
          because 2M secure EPT entry is not populated yet
* vcpu 1: link_external_spt() to update 2M secure EPT entry

Prevent this by setting the mirror PTE to FROZEN_SPTE while the reflect
operations are performed. Only write the actual mirror PTE value once the
reflect operations has completed. When trying to set a PTE to present and
encountering a removed SPTE, retry the fault.

By doing this the race is prevented as follows:
* vcpu 1: atomically update 2M level EPT entry to be FROZEN_SPTE
* vcpu 2: read 2M level EPT entry that is FROZEN_SPTE
* vcpu 2: find that the EPT entry is frozen
          abandon page table walk to resume guest execution
* vcpu 1: link_external_spt() to update 2M secure EPT entry
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
TDX MMU Prep v3:
 - Rename mirrored->external (Paolo)
 - Better comment on logic that bugs if doing tdp_mmu_set_spte() on
   present PTE. (Paolo)
 - Move zapping KVM_BUG_ON() to proper patch
 - Use spte_to_child_sp() (Paolo)
 - Drop unnessary comment in __tdp_mmu_set_spte_atomic() (Paolo)
 - Rename pfn->pfn_for_gfn to match remove_external_pte in next patch.
 - Rename REMOVED_SPTE to FROZEN_SPTE (Paolo)

TDX MMU Prep v2:
 - Split from "KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU"
 - Rename x86_ops from "private" to "reflect"
 - In response to "sp->mirrored_spt" rename helpers to "mirrored"
 - Drop unused old_pfn and new_pfn in handle_changed_spte()
 - Drop redundant is_shadow_present_pte() check in __tdp_mmu_set_spte_atomic
 - Adjust some warnings and KVM_BUG_ONs
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +
 arch/x86/include/asm/kvm_host.h    |  7 +++
 arch/x86/kvm/mmu/tdp_mmu.c         | 98 ++++++++++++++++++++++++++----
 3 files changed, 94 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 566d19b02483..3ef19fcb5e42 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -95,6 +95,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL(link_external_spt)
+KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d67e88a69fc4..12ff04135a0e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1738,6 +1738,13 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	/* Update external mapping with page table link */
+	int (*link_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *mirrored_spt);
+	/* Update the external page table from spte getting set */
+	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 kvm_pfn_t pfn_for_gfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 582e5a045bb7..bc1ad127046d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -244,7 +244,7 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 	struct kvm_mmu_page *root;
 
 	if (mirror)
-		role.is_mirror = 1;
+		role.is_mirror = true;
 
 	/*
 	 * Check for an existing root before acquiring the pages lock to avoid
@@ -440,6 +440,59 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
+static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
+{
+	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
+		struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
+
+		WARN_ON_ONCE(sp->role.level + 1 != level);
+		WARN_ON_ONCE(sp->gfn != gfn);
+		return sp->external_spt;
+	}
+
+	return NULL;
+}
+
+static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
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
+	lockdep_assert_held(&kvm->mmu_lock);
+	/*
+	 * We need to lock out other updates to the SPTE until the external
+	 * page table has been modified. Use FROZEN_SPTE similar to
+	 * the zapping case.
+	 */
+	if (!try_cmpxchg64(sptep, &old_spte, FROZEN_SPTE))
+		return -EBUSY;
+
+	/*
+	 * Use different call to either set up middle level
+	 * external page table, or leaf.
+	 */
+	if (is_leaf) {
+		ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
+	} else {
+		void *mirrored_spt = get_external_spt(gfn, new_spte, level);
+
+		KVM_BUG_ON(!mirrored_spt, kvm);
+		ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, mirrored_spt);
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
@@ -548,7 +601,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
-static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
+static inline int __tdp_mmu_set_spte_atomic(struct kvm *kvm, struct tdp_iter *iter, u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 
@@ -560,15 +613,25 @@ static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
 	 */
 	WARN_ON_ONCE(iter->yielded || is_frozen_spte(iter->old_spte));
 
-	/*
-	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
-	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
-	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
-	 * the current value, so the caller operates on fresh data, e.g. if it
-	 * retries tdp_mmu_set_spte_atomic()
-	 */
-	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
-		return -EBUSY;
+	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(new_spte)) {
+		int ret;
+
+		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
+						iter->old_spte, new_spte, iter->level);
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
@@ -598,7 +661,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	ret = __tdp_mmu_set_spte_atomic(iter, new_spte);
+	ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
 	if (ret)
 		return ret;
 
@@ -623,7 +686,8 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * Delay processing of the zapped SPTE until after TLBs are flushed and
 	 * the FROZEN_SPTE is replaced (see below).
 	 */
-	ret = __tdp_mmu_set_spte_atomic(iter, FROZEN_SPTE);
+	ret = __tdp_mmu_set_spte_atomic(kvm, iter, FROZEN_SPTE);
+
 	if (ret)
 		return ret;
 
@@ -680,6 +744,14 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
 	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+
+	/*
+	 * Users that do non-atomic setting of PTEs don't operate on mirror
+	 * roots, so don't handle it and bug the VM if it's seen.
+	 */
+	if (is_mirror_sptep(sptep))
+		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
+
 	return old_spte;
 }
 
-- 
2.34.1


