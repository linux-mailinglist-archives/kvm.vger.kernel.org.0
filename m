Return-Path: <kvm+bounces-45643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF330AACB63
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1DB6506508
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46EDE288534;
	Tue,  6 May 2025 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPsTk69l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E62288504;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549855; cv=none; b=u11kwTMyIdw3hfuIzxXJTSLSJtzRvvi3HWShgoq2Mg7aZYdtCy/iBw37EyP86RQBfF7pfDFiaclyAChKCcstmnXYhw/FdcwAjxTxOcPquabQFopizx+jHs0awRGcBEa6anu+OeO/zMm9wgIFbCM56fE/7golI7MQ+WtGu5Ci+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549855; c=relaxed/simple;
	bh=/R4S47iybWR0uSmiUV8VpJb9vJDuQV8hWMDmj34P27o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JoOsIo0bqHmYh/1MYPWa7uFUhfCwHHA7V92jgbsWI+a0t1+kP9W5KTO1+IdM/V+4MOPhLWJfxlcupfvfzVXlKsT4hemVvgCGpqIexpCHtPpre6ELbbObHHlbGBoaOLtik5JRtyQPb/O9nDW8FnudqyXOu+QWQKzQJvS/BMBjsqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPsTk69l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047F8C4CEE4;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549855;
	bh=/R4S47iybWR0uSmiUV8VpJb9vJDuQV8hWMDmj34P27o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPsTk69lQUf2vo7ID5H2HeUl3ANv6GTeh2z4+RHERZe9J49eCMGUTiSV2spaRGj4o
	 JYle2GqKLTPL4pQihBa0c2vyKZh435nLrQfgsy341SRwj9dW3Cs1g/7OX0ac9Zmihh
	 vf6BiouScEbMwnT+VXa/QWZZLaha3YcoEBmUvMoaTek7Rs+qgVUtwp8sJ2mLvjIA0T
	 7Syrafwr1UxJsaN4+cX8H1BVP/W37LCLF90kZ1hqPl355lzpAGEfziUqdqhCu1nQkO
	 SMES7iHVvJt4mxFrHHrrmqIrVbhZUj8HZM0A7Av1vsfpVdxNM+UgEjktvpIHA/dgRI
	 A2U94jF4Wz3zA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOv-00CJkN-8t;
	Tue, 06 May 2025 17:44:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 31/43] KVM: arm64: Switch to table-driven FGU configuration
Date: Tue,  6 May 2025 17:43:36 +0100
Message-Id: <20250506164348.346001-32-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Defining the FGU behaviour is extremely tedious. It relies on matching
each set of bits from FGT registers with am architectural feature, and
adding them to the FGU list if the corresponding feature isn't advertised
to the guest.

It is however relatively easy to dump most of that information from
the architecture JSON description, and use that to control the FGU bits.

Let's introduce a new set of tables descripbing the mapping between
FGT bits and features. Most of the time, this is only a lookup in
an idreg field, with a few more complex exceptions.

