Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54D749F946
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348460AbiA1MUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36636 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242767AbiA1MUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69AFD61AF8
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DB5C36AE2;
        Fri, 28 Jan 2022 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372422;
        bh=9bXg9v7rTqWT8enTAvdmWGbMYpWCvjSjcbQOWMhR6TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELgb6cRT1i0OvDNsMJOlfKdFe7ecdone826Fc+tiMPTrh7mYpsuZ5gNEPeTHkfwNt
         53/oM6K/VFkyvjPkwSSQRGWKgQW/ELI6deCDKLkAS7u/8A0MUvB6DCsEo6hDB3werE
         KzPWRk1YKu6dVoJOjHdIa6bRXOLzYRtiFQ9ktgPGMYr276kV/esf9Pa8WyAh9e6jgS
         aGjU75mLcKv+OQ92sxmGI6uphUDEGV8Tw6wXkkzcDSJw7ZP1jS5joFMyyiGHPH6aGZ
         jT47uP4ZlK+Le7CXQWN5jL94p8jn7xAPbl7pInrGAKX09/5UsaZPndruMy2TnU1VR6
         N8x/GsBaPBhGA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDy-003njR-0m; Fri, 28 Jan 2022 12:19:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 16/64] KVM: arm64: nv: Save/Restore vEL2 sysregs
Date:   Fri, 28 Jan 2022 12:18:24 +0000
Message-Id: <20220128121912.509006-17-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whenever we need to restore the guest's system registers to the CPU, we
now need to take care of the EL2 system registers as well. Most of them
are accessed via traps only, but some have an immediate effect and also
a guest running in VHE mode would expect them to be accessible via their
EL1 encoding, which we do not trap.

For vEL2 we write the virtual EL2 registers with an identical format directly
into their EL1 counterpart, and translate the few registers that have a
different format for the same effect on the execution when running a
non-VHE guest guest hypervisor.

Based on an initial patch from Andre Przywara, rewritten many times
since.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 125 ++++++++++++++++++++-
 3 files changed, 127 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 7ecca8b07851..283f780f5f56 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -92,9 +92,10 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
 }
 
