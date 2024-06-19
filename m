Return-Path: <kvm+bounces-20030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E5590F92A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5E1D1F21BE5
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F2B1891A9;
	Wed, 19 Jun 2024 22:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJ6eDaAP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEF416C68C;
	Wed, 19 Jun 2024 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836596; cv=none; b=UgV4JJGMYNojSc2RDb0b9qUxnPRRec+6Tg5Mhmec9kJP2th2K1YITxk3S17ULpTqEgD2J157My3UbLihE3qrkzFcxIkzUQL7yL3bRlet0y7PBrbCO6uQ6Mi0PNlaj/tyx3DEpJg1RRRIBG2yQIU9dd6w826rJ/tNvXyf/KQw47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836596; c=relaxed/simple;
	bh=QNrnm6KfOWbc79FY56+INCLxoz1r3CxxEJXVanY0ovY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qj/eKIezUmbQVwipYFZC32mMjCPYsIfiv/QCyTvH3dVwanZQ8nHPZq7Mlzg/5QgY2/HXAhvqYtOj3/Xu46kHbJH4QsmxeShQqxZiTTp3QuMjx0IyR0rUtSzH8VGw9qaCEfxe3pLLr1X9Nfqnw1RLP4QRFYQLFu1eZiA3tFO+4GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJ6eDaAP; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836593; x=1750372593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QNrnm6KfOWbc79FY56+INCLxoz1r3CxxEJXVanY0ovY=;
  b=HJ6eDaAPMMShF7gnhQUuCnUYq/Zo8JqivOvOwhBpCy2c3Wq058Ut59/R
   /Jok5Nq/mwXszdMhfv/qrsTxxLMsqdEpI27o72chqfKPw5/pGcY//eN/6
   JyBtBv1zEzFjk1UPoGRANNsaPsRZVqNyig+J6Oa+nDQy2Ty4u5GtMuy8R
   KW2xB6DnKxmOvDSL/eaJeIJpK+AF2GBZJM2+pQjPKX50JyzCNvS3j+PZW
   UvWTVYLf6nnke1j8lSJxa+f7z5ON1unx8r23X6agso3ajRzKlBcPkOQeT
   0gdDD0pehfauMZjisv5ay6gzFa2dMfcznHBvu0GNP7LR0FJpBXVba1SU0
   A==;
X-CSE-ConnectionGUID: Kihx/tXgS42mQN4KsJYbCw==
X-CSE-MsgGUID: C6cfpVazS9qbRbQyPmuEbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15932000"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15932000"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:24 -0700
X-CSE-ConnectionGUID: QNT9uhIgQ2y1fbnLnvoTOA==
X-CSE-MsgGUID: sC+z4cTVT0W6/JcIm4Z7cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793376"
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
Subject: [PATCH v3 16/17] KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
Date: Wed, 19 Jun 2024 15:36:13 -0700
Message-Id: <20240619223614.290657-17-rick.p.edgecombe@intel.com>
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
hook tdp_mmu_iter_set_spte() which is use used for mapping and linking
PTs. Don't bother hooking tdp_mmu_set_spte_atomic() as it is only used for
zapping PTEs in operations unsupported by TDX: zapping collapsible PTEs and
kvm_mmu_zap_all_fast().

In previous changes to address races around concurrent populating using
tdp_mmu_set_spte_atomic(), a solution was introduced to temporarily set
REMOVED_SPTE in the mirrored page tables while performing the external
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
TDX MMU Prep v3:
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

TDX MMU Prep v2:
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
index 12ff04135a0e..dca623ffa903 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1745,6 +1745,14 @@ struct kvm_x86_ops {
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn_for_gfn);
 
+	/* Update external page tables for page table about to be freed */
+	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 void *external_spt);
+
+	/* Update external page table from spte getting removed, and flush TLB */
+	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				    kvm_pfn_t pfn_for_gfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc1ad127046d..630e6b6d4bf2 100644
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
@@ -616,6 +656,13 @@ static inline int __tdp_mmu_set_spte_atomic(struct kvm *kvm, struct tdp_iter *it
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
@@ -749,8 +796,10 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
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


