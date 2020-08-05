Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC9923CEA0
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgHESnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbgHES1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFF8722D6D;
        Wed,  5 Aug 2020 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651985;
        bh=sQuw+4Tv7Zd44cShYezIKg+TOSdhGiXqUAipF1jKIS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehrTgvGpizQ+qPp26y3EyrzWbvoWasCxao0ddHCta8x1oStYCS+HmuEUuTB6Z72Cm
         lR96neHMikMF9y53jK47cZNmkqcdyTROGuQdKLziE419kgwYZ/aD/OzJ7iUPTzWQ1z
         AWZgsZdbZE9DpLUlY3qMxRD9eMBX+XlZ9Goktql0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nft-0004w9-U2; Wed, 05 Aug 2020 18:58:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 44/56] KVM: arm64: Disintegrate SPSR array
Date:   Wed,  5 Aug 2020 18:56:48 +0100
Message-Id: <20200805175700.62775-45-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we're about to move SPSR_EL1 into the VNCR page, we need to
disassociate it from the rest of the 32bit cruft. Let's break
the array into individual fields.

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h       |  4 +--
 arch/arm64/include/asm/kvm_host.h          |  6 +++-
 arch/arm64/kvm/guest.c                     | 19 ++++++++----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 28 +++++++----------
 arch/arm64/kvm/regmap.c                    | 35 ++++++++++++++++++++--
 5 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a12b5dc5db0d..5f959fedff09 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -176,7 +176,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
-		return vcpu->arch.ctxt.spsr[KVM_SPSR_EL1];
+		return vcpu->arch.ctxt.spsr_el1;
 }
 
 static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
@@ -189,7 +189,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
-		vcpu->arch.ctxt.spsr[KVM_SPSR_EL1] = v;
+		vcpu->arch.ctxt.spsr_el1 = v;
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2bd6285eaf4c..dfb97ed2f680 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -241,7 +241,11 @@ enum vcpu_sysreg {
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
-	u64	spsr[KVM_NR_SPSR];
+	u64	spsr_el1;		/* aka spsr_svc */
+	u64	spsr_abt;
+	u64	spsr_und;
+	u64	spsr_irq;
+	u64	spsr_fiq;
 
 	struct user_fpsimd_state fp_regs;
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d614716e073b..70215f3a6f89 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -134,11 +134,20 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_CORE_REG(elr_el1):
 		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
 
-	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
-	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
-		off -= KVM_REG_ARM_CORE_REG(spsr[0]);
-		off /= 2;
-		return &vcpu->arch.ctxt.spsr[off];
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
+		return &vcpu->arch.ctxt.spsr_el1;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
+		return &vcpu->arch.ctxt.spsr_abt;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_UND]):
+		return &vcpu->arch.ctxt.spsr_und;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_IRQ]):
+		return &vcpu->arch.ctxt.spsr_irq;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_FIQ]):
+		return &vcpu->arch.ctxt.spsr_fiq;
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4c26ba72120e..fb4bc42e72c5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -48,7 +48,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
-	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
+	ctxt->spsr_el1			= read_sysreg_el1(SYS_SPSR);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -127,7 +127,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 
 	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1),	sp_el1);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
-	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
+	write_sysreg_el1(ctxt->spsr_el1,		SYS_SPSR);
 }
 
 static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -158,17 +158,13 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 
 static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
-	u64 *spsr;
-
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.spsr;
-
-	spsr[KVM_SPSR_ABT] = read_sysreg(spsr_abt);
-	spsr[KVM_SPSR_UND] = read_sysreg(spsr_und);
-	spsr[KVM_SPSR_IRQ] = read_sysreg(spsr_irq);
-	spsr[KVM_SPSR_FIQ] = read_sysreg(spsr_fiq);
+	vcpu->arch.ctxt.spsr_abt = read_sysreg(spsr_abt);
+	vcpu->arch.ctxt.spsr_und = read_sysreg(spsr_und);
+	vcpu->arch.ctxt.spsr_irq = read_sysreg(spsr_irq);
+	vcpu->arch.ctxt.spsr_fiq = read_sysreg(spsr_fiq);
 
 	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
 	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
@@ -179,17 +175,13 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 
 static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
-	u64 *spsr;
-
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	spsr = vcpu->arch.ctxt.spsr;
-
-	write_sysreg(spsr[KVM_SPSR_ABT], spsr_abt);
-	write_sysreg(spsr[KVM_SPSR_UND], spsr_und);
-	write_sysreg(spsr[KVM_SPSR_IRQ], spsr_irq);
-	write_sysreg(spsr[KVM_SPSR_FIQ], spsr_fiq);
+	write_sysreg(vcpu->arch.ctxt.spsr_abt, spsr_abt);
+	write_sysreg(vcpu->arch.ctxt.spsr_und, spsr_und);
+	write_sysreg(vcpu->arch.ctxt.spsr_irq, spsr_irq);
+	write_sysreg(vcpu->arch.ctxt.spsr_fiq, spsr_fiq);
 
 	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
 	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index b1596f314087..97c110810527 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -147,8 +147,20 @@ unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
 {
 	int spsr_idx = vcpu_spsr32_mode(vcpu);
 
-	if (!vcpu->arch.sysregs_loaded_on_cpu)
-		return vcpu->arch.ctxt.spsr[spsr_idx];
+	if (!vcpu->arch.sysregs_loaded_on_cpu) {
+		switch (spsr_idx) {
+		case KVM_SPSR_SVC:
+			return vcpu->arch.ctxt.spsr_el1;
+		case KVM_SPSR_ABT:
+			return vcpu->arch.ctxt.spsr_abt;
+		case KVM_SPSR_UND:
+			return vcpu->arch.ctxt.spsr_und;
+		case KVM_SPSR_IRQ:
+			return vcpu->arch.ctxt.spsr_irq;
+		case KVM_SPSR_FIQ:
+			return vcpu->arch.ctxt.spsr_fiq;
+		}
+	}
 
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
@@ -171,7 +183,24 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 	int spsr_idx = vcpu_spsr32_mode(vcpu);
 
 	if (!vcpu->arch.sysregs_loaded_on_cpu) {
-		vcpu->arch.ctxt.spsr[spsr_idx] = v;
+		switch (spsr_idx) {
+		case KVM_SPSR_SVC:
+			vcpu->arch.ctxt.spsr_el1 = v;
+			break;
+		case KVM_SPSR_ABT:
+			vcpu->arch.ctxt.spsr_abt = v;
+			break;
+		case KVM_SPSR_UND:
+			vcpu->arch.ctxt.spsr_und = v;
+			break;
+		case KVM_SPSR_IRQ:
+			vcpu->arch.ctxt.spsr_irq = v;
+			break;
+		case KVM_SPSR_FIQ:
+			vcpu->arch.ctxt.spsr_fiq = v;
+			break;
+		}
+
 		return;
 	}
 
-- 
2.27.0

