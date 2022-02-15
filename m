Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9474B859D
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiBPK1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiBPK1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:05 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02249211D4C;
        Wed, 16 Feb 2022 02:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007214; x=1676543214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lO7MemBZnElnUMm6DBDbvZjPPlxWTRnnT5YQZV2zZw8=;
  b=Y9oybUbuej3zsSN2+XhYqEOh4/WqAFG0ZUvk3Hm4ykw20nVihj1fNm9H
   +kfnLUdUDOfof1zWjfOTsBsfkGLllk9ZFJKpN/tM1IP0n/NK7A0XilF3d
   1BVQTzaf1O6Sv9FG6S+7P53+XtWJ894T7sqZCqd8aRTjeL5cg22VXeEjV
   zZa5VepnkV7CK0cK2xsTmKzXPE/25g9aiMjUh7JAO/5GSJMI4ME4x3/Hz
   MCTgZ161O3dQkp486tH9+hDEslrHu4wPKMOZsYZAmEdS+iz40yN5lssUw
   pk+x1s+y37n2kDBOlbJkdxlzY5JDbwkYwkbLkDw/7tcMv+HfJJF4s3Lso
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250312476"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="250312476"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708596"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:50 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 08/17] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
Date:   Tue, 15 Feb 2022 16:25:35 -0500
Message-Id: <20220215212544.51666-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215212544.51666-1-weijiang.yang@intel.com>
References: <20220215212544.51666-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/events/intel/lbr.c      |  2 --
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/include/asm/vmx.h       |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c     | 58 +++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c           | 12 +++++++
 5 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 4ab358ca7290..0a313586d254 100644
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
index a4a39c3e0f19..0403d6370c92 100644
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
index cbf00db5448a..e419a8c1ad0d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "pmu.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
+#define KVM_ARCH_LBR_CTL_MASK  (ARCH_LBR_CTL_MASK | ARCH_LBR_CTL_LBREN)
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
@@ -215,6 +216,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_ARCH_LBR_DEPTH:
+	case MSR_ARCH_LBR_CTL:
 		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
 			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 		break;
@@ -361,6 +363,35 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
 	return (depth == pmu->kvm_arch_lbr_depth);
 }
 
+#define ARCH_LBR_CTL_BRN_MASK   GENMASK_ULL(22, 16)
+
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
+	if (!(entry->ebx & BIT(1)) && (ctl & ARCH_LBR_CTL_BRN_MASK))
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
@@ -384,6 +415,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_DEPTH:
 		msr_info->data = lbr_desc->records.nr;
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -454,6 +488,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -659,12 +703,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
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
index efda5e4d6247..7b6eb87ff6ad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2034,6 +2034,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4563,6 +4570,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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

