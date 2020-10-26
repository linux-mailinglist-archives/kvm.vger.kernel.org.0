Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672E7298E91
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780764AbgJZNzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 09:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780756AbgJZNzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:55:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D7532463D;
        Mon, 26 Oct 2020 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603720520;
        bh=4u87s9JoJb0Kfg4Ca+WJmwLZIYUkNuLBCeeJWFa7pPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjfH/rBZsW2+zKP0aZmuGDMu3+OtokmZM+5/6/eDMfJkezYF1m1itmBUBBjy+d4eU
         lmNjes0Of4UEh8nQP9sGe4ph3RH03ihN8lwYUB/+bQSOOKZC7JB7NV/ORk6g5Vkv+2
         ijKWap83QejzdODbNdRg4iNGcD54Ojgrf40j/yNc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kX2eU-004Kjh-6v; Mon, 26 Oct 2020 13:35:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH 11/11] KVM: arm64: Get rid of the AArch32 register mapping code
Date:   Mon, 26 Oct 2020 13:34:50 +0000
Message-Id: <20201026133450.73304-12-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only use of the register mapping code was for the sake of the LR
mapping, which we trivially solved in a previous patch. Get rid of
the whole thing now.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |   2 -
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/guest.c               |  28 +++++-
 arch/arm64/kvm/regmap.c              | 128 ---------------------------
 4 files changed, 26 insertions(+), 134 deletions(-)
 delete mode 100644 arch/arm64/kvm/regmap.c

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3105bb73f539..c8f550a53516 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -33,8 +33,6 @@ enum exception_type {
 	except_type_serror	= 0x180,
 };
 
-unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
-
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 9b32a89a25c8..60fd181df624 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_KVM) += hyp/
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
-	 inject_fault.o regmap.o va_layout.o handle_exit.o \
+	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 arch_timer.o \
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfb5218137ca..3f23f7478d2a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -252,10 +252,32 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	memcpy(addr, valp, KVM_REG_SIZE(reg->id));
 
 	if (*vcpu_cpsr(vcpu) & PSR_MODE32_BIT) {
-		int i;
+		int i, nr_reg;
+
+		switch (*vcpu_cpsr(vcpu)) {
+		/*
+		 * Either we are dealing with user mode, and only the
+		 * first 15 registers (+ PC) must be narrowed to 32bit.
+		 * AArch32 r0-r14 conveniently map to AArch64 x0-x14.
+		 */
+		case PSR_AA32_MODE_USR:
+		case PSR_AA32_MODE_SYS:
+			nr_reg = 15;
+			break;
+
+		/*
+		 * Otherwide, this is a priviledged mode, and *all* the
+		 * registers must be narrowed to 32bit.
+		 */
+		default:
+			nr_reg = 31;
+			break;
+		}
+
+		for (i = 0; i < nr_reg; i++)
+			vcpu_set_reg(vcpu, i, (u32)vcpu_get_reg(vcpu, i));
 
-		for (i = 0; i < 16; i++)
-			*vcpu_reg32(vcpu, i) = (u32)*vcpu_reg32(vcpu, i);
+		*vcpu_pc(vcpu) = (u32)*vcpu_pc(vcpu);
 	}
 out:
 	return err;
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
deleted file mode 100644
index ae7e290bb017..000000000000
--- a/arch/arm64/kvm/regmap.c
+++ /dev/null
@@ -1,128 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * Derived from arch/arm/kvm/emulate.c:
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Author: Christoffer Dall <c.dall@virtualopensystems.com>
- */
-
-#include <linux/mm.h>
-#include <linux/kvm_host.h>
-#include <asm/kvm_emulate.h>
-#include <asm/ptrace.h>
-
-#define VCPU_NR_MODES 6
-#define REG_OFFSET(_reg) \
-	(offsetof(struct user_pt_regs, _reg) / sizeof(unsigned long))
-
-#define USR_REG_OFFSET(R) REG_OFFSET(compat_usr(R))
-
-static const unsigned long vcpu_reg_offsets[VCPU_NR_MODES][16] = {
-	/* USR Registers */
-	{
-		USR_REG_OFFSET(0), USR_REG_OFFSET(1), USR_REG_OFFSET(2),
-		USR_REG_OFFSET(3), USR_REG_OFFSET(4), USR_REG_OFFSET(5),
-		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
-		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
-		USR_REG_OFFSET(12), USR_REG_OFFSET(13),	USR_REG_OFFSET(14),
-		REG_OFFSET(pc)
-	},
-
-	/* FIQ Registers */
-	{
-		USR_REG_OFFSET(0), USR_REG_OFFSET(1), USR_REG_OFFSET(2),
-		USR_REG_OFFSET(3), USR_REG_OFFSET(4), USR_REG_OFFSET(5),
-		USR_REG_OFFSET(6), USR_REG_OFFSET(7),
-		REG_OFFSET(compat_r8_fiq),  /* r8 */
-		REG_OFFSET(compat_r9_fiq),  /* r9 */
-		REG_OFFSET(compat_r10_fiq), /* r10 */
-		REG_OFFSET(compat_r11_fiq), /* r11 */
-		REG_OFFSET(compat_r12_fiq), /* r12 */
-		REG_OFFSET(compat_sp_fiq),  /* r13 */
-		REG_OFFSET(compat_lr_fiq),  /* r14 */
-		REG_OFFSET(pc)
-	},
-
-	/* IRQ Registers */
-	{
-		USR_REG_OFFSET(0), USR_REG_OFFSET(1), USR_REG_OFFSET(2),
-		USR_REG_OFFSET(3), USR_REG_OFFSET(4), USR_REG_OFFSET(5),
-		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
-		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
-		USR_REG_OFFSET(12),
-		REG_OFFSET(compat_sp_irq), /* r13 */
-		REG_OFFSET(compat_lr_irq), /* r14 */
-		REG_OFFSET(pc)
-	},
-
-	/* SVC Registers */
-	{
-		USR_REG_OFFSET(0), USR_REG_OFFSET(1), USR_REG_OFFSET(2),
-		USR_REG_OFFSET(3), USR_REG_OFFSET(4), USR_REG_OFFSET(5),
-		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
-		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
-		USR_REG_OFFSET(12),
-		REG_OFFSET(compat_sp_svc), /* r13 */
-		REG_OFFSET(compat_lr_svc), /* r14 */
-		REG_OFFSET(pc)
-	},
-
-	/* ABT Registers */
-	{
-		USR_REG_OFFSET(0), USR_REG_OFFSET(1), USR_REG_OFFSET(2),
-		USR_REG_OFFSET(3), USR_REG_OFFSET(4), USR_REG_OFFSET(5),
-		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
-		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
-		USR_REG_OFFSET(12),
-		REG_OFFSET(compat_sp_abt), /* r13 */
-		REG_OFFSET(compat_lr_abt), /* r14 */
-		REG_OFFSET(pc)
-	},
-
-	/* UND Registers */
-	{
-		USR_REG_OFFSET(0), USR_REG_OFFSET(1), USR_REG_OFFSET(2),
-		USR_REG_OFFSET(3), USR_REG_OFFSET(4), USR_REG_OFFSET(5),
-		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
-		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
-		USR_REG_OFFSET(12),
-		REG_OFFSET(compat_sp_und), /* r13 */
-		REG_OFFSET(compat_lr_und), /* r14 */
-		REG_OFFSET(pc)
-	},
-};
-
-/*
- * Return a pointer to the register number valid in the current mode of
- * the virtual CPU.
- */
-unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num)
-{
-	unsigned long *reg_array = (unsigned long *)&vcpu->arch.ctxt.regs;
-	unsigned long mode = *vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK;
-
-	switch (mode) {
-	case PSR_AA32_MODE_USR ... PSR_AA32_MODE_SVC:
-		mode &= ~PSR_MODE32_BIT; /* 0 ... 3 */
-		break;
-
-	case PSR_AA32_MODE_ABT:
-		mode = 4;
-		break;
-
-	case PSR_AA32_MODE_UND:
-		mode = 5;
-		break;
-
-	case PSR_AA32_MODE_SYS:
-		mode = 0;	/* SYS maps to USR */
-		break;
-
-	default:
-		BUG();
-	}
-
-	return reg_array + vcpu_reg_offsets[mode][reg_num];
-}
-- 
2.28.0

