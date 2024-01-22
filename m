Return-Path: <kvm+bounces-6602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE0583794D
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0015B28579
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E845C91C;
	Mon, 22 Jan 2024 23:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YEUzXoL2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730305BAF5;
	Mon, 22 Jan 2024 23:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967720; cv=none; b=SJ7ZJNtqkBQ42hCYSDvg6OIjXdpHVW5E2Jv623YntR8BgoO/lHZL2pHLEkExQNPn6OPl02wVgV/ErnpHowvYMQ9/IMFi8X3sS0VWnWYplLTwCXwglwsk/0VLZqWTVTiW81S9hujy+b54Z3ccIQlTCmh2aBIDE1b/v0T1sr1IJ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967720; c=relaxed/simple;
	bh=Tpq13RBs+BSV2s70Hpkd9xyA3NjKbu7RUE/LHc+IJQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TP0AJvTgxqVSHlNNf37h4MGwXkRbXZmE2u22pTuSnY4RqRHA2NX2v9EzFTZ746+05WJgcvxel2G2KGljap9JVgxMxNPNyeI24eEYSYukqH9VwdNLko9lmas2ICj6PTfpeL+iBPQi3k2zb647LWDORohpsafJ1MpWTvU+GqPCsTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YEUzXoL2; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967718; x=1737503718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tpq13RBs+BSV2s70Hpkd9xyA3NjKbu7RUE/LHc+IJQY=;
  b=YEUzXoL2s2GyAGW/Zjc/8wlabpt6vyBmB7OCycWQv+WcnnRRq7s8ZrOd
   6c7buFAJ9lj/2A3ybN6DRaDzOZlHAq2E7Aagp4GU4rxCQTs7MhhGZeBPA
   26WEKxe6nY2iRXVAaXU7hE6hN6k7kwv29RTOjKxJNmZXWawhTy3LAcNw9
   F5bXbuz3zBFKevVqtrvU8fFcBxmirp+f5FQdHRdWcMUKx9N+VyssNchiM
   Daj+zN9j7d4IjL6prACqLi8872pyasMlQagpoKJzHTTAR1W6FP9N9vut3
   jAF/IzUjRVzCK2cgrI0BI5b3CFpFz3sWZFwu6nd4DgB48ARO8AJPeZCrL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243836"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243836"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888586"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888586"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:16 -0800
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
Subject: [PATCH v18 029/121] KVM: TDX: create/free TDX vcpu structure
Date: Mon, 22 Jan 2024 15:53:05 -0800
Message-Id: <f857ba01c0b2ffbcc310727fd7a61599221c4f21.1705965635.git.isaku.yamahata@intel.com>
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

The next step of TDX guest creation is to create vcpu.  Create TDX vcpu
structures, initialize it that doesn't require TDX SEAMCALL.  TDX specific
vcpu initialization will be implemented as independent KVM_TDX_INIT_VCPU
so that when error occurs it's easy to determine which component has the
issue, KVM or TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- update commit log to use create instead of allocate because the patch
  doesn't newly allocate memory for TDX vcpu.

v15 -> v16:
- Add AMX support as the KVM upstream supports it.
---
 arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 49 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h | 10 ++++++++
 arch/x86/kvm/x86.c         |  2 ++
 4 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 50a1f50c0fc5..c2f1dc2000c5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -102,6 +102,42 @@ static void vt_vm_free(struct kvm *kvm)
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
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_reset(vcpu, init_event);
+		return;
+	}
+
+	vmx_vcpu_reset(vcpu, init_event);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -140,10 +176,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index 1c6541789c39..8330f448ab8e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -411,6 +411,55 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	/*
+	 * On cpu creation, cpuid entry is blank.  Forcibly enable
+	 * X2APIC feature to allow X2APIC.
+	 * Because vcpu_reset() can't return error, allocation is done here.
+	 */
+	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
+	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
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
+	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+	vcpu->arch.guest_state_protected =
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
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
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+
+	/* Ignore INIT silently because TDX doesn't support INIT event. */
+	if (init_event)
+		return;
+
+	/* This is stub for now. More logic will come here. */
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 645688081561..1ea532dfaf2a 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -144,7 +144,12 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+
+int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -158,7 +163,12 @@ static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5b66b493f1d..e0027134454c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -502,6 +502,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
@@ -12488,6 +12489,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
 
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-- 
2.25.1


