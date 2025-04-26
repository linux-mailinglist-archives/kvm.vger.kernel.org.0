Return-Path: <kvm+bounces-44424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B5BA9DA9C
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 736F44A5C6C
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9368251796;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apjGdmNr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018BC235347;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670534; cv=none; b=Cob2tZfTdKiiE0xv3Q6VNzWa4a98O0UAOIhL+jwDvPMVpVbENxN0IeaLHHRd01Z9nF3D8Rpuv8U7Ndu2gwujdnXGUBwK80KiS7D7B322y59398rtFX/npCi8ktSuLhiHCyOvQaDZG5DwGUWc4pKPQwg5rk7hq3YpSSYuMi5OTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670534; c=relaxed/simple;
	bh=Wx52G5fJ77nIURvNqC1cFOpUV+HYXyuUHEQTcLPJWco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ri4xdoMo96C9v104ur78qSaBnRcSi4mKTT5M586skVQFdNbaCmjARJuXs0mRcMHWtCWSabKu/gbzxK/JazxFEUWdv0ymXiVOLVK9WcJ8ZwmfPWPb+PYFI2Y+jafYZH/9qu616cdtXoaCe92TmabR29WcqCf8Z/0Aj5l4ndWVl+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apjGdmNr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A2EC4AF0B;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670533;
	bh=Wx52G5fJ77nIURvNqC1cFOpUV+HYXyuUHEQTcLPJWco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apjGdmNrbUgVWk9kbLVmzSP3JinxKWYFX9/jtQt3UVmm6Si4Lmj3vLV4RWHBr2W+2
	 +3Xz47pEje9bqu5Zw63oOwCFZP6yz3wTCfAPYQdEbUXD6I2zIReRMIVZWfJUG7knf9
	 cBkwXfgx8P9xbj8J7LCByY/oaqt14kKT7qyuQLkxBdQml77Dts/GX6zB2v3LMo6PfP
	 OkB70AGmacJT50kHRjh1TjYu3zWjOzmMbj7CvarGLGqqhf6mM4j9Z9UZIvNq6aX5Yk
	 bu/XocAr/axdfu24vr1KP62KXR0NQ5JEWw8jHHwM7wSLvUHryyeSVO2xQOiuys/kwu
	 wWzaHU5uh1urQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeJ-0092VH-MZ;
	Sat, 26 Apr 2025 13:28:51 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 12/42] arm64: tools: Resync sysreg.h
Date: Sat, 26 Apr 2025 13:28:06 +0100
Message-Id: <20250426122836.3341523-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Perform a bulk resync of tools/arch/arm64/include/asm/sysreg.h.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/arch/arm64/include/asm/sysreg.h | 65 ++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 17 deletions(-)

diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index b6c5ece4fdee7..690b6ebd118f4 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -117,6 +117,7 @@
 
 #define SB_BARRIER_INSN			__SYS_BARRIER_INSN(0, 7, 31)
 
+/* Data cache zero operations */
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
 #define SYS_DC_IGSW			sys_insn(1, 0, 7, 6, 4)
 #define SYS_DC_IGDSW			sys_insn(1, 0, 7, 6, 6)
@@ -153,11 +154,13 @@
 #define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
 #define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
 
-/* Data cache zero operations */
 #define SYS_DC_ZVA			sys_insn(1, 3, 7, 4, 1)
 #define SYS_DC_GVA			sys_insn(1, 3, 7, 4, 3)
 #define SYS_DC_GZVA			sys_insn(1, 3, 7, 4, 4)
 
