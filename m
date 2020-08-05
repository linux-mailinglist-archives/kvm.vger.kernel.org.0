Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE8823CEAA
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHESyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729249AbgHESaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2EE422EBE;
        Wed,  5 Aug 2020 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652030;
        bh=qp3vGyVS8xNBN5TVEkt/NeQ+hfrBua50rHsa+h31m5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUhFgXcePjByMI997X16V3Ud4czoDDy1qmKpA3CPVyCOPZKkR5C7Nb/AEOUInXlZK
         3UjqDRL1JY0XHQGkMNxECHZPsHqmXKy1RBSvj/CffWJjrR0YPjUObyhAjfYReKcAQ0
         Or+vpyXUXGF7t0DewzpUc5f5b1qQA0m9sLx9jV3U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfX-0004w9-VC; Wed, 05 Aug 2020 18:57:40 +0100
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
Subject: [PATCH 23/56] KVM: arm64: Split hyp/sysreg-sr.c to VHE/nVHE
Date:   Wed,  5 Aug 2020 18:56:27 +0100
Message-Id: <20200805175700.62775-24-maz@kernel.org>
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

From: David Brazdil <dbrazdil@google.com>

sysreg-sr.c contains KVM's code for saving/restoring system registers, with
some code shared between VHE/nVHE. These common routines are moved to
a header file, VHE-specific code is moved to vhe/sysreg-sr.c and nVHE-specific
code to nvhe/sysreg-sr.c.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-12-dbrazdil@google.com
---
 arch/arm64/include/asm/kvm_host.h             |   6 +-
 arch/arm64/include/asm/kvm_hyp.h              |   5 +-
 arch/arm64/kernel/image-vars.h                |   7 -
 arch/arm64/kvm/arm.c                          |   8 +-
 arch/arm64/kvm/hyp/Makefile                   |   4 +-
 .../{sysreg-sr.c => include/hyp/sysreg-sr.h}  | 158 ++----------------
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |  46 +++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 114 +++++++++++++
 12 files changed, 191 insertions(+), 164 deletions(-)
 rename arch/arm64/kvm/hyp/{sysreg-sr.c => include/hyp/sysreg-sr.h} (56%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/sysreg-sr.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 49d1a5cd8f8f..e0920df1d0c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -338,7 +338,7 @@ struct kvm_vcpu_arch {
 	struct vcpu_reset_state	reset_state;
 
 	/* True when deferrable sysregs are loaded on the physical CPU,
-	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
+	 * see kvm_vcpu_load_sysregs_vhe and kvm_vcpu_put_sysregs_vhe. */
 	bool sysregs_loaded_on_cpu;
 
 	/* Guest PV state */
@@ -639,8 +639,8 @@ static inline int kvm_arm_have_ssbd(void)
 	}
 }
 
-void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
-void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
+void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu);
 
 int kvm_set_ipa_limit(void);
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 82fa05d15b8b..997c5bda1ac7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -66,14 +66,15 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
 void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt);
+#else
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
-void __sysreg32_save_state(struct kvm_vcpu *vcpu);
-void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
+#endif
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c44ca4e7dd66..59eb55893eaf 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -76,13 +76,6 @@ KVM_NVHE_ALIAS(abort_guest_exit_start);
 KVM_NVHE_ALIAS(__fpsimd_restore_state);
 KVM_NVHE_ALIAS(__fpsimd_save_state);
 
