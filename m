Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790424E3E4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfFUJjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:35 -0400
Received: from foss.arm.com ([217.140.110.172]:53960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbfFUJjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77FD114FF;
        Fri, 21 Jun 2019 02:39:34 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 249F43F246;
        Fri, 21 Jun 2019 02:39:33 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 14/59] KVM: arm64: nv: Handle SPSR_EL2 specially
Date:   Fri, 21 Jun 2019 10:37:58 +0100
Message-Id: <20190621093843.220980-15-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 45 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 28 ++++++++++++++++-
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f37006b6eec4..2644258e96ba 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -274,11 +274,51 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
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
@@ -292,6 +332,11 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
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
index d024114da162..2b8734f75a09 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -184,6 +184,7 @@ const struct el2_sysreg_map *find_el2_sysreg(const struct el2_sysreg_map *map,
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
+	u64 val;
 
 	if (!vcpu->arch.sysregs_loaded_on_cpu)
 		goto immediate_read;
@@ -194,6 +195,12 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 		if (!is_hyp_ctxt(vcpu))
 			goto immediate_read;
 
+		switch (reg) {
+		case SPSR_EL2:
+			val = read_sysreg_el1(SYS_SPSR);
+			return __fixup_spsr_el2_read(&vcpu->arch.ctxt, val);
+		}
+
 		el2_reg = find_el2_sysreg(nested_sysreg_map, reg);
 		if (el2_reg) {
 			/*
@@ -267,6 +274,13 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		/* Store the EL2 version in the sysregs array. */
 		__vcpu_sys_reg(vcpu, reg) = val;
 
+		switch (reg) {
+		case SPSR_EL2:
+			val = __fixup_spsr_el2_write(&vcpu->arch.ctxt, val);
+			write_sysreg_el1(val, SYS_SPSR);
+			return;
+		}
+
 		el2_reg = find_el2_sysreg(nested_sysreg_map, reg);
 		if (el2_reg) {
 			/* Does this register have an EL1 counterpart? */
@@ -1556,6 +1570,18 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
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
@@ -1866,7 +1892,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_VTCR_EL2), access_rw, reset_val, VTCR_EL2, 0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
-	{ SYS_DESC(SYS_SPSR_EL2), access_rw, reset_val, SPSR_EL2, 0 },
+	{ SYS_DESC(SYS_SPSR_EL2), access_spsr_el2, reset_val, SPSR_EL2, 0 },
 	{ SYS_DESC(SYS_ELR_EL2), access_rw, reset_val, ELR_EL2, 0 },
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
-- 
2.20.1

