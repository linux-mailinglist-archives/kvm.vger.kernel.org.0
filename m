Return-Path: <kvm+bounces-20025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 752F590F920
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED7C61F22A3D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB3C16B395;
	Wed, 19 Jun 2024 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QDC9E5Yt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303BE15FA87;
	Wed, 19 Jun 2024 22:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836592; cv=none; b=O3/Mi0LwKEAdIpcLzKb4PfwB0cogic8URR+TSzU2Ti/CNP1umuhh2xpmV4sdmK23g2HFoP7/vEIaq7+33kPZwIFVwJIE+AoWXj0Oo1rwqTExS56QUsiO/u4VkWdxjN6ANdmzyYLjZo7QmxB9Vzkunp1Y1a1g5/UfColOM1Z8BlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836592; c=relaxed/simple;
	bh=xjU0Uvi2jaGMr4Uc8852Yu77RNhF+BZmEqBYNn9YWGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b/QxsGHJGhmj396RX+wDlpNBrZ3MMuMf4L18jkob06u2OHHi+eRB7t5MRWPFsfdnsXwfJCLjnZpLq8JkkzrrzT6zf8Yxfpd843OZZEklBDD1qWKDYyKdAQDsRCYK1GUs9tl0M+W2H3PNxo1BKK9xBDaBL3L/Gxvd3vLn6Ic/wKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QDC9E5Yt; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836590; x=1750372590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xjU0Uvi2jaGMr4Uc8852Yu77RNhF+BZmEqBYNn9YWGs=;
  b=QDC9E5Yt/b6DGS3Wq3CCJp90X+SVdDLYRoqeTCn5z5w8GLB9onrJroyj
   6gGXctkVIQIk6yDRw8bTdTOSsv3aaY0j5O8m4eo/q4pqg+msANZrQEolG
   3x+QU1eK7AhZ5dOG+c8YEwhGNpj66pco4rS9Yy0/1s+ZP3CzQA2Dvgl0S
   LolOvEhkYHW2WavTo5Ty6VBQaeDFu7dU7fGtUQf3QOJcj6e4qD2aJ9SA1
   oGBTzxb9G3Kw9ssA+pHLLlIDxgePg1STRSlS4H5hAAGTQCNUZm0fQ+LCF
   2QDR+EBlXXgpRvqEVjTCjwdRkWZLEjlc/iUZ+wX8u8udgk5ELwNlvCq3p
   Q==;
X-CSE-ConnectionGUID: VuNpH33hRFWkEjBS7X2QrA==
X-CSE-MsgGUID: sWFpSR10Se+cBpQuoHnCDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931968"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931968"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:22 -0700
X-CSE-ConnectionGUID: WImm/HPZRbKglmHH8KEhyg==
X-CSE-MsgGUID: sRvR66M0QrS2jYmIZwItPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793348"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:22 -0700
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
Subject: [PATCH v3 09/17] KVM: x86/mmu: Support GFN direct bits
Date: Wed, 19 Jun 2024 15:36:06 -0700
Message-Id: <20240619223614.290657-10-rick.p.edgecombe@intel.com>
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

Teach the MMU to map guest GFNs at a massaged position on the TDP, to aid
in implementing TDX shared memory.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
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
Calling code will behave as if is operating on the PTE mapping the GFN
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

This leaves one drawback. Some operations use a concept of max gfn (i.e.
kvm_mmu_max_gfn()), to iterate over the whole TDP range. These would then
exceed the range actually covered by each root. It should only result in a
bit of extra iterating, and not cause functional problems. This will be
addressed in a future change.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
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

TDX MMU Prep v2:
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
 arch/x86/kvm/mmu/tdp_iter.h     | 10 ++++++----
 5 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c59b129f382..6e07eff06a58 100644
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
index 5a2c9be23627..a19a4a05566a 100644
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
@@ -343,7 +362,12 @@ static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gp
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
index 62c9ca32d922..e9b4dff7c129 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -91,8 +91,10 @@ struct tdp_iter {
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
@@ -121,8 +123,8 @@ struct tdp_iter {
  * preorder traversal.
  */
 #define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)		  \
-	for (tdp_iter_start(&iter, root, min_level, start); \
-	     iter.valid && iter.gfn < end;		     \
+	for (tdp_iter_start(&iter, root, min_level, start, kvm_gfn_root_bits(kvm, root)); \
+	     iter.valid && iter.gfn < end;						  \
 	     tdp_iter_next(&iter))
 
 #define for_each_tdp_pte(iter, kvm, root, start, end)				\
@@ -131,7 +133,7 @@ struct tdp_iter {
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn);
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_bits);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
-- 
2.34.1


