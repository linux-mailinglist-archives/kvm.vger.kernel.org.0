Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F614E3E7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFUJjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:39 -0400
Received: from foss.arm.com ([217.140.110.172]:53986 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbfFUJji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B0D61478;
        Fri, 21 Jun 2019 02:39:37 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 419D73F246;
        Fri, 21 Jun 2019 02:39:36 -0700 (PDT)
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
Subject: [PATCH 16/59] KVM: arm64: nv: Save/Restore vEL2 sysregs
Date:   Fri, 21 Jun 2019 10:38:00 +0100
Message-Id: <20190621093843.220980-17-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

Whenever we need to restore the guest's system registers to the CPU, we
now need to take care of the EL2 system registers as well. Most of them
are accessed via traps only, but some have an immediate effect and also
a guest running in VHE mode would expect them to be accessible via their
EL1 encoding, which we do not trap.

Split the current __sysreg_{save,restore}_el1_state() functions into
handling common sysregs, then differentiate between the guest running in
vEL2 and vEL1.

For vEL2 we write the virtual EL2 registers with an identical format directly
into their EL1 counterpart, and translate the few registers that have a
different format for the same effect on the execution when running a
non-VHE guest guest hypervisor.

  [ Commit message reworked and many bug fixes applied by Marc Zyngier
    and Christoffer Dall. ]

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 160 +++++++++++++++++++++++++++++++--
 1 file changed, 153 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 62866a68e852..2abb9c3ff24f 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -22,6 +22,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 
 /*
  * Non-VHE: Both host and guest must save everything.
@@ -51,11 +52,9 @@ static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
 }
 
-static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
+static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
 	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(SYS_CPACR);
 	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(SYS_TTBR0);
 	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(SYS_TTBR1);
@@ -69,14 +68,58 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(SYS_CONTEXTIDR);
 	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(SYS_AMAIR);
 	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(SYS_CNTKCTL);
-	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
-	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
 
 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
 	ctxt->gp_regs.elr_el1		= read_sysreg_el1(SYS_ELR);
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
 }
 
+static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt->sys_regs[ESR_EL2]		= read_sysreg_el1(SYS_ESR);
+	ctxt->sys_regs[AFSR0_EL2]	= read_sysreg_el1(SYS_AFSR0);
+	ctxt->sys_regs[AFSR1_EL2]	= read_sysreg_el1(SYS_AFSR1);
+	ctxt->sys_regs[FAR_EL2]		= read_sysreg_el1(SYS_FAR);
+	ctxt->sys_regs[MAIR_EL2]	= read_sysreg_el1(SYS_MAIR);
+	ctxt->sys_regs[VBAR_EL2]	= read_sysreg_el1(SYS_VBAR);
+	ctxt->sys_regs[CONTEXTIDR_EL2]	= read_sysreg_el1(SYS_CONTEXTIDR);
+	ctxt->sys_regs[AMAIR_EL2]	= read_sysreg_el1(SYS_AMAIR);
+
+	/*
+	 * In VHE mode those registers are compatible between EL1 and EL2,
+	 * and the guest uses the _EL1 versions on the CPU naturally.
+	 * So we save them into their _EL2 versions here.
+	 * For nVHE mode we trap accesses to those registers, so our
+	 * _EL2 copy in sys_regs[] is always up-to-date and we don't need
+	 * to save anything here.
+	 */
+	if (__vcpu_el2_e2h_is_set(ctxt)) {
+		ctxt->sys_regs[SCTLR_EL2]	= read_sysreg_el1(SYS_SCTLR);
+		ctxt->sys_regs[CPTR_EL2]	= read_sysreg_el1(SYS_CPACR);
+		ctxt->sys_regs[TTBR0_EL2]	= read_sysreg_el1(SYS_TTBR0);
+		ctxt->sys_regs[TTBR1_EL2]	= read_sysreg_el1(SYS_TTBR1);
+		ctxt->sys_regs[TCR_EL2]		= read_sysreg_el1(SYS_TCR);
+		ctxt->sys_regs[CNTHCTL_EL2]	= read_sysreg_el1(SYS_CNTKCTL);
+	}
+
+	ctxt->sys_regs[SP_EL2]		= read_sysreg(sp_el1);
+	ctxt->sys_regs[ELR_EL2]		= read_sysreg_el1(SYS_ELR);
+	ctxt->sys_regs[SPSR_EL2]	= __fixup_spsr_el2_read(ctxt, read_sysreg_el1(SYS_SPSR));
+}
+
+static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
+	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
+	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
+	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
+
+	if (unlikely(__is_hyp_ctxt(ctxt)))
+		__sysreg_save_vel2_state(ctxt);
+	else
+		__sysreg_save_vel1_state(ctxt);
+}
+
 static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
