Return-Path: <kvm+bounces-31915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 392639CDAE2
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED0642839B5
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 08:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4D518C933;
	Fri, 15 Nov 2024 08:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZzcuylc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15EA18BC36;
	Fri, 15 Nov 2024 08:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731660649; cv=none; b=cuHVSZvJbRe3CL45p3oN9ZOcgd7KMaxRpEronFKHgwOH/k7hFzMcvgSuLZue5lpwJnEEcRrwdgjcgPg2hVc/LbaQ9EaaTGln7PAEnY5Ccpa3kGap2eQLpiRdOAxSzL/Sm28JfwdSBebylzLlOcIGzbvKmK7d0yd5k7Lrr/dn7WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731660649; c=relaxed/simple;
	bh=GbtQXzGHgA75ePofMM0C4+LapiDpYgDO8Cc069qpd64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ptDocFu+ErxEX+5Aj1MgMbS+mJm6vidV0Dd1CuRN5Zpdaue3eP6sLyh8PkNXFdHBJ0FucGZ9fpZiAyE/gicYUqlgX0B3vd8icv3vyAMGeYU5UBcOacee1mbHn1eMoRsNAbPAjkepeieI8cvjF8sL6zUsN6zW65TL8B9dDRcVP70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZzcuylc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731660647; x=1763196647;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GbtQXzGHgA75ePofMM0C4+LapiDpYgDO8Cc069qpd64=;
  b=dZzcuylcCjhg59Zeyymjdv3oTPfidtvv5ddTqYVQP+Z/U4Y1kh7Bmfdw
   MDXBHRAi7Wxt6QZmC7IlwwWmSLwmvik/g1+NYSUVzfs+5APntdwlg1n+a
   j1ZA6HVTw4Co1s7cI74+e83Kvd/ToOYkEZqZWQkWXXUQAyvAyU7QpI2WR
   95GY9BL8+fixHUi4QkXhD8UXhlWJEFQogeuM6pj8IENTwXimcrHmMJhf6
   uS/WooX3h/dyR9KZOLd2tIKsLJ8EXz9yCmp63HgGFmbkEw8DTrcXa6UU8
   limiIRbzapjtP2J6NRgCCbPwWWi/EQ9Xmsd6bAhPeFHsg39dLy7ByQ9GU
   g==;
X-CSE-ConnectionGUID: yNcJmzOWRiGoGTujEF4jkQ==
X-CSE-MsgGUID: I1GstPkQSvK0yvl5cr9CQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="42191076"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="42191076"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 00:50:47 -0800
X-CSE-ConnectionGUID: R/BFWuzLR+aQeH/OKvvqcQ==
X-CSE-MsgGUID: HMXu7m7bRva2LbINOpQXWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="88913039"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 00:50:45 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	binbin.wu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: x86/mmu: Only zap valid non-mirror roots in kvm_zap_gfn_range()
Date: Fri, 15 Nov 2024 16:45:59 +0800
Message-ID: <20241115084600.12174-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only zap valid, non-mirror roots in kvm_zap_gfn_range().

There are 3 callers to kvm_zap_gfn_range() in KVM.
(1) in __kvm_set_or_clear_apicv_inhibit().
(2) in sev_handle_rmp_fault().
(3) in kvm_noncoherent_dma_assignment_start_or_stop().

TDX inhibits apicv as soon as TD initialization occurs. Mirror roots do not
apply for SEV. So, kvm_zap_gfn_range() does no need to zap mirror roots in
cases (1) and (2).