While this is obviously many more lines in a new file, this is
mostly generated, and is pretty easy to maintain.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/kvm/Makefile           |   2 +-
 arch/arm64/kvm/config.c           | 589 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  73 +---
 4 files changed, 596 insertions(+), 70 deletions(-)
 create mode 100644 arch/arm64/kvm/config.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e5164fad0dbc..9386f15cdc252 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1610,4 +1610,6 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 209bc76263f10..7c329e01c557a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ CFLAGS_sys_regs.o += -Wno-override-init
 CFLAGS_handle_exit.o += -Wno-override-init
 
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
-	 inject_fault.o va_layout.o handle_exit.o \
+	 inject_fault.o va_layout.o handle_exit.o config.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
new file mode 100644
index 0000000000000..85350b883abf7
--- /dev/null
+++ b/arch/arm64/kvm/config.c
@@ -0,0 +1,589 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/sysreg.h>
+
+struct reg_bits_to_feat_map {
+	u64		bits;
+
+#define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
+#define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
+#define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
+	unsigned long	flags;
+
+	union {
+		struct {
+			u8	regidx;
+			u8	shift;
+			u8	width;
+			bool	sign;
+			s8	lo_lim;
+		};
+		bool	(*match)(struct kvm *);
+		bool	(*fval)(struct kvm *, u64 *);
+	};
+};
+
+#define __NEEDS_FEAT_3(m, f, id, fld, lim)		\
+	{						\
+		.bits	= (m),				\
+		.flags = (f),				\
+		.regidx	= IDREG_IDX(SYS_ ## id),	\
+		.shift	= id ##_## fld ## _SHIFT,	\
+		.width	= id ##_## fld ## _WIDTH,	\
+		.sign	= id ##_## fld ## _SIGNED,	\
+		.lo_lim	= id ##_## fld ##_## lim	\
+	}
+
+#define __NEEDS_FEAT_2(m, f, fun, dummy)		\
+	{						\
+		.bits	= (m),				\
+		.flags = (f) | CALL_FUNC,		\
+		.fval = (fun),				\
+	}
+
+#define __NEEDS_FEAT_1(m, f, fun)			\
+	{						\
+		.bits	= (m),				\
+		.flags = (f) | CALL_FUNC,		\
+		.match = (fun),				\
+	}
+
+#define NEEDS_FEAT_FLAG(m, f, ...)			\
+	CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, __VA_ARGS__)
+
+#define NEEDS_FEAT_FIXED(m, ...)			\
+	NEEDS_FEAT_FLAG(m, FIXED_VALUE, __VA_ARGS__, 0)
+
+#define NEEDS_FEAT(m, ...)	NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
+
+#define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
+#define FEAT_SPE_FnE		ID_AA64DFR0_EL1, PMSVer, V1P2
+#define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
+#define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
+#define FEAT_PMUv3		ID_AA64DFR0_EL1, PMUVer, IMP
+#define FEAT_TRBE		ID_AA64DFR0_EL1, TraceBuffer, IMP
+#define FEAT_DoubleLock		ID_AA64DFR0_EL1, DoubleLock, IMP
+#define FEAT_TRF		ID_AA64DFR0_EL1, TraceFilt, IMP
+#define FEAT_AA64EL1		ID_AA64PFR0_EL1, EL1, IMP
+#define FEAT_AIE		ID_AA64MMFR3_EL1, AIE, IMP
+#define FEAT_S2POE		ID_AA64MMFR3_EL1, S2POE, IMP
+#define FEAT_S1POE		ID_AA64MMFR3_EL1, S1POE, IMP
+#define FEAT_S1PIE		ID_AA64MMFR3_EL1, S1PIE, IMP
+#define FEAT_THE		ID_AA64PFR1_EL1, THE, IMP
+#define FEAT_SME		ID_AA64PFR1_EL1, SME, IMP
+#define FEAT_GCS		ID_AA64PFR1_EL1, GCS, IMP
+#define FEAT_LS64_ACCDATA	ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA
+#define FEAT_RAS		ID_AA64PFR0_EL1, RAS, IMP
+#define FEAT_GICv3		ID_AA64PFR0_EL1, GIC, IMP
+#define FEAT_LOR		ID_AA64MMFR1_EL1, LO, IMP
+#define FEAT_SPEv1p5		ID_AA64DFR0_EL1, PMSVer, V1P5
+#define FEAT_ATS1A		ID_AA64ISAR2_EL1, ATS1A, IMP
+#define FEAT_SPECRES2		ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX
+#define FEAT_SPECRES		ID_AA64ISAR1_EL1, SPECRES, IMP
+#define FEAT_TLBIRANGE		ID_AA64ISAR0_EL1, TLB, RANGE
+#define FEAT_TLBIOS		ID_AA64ISAR0_EL1, TLB, OS
+#define FEAT_PAN2		ID_AA64MMFR1_EL1, PAN, PAN2
+#define FEAT_DPB2		ID_AA64ISAR1_EL1, DPB, DPB2
+#define FEAT_AMUv1		ID_AA64PFR0_EL1, AMU, IMP
+
+static bool feat_rasv1p1(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
+		(kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, IMP) &&
+		 kvm_has_feat(kvm, ID_AA64PFR1_EL1, RAS_frac, RASv1p1)));
+}
+
+static bool feat_csv2_2_csv2_1p2(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm,  ID_AA64PFR0_EL1, CSV2, CSV2_2) ||
+		(kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2) &&
+		 kvm_has_feat_enum(kvm,  ID_AA64PFR0_EL1, CSV2, IMP)));
+}
+
+static bool feat_pauth(struct kvm *kvm)
+{
+	return kvm_has_pauth(kvm, PAuth);
+}
+
+static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
+	NEEDS_FEAT(HFGRTR_EL2_nAMAIR2_EL1	|
+		   HFGRTR_EL2_nMAIR2_EL1,
+		   FEAT_AIE),
+	NEEDS_FEAT(HFGRTR_EL2_nS2POR_EL1, FEAT_S2POE),
+	NEEDS_FEAT(HFGRTR_EL2_nPOR_EL1		|
+		   HFGRTR_EL2_nPOR_EL0,
+		   FEAT_S1POE),
+	NEEDS_FEAT(HFGRTR_EL2_nPIR_EL1		|
+		   HFGRTR_EL2_nPIRE0_EL1,
+		   FEAT_S1PIE),
+	NEEDS_FEAT(HFGRTR_EL2_nRCWMASK_EL1, FEAT_THE),
+	NEEDS_FEAT(HFGRTR_EL2_nTPIDR2_EL0	|
+		   HFGRTR_EL2_nSMPRI_EL1,
+		   FEAT_SME),
+	NEEDS_FEAT(HFGRTR_EL2_nGCS_EL1		|
+		   HFGRTR_EL2_nGCS_EL0,
+		   FEAT_GCS),
+	NEEDS_FEAT(HFGRTR_EL2_nACCDATA_EL1, FEAT_LS64_ACCDATA),
+	NEEDS_FEAT(HFGRTR_EL2_ERXADDR_EL1	|
+		   HFGRTR_EL2_ERXMISCn_EL1	|
+		   HFGRTR_EL2_ERXSTATUS_EL1	|
+		   HFGRTR_EL2_ERXCTLR_EL1	|
+		   HFGRTR_EL2_ERXFR_EL1		|
+		   HFGRTR_EL2_ERRSELR_EL1	|
+		   HFGRTR_EL2_ERRIDR_EL1,
+		   FEAT_RAS),
+	NEEDS_FEAT(HFGRTR_EL2_ERXPFGCDN_EL1|
+		   HFGRTR_EL2_ERXPFGCTL_EL1|
+		   HFGRTR_EL2_ERXPFGF_EL1,
+		   feat_rasv1p1),
+	NEEDS_FEAT(HFGRTR_EL2_ICC_IGRPENn_EL1, FEAT_GICv3),
+	NEEDS_FEAT(HFGRTR_EL2_SCXTNUM_EL0	|
+		   HFGRTR_EL2_SCXTNUM_EL1,
+		   feat_csv2_2_csv2_1p2),
+	NEEDS_FEAT(HFGRTR_EL2_LORSA_EL1		|
+		   HFGRTR_EL2_LORN_EL1		|
+		   HFGRTR_EL2_LORID_EL1		|
+		   HFGRTR_EL2_LOREA_EL1		|
+		   HFGRTR_EL2_LORC_EL1,
+		   FEAT_LOR),
+	NEEDS_FEAT(HFGRTR_EL2_APIBKey		|
+		   HFGRTR_EL2_APIAKey		|
+		   HFGRTR_EL2_APGAKey		|
+		   HFGRTR_EL2_APDBKey		|
+		   HFGRTR_EL2_APDAKey,
+		   feat_pauth),
+	NEEDS_FEAT_FLAG(HFGRTR_EL2_VBAR_EL1	|
+			HFGRTR_EL2_TTBR1_EL1	|
+			HFGRTR_EL2_TTBR0_EL1	|
+			HFGRTR_EL2_TPIDR_EL0	|
+			HFGRTR_EL2_TPIDRRO_EL0	|
+			HFGRTR_EL2_TPIDR_EL1	|
+			HFGRTR_EL2_TCR_EL1	|
+			HFGRTR_EL2_SCTLR_EL1	|
+			HFGRTR_EL2_REVIDR_EL1	|
+			HFGRTR_EL2_PAR_EL1	|
+			HFGRTR_EL2_MPIDR_EL1	|
+			HFGRTR_EL2_MIDR_EL1	|
+			HFGRTR_EL2_MAIR_EL1	|
+			HFGRTR_EL2_ISR_EL1	|
+			HFGRTR_EL2_FAR_EL1	|
+			HFGRTR_EL2_ESR_EL1	|
+			HFGRTR_EL2_DCZID_EL0	|
+			HFGRTR_EL2_CTR_EL0	|
+			HFGRTR_EL2_CSSELR_EL1	|
+			HFGRTR_EL2_CPACR_EL1	|
+			HFGRTR_EL2_CONTEXTIDR_EL1|
+			HFGRTR_EL2_CLIDR_EL1	|
+			HFGRTR_EL2_CCSIDR_EL1	|
+			HFGRTR_EL2_AMAIR_EL1	|
+			HFGRTR_EL2_AIDR_EL1	|
+			HFGRTR_EL2_AFSR1_EL1	|
+			HFGRTR_EL2_AFSR0_EL1,
+			NEVER_FGU, FEAT_AA64EL1),
+};
+
+static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
+	NEEDS_FEAT(HFGWTR_EL2_nAMAIR2_EL1	|
+		   HFGWTR_EL2_nMAIR2_EL1,
+		   FEAT_AIE),
+	NEEDS_FEAT(HFGWTR_EL2_nS2POR_EL1, FEAT_S2POE),
+	NEEDS_FEAT(HFGWTR_EL2_nPOR_EL1		|
+		   HFGWTR_EL2_nPOR_EL0,
+		   FEAT_S1POE),
+	NEEDS_FEAT(HFGWTR_EL2_nPIR_EL1		|
+		   HFGWTR_EL2_nPIRE0_EL1,
+		   FEAT_S1PIE),
+	NEEDS_FEAT(HFGWTR_EL2_nRCWMASK_EL1, FEAT_THE),
+	NEEDS_FEAT(HFGWTR_EL2_nTPIDR2_EL0	|
+		   HFGWTR_EL2_nSMPRI_EL1,
+		   FEAT_SME),
+	NEEDS_FEAT(HFGWTR_EL2_nGCS_EL1		|
+		   HFGWTR_EL2_nGCS_EL0,
+		   FEAT_GCS),
+	NEEDS_FEAT(HFGWTR_EL2_nACCDATA_EL1, FEAT_LS64_ACCDATA),
+	NEEDS_FEAT(HFGWTR_EL2_ERXADDR_EL1	|
+		   HFGWTR_EL2_ERXMISCn_EL1	|
+		   HFGWTR_EL2_ERXSTATUS_EL1	|
+		   HFGWTR_EL2_ERXCTLR_EL1	|
+		   HFGWTR_EL2_ERRSELR_EL1,
+		   FEAT_RAS),
+	NEEDS_FEAT(HFGWTR_EL2_ERXPFGCDN_EL1	|
+		   HFGWTR_EL2_ERXPFGCTL_EL1,
+		   feat_rasv1p1),
+	NEEDS_FEAT(HFGWTR_EL2_ICC_IGRPENn_EL1, FEAT_GICv3),
+	NEEDS_FEAT(HFGWTR_EL2_SCXTNUM_EL0	|
+		   HFGWTR_EL2_SCXTNUM_EL1,
+		   feat_csv2_2_csv2_1p2),
+	NEEDS_FEAT(HFGWTR_EL2_LORSA_EL1		|
+		   HFGWTR_EL2_LORN_EL1		|
+		   HFGWTR_EL2_LOREA_EL1		|
+		   HFGWTR_EL2_LORC_EL1,
+		   FEAT_LOR),
+	NEEDS_FEAT(HFGWTR_EL2_APIBKey		|
+		   HFGWTR_EL2_APIAKey		|
+		   HFGWTR_EL2_APGAKey		|
+		   HFGWTR_EL2_APDBKey		|
+		   HFGWTR_EL2_APDAKey,
+		   feat_pauth),
+	NEEDS_FEAT_FLAG(HFGWTR_EL2_VBAR_EL1	|
+			HFGWTR_EL2_TTBR1_EL1	|
+			HFGWTR_EL2_TTBR0_EL1	|
+			HFGWTR_EL2_TPIDR_EL0	|
+			HFGWTR_EL2_TPIDRRO_EL0	|
+			HFGWTR_EL2_TPIDR_EL1	|
+			HFGWTR_EL2_TCR_EL1	|
+			HFGWTR_EL2_SCTLR_EL1	|
+			HFGWTR_EL2_PAR_EL1	|
+			HFGWTR_EL2_MAIR_EL1	|
+			HFGWTR_EL2_FAR_EL1	|
+			HFGWTR_EL2_ESR_EL1	|
+			HFGWTR_EL2_CSSELR_EL1	|
+			HFGWTR_EL2_CPACR_EL1	|
+			HFGWTR_EL2_CONTEXTIDR_EL1|
+			HFGWTR_EL2_AMAIR_EL1	|
+			HFGWTR_EL2_AFSR1_EL1	|
+			HFGWTR_EL2_AFSR0_EL1,
+			NEVER_FGU, FEAT_AA64EL1),
+};
+
+static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
+	NEEDS_FEAT(HDFGRTR_EL2_PMBIDR_EL1	|
+		   HDFGRTR_EL2_PMSLATFR_EL1	|
+		   HDFGRTR_EL2_PMSIRR_EL1	|
+		   HDFGRTR_EL2_PMSIDR_EL1	|
+		   HDFGRTR_EL2_PMSICR_EL1	|
+		   HDFGRTR_EL2_PMSFCR_EL1	|
+		   HDFGRTR_EL2_PMSEVFR_EL1	|
+		   HDFGRTR_EL2_PMSCR_EL1	|
+		   HDFGRTR_EL2_PMBSR_EL1	|
+		   HDFGRTR_EL2_PMBPTR_EL1	|
+		   HDFGRTR_EL2_PMBLIMITR_EL1,
+		   FEAT_SPE),
+	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, FEAT_SPE_FnE),
+	NEEDS_FEAT(HDFGRTR_EL2_nBRBDATA		|
+		   HDFGRTR_EL2_nBRBCTL		|
+		   HDFGRTR_EL2_nBRBIDR,
+		   FEAT_BRBE),
+	NEEDS_FEAT(HDFGRTR_EL2_TRCVICTLR	|
+		   HDFGRTR_EL2_TRCSTATR		|
+		   HDFGRTR_EL2_TRCSSCSRn	|
+		   HDFGRTR_EL2_TRCSEQSTR	|
+		   HDFGRTR_EL2_TRCPRGCTLR	|
+		   HDFGRTR_EL2_TRCOSLSR		|
+		   HDFGRTR_EL2_TRCIMSPECn	|
+		   HDFGRTR_EL2_TRCID		|
+		   HDFGRTR_EL2_TRCCNTVRn	|
+		   HDFGRTR_EL2_TRCCLAIM		|
+		   HDFGRTR_EL2_TRCAUXCTLR	|
+		   HDFGRTR_EL2_TRCAUTHSTATUS	|
+		   HDFGRTR_EL2_TRC,
+		   FEAT_TRC_SR),
+	NEEDS_FEAT(HDFGRTR_EL2_PMCEIDn_EL0	|
+		   HDFGRTR_EL2_PMUSERENR_EL0	|
+		   HDFGRTR_EL2_PMMIR_EL1	|
+		   HDFGRTR_EL2_PMSELR_EL0	|
+		   HDFGRTR_EL2_PMOVS		|
+		   HDFGRTR_EL2_PMINTEN		|
+		   HDFGRTR_EL2_PMCNTEN		|
+		   HDFGRTR_EL2_PMCCNTR_EL0	|
+		   HDFGRTR_EL2_PMCCFILTR_EL0	|
+		   HDFGRTR_EL2_PMEVTYPERn_EL0	|
+		   HDFGRTR_EL2_PMEVCNTRn_EL0,
+		   FEAT_PMUv3),
+	NEEDS_FEAT(HDFGRTR_EL2_TRBTRG_EL1	|
+		   HDFGRTR_EL2_TRBSR_EL1	|
+		   HDFGRTR_EL2_TRBPTR_EL1	|
+		   HDFGRTR_EL2_TRBMAR_EL1	|
+		   HDFGRTR_EL2_TRBLIMITR_EL1	|
+		   HDFGRTR_EL2_TRBIDR_EL1	|
+		   HDFGRTR_EL2_TRBBASER_EL1,
+		   FEAT_TRBE),
+	NEEDS_FEAT_FLAG(HDFGRTR_EL2_OSDLR_EL1, NEVER_FGU,
+			FEAT_DoubleLock),
+	NEEDS_FEAT_FLAG(HDFGRTR_EL2_OSECCR_EL1	|
+			HDFGRTR_EL2_OSLSR_EL1	|
+			HDFGRTR_EL2_DBGPRCR_EL1	|
+			HDFGRTR_EL2_DBGAUTHSTATUS_EL1|
+			HDFGRTR_EL2_DBGCLAIM	|
+			HDFGRTR_EL2_MDSCR_EL1	|
+			HDFGRTR_EL2_DBGWVRn_EL1	|
+			HDFGRTR_EL2_DBGWCRn_EL1	|
+			HDFGRTR_EL2_DBGBVRn_EL1	|
+			HDFGRTR_EL2_DBGBCRn_EL1,
+			NEVER_FGU, FEAT_AA64EL1)
+};
+
+static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
+	NEEDS_FEAT(HDFGWTR_EL2_PMSLATFR_EL1	|
+		   HDFGWTR_EL2_PMSIRR_EL1	|
+		   HDFGWTR_EL2_PMSICR_EL1	|
+		   HDFGWTR_EL2_PMSFCR_EL1	|
+		   HDFGWTR_EL2_PMSEVFR_EL1	|
+		   HDFGWTR_EL2_PMSCR_EL1	|
+		   HDFGWTR_EL2_PMBSR_EL1	|
+		   HDFGWTR_EL2_PMBPTR_EL1	|
+		   HDFGWTR_EL2_PMBLIMITR_EL1,
+		   FEAT_SPE),
+	NEEDS_FEAT(HDFGWTR_EL2_nPMSNEVFR_EL1, FEAT_SPE_FnE),
+	NEEDS_FEAT(HDFGWTR_EL2_nBRBDATA		|
+		   HDFGWTR_EL2_nBRBCTL,
+		   FEAT_BRBE),
+	NEEDS_FEAT(HDFGWTR_EL2_TRCVICTLR	|
+		   HDFGWTR_EL2_TRCSSCSRn	|
+		   HDFGWTR_EL2_TRCSEQSTR	|
+		   HDFGWTR_EL2_TRCPRGCTLR	|
+		   HDFGWTR_EL2_TRCOSLAR		|
+		   HDFGWTR_EL2_TRCIMSPECn	|
+		   HDFGWTR_EL2_TRCCNTVRn	|
+		   HDFGWTR_EL2_TRCCLAIM		|
+		   HDFGWTR_EL2_TRCAUXCTLR	|
+		   HDFGWTR_EL2_TRC,
+		   FEAT_TRC_SR),
+	NEEDS_FEAT(HDFGWTR_EL2_PMUSERENR_EL0	|
+		   HDFGWTR_EL2_PMCR_EL0		|
+		   HDFGWTR_EL2_PMSWINC_EL0	|
+		   HDFGWTR_EL2_PMSELR_EL0	|
+		   HDFGWTR_EL2_PMOVS		|
+		   HDFGWTR_EL2_PMINTEN		|
+		   HDFGWTR_EL2_PMCNTEN		|
+		   HDFGWTR_EL2_PMCCNTR_EL0	|
+		   HDFGWTR_EL2_PMCCFILTR_EL0	|
+		   HDFGWTR_EL2_PMEVTYPERn_EL0	|
+		   HDFGWTR_EL2_PMEVCNTRn_EL0,
+		   FEAT_PMUv3),
+	NEEDS_FEAT(HDFGWTR_EL2_TRBTRG_EL1	|
+		   HDFGWTR_EL2_TRBSR_EL1	|
+		   HDFGWTR_EL2_TRBPTR_EL1	|
+		   HDFGWTR_EL2_TRBMAR_EL1	|
+		   HDFGWTR_EL2_TRBLIMITR_EL1	|
+		   HDFGWTR_EL2_TRBBASER_EL1,
+		   FEAT_TRBE),
+	NEEDS_FEAT_FLAG(HDFGWTR_EL2_OSDLR_EL1,
+			NEVER_FGU, FEAT_DoubleLock),
+	NEEDS_FEAT_FLAG(HDFGWTR_EL2_OSECCR_EL1	|
+			HDFGWTR_EL2_OSLAR_EL1	|
+			HDFGWTR_EL2_DBGPRCR_EL1	|
+			HDFGWTR_EL2_DBGCLAIM	|
+			HDFGWTR_EL2_MDSCR_EL1	|
+			HDFGWTR_EL2_DBGWVRn_EL1	|
+			HDFGWTR_EL2_DBGWCRn_EL1	|
+			HDFGWTR_EL2_DBGBVRn_EL1	|
+			HDFGWTR_EL2_DBGBCRn_EL1,
+			NEVER_FGU, FEAT_AA64EL1),
+	NEEDS_FEAT(HDFGWTR_EL2_TRFCR_EL1, FEAT_TRF),
+};
+
+
+static const struct reg_bits_to_feat_map hfgitr_feat_map[] = {
+	NEEDS_FEAT(HFGITR_EL2_PSBCSYNC, FEAT_SPEv1p5),
+	NEEDS_FEAT(HFGITR_EL2_ATS1E1A, FEAT_ATS1A),
+	NEEDS_FEAT(HFGITR_EL2_COSPRCTX, FEAT_SPECRES2),
+	NEEDS_FEAT(HFGITR_EL2_nGCSEPP		|
+		   HFGITR_EL2_nGCSSTR_EL1	|
+		   HFGITR_EL2_nGCSPUSHM_EL1,
+		   FEAT_GCS),
+	NEEDS_FEAT(HFGITR_EL2_nBRBIALL		|
+		   HFGITR_EL2_nBRBINJ,
+		   FEAT_BRBE),
+	NEEDS_FEAT(HFGITR_EL2_CPPRCTX		|
+		   HFGITR_EL2_DVPRCTX		|
+		   HFGITR_EL2_CFPRCTX,
+		   FEAT_SPECRES),
+	NEEDS_FEAT(HFGITR_EL2_TLBIRVAALE1	|
+		   HFGITR_EL2_TLBIRVALE1	|
+		   HFGITR_EL2_TLBIRVAAE1	|
+		   HFGITR_EL2_TLBIRVAE1		|
+		   HFGITR_EL2_TLBIRVAALE1IS	|
+		   HFGITR_EL2_TLBIRVALE1IS	|
+		   HFGITR_EL2_TLBIRVAAE1IS	|
+		   HFGITR_EL2_TLBIRVAE1IS	|
+		   HFGITR_EL2_TLBIRVAALE1OS	|
+		   HFGITR_EL2_TLBIRVALE1OS	|
+		   HFGITR_EL2_TLBIRVAAE1OS	|
+		   HFGITR_EL2_TLBIRVAE1OS,
+		   FEAT_TLBIRANGE),
+	NEEDS_FEAT(HFGITR_EL2_TLBIVAALE1OS	|
+		   HFGITR_EL2_TLBIVALE1OS	|
+		   HFGITR_EL2_TLBIVAAE1OS	|
+		   HFGITR_EL2_TLBIASIDE1OS	|
+		   HFGITR_EL2_TLBIVAE1OS	|
+		   HFGITR_EL2_TLBIVMALLE1OS,
+		   FEAT_TLBIOS),
+	NEEDS_FEAT(HFGITR_EL2_ATS1E1WP		|
+		   HFGITR_EL2_ATS1E1RP,
+		   FEAT_PAN2),
+	NEEDS_FEAT(HFGITR_EL2_DCCVADP, FEAT_DPB2),
+	NEEDS_FEAT_FLAG(HFGITR_EL2_DCCVAC	|
+			HFGITR_EL2_SVC_EL1	|
+			HFGITR_EL2_SVC_EL0	|
+			HFGITR_EL2_ERET		|
+			HFGITR_EL2_TLBIVAALE1	|
+			HFGITR_EL2_TLBIVALE1	|
+			HFGITR_EL2_TLBIVAAE1	|
+			HFGITR_EL2_TLBIASIDE1	|
+			HFGITR_EL2_TLBIVAE1	|
+			HFGITR_EL2_TLBIVMALLE1	|
+			HFGITR_EL2_TLBIVAALE1IS	|
+			HFGITR_EL2_TLBIVALE1IS	|
+			HFGITR_EL2_TLBIVAAE1IS	|
+			HFGITR_EL2_TLBIASIDE1IS	|
+			HFGITR_EL2_TLBIVAE1IS	|
+			HFGITR_EL2_TLBIVMALLE1IS|
+			HFGITR_EL2_ATS1E0W	|
+			HFGITR_EL2_ATS1E0R	|
+			HFGITR_EL2_ATS1E1W	|
+			HFGITR_EL2_ATS1E1R	|
+			HFGITR_EL2_DCZVA	|
+			HFGITR_EL2_DCCIVAC	|
+			HFGITR_EL2_DCCVAP	|
+			HFGITR_EL2_DCCVAU	|
+			HFGITR_EL2_DCCISW	|
+			HFGITR_EL2_DCCSW	|
+			HFGITR_EL2_DCISW	|
+			HFGITR_EL2_DCIVAC	|
+			HFGITR_EL2_ICIVAU	|
+			HFGITR_EL2_ICIALLU	|
+			HFGITR_EL2_ICIALLUIS,
+			NEVER_FGU, FEAT_AA64EL1),
+};
+
+static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
+	NEEDS_FEAT(HAFGRTR_EL2_AMEVTYPER115_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER114_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER113_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER112_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER111_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER110_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER19_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER18_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER17_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER16_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER15_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER14_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER13_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER12_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER11_EL0	|
+		   HAFGRTR_EL2_AMEVTYPER10_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR115_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR114_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR113_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR112_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR111_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR110_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR19_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR18_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR17_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR16_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR15_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR14_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR13_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR12_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR11_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR10_EL0	|
+		   HAFGRTR_EL2_AMCNTEN1		|
+		   HAFGRTR_EL2_AMCNTEN0		|
+		   HAFGRTR_EL2_AMEVCNTR03_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR02_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR01_EL0	|
+		   HAFGRTR_EL2_AMEVCNTR00_EL0,
+		   FEAT_AMUv1),
+};
+
+static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
+{
+	u64 regval = kvm->arch.id_regs[map->regidx];
+	u64 regfld = (regval >> map->shift) & GENMASK(map->width - 1, 0);
+
+	if (map->sign) {
+		s64 sfld = sign_extend64(regfld, map->width - 1);
+		s64 slim = sign_extend64(map->lo_lim, map->width - 1);
+		return sfld >= slim;
+	} else {
+		return regfld >= map->lo_lim;
+	}
+}
+
+static u64 __compute_fixed_bits(struct kvm *kvm,
+				const struct reg_bits_to_feat_map *map,
+				int map_size,
+				u64 *fixed_bits,
+				unsigned long require,
+				unsigned long exclude)
+{
+	u64 val = 0;
+
+	for (int i = 0; i < map_size; i++) {
+		bool match;
+
+		if ((map[i].flags & require) != require)
+			continue;
+
+		if (map[i].flags & exclude)
+			continue;
+
+		if (map[i].flags & CALL_FUNC)
+			match = (map[i].flags & FIXED_VALUE) ?
+				map[i].fval(kvm, fixed_bits) :
+				map[i].match(kvm);
+		else
+			match = idreg_feat_match(kvm, &map[i]);
+
+		if (!match || (map[i].flags & FIXED_VALUE))
+			val |= map[i].bits;
+	}
+
+	return val;
+}
+
+static u64 compute_res0_bits(struct kvm *kvm,
+			     const struct reg_bits_to_feat_map *map,
+			     int map_size,
+			     unsigned long require,
+			     unsigned long exclude)
+{
+	return __compute_fixed_bits(kvm, map, map_size, NULL,
+				    require, exclude | FIXED_VALUE);
+}
+
+void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
+{
+	u64 val = 0;
+
+	switch (fgt) {
+	case HFGRTR_GROUP:
+		val |= compute_res0_bits(kvm, hfgrtr_feat_map,
+					 ARRAY_SIZE(hfgrtr_feat_map),
+					 0, NEVER_FGU);
+		val |= compute_res0_bits(kvm, hfgwtr_feat_map,
+					 ARRAY_SIZE(hfgwtr_feat_map),
+					 0, NEVER_FGU);
+		break;
+	case HFGITR_GROUP:
+		val |= compute_res0_bits(kvm, hfgitr_feat_map,
+					 ARRAY_SIZE(hfgitr_feat_map),
+					 0, NEVER_FGU);
+		break;
+	case HDFGRTR_GROUP:
+		val |= compute_res0_bits(kvm, hdfgrtr_feat_map,
+					 ARRAY_SIZE(hdfgrtr_feat_map),
+					 0, NEVER_FGU);
+		val |= compute_res0_bits(kvm, hdfgwtr_feat_map,
+					 ARRAY_SIZE(hdfgwtr_feat_map),
+					 0, NEVER_FGU);
+		break;
+	case HAFGRTR_GROUP:
+		val |= compute_res0_bits(kvm, hafgrtr_feat_map,
+					 ARRAY_SIZE(hafgrtr_feat_map),
+					 0, NEVER_FGU);
+		break;
+	default:
+		BUG();
+	}
+
+	kvm->arch.fgu[fgt] = val;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a9ecca4b2fa74..b3e53a899c1fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5147,75 +5147,10 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
 
-	kvm->arch.fgu[HFGRTR_GROUP] = (HFGRTR_EL2_nAMAIR2_EL1		|
-				       HFGRTR_EL2_nMAIR2_EL1		|
-				       HFGRTR_EL2_nS2POR_EL1		|
-				       HFGRTR_EL2_nSMPRI_EL1_MASK	|
-				       HFGRTR_EL2_nTPIDR2_EL0_MASK);
-
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
-		kvm->arch.fgu[HFGRTR_GROUP] |= HFGRTR_EL2_nACCDATA_EL1;
-
-	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
-		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
-						HFGITR_EL2_TLBIRVALE1OS	|
-						HFGITR_EL2_TLBIRVAAE1OS	|
-						HFGITR_EL2_TLBIRVAE1OS	|
-						HFGITR_EL2_TLBIVAALE1OS	|
-						HFGITR_EL2_TLBIVALE1OS	|
-						HFGITR_EL2_TLBIVAAE1OS	|
-						HFGITR_EL2_TLBIASIDE1OS	|
-						HFGITR_EL2_TLBIVAE1OS	|
-						HFGITR_EL2_TLBIVMALLE1OS);
-
-	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
-		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1	|
-						HFGITR_EL2_TLBIRVALE1	|
-						HFGITR_EL2_TLBIRVAAE1	|
-						HFGITR_EL2_TLBIRVAE1	|
-						HFGITR_EL2_TLBIRVAALE1IS|
-						HFGITR_EL2_TLBIRVALE1IS	|
-						HFGITR_EL2_TLBIRVAAE1IS	|
-						HFGITR_EL2_TLBIRVAE1IS	|
-						HFGITR_EL2_TLBIRVAALE1OS|
-						HFGITR_EL2_TLBIRVALE1OS	|
-						HFGITR_EL2_TLBIRVAAE1OS	|
-						HFGITR_EL2_TLBIRVAE1OS);
-
-	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, ATS1A, IMP))
-		kvm->arch.fgu[HFGITR_GROUP] |= HFGITR_EL2_ATS1E1A;
-
-	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
-		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
-						HFGITR_EL2_ATS1E1WP);
-
-	if (!kvm_has_s1pie(kvm))
-		kvm->arch.fgu[HFGRTR_GROUP] |= (HFGRTR_EL2_nPIRE0_EL1 |
-						HFGRTR_EL2_nPIR_EL1);
-
-	if (!kvm_has_s1poe(kvm))
-		kvm->arch.fgu[HFGRTR_GROUP] |= (HFGRTR_EL2_nPOR_EL1 |
-						HFGRTR_EL2_nPOR_EL0);
-
-	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
-		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
-						  HAFGRTR_EL2_RES1);
-
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP)) {
-		kvm->arch.fgu[HDFGRTR_GROUP] |= (HDFGRTR_EL2_nBRBDATA  |
-						 HDFGRTR_EL2_nBRBCTL   |
-						 HDFGRTR_EL2_nBRBIDR);
-		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_nBRBINJ |
-						HFGITR_EL2_nBRBIALL);
-	}
-
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP)) {
-		kvm->arch.fgu[HFGRTR_GROUP] |= (HFGRTR_EL2_nGCS_EL0 |
-						HFGRTR_EL2_nGCS_EL1);
-		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_nGCSPUSHM_EL1 |
-						HFGITR_EL2_nGCSSTR_EL1 |
-						HFGITR_EL2_nGCSEPP);
-	}
+	compute_fgu(kvm, HFGRTR_GROUP);
+	compute_fgu(kvm, HFGITR_GROUP);
+	compute_fgu(kvm, HDFGRTR_GROUP);
+	compute_fgu(kvm, HAFGRTR_GROUP);
 
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
-- 
2.39.2


