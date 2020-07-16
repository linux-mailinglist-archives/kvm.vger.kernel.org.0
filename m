Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6E9221AB6
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgGPDRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:17:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:8154 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbgGPDRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:17:17 -0400
IronPort-SDR: zBDExVvQI0chJUNDa5qLq5+UblZGjlp3JClFGz60dU31hl3jKPPIjo7a0AmP2reLXf5hRD2r6L
 9TTZ+5lEE90w==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210844858"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210844858"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:17:10 -0700
IronPort-SDR: vIFzIvX3Gj0Ca9twvyDoMRqAZ4G2Jdc9X7ITqDhIpgx73WwfFVE667vboyW9rYktHfGTlGQgUm
 AgqsEg2dRgaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="360910472"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2020 20:17:07 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND v13 07/11] KVM: x86: Add userspace access interface for CET MSRs
Date:   Thu, 16 Jul 2020 11:16:23 +0800
Message-Id: <20200716031627.11492-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200716031627.11492-1-weijiang.yang@intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There're two different places storing Guest CET states, states managed
with XSAVES/XRSTORS, as restored/saved in previous patch, can be read/write
directly from/to the MSRs. For those stored in VMCS fields, they're access
via vmcs_read/vmcs_write.

To correctly read/write the CET MSRs, it's necessary to check whether the
kernel FPU context switch happened and reload guest FPU context if needed.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |   7 +-
 arch/x86/kvm/vmx/vmx.c               | 148 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                   |   4 +
 3 files changed, 156 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 812e9b4c1114..2d3422dc4c81 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -47,12 +47,13 @@
 /* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
 #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
-#define MSR_KVM_ASYNC_PF_EN 0x4b564d02
-#define MSR_KVM_STEAL_TIME  0x4b564d03
-#define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_ASYNC_PF_EN	0x4b564d02
+#define MSR_KVM_STEAL_TIME	0x4b564d03
+#define MSR_KVM_PV_EOI_EN	0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_GUEST_SSP	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0089943fbb31..4ce61427ed49 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1819,6 +1819,94 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
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
+#define CET_MSR_RSVD_BITS_1  GENMASK(2, 0)
+#define CET_MSR_RSVD_BITS_2  GENMASK(9, 6)
+
+static bool cet_check_msr_valid(struct kvm_vcpu *vcpu,
+				struct msr_data *msr, u64 rsvd_bits)
+{
+	u64 data = msr->data;
+	u32 index = msr->index;
+
+	if ((index == MSR_IA32_PL0_SSP || index == MSR_IA32_PL1_SSP ||
+	    index == MSR_IA32_PL2_SSP || index == MSR_IA32_PL3_SSP ||
+	    index == MSR_IA32_INT_SSP_TAB || index == MSR_KVM_GUEST_SSP) &&
+	    is_noncanonical_address(data, vcpu))
+		return false;
+
+	if ((index  == MSR_IA32_S_CET || index == MSR_IA32_U_CET) &&
+	    data & MSR_IA32_CET_ENDBR_EN) {
+		u64 bitmap_base = data >> 12;
+
+		if (is_noncanonical_address(bitmap_base, vcpu))
+			return false;
+	}
+
+	return !(data & rsvd_bits);
+}
+
+static bool cet_check_ssp_msr_accessible(struct kvm_vcpu *vcpu,
+					 struct msr_data *msr)
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
+	if (index == MSR_KVM_GUEST_SSP)
+		return msr->host_initiated &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+	if (index == MSR_IA32_INT_SSP_TAB)
+		return true;
+
+	if (index == MSR_IA32_PL3_SSP)
+		return supported_xss & XFEATURE_MASK_CET_USER;
+
+	return supported_xss & XFEATURE_MASK_CET_KERNEL;
+}
+
+static bool cet_check_ctl_msr_accessible(struct kvm_vcpu *vcpu,
+					 struct msr_data *msr)
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
+	if (index == MSR_IA32_U_CET)
+		return supported_xss & XFEATURE_MASK_CET_USER;
+
+	return supported_xss & XFEATURE_MASK_CET_KERNEL;
+}
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1951,6 +2039,31 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_SSP);
+		break;
+	case MSR_IA32_S_CET:
+		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
+	case MSR_IA32_U_CET:
+		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
+			return 1;
+		vmx_get_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		vmx_get_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2221,6 +2334,41 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_1))
+			return 1;
+		vmcs_writel(GUEST_SSP, data);
+		break;
+	case MSR_IA32_S_CET:
+		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
+			return 1;
+		vmcs_writel(GUEST_S_CET, data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_valid(vcpu, msr_info, 0))
+			return 1;
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
+	case MSR_IA32_U_CET:
+		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
+			return 1;
+		vmx_set_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_1))
+			return 1;
+		vmx_set_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c437ddc22ad6..c71a9ceac05e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1234,6 +1234,10 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_IA32_XSS, MSR_IA32_U_CET, MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
-- 
2.17.2

