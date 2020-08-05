Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED16123CEA4
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgHEStM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgHESaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B73E23100;
        Wed,  5 Aug 2020 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652034;
        bh=1L2BCF17xzGHbhjTN6W/wxwEy+vs3ENuIcpSWlSmA38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBNZPw2gkqABnVhprD6+kvs+/LgZtcwmSUzSDGC2kcnbgTIFcSzwe3IQC547Z9vZY
         Tm6d5m8jmpoitFQ41USEm76kNhKqL2TeFj8aOK0NiOXbusStFdScFLSBqNFwYcw8wS
         G5b3azJUw5rP4wpxNRpSEkWXded0FfUqUWvEg3sI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfc-0004w9-Vl; Wed, 05 Aug 2020 18:57:45 +0100
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
Subject: [PATCH 26/56] KVM: arm64: Remove __hyp_text macro, use build rules instead
Date:   Wed,  5 Aug 2020 18:56:30 +0100
Message-Id: <20200805175700.62775-27-maz@kernel.org>
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

With nVHE code now fully separated from the rest of the kernel, the effects of
the __hyp_text macro (which had to be applied on all nVHE code) can be
achieved with build rules instead. The macro used to:
  (a) move code to .hyp.text ELF section, now done by renaming .text using
      `objcopy`, and
  (b) `notrace` and `__noscs` would negate effects of CC_FLAGS_FTRACE and
      CC_FLAGS_SCS, respectivelly, now those flags are  erased from
      KBUILD_CFLAGS (same way as in EFI stub).

Note that by removing __hyp_text from code shared with VHE, all VHE code is now
compiled into .text and without `notrace` and `__noscs`.

Use of '.pushsection .hyp.text' removed from assembly files as this is now also
covered by the build rules.

For MAINTAINERS: if needed to re-run, uses of macro were removed with the
following command. Formatting was fixed up manually.

  find arch/arm64/kvm/hyp -type f -name '*.c' -o -name '*.h' \
       -exec sed -i 's/ __hyp_text//g' {} +

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-15-dbrazdil@google.com
---
 arch/arm64/include/asm/kvm_emulate.h       |   2 +-
 arch/arm64/include/asm/kvm_hyp.h           |   2 -
 arch/arm64/kvm/hyp/aarch32.c               |   6 +-
 arch/arm64/kvm/hyp/entry.S                 |   1 -
 arch/arm64/kvm/hyp/fpsimd.S                |   1 -
 arch/arm64/kvm/hyp/hyp-entry.S             |   1 -
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  16 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  36 +++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  20 ++--
 arch/arm64/kvm/hyp/nvhe/Makefile           |   8 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  10 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |  18 +--
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   6 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c         |   4 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c              |  14 +--
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c            | 130 +++++++++------------
 17 files changed, 132 insertions(+), 147 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4d0f8ea600ba..269a76cd51ff 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -516,7 +516,7 @@ static __always_inline void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_i
  * Skip an instruction which has been emulated at hyp while most guest sysregs
  * are live.
  */
-static __always_inline void __hyp_text __kvm_skip_instr(struct kvm_vcpu *vcpu)
+static __always_inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(SYS_SPSR);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 19f8b40fe6cf..46689e7db46c 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -12,8 +12,6 @@
 #include <asm/alternative.h>
 #include <asm/sysreg.h>
 
