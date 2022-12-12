Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AB3649F49
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiLLNA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiLLNAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 08:00:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99B412AC5;
        Mon, 12 Dec 2022 04:59:34 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so15623375pjp.1;
        Mon, 12 Dec 2022 04:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubEWeHlBxKHaYOMQNFJfVx4kICdW2pJ9feDQxbalcaw=;
        b=lezNuKasW5mowgc5jAeyXnxYCNRCyJ+LH+6/UbLQWeu8hmPNRvx5DXCSkkb1nnQFyG
         Sz4bGBpwekANhBlTXfBL4h29X7UStVHC8+KYY2X+jGPav6H4mPPznLitbIfC51IfZ8Gt
         T5IEd2mLEqJnp3hlO/dbHtuztOqDyJDDwZI07sZ4RLft9AYW3hkiYlVA+tRHutR/J7/6
         BGTFRV8njfx92ORk0kaB8heLBkBBh4PrX/zoyEee4m9UXPGmobsPIWss9KS1OvVKBu6r
         yTKbcYNYNj4kp9r+bKTlNDzPASuO16VPlBEC/sBiriN4sQbNoucDyJJ85ma9hl0yYBDI
         BrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubEWeHlBxKHaYOMQNFJfVx4kICdW2pJ9feDQxbalcaw=;
        b=ObqqZLJpdQZ0go+x0dqTaQuTGBF1Jv6CAbeXym8slus4bumshg1PkbGKAEUNZIL0AU
         V93ekjHuGixjG4xZgGCY09TMWnrE1GImDQSSKKqSSFSymP8883k5o/IFUzgoVJgrv7+r
         heBbfFeIWrWX98oRLHvYNKGhzqBJs7QkyxB9RymYOYA/xu22diQP+8Ta6jndwDXXvyv3
         n77I0bGyj1IcX9wahzkBBhLgI5LeP44cXlP8QutLyUBbse2XuunFkPX5rhT11qzspdnc
         M+AwsrFpTdDGhtdhihi8V8NYBX+cUZSZUAOhGwqKS0rK4vtU9z/WDDdJsT65kNrVM1xF
         F81g==
X-Gm-Message-State: ANoB5pnHS5VZmAMCTLZBV3z1vEKOz1nrfKbDm0ooQsoedoxjZZ2UmRju
        4FGJWVj8UYswcoPjGaopBgI=
X-Google-Smtp-Source: AA0mqf45N/otSyPPXNDKFC0sjlQ8lDAWctELzAsQRZSHFE4C3eBpW3pBikcEFkYm4/Z9U6ZWpWuGbQ==
X-Received: by 2002:a17:902:7e06:b0:189:ed85:94d2 with SMTP id b6-20020a1709027e0600b00189ed8594d2mr13373461plm.1.1670849973950;
        Mon, 12 Dec 2022 04:59:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:33 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RFC 8/8] KVM: x86/pmu: Add MSR_PERF_METRICS MSR emulation to enable Topdown
Date:   Mon, 12 Dec 2022 20:58:44 +0800
Message-Id: <20221212125844.41157-9-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20221212125844.41157-1-likexu@tencent.com>
References: <20221212125844.41157-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The Ice Lake core PMU provides built-in support for Top-down Micro-
architecture Analysis (TMA) method level 1 metrics. These metrics are
always available to cross-validate performance observations, freeing
general purpose counters to count other events in high counter
utilization scenarios.

A new MSR called MSR_PERF_METRICS, hinted by PERF_CAPABILITIES.
PERF_METRICS_AVAILABLE (bit 15), reports four (on icx) TMA Level 1
metrics directly. The lower 32 bits are divided into four 8-bit fields
each of which is an integer fraction of 255. When performance metrics
use type 2000H (INTEL_PMC_FIXED_RDPMC_METRICS), rdpmc could read
the value of perf_metric.

Bit EN_PERF_METRICS[48] have also been added to the following MSRs:
- MSR_CORE_PERF_GLOBAL_CTRL
- MSR_CORE_PERF_GLOBAL_STATUS
- MSR_CORE_PERF_GLOBAL_OVF_CTRL

