Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77D4E3D2
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFUJjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:25 -0400
Received: from foss.arm.com ([217.140.110.172]:53860 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfFUJjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B25B147A;
        Fri, 21 Jun 2019 02:39:23 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 366583F246;
        Fri, 21 Jun 2019 02:39:22 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 07/59] KVM: arm64: nv: Add EL2 system registers to vcpu context
Date:   Fri, 21 Jun 2019 10:37:51 +0100
Message-Id: <20190621093843.220980-8-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
this bit is set, accessing EL2 registers in EL1 traps to EL2. In
addition, executing the following instructions in EL1 will trap to EL2:
tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
instructions that trap to EL2 with the NV bit were undef at EL1 prior to
ARM v8.3. The only instruction that was not undef is eret.

This patch sets up a handler for EL2 registers and SP_EL1 register
accesses at EL1. The host hypervisor keeps those register values in
memory, and will emulate their behavior.

This patch doesn't set the NV bit yet. It will be set in a later patch
once nested virtualization support is completed.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 37 +++++++++++++++-
 arch/arm64/include/asm/sysreg.h   | 50 ++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 74 ++++++++++++++++++++++++++++---
 3 files changed, 154 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4bcd9c1291d5..2d4290d2513a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -173,12 +173,47 @@ enum vcpu_sysreg {
 	APGAKEYLO_EL1,
 	APGAKEYHI_EL1,
 
-	/* 32bit specific registers. Keep them at the end of the range */
+	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
 	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
+	/* EL2 registers sorted ascending by Op0, Op1, CRn, CRm, Op2 */
+	FIRST_EL2_SYSREG,
+	VPIDR_EL2 = FIRST_EL2_SYSREG,
+			/* Virtualization Processor ID Register */
+	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
+	SCTLR_EL2,	/* System Control Register (EL2) */
+	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
+	HCR_EL2,	/* Hypervisor Configuration Register */
+	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
+	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
+	HSTR_EL2,	/* Hypervisor System Trap Register */
+	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
+	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
+	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
+	TCR_EL2,	/* Translation Control Register (EL2) */
+	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
+	VTCR_EL2,	/* Virtualization Translation Control Register */
+	SPSR_EL2,	/* EL2 saved program status register */
+	ELR_EL2,	/* EL2 exception link register */
+	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
+	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
+	ESR_EL2,	/* Exception Syndrome Register (EL2) */
+	FAR_EL2,	/* Hypervisor IPA Fault Address Register */
+	HPFAR_EL2,	/* Hypervisor IPA Fault Address Register */
+	MAIR_EL2,	/* Memory Attribute Indirection Register (EL2) */
+	AMAIR_EL2,	/* Auxiliary Memory Attribute Indirection Register (EL2) */
+	VBAR_EL2,	/* Vector Base Address Register (EL2) */
+	RVBAR_EL2,	/* Reset Vector Base Address Register */
+	RMR_EL2,	/* Reset Management Register */
+	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
+	TPIDR_EL2,	/* EL2 Software Thread ID Register */
+	CNTVOFF_EL2,	/* Counter-timer Virtual Offset register */
+	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
+	SP_EL2,		/* EL2 Stack Pointer */
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index f3ca7e4796ab..8b95f2c42c3d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -411,17 +411,49 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
 
+#define SYS_VPIDR_EL2			sys_reg(3, 4, 0, 0, 0)
+#define SYS_VMPIDR_EL2			sys_reg(3, 4, 0, 0, 5)
+
+#define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
+#define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
+#define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
+#define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
+#define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
+#define SYS_HSTR_EL2			sys_reg(3, 4, 1, 1, 3)
+#define SYS_HACR_EL2			sys_reg(3, 4, 1, 1, 7)
+
 #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
+
+#define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
+#define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
+#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
+#define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
+#define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
+
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
+
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
+#define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
+
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_AFSR0_EL2			sys_reg(3, 4, 5, 1, 0)
+#define SYS_AFSR1_EL2			sys_reg(3, 4, 5, 1, 1)
 #define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
 #define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
 #define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
 
-#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1,  1)
+#define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
+#define SYS_HPFAR_EL2			sys_reg(3, 4, 6, 0, 4)
+
+#define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
+#define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
+
+#define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
+#define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
+#define SYS_RMR_EL2			sys_reg(3, 4, 12, 0, 2)
+#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1, 1)
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
 #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
 #define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
@@ -463,23 +495,37 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+#define SYS_CONTEXTIDR_EL2		sys_reg(3, 4, 13, 0, 1)
+#define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
+
+#define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
+#define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
+
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
 #define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
 #define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
+
 #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
 #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
 #define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
+
 #define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
 #define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
+
 #define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
 #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
 #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
+
 #define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
+
 #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
 #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
+
 #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
+
 #define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
+
 #define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
 #define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
 #define SYS_CNTP_CTL_EL02		sys_reg(3, 5, 14, 2, 1)
@@ -488,6 +534,8 @@
 #define SYS_CNTV_CTL_EL02		sys_reg(3, 5, 14, 3, 1)
 #define SYS_CNTV_CVAL_EL02		sys_reg(3, 5, 14, 3, 2)
 
+#define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_DSSBS	(_BITUL(44))
 #define SCTLR_ELx_ENIA	(_BITUL(31))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index adb8a7e9c8e4..e81be6debe07 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -184,6 +184,18 @@ static u32 get_ccsidr(u32 csselr)
 	return ccsidr;
 }
 
