Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694D37AF952
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjI0EZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjI0EXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:23:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93151AD38;
        Tue, 26 Sep 2023 20:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695785110; x=1727321110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rNcgFo4RfvPd9sxyVAFnLLF4FaNWBPvZRCJYc76gwf8=;
  b=X7AjTMXFvaEQQc+hagwElzZog4E2GB47wrPNn3XwYdApreDlxEHu0o6P
   qst7qAJuSP5Y+lQm5DJrtmC3DWuHivZnDda7YWoszbacti+yBW4bj7Yko
   FMiLJaIZIKW1bSARdHpQQPKh2DAeGkayKRqOUqHeR+VQoikZ8CUp99wKT
   94e0o/Hq2Hxj00q1xjK/IzTOgW1k47vMdZqndSxGzfxTCMgBzF3dKupL+
   7xH0tu1sYpZM6MuLqrJBYPBH0Ob+YXk6ggqA9y/eIYxwIMrWN9aNX9ouu
   ZGA8+QCzSw6utuUQ9aiVMY++So6HtnzoC8YOqOVgQyz/UHc6cEOSQgNjM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="366780880"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="366780880"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864637269"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864637269"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 20:25:03 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v4 11/13] KVM: x86/pmu: Support topdown perf metrics feature
Date:   Wed, 27 Sep 2023 11:31:22 +0800
Message-Id: <20230927033124.1226509-12-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds topdown perf metrics support for KVM. The topdown perf
metrics is a feature on Intel CPUs which supports the TopDown
Microarchitecture Analysis (TMA) Method. TMA is a structured analysis
methodology to identify critical performance bottlenecks in out-of-order
processors. The details about topdown metrics support on Intel
processors can be found in section "Performance Metrics" of Intel's SDM.

Intel chips use fixed counter 3 and PERF_METRICS MSR together to support
topdown metrics feature. Fix counter 3 counts the elapsed cpu slots,
PERF_METRICS reports the topdown metrics percentage.

Generally speaking, KVM has no method to know guest is running a solo
slots event counting/sampling or guest is profiling the topdown perf
metrics if KVM only observes the fixed counter 3. Fortunately we know
topdown metrics profiling always manipulate fixed counter 3 and
PERF_METRICS MSR together with a fixed sequence, FIXED_CTR3 MSR is
written firstly and then PERF_METRICS follows. So we can assume topdown
metrics profiling is running in guest if KVM observes PERF_METRICS
writing.

In current perf logic, an events group is required to handle the topdown
metrics profiling, and the events group couples a slots event which
acts events group leader and multiple metric events. To coordinate with
the perf topdown metrics handing logic and reduce the code changes in
KVM, we choose to follow current mature vPMU PMC emulation framework. The
only difference is that we need to create a events group for fixed
counter 3 and manipulate FIXED_CTR3 and PERF_METRICS MSRS together
instead of a single event and only manipulating FIXED_CTR3 MSR.

When guest write PERF_METRICS MSR at first, KVM would create an event
group which couples a slots event and a virtual metrics event. In this
event group, slots event claims the fixed counter 3 HW resource and acts
as group leader which is required by perf system. The virtual metrics
event claims the PERF_METRICS MSR. This event group is just like the perf
metrics events group on host and is scheduled by host perf system.

In this proposal, the count of slots event is calculated and emulated
on host and returned to guest just like other normal counters, but there
is a difference for the metrics event processing. KVM doesn't calculate
the real count of topdown metrics, it just stores the raw data of
PERF_METRICS MSR and directly returns the stored raw data to guest. Thus,
guest can get the real HW PERF_METRICS data and guarantee the calculation
accuracy of topdown metrics.

The whole procedure can be summarized as below.
1. KVM intercepts PERF_METRICS MSR writing and marks fixed counter 3
   enter topdown profiling mode (set the max_nr_events of fixed counter 3
   to 2) if it's not.
2. If the topdown metrics events group doesn't exist, create the events
   group firstly, and then update the saved slots count and metrics data
   of the group events with guest values. At last, enable the events and
   make the guest values are loaded into HW FIXED_CTR3 and PERF_METRICS
   MSRs.
