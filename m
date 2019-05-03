Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428AF12E62
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfECMrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:49 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:32906 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbfECMrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B50C21682;
        Fri,  3 May 2019 05:47:48 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D82E3F220;
        Fri,  3 May 2019 05:47:45 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 53/56] arm64: KVM: Avoid isb's by using direct pmxevtyper sysreg
Date:   Fri,  3 May 2019 13:44:24 +0100
Message-Id: <20190503124427.190206-54-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

Upon entering or exiting a guest we may modify multiple PMU counters to
enable of disable EL0 filtering. We presently do this via the indirect
PMXEVTYPER_EL0 system register (where the counter we modify is selected
by PMSELR). With this approach it is necessary to order the writes via
isb instructions such that we select the correct counter before modifying
it.

Let's avoid potentially expensive instruction barriers by using the
direct PMEVTYPER<n>_EL0 registers instead.

As the change to counter type relates only to EL0 filtering we can rely
on the implicit instruction barrier which occurs when we transition from
EL2 to EL1 on entering the guest. On returning to userspace we can, at the
latest, rely on the implicit barrier between EL2 and EL0. We can also
depend on the explicit isb in armv8pmu_select_counter to order our write
against any other kernel changes by the PMU driver to the type register as
a result of preemption.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/pmu.c | 84 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 74 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 3f99a095a1ff..cd49db845ef4 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -91,6 +91,74 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+#define PMEVTYPER_READ_CASE(idx)				\
+	case idx:						\
+		return read_sysreg(pmevtyper##idx##_el0)
+
+#define PMEVTYPER_WRITE_CASE(idx)				\
+	case idx:						\
+		write_sysreg(val, pmevtyper##idx##_el0);	\
+		break
+
+#define PMEVTYPER_CASES(readwrite)				\
+	PMEVTYPER_##readwrite##_CASE(0);			\
+	PMEVTYPER_##readwrite##_CASE(1);			\
+	PMEVTYPER_##readwrite##_CASE(2);			\
+	PMEVTYPER_##readwrite##_CASE(3);			\
+	PMEVTYPER_##readwrite##_CASE(4);			\
+	PMEVTYPER_##readwrite##_CASE(5);			\
+	PMEVTYPER_##readwrite##_CASE(6);			\
+	PMEVTYPER_##readwrite##_CASE(7);			\
+	PMEVTYPER_##readwrite##_CASE(8);			\
+	PMEVTYPER_##readwrite##_CASE(9);			\
+	PMEVTYPER_##readwrite##_CASE(10);			\
+	PMEVTYPER_##readwrite##_CASE(11);			\
+	PMEVTYPER_##readwrite##_CASE(12);			\
+	PMEVTYPER_##readwrite##_CASE(13);			\
+	PMEVTYPER_##readwrite##_CASE(14);			\
+	PMEVTYPER_##readwrite##_CASE(15);			\
+	PMEVTYPER_##readwrite##_CASE(16);			\
+	PMEVTYPER_##readwrite##_CASE(17);			\
+	PMEVTYPER_##readwrite##_CASE(18);			\
+	PMEVTYPER_##readwrite##_CASE(19);			\
+	PMEVTYPER_##readwrite##_CASE(20);			\
+	PMEVTYPER_##readwrite##_CASE(21);			\
+	PMEVTYPER_##readwrite##_CASE(22);			\
+	PMEVTYPER_##readwrite##_CASE(23);			\
+	PMEVTYPER_##readwrite##_CASE(24);			\
+	PMEVTYPER_##readwrite##_CASE(25);			\
+	PMEVTYPER_##readwrite##_CASE(26);			\
+	PMEVTYPER_##readwrite##_CASE(27);			\
+	PMEVTYPER_##readwrite##_CASE(28);			\
+	PMEVTYPER_##readwrite##_CASE(29);			\
+	PMEVTYPER_##readwrite##_CASE(30)
+
+/*
+ * Read a value direct from PMEVTYPER<idx>
+ */
+static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
+{
+	switch (idx) {
+	PMEVTYPER_CASES(READ);
+	default:
+		WARN_ON(1);
+	}
+
+	return 0;
+}
+
+/*
+ * Write a value direct to PMEVTYPER<idx>
+ */
+static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
+{
+	switch (idx) {
+	PMEVTYPER_CASES(WRITE);
+	default:
+		WARN_ON(1);
+	}
+}
+
 /*
  * Modify ARMv8 PMU events to include EL0 counting
  */
@@ -100,11 +168,9 @@ static void kvm_vcpu_pmu_enable_el0(unsigned long events)
 	u32 counter;
 
 	for_each_set_bit(counter, &events, 32) {
-		write_sysreg(counter, pmselr_el0);
-		isb();
-		typer = read_sysreg(pmxevtyper_el0) & ~ARMV8_PMU_EXCLUDE_EL0;
-		write_sysreg(typer, pmxevtyper_el0);
-		isb();
+		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
+		typer &= ~ARMV8_PMU_EXCLUDE_EL0;
+		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
 	}
 }
 
@@ -117,11 +183,9 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
 	u32 counter;
 
 	for_each_set_bit(counter, &events, 32) {
-		write_sysreg(counter, pmselr_el0);
-		isb();
-		typer = read_sysreg(pmxevtyper_el0) | ARMV8_PMU_EXCLUDE_EL0;
-		write_sysreg(typer, pmxevtyper_el0);
-		isb();
+		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
+		typer |= ARMV8_PMU_EXCLUDE_EL0;
+		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
 	}
 }
 
-- 
2.20.1

