Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF722A8BD6
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 02:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733163AbgKFBGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 20:06:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:38191 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733072AbgKFBG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 20:06:29 -0500
IronPort-SDR: ZicaO5qdlZqfiE1OM22QIo4f8RESe/4HYDqX2k5M+d16DZ+jJST+WxLAbG+tdRtckcHN5/btec
 urK1Cm4eZSZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="157264700"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="157264700"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 17:06:28 -0800
IronPort-SDR: 7ScEavtQZnmvzchfgxl69/h7dA0cgyuuULnzEcP+BwNFJTXgWpznkRXnBzzvHkxgyYo28hIUdn
 lKw337bec8WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471874508"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2020 17:06:24 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v14 07/13] KVM: VMX: Emulate reads and writes to CET MSRs
Date:   Fri,  6 Nov 2020 09:16:31 +0800
Message-Id: <20201106011637.14289-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201106011637.14289-1-weijiang.yang@intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
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
index aef73dd3de4f..dd78d3a79e79 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1788,6 +1788,66 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
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
+		return false;
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
@@ -1920,6 +1980,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2189,6 +2269,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 50386318a382..d05c3d11161e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -286,6 +286,11 @@ static inline bool kvm_mpx_supported(void)
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
2.17.2

