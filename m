Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD92E2A300C
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgKBQlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbgKBQlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:41:11 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB56223BD;
        Mon,  2 Nov 2020 16:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604335270;
        bh=DDalEsVdhuQz4z5k9X3JiecV+0TpDk1pvcLDzfecXLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMU9NdCH2P7/4kQQqWnetyT8eBIOeetGLEMWDXjlpU0Ao3cx6XPTmmMLChudQkgqs
         QCrOEPVpP62Gex0xM4wwa4DNc0d1zZ/GUE6lW9K3iEwJzkk+2YJbpCrVZnnyieRVPt
         x+/csRDPQby7AMRTQTOgGGtH9k2X7MVEsvxKL6JA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZctI-006jJf-HB; Mon, 02 Nov 2020 16:41:08 +0000
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
Subject: [PATCH v2 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
Date:   Mon,  2 Nov 2020 16:40:42 +0000
Message-Id: <20201102164045.264512-9-maz@kernel.org>
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

Similarly to what has been done for AArch64, move the AArch32 exception
injection to HYP.

In order to not use the regmap selection code at EL2, simplify the code
populating the target mode's LR register by useing the compatibility
aliases for LR_abt and LR_und.

We also introduce new accessors for SPSR_abt and SPSR_und, and
move VBAR/SCTLR to using the AArch64 accessors (the use of the AArch32
names was an ARMv7 leftover).

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/aarch32.c       | 149 +-----------------------
 arch/arm64/kvm/hyp/exception.c | 200 +++++++++++++++++++++++++++++++--
 2 files changed, 195 insertions(+), 154 deletions(-)

diff --git a/arch/arm64/kvm/aarch32.c b/arch/arm64/kvm/aarch32.c
index 40a62a99fbf8..ad453b47c517 100644
--- a/arch/arm64/kvm/aarch32.c
+++ b/arch/arm64/kvm/aarch32.c
@@ -19,20 +19,6 @@
 #define DFSR_FSC_EXTABT_nLPAE	0x08
 #define DFSR_LPAE		BIT(9)
 
-/*
- * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
- */
-static const u8 return_offsets[8][2] = {
-	[0] = { 0, 0 },		/* Reset, unused */
-	[1] = { 4, 2 },		/* Undefined */
-	[2] = { 0, 0 },		/* SVC, unused */
-	[3] = { 4, 4 },		/* Prefetch abort */
-	[4] = { 8, 8 },		/* Data abort */
-	[5] = { 0, 0 },		/* HVC, unused */
-	[6] = { 4, 4 },		/* IRQ, unused */
-	[7] = { 4, 4 },		/* FIQ, unused */
-};
-
 static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
@@ -53,132 +39,10 @@ static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
 	}
 }
 