-#define __hyp_text __section(.hyp.text) notrace __noscs
-
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/arch/arm64/kvm/hyp/aarch32.c b/arch/arm64/kvm/hyp/aarch32.c
index 25c0e47d57cb..f9ff67dfbf0b 100644
--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -44,7 +44,7 @@ static const unsigned short cc_map[16] = {
 /*
  * Check if a trapped instruction should have been executed or not.
  */
-bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
+bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 {
 	unsigned long cpsr;
 	u32 cpsr_cond;
@@ -93,7 +93,7 @@ bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
  *
  * IT[7:0] -> CPSR[26:25],CPSR[15:10]
  */
-static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
+static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 {
 	unsigned long itbits, cond;
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
@@ -123,7 +123,7 @@ static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
  * kvm_skip_instr - skip a trapped instruction and proceed to the next
  * @vcpu: The vcpu pointer
  */
-void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
+void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
 {
 	u32 pc = *vcpu_pc(vcpu);
 	bool is_thumb;
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 90186cf6473e..dfb4e6d359ab 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -21,7 +21,6 @@
 #define CPU_SP_EL0_OFFSET	(CPU_XREG_OFFSET(30) + 8)
 
 	.text
-	.pushsection	.hyp.text, "ax"
 
 /*
  * We treat x18 as callee-saved as the host may use it as a platform
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 5b8ff517ff10..01f114aa47b0 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -9,7 +9,6 @@
 #include <asm/fpsimdmacros.h>
 
 	.text
-	.pushsection	.hyp.text, "ax"
 
 SYM_FUNC_START(__fpsimd_save_state)
 	fpsimd_save	x0, 1
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 8316ee67d6a0..689fccbc9de7 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -16,7 +16,6 @@
 #include <asm/mmu.h>
 
 	.text
-	.pushsection	.hyp.text, "ax"
 
 .macro do_el2_call
 	/*
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index e041dbd23243..24e8acf9ec10 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -88,9 +88,9 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static inline void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-						 struct kvm_guest_debug_arch *dbg,
-						 struct kvm_cpu_context *ctxt)
+static inline void __debug_save_state(struct kvm_vcpu *vcpu,
+				      struct kvm_guest_debug_arch *dbg,
+				      struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -107,9 +107,9 @@ static inline void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
 	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
 }
 
-static inline void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
-						    struct kvm_guest_debug_arch *dbg,
-						    struct kvm_cpu_context *ctxt)
+static inline void __debug_restore_state(struct kvm_vcpu *vcpu,
+					 struct kvm_guest_debug_arch *dbg,
+					 struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -127,7 +127,7 @@ static inline void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-static inline void __hyp_text __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
+static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -146,7 +146,7 @@ static inline void __hyp_text __debug_switch_to_guest_common(struct kvm_vcpu *vc
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-static inline void __hyp_text __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
+static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 65d2a879b93b..8f622688fa64 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -30,7 +30,7 @@
 extern const char __hyp_panic_string[];
 
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
-static inline bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
+static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * When the system doesn't support FP/SIMD, we cannot rely on
@@ -48,7 +48,7 @@ static inline bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
 }
 
 /* Save the 32-bit only FPSIMD system register state */
-static inline void __hyp_text __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
+static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
@@ -56,7 +56,7 @@ static inline void __hyp_text __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 	vcpu->arch.ctxt.sys_regs[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
 }
 
-static inline void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
+static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * We are about to set CPTR_EL2.TFP to trap all floating point
@@ -73,7 +73,7 @@ static inline void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
+static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 {
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
@@ -89,13 +89,13 @@ static inline void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
-static inline void __hyp_text __deactivate_traps_common(void)
+static inline void __deactivate_traps_common(void)
 {
 	write_sysreg(0, hstr_el2);
 	write_sysreg(0, pmuserenr_el0);
 }
 
-static inline void __hyp_text ___activate_traps(struct kvm_vcpu *vcpu)
+static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 hcr = vcpu->arch.hcr_el2;
 
@@ -108,7 +108,7 @@ static inline void __hyp_text ___activate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
 }
 
-static inline void __hyp_text ___deactivate_traps(struct kvm_vcpu *vcpu)
+static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * If we pended a virtual abort, preserve it until it gets
@@ -122,12 +122,12 @@ static inline void __hyp_text ___deactivate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void __hyp_text __activate_vm(struct kvm *kvm)
+static inline void __activate_vm(struct kvm *kvm)
 {
 	__load_guest_stage2(kvm);
 }
 
-static inline bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
+static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 {
 	u64 par, tmp;
 
@@ -156,7 +156,7 @@ static inline bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
-static inline bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
+static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 {
 	u8 ec;
 	u64 esr;
@@ -196,7 +196,7 @@ static inline bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 }
 
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
-static inline bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
+static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
 	bool vhe, sve_guest, sve_host;
 	u8 hsr_ec;
@@ -283,7 +283,7 @@ static inline bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static inline bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
+static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 {
 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_hsr(vcpu));
 	int rt = kvm_vcpu_sys_get_rt(vcpu);
@@ -338,7 +338,7 @@ static inline bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static inline bool __hyp_text esr_is_ptrauth_trap(u32 esr)
+static inline bool esr_is_ptrauth_trap(u32 esr)
 {
 	u32 ec = ESR_ELx_EC(esr);
 
@@ -371,7 +371,7 @@ static inline bool __hyp_text esr_is_ptrauth_trap(u32 esr)
 	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
 })
 
-static inline bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
+static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *ctxt;
 	u64 val;
@@ -401,7 +401,7 @@ static inline bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  * the guest, false when we should restore the host state and return to the
  * main run loop.
  */
-static inline bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
@@ -473,7 +473,7 @@ static inline bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_
 	return false;
 }
 
-static inline bool __hyp_text __needs_ssbd_off(struct kvm_vcpu *vcpu)
+static inline bool __needs_ssbd_off(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_SSBD))
 		return false;
@@ -481,7 +481,7 @@ static inline bool __hyp_text __needs_ssbd_off(struct kvm_vcpu *vcpu)
 	return !(vcpu->arch.workaround_flags & VCPU_WORKAROUND_2_FLAG);
 }
 
-static inline void __hyp_text __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
+static inline void __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_ARM64_SSBD
 	/*
@@ -494,7 +494,7 @@ static inline void __hyp_text __set_guest_arch_workaround_state(struct kvm_vcpu
 #endif
 }
 
-static inline void __hyp_text __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
+static inline void __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_ARM64_SSBD
 	/*
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 3e0585fbd403..6e04e061f762 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -15,18 +15,18 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-static inline void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
 }
 
-static inline void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
 	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
 }
 
-static inline void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
@@ -51,7 +51,7 @@ static inline void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ct
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
 }
 
-static inline void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(SYS_SPSR);
@@ -60,18 +60,18 @@ static inline void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_cont
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
 }
 
-static inline void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
 }
 
-static inline void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[TPIDR_EL0],		tpidr_el0);
 	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
 }
 
-static inline void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
@@ -130,7 +130,7 @@ static inline void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
 }
 
-static inline void __hyp_text __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
+static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	u64 pstate = ctxt->gp_regs.regs.pstate;
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
@@ -156,7 +156,7 @@ static inline void __hyp_text __sysreg_restore_el2_return_state(struct kvm_cpu_c
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
 }
 
-static inline void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
+static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
@@ -178,7 +178,7 @@ static inline void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
 }
 
-static inline void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
+static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index ad8729f5e814..0b34414557d6 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -21,7 +21,13 @@ $(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
 	$(call if_changed,hypcopy)
 
 quiet_cmd_hypcopy = HYPCOPY $@
-      cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
+      cmd_hypcopy = $(OBJCOPY)	--prefix-symbols=__kvm_nvhe_		\
+				--rename-section=.text=.hyp.text	\
+				$< $@
+
+# Remove ftrace and Shadow Call Stack CFLAGS.
+# This is equivalent to the 'notrace' and '__noscs' annotations.
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 828c0d48e790..91a711aa8382 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -14,7 +14,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static void __hyp_text __debug_save_spe(u64 *pmscr_el1)
+static void __debug_save_spe(u64 *pmscr_el1)
 {
 	u64 reg;
 
@@ -46,7 +46,7 @@ static void __hyp_text __debug_save_spe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
+static void __debug_restore_spe(u64 pmscr_el1)
 {
 	if (!pmscr_el1)
 		return;
@@ -58,20 +58,20 @@ static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
 	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
 	__debug_switch_to_guest_common(vcpu);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
 	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __hyp_text __kvm_get_mdcr_el2(void)
+u32 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f08bfb951df6..a1dcf59bd45e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -27,7 +27,7 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
-static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
@@ -58,7 +58,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
+static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 mdcr_el2;
 
@@ -93,13 +93,13 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
-static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
+static void __deactivate_vm(struct kvm_vcpu *vcpu)
 {
 	write_sysreg(0, vttbr_el2);
 }
 
 /* Save VGICv3 state on non-VHE systems */
-static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
+static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -108,7 +108,7 @@ static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 }
 
 /* Restore VGICv3 state on non_VEH systems */
