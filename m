Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2750868293A
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjAaJnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjAaJnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:43:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A3D3A87B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:42:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B139B81AE0
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3836C4339B;
        Tue, 31 Jan 2023 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158130;
        bh=bZsmY6UAcvugWrDjX7Ym/lqZ6zS77NYQrzzwfsI+gtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxUs8Uq2Wf/yUaRFFSUV8B04pGHaJCOuk9lvoLiG6XiruUMLDQp74JosqWv2iJlhQ
         YSUuoO6Cav60qLxlY3WEz3YcXBlIKpm3Nhz/3LZh7JXQKZTvoiqgzl78FJsIAE/ZqC
         GCVmMmkgn4dH4iMmF3zizXCapdtURLB3ACMK/JOtC7Hf84vXTvhKDVg7Bt9ZOpESPO
         m09uw6jy4Ktvvr/rfwqkKXw1CHA1sq7auEufi935RBNO62sdZOqLSlY3CfNfoGUUFI
         vtwenc76DuOon0Jxzn8Ii0KL4xVqrYTplNX6RZxw0AFczySH8EZmgyrup0gND9TxJs
         /MEBT+Czk013g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtq-0067U2-GD;
        Tue, 31 Jan 2023 09:25:58 +0000
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
Subject: [PATCH v8 44/69] KVM: arm64: nv: arch_timer: Support hyp timer emulation
Date:   Tue, 31 Jan 2023 09:24:39 +0000
Message-Id: <20230131092504.2880505-45-maz@kernel.org>
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

Emulating EL2 also means emulating the EL2 timers. To do so, we expand
our timer framework to deal with at most 4 timers. At any given time,
two timers are using the HW timers, and the two others are purely
emulated.

The role of deciding which is which at any given time is left to a
mapping function which is called every time we need to make such a
decision.

Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   4 +
 arch/arm64/include/asm/sysreg.h   |   2 +
 arch/arm64/kvm/arch_timer.c       | 186 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/sys_regs.c         |  49 +++++++-
 arch/arm64/kvm/trace_arm.h        |   6 +-
 arch/arm64/kvm/vgic/vgic.c        |  15 +++
 include/kvm/arm_arch_timer.h      |   8 +-
 include/kvm/arm_vgic.h            |   1 +
 8 files changed, 257 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a348c93b1094..a486aef61b3f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -397,6 +397,10 @@ enum vcpu_sysreg {
 	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
+	CNTHP_CTL_EL2,
+	CNTHP_CVAL_EL2,
+	CNTHV_CTL_EL2,
+	CNTHV_CVAL_EL2,
 
 	NR_SYS_REGS	/* Nothing after this line! */
 };
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 35147f369336..0457170760d8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -467,6 +467,8 @@
 
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
+#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
+#define SYS_CNTVCT_EL0			sys_reg(3, 3, 14, 0, 2)
 #define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
 #define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 00610477ec7b..a8425a88c750 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -16,6 +16,7 @@
 #include <asm/arch_timer.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
@@ -40,6 +41,16 @@ static const struct kvm_irq_level default_vtimer_irq = {
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
@@ -51,6 +62,11 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static bool kvm_arch_timer_get_input_level(int vintid);
+
+static struct irq_ops arch_timer_irq_ops = {
+	.get_input_level = kvm_arch_timer_get_input_level,
+};
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -61,6 +77,10 @@ u32 timer_get_ctl(struct arch_timer_context *ctxt)
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
@@ -76,6 +96,10 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
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
@@ -105,6 +129,12 @@ static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
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
@@ -121,6 +151,12 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
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
@@ -146,13 +182,27 @@ u64 kvm_phys_timer_read(void)
 
 static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
-	if (has_vhe()) {
+	if (vcpu_has_nv(vcpu)) {
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
 
@@ -345,9 +395,11 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
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
@@ -455,6 +507,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
 		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
 
@@ -480,6 +533,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		set_cntvoff(0);
 		break;
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
 		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTP_CVAL));
 
@@ -517,6 +571,7 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
+	    !kvm_timer_irq_can_fire(map.emul_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.emul_ptimer) &&
 	    !vcpu_has_wfit_active(vcpu))
 		return;
