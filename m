Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45470C8BEE
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 16:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfJBOvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 10:51:04 -0400
Received: from foss.arm.com ([217.140.110.172]:46274 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbfJBOvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 10:51:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 604631597;
        Wed,  2 Oct 2019 07:51:03 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EE973F706;
        Wed,  2 Oct 2019 07:51:01 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/10] KVM: arm64: Support stolen time reporting via shared structure
Date:   Wed,  2 Oct 2019 15:50:32 +0100
Message-Id: <20191002145037.51630-6-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002145037.51630-1-steven.price@arm.com>
References: <20191002145037.51630-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 arch/arm/include/asm/kvm_host.h   | 20 +++++++++++
 arch/arm64/include/asm/kvm_host.h | 21 +++++++++++-
 arch/arm64/kvm/Kconfig            |  1 +
 include/linux/kvm_types.h         |  2 ++
 virt/kvm/arm/arm.c                | 11 ++++++
 virt/kvm/arm/hypercalls.c         |  3 ++
 virt/kvm/arm/pvtime.c             | 56 +++++++++++++++++++++++++++++++
 7 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 5a0c3569ebde..5c401482d62d 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -39,6 +39,7 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -329,6 +330,25 @@ static inline long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	return SMCCC_RET_NOT_SUPPORTED;
 }
 
+static inline long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
+{
+	return SMCCC_RET_NOT_SUPPORTED;
+}
+
+static inline int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
+{
+	return -ENOTSUPP;
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
index 93b46d9526d0..1697e63f6dd8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -338,8 +339,14 @@ struct kvm_vcpu_arch {
 	/* True when deferrable sysregs are loaded on the physical CPU,
 	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
 	bool sysregs_loaded_on_cpu;
-};
 
+	/* Guest PV state */
+	struct {
+		u64 steal;
+		u64 last_steal;
+		gpa_t base;
+	} steal;
+};
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
 				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
@@ -479,6 +486,18 @@ int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
+long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu);
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init);
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
index 86c6aa1cb58e..5d3059aeadb1 100644
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
+			kvm_update_stolen_time(vcpu, false);
 	}
 }
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index e2521e0d3978..3091a5d2e842 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -56,6 +56,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_HV_PV_FEATURES:
 		val = kvm_hypercall_pv_features(vcpu);
 		break;
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		val = kvm_hypercall_stolen_time(vcpu);
+		break;
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
index 7887a61651c6..d9d0dbc6994b 100644
--- a/virt/kvm/arm/pvtime.c
+++ b/virt/kvm/arm/pvtime.c
@@ -3,8 +3,45 @@
 
 #include <linux/arm-smccc.h>
 
+#include <asm/pvclock-abi.h>
+
 #include <kvm/arm_hypercalls.h>
 
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 steal;
+	u64 steal_le;
+	u64 offset;
+	int idx;
+	u64 base = vcpu->arch.steal.base;
+
+	if (base == GPA_INVALID)
+		return -ENOTSUPP;
+
+	/* Let's do the local bookkeeping */
+	steal = vcpu->arch.steal.steal;
+	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.steal = steal;
+
+	steal_le = cpu_to_le64(steal);
+	idx = srcu_read_lock(&kvm->srcu);
+	if (init) {
+		struct pvclock_vcpu_stolen_time init_values = {
+			.revision = 0,
+			.attributes = 0
+		};
+		kvm_write_guest(kvm, base, &init_values,
+				sizeof(init_values));
+	}
+	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
+	kvm_put_guest(kvm, base + offset, steal_le, u64);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return 0;
+}
+
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 {
 	u32 feature = smccc_get_arg1(vcpu);
@@ -12,6 +49,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
 		val = SMCCC_RET_SUCCESS;
 		break;
 	}
@@ -19,3 +57,21 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	return val;
 }
 
+long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
+{
+	int err;
+
+	/*
+	 * Start counting stolen time from the time the guest requests
+	 * the feature enabled.
+	 */
+	vcpu->arch.steal.steal = 0;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+
+	err = kvm_update_stolen_time(vcpu, true);
+
+	if (err)
+		return SMCCC_RET_NOT_SUPPORTED;
+
+	return vcpu->arch.steal.base;
+}
-- 
2.20.1