3. Modify kvm_pmu_rdpmc() function to return PERF_METRICS MSR raw data to
   guest directly.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++
 arch/x86/kvm/pmu.c              | 62 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/pmu.h              | 28 +++++++++++++++
 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 48 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  5 +++
 arch/x86/kvm/x86.c              |  1 +
 7 files changed, 149 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bf1626b2b553..19f8fb65e21e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -487,6 +487,12 @@ enum pmc_type {
 	KVM_PMC_FIXED,
 };
 
+enum topdown_events {
+	KVM_TD_SLOTS = 0,
+	KVM_TD_METRICS = 1,
+	KVM_TD_EVENTS_MAX = 2,
+};
+
 struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b02a56c77647..fad7b2c10bb8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -182,6 +182,30 @@ static u64 pmc_get_pebs_precise_level(struct kvm_pmc *pmc)
 	return 1;
 }
 
+static void pmc_setup_td_metrics_events_attr(struct kvm_pmc *pmc,
+					     struct perf_event_attr *attr,
+					     unsigned int event_idx)
+{
+	if (!pmc_is_topdown_metrics_used(pmc))
+		return;
+
+	/*
+	 * setup slots event attribute, when slots event is
+	 * created for guest topdown metrics profiling, the
+	 * sample period must be 0.
+	 */
+	if (event_idx == KVM_TD_SLOTS)
+		attr->sample_period = 0;
+
+	/* setup vmetrics event attribute */
+	if (event_idx == KVM_TD_METRICS) {
+		attr->config = INTEL_FIXED_VMETRICS_EVENT;
+		attr->sample_period = 0;
+		/* Only group leader event can be pinned. */
+		attr->pinned = false;
+	}
+}
+
 static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 				 bool exclude_user, bool exclude_kernel,
 				 bool intr)
@@ -233,6 +257,8 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 
 	for (i = 0; i < pmc->max_nr_events; i++) {
 		group_leader = i ? pmc->perf_event : NULL;
+		pmc_setup_td_metrics_events_attr(pmc, &attr, i);
+
 		event = perf_event_create_kernel_counter(&attr, -1,
 							 current, group_leader,
 							 kvm_perf_overflow, pmc);
@@ -256,6 +282,12 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 	pmc->is_paused = false;
 	pmc->intr = intr || pebs;
 
+	if (pmc_is_topdown_metrics_active(pmc)) {
+		pmc_update_topdown_metrics(pmc);
+		/* KVM need to inject PMI for PERF_METRICS overflow. */
+		pmc->intr = true;
+	}
+
 	if (!attr.disabled)
 		return 0;
 
@@ -269,6 +301,7 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
 {
 	u64 counter = pmc->counter;
 	unsigned int i;
+	u64 data;
 
 	if (!pmc->perf_event || pmc->is_paused)
 		return;
@@ -279,8 +312,15 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
 	 * then disable non-group leader events.
 	 */
 	counter += perf_event_pause(pmc->perf_event, true);
-	for (i = 1; pmc->perf_events[i] && i < pmc->max_nr_events; i++)
-		perf_event_pause(pmc->perf_events[i], true);
+	for (i = 1; pmc->perf_events[i] && i < pmc->max_nr_events; i++) {
+		data = perf_event_pause(pmc->perf_events[i], true);
+		/*
+		 * The count of vmetrics event actually stores raw data of
+		 * PERF_METRICS, save it to extra_config.
+		 */
+		if (pmc->idx == INTEL_PMC_IDX_FIXED_SLOTS && i == KVM_TD_METRICS)
+			pmc->extra_config = data;
+	}
 	pmc->counter = counter & pmc_bitmask(pmc);
 	pmc->is_paused = true;
 }
@@ -557,6 +597,21 @@ static int kvm_pmu_rdpmc_vmware(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	return 0;
 }
 
+static inline int kvm_pmu_read_perf_metrics(struct kvm_vcpu *vcpu,
+					    unsigned int idx, u64 *data)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR3);
+
+	if (!pmc) {
+		*data = 0;
+		return 1;
+	}
+
+	*data = pmc->extra_config;
+	return 0;
+}
+
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 {
 	bool fast_mode = idx & (1u << 31);
@@ -570,6 +625,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
+	if (idx & INTEL_PMC_FIXED_RDPMC_METRICS)
+		return kvm_pmu_read_perf_metrics(vcpu, idx, data);
+
 	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 3dc0deb83096..43abe793c11c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -257,6 +257,34 @@ static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
 }
 