-static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
+					      u64 mpidr)
 {
-	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);
+	write_sysreg(mpidr,				vmpidr_el2);
 	write_sysreg(ctxt_sys_reg(ctxt, CSSELR_EL1),	csselr_el1);
 
 	if (has_vhe() ||
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
index 29305022bc04..dba101565de3 100644
--- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -28,7 +28,7 @@ void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_el1_state(ctxt, ctxt_sys_reg(ctxt, MPIDR_EL1));
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 007a12dd4351..3e26a78d00c5 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -13,6 +13,96 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
+
+static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
+{
+	/* These registers are common with EL1 */
+	ctxt_sys_reg(ctxt, CSSELR_EL1)	= read_sysreg(csselr_el1);
+	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg(par_el1);
+	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
+
+	ctxt_sys_reg(ctxt, ESR_EL2)	= read_sysreg_el1(SYS_ESR);
+	ctxt_sys_reg(ctxt, AFSR0_EL2)	= read_sysreg_el1(SYS_AFSR0);
+	ctxt_sys_reg(ctxt, AFSR1_EL2)	= read_sysreg_el1(SYS_AFSR1);
+	ctxt_sys_reg(ctxt, FAR_EL2)	= read_sysreg_el1(SYS_FAR);
+	ctxt_sys_reg(ctxt, MAIR_EL2)	= read_sysreg_el1(SYS_MAIR);
+	ctxt_sys_reg(ctxt, VBAR_EL2)	= read_sysreg_el1(SYS_VBAR);
+	ctxt_sys_reg(ctxt, CONTEXTIDR_EL2) = read_sysreg_el1(SYS_CONTEXTIDR);
+	ctxt_sys_reg(ctxt, AMAIR_EL2)	= read_sysreg_el1(SYS_AMAIR);
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
+		ctxt_sys_reg(ctxt, SCTLR_EL2)	= read_sysreg_el1(SYS_SCTLR);
+		ctxt_sys_reg(ctxt, CPTR_EL2)	= read_sysreg_el1(SYS_CPACR);
+		ctxt_sys_reg(ctxt, TTBR0_EL2)	= read_sysreg_el1(SYS_TTBR0);
+		ctxt_sys_reg(ctxt, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
+		ctxt_sys_reg(ctxt, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
+		ctxt_sys_reg(ctxt, CNTHCTL_EL2)	= read_sysreg_el1(SYS_CNTKCTL);
+	}
+
+	ctxt_sys_reg(ctxt, SP_EL2)	= read_sysreg(sp_el1);
+	ctxt_sys_reg(ctxt, ELR_EL2)	= read_sysreg_el1(SYS_ELR);
+	ctxt_sys_reg(ctxt, SPSR_EL2)	= __fixup_spsr_el2_read(ctxt, read_sysreg_el1(SYS_SPSR));
+}
+
+static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
+{
+	u64 val;
+
+	/* These registers are common with EL1 */
+	write_sysreg(ctxt_sys_reg(ctxt, CSSELR_EL1),	csselr_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
+
+	write_sysreg(read_cpuid_id(),			vpidr_el2);
+	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, MAIR_EL2),	SYS_MAIR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, VBAR_EL2),	SYS_VBAR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL2),SYS_CONTEXTIDR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL2),	SYS_AMAIR);
+
+	if (__vcpu_el2_e2h_is_set(ctxt)) {
+		/*
+		 * In VHE mode those registers are compatible between
+		 * EL1 and EL2.
+		 */
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL2),	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, CPTR_EL2),	SYS_CPACR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL2),	SYS_TTBR0);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL2),	SYS_TTBR1);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL2),	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, CNTHCTL_EL2), SYS_CNTKCTL);
+	} else {
+		val = translate_sctlr_el2_to_sctlr_el1(ctxt_sys_reg(ctxt, SCTLR_EL2));
+		write_sysreg_el1(val, SYS_SCTLR);
+		val = translate_cptr_el2_to_cpacr_el1(ctxt_sys_reg(ctxt, CPTR_EL2));
+		write_sysreg_el1(val, SYS_CPACR);
+		val = translate_ttbr0_el2_to_ttbr0_el1(ctxt_sys_reg(ctxt, TTBR0_EL2));
+		write_sysreg_el1(val, SYS_TTBR0);
+		val = translate_tcr_el2_to_tcr_el1(ctxt_sys_reg(ctxt, TCR_EL2));
+		write_sysreg_el1(val, SYS_TCR);
+		val = translate_cnthctl_el2_to_cntkctl_el1(ctxt_sys_reg(ctxt, CNTHCTL_EL2));
+		write_sysreg_el1(val, SYS_CNTKCTL);
+	}
+
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL2),	SYS_ESR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL2),	SYS_AFSR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL2),	SYS_AFSR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, FAR_EL2),	SYS_FAR);
+	write_sysreg(ctxt_sys_reg(ctxt, SP_EL2),	sp_el1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL2),	SYS_ELR);
+
+	val = __fixup_spsr_el2_write(ctxt, ctxt_sys_reg(ctxt, SPSR_EL2));
+	write_sysreg_el1(val,	SYS_SPSR);
+}
 
 /*
  * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
@@ -65,6 +155,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
+	u64 mpidr;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	__sysreg_save_user_state(host_ctxt);
@@ -77,7 +168,29 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_user_state(guest_ctxt);
-	__sysreg_restore_el1_state(guest_ctxt);
+
+	if (unlikely(__is_hyp_ctxt(guest_ctxt))) {
+		__sysreg_restore_vel2_state(guest_ctxt);
+	} else {
+		if (vcpu_has_nv(vcpu)) {
+			/*
+			 * Only set VPIDR_EL2 for nested VMs, as this is the
+			 * only time it changes. We'll restore the MIDR_EL1
+			 * view on put.
+			 */
+			write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2), vpidr_el2);
+
+			/*
+			 * As we're restoring a nested guest, set the value
+			 * provided by the guest hypervisor.
+			 */
+			mpidr = ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
+		} else {
+			mpidr = ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
+		}
+
+		__sysreg_restore_el1_state(guest_ctxt, mpidr);
+	}
 
 	vcpu->arch.sysregs_loaded_on_cpu = true;
 
@@ -103,12 +216,20 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	deactivate_traps_vhe_put(vcpu);
 
-	__sysreg_save_el1_state(guest_ctxt);
+	if (unlikely(__is_hyp_ctxt(guest_ctxt)))
+		__sysreg_save_vel2_state(guest_ctxt);
+	else
+		__sysreg_save_el1_state(guest_ctxt);
+
 	__sysreg_save_user_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
+	/* If leaving a nesting guest, restore MPIDR_EL1 default view */
+	if (vcpu_has_nv(vcpu))
+		write_sysreg(read_cpuid_id(),	vpidr_el2);
+
 	vcpu->arch.sysregs_loaded_on_cpu = false;
 }
-- 
2.30.2

