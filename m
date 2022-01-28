Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9AE49F918
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243265AbiA1MTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348397AbiA1MT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:19:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FF4C061714
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:19:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B790461B0B
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF2FC340E0;
        Fri, 28 Jan 2022 12:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372368;
        bh=NFVmjlUxLmGGeWlyBOoMaSxfLvXZVmT03LLwLgGhYSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9bLeHhQ9FG9elowBCM91R/wtdmtRJy4T8djKBdiid+o3YhkdagdaacsCq7pei/Kj
         r05Q8er67rC1JqdZoboUo+6o6XrG/rSVi4i/IXKdx7qd0fmHkEshAx8SgrbiYqBhGW
         px/ChBIp450KdVUnNBpeP1w6p9c8KXsCiipVUGFn7Y83JekI2KHicmZXRme8T4OqD7
         TmJk/LyF+CzqK6VhsOHIL1JhXGMmBJEG8FgMWIHEOklOLIzPGCRb2LcQdNI7K/myqr
         k1qYjP+qSo42J7SI8f88O1Bv/GCye/ePaqs1YkdRJxnOrpmDx1c7LSog4BSrHweEOI
         KRtluNEtwrSIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDu-003njR-HA; Fri, 28 Jan 2022 12:19:26 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 07/64] KVM: arm64: nv: Handle HCR_EL2.NV system register traps
Date:   Fri, 28 Jan 2022 12:18:15 +0000
Message-Id: <20220128121912.509006-8-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
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
[maz: EL2_REG() macros]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 41 +++++++++++++-
 arch/arm64/kvm/sys_regs.c       | 99 +++++++++++++++++++++++++++++++--
 2 files changed, 134 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 898bee0004ae..61c990e5591a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -532,10 +532,26 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
 
+#define SYS_VPIDR_EL2			sys_reg(3, 4, 0, 0, 0)
+#define SYS_VMPIDR_EL2			sys_reg(3, 4, 0, 0, 5)
+
 #define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
+#define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
+#define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
+#define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
+#define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
+#define SYS_HSTR_EL2			sys_reg(3, 4, 1, 1, 3)
 #define SYS_HFGRTR_EL2			sys_reg(3, 4, 1, 1, 4)
 #define SYS_HFGWTR_EL2			sys_reg(3, 4, 1, 1, 5)
 #define SYS_HFGITR_EL2			sys_reg(3, 4, 1, 1, 6)
+#define SYS_HACR_EL2			sys_reg(3, 4, 1, 1, 7)
+
+#define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
+#define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
+#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
+#define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
+#define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
+
 #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
@@ -544,14 +560,26 @@
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
+#define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_AFSR0_EL2			sys_reg(3, 4, 5, 1, 0)
+#define SYS_AFSR1_EL2			sys_reg(3, 4, 5, 1, 1)
 #define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
 #define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
 #define SYS_TFSR_EL2			sys_reg(3, 4, 5, 6, 0)
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
@@ -593,15 +621,24 @@
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
@@ -619,6 +656,8 @@
 #define SYS_CNTV_CTL_EL02		sys_reg(3, 5, 14, 3, 1)
 #define SYS_CNTV_CVAL_EL02		sys_reg(3, 5, 14, 3, 2)
 
+#define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_DSSBS	(BIT(44))
 #define SCTLR_ELx_ATA	(BIT(43))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dc2fba316ff..06ca98458815 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -24,6 +24,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/perf_event.h>
 #include <asm/sysreg.h>
 
@@ -105,6 +106,18 @@ static u32 get_ccsidr(u32 csselr)
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
@@ -263,6 +276,14 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+static bool trap_undef(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *p,
+		       const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -342,12 +363,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
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
 
@@ -1378,6 +1396,24 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 	.visibility = mte_visibility,		\
 }
 
+static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	if (vcpu_has_nv(vcpu))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+#define EL2_REG(name, acc, rst, v) {		\
+	SYS_DESC(SYS_##name),			\
+	.access = acc,				\
+	.reset = rst,				\
+	.reg = name,				\
+	.visibility = el2_visibility,		\
+	.val = v,				\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -1411,6 +1447,18 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 	.set_user = set_raz_id_reg,		\
 }
 
+static bool access_sp_el1(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		__vcpu_sys_reg(vcpu, SP_EL1) = p->regval;
+	else
+		p->regval = __vcpu_sys_reg(vcpu, SP_EL1);
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1825,9 +1873,50 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
 	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
 
+	EL2_REG(VPIDR_EL2, access_rw, reset_val, 0),
+	EL2_REG(VMPIDR_EL2, access_rw, reset_val, 0),
+	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
+	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HCR_EL2, access_rw, reset_val, 0),
+	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
+	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_EL2_DEFAULT ),
+	EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HACR_EL2, access_rw, reset_val, 0),
+
+	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
+	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
+	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
+	EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
+	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
+
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
+	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
+	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
+
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
+	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
+	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
+	EL2_REG(ESR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
+
+	EL2_REG(FAR_EL2, access_rw, reset_val, 0),
+	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
+
+	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
+	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
+
+	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
+	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
+
+	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
+	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
+
+	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
+	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
+
+	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
 static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
-- 
2.30.2

