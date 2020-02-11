Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD3F15974B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbgBKRxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbgBKRxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:53:37 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E47220870;
        Tue, 11 Feb 2020 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443616;
        bh=/d4QEu6KExCVn1Nyc6BoOADlVZV4Bz226l2YxJeUdxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDNPjgXdR4X4fmVLG0KXib1sFo/eJ7toCHhIgi7nIdKzE8hMWc7Dp71j+BgEBUpak
         4FPgyg+b7PchSyJiFtqaoCVZX4GQaL3WHWtHWu6rAUNzGevpbof+9qmnI1f9uaicb3
         4X0gm0vDK18sR2RCEdbxvo/dELdcjaM6qyutqOms=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgI-004O7k-Hg; Tue, 11 Feb 2020 17:50:42 +0000
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
Subject: [PATCH v2 83/94] KVM: arm64: VNCR-ize ELR_EL1
Date:   Tue, 11 Feb 2020 17:49:27 +0000
Message-Id: <20200211174938.27809-84-maz@kernel.org>
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

ELR_EL1 being a VNCR-capable register, let's flag it as such, and
repaint all the accesses

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 arch/arm64/include/asm/kvm_host.h    | 2 +-
 arch/arm64/kvm/guest.c               | 2 +-
 arch/arm64/kvm/hyp/sysreg-sr.c       | 4 ++--
 arch/arm64/kvm/sys_regs.c            | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 16cd99ab7170..5718fbc56ba5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -164,7 +164,7 @@ static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 
 static inline unsigned long *__vcpu_elr_el1(const struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu->arch.ctxt.elr_el1;
+	return (unsigned long *)__ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
 }
 
 static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 29ecd13ab4e2..a497e7970418 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -264,6 +264,7 @@ enum vcpu_sysreg {
 	VNCR(CONTEXTIDR_EL1),	/* Context ID Register */
 	VNCR(AMAIR_EL1),/* Aux Memory Attribute Indirection Register */
 	VNCR(MDSCR_EL1),/* Monitor Debug System Control Register */
+	VNCR(ELR_EL1),
 	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
 	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
 	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
@@ -335,7 +336,6 @@ struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
 	u64	sp_el1;
-	u64	elr_el1;
 
 	u64	spsr[KVM_NR_SPSR];
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index fb416f624920..40ef6758266d 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -128,7 +128,7 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return &vcpu->arch.ctxt.sp_el1;
 
 	case KVM_REG_ARM_CORE_REG(elr_el1):
-		return &vcpu->arch.ctxt.elr_el1;
+		return __vcpu_elr_el1(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
 	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 8b07be72f2e7..10ce7a6a0c6c 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -59,7 +59,7 @@ static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
 
 	ctxt->sp_el1			= read_sysreg(sp_el1);
-	ctxt->elr_el1			= read_sysreg_el1(SYS_ELR);
+	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
 }
 
@@ -324,7 +324,7 @@ static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
 	}
 
 	write_sysreg(ctxt->sp_el1,			sp_el1);
-	write_sysreg_el1(ctxt->elr_el1,			SYS_ELR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
 	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d59fc246aee3..dc1b75a37f00 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1833,9 +1833,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 		return false;
 
 	if (p->is_write)
-		vcpu->arch.ctxt.elr_el1 = p->regval;
+		*__vcpu_elr_el1(vcpu) = p->regval;
 	else
-		p->regval = vcpu->arch.ctxt.elr_el1;
+		p->regval = *__vcpu_elr_el1(vcpu);
 
 	return true;
 }
-- 
2.20.1

