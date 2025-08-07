Return-Path: <kvm+bounces-54232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F71B1D50C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E104C7B3300
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECDC2641FC;
	Thu,  7 Aug 2025 09:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="elmrrkRu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFEA262FEB;
	Thu,  7 Aug 2025 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559813; cv=none; b=uPMwocLtKav8TVpZLUGNyKcv5uVFF8Gqj/NhlNqQOE7FpOi8WaXtta7i9kTxfj89GToIPyhAW5Q/UAZ2mr81B+1qI2sxJsZVoNdpWJPDdDWakrMCYSVBWUrRJh/VeQfDHtV/ASD8xYl1LCjiXjaH+/ApYsKd4qJukC4NKhqFOLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559813; c=relaxed/simple;
	bh=jG0dXddaFAFFtC/F5TN5N2u7d3qnPPif9gJcxx2UvwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm2ZFXUJaPrsxMQ9FiVz4lZ4+RgKDjvsjxTKW6Mf9iJjf2f63W8K1CdtE7bkQTYxGgNo62aSkbOcaqJbRGlGVmwQ7MuLYU4EZ3sA3dDjaVk9IirxyEeyED8E5hhMBMkiGULHKxxnWFeVPLJ/OdbQgx5wDBJ5ahLwE8jTLH/A2ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=elmrrkRu; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559812; x=1786095812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jG0dXddaFAFFtC/F5TN5N2u7d3qnPPif9gJcxx2UvwY=;
  b=elmrrkRuSEnhPpjm+s9pkxWNrVEQej27zzlZhDRNrgZ+con31k7IXUfx
   gByRMh5qBY1YQhjKFgIiCZ/I3Roib/GC1lFZgQnS+gSazSDFIayn7zA09
   XxmGdxeTemi4Uzlk2PmyPV0x0N57n6pWhCQIm9gdnPyhYVTJ4bkKURlOh
   Ywm1gILCYYmbm9V7bleuNMr/2CaVEdum1Zl8LdkgxjDcey2AwiYjtNYvL
   9gqpH5BBnvnMuqABtaxIGY5X7tVlfrTqLMUjuTDPC/vRJ5LwEqsoTxX6y
   fLfH+RdYLa2bR711B18fw9tDxhquoBha0teTzD96e0GJ46ErCDjKd49XH
   A==;
X-CSE-ConnectionGUID: pt6Np0cyScWW1Vwax2kLSA==
X-CSE-MsgGUID: o/XLMNHpQgSLmh8QhCIt5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68265958"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68265958"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:31 -0700
X-CSE-ConnectionGUID: cwC410AMSP6PgX2xfXXHkw==
X-CSE-MsgGUID: FAbwfQUlT6iGJlPrnA8KEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="196006896"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:23 -0700
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
Subject: [RFC PATCH v2 07/23] KVM: x86/mmu: Disallow page merging (huge page adjustment) for mirror root
Date: Thu,  7 Aug 2025 17:42:54 +0800
Message-ID: <20250807094254.4537-1-yan.y.zhao@intel.com>
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
index 3f76415cec71..9182192daa3a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3412,7 +3412,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
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
index bb95c95f6531..f9a054754544 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1243,6 +1243,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
+	bool hugepage_adjust_disallowed = fault->nx_huge_page_workaround_enabled ||
+					  kvm_has_mirrored_tdp(kvm);
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
@@ -1253,7 +1255,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
-		if (fault->nx_huge_page_workaround_enabled)
+		if (hugepage_adjust_disallowed)
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		/*
-- 
2.43.2


