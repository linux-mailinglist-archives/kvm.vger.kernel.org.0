Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4140F2D60CE
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403879AbgLJQCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403861AbgLJQBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:01:55 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28B323E1E;
        Thu, 10 Dec 2020 16:00:37 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knOMu-0008Di-1L; Thu, 10 Dec 2020 16:00:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Jintack Lim <jintack.lim@linaro.org>
Subject: [PATCH v3 09/66] KVM: arm64: nv: Support virtual EL2 exceptions
Date:   Thu, 10 Dec 2020 15:59:05 +0000
Message-Id: <20201210160002.1407373-10-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, jintack.lim@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Support injecting exceptions and performing exception returns to and
from virtual EL2.  This must be done entirely in software except when
taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
== {1,1}  (a VHE guest hypervisor).

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: switch to common exception injection framework]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h     |  17 +++
 arch/arm64/include/asm/kvm_emulate.h |  10 ++
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/emulate-nested.c      | 176 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/exception.c       |  44 +++++--
 arch/arm64/kvm/inject_fault.c        |  62 ++++++++--
 arch/arm64/kvm/trace_arm.h           |  59 +++++++++
 7 files changed, 352 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm64/kvm/emulate-nested.c

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4e90c2debf70..e9e10e498785 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -332,4 +332,21 @@
 #define CPACR_EL1_TTA		(1 << 28)
 #define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN | CPACR_EL1_ZEN_EL1EN)
 
+#define kvm_mode_names				\
+	{ PSR_MODE_EL0t,	"EL0t" },	\
+	{ PSR_MODE_EL1t,	"EL1t" },	\
+	{ PSR_MODE_EL1h,	"EL1h" },	\
+	{ PSR_MODE_EL2t,	"EL2t" },	\
+	{ PSR_MODE_EL2h,	"EL2h" },	\
+	{ PSR_MODE_EL3t,	"EL3t" },	\
+	{ PSR_MODE_EL3h,	"EL3h" },	\
+	{ PSR_AA32_MODE_USR,	"32-bit USR" },	\
+	{ PSR_AA32_MODE_FIQ,	"32-bit FIQ" },	\
+	{ PSR_AA32_MODE_IRQ,	"32-bit IRQ" },	\
+	{ PSR_AA32_MODE_SVC,	"32-bit SVC" },	\
+	{ PSR_AA32_MODE_ABT,	"32-bit ABT" },	\
+	{ PSR_AA32_MODE_HYP,	"32-bit HYP" },	\
+	{ PSR_AA32_MODE_UND,	"32-bit UND" },	\
+	{ PSR_AA32_MODE_SYS,	"32-bit SYS" }
+
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e3e22d364dc9..deffd3cc4443 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -33,6 +33,12 @@ enum exception_type {
 	except_type_serror	= 0x180,
 };
 
