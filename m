Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F774699776
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjBPOb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjBPObX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:31:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108754AFD6
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:31:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B61BB8217A
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A3AC433EF;
        Thu, 16 Feb 2023 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557878;
        bh=ukFNyRzBJ5W/Z63bOZZfv9TU6SVbzQ+TJNazmezFdW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVma7KpOTOSxVtDNETdFKTxPRugFKhgVsQFbUJe6KBq1mD3+/r7w+6w964+m3YWrF
         Aw2h4TF2sBSKo5+qcBzhHUliuE4XyusFmj6DKGlHS7UDhIPSaylEHyoyHNQGo+5aSX
         Gud/cNjxuM+mncNi9WGK8mHO/9XQSWwELAPmgDO0zyqi+KDzedi8gZEpOq5BhPoDJC
         cUFSQhdL+ZVo2CjMNvNNM14eQPhRjKmVZZM+roD06MW9FLZlQzOOnKGKs+Je7y/T1V
         /HLBT27mvKRt8D+YqTgHSmvCemuQTNvgC8sB8IxogoDmVqiwVmmSiHjjAQRwVONMly
         L6ijnmtI9TnQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8w-00AuwB-7D;
        Thu, 16 Feb 2023 14:21:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 13/16] KVM: arm64: nv: timers: Support hyp timer emulation
Date:   Thu, 16 Feb 2023 14:21:20 +0000
Message-Id: <20230216142123.2638675-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 arch/arm64/kvm/arch_timer.c       | 187 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/trace_arm.h        |   6 +-
 arch/arm64/kvm/vgic/vgic.c        |  15 +++
 include/kvm/arm_arch_timer.h      |   8 +-
 include/kvm/arm_vgic.h            |   1 +
 6 files changed, 207 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8514a37cf8d5..4dceec1a5924 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,6 +367,10 @@ enum vcpu_sysreg {
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
index 1f442ac0c499..0aac92c2d7e5 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -16,6 +16,7 @@
 #include <asm/arch_timer.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
@@ -33,6 +34,8 @@ static DEFINE_STATIC_KEY_FALSE(has_gic_active_state);
 static const u8 default_ppi[] = {
 	[TIMER_PTIMER]  = 30,
 	[TIMER_VTIMER]  = 27,
+	[TIMER_HPTIMER] = 26,
+	[TIMER_HVTIMER] = 28,
 };
 
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
@@ -46,6 +49,11 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static bool kvm_arch_timer_get_input_level(int vintid);
+
+static struct irq_ops arch_timer_irq_ops = {
+	.get_input_level = kvm_arch_timer_get_input_level,
+};
 
 static bool has_cntpoff(void)
 {
@@ -61,6 +69,10 @@ u32 timer_get_ctl(struct arch_timer_context *ctxt)
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
@@ -76,6 +88,10 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
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
@@ -108,6 +124,12 @@ static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
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
@@ -124,6 +146,12 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
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
@@ -146,13 +174,27 @@ u64 kvm_phys_timer_read(void)
 
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
 
@@ -247,8 +289,11 @@ static bool vcpu_has_wfit_active(struct kvm_vcpu *vcpu)
 
 static u64 wfit_delay_ns(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_context *ctx = vcpu_vtimer(vcpu);
 	u64 val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
+	struct arch_timer_context *ctx;
+
+	ctx = (vcpu_has_nv(vcpu) && is_hyp_ctxt(vcpu)) ? vcpu_hvtimer(vcpu)
+						       : vcpu_vtimer(vcpu);
 
 	return kvm_counter_compute_delta(ctx, val);
 }
@@ -345,9 +390,11 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
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
@@ -463,6 +510,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		u64 cval;
 
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
 		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
 
@@ -488,6 +536,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		set_cntvoff(0);
 		break;
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
 		cval = read_sysreg_el0(SYS_CNTP_CVAL);
 
@@ -531,6 +580,7 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
+	    !kvm_timer_irq_can_fire(map.emul_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.emul_ptimer) &&
 	    !vcpu_has_wfit_active(vcpu))
 		return;
@@ -567,12 +617,14 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 		u64 cval, offset;
 
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		set_cntvoff(timer_get_offset(ctx));
 		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
 		isb();
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
 		break;
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		cval = timer_get_cval(ctx);
 		offset = timer_get_offset(ctx);
 		set_cntpoff(offset);
@@ -658,6 +710,57 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 			(_clr) |= (_bit);				\
 	} while (0)
 
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
+
+		/*
+		 * The virtual offset behaviour is "interresting", as it
+		 * always applies when HCR_EL2.E2H==0, but only when
+		 * accessed from EL1 when HCR_EL2.E2H==1. So make sure we
+		 * track E2H when putting the HV timer in "direct" mode.
+		 */
+		if (map->direct_vtimer == vcpu_hvtimer(vcpu)) {
+			struct arch_timer_offset *offs = &map->direct_vtimer->offset;
+
+			if (vcpu_el2_e2h_is_set(vcpu))
+				offs->vcpu_offset = NULL;
+			else
+				offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		}
+	}
+}
+
 static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
 	bool tpt, tpc;