-/*
- * When an exception is taken, most CPSR fields are left unchanged in the
- * handler. However, some are explicitly overridden (e.g. M[4:0]).
- *
- * The SPSR/SPSR_ELx layouts differ, and the below is intended to work with
- * either format. Note: SPSR.J bit doesn't exist in SPSR_ELx, but this bit was
- * obsoleted by the ARMv7 virtualization extensions and is RES0.
- *
- * For the SPSR layout seen from AArch32, see:
- * - ARM DDI 0406C.d, page B1-1148
- * - ARM DDI 0487E.a, page G8-6264
- *
- * For the SPSR_ELx layout for AArch32 seen from AArch64, see:
- * - ARM DDI 0487E.a, page C5-426
- *
- * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
- * MSB to LSB.
- */
-static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
-{
-	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
-	unsigned long old, new;
-
-	old = *vcpu_cpsr(vcpu);
-	new = 0;
-
-	new |= (old & PSR_AA32_N_BIT);
-	new |= (old & PSR_AA32_Z_BIT);
-	new |= (old & PSR_AA32_C_BIT);
-	new |= (old & PSR_AA32_V_BIT);
-	new |= (old & PSR_AA32_Q_BIT);
-
-	// CPSR.IT[7:0] are set to zero upon any exception
-	// See ARM DDI 0487E.a, section G1.12.3
-	// See ARM DDI 0406C.d, section B1.8.3
-
-	new |= (old & PSR_AA32_DIT_BIT);
-
-	// CPSR.SSBS is set to SCTLR.DSSBS upon any exception
-	// See ARM DDI 0487E.a, page G8-6244
-	if (sctlr & BIT(31))
-		new |= PSR_AA32_SSBS_BIT;
-
-	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
-	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
-	// See ARM DDI 0487E.a, page G8-6246
-	new |= (old & PSR_AA32_PAN_BIT);
-	if (!(sctlr & BIT(23)))
-		new |= PSR_AA32_PAN_BIT;
-
-	// SS does not exist in AArch32, so ignore
-
-	// CPSR.IL is set to zero upon any exception
-	// See ARM DDI 0487E.a, page G1-5527
-
-	new |= (old & PSR_AA32_GE_MASK);
-
-	// CPSR.IT[7:0] are set to zero upon any exception
-	// See prior comment above
-
-	// CPSR.E is set to SCTLR.EE upon any exception
-	// See ARM DDI 0487E.a, page G8-6245
-	// See ARM DDI 0406C.d, page B4-1701
-	if (sctlr & BIT(25))
-		new |= PSR_AA32_E_BIT;
-
-	// CPSR.A is unchanged upon an exception to Undefined, Supervisor
-	// CPSR.A is set upon an exception to other modes
-	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
-	// See ARM DDI 0406C.d, page B1-1182
-	new |= (old & PSR_AA32_A_BIT);
-	if (mode != PSR_AA32_MODE_UND && mode != PSR_AA32_MODE_SVC)
-		new |= PSR_AA32_A_BIT;
-
-	// CPSR.I is set upon any exception
-	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
-	// See ARM DDI 0406C.d, page B1-1182
-	new |= PSR_AA32_I_BIT;
-
-	// CPSR.F is set upon an exception to FIQ
-	// CPSR.F is unchanged upon an exception to other modes
-	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
-	// See ARM DDI 0406C.d, page B1-1182
-	new |= (old & PSR_AA32_F_BIT);
-	if (mode == PSR_AA32_MODE_FIQ)
-		new |= PSR_AA32_F_BIT;
-
-	// CPSR.T is set to SCTLR.TE upon any exception
-	// See ARM DDI 0487E.a, page G8-5514
-	// See ARM DDI 0406C.d, page B1-1181
-	if (sctlr & BIT(30))
-		new |= PSR_AA32_T_BIT;
-
-	new |= mode;
-
-	return new;
-}
-
-static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
-{
-	unsigned long spsr = *vcpu_cpsr(vcpu);
-	bool is_thumb = (spsr & PSR_AA32_T_BIT);
-	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
-	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
-
-	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
-
-	/* Note: These now point to the banked copies */
-	vcpu_write_spsr(vcpu, host_spsr_to_spsr32(spsr));
-	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
-
-	/* Branch to exception vector */
-	if (sctlr & (1 << 13))
-		vect_offset += 0xffff0000;
-	else /* always have security exceptions */
-		vect_offset += vcpu_cp15(vcpu, c12_VBAR);
-
-	*vcpu_pc(vcpu) = vect_offset;
-}
-
 void kvm_inject_undef32(struct kvm_vcpu *vcpu)
 {
-	bool loaded = pre_fault_synchronize(vcpu);
-
-	prepare_fault32(vcpu, PSR_AA32_MODE_UND, 4);
-	post_fault_synchronize(vcpu, loaded);
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_UND |
+			     KVM_ARM64_PENDING_EXCEPTION);
 }
 
 /*
@@ -188,7 +52,6 @@ void kvm_inject_undef32(struct kvm_vcpu *vcpu)
 static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 			 unsigned long addr)
 {
-	u32 vect_offset;
 	u32 *far, *fsr;
 	bool is_lpae;
 	bool loaded;
@@ -196,17 +59,17 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 	loaded = pre_fault_synchronize(vcpu);
 
 	if (is_pabt) {
-		vect_offset = 12;
+		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_IABT |
+				     KVM_ARM64_PENDING_EXCEPTION);
 		far = &vcpu_cp15(vcpu, c6_IFAR);
 		fsr = &vcpu_cp15(vcpu, c5_IFSR);
 	} else { /* !iabt */
