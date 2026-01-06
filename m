Return-Path: <kvm+bounces-67114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 330D0CF7C45
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A3442300EE70
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E082326944;
	Tue,  6 Jan 2026 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Evrnd25y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED3B326920;
	Tue,  6 Jan 2026 10:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694950; cv=none; b=cm+ytx1yqIohDR0q69AclIy/JiH8Wc1w/yeGLgdsh7WLB/al+podmRBh57RHu8dMTg9+OvqZXi8YXQyb2jfDjK9GANQjIujZVN1jAnzeWEPjRcof/CCVyS8ep6lBpknGM1YA5iqW5C0OW/Jg1wFoIQG2I8P7+v1wQaDqjc6DfFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694950; c=relaxed/simple;
	bh=GFGrz/CXi/RxbvHEabGemFFSeHhuI34AKA6B/kIEpxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnJ62WocRTGp/8ZUQGt523AgZz6cC264bTeiplyNlbK15ak70ftdZtjhy6wF/nQK7G/Qkj+VXKvlnQ+XKxvKue1+fKkufFEB/ciePr3qvx8e/oPSfgU4YXKzno3kwqV+GFSbVavkkIX2tEDJR7AsFzm+mdeCvU7VgZcb8/3GcA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Evrnd25y; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694948; x=1799230948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GFGrz/CXi/RxbvHEabGemFFSeHhuI34AKA6B/kIEpxc=;
  b=Evrnd25y8UKd6SD3LkkalxyrKm9olr/pBW70anvk+f3mE97BkDFai0X4
   Suf3SYePOeuO+ftOQc/lqhsy8N8u/uoPHh99+IIqUWRN9EVJ4p9yWTF2A
   +hmCetI2wWvwEwKLzV7b/LnLgd8NwGSL/cq237cpZbuacrlNQqaKFS4Hk
   FaLkLkr77Vid31iUlJRBliuSq+An512zQoO7Rp+L3bhXUfNM9JIOo0fqi
   jQ8lgNMD84cigYf76ikMNXlNEp2jh7FuZISwWKEmxtLFcsUUgpNozcg/C
   m2npeph6ahy9jGPzSDVfAFGwKmXcLbbt3De2aB0Ajf2nuEnVpWnx9N0nA
   w==;
X-CSE-ConnectionGUID: iAHHcfajTSWGjQ7zetfurQ==
X-CSE-MsgGUID: ilmTcysXQ8GERKMY2HWZBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68966617"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68966617"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:28 -0800
X-CSE-ConnectionGUID: 4sIsfgaITKafd/iH8wW7Sw==
X-CSE-MsgGUID: sHG+fAR2TvSsgKlp1x31AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207175372"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:21 -0800
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
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 06/24] KVM: x86/mmu: Disallow page merging (huge page adjustment) for mirror root
Date: Tue,  6 Jan 2026 18:20:24 +0800
Message-ID: <20260106102024.25023-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>

Disallow page merging (huge page adjustment) for the mirror root by
utilizing disallowed_hugepage_adjust().

Make the mirror root check asymmetric with NX huge pages and not to litter
the generic MMU code:

Invoke disallowed_hugepage_adjust() in kvm_tdp_mmu_map() when necessary,
specifically when KVM has mirrored TDP or the NX huge page workaround is
enabled.

Check and reduce the goal_level of a fault internally in
disallowed_hugepage_adjust() when the fault is for a mirror root and
there's a shadow present non-leaf entry at the original goal_level.

Signed-off-by: Edgecombe, Rick P <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Check is_mirror_sp() in disallowed_hugepage_adjust() instead of passing
  in an is_mirror arg. (Rick)
- Check kvm_has_mirrored_tdp() in kvm_tdp_mmu_map() to determine whether
  to invoke disallowed_hugepage_adjust(). (Rick)

RFC v1:
- new patch
---
 arch/x86/kvm/mmu/mmu.c     | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d2c49d92d25d..b4f2e3ced716 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3418,7 +3418,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte) &&
-	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
+	    ((spte_to_child_sp(spte)->nx_huge_page_disallowed) ||
+	     is_mirror_sp(spte_to_child_sp(spte)))) {
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch),
 		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9c26038f6b77..dfa56554f9e0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1267,6 +1267,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
+	bool hugepage_adjust_disallowed = fault->nx_huge_page_workaround_enabled ||
+					  kvm_has_mirrored_tdp(kvm);
 
 	KVM_MMU_WARN_ON(!root || root->role.invalid);
 
@@ -1279,7 +1281,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
-		if (fault->nx_huge_page_workaround_enabled)
+		if (hugepage_adjust_disallowed)
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		/*
-- 
2.43.2


