Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DD61B44D2
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgDVMVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgDVMVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:21:34 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9B121582;
        Wed, 22 Apr 2020 12:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587558093;
        bh=lGl4YB3t5njuzaQ5NDpGI0g2EkvzIT9KBV2E4l4iHsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYOpKrJtX2IrSQ3LLQH+recmtwq5O1+xn/kcaE6UHHB9Q3re4KyO77Wq4LvTDyKbh
         YrMHVPhSXWtgKIGCzFyEq7msKizoIzpdPajsPIvWUQfSu00ELjAs4G6q+4sbQlm1Lq
         Qcvqd1seVvWc/uuHATYv/ruST3L8nmvW+0d1qi78=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE40-005UI7-Vi; Wed, 22 Apr 2020 13:01:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 19/26] KVM: arm64: Make struct kvm_regs userspace-only
Date:   Wed, 22 Apr 2020 13:00:43 +0100
Message-Id: <20200422120050.3693593-20-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
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
 arch/arm64/include/asm/kvm_emulate.h | 18 +++----
 arch/arm64/include/asm/kvm_host.h    | 12 ++++-
 arch/arm64/kernel/asm-offsets.c      |  3 +-
 arch/arm64/kvm/fpsimd.c              |  2 +-
 arch/arm64/kvm/guest.c               | 70 +++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/entry.S           |  3 +-
 arch/arm64/kvm/hyp/switch.c          |  4 +-
 arch/arm64/kvm/hyp/sysreg-sr.c       | 28 +++++------
 arch/arm64/kvm/regmap.c              |  6 +--
 arch/arm64/kvm/reset.c               |  2 +-
 10 files changed, 105 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a30b4eec7cb40..c0d9363f328dc 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -130,12 +130,12 @@ static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 
 static __always_inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
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
@@ -156,7 +156,7 @@ static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long
 
 static __always_inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pstate;
+	return (unsigned long *)&vcpu_gp_regs(vcpu)->pstate;
 }
 
 static __always_inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
@@ -185,14 +185,14 @@ static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
 static __always_inline unsigned long vcpu_get_reg(const struct kvm_vcpu *vcpu,
 					 u8 reg_num)
 {
-	return (reg_num == 31) ? 0 : vcpu_gp_regs(vcpu)->regs.regs[reg_num];
+	return (reg_num == 31) ? 0 : vcpu_gp_regs(vcpu)->regs[reg_num];
 }
 
 static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 				unsigned long val)
 {
 	if (reg_num != 31)
-		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
+		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
 }
 
 static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
@@ -203,7 +203,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
+		return vcpu->arch.ctxt.spsr[KVM_SPSR_EL1];
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -216,7 +216,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
+		vcpu->arch.ctxt.spsr[KVM_SPSR_EL1] = v;
 }
 
 /*
@@ -523,11 +523,11 @@ static __always_inline void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_i
 static __always_inline void __hyp_text __kvm_skip_instr(struct kvm_vcpu *vcpu)
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
index 37dd8d8faef67..95977b80265ce 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -235,7 +235,15 @@ enum vcpu_sysreg {
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
@@ -404,7 +412,7 @@ struct kvm_vcpu_arch {
 				  system_supports_generic_auth()) && \
 				 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
 
-#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
+#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 9981a0a5a87f1..1125df6449b60 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -101,13 +101,12 @@ int main(void)
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
index e503caff14d1e..3e081d556e810 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -85,7 +85,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
+		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl);
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 23ebe51410f06..9fec9231b63e2 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -102,6 +102,55 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
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
@@ -126,8 +175,8 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	 * off the index in the "array".
 	 */
 	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
-	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
-	int nr_regs = sizeof(*regs) / sizeof(__u32);
+	int nr_regs = sizeof(struct kvm_regs) / sizeof(__u32);
+	void *addr;
 	u32 off;
 
 	/* Our ID is an index into the kvm_regs struct. */
@@ -139,7 +188,11 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
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
@@ -148,10 +201,9 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
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
 
@@ -164,6 +216,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (validate_core_offset(vcpu, reg))
 		return -EINVAL;
 
+	addr = core_reg_addr(vcpu, reg);
+	if (!addr)		/* Should not happen... */
+		return -EINVAL;
+
 	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
 		return -EINVAL;
 
@@ -199,7 +255,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		}
 	}
 
-	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
+	memcpy(addr, valp, KVM_REG_SIZE(reg->id));
 out:
 	return err;
 }
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index d22d0534dd600..f86f7dc8bebb8 100644
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
index bc6c405b343b4..80dfbe4c4bede 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -418,11 +418,11 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
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
index 970c94ce9d10a..d9dd19f39a537 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -31,7 +31,7 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
 	 * therefore be saved/restored on every entry/exit to/from the guest.
 	 */
-	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
+	ctxt->regs.sp			= read_sysreg(sp_el0);
 }
 
 static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
@@ -61,15 +61,15 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg(par_el1);
 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
 
-	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
-	ctxt->gp_regs.elr_el1		= read_sysreg_el1(SYS_ELR);
-	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
+	ctxt->sp_el1			= read_sysreg(sp_el1);
+	ctxt->elr_el1			= read_sysreg_el1(SYS_ELR);
+	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
 }
 
 static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
-	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(SYS_SPSR);
+	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
+	ctxt->regs.pstate		= read_sysreg_el2(SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
@@ -104,7 +104,7 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
 	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
 	 * therefore be saved/restored on every entry/exit to/from the guest.
 	 */
-	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
+	write_sysreg(ctxt->regs.sp,		  sp_el0);
 }
 
 static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
@@ -166,15 +166,15 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 	}
 
-	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
-	write_sysreg_el1(ctxt->gp_regs.elr_el1,		SYS_ELR);
-	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
+	write_sysreg(ctxt->sp_el1,			sp_el1);
+	write_sysreg_el1(ctxt->elr_el1,			SYS_ELR);
+	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
 }
 
 static void __hyp_text
 __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	u64 pstate = ctxt->gp_regs.regs.pstate;
+	u64 pstate = ctxt->regs.pstate;
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
 
 	/*
@@ -191,7 +191,7 @@ __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 	if (!(mode & PSR_MODE32_BIT) && mode >= PSR_MODE_EL2t)
 		pstate = PSR_MODE_EL2h | PSR_IL_BIT;
 
-	write_sysreg_el2(ctxt->gp_regs.regs.pc,		SYS_ELR);
+	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
@@ -226,7 +226,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	spsr = vcpu->arch.ctxt.spsr;
 
 	spsr[KVM_SPSR_ABT] = read_sysreg(spsr_abt);
 	spsr[KVM_SPSR_UND] = read_sysreg(spsr_und);
@@ -247,7 +247,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	spsr = vcpu->arch.ctxt.spsr;
 
 	write_sysreg(spsr[KVM_SPSR_ABT], spsr_abt);
 	write_sysreg(spsr[KVM_SPSR_UND], spsr_und);
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index a900181e38678..b1596f314087b 100644
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
index 895d7d9ad1866..4bf1242b616f5 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -298,7 +298,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));
-	vcpu_gp_regs(vcpu)->regs.pstate = pstate;
+	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
-- 
2.26.1

