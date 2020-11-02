Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3882A33D7
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgKBTQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgKBTQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 14:16:18 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1E3223BD;
        Mon,  2 Nov 2020 19:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604344578;
        bh=AtpHV5wJJBOkeD5f6w+jY11UMjEHrUBXFJL1igD+zkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pvE1sKeW1L+qzNsQK/0YHwWk7u1rbm8sZJk/1krRYY3zdvKnfxWVA/QMkQhdxB4h
         0+BsdUHyad2Fb/wYGDnRPVDXBmWftY0olFVos4pYFF8Ltajkk9yoGCUi69xuEQMror
         /N649VM3KaLy3tw7GEhwmcY+ETc2XARkooFuuNew=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZfJQ-006nxn-5p; Mon, 02 Nov 2020 19:16:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 7/8] KVM: arm64: Drop legacy copro shadow register
Date:   Mon,  2 Nov 2020 19:16:08 +0000
Message-Id: <20201102191609.265711-8-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Finally remove one of the biggest 32bit legacy: the copro shadow
mapping. We won't missit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 47 +------------------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2772a1421335..c527f9567713 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -201,48 +201,6 @@ enum vcpu_sysreg {
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
-/* 32bit mapping */
-#define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
-#define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
-#define c1_SCTLR	(SCTLR_EL1 * 2)	/* System Control Register */
-#define c1_ACTLR	(ACTLR_EL1 * 2)	/* Auxiliary Control Register */
-#define c1_CPACR	(CPACR_EL1 * 2)	/* Coprocessor Access Control */
-#define c2_TTBR0	(TTBR0_EL1 * 2)	/* Translation Table Base Register 0 */
-#define c2_TTBR0_high	(c2_TTBR0 + 1)	/* TTBR0 top 32 bits */
-#define c2_TTBR1	(TTBR1_EL1 * 2)	/* Translation Table Base Register 1 */
-#define c2_TTBR1_high	(c2_TTBR1 + 1)	/* TTBR1 top 32 bits */
-#define c2_TTBCR	(TCR_EL1 * 2)	/* Translation Table Base Control R. */
-#define c3_DACR		(DACR32_EL2 * 2)/* Domain Access Control Register */
-#define c5_DFSR		(ESR_EL1 * 2)	/* Data Fault Status Register */
-#define c5_IFSR		(IFSR32_EL2 * 2)/* Instruction Fault Status Register */
-#define c5_ADFSR	(AFSR0_EL1 * 2)	/* Auxiliary Data Fault Status R */
-#define c5_AIFSR	(AFSR1_EL1 * 2)	/* Auxiliary Instr Fault Status R */
-#define c6_DFAR		(FAR_EL1 * 2)	/* Data Fault Address Register */
-#define c6_IFAR		(c6_DFAR + 1)	/* Instruction Fault Address Register */
-#define c7_PAR		(PAR_EL1 * 2)	/* Physical Address Register */
-#define c7_PAR_high	(c7_PAR + 1)	/* PAR top 32 bits */
-#define c10_PRRR	(MAIR_EL1 * 2)	/* Primary Region Remap Register */
-#define c10_NMRR	(c10_PRRR + 1)	/* Normal Memory Remap Register */
-#define c12_VBAR	(VBAR_EL1 * 2)	/* Vector Base Address Register */
-#define c13_CID		(CONTEXTIDR_EL1 * 2)	/* Context ID Register */
-#define c13_TID_URW	(TPIDR_EL0 * 2)	/* Thread ID, User R/W */
-#define c13_TID_URO	(TPIDRRO_EL0 * 2)/* Thread ID, User R/O */
-#define c13_TID_PRIV	(TPIDR_EL1 * 2)	/* Thread ID, Privileged */
-#define c10_AMAIR0	(AMAIR_EL1 * 2)	/* Aux Memory Attr Indirection Reg */
-#define c10_AMAIR1	(c10_AMAIR0 + 1)/* Aux Memory Attr Indirection Reg */
-#define c14_CNTKCTL	(CNTKCTL_EL1 * 2) /* Timer Control Register (PL1) */
-
-#define cp14_DBGDSCRext	(MDSCR_EL1 * 2)
-#define cp14_DBGBCR0	(DBGBCR0_EL1 * 2)
-#define cp14_DBGBVR0	(DBGBVR0_EL1 * 2)
-#define cp14_DBGBXVR0	(cp14_DBGBVR0 + 1)
-#define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
-#define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
-#define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
-#define cp14_DBGVCR	(DBGVCR32_EL2 * 2)
-
-#define NR_COPRO_REGS	(NR_SYS_REGS * 2)
-
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
@@ -253,10 +211,7 @@ struct kvm_cpu_context {
 
 	struct user_fpsimd_state fp_regs;
 
-	union {
-		u64 sys_regs[NR_SYS_REGS];
-		u32 copro[NR_COPRO_REGS];
-	};
+	u64 sys_regs[NR_SYS_REGS];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
-- 
2.28.0

