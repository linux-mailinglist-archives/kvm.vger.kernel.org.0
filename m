Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CDBCFE64
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 18:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfJHQB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 12:01:57 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:57057 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728081AbfJHQB5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Oct 2019 12:01:57 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iHrvv-0001rs-7i; Tue, 08 Oct 2019 18:01:55 +0200
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v2 5/5] KVM: arm64: pmu: Reset sample period on overflow handling
Date:   Tue,  8 Oct 2019 17:01:28 +0100
Message-Id: <20191008160128.8872-6-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008160128.8872-1-maz@kernel.org>
References: <20191008160128.8872-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, andrew.murray@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU emulation code uses the perf event sample period to trigger
the overflow detection. This works fine  for the *first* overflow
handling, but results in a huge number of interrupts on the host,
unrelated to the number of interrupts handled in the guest (a x20
factor is pretty common for the cycle counter). On a slow system
(such as a SW model), this can result in the guest only making
forward progress at a glacial pace.

It turns out that the clue is in the name. The sample period is
exactly that: a period. And once the an overflow has occured,
the following period should be the full width of the associated
counter, instead of whatever the guest had initially programed.

Reset the sample period to the architected value in the overflow
handler, which now results in a number of host interrupts that is
much closer to the number of interrupts in the guest.

Fixes: b02386eb7dac ("arm64: KVM: Add PMU overflow interrupt routing")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/pmu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 25a483a04beb..8b524d74c68a 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -442,6 +442,20 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	int idx = pmc->idx;
+	u64 period;
+
+	/*
+	 * Reset the sample period to the architectural limit,
+	 * i.e. the point where the counter overflows.
+	 */
+	period = -(local64_read(&pmc->perf_event->count));
+
+	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+		period &= GENMASK(31, 0);
+
+	local64_set(&pmc->perf_event->hw.period_left, 0);
+	pmc->perf_event->attr.sample_period = period;
+	pmc->perf_event->hw.sample_period = period;
 
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
 
@@ -557,6 +571,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
 		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
+	attr.config1 = PERF_ATTR_CFG1_RELOAD_EVENT;
 
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
-- 
2.20.1

