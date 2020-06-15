Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3B71F98CF
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgFONdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 09:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbgFONd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 09:33:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C13F2083E;
        Mon, 15 Jun 2020 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592228008;
        bh=S7X8obFcCoyICfuXN2Yc1HWVHiT8+Cxqhc+OTSR2LV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gzi5kAtxN29BEbWagQWRlSyNWdzoePXYRPh7JzCsnlJTQcXIQx39qAoF/xF6UnXq3
         BXWv1qrpTZoVRrRk/Be6YRznqYDcZbQINH1mwQ6JCB6519V499JzYQldy5TM78xTvJ
         mv6L5wwqn6P25qRC/f0W6WYYevz46IRUNprT1dw4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jkp9U-0036w9-Sg; Mon, 15 Jun 2020 14:27:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 17/17] KVM: arm64: timers: Move timer registers to the sys_regs file
Date:   Mon, 15 Jun 2020 14:27:19 +0100
Message-Id: <20200615132719.1932408-18-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200615132719.1932408-1-maz@kernel.org>
References: <20200615132719.1932408-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, ascull@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the timer gsisters to the sysreg file. This will further help when
they are directly changed by a nesting hypervisor in the VNCR page.

This requires moving the initialisation of the timer struct so that some
of the helpers (such as arch_timer_ctx_index) can work correctly at an
early stage.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   6 ++
 arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
 arch/arm64/kvm/trace_arm.h        |   8 +-
 include/kvm/arm_arch_timer.h      |  11 +--
 4 files changed, 136 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4fcd296db3a5..96d833c1a651 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -189,6 +189,12 @@ enum vcpu_sysreg {
 	SP_EL1,
 	SPSR_EL1,
 
+	CNTVOFF_EL2,
+	CNTV_CVAL_EL0,
+	CNTV_CTL_EL0,
+	CNTP_CVAL_EL0,
+	CNTP_CTL_EL0,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 33d85a504720..32ba6fbc3814 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -51,6 +51,93 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
 
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
+		WARN_ON(1);
+		return 0;
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
+		WARN_ON(1);
+		return 0;
+	}
+}
+
+static u64 timer_get_offset(struct arch_timer_context *ctxt)
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
+static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
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
+		WARN_ON(1);
+	}
+}
+
+static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
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
+		WARN_ON(1);
+	}
+}
+
+static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
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
+
 u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
@@ -124,8 +211,8 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
 
-	cval = timer_ctx->cnt_cval;
-	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
+	cval = timer_get_cval(timer_ctx);
+	now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
 
 	if (now < cval) {
 		u64 ns;
@@ -144,8 +231,8 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 {
 	WARN_ON(timer_ctx && timer_ctx->loaded);
 	return timer_ctx &&
-	       !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
+		((timer_get_ctl(timer_ctx) &
+		  (ARCH_TIMER_CTRL_IT_MASK | ARCH_TIMER_CTRL_ENABLE)) == ARCH_TIMER_CTRL_ENABLE);
 }
 
 /*
@@ -256,8 +343,8 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 	if (!kvm_timer_irq_can_fire(timer_ctx))
 		return false;
 
-	cval = timer_ctx->cnt_cval;
-	now = kvm_phys_timer_read() - timer_ctx->cntvoff;
+	cval = timer_get_cval(timer_ctx);
+	now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
 
 	return cval <= now;
 }
@@ -350,8 +437,8 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
-		ctx->cnt_ctl = read_sysreg_el0(SYS_CNTV_CTL);
-		ctx->cnt_cval = read_sysreg_el0(SYS_CNTV_CVAL);
+		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
+		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
 
 		/* Disable the timer */
 		write_sysreg_el0(0, SYS_CNTV_CTL);
@@ -359,8 +446,8 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 		break;
 	case TIMER_PTIMER:
-		ctx->cnt_ctl = read_sysreg_el0(SYS_CNTP_CTL);
-		ctx->cnt_cval = read_sysreg_el0(SYS_CNTP_CVAL);
+		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
+		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTP_CVAL));
 
 		/* Disable the timer */
 		write_sysreg_el0(0, SYS_CNTP_CTL);
@@ -429,14 +516,14 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
-		write_sysreg_el0(ctx->cnt_cval, SYS_CNTV_CVAL);
+		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
 		isb();
-		write_sysreg_el0(ctx->cnt_ctl, SYS_CNTV_CTL);
+		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
 		break;
 	case TIMER_PTIMER:
-		write_sysreg_el0(ctx->cnt_cval, SYS_CNTP_CVAL);
+		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
 		isb();
-		write_sysreg_el0(ctx->cnt_ctl, SYS_CNTP_CTL);
+		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
 		break;
 	case NR_KVM_TIMERS:
 		BUG();
@@ -528,7 +615,7 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 		kvm_timer_vcpu_load_nogic(vcpu);
 	}
 
-	set_cntvoff(map.direct_vtimer->cntvoff);
+	set_cntvoff(timer_get_offset(map.direct_vtimer));
 
 	kvm_timer_unblocking(vcpu);
 
