Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F8B33A5EB
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 17:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhCNQBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 12:01:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:7174 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234118AbhCNQAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 12:00:46 -0400
IronPort-SDR: N7aLLwjjQQXTPolDhoGrcBzQC6PVQlsSb0lHHLO+SBX8M8wLKtGN838rPT3JcVsaxdVCNbsjwG
 nJRURX3q2gSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="188360740"
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="188360740"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 09:00:46 -0700
IronPort-SDR: BSBHelr1j6/5ZRVfz/M2CzoN3Aj79wiWDxwC9LhU1NCZMHwoPNJTbWhUbKiIqKBtRSyhzsDmnP
 i4giyOcuAr/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="439530694"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2021 09:00:43 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v4 07/11] KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
Date:   Sun, 14 Mar 2021 23:52:20 +0800
Message-Id: <20210314155225.206661-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314155225.206661-1-like.xu@linux.intel.com>
References: <20210314155225.206661-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
When guest Arch LBR is enabled, a guest LBR event will be created like the
model-specific LBR does.

On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
meaning. It can be written to 0 or 1, but reads will always return 0.
Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also reserved on INIT.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h   |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c | 31 ++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c       |  9 +++++++++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 358707f60d99..6826fd0e8d1a 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -245,6 +245,8 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_LBR_CTL		= 0x00002816,
+	GUEST_IA32_LBR_CTL_HIGH		= 0x00002817,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d9c9cb6c9a4b..15490d31b828 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,12 @@
 #include "pmu.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
+/*
+ * Regardless of the Arch LBR or legacy LBR, when the LBREn bit 0 of the
+ * corresponding control MSR is set to 1, LBR recording will be enabled.
+ */
+#define LBR_CTL_EN	BIT(0)
+#define KVM_ARCH_LBR_CTL_MASK	(ARCH_LBR_CTL_MASK | LBR_CTL_EN)
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -221,6 +227,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_ARCH_LBR_DEPTH:
+	case MSR_ARCH_LBR_CTL:
 		ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 		break;
 	default:
@@ -390,6 +397,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_DEPTH:
 		msr_info->data = lbr_desc->records.nr;
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -457,6 +467,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		lbr_desc->records.nr = data;
 		lbr_desc->arch_lbr_reset = true;
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		if (data & ~KVM_ARCH_LBR_CTL_MASK)
+			break;
+		vmcs_write64(GUEST_IA32_LBR_CTL, data);
+		if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
+		    (data & ARCH_LBR_CTL_LBREN))
+			intel_pmu_create_guest_lbr_event(vcpu);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -635,12 +653,15 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
  */
 static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
 {
-	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+	u32 lbr_ctl_field = GUEST_IA32_DEBUGCTL;
 
-	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
-		data &= ~DEBUGCTLMSR_LBR;
-		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
-	}
+	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
+		return;
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		lbr_ctl_field = GUEST_IA32_LBR_CTL;
+
+	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~LBR_CTL_EN);
 }
 
 static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef826594365f..38007daba935 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2054,6 +2054,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4474,6 +4481,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vmcs_writel(GUEST_SYSENTER_ESP, 0);
 		vmcs_writel(GUEST_SYSENTER_EIP, 0);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+		if (cpu_has_vmx_arch_lbr())
+			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
 	}
 
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
-- 
2.29.2