-static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
+static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -119,7 +119,7 @@ static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 /**
  * Disable host events, enable guest events
  */
-static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_host_data *host;
 	struct kvm_pmu_events *pmu;
@@ -139,7 +139,7 @@ static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
 /**
  * Disable guest events, enable host events
  */
-static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
+static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_host_data *host;
 	struct kvm_pmu_events *pmu;
@@ -155,7 +155,7 @@ static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 }
 
 /* Switch to the guest for legacy non-VHE systems */
-int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -242,7 +242,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
index 710cf28ab1ec..88a25fc8fcd3 100644
--- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -18,7 +18,7 @@
  * Non-VHE: Both host and guest must save everything.
  */
 
-void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
+void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
@@ -26,7 +26,7 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_save_el2_return_state(ctxt);
 }
 
-void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
+void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
@@ -34,7 +34,7 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_el2_return_state(ctxt);
 }
 
-void __hyp_text __kvm_enable_ssbs(void)
+void __kvm_enable_ssbs(void)
 {
 	u64 tmp;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 42c8ed71d06e..9072e71693ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -19,7 +19,7 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
-void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
+void __timer_disable_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
@@ -33,7 +33,7 @@ void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
-void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
+void __timer_enable_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index deb48c8c00ee..d4475f8340c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -12,8 +12,7 @@ struct tlb_inv_context {
 	u64		tcr;
 };
 
-static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
-					     struct tlb_inv_context *cxt)
+static void __tlb_switch_to_guest(struct kvm *kvm, struct tlb_inv_context *cxt)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
@@ -36,8 +35,7 @@ static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
 	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
