Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888D218C5F2
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 04:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCTDkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 23:40:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:27908 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbgCTDkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 23:40:46 -0400
IronPort-SDR: ZzOAajjLdf0ksnTm8e0FOVyfQyvEvmZKwY46lt8rSp9b+/F7yQCVzPOZnZ4784GHwWu42alwqm
 abBDaW//JhKA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 20:40:46 -0700
IronPort-SDR: cZZymfSosMDqlAQZiXXjOazLOfIDdq+RqSop6KhhUk9I0TVOc8RqCOYaNM099s2G41b9zMHrk3
 UH19CRgJvyCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="263945582"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 19 Mar 2020 20:40:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 2/8] KVM: VMX: Set up guest CET MSRs per KVM and host configuration
Date:   Fri, 20 Mar 2020 11:43:35 +0800
Message-Id: <20200320034342.26610-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200320034342.26610-1-weijiang.yang@intel.com>
References: <20200320034342.26610-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET MSRs pass through guest directly to enhance performance.
CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
these MSRs are defined in kernel and re-used here.

MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user-mode protection,
the MSR contents are switched between threads during scheduling,
it makes sense to pass through them so that the guest kernel can
use xsaves/xrstors to operate them efficiently. Other MSRs are used
for non-user mode protection. See SDM for detailed info.

The difference between CET VMCS fields and CET MSRs is that,the former
are used during VMEnter/VMExit, whereas the latter are used for CET
state storage between task/thread scheduling.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 860e5f4a9f7b..61d2a4bf9eb6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3033,6 +3033,19 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
+static bool is_cet_mode_allowed(struct kvm_vcpu *vcpu, u32 mode_mask)
+{
+	return ((supported_xss & mode_mask) &&
+		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
+}
+
+static bool is_cet_supported(struct kvm_vcpu *vcpu)
+{
+	return is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_USER |
+				   XFEATURE_MASK_CET_KERNEL);
+}
+
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7064,6 +7077,35 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	bool flag;
+
+	flag = !is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_USER);
+	/*
+	 * U_CET is required for USER CET, and U_CET, PL3_SPP are bound as
+	 * one component and controlled by IA32_XSS[bit 11].
+	 */
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW, flag);
+
+	flag = !is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_KERNEL);
+	/*
+	 * S_CET is required for KERNEL CET, and PL0_SSP ... PL2_SSP are
+	 * bound as one component and controlled by IA32_XSS[bit 12].
+	 */
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW, flag);
+
+	flag |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+	/* SSP_TAB is only available for KERNEL SHSTK.*/
+	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, flag);
+}
+
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7102,6 +7144,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
+	vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static __init void vmx_set_cpu_caps(void)
-- 
2.17.2

