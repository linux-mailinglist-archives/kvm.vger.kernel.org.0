Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A758462388
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbhK2Vpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhK2Vnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:43:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B403FC091D14
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5660BB815E6
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6BFC53FAD;
        Mon, 29 Nov 2021 20:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216336;
        bh=vZ5+4M/yS/H0Yg3zlLXG6/fGkpBg6B4sjXc53adq3EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogw3ZFnAfhBapauo0udzHMlJ+bHG6Y1dZbhMrvq+kQqTPm1n20fYG8VKUCyUdFE5s
         m4f7/gDmx7Y91sR9FDThOBNejb10KvPQecDoqPeojDLbwrUO8PGL6xUfTcfGhdrEeD
         sSdAx4JsontFLbxLcp7eb6qDs1jtoGtSorwGv0S3YV+tITRyP4Jx3bJ6566gCvyOHM
         dxfMi5gjMA6Ap0J0s1gUivfwHVXvEp+VFV9mEgZxznz4H55bwRsmuRNEckji7qacPP
         6nb/wCxYQw3d0+OPz0uclUSh3Xk4ptKQ0ZuyD8ypzHJqmIrovz5rx1sBlqh8csNFxk
         wBdGhKIkudw8Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqt-008gvR-1X; Mon, 29 Nov 2021 20:02:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 18/69] KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()
Date:   Mon, 29 Nov 2021 20:00:59 +0000
Message-Id: <20211129200150.351436-19-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
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
 arch/arm64/kvm/sys_regs.c | 143 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 139 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 730a24468915..61596355e42d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -24,6 +24,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/perf_event.h>
 #include <asm/sysreg.h>
 
@@ -64,23 +65,157 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
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
+		PURE_EL2_SYSREG(  TPIDR_EL2	);
+		PURE_EL2_SYSREG(  HPFAR_EL2	);
+		PURE_EL2_SYSREG(  ELR_EL2	);
+		PURE_EL2_SYSREG(  SPSR_EL2	);
+		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
+				  translate_sctlr_el2_to_sctlr_el1	     );
+		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
+				  translate_cptr_el2_to_cpacr_el1	     );
+		MAPPED_EL2_SYSREG(TTBR0_EL2,   TTBR0_EL1,
+				  translate_ttbr0_el2_to_ttbr0_el1	     );
+		MAPPED_EL2_SYSREG(TTBR1_EL2,   TTBR1_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(TCR_EL2,     TCR_EL1,
+				  translate_tcr_el2_to_tcr_el1		     );
+		MAPPED_EL2_SYSREG(VBAR_EL2,    VBAR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(AFSR0_EL2,   AFSR0_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(AFSR1_EL2,   AFSR1_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(ESR_EL2,     ESR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(FAR_EL2,     FAR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(MAIR_EL2,    MAIR_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
+		MAPPED_EL2_SYSREG(CNTHCTL_EL2, CNTKCTL_EL1,
+				  translate_cnthctl_el2_to_cntkctl_el1	     );
+	default:
+		return false;
+	}
+}
+
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val = 0x8badf00d8badf00d;
+	u64 (*xlate)(u64) = NULL;
+	unsigned int el1r;
+
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
+		goto memory_read;
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
+	}
+
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_read;
 
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
-	    __vcpu_read_sys_reg_from_cpu(reg, &val))
+	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
+memory_read:
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
-	    __vcpu_write_sys_reg_to_cpu(val, reg))
+	u64 (*xlate)(u64) = NULL;
+	unsigned int el1r;
+
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
+		goto memory_write;
+
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
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_write;
+
+	if (__vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
+memory_write:
 	 __vcpu_sys_reg(vcpu, reg) = val;
 }
 
-- 
2.30.2

