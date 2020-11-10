Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793762AD7AF
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 14:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbgKJNgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 08:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732036AbgKJNge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 08:36:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0873020797;
        Tue, 10 Nov 2020 13:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605015394;
        bh=oEJ26RwAVCuQCGt/s5ti5ysXVRlvv3yQD7m3Uv3qvgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ih2uiva/j21mG9p+sqVSaUKNG4MzdGBunyOsJpwqXV2WWSMopnjVySAggRyFastWD
         QHD4xmDCb80dxRj+K2TiCrZFBoAykMlHZrXGx3Vh7136YdG4XFohValRT5NgmlJBh6
         dZ4dHQq2mZZcA6GgRyG78lpZl9jmWTL5ecUFHTwU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcTp2-009SZy-6h; Tue, 10 Nov 2020 13:36:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 8/9] KVM: arm64: Drop legacy copro shadow register
Date:   Tue, 10 Nov 2020 13:36:18 +0000
Message-Id: <20201110133619.451157-9-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110133619.451157-1-maz@kernel.org>
References: <20201110133619.451157-1-maz@kernel.org>
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
 arch/arm64/include/asm/kvm_host.h | 48 +------------------------------
 1 file changed, 1 insertion(+), 47 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0d023e4f80a0..c527f9567713 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -201,49 +201,6 @@ enum vcpu_sysreg {
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
-#define c2_TTBCR2	(c2_TTBCR + 1)	/* Translation Table Base Control R. 2 */
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
 
@@ -254,10 +211,7 @@ struct kvm_cpu_context {
 
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

