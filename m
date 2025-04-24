Return-Path: <kvm+bounces-44044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D07A99F5A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 018927B0EB1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A501AAA2F;
	Thu, 24 Apr 2025 03:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jl4Empt7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8151A3BC0;
	Thu, 24 Apr 2025 03:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464180; cv=none; b=KJdVeVF6AAfjz75QWW0hgMxihShrAf1pX8NLd10EYx8K+Yf68nyVCNqcGDvuf8s/d3sqJIBi+zAbUzCl/402i1YxXP7sTQe/Q0x2HdFgZCqO3wyTkZZNnIafcnbv9jqlkjFgxLRUq6wO7J+DiSSSKg1+SuVfv1lrQt44vF6Gj08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464180; c=relaxed/simple;
	bh=YdSFshmGq8zPBH68uzJJEmxWC6zTa/c0cywoRbucihE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLT+MrMv8qSYeh6guWAk9BE6pELxaxsY0xOiwtvlvzTBKqNBekCx8OVAg+QoWV8HKmQiEqF9rW4VItQvokg2+mAd8TYDVf4o5a8qZrDpPUQGeqrxtPPXvyWMdV0AXRMPhTi96zZzpaRH3CttUoegJ6GY80fMfHwa/E7v1UXx4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jl4Empt7; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464178; x=1777000178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YdSFshmGq8zPBH68uzJJEmxWC6zTa/c0cywoRbucihE=;
  b=Jl4Empt7XisMF9qZ5xPaDUjy2m5GJ1LjArKmeDxqRkXzVrdu+OMpKGxw
   +NZGSAK8c4+VIumMXMEUg/ad3xZV1CZ0ECRFBtOQLoZZu+Kssxwgh+GeV
   EAuF1IW7fOsEGbkvGSthomMk0pL+ctx5DLsF+cGa8XZVnjbpC0ivRmyKc
   i3tdl/pt9JsOJN2ZGI0UaJJ044dP65x10W5Oz8cM7zATMP5dZNjVY6O5O
   /Za9Mwys6N/4yB/WnEapP69IgpkkdmQ2BPfDvdxwoCqrupDeoc9HVmgdD
   3Uewtc7h8RaeJWi4sTy8zOxBJ5/6i8XD7erVBnM0LvgntEOlrddsdmnaW
   g==;
X-CSE-ConnectionGUID: s7hK2oU4SvqDgE1R36+2Kg==
X-CSE-MsgGUID: EP5Uu31gQze8hxKCSPV/yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="58072852"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="58072852"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:37 -0700
X-CSE-ConnectionGUID: KkTkHuv+St6xpKLZJBIUAQ==
X-CSE-MsgGUID: u941jiNdSUukcLiF/XlhEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137659140"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:30 -0700
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
Subject: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt hook with exclusive mmu_lock
Date: Thu, 24 Apr 2025 11:07:44 +0800
Message-ID: <20250424030744.435-1-yan.y.zhao@intel.com>
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

Introduce the split_external_spt hook and call it within tdp_mmu_set_spte()
for the mirror page table when kvm->mmu_lock is held for writing.

When tdp_mmu_set_spte() is invoked to transition an old leaf SPTE to a new
non-leaf SPTE in the mirror page table, use the split_external_spt hook to
propagate the entry splitting request to the external page table.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  4 ++++
 arch/x86/kvm/mmu/tdp_mmu.c         | 26 ++++++++++++++++++++------
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 79406bf07a1c..f8403e0f6c1e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -99,6 +99,7 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP_OPTIONAL(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(split_external_spt)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f96d30ad4ae8..6962a8a424ef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1812,6 +1812,10 @@ struct kvm_x86_ops {
 	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				    kvm_pfn_t pfn_for_gfn);
 
+	/* Split the external page table into smaller page tables */
+	int (*split_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				  void *external_spt);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 799a08f91bf9..0f683753a7bb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -325,6 +325,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				bool shared);
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror);
+static void *get_external_spt(gfn_t gfn, u64 new_spte, int level);
 
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -384,6 +385,19 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	KVM_BUG_ON(ret, kvm);
 }
 
+static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+			      u64 new_spte, int level)
+{
+	void *external_spt = get_external_spt(gfn, new_spte, level);
+	int ret;
+
+	KVM_BUG_ON(!external_spt, kvm);
+
+	ret = static_call(kvm_x86_split_external_spt)(kvm, gfn, level, external_spt);
+	KVM_BUG_ON(ret, kvm);
+
+	return ret;
+}
 /**
  * handle_removed_pt() - handle a page table removed from the TDP structure
  *
@@ -764,13 +778,13 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 
-	/*
-	 * Users that do non-atomic setting of PTEs don't operate on mirror
-	 * roots, so don't handle it and bug the VM if it's seen.
-	 */
 	if (is_mirror_sptep(sptep)) {
-		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
-		remove_external_spte(kvm, gfn, old_spte, level);
+		if (!is_shadow_present_pte(new_spte))
+			remove_external_spte(kvm, gfn, old_spte, level);
+		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
+			split_external_spt(kvm, gfn, old_spte, new_spte, level);
+		else
+			KVM_BUG_ON(1, kvm);
 	}
 
 	return old_spte;
-- 
2.43.2


