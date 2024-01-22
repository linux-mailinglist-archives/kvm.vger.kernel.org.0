Return-Path: <kvm+bounces-6655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DD8837839
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80B382924B5
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD124F8A1;
	Mon, 22 Jan 2024 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dwZ2t8AF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D9667751;
	Mon, 22 Jan 2024 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967758; cv=none; b=kFJrIH9KuZMyErzn/k5pyHJXSUARwQgPQ2mOZVd9BggHNjEKSiXFVtHkNN+UtWpPl4PtVyPYfoDBmyim2dxW5No+fAPGm0M9byGjA4ZM1pOwef6E5i+vxZmmUSBwdGJWojb5u/K3qFHZRyv9cTXBBdgy6V4e87lHVrLCVYQhPN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967758; c=relaxed/simple;
	bh=FRxdRt8ccEie5mybzd3cHLcNjRG7Fi7o3/8qAdmP2sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JJiiTneyYiDCa4tUF/zA2ITmPsldH60PUOXr5wvUsaQTTJq28E87ZmvWJsz5VZcPoEQvtrqj01U5j1/iedVk7cwXNJ4G6dAQStxN2lIsKPprgovFITEKg3ns1QhlMXDncpAC2RfrBBVEQMZHbn9VLb4cC6P64ZSxNOzHwWadZAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dwZ2t8AF; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967756; x=1737503756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FRxdRt8ccEie5mybzd3cHLcNjRG7Fi7o3/8qAdmP2sI=;
  b=dwZ2t8AFTO6vuT7GqOqY61BNJZWpw58R0zMB2fpWZaa+isFroj6CeDnb
   IuzyKSccrpkgr2WkR9nM7Z4pHNVSmO6KH7QqhsWjBR5tCBjy+NjrYUKTp
   6iULXGoOB8LZYwOkQ1pJ6US5IgSnTTSbAczCrL+5zREHHf0BhhP/DBAnA
   X5060JOA5oLN44JXdpZn4KM1OllvnJ/Dv77HZlJpz8rTxD13AVdCFNdDt
   RolUmgygZ+esX4sWNw79Wp8rln2odnDA9Ccw+rqSvpbHWG6GQcL9tc6Eg
   Zm/6avmBR8Zp4QSwwoIS1P8UsumQ5uGuaiqG6FU2y/kIoYjw/ROcuFQx3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016486"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016486"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468219"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:37 -0800
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
Subject: [PATCH v18 063/121] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
Date: Mon, 22 Jan 2024 15:53:39 -0800
Message-Id: <1a64f798b550dad9e096603e8dae3b6e8fb2fbd5.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
v14 -> v15:
- Remove loop in kvm_mmu_map_tdp_page() and return error code based on
  RET_FP_xxx value to avoid potential infinite loop.  The caller should
  loop on -EAGAIN instead now.
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bad6a1e43a54..ebf91b605c37 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -184,6 +184,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			 int max_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7db152f46d82..26d215e85b76 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4635,6 +4635,63 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			 int max_level)
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
+	fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
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


