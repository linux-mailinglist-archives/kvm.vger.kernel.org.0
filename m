Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F29187B09
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 09:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgCQIRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 04:17:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:17620 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgCQIRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 04:17:30 -0400
IronPort-SDR: JWpHzikvSX4FPH3+JvEfRalfolr5JXzm/ewvSdi61VKpicIbCcgt6CQHzPNDv1oJpKq/XdR1Oq
 s2g0FZz6rOnA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 01:17:30 -0700
IronPort-SDR: PogRVo52L4c/bHJT8ZMdD3bunGoSsLhHQc/kjfz1lqeJ2kBhfpOnK+G1yBjX10VJVMqJyVoXWX
 HHJzp5nQh2ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="445419123"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2020 01:17:27 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com, like.xu@linux.intel.com
Cc:     ehankland@google.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: [PATCH v2] KVM: x86/pmu: Reduce counter period change overhead and delay the effective time
Date:   Tue, 17 Mar 2020 16:14:58 +0800
Message-Id: <20200317081458.88714-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200317075315.70933-1-like.xu@linux.intel.com>
References: <20200317075315.70933-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cost of perf_event_period() is unstable, and when the guest samples
multiple events, the overhead increases dramatically (5378 ns on E5-2699).

For a non-running counter, the effective time of the new period is when
its corresponding enable bit is enabled. Calling perf_event_period()
in advance is superfluous. For a running counter, it's safe to delay the
effective time until the KVM_REQ_PMU event is handled. If there are
multiple perf_event_period() calls before handling KVM_REQ_PMU,
it helps to reduce the total cost.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c           | 11 -----------
 arch/x86/kvm/pmu.h           | 11 +++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d1f8ca57d354..527a8bb85080 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -437,17 +437,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 }
 
-static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
-
-	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
-}
-
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d7da2b9e0755..cd112e825d2c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -138,6 +138,17 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7c857737b438..20f654a0c09b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -263,15 +263,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!msr_info->host_initiated)
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			if (pmc_speculative_in_use(pmc))
+				kvm_make_request(KVM_REQ_PMU, vcpu);
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			if (pmc_speculative_in_use(pmc))
+				kvm_make_request(KVM_REQ_PMU, vcpu);
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
-- 
2.21.1

