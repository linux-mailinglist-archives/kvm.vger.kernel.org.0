Return-Path: <kvm+bounces-54345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88BEBB1F501
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 16:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43726563433
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 14:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7753298CC9;
	Sat,  9 Aug 2025 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJCAcpqa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC78B8F6E;
	Sat,  9 Aug 2025 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754750898; cv=none; b=a3CgrsW3YwQ+n4NMPovKLqG5LdL4K2GtzQbk8n1xiriJg8rBRsl675+qfb/hNRSTk+vaWCEO74j1bW4UYmNi73ybb3WOIDFem71E6EgBb+BBhDEEGWIF/64b/LPab0AS1PStOwsgRHIyr00pIZ2Xc/hwvpgmN8hEpCHENITseb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754750898; c=relaxed/simple;
	bh=4awGKrAQzvTwgCvexDgJWkuN8i3prB0yA4DHFUJoLDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=omDFf4ZGDyEVhUlSMxqQhb7Yr2rHmyx2IoXOCSSxHMESbjC8zRIHdC8WtFxP+6wdx/YVSLJBPTx3jDTf0S7rHk0EO7kJ4z7yP5fur+fDdezctJnGvUl3eUpNN7Ql4pELRF7kDIdpGrfu2h9i4i27YEFnCxsLAvPUvIqjoOYesB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJCAcpqa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBABC4CEE7;
	Sat,  9 Aug 2025 14:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754750897;
	bh=4awGKrAQzvTwgCvexDgJWkuN8i3prB0yA4DHFUJoLDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJCAcpqa1yuxShnhYf2YD7oZ+benu0nbtzj3Q/JRHC3IIbSNovBUl9Zd9sxSJvl8s
	 6+nf+xLJYwrzpCWFYWglxQ4YCB4Uln8GtpwyZLF5r8mCKQATvfXWFucyy/y9KJJsTL
	 WyqjwEJ4sEpj1TxmT2RQ6C4kul1tsLgJHC0CcN/MZB+LK6Blu1k/jSZqJ9bmqRaKk+
	 MhYbYeaDi7TSUpnJn8owZDThJQ7bNEPNwjCUbbyLJ9GIlGv0n7XpI5zq5b9qLa30Gk
	 GoKqf4/+A2kDH2zcS4HCwsDVAcrzYWBrBSzy34bDdf+0JapJqH93WTBvalNJM0+Lq3
	 fhUU+auUWlFZg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ukkrn-005eZC-4x;
	Sat, 09 Aug 2025 15:48:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/2] KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
Date: Sat,  9 Aug 2025 15:48:11 +0100
Message-Id: <20250809144811.2314038-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250809144811.2314038-1-maz@kernel.org>
References: <20250809144811.2314038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, volodymyr_babchuk@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Volodymyr reports (again!) that under some circumstances (E2H==0,
walking S1 PTs), PAR_EL1 doesn't report the value of the latest
walk in the CPU register, but that instead the value is written to
the backing store.

Further investigation indicates that the root cause of this is
that a group of registers (PAR_EL1, TPIDR*_EL{0,1}) should always
be considered as "on CPU", as they are not remapped between EL1 and
EL2. We fail to treat them accordingly, and end-up considering that
the register (PAR_EL1 in this example) should be written to memory
instead of in the register.

While it would be possible to quickly work around it, it is obvious
that the way we track these things at the moment is pretty horrible,
and could do with some improvement.

Revamp the whole thing by:

- defining a location for a register (memory, cpu), potentially
  depending on the state of the vcpu

- define a transformation for this register (mapped register, potential
  translation, special register needing some particular attention)

- convey this information in a structure that can be easily passed
  around

As a result, the accessors themselves become much simpler, as the
state is explicit instead of being driven by hard-to-understand
conventions.

We get rid of the "pure EL2 register" notion, which wasn't very
useful, and add sanitisation of the values by applying the RESx
masks as required, something that was missing so far.

And of course, we add the missing registers to the list, with the
indication that they are always loaded.

Reported-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: fedc612314acf ("KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()")
Link: https://lore.kerbnel.org/r/20250806141707.3479194-3-volodymyr_babchuk@epam.com
---
 arch/arm64/include/asm/kvm_host.h |   4 +-
 arch/arm64/kvm/sys_regs.c         | 243 +++++++++++++++---------------
 2 files changed, 127 insertions(+), 120 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2f2394cce24ed..a9661d35bfd02 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1160,8 +1160,8 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 		__v;							\
 	})
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
+u64 vcpu_read_sys_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
+void vcpu_write_sys_reg(struct kvm_vcpu *, u64, enum vcpu_sysreg);
 
 static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82ffb3b3b3cf7..c9aa41da8d3a3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -82,43 +82,55 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 			"sys_reg write to read-only register");
 }
 