@@ -639,8 +726,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	vcpu_vtimer(vcpu)->cnt_ctl = 0;
-	vcpu_ptimer(vcpu)->cnt_ctl = 0;
+	timer_set_ctl(vcpu_vtimer(vcpu), 0);
+	timer_set_ctl(vcpu_ptimer(vcpu), 0);
 
 	if (timer->enabled) {
 		kvm_timer_update_irq(vcpu, false, vcpu_vtimer(vcpu));
@@ -668,13 +755,13 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, tmp, kvm)
-		vcpu_vtimer(tmp)->cntvoff = cntvoff;
+		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	vcpu_vtimer(vcpu)->cntvoff = cntvoff;
+	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
 	mutex_unlock(&kvm->lock);
 }
 
@@ -684,9 +771,12 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
+	vtimer->vcpu = vcpu;
+	ptimer->vcpu = vcpu;
+
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
-	ptimer->cntvoff = 0;
+	timer_set_offset(ptimer, 0);
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	timer->bg_timer.function = kvm_bg_timer_expire;
@@ -704,9 +794,6 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 
 	vtimer->host_timer_irq_flags = host_vtimer_irq_flags;
 	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
-
-	vtimer->vcpu = vcpu;
-	ptimer->vcpu = vcpu;
 }
 
 static void kvm_timer_init_interrupt(void *info)
@@ -756,10 +843,12 @@ static u64 read_timer_ctl(struct arch_timer_context *timer)
 	 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
 	 * regardless of ENABLE bit for our implementation convenience.
 	 */
+	u32 ctl = timer_get_ctl(timer);
+
 	if (!kvm_timer_compute_delta(timer))
-		return timer->cnt_ctl | ARCH_TIMER_CTRL_IT_STAT;
-	else
-		return timer->cnt_ctl;
+		ctl |= ARCH_TIMER_CTRL_IT_STAT;
+
+	return ctl;
 }
 
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
@@ -795,8 +884,8 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		val = timer->cnt_cval - kvm_phys_timer_read() + timer->cntvoff;
-		val &= lower_32_bits(val);
+		val = timer_get_cval(timer) - kvm_phys_timer_read() + timer_get_offset(timer);
+		val = lower_32_bits(val);
 		break;
 
 	case TIMER_REG_CTL:
@@ -804,11 +893,11 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 		break;
 
 	case TIMER_REG_CVAL:
-		val = timer->cnt_cval;
+		val = timer_get_cval(timer);
 		break;
 
 	case TIMER_REG_CNT:
-		val = kvm_phys_timer_read() - timer->cntvoff;
+		val = kvm_phys_timer_read() - timer_get_offset(timer);
 		break;
 
 	default:
@@ -842,15 +931,15 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 {
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + (s32)val;
+		timer_set_cval(timer, kvm_phys_timer_read() - timer_get_offset(timer) + (s32)val);
 		break;
 
 	case TIMER_REG_CTL:
-		timer->cnt_ctl = val & ~ARCH_TIMER_CTRL_IT_STAT;
+		timer_set_ctl(timer, val & ~ARCH_TIMER_CTRL_IT_STAT);
 		break;
 
 	case TIMER_REG_CVAL:
-		timer->cnt_cval = val;
+		timer_set_cval(timer, val);
 		break;
 
 	default:
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 4c71270cc097..4691053c5ee4 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -301,8 +301,8 @@ TRACE_EVENT(kvm_timer_save_state,
 	),
 
 	TP_fast_assign(
-		__entry->ctl			= ctx->cnt_ctl;
-		__entry->cval			= ctx->cnt_cval;
+		__entry->ctl			= timer_get_ctl(ctx);
+		__entry->cval			= timer_get_cval(ctx);
 		__entry->timer_idx		= arch_timer_ctx_index(ctx);
 	),
 
@@ -323,8 +323,8 @@ TRACE_EVENT(kvm_timer_restore_state,
 	),
 
 	TP_fast_assign(
-		__entry->ctl			= ctx->cnt_ctl;
-		__entry->cval			= ctx->cnt_cval;
+		__entry->ctl			= timer_get_ctl(ctx);
+		__entry->cval			= timer_get_cval(ctx);
 		__entry->timer_idx		= arch_timer_ctx_index(ctx);
 	),
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index a821dd1df0cf..51c19381108c 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -26,16 +26,9 @@ enum kvm_arch_timer_regs {
 struct arch_timer_context {
 	struct kvm_vcpu			*vcpu;
 
-	/* Registers: control register, timer value */
-	u32				cnt_ctl;
-	u64				cnt_cval;
-
 	/* Timer IRQ */
 	struct kvm_irq_level		irq;
 
-	/* Virtual offset */
-	u64				cntvoff;
-
 	/* Emulated Timer (may be unused) */
 	struct hrtimer			hrtimer;
 
@@ -109,4 +102,8 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 				enum kvm_arch_timer_regs treg,
 				u64 val);
 
+/* Needed for tracing */
+u32 timer_get_ctl(struct arch_timer_context *ctxt);
+u64 timer_get_cval(struct arch_timer_context *ctxt);
+
 #endif
-- 
2.27.0