+static bool access_rw(struct kvm_vcpu *vcpu,
+		      struct sys_reg_params *p,
+		      const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
+	else
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+
+	return true;
+}
+
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -394,12 +406,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
-	if (p->is_write) {
-		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
+	access_rw(vcpu, p, r);
+	if (p->is_write)
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-	} else {
-		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
-	}
 
 	trace_trap_reg(__func__, r->reg, p->is_write, p->regval);
 
@@ -1354,6 +1363,19 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	.set_user = set_raz_id_reg,		\
 }
 
+static bool access_sp_el1(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	/* SP_EL1 is NOT maintained in sys_regs array */
+	if (p->is_write)
+		vcpu->arch.ctxt.gp_regs.sp_el1 = p->regval;
+	else
+		p->regval = vcpu->arch.ctxt.gp_regs.sp_el1;
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1646,9 +1668,51 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 */
 	{ SYS_DESC(SYS_PMCCFILTR_EL0), access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
 
+	{ SYS_DESC(SYS_VPIDR_EL2), access_rw, reset_val, VPIDR_EL2, 0 },
+	{ SYS_DESC(SYS_VMPIDR_EL2), access_rw, reset_val, VMPIDR_EL2, 0 },
+
+	{ SYS_DESC(SYS_SCTLR_EL2), access_rw, reset_val, SCTLR_EL2, 0 },
+	{ SYS_DESC(SYS_ACTLR_EL2), access_rw, reset_val, ACTLR_EL2, 0 },
+	{ SYS_DESC(SYS_HCR_EL2), access_rw, reset_val, HCR_EL2, 0 },
+	{ SYS_DESC(SYS_MDCR_EL2), access_rw, reset_val, MDCR_EL2, 0 },
+	{ SYS_DESC(SYS_CPTR_EL2), access_rw, reset_val, CPTR_EL2, 0 },
+	{ SYS_DESC(SYS_HSTR_EL2), access_rw, reset_val, HSTR_EL2, 0 },
+	{ SYS_DESC(SYS_HACR_EL2), access_rw, reset_val, HACR_EL2, 0 },
+
+	{ SYS_DESC(SYS_TTBR0_EL2), access_rw, reset_val, TTBR0_EL2, 0 },
+	{ SYS_DESC(SYS_TTBR1_EL2), access_rw, reset_val, TTBR1_EL2, 0 },
+	{ SYS_DESC(SYS_TCR_EL2), access_rw, reset_val, TCR_EL2, 0 },
+	{ SYS_DESC(SYS_VTTBR_EL2), access_rw, reset_val, VTTBR_EL2, 0 },
+	{ SYS_DESC(SYS_VTCR_EL2), access_rw, reset_val, VTCR_EL2, 0 },
+
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
+	{ SYS_DESC(SYS_SPSR_EL2), access_rw, reset_val, SPSR_EL2, 0 },
+	{ SYS_DESC(SYS_ELR_EL2), access_rw, reset_val, ELR_EL2, 0 },
+	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
+
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
+	{ SYS_DESC(SYS_AFSR0_EL2), access_rw, reset_val, AFSR0_EL2, 0 },
+	{ SYS_DESC(SYS_AFSR1_EL2), access_rw, reset_val, AFSR1_EL2, 0 },
+	{ SYS_DESC(SYS_ESR_EL2), access_rw, reset_val, ESR_EL2, 0 },
 	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
+
+	{ SYS_DESC(SYS_FAR_EL2), access_rw, reset_val, FAR_EL2, 0 },
+	{ SYS_DESC(SYS_HPFAR_EL2), access_rw, reset_val, HPFAR_EL2, 0 },
+
+	{ SYS_DESC(SYS_MAIR_EL2), access_rw, reset_val, MAIR_EL2, 0 },
+	{ SYS_DESC(SYS_AMAIR_EL2), access_rw, reset_val, AMAIR_EL2, 0 },
+
+	{ SYS_DESC(SYS_VBAR_EL2), access_rw, reset_val, VBAR_EL2, 0 },
+	{ SYS_DESC(SYS_RVBAR_EL2), access_rw, reset_val, RVBAR_EL2, 0 },
+	{ SYS_DESC(SYS_RMR_EL2), access_rw, reset_val, RMR_EL2, 0 },
+
+	{ SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
+	{ SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
+
+	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
+	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
+
+	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
 };
 
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
-- 
2.20.1

