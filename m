Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E700F23CE9B
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgHESgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgHES1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4E4B22D6F;
        Wed,  5 Aug 2020 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651992;
        bh=Qb7b2h0IscN4Tyvpc8jbgw5a2ZVsIZ1sqfWWGF8CpAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKw2DeJ/RdK1RClpvJSfLAV84l+4jepEgtvAovq/gvKqzEmiZufvPSfVRduTle6mY
         PeWq+sVDufM864SyLMd2gg9L1mEX8oDtEGSuif3OHeLAFOaGJvdMrnZHTKVbXCho53
         boBOzSsxxTF3JZiCf14Z9UBMy3dczW/Acky9j2tM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfT-0004w9-QC; Wed, 05 Aug 2020 18:57:37 +0100
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
Subject: [PATCH 20/56] KVM: arm64: Duplicate hyp/tlb.c for VHE/nVHE
Date:   Wed,  5 Aug 2020 18:56:24 +0100
Message-Id: <20200805175700.62775-21-maz@kernel.org>
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

tlb.c contains code for flushing the TLB, with code shared between VHE/nVHE.
Because common code is small, duplicate tlb.c and specialize each copy for
VHE/nVHE.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-9-dbrazdil@google.com
---
 arch/arm64/kernel/image-vars.h      |  14 +--
 arch/arm64/kvm/hyp/Makefile         |   2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile    |   2 +-
 arch/arm64/kvm/hyp/{ => nvhe}/tlb.c |  96 +----------------
 arch/arm64/kvm/hyp/vhe/Makefile     |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c        | 161 ++++++++++++++++++++++++++++
 6 files changed, 177 insertions(+), 100 deletions(-)
 rename arch/arm64/kvm/hyp/{ => nvhe}/tlb.c (61%)
 create mode 100644 arch/arm64/kvm/hyp/vhe/tlb.c

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 63186c91b614..f029f3ea7ffe 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -81,12 +81,6 @@ KVM_NVHE_ALIAS(__kvm_enable_ssbs);
 /* Symbols defined in timer-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_timer_set_cntvoff);
 
-/* Symbols defined in tlb.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__kvm_flush_vm_context);
-KVM_NVHE_ALIAS(__kvm_tlb_flush_local_vmid);
-KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid);
-KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid_ipa);
-
 /* Symbols defined in vgic-v3-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__vgic_v3_get_ich_vtr_el2);
 KVM_NVHE_ALIAS(__vgic_v3_init_lrs);
@@ -116,6 +110,14 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
 /* IDMAP TCR_EL1.T0SZ as computed by the EL1 init code */
 KVM_NVHE_ALIAS(idmap_t0sz);
 
+/* Kernel symbol used by icache_is_vpipt(). */
+KVM_NVHE_ALIAS(__icache_flags);
+
+/* Kernel symbols needed for cpus_have_final/const_caps checks. */
+KVM_NVHE_ALIAS(arm64_const_caps_ready);
+KVM_NVHE_ALIAS(cpu_hwcap_keys);
+KVM_NVHE_ALIAS(cpu_hwcaps);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 8b0cf85080b5..87d3cce2b26e 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
 hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
-	 debug-sr.o entry.o switch.o fpsimd.o tlb.o
+	 debug-sr.o entry.o switch.o fpsimd.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index bf2d8dea5400..a5316e97d373 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := hyp-init.o ../hyp-entry.o
+obj-y := tlb.o hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
similarity index 61%
rename from arch/arm64/kvm/hyp/tlb.c
rename to arch/arm64/kvm/hyp/nvhe/tlb.c
index d063a576d511..deb48c8c00ee 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -4,64 +4,16 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <linux/irqflags.h>
-
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/tlbflush.h>
 
 struct tlb_inv_context {
-	unsigned long	flags;
 	u64		tcr;
-	u64		sctlr;
 };
 
-static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
-						 struct tlb_inv_context *cxt)
-{
-	u64 val;
-
-	local_irq_save(cxt->flags);
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		/*
-		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
-		 * we cannot trust stage-1 to be in a correct state at that
-		 * point. Since we do not want to force a full load of the
-		 * vcpu state, we prevent the EL1 page-table walker to
-		 * allocate new TLBs. This is done by setting the EPD bits
-		 * in the TCR_EL1 register. We also need to prevent it to
-		 * allocate IPA->PA walks, so we enable the S1 MMU...
-		 */
-		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
-		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
-		write_sysreg_el1(val, SYS_TCR);
-		val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
-		val |= SCTLR_ELx_M;
-		write_sysreg_el1(val, SYS_SCTLR);
-	}
-
-	/*
-	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
-	 * most TLB operations target EL2/EL0. In order to affect the
-	 * guest TLBs (EL1/EL0), we need to change one of these two
-	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
-	 * let's flip TGE before executing the TLB operation.
-	 *
-	 * ARM erratum 1165522 requires some special handling (again),
-	 * as we need to make sure both stages of translation are in
-	 * place before clearing TGE. __load_guest_stage2() already
-	 * has an ISB in order to deal with this.
-	 */
-	__load_guest_stage2(kvm);
-	val = read_sysreg(hcr_el2);
-	val &= ~HCR_TGE;
-	write_sysreg(val, hcr_el2);
-	isb();
-}
-
-static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
-						  struct tlb_inv_context *cxt)
+static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
+					     struct tlb_inv_context *cxt)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
@@ -84,37 +36,8 @@ static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
 	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
