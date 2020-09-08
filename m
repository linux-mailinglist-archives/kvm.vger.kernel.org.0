Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE870260CCB
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgIHH7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729956AbgIHH6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:58:48 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC7E218AC;
        Tue,  8 Sep 2020 07:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599551927;
        bh=PTXwQoLNzVw8n2B2UXJ5WLwz7WpymCh7HcTkvegZdXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxS3vwyp+td5GDsGiOuY4tN2T3P8LYEaUzOfg4RNHUi72AfgmROOFzTWC3O2nMXdM
         oS/6nI2POrKdWUep3AOffGRlxzoXVObEeydGAFYxYHTUS38HkpXEDoRItqUGUgFM2p
         YTSer7pdtuyCzWSCU1IqLs1OOpXtInKgApT0rE5U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kFYWb-009zhy-Oj; Tue, 08 Sep 2020 08:58:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>, graf@amazon.com,
        kernel-team@android.com
Subject: [PATCH v3 2/5] KVM: arm64: Use event mask matching architecture revision
Date:   Tue,  8 Sep 2020 08:58:27 +0100
Message-Id: <20200908075830.1161921-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908075830.1161921-1-maz@kernel.org>
References: <20200908075830.1161921-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com, graf@amazon.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU code suffers from a small defect where we assume that the event
number provided by the guest is always 16 bit wide, even if the CPU only
implements the ARMv8.0 architecture. This isn't really problematic in
the sense that the event number ends up in a system register, cropping
it to the right width, but still this needs fixing.

In order to make it work, let's probe the version of the PMU that the
guest is going to use. This is done by temporarily creating a kernel
event and looking at the PMUVer field that has been saved at probe time
in the associated arm_pmu structure. This in turn gets saved in the kvm
structure, and subsequently used to compute the event mask that gets
used throughout the PMU code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/pmu-emul.c         | 81 +++++++++++++++++++++++++++++--
 2 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 65568b23868a..6cd60be69c28 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -110,6 +110,8 @@ struct kvm_arch {
 	 * supported.
 	 */
 	bool return_nisv_io_abort_to_user;
+
+	unsigned int pmuver;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 93d797df42c6..8a5f65763814 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -20,6 +20,20 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
 
 #define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
 
+static u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	switch (kvm->arch.pmuver) {
+	case 1:			/* ARMv8.0 */
+		return GENMASK(9, 0);
+	case 4:			/* ARMv8.1 */
+	case 5:			/* ARMv8.4 */
+	case 6:			/* ARMv8.5 */
+		return GENMASK(15, 0);
+	default:		/* Shouldn't be there, just for sanity */
+		return 0;
+	}
+}
+
 /**
  * kvm_pmu_idx_is_64bit - determine if select_idx is a 64bit counter
  * @vcpu: The vcpu pointer
@@ -100,7 +114,7 @@ static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
 		return false;
 
 	reg = PMEVTYPER0_EL0 + select_idx;
-	eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
+	eventsel = __vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu->kvm);
 
 	return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
 }
@@ -495,7 +509,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 
 		/* PMSWINC only applies to ... SW_INC! */
 		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
-		type &= ARMV8_PMU_EVTYPE_EVENT;
+		type &= kvm_pmu_event_mask(vcpu->kvm);
 		if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
 			continue;
 
@@ -578,7 +592,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
-	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
+	eventsel = data & kvm_pmu_event_mask(vcpu->kvm);;
 
 	/* Software increment event does't need to be backed by a perf event */
 	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
@@ -679,17 +693,68 @@ static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx)
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx)
 {
-	u64 reg, event_type = data & ARMV8_PMU_EVTYPE_MASK;
+	u64 reg, mask;
+
+	mask  =  ARMV8_PMU_EVTYPE_MASK;
+	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
+	mask |= kvm_pmu_event_mask(vcpu->kvm);
 
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
 
-	__vcpu_sys_reg(vcpu, reg) = event_type;
+	__vcpu_sys_reg(vcpu, reg) = data & mask;
 
 	kvm_pmu_update_pmc_chained(vcpu, select_idx);
 	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
+static int kvm_pmu_probe_pmuver(void)
+{
+	struct perf_event_attr attr = { };
+	struct perf_event *event;
+	struct arm_pmu *pmu;
+	int pmuver = 0xf;
+
+	/*
+	 * Create a dummy event that only counts user cycles. As we'll never
+	 * leave thing function with the event being live, it will never
+	 * count anything. But it allows us to probe some of the PMU
+	 * details. Yes, this is terrible.
+	 */
+	attr.type = PERF_TYPE_RAW;
+	attr.size = sizeof(attr);
+	attr.pinned = 1;
+	attr.disabled = 0;
+	attr.exclude_user = 0;
+	attr.exclude_kernel = 1;
+	attr.exclude_hv = 1;
+	attr.exclude_host = 1;
+	attr.config = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+	attr.sample_period = GENMASK(63, 0);
+
+	event = perf_event_create_kernel_counter(&attr, -1, current,
+						 kvm_pmu_perf_overflow, &attr);
+
+	if (IS_ERR(event)) {
+		pr_err_once("kvm: pmu event creation failed %ld\n",
+			    PTR_ERR(event));
+		return 0xf;
+	}
+
+	if (event->pmu) {
+		pmu = to_arm_pmu(event->pmu);
+		if (pmu->pmuver)
+			pmuver = pmu->pmuver;
+		pr_debug("PMU on CPUs %*pbl version %x\n",
+			 cpumask_pr_args(&pmu->supported_cpus), pmuver);
+	}
+
+	perf_event_disable(event);
+	perf_event_release_kernel(event);
+
+	return pmuver;
+}
+
 bool kvm_arm_support_pmu_v3(void)
 {
 	/*
@@ -796,6 +861,12 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
+	if (!vcpu->kvm->arch.pmuver)
+		vcpu->kvm->arch.pmuver = kvm_pmu_probe_pmuver();
+
+	if (vcpu->kvm->arch.pmuver == 0xf)
+		return -ENODEV;
+
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
-- 
2.28.0

