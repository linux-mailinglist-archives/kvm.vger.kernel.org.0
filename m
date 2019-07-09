Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30A6635AB
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGIMZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:25:44 -0400
Received: from foss.arm.com ([217.140.110.172]:42776 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbfGIMZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:25:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39FAC1576;
        Tue,  9 Jul 2019 05:25:42 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E3E53F59C;
        Tue,  9 Jul 2019 05:25:40 -0700 (PDT)
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
Subject: [PATCH 11/18] KVM: arm/arm64: Re-create event when setting counter value
Date:   Tue,  9 Jul 2019 13:25:00 +0100
Message-Id: <20190709122507.214494-12-marc.zyngier@arm.com>
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

The perf event sample_period is currently set based upon the current
counter value, when PMXEVTYPER is written to and the perf event is created.
However the user may choose to write the type before the counter value in
which case sample_period will be set incorrectly. Let's instead decouple
event creation from PMXEVTYPER and (re)create the event in either
suitation.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/pmu.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index efdc7f6db6cd..f77643f4274c 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -13,6 +13,7 @@
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
 
+static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -51,6 +52,9 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
+
+	/* Recreate the perf event to reflect the updated sample_period */
+	kvm_pmu_create_perf_event(vcpu, select_idx);
 }
 
 /**
@@ -367,23 +371,21 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 }
 
 /**
- * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
+ * kvm_pmu_create_perf_event - create a perf event for a counter
  * @vcpu: The vcpu pointer
- * @data: The data guest writes to PMXEVTYPER_EL0
  * @select_idx: The number of selected counter
- *
- * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
- * event with given hardware event number. Here we call perf_event API to
- * emulate this action and create a kernel perf event for it.
  */
-void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
-				    u64 select_idx)
+static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
 	struct perf_event *event;
 	struct perf_event_attr attr;
-	u64 eventsel, counter;
+	u64 eventsel, counter, reg, data;
+
+	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
+	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
+	data = __vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
 	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
@@ -420,6 +422,28 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	pmc->perf_event = event;
 }
 
+/**
+ * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
+ * @vcpu: The vcpu pointer
+ * @data: The data guest writes to PMXEVTYPER_EL0
+ * @select_idx: The number of selected counter
+ *
+ * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
+ * event with given hardware event number. Here we call perf_event API to
+ * emulate this action and create a kernel perf event for it.
+ */
+void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
+				    u64 select_idx)
+{
+	u64 reg, event_type = data & ARMV8_PMU_EVTYPE_MASK;
+
+	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
+	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
+
+	__vcpu_sys_reg(vcpu, reg) = event_type;
+	kvm_pmu_create_perf_event(vcpu, select_idx);
+}
+
 bool kvm_arm_support_pmu_v3(void)
 {
 	/*
-- 
2.20.1