-static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
-					     struct tlb_inv_context *cxt)
-{
-	if (has_vhe())
-		__tlb_switch_to_guest_vhe(kvm, cxt);
-	else
-		__tlb_switch_to_guest_nvhe(kvm, cxt);
-}
-
-static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
-						struct tlb_inv_context *cxt)
-{
-	/*
-	 * We're done with the TLB operation, let's restore the host's
-	 * view of HCR_EL2.
-	 */
-	write_sysreg(0, vttbr_el2);
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
-	isb();
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		/* Restore the registers to what they were */
-		write_sysreg_el1(cxt->tcr, SYS_TCR);
-		write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
-	}
-
-	local_irq_restore(cxt->flags);
-}
-
-static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
-						 struct tlb_inv_context *cxt)
+static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
+					    struct tlb_inv_context *cxt)
 {
 	write_sysreg(0, vttbr_el2);
 
@@ -126,15 +49,6 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
 	}
 }
 
-static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
-					    struct tlb_inv_context *cxt)
-{
-	if (has_vhe())
-		__tlb_switch_to_host_vhe(kvm, cxt);
-	else
-		__tlb_switch_to_host_nvhe(kvm, cxt);
-}
-
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	struct tlb_inv_context cxt;
@@ -183,7 +97,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * The moral of this story is: if you have a VPIPT I-cache, then
 	 * you should be running with VHE enabled.
 	 */
-	if (!has_vhe() && icache_is_vpipt())
+	if (icache_is_vpipt())
 		__flush_icache_all();
 
 	__tlb_switch_to_host(kvm, &cxt);
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 323029e02b4e..704140fc5d66 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := ../hyp-entry.o
+obj-y := tlb.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
new file mode 100644
index 000000000000..b275101e9c9c
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <linux/irqflags.h>
+
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <asm/tlbflush.h>
+
+struct tlb_inv_context {
+	unsigned long	flags;
+	u64		tcr;
+	u64		sctlr;
+};
+
+static void __tlb_switch_to_guest(struct kvm *kvm, struct tlb_inv_context *cxt)
+{
+	u64 val;
+
+	local_irq_save(cxt->flags);
+
+	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
+		/*
+		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
+		 * we cannot trust stage-1 to be in a correct state at that
+		 * point. Since we do not want to force a full load of the
+		 * vcpu state, we prevent the EL1 page-table walker to
+		 * allocate new TLBs. This is done by setting the EPD bits
+		 * in the TCR_EL1 register. We also need to prevent it to
+		 * allocate IPA->PA walks, so we enable the S1 MMU...
+		 */
+		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
+		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
+		write_sysreg_el1(val, SYS_TCR);
+		val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
+		val |= SCTLR_ELx_M;
+		write_sysreg_el1(val, SYS_SCTLR);
+	}
+
+	/*
+	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
+	 * most TLB operations target EL2/EL0. In order to affect the
+	 * guest TLBs (EL1/EL0), we need to change one of these two
+	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
+	 * let's flip TGE before executing the TLB operation.
+	 *
+	 * ARM erratum 1165522 requires some special handling (again),
+	 * as we need to make sure both stages of translation are in
+	 * place before clearing TGE. __load_guest_stage2() already
+	 * has an ISB in order to deal with this.
+	 */
+	__load_guest_stage2(kvm);
+	val = read_sysreg(hcr_el2);
+	val &= ~HCR_TGE;
+	write_sysreg(val, hcr_el2);
+	isb();
+}
+
+static void __tlb_switch_to_host(struct kvm *kvm, struct tlb_inv_context *cxt)
+{
+	/*
+	 * We're done with the TLB operation, let's restore the host's
+	 * view of HCR_EL2.
+	 */
+	write_sysreg(0, vttbr_el2);
+	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	isb();
+
+	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
+		/* Restore the registers to what they were */
+		write_sysreg_el1(cxt->tcr, SYS_TCR);
+		write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
+	}
+
+	local_irq_restore(cxt->flags);
+}
+
+void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(kvm, &cxt);
+
+	/*
+	 * We could do so much better if we had the VA as well.
+	 * Instead, we invalidate Stage-2 for this IPA, and the
+	 * whole of Stage-1. Weep...
+	 */
+	ipa >>= 12;
+	__tlbi(ipas2e1is, ipa);
+
+	/*
+	 * We have to ensure completion of the invalidation at Stage-2,
+	 * since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
+	 * the Stage-1 invalidation happened first.
+	 */
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(kvm, &cxt);
+}
+
+void __kvm_tlb_flush_vmid(struct kvm *kvm)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(kvm, &cxt);
+
+	__tlbi(vmalls12e1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(kvm, &cxt);
+}
+
+void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct tlb_inv_context cxt;
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(kvm, &cxt);
+
+	__tlbi(vmalle1);
+	dsb(nsh);
+	isb();
+
+	__tlb_switch_to_host(kvm, &cxt);
+}
+
+void __kvm_flush_vm_context(void)
+{
+	dsb(ishst);
+	__tlbi(alle1is);
+
+	/*
+	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
+	 * is necessary across a VMID rollover.
+	 *
+	 * VPIPT caches constrain lookup and maintenance to the active VMID,
+	 * so we need to invalidate lines with a stale VMID to avoid an ABA
+	 * race after multiple rollovers.
+	 *
+	 */
+	if (icache_is_vpipt())
+		asm volatile("ic ialluis");
+
+	dsb(ish);
+}
-- 
2.27.0

