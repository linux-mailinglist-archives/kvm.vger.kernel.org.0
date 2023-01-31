Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C84068293D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjAaJnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjAaJnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:43:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2DC41B66
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:42:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D17461485
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FBDC433D2;
        Tue, 31 Jan 2023 09:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158139;
        bh=YACg1Bg1F6tlU5rlGxllCmzvxEEHh3zo3innGE1lwMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PC8LmBEk47rDqgtw/At7PeT0sY4eGAzUEsovmVEEv7EreoV6XUaeUzJqy6u9kl/gj
         xe0nzX5Zwl18PZGu4Kp0fEjQKIcI4fDEhq2ySd5U411b2x+ApQ62kyvYFPxHMPgCiG
         jJsuXcOklKJbm9ba0WWdTWbjhZLQ8pSWvDpMQrtTJKczV/60tz3iO3Rew0psM3lgLS
         uariw+MjP43X2U/d1VvaQUFzW2HKvdOufVrfSGpLNPFQxlWhykpJm3bJ9sKQUUNUIR
         23NjYNucxsqkhZqda68BnR05DleZsvwQbaadyQ32cIimCmxsa5xmY5lw6HGFjGMcrk
         rO6QtaxUHa/fg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtQ-0067U2-9m;
        Tue, 31 Jan 2023 09:25:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 10/69] KVM: arm64: nv: Support virtual EL2 exceptions
Date:   Tue, 31 Jan 2023 09:24:05 +0000
Message-Id: <20230131092504.2880505-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Support injecting exceptions and performing exception returns to and
from virtual EL2.  This must be done entirely in software except when
taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
== {1,1}  (a VHE guest hypervisor).

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: switch to common exception injection framework, illegal exeption
 return handling]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h     |  17 +++
 arch/arm64/include/asm/kvm_emulate.h |  10 ++
 arch/arm64/include/asm/kvm_host.h    |   2 +-
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/emulate-nested.c      | 203 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/exception.c       |  48 +++++--
 arch/arm64/kvm/inject_fault.c        |  61 +++++++-
 arch/arm64/kvm/trace_arm.h           |  59 ++++++++
 8 files changed, 382 insertions(+), 20 deletions(-)
 create mode 100644 arch/arm64/kvm/emulate-nested.c

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5a4b2342d571..c101a611af9c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -350,4 +350,21 @@
 #define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |\
 				 CPACR_EL1_ZEN_EL1EN)
 
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
index c12287345ede..b31b32ecbe2d 100644
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
 
@@ -44,6 +50,10 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
+void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
+int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
+int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
+
 #if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8ae20f57cf9a..640997251724 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -638,7 +638,7 @@ struct kvm_vcpu_arch {
 #define EXCEPT_AA64_EL1_IRQ	__vcpu_except_flags(1)
 #define EXCEPT_AA64_EL1_FIQ	__vcpu_except_flags(2)
 #define EXCEPT_AA64_EL1_SERR	__vcpu_except_flags(3)
-/* For AArch64 with NV (one day): */
+/* For AArch64 with NV: */
 #define EXCEPT_AA64_EL2_SYNC	__vcpu_except_flags(4)
 #define EXCEPT_AA64_EL2_IRQ	__vcpu_except_flags(5)
 #define EXCEPT_AA64_EL2_FIQ	__vcpu_except_flags(6)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5e33c2d4645a..31b07f2b2186 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
-	 arch_timer.o trng.o vmid.o \
+	 arch_timer.o trng.o vmid.o emulate-nested.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
new file mode 100644
index 000000000000..b96662029fb1
--- /dev/null
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2016 - Linaro and Columbia University
+ * Author: Jintack Lim <jintack.lim@linaro.org>
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
+static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
+{
+	u64 mode = spsr & PSR_MODE_MASK;
+
+	/*
+	 * Possible causes for an Illegal Exception Return from EL2:
+	 * - trying to return to EL3
+	 * - trying to return to an illegal M value
+	 * - trying to return to a 32bit EL
+	 * - trying to return to EL1 with HCR_EL2.TGE set
+	 */
+	if (mode == PSR_MODE_EL3t   || mode == PSR_MODE_EL3h ||
+	    mode == 0b00001         || (mode & BIT(1))       ||
+	    (spsr & PSR_MODE32_BIT) ||
+	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
+					   mode == PSR_MODE_EL1h))) {
+		/*
+		 * The guest is playing with our nerves. Preserve EL, SP,
+		 * masks, flags from the existing PSTATE, and set IL.
+		 * The HW will then generate an Illegal State Exception
+		 * immediately after ERET.
+		 */
+		spsr = *vcpu_cpsr(vcpu);
+
+		spsr &= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
+			 PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT |
+			 PSR_MODE_MASK | PSR_MODE32_BIT);
+		spsr |= PSR_IL_BIT;
+	}
+
+	return spsr;
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
+	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
+
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
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
+		vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
+		break;
+	case except_type_irq:
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_IRQ);
+		break;
+	default:
+		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);
+	}
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
+	if (!vcpu_has_nv(vcpu)) {
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
+
+	/*
+	 * We may have an exception or PC update in the EL0/EL1 context.
+	 * Commit it before entering EL2.
+	 */
+	__kvm_adjust_pc(vcpu);
+
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
+	__kvm_adjust_pc(vcpu);
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
+	if (vcpu_is_el2(vcpu) && !vcpu_el2_tge_is_set(vcpu) &&
+	    !(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_IMO))
+		return 1;
+
+	/* esr_el2 value doesn't matter for exits due to irqs. */
+	return kvm_inject_nested(vcpu, 0, except_type_irq);
+}
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 791d3de76771..424a5107cddb 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -14,6 +14,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 
 #if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
 #error Hypervisor code only!
