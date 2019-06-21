Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21294E446
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfFUJl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:41:27 -0400
Received: from foss.arm.com ([217.140.110.172]:54268 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbfFUJkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABCBB1529;
        Fri, 21 Jun 2019 02:40:24 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 584B63F246;
        Fri, 21 Jun 2019 02:40:23 -0700 (PDT)
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
Subject: [PATCH 46/59] KVM: arm64: nv: arch_timer: Support hyp timer emulation
Date:   Fri, 21 Jun 2019 10:38:30 +0100
Message-Id: <20190621093843.220980-47-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h |   2 +
 include/kvm/arm_arch_timer.h       |   5 ++
 include/kvm/arm_vgic.h             |   1 +
 virt/kvm/arm/arch_timer.c          | 122 ++++++++++++++++++++++++++++-
 virt/kvm/arm/trace.h               |   6 +-
 virt/kvm/arm/vgic/vgic.c           |  15 ++++
 6 files changed, 147 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 6b7644a383f6..865ce545b465 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -333,4 +333,6 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 
 static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu) {}
 
+static inline bool is_hyp_ctxt(struct kvm_vcpu *vcpu) { return false; }
+
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index d120e6c323e7..3a5d9255120e 100644
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
 
@@ -54,6 +56,7 @@ struct arch_timer_context {
 struct timer_map {
 	struct arch_timer_context *direct_vtimer;
 	struct arch_timer_context *direct_ptimer;
+	struct arch_timer_context *emul_vtimer;
 	struct arch_timer_context *emul_ptimer;
 };
 
@@ -98,6 +101,8 @@ bool kvm_arch_timer_get_input_level(int vintid);
 #define vcpu_get_timer(v,t)	(&vcpu_timer(v)->timers[(t)])
 #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_VTIMER])
 #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_PTIMER])
+#define vcpu_hvtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HVTIMER])
+#define vcpu_hptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HPTIMER])
 
 #define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c36c86f1ec9a..7fc3b413b3de 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -355,6 +355,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 			  u32 vintid, bool (*get_input_level)(int vindid));
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
+int kvm_vgic_get_map(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 089441a07ed7..3d84c240071d 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
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
@@ -58,13 +69,27 @@ u64 kvm_phys_timer_read(void)
 
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
 
@@ -237,9 +262,11 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
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
@@ -270,6 +297,7 @@ bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
 
 	return kvm_timer_should_fire(map.direct_vtimer) ||
 	       kvm_timer_should_fire(map.direct_ptimer) ||
+	       kvm_timer_should_fire(map.emul_vtimer) ||
 	       kvm_timer_should_fire(map.emul_ptimer);
 }
 
@@ -349,6 +377,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		ctx->cnt_ctl = read_sysreg_el0(SYS_CNTV_CTL);
 		ctx->cnt_cval = read_sysreg_el0(SYS_CNTV_CVAL);
 
@@ -358,6 +387,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 		break;
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		ctx->cnt_ctl = read_sysreg_el0(SYS_CNTP_CTL);
 		ctx->cnt_cval = read_sysreg_el0(SYS_CNTP_CVAL);
 
@@ -395,6 +425,7 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
+	    !kvm_timer_irq_can_fire(map.emul_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.emul_ptimer))
 		return;
 
@@ -428,11 +459,13 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
+	case TIMER_HVTIMER:
 		write_sysreg_el0(ctx->cnt_cval, SYS_CNTV_CVAL);
 		isb();
 		write_sysreg_el0(ctx->cnt_ctl, SYS_CNTV_CTL);
 		break;
 	case TIMER_PTIMER:
+	case TIMER_HPTIMER:
 		write_sysreg_el0(ctx->cnt_cval, SYS_CNTP_CVAL);
 		isb();
 		write_sysreg_el0(ctx->cnt_ctl, SYS_CNTP_CTL);
