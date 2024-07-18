Return-Path: <kvm+bounces-21893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0594B935305
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E82AB21D1F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6121494A9;
	Thu, 18 Jul 2024 21:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b5FklUsU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7D1482E8;
	Thu, 18 Jul 2024 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337173; cv=none; b=EyFrOCYIg4rS8x4pyNmkwNDn3MhWZp/uvLVGhlNSulhpkTrgIYNGh1wIRH1rNtLyfsBOB01SZkHGN3+T1FN3l3RNEuZ0VtgKAp+EfmzelwK5ie4phglLsaNSoMlc626ZBUUlPdf98/AIz8sW2hpM4oOabaweym74XuFH3ZCo+KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337173; c=relaxed/simple;
	bh=ErxbfdqQRNxj/yVhrRUoQP5sQ+QEnblBq2Uf+/OullE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q4/LD0gNzMktt7A/MgN0Myt/AKVXIx06r50Tf3SpQR2NOCECQBmF+MoTkNpy6BTd+n/bcP8JEw7s0BwVNalFeIcIjg/HD2c9HuEpD6IGmqXX+M2GGASToIUr8DgZ6/zyTX/nPrystFm9fXWOTwmDoTIizVi2QfaG4ylfw1Ts928=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b5FklUsU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337171; x=1752873171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ErxbfdqQRNxj/yVhrRUoQP5sQ+QEnblBq2Uf+/OullE=;
  b=b5FklUsU1QoNQZBLHlZRANycb7CF387yAedZMI7CDjr8llqRde28P43D
   lfspGk2lvrN/OpJOItZPI+sjw//X2W6vBk6QDJlG1q8woen7/1vKH/con
   l87c4XehAh1rjCJ1/HDUAFVcr2S5dGatyxZHJrQbgz47d33eSA09OJlJk
   5B55vpJBC/BcljZuMDmCY/pt5A8eHCRttTQ57pzliU2cGuwjEQ/VGwSN5
   ZDg5ujahIaqVcxsTmP0Latftd9SqL6SDuNgNE+ubzRA9lIz71qobpJVTk
   w/fpDtUBezY3bqjFgOj3HUc4MsbTSpqx1P0IVn2aJ7XtDkY0Cg5qRFeSv
   A==;
X-CSE-ConnectionGUID: F1uQolgDTfixn/96rqUUCQ==
X-CSE-MsgGUID: mc1G8hj6Qlmd2mZxKGjpsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697428"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697428"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:46 -0700
X-CSE-ConnectionGUID: +jGES0tmQqC/fhGO3g4izw==
X-CSE-MsgGUID: AHw6fDmzSCKGQoHRtB7pYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760394"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:45 -0700
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
Subject: [PATCH v4 08/18] KVM: x86/mmu: Support GFN direct bits
Date: Thu, 18 Jul 2024 14:12:20 -0700
Message-Id: <20240718211230.1492011-9-rick.p.edgecombe@intel.com>
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

Teach the MMU to map guest GFNs at a massaged position on the TDP, to aid
in implementing TDX shared memory.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly through calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

For TDX, the shared half will be mapped in the higher alias, with a "shared
bit" set in the GPA. However, KVM will still manage it with the same
memslots as the private half. This means memslot looks ups and zapping
operations will be provided with a GFN without the shared bit set.

So KVM will either need to apply or strip the shared bit before mapping or
zapping the shared EPT. Having GFNs sometimes have the shared bit and
sometimes not would make the code confusing.

So instead arrange the code such that GFNs never have shared bit set.
Create a concept of "direct bits", that is stripped from the fault
address when setting fault->gfn, and applied within the TDP MMU iterator.
Calling code will behave as if it is operating on the PTE mapping the GFN
(without shared bits) but within the iterator, the actual mappings will be
shifted using bits specific for the root. SPs will have the GFN set
without the shared bit. In the end the TDP MMU will behave like it is
mapping things at the GFN without the shared bit but with a strange page
table format where everything is offset by the shared bit.

Since TDX only needs to shift the mapping like this for the shared bit,
which is mapped as the normal TDP root, add a "gfn_direct_bits" field to
the kvm_arch structure for each VM with a default value of 0. It will
have the bit set at the position of the GPA shared bit in GFN through TD
specific initialization code. Keep TDX specific concepts out of the MMU
code by not naming it "shared".

Ranged TLB flushes (i.e. flush_remote_tlbs_range()) target specific GFN
ranges. In convention established above, these would need to target the
shifted GFN range. It won't matter functionally, since the actual
implementation will always result in a full flush for the only planned
user (TDX). For correctness reasons, future changes can provide a TDX
x86_ops.flush_remote_tlbs_range implementation to return -EOPNOTSUPP and
force the full flush for TDs.

This leaves one problem. Some operations use a concept of max GFN (i.e.
kvm_mmu_max_gfn()), to iterate over the whole TDP range. When applying the
direct mask to the start of the range, the iterator would end up skipping
iterating over the range not covered by the direct mask bit. For safety,
make sure the __tdp_mmu_zap_root() operation iterates over the full GFN
range supported by the underlying TDP format. Add a new iterator helper,
for_each_tdp_pte_min_level_all(), that iterates the entire TDP GFN range,
regardless of root.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Add for_each_tdp_pte_min_level_all()
 - Log typos

