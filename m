Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E054E3E5
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfFUJjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:37 -0400
Received: from foss.arm.com ([217.140.110.172]:53976 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbfFUJjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CAD6142F;
        Fri, 21 Jun 2019 02:39:36 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD3913F246;
        Fri, 21 Jun 2019 02:39:34 -0700 (PDT)
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
Subject: [PATCH 15/59] KVM: arm64: nv: Refactor vcpu_{read,write}_sys_reg
Date:   Fri, 21 Jun 2019 10:37:59 +0100
Message-Id: <20190621093843.220980-16-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the direct HW accessors for later reuse.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 247 +++++++++++++++++++++-----------------
 1 file changed, 139 insertions(+), 108 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2b8734f75a09..e181359adadf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -182,99 +182,161 @@ const struct el2_sysreg_map *find_el2_sysreg(const struct el2_sysreg_map *map,
 	return entry;
 }
 
+static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
+{
+	/*
+	 * System registers listed in the switch are not saved on every
+	 * exit from the guest but are only saved on vcpu_put.
+	 *
+	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
+	 * should never be listed below, because the guest cannot modify its
+	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
+	 * thread when emulating cross-VCPU communication.
+	 */
+	switch (reg) {
+	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
+	case ACTLR_EL1:		*val = read_sysreg_s(SYS_ACTLR_EL1);	break;
+	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
+	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
+	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
+	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
+	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
+	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
+	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	default:		return false;
+	}
+
+	return true;
+}
+
+static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
+{
+	/*
+	 * System registers listed in the switch are not restored on every
+	 * entry to the guest but are only restored on vcpu_load.
+	 *
+	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
+	 * should never be listed below, because the the MPIDR should only be
+	 * set once, before running the VCPU, and never changed later.
+	 */
+	switch (reg) {
+	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
+	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	break;
+	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
+	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
+	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
+	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
+	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
+	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
+	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	default:		return false;
+	}
+
+	return true;
+}
+
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
-	u64 val;
+	u64 val = 0x8badf00d8badf00d;
 
 	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		goto immediate_read;
+		goto memory_read;
 
 	if (unlikely(sysreg_is_el2(reg))) {
 		const struct el2_sysreg_map *el2_reg;
 
 		if (!is_hyp_ctxt(vcpu))
-			goto immediate_read;
+			goto memory_read;
 
 		switch (reg) {
+		case ELR_EL2:
+			return read_sysreg_el1(SYS_ELR);
 		case SPSR_EL2:
 			val = read_sysreg_el1(SYS_SPSR);
 			return __fixup_spsr_el2_read(&vcpu->arch.ctxt, val);
 		}
 
 		el2_reg = find_el2_sysreg(nested_sysreg_map, reg);
-		if (el2_reg) {
-			/*
-			 * If this register does not have an EL1 counterpart,
-			 * then read the stored EL2 version.
-			 */
-			if (el2_reg->mapping == __INVALID_SYSREG__)
-				goto immediate_read;
-
-			/* Get the current version of the EL1 counterpart. */
-			reg = el2_reg->mapping;
-		}
-	} else {
-		/* EL1 register can't be on the CPU if the guest is in vEL2. */
-		if (unlikely(is_hyp_ctxt(vcpu)))
-			goto immediate_read;
+		BUG_ON(!el2_reg);
+
+		/*
+		 * If this register does not have an EL1 counterpart,
+		 * then read the stored EL2 version.
+		 */
+		if (el2_reg->mapping == __INVALID_SYSREG__)
+			goto memory_read;
+
+		if (!vcpu_el2_e2h_is_set(vcpu) &&
+		    el2_reg->translate)
+			goto memory_read;
+
+		/* Get the current version of the EL1 counterpart. */
+		reg = el2_reg->mapping;
+		WARN_ON(!__vcpu_read_sys_reg_from_cpu(reg, &val));
+		return val;
 	}
 
-	/*
-	 * System registers listed in the switch are not saved on every
-	 * exit from the guest but are only saved on vcpu_put.
-	 *
-	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
-	 * should never be listed below, because the guest cannot modify its
-	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
-	 * thread when emulating cross-VCPU communication.
-	 */
-	switch (reg) {
-	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
-	case SCTLR_EL1:		return read_sysreg_s(SYS_SCTLR_EL12);
-	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
-	case CPACR_EL1:		return read_sysreg_s(SYS_CPACR_EL12);
-	case TTBR0_EL1:		return read_sysreg_s(SYS_TTBR0_EL12);
-	case TTBR1_EL1:		return read_sysreg_s(SYS_TTBR1_EL12);
-	case TCR_EL1:		return read_sysreg_s(SYS_TCR_EL12);
-	case ESR_EL1:		return read_sysreg_s(SYS_ESR_EL12);
-	case AFSR0_EL1:		return read_sysreg_s(SYS_AFSR0_EL12);
-	case AFSR1_EL1:		return read_sysreg_s(SYS_AFSR1_EL12);
-	case FAR_EL1:		return read_sysreg_s(SYS_FAR_EL12);
-	case MAIR_EL1:		return read_sysreg_s(SYS_MAIR_EL12);
-	case VBAR_EL1:		return read_sysreg_s(SYS_VBAR_EL12);
-	case CONTEXTIDR_EL1:	return read_sysreg_s(SYS_CONTEXTIDR_EL12);
-	case TPIDR_EL0:		return read_sysreg_s(SYS_TPIDR_EL0);
-	case TPIDRRO_EL0:	return read_sysreg_s(SYS_TPIDRRO_EL0);
-	case TPIDR_EL1:		return read_sysreg_s(SYS_TPIDR_EL1);
-	case AMAIR_EL1:		return read_sysreg_s(SYS_AMAIR_EL12);
-	case CNTKCTL_EL1:	return read_sysreg_s(SYS_CNTKCTL_EL12);
-	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1);
-	case DACR32_EL2:	return read_sysreg_s(SYS_DACR32_EL2);
-	case IFSR32_EL2:	return read_sysreg_s(SYS_IFSR32_EL2);
-	case DBGVCR32_EL2:	return read_sysreg_s(SYS_DBGVCR32_EL2);
-	case SP_EL2:		return read_sysreg(sp_el1);
-	case ELR_EL2:		return read_sysreg_el1(SYS_ELR);
-	}
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_read;
+
+	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
+		return val;
 
