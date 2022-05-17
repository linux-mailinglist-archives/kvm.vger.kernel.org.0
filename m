Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24CD52A71E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350316AbiEQPmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350495AbiEQPli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5560741312;
        Tue, 17 May 2022 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802097; x=1684338097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Myp3GlTN5oxwIa3pW8JLbfoYhVNkfVcR8xonCn01QvI=;
  b=YLoCgZF0hmc5T27Ma+Xsg1daK60nfrj8L5mgtYKvDNCq0n7YkVThAt/O
   Zj2bWCw223eFNi1q8xF6J3oc+DDQJkFb/0oUgXArxc0qNwYtnKMvviTcv
   vvKzkcSREKQUGwhWzaZ8wS/HAmMVyxBFj9nSTnZK1G6xkuWtHrvkP1jR5
   WyDAhu/PIcSkGCTKTM24JqXMV+PiDMve3u3qidQvOIS6hihG9q54JyQKK
   MyFw2eBK0KyweswBNAKN1osNGjhGC3sIFWx5A7GC/CeBHQD1VUeev5eyl
   BYOx6xYgRqmmyJ1cKrvvnhAWbNFiEZYW+mn1hkR5MqrFRKY2eqPY0q+B5
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632105"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632105"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533575"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:33 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 07/16] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
Date:   Tue, 17 May 2022 11:40:51 -0400
Message-Id: <20220517154100.29983-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
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
index c89ca8f78462..65e90414c603 100644
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
index 89d2172787c5..a84d902952ce 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -256,6 +256,8 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_LBR_CTL		= 0x00002816,
+	GUEST_IA32_LBR_CTL_HIGH		= 0x00002817,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 22d6a869ea4d..0e882e97728e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "pmu.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
+#define KVM_ARCH_LBR_CTL_MASK  (ARCH_LBR_CTL_MASK | ARCH_LBR_CTL_LBREN)
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
@@ -182,7 +183,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	if (!intel_pmu_lbr_is_enabled(vcpu))
 		return ret;
 
-	if (index == MSR_ARCH_LBR_DEPTH) {
+	if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL) {
 		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
 			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 		return ret;
@@ -364,6 +365,33 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
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
@@ -396,6 +424,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_DEPTH:
 		msr_info->data = lbr_desc->records.nr;
 		return 0;
+	case MSR_ARCH_LBR_CTL:
+		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -488,6 +519,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -726,12 +767,16 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
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
index 8bbcf2071faf..60f00598f3c9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2025,6 +2025,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4641,6 +4648,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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

