Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93515635AD
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfGIMZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:48 -0400
Received: from foss.arm.com ([217.140.110.172]:42796 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbfGIMZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A27B1597;
        Tue,  9 Jul 2019 05:25:46 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72A5E3F59C;
        Tue,  9 Jul 2019 05:25:44 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/18] KVM: arm/arm64: Support chained PMU counters
Date:   Tue,  9 Jul 2019 13:25:02 +0100
Message-Id: <20190709122507.214494-14-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709122507.214494-1-marc.zyngier@arm.com>
References: <20190709122507.214494-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

ARMv8 provides support for chained PMU counters, where an event type
of 0x001E is set for odd-numbered counters, the event counter will
increment by one for each overflow of the preceding even-numbered
counter. Let's emulate this in KVM by creating a 64 bit perf counter
when a user chains two emulated counters together.

For chained events we only support generating an overflow interrupt
on the high counter. We use the attributes of the low counter to
determine the attributes of the perf event.

Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_pmu.h |   2 +
 virt/kvm/arm/pmu.c    | 252 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 217 insertions(+), 37 deletions(-)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 48a15d4b820e..16c769a7f979 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -11,6 +11,7 @@
 #include <asm/perf_event.h>
 
 #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
+#define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
 
 #ifdef CONFIG_KVM_ARM_PMU
 
@@ -22,6 +23,7 @@ struct kvm_pmc {
 struct kvm_pmu {
 	int irq_num;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
+	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
 	bool ready;
 	bool created;
 	bool irq_level;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 24c6cf869a16..3dd8238ed246 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -15,6 +15,8 @@
 
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
 
+#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
+
 /**
  * kvm_pmu_idx_is_64bit - determine if select_idx is a 64bit counter
  * @vcpu: The vcpu pointer
@@ -26,29 +28,126 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
 		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
 }
 
+static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu;
+	struct kvm_vcpu_arch *vcpu_arch;
+
+	pmc -= pmc->idx;
+	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
+	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
+	return container_of(vcpu_arch, struct kvm_vcpu, arch);
+}
+
 /**
- * kvm_pmu_get_counter_value - get PMU counter value
+ * kvm_pmu_pmc_is_chained - determine if the pmc is chained
+ * @pmc: The PMU counter pointer
+ */
+static bool kvm_pmu_pmc_is_chained(struct kvm_pmc *pmc)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+
+	return test_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
+}
+
+/**
+ * kvm_pmu_idx_is_high_counter - determine if select_idx is a high/low counter
+ * @select_idx: The counter index
+ */
+static bool kvm_pmu_idx_is_high_counter(u64 select_idx)
+{
+	return select_idx & 0x1;
+}
+
+/**
+ * kvm_pmu_get_canonical_pmc - obtain the canonical pmc
+ * @pmc: The PMU counter pointer
+ *
+ * When a pair of PMCs are chained together we use the low counter (canonical)
+ * to hold the underlying perf event.
+ */
+static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
+{
+	if (kvm_pmu_pmc_is_chained(pmc) &&
+	    kvm_pmu_idx_is_high_counter(pmc->idx))
+		return pmc - 1;
+
+	return pmc;
+}
+
+/**
+ * kvm_pmu_idx_has_chain_evtype - determine if the event type is chain
  * @vcpu: The vcpu pointer
  * @select_idx: The counter index
  */
-u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
+static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	u64 counter, reg, enabled, running;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	u64 eventsel, reg;
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
-	counter = __vcpu_sys_reg(vcpu, reg);
+	select_idx |= 0x1;
+
+	if (select_idx == ARMV8_PMU_CYCLE_IDX)
+		return false;
+
+	reg = PMEVTYPER0_EL0 + select_idx;
+	eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
+
+	return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
+}
+
+/**
+ * kvm_pmu_get_pair_counter_value - get PMU counter value
+ * @vcpu: The vcpu pointer
+ * @pmc: The PMU counter pointer
+ */
+static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
+					  struct kvm_pmc *pmc)
+{
+	u64 counter, counter_high, reg, enabled, running;
 
-	/* The real counter value is equal to the value of counter register plus
+	if (kvm_pmu_pmc_is_chained(pmc)) {
+		pmc = kvm_pmu_get_canonical_pmc(pmc);
+		reg = PMEVCNTR0_EL0 + pmc->idx;
+
+		counter = __vcpu_sys_reg(vcpu, reg);
+		counter_high = __vcpu_sys_reg(vcpu, reg + 1);
+
+		counter = lower_32_bits(counter) | (counter_high << 32);
+	} else {
+		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
+		      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
+		counter = __vcpu_sys_reg(vcpu, reg);
+	}
+
+	/*
+	 * The real counter value is equal to the value of counter register plus
 	 * the value perf event counts.
 	 */
 	if (pmc->perf_event)
 		counter += perf_event_read_value(pmc->perf_event, &enabled,
 						 &running);
 
-	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
+	return counter;
+}
+
+/**
+ * kvm_pmu_get_counter_value - get PMU counter value
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	u64 counter;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
+
+	if (kvm_pmu_pmc_is_chained(pmc) &&
+	    kvm_pmu_idx_is_high_counter(select_idx))
+		counter = upper_32_bits(counter);
+
+	else if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
 		counter = lower_32_bits(counter);
 
 	return counter;
@@ -78,6 +177,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
  */
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
 {
+	pmc = kvm_pmu_get_canonical_pmc(pmc);
 	if (pmc->perf_event) {
 		perf_event_disable(pmc->perf_event);
 		perf_event_release_kernel(pmc->perf_event);
@@ -95,13 +195,23 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 {
 	u64 counter, reg;
 
-	if (pmc->perf_event) {
-		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
+	pmc = kvm_pmu_get_canonical_pmc(pmc);
+	if (!pmc->perf_event)
+		return;
+
+	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
+
+	if (kvm_pmu_pmc_is_chained(pmc)) {
+		reg = PMEVCNTR0_EL0 + pmc->idx;
+		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
+		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
+	} else {
 		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
-		__vcpu_sys_reg(vcpu, reg) = counter;
-		kvm_pmu_release_perf_event(pmc);
+		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
 	}
+
+	kvm_pmu_release_perf_event(pmc);
 }
 
 /**
@@ -118,6 +228,8 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
 		pmu->pmc[i].idx = i;
 	}
+
+	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
 }
 
 /**
@@ -166,6 +278,18 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 			continue;
 
 		pmc = &pmu->pmc[i];
+
+		/*
+		 * For high counters of chained events we must recreate the
+		 * perf event with the long (64bit) attribute set.
+		 */
+		if (kvm_pmu_pmc_is_chained(pmc) &&
+		    kvm_pmu_idx_is_high_counter(i)) {
+			kvm_pmu_create_perf_event(vcpu, i);
+			continue;
+		}
+
+		/* At this point, pmc must be the canonical */
 		if (pmc->perf_event) {
 			perf_event_enable(pmc->perf_event);
 			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
@@ -195,6 +319,18 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 			continue;
 
 		pmc = &pmu->pmc[i];
+
+		/*
+		 * For high counters of chained events we must recreate the
+		 * perf event with the long (64bit) attribute unset.
+		 */
+		if (kvm_pmu_pmc_is_chained(pmc) &&
+		    kvm_pmu_idx_is_high_counter(i)) {
+			kvm_pmu_create_perf_event(vcpu, i);
+			continue;
+		}
+
+		/* At this point, pmc must be the canonical */
 		if (pmc->perf_event)
 			perf_event_disable(pmc->perf_event);
 	}
@@ -284,17 +420,6 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
 	kvm_pmu_update_state(vcpu);
 }
 
-static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu;
-	struct kvm_vcpu_arch *vcpu_arch;
-
-	pmc -= pmc->idx;
-	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
-	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
-	return container_of(vcpu_arch, struct kvm_vcpu, arch);
-}
-
 /**
  * When the perf event overflows, set the overflow status and inform the vcpu.
  */
@@ -385,13 +510,20 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+	struct kvm_pmc *pmc;
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	u64 eventsel, counter, reg, data;
 
-	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
-	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
+	/*
+	 * For chained counters the event type and filtering attributes are
+	 * obtained from the low/even counter. We also use this counter to
+	 * determine if the event is enabled/disabled.
+	 */
+	pmc = kvm_pmu_get_canonical_pmc(&pmu->pmc[select_idx]);
+
+	reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
+	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
 	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
@@ -399,30 +531,47 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 
 	/* Software increment event does't need to be backed by a perf event */
 	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
-	    select_idx != ARMV8_PMU_CYCLE_IDX)
+	    pmc->idx != ARMV8_PMU_CYCLE_IDX)
 		return;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.type = PERF_TYPE_RAW;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
