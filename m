Return-Path: <kvm+bounces-21897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3950893530D
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D33B1C21106
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183C014A4E7;
	Thu, 18 Jul 2024 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gNu6sVtC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356351494DF;
	Thu, 18 Jul 2024 21:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337177; cv=none; b=kqaEk16dsTbe4CKpDk5Zup7CpqHsQ5JQ3sLaIXlk2abNbjafWRr0+OcibldkuHY/ic5kgYjFLH5iznhQbQFVJZ14rokElUP38fM6q0c12PcxinZ+8TQlzfplOCTuTPBRHEK8DFcyWMb+ODDPs6FztfcgTQlC0poyBMPgquuTCbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337177; c=relaxed/simple;
	bh=hyeN8N4x/xCECZf6qOEtw7mjw3OZyP3Gt7S/eTIPXpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KPNTqcTmK2/pj9i3Nhs7YOzqU4AI16JZkNxdyiKuRjqQZm+efQFkdtV5509PiEozPcO8cR0VPoE/eTQmxMHaNY88NSfFSqiEsq/zVFBoz/yGpZj2nXHMIjJf8uQiAf8hQW561gUKUaCpM+TiWIV7w/03wbF+zizA/oselUmOSAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gNu6sVtC; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337175; x=1752873175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hyeN8N4x/xCECZf6qOEtw7mjw3OZyP3Gt7S/eTIPXpY=;
  b=gNu6sVtCzxxitCDsvAx0n9fkwplaPTl9/gjfEbiV/yixW2Bg27audsYI
   hI5eyQ6tfUM+sfRUqKAvJXCy1hAvcJ1dcIZZfvLkrl754B0uT/cmdemMF
   a4JP/SIkqSOvwoMv9Vi55E4ZV99/rNZq8DJcYvYQRiJ7/NUr8iCth8y5C
   KmxFTbO9t7tKej29TTaNj6fe0IoFjkQnvTHSvISCMJl2iW6bjgxKkBa4M
   /amcyF1W8nWff3psnzIQuU3I4ooJtl2I+7B012zH6eQ7xH8d7tZYza1Z6
   GKnIvkXlvQjQPLFt8kD64is4g1OHrSJ2qGRq15IEycSZEoh/1Ih15mzBL
   w==;
X-CSE-ConnectionGUID: 93qykgmYQRqBIMoRovIgOg==
X-CSE-MsgGUID: /EZ9Fj69Teet5nVOns/zJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697466"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697466"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:51 -0700
X-CSE-ConnectionGUID: UD+z9r87RouQxnRr0QpWMw==
X-CSE-MsgGUID: h4ha1Je0THeljMC3CAkOqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760426"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:50 -0700
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
Subject: [PATCH v4 15/18] KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
Date: Thu, 18 Jul 2024 14:12:27 -0700
Message-Id: <20240718211230.1492011-16-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Integrate hooks for mirroring page table operations for cases where TDX
will zap PTEs or free page tables.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

Since calls into the TDX module are relatively slow, walking private page
tables by making calls into the TDX module would not be efficient. Because
of this, previous changes have taught the TDP MMU to keep a mirror root,
which is separate, unmapped TDP root that private operations can be
directed to. Currently this root is disconnected from the guest. Now add
plumbing to propagate changes to the "external" page tables being
mirrored. Just create the x86_ops for now, leave plumbing the operations
into the TDX module for future patches.

Add two operations for tearing down page tables, one for freeing page
tables (free_external_spt) and one for zapping PTEs (remove_external_spte).
Define them such that remove_external_spte will perform a TLB flush as
well. (in TDX terms "ensure there are no active translations").

TDX MMU support will exclude certain MMU operations, so only plug in the
mirroring x86 ops where they will be needed. For zapping/freeing, only
hook tdp_mmu_iter_set_spte() which is used for mapping and linking PTs.
Don't bother hooking tdp_mmu_set_spte_atomic() as it is only used for
zapping PTEs in operations unsupported by TDX: zapping collapsible PTEs and
kvm_mmu_zap_all_fast().

In previous changes to address races around concurrent populating using
tdp_mmu_set_spte_atomic(), a solution was introduced to temporarily set
FROZEN_SPTE in the mirrored page tables while performing the external
operations. Such a solution is not needed for the tear down paths in TDX
as these will always be performed with the mmu_lock held for write.
Sprinkle some KVM_BUG_ON()s to reflect this.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Log typos