+#define SYS_DC_CIVAPS			sys_insn(1, 0, 7, 15, 1)
+#define SYS_DC_CIGDVAPS			sys_insn(1, 0, 7, 15, 5)
+
 /*
  * Automatically generated definitions for system registers, the
  * manual encodings below are in the process of being converted to
@@ -475,6 +478,7 @@
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
 #define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
+#define SYS_CNTVCT_EL0			sys_reg(3, 3, 14, 0, 2)
 #define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
 #define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
 
@@ -482,23 +486,36 @@
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
 #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
 
+#define SYS_CNTV_TVAL_EL0		sys_reg(3, 3, 14, 3, 0)
 #define SYS_CNTV_CTL_EL0		sys_reg(3, 3, 14, 3, 1)
 #define SYS_CNTV_CVAL_EL0		sys_reg(3, 3, 14, 3, 2)
 
 #define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
 #define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
 #define SYS_AARCH32_CNTPCT		sys_reg(0, 0, 0, 14, 0)
+#define SYS_AARCH32_CNTVCT		sys_reg(0, 1, 0, 14, 0)
 #define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
 #define SYS_AARCH32_CNTPCTSS		sys_reg(0, 8, 0, 14, 0)
+#define SYS_AARCH32_CNTVCTSS		sys_reg(0, 9, 0, 14, 0)
 
 #define __PMEV_op2(n)			((n) & 0x7)
 #define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
+#define SYS_PMEVCNTSVRn_EL1(n)		sys_reg(2, 0, 14, __CNTR_CRm(n), __PMEV_op2(n))
 #define SYS_PMEVCNTRn_EL0(n)		sys_reg(3, 3, 14, __CNTR_CRm(n), __PMEV_op2(n))
 #define __TYPER_CRm(n)			(0xc | (((n) >> 3) & 0x3))
 #define SYS_PMEVTYPERn_EL0(n)		sys_reg(3, 3, 14, __TYPER_CRm(n), __PMEV_op2(n))
 
 #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
 
+#define	SYS_SPMCGCRn_EL1(n)		sys_reg(2, 0, 9, 13, ((n) & 1))
+
+#define __SPMEV_op2(n)			((n) & 0x7)
+#define __SPMEV_crm(p, n)		((((p) & 7) << 1) | (((n) >> 3) & 1))
+#define SYS_SPMEVCNTRn_EL0(n)		sys_reg(2, 3, 14, __SPMEV_crm(0b000, n), __SPMEV_op2(n))
+#define	SYS_SPMEVFILT2Rn_EL0(n)		sys_reg(2, 3, 14, __SPMEV_crm(0b011, n), __SPMEV_op2(n))
+#define	SYS_SPMEVFILTRn_EL0(n)		sys_reg(2, 3, 14, __SPMEV_crm(0b010, n), __SPMEV_op2(n))
+#define	SYS_SPMEVTYPERn_EL0(n)		sys_reg(2, 3, 14, __SPMEV_crm(0b001, n), __SPMEV_op2(n))
+
 #define SYS_VPIDR_EL2			sys_reg(3, 4, 0, 0, 0)
 #define SYS_VMPIDR_EL2			sys_reg(3, 4, 0, 0, 5)
 
@@ -518,7 +535,6 @@
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
 #define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
-#define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
 #define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
@@ -604,28 +620,18 @@
 
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
-#define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
-#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
-#define SYS_SCTLR2_EL12			sys_reg(3, 5, 1, 0, 3)
-#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
-#define SYS_TRFCR_EL12			sys_reg(3, 5, 1, 2, 1)
-#define SYS_SMCR_EL12			sys_reg(3, 5, 1, 2, 6)
 #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
 #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
-#define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
-#define SYS_TCR2_EL12			sys_reg(3, 5, 2, 0, 3)
 #define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
 #define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
 #define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
 #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
 #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
 #define SYS_TFSR_EL12			sys_reg(3, 5, 5, 6, 0)
-#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
 #define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)
 #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
 #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
 #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
-#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
 #define SYS_SCXTNUM_EL12		sys_reg(3, 5, 13, 0, 7)
 #define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
 #define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
@@ -1028,8 +1034,11 @@
 #define PIE_RX		UL(0xa)
 #define PIE_RW		UL(0xc)
 #define PIE_RWX		UL(0xe)
+#define PIE_MASK	UL(0xf)
 
-#define PIRx_ELx_PERM(idx, perm)	((perm) << ((idx) * 4))
+#define PIRx_ELx_BITS_PER_IDX		4
+#define PIRx_ELx_PERM_SHIFT(idx)	((idx) * PIRx_ELx_BITS_PER_IDX)
+#define PIRx_ELx_PERM_PREP(idx, perm)	(((perm) & PIE_MASK) << PIRx_ELx_PERM_SHIFT(idx))
 
 /*
  * Permission Overlay Extension (POE) permission encodings.
@@ -1040,12 +1049,34 @@
 #define POE_RX		UL(0x3)
 #define POE_W		UL(0x4)
 #define POE_RW		UL(0x5)
-#define POE_XW		UL(0x6)
-#define POE_RXW		UL(0x7)
+#define POE_WX		UL(0x6)
+#define POE_RWX		UL(0x7)
 #define POE_MASK	UL(0xf)
 
-/* Initial value for Permission Overlay Extension for EL0 */
-#define POR_EL0_INIT	POE_RXW
+#define POR_ELx_BITS_PER_IDX		4
+#define POR_ELx_PERM_SHIFT(idx)		((idx) * POR_ELx_BITS_PER_IDX)
+#define POR_ELx_PERM_GET(idx, reg)	(((reg) >> POR_ELx_PERM_SHIFT(idx)) & POE_MASK)
+#define POR_ELx_PERM_PREP(idx, perm)	(((perm) & POE_MASK) << POR_ELx_PERM_SHIFT(idx))
+
+/*
+ * Definitions for Guarded Control Stack
+ */
+
+#define GCS_CAP_ADDR_MASK		GENMASK(63, 12)
+#define GCS_CAP_ADDR_SHIFT		12
+#define GCS_CAP_ADDR_WIDTH		52
+#define GCS_CAP_ADDR(x)			FIELD_GET(GCS_CAP_ADDR_MASK, x)
+
+#define GCS_CAP_TOKEN_MASK		GENMASK(11, 0)
+#define GCS_CAP_TOKEN_SHIFT		0
+#define GCS_CAP_TOKEN_WIDTH		12
+#define GCS_CAP_TOKEN(x)		FIELD_GET(GCS_CAP_TOKEN_MASK, x)
+
+#define GCS_CAP_VALID_TOKEN		0x1
+#define GCS_CAP_IN_PROGRESS_TOKEN	0x5
+
+#define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
+					       GCS_CAP_VALID_TOKEN)
 
 #define ARM64_FEATURE_FIELD_BITS	4
 
-- 
2.39.2


