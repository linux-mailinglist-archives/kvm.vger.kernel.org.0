Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D906D39F88D
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhFHONz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbhFHONz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:13:55 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846F8C061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 07:12:02 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q8-20020ad45ca80000b02902329fd23199so3495709qvh.7
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6LpaHhhXDpuJgRjjUnOsgzEC9sfOrmSwgfSTkrOttsw=;
        b=GIO8FUa4smoJYCrslqmevtuLVUP6gpOyRh7IU8lD6Ek2nygMIZotzOGhAORWkh/Cj1
         F0dincun5s1v6metdFPiKesJYwDbnlf8MQYTDBgvTAQRUl18Hc194t9qPThC1u61ltbO
         fG83EMPkAzbQ71/RyJppUmCpNihYXa2Lnd1ZW8LhRCVNzJ97Wc+zIEeAhG08BPHWWa8Z
         4lllK6MTsGN4YHZX7WHrepQ8tTRWfl1zWMXCXG4hpZxjUH6MdhGGpkK2xXsEPD21EKbG
         CFC5txoY6mfRA6M7f5OsHjYYg7j3SqS2OZcTMnuEgA2DAgcFQXrquGnKce//kOisLbCi
         lkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6LpaHhhXDpuJgRjjUnOsgzEC9sfOrmSwgfSTkrOttsw=;
        b=PL7vEBIzEGgUXBV8/iL+T0IlvwmQWHFqElIRK6Afszsk1YwnZxLMCgT7h5ZYZ6uQor
         7gkoLx3YyYbBIjJX6l8CiTZouuWHmJ/ecR7L0HpOFfWue4bGiaeGmww0aSYQaB0YHcnD
         BSdvAwA8u4xKRykzhQpo+04SYScLhqy096xaNLPicSwK6JApdvOQ7Da54krrDUnzzB4X
         EALvh8hT/Mmcf0An0R2dSndkKMx4uzNqmMyKgph+uEwHeBrW0XFKN4Kw/DkANvla7t7s
         Xkpn/BGR+GI3HKIcmy84o7VBCRvF2NiZkYCZoURwvYEkwT2Qy8rY1lh5qBA97StBisSh
         31pw==
X-Gm-Message-State: AOAM531t0j6Kgt+Rb+/KB3idbB5IL87S6E6/FhHtDSXfLlgzMam22sIG
        i/3lwjScYEm61FIShYwjggfBmG9jHA==
X-Google-Smtp-Source: ABdhPJw2ia6P/aSpSSG+OrbZNi8BHoG26Qv4QCU3TXzkzpitGwKHgrMivs9ODvFWz3Yd0kQBtIraA5J3GQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:aa13:: with SMTP id d19mr23638744qvb.3.1623161521645;
 Tue, 08 Jun 2021 07:12:01 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:37 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-10-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 09/13] KVM: arm64: Add trap handlers for protected VMs
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add trap handlers for protected VMs. These are mainly for Sys64
and debug traps.

No functional change intended as these are not hooked in yet.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |   4 +
 arch/arm64/kvm/arm.c               |   4 +
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 496 +++++++++++++++++++++++++++++
 4 files changed, 505 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..23d4e5aac41d 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -115,7 +115,11 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 #endif
 
+extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64dfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d71da6089822..a56ff3a6d2c0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1751,8 +1751,12 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
 	void *addr = phys_to_virt(hyp_mem_base);
 	int ret;
 