When it comes to KVM implementation, the topdown mode is only
enabled when guest starts both registers, PERF_METRICS and fixed
counter 3, from zero.

In topdwon mode, vPMU creates a group of zero sample period events
for fixed counter3. The first pmc->event is a group leader slot event,
and its event->count is used to emulate counter value, marking bit 35
when it generates an interrupt, as usual. (Note, the fixed counter3 can
be used independently, for counting or sampling, but isn't compatible
with topdown mode at the same time).

The four (or more) sub-events for perf_metrics are each emulated with
a metric event (its event attr.config is kernel-defined, starting with
INTEL_TD_METRIC_RETIRING), which increments independently and
share the same bit INTEL_PERF_METRICS_IDX on overflow.

When pmu->perf_metric is read, vPMU collects all event->count from
multiple metric events, but their original values have already been
processed by the host perf core (defined in icl_get_metrics_event_value(),
with a division and multiplication). This part of calculation logic needs
to be reversed in vPMU to restore their real values and stitch them
together in turn to form pmu->perf_metric.

The pmc_read_counter() has been enhanced, moved out of the header file,
and wrapped with EXPORT_SYMBOL_GPL. A little trick is that the PMC
corresponding to bit 35 and 48 (INTEL_PERF_METRICS_IDX) are both
fixed counter3, in order to lazy release of all above grouped events.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h  |   6 ++
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/kvm/pmu.c               | 105 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h               |  16 ++---
 arch/x86/kvm/vmx/pmu_intel.c     |  33 ++++++++++
 arch/x86/kvm/vmx/vmx.c           |   3 +
 arch/x86/kvm/x86.c               |   3 +
 7 files changed, 153 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 73740aa891d3..4f2e2ede09b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -522,6 +522,7 @@ struct kvm_pmc {
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
+	unsigned int nr_perf_metrics;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
 	u64 fixed_ctr_ctrl_mask;
@@ -564,6 +565,11 @@ struct kvm_pmu {
 	 */
 	u64 host_cross_mapped_mask;
 
+	/* Intel Topdown Performance Metrics */
+	u64 perf_metrics;
+	u64 perf_metrics_mask;
+	bool metric_event_ovf;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4a2af82553e4..5dde0242ff28 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -246,6 +246,7 @@
 #define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
 #define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
 				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
+#define MSR_CAP_PERF_METRICS           BIT_ULL(15)
 
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index ae53a8298dec..4bc888462b4f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -96,6 +96,11 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 	kvm_pmu_deliver_pmi(vcpu);
 }
 
+static inline bool pmc_support_perf_metrics(struct kvm_pmc *pmc)
+{
+	return pmc->idx == (INTEL_PMC_IDX_FIXED + 3);
+}
+
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -115,6 +120,10 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
 						      (unsigned long *)&pmu->global_status);
 		}
+	} else if (pmu->metric_event_ovf && pmc_support_perf_metrics(pmc)) {
+		/* At least one of PERF_METRICS sub-counter has overflowed */
+		__set_bit(INTEL_PERF_METRICS_IDX, (unsigned long *)&pmu->global_status);
+		pmu->metric_event_ovf = false;
 	} else {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
@@ -155,6 +164,16 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+static inline bool perf_metrics_is_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	return !pmu->perf_metrics && !pmc->counter &&
+		pmc_support_perf_metrics(pmc) && pmc_speculative_in_use(pmc) &&
+		pmc_is_enabled(pmc) && test_bit(GLOBAL_CTRL_EN_PERF_METRICS,
+						(unsigned long *)&pmu->global_ctrl);
+}
+
 static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 				 bool exclude_user, bool exclude_kernel,
 				 bool intr)
@@ -172,6 +191,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 		.config = config,
 	};
 	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
+	bool topdown = perf_metrics_is_enabled(pmc);
 	unsigned int i;
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
@@ -205,6 +225,10 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 			attr.precise_ip = 3;
 	}
 
