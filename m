Return-Path: <kvm+bounces-44421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34084A9DA95
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95F4A7B1415
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A8FE24FBE7;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQdzaRKO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BB324167E;
	Sat, 26 Apr 2025 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670533; cv=none; b=pG6NQ6SSmijs2Tcgp+YuXGftOYhO++nviNfafaTAlqNdDrTJyr4t7jBEfjQPOPeO6uJu2QipRDlbjDVMOKrdYPdZEb6HHc4NbAMfA6Wmmgwo//fr5eb04XNipeiNiLNnQRaqnYPPRezxsEEu0hBlNw1MqYs/ZaMLJ2QmQ3gY32U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670533; c=relaxed/simple;
	bh=IxAZVscD1I/Y7pQJtIr/f64gFGeCfV1USLz8dUrBxzU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UYa1btQWnl4MYl4NADxlShCjvpLQzrduCzn29E6tDt0Pa7R7PB8wSyY1/loXwlhQxB0jVYBv6xKqMwIfQ+ysFpuhOdjK8lQS4xJqitY9kIedWY/i0+m8w2XziR2hW4N3WlU47miQnIP1Bh9qA+axnN5qO4luhf7G5Rm8WKtNfCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQdzaRKO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995EDC4CEED;
	Sat, 26 Apr 2025 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670532;
	bh=IxAZVscD1I/Y7pQJtIr/f64gFGeCfV1USLz8dUrBxzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQdzaRKO44FDml88LkBqCKoMDb2rx+YasYqJaNBLD0QGH3l60jVdbTCVeM8yR5HH0
	 sM6p/l+ovGN/BIoHWMccj3q5k57C8Xu/TyieVfQLr8Il1T5LJr7OpvaFi7DA2A0l74
	 qykbmMg9QpmnFURtSWjAtqLJbpZZ4dTuUu/CJmiGaxmP2PIeTL88yleiZ1B6mbO6kk
	 sL6b3K/7kcanLfmN3+tu5Kyjux9mBtO+TuEUHAPsEyO0/JpB5kwgHPC3IgxoyjuJb9
	 sBW7Mt65hE9GOfHbMcgwnApBGgBFYCldO5fmjX/hgt4Z2SVYCqopJgDCB/Xj19ADPY
	 xs6LnvmECHPMQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeI-0092VH-NV;
	Sat, 26 Apr 2025 13:28:50 +0100
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
Subject: [PATCH v3 09/42] arm64: sysreg: Add registers trapped by HDFG{R,W}TR2_EL2
Date: Sat, 26 Apr 2025 13:28:03 +0100
Message-Id: <20250426122836.3341523-10-maz@kernel.org>
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

Bulk addition of all the system registers trapped by HDFG{R,W}TR2_EL2.

The descriptions are extracted from the BSD-licenced JSON file part
of the 2025-03 drop from ARM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  10 +
 arch/arm64/tools/sysreg         | 343 ++++++++++++++++++++++++++++++++
 2 files changed, 353 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073d..a943eac446938 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -497,12 +497,22 @@
 
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
 
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7969e632492bb..5695b12b8b4b2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -101,6 +101,17 @@ Res0	63:32
 Field	31:0	DTRTX
 EndSysreg
 
+Sysreg	MDSELR_EL1	2	0	0	4	2
+Res0	63:6
+Field	5:4	BANK
+Res0	3:0
+EndSysreg
+
+Sysreg	MDSTEPOP_EL1	2	0	0	5	2
+Res0	63:32
+Field	31:0	OPCODE
+EndSysreg
+
 Sysreg	OSECCR_EL1	2	0	0	6	2
 Res0	63:32
 Field	31:0	EDECCR
@@ -111,6 +122,285 @@ Res0	63:1
 Field	0	OSLK
 EndSysreg
 