-/* Symbols defined in sysreg-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__kvm_enable_ssbs);
-KVM_NVHE_ALIAS(__sysreg32_restore_state);
-KVM_NVHE_ALIAS(__sysreg32_save_state);
-KVM_NVHE_ALIAS(__sysreg_restore_state_nvhe);
-KVM_NVHE_ALIAS(__sysreg_save_state_nvhe);
-
 /* Symbols defined in timer-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_timer_set_cntvoff);
 KVM_NVHE_ALIAS(__timer_disable_traps);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 26780b78a523..0bf2cf5614c6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -351,7 +351,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
-	kvm_vcpu_load_sysregs(vcpu);
+	if (has_vhe())
+		kvm_vcpu_load_sysregs_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
@@ -369,7 +370,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_vcpu_put_fp(vcpu);
-	kvm_vcpu_put_sysregs(vcpu);
+	if (has_vhe())
+		kvm_vcpu_put_sysregs_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
@@ -1302,7 +1304,7 @@ static void cpu_init_hyp_mode(void)
 	 */
 	if (this_cpu_has_cap(ARM64_SSBS) &&
 	    arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE) {
-		kvm_call_hyp(__kvm_enable_ssbs);
+		kvm_call_hyp_nvhe(__kvm_enable_ssbs);
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index fc09025d2e97..f49797237818 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -13,8 +13,8 @@ subdir-ccflags-y := -I$(incdir)				\
 obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
-hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
-	 entry.o fpsimd.o
+hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o entry.o \
+	 fpsimd.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
similarity index 56%
rename from arch/arm64/kvm/hyp/sysreg-sr.c
rename to arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 2493439a5c54..3e0585fbd403 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -4,6 +4,9 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#ifndef __ARM64_KVM_HYP_SYSREG_SR_H__
+#define __ARM64_KVM_HYP_SYSREG_SR_H__
+
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
@@ -12,30 +15,18 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-/*
- * Non-VHE: Both host and guest must save everything.
- *
- * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
- * pstate, which are handled as part of the el2 return state) on every
- * switch (sp_el0 is being dealt with in the assembly code).
- * tpidr_el0 and tpidrro_el0 only need to be switched when going
- * to host userspace or a different VCPU.  EL1 registers only need to be
- * switched when potentially going to run a different VCPU.  The latter two
- * classes are handled as part of kvm_arch_vcpu_load and kvm_arch_vcpu_put.
- */
-
-static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
 }
 
-static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
 	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
 }
 
-static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
@@ -60,7 +51,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
 }
 
-static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(SYS_SPSR);
@@ -69,39 +60,18 @@ static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ct
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
 }
 
-void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_save_el1_state(ctxt);
-	__sysreg_save_common_state(ctxt);
-	__sysreg_save_user_state(ctxt);
-	__sysreg_save_el2_return_state(ctxt);
-}
-
-void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_save_common_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_save_host_state_vhe);
-
-void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_save_common_state(ctxt);
-	__sysreg_save_el2_return_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_save_guest_state_vhe);
-
-static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
 }
 
-static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[TPIDR_EL0],		tpidr_el0);
 	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
 }
 
-static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
@@ -160,8 +130,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
 }
 
-static void __hyp_text
-__sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	u64 pstate = ctxt->gp_regs.regs.pstate;
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
@@ -187,28 +156,7 @@ __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
 }
 
-void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_restore_el1_state(ctxt);
-	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_user_state(ctxt);
-	__sysreg_restore_el2_return_state(ctxt);
-}
-
-void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_restore_common_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_restore_host_state_vhe);
-
-void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_el2_return_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
-
-void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
@@ -230,7 +178,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
 }
 
-void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
@@ -252,82 +200,4 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
 }
 
