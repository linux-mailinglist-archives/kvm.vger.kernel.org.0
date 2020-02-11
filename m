Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670241596C8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgBKRvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbgBKRvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:43 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52672206D7;
        Tue, 11 Feb 2020 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443501;
        bh=Pp+Sia3oFFzauowV5v05awPTOI+wk4zff4Y+ELG9ZVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkPP3SqpBzxDFUrQbBfAy3VqrQ7/zs3BktYAOKA+ciUY7EUeacW4EFyOwzfuwkW3D
         ftq/hcUO9ISrKXfCuCo0gj1xAYALorGXOdbiES2mgq6IIL5AZl0XLYx/v+Mx0AKMms
         n3qOcXIyQEfypjXFs/bREo7zwHgKK7XlWdvvjR9A=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgH-004O7k-UH; Tue, 11 Feb 2020 17:50:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 82/94] KVM: arm64: Make struct kvm_regs userspace-only
Date:   Tue, 11 Feb 2020 17:49:26 +0000
Message-Id: <20200211174938.27809-83-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct kvm_regs is used by userspace to indicate which register gets
accessed by the {GET,SET}_ONE_REG API. But as we're about to refactor
the layout of the in-kernel register structures, we need the kernel to
move away from it.

Let's make kvm_regs userspace only, and let the kernel map it to its own
internal representation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 20 ++++----
 arch/arm64/include/asm/kvm_host.h    | 12 ++++-
 arch/arm64/kernel/asm-offsets.c      |  3 +-
 arch/arm64/kvm/fpsimd.c              |  2 +-
 arch/arm64/kvm/guest.c               | 70 +++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/entry.S           |  3 +-
 arch/arm64/kvm/hyp/switch.c          |  4 +-
 arch/arm64/kvm/hyp/sysreg-sr.c       | 30 ++++++------
 arch/arm64/kvm/regmap.c              |  6 +--
 arch/arm64/kvm/reset.c               |  2 +-
 arch/arm64/kvm/sys_regs.c            | 12 ++---
 11 files changed, 113 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1ff1735ff2b3..16cd99ab7170 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -159,12 +159,12 @@ static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 
 static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
+	return (unsigned long *)&vcpu_gp_regs(vcpu)->pc;
 }
 
 static inline unsigned long *__vcpu_elr_el1(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->elr_el1;
+	return (unsigned long *)&vcpu->arch.ctxt.elr_el1;
 }
 
 static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
@@ -185,7 +185,7 @@ static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long
 
 static inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pstate;
+	return (unsigned long *)&vcpu_gp_regs(vcpu)->pstate;
 }
 
 static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
@@ -214,19 +214,19 @@ static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
 static inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
 					 u8 reg_num)
 {
-	return (reg_num == 31) ? 0 : vcpu_gp_regs(vcpu)->regs.regs[reg_num];
+	return (reg_num == 31) ? 0 : vcpu_gp_regs(vcpu)->regs[reg_num];
 }
 
 static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 				unsigned long val)
 {
 	if (reg_num != 31)
-		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
+		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
 }
 
 static inline bool vcpu_mode_el2_ctxt(const struct kvm_cpu_context *ctxt)
 {
-	unsigned long cpsr = ctxt->gp_regs.regs.pstate;
+	unsigned long cpsr = ctxt->regs.pstate;
 
 	switch (cpsr & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
 	case PSR_MODE_EL2h:
@@ -327,7 +327,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
+		return vcpu->arch.ctxt.spsr[KVM_SPSR_EL1];
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -345,7 +345,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
+		vcpu->arch.ctxt.spsr[KVM_SPSR_EL1] = v;
 }
 
 /*
@@ -676,11 +676,11 @@ static inline void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_instr)
 static inline void __hyp_text __kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
-	vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(SYS_SPSR);
+	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
 
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 
-	write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, SYS_SPSR);
+	write_sysreg_el2(vcpu_gp_regs(vcpu)->pstate, SYS_SPSR);
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 }
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e48ec1ba057..29ecd13ab4e2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -332,7 +332,15 @@ enum vcpu_sysreg {
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
 struct kvm_cpu_context {
-	struct kvm_regs	gp_regs;
+	struct user_pt_regs regs;	/* sp = sp_el0 */
+
+	u64	sp_el1;
+	u64	elr_el1;
+
+	u64	spsr[KVM_NR_SPSR];
+
+	struct user_fpsimd_state fp_regs;
+
 	union {
 		u64 sys_regs[NR_SYS_REGS];
 		u32 copro[NR_COPRO_REGS];
@@ -504,7 +512,7 @@ struct kvm_vcpu_arch {
 				  system_supports_generic_auth()) && \
 				 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
 
-#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
+#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index a5bdce8af65b..e5ad90a2543f 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -94,13 +94,12 @@ int main(void)
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
-  DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
+  DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
   DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
   DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
   DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
-  DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
 #endif
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 738ee805aa3c..b983b3f13156 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -86,7 +86,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
+		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl);
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index c75b5498c048..fb416f624920 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -104,6 +104,55 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 	return size;
 }
 
