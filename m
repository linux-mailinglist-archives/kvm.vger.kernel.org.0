Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B17101596A1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgBKRvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbgBKRvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:07 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC52F20870;
        Tue, 11 Feb 2020 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443466;
        bh=vAs368NRaKbhbckeko/jjWU/YpL6QHPO+CUHr/uUINw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3x+n34IPHf14JmYAIcLCQUXF5ebOdDALWzW+InXPWDQf/0TVYO9BtPUwiEsonFeX
         jQ58xgaOkfeL/EemZipxT0Xf4JzZB+xsac9u6Yz30v06m/c7Rk6m/W0qY5d8Myd0D9
         ew/gLe5J3PGuxLiztF5481M8tqMGNtWBjqnowB/M=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgH-004O7k-Bb; Tue, 11 Feb 2020 17:50:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 81/94] KVM: arm64: Add VNCR-capable timer accessors for arm64
Date:   Tue, 11 Feb 2020 17:49:25 +0000
Message-Id: <20200211174938.27809-82-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As promissed, we now add an arm64-specific set of timer accessors, which
in some cases access the VNCR page instead of the struct timer fields.

This requires moving the initialisation of the timer struct so that some
of the helpers (such as arch_timer_ctx_index) can work correctly at an
early stage.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  6 ++
 arch/arm64/kvm/Makefile           |  1 +
 virt/kvm/arm/arch_timer.c         | 10 ++--
 virt/kvm/arm/arch_timer_nested.c  | 95 +++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+), 5 deletions(-)
 create mode 100644 virt/kvm/arm/arch_timer_nested.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7a66abd3df7e..9e48ec1ba057 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -281,6 +281,12 @@ enum vcpu_sysreg {
 	VNCR(ICH_HCR_EL2),
 	VNCR(ICH_VMCR_EL2),
 
+	VNCR(CNTVOFF_EL2),
+	VNCR(CNTV_CVAL_EL0),
+	VNCR(CNTV_CTL_EL0),
+	VNCR(CNTP_CVAL_EL0),
+	VNCR(CNTP_CTL_EL0),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 4521fdfacef0..c4c3eda0496e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -40,4 +40,5 @@ kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += nested.o
 kvm-$(CONFIG_KVM_ARM_HOST) += emulate-nested.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer_nested.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3-nested.o
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index d87e52f7e962..f9ef86752630 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -805,6 +805,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *hvtimer = vcpu_hvtimer(vcpu);
 	struct arch_timer_context *hptimer = vcpu_hptimer(vcpu);
 
+	vtimer->vcpu = vcpu;
+	ptimer->vcpu = vcpu;
+	hvtimer->vcpu = vcpu;
+	hptimer->vcpu = vcpu;
+
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
 	timer_set_offset(ptimer, 0);
@@ -838,11 +843,6 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
 	hvtimer->host_timer_irq_flags = host_vtimer_irq_flags;
 	hptimer->host_timer_irq_flags = host_ptimer_irq_flags;
-
-	vtimer->vcpu = vcpu;
-	ptimer->vcpu = vcpu;
-	hvtimer->vcpu = vcpu;
-	hptimer->vcpu = vcpu;
 }
 
 static void kvm_timer_init_interrupt(void *info)
diff --git a/virt/kvm/arm/arch_timer_nested.c b/virt/kvm/arm/arch_timer_nested.c
new file mode 100644
index 000000000000..f081e13e47ad
--- /dev/null
+++ b/virt/kvm/arm/arch_timer_nested.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2019 ARM Ltd.
+ * Author: Marc Zyngier <maz@kernel.org>
+ *
+ * Override timer accessors to be nested-capable on ARMv8.4.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kvm_host.h>
+
+u32 timer_get_ctl(struct arch_timer_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
+	case TIMER_PTIMER:
+		return __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+	default:
+		return ctxt->cnt_ctl;
+	}
+}
+
+u64 timer_get_cval(struct arch_timer_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+	case TIMER_PTIMER:
+		return __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+	default:
+		return ctxt->cnt_cval;
+	}
+}
+
+u64 timer_get_offset(struct arch_timer_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+	default:
+		return 0;
+	}
+}
+
+void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		__vcpu_sys_reg(vcpu, CNTV_CTL_EL0) = ctl;
+		break;
+	case TIMER_PTIMER:
+		__vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = ctl;
+		break;
+	default:
+		ctxt->cnt_ctl = ctl;
+	}
+}
+
+void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) = cval;
+		break;
+	case TIMER_PTIMER:
+		__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = cval;
+		break;
+	default:
+		ctxt->cnt_cval = cval;
+	}
+}
+
+void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
+		break;
+	default:
+		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
+	}
+}
-- 
2.20.1