-#define PURE_EL2_SYSREG(el2)						\
-	case el2: {							\
-		*el1r = el2;						\
-		return true;						\
-	}
+enum sr_loc_attr {
+	SR_LOC_MEMORY	= 0,	  /* Register definitely in memory */
+	SR_LOC_LOADED	= BIT(0), /* Register on CPU, unless it cannot */
+	SR_LOC_MAPPED	= BIT(1), /* Register in a different CPU register */
+	SR_LOC_XLATED	= BIT(2), /* Register translated to fit another reg */
+	SR_LOC_SPECIAL	= BIT(3), /* Demanding register, implies loaded */
+};
 
-#define MAPPED_EL2_SYSREG(el2, el1, fn)					\
-	case el2: {							\
-		*xlate = fn;						\
-		*el1r = el1;						\
-		return true;						\
-	}
+struct sr_loc {
+	enum sr_loc_attr loc;
+	enum vcpu_sysreg map_reg;
+	u64		 (*xlate)(u64);
+};
 
-static bool get_el2_to_el1_mapping(unsigned int reg,
-				   unsigned int *el1r, u64 (**xlate)(u64))
+static void locate_mapped_el2_register(const struct kvm_vcpu *vcpu,
+				       enum vcpu_sysreg reg,
+				       enum vcpu_sysreg map_reg,
+				       u64 (*xlate)(u64),
+				       struct sr_loc *loc)
 {
+	if (!is_hyp_ctxt(vcpu)) {
+		loc->loc = SR_LOC_MEMORY;
+		return;
+	}
+
+	loc->loc = SR_LOC_LOADED | SR_LOC_MAPPED;
+	loc->map_reg = map_reg;
+
+	if (xlate != NULL && !vcpu_el2_e2h_is_set(vcpu)) {
+		loc->loc |= SR_LOC_XLATED;
+		loc->xlate = xlate;
+	}
+}
+
+#define MAPPED_EL2_SYSREG(r, m, t)					\
+	case r:	{							\
+		locate_mapped_el2_register(vcpu, r, m, t, loc);		\
+		break;							\
+	}
+
+static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
+			    struct sr_loc *loc)
+{
+	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU)) {
+		loc->loc = SR_LOC_MEMORY;
+		return;
+	}
+
 	switch (reg) {
-		PURE_EL2_SYSREG(  VPIDR_EL2	);
-		PURE_EL2_SYSREG(  VMPIDR_EL2	);
-		PURE_EL2_SYSREG(  ACTLR_EL2	);
-		PURE_EL2_SYSREG(  HCR_EL2	);
-		PURE_EL2_SYSREG(  MDCR_EL2	);
-		PURE_EL2_SYSREG(  HSTR_EL2	);
-		PURE_EL2_SYSREG(  HACR_EL2	);
-		PURE_EL2_SYSREG(  VTTBR_EL2	);
-		PURE_EL2_SYSREG(  VTCR_EL2	);
-		PURE_EL2_SYSREG(  TPIDR_EL2	);
-		PURE_EL2_SYSREG(  HPFAR_EL2	);
-		PURE_EL2_SYSREG(  HCRX_EL2	);
-		PURE_EL2_SYSREG(  HFGRTR_EL2	);
-		PURE_EL2_SYSREG(  HFGWTR_EL2	);
-		PURE_EL2_SYSREG(  HFGITR_EL2	);
-		PURE_EL2_SYSREG(  HDFGRTR_EL2	);
-		PURE_EL2_SYSREG(  HDFGWTR_EL2	);
-		PURE_EL2_SYSREG(  HAFGRTR_EL2	);
-		PURE_EL2_SYSREG(  CNTVOFF_EL2	);
-		PURE_EL2_SYSREG(  CNTHCTL_EL2	);
 		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
 				  translate_sctlr_el2_to_sctlr_el1	     );
 		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
@@ -144,125 +156,120 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(ZCR_EL2,     ZCR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(CONTEXTIDR_EL2, CONTEXTIDR_EL1, NULL	     );
 		MAPPED_EL2_SYSREG(SCTLR2_EL2,  SCTLR2_EL1,  NULL	     );
+	case CNTHCTL_EL2:
+		/* CNTHCTL_EL2 is super special, until we support NV2.1 */
+		loc->loc = ((is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu)) ?
+			    SR_LOC_SPECIAL : SR_LOC_MEMORY);
+		break;
+	case TPIDR_EL0:
+	case TPIDRRO_EL0:
+	case TPIDR_EL1:
+	case PAR_EL1:
+		/* These registers are always loaded, no matter what */
+		loc->loc = SR_LOC_LOADED;
+		break;
 	default:
-		return false;
+		/*
+		 * Non-mapped EL2 registers are by definition in memory, but
+		 * we don't need to distinguish them here, as the CPU
+		 * register accessors will bail out and we'll end-up using
+		 * the backing store.
+		 *
+		 * EL1 registers are, however, only loaded if we're
+		 * not in hypervisor context.
+		 */
+		loc->loc = is_hyp_ctxt(vcpu) ? SR_LOC_MEMORY : SR_LOC_LOADED;
 	}
 }
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 {
-	u64 val = 0x8badf00d8badf00d;
-	u64 (*xlate)(u64) = NULL;
-	unsigned int el1r;
+	struct sr_loc loc = {};
 
-	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
-		goto memory_read;
+	locate_register(vcpu, reg, &loc);
 
-	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
-		if (!is_hyp_ctxt(vcpu))
-			goto memory_read;
+	if (loc.loc & SR_LOC_SPECIAL) {
+		u64 val;
 
 		/*
-		 * CNTHCTL_EL2 requires some special treatment to
-		 * account for the bits that can be set via CNTKCTL_EL1.
+		 * CNTHCTL_EL2 requires some special treatment to account
+		 * for the bits that can be set via CNTKCTL_EL1 when E2H==1.
 		 */
 		switch (reg) {
 		case CNTHCTL_EL2:
-			if (vcpu_el2_e2h_is_set(vcpu)) {
-				val = read_sysreg_el1(SYS_CNTKCTL);
-				val &= CNTKCTL_VALID_BITS;
-				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
-				return val;
-			}
-			break;
+			val = read_sysreg_el1(SYS_CNTKCTL);
+			val &= CNTKCTL_VALID_BITS;
+			val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
+			return val;
+		default:
+			WARN_ON_ONCE(1);
 		}
-
-		/*
-		 * If this register does not have an EL1 counterpart,
-		 * then read the stored EL2 version.
-		 */
-		if (reg == el1r)
-			goto memory_read;
-
-		/*
-		 * If we have a non-VHE guest and that the sysreg
-		 * requires translation to be used at EL1, use the
-		 * in-memory copy instead.
-		 */
-		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
-			goto memory_read;
-
-		/* Get the current version of the EL1 counterpart. */
-		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
-		if (reg >= __SANITISED_REG_START__)
-			val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
-
-		return val;
 	}
 
-	/* EL1 register can't be on the CPU if the guest is in vEL2. */
-	if (unlikely(is_hyp_ctxt(vcpu)))
-		goto memory_read;
+	if (loc.loc & SR_LOC_LOADED) {
+		enum vcpu_sysreg map_reg = reg;
+		u64 val = 0x8badf00d8badf00d;
 
-	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
-		return val;
+		if (loc.loc & SR_LOC_MAPPED)
+			map_reg = loc.map_reg;
+
+		if (!(loc.loc & SR_LOC_XLATED) &&
+		    __vcpu_read_sys_reg_from_cpu(map_reg, &val)) {
+			if (reg >= __SANITISED_REG_START__)
+				val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
+
+			return val;
+		}
+	}
 
-memory_read:
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
 {
-	u64 (*xlate)(u64) = NULL;
-	unsigned int el1r;
+	struct sr_loc loc = {};
 
-	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
-		goto memory_write;
-
-	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
-		if (!is_hyp_ctxt(vcpu))
-			goto memory_write;
-
-		/*
-		 * Always store a copy of the write to memory to avoid having
-		 * to reverse-translate virtual EL2 system registers for a
-		 * non-VHE guest hypervisor.
-		 */
-		__vcpu_assign_sys_reg(vcpu, reg, val);
+	locate_register(vcpu, reg, &loc);
 
+	if (loc.loc & SR_LOC_SPECIAL) {
 		switch (reg) {
 		case CNTHCTL_EL2:
 			/*
-			 * If E2H=0, CNHTCTL_EL2 is a pure shadow register.
-			 * Otherwise, some of the bits are backed by
+			 * If E2H=1, some of the bits are backed by
 			 * CNTKCTL_EL1, while the rest is kept in memory.
 			 * Yes, this is fun stuff.
 			 */
-			if (vcpu_el2_e2h_is_set(vcpu))
-				write_sysreg_el1(val, SYS_CNTKCTL);
-			return;
+			write_sysreg_el1(val, SYS_CNTKCTL);
+			break;
+		default:
+			WARN_ON_ONCE(1);
 		}
-
-		/* No EL1 counterpart? We're done here.? */
-		if (reg == el1r)
-			return;
-
-		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
-			val = xlate(val);
-
-		/* Redirect this to the EL1 version of the register. */
-		WARN_ON(!__vcpu_write_sys_reg_to_cpu(val, el1r));
-		return;
 	}
 
-	/* EL1 register can't be on the CPU if the guest is in vEL2. */
-	if (unlikely(is_hyp_ctxt(vcpu)))
-		goto memory_write;
+	if (loc.loc & SR_LOC_LOADED) {
+		enum vcpu_sysreg map_reg = reg;
+		u64 xlated_val;
 
-	if (__vcpu_write_sys_reg_to_cpu(val, reg))
-		return;
+		if (reg >= __SANITISED_REG_START__)
+			val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
+
+		if (loc.loc & SR_LOC_MAPPED)
+			map_reg = loc.map_reg;
+
+		if (loc.loc & SR_LOC_XLATED)
+			xlated_val = loc.xlate(val);
+		else
+			xlated_val = val;
+
+		__vcpu_write_sys_reg_to_cpu(xlated_val, map_reg);
+
+		/*
+		 * Fall through to write the backing store anyway, which
+		 * allows translated registers to be directly read without a
+		 * reverse translation.
+		 */
+	}
 
-memory_write:
 	__vcpu_assign_sys_reg(vcpu, reg, val);
 }
 
-- 
2.39.2