@@ -124,10 +167,91 @@ static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
 }
 
-static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
+static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
 {
+	u64 val;
+
+	write_sysreg(read_cpuid_id(),			vpidr_el2);
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
-	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
+	write_sysreg_el1(ctxt->sys_regs[MAIR_EL2],	SYS_MAIR);
+	write_sysreg_el1(ctxt->sys_regs[VBAR_EL2],	SYS_VBAR);
+	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL2],SYS_CONTEXTIDR);
+	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL2],	SYS_AMAIR);
+
+	if (__vcpu_el2_e2h_is_set(ctxt)) {
+		/*
+		 * In VHE mode those registers are compatible between
+		 * EL1 and EL2.
+		 */
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL2],	SYS_SCTLR);
+		write_sysreg_el1(ctxt->sys_regs[CPTR_EL2],	SYS_CPACR);
+		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
+		write_sysreg_el1(ctxt->sys_regs[TTBR1_EL2],	SYS_TTBR1);
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL2],	SYS_TCR);
+		write_sysreg_el1(ctxt->sys_regs[CNTHCTL_EL2],	SYS_CNTKCTL);
+	} else {
+		write_sysreg_el1(translate_sctlr(ctxt->sys_regs[SCTLR_EL2]),
+				 SYS_SCTLR);
+		write_sysreg_el1(translate_cptr(ctxt->sys_regs[CPTR_EL2]),
+				 SYS_CPACR);
+		write_sysreg_el1(translate_ttbr0(ctxt->sys_regs[TTBR0_EL2]),
+				 SYS_TTBR0);
+		write_sysreg_el1(translate_tcr(ctxt->sys_regs[TCR_EL2]),
+				 SYS_TCR);
+		write_sysreg_el1(translate_cnthctl(ctxt->sys_regs[CNTHCTL_EL2]),
+				 SYS_CNTKCTL);
+	}
+
+	/*
+	 * These registers can be modified behind our back by a fault
+	 * taken inside vEL2. Save them, always.
+	 */
+	write_sysreg_el1(ctxt->sys_regs[ESR_EL2],	SYS_ESR);
+	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL2],	SYS_AFSR0);
+	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL2],	SYS_AFSR1);
+	write_sysreg_el1(ctxt->sys_regs[FAR_EL2],	SYS_FAR);
+	write_sysreg(ctxt->sys_regs[SP_EL2],		sp_el1);
+	write_sysreg_el1(ctxt->sys_regs[ELR_EL2],	SYS_ELR);
+
+	val = __fixup_spsr_el2_write(ctxt, ctxt->sys_regs[SPSR_EL2]);
+	write_sysreg_el1(val,	SYS_SPSR);
+}
+
+static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
+{
+	u64 mpidr;
+
+	if (has_vhe()) {
+		struct kvm_vcpu *vcpu;
+
+		/*
+		 * Warning: this hack only works on VHE, because we only
+		 * call this with the *guest* context, which is part of
+		 * struct kvm_vcpu. On a host context, you'd get pure junk.
+		 */
+		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
+
+		if (nested_virt_in_use(vcpu)) {
+			/*
+			 * Only set VPIDR_EL2 for nested VMs, as this is the
+			 * only time it changes. We'll restore the MIDR_EL1
+			 * view on put.
+			 */
+			write_sysreg(ctxt->sys_regs[VPIDR_EL2],	vpidr_el2);
+
+			/*
+			 * As we're restoring a nested guest, set the value
+			 * provided by the guest hypervisor.
+			 */
+			mpidr = ctxt->sys_regs[VMPIDR_EL2];
+		} else {
+			mpidr = ctxt->sys_regs[MPIDR_EL1];
+		}
+	} else {
+		mpidr = ctxt->sys_regs[MPIDR_EL1];
+	}
+
+	write_sysreg(mpidr,				vmpidr_el2);
 	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
 	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
 	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
@@ -151,6 +275,19 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
 }
 
+static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
+{
+	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
+	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
+	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
+	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
+
+	if (__is_hyp_ctxt(ctxt))
+		__sysreg_restore_vel2_state(ctxt);
+	else
+		__sysreg_restore_vel1_state(ctxt);
+}
+
 static void __hyp_text
 __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
@@ -307,6 +444,15 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
+	/*
+	 * If leaving a nesting guest, restore MPIDR_EL1 default view. It is
+	 * slightly ugly to do it here, but the alternative is to penalize
+	 * all non-nesting guests by forcing this on every load. Instead, we
+	 * choose to only penalize nesting VMs.
+	 */
+	if (nested_virt_in_use(vcpu))
+		write_sysreg(read_cpuid_id(),	vpidr_el2);
+
 	vcpu->arch.sysregs_loaded_on_cpu = false;
 }
 
-- 
2.20.1