Currently, TDX does not support the assignment of noncoherent DMA devices,
even to shared memory (there's no corresponding WBINVD emulation). Even if
TDX supports noncoherent DMA devices assignment in the future, the private
EPT (underlying the mirror roots) in TDX always forces the EPT memory types
to WB. Thus, kvm_zap_gfn_range() does not need to zap mirror roots in case
(3). Zapping only valid, non-mirror roots in kvm_zap_gfn_range() allows TDX
to avoid depending on the self-snoop feature when reusing VMX's op
get_mt_mask for TDX shared EPT.

Introduce a static helper kvm_zap_gfn_range_filtered() and have
kvm_zap_gfn_range() invoke it with the filter KVM_FILTER_SHARED.

Opportunistically, move EXPORT_SYMBOL_GPL of kvm_zap_gfn_range() closer to
the function itself.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
The code base is kvm-coco-queue.

Previously Paolo suggested dropping TDX's specific implmentation of the op
get_mt_mask and having TDX reuse VMX's implementation. [1]

Sean also suggested making the self-snoop feature a hard dependency for
enabling TDX [2].

That is because
- TDX shared EPT is able to reuse the memory type specified in VMX's code
  as long as guest MTRRs are not referenced.
- KVM does not call kvm_zap_gfn_range() when attaching/detaching
  non-coherent DMA devices when the CPU have feature self-snoop. [3]

However, [3] cannot be guaranteed after commit 9d70f3fec144 ("Revert "KVM:
VMX: Always honor guest PAT on CPUs that support self-snoop"), which was
due to a regression with the bochsdrm driver.

Although [3] may be added back in the future, rather than relying on or
waiting for that, a better approach would be to avoid zapping the private
EPT in kvm_zap_gfn_range().

[1] https://lore.kernel.org/kvm/b791a3f6-a5ab-4f7e-bb2a-d277b26ec2c4@redhat.com/
[2] https://lore.kernel.org/kvm/ZuBSNS33_ck-w6-9@google.com
[3] https://lore.kernel.org/all/20240309010929.1403984-6-seanjc@google.com
---
 arch/x86/kvm/mmu/mmu.c     | 20 ++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c | 11 ++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++-
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8fc943824015..c2e4a4dcbfac 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6629,9 +6629,10 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
 
 /*
  * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
- * (not including it)
+ * (not including it) for VALID roots specified with attr_filter
  */
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+static void kvm_zap_gfn_range_filtered(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end,
+				       enum kvm_gfn_range_filter attr_filter)
 {
 	bool flush;
 
@@ -6647,7 +6648,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
 	if (tdp_mmu_enabled)
-		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
+		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end,
+					      attr_filter, flush);
 
 	if (flush)
 		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
@@ -6657,6 +6659,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	write_unlock(&kvm->mmu_lock);
 }
 
+/*
+ * Invalidate (zap) SPTEs that cover GFNs from gfn_start and up to gfn_end
+ * (not including it) for all *VALID* non-mirror roots.
+ */
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	kvm_zap_gfn_range_filtered(kvm, gfn_start, gfn_end,
+				   KVM_FILTER_SHARED);
+}
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
+
 static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot)
@@ -6998,7 +7011,6 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
-EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b0e1c4cb3004..5482f0d5d262 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1016,16 +1016,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 
 /*
- * Zap leaf SPTEs for the range of gfns, [start, end), for all *VALID** roots.
+ * Zap leaf SPTEs for the range of gfns, [start, end), for *VALID** roots
+ * specified with attr_filter.
  * Returns true if a TLB flush is needed before releasing the MMU lock, i.e. if
  * one or more SPTEs were zapped since the MMU lock was last acquired.
  */
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end,
+			   enum kvm_gfn_range_filter attr_filter, bool flush)
 {
+	enum kvm_tdp_mmu_root_types types;
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, -1)
+
+	types = kvm_gfn_range_filter_to_root_types(kvm, attr_filter);
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, -1, types)
 		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
 
 	return flush;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 7927fa4a96e0..6e17d4d151b9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -63,7 +63,8 @@ static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
 	return root_to_sp(vcpu->arch.mmu->root.hpa);
 }
 
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end,
+			   enum kvm_gfn_range_filter attr_filter, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,

base-commit: 2893e1e10283b33c1412b83949ea346aa75eaf18
-- 
2.43.2


