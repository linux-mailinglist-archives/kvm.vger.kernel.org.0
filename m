Return-Path: <kvm+bounces-2081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A106D7F13FD
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 571332820F1
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53AF81C6B2;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3Vkzip5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE771BDC9;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7668DC433AB;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485853;
	bh=CZhhXZ8QKNznTktBE86rbHLYtD+3fHcym+v/429FNkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3Vkzip52fMIzd4T+Dx+HYtoXn7B0WFsmWgzBVQ5bV5AHf3WEg4Z3UmqGHZropyQc
	 JcgjtT4WK8jNSUpir85/165UuGZr6ZpKyLL/GAV5CT92tZ6FwDKTEHy7PCrCqnAKbo
	 ZzBSMsIlMLgh2XKu1+eKAgVJB8HcTM/JMOBMXCpUulfcHrLSKO2KJCTbEArkFxvzzq
	 sIcItqnYVAIKoFLGfbkDcBWoqqSROy9kPPxCPbwiDoGqk/zcuCWWn96YlE5BRP1Ras
	 bgca4syx6TGQlUb2XozFMHGlrr2SXp6s/T6ZlrAuwh0g7GkyeOS5lc+BRmw+vAi7nl
	 jzrTzICihuLkw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5439-00EjnU-Jh;
	Mon, 20 Nov 2023 13:10:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 10/43] KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()
Date: Mon, 20 Nov 2023 13:09:54 +0000
Message-Id: <20231120131027.854038-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

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

- Some EL2 system registers have a different format than their EL1
  counterpart, so we need to translate them before writing them to the
  CPU. This is done using an (optional) translate function in the map.

All of these cases are now wrapped into the existing accessor functions,
so KVM users wouldn't need to care whether they access EL2 or EL1
registers and also which state the guest is in.

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Co-developed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/kvm/sys_regs.c         | 129 ++++++++++++++++++++++++++++--
 2 files changed, 126 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8cd2bb95c3..f17fb7c42973 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -907,6 +907,7 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
 	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
+	case SPSR_EL1:		*val = read_sysreg_s(SYS_SPSR_EL12);	break;
 	case PAR_EL1:		*val = read_sysreg_par();		break;
 	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
@@ -951,6 +952,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
 	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
+	case SPSR_EL1:		write_sysreg_s(val, SYS_SPSR_EL12);	break;
 	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
 	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c31fddc1591d..92bb91e520a8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -72,24 +72,143 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 			"sys_reg write to read-only register");
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
+static bool get_el2_to_el1_mapping(unsigned int reg,
+				   unsigned int *el1r, u64 (**xlate)(u64))
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
+		PURE_EL2_SYSREG(  CNTHCTL_EL2	);
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
+		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
+		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
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
+	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
+		goto memory_read;
 
-	if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
-	    __vcpu_read_sys_reg_from_cpu(reg, &val))
+	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
+		if (!is_hyp_ctxt(vcpu))
+			goto memory_read;
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
+
+	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
+memory_read:
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
-	    __vcpu_write_sys_reg_to_cpu(val, reg))
+	u64 (*xlate)(u64) = NULL;
+	unsigned int el1r;
+
+	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
+		goto memory_write;
+
+	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
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
 
-	__vcpu_sys_reg(vcpu, reg) = val;
+memory_write:
+	 __vcpu_sys_reg(vcpu, reg) = val;
 }
 
 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
-- 
2.39.2