-static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
-					    struct tlb_inv_context *cxt)
+static void __tlb_switch_to_host(struct kvm *kvm, struct tlb_inv_context *cxt)
 {
 	write_sysreg(0, vttbr_el2);
 
@@ -49,7 +47,7 @@ static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
 	}
 }
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	struct tlb_inv_context cxt;
 
@@ -103,7 +101,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	__tlb_switch_to_host(kvm, &cxt);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
+void __kvm_tlb_flush_vmid(struct kvm *kvm)
 {
 	struct tlb_inv_context cxt;
 
@@ -120,7 +118,7 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 	__tlb_switch_to_host(kvm, &cxt);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 	struct tlb_inv_context cxt;
@@ -135,7 +133,7 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	__tlb_switch_to_host(kvm, &cxt);
 }
 
-void __hyp_text __kvm_flush_vm_context(void)
+void __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	__tlbi(alle1is);
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 4f3a087e36d5..bd1bab551d48 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -13,7 +13,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static bool __hyp_text __is_be(struct kvm_vcpu *vcpu)
+static bool __is_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu))
 		return !!(read_sysreg_el2(SYS_SPSR) & PSR_AA32_E_BIT);
@@ -32,7 +32,7 @@ static bool __hyp_text __is_be(struct kvm_vcpu *vcpu)
  *  0: Not a GICV access
  * -1: Illegal GICV access successfully performed
  */
-int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
+int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 10ed539835c1..d31eb6266f2e 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -16,7 +16,7 @@
 #define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
 #define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
 
