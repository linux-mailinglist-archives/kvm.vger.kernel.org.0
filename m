Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC503159730
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgBKRxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730657AbgBKRxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:53:14 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E296D20661;
        Tue, 11 Feb 2020 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443594;
        bh=FUObRX1i5yYjDDdV90Q3AHebzA2hM6GwZwnuM2X/+0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZwWvTFctOfcTpC0Hf84F/pPsaUV0lORAgSdwrWdnSI0tHczAcA676pWGeBhKuRVa
         uR6VMyXM2eZrQUH7Ian7wZi0TiIZ/L0CT07digHlsaUS+SYn5PJ6YetRUChtCGnTjc
         jWc0o6JH04mvLnUJyCI6/ec+FeFyrrUjkEpI077A=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfd-004O7k-Lp; Tue, 11 Feb 2020 17:50:01 +0000
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
Subject: [PATCH v2 14/94] KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()
Date:   Tue, 11 Feb 2020 17:48:18 +0000
Message-Id: <20200211174938.27809-15-maz@kernel.org>
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

KVM internally uses accessor functions when reading or writing the
guest's system registers. This takes care of accessing either the stored
copy or using the "live" EL1 system registers when the host uses VHE.

With the introduction of virtual EL2 we add a bunch of EL2 system
registers, which now must also be taken care of:
- If the guest is running in vEL2, and we access an EL1 sysreg, we must
  revert to the stored version of that, and not use the CPU's copy.
- If the guest is running in vEL1, and we access an EL2 sysreg, we must
  also use the stored version, since the CPU carries the EL1 copy.
- Some EL2 system registers are supposed to affect the current execution
  of the system, so we need to put them into their respective EL1
  counterparts. For this we need to define a mapping between the two.
  This is done using the newly introduced struct el2_sysreg_map.
- Some EL2 system registers have a different format than their EL1
  counterpart, so we need to translate them before writing them to the
  CPU. This is done using an (optional) translate function in the map.
- There are the three special registers SP_EL2, SPSR_EL2 and ELR_EL2,
  which need some separate handling (SPSR_EL2 is being handled in a
  separate patch).

All of these cases are now wrapped into the existing accessor functions,
so KVM users wouldn't need to care whether they access EL2 or EL1
registers and also which state the guest is in.

This handles what was formerly known as the "shadow state" dynamically,
without requiring a separate copy for each vCPU EL.

Co-developed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 117 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 116 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42a268c21f06..64be9f452ad6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -113,6 +113,56 @@ u64 translate_cnthctl(u64 cnthctl)
 	return ((cnthctl & 0x3) << 10) | (cnthctl & 0xfc);
 }
 
+#define PURE_EL2_SYSREG(el2)						\
+	case el2: {							\
+		*el1r = el2;						\
+		return true;						\
+	}
+
+#define MAPPED_EL2_SYSREG(el2, el1, fn)					\
+	case el2: {							\
+		*xlate = fn;						\
+		*el1r = el1;						\
+		return true;						\
+	}
+
+static bool get_el2_mapping(unsigned int reg,
+			    unsigned int *el1r, u64 (**xlate)(u64))
+{
+	switch (reg) {
+		PURE_EL2_SYSREG(  VPIDR_EL2	);
+		PURE_EL2_SYSREG(  VMPIDR_EL2	);
+		PURE_EL2_SYSREG(  ACTLR_EL2	);
+		PURE_EL2_SYSREG(  HCR_EL2	);
+		PURE_EL2_SYSREG(  MDCR_EL2	);
+		PURE_EL2_SYSREG(  HSTR_EL2	);
+		PURE_EL2_SYSREG(  HACR_EL2	);
+		PURE_EL2_SYSREG(  VTTBR_EL2	);
+		PURE_EL2_SYSREG(  VTCR_EL2	);
+		PURE_EL2_SYSREG(  RVBAR_EL2	);
+		PURE_EL2_SYSREG(  RMR_EL2	);
+		PURE_EL2_SYSREG(  TPIDR_EL2	);
+		PURE_EL2_SYSREG(  HPFAR_EL2	);
+		PURE_EL2_SYSREG(  ELR_EL2	);
+		PURE_EL2_SYSREG(  SPSR_EL2	);
+		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,   translate_sctlr  );
+		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,   translate_cptr   );
+		MAPPED_EL2_SYSREG(TTBR0_EL2,   TTBR0_EL1,   translate_ttbr0  );
+		MAPPED_EL2_SYSREG(TTBR1_EL2,   TTBR1_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(TCR_EL2,     TCR_EL1,     translate_tcr    );
+		MAPPED_EL2_SYSREG(VBAR_EL2,    VBAR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(AFSR0_EL2,   AFSR0_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(AFSR1_EL2,   AFSR1_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(ESR_EL2,     ESR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(FAR_EL2,     FAR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(MAIR_EL2,    MAIR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(CNTHCTL_EL2, CNTKCTL_EL1, translate_cnthctl);
+	default:
+		return false;
+	}
+}
+
 static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 {
 	/*
@@ -197,9 +247,42 @@ static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val = 0x8badf00d8badf00d;
+	u64 (*xlate)(u64) = NULL;
+	unsigned int el1r;
 
-	if (!vcpu->arch.sysregs_loaded_on_cpu) {
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
 		goto memory_read;
+
+	if (unlikely(get_el2_mapping(reg, &el1r, &xlate))) {
+		if (!is_hyp_ctxt(vcpu))
+			goto memory_read;
+
+		/*
+		 * ELR_EL2 is special cased for now.
+		 */
+		switch (reg) {
+		case ELR_EL2:
+			return read_sysreg_el1(SYS_ELR);
+		}
+
+		/*
+		 * If this register does not have an EL1 counterpart,
+		 * then read the stored EL2 version.
+		 */
+		if (reg == el1r)
+			goto memory_read;
+
+		/*
+		 * If we have a non-VHE guest and that the sysreg
+		 * requires translation to be used at EL1, use the
+		 * in-memory copy instead.
+		 */
+		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
+			goto memory_read;
+
+		/* Get the current version of the EL1 counterpart. */
+		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
+		return val;
 	}
 
 	/* EL1 register can't be on the CPU if the guest is in vEL2. */
@@ -215,9 +298,41 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
+	u64 (*xlate)(u64) = NULL;
+	unsigned int el1r;
+
 	if (!vcpu->arch.sysregs_loaded_on_cpu)
 		goto memory_write;
 
+	if (unlikely(get_el2_mapping(reg, &el1r, &xlate))) {
+		if (!is_hyp_ctxt(vcpu))
+			goto memory_write;
+
+		/*
+		 * Always store a copy of the write to memory to avoid having
+		 * to reverse-translate virtual EL2 system registers for a
+		 * non-VHE guest hypervisor.
+		 */
+		__vcpu_sys_reg(vcpu, reg) = val;
+
+		switch (reg) {
+		case ELR_EL2:
+			write_sysreg_el1(val, SYS_ELR);
+			return;
+		}
+
+		/* No EL1 counterpart? We're done here.? */
+		if (reg == el1r)
+			return;
+
+		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
+			val = xlate(val);
+
+		/* Redirect this to the EL1 version of the register. */
+		WARN_ON(!__vcpu_write_sys_reg_to_cpu(val, el1r));
+		return;
+	}
+
 	/* EL1 register can't be on the CPU if the guest is in vEL2. */
 	if (unlikely(is_hyp_ctxt(vcpu)))
 		goto memory_write;
-- 
2.20.1