@@ -552,11 +607,14 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 	switch (index) {
 	case TIMER_VTIMER:
 		set_cntvoff(timer_get_offset(ctx));
+		fallthrough;
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
@@ -628,6 +686,59 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
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
+					    &arch_timer_irq_ops);
+		WARN_ON_ONCE(ret);
+		ret = kvm_vgic_map_phys_irq(vcpu,
+					    map->direct_ptimer->host_timer_irq,
+					    map->direct_ptimer->irq.irq,
+					    &arch_timer_irq_ops);
+		WARN_ON_ONCE(ret);
+	}
+
+	/*
+	 * Apply the trapping bits that the guest hypervisor has
+	 * requested for its own guest.
+	 */
+	if (!is_hyp_ctxt(vcpu)) {
+		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
+
+		if (vcpu_el2_e2h_is_set(vcpu))
+			val &= (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN) << 10;
+		else
+			val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
+
+		sysreg_clear_set(cntkctl_el1,
+				 (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN) << 10,
+				 val);
+	}
+}
+
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -639,6 +750,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
 
 	if (static_branch_likely(&has_gic_active_state)) {
+		if (vcpu_has_nv(vcpu))
+			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
+
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
 		if (map.direct_ptimer)
 			kvm_timer_vcpu_load_gic(map.direct_ptimer);
@@ -652,6 +766,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	if (map.direct_ptimer)
 		timer_restore_state(map.direct_ptimer);
 
+	if (map.emul_vtimer)
+		timer_emulate(map.emul_vtimer);
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
 }
@@ -696,6 +812,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * In any case, we re-schedule the hrtimer for the physical timer when
 	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
 	 */
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -747,10 +865,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
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
@@ -759,6 +881,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -789,30 +913,47 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
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
 
 void kvm_timer_cpu_up(void)
@@ -927,6 +1068,10 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 		val = kvm_phys_timer_read() - timer_get_offset(timer);
 		break;
 
+	case TIMER_REG_VOFF:
+		val = timer_get_offset(timer);
+		break;
+
 	default:
 		BUG();
 	}
@@ -945,7 +1090,7 @@ u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 	get_timer_map(vcpu, &map);
 	timer = vcpu_get_timer(vcpu, tmr);
 
-	if (timer == map.emul_ptimer)
+	if (timer == map.emul_vtimer || timer == map.emul_ptimer)
 		return kvm_arm_timer_read(vcpu, timer, treg);
 
 	preempt_disable();
@@ -977,6 +1122,10 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 		timer_set_cval(timer, val);
 		break;
 
+	case TIMER_REG_VOFF:
+		timer_set_offset(timer, val);
+		break;
+
 	default:
 		BUG();
 	}
@@ -992,7 +1141,7 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 
 	get_timer_map(vcpu, &map);
 	timer = vcpu_get_timer(vcpu, tmr);
