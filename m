Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A662A3009
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgKBQlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbgKBQlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:41:11 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B4E6223B0;
        Mon,  2 Nov 2020 16:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604335269;
        bh=XXmPgEccIdzPSnz+RmOCSdFNNHqGNQB5zWQmx9DDdaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxBXK6f/NCrBa6fsEy2I4MlEPawikls4JVfVKdXt/QLmVqWeI5tIF8UIHoesALd0f
         zQDroSrHeSH27V6WY7BYxy1t2UqraJQ6vx6RSX6rU2y3gz7Dxq7laByC3hfbuBFO+a
         BQqD81GG8kcIiGAs7Gq1u5nPYByjouRquzVaqj1A=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZctH-006jJf-VL; Mon, 02 Nov 2020 16:41:08 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH v2 07/11] KVM: arm64: Inject AArch64 exceptions from HYP
Date:   Mon,  2 Nov 2020 16:40:41 +0000
Message-Id: <20201102164045.264512-8-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164045.264512-1-maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, mark.rutland@arm.com, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the AArch64 exception injection code from EL1 to HYP, leaving
only the ESR_EL1 updates to EL1. In order to come with the differences
between VHE and nVHE, two set of system register accessors are provided.

SPSR, ELR, PC and PSTATE are now completely handled in the hypervisor.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  12 +++
 arch/arm64/kvm/hyp/exception.c       | 136 +++++++++++++++++++++++++++
 arch/arm64/kvm/inject_fault.c        | 114 ++--------------------
 3 files changed, 154 insertions(+), 108 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 6d2b5d1aa7b3..736a342dadf7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -21,6 +21,18 @@
 #include <asm/cputype.h>
 #include <asm/virt.h>
 
+#define CURRENT_EL_SP_EL0_VECTOR	0x0
+#define CURRENT_EL_SP_ELx_VECTOR	0x200
+#define LOWER_EL_AArch64_VECTOR		0x400
+#define LOWER_EL_AArch32_VECTOR		0x600
+
+enum exception_type {
+	except_type_sync	= 0,
+	except_type_irq		= 0x80,
+	except_type_fiq		= 0x100,
+	except_type_serror	= 0x180,
+};
+
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
 unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu);
 void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v);
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 6533a9270850..94d6d823424d 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -11,7 +11,143 @@
  */
 
 #include <hyp/adjust_pc.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+
+#if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
+#error Hypervisor code only!
+#endif
+
+static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+{
+	u64 val;
+
+	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
+		return val;
+
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
+static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+{
+	if (__vcpu_write_sys_reg_to_cpu(val, reg))
+		return;
+
+	 __vcpu_sys_reg(vcpu, reg) = val;
+}
+
+static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
+{
+	write_sysreg_el1(val, SYS_SPSR);
+}
+
+/*
+ * This performs the exception entry at a given EL (@target_mode), stashing PC
+ * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
+ * The EL passed to this function *must* be a non-secure, privileged mode with
+ * bit 0 being set (PSTATE.SP == 1).
+ *
+ * When an exception is taken, most PSTATE fields are left unchanged in the
+ * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
+ * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
+ * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
+ *
+ * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
+ * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
+ *
+ * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
+ * MSB to LSB.
+ */
+static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			      enum exception_type type)
+{
+	unsigned long sctlr, vbar, old, new, mode;
+	u64 exc_offset;
+
+	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	if      (mode == target_mode)
+		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
+	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
+		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
+	else if (!(mode & PSR_MODE32_BIT))
+		exc_offset = LOWER_EL_AArch64_VECTOR;
+	else
+		exc_offset = LOWER_EL_AArch32_VECTOR;
+
+	switch (target_mode) {
+	case PSR_MODE_EL1h:
+		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		break;
+	default:
+		/* Don't do that */
+		BUG();
+	}
+
+	*vcpu_pc(vcpu) = vbar + exc_offset + type;
+
+	old = *vcpu_cpsr(vcpu);
+	new = 0;
+
+	new |= (old & PSR_N_BIT);
+	new |= (old & PSR_Z_BIT);
+	new |= (old & PSR_C_BIT);
+	new |= (old & PSR_V_BIT);
+
+	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
+
+	new |= (old & PSR_DIT_BIT);
+
+	// PSTATE.UAO is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D5-2579.
+
+	// PSTATE.PAN is unchanged unless SCTLR_ELx.SPAN == 0b0
+	// SCTLR_ELx.SPAN is RES1 when ARMv8.1-PAN is not implemented
+	// See ARM DDI 0487E.a, page D5-2578.
+	new |= (old & PSR_PAN_BIT);
+	if (!(sctlr & SCTLR_EL1_SPAN))
+		new |= PSR_PAN_BIT;
+
+	// PSTATE.SS is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D2-2452.
+
+	// PSTATE.IL is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D1-2306.
+
+	// PSTATE.SSBS is set to SCTLR_ELx.DSSBS upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D13-3258
+	if (sctlr & SCTLR_ELx_DSSBS)
+		new |= PSR_SSBS_BIT;
+
+	// PSTATE.BTYPE is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
+
+	new |= PSR_D_BIT;
+	new |= PSR_A_BIT;
+	new |= PSR_I_BIT;
+	new |= PSR_F_BIT;
+
+	new |= target_mode;
+
+	*vcpu_cpsr(vcpu) = new;
+	__vcpu_write_spsr(vcpu, old);
+}
 
 void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