v3:
 - Rename mirrored->external (Paolo)
 - Drop new_spte arg from reflect_removed_spte() (Paolo)
 - ...and drop was_present and is_present bools (Paolo)
 - Use base_gfn instead of sp->gfn (Paolo)
 - Better comment on logic that bugs if doing tdp_mmu_set_spte() on
   present PTE. (Paolo)
 - Move comment around KVM_BUG_ON() in __tdp_mmu_set_spte_atomic() to this
   patch, and add better comment. (Paolo)
 - In remove_external_spte(), remove was_leaf bool, skip duplicates
   present check and add comment.
 - Rename REMOVED_SPTE to FROZEN_SPTE (Paolo)

v2:
 - Split from "KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU"
 - Rename x86_ops from "private" to "reflect"
 - In response to "sp->mirrored_spt" rename helpers to "mirrored"
 - Remove unused present mirroring support in tdp_mmu_set_spte()
 - Merge reflect_zap_spte() into reflect_remove_spte()
 - Move mirror zapping logic out of handle_changed_spte()
 - Add some KVM_BUG_ONs
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  8 +++++
 arch/x86/kvm/mmu/tdp_mmu.c         | 51 +++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3ef19fcb5e42..18a83b211c90 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -97,6 +97,8 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
+KVM_X86_OP_OPTIONAL(free_external_spt)
+KVM_X86_OP_OPTIONAL(remove_external_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a17b672b1923..9c7e2f107eef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1745,6 +1745,14 @@ struct kvm_x86_ops {
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn_for_gfn);
 
+	/* Update external page tables for page table about to be freed. */
+	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 void *external_spt);
+
+	/* Update external page table from spte getting removed, and flush TLB. */
+	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				    kvm_pfn_t pfn_for_gfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 116dc3e9bdb3..ea2c64450135 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -340,6 +340,29 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
+static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+				 int level)
+{
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	int ret;
+
+	/*
+	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
+	 * PTs are removed in a special order, involving free_external_spt().
+	 * But remove_external_spte() will be called on non-leaf PTEs via
+	 * __tdp_mmu_zap_root(), so avoid the error the former would return
+	 * in this case.
+	 */
+	if (!is_last_spte(old_spte, level))
+		return;
+
+	/* Zapping leaf spte is allowed only when write lock is held. */
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	/* Because write lock is held, operation should success. */
+	ret = static_call(kvm_x86_remove_external_spte)(kvm, gfn, level, old_pfn);
+	KVM_BUG_ON(ret, kvm);
+}
+
 /**
  * handle_removed_pt() - handle a page table removed from the TDP structure
  *
@@ -435,6 +458,23 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
 				    old_spte, FROZEN_SPTE, level, shared);
+
+		if (is_mirror_sp(sp)) {
+			KVM_BUG_ON(shared, kvm);
+			remove_external_spte(kvm, gfn, old_spte, level);
+		}
+	}
+
+	if (is_mirror_sp(sp) &&
+	    WARN_ON(static_call(kvm_x86_free_external_spt)(kvm, base_gfn, sp->role.level,
+							  sp->external_spt))) {
+		/*
+		 * Failed to free page table page in mirror page table and
+		 * there is nothing to do further.
+		 * Intentionally leak the page to prevent the kernel from
+		 * accessing the encrypted page.
+		 */
+		sp->external_spt = NULL;
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -618,6 +658,13 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(new_spte)) {
 		int ret;
 
+		/*
+		 * Users of atomic zapping don't operate on mirror roots,
+		 * so don't handle it and bug the VM if it's seen.
+		 */
+		if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
+			return -EBUSY;
+
 		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
 						iter->old_spte, new_spte, iter->level);
 		if (ret)
@@ -751,8 +798,10 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	 * Users that do non-atomic setting of PTEs don't operate on mirror
 	 * roots, so don't handle it and bug the VM if it's seen.
 	 */
-	if (is_mirror_sptep(sptep))
+	if (is_mirror_sptep(sptep)) {
 		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
+		remove_external_spte(kvm, gfn, old_spte, level);
+	}
 
 	return old_spte;
 }
-- 
2.34.1


