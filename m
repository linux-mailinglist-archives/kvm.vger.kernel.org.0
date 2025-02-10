Return-Path: <kvm+bounces-37725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D237A2F793
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53F133A18EF
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC5F25E457;
	Mon, 10 Feb 2025 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMH02W6P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7F725A2A3;
	Mon, 10 Feb 2025 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212923; cv=none; b=newqetMYD7Hr1rCTtuTNp1ONcPjOXwYfMbeNWS3VZzvkNkmAODzzhXeyzp/cyOnA6Pye5HhUyn5STpZnwzS8mtuEygRrK9dVH287Kky/xLGbtmd+D/33PmtyWQiTqY2juy2jS5PkFuzEMsEwFzjEOY93gn43w33/CasekUabeZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212923; c=relaxed/simple;
	bh=z7iBEbHjuVZsXkMILKTE3VIgBtdRVfUQrmyYRKq8OeU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qE9hFJ4FqatNJTsBdWE00EzbCGagpOs/Q0NeBz+pJcjIW9lKuEJTi9sXtGDN/+YSzrsCJWFAti5EB3gFZpVnok1L0ndo3ibPIw29sgm/CiSERCNGyiu/HybcU7oP9G1LKyB37u6sNuPjx9JkhbTvi0madlzYHXygy/jwPftT04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMH02W6P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC15C4CEE4;
	Mon, 10 Feb 2025 18:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212923;
	bh=z7iBEbHjuVZsXkMILKTE3VIgBtdRVfUQrmyYRKq8OeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMH02W6PgTqygi6inCP4IVAWjz/OCPv2xQ9xIKaPZpL/f9FBRTvWDsh8OmL6Jl4cS
	 OFG6ZD6e1k9GKQkF917fpBAOU2zt5GqJ7Ka0Uax/0D9tSkaARTOA5GgNFnSTn2/zEb
	 vhHFmhwh3kZIS+2sOqIQkAFg1xMJuU4wiDIjJ0+jRYe2cJ7saKO6UHTY5GpIG4//YZ
	 I8gpArUji228Xn4y8ruubPB0pnqlJu1bp6TcVNOVwXDgiVwcJ1I9Z1GRAHc5UomdEw
	 tMIditfcOAJJeSESZmSp4esbUWAw5NZk24S/EhWNXliJrKlI3cwzsBhsqgaILc0Ni4
	 AYznwn0OB2ViQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjJ-002g2I-2n;
	Mon, 10 Feb 2025 18:42:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 16/18] KVM: arm64: Switch to table-driven FGU configuration