@@ -23,7 +24,9 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val;
 
-	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
+	if (unlikely(vcpu_has_nv(vcpu)))
+		return vcpu_read_sys_reg(vcpu, reg);
+	else if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
 	return __vcpu_sys_reg(vcpu, reg);
@@ -31,18 +34,25 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	if (__vcpu_write_sys_reg_to_cpu(val, reg))
-		return;
-
-	 __vcpu_sys_reg(vcpu, reg) = val;
+	if (unlikely(vcpu_has_nv(vcpu)))
+		vcpu_write_sys_reg(vcpu, val, reg);
+	else if (!__vcpu_write_sys_reg_to_cpu(val, reg))
+		__vcpu_sys_reg(vcpu, reg) = val;
 }
 
-static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
+static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
+			      u64 val)
 {
-	if (has_vhe())
+	if (unlikely(vcpu_has_nv(vcpu))) {
+		if (target_mode == PSR_MODE_EL1h)
+			vcpu_write_sys_reg(vcpu, val, SPSR_EL1);
+		else
+			vcpu_write_sys_reg(vcpu, val, SPSR_EL2);
+	} else if (has_vhe()) {
 		write_sysreg_el1(val, SYS_SPSR);
-	else
+	} else {
 		__vcpu_sys_reg(vcpu, SPSR_EL1) = val;
+	}
 }
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
@@ -101,6 +111,11 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
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
@@ -153,7 +168,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	new |= target_mode;
 
 	*vcpu_cpsr(vcpu) = new;
-	__vcpu_write_spsr(vcpu, old);
+	__vcpu_write_spsr(vcpu, target_mode, old);
 }
 
 /*
@@ -323,11 +338,20 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC):
 			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
 			break;
+
+		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
+			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_sync);
+			break;
+
+		case unpack_vcpu_flag(EXCEPT_AA64_EL2_IRQ):
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
index f32f4a2a347f..64c3aec0d937 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -12,17 +12,55 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
 #include <asm/esr.h>
 
+static void pend_sync_exception(struct kvm_vcpu *vcpu)
+{
+	/* If not nesting, EL1 is the only possible exception target */
+	if (likely(!vcpu_has_nv(vcpu))) {
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
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
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
+		break;
+	case PSR_MODE_EL1h:
+	case PSR_MODE_EL1t:
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+		break;
+	case PSR_MODE_EL0t:
+		if (vcpu_el2_tge_is_set(vcpu))
+			kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
+		else
+			kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static bool match_target_el(struct kvm_vcpu *vcpu, unsigned long target)
+{
+	return (vcpu_get_flag(vcpu, EXCEPT_MASK) == target);
+}
+
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u64 esr = 0;
 
-	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
-
-	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+	pend_sync_exception(vcpu);
 
 	/*
 	 * Build an {i,d}abort, depending on the level and the
@@ -43,14 +81,22 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
-	vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
+	esr |= ESR_ELx_FSC_EXTABT;
+
+	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC))) {
+		vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	} else {
+		vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
+	}
 }
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+	pend_sync_exception(vcpu);
 
 	/*
 	 * Build an unknown exception, depending on the instruction
@@ -59,7 +105,10 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_trap_il_is32bit(vcpu))
 		esr |= ESR_ELx_IL;
 
-	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC)))
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	else
+		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
 }
 
 #define DFSR_FSC_EXTABT_LPAE	0x10
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 33e4e7dd2719..f3e46a976125 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -2,6 +2,7 @@
 #if !defined(_TRACE_ARM_ARM64_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_ARM_ARM64_KVM_H
 
+#include <asm/kvm_emulate.h>
 #include <kvm/arm_arch_timer.h>
 #include <linux/tracepoint.h>
 
@@ -301,6 +302,64 @@ TRACE_EVENT(kvm_timer_emulate,
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
2.34.1

