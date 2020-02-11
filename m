Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960A2159716
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgBKRwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbgBKRwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:52:53 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B4A220578;
        Tue, 11 Feb 2020 17:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443571;
        bh=WOGfIiGa8LmQbXWRddZTVbs63o9xNFRhXD3mTs4iyeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KyB9IqLM9pbbXbrrHK5zR8gsdUzwYUGqKNuUQJQZCyNlEIXudGqub9JlDKbwJ2Pr
         0Yd94oGx97ho1E7NbgBo7a5ZGx9qWtCSp9fvXtQsuD+H/UGFSicelZmlz00Fy2bWQL
         M5N3fyXuT/PaG2ZWWX18K0Iky9H0vdfScxqyPDPU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgB-004O7k-UT; Tue, 11 Feb 2020 17:50:36 +0000
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
Subject: [PATCH v2 72/94] KVM: arm64: sysreg: Use ctxt_sys_reg() instead of raw sys_regs access
Date:   Tue, 11 Feb 2020 17:49:16 +0000
Message-Id: <20200211174938.27809-73-maz@kernel.org>
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

Now that we have a wrapper for the sysreg accesses, let's use that
consistently.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |   6 +-
 arch/arm64/include/asm/kvm_host.h    |   2 +-
 arch/arm64/kvm/hyp/at.c              |  30 ++---
 arch/arm64/kvm/hyp/switch.c          |   6 +-
 arch/arm64/kvm/hyp/sysreg-sr.c       | 192 +++++++++++++--------------
 5 files changed, 118 insertions(+), 118 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1ccd98b5fead..1ff1735ff2b3 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -244,7 +244,7 @@ static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
 
 static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
 {
-	return ctxt->sys_regs[HCR_EL2] & HCR_E2H;
+	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
 }
 
 static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
@@ -254,7 +254,7 @@ static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
 
 static inline bool __vcpu_el2_tge_is_set(const struct kvm_cpu_context *ctxt)
 {
-	return ctxt->sys_regs[HCR_EL2] & HCR_TGE;
+	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_TGE;
 }
 
 static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
@@ -303,7 +303,7 @@ static inline u64 __fixup_spsr_el2_read(const struct kvm_cpu_context *ctxt, u64
 	 * register has still the value we saved on the last write.
 	 */
 	if ((val & 0xc) == 0)
-		return ctxt->sys_regs[SPSR_EL2];
+		return ctxt_sys_reg(ctxt, SPSR_EL2);
 
 	/*
 	 * Otherwise there was a "local" exception on the CPU,
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 00748ceb9769..83ed3865dda8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -609,7 +609,7 @@ DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
-	cpu_ctxt->sys_regs[MPIDR_EL1] = read_cpuid_mpidr();
+	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
 }
 
 void __kvm_enable_ssbs(void);
diff --git a/arch/arm64/kvm/hyp/at.c b/arch/arm64/kvm/hyp/at.c
index 9fdb87fa3597..a703e811291a 100644
--- a/arch/arm64/kvm/hyp/at.c
+++ b/arch/arm64/kvm/hyp/at.c
@@ -83,10 +83,10 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	/* We've trapped, so everything is live on the CPU. */
 	__mmu_config_save(&config);
 
-	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
-	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
-	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
-	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1),	SYS_TTBR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1),	SYS_TTBR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
 	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
 	/*
 	 * REVISIT: do we need anything from the guest's VTCR_EL2? If
@@ -122,7 +122,7 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	isb();
 
-	ctxt->sys_regs[PAR_EL1] = read_sysreg(par_el1);
+	ctxt_sys_reg(ctxt, PAR_EL1) = read_sysreg(par_el1);
 
 	/*
 	 * Failed? let's leave the building now.
@@ -131,7 +131,7 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 * wasn't populated? We may need to perform a SW PTW,
 	 * populating our shadow S2 and retry the instruction.
 	 */
-	if (ctxt->sys_regs[PAR_EL1] & 1)
+	if (ctxt_sys_reg(ctxt, PAR_EL1) & 1)
 		goto nopan;
 
 	/* No PAN? No problem. */
@@ -162,7 +162,7 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 * should return the real fault level.
 	 */
 	if (!(read_sysreg(par_el1) & 1))
-		ctxt->sys_regs[PAR_EL1] = 0x1f;
+		ctxt_sys_reg(ctxt, PAR_EL1) = 0x1f;
 
 nopan:
 	if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