@@ -691,6 +794,21 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 		tpt = tpc = true;
 
 	/*
+	 * Apply the enable bits that the guest hypervisor has requested for
+	 * its own guest. We can only add traps that wouldn't have been set
+	 * above.
+	 */
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
+
+		/* Use the VHE format for mental sanity */
+		if (!vcpu_el2_e2h_is_set(vcpu))
+			val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
+
+		tpt |= !(val & (CNTHCTL_EL1PCEN << 10));
+		tpc |= !(val & (CNTHCTL_EL1PCTEN << 10));
+	}
+
 	/*
 	 * Now that we have collected our requirements, compute the
 	 * trap and enable bits.
@@ -716,6 +834,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
 
 	if (static_branch_likely(&has_gic_active_state)) {
+		if (vcpu_has_nv(vcpu))
+			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
+
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
 		if (map.direct_ptimer)
 			kvm_timer_vcpu_load_gic(map.direct_ptimer);
@@ -728,6 +849,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	timer_restore_state(map.direct_vtimer);
 	if (map.direct_ptimer)
 		timer_restore_state(map.direct_ptimer);
+	if (map.emul_vtimer)
+		timer_emulate(map.emul_vtimer);
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
 
@@ -774,6 +897,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * In any case, we re-schedule the hrtimer for the physical timer when
 	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
 	 */
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -826,6 +951,17 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	for (int i = 0; i < NR_KVM_TIMERS; i++)
 		timer_set_ctl(vcpu_get_timer(vcpu, i), 0);
 
+	/*
+	 * A vcpu running at EL2 is in charge of the offset applied to
+	 * the virtual timer, so use the physical VM offset, and point
+	 * the vcpu offset to CNTVOFF_EL2.
+	 */
+	if (vcpu_has_nv(vcpu)) {
+		struct arch_timer_offset *offs = &vcpu_vtimer(vcpu)->offset;
+
+		offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		offs->vm_offset = &vcpu->kvm->arch.offsets.poffset;
+	}
 
 	if (timer->enabled) {
 		for (int i = 0; i < NR_KVM_TIMERS; i++)
@@ -839,6 +975,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -863,9 +1001,11 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	switch (timerid) {
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		ctxt->host_timer_irq = host_ptimer_irq;
 		break;
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		ctxt->host_timer_irq = host_vtimer_irq;
 		break;
 	}
@@ -1010,6 +1150,10 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 		val = kvm_phys_timer_read() - timer_get_offset(timer);
 		break;
 
+	case TIMER_REG_VOFF:
+		val = *timer->offset.vcpu_offset;
+		break;
+
 	default:
 		BUG();
 	}
@@ -1028,7 +1172,7 @@ u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 	get_timer_map(vcpu, &map);
 	timer = vcpu_get_timer(vcpu, tmr);
 
-	if (timer == map.emul_ptimer)
+	if (timer == map.emul_vtimer || timer == map.emul_ptimer)
 		return kvm_arm_timer_read(vcpu, timer, treg);
 
 	preempt_disable();
@@ -1060,6 +1204,10 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 		timer_set_cval(timer, val);
 		break;
 
+	case TIMER_REG_VOFF:
+		*timer->offset.vcpu_offset = val;
+		break;
+
 	default:
 		BUG();
 	}
@@ -1075,7 +1223,7 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 
 	get_timer_map(vcpu, &map);
 	timer = vcpu_get_timer(vcpu, tmr);
-	if (timer == map.emul_ptimer) {
+	if (timer == map.emul_vtimer || timer == map.emul_ptimer) {
 		soft_timer_cancel(&timer->hrtimer);
 		kvm_arm_timer_write(vcpu, timer, treg, val);
 		timer_emulate(timer);
@@ -1155,10 +1303,6 @@ static const struct irq_domain_ops timer_domain_ops = {
 	.free	= timer_irq_domain_free,
 };
 
-static struct irq_ops arch_timer_irq_ops = {
-	.get_input_level = kvm_arch_timer_get_input_level,
-};
-
 static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
 {
 	*flags = irq_get_trigger_type(virq);
@@ -1300,7 +1444,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 
 static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 {
-	int vtimer_irq, ptimer_irq, ret;
+	int vtimer_irq, ptimer_irq, hvtimer_irq, hptimer_irq, ret;
 	unsigned long i;
 
 	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
@@ -1313,16 +1457,28 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
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
@@ -1334,6 +1490,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
 		timer = vcpu_ptimer(vcpu);
+	else if (vintid == vcpu_hvtimer(vcpu)->irq.irq)
+		timer = vcpu_hvtimer(vcpu);
+	else if (vintid == vcpu_hptimer(vcpu)->irq.irq)
+		timer = vcpu_hptimer(vcpu);
 	else
 		BUG();
 
@@ -1403,6 +1563,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
 		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
+		/* TODO: Add support for hv/hp timers */
 	}
 }
 
@@ -1413,6 +1574,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return -EINVAL;
 
@@ -1445,6 +1608,8 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *timer;
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 		timer = vcpu_vtimer(vcpu);
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
index e76e513b90c5..8ccd90b45587 100644
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
 
 struct arch_timer_offset {
@@ -69,6 +72,7 @@ struct arch_timer_context {
 struct timer_map {
 	struct arch_timer_context *direct_vtimer;
 	struct arch_timer_context *direct_ptimer;
+	struct arch_timer_context *emul_vtimer;
 	struct arch_timer_context *emul_ptimer;
 };
 
@@ -105,12 +109,12 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
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
index d3ad51fde9db..402b545959af 100644
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

