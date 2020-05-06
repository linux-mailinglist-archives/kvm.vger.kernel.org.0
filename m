Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E4E1C6B72
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgEFITi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:19:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:35417 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgEFITg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:36 -0400
IronPort-SDR: FDomUIbBCgqFWiUipQrHWJRwxazEhU1N8i+KgsPDWV8tzIqcDdeL5E/NS/DireFSc1z2UHVD+r
 XSqTag3mwY9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:35 -0700
IronPort-SDR: CCLYkSb0Yx41q6+h74IRWTcUMoaRcpqgdrOQMirgpoQd0PBKgB2sv9uOLp23NMWzYFWUH0WdL/
 Vc7M+4ZNYbPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030075"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 02/10] KVM: VMX: Set guest CET MSRs per KVM and host configuration
Date:   Wed,  6 May 2020 16:21:01 +0800
Message-Id: <20200506082110.25441-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
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
index d52d470e36b1..97e766875a7e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3020,6 +3020,13 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3)
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
@@ -7098,6 +7105,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
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
@@ -7136,6 +7179,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
+
+	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))
+		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static __init void vmx_set_cpu_caps(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..6390b62c12ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -186,6 +186,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
+#define KVM_SUPPORTED_XSS       (XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
-- 
2.17.2

