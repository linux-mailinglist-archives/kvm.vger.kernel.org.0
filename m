Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AEA193A93
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgCZIQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 04:16:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:27564 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgCZIQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:16:14 -0400
IronPort-SDR: ybsUDEKbcl4ES5Ii/p/H5gKaRvtntj4A4rFIVkaUJ1olrYjhi+MJakfOX4QR1IV7xObmV+99E8
 iFey+QgJoVfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:16:13 -0700
IronPort-SDR: 53ti/ap2rtlaL4wK+IFj898+HWKaFj2a/WlDAAzFUgMPSLagY3cEJdv53Eda5aiq1l6cxbzuV8
 uhehj27GaHbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393898946"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 01:16:11 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET MSRs
Date:   Thu, 26 Mar 2020 16:18:44 +0800
Message-Id: <20200326081847.5870-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200326081847.5870-1-weijiang.yang@intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There're two different places storing Guest CET states, states
managed with XSAVES/XRSTORS, as restored/saved
in previous patch, can be read/write directly from/to the MSRs.
For those stored in VMCS fields, they're access via vmcs_read/
vmcs_write.

To correctly read/write the CET MSRs, it's necessary to check
whether the kernel FPU context switch happened and reload guest
FPU context if needed.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 133 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  11 ++++
 2 files changed, 144 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 87f101750746..a3d01014b9e7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1809,6 +1809,91 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	}
 }
 
+static void vmx_get_xsave_msr(struct msr_data *msr_info)
+{
+	local_irq_disable();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+	rdmsrl(msr_info->index, msr_info->data);
+	local_irq_enable();
+}
+
+static void vmx_set_xsave_msr(struct msr_data *msr_info)
+{
+	local_irq_disable();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+	wrmsrl(msr_info->index, msr_info->data);
+	local_irq_enable();
+}
+
+#define CET_MSR_RSVD_BITS_1  GENMASK(1, 0)
+#define CET_MSR_RSVD_BITS_2  GENMASK(9, 6)
+
+static bool cet_check_msr_write(struct kvm_vcpu *vcpu,
+				struct msr_data *msr,
+				u64 mask)
+{
+	u64 data = msr->data;
+	u32 high_word = data >> 32;
+
+	if (data & mask)
+		return false;
+
+	if (!is_64_bit_mode(vcpu) && high_word)
+		return false;
+
+	return true;
+}
+
+static bool cet_check_ssp_msr_access(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr)
+{
+	u32 index = msr->index;
+
+	if (!boot_cpu_has(X86_FEATURE_SHSTK))
+		return false;
+
+	if (!msr->host_initiated &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+		return false;
+
+	if (index == MSR_IA32_INT_SSP_TAB)
+		return true;
+
+	if (index == MSR_IA32_PL3_SSP) {
+		if (!(supported_xss & XFEATURE_MASK_CET_USER))
+			return false;
+	} else if (!(supported_xss & XFEATURE_MASK_CET_KERNEL)) {
+		return false;
+	}
+
+	return true;
+}
+
+static bool cet_check_ctl_msr_access(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr)
+{
+	u32 index = msr->index;
+
+	if (!boot_cpu_has(X86_FEATURE_SHSTK) &&
+	    !boot_cpu_has(X86_FEATURE_IBT))
+		return false;
+
+	if (!msr->host_initiated &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+		return false;
+
+	if (index == MSR_IA32_U_CET) {
+		if (!(supported_xss & XFEATURE_MASK_CET_USER))
+			return false;
+	} else if (!(supported_xss & XFEATURE_MASK_CET_KERNEL)) {
+		return false;
+	}
+
+	return true;
+}
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1941,6 +2026,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+		if (!cet_check_ctl_msr_access(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_check_ssp_msr_access(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
+	case MSR_IA32_U_CET:
+		if (!cet_check_ctl_msr_access(vcpu, msr_info))
+			return 1;
+		vmx_get_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_check_ssp_msr_access(vcpu, msr_info))
+			return 1;
+		vmx_get_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2197,6 +2302,34 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+		if (!cet_check_ctl_msr_access(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_write(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
+			return 1;
+		vmcs_writel(GUEST_S_CET, data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_check_ctl_msr_access(vcpu, msr_info))
+			return 1;
+		if (!is_64_bit_mode(vcpu))
+			return 1;
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
+	case MSR_IA32_U_CET:
+		if (!cet_check_ctl_msr_access(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_write(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
+			return 1;
+		vmx_set_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_check_ssp_msr_access(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_write(vcpu, msr_info, CET_MSR_RSVD_BITS_1))
+			return 1;
+		vmx_set_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9654d779bdab..9e89ee6a09e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1229,6 +1229,10 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_IA32_XSS, MSR_IA32_U_CET, MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -1504,6 +1508,13 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * invokes 64-bit SYSENTER.
 		 */
 		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_IA32_INT_SSP_TAB:
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
 	}
 
 	msr.data = data;
-- 
2.17.2

