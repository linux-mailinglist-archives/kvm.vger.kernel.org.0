Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0101A428211
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhJJO64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhJJO6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:58:55 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37486C061570
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:57 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id c30-20020a50f61e000000b003daf3955d5aso13524015edn.4
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/kzpdl8qb8YxD7/pSrMpSy4ZVDEXMwybqCFHaV65VlA=;
        b=p4kgYiZDyA3NuBAbYotvfD8uiPebKOduHD3TRsKYGz3B5P/XfbSKQOxoIQjK/cYzr/
         d2O+hNVyoZUsG/EssSQehirxdBzXVE6/noGcYVZXCwg9GcmuBNOW7OBigtiE3C0H2m5R
         lEvyLulH/5OewXkBRBmgDrtpe9gYre0UMFVYKGsdPRUfytjGH1bmq1rt6CGS+vPvaDH7
         RaDvfxDRuyKzSfvEhedKUI3KcCT+sbullnemNyFJu2x/qkBv0Kd+yx98xeydB5/ZBFUc
         CgDDbpGxnSV/4tNuwg6HGXiFFSW68ty5/hWKwwpmkeJo6F3T4xr672lO+36Bmw2qRW5B
         j/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/kzpdl8qb8YxD7/pSrMpSy4ZVDEXMwybqCFHaV65VlA=;
        b=w45R6hn6/n1oPjuwWqVGCWoN9sEY/ZkF+04dl25BBdYVZ2Ck5LEyRKo16+kUA20U1F
         XtYfDCqcdwuHtyB1r8ultVwSpUy/vNjaiSG8x/emZz4jhREhGsPWad3tefN5N25Kc4gE
         F3YGwtsF8vNRuf2pt3G4t2V3JX0Z2LjutzkVLiJoJvTdsEYTct8Ex4mSqvfCgcCoNx8g
         UnirBa0xhRG1Py8mEjJfeKMs7OLpBShTz9PqtUoODkCJ672R4vChrdvITQKd1m7eRnQB
         tE2HME6/m4Ba0uiZTyxhBNdauqfCkCFqpYFDVTc+GiCGjxsnPFn/cP6DePzO9ACw3Fre
         0LXA==
X-Gm-Message-State: AOAM532V2CKbLTFLccJEcRCo//huqxqn9Z8HcQZmLEOnCk06iLBCt1Jb
        RPZqEoVsYb9PQ0yJ/88vtZwVaxsRQw==
X-Google-Smtp-Source: ABdhPJw5qkA9Eu4TRl3/6nmdwcn+i5wZknUBVx7T38mw7TzU9xGFxxM2vkxBAiOOjGmYBt3cet2jjF3sdQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6402:4305:: with SMTP id
 m5mr32265479edc.277.1633877815712; Sun, 10 Oct 2021 07:56:55 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:33 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-9-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 08/11] KVM: arm64: Initialize trap registers for protected VMs
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected VMs have more restricted features that need to be
trapped. Moreover, the host should not be trusted to set the
appropriate trapping registers and their values.

Initialize the trapping registers, i.e., hcr_el2, mdcr_el2, and
cptr_el2 at EL2 for protected guests, based on the values of the
guest's feature id registers.

No functional change intended as trap handlers introduced in the
previous patch are still not hooked in to the guest exit
handlers.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/kvm/arm.c                          |   8 +
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   9 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 186 ++++++++++++++++++
 7 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e86045ac43ba..a460e1243cef 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -64,6 +64,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
 #define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			20
+#define __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps		21
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..4a323aa27a6b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -780,6 +780,8 @@ static inline bool kvm_vm_is_protected(struct kvm *kvm)
 	return false;
 }
 
+void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6aa7b0c5bf21..3af6d59d1919 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -620,6 +620,14 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
 
+	/*
+	 * Initialize traps for protected VMs.
+	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
+	 * the code is in place for first run initialization at EL2.
+	 */
+	if (kvm_vm_is_protected(kvm))
+		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
index 1e6d995968a1..45a84f0ade04 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
@@ -15,4 +15,6 @@
 #define DECLARE_REG(type, name, ctxt, reg)	\
 				type name = (type)cpu_reg(ctxt, (reg))
 
