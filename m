Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08D923CEAC
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgHESyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgHESaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F64C22DD6;
        Wed,  5 Aug 2020 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652016;
        bh=YNx+MeMmTTjRzZ24xWo3RQozCg4nqRaUJD7bFD4D/Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iZ7K8K17r8tKk1+frGArAsTH2WorTxUUIqPBRQwDtFcPTY8MWAKbqNSWNN8FfEGv
         PoL1Dec9p33eJdbtNZPfIXJCnJBdX9CzxTpuhj83JHdCvOklX49LpH6n/L1q21SIce
         QW0RnImHkGqL/tR2+yEbMbg8xLy0FS2U9gXKnBBY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfS-0004w9-0v; Wed, 05 Aug 2020 18:57:34 +0100
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
Subject: [PATCH 18/56] KVM: arm64: Build hyp-entry.S separately for VHE/nVHE
Date:   Wed,  5 Aug 2020 18:56:22 +0100
Message-Id: <20200805175700.62775-19-maz@kernel.org>
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

hyp-entry.S contains implementation of KVM hyp vectors. This code is mostly
shared between VHE/nVHE, therefore compile it under both VHE and nVHE build
rules. nVHE-specific host HVC handler is hidden behind __KVM_NVHE_HYPERVISOR__.

Adjust code which selects which KVM hyp vecs to install to choose the correct
VHE/nVHE symbol.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-7-dbrazdil@google.com
---
 arch/arm64/include/asm/kvm_asm.h | 22 +++++++++++++++++-----
 arch/arm64/include/asm/mmu.h     |  7 -------
 arch/arm64/kernel/image-vars.h   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/arm.c             |  2 +-
 arch/arm64/kvm/hyp/Makefile      |  4 ++--
 arch/arm64/kvm/hyp/hyp-entry.S   |  2 ++
 arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
 arch/arm64/kvm/hyp/vhe/Makefile  |  2 +-
 8 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6a682d66a640..6026cbd204ae 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -60,12 +60,17 @@
 	DECLARE_KVM_VHE_SYM(sym);		\
 	DECLARE_KVM_NVHE_SYM(sym)
 
-/* Translate a kernel address of @sym into its equivalent linear mapping */
-#define kvm_ksym_ref(sym)						\
+#define CHOOSE_VHE_SYM(sym)	sym
+#define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
+#define CHOOSE_HYP_SYM(sym)	(has_vhe() ? CHOOSE_VHE_SYM(sym) \
+					   : CHOOSE_NVHE_SYM(sym))
+
+/* Translate a kernel address @ptr into its equivalent linear mapping */
+#define kvm_ksym_ref(ptr)						\
 	({								\
-		void *val = &sym;					\
+		void *val = (ptr);					\
 		if (!is_kernel_in_hyp_mode())				\
-			val = lm_alias(&sym);				\
+			val = lm_alias((ptr));				\
 		val;							\
 	 })
 #define kvm_ksym_ref_nvhe(sym)	kvm_ksym_ref(kvm_nvhe_sym(sym))
@@ -76,7 +81,14 @@ struct kvm_vcpu;
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
 
-extern char __kvm_hyp_vector[];
+DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
+#define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
+
+#ifdef CONFIG_KVM_INDIRECT_VECTORS
+extern atomic_t arm64_el2_vector_last_slot;
+DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
+#define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
+#endif
 
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 8444df000181..a7a5ecaa2e83 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -45,13 +45,6 @@ struct bp_hardening_data {
 	bp_hardening_cb_t	fn;
 };
 
-#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
-     defined(CONFIG_HARDEN_EL2_VECTORS))
-
-extern char __bp_harden_hyp_vecs[];
-extern atomic_t arm64_el2_vector_last_slot;
-#endif  /* CONFIG_HARDEN_BRANCH_PREDICTOR || CONFIG_HARDEN_EL2_VECTORS */
-
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 36444bac6a05..f28da486b75a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -66,8 +66,17 @@ __efistub__ctype		= _ctype;
 /* Symbols defined in debug-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_get_mdcr_el2);
 
+/* Symbols defined in entry.S (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__guest_exit);
+KVM_NVHE_ALIAS(abort_guest_exit_end);
+KVM_NVHE_ALIAS(abort_guest_exit_start);
+
+/* Symbols defined in hyp-init.S (not yet compiled with nVHE build rules). */
+KVM_NVHE_ALIAS(__kvm_handle_stub_hvc);
+
 /* Symbols defined in switch.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_vcpu_run_nvhe);
+KVM_NVHE_ALIAS(hyp_panic);
 
 /* Symbols defined in sysreg-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_enable_ssbs);
@@ -89,6 +98,21 @@ KVM_NVHE_ALIAS(__vgic_v3_restore_aprs);
 KVM_NVHE_ALIAS(__vgic_v3_save_aprs);
 KVM_NVHE_ALIAS(__vgic_v3_write_vmcr);
 
+/* Alternative callbacks for init-time patching of nVHE hyp code. */
+KVM_NVHE_ALIAS(arm64_enable_wa2_handling);
+KVM_NVHE_ALIAS(kvm_patch_vector_branch);
+KVM_NVHE_ALIAS(kvm_update_va_mask);
+
+/* Global kernel state accessed by nVHE hyp code. */
+KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
+KVM_NVHE_ALIAS(kvm_host_data);
+
+/* Kernel constant needed to compute idmap addresses. */
+KVM_NVHE_ALIAS(kimage_voffset);
+
+/* Kernel symbols used to call panic() from nVHE hyp code (via ERET). */
+KVM_NVHE_ALIAS(panic);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..34b551385153 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1285,7 +1285,7 @@ static void cpu_init_hyp_mode(void)
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
 	tpidr_el2 = ((unsigned long)this_cpu_ptr(&kvm_host_data) -
-		     (unsigned long)kvm_ksym_ref(kvm_host_data));
+		     (unsigned long)kvm_ksym_ref(&kvm_host_data));
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 9c5dfe6ff80b..8b0cf85080b5 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,11 +10,11 @@ subdir-ccflags-y := -I$(incdir)				\
 		    -DDISABLE_BRANCH_PROFILING		\
 		    $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += hyp.o nvhe/
+obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
 hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
-	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
+	 debug-sr.o entry.o switch.o fpsimd.o tlb.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index d362fad97cc8..7e3c72fa634f 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -40,6 +40,7 @@ el1_sync:				// Guest trapped into EL2
 	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
 
+#ifdef __KVM_NVHE_HYPERVISOR__
 	mrs	x1, vttbr_el2		// If vttbr is valid, the guest
 	cbnz	x1, el1_hvc_guest	// called HVC
 
@@ -74,6 +75,7 @@ el1_sync:				// Guest trapped into EL2
 
 	eret
 	sb
+#endif /* __KVM_NVHE_HYPERVISOR__ */
 
 el1_hvc_guest:
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 955f4188e00f..79eb8eed96a1 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y :=
+obj-y := ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index e04375546081..323029e02b4e 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y :=
+obj-y := ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.27.0

