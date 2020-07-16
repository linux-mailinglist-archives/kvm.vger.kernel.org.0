Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8196B221ABC
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgGPDRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:17:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:8148 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgGPDRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:17:03 -0400
IronPort-SDR: 21+yi4nCdZLwI0xWpKZXKrd/3PnERlK3UF7ynDZ3wxXZ7TDOmz6dfSTX7NQ5zBKMEEuL7kqmgX
 HClmlru12oLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210844846"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210844846"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:17:01 -0700
IronPort-SDR: nps9WVQV5xIg+UyKTTq75xibVbW6wJLd+so25eSlMl5Dk9ZxhFhb1GkAHWInAVezz8HbE65Kkg
 lAXGE6/1rYSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="360910429"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2020 20:16:59 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND v13 03/11] KVM: VMX: Set guest CET MSRs per KVM and host configuration
Date:   Thu, 16 Jul 2020 11:16:19 +0800
Message-Id: <20200716031627.11492-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200716031627.11492-1-weijiang.yang@intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET MSRs pass through guest directly to enhance performance. CET runtime
control settings are stored in MSR_IA32_{U,S}_CET, Shadow Stack Pointer(SSP)
are stored in MSR_IA32_PL{0,1,2,3}_SSP, SSP table base address is stored in
MSR_IA32_INT_SSP_TAB, these MSRs are defined in kernel and re-used here.

MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user-mode protection,the MSR
contents are switched between threads during scheduling, it makes sense to pass
through them so that the guest kernel can use xsaves/xrstors to operate them
efficiently. Other MSRs are used for non-user mode protection. See SDM for detailed
info.

The difference between CET VMCS fields and CET MSRs is that,the former are used
during VMEnter/VMExit, whereas the latter are used for CET state storage between
task/thread scheduling.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  3 +++
 2 files changed, 49 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13745f2a5ecd..a9f135c52cbc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3126,6 +3126,13 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
+static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_states)
+{
+	return ((supported_xss & xss_states) &&
+		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
+}
+
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7230,6 +7237,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	bool incpt;
+
+	incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER);
+	/*
+	 * U_CET is required for USER CET, and U_CET, PL3_SPP are bound as
+	 * one component and controlled by IA32_XSS[bit 11].
+	 */
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW,
+				  incpt);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW,
+				  incpt);
+
+	incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_KERNEL);
+	/*
+	 * S_CET is required for KERNEL CET, and PL0_SSP ... PL2_SSP are
+	 * bound as one component and controlled by IA32_XSS[bit 12].
+	 */
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW,
+				  incpt);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW,
+				  incpt);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW,
+				  incpt);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW,
+				  incpt);
+
+	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+	/* SSP_TAB is only available for KERNEL SHSTK.*/
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW,
+				  incpt);
+}
+
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7268,6 +7311,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
+
+	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))
+		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static __init void vmx_set_cpu_caps(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..ea8a9dc9fbad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -184,6 +184,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
+#define KVM_SUPPORTED_XSS       (XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
-- 
2.17.2