+void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0bbe37a18d5d..c3c11974fa3b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8ca1104f4774..a6303db09cd6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -160,6 +160,14 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 {
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
+
+static void handle___pkvm_vcpu_init_traps(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+
+	__pkvm_vcpu_init_traps(kern_hyp_va(vcpu));
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -185,6 +193,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_prot_finalize),
+	HANDLE_FUNC(__pkvm_vcpu_init_traps),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
new file mode 100644
index 000000000000..633547cc1033
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 Google LLC
+ * Author: Fuad Tabba <tabba@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/mm.h>
+#include <asm/kvm_fixed_config.h>
+#include <nvhe/sys_regs.h>
+#include <nvhe/trap_handler.h>
+
+/*
+ * Set trap register values based on features in ID_AA64PFR0.
+ */
+static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = get_pvm_id_aa64pfr0(vcpu);
+	u64 hcr_set = HCR_RW;
+	u64 hcr_clear = 0;
+	u64 cptr_set = 0;
+
+	/* Protected KVM does not support AArch32 guests. */
+	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
+		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_ELx_64BIT_ONLY);
+	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1),
+		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_ELx_64BIT_ONLY);
+
+	/*
+	 * Linux guests assume support for floating-point and Advanced SIMD. Do
+	 * not change the trapping behavior for these from the KVM default.
+	 */
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
+				PVM_ID_AA64PFR0_ALLOW));
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
+				PVM_ID_AA64PFR0_ALLOW));
+
+	/* Trap RAS unless all current versions are supported */
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_RAS), feature_ids) <
+	    ID_AA64PFR0_RAS_V1P1) {
+		hcr_set |= HCR_TERR | HCR_TEA;
+		hcr_clear |= HCR_FIEN;
+	}
+
+	/* Trap AMU */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_AMU), feature_ids)) {
+		hcr_clear |= HCR_AMVOFFEN;
+		cptr_set |= CPTR_EL2_TAM;
+	}
+
+	/* Trap SVE */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE), feature_ids))
+		cptr_set |= CPTR_EL2_TZ;
+
+	vcpu->arch.hcr_el2 |= hcr_set;
+	vcpu->arch.hcr_el2 &= ~hcr_clear;
+	vcpu->arch.cptr_el2 |= cptr_set;
+}
+
+/*
+ * Set trap register values based on features in ID_AA64PFR1.
+ */
+static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = get_pvm_id_aa64pfr1(vcpu);
+	u64 hcr_set = 0;
+	u64 hcr_clear = 0;
+
+	/* Memory Tagging: Trap and Treat as Untagged if not supported. */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), feature_ids)) {
+		hcr_set |= HCR_TID5;
+		hcr_clear |= HCR_DCT | HCR_ATA;
+	}
+
+	vcpu->arch.hcr_el2 |= hcr_set;
+	vcpu->arch.hcr_el2 &= ~hcr_clear;
+}
+
+/*
+ * Set trap register values based on features in ID_AA64DFR0.
+ */
+static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = get_pvm_id_aa64dfr0(vcpu);
+	u64 mdcr_set = 0;
+	u64 mdcr_clear = 0;
+	u64 cptr_set = 0;
+
+	/* Trap/constrain PMU */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), feature_ids)) {
+		mdcr_set |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
+		mdcr_clear |= MDCR_EL2_HPME | MDCR_EL2_MTPME |
+			      MDCR_EL2_HPMN_MASK;
+	}
+
+	/* Trap Debug */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), feature_ids))
+		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
+
+	/* Trap OS Double Lock */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), feature_ids))
+		mdcr_set |= MDCR_EL2_TDOSA;
+
+	/* Trap SPE */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER), feature_ids)) {
+		mdcr_set |= MDCR_EL2_TPMS;
+		mdcr_clear |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
+	}
+
+	/* Trap Trace Filter */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_TRACE_FILT), feature_ids))
+		mdcr_set |= MDCR_EL2_TTRF;
+
+	/* Trap Trace */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_TRACEVER), feature_ids))
+		cptr_set |= CPTR_EL2_TTA;
+
+	vcpu->arch.mdcr_el2 |= mdcr_set;
+	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
+	vcpu->arch.cptr_el2 |= cptr_set;
+}
+
+/*
+ * Set trap register values based on features in ID_AA64MMFR0.
+ */
+static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = get_pvm_id_aa64mmfr0(vcpu);
+	u64 mdcr_set = 0;
+
+	/* Trap Debug Communications Channel registers */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_FGT), feature_ids))
+		mdcr_set |= MDCR_EL2_TDCC;
+
+	vcpu->arch.mdcr_el2 |= mdcr_set;
+}
+
+/*
+ * Set trap register values based on features in ID_AA64MMFR1.
+ */
+static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
+{
+	const u64 feature_ids = get_pvm_id_aa64mmfr1(vcpu);
+	u64 hcr_set = 0;
+
+	/* Trap LOR */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_LOR), feature_ids))
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
+void __pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+{
+	pvm_init_trap_regs(vcpu);
+	pvm_init_traps_aa64pfr0(vcpu);
+	pvm_init_traps_aa64pfr1(vcpu);
+	pvm_init_traps_aa64dfr0(vcpu);
+	pvm_init_traps_aa64mmfr0(vcpu);
+	pvm_init_traps_aa64mmfr1(vcpu);
+}
-- 
2.33.0.882.g93a45727a2-goog

