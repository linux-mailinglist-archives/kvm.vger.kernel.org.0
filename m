Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE776159728
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgBKRxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730673AbgBKRxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:53:07 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A10220578;
        Tue, 11 Feb 2020 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443586;
        bh=gtQO6DnA30segjYAYUIYRQkYSFgAx9NxUhck8T27+04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/mDxxc3ah/TZ1sf3Rb8hEdp6xg6O/JZIuWhXYpHHhctmkHjf6G86fqdSkCauCkdE
         4g6W/HOAHsO4txgrMfKpwSMQtCyW1zZvVk6ekEM8vcSkdh2qzfg6atWMH7TqEaFn79
         Ee84VAd94Vryh+BEo0nkXfyhxCtgAwNzhpgOT6q0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfe-004O7k-8B; Tue, 11 Feb 2020 17:50:02 +0000
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
Subject: [PATCH v2 15/94] KVM: arm64: nv: Handle SPSR_EL2 specially
Date:   Tue, 11 Feb 2020 17:48:19 +0000
Message-Id: <20200211174938.27809-16-maz@kernel.org>
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

SPSR_EL2 needs special attention when running nested on ARMv8.3:

If taking an exception while running at vEL2 (actually EL1), the
HW will update the SPSR_EL1 register with the EL1 mode. We need
to track this in order to make sure that accesses to the virtual
view of SPSR_EL2 is correct.

To do so, we place an illegal value in SPSR_EL1.M, and patch it
accordingly if required when accessing it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 45 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 23 ++++++++++++--
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 486978d0346b..26552c8571cb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -277,11 +277,51 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 	return __is_hyp_ctxt(&vcpu->arch.ctxt);
 }
 
+static inline u64 __fixup_spsr_el2_write(struct kvm_cpu_context *ctxt, u64 val)
+{
+	if (!__vcpu_el2_e2h_is_set(ctxt)) {
+		/*
+		 * Clear the .M field when writing SPSR to the CPU, so that we
+		 * can detect when the CPU clobbered our SPSR copy during a
+		 * local exception.
+		 */
+		val &= ~0xc;
+	}
+
+	return val;
+}
+
+static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64 val)
+{
+	if (__vcpu_el2_e2h_is_set(ctxt))
+		return val;
+
+	/*
+	 * SPSR.M == 0 means the CPU has not touched the SPSR, so the
+	 * register has still the value we saved on the last write.
+	 */
+	if ((val & 0xc) == 0)
+		return ctxt->sys_regs[SPSR_EL2];
+
+	/*
+	 * Otherwise there was a "local" exception on the CPU,
+	 * which from the guest's point of view was being taken from
+	 * EL2 to EL2, although it actually happened to be from
+	 * EL1 to EL1.
+	 * So we need to fix the .M field in SPSR, to make it look
+	 * like EL2, which is what the guest would expect.
+	 */
+	return (val & ~0x0c) | CurrentEL_EL2;
+}
+
 static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu))
 		return vcpu_read_spsr32(vcpu);
 
+	if (unlikely(vcpu_mode_el2(vcpu)))
+		return vcpu_read_sys_reg(vcpu, SPSR_EL2);
+
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		return read_sysreg_el1(SYS_SPSR);
 	else
@@ -295,6 +335,11 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 		return;
 	}
 
+	if (unlikely(vcpu_mode_el2(vcpu))) {
+		vcpu_write_sys_reg(vcpu, v, SPSR_EL2);
+		return;
+	}
+
 	if (vcpu->arch.sysregs_loaded_on_cpu)
 		write_sysreg_el1(v, SYS_SPSR);
 	else
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 64be9f452ad6..8c7d3d410689 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -258,11 +258,14 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 			goto memory_read;
 
 		/*
-		 * ELR_EL2 is special cased for now.
+		 * ELR_EL2 and SPSR_EL2 are special cased for now.
 		 */
 		switch (reg) {
 		case ELR_EL2:
 			return read_sysreg_el1(SYS_ELR);
+		case SPSR_EL2:
+			val = read_sysreg_el1(SYS_SPSR);
+			return __fixup_spsr_el2_read(&vcpu->arch.ctxt, val);
 		}
 
 		/*
@@ -319,6 +322,10 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		case ELR_EL2:
 			write_sysreg_el1(val, SYS_ELR);
 			return;
+		case SPSR_EL2:
+			val = __fixup_spsr_el2_write(&vcpu->arch.ctxt, val);
+			write_sysreg_el1(val, SYS_SPSR);
+			return;
 		}
 
 		/* No EL1 counterpart? We're done here.? */
@@ -1589,6 +1596,18 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_spsr_el2(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
+	else
+		p->regval = vcpu_read_sys_reg(vcpu, SPSR_EL2);
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1899,7 +1918,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_VTCR_EL2), access_rw, reset_val, VTCR_EL2, 0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
-	{ SYS_DESC(SYS_SPSR_EL2), access_rw, reset_val, SPSR_EL2, 0 },
+	{ SYS_DESC(SYS_SPSR_EL2), access_spsr_el2, reset_val, SPSR_EL2, 0 },
 	{ SYS_DESC(SYS_ELR_EL2), access_rw, reset_val, ELR_EL2, 0 },
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
-- 
2.20.1

