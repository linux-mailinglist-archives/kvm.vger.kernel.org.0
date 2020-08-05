Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1523523CF0E
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgHETMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgHES1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48EF122D02;
        Wed,  5 Aug 2020 18:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651965;
        bh=7dzCAUrVpnVcxtjV5qyu8K3K2a9RXob2h7gzE+K9hy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JT9WPW6IbixVZ/79JlZS6hIO/uzrerK2npuYXbKedw7vRBdGSYqe24eRTP2ShuYyc
         8I1FKQr3mBa5YfIUntxVVK2NCT/ylBOwaZd+gyrxbRnFQzEN7i4wcGQwQ05Yo0obVy
         HaUzFV6M/y8gVeJcjwMCyJH+YcR8etbuaozQOx5E=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfX-0004w9-2V; Wed, 05 Aug 2020 18:57:39 +0100
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
Subject: [PATCH 22/56] KVM: arm64: Split hyp/debug-sr.c to VHE/nVHE
Date:   Wed,  5 Aug 2020 18:56:26 +0100
Message-Id: <20200805175700.62775-23-maz@kernel.org>
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

debug-sr.c contains KVM's code for context-switching debug registers, with some
code shared between VHE/nVHE. These common routines are moved to a header file,
VHE-specific code is moved to vhe/debug-sr.c and nVHE-specific code to
nvhe/debug-sr.c.

Functions are slightly refactored to move code hidden behind `has_vhe()` checks
to the corresponding .c files.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-11-dbrazdil@google.com
---
 arch/arm64/kernel/image-vars.h                |  5 --
 arch/arm64/kvm/hyp/Makefile                   |  2 +-
 .../{debug-sr.c => include/hyp/debug-sr.h}    | 78 +++----------------
 arch/arm64/kvm/hyp/nvhe/Makefile              |  2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            | 77 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile               |  2 +-
 arch/arm64/kvm/hyp/vhe/debug-sr.c             | 26 +++++++
 7 files changed, 118 insertions(+), 74 deletions(-)
 rename arch/arm64/kvm/hyp/{debug-sr.c => include/hyp/debug-sr.h} (71%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/debug-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/debug-sr.c

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 06fe9833104a..c44ca4e7dd66 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -66,11 +66,6 @@ __efistub__ctype		= _ctype;
 /* Symbols defined in aarch32.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(kvm_skip_instr32);
 
-/* Symbols defined in debug-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__debug_switch_to_guest);
-KVM_NVHE_ALIAS(__debug_switch_to_host);
-KVM_NVHE_ALIAS(__kvm_get_mdcr_el2);
-
 /* Symbols defined in entry.S (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__guest_enter);
 KVM_NVHE_ALIAS(__guest_exit);
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 7462d3a8a6f2..fc09025d2e97 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
 hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
-	 debug-sr.o entry.o fpsimd.o
+	 entry.o fpsimd.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
similarity index 71%
rename from arch/arm64/kvm/hyp/debug-sr.c
rename to arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index e95af204fec7..e041dbd23243 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -4,6 +4,9 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#ifndef __ARM64_KVM_HYP_DEBUG_SR_H__
+#define __ARM64_KVM_HYP_DEBUG_SR_H__
+
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
@@ -85,53 +88,9 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
-{
-	u64 reg;
-
-	/* Clear pmscr in case of early return */
-	*pmscr_el1 = 0;
-
-	/* SPE present on this CPU? */
-	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
-						  ID_AA64DFR0_PMSVER_SHIFT))
-		return;
-
-	/* Yes; is it owned by EL3? */
-	reg = read_sysreg_s(SYS_PMBIDR_EL1);
-	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
-		return;
-
-	/* No; is the host actually using the thing? */
-	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
-	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
-		return;
-
-	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
-	write_sysreg_s(0, SYS_PMSCR_EL1);
-	isb();
-
-	/* Now drain all buffered data to memory */
-	psb_csync();
-	dsb(nsh);
-}
-
-static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
-{
-	if (!pmscr_el1)
-		return;
-
-	/* The host page table is installed, but not yet synchronised */
-	isb();
-
-	/* Re-enable data generation */
-	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
-}
-
-static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-					  struct kvm_guest_debug_arch *dbg,
-					  struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
+						 struct kvm_guest_debug_arch *dbg,
+						 struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -148,9 +107,9 @@ static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
 	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
 }
 
-static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
-					     struct kvm_guest_debug_arch *dbg,
-					     struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
+						    struct kvm_guest_debug_arch *dbg,
+						    struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
@@ -168,20 +127,13 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
-	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -194,16 +146,13 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -218,7 +167,4 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
-u32 __hyp_text __kvm_get_mdcr_el2(void)
-{
-	return read_sysreg(mdcr_el2);
-}
+#endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8b3ac38eaa44..b3cb67b63d67 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := switch.o tlb.o hyp-init.o ../hyp-entry.o
+obj-y := debug-sr.o switch.o tlb.o hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
new file mode 100644
index 000000000000..828c0d48e790
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/debug-sr.h>
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/debug-monitors.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+static void __hyp_text __debug_save_spe(u64 *pmscr_el1)
+{
+	u64 reg;
+
+	/* Clear pmscr in case of early return */
+	*pmscr_el1 = 0;
+
+	/* SPE present on this CPU? */
+	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
+						  ID_AA64DFR0_PMSVER_SHIFT))
+		return;
+
+	/* Yes; is it owned by EL3? */
+	reg = read_sysreg_s(SYS_PMBIDR_EL1);
+	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
+		return;
+
+	/* No; is the host actually using the thing? */
+	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (!(reg & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)))
+		return;
+
+	/* Yes; save the control register and disable data generation */
+	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
+	write_sysreg_s(0, SYS_PMSCR_EL1);
+	isb();
+
+	/* Now drain all buffered data to memory */
+	psb_csync();
+	dsb(nsh);
+}
+
+static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
+{
+	if (!pmscr_el1)
+		return;
+
+	/* The host page table is installed, but not yet synchronised */
+	isb();
+
+	/* Re-enable data generation */
+	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
+}
+
+void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	/* Disable and flush SPE data generation */
+	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+	__debug_switch_to_guest_common(vcpu);
+}
+
+void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+	__debug_switch_to_host_common(vcpu);
+}
+
+u32 __hyp_text __kvm_get_mdcr_el2(void)
+{
+	return read_sysreg(mdcr_el2);
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 9f71cd3ba50d..62bdaf272b03 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := switch.o tlb.o ../hyp-entry.o
+obj-y := debug-sr.o switch.o tlb.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
new file mode 100644
index 000000000000..f1e2e5a00933
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/debug-sr.h>
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_hyp.h>
+
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	__debug_switch_to_guest_common(vcpu);
+}
+
+void __debug_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	__debug_switch_to_host_common(vcpu);
+}
+
+u32 __kvm_get_mdcr_el2(void)
+{
+	return read_sysreg(mdcr_el2);
+}
-- 
2.27.0