-	if (timer == map.emul_ptimer) {
+	if (timer == map.emul_vtimer || timer == map.emul_ptimer) {
 		soft_timer_cancel(&timer->hrtimer);
 		kvm_arm_timer_write(vcpu, timer, treg, val);
 		timer_emulate(timer);
@@ -1072,10 +1221,6 @@ static const struct irq_domain_ops timer_domain_ops = {
 	.free	= timer_irq_domain_free,
 };
 
-static struct irq_ops arch_timer_irq_ops = {
-	.get_input_level = kvm_arch_timer_get_input_level,
-};
-
 static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
 {
 	*flags = irq_get_trigger_type(virq);
@@ -1217,7 +1362,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 
 static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 {
-	int vtimer_irq, ptimer_irq, ret;
+	int vtimer_irq, ptimer_irq, hvtimer_irq, hptimer_irq, ret;
 	unsigned long i;
 
 	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
@@ -1230,16 +1375,28 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
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
 
 	return true;
 }
 
-bool kvm_arch_timer_get_input_level(int vintid)
+static bool kvm_arch_timer_get_input_level(int vintid)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct arch_timer_context *timer;
@@ -1251,6 +1408,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
 		timer = vcpu_ptimer(vcpu);
+	else if (vintid == vcpu_hvtimer(vcpu)->irq.irq)
+		timer = vcpu_hvtimer(vcpu);
+	else if (vintid == vcpu_hptimer(vcpu)->irq.irq)
+		timer = vcpu_hptimer(vcpu);
 	else
 		BUG();
 
@@ -1333,6 +1494,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
 		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
+		/* TODO: Add support for hv/hp timers */
 	}
 }
 
@@ -1343,6 +1505,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return -EINVAL;
 
@@ -1375,6 +1539,8 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *timer;
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 		timer = vcpu_vtimer(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 40215710ede2..a58235dec296 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1363,12 +1363,57 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CVAL;
 		break;
+	case SYS_CNTVOFF_EL2:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_VOFF;
+		break;
+
+	case SYS_CNTPCT_EL0:
+	case SYS_CNTPCTSS_EL0:
+		if (is_hyp_ctxt(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_CNT;
+		break;
+
 	default:
 		print_sys_reg_msg(p, "%s", "Unhandled trapped timer register");
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
 
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu) && tmr == TIMER_PTIMER) {
+		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
+		bool trap;
+
+		if (vcpu_el2_e2h_is_set(vcpu))
+			val &= (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN) << 10;
+		else
+			val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
+
+		switch (treg) {
+		case TIMER_REG_CVAL:
+		case TIMER_REG_CTL:
+		case TIMER_REG_TVAL:
+			trap = val & (CNTHCTL_EL1PCEN << 10);
+			break;
+
+		case TIMER_REG_CNT:
+			trap = val & (CNTHCTL_EL1PCTEN << 10);
+			break;
+
+		default:
+			trap = false;
+			break;
+		}
+
+		if (trap) {
+			kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+			return false;
+		}
+	}
+
 	if (p->is_write)
 		kvm_arm_timer_write_sysreg(vcpu, tmr, treg, p->regval);
 	else
@@ -2325,6 +2370,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	AMU_AMEVTYPER1_EL0(14),
 	AMU_AMEVTYPER1_EL0(15),
 
+	{ SYS_DESC(SYS_CNTPCT_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTPCTSS_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
@@ -2441,7 +2488,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
 
-	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_CNTVOFF_EL2), access_arch_timer },
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 
 	EL12_REG(SCTLR, access_vm_reg, reset_val, 0x00C50078),
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index f3e46a976125..6ce5c025218d 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -206,6 +206,7 @@ TRACE_EVENT(kvm_get_timer_map,
 		__field(	unsigned long,		vcpu_id	)
 		__field(	int,			direct_vtimer	)
 		__field(	int,			direct_ptimer	)
+		__field(	int,			emul_vtimer	)
 		__field(	int,			emul_ptimer	)
 	),
 
@@ -214,14 +215,17 @@ TRACE_EVENT(kvm_get_timer_map,
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
index d97e6080b421..ae491ef97188 100644
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
index 71916de7c6c4..24dad4aaa6a3 100644
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
 
@@ -83,12 +87,12 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vhe(void);
 
-bool kvm_arch_timer_get_input_level(int vintid);
-
 #define vcpu_timer(v)	(&(v)->arch.timer_cpu)
 #define vcpu_get_timer(v,t)	(&vcpu_timer(v)->timers[(t)])
 #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_VTIMER])
 #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_PTIMER])
+#define vcpu_hvtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HVTIMER])
+#define vcpu_hptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HPTIMER])
 
 #define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 0629e3532ad0..67c50f42df9c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -380,6 +380,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid, struct irq_ops *ops);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
+int kvm_vgic_get_map(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
-- 
2.34.1