-static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
+static u64 __gic_v3_get_lr(unsigned int lr)
 {
 	switch (lr & 0xf) {
 	case 0:
@@ -56,7 +56,7 @@ static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
 	unreachable();
 }
 
-static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
+static void __gic_v3_set_lr(u64 val, int lr)
 {
 	switch (lr & 0xf) {
 	case 0:
@@ -110,7 +110,7 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
 	}
 }
 
-static void __hyp_text __vgic_v3_write_ap0rn(u32 val, int n)
+static void __vgic_v3_write_ap0rn(u32 val, int n)
 {
 	switch (n) {
 	case 0:
@@ -128,7 +128,7 @@ static void __hyp_text __vgic_v3_write_ap0rn(u32 val, int n)
 	}
 }
 
-static void __hyp_text __vgic_v3_write_ap1rn(u32 val, int n)
+static void __vgic_v3_write_ap1rn(u32 val, int n)
 {
 	switch (n) {
 	case 0:
@@ -146,7 +146,7 @@ static void __hyp_text __vgic_v3_write_ap1rn(u32 val, int n)
 	}
 }
 
-static u32 __hyp_text __vgic_v3_read_ap0rn(int n)
+static u32 __vgic_v3_read_ap0rn(int n)
 {
 	u32 val;
 
@@ -170,7 +170,7 @@ static u32 __hyp_text __vgic_v3_read_ap0rn(int n)
 	return val;
 }
 
-static u32 __hyp_text __vgic_v3_read_ap1rn(int n)
+static u32 __vgic_v3_read_ap1rn(int n)
 {
 	u32 val;
 
@@ -194,7 +194,7 @@ static u32 __hyp_text __vgic_v3_read_ap1rn(int n)
 	return val;
 }
 
-void __hyp_text __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
+void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 used_lrs = cpu_if->used_lrs;
 
@@ -229,7 +229,7 @@ void __hyp_text __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 	}
 }
 
-void __hyp_text __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
+void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 used_lrs = cpu_if->used_lrs;
 	int i;
@@ -255,7 +255,7 @@ void __hyp_text __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
 	}
 }
 
-void __hyp_text __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
+void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
 	/*
 	 * VFIQEn is RES1 if ICC_SRE_EL1.SRE is 1. This causes a
@@ -302,7 +302,7 @@ void __hyp_text __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 }
 
-void __hyp_text __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
+void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 
@@ -328,7 +328,7 @@ void __hyp_text __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 		write_gicreg(0, ICH_HCR_EL2);
 }
 
-void __hyp_text __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
+void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 	u32 nr_pre_bits;
@@ -361,7 +361,7 @@ void __hyp_text __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 	}
 }
 
-void __hyp_text __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
+void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 	u32 nr_pre_bits;
@@ -394,7 +394,7 @@ void __hyp_text __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 	}
 }
 
-void __hyp_text __vgic_v3_init_lrs(void)
+void __vgic_v3_init_lrs(void)
 {
 	int max_lr_idx = vtr_to_max_lr_idx(read_gicreg(ICH_VTR_EL2));
 	int i;
@@ -403,28 +403,28 @@ void __hyp_text __vgic_v3_init_lrs(void)
 		__gic_v3_set_lr(0, i);
 }
 
-u64 __hyp_text __vgic_v3_get_ich_vtr_el2(void)
+u64 __vgic_v3_get_ich_vtr_el2(void)
 {
 	return read_gicreg(ICH_VTR_EL2);
 }
 
-u64 __hyp_text __vgic_v3_read_vmcr(void)
+u64 __vgic_v3_read_vmcr(void)
 {
 	return read_gicreg(ICH_VMCR_EL2);
 }
 
-void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
+void __vgic_v3_write_vmcr(u32 vmcr)
 {
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
-static int __hyp_text __vgic_v3_bpr_min(void)
+static int __vgic_v3_bpr_min(void)
 {
 	/* See Pseudocode for VPriorityGroup */
 	return 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
 }
 
-static int __hyp_text __vgic_v3_get_group(struct kvm_vcpu *vcpu)
+static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 {
 	u32 esr = kvm_vcpu_get_hsr(vcpu);
 	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
@@ -434,9 +434,8 @@ static int __hyp_text __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 
 #define GICv3_IDLE_PRIORITY	0xff
 
-static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
-						    u32 vmcr,
-						    u64 *lr_val)
+static int __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu, u32 vmcr,
+					 u64 *lr_val)
 {
 	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
 	u8 priority = GICv3_IDLE_PRIORITY;
@@ -474,8 +473,8 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
 	return lr;
 }
 
