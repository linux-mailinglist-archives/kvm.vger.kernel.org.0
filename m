Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272D26F0167
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbjD0HMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242693AbjD0HLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:11:21 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 783E149C4;
        Thu, 27 Apr 2023 00:11:19 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxRPAWIEpkTnQBAA--.2620S3;
        Thu, 27 Apr 2023 15:11:18 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxtrENIEpksEA+AA--.18906S20;
        Thu, 27 Apr 2023 15:11:17 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v8 18/30] LoongArch: KVM: Implement vcpu timer operations
Date:   Thu, 27 Apr 2023 15:10:57 +0800
Message-Id: <20230427071109.3367258-19-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230427071109.3367258-1-zhaotianrui@loongson.cn>
References: <20230427071109.3367258-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxtrENIEpksEA+AA--.18906S20
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxtw18Kw4UAFyDXF1kZryrJFb_yoW3ur13pr
        WIkryIqr48X34jgwn3AFs0vrn8W3y8Kw17Gry7J3ySyrnxJ3s8XF40gryDJFZxGryIvF1S
        vryrAwn8Ar4kA3DanT9S1TB71UUUUbUqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bx8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        tVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0zRfuc_UUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch vcpu timer operations such as init kvm timer,
require kvm timer, save kvm timer and restore kvm timer. When
vcpu exit, we use kvm soft timer to emulate hardware timer. If
timeout happens, the vcpu timer interrupt will be set and it is
going to be handled at vcpu next entrance.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/timer.c | 266 +++++++++++++++++++++++++++++++++++++
 1 file changed, 266 insertions(+)
 create mode 100644 arch/loongarch/kvm/timer.c

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
new file mode 100644
index 000000000000..48aee921ba78
--- /dev/null
+++ b/arch/loongarch/kvm/timer.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_csr.h>
+#include <asm/kvm_vcpu.h>
+
+/* low level hrtimer wake routine */
+enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = container_of(timer, struct kvm_vcpu, arch.swtimer);
+	_kvm_queue_irq(vcpu, LARCH_INT_TIMER);
+	rcuwait_wake_up(&vcpu->wait);
+	return kvm_count_timeout(vcpu);
+}
+
+/*
+ * ktime_to_tick() - Scale ktime_t to a 64-bit stable timer.
+ *
+ * Caches the dynamic nanosecond bias in vcpu->arch.timer_dyn_bias.
+ */
+static unsigned long ktime_to_tick(struct kvm_vcpu *vcpu, ktime_t now)
+{
+	s64 now_ns, periods;
+	unsigned long delta;
+
+	now_ns = ktime_to_ns(now);
+	delta = now_ns + vcpu->arch.timer_dyn_bias;
+
+	if (delta >= vcpu->arch.timer_period_ns) {
+		/* If delta is out of safe range the bias needs adjusting */
+		periods = div64_s64(now_ns, vcpu->arch.timer_period_ns);
+		vcpu->arch.timer_dyn_bias = -periods * vcpu->arch.timer_period_ns;
+		/* Recalculate delta with new bias */
+		delta = now_ns + vcpu->arch.timer_dyn_bias;
+	}
+
+	/*
+	 * We've ensured that:
+	 *   delta < timer_period_ns
+	 */
+	return div_u64(delta * vcpu->arch.timer_mhz, MNSEC_PER_SEC);
+}
+
+/**
+ * kvm_resume_hrtimer() - Resume hrtimer, updating expiry.
+ * @vcpu:	Virtual CPU.
+ * @now:	ktime at point of resume.
+ * @val:	stable timer at point of resume.
+ *
+ * Resumes the timer and updates the timer expiry based on @now and @count.
+ */
+static void kvm_resume_hrtimer(struct kvm_vcpu *vcpu, ktime_t now,
+				unsigned long val)
+{
+	unsigned long delta;
+	ktime_t expire;
+
+	/* Stable timer decreased to zero or
+	 * initialize to zero, set 4 second timer
+	 */
+	delta = div_u64(val * MNSEC_PER_SEC, vcpu->arch.timer_mhz);
+	expire = ktime_add_ns(now, delta);
+
+	/* Update hrtimer to use new timeout */
+	hrtimer_cancel(&vcpu->arch.swtimer);
+	hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
+}
+
+/**
+ * kvm_init_timer() - Initialise stable timer.
+ * @vcpu:	Virtual CPU.
+ * @timer_hz:	Frequency of timer.
+ *
+ * Initialise the timer to the specified frequency, zero it, and set it going if
+ * it's enabled.
+ */
+void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long timer_hz)
+{
+	ktime_t now;
+	unsigned long ticks;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	ticks = (unsigned long)MNSEC_PER_SEC * CSR_TCFG_VAL;
+	vcpu->arch.timer_mhz = timer_hz >> 20;
+	vcpu->arch.timer_period_ns = div_u64(ticks, vcpu->arch.timer_mhz);
+	vcpu->arch.timer_dyn_bias = 0;
+
+	/* Starting at 0 */
+	ticks = 0;
+	now = ktime_get();
+	vcpu->arch.timer_bias = ticks - ktime_to_tick(vcpu, now);
+	vcpu->arch.timer_bias &= CSR_TCFG_VAL;
+	kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TVAL, ticks);
+}
+
+/**
+ * kvm_count_timeout() - Push timer forward on timeout.
+ * @vcpu:	Virtual CPU.
+ *
+ * Handle an hrtimer event by push the hrtimer forward a period.
+ *
+ * Returns:	The hrtimer_restart value to return to the hrtimer subsystem.
+ */
+enum hrtimer_restart kvm_count_timeout(struct kvm_vcpu *vcpu)
+{
+	unsigned long cfg;
+
+	/* Add the Count period to the current expiry time */
+	cfg = kvm_read_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG);
+	if (cfg & CSR_TCFG_PERIOD) {
+		hrtimer_add_expires_ns(&vcpu->arch.swtimer, cfg & CSR_TCFG_VAL);
+		return HRTIMER_RESTART;
+	} else
+		return HRTIMER_NORESTART;
+}
+
+/*
+ * kvm_restore_timer() - Restore timer state.
+ * @vcpu:       Virtual CPU.
+ *
+ * Restore soft timer state from saved context.
+ */
+void kvm_restore_timer(struct kvm_vcpu *vcpu)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	ktime_t saved_ktime, now;
+	unsigned long val, new, delta;
+	int expired = 0;
+	unsigned long cfg;
+
+	/*
+	 * Set guest stable timer cfg csr
+	 */
+	cfg = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
+	if (!(cfg & CSR_TCFG_EN)) {
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TCFG);
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TVAL);
+		return;
+	}
+
+	now = ktime_get();
+	saved_ktime = vcpu->arch.stable_ktime_saved;
+	val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TVAL);
+
+	/*hrtimer not expire */
+	delta = ktime_to_tick(vcpu, ktime_sub(now, saved_ktime));
+	if (delta >= val) {
+		expired = 1;
+		if (cfg & CSR_TCFG_PERIOD)
+			new = (delta - val) % (cfg & CSR_TCFG_VAL);
+		else
+			new = 1;
+	} else
+		new = val - delta;
+
+	new &= CSR_TCFG_VAL;
+	write_gcsr_timercfg(cfg);
+	write_gcsr_timertick(new);
+	if (expired)
+		_kvm_queue_irq(vcpu, LARCH_INT_TIMER);
+}
+
+/*
+ * kvm_acquire_timer() - Switch to hard timer state.
+ * @vcpu:       Virtual CPU.
+ *
+ * Restore hard timer state on top of existing soft timer state if possible.
+ *
+ * Since hard timer won't remain active over preemption, preemption should be
+ * disabled by the caller.
+ */
+void kvm_acquire_timer(struct kvm_vcpu *vcpu)
+{
+	unsigned long flags, guestcfg;
+
+	guestcfg = read_csr_gcfg();
+	if (!(guestcfg & CSR_GCFG_TIT))
+		return;
+
+	/* enable guest access to hard timer */
+	write_csr_gcfg(guestcfg & ~CSR_GCFG_TIT);
+
+	/*
+	 * Freeze the soft-timer and sync the guest stable timer with it. We do
+	 * this with interrupts disabled to avoid latency.
+	 */
+	local_irq_save(flags);
+	hrtimer_cancel(&vcpu->arch.swtimer);
+	local_irq_restore(flags);
+}
+
+
+/*
+ * _kvm_save_timer() - Switch to software emulation of guest timer.
+ * @vcpu:       Virtual CPU.
+ *
+ * Save guest timer state and switch to software emulation of guest
+ * timer. The hard timer must already be in use, so preemption should be
+ * disabled.
+ */
+static ktime_t _kvm_save_timer(struct kvm_vcpu *vcpu, unsigned long *val)
+{
+	unsigned long end_time;
+	ktime_t before_time;
+
+	before_time = ktime_get();
+
+	/*
+	 * Record a final stable timer which we will transfer to the soft-timer.
+	 */
+	end_time = read_gcsr_timertick();
+	*val = end_time;
+
+	kvm_resume_hrtimer(vcpu, before_time, end_time);
+	return before_time;
+}
+
+/*
+ * kvm_save_timer() - Save guest timer state.
+ * @vcpu:       Virtual CPU.
+ *
+ * Save guest timer state and switch to soft guest timer if hard timer was in
+ * use.
+ */
+void kvm_save_timer(struct kvm_vcpu *vcpu)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	unsigned long guestcfg, val;
+	ktime_t save_ktime;
+
+	preempt_disable();
+	guestcfg = read_csr_gcfg();
+	if (!(guestcfg & CSR_GCFG_TIT)) {
+		/* disable guest use of hard timer */
+		write_csr_gcfg(guestcfg | CSR_GCFG_TIT);
+
+		/* save hard timer state */
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TCFG);
+		if (kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG) & CSR_TCFG_EN) {
+			save_ktime = _kvm_save_timer(vcpu, &val);
+			kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TVAL, val);
+			vcpu->arch.stable_ktime_saved = save_ktime;
+			if (val == CSR_TCFG_VAL)
+				_kvm_queue_irq(vcpu, LARCH_INT_TIMER);
+		} else {
+			kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TVAL);
+		}
+	}
+
+	/* save timer-related state to vCPU context */
+	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
+	preempt_enable();
+}
+
+void kvm_reset_timer(struct kvm_vcpu *vcpu)
+{
+	write_gcsr_timercfg(0);
+	kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG, 0);
+	hrtimer_cancel(&vcpu->arch.swtimer);
+}
-- 
2.31.1

