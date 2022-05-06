Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E694151CFA1
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388624AbiEFDh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388658AbiEFDhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3166470A;
        Thu,  5 May 2022 20:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808013; x=1683344013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8JIFjwJl7uZ0J4Csugtm3GgvKSHuvJNOWDdlkAphcCw=;
  b=epZyJJUjly+JDb8qYDHLC90AK2moAMnIs48OsWs8wOTUOU8453peNY/O
   dIhCVgeUf4OiMUV3zavDk6uSW3kEiBFLloU9FD+9qBtmD6MYPhANfnt9v
   OXkf0Xv2zw8aK/E3Y7Icdepq/48Qc72BHAa4XPmwcWoJXVyksP1usRTgy
   FhGhzrkTrGLJa7hEY/kkvuvpcD6MZbPVxRTcSYCVo9Z38X59mom1HaJoI
   1+8jNj3onrUosV3MzUijEJHjeGyw6pXVPaUFkL2Rf3L68sqPGVCzEG4iI
   HTeLvF4ImF52/pnsY6cYxbX3Zd8Z5FeepSNCWRKIVUJTxP1A1T4c1J9n/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241434"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241434"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745178"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:32 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 07/16] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
Date:   Thu,  5 May 2022 23:32:56 -0400
Message-Id: <20220506033305.5135-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

Arch LBR is enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
When guest Arch LBR is enabled, a guest LBR event will be created like the
model-specific LBR does. Clear guest LBR enable bit on host PMI handling so
guest can see expected config.

On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
meaning. It can be written to 0 or 1, but reads will always return 0.
Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also preserved on INIT.

Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of the
corresponding control MSR is set to 1, LBR recording will be enabled.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/events/intel/lbr.c      |  2 --
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/include/asm/vmx.h       |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c     | 57 ++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c           | 12 +++++++
 5 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 4529ce448b2e..4fe6c3b50fc3 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -160,8 +160,6 @@ enum {
 	 ARCH_LBR_RETURN		|\
 	 ARCH_LBR_OTHER_BRANCH)
 
-#define ARCH_LBR_CTL_MASK			0x7f000e
-
 static void intel_pmu_lbr_filter(struct cpu_hw_events *cpuc);
 
 static __always_inline bool is_lbr_call_stack_bit_set(u64 config)
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ee15311b6be1..fdf0e3097e0b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -169,6 +169,7 @@
 #define LBR_INFO_BR_TYPE		(0xfull << LBR_INFO_BR_TYPE_OFFSET)
 
 #define MSR_ARCH_LBR_CTL		0x000014ce
+#define ARCH_LBR_CTL_MASK		0x7f000e
 #define ARCH_LBR_CTL_LBREN		BIT(0)
 #define ARCH_LBR_CTL_CPL_OFFSET		1
 #define ARCH_LBR_CTL_CPL		(0x3ull << ARCH_LBR_CTL_CPL_OFFSET)
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..ea3be961cc8e 100644
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
index e2b5fc1f4f1a..aa36d2072b91 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "pmu.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
+#define KVM_ARCH_LBR_CTL_MASK  (ARCH_LBR_CTL_MASK | ARCH_LBR_CTL_LBREN)
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
@@ -192,7 +193,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	if (!intel_pmu_lbr_is_enabled(vcpu))
 		return ret;
 
-	if (index == MSR_ARCH_LBR_DEPTH) {
+	if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL) {
 		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
 			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 		return ret;
@@ -363,6 +364,33 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
 	return (depth == pmu->kvm_arch_lbr_depth);
 }
 
+static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return false;
+
+	if (ctl & ~KVM_ARCH_LBR_CTL_MASK)
+		goto warn;
+
+	entry = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
+	if (!entry)
+		return false;
+
+	if (!(entry->ebx & BIT(0)) && (ctl & ARCH_LBR_CTL_CPL))
+		return false;
+	if (!(entry->ebx & BIT(2)) && (ctl & ARCH_LBR_CTL_STACK))
+		return false;
+	if (!(entry->ebx & BIT(1)) && (ctl & ARCH_LBR_CTL_FILTER))
+		return false;
+	return true;
+warn:
+	pr_warn_ratelimited("kvm: vcpu-%d: invalid arch lbr ctl.\n",
+			    vcpu->vcpu_id);
+	return false;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -386,6 +414,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_DEPTH:
 		msr_info->data = lbr_desc->records.nr;
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -457,6 +488,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		if (!arch_lbr_ctl_is_valid(vcpu, data))
+			break;
+
+		vmcs_write64(GUEST_IA32_LBR_CTL, data);
+
+		if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
+		    (data & ARCH_LBR_CTL_LBREN))
+			intel_pmu_create_guest_lbr_event(vcpu);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -666,12 +707,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
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
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		lbr_ctl_field = GUEST_IA32_LBR_CTL;
+
+	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~0x1ULL);
 }
 
 static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d58b763df855..b6bc7d97e4b4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2022,6 +2022,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4553,6 +4560,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
+
+	if (!init_event) {
+		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
+			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+	}
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
-- 
2.27.0

