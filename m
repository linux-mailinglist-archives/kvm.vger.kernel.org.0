Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A9E1596C3
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgBKRvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbgBKRvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:36 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11DD20578;
        Tue, 11 Feb 2020 17:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443495;
        bh=vJgCeyNhc/zjTIzrf5MG6+BOepmc9H4if6t7gh/kTSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge+7LsrMQjgNYp3YORkBfaJvbrDPYo1v/5naMcnSuHcXLhaRrtON8wAkI3dHwSLkX
         81ziN2BC0cmYcNCwOpLvcxQuA1z9tF948+ntPi8gRPCGV6VAQmWmr8JotPIGO7tyGD
         J7gUxDJX7x4va5Hm7y7Tf+CdhP24aakywn+rO2pI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgJ-004O7k-4I; Tue, 11 Feb 2020 17:50:43 +0000
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
Subject: [PATCH v2 84/94] KVM: arm64: VNCR-ize SP_EL1
Date:   Tue, 11 Feb 2020 17:49:28 +0000
Message-Id: <20200211174938.27809-85-maz@kernel.org>
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

SP_EL1 being a VNCR-capable register, let's flag it as such, and
repaint all the accesses

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 +--
 arch/arm64/kvm/guest.c            | 2 +-
 arch/arm64/kvm/hyp/sysreg-sr.c    | 4 ++--
 arch/arm64/kvm/sys_regs.c         | 5 ++---
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a497e7970418..fe6d5a3bc338 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -265,6 +265,7 @@ enum vcpu_sysreg {
 	VNCR(AMAIR_EL1),/* Aux Memory Attribute Indirection Register */
 	VNCR(MDSCR_EL1),/* Monitor Debug System Control Register */
 	VNCR(ELR_EL1),
+	VNCR(SP_EL1),
 	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
 	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
 	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
@@ -335,8 +336,6 @@ enum vcpu_sysreg {
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
-	u64	sp_el1;
-
 	u64	spsr[KVM_NR_SPSR];
 
 	struct user_fpsimd_state fp_regs;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 40ef6758266d..869017e50464 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -125,7 +125,7 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return &vcpu->arch.ctxt.regs.pstate;
 
 	case KVM_REG_ARM_CORE_REG(sp_el1):
-		return &vcpu->arch.ctxt.sp_el1;
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
 
 	case KVM_REG_ARM_CORE_REG(elr_el1):
 		return __vcpu_elr_el1(vcpu);
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 10ce7a6a0c6c..e5359cd39b32 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -58,7 +58,7 @@ static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
 
-	ctxt->sp_el1			= read_sysreg(sp_el1);
+	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
 }
@@ -323,7 +323,7 @@ static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 	}
 
-	write_sysreg(ctxt->sp_el1,			sp_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
 	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dc1b75a37f00..2c3e90e192b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1803,11 +1803,10 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	/* SP_EL1 is NOT maintained in sys_regs array */
 	if (p->is_write)
-		vcpu->arch.ctxt.sp_el1 = p->regval;
+		__vcpu_sys_reg(vcpu, SP_EL1) = p->regval;
 	else
-		p->regval = vcpu->arch.ctxt.sp_el1;
+		p->regval = __vcpu_sys_reg(vcpu, SP_EL1);
 
 	return true;
 }
-- 
2.20.1

