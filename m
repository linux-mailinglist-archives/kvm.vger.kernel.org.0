Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1071130A12E
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhBAFW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:22:29 -0500
Received: from mga17.intel.com ([192.55.52.151]:9259 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhBAFUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:20:24 -0500
IronPort-SDR: tTiT6hQ07E1XMywayErJIdLbL1LWcf3OjWvX7NGPxYWVLQd91X9chhcoWoyDQoYCe/aC6gOdUA
 BM1lpj4xBoiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401837"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401837"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:23 -0800
IronPort-SDR: GEmaEI9gayyvjtkzEpdaqPVTOycsQYudS2F+KbVcz9K/tRFbvP6MnHCUYfwh7UJUKgM3BCFZa8
 FA/q9IeyBJ7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694292"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:20 -0800
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
Subject: [PATCH v14 05/11] KVM: vmx/pmu: Create a guest LBR event when vcpu sets DEBUGCTLMSR_LBR
Date:   Mon,  1 Feb 2021 13:10:33 +0800
Message-Id: <20210201051039.255478-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vcpu sets DEBUGCTLMSR_LBR in the MSR_IA32_DEBUGCTLMSR, the KVM handler
would create a guest LBR event which enables the callstack mode and none of
hardware counter is assigned. The host perf would schedule and enable this
event as usual but in an exclusive way.

The guest LBR event will be released when the vPMU is reset but soon,
the lazy release mechanism would be applied to this event like a vPMC.

Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 63 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c       |  3 ++
 arch/x86/kvm/vmx/vmx.h       | 10 ++++++
 3 files changed, 76 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e75a957b2068..22c271a1c7a4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -224,6 +224,66 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (lbr_desc->event) {
+		perf_event_release_kernel(lbr_desc->event);
+		lbr_desc->event = NULL;
+		vcpu_to_pmu(vcpu)->event_count--;
+	}
+}
+
+int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event;
+
+	/*
+	 * The perf_event_attr is constructed in the minimum efficient way:
+	 * - set 'pinned = true' to make it task pinned so that if another
+	 *   cpu pinned event reclaims LBR, the event->oncpu will be set to -1;
+	 * - set '.exclude_host = true' to record guest branches behavior;
+	 *
+	 * - set '.config = INTEL_FIXED_VLBR_EVENT' to indicates host perf
+	 *   schedule the event without a real HW counter but a fake one;
+	 *   check is_guest_lbr_event() and __intel_get_event_constraints();
+	 *
+	 * - set 'sample_type = PERF_SAMPLE_BRANCH_STACK' and
+	 *   'branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+	 *   PERF_SAMPLE_BRANCH_USER' to configure it as a LBR callstack
+	 *   event, which helps KVM to save/restore guest LBR records
+	 *   during host context switches and reduces quite a lot overhead,
+	 *   check branch_user_callstack() and intel_pmu_lbr_sched_task();
+	 */
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_RAW,
+		.size = sizeof(attr),
+		.config = INTEL_FIXED_VLBR_EVENT,
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+		.pinned = true,
+		.exclude_host = true,
+		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+					PERF_SAMPLE_BRANCH_USER,
+	};
+
+	if (unlikely(lbr_desc->event))
+		return 0;
+
+	event = perf_event_create_kernel_counter(&attr, -1,
+						current, NULL, NULL);
+	if (IS_ERR(event)) {
+		pr_debug_ratelimited("%s: failed %ld\n",
+					__func__, PTR_ERR(event));
+		return -ENOENT;
+	}
+	lbr_desc->event = event;
+	pmu->event_count++;
+	return 0;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -428,6 +488,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.perf_capabilities = 0;
 	lbr_desc->records.nr = 0;
+	lbr_desc->event = NULL;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -452,6 +513,8 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
+
+	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3c008dec407c..c85a42b39bed 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2023,6 +2023,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			data &= ~DEBUGCTLMSR_BTF;
 		}
 		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
+		    (data & DEBUGCTLMSR_LBR))
+			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1b0bbfffa1f0..ae645c2082ba 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -76,9 +76,19 @@ struct pt_desc {
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
+int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
+
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
 	struct x86_pmu_lbr records;
+
+	/*
+	 * Emulate LBR feature via passthrough LBR registers when the
+	 * per-vcpu guest LBR event is scheduled on the current pcpu.
+	 *
+	 * The records may be inaccurate if the host reclaims the LBR.
+	 */
+	struct perf_event *event;
 };
 
 /*
-- 
2.29.2

