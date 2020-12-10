Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9488B2D61EA
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391684AbgLJQbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391544AbgLJQFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:05:09 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 131A023ECF;
        Thu, 10 Dec 2020 16:04:11 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knONX-0008Di-Tz; Thu, 10 Dec 2020 16:01:16 +0000
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
        kernel-team@android.com
Subject: [PATCH v3 43/66] KVM: arm64: nv: arch_timer: Support hyp timer emulation
Date:   Thu, 10 Dec 2020 15:59:39 +0000
Message-Id: <20201210160002.1407373-44-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Emulating EL2 also means emulating the EL2 timers. To do so, we expand
our timer framework to deal with at most 4 timers. At any given time,
two timers are using the HW timers, and the two others are purely
emulated.

The role of deciding which is which at any given time is left to a
mapping function which is called every time we need to make such a
decision.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: added CNTVOFF support, general reworking for v4.8]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   4 +
 arch/arm64/kvm/arch_timer.c       | 152 +++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         |   7 +-
 arch/arm64/kvm/trace_arm.h        |   6 +-
 arch/arm64/kvm/vgic/vgic.c        |  15 +++
 include/kvm/arm_arch_timer.h      |   6 ++
 include/kvm/arm_vgic.h            |   1 +
 7 files changed, 186 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bf60c50eec17..f3743e45ded1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -272,6 +272,10 @@ enum vcpu_sysreg {
 	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
+	CNTHP_CTL_EL2,
+	CNTHP_CVAL_EL2,
+	CNTHV_CTL_EL2,
+	CNTHV_CVAL_EL2,
 
 	NR_SYS_REGS	/* Nothing after this line! */
 };
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 32ba6fbc3814..1c2be6391951 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -15,6 +15,7 @@
 #include <asm/arch_timer.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
@@ -39,6 +40,16 @@ static const struct kvm_irq_level default_vtimer_irq = {
 	.level	= 1,
 };
 
+static const struct kvm_irq_level default_hptimer_irq = {
+	.irq	= 26,
+	.level	= 1,
+};
+
+static const struct kvm_irq_level default_hvtimer_irq = {
+	.irq	= 28,
+	.level	= 1,
+};
+
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx);
@@ -60,6 +71,10 @@ u32 timer_get_ctl(struct arch_timer_context *ctxt)
 		return __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
 	case TIMER_PTIMER:
 		return __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+	case TIMER_HVTIMER:
+		return __vcpu_sys_reg(vcpu, CNTHV_CTL_EL2);
+	case TIMER_HPTIMER:
+		return __vcpu_sys_reg(vcpu, CNTHP_CTL_EL2);
 	default:
 		WARN_ON(1);
 		return 0;
@@ -75,6 +90,10 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 		return __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
 	case TIMER_PTIMER:
 		return __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+	case TIMER_HVTIMER:
+		return __vcpu_sys_reg(vcpu, CNTHV_CVAL_EL2);
+	case TIMER_HPTIMER:
+		return __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2);
 	default:
 		WARN_ON(1);
 		return 0;
@@ -104,6 +123,12 @@ static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
 	case TIMER_PTIMER:
 		__vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = ctl;
 		break;
+	case TIMER_HVTIMER:
+		__vcpu_sys_reg(vcpu, CNTHV_CTL_EL2) = ctl;
+		break;
+	case TIMER_HPTIMER:
+		__vcpu_sys_reg(vcpu, CNTHP_CTL_EL2) = ctl;
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -120,6 +145,12 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 	case TIMER_PTIMER:
 		__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = cval;
 		break;
+	case TIMER_HVTIMER:
+		__vcpu_sys_reg(vcpu, CNTHV_CVAL_EL2) = cval;
+		break;
+	case TIMER_HPTIMER:
+		__vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2) = cval;
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -145,13 +176,27 @@ u64 kvm_phys_timer_read(void)
 
 static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
