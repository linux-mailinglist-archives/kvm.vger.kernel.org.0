Return-Path: <kvm+bounces-54236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7A2B1D514
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3320E3ABB72
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7D02571C5;
	Thu,  7 Aug 2025 09:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZHAWmckp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C567B25C6F1;
	Thu,  7 Aug 2025 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559869; cv=none; b=sXO5ruoPbstOcVEg3kqS+dDaH2vLDx/YUboebXYG6NFRxmOoPVPgtdqzbdKYyE2hKyrzgrdQTNmcUoYmi8HKeSxVZVneX231gOCfGrHuZe7yBX3AVplO3bazEwWKd7ymEZdwt/dHkjMRvLMHTWjcukHxfq3Q/bCcz6ublR0x8vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559869; c=relaxed/simple;
	bh=k0fqS42rCkj1QxdhJED46aYQeUqVWIMo/Hw/gwBrR+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyv0IyoY+nhkVijCual36E41kPVjXFNsa4XwYaPbXc6z6sG867hwPMImtab6mnTOEiBS938fDGcF7Ujfk03oZ4MasdEqSf2wMocUllIW0lLRr3W9IJb/QdC2/6YguR9s4Tn58m0L8hS1xwocqOOqIuuV33LzOeDpC9HgzGzt9kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZHAWmckp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559868; x=1786095868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0fqS42rCkj1QxdhJED46aYQeUqVWIMo/Hw/gwBrR+4=;
  b=ZHAWmckpSaMoCL/2q91Z1O09M0zK0ZNq7srqS51QHgtet/kNVsURm33X
   /m3/hENDxyzl18ymUdtf/2cFSjBh57Taeu5Nduc2okU9fTxSc06PNaZ98
   E/1u3tWPQWELkEuAP5mqdiME+y2UZIK5kwebsjuqWaPzpH3E6xcaToxWn
   NeIfJa8XTbal3cdF9+KCcIB2WbzlLTRtcC5lCLR4iJhuGPiZph0k9XI5l
   i6raaVD/z/Q5SBEzBa0h7MzH1nqZS5S/Sxhm7uKYiYDDybb1P6CMYoV56
   8ZfWEItCPElPOZhwwkMSt+FjCsY8OpRP8FmcACaU4nqSJq/yTmipYoNb4
   g==;
X-CSE-ConnectionGUID: sWjJQbDnTh+WE6c/pokmEA==
X-CSE-MsgGUID: UCREFGqOTLCFAwJNFu7Omg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="79435922"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="79435922"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:22 -0700
X-CSE-ConnectionGUID: 2xF2TkJZSai6PZUQfOiL+g==
X-CSE-MsgGUID: shqHCTw0QZi3deWzEyaPkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="164263262"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:16 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
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
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 11/23] KVM: x86: Reject splitting huge pages under shared mmu_lock for mirror root
Date: Thu,  7 Aug 2025 17:43:45 +0800
Message-ID: <20250807094345.4593-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While removing the KVM_BUG_ON() for the mirror root before invoking
tdp_mmu_split_huge_page() in the fault path, update the hook
split_external_spt to pass in shared mmu_lock info and invoke the hook in
set_external_spte_present() on splitting is detected. Reject the splitting
in TDX if the splitting is under shared mmu_lock.

TDX requires different handling for splitting under shared or exclusive
mmu_lock.

Under a shared mmu_lock, TDX cannot kick off all vCPUs to avoid BUSY error
from tdh_mem_page_demote(). As the current TDX module requires
tdh_mem_range_block() to be invoked before each tdh_mem_page_demote(), if a
BUSY error occurs, TDX must call tdh_mem_range_unblock() before returning
the error to the KVM MMU core to roll back the old SPTE and retry. However,
tdh_mem_range_unblock() may also fail due to contention.

Reject splitting huge pages under shared mmu_lock for mirror root in TDX
rather than KVM_BUG_ON() in KVM MMU core to allow for future real
implementation of demote under shared mmu_lock once non-blocking demote is
available.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- WARN_ON_ONCE() and return error in tdx_sept_split_private_spt() if it's
  invoked under shared mmu_lock. (rather than increase the next fault's
  max_level in current vCPU via tdx->violation_gfn_start/end and
  tdx->violation_request_level).
