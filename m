Return-Path: <kvm+bounces-44051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C56AAA99F6C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4844921E1C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D1A1AED5C;
	Thu, 24 Apr 2025 03:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a/7ldhVa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EB61A9B4D;
	Thu, 24 Apr 2025 03:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464282; cv=none; b=eUDHDjVBhafgjFnYxDu+JyKYIH+JWFP0x/fU9GklNVMjXDpd2A3MbfkEyTdwQxCUPTA/BVGOWJvhsCZ8C24fArmGQ9QZcm651m4hGM8tJ8vF8BvTFtQAdSgkaOoKmmIuN/zED2z3zJokeQxWjFkUdNEtXTUQogR65+WPjyYtuf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464282; c=relaxed/simple;
	bh=zRFvAmxtMph549CzIA/AmyU/e7s3BzXqr9YPnTCY/aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOdqsPipaHZaQV0JEKIkiSp6NxmvMIikJ2aPoP0nVDbRf2LjBDs/YtXCMCTn+tHEcyv2FnG87nM3Z7w55S1Y0SVWvkgfh+h3bVurfHKx04/kHrpXlVJfnorll8T6P+YHBtARuW7Oe9SDlYBaOOLmU+PbW2CXMhTVaxodpgq8vG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a/7ldhVa; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464281; x=1777000281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zRFvAmxtMph549CzIA/AmyU/e7s3BzXqr9YPnTCY/aM=;
  b=a/7ldhVa7gKA2fixopaiw8bFjPbW8ol+02lwn5SeovUwbRrJmLRR/js8
   FDHW9uBXCTz4fJhJhotPwxglSq57PkH+gb64sptfLAw3yDbsINJhkvOk2
   C3K72kcHKzKC7rpRdgsHfwkdt1AkfnIpbr7GqfE6NRmk7sabSoM7POEDH
   rcuVJXXmYLD+0IRseANmZx5tpsx30284h/mNq8+Ps5+hk0ambs61KL4NI
   1x38CpTSiQKQ54ZVTG5ZVp2di/EGecNr1iwhGaKQBiFOdc/9YbrYKdtN1
   DIXoj3k0zuxPHbOQZ8URaDVj0xIuRnE9ciJcB4Xn3dDVxYh50jqT1aSAM
   g==;
X-CSE-ConnectionGUID: O0WvX5blTPSXtNkFuyuFJg==
X-CSE-MsgGUID: P4kXdGt3QXeZWQhsHy7KGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="64491627"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="64491627"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:11:18 -0700
X-CSE-ConnectionGUID: 9y83hrGHQAetUBDbV6N0jA==
X-CSE-MsgGUID: 7NIpUHhjTEGnnojBLd951A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="136565685"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:11:12 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 21/21] KVM: x86: Ignore splitting huge pages in fault path for TDX
Date: Thu, 24 Apr 2025 11:09:26 +0800
Message-ID: <20250424030926.554-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As handling the BUSY error from SEAMCALLs for splitting huge pages is more
comprehensive in the fault path, which is with kvm->mmu_lock held for
reading, simply ignore the splitting huge page request in fault path for
TDX.

Splitting in fault path can now be caused by vCPUs' concurrent ACCEPT
operations at diffent levels, e.g. one vCPU accepts at 2MB level while
another vCPU accepts at 4KB level. As the first vCPU will accepts the whole
2MB range ultimately, ignoring the mapping request (which leads to huge
page splitting) caused by the second 4KB ACCEPT operation is fine.

A rare case that could lead to splitting in the fault path is when a TD is
configured to receive #VE and accesses memory before the ACCEPT operation.
By the time a vCPU accesses a private GFN, due to the lack of any guest
preferred level, KVM could create a mapping at 2MB level. If the TD then
only performs the ACCEPT operation at 4KB level, splitting in the fault
path will be triggered. However, this is not regarded as a typical use
case, as usually TD always accepts pages in the order from 1GB->2MB->4KB.
The worst outcome to ignore the resulting splitting request is an endless
EPT violation. This would not happen for a Linux guest, which does not
expect any #VE.

This ignoring of splitting huge page in fault path is achieved in 3 parts:
1. In KVM TDP MMU,
   allow splitting huge pages in fault path for the mirror page table and
   propagate the splitting request to TDX.
2. Enhance the hook split_external_spt by
   passing in shared/exclusive status of kvm->mmu_lock
3. In TDX's implementation of hook split_external_spt,
   do nothing but to set the max_level of the next fault on the splitting
   GFN range on the vCPU to 2MB and return -EBUSY.

Then after tdx_sept_split_private_spt() returns, TDX's EPT violation
handler may (a) return to guest directly (when signal/interrupt pending) or
(b) retry locally in the TDX's code.
- for (a), the TD can retry the ACCEPT operation, finding the memory is
  accepted at 2MB level by another vCPU.