-		vect_offset = 16;
+		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_DABT |
+				     KVM_ARM64_PENDING_EXCEPTION);
 		far = &vcpu_cp15(vcpu, c6_DFAR);
 		fsr = &vcpu_cp15(vcpu, c5_DFSR);
 	}
 
-	prepare_fault32(vcpu, PSR_AA32_MODE_ABT, vect_offset);
-
 	*far = addr;
 
 	/* Give the guest an IMPLEMENTATION DEFINED exception */
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 94d6d823424d..73629094f903 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -41,6 +41,22 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
 	write_sysreg_el1(val, SYS_SPSR);
 }
 
+static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (has_vhe())
+		write_sysreg(val, spsr_abt);
+	else
+		vcpu->arch.ctxt.spsr_abt = val;
+}
+
+static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (has_vhe())
+		write_sysreg(val, spsr_und);
+	else
+		vcpu->arch.ctxt.spsr_und = val;
+}
+
 /*
  * This performs the exception entry at a given EL (@target_mode), stashing PC
  * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
@@ -135,19 +151,181 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	__vcpu_write_spsr(vcpu, old);
 }
 
-void kvm_inject_exception(struct kvm_vcpu *vcpu)
+/*
+ * When an exception is taken, most CPSR fields are left unchanged in the
+ * handler. However, some are explicitly overridden (e.g. M[4:0]).
+ *
+ * The SPSR/SPSR_ELx layouts differ, and the below is intended to work with
+ * either format. Note: SPSR.J bit doesn't exist in SPSR_ELx, but this bit was
+ * obsoleted by the ARMv7 virtualization extensions and is RES0.
+ *
+ * For the SPSR layout seen from AArch32, see:
+ * - ARM DDI 0406C.d, page B1-1148
+ * - ARM DDI 0487E.a, page G8-6264
+ *
+ * For the SPSR_ELx layout for AArch32 seen from AArch64, see:
+ * - ARM DDI 0487E.a, page C5-426
+ *
+ * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
+ * MSB to LSB.
+ */
+static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
+{
+	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	unsigned long old, new;
+
+	old = *vcpu_cpsr(vcpu);
+	new = 0;
+
+	new |= (old & PSR_AA32_N_BIT);
+	new |= (old & PSR_AA32_Z_BIT);
+	new |= (old & PSR_AA32_C_BIT);
+	new |= (old & PSR_AA32_V_BIT);
+	new |= (old & PSR_AA32_Q_BIT);
+
+	// CPSR.IT[7:0] are set to zero upon any exception
+	// See ARM DDI 0487E.a, section G1.12.3
+	// See ARM DDI 0406C.d, section B1.8.3
+
+	new |= (old & PSR_AA32_DIT_BIT);
+
+	// CPSR.SSBS is set to SCTLR.DSSBS upon any exception
+	// See ARM DDI 0487E.a, page G8-6244
+	if (sctlr & BIT(31))
+		new |= PSR_AA32_SSBS_BIT;
+
+	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
+	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
+	// See ARM DDI 0487E.a, page G8-6246
+	new |= (old & PSR_AA32_PAN_BIT);
+	if (!(sctlr & BIT(23)))
+		new |= PSR_AA32_PAN_BIT;
+
+	// SS does not exist in AArch32, so ignore
+
+	// CPSR.IL is set to zero upon any exception
+	// See ARM DDI 0487E.a, page G1-5527
+
+	new |= (old & PSR_AA32_GE_MASK);
+
+	// CPSR.IT[7:0] are set to zero upon any exception
+	// See prior comment above
+
+	// CPSR.E is set to SCTLR.EE upon any exception
+	// See ARM DDI 0487E.a, page G8-6245
+	// See ARM DDI 0406C.d, page B4-1701
+	if (sctlr & BIT(25))
+		new |= PSR_AA32_E_BIT;
+
+	// CPSR.A is unchanged upon an exception to Undefined, Supervisor
+	// CPSR.A is set upon an exception to other modes
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= (old & PSR_AA32_A_BIT);
+	if (mode != PSR_AA32_MODE_UND && mode != PSR_AA32_MODE_SVC)
+		new |= PSR_AA32_A_BIT;
+
+	// CPSR.I is set upon any exception
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= PSR_AA32_I_BIT;
+
+	// CPSR.F is set upon an exception to FIQ
+	// CPSR.F is unchanged upon an exception to other modes
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= (old & PSR_AA32_F_BIT);
+	if (mode == PSR_AA32_MODE_FIQ)
+		new |= PSR_AA32_F_BIT;
+
+	// CPSR.T is set to SCTLR.TE upon any exception
+	// See ARM DDI 0487E.a, page G8-5514
+	// See ARM DDI 0406C.d, page B1-1181
+	if (sctlr & BIT(30))
+		new |= PSR_AA32_T_BIT;
+
+	new |= mode;
+
+	return new;
+}
+
+/*
+ * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
+ */
+static const u8 return_offsets[8][2] = {
+	[0] = { 0, 0 },		/* Reset, unused */
+	[1] = { 4, 2 },		/* Undefined */
+	[2] = { 0, 0 },		/* SVC, unused */
+	[3] = { 4, 4 },		/* Prefetch abort */
+	[4] = { 8, 8 },		/* Data abort */
+	[5] = { 0, 0 },		/* HVC, unused */
+	[6] = { 4, 4 },		/* IRQ, unused */
+	[7] = { 4, 4 },		/* FIQ, unused */
+};
+
+static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
-	switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
-	case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
-	      KVM_ARM64_EXCEPT_AA64_EL1):
-		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
+	unsigned long spsr = *vcpu_cpsr(vcpu);
+	bool is_thumb = (spsr & PSR_AA32_T_BIT);
+	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	u32 return_address;
+
+	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
+	return_address   = *vcpu_pc(vcpu);
+	return_address  += return_offsets[vect_offset >> 2][is_thumb];
+
+	/* KVM only enters the ABT and UND modes, so only deal with those */
+	switch(mode) {
+	case PSR_AA32_MODE_ABT:
+		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
+		vcpu_gp_regs(vcpu)->compat_lr_abt = return_address;
 		break;
-	default:
-		/*
-		 * Only EL1_SYNC makes sense so far, EL2_{SYNC,IRQ}
-		 * will be implemented at some point. Everything
-		 * else gets silently ignored.
-		 */
+
+	case PSR_AA32_MODE_UND:
+		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
+		vcpu_gp_regs(vcpu)->compat_lr_und = return_address;
 		break;
 	}