- TODO: Perform the real implementation of demote under shared mmu_lock
        when new version of TDX module supporting non-blocking demote is
        available.

RFC v1:
- New patch.
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 45 ++++++++++++++++++++-------------
 arch/x86/kvm/vmx/tdx.c          |  8 +++++-
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e431ce0e3180..6cb5b422dd1d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1841,7 +1841,7 @@ struct kvm_x86_ops {
 
 	/* Split the external page table into smaller page tables */
 	int (*split_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				  void *external_spt);
+				  void *external_spt, bool mmu_lock_shared);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a2c6e6e4773f..ce49cc850ed5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -386,15 +386,14 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 }
 
 static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
-			      u64 new_spte, int level)
+			      u64 new_spte, int level, bool shared)
 {
 	void *external_spt = get_external_spt(gfn, new_spte, level);
 	int ret;
 
 	KVM_BUG_ON(!external_spt, kvm);
 
-	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level, external_spt);
-
+	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level, external_spt, shared);
 	return ret;
 }
 /**
@@ -533,11 +532,19 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
 	int ret = 0;
 
-	KVM_BUG_ON(was_present, kvm);
+	/*
+	 * Caller ensures new_spte must be present.
+	 * Current valid transitions:
+	 * - leaf to non-leaf (demote)
+	 * - !present to present leaf
+	 * - !present to present non-leaf
+	 */
+	KVM_BUG_ON(!(!was_present || (was_leaf && !is_leaf)), kvm);
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	/*
@@ -548,18 +555,24 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	if (!try_cmpxchg64(rcu_dereference(sptep), &old_spte, FROZEN_SPTE))
 		return -EBUSY;
 
-	/*
-	 * Use different call to either set up middle level
-	 * external page table, or leaf.
-	 */
-	if (is_leaf) {
-		ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_pfn);
-	} else {
-		void *external_spt = get_external_spt(gfn, new_spte, level);
+	if (!was_present) {
+		/*
+		 * Use different call to either set up middle level
+		 * external page table, or leaf.
+		 */
+		if (is_leaf) {
+			ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_pfn);
+		} else {
+			void *external_spt = get_external_spt(gfn, new_spte, level);
 
-		KVM_BUG_ON(!external_spt, kvm);
-		ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
+			KVM_BUG_ON(!external_spt, kvm);
+			ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
+		}
+	} else if (was_leaf && !is_leaf) {
+		/* demote */
+		ret = split_external_spt(kvm, gfn, old_spte, new_spte, level, true);
 	}
+
 	if (ret)
 		__kvm_tdp_mmu_write_spte(sptep, old_spte);
 	else
@@ -789,7 +802,7 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 		if (!is_shadow_present_pte(new_spte))
 			remove_external_spte(kvm, gfn, old_spte, level);
 		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
-			split_external_spt(kvm, gfn, old_spte, new_spte, level);
+			split_external_spt(kvm, gfn, old_spte, new_spte, level, false);
 		else
 			KVM_BUG_ON(1, kvm);
 	}
@@ -1308,8 +1321,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
 		if (is_shadow_present_pte(iter.old_spte)) {
-			/* Don't support large page for mirrored roots (TDX) */
-			KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
 		} else {
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8a60ba5b6595..035d81275be4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1941,7 +1941,7 @@ static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
 }
 
 static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				      void *private_spt)
+				      void *private_spt, bool mmu_lock_shared)
 {
 	struct page *page = virt_to_page(private_spt);
 	int ret;
@@ -1950,6 +1950,12 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level
 		       level != PG_LEVEL_2M, kvm))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(mmu_lock_shared)) {
+		pr_warn_once("Splitting of GFN %llx level %d under shared lock occurs when KVM does not support it yet\n",
+			     gfn, level);
+		return -EOPNOTSUPP;
+	}
+
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
 		return ret;
-- 
2.43.2


