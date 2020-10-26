Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997E9298E0D
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780213AbgJZNfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 09:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1769388AbgJZNfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:35:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 201BC206DD;
        Mon, 26 Oct 2020 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603719310;
        bh=uFc4/WHBo76kUf8EXhinDGT17Lp0Jm+obdgt4FXWy5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAreB+HtGnFwLc14jLs40XXEXTMbbhLDW0DiqTJaMtihD22Sq8U4OR+Zt2OdBFVYQ
         EGfpEmSgpeIKFNFIRaiQCBUvNurIndR1SUpFiteDtjYFtlUI4AUboGmItHeEMGCiM+
         HYJcEyIjef6XTauYBJZrsbgMXsvVROOB/IyC9Fos=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kX2eR-004Kjh-HK; Mon, 26 Oct 2020 13:35:08 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH 09/11] KVM: arm64: Remove SPSR manipulation primitives
Date:   Mon, 26 Oct 2020 13:34:48 +0000
Message-Id: <20201026133450.73304-10-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SPR setting code is now completely unused, including that dealing
with banked AArch32 SPSRs. Cleanup time.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 26 --------
 arch/arm64/kvm/regmap.c              | 96 ----------------------------
 2 files changed, 122 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 736a342dadf7..5d957d0e7b69 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -34,8 +34,6 @@ enum exception_type {
 };
 
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
-unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu);
-void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v);
 
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
@@ -180,30 +178,6 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
 }
 
-static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
-{
-	if (vcpu_mode_is_32bit(vcpu))
-		return vcpu_read_spsr32(vcpu);
-
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		return read_sysreg_el1(SYS_SPSR);
-	else
-		return __vcpu_sys_reg(vcpu, SPSR_EL1);
-}
-
-static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
-{
-	if (vcpu_mode_is_32bit(vcpu)) {
-		vcpu_write_spsr32(vcpu, v);
-		return;
-	}
-
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		write_sysreg_el1(v, SYS_SPSR);
-	else
-		__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
-}
-
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index accc1d5fba61..ae7e290bb017 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -126,99 +126,3 @@ unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
 
 	return reg_array + vcpu_reg_offsets[mode][reg_num];
 }
-
-/*
- * Return the SPSR for the current mode of the virtual CPU.
- */
-static int vcpu_spsr32_mode(const struct kvm_vcpu *vcpu)
-{
-	unsigned long mode = *vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK;
-	switch (mode) {
-	case PSR_AA32_MODE_SVC: return KVM_SPSR_SVC;
-	case PSR_AA32_MODE_ABT: return KVM_SPSR_ABT;
-	case PSR_AA32_MODE_UND: return KVM_SPSR_UND;
-	case PSR_AA32_MODE_IRQ: return KVM_SPSR_IRQ;
-	case PSR_AA32_MODE_FIQ: return KVM_SPSR_FIQ;
-	default: BUG();
-	}
-}
-
-unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
-{
-	int spsr_idx = vcpu_spsr32_mode(vcpu);
-
-	if (!vcpu->arch.sysregs_loaded_on_cpu) {
-		switch (spsr_idx) {
-		case KVM_SPSR_SVC:
-			return __vcpu_sys_reg(vcpu, SPSR_EL1);
-		case KVM_SPSR_ABT:
-			return vcpu->arch.ctxt.spsr_abt;
-		case KVM_SPSR_UND:
-			return vcpu->arch.ctxt.spsr_und;
-		case KVM_SPSR_IRQ:
-			return vcpu->arch.ctxt.spsr_irq;
-		case KVM_SPSR_FIQ:
-			return vcpu->arch.ctxt.spsr_fiq;
-		}
-	}
-
-	switch (spsr_idx) {
-	case KVM_SPSR_SVC:
-		return read_sysreg_el1(SYS_SPSR);
-	case KVM_SPSR_ABT:
-		return read_sysreg(spsr_abt);
-	case KVM_SPSR_UND:
-		return read_sysreg(spsr_und);
-	case KVM_SPSR_IRQ:
-		return read_sysreg(spsr_irq);
-	case KVM_SPSR_FIQ:
-		return read_sysreg(spsr_fiq);
-	default:
-		BUG();
-	}
-}
-
-void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
-{
-	int spsr_idx = vcpu_spsr32_mode(vcpu);
-
-	if (!vcpu->arch.sysregs_loaded_on_cpu) {
-		switch (spsr_idx) {
-		case KVM_SPSR_SVC:
-			__vcpu_sys_reg(vcpu, SPSR_EL1) = v;
-			break;
-		case KVM_SPSR_ABT:
-			vcpu->arch.ctxt.spsr_abt = v;
-			break;
-		case KVM_SPSR_UND:
-			vcpu->arch.ctxt.spsr_und = v;
-			break;
-		case KVM_SPSR_IRQ:
-			vcpu->arch.ctxt.spsr_irq = v;
-			break;
-		case KVM_SPSR_FIQ:
-			vcpu->arch.ctxt.spsr_fiq = v;
-			break;
-		}
-
-		return;
-	}
-
-	switch (spsr_idx) {
-	case KVM_SPSR_SVC:
-		write_sysreg_el1(v, SYS_SPSR);
-		break;
-	case KVM_SPSR_ABT:
-		write_sysreg(v, spsr_abt);
-		break;
-	case KVM_SPSR_UND:
-		write_sysreg(v, spsr_und);
-		break;
-	case KVM_SPSR_IRQ:
-		write_sysreg(v, spsr_irq);
-		break;
-	case KVM_SPSR_FIQ:
-		write_sysreg(v, spsr_fiq);
-		break;
-	}
-}
-- 
2.28.0