+	/* A group of events is needed to emulate each perf_metric. */
+	if (topdown)
+		pmc->max_nr_events = pmu->nr_perf_metrics + 1;
+
 	/*
 	 * To create grouped events, the first created perf_event doesn't
 	 * know it will be the group_leader and may move to an unexpected
@@ -215,6 +239,17 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 		attr.disabled = 1;
 
 	for (i = 0; i < pmc->max_nr_events; i++) {
+		if (topdown) {
+			/*
+			 * According to perf core, the group_leader slots event must
+			 * not be a sampling event for topdown metric use, and the
+			 * topdown metric events don't support sampling.
+			 */
+			attr.sample_period = 0;
+			if (i)
+				attr.config = INTEL_TD_METRIC_RETIRING + 0x100 * (i - 1);
+		}
+
 		group_leader = i ? pmc->perf_event : NULL;
 		event = perf_event_create_kernel_counter(&attr, -1, current, group_leader,
 							 kvm_perf_overflow, pmc);
@@ -229,7 +264,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 	}
 
 	pmc->is_paused = false;
-	pmc->intr = intr || pebs;
+	pmc->intr = intr || pebs || topdown;
 
 	if (!attr.disabled)
 		return 0;
@@ -263,6 +298,9 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	if (!pmc->perf_event)
 		return false;
 