+	case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+	      KVM_ARM64_EXCEPT_AA64_EL1):
+		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
+		break;
+	default:
+		/*
+		 * Only EL1_SYNC makes sense so far, EL2_{SYNC,IRQ}
+		 * will be implemented at some point. Everything
+		 * else gets silently ignored.
+		 */
+		break;
+	}
 }
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 34a96ab244fa..8862431f8e3b 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -14,119 +14,15 @@
 #include <asm/kvm_emulate.h>
 #include <asm/esr.h>
 
-#define CURRENT_EL_SP_EL0_VECTOR	0x0
-#define CURRENT_EL_SP_ELx_VECTOR	0x200
-#define LOWER_EL_AArch64_VECTOR		0x400
-#define LOWER_EL_AArch32_VECTOR		0x600
-
-enum exception_type {
-	except_type_sync	= 0,
-	except_type_irq		= 0x80,
-	except_type_fiq		= 0x100,
-	except_type_serror	= 0x180,
-};
-
-/*
- * This performs the exception entry at a given EL (@target_mode), stashing PC
- * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
- * The EL passed to this function *must* be a non-secure, privileged mode with
- * bit 0 being set (PSTATE.SP == 1).
- *
- * When an exception is taken, most PSTATE fields are left unchanged in the
- * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
- * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
- * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
- *
- * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
- * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
- *
- * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
- * MSB to LSB.
- */
-static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
-			      enum exception_type type)
-{
-	unsigned long sctlr, vbar, old, new, mode;
-	u64 exc_offset;
-
-	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
-
-	if      (mode == target_mode)
-		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
-	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
-		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
-	else if (!(mode & PSR_MODE32_BIT))
-		exc_offset = LOWER_EL_AArch64_VECTOR;
-	else
-		exc_offset = LOWER_EL_AArch32_VECTOR;
-
-	switch (target_mode) {
-	case PSR_MODE_EL1h:
-		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
-		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
-		break;
-	default:
-		/* Don't do that */
-		BUG();
-	}
-
-	*vcpu_pc(vcpu) = vbar + exc_offset + type;
-
-	old = *vcpu_cpsr(vcpu);
-	new = 0;
-
-	new |= (old & PSR_N_BIT);
-	new |= (old & PSR_Z_BIT);
-	new |= (old & PSR_C_BIT);
-	new |= (old & PSR_V_BIT);
-
-	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
-
-	new |= (old & PSR_DIT_BIT);
-
-	// PSTATE.UAO is set to zero upon any exception to AArch64
-	// See ARM DDI 0487E.a, page D5-2579.
-
-	// PSTATE.PAN is unchanged unless SCTLR_ELx.SPAN == 0b0
-	// SCTLR_ELx.SPAN is RES1 when ARMv8.1-PAN is not implemented
-	// See ARM DDI 0487E.a, page D5-2578.
-	new |= (old & PSR_PAN_BIT);
-	if (!(sctlr & SCTLR_EL1_SPAN))
-		new |= PSR_PAN_BIT;
-
-	// PSTATE.SS is set to zero upon any exception to AArch64
-	// See ARM DDI 0487E.a, page D2-2452.
-
-	// PSTATE.IL is set to zero upon any exception to AArch64
-	// See ARM DDI 0487E.a, page D1-2306.
-
-	// PSTATE.SSBS is set to SCTLR_ELx.DSSBS upon any exception to AArch64
-	// See ARM DDI 0487E.a, page D13-3258
-	if (sctlr & SCTLR_ELx_DSSBS)
-		new |= PSR_SSBS_BIT;
-
-	// PSTATE.BTYPE is set to zero upon any exception to AArch64
-	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
-
-	new |= PSR_D_BIT;
-	new |= PSR_A_BIT;
-	new |= PSR_I_BIT;
-	new |= PSR_F_BIT;
-
-	new |= target_mode;
-
-	*vcpu_cpsr(vcpu) = new;
-	vcpu_write_spsr(vcpu, old);
-}
-
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
+			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
+			     KVM_ARM64_PENDING_EXCEPTION);
 
 	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
 
@@ -156,7 +52,9 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
+			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
+			     KVM_ARM64_PENDING_EXCEPTION);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
-- 
2.28.0