+static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	u64 off = core_reg_offset_from_id(reg->id);
+
+	switch (off) {
+	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
+	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
+		off -= KVM_REG_ARM_CORE_REG(regs.regs[0]);
+		off /= 2;
+		return &vcpu->arch.ctxt.regs.regs[off];
+
+	case KVM_REG_ARM_CORE_REG(regs.sp):
+		return &vcpu->arch.ctxt.regs.sp;
+
+	case KVM_REG_ARM_CORE_REG(regs.pc):
+		return &vcpu->arch.ctxt.regs.pc;
+
+	case KVM_REG_ARM_CORE_REG(regs.pstate):
+		return &vcpu->arch.ctxt.regs.pstate;
+
+	case KVM_REG_ARM_CORE_REG(sp_el1):
+		return &vcpu->arch.ctxt.sp_el1;
+
+	case KVM_REG_ARM_CORE_REG(elr_el1):
+		return &vcpu->arch.ctxt.elr_el1;
+
+	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
+	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
+		off -= KVM_REG_ARM_CORE_REG(spsr[0]);
+		off /= 2;
+		return &vcpu->arch.ctxt.spsr[off];
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
+	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
+		off -= KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
+		off /= 4;
+		return &vcpu->arch.ctxt.fp_regs.vregs[off];
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
+		return &vcpu->arch.ctxt.fp_regs.fpsr;
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
+		return &vcpu->arch.ctxt.fp_regs.fpcr;
+
+	default:
+		return NULL;
+	}
+}
+
 static int validate_core_offset(const struct kvm_vcpu *vcpu,
 				const struct kvm_one_reg *reg)
 {
@@ -128,8 +177,8 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	 * off the index in the "array".
 	 */
 	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
-	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
-	int nr_regs = sizeof(*regs) / sizeof(__u32);
+	int nr_regs = sizeof(struct kvm_regs) / sizeof(__u32);
+	void *addr;
 	u32 off;
 
 	/* Our ID is an index into the kvm_regs struct. */
@@ -141,7 +190,11 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (validate_core_offset(vcpu, reg))
 		return -EINVAL;
 
-	if (copy_to_user(uaddr, ((u32 *)regs) + off, KVM_REG_SIZE(reg->id)))
+	addr = core_reg_addr(vcpu, reg);
+	if (!addr)		/* Should not happen... */
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, addr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
 	return 0;
@@ -150,10 +203,9 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
-	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
-	int nr_regs = sizeof(*regs) / sizeof(__u32);
+	int nr_regs = sizeof(struct kvm_regs) / sizeof(__u32);
 	__uint128_t tmp;
-	void *valp = &tmp;
+	void *valp = &tmp, *addr;
 	u64 off;
 	int err = 0;
 
@@ -166,6 +218,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (validate_core_offset(vcpu, reg))
 		return -EINVAL;
 
+	addr = core_reg_addr(vcpu, reg);
+	if (!addr)		/* Should not happen... */
+		return -EINVAL;
+
 	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
 		return -EINVAL;
 
@@ -206,7 +262,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		}
 	}
 
-	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
+	memcpy(addr, valp, KVM_REG_SIZE(reg->id));
 out:
 	return err;
 }
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index d22d0534dd60..f86f7dc8bebb 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -16,8 +16,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_ptrauth.h>
 
-#define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
-#define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
+#define CPU_XREG_OFFSET(x)	(CPU_USER_PT_REGS + 8*x)
 
 	.text
 	.pushsection	.hyp.text, "ax"
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c5405fa68bc9..a1a9ca35347c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -461,11 +461,11 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	if (sve_guest) {
 		sve_load_state(vcpu_sve_pffr(vcpu),
-			       &vcpu->arch.ctxt.gp_regs.fp_regs.fpsr,
+			       &vcpu->arch.ctxt.fp_regs.fpsr,
 			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
 		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
 	} else {
-		__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
+		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
 	}
 
 	/* Skip restoring fpexc32 for AArch64 guests */
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index df9ca6fdf3fb..8b07be72f2e7 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -32,7 +32,7 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
 	 * therefore be saved/restored on every entry/exit to/from the guest.
 	 */
-	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
+	ctxt->regs.sp			= read_sysreg(sp_el0);
 }
 
 static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
@@ -58,9 +58,9 @@ static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
 
-	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
-	ctxt->gp_regs.elr_el1		= read_sysreg_el1(SYS_ELR);
-	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
+	ctxt->sp_el1			= read_sysreg(sp_el1);
+	ctxt->elr_el1			= read_sysreg_el1(SYS_ELR);
+	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
 }
 
 static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
@@ -133,8 +133,8 @@ static u64 __hyp_text from_hw_pstate(const struct kvm_cpu_context *ctxt)
 
 static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