+#define kvm_exception_type_names		\
+	{ except_type_sync,	"SYNC"   },	\
+	{ except_type_irq,	"IRQ"    },	\
+	{ except_type_fiq,	"FIQ"    },	\
+	{ except_type_serror,	"SERROR" }
+
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
@@ -41,6 +47,10 @@ void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
+int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
+int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
+
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 60fd181df624..672acdf1e993 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -17,11 +17,11 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 arch_timer.o \
+	 emulate-nested.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
-
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
new file mode 100644
index 000000000000..ee91bcd925d8
--- /dev/null
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -0,0 +1,176 @@
+/*
+ * Copyright (C) 2016 - Linaro and Columbia University
+ * Author: Jintack Lim <jintack.lim@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
+
+#include "hyp/include/hyp/adjust_pc.h"
+
+#include "trace.h"
+
+void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
+{
+	u64 spsr, elr, mode;
+	bool direct_eret;
+
+	/*
+	 * Going through the whole put/load motions is a waste of time
+	 * if this is a VHE guest hypervisor returning to its own
+	 * userspace, or the hypervisor performing a local exception
+	 * return. No need to save/restore registers, no need to
+	 * switch S2 MMU. Just do the canonical ERET.
+	 */
+	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
+	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	direct_eret  = (mode == PSR_MODE_EL0t &&
+			vcpu_el2_e2h_is_set(vcpu) &&
+			vcpu_el2_tge_is_set(vcpu));
+	direct_eret |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
+
+	if (direct_eret) {
+		*vcpu_pc(vcpu) = vcpu_read_sys_reg(vcpu, ELR_EL2);
+		*vcpu_cpsr(vcpu) = spsr;
+		trace_kvm_nested_eret(vcpu, *vcpu_pc(vcpu), spsr);
+		return;
+	}
+
+	preempt_disable();
+	kvm_arch_vcpu_put(vcpu);
+
+	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
+
+	trace_kvm_nested_eret(vcpu, elr, spsr);
+
+	/*
+	 * Note that the current exception level is always the virtual EL2,
+	 * since we set HCR_EL2.NV bit only when entering the virtual EL2.
+	 */
+	*vcpu_pc(vcpu) = elr;
+	*vcpu_cpsr(vcpu) = spsr;
+
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	preempt_enable();
+}
+
+static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
+				     enum exception_type type)
+{
+	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
+
+	switch (type) {
+	case except_type_sync:
+		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_ELx_SYNC;
+		break;
+	case except_type_irq:
+		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_ELx_IRQ;
+		break;
+	default:
+		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);
+	}
+
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL2		|
+			     KVM_ARM64_PENDING_EXCEPTION);
+
+	vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
+}
+
+/*
+ * Emulate taking an exception to EL2.
+ * See ARM ARM J8.1.2 AArch64.TakeException()
+ */
+static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
+			     enum exception_type type)
+{
+	u64 pstate, mode;
+	bool direct_inject;
+
+	if (!nested_virt_in_use(vcpu)) {
+		kvm_err("Unexpected call to %s for the non-nesting configuration\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * As for ERET, we can avoid doing too much on the injection path by
+	 * checking that we either took the exception from a VHE host
+	 * userspace or from vEL2. In these cases, there is no change in
+	 * translation regime (or anything else), so let's do as little as
+	 * possible.
+	 */
+	pstate = *vcpu_cpsr(vcpu);
+	mode = pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	direct_inject  = (mode == PSR_MODE_EL0t &&
+			  vcpu_el2_e2h_is_set(vcpu) &&
+			  vcpu_el2_tge_is_set(vcpu));
+	direct_inject |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
+
+	if (direct_inject) {
+		kvm_inject_el2_exception(vcpu, esr_el2, type);
+		return 1;
+	}
+
+	preempt_disable();
+	kvm_arch_vcpu_put(vcpu);
+
+	kvm_inject_el2_exception(vcpu, esr_el2, type);
+
+	/*
+	 * A hard requirement is that a switch between EL1 and EL2
+	 * contexts has to happen between a put/load, so that we can
+	 * pick the correct timer and interrupt configuration, among
+	 * other things.
+	 *
+	 * Make sure the exception actually took place before we load
+	 * the new context.
+	 */
+	__adjust_pc(vcpu);
+
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	preempt_enable();
+
+	return 1;
+}
+
+int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2)
+{
+	return kvm_inject_nested(vcpu, esr_el2, except_type_sync);
+}
+
+int kvm_inject_nested_irq(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Do not inject an irq if the:
+	 *  - Current exception level is EL2, and
+	 *  - virtual HCR_EL2.TGE == 0
+	 *  - virtual HCR_EL2.IMO == 0
+	 *
+	 * See Table D1-17 "Physical interrupt target and masking when EL3 is
+	 * not implemented and EL2 is implemented" in ARM DDI 0487C.a.
+	 */
+
+	if (vcpu_mode_el2(vcpu) && !vcpu_el2_tge_is_set(vcpu) &&
+	    !(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_IMO))
+		return 1;
+
+	/* esr_el2 value doesn't matter for exits due to irqs. */
+	return kvm_inject_nested(vcpu, 0, except_type_irq);
+}
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 73629094f903..7c8b3681dafd 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -22,7 +22,9 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val;
 
-	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
+	if (unlikely(nested_virt_in_use(vcpu)))
+		return vcpu_read_sys_reg(vcpu, reg);
+	else if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
 	return __vcpu_sys_reg(vcpu, reg);
@@ -30,14 +32,26 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	if (__vcpu_write_sys_reg_to_cpu(val, reg))
+	if (unlikely(nested_virt_in_use(vcpu)))
+		vcpu_write_sys_reg(vcpu, val, reg);
+	else if (__vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
 	 __vcpu_sys_reg(vcpu, reg) = val;
 }
 
-static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
+static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			      u64 val)
 {
+	if (unlikely(nested_virt_in_use(vcpu))) {
+		if (target_mode == PSR_MODE_EL1h)
+			vcpu_write_sys_reg(vcpu, val, SPSR_EL1);
+		else
+			vcpu_write_sys_reg(vcpu, val, SPSR_EL2);
+
+		return;
+	}
+
 	write_sysreg_el1(val, SYS_SPSR);
 }
 
@@ -97,6 +111,11 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
 		break;
+	case PSR_MODE_EL2h:
+		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
+		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
+		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
+		break;
 	default:
 		/* Don't do that */
 		BUG();
@@ -148,7 +167,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	new |= target_mode;
 
 	*vcpu_cpsr(vcpu) = new;
-	__vcpu_write_spsr(vcpu, old);
+	__vcpu_write_spsr(vcpu, target_mode, old);
 }
 
 /*
@@ -319,11 +338,22 @@ void kvm_inject_exception(struct kvm_vcpu *vcpu)
 		      KVM_ARM64_EXCEPT_AA64_EL1):
 			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
 			break;
+
+		case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
+		      KVM_ARM64_EXCEPT_AA64_EL2):
+			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_sync);
+			break;
+
+		case (KVM_ARM64_EXCEPT_AA64_ELx_IRQ |
+		      KVM_ARM64_EXCEPT_AA64_EL2):
+			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_irq);
+			break;
+
 		default:
 			/*
-			 * Only EL1_SYNC makes sense so far, EL2_{SYNC,IRQ}
-			 * will be implemented at some point. Everything
-			 * else gets silently ignored.
+			 * Only EL1_SYNC and EL2_{SYNC,IRQ} makes
+			 * sense so far. Everything else gets silently
+			 * ignored.
 			 */
 			break;
 		}
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index b47df73e98d7..530562eb09fd 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -14,17 +14,50 @@
 #include <asm/kvm_emulate.h>
 #include <asm/esr.h>
 
