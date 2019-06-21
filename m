Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1684E3DF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfFUJja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:30 -0400
Received: from foss.arm.com ([217.140.110.172]:53896 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfFUJj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D740142F;
        Fri, 21 Jun 2019 02:39:28 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDFB53F246;
        Fri, 21 Jun 2019 02:39:26 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 10/59] KVM: arm64: nv: Support virtual EL2 exceptions
Date:   Fri, 21 Jun 2019 10:37:54 +0100
Message-Id: <20190621093843.220980-11-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h     |  17 +++
 arch/arm64/include/asm/kvm_emulate.h |  22 ++++
 arch/arm64/kvm/Makefile              |   2 +
 arch/arm64/kvm/emulate-nested.c      | 184 +++++++++++++++++++++++++++
 arch/arm64/kvm/inject_fault.c        |  12 --
 arch/arm64/kvm/trace.h               |  56 ++++++++
 6 files changed, 281 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm64/kvm/emulate-nested.c

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 7f9d2bfcf82e..9d70a5362fbb 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -339,4 +339,21 @@
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
index 8f201ea56f6e..c43aac5fed69 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -33,6 +33,24 @@
 #include <asm/cputype.h>
 #include <asm/virt.h>
 
+#define CURRENT_EL_SP_EL0_VECTOR	0x0
+#define CURRENT_EL_SP_ELx_VECTOR	0x200
+#define LOWER_EL_AArch64_VECTOR		0x400
+#define LOWER_EL_AArch32_VECTOR		0x600
+
+enum exception_type {
+	except_type_sync	= 0,
+	except_type_irq		= 0x80,
+	except_type_fiq		= 0x100,
+	except_type_serror	= 0x180,
+};
+
+#define kvm_exception_type_names		\
+	{ except_type_sync,	"SYNC"   },	\
+	{ except_type_irq,	"IRQ"    },	\
+	{ except_type_fiq,	"FIQ"    },	\
+	{ except_type_serror,	"SERROR" }
+
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
 unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu);
 void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v);
@@ -48,6 +66,10 @@ void kvm_inject_undef32(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 
+void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
+int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
+int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
+
 static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3ac1a64d2fb9..9e450aea7db6 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -35,3 +35,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-debug.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
+
+kvm-$(CONFIG_KVM_ARM_HOST) += emulate-nested.o
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
new file mode 100644
index 000000000000..f829b8b04dc8
--- /dev/null
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -0,0 +1,184 @@
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
+#include <asm/kvm_coproc.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
+
+#include "trace.h"
+
+/* This is borrowed from get_except_vector in inject_fault.c */
+static u64 get_el2_except_vector(struct kvm_vcpu *vcpu,
+		enum exception_type type)
+{
+	u64 exc_offset;
+
+	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
+	case PSR_MODE_EL2t:
+		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
+		break;
+	case PSR_MODE_EL2h:
+		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
+		break;
+	case PSR_MODE_EL1t:
+	case PSR_MODE_EL1h:
+	case PSR_MODE_EL0t:
+		exc_offset = LOWER_EL_AArch64_VECTOR;
+		break;
+	default:
+		kvm_err("Unexpected previous exception level: aarch32\n");
+		exc_offset = LOWER_EL_AArch32_VECTOR;
+	}
+
+	return vcpu_read_sys_reg(vcpu, VBAR_EL2) + exc_offset + type;
+}
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
+		trace_kvm_nested_eret(vcpu, *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
+		return;
+	}
+
+	preempt_disable();
+	kvm_arch_vcpu_put(vcpu);
+
+	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
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
+static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
+				enum exception_type type)
+{
+	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
+
+	vcpu_write_sys_reg(vcpu, *vcpu_cpsr(vcpu), SPSR_EL2);
+	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
+	vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
+
+	*vcpu_pc(vcpu) = get_el2_except_vector(vcpu, type);
+	/* On an exception, PSTATE.SP becomes 1 */
+	*vcpu_cpsr(vcpu) = PSR_MODE_EL2h;
+	*vcpu_cpsr(vcpu) |= PSR_A_BIT | PSR_F_BIT | PSR_I_BIT | PSR_D_BIT;
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
+		enter_el2_exception(vcpu, esr_el2, type);
+		return 1;
+	}
+
+	preempt_disable();
+	kvm_arch_vcpu_put(vcpu);
+
+	enter_el2_exception(vcpu, esr_el2, type);
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
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a55e91dfcf8f..fac962b467bd 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -28,18 +28,6 @@
 #define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
 				 PSR_I_BIT | PSR_D_BIT)
 
-#define CURRENT_EL_SP_EL0_VECTOR	0x0
-#define CURRENT_EL_SP_ELx_VECTOR	0x200
-#define LOWER_EL_AArch64_VECTOR		0x400
-#define LOWER_EL_AArch32_VECTOR		0x600
-
-enum exception_type {
-	except_type_sync	= 0,
-	except_type_irq		= 0x80,
-	except_type_fiq		= 0x100,
-	except_type_serror	= 0x180,
-};
-
 static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
 {
 	u64 exc_offset;
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index eab91ad0effb..797a705bb644 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -204,7 +204,63 @@ TRACE_EVENT(kvm_set_guest_debug,
 	TP_printk("vcpu: %p, flags: 0x%08x", __entry->vcpu, __entry->guest_debug)
 );
 
+TRACE_EVENT(kvm_nested_eret,
+	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long elr_el2,
+		 unsigned long spsr_el2),
+	TP_ARGS(vcpu, elr_el2, spsr_el2),
 
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
+		__field(int,				source_mode)
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
 #endif /* _TRACE_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.20.1