@@ -187,17 +187,17 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	__mmu_config_save(&config);
 
 	if (vcpu_el2_e2h_is_set(vcpu)) {
-		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
-		write_sysreg_el1(ctxt->sys_regs[TTBR1_EL2],	SYS_TTBR1);
-		write_sysreg_el1(ctxt->sys_regs[TCR_EL2],	SYS_TCR);
-		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL2],	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL2),	SYS_TTBR0);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL2),	SYS_TTBR1);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL2),	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL2),	SYS_SCTLR);
 
 		val = config.hcr;
 	} else {
-		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
-		write_sysreg_el1(translate_tcr(ctxt->sys_regs[TCR_EL2]),
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL2),	SYS_TTBR0);
+		write_sysreg_el1(translate_tcr(ctxt_sys_reg(ctxt, TCR_EL2)),
 				 SYS_TCR);
-		write_sysreg_el1(translate_sctlr(ctxt->sys_regs[SCTLR_EL2]),
+		write_sysreg_el1(translate_sctlr(ctxt_sys_reg(ctxt, SCTLR_EL2)),
 				 SYS_SCTLR);
 
 		val = config.hcr | HCR_NV | HCR_NV1;
@@ -224,7 +224,7 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	isb();
 
 	/* FIXME: handle failed translation due to shadow S2 */
-	ctxt->sys_regs[PAR_EL1] = read_sysreg(par_el1);
+	ctxt_sys_reg(ctxt, PAR_EL1) = read_sysreg(par_el1);
 
 	__mmu_config_restore(&config);
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 97c5c1a791b8..c5405fa68bc9 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -138,9 +138,9 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 		 * configured and enabled. We can now restore the guest's S1
 		 * configuration: SCTLR, and only then TCR.
 		 */
-		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
 		isb();
-		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 	}
 }
 