+static void pend_sync_exception(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
+			     KVM_ARM64_PENDING_EXCEPTION);
+
+	/* If not nesting, EL1 is the only possible exception target */
+	if (likely(!nested_virt_in_use(vcpu))) {
+		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
+		return;
+	}
+
+	/*
+	 * With NV, we need to pick between EL1 and EL2. Note that we
+	 * never deal with a nesting exception here, hence never
+	 * changing context, and the exception itself can be delayed
+	 * until the next entry.
+	 */
+	switch(*vcpu_cpsr(vcpu) & PSR_MODE_MASK) {
+	case PSR_MODE_EL2h:
+	case PSR_MODE_EL2t:
+		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL2;
+		break;
+	case PSR_MODE_EL1h:
+	case PSR_MODE_EL1t:
+		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
+		break;
+	case PSR_MODE_EL0t:
+		if (vcpu_el2_tge_is_set(vcpu) & HCR_TGE)
+			vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL2;
+		else
+			vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
+		break;
+	default:
+		BUG();
+	}
+}
+
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
-			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
-			     KVM_ARM64_PENDING_EXCEPTION);
-
-	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+	pend_sync_exception(vcpu);
 
 	/*
 	 * Build an {i,d}abort, depending on the level and the
@@ -45,16 +78,22 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
-	vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
+	esr |= ESR_ELx_FSC_EXTABT;
+
+	if (vcpu->arch.flags & KVM_ARM64_EXCEPT_AA64_EL1) {
+		vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	} else {
+		vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
+	}
 }
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
-			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
-			     KVM_ARM64_PENDING_EXCEPTION);
+	pend_sync_exception(vcpu);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
@@ -63,7 +102,10 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_trap_il_is32bit(vcpu))
 		esr |= ESR_ELx_IL;
 
-	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	if (vcpu->arch.flags & KVM_ARM64_EXCEPT_AA64_EL1)
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	else
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
 }
 
 #define DFSR_FSC_EXTABT_LPAE	0x10
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index ff0444352bba..5707011c4f47 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -2,6 +2,7 @@
 #if !defined(_TRACE_ARM_ARM64_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_ARM_ARM64_KVM_H
 
+#include <asm/kvm_emulate.h>
 #include <kvm/arm_arch_timer.h>
 #include <linux/tracepoint.h>
 
@@ -367,6 +368,64 @@ TRACE_EVENT(kvm_timer_emulate,
 		  __entry->timer_idx, __entry->should_fire)
 );
 
+TRACE_EVENT(kvm_nested_eret,
+	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long elr_el2,
+		 unsigned long spsr_el2),
+	TP_ARGS(vcpu, elr_el2, spsr_el2),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *,	vcpu)
+		__field(unsigned long,		elr_el2)
+		__field(unsigned long,		spsr_el2)
+		__field(unsigned long,		target_mode)
+		__field(unsigned long,		hcr_el2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->elr_el2 = elr_el2;
+		__entry->spsr_el2 = spsr_el2;
+		__entry->target_mode = spsr_el2 & (PSR_MODE_MASK | PSR_MODE32_BIT);
+		__entry->hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+	),
+
+	TP_printk("elr_el2: 0x%lx spsr_el2: 0x%08lx (M: %s) hcr_el2: %lx",
+		  __entry->elr_el2, __entry->spsr_el2,
+		  __print_symbolic(__entry->target_mode, kvm_mode_names),
+		  __entry->hcr_el2)
+);
+
+TRACE_EVENT(kvm_inject_nested_exception,
+	TP_PROTO(struct kvm_vcpu *vcpu, u64 esr_el2, int type),
+	TP_ARGS(vcpu, esr_el2, type),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *,		vcpu)
+		__field(unsigned long,			esr_el2)
+		__field(int,				type)
+		__field(unsigned long,			spsr_el2)
+		__field(unsigned long,			pc)
+		__field(unsigned long,			source_mode)
+		__field(unsigned long,			hcr_el2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->esr_el2 = esr_el2;
+		__entry->type = type;
+		__entry->spsr_el2 = *vcpu_cpsr(vcpu);
+		__entry->pc = *vcpu_pc(vcpu);
+		__entry->source_mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
+		__entry->hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+	),
+
+	TP_printk("%s: esr_el2 0x%lx elr_el2: 0x%lx spsr_el2: 0x%08lx (M: %s) hcr_el2: %lx",
+		  __print_symbolic(__entry->type, kvm_exception_type_names),
+		  __entry->esr_el2, __entry->pc, __entry->spsr_el2,
+		  __print_symbolic(__entry->source_mode, kvm_mode_names),
+		  __entry->hcr_el2)
+);
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.29.2