+	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64dfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
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
index 000000000000..890c96315e55
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -0,0 +1,496 @@
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
+#include <asm/kvm_mmu.h>
+
+#include <hyp/adjust_pc.h>
+
+#include "../../sys_regs.h"
+
+u64 id_aa64pfr0_el1_sys_val;
+u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64dfr0_el1_sys_val;
+u64 id_aa64mmfr2_el1_sys_val;
+
+/*
+ * Inject an undefined exception to the guest.
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
+	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
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
+/* Accessor for ID_AA64PFR0_EL1. */
+static bool pvm_access_id_aa64pfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	u64 clear_mask;
+	u64 set_mask;
+	u64 val = id_aa64pfr0_el1_sys_val;
+	const struct kvm *kvm = (const struct kvm *) kern_hyp_va(vcpu->kvm);
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for:
+	 * - AArch32 state for protected VMs
+	 * - GIC CPU Interface
+	 * - ARMv8.4-RAS (restricted to v1)
+	 * - Scalable Vectors
+	 * - Memory Partitioning and Monitoring
+	 * - Activity Monitoring
+	 * - Secure EL2 (not relevant to non-secure guests)
+	 */
+	clear_mask = SYS_FEATURE(ID_AA64PFR0_EL0) |
+		     SYS_FEATURE(ID_AA64PFR0_EL1) |
+		     SYS_FEATURE(ID_AA64PFR0_EL2) |
+		     SYS_FEATURE(ID_AA64PFR0_EL3) |
+		     SYS_FEATURE(ID_AA64PFR0_GIC) |
+		     SYS_FEATURE(ID_AA64PFR0_RAS) |
+		     SYS_FEATURE(ID_AA64PFR0_SVE) |
+		     SYS_FEATURE(ID_AA64PFR0_MPAM) |
+		     SYS_FEATURE(ID_AA64PFR0_AMU) |
+		     SYS_FEATURE(ID_AA64PFR0_SEL2) |
+		     SYS_FEATURE(ID_AA64PFR0_CSV2) |
+		     SYS_FEATURE(ID_AA64PFR0_CSV3);
+
+	set_mask = (ID_AA64PFR0_EL0_64BIT_ONLY << ID_AA64PFR0_EL0_SHIFT) |
+		   (ID_AA64PFR0_EL1_64BIT_ONLY << ID_AA64PFR0_EL1_SHIFT) |
+		   (ID_AA64PFR0_EL2_64BIT_ONLY << ID_AA64PFR0_EL2_SHIFT);
+
+	/* Only set EL3 handling if EL3 exists. */
+	if (val & SYS_FEATURE(ID_AA64PFR0_EL3))
+		set_mask |=
+			(ID_AA64PFR0_EL3_64BIT_ONLY << ID_AA64PFR0_EL3_SHIFT);
+
+	/* RAS restricted to v1 (0x1). */
+	if (val & SYS_FEATURE(ID_AA64PFR0_RAS))
+		set_mask |= FIELD_PREP(SYS_FEATURE(ID_AA64PFR0_RAS), 1);
+
+	/* Check whether Spectre and Meltdown are mitigated. */
+	set_mask |= FIELD_PREP(SYS_FEATURE(ID_AA64PFR0_CSV2),
+			       (u64)kvm->arch.pfr0_csv2);
+	set_mask |= FIELD_PREP(SYS_FEATURE(ID_AA64PFR0_CSV3),
+			       (u64)kvm->arch.pfr0_csv3);
+
+	p->regval = (val & ~clear_mask) | set_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64PFR1_EL1. */
+static bool pvm_access_id_aa64pfr1(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	u64 clear_mask;
+	u64 val = id_aa64pfr1_el1_sys_val;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for:
+	 * - ARMv8.4-RAS (restricted to v1)
+	 * - Memory Partitioning and Monitoring
+	 * - Memory Tagging
+	 */
+	clear_mask = SYS_FEATURE(ID_AA64PFR1_RASFRAC) |
+		     SYS_FEATURE(ID_AA64PFR1_MPAMFRAC) |
+		     SYS_FEATURE(ID_AA64PFR1_MTE);
+
+	p->regval = val & ~clear_mask;
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
+	/* No support for Scalable Vectors */
+	p->regval = 0;
+	return true;
+}
+
+/* Accessor for ID_AA64DFR0_EL1. */
+static bool pvm_access_id_aa64dfr0(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	u64 clear_mask;
+	u64 val = id_aa64dfr0_el1_sys_val;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for:
+	 * - Debug: includes breakpoints, and watchpoints.
+	 * Note: not supporting debug at all is not arch-compliant.
+	 * - OS Double Lock
+	 * - Trace and Self Hosted Trace
+	 * - Performance Monitoring
+	 * - Statistical Profiling
+	 */
+	clear_mask = SYS_FEATURE(ID_AA64DFR0_DEBUGVER) |
+		     SYS_FEATURE(ID_AA64DFR0_BRPS) |
+		     SYS_FEATURE(ID_AA64DFR0_WRPS) |
+		     SYS_FEATURE(ID_AA64DFR0_CTX_CMPS) |
+		     SYS_FEATURE(ID_AA64DFR0_DOUBLELOCK) |
+		     SYS_FEATURE(ID_AA64DFR0_TRACEVER) |
+		     SYS_FEATURE(ID_AA64DFR0_TRACE_FILT) |
+		     SYS_FEATURE(ID_AA64DFR0_PMUVER) |
+		     SYS_FEATURE(ID_AA64DFR0_MTPMU) |
+		     SYS_FEATURE(ID_AA64DFR0_PMSVER);
+
+	p->regval = val & ~clear_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR0_EL1. */
+static bool pvm_access_id_aa64mmfr0(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	u64 clear_mask;
+	u64 set_mask;
+	u64 val = id_aa64mmfr0_el1_sys_val;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for:
+	 * - Nested Virtualization
+	 *
+	 * Only support for:
+	 * - 4KB granule
+	 * - 40-bit IPA
+	 */
+	clear_mask = SYS_FEATURE(ID_AA64MMFR0_ECV) |
+		     SYS_FEATURE(ID_AA64MMFR0_FGT) |
+		     SYS_FEATURE(ID_AA64MMFR0_TGRAN4_2) |
+		     SYS_FEATURE(ID_AA64MMFR0_TGRAN64_2) |
+		     SYS_FEATURE(ID_AA64MMFR0_TGRAN16_2) |
+		     SYS_FEATURE(ID_AA64MMFR0_TGRAN4) |
+		     SYS_FEATURE(ID_AA64MMFR0_TGRAN16) |
+		     SYS_FEATURE(ID_AA64MMFR0_PARANGE);
+
+	set_mask = SYS_FEATURE(ID_AA64MMFR0_TGRAN64) |
+		   (ID_AA64MMFR0_PARANGE_40 << ID_AA64MMFR0_PARANGE_SHIFT);
+
+	p->regval = (val & ~clear_mask) | set_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR1_EL1. */
+static bool pvm_access_id_aa64mmfr1(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	u64 clear_mask;
+	u64 val = id_aa64mmfr1_el1_sys_val;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for:
+	 * - Nested Virtualization
+	 * - Limited Ordering Regions
+	 */
+	clear_mask = SYS_FEATURE(ID_AA64MMFR1_TWED) |
+		     SYS_FEATURE(ID_AA64MMFR1_XNX) |
+		     SYS_FEATURE(ID_AA64MMFR1_VHE) |
+		     SYS_FEATURE(ID_AA64MMFR1_LOR);
+
+	p->regval = val & ~clear_mask;
+	return true;
+}
+
+/* Accessor for ID_AA64MMFR2_EL1. */
+static bool pvm_access_id_aa64mmfr2(struct kvm_vcpu *vcpu,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	u64 clear_mask;
+	u64 val = id_aa64mmfr2_el1_sys_val;
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * No support for:
+	 * - Nested Virtualization
+	 * - Small translation tables
+	 * - 64-bit format of CCSIDR_EL1
+	 * - 52-bit VAs
+	 * - AArch32 state for protected VMs
+	 */
+	clear_mask = SYS_FEATURE(ID_AA64MMFR2_EVT) |
+		     SYS_FEATURE(ID_AA64MMFR2_FWB) |
+		     SYS_FEATURE(ID_AA64MMFR2_NV) |
+		     SYS_FEATURE(ID_AA64MMFR2_ST) |
+		     SYS_FEATURE(ID_AA64MMFR2_CCIDX) |
+		     SYS_FEATURE(ID_AA64MMFR2_LVA) |
+		     SYS_FEATURE(ID_AA64MMFR2_LSM);
+
+	p->regval = val & ~clear_mask;
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
-- 
2.32.0.rc1.229.g3e70b5a671-goog