@@ -463,7 +463,7 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		sve_load_state(vcpu_sve_pffr(vcpu),
 			       &vcpu->arch.ctxt.gp_regs.fp_regs.fpsr,
 			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
-		write_sysreg_s(vcpu->arch.ctxt.sys_regs[ZCR_EL1], SYS_ZCR_EL12);
+		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
 	} else {
 		__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
 	}
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 384f0da6b4f3..df9ca6fdf3fb 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -26,7 +26,7 @@
 
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
+	ctxt_sys_reg(ctxt, MDSCR_EL1)	= read_sysreg(mdscr_el1);
 
 	/*
 	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
@@ -37,26 +37,26 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 
 static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
-	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
+	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
+	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
 }
 
 static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
-	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(SYS_CPACR);
-	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(SYS_TTBR0);
-	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(SYS_TTBR1);
-	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(SYS_TCR);
-	ctxt->sys_regs[ESR_EL1]		= read_sysreg_el1(SYS_ESR);
-	ctxt->sys_regs[AFSR0_EL1]	= read_sysreg_el1(SYS_AFSR0);
-	ctxt->sys_regs[AFSR1_EL1]	= read_sysreg_el1(SYS_AFSR1);
-	ctxt->sys_regs[FAR_EL1]		= read_sysreg_el1(SYS_FAR);
-	ctxt->sys_regs[MAIR_EL1]	= read_sysreg_el1(SYS_MAIR);
-	ctxt->sys_regs[VBAR_EL1]	= read_sysreg_el1(SYS_VBAR);
-	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(SYS_CONTEXTIDR);
-	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(SYS_AMAIR);
-	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(SYS_CNTKCTL);
+	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
+	ctxt_sys_reg(ctxt, CPACR_EL1)	= read_sysreg_el1(SYS_CPACR);
+	ctxt_sys_reg(ctxt, TTBR0_EL1)	= read_sysreg_el1(SYS_TTBR0);
+	ctxt_sys_reg(ctxt, TTBR1_EL1)	= read_sysreg_el1(SYS_TTBR1);
+	ctxt_sys_reg(ctxt, TCR_EL1)	= read_sysreg_el1(SYS_TCR);
+	ctxt_sys_reg(ctxt, ESR_EL1)	= read_sysreg_el1(SYS_ESR);
+	ctxt_sys_reg(ctxt, AFSR0_EL1)	= read_sysreg_el1(SYS_AFSR0);
+	ctxt_sys_reg(ctxt, AFSR1_EL1)	= read_sysreg_el1(SYS_AFSR1);
+	ctxt_sys_reg(ctxt, FAR_EL1)	= read_sysreg_el1(SYS_FAR);
+	ctxt_sys_reg(ctxt, MAIR_EL1)	= read_sysreg_el1(SYS_MAIR);
+	ctxt_sys_reg(ctxt, VBAR_EL1)	= read_sysreg_el1(SYS_VBAR);
+	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
+	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
+	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
 
 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
 	ctxt->gp_regs.elr_el1		= read_sysreg_el1(SYS_ELR);
@@ -65,14 +65,14 @@ static void __hyp_text __sysreg_save_vel1_state(struct kvm_cpu_context *ctxt)
 
 static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[ESR_EL2]		= read_sysreg_el1(SYS_ESR);
-	ctxt->sys_regs[AFSR0_EL2]	= read_sysreg_el1(SYS_AFSR0);
-	ctxt->sys_regs[AFSR1_EL2]	= read_sysreg_el1(SYS_AFSR1);
-	ctxt->sys_regs[FAR_EL2]		= read_sysreg_el1(SYS_FAR);
-	ctxt->sys_regs[MAIR_EL2]	= read_sysreg_el1(SYS_MAIR);
-	ctxt->sys_regs[VBAR_EL2]	= read_sysreg_el1(SYS_VBAR);
-	ctxt->sys_regs[CONTEXTIDR_EL2]	= read_sysreg_el1(SYS_CONTEXTIDR);
-	ctxt->sys_regs[AMAIR_EL2]	= read_sysreg_el1(SYS_AMAIR);
+	ctxt_sys_reg(ctxt, ESR_EL2)	= read_sysreg_el1(SYS_ESR);
+	ctxt_sys_reg(ctxt, AFSR0_EL2)	= read_sysreg_el1(SYS_AFSR0);
+	ctxt_sys_reg(ctxt, AFSR1_EL2)	= read_sysreg_el1(SYS_AFSR1);
+	ctxt_sys_reg(ctxt, FAR_EL2)	= read_sysreg_el1(SYS_FAR);
+	ctxt_sys_reg(ctxt, MAIR_EL2)	= read_sysreg_el1(SYS_MAIR);
+	ctxt_sys_reg(ctxt, VBAR_EL2)	= read_sysreg_el1(SYS_VBAR);
+	ctxt_sys_reg(ctxt, CONTEXTIDR_EL2) = read_sysreg_el1(SYS_CONTEXTIDR);
+	ctxt_sys_reg(ctxt, AMAIR_EL2)	= read_sysreg_el1(SYS_AMAIR);
 
 	/*
 	 * In VHE mode those registers are compatible between EL1 and EL2,
@@ -83,25 +83,25 @@ static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
 	 * to save anything here.
 	 */
 	if (__vcpu_el2_e2h_is_set(ctxt)) {
-		ctxt->sys_regs[SCTLR_EL2]	= read_sysreg_el1(SYS_SCTLR);
-		ctxt->sys_regs[CPTR_EL2]	= read_sysreg_el1(SYS_CPACR);
-		ctxt->sys_regs[TTBR0_EL2]	= read_sysreg_el1(SYS_TTBR0);
-		ctxt->sys_regs[TTBR1_EL2]	= read_sysreg_el1(SYS_TTBR1);
-		ctxt->sys_regs[TCR_EL2]		= read_sysreg_el1(SYS_TCR);
-		ctxt->sys_regs[CNTHCTL_EL2]	= read_sysreg_el1(SYS_CNTKCTL);
+		ctxt_sys_reg(ctxt, SCTLR_EL2)	= read_sysreg_el1(SYS_SCTLR);
+		ctxt_sys_reg(ctxt, CPTR_EL2)	= read_sysreg_el1(SYS_CPACR);
+		ctxt_sys_reg(ctxt, TTBR0_EL2)	= read_sysreg_el1(SYS_TTBR0);
+		ctxt_sys_reg(ctxt, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
+		ctxt_sys_reg(ctxt, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
+		ctxt_sys_reg(ctxt, CNTHCTL_EL2)	= read_sysreg_el1(SYS_CNTKCTL);
 	}
 
-	ctxt->sys_regs[SP_EL2]		= read_sysreg(sp_el1);
-	ctxt->sys_regs[ELR_EL2]		= read_sysreg_el1(SYS_ELR);
-	ctxt->sys_regs[SPSR_EL2]	= __fixup_spsr_el2_read(ctxt, read_sysreg_el1(SYS_SPSR));
+	ctxt_sys_reg(ctxt, SP_EL2)	= read_sysreg(sp_el1);
+	ctxt_sys_reg(ctxt, ELR_EL2)	= read_sysreg_el1(SYS_ELR);
+	ctxt_sys_reg(ctxt, SPSR_EL2)	= __fixup_spsr_el2_read(ctxt, read_sysreg_el1(SYS_SPSR));
 }
 
 static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
-	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
-	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
+	ctxt_sys_reg(ctxt, CSSELR_EL1)	= read_sysreg(csselr_el1);
+	ctxt_sys_reg(ctxt, ACTLR_EL1)	= read_sysreg(actlr_el1);
+	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg(par_el1);
+	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
 
 	if (unlikely(__is_hyp_ctxt(ctxt)))
 		__sysreg_save_vel2_state(ctxt);
@@ -137,7 +137,7 @@ static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ct
 	ctxt->gp_regs.regs.pstate	= from_hw_pstate(ctxt);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
-		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
+		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
 }
 
 void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
