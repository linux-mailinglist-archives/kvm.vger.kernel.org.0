Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B608F159743
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgBKRxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:53:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730637AbgBKRxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:53:31 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC7020848;
        Tue, 11 Feb 2020 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443610;
        bh=uuLHNfNqbhykqXJ9OzYGP0lyKUcFqC0HNltRPFdpYz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/DCsWRjqy8g4WNASBYHLgVAIpeEil/l8KpiT8y2zSrbO/Ga7rjvZPjNOcIZqbe7z
         Ssk0BrNQTY3FwRdNdktWOfAjZsMmwA6EAovirRiOJ0bhJLe6ZEyp3O5PXZViNPG57x
         jQTBS8xqv7rXDToTTencxTXIQMrUoay999JuhKhE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgK-004O7k-SA; Tue, 11 Feb 2020 17:50:44 +0000
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
Subject: [PATCH v2 87/94] KVM: arm64: VNCR-ize SPSR_EL1
Date:   Tue, 11 Feb 2020 17:49:31 +0000
Message-Id: <20200211174938.27809-88-maz@kernel.org>
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

As promised, let's move SPSR_EL1 to the VNCR page.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++--
 arch/arm64/include/asm/kvm_host.h    | 2 +-
 arch/arm64/kvm/guest.c               | 2 +-
 arch/arm64/kvm/hyp/sysreg-sr.c       | 4 ++--
 arch/arm64/kvm/regmap.c              | 4 ++--
 arch/arm64/kvm/sys_regs.c            | 4 ++--
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index eed8bd48e60c..6df684e1790e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -327,7 +327,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu->arch.ctxt.spsr_el1;
+		return __vcpu_sys_reg(vcpu, SPSR_EL1);
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -345,7 +345,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu->arch.ctxt.spsr_el1 = v;
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 111597123c17..657c2c5d1a39 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -266,6 +266,7 @@ enum vcpu_sysreg {
 	VNCR(MDSCR_EL1),/* Monitor Debug System Control Register */
 	VNCR(ELR_EL1),
 	VNCR(SP_EL1),
+	VNCR(SPSR_EL1),
 	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
 	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
 	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
@@ -336,7 +337,6 @@ enum vcpu_sysreg {
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
-	u64	spsr_el1;		/* aka spsr_svc */
 	u64	spsr_abt;
 	u64	spsr_und;
 	u64	spsr_irq;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9710fe55c5dd..e295368a13f2 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -131,7 +131,7 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return __vcpu_elr_el1(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
-		return &vcpu->arch.ctxt.spsr_el1;
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
 		return &vcpu->arch.ctxt.spsr_abt;
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index b009afd87322..eaf78e9b3238 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -60,7 +60,7 @@ static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
 
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
-	ctxt->spsr_el1			= read_sysreg_el1(SYS_SPSR);
+	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
 }
 
 static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
@@ -325,7 +325,7 @@ static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
 
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
-	write_sysreg_el1(ctxt->spsr_el1,		SYS_SPSR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
 }
 
 static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index 97c110810527..accc1d5fba61 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -150,7 +150,7 @@ unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.sysregs_loaded_on_cpu) {
 		switch (spsr_idx) {
 		case KVM_SPSR_SVC:
-			return vcpu->arch.ctxt.spsr_el1;
+			return __vcpu_sys_reg(vcpu, SPSR_EL1);
 		case KVM_SPSR_ABT:
 			return vcpu->arch.ctxt.spsr_abt;
 		case KVM_SPSR_UND:
@@ -185,7 +185,7 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	if (!vcpu->arch.sysregs_loaded_on_cpu) {
 		switch (spsr_idx) {
 		case KVM_SPSR_SVC:
-			vcpu->arch.ctxt.spsr_el1 = v;
+			__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
 			break;
 		case KVM_SPSR_ABT:
 			vcpu->arch.ctxt.spsr_abt = v;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0d3500a11c50..f20f5975633f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1850,9 +1850,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 		return false;
 
 	if (p->is_write)
-		vcpu->arch.ctxt.spsr_el1 = p->regval;
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
 	else
-		p->regval = vcpu->arch.ctxt.spsr_el1;
+		p->regval = __vcpu_sys_reg(vcpu, SPSR_EL1);
 
 	return true;
 }
-- 
2.20.1