v3:
 - Add comment for kvm_gfn_root_mask() (Paolo)
 - Change names mask -> bits (Paolo)
 - Add comment in struct definition for fault->gfn not containing shared
   bit. (Paolo)
 - Drop special handling in kvm_arch_flush_remote_tlbs_range(),
   implement kvm_x86_ops.flush_remote_tlbs_range in a future patch.
   (Paolo)
 - Do addition of kvm arg to iterator in previous patch (Paolo)
 - OR gfn_bits in try_step_side() too, because of issue seen with 4
   level EPT
 - Add warning for GFN bits in wrong arg in tdp_iter_start()

v2:
 - Rename from "KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA"
 - Dropped Binbin's reviewed-by tag because of the extend of the changes
 - Rename gfn_shared_mask to gfn_direct_mask.
 - Don't include shared bits in GFNs, hide the existence in the TDP MMU
   iterator.
 - Don't do range flushes if a gfn_direct_mask is present.
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              |  5 +++++
 arch/x86/kvm/mmu/mmu_internal.h | 28 ++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_iter.c     | 10 ++++++----
 arch/x86/kvm/mmu/tdp_iter.h     | 15 +++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c      |  5 +----
 6 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f764a07a32f9..1730f94c9742 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1525,6 +1525,8 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	gfn_t gfn_direct_bits;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0c3bf89cf7db..63179a4fba7b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -323,4 +323,9 @@ static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
+
+static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
+{
+	return kvm->arch.gfn_direct_bits;
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 3319d0a42f36..6e768cd438b9 100644
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
@@ -173,6 +175,18 @@ static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_
 	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
 }
 
+static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mmu_page *root)
+{
+	/*
+	 * Since mirror SPs are used only for TDX, which maps private memory
+	 * at its "natural" GFN, no mask needs to be applied to them - and, dually,
+	 * we expect that the bits is only used for the shared PT.
+	 */
+	if (is_mirror_sp(root))
+		return 0;
+	return kvm_gfn_direct_bits(kvm);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
@@ -257,7 +271,12 @@ struct kvm_page_fault {
 	 */
 	u8 goal_level;
 
-	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
+	/*
+	 * Shifted addr, or result of guest page table walk if addr is a gva. In
+	 * the case of VM where memslot's can be mapped at multiple GPA aliases
+	 * (i.e. TDX), the gfn field does not contain the bit that selects between
+	 * the aliases (i.e. the shared bit for TDX).
+	 */
 	gfn_t gfn;
 
 	/* The memslot containing gfn. May be NULL. */
@@ -343,7 +362,12 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	int r;
 
 	if (vcpu->arch.mmu->root_role.direct) {
-		fault.gfn = fault.addr >> PAGE_SHIFT;
+		/*
+		 * Things like memslots don't understand the concept of a shared
+		 * bit. Strip it so that the GFN can be used like normal, and the
+		 * fault.addr can be used when the shared bit is needed.
+		 */
+		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_direct_bits(vcpu->kvm);
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 04c247bfe318..9e17bfa80901 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -12,7 +12,7 @@
 static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
-		SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+		SPTE_INDEX((iter->gfn | iter->gfn_bits) << PAGE_SHIFT, iter->level);
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
@@ -37,15 +37,17 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn)
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_bits)
 {
 	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
-			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
+			 (root->role.level > PT64_ROOT_MAX_LEVEL) ||
+			 (gfn_bits && next_last_level_gfn >= gfn_bits))) {
 		iter->valid = false;
 		return;
 	}
 
 	iter->next_last_level_gfn = next_last_level_gfn;
+	iter->gfn_bits = gfn_bits;
 	iter->root_level = root->role.level;
 	iter->min_level = min_level;
 	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
@@ -113,7 +115,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	 * Check if the iterator is already at the end of the current page
 	 * table.
 	 */
-	if (SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
+	if (SPTE_INDEX((iter->gfn | iter->gfn_bits) << PAGE_SHIFT, iter->level) ==
 	    (SPTE_ENT_PER_PAGE - 1))
 		return false;
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index d8f2884e3c66..047b78333653 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -93,8 +93,10 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN mapped by the current SPTE */
+	/* The lowest GFN (mask bits excluded) mapped by the current SPTE */
 	gfn_t gfn;
+	/* Mask applied to convert the GFN to the mapping GPA */
+	gfn_t gfn_bits;
 	/* The level of the root page given to the iterator */
 	int root_level;
 	/* The lowest level the iterator should traverse to */
@@ -123,17 +125,22 @@ struct tdp_iter {
  * preorder traversal.
  */
 #define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)		  \
-	for (tdp_iter_start(&iter, root, min_level, start); \
-	     iter.valid && iter.gfn < end;		     \
+	for (tdp_iter_start(&iter, root, min_level, start, kvm_gfn_root_bits(kvm, root)); \
+	     iter.valid && iter.gfn < end;						  \
 	     tdp_iter_next(&iter))
 
+#define for_each_tdp_pte_min_level_all(iter, root, min_level)		\
+	for (tdp_iter_start(&iter, root, min_level, 0, 0);		\
+		iter.valid && iter.gfn < tdp_mmu_max_gfn_exclusive();	\
+		tdp_iter_next(&iter))
+
 #define for_each_tdp_pte(iter, kvm, root, start, end)				\
 	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn);
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_bits);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 89b8a8eed116..2befece426aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -749,10 +749,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	gfn_t end = tdp_mmu_max_gfn_exclusive();
-	gfn_t start = 0;
-
-	for_each_tdp_pte_min_level(iter, kvm, root, zap_level, start, end) {
+	for_each_tdp_pte_min_level_all(iter, root, zap_level) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
-- 
2.34.1


