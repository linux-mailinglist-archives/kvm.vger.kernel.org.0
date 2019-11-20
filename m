Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81138104118
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 17:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732886AbfKTQnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 11:43:11 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:58476 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732858AbfKTQnK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 11:43:10 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iXT4F-0007RI-Qz; Wed, 20 Nov 2019 17:42:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Julien Grall <julien.grall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Price <steven.price@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 07/22] KVM: arm64: Support stolen time reporting via shared structure
Date:   Wed, 20 Nov 2019 16:42:21 +0000
Message-Id: <20191120164236.29359-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
References: <20191120164236.29359-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com, drjones@redhat.com, borntraeger@de.ibm.com, christoffer.dall@arm.com, eric.auger@redhat.com, xypron.glpk@gmx.de, julien.grall@arm.com, mark.rutland@arm.com, bigeasy@linutronix.de, steven.price@arm.com, tglx@linutronix.de, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steven Price <steven.price@arm.com>

Implement the service call for configuring a shared structure between a
VCPU and the hypervisor in which the hypervisor can write the time
stolen from the VCPU's execution time by other tasks on the host.

User space allocates memory which is placed at an IPA also chosen by user
space. The hypervisor then updates the shared structure using
kvm_put_guest() to ensure single copy atomicity of the 64-bit value
reporting the stolen time in nanoseconds.

Whenever stolen time is enabled by the guest, the stolen time counter is
reset.

The stolen time itself is retrieved from the sched_info structure
maintained by the Linux scheduler code. We enable SCHEDSTATS when
selecting KVM Kconfig to ensure this value is meaningful.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_host.h   | 19 +++++++++++
 arch/arm64/include/asm/kvm_host.h | 20 ++++++++++++
 arch/arm64/kvm/Kconfig            |  1 +
 include/linux/kvm_types.h         |  2 ++
 virt/kvm/arm/arm.c                | 11 +++++++
 virt/kvm/arm/hypercalls.c         |  6 ++++
 virt/kvm/arm/pvtime.c             | 52 +++++++++++++++++++++++++++++++
 7 files changed, 111 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 5a0c3569ebde..5a077f85813f 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -39,6 +39,7 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -329,6 +330,24 @@ static inline long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	return SMCCC_RET_NOT_SUPPORTED;
 }
 
+static inline gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
+{
+	return GPA_INVALID;
+}
+
+static inline void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
+{
+}
+
+static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
+{
+	return false;
+}
+
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 93b46d9526d0..75ef37f79633 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -338,6 +339,13 @@ struct kvm_vcpu_arch {
 	/* True when deferrable sysregs are loaded on the physical CPU,
 	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
 	bool sysregs_loaded_on_cpu;
+
+	/* Guest PV state */
+	struct {
+		u64 steal;
+		u64 last_steal;
+		gpa_t base;
+	} steal;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -479,6 +487,18 @@ int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
+gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
+void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
+
+static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
+{
+	vcpu_arch->steal.base = GPA_INVALID;
+}
+
+static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
+{
+	return (vcpu_arch->steal.base != GPA_INVALID);
+}
 
 void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a67121d419a2..d8b88e40d223 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ config KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
+	select SCHEDSTATS
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index bde5374ae021..1c88e69db3d9 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -35,6 +35,8 @@ typedef unsigned long  gva_t;
 typedef u64            gpa_t;
 typedef u64            gfn_t;
 
+#define GPA_INVALID	(~(gpa_t)0)
+
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;
 typedef u64            hfn_t;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..2aba375dfd13 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -40,6 +40,10 @@
 #include <asm/kvm_coproc.h>
 #include <asm/sections.h>
 
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_pmu.h>
+#include <kvm/arm_psci.h>
+
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
 #endif
@@ -351,6 +355,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
+	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
+
 	return kvm_vgic_vcpu_init(vcpu);
 }
 
@@ -380,6 +386,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
+		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	if (single_task_running())
 		vcpu_clear_wfe_traps(vcpu);
@@ -645,6 +653,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 * that a VCPU sees new virtual interrupts.
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
+			kvm_update_stolen_time(vcpu);
 	}
 }
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index 97ea8b133e77..550dfa3e53cd 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -14,6 +14,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	u32 func_id = smccc_get_function(vcpu);
 	long val = SMCCC_RET_NOT_SUPPORTED;
 	u32 feature;
+	gpa_t gpa;
 
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
@@ -56,6 +57,11 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 		val = kvm_hypercall_pv_features(vcpu);
 		break;
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		gpa = kvm_init_stolen_time(vcpu);
+		if (gpa != GPA_INVALID)
+			val = gpa;
+		break;
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
index 9fc69fc2d683..b90b3a7bea85 100644
--- a/virt/kvm/arm/pvtime.c
+++ b/virt/kvm/arm/pvtime.c
@@ -3,8 +3,35 @@
 
 #include <linux/arm-smccc.h>
 
+#include <asm/pvclock-abi.h>
+
 #include <kvm/arm_hypercalls.h>
 
+void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 steal;
+	__le64 steal_le;
+	u64 offset;
+	int idx;
+	u64 base = vcpu->arch.steal.base;
+
+	if (base == GPA_INVALID)
+		return;
+
+	/* Let's do the local bookkeeping */
+	steal = vcpu->arch.steal.steal;
+	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.steal = steal;
+
+	steal_le = cpu_to_le64(steal);
+	idx = srcu_read_lock(&kvm->srcu);
+	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
+	kvm_put_guest(kvm, base + offset, steal_le, u64);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 {
 	u32 feature = smccc_get_arg1(vcpu);
@@ -12,9 +39,34 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
 		val = SMCCC_RET_SUCCESS;
 		break;
 	}
 
 	return val;
 }
+
+gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_stolen_time init_values = {};
+	struct kvm *kvm = vcpu->kvm;
+	u64 base = vcpu->arch.steal.base;
+	int idx;
+
+	if (base == GPA_INVALID)
+		return base;
+
+	/*
+	 * Start counting stolen time from the time the guest requests
+	 * the feature enabled.
+	 */
+	vcpu->arch.steal.steal = 0;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return base;
+}
-- 
2.20.1

