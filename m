Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DCF3CE532
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241001AbhGSPsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350270AbhGSPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:47 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756CC0ABCA8
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:28 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id j16-20020ac855100000b029025bf786be09so9644199qtq.20
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5cM7jtj85cjx0QSVLQLCmvdR8Pr0iuRIwLrrzJeca78=;
        b=DPJp8D/pnryqUzXhQjUCJZnGq9FRfoYUNPOX/JSopc5kReLfscURRnYMeN7Vyhmoqr
         aqQs4puMw9J/6nZirR0NxVjQWgwgX3SCSN1Ez7J3uP9dCg+8f+PolahbLKr5zScfOom9
         ITrk+4V9pKgcGrucnRBQ3UBxDsi12FKRh73UJd5v5yJHZ0nihROLGkSrMVT+bVExJhN/
         J2xg6aEd2uQO3b+l6DqI8RimffLelBfYHEyohU2av624TGiin3WIIuvTEGj8lBdHKMpW
         8q1poXFXprKq1wXoGPRAA2XwxXUFEo2ErpHiETCnEbjG4h+1ly8HNgpX+Xjf/EpBmH3P
         pZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5cM7jtj85cjx0QSVLQLCmvdR8Pr0iuRIwLrrzJeca78=;
        b=s5D3t1AlWx18hFb+aLP4LR9IDxXllIo87Y2dHzBNWAoBnt1RFrH1bT1hliQQS2Mpkz
         KW7BD54osVJnu4ByguWealioKeBa3oN0IYVrQaDqWh+sBNO56RNHwZd90GAsz5egjqBN
         Lht1s13Ke+VZwAVe1EYN8TeOKvNkjssOOVOrvkF9ZqMIZw4xDo/A2DxwtBZLTHyP5hv8
         vXrGziGdzxslR1ULTRrpC98ymL3ZnQmq5/JyHdxGO3zleZEafUIQrfaQH/wLydxqMe0q
         rMY3YdoqXU9/BRTS/nt4VKaJmvEWCGyxDYdYYTXD8+CHIKS/qJi1HZi5tD6zJYihRw78
         clhw==
X-Gm-Message-State: AOAM532kLAP1mhukLgD7TmoTSM379XC/3W/XmxgQiTL0ERykcObqZ+/S
        VVqanHNRB5dFnK462emOTvK1B1qM6A==
X-Google-Smtp-Source: ABdhPJxz92i3y8c3czqTbIVTtbEUXRxAaUT2p/IcLKS9WUGWkxVTIg0PaosUmaKkACdcuaG/byA4afFQZg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:ca5:: with SMTP id
 s5mr25400616qvs.58.1626710651062; Mon, 19 Jul 2021 09:04:11 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:42 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-12-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 11/15] KVM: arm64: Add trap handlers for protected VMs
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add trap handlers for protected VMs. These are mainly for Sys64
and debug traps.

No functional change intended as these are not hooked in yet to
the guest exit handlers introduced earlier. So even when trapping
is triggered, the exit handlers would let the host handle it, as
before.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_fixed_config.h | 178 +++++++++
 arch/arm64/include/asm/kvm_host.h         |   2 +
 arch/arm64/include/asm/kvm_hyp.h          |   3 +
 arch/arm64/kvm/Makefile                   |   2 +-
 arch/arm64/kvm/arm.c                      |  11 +
 arch/arm64/kvm/hyp/nvhe/Makefile          |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c        | 443 ++++++++++++++++++++++
 arch/arm64/kvm/pkvm.c                     | 183 +++++++++
 8 files changed, 822 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
 create mode 100644 arch/arm64/kvm/pkvm.c

