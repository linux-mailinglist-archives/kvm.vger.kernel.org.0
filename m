Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB97159735
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgBKRxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730707AbgBKRxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:53:19 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A86E208C3;
        Tue, 11 Feb 2020 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443597;
        bh=QY0vOrEBi06uaCWEKz/JMSvWF3lSjw1/mP4A3k4YHko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwNNhkC9RVAuwBJwVCrb46vUMRF9z0KonhJQ0wgMJ1Wh3e8sJqewsHcGQBGTB+ssR
         1nu1+0M4mu92YujrOo7X4aIkZLJssfBMF0nlriO8FTfLWHcqDwvBu9lH3CjvnO6hc+
         YRNkcATJNfzuuvZb3QItsYR8hXENZAIUFirPCXdM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfd-004O7k-3X; Tue, 11 Feb 2020 17:50:01 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 13/94] KVM: arm64: nv: Refactor vcpu_{read,write}_sys_reg
Date:   Tue, 11 Feb 2020 17:48:17 +0000
Message-Id: <20200211174938.27809-14-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the direct HW accessors for later reuse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 143 +++++++++++++++++++++++---------------
 1 file changed, 86 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 634d3ee6799c..42a268c21f06 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -113,11 +113,8 @@ u64 translate_cnthctl(u64 cnthctl)
 	return ((cnthctl & 0x3) << 10) | (cnthctl & 0xfc);
 }
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 {
-	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		goto immediate_read;
-
 	/*
 	 * System registers listed in the switch are not saved on every
 	 * exit from the guest but are only saved on vcpu_put.
@@ -128,40 +125,37 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 	 * thread when emulating cross-VCPU communication.
 	 */
 	switch (reg) {
-	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
-	case SCTLR_EL1:		return read_sysreg_s(SYS_SCTLR_EL12);
-	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
-	case CPACR_EL1:		return read_sysreg_s(SYS_CPACR_EL12);
-	case TTBR0_EL1:		return read_sysreg_s(SYS_TTBR0_EL12);
-	case TTBR1_EL1:		return read_sysreg_s(SYS_TTBR1_EL12);
-	case TCR_EL1:		return read_sysreg_s(SYS_TCR_EL12);
-	case ESR_EL1:		return read_sysreg_s(SYS_ESR_EL12);
-	case AFSR0_EL1:		return read_sysreg_s(SYS_AFSR0_EL12);
-	case AFSR1_EL1:		return read_sysreg_s(SYS_AFSR1_EL12);
-	case FAR_EL1:		return read_sysreg_s(SYS_FAR_EL12);
-	case MAIR_EL1:		return read_sysreg_s(SYS_MAIR_EL12);
-	case VBAR_EL1:		return read_sysreg_s(SYS_VBAR_EL12);
-	case CONTEXTIDR_EL1:	return read_sysreg_s(SYS_CONTEXTIDR_EL12);
-	case TPIDR_EL0:		return read_sysreg_s(SYS_TPIDR_EL0);
-	case TPIDRRO_EL0:	return read_sysreg_s(SYS_TPIDRRO_EL0);
-	case TPIDR_EL1:		return read_sysreg_s(SYS_TPIDR_EL1);
-	case AMAIR_EL1:		return read_sysreg_s(SYS_AMAIR_EL12);
-	case CNTKCTL_EL1:	return read_sysreg_s(SYS_CNTKCTL_EL12);
-	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1);
-	case DACR32_EL2:	return read_sysreg_s(SYS_DACR32_EL2);
-	case IFSR32_EL2:	return read_sysreg_s(SYS_IFSR32_EL2);
-	case DBGVCR32_EL2:	return read_sysreg_s(SYS_DBGVCR32_EL2);
+	case CSSELR_EL1:	*val = read_sysreg_s(SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		*val = read_sysreg_s(SYS_SCTLR_EL12);	break;
+	case ACTLR_EL1:		*val = read_sysreg_s(SYS_ACTLR_EL1);	break;
+	case CPACR_EL1:		*val = read_sysreg_s(SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
+	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		*val = read_sysreg_s(SYS_FAR_EL12);	break;
+	case MAIR_EL1:		*val = read_sysreg_s(SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		*val = read_sysreg_s(SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	*val = read_sysreg_s(SYS_CONTEXTIDR_EL12);break;
+	case TPIDR_EL0:		*val = read_sysreg_s(SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	*val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
+	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
+	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
+	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
+	default:		return false;
 	}
 
-immediate_read:
-	return __vcpu_sys_reg(vcpu, reg);
+	return true;
 }
 
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 {
-	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		goto immediate_write;
-
 	/*
 	 * System registers listed in the switch are not restored on every
 	 * entry to the guest but are only restored on vcpu_load.
@@ -171,32 +165,67 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	 * set once, before running the VCPU, and never changed later.
 	 */
 	switch (reg) {
-	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
-	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	return;
-	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
-	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	return;
-	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	return;
-	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	return;
-	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	return;
-	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	return;
-	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	return;
-	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	return;
-	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	return;
-	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	return;
-	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	return;
-	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12); return;
-	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	return;
-	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	return;
-	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	return;
-	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	return;
-	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	return;
-	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	return;
-	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	return;
-	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	return;
-	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	return;
+	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	break;
+	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	break;
+	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	break;
+	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	break;
+	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
+	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
+	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
+	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
+	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
+	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;
+	case FAR_EL1:		write_sysreg_s(val, SYS_FAR_EL12);	break;
+	case MAIR_EL1:		write_sysreg_s(val, SYS_MAIR_EL12);	break;
+	case VBAR_EL1:		write_sysreg_s(val, SYS_VBAR_EL12);	break;
+	case CONTEXTIDR_EL1:	write_sysreg_s(val, SYS_CONTEXTIDR_EL12);break;
+	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
+	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
+	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
+	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
+	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
+	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
+	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
+	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
+	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
+	default:		return false;
+	}
+
+	return true;
+}
+
+u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+{
+	u64 val = 0x8badf00d8badf00d;
+
+	if (!vcpu->arch.sysregs_loaded_on_cpu) {
+		goto memory_read;
 	}
 
-immediate_write:
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_read;
+
+	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
+		return val;
+
+memory_read:
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
+void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+{
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
+		goto memory_write;
+
+	/* EL1 register can't be on the CPU if the guest is in vEL2. */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		goto memory_write;
+
+	if (__vcpu_write_sys_reg_to_cpu(val, reg))
+		return;
+
+memory_write:
 	 __vcpu_sys_reg(vcpu, reg) = val;
 }
 
-- 
2.20.1