-static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
-					       int intid, u64 *lr_val)
+static int __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu, int intid,
+				    u64 *lr_val)
 {
 	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
 	int i;
@@ -494,7 +493,7 @@ static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
 	return -1;
 }
 
-static int __hyp_text __vgic_v3_get_highest_active_priority(void)
+static int __vgic_v3_get_highest_active_priority(void)
 {
 	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
 	u32 hap = 0;
@@ -526,12 +525,12 @@ static int __hyp_text __vgic_v3_get_highest_active_priority(void)
 	return GICv3_IDLE_PRIORITY;
 }
 
-static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
+static unsigned int __vgic_v3_get_bpr0(u32 vmcr)
 {
 	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
 }
 
-static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
+static unsigned int __vgic_v3_get_bpr1(u32 vmcr)
 {
 	unsigned int bpr;
 
@@ -550,7 +549,7 @@ static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
  * Convert a priority to a preemption level, taking the relevant BPR
  * into account by zeroing the sub-priority bits.
  */
-static u8 __hyp_text __vgic_v3_pri_to_pre(u8 pri, u32 vmcr, int grp)
+static u8 __vgic_v3_pri_to_pre(u8 pri, u32 vmcr, int grp)
 {
 	unsigned int bpr;
 
@@ -568,7 +567,7 @@ static u8 __hyp_text __vgic_v3_pri_to_pre(u8 pri, u32 vmcr, int grp)
  * matter what the guest does with its BPR, we can always set/get the
  * same value of a priority.
  */
-static void __hyp_text __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
+static void __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
 {
 	u8 pre, ap;
 	u32 val;
@@ -587,7 +586,7 @@ static void __hyp_text __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
 	}
 }
 
-static int __hyp_text __vgic_v3_clear_highest_active_priority(void)
+static int __vgic_v3_clear_highest_active_priority(void)
 {
 	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
 	u32 hap = 0;
@@ -625,7 +624,7 @@ static int __hyp_text __vgic_v3_clear_highest_active_priority(void)
 	return GICv3_IDLE_PRIORITY;
 }
 
-static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 lr_val;
 	u8 lr_prio, pmr;
@@ -661,7 +660,7 @@ static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int r
 	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
 }
 
-static void __hyp_text __vgic_v3_clear_active_lr(int lr, u64 lr_val)
+static void __vgic_v3_clear_active_lr(int lr, u64 lr_val)
 {
 	lr_val &= ~ICH_LR_ACTIVE_BIT;
 	if (lr_val & ICH_LR_HW) {
@@ -674,7 +673,7 @@ static void __hyp_text __vgic_v3_clear_active_lr(int lr, u64 lr_val)
 	__gic_v3_set_lr(lr_val, lr);
 }
 
-static void __hyp_text __vgic_v3_bump_eoicount(void)
+static void __vgic_v3_bump_eoicount(void)
 {
 	u32 hcr;
 
@@ -683,8 +682,7 @@ static void __hyp_text __vgic_v3_bump_eoicount(void)
 	write_gicreg(hcr, ICH_HCR_EL2);
 }
 
-static void __hyp_text __vgic_v3_write_dir(struct kvm_vcpu *vcpu,
-					   u32 vmcr, int rt)
+static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 vid = vcpu_get_reg(vcpu, rt);
 	u64 lr_val;
@@ -707,7 +705,7 @@ static void __hyp_text __vgic_v3_write_dir(struct kvm_vcpu *vcpu,
 	__vgic_v3_clear_active_lr(lr, lr_val);
 }
 
-static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 vid = vcpu_get_reg(vcpu, rt);
 	u64 lr_val;
@@ -744,17 +742,17 @@ static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int
 	__vgic_v3_clear_active_lr(lr, lr_val);
 }
 
-static void __hyp_text __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
 }
 
-static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
 }
 
-static void __hyp_text __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 val = vcpu_get_reg(vcpu, rt);
 
@@ -766,7 +764,7 @@ static void __hyp_text __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr,
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 val = vcpu_get_reg(vcpu, rt);
 
