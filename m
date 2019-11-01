Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB7FDEBFF5
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 09:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfKAIt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 04:49:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:34433 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfKAIt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 04:49:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 01:49:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,254,1569308400"; 
   d="scan'208";a="194606609"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2019 01:49:53 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 3/7] KVM: VMX: Pass through CET related MSRs
Date:   Fri,  1 Nov 2019 16:52:18 +0800
Message-Id: <20191101085222.27997-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191101085222.27997-1-weijiang.yang@intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET MSRs pass through Guest directly to enhance performance.
CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
these MSRs are defined in kernel and re-used here.

MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user mode protection,
the contents could differ from process to process, therefore,
kernel needs to save/restore them during context switch, it makes
sense to pass through them so that the guest kernel can
use xsaves/xrstors to operate them efficiently. Other MSRs are used
for non-user mode protection. See CET spec for detailed info.

The difference between CET VMCS state fields and xsave components is that,
the former used for CET state storage during VMEnter/VMExit,
whereas the latter used for state retention between Guest task/process
switch.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c   |  4 +--
 arch/x86/kvm/cpuid.h   |  2 ++
 arch/x86/kvm/vmx/vmx.c | 65 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd387a785c1e..4166c4fcad1e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -371,13 +371,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SHSTK);
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR);
+		F(MD_CLEAR) | F(IBT);
 
 	/* cpuid 7.1.eax */
 	const u32 kvm_cpuid_7_1_eax_x86_features =
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d78a61408243..1d77b880084d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -27,6 +27,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
 
+u64 kvm_supported_xss(void);
+
 static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.maxphyaddr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a84198cff397..db03d9dc1297 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2918,6 +2918,24 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
+static bool guest_cet_allowed(struct kvm_vcpu *vcpu, u32 feature, u32 mode)
+{
+	u64 kvm_xss = kvm_supported_xss();
+
+	/*
+	 * Sanity check for guest CET dependencies, guest_cpu_has(SHSTK|IBT) has
+	 * implied corresponding host CET status check.
+	 */
+	if (feature == X86_FEATURE_SHSTK)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+		       (kvm_xss & mode);
+	else if (feature == X86_FEATURE_IBT)
+		return guest_cpuid_has(vcpu, X86_FEATURE_IBT) &&
+		       (kvm_xss & mode);
+
+	return false;
+}
+
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7001,6 +7019,50 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_pass_cet_msrs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+
+	/*
+	 * U_CET is required for USER CET, per CET spec., meanwhile U_CET and
+	 * PL3_SPP are a bundle for USER CET xsaves.
+	 */
+	if (guest_cet_allowed(vcpu, X86_FEATURE_SHSTK, XFEATURE_MASK_CET_USER) ||
+	    guest_cet_allowed(vcpu, X86_FEATURE_IBT, XFEATURE_MASK_CET_USER)) {
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
+	} else {
+		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW, true);
+		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW, true);
+	}
+	/*
+	 * S_CET is required for KERNEL CET, meanwhile PL0_SSP ... PL2_SSP are a bundle
+	 * for CET KERNEL xsaves.
+	 */
+	if (guest_cet_allowed(vcpu, X86_FEATURE_SHSTK, XFEATURE_MASK_CET_KERNEL) ||
+	    guest_cet_allowed(vcpu, X86_FEATURE_IBT, XFEATURE_MASK_CET_KERNEL)) {
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
+
+		/* SSP_TAB only available for KERNEL SHSTK.*/
+		if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+			vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
+						      MSR_TYPE_RW);
+		else
+			vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
+						  MSR_TYPE_RW, true);
+	} else {
+		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW, true);
+		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW, true);
+		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW, true);
+		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW, true);
+		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, true);
+	}
+}
+
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7025,6 +7087,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
 		update_intel_pt_cfg(vcpu);
+
+	if (!is_guest_mode(vcpu))
+		vmx_pass_cet_msrs(vcpu);
 }
 
 static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
-- 
2.17.2