-	if (has_vhe()) {
+	if (nested_virt_in_use(vcpu)) {
+		if (is_hyp_ctxt(vcpu)) {
+			map->direct_vtimer = vcpu_hvtimer(vcpu);
+			map->direct_ptimer = vcpu_hptimer(vcpu);
+			map->emul_vtimer = vcpu_vtimer(vcpu);
+			map->emul_ptimer = vcpu_ptimer(vcpu);
+		} else {
+			map->direct_vtimer = vcpu_vtimer(vcpu);
+			map->direct_ptimer = vcpu_ptimer(vcpu);
+			map->emul_vtimer = vcpu_hvtimer(vcpu);
+			map->emul_ptimer = vcpu_hptimer(vcpu);
+		}
+	} else if (has_vhe()) {
 		map->direct_vtimer = vcpu_vtimer(vcpu);
 		map->direct_ptimer = vcpu_ptimer(vcpu);
+		map->emul_vtimer = NULL;
 		map->emul_ptimer = NULL;
 	} else {
 		map->direct_vtimer = vcpu_vtimer(vcpu);
 		map->direct_ptimer = NULL;
+		map->emul_vtimer = NULL;
 		map->emul_ptimer = vcpu_ptimer(vcpu);
 	}
 
@@ -324,9 +369,11 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
 		switch (index) {
 		case TIMER_VTIMER:
+		case TIMER_HVTIMER:
 			cnt_ctl = read_sysreg_el0(SYS_CNTV_CTL);
 			break;
 		case TIMER_PTIMER:
+		case TIMER_HPTIMER:
 			cnt_ctl = read_sysreg_el0(SYS_CNTP_CTL);
 			break;
 		case NR_KVM_TIMERS:
@@ -357,6 +404,7 @@ bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
 
 	return kvm_timer_should_fire(map.direct_vtimer) ||
 	       kvm_timer_should_fire(map.direct_ptimer) ||
+	       kvm_timer_should_fire(map.emul_vtimer) ||
 	       kvm_timer_should_fire(map.emul_ptimer);
 }
 
@@ -437,6 +485,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
 		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
 
@@ -446,6 +495,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 		break;
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
 		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTP_CVAL));
 
@@ -483,6 +533,7 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
+	    !kvm_timer_irq_can_fire(map.emul_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.emul_ptimer))
 		return;
 
@@ -516,11 +567,13 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
 		isb();
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
 		break;
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
 		isb();
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
@@ -597,6 +650,40 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 		enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
 }
 
+static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
+					      struct timer_map *map)
+{
+	int hw, ret;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return;
+
+	/*
+	 * We only ever unmap the vtimer irq on a VHE system that runs nested
+	 * virtualization, in which case we have both a valid emul_vtimer,
+	 * emul_ptimer, direct_vtimer, and direct_ptimer.
+	 *
+	 * Since this is called from kvm_timer_vcpu_load(), a change between
+	 * vEL2 and vEL1/0 will have just happened, and the timer_map will
+	 * represent this, and therefore we switch the emul/direct mappings
+	 * below.
+	 */
+	hw = kvm_vgic_get_map(vcpu, map->direct_vtimer->irq.irq);
+	if (hw < 0) {
+		kvm_vgic_unmap_phys_irq(vcpu, map->emul_vtimer->irq.irq);
+		kvm_vgic_unmap_phys_irq(vcpu, map->emul_ptimer->irq.irq);
+
+		ret = kvm_vgic_map_phys_irq(vcpu,
+					    map->direct_vtimer->host_timer_irq,
+					    map->direct_vtimer->irq.irq,
+					    kvm_arch_timer_get_input_level);
+		ret = kvm_vgic_map_phys_irq(vcpu,
+					    map->direct_ptimer->host_timer_irq,
+					    map->direct_ptimer->irq.irq,
+					    kvm_arch_timer_get_input_level);
+	}
+}
+
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -608,6 +695,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
 
 	if (static_branch_likely(&has_gic_active_state)) {
+		if (nested_virt_in_use(vcpu))
+			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
+
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
 		if (map.direct_ptimer)
 			kvm_timer_vcpu_load_gic(map.direct_ptimer);
@@ -623,6 +713,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	if (map.direct_ptimer)
 		timer_restore_state(map.direct_ptimer);
 
+	if (map.emul_vtimer)
+		timer_emulate(map.emul_vtimer);
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
 }
@@ -668,6 +760,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * In any case, we re-schedule the hrtimer for the physical timer when
 	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
 	 */
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -728,10 +822,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 */
 	timer_set_ctl(vcpu_vtimer(vcpu), 0);
 	timer_set_ctl(vcpu_ptimer(vcpu), 0);
