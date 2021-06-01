Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DAB396F7C
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhFAIuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:50:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:45213 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233818AbhFAIuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:50:22 -0400
IronPort-SDR: yKVa4fsE+CY758/R3/1tXTyFV9uKKEsa/STmFlcLQBrhF5YHL5ZNNNmC7GgRI8dsQPDIYEsp4T
 3U5KyKaC+lTw==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381439"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381439"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:27 -0700
IronPort-SDR: j6+pw+2suYFV1Y2iWYvoJjKwf6F8XIkYNO0Pqgtt9LxZMUu2Y0p9wiB3HbeYfTCrnkNTaIAK/2
 SEYyGd2ZNX5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967826"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:24 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 10/15] kvm/vmx/nested: Support new IA32_VMX_PROCBASED_CTLS3 vmx capability MSR
Date:   Tue,  1 Jun 2021 16:47:49 +0800
Message-Id: <1622537274-146420-11-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add this new VMX capability MSR in nested_vmx_msrs, and related functions
for its nested support.

Don't set its LOADIWKEY VM-Exit bit at present. It will be enabled in last
patch when everything's prepared.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  2 ++
 arch/x86/kvm/vmx/nested.c       | 22 +++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  6 +++---
 arch/x86/kvm/x86.c              |  2 ++
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index df7550c..0a0bea9 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -33,6 +33,8 @@ struct nested_vmx_msrs {
 	u32 procbased_ctls_high;
 	u32 secondary_ctls_low;
 	u32 secondary_ctls_high;
+	/* Tertiary Controls is 64bit allow-1 semantics */
+	u64 tertiary_ctls;
 	u32 pinbased_ctls_low;
 	u32 pinbased_ctls_high;
 	u32 exit_ctls_low;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bced766..b04184b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1272,6 +1272,18 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 		lowp = &vmx->nested.msrs.secondary_ctls_low;
 		highp = &vmx->nested.msrs.secondary_ctls_high;
 		break;
+	/*
+	 * MSR_IA32_VMX_PROCBASED_CTLS3 is 64bit, all allow-1 (must-be-0)
+	 * semantics.
+	 */
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
+		/* Check must-be-0 bits are still 0. */
+		if (!is_bitwise_subset(vmx->nested.msrs.tertiary_ctls,
+				       data, GENMASK_ULL(63, 0)))
+			return -EINVAL;
+
+		vmx->nested.msrs.tertiary_ctls = data;
+		return 0;
 	default:
 		BUG();
 	}
@@ -1408,6 +1420,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
 		return vmx_restore_control_msr(vmx, msr_index, data);
 	case MSR_IA32_VMX_MISC:
 		return vmx_restore_vmx_misc(vmx, data);
@@ -1503,6 +1516,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 			msrs->secondary_ctls_low,
 			msrs->secondary_ctls_high);
 		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
+		*pdata = msrs->tertiary_ctls;
+		break;
 	case MSR_IA32_VMX_EPT_VPID_CAP:
 		*pdata = msrs->ept_caps |
 			((u64)msrs->vpid_caps << 32);
@@ -6429,7 +6445,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_TRAP_FLAG |
 		CPU_BASED_MONITOR_EXITING | CPU_BASED_RDPMC_EXITING |
 		CPU_BASED_RDTSC_EXITING | CPU_BASED_PAUSE_EXITING |
-		CPU_BASED_TPR_SHADOW | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+		CPU_BASED_TPR_SHADOW | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
+		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	/*
 	 * We can allow some features even when not supported by the
 	 * hardware. For example, L1 can specify an MSR bitmap - and we
@@ -6467,6 +6484,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES;
 
+	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
+		rdmsrl(MSR_IA32_VMX_PROCBASED_CTLS3, msrs->tertiary_ctls);
+	msrs->tertiary_ctls &= 0;
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
 	 * doesn't support it.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da4c123..44c9f16 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1981,7 +1981,7 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_PROCBASED_CTLS3:
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
@@ -2069,7 +2069,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
 			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
 		break;
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_PROCBASED_CTLS3:
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
 		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
@@ -2399,7 +2399,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->msr_ia32_sgxlepubkeyhash
 			[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
 		break;
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_PROCBASED_CTLS3:
 		if (!msr_info->host_initiated)
 			return 1; /* they are read-only */
 		if (!nested_vmx_allowed(vcpu))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6eda283..9b87e64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1332,6 +1332,7 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_IA32_VMX_PROCBASED_CTLS2,
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
+	MSR_IA32_VMX_PROCBASED_CTLS3,
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
@@ -1363,6 +1364,7 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_IA32_VMX_PROCBASED_CTLS2,
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
+	MSR_IA32_VMX_PROCBASED_CTLS3,
 
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
-- 
1.8.3.1

