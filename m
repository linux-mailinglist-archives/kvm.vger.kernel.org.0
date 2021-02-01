Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3494F30A12A
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBAFUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:20:47 -0500
Received: from mga17.intel.com ([192.55.52.151]:9254 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229884AbhBAFUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:20:20 -0500
IronPort-SDR: SVitZlEAMPIFfpYjI8TF3IlOBH0r8cGt7juGJTA3vYk5E8DIrKx/wviv5EslAYh1CkH1lAlml6
 P28m0rkjB+MQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401835"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401835"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:20 -0800
IronPort-SDR: nuQ4UIGoRFc6BfQX7FybG7k1k9SCMLsO79sf3wEAba2EgFp6e4D6NDDIuN0Vdh6AHEN9v7Stvu
 yIHV9+3Qolgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694287"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:17 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 04/11] KVM: vmx/pmu: Expose DEBUGCTLMSR_LBR in the MSR_IA32_DEBUGCTLMSR
Date:   Mon,  1 Feb 2021 13:10:32 +0800
Message-Id: <20210201051039.255478-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the DEBUGCTLMSR_LBR bit 0 is set, the processor records a running
trace of the most recent branches, interrupts, and/or exceptions taken
by the processor (prior to a debug exception being generated) in the
last branch record (LBR) stack.

Adding vcpu_supported_debugctl() to throw #GP for DEBUGCTLMSR_LBR
based on per-guest LBR setting.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  7 ++++++-
 arch/x86/kvm/vmx/pmu_intel.c    |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 28 +++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.h          |  1 +
 4 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index db1178a66d93..62aa7a701ebb 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -381,7 +381,12 @@ static inline u64 vmx_get_perf_capabilities(void)
 
 static inline u64 vmx_supported_debugctl(void)
 {
-	return DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF;
+	u64 debugctl = DEBUGCTLMSR_BTF;
+
+	if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
+		debugctl |= DEBUGCTLMSR_LBR;
+
+	return debugctl;
 }
 
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 01b2cd8eca47..e75a957b2068 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -183,6 +183,13 @@ bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
 	return !x86_perf_get_lbr(lbr);
 }
 
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
+
+	return lbr->nr && (vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT);
+}
+
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index af9c7632ecfa..3c008dec407c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1925,7 +1925,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = 0;
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
 	default:
 	find_uret_msr:
@@ -1950,6 +1950,16 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 	return (unsigned long)data;
 }
 
+static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
+{
+	u64 debugctl = vmx_supported_debugctl();
+
+	if (!intel_pmu_lbr_is_enabled(vcpu))
+		debugctl &= ~DEBUGCTLMSR_LBR;
+
+	return debugctl;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2005,18 +2015,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
-		if (!data) {
-			/* We support the non-activated case already */
-			return 0;
-		} else if (data & ~vmx_supported_debugctl()) {
-			/*
-			 * Values other than LBR and BTF are vendor-specific,
-			 * thus reserved and should throw a #GP.
-			 */
+		if (data & ~vcpu_supported_debugctl(vcpu))
 			return 1;
+		if (data & DEBUGCTLMSR_BTF) {
+			vcpu_unimpl(vcpu, "%s: BTF in MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
+			__func__, data);
+			data &= ~DEBUGCTLMSR_BTF;
 		}
-		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-			    __func__, data);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
 		return 0;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 095e357e5316..1b0bbfffa1f0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -74,6 +74,7 @@ struct pt_desc {
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
-- 
2.29.2