+	timer_set_ctl(vcpu_hvtimer(vcpu), 0);
+	timer_set_ctl(vcpu_hptimer(vcpu), 0);
 
 	if (timer->enabled) {
 		kvm_timer_update_irq(vcpu, false, vcpu_vtimer(vcpu));
 		kvm_timer_update_irq(vcpu, false, vcpu_ptimer(vcpu));
+		kvm_timer_update_irq(vcpu, false, vcpu_hvtimer(vcpu));
+		kvm_timer_update_irq(vcpu, false, vcpu_hptimer(vcpu));
 
 		if (irqchip_in_kernel(vcpu->kvm)) {
 			kvm_vgic_reset_mapped_irq(vcpu, map.direct_vtimer->irq.irq);
@@ -740,6 +838,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -770,30 +870,47 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct arch_timer_context *hvtimer = vcpu_hvtimer(vcpu);
+	struct arch_timer_context *hptimer = vcpu_hptimer(vcpu);
 
 	vtimer->vcpu = vcpu;
 	ptimer->vcpu = vcpu;
+	hvtimer->vcpu = vcpu;
+	hptimer->vcpu = vcpu;
 
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
 	timer_set_offset(ptimer, 0);
+	timer_set_offset(hvtimer, 0);
+	timer_set_offset(hptimer, 0);
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	timer->bg_timer.function = kvm_bg_timer_expire;
 
 	hrtimer_init(&vtimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	hrtimer_init(&ptimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
+	hrtimer_init(&hvtimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
+	hrtimer_init(&hptimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
+
 	vtimer->hrtimer.function = kvm_hrtimer_expire;
 	ptimer->hrtimer.function = kvm_hrtimer_expire;
+	hvtimer->hrtimer.function = kvm_hrtimer_expire;
+	hptimer->hrtimer.function = kvm_hrtimer_expire;
 
 	vtimer->irq.irq = default_vtimer_irq.irq;
 	ptimer->irq.irq = default_ptimer_irq.irq;
+	hvtimer->irq.irq = default_hvtimer_irq.irq;
+	hptimer->irq.irq = default_hptimer_irq.irq;
 
 	vtimer->host_timer_irq = host_vtimer_irq;
 	ptimer->host_timer_irq = host_ptimer_irq;
+	hvtimer->host_timer_irq = host_vtimer_irq;
+	hptimer->host_timer_irq = host_ptimer_irq;
 
 	vtimer->host_timer_irq_flags = host_vtimer_irq_flags;
 	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
+	hvtimer->host_timer_irq_flags = host_vtimer_irq_flags;
+	hptimer->host_timer_irq_flags = host_ptimer_irq_flags;
 }
 
 static void kvm_timer_init_interrupt(void *info)
@@ -900,6 +1017,10 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 		val = kvm_phys_timer_read() - timer_get_offset(timer);
 		break;
 
+	case TIMER_REG_VOFF:
+		val = timer_get_offset(timer);
+		break;
+
 	default:
 		BUG();
 	}
@@ -942,6 +1063,10 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 		timer_set_cval(timer, val);
 		break;
 
+	case TIMER_REG_VOFF:
+		timer_set_offset(timer, val);
+		break;
+
 	default:
 		BUG();
 	}
@@ -1079,7 +1204,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 
 static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 {
-	int vtimer_irq, ptimer_irq;
+	int vtimer_irq, ptimer_irq, hvtimer_irq, hptimer_irq;
 	int i, ret;
 
 	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
@@ -1092,9 +1217,21 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 	if (ret)
 		return false;
 
+	hvtimer_irq = vcpu_hvtimer(vcpu)->irq.irq;
+	ret = kvm_vgic_set_owner(vcpu, hvtimer_irq, vcpu_hvtimer(vcpu));
+	if (ret)
+		return false;
+
+	hptimer_irq = vcpu_hptimer(vcpu)->irq.irq;
+	ret = kvm_vgic_set_owner(vcpu, hptimer_irq, vcpu_hptimer(vcpu));
+	if (ret)
+		return false;
+
 	kvm_for_each_vcpu(i, vcpu, vcpu->kvm) {
 		if (vcpu_vtimer(vcpu)->irq.irq != vtimer_irq ||
-		    vcpu_ptimer(vcpu)->irq.irq != ptimer_irq)
+		    vcpu_ptimer(vcpu)->irq.irq != ptimer_irq ||
+		    vcpu_hvtimer(vcpu)->irq.irq != hvtimer_irq ||
+		    vcpu_hptimer(vcpu)->irq.irq != hptimer_irq)
 			return false;
 	}
 
@@ -1110,6 +1247,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
 		timer = vcpu_ptimer(vcpu);
+	else if (vintid == vcpu_hvtimer(vcpu)->irq.irq)
+		timer = vcpu_hvtimer(vcpu);
+	else if (vintid == vcpu_hptimer(vcpu)->irq.irq)
+		timer = vcpu_hptimer(vcpu);
 	else
 		BUG();
 
@@ -1191,6 +1332,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
 		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
+		/* TODO: Add support for hv/hp timers */
 	}
 }
 
@@ -1201,6 +1343,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return -EINVAL;
 
@@ -1233,6 +1377,8 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *timer;
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 		timer = vcpu_vtimer(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ecd61a6b06d1..98ff5b42a6b5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1290,6 +1290,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CVAL;
 		break;
+	case SYS_CNTVOFF_EL2:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_VOFF;
+		break;
+
 	default:
 		BUG();
 	}
@@ -2101,7 +2106,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
 
-	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
+	{ SYS_DESC(SYS_CNTVOFF_EL2), access_arch_timer },
 	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
 
 	{ SYS_DESC(SYS_SCTLR_EL12), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 5707011c4f47..49f4cb52d35d 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -272,6 +272,7 @@ TRACE_EVENT(kvm_get_timer_map,
 		__field(	unsigned long,		vcpu_id	)
 		__field(	int,			direct_vtimer	)
 		__field(	int,			direct_ptimer	)
+		__field(	int,			emul_vtimer	)
 		__field(	int,			emul_ptimer	)
 	),
 
@@ -280,14 +281,17 @@ TRACE_EVENT(kvm_get_timer_map,
 		__entry->direct_vtimer		= arch_timer_ctx_index(map->direct_vtimer);
 		__entry->direct_ptimer =
 			(map->direct_ptimer) ? arch_timer_ctx_index(map->direct_ptimer) : -1;
+		__entry->emul_vtimer =
+			(map->emul_vtimer) ? arch_timer_ctx_index(map->emul_vtimer) : -1;
 		__entry->emul_ptimer =
 			(map->emul_ptimer) ? arch_timer_ctx_index(map->emul_ptimer) : -1;
 	),
 
-	TP_printk("VCPU: %ld, dv: %d, dp: %d, ep: %d",
+	TP_printk("VCPU: %ld, dv: %d, dp: %d, ev: %d, ep: %d",
 		  __entry->vcpu_id,
 		  __entry->direct_vtimer,
 		  __entry->direct_ptimer,
+		  __entry->emul_vtimer,
 		  __entry->emul_ptimer)
 );
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1c597c9885fa..2af93dc80689 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -573,6 +573,21 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 	return 0;
 }
 
+int kvm_vgic_get_map(struct kvm_vcpu *vcpu, unsigned int vintid)
+{
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	unsigned long flags;
+	int ret = -1;
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (irq->hw)
+		ret = irq->hwintid;
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	vgic_put_irq(vcpu->kvm, irq);
+	return ret;
+}
+
 /**
  * kvm_vgic_set_owner - Set the owner of an interrupt for a VM
  *
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..063f613fbc7e 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -13,6 +13,8 @@
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
+	TIMER_HVTIMER,
+	TIMER_HPTIMER,
 	NR_KVM_TIMERS
 };
 
@@ -21,6 +23,7 @@ enum kvm_arch_timer_regs {
 	TIMER_REG_CVAL,
 	TIMER_REG_TVAL,
 	TIMER_REG_CTL,
+	TIMER_REG_VOFF,
 };
 
 struct arch_timer_context {
@@ -47,6 +50,7 @@ struct arch_timer_context {
 struct timer_map {
 	struct arch_timer_context *direct_vtimer;
 	struct arch_timer_context *direct_ptimer;
+	struct arch_timer_context *emul_vtimer;
 	struct arch_timer_context *emul_ptimer;
 };
 
@@ -91,6 +95,8 @@ bool kvm_arch_timer_get_input_level(int vintid);
 #define vcpu_get_timer(v,t)	(&vcpu_timer(v)->timers[(t)])
 #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_VTIMER])
 #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_PTIMER])
+#define vcpu_hvtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HVTIMER])
+#define vcpu_hptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HPTIMER])
 
 #define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3d74f1060bd1..4749c4748e5a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -353,6 +353,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid, bool (*get_input_level)(int vindid));
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
+int kvm_vgic_get_map(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
-- 
2.29.2