- for (b), as the violation_request_level is set to 2MB, the next
  kvm_mmu_page_fault() will return RET_PF_SPURIOUS, causing re-entering of
  the TD.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 44 ++++++++++++++++++++-------------
 arch/x86/kvm/vmx/tdx.c          | 25 ++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h      |  5 ++--
 4 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5167458742bf..faae82eefd99 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1814,7 +1814,7 @@ struct kvm_x86_ops {
 
 	/* Split the external page table into smaller page tables */
 	int (*split_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				  void *external_spt);
+				  void *external_spt, bool mmu_lock_shared);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d3fba5d11ea2..1b2bacde009f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -388,15 +388,15 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 }
 
 static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
-			      u64 new_spte, int level)
+			      u64 new_spte, int level, bool shared)
 {
 	void *external_spt = get_external_spt(gfn, new_spte, level);
 	int ret;
 
 	KVM_BUG_ON(!external_spt, kvm);
 
-	ret = static_call(kvm_x86_split_external_spt)(kvm, gfn, level, external_spt);
-	KVM_BUG_ON(ret, kvm);
+	ret = static_call(kvm_x86_split_external_spt)(kvm, gfn, level, external_spt, shared);
+	KVM_BUG_ON(ret && !shared, kvm);
 
 	return ret;
 }
@@ -536,11 +536,13 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
 	int ret = 0;
 
-	KVM_BUG_ON(was_present, kvm);
+	/* leaf to leaf or non-leaf to non-leaf updates are not allowed */
+	KVM_BUG_ON((was_leaf && is_leaf) || (was_present && !was_leaf && !is_leaf), kvm);
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	/*
@@ -551,18 +553,28 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	if (!try_cmpxchg64(rcu_dereference(sptep), &old_spte, FROZEN_SPTE))
 		return -EBUSY;
 
-	/*
-	 * Use different call to either set up middle level
-	 * external page table, or leaf.
-	 */
-	if (is_leaf) {
-		ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
-	} else {
-		void *external_spt = get_external_spt(gfn, new_spte, level);
+	if (!was_present) {
+		/*
+		 * Propagate to install a new leaf or non-leaf entry in external
+		 * page table.
+		 */
+		if (is_leaf) {
+			ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
+		} else {
+			void *external_spt = get_external_spt(gfn, new_spte, level);
 
-		KVM_BUG_ON(!external_spt, kvm);
-		ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, external_spt);
+			KVM_BUG_ON(!external_spt, kvm);
+			ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, external_spt);
+		}
+	} else if (was_leaf && is_present && !is_leaf) {
+		/* demote */
+		ret = split_external_spt(kvm, gfn, old_spte, new_spte, level, true);
+	} else {
+		/* Promotion is not supported by mirror root (TDX)*/
+		KVM_BUG_ON(1, kvm);
+		ret = -EOPNOTSUPP;
 	}
+
 	if (ret)
 		__kvm_tdp_mmu_write_spte(sptep, old_spte);
 	else
@@ -784,7 +796,7 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 		if (!is_shadow_present_pte(new_spte))
 			remove_external_spte(kvm, gfn, old_spte, level);
 		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
-			split_external_spt(kvm, gfn, old_spte, new_spte, level);
+			split_external_spt(kvm, gfn, old_spte, new_spte, level, false);
 		else
 			KVM_BUG_ON(1, kvm);
 	}
@@ -1315,8 +1327,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
 		if (is_shadow_present_pte(iter.old_spte)) {
-			/* Don't support large page for mirrored roots (TDX) */
-			KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
 		} else {
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e24d1cbcc762..e994a6c08a75 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1834,7 +1834,7 @@ static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
 }
 
 int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-			       void *private_spt)
+			       void *private_spt, bool mmu_lock_shared)
 {
 	struct page *page = virt_to_page(private_spt);
 	int ret;
@@ -1842,6 +1842,29 @@ int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE || level != PG_LEVEL_2M, kvm))
 		return -EINVAL;
 
+	/*
+	 * Split request with mmu_lock held for reading can only occur when one
+	 * vCPU accepts at 2MB level while another vCPU accepts at 4KB level.
+	 * Ignore this 4KB mapping request by setting violation_request_level to
+	 * 2MB and returning -EBUSY for retry. Then the next fault at 2MB level
+	 * would be a spurious fault. The vCPU accepting at 2MB will accept the
+	 * whole 2MB range.
+	 */
+	if (mmu_lock_shared) {
+		struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+		struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+		if (KVM_BUG_ON(!vcpu, kvm))
+			return -EOPNOTSUPP;
+
+		/* Request to map as 2MB leaf for the whole 2MB range */
+		tdx->violation_gfn_start = gfn_round_for_level(gfn, level);
+		tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
+		tdx->violation_request_level = level;
+
+		return -EBUSY;
+	}
+
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
 		return ret;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 0619e9390e5d..fcba76887508 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -159,7 +159,7 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn);
 int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-			       void *private_spt);
+			       void *private_spt, bool mmu_lock_shared);
 
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
@@ -228,7 +228,8 @@ static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
 static inline int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
 					     enum pg_level level,
-					     void *private_spt)
+					     void *private_spt,
+					     bool mmu_lock_shared)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.43.2


