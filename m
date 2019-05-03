Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4160812E57
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfECMre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:34 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:32796 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbfECMrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3596880D;
        Fri,  3 May 2019 05:47:31 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F205A3F220;
        Fri,  3 May 2019 05:47:27 -0700 (PDT)
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
Subject: [PATCH 48/56] arm64: KVM: Encapsulate kvm_cpu_context in kvm_host_data
Date:   Fri,  3 May 2019 13:44:19 +0100
Message-Id: <20190503124427.190206-49-marc.zyngier@arm.com>
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

The virt/arm core allocates a kvm_cpu_context_t percpu, at present this is
a typedef to kvm_cpu_context and is used to store host cpu context. The
kvm_cpu_context structure is also used elsewhere to hold vcpu context.
In order to use the percpu to hold additional future host information we
encapsulate kvm_cpu_context in a new structure and rename the typedef and
percpu to match.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 10 +++++++---
 arch/arm64/include/asm/kvm_asm.h  |  3 ++-
 arch/arm64/include/asm/kvm_host.h | 16 ++++++++++------
 arch/arm64/kernel/asm-offsets.c   |  1 +
 virt/kvm/arm/arm.c                | 14 ++++++++------
 5 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index fe7754315e9c..2d721ab05925 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -153,9 +153,13 @@ struct kvm_cpu_context {
 	u32 cp15[NR_CP15_REGS];
 };
 
-typedef struct kvm_cpu_context kvm_cpu_context_t;
+struct kvm_host_data {
+	struct kvm_cpu_context host_ctxt;
+};
+
+typedef struct kvm_host_data kvm_host_data_t;
 
-static inline void kvm_init_host_cpu_context(kvm_cpu_context_t *cpu_ctxt,
+static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt,
 					     int cpu)
 {
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
@@ -185,7 +189,7 @@ struct kvm_vcpu_arch {
 	struct kvm_vcpu_fault_info fault;
 
 	/* Host FP context */
-	kvm_cpu_context_t *host_cpu_context;
+	struct kvm_cpu_context *host_cpu_context;
 
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f5b79e995f40..ff73f5462aca 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -108,7 +108,8 @@ extern u32 __kvm_get_mdcr_el2(void);
 .endm
 
 .macro get_host_ctxt reg, tmp
-	hyp_adr_this_cpu \reg, kvm_host_cpu_state, \tmp
+	hyp_adr_this_cpu \reg, kvm_host_data, \tmp
+	add	\reg, \reg, #HOST_DATA_CONTEXT
 .endm
 
 .macro get_vcpu_ptr vcpu, ctxt
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f772ac2fb3e9..9ba59832b71a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -233,7 +233,11 @@ struct kvm_cpu_context {
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
-typedef struct kvm_cpu_context kvm_cpu_context_t;
+struct kvm_host_data {
+	struct kvm_cpu_context host_ctxt;
+};
+
+typedef struct kvm_host_data kvm_host_data_t;
 
 struct vcpu_reset_state {
 	unsigned long	pc;
@@ -278,7 +282,7 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch external_debug_state;
 
 	/* Pointer to host CPU context */
-	kvm_cpu_context_t *host_cpu_context;
+	struct kvm_cpu_context *host_cpu_context;
 
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
@@ -483,9 +487,9 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
+DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
 
-static inline void kvm_init_host_cpu_context(kvm_cpu_context_t *cpu_ctxt,
+static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt,
 					     int cpu)
 {
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
@@ -503,8 +507,8 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	u64 tpidr_el2 = ((u64)this_cpu_ptr(&kvm_host_cpu_state) -
-			 (u64)kvm_ksym_ref(kvm_host_cpu_state));
+	u64 tpidr_el2 = ((u64)this_cpu_ptr(&kvm_host_data) -
+			 (u64)kvm_ksym_ref(kvm_host_data));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 8178330a9f7a..768b23101ff0 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -134,6 +134,7 @@ int main(void)
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
+  DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 156c09da9e2b..e960b91551d6 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -56,7 +56,7 @@
 __asm__(".arch_extension	virt");
 #endif
 
-DEFINE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
+DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* Per-CPU variable containing the currently running vcpu. */
@@ -360,8 +360,10 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
+	kvm_host_data_t *cpu_data;
 
 	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
+	cpu_data = this_cpu_ptr(&kvm_host_data);
 
 	/*
 	 * We might get preempted before the vCPU actually runs, but
@@ -373,7 +375,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	vcpu->cpu = cpu;
-	vcpu->arch.host_cpu_context = this_cpu_ptr(&kvm_host_cpu_state);
+	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
 
 	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
@@ -1569,11 +1571,11 @@ static int init_hyp_mode(void)
 	}
 
 	for_each_possible_cpu(cpu) {
-		kvm_cpu_context_t *cpu_ctxt;
+		kvm_host_data_t *cpu_data;
 
-		cpu_ctxt = per_cpu_ptr(&kvm_host_cpu_state, cpu);
-		kvm_init_host_cpu_context(cpu_ctxt, cpu);
-		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1, PAGE_HYP);
+		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
+		kvm_init_host_cpu_context(&cpu_data->host_ctxt, cpu);
+		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
 
 		if (err) {
 			kvm_err("Cannot map host CPU state: %d\n", err);
-- 
2.20.1

