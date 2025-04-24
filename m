Return-Path: <kvm+bounces-44040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E55A99F53
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DEBC17F6FD
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4702C1A9B40;
	Thu, 24 Apr 2025 03:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uft4JMfJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCFD1A23AC;
	Thu, 24 Apr 2025 03:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464109; cv=none; b=gAh+N3v7P2bzR9bF1Fls37FNArsLIPRx5x4FoOg7fl2JudRrS/bPpEfxnGx2ju5A6CgEJ023xAvfNaG6ILljNcVrhKeAeCiwU11wXnsBOIs4JIl7/2g5GAWaDwbqgr3PRvrQbzSQKYLWQGCdaHDXn9mG2+gHJNyCoBV9GgjOtQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464109; c=relaxed/simple;
	bh=mhjtVrJ8qBt5CsQJUNaQTk+Zdl0pnCltrFFjNbwUZvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRuOO1+Ol88Xm0nimJPnyArjziwXIuvrT/H5oMY5Wr5ZFwkPoDH5eVUj/w7qi+i0GXzsAwjyO4ZEJT+P9oNT30Me3vvV51LxjX90/t2oIGqV/ZsqnqHXJXGpU2xy8aHn+Hr+R5OJZwWhP6sR/zPMC7oyZphYOIwDHhmmdCw9y/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uft4JMfJ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464108; x=1777000108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mhjtVrJ8qBt5CsQJUNaQTk+Zdl0pnCltrFFjNbwUZvw=;
  b=Uft4JMfJWIfxPEh24392x979S4cNqUr8UOUXMp12/6jC0TAYSowQE76F
   AAo8TrmkdMUszlPxMcyFugCZGv/IJXHzREpRZUSYLl8cemmHCaXGAM74o
   OiD9rJc8jtxmsUxJTdSSSrKGK/KaPbrlTQQQmgo4eAHIZRyyMJfvOqpty
   XPnAvChDrlB+d8lY1A9ZqNoVR4scMNsug/1dXbd4LoufpeLGFtA5ICndo
   ZR2ciui3IUF4V/EsAfHbHYGbaLwZW2b3Duy3njcg+1EKMxFB4cGq549b/
   t5nBE/pmixQJFtL9uBH6SykDyV7GSFuJxi2dbxsBxIJS4JkPeTxM6Sq/D
   w==;
X-CSE-ConnectionGUID: ygFYWCmlT2iNU7q2UoZq2w==
X-CSE-MsgGUID: vsCD6VOVQ/qbDWt9q8pDnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47255845"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47255845"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:08:27 -0700
X-CSE-ConnectionGUID: lnFZ44agSUy+KR/aynQXhQ==
X-CSE-MsgGUID: xkBGzm1vSR+qYvM70t/8EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132222656"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:08:21 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com,
	kirill.shutemov@intel.com, tabba@google.com, ackerleytng@google.com,
	quic_eberman@quicinc.com, michael.roth@amd.com, david@redhat.com,
	vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
	thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
	fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, chao.p.peng@intel.com,
	Edgecombe@web.codeaurora.org, Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page adjustment) for mirror root
Date: Thu, 24 Apr 2025 11:06:34 +0800
Message-ID: <20250424030634.369-1-yan.y.zhao@intel.com>
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

From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>

Disallow page merging (huge page adjustment) for mirror root by leveraging
the disallowed_hugepage_adjust().

[Yan: Passing is_mirror to disallowed_hugepage_adjust()]

Signed-off-by: Edgecombe, Rick P <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 6 +++---
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 7 ++++---
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a284dce227a0..b923deeeb62e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3326,13 +3326,13 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	fault->pfn &= ~mask;
 }
 
-void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level)
+void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level, bool is_mirror)
 {
 	if (cur_level > PG_LEVEL_4K &&
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte) &&
-	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
+	    (spte_to_child_sp(spte)->nx_huge_page_disallowed || is_mirror)) {
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch),
 		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
@@ -3363,7 +3363,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * large page, as the leaf could be executable.
 		 */
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
+			disallowed_hugepage_adjust(fault, *it.sptep, it.level, false);
 
 		base_gfn = gfn_round_for_level(fault->gfn, it.level);
 		if (it.level == fault->goal_level)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de62..1c1764f46e66 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
+void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level, bool is_mirror);
 
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 68e323568e95..1559182038e3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -717,7 +717,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * large page, as the leaf could be executable.
 		 */
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
+			disallowed_hugepage_adjust(fault, *it.sptep, it.level, false);
 
 		base_gfn = gfn_round_for_level(fault->gfn, it.level);
 		if (it.level == fault->goal_level)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 405874f4d088..8ee01277cc07 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1244,6 +1244,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
+	bool is_mirror = is_mirror_sp(root);
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
@@ -1254,8 +1255,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
-		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
+		if (fault->nx_huge_page_workaround_enabled || is_mirror)
+			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level, is_mirror);
 
 		/*
 		 * If SPTE has been frozen by another thread, just give up and
@@ -1278,7 +1279,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 */
 		sp = tdp_mmu_alloc_sp(vcpu);
 		tdp_mmu_init_child_sp(sp, &iter);
-		if (is_mirror_sp(sp))
+		if (is_mirror)
 			kvm_mmu_alloc_external_spt(vcpu, sp);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
-- 
2.43.2