Date: Mon, 10 Feb 2025 18:41:47 +0000
Message-Id: <20250210184150.2145093-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
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
 arch/arm64/kvm/config.c           | 559 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  73 +---
 4 files changed, 566 insertions(+), 70 deletions(-)
 create mode 100644 arch/arm64/kvm/config.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7220382aeb9dc..f9975b5f8907a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1576,4 +1576,6 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3cf7adb2b5038..f05713e125077 100644
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
index 0000000000000..0a68555068f11
--- /dev/null
+++ b/arch/arm64/kvm/config.c
@@ -0,0 +1,559 @@
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
+static struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
+	NEEDS_FEAT(HFGxTR_EL2_nAMAIR2_EL1	|
+		   HFGxTR_EL2_nMAIR2_EL1,
+		   FEAT_AIE),
+	NEEDS_FEAT(HFGxTR_EL2_nS2POR_EL1, FEAT_S2POE),
+	NEEDS_FEAT(HFGxTR_EL2_nPOR_EL1		|
+		   HFGxTR_EL2_nPOR_EL0,
+		   FEAT_S1POE),
+	NEEDS_FEAT(HFGxTR_EL2_nPIR_EL1		|
+		   HFGxTR_EL2_nPIRE0_EL1,
+		   FEAT_S1PIE),
+	NEEDS_FEAT(HFGxTR_EL2_nRCWMASK_EL1, FEAT_THE),
+	NEEDS_FEAT(HFGxTR_EL2_nTPIDR2_EL0	|
+		   HFGxTR_EL2_nSMPRI_EL1,
+		   FEAT_SME),
+	NEEDS_FEAT(HFGxTR_EL2_nGCS_EL1		|
+		   HFGxTR_EL2_nGCS_EL0,
+		   FEAT_GCS),
+	NEEDS_FEAT(HFGxTR_EL2_nACCDATA_EL1, FEAT_LS64_ACCDATA),
+	NEEDS_FEAT(HFGxTR_EL2_ERXADDR_EL1	|
+		   HFGxTR_EL2_ERXMISCn_EL1	|
+		   HFGxTR_EL2_ERXSTATUS_EL1	|
+		   HFGxTR_EL2_ERXCTLR_EL1	|
+		   HFGxTR_EL2_ERXFR_EL1		|
+		   HFGxTR_EL2_ERRSELR_EL1	|
+		   HFGxTR_EL2_ERRIDR_EL1,
+		   FEAT_RAS),
+	NEEDS_FEAT(HFGxTR_EL2_ERXPFGCDN_EL1|
+		   HFGxTR_EL2_ERXPFGCTL_EL1|
+		   HFGxTR_EL2_ERXPFGF_EL1,
+		   feat_rasv1p1),
+	NEEDS_FEAT(HFGxTR_EL2_ICC_IGRPENn_EL1, FEAT_GICv3),
+	NEEDS_FEAT(HFGxTR_EL2_SCXTNUM_EL0	|
+		   HFGxTR_EL2_SCXTNUM_EL1,
+		   feat_csv2_2_csv2_1p2),
+	NEEDS_FEAT(HFGxTR_EL2_LORSA_EL1		|
+		   HFGxTR_EL2_LORN_EL1		|
+		   HFGxTR_EL2_LORID_EL1		|
+		   HFGxTR_EL2_LOREA_EL1		|
+		   HFGxTR_EL2_LORC_EL1,
+		   FEAT_LOR),
+	NEEDS_FEAT(HFGxTR_EL2_APIBKey		|
+		   HFGxTR_EL2_APIAKey		|
+		   HFGxTR_EL2_APGAKey		|
+		   HFGxTR_EL2_APDBKey		|
+		   HFGxTR_EL2_APDAKey,
+		   feat_pauth),
+	NEEDS_FEAT(HFGxTR_EL2_VBAR_EL1		|
+		   HFGxTR_EL2_TTBR1_EL1		|
+		   HFGxTR_EL2_TTBR0_EL1		|
+		   HFGxTR_EL2_TPIDR_EL0		|
+		   HFGxTR_EL2_TPIDRRO_EL0	|
+		   HFGxTR_EL2_TPIDR_EL1		|
+		   HFGxTR_EL2_TCR_EL1		|
+		   HFGxTR_EL2_SCTLR_EL1		|
+		   HFGxTR_EL2_REVIDR_EL1	|
+		   HFGxTR_EL2_PAR_EL1		|
+		   HFGxTR_EL2_MPIDR_EL1		|
+		   HFGxTR_EL2_MIDR_EL1		|
+		   HFGxTR_EL2_MAIR_EL1		|
+		   HFGxTR_EL2_ISR_EL1		|
+		   HFGxTR_EL2_FAR_EL1		|
+		   HFGxTR_EL2_ESR_EL1		|
+		   HFGxTR_EL2_DCZID_EL0		|
+		   HFGxTR_EL2_CTR_EL0		|
+		   HFGxTR_EL2_CSSELR_EL1	|
+		   HFGxTR_EL2_CPACR_EL1		|
+		   HFGxTR_EL2_CONTEXTIDR_EL1	|
+		   HFGxTR_EL2_CLIDR_EL1		|
+		   HFGxTR_EL2_CCSIDR_EL1	|
+		   HFGxTR_EL2_AMAIR_EL1		|
+		   HFGxTR_EL2_AIDR_EL1		|
+		   HFGxTR_EL2_AFSR1_EL1		|
+		   HFGxTR_EL2_AFSR0_EL1,
+		   FEAT_AA64EL1),
+};
+
+static struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
+	NEEDS_FEAT(HFGxTR_EL2_nAMAIR2_EL1	|
+		   HFGxTR_EL2_nMAIR2_EL1,
+		   FEAT_AIE),
+	NEEDS_FEAT(HFGxTR_EL2_nS2POR_EL1, FEAT_S2POE),
+	NEEDS_FEAT(HFGxTR_EL2_nPOR_EL1		|
+		   HFGxTR_EL2_nPOR_EL0,
+		   FEAT_S1POE),
+	NEEDS_FEAT(HFGxTR_EL2_nPIR_EL1		|
+		   HFGxTR_EL2_nPIRE0_EL1,
+		   FEAT_S1PIE),
+	NEEDS_FEAT(HFGxTR_EL2_nRCWMASK_EL1, FEAT_THE),
+	NEEDS_FEAT(HFGxTR_EL2_nTPIDR2_EL0	|
+		   HFGxTR_EL2_nSMPRI_EL1,
+		   FEAT_SME),
+	NEEDS_FEAT(HFGxTR_EL2_nGCS_EL1		|
+		   HFGxTR_EL2_nGCS_EL0,
+		   FEAT_GCS),
+	NEEDS_FEAT(HFGxTR_EL2_nACCDATA_EL1, FEAT_LS64_ACCDATA),
+	NEEDS_FEAT(HFGxTR_EL2_ERXADDR_EL1	|
+		   HFGxTR_EL2_ERXMISCn_EL1	|
+		   HFGxTR_EL2_ERXSTATUS_EL1	|
+		   HFGxTR_EL2_ERXCTLR_EL1	|
+		   HFGxTR_EL2_ERRSELR_EL1,
+		   FEAT_RAS),
+	NEEDS_FEAT(HFGxTR_EL2_ERXPFGCDN_EL1	|
+		   HFGxTR_EL2_ERXPFGCTL_EL1,
+		   feat_rasv1p1),
+	NEEDS_FEAT(HFGxTR_EL2_ICC_IGRPENn_EL1, FEAT_GICv3),
+	NEEDS_FEAT(HFGxTR_EL2_SCXTNUM_EL0	|
+		   HFGxTR_EL2_SCXTNUM_EL1,
+		   feat_csv2_2_csv2_1p2),
+	NEEDS_FEAT(HFGxTR_EL2_LORSA_EL1		|
+		   HFGxTR_EL2_LORN_EL1		|
+		   HFGxTR_EL2_LOREA_EL1		|
+		   HFGxTR_EL2_LORC_EL1,
+		   FEAT_LOR),
+	NEEDS_FEAT(HFGxTR_EL2_APIBKey		|
+		   HFGxTR_EL2_APIAKey		|
+		   HFGxTR_EL2_APGAKey		|
+		   HFGxTR_EL2_APDBKey		|
+		   HFGxTR_EL2_APDAKey,
+		   feat_pauth),
+	NEEDS_FEAT(HFGxTR_EL2_VBAR_EL1		|
+		   HFGxTR_EL2_TTBR1_EL1		|
+		   HFGxTR_EL2_TTBR0_EL1		|
+		   HFGxTR_EL2_TPIDR_EL0		|
+		   HFGxTR_EL2_TPIDRRO_EL0	|
+		   HFGxTR_EL2_TPIDR_EL1		|
+		   HFGxTR_EL2_TCR_EL1		|
+		   HFGxTR_EL2_SCTLR_EL1		|
+		   HFGxTR_EL2_PAR_EL1		|
+		   HFGxTR_EL2_MAIR_EL1		|
+		   HFGxTR_EL2_FAR_EL1		|
+		   HFGxTR_EL2_ESR_EL1		|
+		   HFGxTR_EL2_CSSELR_EL1	|
+		   HFGxTR_EL2_CPACR_EL1		|
+		   HFGxTR_EL2_CONTEXTIDR_EL1	|
+		   HFGxTR_EL2_AMAIR_EL1		|
+		   HFGxTR_EL2_AFSR1_EL1		|
+		   HFGxTR_EL2_AFSR0_EL1,
+		   FEAT_AA64EL1),
+};
+
+static struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
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
+	NEEDS_FEAT(HDFGRTR_EL2_OSECCR_EL1	|
+		   HDFGRTR_EL2_OSLSR_EL1	|
+		   HDFGRTR_EL2_DBGPRCR_EL1	|
+		   HDFGRTR_EL2_DBGAUTHSTATUS_EL1|
+		   HDFGRTR_EL2_DBGCLAIM		|
+		   HDFGRTR_EL2_MDSCR_EL1	|
+		   HDFGRTR_EL2_DBGWVRn_EL1	|
+		   HDFGRTR_EL2_DBGWCRn_EL1	|
+		   HDFGRTR_EL2_DBGBVRn_EL1	|
+		   HDFGRTR_EL2_DBGBCRn_EL1,
+		   FEAT_AA64EL1)
+};
+
+static struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
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
+	NEEDS_FEAT(HDFGWTR_EL2_OSECCR_EL1	|
+		   HDFGWTR_EL2_OSLAR_EL1	|
+		   HDFGWTR_EL2_DBGPRCR_EL1	|
+		   HDFGWTR_EL2_DBGCLAIM		|
+		   HDFGWTR_EL2_MDSCR_EL1	|
+		   HDFGWTR_EL2_DBGWVRn_EL1	|
+		   HDFGWTR_EL2_DBGWCRn_EL1	|
+		   HDFGWTR_EL2_DBGBVRn_EL1	|
+		   HDFGWTR_EL2_DBGBCRn_EL1,
+		   FEAT_AA64EL1),
+	NEEDS_FEAT(HDFGWTR_EL2_TRFCR_EL1, FEAT_TRF),
+};
+
+
+static struct reg_bits_to_feat_map hfgitr_feat_map[] = {
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
+	NEEDS_FEAT(HFGITR_EL2_DCCVAC		|
+		   HFGITR_EL2_SVC_EL1		|
+		   HFGITR_EL2_SVC_EL0		|
+		   HFGITR_EL2_ERET		|
+		   HFGITR_EL2_TLBIVAALE1	|
+		   HFGITR_EL2_TLBIVALE1		|
+		   HFGITR_EL2_TLBIVAAE1		|
+		   HFGITR_EL2_TLBIASIDE1	|
+		   HFGITR_EL2_TLBIVAE1		|
+		   HFGITR_EL2_TLBIVMALLE1	|
+		   HFGITR_EL2_TLBIVAALE1IS	|
+		   HFGITR_EL2_TLBIVALE1IS	|
+		   HFGITR_EL2_TLBIVAAE1IS	|
+		   HFGITR_EL2_TLBIASIDE1IS	|
+		   HFGITR_EL2_TLBIVAE1IS	|
+		   HFGITR_EL2_TLBIVMALLE1IS	|
+		   HFGITR_EL2_ATS1E0W		|
+		   HFGITR_EL2_ATS1E0R		|
+		   HFGITR_EL2_ATS1E1W		|
+		   HFGITR_EL2_ATS1E1R		|
+		   HFGITR_EL2_DCZVA		|
+		   HFGITR_EL2_DCCIVAC		|
+		   HFGITR_EL2_DCCVAP		|
+		   HFGITR_EL2_DCCVAU		|
+		   HFGITR_EL2_DCCISW		|
+		   HFGITR_EL2_DCCSW		|
+		   HFGITR_EL2_DCISW		|
+		   HFGITR_EL2_DCIVAC		|
+		   HFGITR_EL2_ICIVAU		|
+		   HFGITR_EL2_ICIALLU		|
+		   HFGITR_EL2_ICIALLUIS,
+		   FEAT_AA64EL1),
+};
+
+static struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
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
+static bool idreg_feat_match(struct kvm *kvm, struct reg_bits_to_feat_map *map)
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
+static u64 __compute_unsupported_bits(struct kvm *kvm,
+				      struct reg_bits_to_feat_map *map,
+				      int map_size, unsigned long filter_out)
+{
+	u64 val = 0;
+
+	for (int i = 0; i < map_size; i++) {
+		bool match;
+
+		if (map[i].flags & filter_out)
+			continue;
+
+		if (map[i].flags & CALL_FUNC)
+			match = map[i].match(kvm);
+		else
+			match = idreg_feat_match(kvm, &map[i]);
+
+		if (!match)
+			val |= map[i].bits;
+	}
+
+	return val;
+}
+
+void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
+{
+	u64 val = 0;
+
+	switch (fgt) {
+	case HFGxTR_GROUP:
+		val |= __compute_unsupported_bits(kvm, hfgrtr_feat_map,
+						  ARRAY_SIZE(hfgrtr_feat_map),
+						  NEVER_FGU);
+		val |= __compute_unsupported_bits(kvm, hfgwtr_feat_map,
+						  ARRAY_SIZE(hfgwtr_feat_map),
+						  NEVER_FGU);
+		break;
+	case HFGITR_GROUP:
+		val |= __compute_unsupported_bits(kvm, hfgitr_feat_map,
+						  ARRAY_SIZE(hfgitr_feat_map),
+						  NEVER_FGU);
+		break;
+	case HDFGRTR_GROUP:
+		val |= __compute_unsupported_bits(kvm, hdfgrtr_feat_map,
+						  ARRAY_SIZE(hdfgrtr_feat_map),
+						  NEVER_FGU);
+		val |= __compute_unsupported_bits(kvm, hdfgwtr_feat_map,
+						  ARRAY_SIZE(hdfgwtr_feat_map),
+						  NEVER_FGU);
+		break;
+	case HAFGRTR_GROUP:
+		val |= __compute_unsupported_bits(kvm, hafgrtr_feat_map,
+						  ARRAY_SIZE(hafgrtr_feat_map),
+						  NEVER_FGU);
+		break;
+	default:
+		BUG();
+	}
+
+	kvm->arch.fgu[fgt] = val;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ecd0d51a2dae..d3990ceaa59c2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4994,75 +4994,10 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
 
-	kvm->arch.fgu[HFGxTR_GROUP] = (HFGxTR_EL2_nAMAIR2_EL1		|
-				       HFGxTR_EL2_nMAIR2_EL1		|
-				       HFGxTR_EL2_nS2POR_EL1		|
-				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
-				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
-
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
-		kvm->arch.fgu[HFGxTR_GROUP] |= HFGxTR_EL2_nACCDATA_EL1;
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
-		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
-						HFGxTR_EL2_nPIR_EL1);
-
-	if (!kvm_has_s1poe(kvm))
-		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPOR_EL1 |
-						HFGxTR_EL2_nPOR_EL0);
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
-		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nGCS_EL0 |
-						HFGxTR_EL2_nGCS_EL1);
-		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_nGCSPUSHM_EL1 |
-						HFGITR_EL2_nGCSSTR_EL1 |
-						HFGITR_EL2_nGCSEPP);
-	}
+	compute_fgu(kvm, HFGxTR_GROUP);
+	compute_fgu(kvm, HFGITR_GROUP);
+	compute_fgu(kvm, HDFGRTR_GROUP);
+	compute_fgu(kvm, HAFGRTR_GROUP);
 
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
-- 
2.39.2


