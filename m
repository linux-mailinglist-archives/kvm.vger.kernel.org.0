Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8712AD7AE
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 14:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbgKJNgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 08:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbgKJNgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 08:36:33 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3885820825;
        Tue, 10 Nov 2020 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605015392;
        bh=hcplEBibrUZSHZ2b4qhORY9gMip9pS7Z0zY5ZHBatSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyWyVf+Wz3G7abw49FhZCk2ouwkikQkLKVPFmEZn0W38oDB4dczAbE6yOYUxXChXG
         R/Fr1s3CmoH3wUVX05wayueLuCrVyTAek2ilX8M4S5bA+os1B2IQVoFpBj/EPqBvOd
         jrjdalAJU8GkH3qbdSMEWC/I8sAW+PwJMycxAMAU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcTp0-009SZy-EA; Tue, 10 Nov 2020 13:36:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 5/9] KVM: arm64: Map AArch32 cp14 register to AArch64 sysregs
Date:   Tue, 10 Nov 2020 13:36:15 +0000
Message-Id: <20201110133619.451157-6-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110133619.451157-1-maz@kernel.org>
References: <20201110133619.451157-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similarly to what has been done on the cp15 front, repaint the
debug registers to use their AArch64 counterparts. This results
in some simplification as we can remove the 32bit-specific
accessors.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   8 ---
 arch/arm64/kvm/sys_regs.c         | 109 ++++++++++--------------------
 2 files changed, 37 insertions(+), 80 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c905c3fcaaa0..0d023e4f80a0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -555,14 +555,6 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	return true;
 }
 
-/*
- * CP14 and CP15 live in the same array, as they are backed by the
- * same system registers.
- */
-#define CPx_BIAS		IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)
-
-#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_BIAS])
-
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
 };
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ab66101c855e..660ff6c18b2e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -366,26 +366,30 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
  */
 static void reg_to_dbg(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
+		       const struct sys_reg_desc *rd,
 		       u64 *dbg_reg)
 {
-	u64 val = p->regval;
+	u64 mask, shift, val;
 
-	if (p->is_32bit) {
-		val &= 0xffffffffUL;
-		val |= ((*dbg_reg >> 32) << 32);
-	}
+	get_access_mask(rd, &mask, &shift);
 
+	val = *dbg_reg;
+	val &= ~mask;
+	val |= (p->regval & (mask >> shift)) << shift;
 	*dbg_reg = val;
+
 	vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 }
 
 static void dbg_to_reg(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
+		       const struct sys_reg_desc *rd,
 		       u64 *dbg_reg)
 {
-	p->regval = *dbg_reg;
-	if (p->is_32bit)
-		p->regval &= 0xffffffffUL;
+	u64 mask, shift;
+
+	get_access_mask(rd, &mask, &shift);
+	p->regval = (*dbg_reg & mask) >> shift;
 }
 
 static bool trap_bvr(struct kvm_vcpu *vcpu,
@@ -395,9 +399,9 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
 
 	if (p->is_write)
-		reg_to_dbg(vcpu, p, dbg_reg);
+		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
-		dbg_to_reg(vcpu, p, dbg_reg);
+		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
 	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
 
@@ -437,9 +441,9 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
 
 	if (p->is_write)
-		reg_to_dbg(vcpu, p, dbg_reg);
+		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
-		dbg_to_reg(vcpu, p, dbg_reg);
+		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
 	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
 
@@ -480,9 +484,9 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
 
 	if (p->is_write)
-		reg_to_dbg(vcpu, p, dbg_reg);
+		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
-		dbg_to_reg(vcpu, p, dbg_reg);
+		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
 	trace_trap_reg(__func__, rd->reg, p->is_write,
 		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg]);
@@ -523,9 +527,9 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
 
 	if (p->is_write)
-		reg_to_dbg(vcpu, p, dbg_reg);
+		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
-		dbg_to_reg(vcpu, p, dbg_reg);
+		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
 	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
 
@@ -1744,66 +1748,27 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 	}
 }
 
-static bool trap_debug32(struct kvm_vcpu *vcpu,
-			 struct sys_reg_params *p,
-			 const struct sys_reg_desc *r)
-{
-	if (p->is_write) {
-		vcpu_cp14(vcpu, r->reg) = p->regval;
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-	} else {
-		p->regval = vcpu_cp14(vcpu, r->reg);
-	}
-
-	return true;
-}
-
-/* AArch32 debug register mappings
+/*
+ * AArch32 debug register mappings
  *
  * AArch32 DBGBVRn is mapped to DBGBVRn_EL1[31:0]
  * AArch32 DBGBXVRn is mapped to DBGBVRn_EL1[63:32]
  *
- * All control registers and watchpoint value registers are mapped to
- * the lower 32 bits of their AArch64 equivalents. We share the trap
- * handlers with the above AArch64 code which checks what mode the
- * system is in.
+ * None of the other registers share their location, so treat them as
+ * if they were 64bit.
  */
-
-static bool trap_xvr(struct kvm_vcpu *vcpu,
-		     struct sys_reg_params *p,
-		     const struct sys_reg_desc *rd)
-{
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
-
-	if (p->is_write) {
-		u64 val = *dbg_reg;
-
-		val &= 0xffffffffUL;
-		val |= p->regval << 32;
-		*dbg_reg = val;
-
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-	} else {
-		p->regval = *dbg_reg >> 32;
-	}
-
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
-
-	return true;
-}
-
-#define DBG_BCR_BVR_WCR_WVR(n)						\
-	/* DBGBVRn */							\
-	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_bvr, NULL, n }, 	\
-	/* DBGBCRn */							\
-	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_bcr, NULL, n },	\
-	/* DBGWVRn */							\
-	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_wvr, NULL, n },	\
-	/* DBGWCRn */							\
+#define DBG_BCR_BVR_WCR_WVR(n)						      \
+	/* DBGBVRn */							      \
+	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_bvr, NULL, n }, \
+	/* DBGBCRn */							      \
+	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_bcr, NULL, n },	      \
+	/* DBGWVRn */							      \
+	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_wvr, NULL, n },	      \
+	/* DBGWCRn */							      \
 	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_wcr, NULL, n }
 
-#define DBGBXVR(n)							\
-	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_xvr, NULL, n }
+#define DBGBXVR(n)							      \
+	{ AA32(HI), Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_bvr, NULL, n }
 
 /*
  * Trapped cp14 registers. We generally ignore most of the external
@@ -1821,9 +1786,9 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 1), Op2( 0), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(1),
 	/* DBGDCCINT */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug32, NULL, cp14_DBGDCCINT },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug_regs, NULL, MDCCINT_EL1 },
 	/* DBGDSCRext */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug32, NULL, cp14_DBGDSCRext },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug_regs, NULL, MDSCR_EL1 },
 	DBG_BCR_BVR_WCR_WVR(2),
 	/* DBGDTR[RT]Xint */
 	{ Op1( 0), CRn( 0), CRm( 3), Op2( 0), trap_raz_wi },
@@ -1838,7 +1803,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 6), Op2( 2), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(6),
 	/* DBGVCR */
-	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32, NULL, cp14_DBGVCR },
+	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug_regs, NULL, DBGVCR32_EL2 },
 	DBG_BCR_BVR_WCR_WVR(7),
 	DBG_BCR_BVR_WCR_WVR(8),
 	DBG_BCR_BVR_WCR_WVR(9),
-- 
2.28.0