+	if (perf_metrics_is_enabled(pmc) == (pmc->max_nr_events == 1))
+		return false;
+
 	/* recalibrate sample period and check if it's accepted by perf core */
 	if (is_sampling_event(pmc->perf_event) &&
 	    perf_event_period(pmc->perf_event,
@@ -447,6 +485,60 @@ static int kvm_pmu_rdpmc_vmware(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	return 0;
 }
 
+void pmu_read_perf_metrics(struct kvm_pmu *pmu, u64 slots)
+{
+	struct kvm_pmc *pmc = &pmu->fixed_counters[3];
+	u64 old_counter, enabled, running, delta;
+	union {
+		u8 field[KVM_PERF_METRICS_NUM_MAX];
+		u64	data;
+	} perf_metrics;
+	unsigned int i;
+
+	perf_metrics.data = pmu->perf_metrics;
+	for (i = 1; i < pmc->max_nr_events; i++) {
+		if (!pmc->perf_events[i])
+			continue;
+
+		old_counter = perf_metrics.field[i - 1];
+		delta = perf_event_read_value(pmc->perf_events[i], &enabled, &running);
+
+		/*
+		 * Reverse the actual metric counter value out
+		 * according to icl_get_metrics_event_value().
+		 */
+		delta = mul_u64_u64_div_u64(delta, 0xff, slots) + 1;
+		perf_metrics.field[i - 1] = 0xff & (old_counter + delta);
+
+		/* Check if any metric counter have been overflowed. */
+		if (perf_metrics.field[i - 1] < old_counter)
+			pmu->metric_event_ovf = true;
+	}
+
+	if (pmu->metric_event_ovf)
+		__kvm_perf_overflow(pmc, false);
+
+	pmu->perf_metrics = perf_metrics.data & (~pmu->perf_metrics_mask);
+	__set_bit(INTEL_PERF_METRICS_IDX, pmu->pmc_in_use);
+}
+
+u64 pmc_read_counter(struct kvm_pmc *pmc)
+{
+	u64 counter, enabled, running, delta;
+
+	counter = pmc->counter;
+	if (pmc->perf_event && !pmc->is_paused) {
+		delta = perf_event_read_value(pmc->perf_event, &enabled, &running);
+		if (delta && pmc_support_perf_metrics(pmc))
+			pmu_read_perf_metrics(pmc_to_pmu(pmc), delta);
+		counter += delta;
+	}
+
+	/* FIXME: Scaling needed? */
+	return counter & pmc_bitmask(pmc);
+}
+EXPORT_SYMBOL_GPL(pmc_read_counter);
+
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 {
 	bool fast_mode = idx & (1u << 31);
@@ -469,7 +561,16 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	    (kvm_read_cr0(vcpu) & X86_CR0_PE))
 		return 1;
 
-	*data = pmc_read_counter(pmc) & mask;
+	if (idx & INTEL_PMC_FIXED_RDPMC_METRICS) {
+		if (!(vcpu->arch.perf_capabilities & MSR_CAP_PERF_METRICS))
+			return 1;
+
+		pmc_read_counter(&pmu->fixed_counters[3]);
+		*data = pmu->perf_metrics;
+	} else {
+		*data = pmc_read_counter(pmc) & mask;
+	}
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index e4b738b7c208..be800a0c5366 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -10,6 +10,8 @@
 
 #define MSR_IA32_MISC_ENABLE_PMU_RO_MASK (MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |	\
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
+#define INTEL_PERF_METRICS_IDX GLOBAL_CTRL_EN_PERF_METRICS
+#define KVM_PERF_METRICS_NUM_MAX	8
 
 /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
 #define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
@@ -42,6 +44,8 @@ struct kvm_pmu_ops {
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
+void pmu_read_perf_metrics(struct kvm_pmu *pmu, u64 slots);
+u64 pmc_read_counter(struct kvm_pmc *pmc);
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
@@ -50,18 +54,6 @@ static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 	return pmu->counter_bitmask[pmc->type];
 }
 
-static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
-{
-	u64 counter, enabled, running;
-
-	counter = pmc->counter;
-	if (pmc->perf_event && !pmc->is_paused)
-		counter += perf_event_read_value(pmc->perf_event,
-						 &enabled, &running);
-	/* FIXME: Scaling needed? */
-	return counter & pmc_bitmask(pmc);
-}
-
 static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 {
 	unsigned int i;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8e1f679d4d9d..52fef388fdb0 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -81,6 +81,8 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	if (pmc_idx < INTEL_PMC_IDX_FIXED) {
 		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
 				  MSR_P6_EVNTSEL0);
+	} else if (pmc_idx == INTEL_PERF_METRICS_IDX) {
+		return get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR3);
 	} else {
 		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
 
@@ -160,6 +162,12 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 		counters = pmu->gp_counters;
 		num_counters = pmu->nr_arch_gp_counters;
 	}
+
+	if (idx & INTEL_PMC_FIXED_RDPMC_METRICS) {
+		fixed = true;
+		idx = 3;
+	}
+
 	if (idx >= num_counters)
 		return NULL;
 	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
@@ -229,6 +237,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
 			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
 		break;
+	case MSR_PERF_METRICS:
+		ret = vcpu->arch.perf_capabilities & MSR_CAP_PERF_METRICS;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -385,6 +396,10 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PEBS_DATA_CFG:
 		msr_info->data = pmu->pebs_data_cfg;
 		return 0;
+	case MSR_PERF_METRICS:
+		pmc_read_counter(&pmu->fixed_counters[3]);
+		msr_info->data = pmu->perf_metrics;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -472,6 +487,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_PERF_METRICS:
+		if (pmu->perf_metrics == data)
+			return 0;
+		if (!(data & pmu->perf_metrics_mask)) {
+			pmu->perf_metrics = data;
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -545,6 +568,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
+	pmu->perf_metrics_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
@@ -584,6 +608,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
 	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
+	if (vcpu->arch.perf_capabilities & MSR_CAP_PERF_METRICS) {
+		counter_mask &= ~(1ULL << INTEL_PERF_METRICS_IDX);
+		pmu->nr_perf_metrics = min_t(int, KVM_PERF_METRICS_NUM_MAX,
+					     kvm_pmu_cap.num_topdown_events);
+		for (i = 0; i < pmu->nr_perf_metrics; i++)
+			pmu->perf_metrics_mask &= ~(0xffull << (i * 8));
+	}
 	pmu->global_ctrl_mask = counter_mask;
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
@@ -656,6 +687,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
 	lbr_desc->msr_passthrough = false;
+
+	BUILD_BUG_ON(KVM_PERF_METRICS_NUM_MAX > INTEL_TD_METRIC_NUM);
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..57312b5a3d9d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7721,6 +7721,9 @@ static u64 vmx_get_perf_capabilities(void)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
+	if (kvm_pmu_cap.num_topdown_events)
+		perf_cap |= host_perf_cap & MSR_CAP_PERF_METRICS;
+
 	return perf_cap;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b61cb58c877..a50b3ad7294c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1439,6 +1439,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
+	MSR_PERF_METRICS,
 
 	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
@@ -3880,6 +3881,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
+	case MSR_PERF_METRICS:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -3983,6 +3985,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
+	case MSR_PERF_METRICS:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
-- 
2.38.2

