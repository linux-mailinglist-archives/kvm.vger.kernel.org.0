Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2756A2D6129
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392271AbgLJQGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:06:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391674AbgLJQF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:05:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C3223DE4;
        Thu, 10 Dec 2020 16:05:29 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knONl-0008Di-Tf; Thu, 10 Dec 2020 16:01:30 +0000
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
Subject: [PATCH v3 58/66] KVM: arm64: Map VNCR-capable registers to a separate page
Date:   Thu, 10 Dec 2020 15:59:54 +0000
Message-Id: <20201210160002.1407373-59-maz@kernel.org>
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

With ARMv8.4-NV, registers that can be directly accessed in memory
by the guest have to live at architected offsets in a special page.

Let's annotate the sysreg enum to reflect the offset at which they
are in this page, whith a little twist:

If running on HW that doesn't have the ARMv8.4-NV feature, or even
a VM that doesn't use NV, we store all the system registers in the
usual sys_regs array. The only difference with the pre-8.4
situation is that VNCR-capable registers are at a "similar" offset
as in the VNCR page (we can compute the actual offset at compile
time), and that the sys_regs array is both bigger and sparse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 97 ++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e190a65e78b..a4832df71a52 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/thread_info.h>
+#include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -171,31 +172,32 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
+/*
+ * VNCR() just places the VNCR_capable registers in the enum after
+ * __VNCR_START__, and the value (after correction) to be an 8-byte offset
+ * from the VNCR base. As we don't require the enum to be otherwise ordered,
+ * we need the terrible hack below to ensure that we correctly size the
+ * sys_regs array, no matter what.
+ *
+ * The __MAX__ macro has been lifted from Sean Eron Anderson's wonderful
+ * treasure trove of bit hacks:
+ * https://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
+ */
+#define __MAX__(x,y)	((x) ^ (((x) ^ (y)) & -((x) < (y))))
+#define VNCR(r)						\
+	__before_##r,					\
+	r = __VNCR_START__ + ((VNCR_ ## r) / 8),	\
+	__after_##r = __MAX__(__before_##r - 1, r)
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
 	CSSELR_EL1,	/* Cache Size Selection Register */
-	SCTLR_EL1,	/* System Control Register */
-	ACTLR_EL1,	/* Auxiliary Control Register */
-	CPACR_EL1,	/* Coprocessor Access Control */
-	ZCR_EL1,	/* SVE Control */
-	TTBR0_EL1,	/* Translation Table Base Register 0 */
-	TTBR1_EL1,	/* Translation Table Base Register 1 */
-	TCR_EL1,	/* Translation Control Register */
-	ESR_EL1,	/* Exception Syndrome Register */
-	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
-	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
-	FAR_EL1,	/* Fault Address Register */
-	MAIR_EL1,	/* Memory Attribute Indirection Register */
-	VBAR_EL1,	/* Vector Base Address Register */
-	CONTEXTIDR_EL1,	/* Context ID Register */
 	TPIDR_EL0,	/* Thread ID, User R/W */
 	TPIDRRO_EL0,	/* Thread ID, User R/O */
 	TPIDR_EL1,	/* Thread ID, Privileged */
-	AMAIR_EL1,	/* Aux Memory Attribute Indirection Register */
 	CNTKCTL_EL1,	/* Timer Control Register (EL1) */
 	PAR_EL1,	/* Physical Address Register */
-	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
@@ -226,16 +228,6 @@ enum vcpu_sysreg {
 	APGAKEYLO_EL1,
 	APGAKEYHI_EL1,
 
-	ELR_EL1,
-	SP_EL1,
-	SPSR_EL1,
-
-	CNTVOFF_EL2,
-	CNTV_CVAL_EL0,
-	CNTV_CTL_EL0,
-	CNTP_CVAL_EL0,
-	CNTP_CTL_EL0,
-
 	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -243,20 +235,14 @@ enum vcpu_sysreg {
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
 	/* EL2 registers */
-	VPIDR_EL2,	/* Virtualization Processor ID Register */
-	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
 	SCTLR_EL2,	/* System Control Register (EL2) */
 	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
-	HCR_EL2,	/* Hypervisor Configuration Register */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
-	HSTR_EL2,	/* Hypervisor System Trap Register */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
-	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
-	VTCR_EL2,	/* Virtualization Translation Control Register */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
@@ -270,7 +256,6 @@ enum vcpu_sysreg {
 	RVBAR_EL2,	/* Reset Vector Base Address Register */
 	RMR_EL2,	/* Reset Management Register */
 	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
-	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
 	CNTHP_CTL_EL2,
@@ -278,6 +263,41 @@ enum vcpu_sysreg {
 	CNTHV_CTL_EL2,
 	CNTHV_CVAL_EL2,
 
+	__VNCR_START__,	/* Any VNCR-capable reg goes after this point */
+
+	VNCR(SCTLR_EL1),/* System Control Register */
+	VNCR(ACTLR_EL1),/* Auxiliary Control Register */
+	VNCR(CPACR_EL1),/* Coprocessor Access Control */
+	VNCR(ZCR_EL1),	/* SVE Control */
+	VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
+	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
+	VNCR(TCR_EL1),	/* Translation Control Register */
+	VNCR(ESR_EL1),	/* Exception Syndrome Register */
+	VNCR(AFSR0_EL1),/* Auxiliary Fault Status Register 0 */
+	VNCR(AFSR1_EL1),/* Auxiliary Fault Status Register 1 */
+	VNCR(FAR_EL1),	/* Fault Address Register */
+	VNCR(MAIR_EL1),	/* Memory Attribute Indirection Register */
+	VNCR(VBAR_EL1),	/* Vector Base Address Register */
+	VNCR(CONTEXTIDR_EL1),	/* Context ID Register */
+	VNCR(AMAIR_EL1),/* Aux Memory Attribute Indirection Register */
+	VNCR(MDSCR_EL1),/* Monitor Debug System Control Register */
+	VNCR(ELR_EL1),
+	VNCR(SP_EL1),
+	VNCR(SPSR_EL1),
+	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
+	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
+	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
+	VNCR(HSTR_EL2),	/* Hypervisor System Trap Register */
+	VNCR(VTTBR_EL2),/* Virtualization Translation Table Base Register */
+	VNCR(VTCR_EL2),	/* Virtualization Translation Control Register */
+	VNCR(TPIDR_EL2),/* EL2 Software Thread ID Register */
+
+	VNCR(CNTVOFF_EL2),
+	VNCR(CNTV_CVAL_EL0),
+	VNCR(CNTV_CTL_EL0),
+	VNCR(CNTP_CVAL_EL0),
+	VNCR(CNTP_CTL_EL0),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
@@ -294,6 +314,9 @@ struct kvm_cpu_context {
 	u64 sys_regs[NR_SYS_REGS];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
+
+	/* This pointer has to be 4kB aligned. */
+	u64 *vncr_array;
 };
 
 struct kvm_pmu_events {
@@ -489,7 +512,13 @@ struct kvm_vcpu_arch {
  * for system registers that are never context switched, but only
  * emulated.
  */
-#define __ctxt_sys_reg(c,r)	(&(c)->sys_regs[(r)])
+static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
+{
+	if (unlikely(r >= __VNCR_START__ && ctxt->vncr_array))
+		return &ctxt->vncr_array[r - __VNCR_START__];
+
+	return (u64 *)&ctxt->sys_regs[r];
+}
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
-- 
2.29.2

