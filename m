Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060DB30DC33
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhBCOFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:05:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:50308 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231646AbhBCOFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 09:05:36 -0500
IronPort-SDR: MG12r3RHnDmZkOUO8JzSb7S0hWF5r1r8wfwEGuDiBSJaZk4hDF2UNS0NDishRsHDngapeGdW2S
 i6dQR/7g79FQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242555119"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="242555119"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 06:03:50 -0800
IronPort-SDR: vZMudbZEMdpuHQUfWuKzWJEHDobeaUKi0ZI8VWL635/cLnF3nWTyf6jGUR6jquUisUGFAgyKRc
 3Z8xhDRLkO6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="371490672"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2021 06:03:48 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
Date:   Wed,  3 Feb 2021 21:57:12 +0800
Message-Id: <20210203135714.318356-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135714.318356-1-like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. On
processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has
no meaning. It can be written to 0 or 1, but reads will always return 0.

A new guest state field named "Guest IA32_LBR_CTL" has been added to
enhance guest LBR usage and the guest value of MSR_ARCH_LBR_CTL is
written to this field on all VM exits.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h   |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c       |  7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 1b387713eddd..c099c3d17612 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -247,6 +247,8 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_LBR_CTL		= 0x00002816,
+	GUEST_IA32_LBR_CTL_HIGH		= 0x00002817,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b550c4a6ce33..a00d89c93eb7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "pmu.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
+#define ARCH_LBR_CTL_MASK			0x7f000e
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -221,6 +222,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_ARCH_LBR_DEPTH:
+	case MSR_ARCH_LBR_CTL:
 		ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 		break;
 	default:
@@ -390,6 +392,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_DEPTH:
 		msr_info->data = lbr_desc->records.nr;
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -458,6 +463,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		lbr_desc->arch_lbr_reset = true;
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		if (!(data & ARCH_LBR_CTL_MASK)) {
+			vmcs_write64(GUEST_IA32_LBR_CTL, data);
+			if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
+				(data & DEBUGCTLMSR_LBR))
+				intel_pmu_create_guest_lbr_event(vcpu);
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index beb5a912014d..edecf2961924 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2109,6 +2109,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
+		/*
+		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
+		 * It can be written to 0 or 1, but reads will always return 0.
+		 */
+		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+			data &= ~DEBUGCTLMSR_LBR;
+
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
 		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
 		    (data & DEBUGCTLMSR_LBR))
-- 
2.29.2

