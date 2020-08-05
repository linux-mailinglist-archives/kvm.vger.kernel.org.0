Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF07523CEA9
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgHESyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbgHESaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21D3D22DCC;
        Wed,  5 Aug 2020 18:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652010;
        bh=CC6A47nxAmRdpF3iRuUznEhc1tT4BBkjxev642A2AW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mClhTm4Zix0Xrae5t/h+OXMkDk4Pvi5I4VgwZNBQ89MWGZD+meulzeLAAzL62N8+O
         YvsplL+4erlsX1NANDZ2ZtiZ9D6Q64/Ql8EfepllkqFCVICO3jGYdoLSUOPautOhOm
         8mpzxf85V9A9EGDY8i0w8t03Kllj+BXeLLM+rJmo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfr-0004w9-5E; Wed, 05 Aug 2020 18:57:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 41/56] KVM: arm64: Make struct kvm_regs userspace-only
Date:   Wed,  5 Aug 2020 18:56:45 +0100
Message-Id: <20200805175700.62775-42-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
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

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h       | 18 +++---
 arch/arm64/include/asm/kvm_host.h          | 12 +++-
 arch/arm64/kernel/asm-offsets.c            |  3 +-
 arch/arm64/kvm/fpsimd.c                    |  2 +-
 arch/arm64/kvm/guest.c                     | 70 +++++++++++++++++-----
 arch/arm64/kvm/hyp/entry.S                 |  3 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  4 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 24 ++++----
 arch/arm64/kvm/regmap.c                    |  6 +-
 arch/arm64/kvm/reset.c                     |  2 +-
 10 files changed, 96 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 269a76cd51ff..cd607999abc2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -124,12 +124,12 @@ static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 
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
@@ -150,7 +150,7 @@ static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long
 
 static __always_inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pstate;
+	return (unsigned long *)&vcpu_gp_regs(vcpu)->pstate;
 }
 
 static __always_inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
@@ -179,14 +179,14 @@ static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
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
@@ -197,7 +197,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
+		return vcpu->arch.ctxt.spsr[KVM_SPSR_EL1];
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -210,7 +210,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
+		vcpu->arch.ctxt.spsr[KVM_SPSR_EL1] = v;
 }
 
 /*
@@ -519,11 +519,11 @@ static __always_inline void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_i
 static __always_inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
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
index d9360f91ef44..bc1e91573d00 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -236,7 +236,15 @@ enum vcpu_sysreg {
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
@@ -402,7 +410,7 @@ struct kvm_vcpu_arch {
 				  system_supports_generic_auth()) && \
 				 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
 
-#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
+#define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
 /*
  * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 0577e2142284..7d32fc959b1a 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -102,13 +102,12 @@ int main(void)
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
index e503caff14d1..3e081d556e81 100644
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
index aea43ec60f37..9dd5bbeefae6 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -101,19 +101,60 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 	return size;
 }
 
-static int validate_core_offset(const struct kvm_vcpu *vcpu,
-				const struct kvm_one_reg *reg)
+static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	u64 off = core_reg_offset_from_id(reg->id);
 	int size = core_reg_size_from_offset(vcpu, off);
 
 	if (size < 0)
-		return -EINVAL;
+		return NULL;
 
 	if (KVM_REG_SIZE(reg->id) != size)
-		return -EINVAL;
+		return NULL;
 
-	return 0;
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
 }
 
 static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
@@ -125,8 +166,8 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	 * off the index in the "array".
 	 */
 	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
-	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
-	int nr_regs = sizeof(*regs) / sizeof(__u32);
+	int nr_regs = sizeof(struct kvm_regs) / sizeof(__u32);
+	void *addr;
 	u32 off;
 
 	/* Our ID is an index into the kvm_regs struct. */
@@ -135,10 +176,11 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_offset(vcpu, reg))
+	addr = core_reg_addr(vcpu, reg);
+	if (!addr)
 		return -EINVAL;
 
-	if (copy_to_user(uaddr, ((u32 *)regs) + off, KVM_REG_SIZE(reg->id)))
+	if (copy_to_user(uaddr, addr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
 	return 0;
@@ -147,10 +189,9 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
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
 
@@ -160,7 +201,8 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_offset(vcpu, reg))
+	addr = core_reg_addr(vcpu, reg);
+	if (!addr)
 		return -EINVAL;
 
 	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
@@ -198,7 +240,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		}
 	}
 
-	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
+	memcpy(addr, valp, KVM_REG_SIZE(reg->id));
 
 	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
 		int i;
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index dfb4e6d359ab..ee32a7743389 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -16,8 +16,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_ptrauth.h>
 
-#define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
-#define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
+#define CPU_XREG_OFFSET(x)	(CPU_USER_PT_REGS + 8*x)
 #define CPU_SP_EL0_OFFSET	(CPU_XREG_OFFSET(30) + 8)
 
 	.text
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 70367699d69a..784a581071fc 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -266,11 +266,11 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
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
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 37ef3e2cdbef..50938093cc5d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -46,15 +46,15 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg(par_el1);
 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
 
-	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
-	ctxt->gp_regs.elr_el1		= read_sysreg_el1(SYS_ELR);
-	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
+	ctxt->sp_el1			= read_sysreg(sp_el1);
+	ctxt->elr_el1			= read_sysreg_el1(SYS_ELR);
+	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
-	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(SYS_SPSR);
+	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
+	ctxt->regs.pstate		= read_sysreg_el2(SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
@@ -125,14 +125,14 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 	}
 
-	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
-	write_sysreg_el1(ctxt->gp_regs.elr_el1,		SYS_ELR);
-	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
+	write_sysreg(ctxt->sp_el1,			sp_el1);
+	write_sysreg_el1(ctxt->elr_el1,			SYS_ELR);
+	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
 }
 
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	u64 pstate = ctxt->gp_regs.regs.pstate;
+	u64 pstate = ctxt->regs.pstate;
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
 
 	/*
@@ -149,7 +149,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 	if (!(mode & PSR_MODE32_BIT) && mode >= PSR_MODE_EL2t)
 		pstate = PSR_MODE_EL2h | PSR_IL_BIT;
 
-	write_sysreg_el2(ctxt->gp_regs.regs.pc,		SYS_ELR);
+	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
@@ -163,7 +163,7 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	spsr = vcpu->arch.ctxt.spsr;
 
 	spsr[KVM_SPSR_ABT] = read_sysreg(spsr_abt);
 	spsr[KVM_SPSR_UND] = read_sysreg(spsr_und);
@@ -184,7 +184,7 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	spsr = vcpu->arch.ctxt.spsr;
 
 	write_sysreg(spsr[KVM_SPSR_ABT], spsr_abt);
 	write_sysreg(spsr[KVM_SPSR_UND], spsr_und);
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
index d3b209023727..8ca8607f5a9f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -288,7 +288,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
-	vcpu_gp_regs(vcpu)->regs.pstate = pstate;
+	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
-- 
2.27.0