-immediate_read:
+memory_read:
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
 	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		goto immediate_write;
+		goto memory_write;
 
 	if (unlikely(sysreg_is_el2(reg))) {
 		const struct el2_sysreg_map *el2_reg;
 
 		if (!is_hyp_ctxt(vcpu))
-			goto immediate_write;
+			goto memory_write;
 
-		/* Store the EL2 version in the sysregs array. */
+		/*
+		 * Always store a copy of the write to memory to avoid having
+		 * to reverse-translate virtual EL2 system registers for a
+		 * non-VHE guest hypervisor.
+		 */
 		__vcpu_sys_reg(vcpu, reg) = val;
 
 		switch (reg) {
+		case ELR_EL2:
+			write_sysreg_el1(val, SYS_ELR);
+			return;
 		case SPSR_EL2:
 			val = __fixup_spsr_el2_write(&vcpu->arch.ctxt, val);
 			write_sysreg_el1(val, SYS_SPSR);
@@ -282,61 +344,30 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		}
 
 		el2_reg = find_el2_sysreg(nested_sysreg_map, reg);
-		if (el2_reg) {
-			/* Does this register have an EL1 counterpart? */
-			if (el2_reg->mapping == __INVALID_SYSREG__)
-				return;
+		WARN(!el2_reg, "reg: %d\n", reg);
 
-			if (!vcpu_el2_e2h_is_set(vcpu) &&
-			    el2_reg->translate)
-				val = el2_reg->translate(val);
+		/* Does this register have an EL1 counterpart? */
+		if (el2_reg->mapping == __INVALID_SYSREG__)
+			goto memory_write;
 
-			/* Redirect this to the EL1 version of the register. */
-			reg = el2_reg->mapping;
-		}
-	} else {
-		/* EL1 register can't be on the CPU if the guest is in vEL2. */
-		if (unlikely(is_hyp_ctxt(vcpu)))
-			goto immediate_write;
-	}
+		if (!vcpu_el2_e2h_is_set(vcpu) &&
+		    el2_reg->translate)
+			val = el2_reg->translate(val);
 
-	/*
-	 * System registers listed in the switch are not restored on every
-	 * entry to the guest but are only restored on vcpu_load.
-	 *
-	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
-	 * should never be listed below, because the the MPIDR should only be
-	 * set once, before running the VCPU, and never changed later.
-	 */
-	switch (reg) {
-	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
-	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	return;
-	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
-	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	return;
-	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	return;
-	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	return;
-	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	return;
-	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	return;
-	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	return;
-	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	return;
-	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	return;
-	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	return;
-	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	return;
-	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12); return;
-	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	return;
-	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	return;
-	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	return;
-	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	return;
-	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	return;
-	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	return;
-	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	return;
-	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	return;
-	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	return;
-	case SP_EL2:		write_sysreg(val, sp_el1);		return;
-	case ELR_EL2:		write_sysreg_el1(val, SYS_ELR);		return;
+		/* Redirect this to the EL1 version of the register. */
+		reg = el2_reg->mapping;
+		WARN_ON(!__vcpu_write_sys_reg_to_cpu(val, reg));
+		return;
 	}
 
-immediate_write:
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_write;
+
+	if (__vcpu_write_sys_reg_to_cpu(val, reg))
+		return;
+
+memory_write:
 	 __vcpu_sys_reg(vcpu, reg) = val;
 }
 
-- 
2.20.1

