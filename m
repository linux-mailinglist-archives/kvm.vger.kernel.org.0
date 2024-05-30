Return-Path: <kvm+bounces-18452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE318D544B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF58F1C24A87
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9AC158DCF;
	Thu, 30 May 2024 21:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IHr5zb9A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DCC19DF74;
	Thu, 30 May 2024 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103263; cv=none; b=gKGrt182JuePRwWSh356/QKYj2AuawbOUHUUgUm4UaD751JCF3KiA2mlqU6isED2urn//0jv1r2P8V/BIpVilHrXpLb09d1y47IwWB69eKX+jBRH3sf8heZU3ksNDqENnYM4ygXFJWSp2b7CQDw6hMtTXsQbjn3W9mTv8gwv0r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103263; c=relaxed/simple;
	bh=RhOrvlDCB6yJXtvahjiMpZSvhsMFBEPAMKead2giHm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AgHEqy54W8HHYrZDf7v85tixLoFJENqBXD4op7zeISdXeh3d+5wugCKYQfSQVWd39xQ1SEsEWDQg/zHzZiCsDedrW0rbfDIkuEcMeECTBOnADttHp56k54U57p/321YfxN71fm/ZL28e8aBRT5zUkD/liJxHR5f6LwnY2YysSFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IHr5zb9A; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103262; x=1748639262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RhOrvlDCB6yJXtvahjiMpZSvhsMFBEPAMKead2giHm4=;
  b=IHr5zb9AKd6zQd6wqatpHP+Mz6QV+8q2n/0/IaMKLD9NmTMlWasYBo63
   wOV6r6brWQiAD3FBQOhXI7/fw7SxFGn5Bi7ogctC+yEs3P5kOjPDElmfJ
   +MOp4RZnG1YU9L497aYsLsImmPjBqUkIWT6yBdxAQ51gkWrzKfpwuBmmo
   De8yNIPZyHu5Wmtvi+V1k+3C6ysi4JGzER0TdpoGjDAWoqLRtjkw8Z5+o
   HJywS9znTY5mzUSmhrKfNWlpL/6eo310Q0Yx8XcidQ29GrgMIyxtnYJBz
   BpJ9E7nXbL+xPWKruxSFWwHI/dHTYw/AXyvmWGLaYD4sHkLFc7dcQ2Yxx
   A==;
X-CSE-ConnectionGUID: FXT/3HIwTO+I3FF4huNzMg==
X-CSE-MsgGUID: f7c+nIkHQLuxcxdBJ+s3aw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117160"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117160"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:41 -0700
X-CSE-ConnectionGUID: jHJoLRZrQpiBy/3iK8O+fw==
X-CSE-MsgGUID: b3anRiYBSW+HuFOdBRo+Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874471"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:40 -0700
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
Subject: [PATCH v2 15/15] KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
Date: Thu, 30 May 2024 14:07:14 -0700
Message-Id: <20240530210714.364118-16-rick.p.edgecombe@intel.com>
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

Export a function to walk down the TDP without modifying it.

Future changes will support pre-populating TDX private memory. In order to
implement this KVM will need to check if a given GFN is already
pre-populated in the mirrored EPT, and verify the populated private memory
PFN matches the current one.[1]

There is already a TDP MMU walker, kvm_tdp_mmu_get_walk() for use within
the KVM MMU that almost does what is required. However, to make sense of
the results, MMU internal PTE helpers are needed. Refactor the code to
provide a helper that can be used outside of the KVM MMU code.

Refactoring the KVM page fault handler to support this lookup usage was
also considered, but it was an awkward fit.

Link: https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/ [1]
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
This helper will be used in the future change that implements
KVM_TDX_INIT_MEM_REGION. Please refer to the following commit for the
usage:
https://github.com/intel/tdx/commit/9594fb9a0ab566e0ad556bb19770665319d800fd

TDX MMU Prep v2:
 - Rename function with "mirror" and use root enum

TDX MMU Prep:
 - New patch
---
 arch/x86/kvm/mmu.h         |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c | 39 +++++++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 006f06463a27..625a57515d48 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -275,6 +275,8 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
+int kvm_tdp_mmu_get_walk_mirror_pfn(struct kvm_vcpu *vcpu, u64 gpa, kvm_pfn_t *pfn);
+
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0caa1029b6bd..897d8aa1f544 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1946,16 +1946,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  *
  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
+static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+				  enum kvm_tdp_mmu_root_types root_type)
 {
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, root_type);
 	struct tdp_iter iter;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->root_role.level;
-
 	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
@@ -1964,6 +1962,37 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return leaf;
 }
 
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
+{
+	*root_level = vcpu->arch.mmu->root_role.level;
+
+	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, KVM_DIRECT_ROOTS);
+}
+
+int kvm_tdp_mmu_get_walk_mirror_pfn(struct kvm_vcpu *vcpu, u64 gpa,
+				     kvm_pfn_t *pfn)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
+	int leaf;
+
+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
+
+	rcu_read_lock();
+	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, KVM_MIRROR_ROOTS);
+	rcu_read_unlock();
+	if (leaf < 0)
+		return -ENOENT;
+
+	spte = sptes[leaf];
+	if (!(is_shadow_present_pte(spte) && is_last_spte(spte, leaf)))
+		return -ENOENT;
+
+	*pfn = spte_to_pfn(spte);
+	return leaf;
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_mmu_get_walk_mirror_pfn);
+
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
-- 
2.34.1


