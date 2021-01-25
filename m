Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C51303409
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbhAZFMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:12:48 -0500
Received: from mga14.intel.com ([192.55.52.115]:22891 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbhAYJRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:17:21 -0500
IronPort-SDR: C3/TwMfYo9FRN5ds5iEwhCYyEigez+d5Fp247BTIgXHXjaDGl7H0JLdupN8tOt2zMzdM+Z24Lx
 UVp5e67f4pCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915803"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915803"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:15 -0800
IronPort-SDR: auUtUaqroYPsrUBB/18m0dISPt3GX+kzly+G3Hx9di3PUWL5ffaduo8X4XzrHnvnuNwOYVJhEH
 NZJAkFFWB10Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223891"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:13 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 07/12] kvm/vmx/nested: Support new IA32_VMX_PROCBASED_CTLS3 vmx feature control MSR
Date:   Mon, 25 Jan 2021 17:06:15 +0800
Message-Id: <1611565580-47718-8-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add this new VMX feature MSR in nested_vmx_msrs, for the Tertiary
Proc-based Exec-Control nested support.

Don't set its LOADIWKEY VM-Exit bit at present. It will be enabled in last
patch when everything's prepared.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  2 ++
 arch/x86/kvm/vmx/nested.c       | 18 +++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  6 +++---
 arch/x86/kvm/x86.c              |  2 ++
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d8bbde4..2a694c9 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -30,6 +30,8 @@ struct nested_vmx_msrs {
 	u32 procbased_ctls_high;
 	u32 secondary_ctls_low;
 	u32 secondary_ctls_high;
+	/* Tertiary Controls is 64bit allow-1 semantics */
+	u64 tertiary_ctls;
 	u32 pinbased_ctls_low;
 	u32 pinbased_ctls_high;
 	u32 exit_ctls_low;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 89af692..9eb1c0b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1285,6 +1285,13 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 		lowp = &vmx->nested.msrs.secondary_ctls_low;
 		highp = &vmx->nested.msrs.secondary_ctls_high;
 		break;
+	/*
+	 * MSR_IA32_VMX_PROCBASED_CTLS3 is 64bit, all allow-1.
+	 * No need to check. Just return.
+	 */
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
+		vmx->nested.msrs.tertiary_ctls = data;
+		return 0;
 	default:
 		BUG();
 	}
@@ -1421,6 +1428,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
 		return vmx_restore_control_msr(vmx, msr_index, data);
 	case MSR_IA32_VMX_MISC:
 		return vmx_restore_vmx_misc(vmx, data);
@@ -1516,6 +1524,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 			msrs->secondary_ctls_low,
 			msrs->secondary_ctls_high);
 		break;
+	case MSR_IA32_VMX_PROCBASED_CTLS3:
+		*pdata = msrs->tertiary_ctls;
+		break;
 	case MSR_IA32_VMX_EPT_VPID_CAP:
 		*pdata = msrs->ept_caps |
 			((u64)msrs->vpid_caps << 32);
@@ -6375,7 +6386,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_TRAP_FLAG |
 		CPU_BASED_MONITOR_EXITING | CPU_BASED_RDPMC_EXITING |
 		CPU_BASED_RDTSC_EXITING | CPU_BASED_PAUSE_EXITING |
-		CPU_BASED_TPR_SHADOW | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+		CPU_BASED_TPR_SHADOW | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
+		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	/*
 	 * We can allow some features even when not supported by the
 	 * hardware. For example, L1 can specify an MSR bitmap - and we
@@ -6413,6 +6425,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES;
 
+	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
+		rdmsrl(MSR_IA32_VMX_PROCBASED_CTLS3,
+		      msrs->tertiary_ctls);
+	msrs->tertiary_ctls &= ~TERTIARY_EXEC_LOADIWKEY_EXITING;
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
 	 * doesn't support it.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6be6d87..f29a91c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1880,7 +1880,7 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_PROCBASED_CTLS3:
 		if (!nested)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
@@ -1961,7 +1961,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_FEAT_CTL:
 		msr_info->data = vmx->msr_ia32_feature_control;
 		break;
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_PROCBASED_CTLS3:
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
 		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
@@ -2240,7 +2240,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr_info->host_initiated && data == 0)
 			vmx_leave_nested(vcpu);
 		break;
-	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
+	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_PROCBASED_CTLS3:
 		if (!msr_info->host_initiated)
 			return 1; /* they are read-only */
 		if (!nested_vmx_allowed(vcpu))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbc839a..d428022 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1300,6 +1300,7 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_IA32_VMX_PROCBASED_CTLS2,
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
+	MSR_IA32_VMX_PROCBASED_CTLS3,
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
@@ -1331,6 +1332,7 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_IA32_VMX_PROCBASED_CTLS2,
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
+	MSR_IA32_VMX_PROCBASED_CTLS3,
 
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
-- 
1.8.3.1