+static inline int pmc_is_topdown_metrics_used(struct kvm_pmc *pmc)
+{
+	return (pmc->idx == INTEL_PMC_IDX_FIXED_SLOTS) &&
+	       (pmc->max_nr_events == KVM_TD_EVENTS_MAX);
+}
+
+static inline int pmc_is_topdown_metrics_active(struct kvm_pmc *pmc)
+{
+	return pmc_is_topdown_metrics_used(pmc) &&
+	       pmc->perf_events[KVM_TD_METRICS];
+}
+
+static inline void pmc_update_topdown_metrics(struct kvm_pmc *pmc)
+{
+	struct perf_event *event;
+	int i;
+
+	struct td_metrics td_metrics = {
+		.slots = pmc->counter,
+		.metric = pmc->extra_config,
+	};
+
+	for (i = 0; i < pmc->max_nr_events; i++) {
+		event = pmc->perf_events[i];
+		perf_event_topdown_metrics(event, &td_metrics);
+	}
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..d8317552b634 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -22,6 +22,7 @@ extern int __read_mostly pt_mode;
 #define PT_MODE_HOST_GUEST	1
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
+#define PMU_CAP_PERF_METRICS	BIT_ULL(15)
 #define PMU_CAP_LBR_FMT		0x3f
 
 struct nested_vmx_msrs {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b45396e0a46c..04ccb8c6f7e4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -229,6 +229,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
 			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
 		break;
+	case MSR_PERF_METRICS:
+		ret = intel_pmu_metrics_is_enabled(vcpu) && (pmu->version > 1);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -357,6 +360,43 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static int intel_pmu_handle_perf_metrics_access(struct kvm_vcpu *vcpu,
+						struct msr_data *msr_info, bool read)
+{
+	u32 index = msr_info->index;
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR3);
+
+	if (!pmc || index != MSR_PERF_METRICS)
+		return 1;
+
+	if (read) {
+		msr_info->data = pmc->extra_config;
+	} else {
+		/*
+		 * Save guest PERF_METRICS data in to extra_config,
+		 * the extra_config would be read to write to PERF_METRICS
+		 * MSR in later events group creating process.
+		 */
+		pmc->extra_config = msr_info->data;
+		if (pmc_is_topdown_metrics_active(pmc)) {
+			pmc_update_topdown_metrics(pmc);
+		} else {
+			/*
+			 * If the slots/vmetrics events group is not
+			 * created yet, set max_nr_events to 2
+			 * (slots event + vmetrics event), so KVM knows
+			 * topdown metrics profiling is running in guest
+			 * and slots/vmetrics events group would be created
+			 * later.
+			 */
+			pmc->max_nr_events = KVM_TD_EVENTS_MAX;
+		}
+	}
+
+	return 0;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -376,6 +416,10 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PEBS_DATA_CFG:
 		msr_info->data = pmu->pebs_data_cfg;
 		break;
+	case MSR_PERF_METRICS:
+		if (intel_pmu_handle_perf_metrics_access(vcpu, msr_info, true))
+			return 1;
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -438,6 +482,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		pmu->pebs_data_cfg = data;
 		break;
+	case MSR_PERF_METRICS:
+		if (intel_pmu_handle_perf_metrics_access(vcpu, msr_info, false))
+			return 1;
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..63b6dcc360c2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -670,6 +670,11 @@ static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 	return !!vcpu_to_lbr_records(vcpu)->nr;
 }
 
+static inline bool intel_pmu_metrics_is_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.perf_capabilities & PMU_CAP_PERF_METRICS;
+}
+
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 906af36850fb..1f4c4ebe2efc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1472,6 +1472,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
+	MSR_PERF_METRICS,
 
 	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
-- 
2.34.1

