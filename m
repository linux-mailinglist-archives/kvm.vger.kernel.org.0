Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB33F5929
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbhHXHls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:41:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:33537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235189AbhHXHle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:41:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204453461"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="204453461"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:40:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="473402100"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 00:40:47 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 04/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
Date:   Tue, 24 Aug 2021 15:56:06 +0800
Message-Id: <1629791777-16430-5-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The number of Arch LBR entries available is determined by the value
in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
supported.

On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
(this is safe because the two values will be the same) when the Arch LBR
records MSRs are pass-through to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 63 ++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..a93b77b10933 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -515,6 +515,9 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/* Guest arch lbr depth supported by KVM. */
+	u64 kvm_arch_lbr_depth;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9efc1a6b8693..cddc23689846 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -211,7 +211,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int ret;
+	int ret = 0;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -220,6 +220,10 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -348,10 +352,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * Check if the requested depth value the same as that of host.
+ * When guest/host depth are different, the handling would be tricky,
+ * so now only max depth is supported for both host and guest.
+ */
+static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return false;
+
+	return (depth == pmu->kvm_arch_lbr_depth);
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 
 	switch (msr) {
@@ -367,6 +387,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_ARCH_LBR_DEPTH:
+		msr_info->data = lbr_desc->records.nr;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -393,8 +416,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u64 lbr_ctl;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -427,6 +452,30 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (!arch_lbr_depth_is_valid(vcpu, data))
+			return 1;
+		lbr_desc->records.nr = data;
+		if (msr_info->host_initiated)
+			return 0;
+
+		rdmsrl(MSR_ARCH_LBR_CTL, lbr_ctl);
+		/*
+		 * If the host is using Arch LBR on this CPU at this point,
+		 * then reject guest's request.
+		 */
+		if (lbr_ctl & ARCH_LBR_CTL_LBREN && !lbr_desc->event)
+			return 1;
+		/* If the event has been sched out, we don't write the msr.*/
+		if (lbr_desc->event &&
+		    lbr_desc->event->state < PERF_EVENT_STATE_ACTIVE)
+			return 1;
+		/*
+		 * Otherwise, guest is programming the depth MSR or reset lbr records
+		 * via short-cut, then allow write to the MSR.
+		 */
+		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -540,6 +589,18 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return;
+
+	entry = kvm_find_cpuid_entry(vcpu, 28, 0);
+	if (entry) {
+		/*
+		 * The depth mask in CPUID has been forced by KVM to that of host
+		 * supported value when user-space sets guest CPUID.
+		 */
+		pmu->kvm_arch_lbr_depth = fls(entry->eax & 0xff) * 8;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.25.1

