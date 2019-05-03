Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E13012E61
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfECMrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:46 -0400
Received: from foss.arm.com ([217.140.101.70]:32886 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbfECMrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A73715AD;
        Fri,  3 May 2019 05:47:45 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02B333F220;
        Fri,  3 May 2019 05:47:41 -0700 (PDT)
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
Subject: [PATCH 52/56] arm64: KVM: Enable VHE support for :G/:H perf event modifiers
Date:   Fri,  3 May 2019 13:44:23 +0100
Message-Id: <20190503124427.190206-53-marc.zyngier@arm.com>
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

With VHE different exception levels are used between the host (EL2) and
guest (EL1) with a shared exception level for userpace (EL0). We can take
advantage of this and use the PMU's exception level filtering to avoid
enabling/disabling counters in the world-switch code. Instead we just
modify the counter type to include or exclude EL0 at vcpu_{load,put} time.

We also ensure that trapped PMU system register writes do not re-enable
EL0 when reconfiguring the backing perf events.

This approach completely avoids blackout windows seen with !VHE.

Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  3 ++
 arch/arm64/include/asm/kvm_host.h |  5 +-
 arch/arm64/kernel/perf_event.c    |  6 ++-
 arch/arm64/kvm/pmu.c              | 88 ++++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         |  3 ++
 virt/kvm/arm/arm.c                |  2 +
 6 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 2d721ab05925..075e1921fdd9 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -368,6 +368,9 @@ static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
 
+static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
+
 static inline void kvm_arm_vhe_guest_enter(void) {}
 static inline void kvm_arm_vhe_guest_exit(void) {}
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 645d74c705d6..2a8d3f8ca22c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -580,7 +580,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 {
-	return attr->exclude_host;
+	return (!has_vhe() && attr->exclude_host);
 }
 
 #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
@@ -594,6 +594,9 @@ void kvm_clr_pmu_events(u32 clr);
 
 void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt);
 bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt);
+
+void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
+void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #else
 static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 6bb28aaf5aea..314b1adedf06 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -847,8 +847,12 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	 * with other architectures (x86 and Power).
 	 */
 	if (is_kernel_in_hyp_mode()) {
-		if (!attr->exclude_kernel)
+		if (!attr->exclude_kernel && !attr->exclude_host)
 			config_base |= ARMV8_PMU_INCLUDE_EL2;
+		if (attr->exclude_guest)
+			config_base |= ARMV8_PMU_EXCLUDE_EL1;
+		if (attr->exclude_host)
+			config_base |= ARMV8_PMU_EXCLUDE_EL0;
 	} else {
 		if (!attr->exclude_hv && !attr->exclude_host)
 			config_base |= ARMV8_PMU_INCLUDE_EL2;
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 599e6d3f692e..3f99a095a1ff 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -8,11 +8,19 @@
 #include <asm/kvm_hyp.h>
 
 /*
- * Given the exclude_{host,guest} attributes, determine if we are going
- * to need to switch counters at guest entry/exit.
+ * Given the perf event attributes and system type, determine
+ * if we are going to need to switch counters at guest entry/exit.
  */
 static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
 {
+	/**
+	 * With VHE the guest kernel runs at EL1 and the host at EL2,
+	 * where user (EL0) is excluded then we have no reason to switch
+	 * counters.
+	 */
+	if (has_vhe() && attr->exclude_user)
+		return false;
+
 	/* Only switch if attributes are different */
 	return (attr->exclude_host != attr->exclude_guest);
 }
@@ -82,3 +90,79 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 	if (pmu->events_host)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
+
+/*
+ * Modify ARMv8 PMU events to include EL0 counting
+ */
+static void kvm_vcpu_pmu_enable_el0(unsigned long events)
+{
+	u64 typer;
+	u32 counter;
+
+	for_each_set_bit(counter, &events, 32) {
+		write_sysreg(counter, pmselr_el0);
+		isb();
+		typer = read_sysreg(pmxevtyper_el0) & ~ARMV8_PMU_EXCLUDE_EL0;
+		write_sysreg(typer, pmxevtyper_el0);
+		isb();
+	}
+}
+
+/*
+ * Modify ARMv8 PMU events to exclude EL0 counting
+ */
+static void kvm_vcpu_pmu_disable_el0(unsigned long events)
+{
+	u64 typer;
+	u32 counter;
+
+	for_each_set_bit(counter, &events, 32) {
+		write_sysreg(counter, pmselr_el0);
+		isb();
+		typer = read_sysreg(pmxevtyper_el0) | ARMV8_PMU_EXCLUDE_EL0;
+		write_sysreg(typer, pmxevtyper_el0);
+		isb();
+	}
+}
+
+/*
+ * On VHE ensure that only guest events have EL0 counting enabled
+ */
+void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_host_data *host;
+	u32 events_guest, events_host;
+
+	if (!has_vhe())
+		return;
+
+	host_ctxt = vcpu->arch.host_cpu_context;
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	events_guest = host->pmu_events.events_guest;
+	events_host = host->pmu_events.events_host;
+
+	kvm_vcpu_pmu_enable_el0(events_guest);
+	kvm_vcpu_pmu_disable_el0(events_host);
+}
+
+/*
+ * On VHE ensure that only host events have EL0 counting enabled
+ */
+void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_host_data *host;
+	u32 events_guest, events_host;
+
+	if (!has_vhe())
+		return;
+
+	host_ctxt = vcpu->arch.host_cpu_context;
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	events_guest = host->pmu_events.events_guest;
+	events_host = host->pmu_events.events_host;
+
+	kvm_vcpu_pmu_enable_el0(events_host);
+	kvm_vcpu_pmu_disable_el0(events_guest);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 12bd72e42b91..9d02643bc601 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -695,6 +695,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
+		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
@@ -850,6 +851,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
 		__vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_PMU_EVTYPE_MASK;
+		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;
 	}
@@ -875,6 +877,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMCNTENSET_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
 			kvm_pmu_enable_counter(vcpu, val);
+			kvm_vcpu_pmu_restore_guest(vcpu);
 		} else {
 			/* accessing PMCNTENCLR_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index e960b91551d6..8b7ca101f0f7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -382,6 +382,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_pmu_restore_guest(vcpu);
 
 	if (single_task_running())
 		vcpu_clear_wfe_traps(vcpu);
@@ -397,6 +398,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vcpu_put_sysregs(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
+	kvm_vcpu_pmu_restore_host(vcpu);
 
 	vcpu->cpu = -1;
 
-- 
2.20.1

