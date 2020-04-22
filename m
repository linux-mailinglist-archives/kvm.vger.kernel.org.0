Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C360D1B44D8
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgDVMVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgDVMV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:21:28 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF9A520CC7;
        Wed, 22 Apr 2020 12:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587558088;
        bh=dUX4q4l8l1MjkjG9bujDCFwzi5QJU2LLYz1oNl6gCBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9KA6gt26GAubVHNsWgD8si08HINf0OGqPx7OXMC6Jmuu06mN6+cfvEimPAIPaR1B
         QUH6uEcZ0zbjwoDoxlCzRaaaWEsxprvq3lnlp/9+HicKz+IduU2WgMf2zPYc0QOdyU
         hnoj/uuEkP+mjTJ03sg/YE9do6QPofJ8yjD6SxgE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE44-005UI7-QY; Wed, 22 Apr 2020 13:01:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 23/26] KVM: arm64: Move SPSR_EL1 to the system register array
Date:   Wed, 22 Apr 2020 13:00:47 +0100
Message-Id: <20200422120050.3693593-24-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPSR_EL1 being a VNCR-capable register with ARMv8.4-NV, move it to
the sysregs array and update the accessors.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++--
 arch/arm64/include/asm/kvm_host.h    | 2 +-
 arch/arm64/kvm/guest.c               | 2 +-
 arch/arm64/kvm/hyp/sysreg-sr.c       | 4 ++--
 arch/arm64/kvm/regmap.c              | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 6eb48c1f324d5..77f771b08cf35 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -182,7 +182,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu->arch.ctxt.spsr_el1;
+		return __vcpu_sys_reg(vcpu, SPSR_EL1);
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -195,7 +195,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu->arch.ctxt.spsr_el1 = v;
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a918f33074b15..e8305761f0077 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -186,6 +186,7 @@ enum vcpu_sysreg {
 
 	ELR_EL1,
 	SP_EL1,
+	SPSR_EL1,
 
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
@@ -240,7 +241,6 @@ enum vcpu_sysreg {
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
-	u64	spsr_el1;		/* aka spsr_svc */
 	u64	spsr_abt;
 	u64	spsr_und;
 	u64	spsr_irq;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 6e655ea6c98d0..91215170e6883 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -129,7 +129,7 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
-		return &vcpu->arch.ctxt.spsr_el1;
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
 		return &vcpu->arch.ctxt.spsr_abt;
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index c932ace46c9df..3457252e475de 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -63,7 +63,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
-	ctxt->spsr_el1			= read_sysreg_el1(SYS_SPSR);
+	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
 }
 
 static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -168,7 +168,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
-	write_sysreg_el1(ctxt->spsr_el1,		SYS_SPSR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
 }
 
 static void __hyp_text
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index 97c110810527e..accc1d5fba615 100644
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
-- 
2.26.1