diff --git a/arch/arm64/include/asm/kvm_fixed_config.h b/arch/arm64/include/asm/kvm_fixed_config.h
new file mode 100644
index 000000000000..b39a5de2c4b9
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_fixed_config.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Google LLC
+ * Author: Fuad Tabba <tabba@google.com>
+ */
+
+#ifndef __ARM64_KVM_FIXED_CONFIG_H__
+#define __ARM64_KVM_FIXED_CONFIG_H__
+
+#include <asm/sysreg.h>
+
+/*
+ * This file contains definitions for features to be allowed or restricted for
+ * guest virtual machines as a baseline, depending on what mode KVM is running
+ * in and on the type of guest is running.
+ *
+ * The features are represented as the highest allowed value for a feature in
+ * the feature id registers. If the field is set to all ones (i.e., 0b1111),
+ * then it's only restricted by what the system allows. If the feature is set to
+ * another value, then that value would be the maximum value allowed and
+ * supported in pKVM, even if the system supports a higher value.
+ *
+ * Some features are forced to a certain value, in which case a SET bitmap is
+ * used to force these values.
+ */
+
+
+/*
+ * Allowed features for protected guests (Protected KVM)
+ *
+ * The approach taken here is to allow features that are:
+ * - needed by common Linux distributions (e.g., flooating point)
+ * - are trivial, e.g., supporting the feature doesn't introduce or require the
+ * tracking of additional state
+ * - not trapable
+ */
+
+/*
+ * - Floating-point and Advanced SIMD:
+ *	Don't require much support other than maintaining the context, which KVM
+ *	already has.
+ * - AArch64 guests only (no support for AArch32 guests):
+ *	Simplify support in case of asymmetric AArch32 systems.
+ * - RAS (v1)
+ *	v1 doesn't require much additional support, but later versions do.
+ * - Data Independent Timing
+ *	Trivial
+ * Remaining features are not supported either because they require too much
+ * support from KVM, or risk leaking guest data.
+ */
+#define PVM_ID_AA64PFR0_ALLOW (\
+	FEATURE(ID_AA64PFR0_FP) | \
+	FIELD_PREP(FEATURE(ID_AA64PFR0_EL0), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(FEATURE(ID_AA64PFR0_EL1), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), ID_AA64PFR0_ELx_64BIT_ONLY) | \
+	FIELD_PREP(FEATURE(ID_AA64PFR0_RAS), ID_AA64PFR0_RAS_V1) | \
+	FEATURE(ID_AA64PFR0_ASIMD) | \
+	FEATURE(ID_AA64PFR0_DIT) \
+	)
+
+/*
+ * - Branch Target Identification
+ * - Speculative Store Bypassing
+ *	These features are trivial to support
+ */
+#define PVM_ID_AA64PFR1_ALLOW (\
+	FEATURE(ID_AA64PFR1_BT) | \
+	FEATURE(ID_AA64PFR1_SSBS) \
+	)
+
+/*
+ * No support for Scalable Vectors:
+ *	Requires additional support from KVM
+ */
+#define PVM_ID_AA64ZFR0_ALLOW (0ULL)
+
+/*
+ * No support for debug, including breakpoints, and watchpoints:
+ *	Reduce complexity and avoid exposing/leaking guest data
+ *
+ * NOTE: The Arm architecture mandates support for at least the Armv8 debug
+ * architecture, which would include at least 2 hardware breakpoints and
+ * watchpoints. Providing that support to protected guests adds considerable
+ * state and complexity, and risks leaking guest data. Therefore, the reserved
+ * value of 0 is used for debug-related fields.
+ */
+#define PVM_ID_AA64DFR0_ALLOW (0ULL)
+
+/*
+ * These features are chosen because they are supported by KVM and to limit the
+ * confiruation state space and make it more deterministic.
+ * - 40-bit IPA
+ * - 16-bit ASID
+ * - Mixed-endian
+ * - Distinction between Secure and Non-secure Memory
+ * - Mixed-endian at EL0 only
+ * - Non-context synchronizing exception entry and exit
+ */
+#define PVM_ID_AA64MMFR0_ALLOW (\
+	FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), ID_AA64MMFR0_PARANGE_40) | \
+	FIELD_PREP(FEATURE(ID_AA64MMFR0_ASID), ID_AA64MMFR0_ASID_16) | \
+	FEATURE(ID_AA64MMFR0_BIGENDEL) | \
+	FEATURE(ID_AA64MMFR0_SNSMEM) | \
+	FEATURE(ID_AA64MMFR0_BIGENDEL0) | \
+	FEATURE(ID_AA64MMFR0_EXS) \
+	)
+
+/*
+ * - 64KB granule not supported
+ */
+#define PVM_ID_AA64MMFR0_SET (\
+	FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64), ID_AA64MMFR0_TGRAN64_NI) \
+	)
+
+/*
+ * These features are chosen because they are supported by KVM and to limit the
+ * confiruation state space and make it more deterministic.
+ * - Hardware translation table updates to Access flag and Dirty state
+ * - Number of VMID bits from CPU
+ * - Hierarchical Permission Disables
+ * - Privileged Access Never
+ * - SError interrupt exceptions from speculative reads
+ * - Enhanced Translation Synchronization
+ */
+#define PVM_ID_AA64MMFR1_ALLOW (\
+	FEATURE(ID_AA64MMFR1_HADBS) | \
+	FEATURE(ID_AA64MMFR1_VMIDBITS) | \
+	FEATURE(ID_AA64MMFR1_HPD) | \
+	FEATURE(ID_AA64MMFR1_PAN) | \
+	FEATURE(ID_AA64MMFR1_SPECSEI) | \
+	FEATURE(ID_AA64MMFR1_ETS) \
+	)
+
+/*
+ * These features are chosen because they are supported by KVM and to limit the
+ * confiruation state space and make it more deterministic.
+ * - Common not Private translations
+ * - User Access Override
+ * - IESB bit in the SCTLR_ELx registers
+ * - Unaligned single-copy atomicity and atomic functions
+ * - ESR_ELx.EC value on an exception by read access to feature ID space
+ * - TTL field in address operations.
+ * - Break-before-make sequences when changing translation block size
+ * - E0PDx mechanism
+ */
+#define PVM_ID_AA64MMFR2_ALLOW (\
+	FEATURE(ID_AA64MMFR2_CNP) | \
+	FEATURE(ID_AA64MMFR2_UAO) | \
+	FEATURE(ID_AA64MMFR2_IESB) | \
+	FEATURE(ID_AA64MMFR2_AT) | \
+	FEATURE(ID_AA64MMFR2_IDS) | \
+	FEATURE(ID_AA64MMFR2_TTL) | \
+	FEATURE(ID_AA64MMFR2_BBM) | \
+	FEATURE(ID_AA64MMFR2_E0PD) \
+	)
+
+/*
+ * Allow all features in this register because they are trivial to support, or
+ * are already supported by KVM:
+ * - LS64
+ * - XS
+ * - I8MM
+ * - DGB
+ * - BF16
+ * - SPECRES
+ * - SB
+ * - FRINTTS
+ * - PAuth
+ * - FPAC
+ * - LRCPC
+ * - FCMA
+ * - JSCVT
+ * - DPB
+ */
+#define PVM_ID_AA64ISAR1_ALLOW (~0ULL)
+
+#endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac67d5699c68..e1ceadd69575 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -780,6 +780,8 @@ static inline bool kvm_vm_is_protected(struct kvm *kvm)
 	return false;
 }
 