+Sysreg	SPMACCESSR_EL1	2	0	9	13	3
+UnsignedEnum	63:62	P31
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	61:60	P30
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	59:58	P29
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	57:56	P28
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	55:54	P27
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	53:52	P26
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	51:50	P25
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	49:48	P24
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	47:46	P23
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	45:44	P22
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	43:42	P21
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	41:40	P20
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	39:38	P19
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	37:36	P18
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	35:34	P17
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	33:32	P16
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	31:30	P15
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	29:28	P14
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	27:26	P13
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	25:24	P12
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	23:22	P11
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	21:20	P10
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	19:18	P9
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	17:16	P8
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	15:14	P7
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	13:12	P6
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	11:10	P5
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	9:8	P4
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	7:6	P3
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	5:4	P2
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	3:2	P1
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+UnsignedEnum	1:0	P0
+	0b00	TRAP_RW
+	0b01	TRAP_W
+	0b11	NOTRAP
+EndEnum
+EndSysreg
+
+Sysreg	SPMACCESSR_EL12	2	5	9	13	3
+Mapping	SPMACCESSR_EL1
+EndSysreg
+
+Sysreg	SPMIIDR_EL1	2	0	9	13	4
+Res0	63:32
+Field	31:20	ProductID
+Field	19:16	Variant
+Field	15:12	Revision
+Field	11:0	Implementer
+EndSysreg
+
+Sysreg	SPMDEVARCH_EL1	2	0	9	13	5
+Res0	63:32
+Field	31:21	ARCHITECT
+Field	20	PRESENT
+Field	19:16	REVISION
+Field	15:12	ARCHVER
+Field	11:0	ARCHPART
+EndSysreg
+
+Sysreg	SPMDEVAFF_EL1	2	0	9	13	6
+Res0	63:40
+Field	39:32	Aff3
+Field	31	F0V
+Field	30	U
+Res0	29:25
+Field	24	MT
+Field	23:16	Aff2
+Field	15:8	Aff1
+Field	7:0	Aff0
+EndSysreg
+
+Sysreg	SPMCFGR_EL1	2	0	9	13	7
+Res0	63:32
+Field	31:28	NCG
+Res0	27:25
+Field	24	HDBG
+Field	23	TRO
+Field	22	SS
+Field	21	FZO
+Field	20	MSI
+Field	19	RAO
+Res0	18	
+Field	17	NA
+Field	16	EX
+Field	15:14	RAZ
+Field	13:8	SIZE
+Field	7:0	N
+EndSysreg
+
+Sysreg	SPMINTENSET_EL1	2	0	9	14	1
+Field	63:0	P
+EndSysreg
+
+Sysreg	SPMINTENCLR_EL1	2	0	9	14	2
+Field	63:0	P
+EndSysreg
+
+Sysreg	PMCCNTSVR_EL1	2	0	14	11	7
+Field	63:0	CCNT
+EndSysreg
+
+Sysreg	PMICNTSVR_EL1	2	0	14	12	0
+Field	63:0	ICNT
+EndSysreg
+
+Sysreg	SPMCR_EL0	2	3	9	12	0
+Res0	63:12
+Field	11	TRO
+Field	10	HDBG
+Field	9	FZO
+Field	8	NA
+Res0	7:5	
+Field	4	EX
+Res0	3:2	
+Field	1	P
+Field	0	E
+EndSysreg
+
+Sysreg	SPMCNTENSET_EL0	2	3	9	12	1
+Field	63:0	P
+EndSysreg
+
+Sysreg	SPMCNTENCLR_EL0	2	3	9	12	2
+Field	63:0	P
+EndSysreg
+
+Sysreg	SPMOVSCLR_EL0	2	3	9	12	3
+Field	63:0	P
+EndSysreg
+
+Sysreg	SPMZR_EL0       2	3	9	12	4
+Field   63:0      P
+EndSysreg
+
+Sysreg	SPMSELR_EL0	2	3	9	12	5
+Res0	63:10
+Field	9:4	SYSPMUSEL
+Res0	3:2	
+Field	1:0	BANK
+EndSysreg
+
+Sysreg	SPMOVSSET_EL0	2	3	9	14	3
+Field	63:0	P
+EndSysreg
+
+Sysreg	SPMSCR_EL1	2	7	9	14	7
+Field	63:32	IMPDEF
+Field	31	RAO
+Res0	30:5	
+Field	4	NAO
+Res0	3:1	
+Field	0	SO
+EndSysreg
+
 Sysreg ID_PFR0_EL1	3	0	0	1	0
 Res0	63:32
 UnsignedEnum	31:28	RAS
@@ -2430,6 +2720,16 @@ Field	1	ExTRE
 Field	0	E0TRE
 EndSysreg
 
+Sysreg	TRCITECR_EL1	3	0	1	2	3
+Res0	63:2
+Field	1	E1E
+Field	0	E0E
+EndSysreg
+
+Sysreg	TRCITECR_EL12	3	5	1	2	3
+Mapping	TRCITECR_EL1
+EndSysreg
+
 Sysreg	SMPRI_EL1	3	0	1	2	4
 Res0	63:4
 Field	3:0	PRIORITY
@@ -2663,6 +2963,16 @@ Field	16	COLL
 Field	15:0	MSS
 EndSysreg
 
+Sysreg	PMSDSFR_EL1	3	0	9	10	4
+Field	63:0	S
+EndSysreg
+
+Sysreg	PMBMAR_EL1	3	0	9	10	5
+Res0	63:10
+Field	9:8	SH
+Field	7:0	Attr
+EndSysreg
+
 Sysreg	PMBIDR_EL1	3	0	9	10	7
 Res0	63:12
 Enum	11:8	EA
@@ -2676,6 +2986,21 @@ Field	4	P
 Field	3:0	ALIGN
 EndSysreg
 
+Sysreg	TRBMPAM_EL1	3	0	9	11	5
+Res0	63:27
+Field	26	EN
+Field	25:24	MPAM_SP
+Field	23:16	PMG
+Field	15:0	PARTID
+EndSysreg
+
+Sysreg	PMSSCR_EL1	3	0	9	13	3
+Res0	63:33
+Field	32	NC
+Res0	31:1	
+Field	0	SS
+EndSysreg
+
 Sysreg	PMUACR_EL1	3	0	9	14	4
 Res0	63:33
 Field	32	F0
@@ -2683,11 +3008,29 @@ Field	31	C
 Field	30:0	P
 EndSysreg
 
+Sysreg	PMECR_EL1	3	0	9	14	5
+Res0	63:5
+Field	4:3	SSE
+Field	2	KPME
+Field	1:0	PMEE
+EndSysreg
+
+Sysreg	PMIAR_EL1	3	0	9	14	7
+Field	63:0	ADDRESS
+EndSysreg
+
 Sysreg	PMSELR_EL0	3	3	9	12	5
 Res0	63:5
 Field	4:0	SEL
 EndSysreg
 
+Sysreg	PMZR_EL0        3	3	9	13	4
+Res0	63:33
+Field	32	F0
+Field	31	C
+Field	30:0	P
+EndSysreg
+
 SysregFields	CONTEXTIDR_ELx
 Res0	63:32
 Field	31:0	PROCID
-- 
2.39.2


