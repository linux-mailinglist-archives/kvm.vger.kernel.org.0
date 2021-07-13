Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD79C3C71AB
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 15:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhGMOB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236696AbhGMOB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 10:01:57 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 393206128B;
        Tue, 13 Jul 2021 13:59:07 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m3IwD-00D5p8-LF; Tue, 13 Jul 2021 14:59:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, kernel-team@android.com
Subject: [PATCH 3/3] KVM: arm64: Disabling disabled PMU counters wastes a lot of time
Date:   Tue, 13 Jul 2021 14:59:00 +0100
Message-Id: <20210713135900.1473057-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713135900.1473057-1-maz@kernel.org>
References: <20210713135900.1473057-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandre Chartre <alexandre.chartre@oracle.com>

In a KVM guest on arm64, performance counters interrupts have an
unnecessary overhead which slows down execution when using the "perf
record" command and limits the "perf record" sampling period.

The problem is that when a guest VM disables counters by clearing the
PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.

KVM disables a counter by calling into the perf framework, in particular
by calling perf_event_create_kernel_counter() which is a time consuming
operation. So, for example, with a Neoverse N1 CPU core which has 6 event
counters and one cycle counter, KVM will always disable all 7 counters
even if only one is enabled.

This typically happens when using the "perf record" command in a guest
VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
uses the cycle counter. And when using the "perf record" -F option with
a high profiling frequency, the overhead of KVM disabling all counters
instead of one on every counter interrupt becomes very noticeable.

The problem is fixed by having KVM disable only counters which are
enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
then KVM will not enable it when setting PMCR_EL0.E and it will remain
disabled as long as it is not enabled in PMCNTENSET_EL0. So there is
effectively no need to disable a counter when clearing PMCR_EL0.E if it
is not enabled PMCNTENSET_EL0.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
[maz: moved 'mask' close to the actual user, simplifying the patch]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210712170345.660272-1-alexandre.chartre@oracle.com
---
 arch/arm64/kvm/pmu-emul.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fae4e95b586c..dc65b58dc68f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -563,20 +563,21 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
  */
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
-	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
 	int i;
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	} else {
-		kvm_pmu_disable_counter_mask(vcpu, mask);
+		kvm_pmu_disable_counter_mask(vcpu,
+		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	}
 
 	if (val & ARMV8_PMU_PMCR_C)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
+		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_counter_value(vcpu, i, 0);
-- 
2.30.2