@@ -163,7 +163,7 @@ NOKPROBE_SYMBOL(sysreg_save_guest_state_vhe);
 
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, MDSCR_EL1),  mdscr_el1);
 
 	/*
 	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
@@ -174,8 +174,8 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
 
 static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[TPIDR_EL0],		tpidr_el0);
-	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),	tpidr_el0);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
 }
 
 static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
@@ -183,33 +183,33 @@ static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
 	u64 val;
 
 	write_sysreg(read_cpuid_id(),			vpidr_el2);
-	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
-	write_sysreg_el1(ctxt->sys_regs[MAIR_EL2],	SYS_MAIR);
-	write_sysreg_el1(ctxt->sys_regs[VBAR_EL2],	SYS_VBAR);
-	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL2],SYS_CONTEXTIDR);
-	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL2],	SYS_AMAIR);
+	write_sysreg(ctxt_sys_reg(ctxt, MPIDR_EL1),	vmpidr_el2);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, MAIR_EL2),	SYS_MAIR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, VBAR_EL2),	SYS_VBAR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL2),SYS_CONTEXTIDR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL2),	SYS_AMAIR);
 
 	if (__vcpu_el2_e2h_is_set(ctxt)) {
 		/*
 		 * In VHE mode those registers are compatible between
 		 * EL1 and EL2.
 		 */
-		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL2],	SYS_SCTLR);
-		write_sysreg_el1(ctxt->sys_regs[CPTR_EL2],	SYS_CPACR);
-		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
-		write_sysreg_el1(ctxt->sys_regs[TTBR1_EL2],	SYS_TTBR1);
-		write_sysreg_el1(ctxt->sys_regs[TCR_EL2],	SYS_TCR);
-		write_sysreg_el1(ctxt->sys_regs[CNTHCTL_EL2],	SYS_CNTKCTL);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL2),	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, CPTR_EL2),	SYS_CPACR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL2),	SYS_TTBR0);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL2),	SYS_TTBR1);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL2),	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, CNTHCTL_EL2), SYS_CNTKCTL);
 	} else {
-		write_sysreg_el1(translate_sctlr(ctxt->sys_regs[SCTLR_EL2]),
+		write_sysreg_el1(translate_sctlr(ctxt_sys_reg(ctxt, SCTLR_EL2)),
 				 SYS_SCTLR);
-		write_sysreg_el1(translate_cptr(ctxt->sys_regs[CPTR_EL2]),
+		write_sysreg_el1(translate_cptr(ctxt_sys_reg(ctxt, CPTR_EL2)),
 				 SYS_CPACR);
-		write_sysreg_el1(translate_ttbr0(ctxt->sys_regs[TTBR0_EL2]),
+		write_sysreg_el1(translate_ttbr0(ctxt_sys_reg(ctxt, TTBR0_EL2)),
 				 SYS_TTBR0);
-		write_sysreg_el1(translate_tcr(ctxt->sys_regs[TCR_EL2]),
+		write_sysreg_el1(translate_tcr(ctxt_sys_reg(ctxt, TCR_EL2)),
 				 SYS_TCR);
-		write_sysreg_el1(translate_cnthctl(ctxt->sys_regs[CNTHCTL_EL2]),
+		write_sysreg_el1(translate_cnthctl(ctxt_sys_reg(ctxt, CNTHCTL_EL2)),
 				 SYS_CNTKCTL);
 	}
 
@@ -217,14 +217,14 @@ static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
 	 * These registers can be modified behind our back by a fault
 	 * taken inside vEL2. Save them, always.
 	 */
-	write_sysreg_el1(ctxt->sys_regs[ESR_EL2],	SYS_ESR);
-	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL2],	SYS_AFSR0);
-	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL2],	SYS_AFSR1);
-	write_sysreg_el1(ctxt->sys_regs[FAR_EL2],	SYS_FAR);
-	write_sysreg(ctxt->sys_regs[SP_EL2],		sp_el1);
-	write_sysreg_el1(ctxt->sys_regs[ELR_EL2],	SYS_ELR);
-
-	val = __fixup_spsr_el2_write(ctxt, ctxt->sys_regs[SPSR_EL2]);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL2),	SYS_ESR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL2),	SYS_AFSR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL2),	SYS_AFSR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, FAR_EL2),	SYS_FAR);
+	write_sysreg(ctxt_sys_reg(ctxt, SP_EL2),	sp_el1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL2),	SYS_ELR);
+
+	val = __fixup_spsr_el2_write(ctxt, ctxt_sys_reg(ctxt, SPSR_EL2));
 	write_sysreg_el1(val,	SYS_SPSR);
 }
 
