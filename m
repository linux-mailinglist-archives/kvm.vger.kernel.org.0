Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4870A49F940
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiA1MUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55748 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348456AbiA1MUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F8E0B82569
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E8CC340E6;
        Fri, 28 Jan 2022 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372412;
        bh=izeWPdWeu6uUe9sodIDsHxQyDl9HwKALG18FrUeSXEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lq6497030gPyQQysRN2CABPi6KzPDmroG+ReJIs1POX5jzoJ4H0lAbPQ5vB4WWvjv
         SrvwegFQv/YL4nVZFAg3OdBrhuk89/9LnTg2rMuFFasKgoFlgbv072gvWOhp64tue0
         RS1/ZdWoKV4TUyTyr6hF6b+V63XOBjWFiysxl1zHGoHTHEK1xgOhD+MO3dAuUw20gx
         oRrIG7WIgYsVL1A05y0Jp5oq/tEeh30iBVCDah+l0mvnaK6aFqFZY965gfuCXAV7GH
         /jRtNx+dQYIMTxcdexQ4YIUfITDVOWpyHQxjpNrNtTe9pg/u9t4nCqzrpfEk89CAcB
         cT319NooQR7Iw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDx-003njR-6Q; Fri, 28 Jan 2022 12:19:29 +0000
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
Subject: [PATCH v6 14/64] KVM: arm64: nv: Handle SPSR_EL2 specially
Date:   Fri, 28 Jan 2022 12:18:22 +0000
Message-Id: <20220128121912.509006-15-maz@kernel.org>
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

SPSR_EL2 needs special attention when running nested on ARMv8.3:

If taking an exception while running at vEL2 (actually EL1), the
HW will update the SPSR_EL1 register with the EL1 mode. We need
to track this in order to make sure that accesses to the virtual
view of SPSR_EL2 is correct.

To do so, we place an illegal value in SPSR_EL1.M, and patch it
accordingly if required when accessing it.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 37 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 23 +++++++++++++++--
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cb9f123d26f3..54e8eee413eb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -241,6 +241,43 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 	return __is_hyp_ctxt(&vcpu->arch.ctxt);
 }
 
+static inline u64 __fixup_spsr_el2_write(struct kvm_cpu_context *ctxt, u64 val)
+{
+	if (!__vcpu_el2_e2h_is_set(ctxt)) {
+		/*
+		 * Clear the .M field when writing SPSR to the CPU, so that we
+		 * can detect when the CPU clobbered our SPSR copy during a
+		 * local exception.
+		 */
+		val &= ~0xc;
+	}
+
+	return val;
+}
+
+static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64 val)
+{
+	if (__vcpu_el2_e2h_is_set(ctxt))
+		return val;
+
+	/*
+	 * SPSR.M == 0 means the CPU has not touched the SPSR, so the
+	 * register has still the value we saved on the last write.
+	 */
+	if ((val & 0xc) == 0)
+		return ctxt_sys_reg(ctxt, SPSR_EL2);
+
+	/*
+	 * Otherwise there was a "local" exception on the CPU,
+	 * which from the guest's point of view was being taken from
+	 * EL2 to EL2, although it actually happened to be from
+	 * EL1 to EL1.
+	 * So we need to fix the .M field in SPSR, to make it look
+	 * like EL2, which is what the guest would expect.
+	 */
+	return (val & ~0x0c) | CurrentEL_EL2;
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0927e6c345b4..ace4a54caef9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -133,11 +133,14 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 			goto memory_read;
 
 		/*
-		 * ELR_EL2 is special cased for now.
+		 * ELR_EL2 and SPSR_EL2 are special cased for now.
 		 */
 		switch (reg) {
 		case ELR_EL2:
 			return read_sysreg_el1(SYS_ELR);
+		case SPSR_EL2:
+			val = read_sysreg_el1(SYS_SPSR);
+			return __fixup_spsr_el2_read(&vcpu->arch.ctxt, val);
 		}
 
 		/*
@@ -194,6 +197,10 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		case ELR_EL2:
 			write_sysreg_el1(val, SYS_ELR);
 			return;
+		case SPSR_EL2:
+			val = __fixup_spsr_el2_write(&vcpu->arch.ctxt, val);
+			write_sysreg_el1(val, SYS_SPSR);
+			return;
 		}
 
 		/* No EL1 counterpart? We're done here.? */
@@ -1610,6 +1617,18 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_spsr_el2(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
+	else
+		p->regval = vcpu_read_sys_reg(vcpu, SPSR_EL2);
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2041,7 +2060,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
-	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
+	EL2_REG(SPSR_EL2, access_spsr_el2, reset_val, 0),
 	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
-- 
2.30.2