-/**
- * kvm_vcpu_load_sysregs - Load guest system registers to the physical CPU
- *
- * @vcpu: The VCPU pointer
- *
- * Load system registers that do not affect the host's execution, for
- * example EL1 system registers on a VHE system where the host kernel
- * runs at EL2.  This function is called from KVM's vcpu_load() function
- * and loading system register state early avoids having to load them on
- * every entry to the VM.
- */
-void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
-	struct kvm_cpu_context *host_ctxt;
-
-	if (!has_vhe())
-		return;
-
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	__sysreg_save_user_state(host_ctxt);
-
-	/*
-	 * Load guest EL1 and user state
-	 *
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 */
-	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_user_state(guest_ctxt);
-	__sysreg_restore_el1_state(guest_ctxt);
-
-	vcpu->arch.sysregs_loaded_on_cpu = true;
-
-	activate_traps_vhe_load(vcpu);
-}
-
-/**
- * kvm_vcpu_put_sysregs - Restore host system registers to the physical CPU
- *
- * @vcpu: The VCPU pointer
- *
- * Save guest system registers that do not affect the host's execution, for
- * example EL1 system registers on a VHE system where the host kernel
- * runs at EL2.  This function is called from KVM's vcpu_put() function
- * and deferring saving system register state until we're no longer running the
- * VCPU avoids having to save them on every exit from the VM.
- */
-void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
-	struct kvm_cpu_context *host_ctxt;
-
-	if (!has_vhe())
-		return;
-
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put();
-
-	__sysreg_save_el1_state(guest_ctxt);
-	__sysreg_save_user_state(guest_ctxt);
-	__sysreg32_save_state(vcpu);
-
-	/* Restore host user state */
-	__sysreg_restore_user_state(host_ctxt);
-
-	vcpu->arch.sysregs_loaded_on_cpu = false;
-}
-
-void __hyp_text __kvm_enable_ssbs(void)
-{
-	u64 tmp;
-
-	asm volatile(
-	"mrs	%0, sctlr_el2\n"
-	"orr	%0, %0, %1\n"
-	"msr	sctlr_el2, %0"
-	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
-}
+#endif /* __ARM64_KVM_HYP_SYSREG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b3cb67b63d67..61a8160f0dd9 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := debug-sr.o switch.o tlb.o hyp-init.o ../hyp-entry.o
+obj-y := sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7f6b8d3dc637..f08bfb951df6 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -5,6 +5,7 @@
  */
 
 #include <hyp/switch.h>
+#include <hyp/sysreg-sr.h>
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
new file mode 100644
index 000000000000..710cf28ab1ec
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2012-2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/sysreg-sr.h>
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kprobes.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+
+/*
+ * Non-VHE: Both host and guest must save everything.
+ */
+
+void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_el1_state(ctxt);
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
+}
+
+void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
+}
+
+void __hyp_text __kvm_enable_ssbs(void)
+{
+	u64 tmp;
+
+	asm volatile(
+	"mrs	%0, sctlr_el2\n"
+	"orr	%0, %0, %1\n"
+	"msr	sctlr_el2, %0"
+	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 62bdaf272b03..2801582a739a 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := debug-sr.o switch.o tlb.o ../hyp-entry.o
+obj-y := sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index e8d76cab44e4..c0d33deba77e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -120,7 +120,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * HCR_EL2.TGE.
 	 *
 	 * We have already configured the guest's stage 1 translation in
-	 * kvm_vcpu_load_sysregs above.  We must now call __activate_vm
+	 * kvm_vcpu_load_sysregs_vhe above.  We must now call __activate_vm
 	 * before __activate_traps, because __activate_vm configures
 	 * stage 2 translation, and __activate_traps clear HCR_EL2.TGE
 	 * (among other things).
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
new file mode 100644
index 000000000000..996471e4c138
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2012-2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/sysreg-sr.h>
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kprobes.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+
+/*
+ * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
+ * pstate, which are handled as part of the el2 return state) on every
+ * switch (sp_el0 is being dealt with in the assembly code).
+ * tpidr_el0 and tpidrro_el0 only need to be switched when going
+ * to host userspace or a different VCPU.  EL1 registers only need to be
+ * switched when potentially going to run a different VCPU.  The latter two
+ * classes are handled as part of kvm_arch_vcpu_load and kvm_arch_vcpu_put.
+ */
+
+void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_common_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_save_host_state_vhe);
+
+void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_save_guest_state_vhe);
+
+void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_common_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_restore_host_state_vhe);
+
+void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
+
+/**
+ * kvm_vcpu_load_sysregs_vhe - Load guest system registers to the physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * Load system registers that do not affect the host's execution, for
+ * example EL1 system registers on a VHE system where the host kernel
+ * runs at EL2.  This function is called from KVM's vcpu_load() function
+ * and loading system register state early avoids having to load them on
+ * every entry to the VM.
+ */
+void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	__sysreg_save_user_state(host_ctxt);
+
+	/*
+	 * Load guest EL1 and user state
+	 *
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_user_state(guest_ctxt);
+	__sysreg_restore_el1_state(guest_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = true;
+
+	activate_traps_vhe_load(vcpu);
+}
+
+/**
+ * kvm_vcpu_put_sysregs_vhe - Restore host system registers to the physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * Save guest system registers that do not affect the host's execution, for
+ * example EL1 system registers on a VHE system where the host kernel
+ * runs at EL2.  This function is called from KVM's vcpu_put() function
+ * and deferring saving system register state until we're no longer running the
+ * VCPU avoids having to save them on every exit from the VM.
+ */
+void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	deactivate_traps_vhe_put();
+
+	__sysreg_save_el1_state(guest_ctxt);
+	__sysreg_save_user_state(guest_ctxt);
+	__sysreg32_save_state(vcpu);
+
+	/* Restore host user state */
+	__sysreg_restore_user_state(host_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = false;
+}
-- 
2.27.0

