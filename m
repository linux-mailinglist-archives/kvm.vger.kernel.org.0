Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED91627103
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiKMQrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbiKMQqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:46:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67081DEF1
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:46:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA31960B7F
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 16:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F9BC433C1;
        Sun, 13 Nov 2022 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668357999;
        bh=zy0P7IlENTaz+Qq6WsrJrfCxb/a1cklBAJ7fWM11tFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJaJyq3GFE/6j0tU0KBdSk5q1v174FW9htDpW9FnhSTCSG8pXf50eq3/PgoRhQYBv
         KxhdBeexWeLjm9IUzHrXrN0IXi32SNQzwEHZl4GS618Z8qpBjEDUGgV6auOK5TQqCd
         s2xtgWPs2IRr8jAVE5d5PlK8xJjs/WGha8ExJbsaZd456wqqv4EwPykNKDIRsK5LGG
         axdq3Bn2rIIuipHVnp10csBQXMgkReOHgfOQ7hYzo57nuWB/DFgbHf2nsh9APC760o
         P70pW7T3M+tUirJLB6T8+Ltv+oNDQVqJ8VyAHwj90mL3taLc6MAaTj6ZN3Zn0+0+BB
         PgaVi41iZeLLA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouG0R-005oYZ-5B;
        Sun, 13 Nov 2022 16:38:51 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v4 16/16] KVM: arm64: PMU: Make kvm_pmc the main data structure
Date:   Sun, 13 Nov 2022 16:38:32 +0000
Message-Id: <20221113163832.3154370-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU code has historically been torn between referencing a counter
as a pair vcpu+index or as the PMC pointer.

Given that it is pretty easy to go from one representation to
the other, standardise on the latter which, IMHO, makes the
code slightly more readable. YMMV.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 174 +++++++++++++++++++-------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e3d5fe260dcc..cf929c626b79 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -22,9 +22,19 @@ DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 static LIST_HEAD(arm_pmus);
 static DEFINE_MUTEX(arm_pmus_lock);
 
-static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
+static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 
+static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
+{
+	return container_of(pmc, struct kvm_vcpu, arch.pmu.pmc[pmc->idx]);
+}
+
+static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
+{
+	return &vcpu->arch.pmu.pmc[cnt_idx];
+}
+
 static u32 kvm_pmu_event_mask(struct kvm *kvm)
 {
 	unsigned int pmuver;
@@ -46,38 +56,27 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 }
 
 /**
- * kvm_pmu_idx_is_64bit - determine if select_idx is a 64bit counter
- * @vcpu: The vcpu pointer
- * @select_idx: The counter index
+ * kvm_pmc_is_64bit - determine if counter is 64bit
+ * @pmc: counter context
  */
-static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
+static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
 {
-	return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
+	return (pmc->idx == ARMV8_PMU_CYCLE_IDX ||
+		kvm_pmu_is_3p5(kvm_pmc_to_vcpu(pmc)));
 }
 