-	ctxt->gp_regs.regs.pstate	= from_hw_pstate(ctxt);
+	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
+	ctxt->regs.pstate		= from_hw_pstate(ctxt);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
@@ -169,7 +169,7 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
 	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
 	 * therefore be saved/restored on every entry/exit to/from the guest.
 	 */
-	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
+	write_sysreg(ctxt->regs.sp,		  sp_el0);
 }
 
 static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
@@ -323,9 +323,9 @@ static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 	}
 
-	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
-	write_sysreg_el1(ctxt->gp_regs.elr_el1,		SYS_ELR);
-	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
+	write_sysreg(ctxt->sp_el1,			sp_el1);
+	write_sysreg_el1(ctxt->elr_el1,			SYS_ELR);
+	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
 }
 
 static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
@@ -344,7 +344,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 /* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
 static u64 __hyp_text to_hw_pstate(const struct kvm_cpu_context *ctxt)
 {
-	u64 mode = ctxt->gp_regs.regs.pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
+	u64 mode = ctxt->regs.pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
 
 	switch (mode) {
 	case PSR_MODE_EL2t:
@@ -355,7 +355,7 @@ static u64 __hyp_text to_hw_pstate(const struct kvm_cpu_context *ctxt)
 		break;
 	}
 
-	return (ctxt->gp_regs.regs.pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+	return (ctxt->regs.pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
 }
 
 static void __hyp_text
@@ -378,7 +378,7 @@ __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 	if (!(mode & PSR_MODE32_BIT) && mode >= PSR_MODE_EL2t)
 		pstate = PSR_MODE_EL2h | PSR_IL_BIT;
 
-	write_sysreg_el2(ctxt->gp_regs.regs.pc,		SYS_ELR);
+	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
@@ -413,7 +413,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	spsr = vcpu->arch.ctxt.spsr;
 	sysreg = vcpu->arch.ctxt.sys_regs;
 
 	spsr[KVM_SPSR_ABT] = read_sysreg(spsr_abt);
@@ -435,7 +435,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	spsr = vcpu->arch.ctxt.spsr;
 	sysreg = vcpu->arch.ctxt.sys_regs;
 
 	write_sysreg(spsr[KVM_SPSR_ABT], spsr_abt);
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index a900181e3867..b1596f314087 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -100,7 +100,7 @@ static const unsigned long vcpu_reg_offsets[VCPU_NR_MODES][16] = {
  */
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
 {
-	unsigned long *reg_array = (unsigned long *)&vcpu->arch.ctxt.gp_regs.regs;
+	unsigned long *reg_array = (unsigned long *)&vcpu->arch.ctxt.regs;
 	unsigned long mode = *vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK;
 
 	switch (mode) {
@@ -148,7 +148,7 @@ unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
 	int spsr_idx = vcpu_spsr32_mode(vcpu);
 
 	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		return vcpu_gp_regs(vcpu)->spsr[spsr_idx];
+		return vcpu->arch.ctxt.spsr[spsr_idx];
 
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
@@ -171,7 +171,7 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	int spsr_idx = vcpu_spsr32_mode(vcpu);
 
 	if (!vcpu->arch.sysregs_loaded_on_cpu) {
-		vcpu_gp_regs(vcpu)->spsr[spsr_idx] = v;
+		vcpu->arch.ctxt.spsr[spsr_idx] = v;
 		return;
 	}
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 038765d1e60d..07462af1b69d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -307,7 +307,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));
-	vcpu_gp_regs(vcpu)->regs.pstate = pstate;
+	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5a41788054b7..d59fc246aee3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1805,9 +1805,9 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 {
 	/* SP_EL1 is NOT maintained in sys_regs array */
 	if (p->is_write)
-		vcpu->arch.ctxt.gp_regs.sp_el1 = p->regval;
+		vcpu->arch.ctxt.sp_el1 = p->regval;
 	else
-		p->regval = vcpu->arch.ctxt.gp_regs.sp_el1;
+		p->regval = vcpu->arch.ctxt.sp_el1;
 
 	return true;
 }
@@ -1833,9 +1833,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 		return false;
 
 	if (p->is_write)
-		vcpu->arch.ctxt.gp_regs.elr_el1 = p->regval;
+		vcpu->arch.ctxt.elr_el1 = p->regval;
 	else
-		p->regval = vcpu->arch.ctxt.gp_regs.elr_el1;
+		p->regval = vcpu->arch.ctxt.elr_el1;
 
 	return true;
 }
@@ -1851,9 +1851,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 		return false;
 
 	if (p->is_write)
-		vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1] = p->regval;
+		vcpu->arch.ctxt.spsr[KVM_SPSR_EL1] = p->regval;
 	else
-		p->regval = vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1];
+		p->regval = vcpu->arch.ctxt.spsr[KVM_SPSR_EL1];
 
 	return true;
 }
-- 
2.20.1

