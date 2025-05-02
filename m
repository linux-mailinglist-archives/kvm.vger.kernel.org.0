Return-Path: <kvm+bounces-45228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DF7AA72F7
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF85C4E0A84
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53BF2580F4;
	Fri,  2 May 2025 13:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVsLqJH4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A42566E3;
	Fri,  2 May 2025 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191329; cv=none; b=uZPy254i3uIfKhD8i4rKU032ronlIoYLnVvmPXXgvE+GEb3gRe3qjUcL8e8mD+hkoSp8MVAEDBq6aPekLtBFvjks7itn4nReSs38rxLRVEyHOVHZL5liRuMmgcxO67yAOpfrtd1aJUYJnzMu+qQsU5NxrNg7Po9MXMPgmBIT0T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191329; c=relaxed/simple;
	bh=EA7G0eYYU+Fzt6HFAAauj8vAuuhBCOFdQK2LisRs3Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZwXJjqCJgukuDnveaF4yyPp6uR1xkNj9rueuZoJRVcyQd4Vt6jU+T4K4Zi21wjuBWMTBVlYyEw+WDwMbNR4ZeZFbgxE9P7SVfGzmvx4SuLx9GAXd8MXny0Bfj7tsM85yncmWlmwwbnLgO89HEBp9Y9Q0R3v06nTw8c9zoQumZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVsLqJH4; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191327; x=1777727327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EA7G0eYYU+Fzt6HFAAauj8vAuuhBCOFdQK2LisRs3Ro=;
  b=mVsLqJH42TMHW0e96BlpoN7tBYLWI3OBtSp3A83IBUw944VHjaBkqZSN
   7kmOFvV1XxooctEYfHdfLOCV6DS1eZXNjr8GhqftaWvBXJA6ZHKWxL/TH
   IvdK0yo7VqXCF2YMOw2zu+jKftXfB/slrrDwQZgqHQ1EHbT57b01LDsgU
   IXhPUSiUFX7Vqn+THS41aIv7jEumc91nWP7KlWv1zHdZUty76fr3duFvL
   n3QuxB9bH93xvLbAI6Vb6fWpirQyq+lwFBSGyjHfGYQLTR2cGKuB/SwTc
   XHbip9Obq/Yu5ZzVobPjBlM/NtUIPjvoDGIOyx2swX9RsL3I5eiQjMxG4
   g==;
X-CSE-ConnectionGUID: RHT6O2fBQt2be54mHDDREw==
X-CSE-MsgGUID: 0tERy6K8SlOdD0Yms5fLkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="48013003"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="48013003"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:45 -0700
X-CSE-ConnectionGUID: JDHTPLdtRNylud+KIJttpg==
X-CSE-MsgGUID: EBR059RXSo2bT5ZO4EBvmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="157871092"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 02 May 2025 06:08:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 7235735D; Fri, 02 May 2025 16:08:36 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and phys_cleanup() to kvm_x86_ops
Date: Fri,  2 May 2025 16:08:24 +0300
Message-ID: <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The functions kvm_x86_ops::link_external_spt() and
kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
When using TDX with Dynamic PAMT enabled, the assigned memory must be
covered by PAMT.

The new function kvm_x86_ops::phys_prepare() is called before
link_external_spt() and set_external_spte() to ensure that the memory is
ready to be assigned to the virtual machine. In the case of TDX, it
makes sure that the memory is covered by PAMT.

kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
is available, allowing the implementation to allocate memory from a
per-VCPU pool.

The function kvm_x86_ops::phys_cleanup() frees PAMT memory in case of
failure.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  3 ++
 arch/x86/kvm/mmu/tdp_mmu.c         | 47 +++++++++++++++++++++++++++---
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 79406bf07a1c..37081d04e82f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -99,6 +99,8 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP_OPTIONAL(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(phys_prepare)
+KVM_X86_OP_OPTIONAL(phys_cleanup)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c06f3d6e081..91958c55f918 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1813,6 +1813,9 @@ struct kvm_x86_ops {
 	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				    kvm_pfn_t pfn_for_gfn);
 
+	int (*phys_prepare)(struct kvm_vcpu *vcpu, kvm_pfn_t pfn);
+	void (*phys_cleanup)(kvm_pfn_t pfn);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 405874f4d088..f6c836b2e6fc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1137,6 +1137,26 @@ void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 	}
 }
 
+static int tdp_mmu_install_spte(struct kvm_vcpu *vcpu,
+				struct tdp_iter *iter,
+				u64 spte)
+{
+	kvm_pfn_t pfn = 0;
+	int ret = 0;
+
+	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(spte)) {
+		pfn = spte_to_pfn(spte);
+		ret = static_call(kvm_x86_phys_prepare)(vcpu, pfn);
+	}
+	if (ret)
+		return ret;
+	ret = tdp_mmu_set_spte_atomic(vcpu->kvm, iter, spte);
+	if (pfn && ret)
+		static_call(kvm_x86_phys_cleanup)(pfn);
+
+	return ret;
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
@@ -1170,7 +1190,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (tdp_mmu_install_spte(vcpu, iter, new_spte))
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 (!is_last_spte(iter->old_spte, iter->level) ||
@@ -1211,7 +1231,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
  * Returns: 0 if the new page table was installed. Non-0 if the page table
  *          could not be installed (e.g. the atomic compare-exchange failed).
  */
-static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
+static int __tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 			   struct kvm_mmu_page *sp, bool shared)
 {
 	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled);
@@ -1230,6 +1250,25 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
+static int tdp_mmu_link_sp(struct kvm_vcpu *vcpu, struct tdp_iter *iter,
+			   struct kvm_mmu_page *sp, bool shared)
+{
+	kvm_pfn_t pfn = 0;
+	int ret = 0;
+
+	if (sp->external_spt) {
+		pfn = __pa(sp->external_spt) >> PAGE_SHIFT;
+		ret = static_call(kvm_x86_phys_prepare)(vcpu, pfn);
+		if (ret)
+			return ret;
+	}
+	ret = __tdp_mmu_link_sp(vcpu->kvm, iter, sp, shared);
+	if (pfn && ret)
+		static_call(kvm_x86_phys_cleanup)(pfn);
+
+	return ret;
+}
+
 static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 				   struct kvm_mmu_page *sp, bool shared);
 
@@ -1288,7 +1327,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
 		} else {
-			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
+			r = tdp_mmu_link_sp(vcpu, &iter, sp, true);
 		}
 
 		/*
@@ -1514,7 +1553,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
+	ret = __tdp_mmu_link_sp(kvm, iter, sp, shared);
 	if (ret)
 		goto out;
 
-- 
2.47.2