-static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
+static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
 {
-	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 val = __vcpu_sys_reg(kvm_pmc_to_vcpu(pmc), PMCR_EL0);
 
-	return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
-	       (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
+	return (pmc->idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
+	       (pmc->idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
 }
 
-static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
+static bool kvm_pmu_counter_can_chain(struct kvm_pmc *pmc)
 {
-	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
-		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
-}
-
-static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu;
-	struct kvm_vcpu_arch *vcpu_arch;
-
-	pmc -= pmc->idx;
-	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
-	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
-	return container_of(vcpu_arch, struct kvm_vcpu, arch);
+	return (!(pmc->idx & 1) && (pmc->idx + 1) < ARMV8_PMU_CYCLE_IDX &&
+		!kvm_pmc_has_64bit_overflow(pmc));
 }
 
 static u32 counter_index_to_reg(u64 idx)
@@ -90,21 +89,12 @@ static u32 counter_index_to_evtreg(u64 idx)
 	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
 }
 
-/**
- * kvm_pmu_get_counter_value - get PMU counter value
- * @vcpu: The vcpu pointer
- * @select_idx: The counter index
- */
-u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
+static u64 kvm_pmu_get_pmc_value(struct kvm_pmc *pmc)
 {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	u64 counter, reg, enabled, running;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
-
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
 
-	reg = counter_index_to_reg(select_idx);
+	reg = counter_index_to_reg(pmc->idx);
 	counter = __vcpu_sys_reg(vcpu, reg);
 
 	/*
@@ -115,25 +105,35 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 		counter += perf_event_read_value(pmc->perf_event, &enabled,
 						 &running);
 
-	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
+	if (!kvm_pmc_is_64bit(pmc))
 		counter = lower_32_bits(counter);
 
 	return counter;
 }
 
-static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 select_idx, u64 val,
-				bool force)
+/**
+ * kvm_pmu_get_counter_value - get PMU counter value
+ * @vcpu: The vcpu pointer
+ * @select_idx: The counter index
+ */
+u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	u64 reg;
-
 	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
+		return 0;
 
-	kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
+	return kvm_pmu_get_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
+}
 
-	reg = counter_index_to_reg(select_idx);
+static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	u64 reg;
 
-	if (vcpu_mode_is_32bit(vcpu) && select_idx != ARMV8_PMU_CYCLE_IDX &&
+	kvm_pmu_release_perf_event(pmc);
+
+	reg = counter_index_to_reg(pmc->idx);
+
+	if (vcpu_mode_is_32bit(vcpu) && pmc->idx != ARMV8_PMU_CYCLE_IDX &&
 	    !force) {
 		/*
 		 * Even with PMUv3p5, AArch32 cannot write to the top
@@ -148,7 +148,7 @@ static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 select_idx, u64 val,
 	__vcpu_sys_reg(vcpu, reg) = val;
 
 	/* Recreate the perf event to reflect the updated sample_period */
-	kvm_pmu_create_perf_event(vcpu, select_idx);
+	kvm_pmu_create_perf_event(pmc);
 }
 
 /**
@@ -159,7 +159,10 @@ static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 select_idx, u64 val,
  */
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
-	kvm_pmu_set_counter(vcpu, select_idx, val, false);
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
+	kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx), val, false);
 }
 
 /**
@@ -181,14 +184,15 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
  *
  * If this counter has been configured to monitor some event, release it here.
  */
-static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
+static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	u64 reg, val;
 
 	if (!pmc->perf_event)
 		return;
 
-	val = kvm_pmu_get_counter_value(vcpu, pmc->idx);
+	val = kvm_pmu_get_pmc_value(pmc);
 
 	reg = counter_index_to_reg(pmc->idx);
 
@@ -219,11 +223,10 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	int i;
 
 	for_each_set_bit(i, &mask, 32)
-		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
+		kvm_pmu_stop_counter(kvm_vcpu_idx_to_pmc(vcpu, i));
 }
 
 /**
@@ -234,10 +237,9 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
-		kvm_pmu_release_perf_event(&pmu->pmc[i]);
+		kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, i));
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
@@ -262,9 +264,6 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc;
-
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
@@ -272,13 +271,15 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+		struct kvm_pmc *pmc;
+
 		if (!(val & BIT(i)))
 			continue;
 
-		pmc = &pmu->pmc[i];
+		pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
 
 		if (!pmc->perf_event) {
-			kvm_pmu_create_perf_event(vcpu, i);
+			kvm_pmu_create_perf_event(pmc);
 		} else {
 			perf_event_enable(pmc->perf_event);
 			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
@@ -297,17 +298,17 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc;
 
 	if (!kvm_vcpu_has_pmu(vcpu) || !val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+		struct kvm_pmc *pmc;
+
 		if (!(val & BIT(i)))
 			continue;
 
-		pmc = &pmu->pmc[i];
+		pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
 
 		if (pmc->perf_event)
 			perf_event_disable(pmc->perf_event);
@@ -427,6 +428,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 	mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 
 	for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
+		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
 		u64 type, reg;
 
 		/* Filter on event type */
@@ -437,30 +439,30 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 
 		/* Increment this counter */
 		reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
