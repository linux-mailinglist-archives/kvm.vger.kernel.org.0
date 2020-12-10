Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A022D60CD
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392118AbgLJQBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403858AbgLJQBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:01:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F28A23E1B;
        Thu, 10 Dec 2020 16:00:34 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knOMq-0008Di-OD; Thu, 10 Dec 2020 16:00:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 05/66] KVM: arm64: nv: Add EL2 system registers to vcpu context
Date:   Thu, 10 Dec 2020 15:59:01 +0000
Message-Id: <20201210160002.1407373-6-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the minimal set of EL2 system registers to the vcpu context.
Nothing uses them just yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 34 ++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 11beda85ee7e..d731cf7a56cb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -206,12 +206,44 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
-	/* 32bit specific registers. Keep them at the end of the range */
+	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
 	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
+	/* EL2 registers */
+	VPIDR_EL2,	/* Virtualization Processor ID Register */
+	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
+	SCTLR_EL2,	/* System Control Register (EL2) */
+	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
+	HCR_EL2,	/* Hypervisor Configuration Register */
+	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
+	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
+	HSTR_EL2,	/* Hypervisor System Trap Register */
+	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
+	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
+	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
+	TCR_EL2,	/* Translation Control Register (EL2) */
+	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
+	VTCR_EL2,	/* Virtualization Translation Control Register */
+	SPSR_EL2,	/* EL2 saved program status register */
+	ELR_EL2,	/* EL2 exception link register */
+	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
+	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
+	ESR_EL2,	/* Exception Syndrome Register (EL2) */
+	FAR_EL2,	/* Hypervisor IPA Fault Address Register */
+	HPFAR_EL2,	/* Hypervisor IPA Fault Address Register */
+	MAIR_EL2,	/* Memory Attribute Indirection Register (EL2) */
+	AMAIR_EL2,	/* Auxiliary Memory Attribute Indirection Register (EL2) */
+	VBAR_EL2,	/* Vector Base Address Register (EL2) */
+	RVBAR_EL2,	/* Reset Vector Base Address Register */
+	RMR_EL2,	/* Reset Management Register */
+	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
+	TPIDR_EL2,	/* EL2 Software Thread ID Register */
+	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
+	SP_EL2,		/* EL2 Stack Pointer */
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
-- 
2.29.2

