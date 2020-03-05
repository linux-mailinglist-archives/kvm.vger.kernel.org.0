Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7AF17A2AA
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgCEJ72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:16885 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgCEJ71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366551"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:59:18 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com
Subject: [PATCH v1 05/11] KVM: x86/pmu: Add support to reprogram PEBS event for guest counters
Date:   Fri,  6 Mar 2020 01:56:59 +0800
Message-Id: <1583431025-19802-6-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

When the event precise level is non-zero, the performance counter
will be reprogramed for PEBS event and set PBES PMI bit in global_status
when the PEBS event is overflowed. Since KVM never knows the setting
of precise level in guest because it's a SW parameter, we force all PEBS
events to be precise level 1 for enough accuracy with a dedicated counter.

Originally-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 69 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pmu_intel.c    |  1 +
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98959e8..83abb49 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -478,6 +478,7 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 pebs_enable;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b4f9e97..b2bdacb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -77,6 +77,11 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 
 	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+
+		/* Indicate PEBS overflow to guest. */
+		if (perf_event->attr.precise_ip)
+			__set_bit(62, (unsigned long *)&pmu->global_status);
+
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
 		/*
@@ -99,6 +104,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
 	struct perf_event *event;
 	struct perf_event_attr attr = {
 		.type = type,
@@ -111,6 +117,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.config = config,
 		.disabled = 1,
 	};
+	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
 
 	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
 
@@ -126,8 +133,50 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		attr.config |= HSW_IN_TX_CHECKPOINTED;
 	}
 
+	if (pebs) {
+		/*
+		 * Host never knows the precision level set by guest.
+		 * Force Host's PEBS event to precision level 1, which will
+		 * not impact the accuracy of the results for guest PEBS events.
+		 * Because,
+		 * - For most cases, there is no difference among precision
+		 *   level 1 to 3 for PEBS events.
+		 * - The functions as below checks the precision level in host.
+		 *   But the results from these functions in host are replaced
+		 *   by guest when sampling the guest.
+		 *   The accuracy for guest PEBS events will not be impacted.
+		 *    -- event_constraints() impacts the index of counter.
+		 *	The index for host event is exactly the same as guest.
+		 *	It's decided by guest.
+		 *    -- pebs_update_adaptive_cfg() impacts the value of
+		 *	MSR_PEBS_DATA_CFG. When guest is switched in,
+		 *	the MSR value will be replaced by the value from guest.
+		 *    -- setup_sample () impacts the output of a PEBS record.
+		 *	Guest handles the PEBS records.
+		 */
+		attr.precise_ip = 1;
+		/*
+		 * When the host's PMI handler completes, it's going to
+		 * enter the guest and trigger the guest's PMI handler.
+		 *
+		 * At this moment, this function may be called by
+		 * kvm_pmu_handle_event(). However the next sample_period
+		 * hasn't been determined by guest yet and the left period,
+		 * which probably be 0, is used for current sample_period.
+		 *
+		 * In this case, perf will mistakenly treat it as non
+		 * sampling events. The PEBS event will error out.
+		 *
+		 * Fill it with maximum period to prevent the error out.
+		 * The guest PMI handler will soon reprogram the counter.
+		 */
+		if (!attr.sample_period)
+			attr.sample_period = (-1ULL) & pmc_bitmask(pmc);
+	}
+
 	event = perf_event_create_kernel_counter(&attr, -1, current,
-						 intr ? kvm_perf_overflow_intr :
+						 (intr || pebs) ?
+						 kvm_perf_overflow_intr :
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
@@ -135,6 +184,20 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		return;
 	}
 
+	if (pebs) {
+		event->guest_dedicated_idx = pmc->idx;
+		/*
+		 * For guest PEBS events, guest takes the responsibility to
+		 * drain PEBS buffers, and load proper values to reset counters.
+		 *
+		 * Host will unconditionally set auto-reload flag for PEBS
+		 * events with fixed period which is not necessary. Host should
+		 * do nothing in drain_pebs() but inject the PMI into the guest.
+		 *
+		 * Unset the auto-reload flag for guest PEBS events.
+		 */
+		perf_x86_pmu_unset_auto_reload(event);
+	}
 	pmc->perf_event = event;
 	pmc_to_pmu(pmc)->event_count++;
 	perf_event_enable(event);
@@ -158,6 +221,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	if (!pmc->perf_event)
 		return false;
 
+	if (test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable)
+		!= (!!pmc->perf_event->attr.precise_ip))
+		return false;
+
 	/* recalibrate sample period and check if it's accepted by perf core */
 	if (perf_event_period(pmc->perf_event,
 			(-pmc->counter) & pmc_bitmask(pmc)))
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fd21cdb..ebadc33 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -293,6 +293,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_GP] = 0;
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
+	pmu->pebs_enable = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-- 
1.8.3.1

