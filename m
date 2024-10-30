Return-Path: <kvm+bounces-30100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B20A99B6CB6
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5CCF1C214DF
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67DB228B68;
	Wed, 30 Oct 2024 19:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXrV47gV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C822803D;
	Wed, 30 Oct 2024 19:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314879; cv=none; b=QWwbxaBeB61PnYxI95c+wvuqOhF1JdUz8ieOHA1/SY0RbDAf4ZVS22qaOElhP+nTGPlgYeh3t4I466rb9Pl8QlPBuBBucAr74wBMkoLgE+M/pFxLIGofCQSdhYLjS2GAv+S9yYDC9shvp0cV1n11kvouNSUGRxmp233/c177A0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314879; c=relaxed/simple;
	bh=fqmwphDCrskUaL59MGcD/o60ek35Jc4EKTRV3Dd/iMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSaDKCc+SIX003tQ4PI3aaw9H4COT0+acS6cL4m35wf0g7uGn4nLGtEm+cedfBI56ftJr4uj1bc22oib5iZFYi5zqkmPzRFGe8hZpfb8uM5UA7gkaeqmIIvlySObCfii9FJ07OJ43T+SgGuEI1l2+qBuW6y2B3fTPnoFQpSd7os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXrV47gV; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314877; x=1761850877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fqmwphDCrskUaL59MGcD/o60ek35Jc4EKTRV3Dd/iMc=;
  b=nXrV47gVAU+VjlveJeC6DMi56X7MH9uwEd1jdQChzRAYqlaGtF64CZYU
   VCMN/D2ZffN1SzWlwPn2lrk7Z11ge4l5zJUvHJ3NdeH0Lf6cwwH6VxyfC
   bO0kNndnxRImwIvpBxJcFOt6mv/gKf6WgvLafeV7uLhxEdrlYkYrGrKJW
   lIv0ZbB0nFXxf4y0PHJegNjVcFa4442DLcy5hcmc9a/AmcFdL8zB51ExY
   IjxUrzsNS/VMUCw1G2YR+njE+GcUf+dU+RqAZqCweO+DKq0q0IaeD+yf0
   AaTZ4ObbS7u/oizwvlG2ffAQOlooH6Sb75c01Dzye779H1b0mgfqOVNKd
   w==;
X-CSE-ConnectionGUID: sWDU3JisQ3GgQR9kjXHQjw==
X-CSE-MsgGUID: 19HHaE1dQ3uhxfhPyhe7TQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678843"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678843"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:07 -0700
X-CSE-ConnectionGUID: Pr6ol+dMTJ2NETEbXzs0kg==
X-CSE-MsgGUID: zQmAWYC2SyWkBoeUEIvyEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499453"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:07 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 22/25] KVM: TDX: create/free TDX vcpu structure
Date: Wed, 30 Oct 2024 12:00:35 -0700
Message-ID: <20241030190039.77971-23-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement vcpu related stubs for TDX for create, reset and free.

For now, create only the features that do not require the TDX SEAMCALL.
The TDX specific vcpu initialization will be handled by KVM_TDX_INIT_VCPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Drop dummy tdx_vcpu_reset() (Binbin)
 - Add TD state handling (Tony)
uAPI breakout v1:
 - Dropped unnecessary WARN_ON_ONCE() in tdx_vcpu_create().
   WARN_ON_ONCE(vcpu->arch.cpuid_entries),
   WARN_ON_ONCE(vcpu->arch.cpuid_nent)
 - Use kvm_tdx instead of to_kvm_tdx() in tdx_vcpu_create() (Chao)

v19:
 - removed stale comment in tdx_vcpu_create().

v18:
 - update commit log to use create instead of allocate because the patch
   doesn't newly allocate memory for TDX vcpu.

v16:
 - Add AMX support as the KVM upstream supports it.
--
2.46.0
---
 arch/x86/kvm/vmx/main.c    | 42 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 34 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  8 ++++++++
 3 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 559f9450dec7..0548d54eb055 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -64,6 +64,40 @@ static void vt_vm_free(struct kvm *kvm)
 		tdx_vm_free(kvm);
 }
 
+static int vt_vcpu_precreate(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return 0;
+
+	return vmx_vcpu_precreate(kvm);
+}
+
+static int vt_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_create(vcpu);
+
+	return vmx_vcpu_create(vcpu);
+}
+
+static void vt_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_free(vcpu);
+		return;
+	}
+
+	vmx_vcpu_free(vcpu);
+}
+
+static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_vcpu_reset(vcpu, init_event);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -100,10 +134,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vm_destroy = vt_vm_destroy,
 	.vm_free = vt_vm_free,
 
-	.vcpu_precreate = vmx_vcpu_precreate,
-	.vcpu_create = vmx_vcpu_create,
-	.vcpu_free = vmx_vcpu_free,
-	.vcpu_reset = vmx_vcpu_reset,
+	.vcpu_precreate = vt_vcpu_precreate,
+	.vcpu_create = vt_vcpu_create,
+	.vcpu_free = vt_vcpu_free,
+	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 17df857ae4c1..479ffb8f41c8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -416,6 +416,40 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	if (kvm_tdx->state != TD_STATE_INITIALIZED)
+		return -EIO;
+
+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
+	if (!vcpu->arch.apic)
+		return -EINVAL;
+
+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
+
+	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
+
+	vcpu->arch.cr0_guest_owned_bits = -1ul;
+	vcpu->arch.cr4_guest_owned_bits = -1ul;
+
+	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+	vcpu->arch.guest_state_protected =
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
+
+	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
+		vcpu->arch.xfd_no_write_intercept = true;
+
+	return 0;
+}
+
+void tdx_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	/* This is stub for now.  More logic will come. */
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index e7d5afce68f0..107c60ac94f4 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -122,12 +122,20 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+
+int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.47.0