-		if (!kvm_pmu_idx_is_64bit(vcpu, i))
+		if (!kvm_pmc_is_64bit(pmc))
 			reg = lower_32_bits(reg);
 		__vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
 
 		/* No overflow? move on */
-		if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
+		if (kvm_pmc_has_64bit_overflow(pmc) ? reg : lower_32_bits(reg))
 			continue;
 
 		/* Mark overflow */
 		__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
 
-		if (kvm_pmu_counter_can_chain(vcpu, i))
+		if (kvm_pmu_counter_can_chain(pmc))
 			kvm_pmu_counter_increment(vcpu, BIT(i + 1),
 						  ARMV8_PMUV3_PERFCTR_CHAIN);
 	}
 }
 
 /* Compute the sample period for a given counter value */
-static u64 compute_period(struct kvm_vcpu *vcpu, u64 select_idx, u64 counter)
+static u64 compute_period(struct kvm_pmc *pmc, u64 counter)
 {
 	u64 val;
 
-	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
-		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
+	if (kvm_pmc_is_64bit(pmc)) {
+		if (!kvm_pmc_has_64bit_overflow(pmc))
 			val = -(counter & GENMASK(31, 0));
 		else
 			val = (-counter) & GENMASK(63, 0);
@@ -490,7 +492,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	 * Reset the sample period to the architectural limit,
 	 * i.e. the point where the counter overflows.
 	 */
-	period = compute_period(vcpu, idx, local64_read(&perf_event->count));
+	period = compute_period(pmc, local64_read(&perf_event->count));
 
 	local64_set(&perf_event->hw.period_left, 0);
 	perf_event->attr.sample_period = period;
@@ -498,7 +500,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
 
-	if (kvm_pmu_counter_can_chain(vcpu, idx))
+	if (kvm_pmu_counter_can_chain(pmc))
 		kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
 					  ARMV8_PMUV3_PERFCTR_CHAIN);
 
@@ -551,34 +553,33 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
-			kvm_pmu_set_counter(vcpu, i, 0, true);
+			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
 }
 
-static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
+static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
 {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
-	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(select_idx));
+	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx));
 }
 
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
- * @vcpu: The vcpu pointer
- * @select_idx: The number of selected counter
+ * @pmc: Counter context
  */
-static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
+static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
 	struct perf_event *event;
 	struct perf_event_attr attr;
-	u64 eventsel, counter, reg, data;
+	u64 eventsel, reg, data;
 
-	reg = counter_index_to_evtreg(select_idx);
+	reg = counter_index_to_evtreg(pmc->idx);
 	data = __vcpu_sys_reg(vcpu, reg);
 
-	kvm_pmu_stop_counter(vcpu, pmc);
+	kvm_pmu_stop_counter(pmc);
 	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
 	else
@@ -604,24 +605,22 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	attr.type = arm_pmu->pmu.type;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
-	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
+	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
 	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
 	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = eventsel;
 
-	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
-
 	/*
 	 * If counting with a 64bit counter, advertise it to the perf
 	 * code, carefully dealing with the initial sample period
 	 * which also depends on the overflow.
 	 */
-	if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
+	if (kvm_pmc_is_64bit(pmc))
 		attr.config1 |= PERF_ATTR_CFG1_COUNTER_64BIT;
 
-	attr.sample_period = compute_period(vcpu, select_idx, counter);
+	attr.sample_period = compute_period(pmc, kvm_pmu_get_pmc_value(pmc));
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_pmu_perf_overflow, pmc);
@@ -648,6 +647,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx)
 {
+	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, select_idx);
 	u64 reg, mask;
 
 	if (!kvm_vcpu_has_pmu(vcpu))
@@ -657,11 +657,11 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
 
-	reg = counter_index_to_evtreg(select_idx);
+	reg = counter_index_to_evtreg(pmc->idx);
 
 	__vcpu_sys_reg(vcpu, reg) = data & mask;
 
-	kvm_pmu_create_perf_event(vcpu, select_idx);
+	kvm_pmu_create_perf_event(pmc);
 }
 
 void kvm_host_pmu_init(struct arm_pmu *pmu)
-- 
2.34.1