@@ -519,6 +552,40 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
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
@@ -530,6 +597,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
 
 	if (static_branch_likely(&has_gic_active_state)) {
+		kvm_timer_vcpu_load_nested_switch(vcpu, &map);
+
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
 		if (map.direct_ptimer)
 			kvm_timer_vcpu_load_gic(map.direct_ptimer);
@@ -545,6 +614,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	if (map.direct_ptimer)
 		timer_restore_state(map.direct_ptimer);
 
+	if (map.emul_vtimer)
+		timer_emulate(map.emul_vtimer);
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
 }
@@ -589,6 +660,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * In any case, we re-schedule the hrtimer for the physical timer when
 	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
 	 */
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -649,10 +722,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 */
 	vcpu_vtimer(vcpu)->cnt_ctl = 0;
 	vcpu_ptimer(vcpu)->cnt_ctl = 0;
+	vcpu_hvtimer(vcpu)->cnt_ctl = 0;
+	vcpu_hptimer(vcpu)->cnt_ctl = 0;
 
 	if (timer->enabled) {
 		kvm_timer_update_irq(vcpu, false, vcpu_vtimer(vcpu));
 		kvm_timer_update_irq(vcpu, false, vcpu_ptimer(vcpu));
+		kvm_timer_update_irq(vcpu, false, vcpu_hvtimer(vcpu));
+		kvm_timer_update_irq(vcpu, false, vcpu_hptimer(vcpu));
 
 		if (irqchip_in_kernel(vcpu->kvm)) {
 			kvm_vgic_reset_mapped_irq(vcpu, map.direct_vtimer->irq.irq);
@@ -661,6 +738,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (map.emul_vtimer)
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
@@ -691,30 +770,46 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct arch_timer_context *hvtimer = vcpu_hvtimer(vcpu);
+	struct arch_timer_context *hptimer = vcpu_hptimer(vcpu);
 
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
 	ptimer->cntvoff = 0;
+	hvtimer->cntvoff = 0;
+	hptimer->cntvoff = 0;
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->bg_timer.function = kvm_bg_timer_expire;
 
 	hrtimer_init(&vtimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	hrtimer_init(&ptimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&hvtimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&hptimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
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
 
 	vtimer->vcpu = vcpu;
 	ptimer->vcpu = vcpu;
+	hvtimer->vcpu = vcpu;
+	hptimer->vcpu = vcpu;
 }
 
 static void kvm_timer_init_interrupt(void *info)
@@ -997,7 +1092,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 
 static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 {
-	int vtimer_irq, ptimer_irq;
+	int vtimer_irq, ptimer_irq, hvtimer_irq, hptimer_irq;
 	int i, ret;
 
 	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
@@ -1010,9 +1105,21 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
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
 
@@ -1028,6 +1135,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
 		timer = vcpu_ptimer(vcpu);
+	else if (vintid == vcpu_hvtimer(vcpu)->irq.irq)
+		timer = vcpu_hvtimer(vcpu);
+	else if (vintid == vcpu_hptimer(vcpu)->irq.irq)
+		timer = vcpu_hptimer(vcpu);
 	else
 		BUG();
 
@@ -1109,6 +1220,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
 		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
+		/* TODO: Add support for hv/hp timers */
 	}
 }
 
@@ -1119,6 +1231,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return -EINVAL;
 
@@ -1151,6 +1265,8 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	struct arch_timer_context *timer;
 	int irq;
 
+	/* TODO: Add support for hv/hp timers */
+
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 		timer = vcpu_vtimer(vcpu);
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 204d210d01c2..3b08cc0376f4 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -271,6 +271,7 @@ TRACE_EVENT(kvm_get_timer_map,
 		__field(	unsigned long,		vcpu_id	)
 		__field(	int,			direct_vtimer	)
 		__field(	int,			direct_ptimer	)
+		__field(	int,			emul_vtimer	)
 		__field(	int,			emul_ptimer	)
 	),
 
@@ -279,14 +280,17 @@ TRACE_EVENT(kvm_get_timer_map,
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
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 191deccf60bf..1c5b4dbd33e4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -569,6 +569,21 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
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
-- 
2.20.1

