Return-Path: <kvm+bounces-6645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A4B837823
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0834D28FEBA
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B0A664B3;
	Mon, 22 Jan 2024 23:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JomHLb/u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DFC64CDD;
	Mon, 22 Jan 2024 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967753; cv=none; b=m4IJ5ZuzTTdnARw037wXXcvvhrTtYwaEKK0DSWzvqfpeKpbAF1WG+gT0UiXmr8EYMZFpghOVApLs1MrF7mI4UznMXW/+WXlsSCWLH4Cvkzfl/lS8g/5uafmTORSUhRP5fU8SoV9s1gPcpYWsNctvDqwNddaFX9iU3LPwh0nP07k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967753; c=relaxed/simple;
	bh=AJiWF4nW/7gtuzb4Y7VNveONtsWoft8ZVCCZl/SxtbU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hS5t9ijtMziVYiK2irlaUj7n60wKK6NCA8WqV9dYUZiAmQChbipuGNVyFZiY2x6kenX0f9t3d51coKCg1BsJKQ5K1nwgjrlvq0xSGhjsykb+8Oyzf4wbbDRULgrG+1IKaxxXk0+L7/+9C5kqL7vb6ToGvsuc/2RRPE1ZS+cZbDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JomHLb/u; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967751; x=1737503751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AJiWF4nW/7gtuzb4Y7VNveONtsWoft8ZVCCZl/SxtbU=;
  b=JomHLb/uxWwUFaSOavSKQfqmoiFxz4Sm6cNilAxw6AOYDATNUVznTy57
   cMnWUAmYrkxUaR1hpVLVFfHHkyUuMsDZMNJW/ch9g/v5LodFBo6wcf+3f
   Pb2lSOIKrVa3TnwZ8dw8m5HhHZMLirXByB0IT1H1M5cuAA4Lg2S7oQAsQ
   0eDEXHL4fYZGDb9UFFVnYvbCXV/kHKv1GwJJ0nBZr4HiWb1LEFKbfIBgM
   wSCCIckjFUjdhA/4FtCjPY9BqAXJFZkl9mva4uwwD6jm+ubQ+VF2AMVb7
   4zx0bE1vQavfgzAJ11rjxUFjUBFNo7ZOWuvxJ+aZzvY+mBb5nTaRmRByw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016462"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016462"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468205"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:36 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 061/121] KVM: TDX: MTRR: implement get_mt_mask() for TDX
Date: Mon, 22 Jan 2024 15:53:37 -0800
Message-Id: <83048a3bba898a4a81215f3c62489b03e307d180.1705965635.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX virtualize cpuid[0x1].EDX[MTRR: bit 12] to fixed 1, guest TD
thinks MTRR is supported.  Although TDX supports only WB for private GPA,
it's desirable to support MTRR for shared GPA.  As guest access to MTRR
MSRs causes #VE and KVM/x86 tracks the values of MTRR MSRs, the remining
part is to implement get_mt_mask method for TDX for shared GPA.

Pass around shared bit from kvm fault handler to get_mt_mask method so that
it can determine if the gfn is shared or private.  Implement get_mt_mask()
following vmx case for shared GPA and return WB for private GPA.
the existing vmx_get_mt_mask() can't be directly used as CPU state(CR0.CD)
is protected.  GFN passed to kvm_mtrr_check_gfn_range_consistency() should
include shared bit.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 10 +++++++++-
 arch/x86/kvm/vmx/tdx.c     | 23 +++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 569f2f67094c..0784290d846f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -232,6 +232,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
+
+	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -351,7 +359,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
+	.get_mt_mask = vt_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4002e7e7b191..4cbcedff4f16 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -439,6 +439,29 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_mmio)
+		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+
+	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+
+	/*
+	 * TDX enforces CR0.CD = 0 and KVM MTRR emulation enforces writeback.
+	 * TODO: implement MTRR MSR emulation so that
+	 * MTRRCap: SMRR=0: SMRR interface unsupported
+	 *          WC=0: write combining unsupported
+	 *          FIX=0: Fixed range registers unsupported
+	 *          VCNT=0: number of variable range regitsers = 0
+	 * MTRRDefType: E=1, FE=0, type=writeback only. Don't allow other value.
+	 *              E=1: enable MTRR
+	 *              FE=0: disable fixed range MTRRs
+	 *              type: default memory type=writeback
+	 */
+	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 441915e9293e..5a9aabf39c02 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -150,6 +150,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -176,6 +177,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1


