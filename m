Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6687DC1D8
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 11:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633195AbfJRJwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 05:52:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:35375 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633188AbfJRJwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 05:52:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 02:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="221689702"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2019 02:52:29 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: VMX: Some minor refactor of MSR bitmap
Date:   Fri, 18 Oct 2019 17:37:23 +0800
Message-Id: <20191018093723.102471-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191018093723.102471-1-xiaoyao.li@intel.com>
References: <20191018093723.102471-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the MSR bitmap capability check from vmx_disable_intercept_for_msr()
and vmx_enable_intercept_for_msr(), so that we can do the check far
early before we really want to touch the bitmap.

Also, we can move the common MSR not-intercept setup to where msr bitmap
is actually used.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v2:
  - Remove the check of cpu_has_vmx_msr_bitmap() from
    vmx_{disable,enable}_intercept_for_msr (Krish)
---
 arch/x86/kvm/vmx/vmx.c | 65 +++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b083316a598d..017689d0144e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -343,8 +343,8 @@ module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
 static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
-							  u32 msr, int type);
+static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
+		u32 msr, int type, bool value);
 
 void vmx_vmexit(void);
 
@@ -2000,9 +2000,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
-					      MSR_IA32_SPEC_CTRL,
-					      MSR_TYPE_RW);
+		vmx_set_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+					  MSR_IA32_SPEC_CTRL,
+					  MSR_TYPE_RW, false);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr_info->host_initiated &&
@@ -2028,8 +2028,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
-					      MSR_TYPE_W);
+		vmx_set_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+					  MSR_IA32_PRED_CMD,
+					  MSR_TYPE_W, false);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
@@ -3599,9 +3600,6 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 {
 	int f = sizeof(unsigned long);
 
-	if (!cpu_has_vmx_msr_bitmap())
-		return;
-
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
 
@@ -3637,9 +3635,6 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 {
 	int f = sizeof(unsigned long);
 
-	if (!cpu_has_vmx_msr_bitmap())
-		return;
-
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
 
@@ -3673,6 +3668,9 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
 			     			      u32 msr, int type, bool value)
 {
+	if (!cpu_has_vmx_msr_bitmap())
+		return;
+
 	if (value)
 		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
 	else
@@ -4163,11 +4161,30 @@ static void ept_set_mmio_spte_mask(void)
 
 static void vmx_vmcs_setup(struct vcpu_vmx *vmx)
 {
+	unsigned long *msr_bitmap;
+
 	if (nested)
 		nested_vmx_vmcs_setup();
 
-	if (cpu_has_vmx_msr_bitmap())
+	if (cpu_has_vmx_msr_bitmap()) {
+		msr_bitmap = vmx->vmcs01.msr_bitmap;
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+		if (kvm_cstate_in_guest(vmx->vcpu.kvm)) {
+			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
+			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+			vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+		}
+
 		vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
+	}
+	vmx->msr_bitmap_mode = 0;
 
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
@@ -6074,7 +6091,8 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	}
 	secondary_exec_controls_set(vmx, sec_exec_control);
 
-	vmx_update_msr_bitmap(vcpu);
+	if (cpu_has_vmx_msr_bitmap())
+		vmx_update_msr_bitmap(vcpu);
 }
 
 static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
@@ -6688,7 +6706,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	int err;
 	struct vcpu_vmx *vmx;
-	unsigned long *msr_bitmap;
 	int i, cpu;
 
 	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
@@ -6745,22 +6762,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (err < 0)
 		goto free_msrs;
 
-	msr_bitmap = vmx->vmcs01.msr_bitmap;
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-	if (kvm_cstate_in_guest(kvm)) {
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
-	}
-	vmx->msr_bitmap_mode = 0;
-
 	vmx->loaded_vmcs = &vmx->vmcs01;
 	cpu = get_cpu();
 	vmx_vcpu_load(&vmx->vcpu, cpu);
-- 
2.19.1

