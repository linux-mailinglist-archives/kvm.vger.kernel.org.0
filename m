Return-Path: <kvm+bounces-64041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BB0E6C76D16
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:55:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 71A464E507A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4CD2D47E8;
	Fri, 21 Nov 2025 00:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C/kKLf12"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034DE2BEFFB;
	Fri, 21 Nov 2025 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686313; cv=none; b=XBFzJQAstaeDrFcNMIFf7nmUj0C6ymZ7z/miFvX7+JuRn0DTBgn/DZqKUtbK6tsagM+Ly9I3/iEdHcxN/hLaqSfZCu+xGdbSSgHDVLFEV7KOAJmET0Swjgd25eqz1jffqWMH9sl3CLHzVd1/dkchPdKWS4SGQeoWJToNF+oDdns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686313; c=relaxed/simple;
	bh=offIBt/bV1lfz1wf0hW8B+rpNbtyHBQVqfkKecJfyYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hbdf0Q68D6lTjk+E7XT4Z7+PTqYakKewKRDBA30RIejh0230qYzQJ1i/pX3BYYOj3lWx2B1Bm2wRW8zGJXlP0ySLv2wkKNMpVjoIeKRGqfJPFLN3+0UXudYC+nlFBeXp1i9lvvSRkky6Q4St45/SRKdT4B2jShO/eBycqdym6ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C/kKLf12; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686311; x=1795222311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=offIBt/bV1lfz1wf0hW8B+rpNbtyHBQVqfkKecJfyYI=;
  b=C/kKLf12FciGyY1pm11Ij/VXZVBRXddt7hKg+vxthfTKX5LU88SU85Fi
   hpjH7eMplMlPzvUKI+mPX2yPIMps/A/CbUt8hZnIMQEBCQmHtqarX80ew
   g1GHhUrqVnXTP9FBSwi7LLTDDibKXTw0dTO1hCwXVGc4JPrleyjeACDk7
   z1sowyem4KX3zgpVNQOyp8WT/vpio4hYB+5LOtoq4X3zeJyZ/HFcP8zbL
   OAf5SFPgA9mcb7I3co0oPoOq/+6M1kCRo01FNErkUvFVmG28fhbyx7P41
   94PCIRYXOSb605I9ZwhqCwksQqQ4SvUEziOleI/etNLFWfQnIHrt1DLyF
   w==;
X-CSE-ConnectionGUID: XhlTnacWTP6O/X1GtrlswQ==
X-CSE-MsgGUID: QDdx+zayQgupWqVpMIptXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780811"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780811"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:46 -0800
X-CSE-ConnectionGUID: ZFbe7ywYTTW1orqihqfo0w==
X-CSE-MsgGUID: l1a2sYzrQem7tBe73BQOFA==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:46 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 13/16] KVM: TDX: Handle PAMT allocation in fault path
Date: Thu, 20 Nov 2025 16:51:22 -0800
Message-ID: <20251121005125.417831-14-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Install PAMT pages for TDX call backs called during the fault path.

There are two distinct cases when the kernel needs to allocate PAMT memory
in the fault path: for SEPT page tables in tdx_sept_link_private_spt() and
for leaf pages in tdx_sept_set_private_spte().

These code paths run in atomic context. Previous changes have made the
fault path top up the per-VCPU pool for memory allocations. Use it to do
tdx_pamt_get/put() for the fault path operations.

In the generic MMU these ops are inside functions that don’t always
operate from the vCPU contexts (for example zap paths), which means they
don’t have a struct kvm_vcpu handy. But for TDX they are always in a vCPU
context. Since the pool of pre-allocated pages is on the vCPU, use
kvm_get_running_vcpu() to get the vCPU. In case a new path appears where
this is not the  case, leave some KVM_BUG_ON()’s.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Do prealloc.page_list initialization in tdx_td_vcpu_init() in case
   userspace doesn't call KVM_TDX_INIT_VCPU.

v3:
 - Use new pre-allocation method
 - Updated log
 - Some extra safety around kvm_get_running_vcpu()
---
 arch/x86/kvm/vmx/tdx.c | 44 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 61a058a8f159..24322263ac27 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -683,6 +683,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!irqchip_split(vcpu->kvm))
 		return -EINVAL;
 
+	INIT_LIST_HEAD(&tdx->prealloc.page_list);
+
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.apic->guest_apic_protected = true;
 	INIT_LIST_HEAD(&tdx->vt.pi_wakeup_list);
@@ -1698,8 +1700,15 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, u64 mirror_spte)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct page *page = pfn_to_page(pfn);
+	int ret;
+
+	if (KVM_BUG_ON(!vcpu, kvm))
+		return -EINVAL;
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
@@ -1708,6 +1717,10 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
 		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
 
+	ret = tdx_pamt_get(page, &tdx->prealloc);
+	if (ret)
+		return ret;
+
 	/*
 	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
 	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
@@ -1720,27 +1733,46 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * If the TD isn't finalized/runnable, then userspace is initializing
 	 * the VM image via KVM_TDX_INIT_MEM_REGION; ADD the page to the TD.
 	 */
-	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
-		return tdx_mem_page_add(kvm, gfn, level, pfn);
+	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
+		ret = tdx_mem_page_aug(kvm, gfn, level, pfn);
+	else
+		ret = tdx_mem_page_add(kvm, gfn, level, pfn);
 
-	return tdx_mem_page_aug(kvm, gfn, level, pfn);
+	if (ret)
+		tdx_pamt_put(page);
+
+	return ret;
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
-	gpa_t gpa = gfn_to_gpa(gfn);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct page *page = virt_to_page(private_spt);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
+	int ret;
+
+	if (KVM_BUG_ON(!vcpu, kvm))
+		return -EINVAL;
+
+	ret = tdx_pamt_get(page, &tdx->prealloc);
+	if (ret)
+		return ret;
 
 	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
 			       &level_state);
-	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
+		tdx_pamt_put(page);
 		return -EBUSY;
+	}
 
-	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
+	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm)) {
+		tdx_pamt_put(page);
 		return -EIO;
+	}
 
 	return 0;
 }
-- 
2.51.2


