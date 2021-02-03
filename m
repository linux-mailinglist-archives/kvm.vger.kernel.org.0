Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C3330D887
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhBCLXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:23:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:28338 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhBCLXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:23:25 -0500
IronPort-SDR: SGXruRnAaxHfJtgDJkoXwB2eTuXiEiWhWPhr3s4EKHfCNZ8X3fw4YaSehUABO4py4r3QLxR8mb
 hFougaQ6i5eg==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981283"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981283"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:19 -0800
IronPort-SDR: 99trbFJmizx+1iANyjSuY/7+OxC/3Sim0WhsVEQzGu/tz2vnTKTvcOcc3OBLL0Cwc2pEDnCqZQ
 cvspMPQ8Y7Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311151"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:18 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 07/14] KVM: VMX: Emulate reads and writes to CET MSRs
Date:   Wed,  3 Feb 2021 19:34:14 +0800
Message-Id: <20210203113421.5759-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for emulating read and write accesses to CET MSRs.  CET MSRs
are universally "special" as they are either context switched via
dedicated VMCS fields or via XSAVES, i.e. no additional in-memory
tracking is needed, but emulated reads/writes are more expensive.

MSRs that are switched through XSAVES are especially annoying due to the
possibility of the kernel's FPU being used in IRQ context.  Disable IRQs
and ensure the guest's FPU state is loaded when accessing such MSRs.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 105 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |   5 ++
 2 files changed, 110 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc60b1fc3ee7..694879c2b0b7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1787,6 +1787,66 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
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
+static void  vmx_set_xsave_msr(struct msr_data *msr_info)
+{
+	local_irq_disable();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+	wrmsrl(msr_info->index, msr_info->data);
+	local_irq_enable();
+}
+
+static bool cet_is_ssp_msr_accessible(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr)
+{
+	u64 mask;
+
+	if (!kvm_cet_supported())
+		return false;
+
+	if (msr->host_initiated)
+		return true;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+		return false;
+
+	if (msr->index == MSR_IA32_INT_SSP_TAB)
+		return true;
+
+	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
+						  XFEATURE_MASK_CET_KERNEL;
+	return !!(vcpu->arch.guest_supported_xss & mask);
+}
+
+static bool cet_is_control_msr_accessible(struct kvm_vcpu *vcpu,
+					  struct msr_data *msr)
+{
+	u64 mask;
+
+	if (!kvm_cet_supported())
+		return false;
+
+	if (msr->host_initiated)
+		return true;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+		return false;
+
+	mask = (msr->index == MSR_IA32_U_CET) ? XFEATURE_MASK_CET_USER :
+						XFEATURE_MASK_CET_KERNEL;
+	return !!(vcpu->arch.guest_supported_xss & mask);
+}
+
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1919,6 +1979,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+		if (!cet_is_control_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_IA32_U_CET:
+		if (!cet_is_control_msr_accessible(vcpu, msr_info))
+			return 1;
+		vmx_get_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		vmx_get_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2188,6 +2268,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+	case MSR_IA32_U_CET:
+		if (!cet_is_control_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (data & GENMASK(9, 6))
+			return 1;
+		if (msr_index == MSR_IA32_S_CET)
+			vmcs_writel(GUEST_S_CET, data);
+		else
+			vmx_set_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_is_control_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))
+			return 1;
+		vmx_set_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fd8c46da2030..16c661d94349 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -288,6 +288,11 @@ static inline bool kvm_mpx_supported(void)
 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 }
 
+static inline bool kvm_cet_supported(void)
+{
+	return supported_xss & XFEATURE_MASK_CET_USER;
+}
+
 extern unsigned int min_timer_period_us;
 
 extern bool enable_vmware_backdoor;
-- 
2.26.2

