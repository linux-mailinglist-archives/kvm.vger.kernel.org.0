Return-Path: <kvm+bounces-9640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E228D866C55
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FA2A1C21D0D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B638C535C8;
	Mon, 26 Feb 2024 08:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hffJbi5x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB6E50A68;
	Mon, 26 Feb 2024 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936069; cv=none; b=mqaolWkBKHTkWGBS+VHTcwPlXd+AckwWLGYaMSq7GynlsmAzwthbQkyeQ8zMoheXfNdBycCNoq6hhAy3YNS+NDSghzNXFqKpBBI4gwEEbVJyQSUCQXDmOQ3g6YE04EWdc4kkfR2BXoR5MRuEcb5/Fr3au1CxQl9ETk3yZOexXr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936069; c=relaxed/simple;
	bh=GqHoLR8nZGd0nBBjdIPWykKQiMpqYqCouXVMjthiwa8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JFePOq7ChUDEcekOi3iewSjsOsB5n3RBaGvhXt/N1z2ECwFvAS0SAQ8qKbqaCmrpOn3cjE6O1zPClBJ5xCpk4MGD1/yz0FHDsE72+oGGgv5gCX+LRUeGuoEpTHQGy992blD8dv5vDkiic5S/ZecaMYgDg43iFXuZD+8wWA8INOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hffJbi5x; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936068; x=1740472068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GqHoLR8nZGd0nBBjdIPWykKQiMpqYqCouXVMjthiwa8=;
  b=hffJbi5x2K/2siNEXQ1FVjo2ysr0bPi9K2Df481tpULsmHv/EWg0J7S6
   tuRzhg0Eo8pz2mc5ql5oAA+cBb5fYGVbnNH9gTINHMM/Ze/DYURmmC9vT
   /LtPuP/HhaNLfORLkycSUunGQDFGpaM60hQNTccnGaCPT8zPgyCoDbn7I
   j2pZqcgAx3eatwrrPrMNTVcIuodzzOgBVG50Z1ZGzter9ZuOpCKjs3NjR
   mR2v33sblytVbMxOmvc1WsW5jY20vMS36sHnDxWTkLdU2LVN16I8Cas9G
   WsyakamYJ1yPI3XqY+tzT33WhsIwRarQYj/POhsZpubc2286ZiXc4vD8j
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631493"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631493"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474345"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:43 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v19 016/130] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
Date: Mon, 26 Feb 2024 00:25:18 -0800
Message-Id: <b2b7eeb1bab4cbf5421bf18647357a59b472dabe.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

Introduce a helper to directly (pun intended) fault-in a TDP page
without having to go through the full page fault path.  This allows
TDX to get the resulting pfn and also allows the RET_PF_* enums to
stay in mmu.c where they belong.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- Move up for KVM_MEMORY_MAPPING.
- Add goal_level for the caller to know how many pages are mapped.

v14 -> v15:
- Remove loop in kvm_mmu_map_tdp_page() and return error code based on
  RET_FP_xxx value to avoid potential infinite loop.  The caller should
  loop on -EAGAIN instead now.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..d96c93a25b3b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			 u8 max_level, u8 *goal_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61674d6b17aa..ca0c91f14063 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4615,6 +4615,64 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			 u8 max_level, u8 *goal_level)
+{
+	int r;
+	struct kvm_page_fault fault = (struct kvm_page_fault) {
+		.addr = gpa,
+		.error_code = error_code,
+		.exec = error_code & PFERR_FETCH_MASK,
+		.write = error_code & PFERR_WRITE_MASK,
+		.present = error_code & PFERR_PRESENT_MASK,
+		.rsvd = error_code & PFERR_RSVD_MASK,
+		.user = error_code & PFERR_USER_MASK,
+		.prefetch = false,
+		.is_tdp = true,
+		.is_private = error_code & PFERR_GUEST_ENC_MASK,
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
+	};
+
+	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
+	fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	fault.max_level = max_level;
+	fault.req_level = PG_LEVEL_4K;
+	fault.goal_level = PG_LEVEL_4K;
+
+#ifdef CONFIG_X86_64
+	if (tdp_mmu_enabled)
+		r = kvm_tdp_mmu_page_fault(vcpu, &fault);
+	else
+#endif
+		r = direct_page_fault(vcpu, &fault);
+
+	if (is_error_noslot_pfn(fault.pfn) || vcpu->kvm->vm_bugged)
+		return -EFAULT;
+
+	switch (r) {
+	case RET_PF_RETRY:
+		return -EAGAIN;
+
+	case RET_PF_FIXED:
+	case RET_PF_SPURIOUS:
+		if (goal_level)
+			*goal_level = fault.goal_level;
+		return 0;
+
+	case RET_PF_CONTINUE:
+	case RET_PF_EMULATE:
+	case RET_PF_INVALID:
+	default:
+		return -EIO;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.25.1