@@ -778,17 +776,17 @@ static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr,
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __hyp_text __vgic_v3_read_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr0(vmcr));
 }
 
-static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
 }
 
-static void __hyp_text __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 val = vcpu_get_reg(vcpu, rt);
 	u8 bpr_min = __vgic_v3_bpr_min() - 1;
@@ -805,7 +803,7 @@ static void __hyp_text __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 val = vcpu_get_reg(vcpu, rt);
 	u8 bpr_min = __vgic_v3_bpr_min();
@@ -825,7 +823,7 @@ static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int
 	__vgic_v3_write_vmcr(vmcr);
 }
 
-static void __hyp_text __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
+static void __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 {
 	u32 val;
 
@@ -837,7 +835,7 @@ static void __hyp_text __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n
 	vcpu_set_reg(vcpu, rt, val);
 }
 
-static void __hyp_text __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
+static void __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 {
 	u32 val = vcpu_get_reg(vcpu, rt);
 
@@ -847,56 +845,49 @@ static void __hyp_text __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int
 		__vgic_v3_write_ap1rn(val, n);
 }
 
-static void __hyp_text __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
+static void __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
 					    u32 vmcr, int rt)
 {
 	__vgic_v3_read_apxrn(vcpu, rt, 0);
 }
 
-static void __hyp_text __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
+static void __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
 					    u32 vmcr, int rt)
 {
 	__vgic_v3_read_apxrn(vcpu, rt, 1);
 }
 
-static void __hyp_text __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu,
-					    u32 vmcr, int rt)
+static void __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	__vgic_v3_read_apxrn(vcpu, rt, 2);
 }
 
-static void __hyp_text __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu,
-					    u32 vmcr, int rt)
+static void __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	__vgic_v3_read_apxrn(vcpu, rt, 3);
 }
 
-static void __hyp_text __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu,
-					     u32 vmcr, int rt)
+static void __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	__vgic_v3_write_apxrn(vcpu, rt, 0);
 }
 
-static void __hyp_text __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu,
-					     u32 vmcr, int rt)
+static void __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	__vgic_v3_write_apxrn(vcpu, rt, 1);
 }
 
-static void __hyp_text __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu,
-					     u32 vmcr, int rt)
+static void __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	__vgic_v3_write_apxrn(vcpu, rt, 2);
 }
 
-static void __hyp_text __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu,
-					     u32 vmcr, int rt)
+static void __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	__vgic_v3_write_apxrn(vcpu, rt, 3);
 }
 
-static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
-					    u32 vmcr, int rt)
+static void __vgic_v3_read_hppir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 lr_val;
 	int lr, lr_grp, grp;
@@ -915,16 +906,14 @@ static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
 }
 
-static void __hyp_text __vgic_v3_read_pmr(struct kvm_vcpu *vcpu,
-					  u32 vmcr, int rt)
+static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vmcr &= ICH_VMCR_PMR_MASK;
 	vmcr >>= ICH_VMCR_PMR_SHIFT;
 	vcpu_set_reg(vcpu, rt, vmcr);
 }
 
-static void __hyp_text __vgic_v3_write_pmr(struct kvm_vcpu *vcpu,
-					   u32 vmcr, int rt)
+static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val = vcpu_get_reg(vcpu, rt);
 
@@ -936,15 +925,13 @@ static void __hyp_text __vgic_v3_write_pmr(struct kvm_vcpu *vcpu,
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
-static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
-					  u32 vmcr, int rt)
+static void __vgic_v3_read_rpr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val = __vgic_v3_get_highest_active_priority();
 	vcpu_set_reg(vcpu, rt, val);
 }
 
-static void __hyp_text __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu,
-					   u32 vmcr, int rt)
+static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 vtr, val;
 
@@ -965,8 +952,7 @@ static void __hyp_text __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, rt, val);
 }
 
-static void __hyp_text __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu,
-					    u32 vmcr, int rt)
+static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val = vcpu_get_reg(vcpu, rt);
 
@@ -983,7 +969,7 @@ static void __hyp_text __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu,
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
-int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
+int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
 	u32 esr;
-- 
2.27.0