-	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, select_idx);
+	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
 	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
 	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
-	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
+	attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
 		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
 
-	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
-	/* The initial sample period (overflow count) of an event. */
-	if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
+
+	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
+		/**
+		 * The initial sample period (overflow count) of an event. For
+		 * chained counters we only support overflow interrupts on the
+		 * high counter.
+		 */
 		attr.sample_period = (-counter) & GENMASK(63, 0);
-	else
-		attr.sample_period = (-counter) & GENMASK(31, 0);
+		event = perf_event_create_kernel_counter(&attr, -1, current,
+							 kvm_pmu_perf_overflow,
+							 pmc + 1);
+
+		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
+			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
+	} else {
+		/* The initial sample period (overflow count) of an event. */
+		if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+			attr.sample_period = (-counter) & GENMASK(63, 0);
+		else
+			attr.sample_period = (-counter) & GENMASK(31, 0);
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
+		event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_pmu_perf_overflow, pmc);
+	}
+
 	if (IS_ERR(event)) {
 		pr_err_once("kvm: pmu event creation failed %ld\n",
 			    PTR_ERR(event));
@@ -432,6 +581,33 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	pmc->perf_event = event;
 }
 
+/**
+ * kvm_pmu_update_pmc_chained - update chained bitmap
+ * @vcpu: The vcpu pointer
+ * @select_idx: The number of selected counter
+ *
+ * Update the chained bitmap based on the event type written in the
+ * typer register.
+ */
+static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
+		/*
+		 * During promotion from !chained to chained we must ensure
+		 * the adjacent counter is stopped and its event destroyed
+		 */
+		if (!kvm_pmu_pmc_is_chained(pmc))
+			kvm_pmu_stop_counter(vcpu, pmc);
+
+		set_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
+	} else {
+		clear_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
+	}
+}
+
 /**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
@@ -451,6 +627,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
 
 	__vcpu_sys_reg(vcpu, reg) = event_type;
+
+	kvm_pmu_update_pmc_chained(vcpu, select_idx);
 	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
-- 
2.20.1