@@ -258,53 +258,53 @@ static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
 			 * only time it changes. We'll restore the MIDR_EL1
 			 * view on put.
 			 */
-			write_sysreg(ctxt->sys_regs[VPIDR_EL2],	vpidr_el2);
+			write_sysreg(ctxt_sys_reg(ctxt, VPIDR_EL2),	vpidr_el2);
 
 			/*
 			 * As we're restoring a nested guest, set the value
 			 * provided by the guest hypervisor.
 			 */
-			mpidr = ctxt->sys_regs[VMPIDR_EL2];
+			mpidr = ctxt_sys_reg(ctxt, VMPIDR_EL2);
 		} else {
-			mpidr = ctxt->sys_regs[MPIDR_EL1];
+			mpidr = ctxt_sys_reg(ctxt, MPIDR_EL1);
 		}
 	} else {
-		mpidr = ctxt->sys_regs[MPIDR_EL1];
+		mpidr = ctxt_sys_reg(ctxt, MPIDR_EL1);
 	}
 
 	write_sysreg(mpidr,				vmpidr_el2);
-	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
 
 	if (!cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
-		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
-		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 	} else	if (!ctxt->__hyp_running_vcpu) {
 		/*
 		 * Must only be done for guest registers, hence the context
 		 * test. We're coming from the host, so SCTLR.M is already
 		 * set. Pairs with __activate_traps_nvhe().
 		 */
-		write_sysreg_el1((ctxt->sys_regs[TCR_EL1] |
+		write_sysreg_el1((ctxt_sys_reg(ctxt, TCR_EL1) |
 				  TCR_EPD1_MASK | TCR_EPD0_MASK),
 				 SYS_TCR);
 		isb();
 	}
 
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
-	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
-	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
-	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
-	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	SYS_ESR);
-	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	SYS_AFSR0);
-	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	SYS_AFSR1);
-	write_sysreg_el1(ctxt->sys_regs[FAR_EL1],	SYS_FAR);
-	write_sysreg_el1(ctxt->sys_regs[MAIR_EL1],	SYS_MAIR);
-	write_sysreg_el1(ctxt->sys_regs[VBAR_EL1],	SYS_VBAR);
-	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL1],SYS_CONTEXTIDR);
-	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	SYS_AMAIR);
-	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1],	SYS_CNTKCTL);
-	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, ACTLR_EL1),		actlr_el1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CPACR_EL1),	SYS_CPACR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1),	SYS_TTBR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1),	SYS_TTBR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL1),	SYS_ESR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL1),	SYS_AFSR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL1),	SYS_AFSR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, FAR_EL1),	SYS_FAR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, MAIR_EL1),	SYS_MAIR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, VBAR_EL1),	SYS_VBAR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL1),SYS_CONTEXTIDR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL1),	SYS_AMAIR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CNTKCTL_EL1),	SYS_CNTKCTL);
+	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),		par_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),		tpidr_el1);
 
 	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE) &&
 	    ctxt->__hyp_running_vcpu) {
@@ -318,9 +318,9 @@ static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
 		 * deconfigured and disabled. We can now restore the host's
 		 * S1 configuration: SCTLR, and only then TCR.
 		 */
-		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
 		isb();
-		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
 	}
 
 	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
@@ -330,10 +330,10 @@ static void __hyp_text __sysreg_restore_vel1_state(struct kvm_cpu_context *ctxt)
 
 static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
-	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, CSSELR_EL1),	csselr_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, ACTLR_EL1),	actlr_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
 
 	if (__is_hyp_ctxt(ctxt))
 		__sysreg_restore_vel2_state(ctxt);
@@ -382,7 +382,7 @@ __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
-		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
+		write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
 }
 
 void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
-- 
2.20.1