+
+	/* Branch to exception vector */
+	if (sctlr & (1 << 13))
+		vect_offset += 0xffff0000;
+	else /* always have security exceptions */
+		vect_offset += __vcpu_read_sys_reg(vcpu, VBAR_EL1);
+
+	*vcpu_pc(vcpu) = vect_offset;
+}
+
+void kvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_el1_is_32bit(vcpu)) {
+		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
+		case KVM_ARM64_EXCEPT_AA32_UND:
+			enter_exception32(vcpu, PSR_AA32_MODE_UND, 4);
+			break;
+		case KVM_ARM64_EXCEPT_AA32_IABT:
+			enter_exception32(vcpu, PSR_AA32_MODE_ABT, 12);
+			break;
+		case KVM_ARM64_EXCEPT_AA32_DABT:
+			enter_exception32(vcpu, PSR_AA32_MODE_ABT, 16);
+			break;
+		default:
+			/* Err... */
+			break;
+		}
+	} else {
+		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
+		case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+		      KVM_ARM64_EXCEPT_AA64_EL1):
+			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
+			break;
+		default:
+			/*
+			 * Only EL1_SYNC makes sense so far, EL2_{SYNC,IRQ}
+			 * will be implemented at some point. Everything
+			 * else gets silently ignored.
+			 */
+			break;
+		}
+	}
 }
-- 
2.28.0

