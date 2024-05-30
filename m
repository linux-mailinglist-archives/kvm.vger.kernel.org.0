Return-Path: <kvm+bounces-18448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7378D5443
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 573251F25130
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010B419DF69;
	Thu, 30 May 2024 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gYR5TC0v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1F194C72;
	Thu, 30 May 2024 21:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103261; cv=none; b=QgJERj+pMK/52ocXTqhqUf8cMqoe2MOL6uH0uQE1YEcwMrMMy3ixx+AwNl2WaPddSR5MPFiDM/FG/RR/ox0I15oU7JKXm8sKwHHyKRhttQZiLgdufE5nj5QLvSMDi8AjkuoZowSLVu38OF8e7ukTAgD8dNA4YvfJW+pkJD3GmbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103261; c=relaxed/simple;
	bh=TgO6tpp8a+8fa4ZO/q48aPWV1n+q1shBCab9DfG7F3I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q8EiKYa5mCsILM8Sd2w8O+a/vdkzkjVZnvhDJl4RCLQrWHIcCCZ+oylRvkEyLNBUGGKAtIcS1kv8GlCA0qXLYmnnEr6AKWNOMxSxGyswU5s31CHfA2VYDP61+6TqwgRX+9jyeWoY/vlFs216L9bUH8InYGnJeuGzs8oy0ziw3DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gYR5TC0v; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103259; x=1748639259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TgO6tpp8a+8fa4ZO/q48aPWV1n+q1shBCab9DfG7F3I=;
  b=gYR5TC0v4qlNujq49qEQBYElokdLY3w7Pdr/hqSbuOSYwBWBOYDLUjrv
   MWOjbyyfDDtAO7GYzAYQD/eJMNkJko7dagZjJ10RMJt/V1BJtedyleQrE
   Gwu43h3AZSRlI6VnGrQnLxryZPjA8TpIoKJtl6WQ34/d0WJysG6C4s+01
   J4V9wzbGM0rQBLmz6sDLV03oGk7wrmBSJO8ZKkWXdYb3R89WVGVVudL+T
   s7oYcIxw3zdgBP9MRhNHkYm47wIR5GEJyoFMT0WOEdT1zXhQzyrISCfdO
   9pGw/Foq9t87J5sLSoOJjjX/W6IYBmzKCHCEV7Zz65Vobb2iLGVgQr9KW
   w==;
X-CSE-ConnectionGUID: x+UyJwDeQhO8HWxftrJwNQ==
X-CSE-MsgGUID: c0UeOLboRFGAUL2YiXZXiQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117136"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117136"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:38 -0700
X-CSE-ConnectionGUID: nX9MOUKaQ2OzKWHex3JHrg==
X-CSE-MsgGUID: Q8io8ErSSfmItvL1a8RdAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874452"
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
Subject: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror page tables
Date: Thu, 30 May 2024 14:07:10 -0700
Message-Id: <20240530210714.364118-12-rick.p.edgecombe@intel.com>
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
plumbing to "reflect" changes to the mirror to the page tables being
mirrored. Just create the x86_ops for now, leave plumbing the operations
into the TDX module for future patches.

Add two operations for tearing down page tables, one for freeing page
tables (reflect_free_spt) and one for zapping PTEs (reflect_remove_spte).
Define them such that reflect_remove_spte will perform a TLB flush as well.
(in TDX terms "ensure there are no active translations").

TDX MMU support will exclude certain MMU operations, so only plug in the
mirroring x86 ops where they will be needed. For zapping/freeing, only
hook tdp_mmu_iter_set_spte() which is use used for mapping and linking
PTs. Don't bother hooking tdp_mmu_set_spte_atomic() as it is only used for
zapping PTEs in operations unsupported by TDX: zapping collapsible PTEs and
kvm_mmu_zap_all_fast().

In previous changes to address races around concurrent populating using
tdp_mmu_set_spte_atomic(), a solution was introduced to temporarily set
REMOVED_SPTE in the mirrored page tables while performing the "reflect"
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
 arch/x86/include/asm/kvm_host.h    |  8 ++++++
 arch/x86/kvm/mmu/tdp_mmu.c         | 45 ++++++++++++++++++++++++++++--
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 1877d6a77525..dae06afc6038 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -97,6 +97,8 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(reflect_link_spt)
 KVM_X86_OP_OPTIONAL(reflect_set_spte)
+KVM_X86_OP_OPTIONAL(reflect_free_spt)
+KVM_X86_OP_OPTIONAL(reflect_remove_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20bb10f22ca6..0df4a31a0df9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1755,6 +1755,14 @@ struct kvm_x86_ops {
 	int (*reflect_set_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				kvm_pfn_t pfn);
 
+	/* Update mirrored page tables for page table about to be freed */
+	int (*reflect_free_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *mirrored_spt);
+
+	/* Update mirrored page table from spte getting removed, and flush TLB */
+	int (*reflect_remove_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				   kvm_pfn_t pfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 41b1d3f26597..1245f6a48dbe 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -346,6 +346,29 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
+static void reflect_removed_spte(struct kvm *kvm, gfn_t gfn,
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
+	/* Because write lock is held, operation should success. */
+	ret = static_call(kvm_x86_reflect_remove_spte)(kvm, gfn, level, old_pfn);
+	KVM_BUG_ON(ret, kvm);
+}
+
 /**
  * handle_removed_pt() - handle a page table removed from the TDP structure
  *
@@ -441,6 +464,22 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
 				    old_spte, REMOVED_SPTE, sp->role, shared);
+		if (is_mirror_sp(sp)) {
+			KVM_BUG_ON(shared, kvm);
+			reflect_removed_spte(kvm, gfn, old_spte, REMOVED_SPTE, level);
+		}
+	}
+
+	if (is_mirror_sp(sp) &&
+	    WARN_ON(static_call(kvm_x86_reflect_free_spt)(kvm, sp->gfn, sp->role.level,
+							  kvm_mmu_mirrored_spt(sp)))) {
+		/*
+		 * Failed to free page table page in mirror page table and
+		 * there is nothing to do further.
+		 * Intentionally leak the page to prevent the kernel from
+		 * accessing the encrypted page.
+		 */
+		sp->mirrored_spt = NULL;
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -778,9 +817,11 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	role.level = level;
 	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
 
-	/* Don't support setting for the non-atomic case */
-	if (is_mirror_sptep(sptep))
+	if (is_mirror_sptep(sptep)) {
+		/* Only support zapping for the non-atomic case */
 		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
+		reflect_removed_spte(kvm, gfn, old_spte, REMOVED_SPTE, level);
+	}
 
 	return old_spte;
 }
-- 
2.34.1