+void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 657d0c94cf82..3f4866322f85 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -115,7 +115,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 #endif
 
+extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 989bb5dad2c8..0be63f5c495f 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
-	 guest.o debug.o reset.o sys_regs.o \
+	 guest.o debug.o pkvm.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 arch_timer.o trng.o\
 	 vgic/vgic.o vgic/vgic-init.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14b12f2c08c0..3f28549aff0d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -618,6 +618,14 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
 
+	/*
+	 * Initialize traps for protected VMs.
+	 * NOTE: Move  trap initialization to EL2 once the code is in place for
+	 * maintaining protected VM state at EL2 instead of the host.
+	 */
+	if (kvm_vm_is_protected(kvm))
+		kvm_init_protected_traps(vcpu);
+
 	return ret;
 }
 
@@ -1781,8 +1789,11 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
 	void *addr = phys_to_virt(hyp_mem_base);
 	int ret;
 
+	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 
 	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
 	if (ret)
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 5df6193fc430..a23f417a0c20 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
new file mode 100644
index 000000000000..6c7230aa70e9
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -0,0 +1,443 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 Google LLC
+ * Author: Fuad Tabba <tabba@google.com>
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_fixed_config.h>
+#include <asm/kvm_mmu.h>
+
+#include <hyp/adjust_pc.h>
+
+#include "../../sys_regs.h"
+
+/*
+ * Copies of the host's CPU features registers holding sanitized values.
+ */
+u64 id_aa64pfr0_el1_sys_val;
+u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64mmfr2_el1_sys_val;
+
+/*
+ * Inject an unknown/undefined exception to the guest.
+ */
+static void inject_undef(struct kvm_vcpu *vcpu)
+{
+	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1 |
+			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+			     KVM_ARM64_PENDING_EXCEPTION);
+
+	__kvm_adjust_pc(vcpu);
+
+	write_sysreg_el1(esr, SYS_ESR);
+	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+}
+
+/*
+ * Accessor for undefined accesses.
+ */
+static bool undef_access(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	inject_undef(vcpu);
+	return false;
+}
+
+/*
+ * Accessors for feature registers.
+ *
+ * If access is allowed, set the regval to the protected VM's view of the
+ * register and return true.
+ * Otherwise, inject an undefined exception and return false.
+ */
+
+/*
+ * Returns the minimum feature supported and allowed.
+ */
+static u64 get_min_feature(u64 feature, u64 allowed_features,
+			   u64 supported_features)
+{
+	const u64 allowed_feature = FIELD_GET(feature, allowed_features);
+	const u64 supported_feature = FIELD_GET(feature, supported_features);
+
+	return min(allowed_feature, supported_feature);
+}
+
+/* Accessor for ID_AA64PFR0_EL1. */
+static bool pvm_access_id_aa64pfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	const struct kvm *kvm = (const struct kvm *) kern_hyp_va(vcpu->kvm);
+	const u64 feature_ids = PVM_ID_AA64PFR0_ALLOW;
+	u64 set_mask = 0;
+	u64 clear_mask = 0;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/* Get the RAS version allowed and supported */
+	clear_mask |= FEATURE(ID_AA64PFR0_RAS);
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_RAS),
+			       get_min_feature(FEATURE(ID_AA64PFR0_RAS),
+					       feature_ids,
+					       id_aa64pfr0_el1_sys_val));
+
+	/* AArch32 guests: if not allowed then force guests to 64-bits only */
+	clear_mask |= FEATURE(ID_AA64PFR0_EL0) | FEATURE(ID_AA64PFR0_EL1) |
+		      FEATURE(ID_AA64PFR0_EL2) | FEATURE(ID_AA64PFR0_EL3);
+
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL0),
+			       get_min_feature(FEATURE(ID_AA64PFR0_EL0),
+					       feature_ids,
+			                       id_aa64pfr0_el1_sys_val));
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL1),
+			       get_min_feature(FEATURE(ID_AA64PFR0_EL1),
+					       feature_ids,
+			                       id_aa64pfr0_el1_sys_val));
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2),
+			       get_min_feature(FEATURE(ID_AA64PFR0_EL2),
+					       feature_ids,
+			                       id_aa64pfr0_el1_sys_val));
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3),
+			       get_min_feature(FEATURE(ID_AA64PFR0_EL3),
+					       feature_ids,
+			                       id_aa64pfr0_el1_sys_val));
+
+	/* Spectre and Meltdown mitigation */
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2),
+			       (u64)kvm->arch.pfr0_csv2);
+	set_mask |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3),
+			       (u64)kvm->arch.pfr0_csv3);
+
+	p->regval = (id_aa64pfr0_el1_sys_val & feature_ids & ~clear_mask) |
+		    set_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64PFR1_EL1. */
+static bool pvm_access_id_aa64pfr1(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	const u64 feature_ids = PVM_ID_AA64PFR1_ALLOW;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	p->regval = id_aa64pfr1_el1_sys_val & feature_ids;
+	return true;
+}
+
+/* Accessor for ID_AA64ZFR0_EL1. */
+static bool pvm_access_id_aa64zfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for Scalable Vectors, therefore, pKVM has no sanitized
+	 * copy of the feature id register.
+	 */
+	BUILD_BUG_ON(PVM_ID_AA64ZFR0_ALLOW != 0ULL);
+
+	p->regval = 0;
+	return true;
+}
+
+/* Accessor for ID_AA64DFR0_EL1. */
+static bool pvm_access_id_aa64dfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for debug, including breakpoints, and watchpoints,
+	 * therefore, pKVM has no sanitized copy of the feature id register.
+	 */
+	BUILD_BUG_ON(PVM_ID_AA64DFR0_ALLOW != 0ULL);
+
+	p->regval = 0;
+	return true;
+}
+
+/*
+ * No restrictions on ID_AA64ISAR1_EL1 features, therefore, pKVM has no
+ * sanitized copy of the feature id register and it's handled by the host.
+ */
+static_assert(PVM_ID_AA64ISAR1_ALLOW == ~0ULL);
+
+/* Accessor for ID_AA64MMFR0_EL1. */
+static bool pvm_access_id_aa64mmfr0(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	const u64 feature_ids = PVM_ID_AA64MMFR0_ALLOW;
+	u64 set_mask = PVM_ID_AA64MMFR0_SET;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	p->regval = (id_aa64mmfr0_el1_sys_val & feature_ids) | set_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR1_EL1. */
+static bool pvm_access_id_aa64mmfr1(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	const u64 feature_ids = PVM_ID_AA64MMFR1_ALLOW;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	p->regval = id_aa64mmfr1_el1_sys_val & feature_ids;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR2_EL1. */
+static bool pvm_access_id_aa64mmfr2(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	const u64 feature_ids = PVM_ID_AA64MMFR2_ALLOW;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	p->regval = id_aa64mmfr2_el1_sys_val & feature_ids;
+	return true;
+}
+
+/*
+ * Accessor for AArch32 Processor Feature Registers.
+ *
+ * The value of these registers is "unknown" according to the spec if AArch32
+ * isn't supported.
+ */
+static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
+				  struct sys_reg_params *p,
+				  const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for AArch32 guests, therefore, pKVM has no sanitized copy
+	 * of AArch 32 feature id registers.
+	 */
+	BUILD_BUG_ON(FIELD_GET(FEATURE(ID_AA64PFR0_EL1),
+		     PVM_ID_AA64PFR0_ALLOW) > ID_AA64PFR0_ELx_64BIT_ONLY);
+
+	/* Use 0 for architecturally "unknown" values. */
+	p->regval = 0;
+	return true;
+}
+
+/* Mark the specified system register as an AArch32 feature register. */
+#define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
+
+/* Mark the specified system register as not being handled in hyp. */
+#define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
+
+/*
+ * Architected system registers.
+ * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
+ *
+ * NOTE: Anything not explicitly listed here will be *restricted by default*,
+ * i.e., it will lead to injecting an exception into the guest.
+ */
+static const struct sys_reg_desc pvm_sys_reg_descs[] = {
+	/* Cache maintenance by set/way operations are restricted. */
+
+	/* Debug and Trace Registers are all restricted */
+
+	/* AArch64 mappings of the AArch32 ID registers */
+	/* CRm=1 */
+	AARCH32(SYS_ID_PFR0_EL1),
+	AARCH32(SYS_ID_PFR1_EL1),
+	AARCH32(SYS_ID_DFR0_EL1),
+	AARCH32(SYS_ID_AFR0_EL1),
+	AARCH32(SYS_ID_MMFR0_EL1),
+	AARCH32(SYS_ID_MMFR1_EL1),
+	AARCH32(SYS_ID_MMFR2_EL1),
+	AARCH32(SYS_ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	AARCH32(SYS_ID_ISAR0_EL1),
+	AARCH32(SYS_ID_ISAR1_EL1),
+	AARCH32(SYS_ID_ISAR2_EL1),
+	AARCH32(SYS_ID_ISAR3_EL1),
+	AARCH32(SYS_ID_ISAR4_EL1),
+	AARCH32(SYS_ID_ISAR5_EL1),
+	AARCH32(SYS_ID_MMFR4_EL1),
+	AARCH32(SYS_ID_ISAR6_EL1),
+
+	/* CRm=3 */
+	AARCH32(SYS_MVFR0_EL1),
+	AARCH32(SYS_MVFR1_EL1),
+	AARCH32(SYS_MVFR2_EL1),
+	AARCH32(SYS_ID_PFR2_EL1),
+	AARCH32(SYS_ID_DFR1_EL1),
+	AARCH32(SYS_ID_MMFR5_EL1),
+
+	/* AArch64 ID registers */
+	/* CRm=4 */
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = pvm_access_id_aa64pfr0 },
+	{ SYS_DESC(SYS_ID_AA64PFR1_EL1), .access = pvm_access_id_aa64pfr1 },
+	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), .access = pvm_access_id_aa64zfr0 },
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = pvm_access_id_aa64dfr0 },
+	HOST_HANDLED(SYS_ID_AA64DFR1_EL1),
+	HOST_HANDLED(SYS_ID_AA64AFR0_EL1),
+	HOST_HANDLED(SYS_ID_AA64AFR1_EL1),
+	HOST_HANDLED(SYS_ID_AA64ISAR0_EL1),
+	HOST_HANDLED(SYS_ID_AA64ISAR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR0_EL1), .access = pvm_access_id_aa64mmfr0 },
+	{ SYS_DESC(SYS_ID_AA64MMFR1_EL1), .access = pvm_access_id_aa64mmfr1 },
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1), .access = pvm_access_id_aa64mmfr2 },
+
+	HOST_HANDLED(SYS_SCTLR_EL1),
+	HOST_HANDLED(SYS_ACTLR_EL1),
+	HOST_HANDLED(SYS_CPACR_EL1),
+
+	HOST_HANDLED(SYS_RGSR_EL1),
+	HOST_HANDLED(SYS_GCR_EL1),
+
+	/* Scalable Vector Registers are restricted. */
+
+	HOST_HANDLED(SYS_TTBR0_EL1),
+	HOST_HANDLED(SYS_TTBR1_EL1),
+	HOST_HANDLED(SYS_TCR_EL1),
+
+	HOST_HANDLED(SYS_APIAKEYLO_EL1),
+	HOST_HANDLED(SYS_APIAKEYHI_EL1),
+	HOST_HANDLED(SYS_APIBKEYLO_EL1),
+	HOST_HANDLED(SYS_APIBKEYHI_EL1),
+	HOST_HANDLED(SYS_APDAKEYLO_EL1),
+	HOST_HANDLED(SYS_APDAKEYHI_EL1),
+	HOST_HANDLED(SYS_APDBKEYLO_EL1),
+	HOST_HANDLED(SYS_APDBKEYHI_EL1),
+	HOST_HANDLED(SYS_APGAKEYLO_EL1),
+	HOST_HANDLED(SYS_APGAKEYHI_EL1),
+
+	HOST_HANDLED(SYS_AFSR0_EL1),
+	HOST_HANDLED(SYS_AFSR1_EL1),
+	HOST_HANDLED(SYS_ESR_EL1),
+
+	HOST_HANDLED(SYS_ERRIDR_EL1),
+	HOST_HANDLED(SYS_ERRSELR_EL1),
+	HOST_HANDLED(SYS_ERXFR_EL1),
+	HOST_HANDLED(SYS_ERXCTLR_EL1),
+	HOST_HANDLED(SYS_ERXSTATUS_EL1),
+	HOST_HANDLED(SYS_ERXADDR_EL1),
+	HOST_HANDLED(SYS_ERXMISC0_EL1),
+	HOST_HANDLED(SYS_ERXMISC1_EL1),
+
+	HOST_HANDLED(SYS_TFSR_EL1),
+	HOST_HANDLED(SYS_TFSRE0_EL1),
+
+	HOST_HANDLED(SYS_FAR_EL1),
+	HOST_HANDLED(SYS_PAR_EL1),
+
+	/* Performance Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_MAIR_EL1),
+	HOST_HANDLED(SYS_AMAIR_EL1),
+
+	/* Limited Ordering Regions Registers are restricted. */
+
+	HOST_HANDLED(SYS_VBAR_EL1),
+	HOST_HANDLED(SYS_DISR_EL1),
+
+	/* GIC CPU Interface registers are restricted. */
+
+	HOST_HANDLED(SYS_CONTEXTIDR_EL1),
+	HOST_HANDLED(SYS_TPIDR_EL1),
+
+	HOST_HANDLED(SYS_SCXTNUM_EL1),
+
+	HOST_HANDLED(SYS_CNTKCTL_EL1),
+
+	HOST_HANDLED(SYS_CCSIDR_EL1),
+	HOST_HANDLED(SYS_CLIDR_EL1),
+	HOST_HANDLED(SYS_CSSELR_EL1),
+	HOST_HANDLED(SYS_CTR_EL0),
+
+	/* Performance Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_TPIDR_EL0),
+	HOST_HANDLED(SYS_TPIDRRO_EL0),
+
+	HOST_HANDLED(SYS_SCXTNUM_EL0),
+
+	/* Activity Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_CNTP_TVAL_EL0),
+	HOST_HANDLED(SYS_CNTP_CTL_EL0),
+	HOST_HANDLED(SYS_CNTP_CVAL_EL0),
+
+	/* Performance Monitoring Registers are restricted. */
+
+	HOST_HANDLED(SYS_DACR32_EL2),
+	HOST_HANDLED(SYS_IFSR32_EL2),
+	HOST_HANDLED(SYS_FPEXC32_EL2),
+};
+
+/*
+ * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu)
+{
+	const struct sys_reg_desc *r;
+	struct sys_reg_params params;
+	unsigned long esr = kvm_vcpu_get_esr(vcpu);
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+
+	params = esr_sys64_to_params(esr);
+	params.regval = vcpu_get_reg(vcpu, Rt);
+
+	r = find_reg(&params, pvm_sys_reg_descs, ARRAY_SIZE(pvm_sys_reg_descs));
+
+	/* Undefined access (RESTRICTED). */
+	if (r == NULL) {
+		inject_undef(vcpu);
+		return 1;
+	}
+
+	/* Handled by the host (HOST_HANDLED) */
+	if (r->access == NULL)
+		return 0;
+
+	/* Handled by hyp: skip instruction if instructed to do so. */
+	if (r->access(vcpu, &params, r))
+		__kvm_skip_instr(vcpu);
+
+	vcpu_set_reg(vcpu, Rt, params.regval);
+	return 1;
+}
+
+/*
+ * Handler for protected VM restricted exceptions.
+ *
+ * Inject an undefined exception into the guest and return 1 to indicate that
+ * it was handled.
+ */
+int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu)
+{
+	inject_undef(vcpu);
+	return 1;
+}
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
new file mode 100644
index 000000000000..b8430b3d97af
--- /dev/null
+++ b/arch/arm64/kvm/pkvm.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM host (EL1) interface to Protected KVM (pkvm) code at EL2.
+ *
+ * Copyright (C) 2021 Google LLC
+ * Author: Fuad Tabba <tabba@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/mm.h>
+
+#include <asm/kvm_fixed_config.h>
+
+/*
+ * Set trap register values for features not allowed in ID_AA64PFR0.
+ */
+static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = PVM_ID_AA64PFR0_ALLOW;
+	u64 hcr_set = 0;
+	u64 hcr_clear = 0;
+	u64 cptr_set = 0;
+
+	/* Trap AArch32 guests */
+	if (FIELD_GET(FEATURE(ID_AA64PFR0_EL0), feature_ids) <
+		    ID_AA64PFR0_ELx_32BIT_64BIT ||
+	    FIELD_GET(FEATURE(ID_AA64PFR0_EL1), feature_ids) <
+		    ID_AA64PFR0_ELx_32BIT_64BIT)
+		hcr_set |= HCR_RW | HCR_TID0;
+
+	/* Trap RAS unless all versions are supported */
+	if (FIELD_GET(FEATURE(ID_AA64PFR0_RAS), feature_ids) <
+	    ID_AA64PFR0_RAS_ANY) {
+		hcr_set |= HCR_TERR | HCR_TEA;
+		hcr_clear |= HCR_FIEN;
+	}
+
+	/* Trap AMU */
+	if (!FIELD_GET(FEATURE(ID_AA64PFR0_AMU), feature_ids)) {
+		hcr_clear |= HCR_AMVOFFEN;
+		cptr_set |= CPTR_EL2_TAM;
+	}
+
+	/* Trap ASIMD */
+	if (!FIELD_GET(FEATURE(ID_AA64PFR0_ASIMD), feature_ids))
+		cptr_set |= CPTR_EL2_TFP;
+
+	/* Trap SVE */
+	if (!FIELD_GET(FEATURE(ID_AA64PFR0_SVE), feature_ids))
+		cptr_set |= CPTR_EL2_TZ;
+
+	vcpu->arch.hcr_el2 |= hcr_set;
+	vcpu->arch.hcr_el2 &= ~hcr_clear;
+	vcpu->arch.cptr_el2 |= cptr_set;
+}
+
+/*
+ * Set trap register values for features not allowed in ID_AA64PFR1.
+ */
+static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = PVM_ID_AA64PFR1_ALLOW;
+	u64 hcr_set = 0;
+	u64 hcr_clear = 0;
+
+	/* Memory Tagging: Trap and Treat as Untagged if not allowed. */
+	if (!FIELD_GET(FEATURE(ID_AA64PFR1_MTE), feature_ids)) {
+		hcr_set |= HCR_TID5;
+		hcr_clear |= HCR_DCT | HCR_ATA;
+	}
+
+	vcpu->arch.hcr_el2 |= hcr_set;
+	vcpu->arch.hcr_el2 &= ~hcr_clear;
+}
+
+/*
+ * Set trap register values for features not allowed in ID_AA64DFR0.
+ */
+static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = PVM_ID_AA64DFR0_ALLOW;
+	u64 mdcr_set = 0;
+	u64 mdcr_clear = 0;
+	u64 cptr_set = 0;
+
+	/* Trap/constrain PMU */
+	if (!FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), feature_ids)) {
+		mdcr_set |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
+		mdcr_clear |= MDCR_EL2_HPME | MDCR_EL2_MTPME |
+			      MDCR_EL2_HPMN_MASK;
+	}
+
+	/* Trap Debug */
+	if (!FIELD_GET(FEATURE(ID_AA64DFR0_DEBUGVER), feature_ids))
+		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
+
+	/* Trap OS Double Lock */
+	if (!FIELD_GET(FEATURE(ID_AA64DFR0_DOUBLELOCK), feature_ids))
+		mdcr_set |= MDCR_EL2_TDOSA;
+
+	/* Trap SPE */
+	if (!FIELD_GET(FEATURE(ID_AA64DFR0_PMSVER), feature_ids)) {
+		mdcr_set |= MDCR_EL2_TPMS;
+		mdcr_clear |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
+	}
+
+	/* Trap Trace Filter */
+	if (!FIELD_GET(FEATURE(ID_AA64DFR0_TRACE_FILT), feature_ids))
+		mdcr_set |= MDCR_EL2_TTRF;
+
+	/* Trap Trace */
+	if (!FIELD_GET(FEATURE(ID_AA64DFR0_TRACEVER), feature_ids))
+		cptr_set |= CPTR_EL2_TTA;
+
+	vcpu->arch.mdcr_el2 |= mdcr_set;
+	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
+	vcpu->arch.cptr_el2 |= cptr_set;
+}
+
+/*
+ * Set trap register values for features not allowed in ID_AA64MMFR0.
+ */
+static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = PVM_ID_AA64MMFR0_ALLOW;
+	u64 mdcr_set = 0;
+
+	/* Trap Debug Communications Channel registers */
+	if (!FIELD_GET(FEATURE(ID_AA64MMFR0_FGT), feature_ids))
+		mdcr_set |= MDCR_EL2_TDCC;
+
+	vcpu->arch.mdcr_el2 |= mdcr_set;
+}
+
+/*
+ * Set trap register values for features not allowed in ID_AA64MMFR1.
+ */
+static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = PVM_ID_AA64MMFR1_ALLOW;
+	u64 hcr_set = 0;
+
+	/* Trap LOR */
+	if (!FIELD_GET(FEATURE(ID_AA64MMFR1_LOR), feature_ids))
+		hcr_set |= HCR_TLOR;
+
+	vcpu->arch.hcr_el2 |= hcr_set;
+}
+
+/*
+ * Set baseline trap register values.
+ */
+static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
+{
+	const u64 hcr_trap_feat_regs = HCR_TID3;
+	const u64 hcr_trap_impdef = HCR_TACR | HCR_TIDCP | HCR_TID1;
+
+	/*
+	 * Always trap:
+	 * - Feature id registers: to control features exposed to guests
+	 * - Implementation-defined features
+	 */
+	vcpu->arch.hcr_el2 |= hcr_trap_feat_regs | hcr_trap_impdef;
+
+	/* Clear res0 and set res1 bits to trap potential new features. */
+	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
+	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
+	vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
+	vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
+}
+
+/*
+ * Initialize trap register values for protected VMs.
+ */
+void kvm_init_protected_traps(struct kvm_vcpu *vcpu)
+{
+	pvm_init_trap_regs(vcpu);
+	pvm_init_traps_aa64pfr0(vcpu);
+	pvm_init_traps_aa64pfr1(vcpu);
+	pvm_init_traps_aa64dfr0(vcpu);
+	pvm_init_traps_aa64mmfr0(vcpu);
+	pvm_init_traps_aa64mmfr1(vcpu);
+}
-- 
2.32.0.402.g57bb445576-goog

