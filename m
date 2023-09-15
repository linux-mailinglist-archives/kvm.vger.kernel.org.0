Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458DB7A1334
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjIOBuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjIOBun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:43 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FB6430C1;
        Thu, 14 Sep 2023 18:50:10 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dx_+tIuANlGv8nAA--.10551S3;
        Fri, 15 Sep 2023 09:50:00 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S19;
        Fri, 15 Sep 2023 09:49:59 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v21 17/29] LoongArch: KVM: Implement vcpu timer operations
Date:   Fri, 15 Sep 2023 09:49:37 +0800
Message-Id: <20230915014949.1222777-18-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S19
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch vcpu timer operations such as init kvm timer,
require kvm timer, save kvm timer and restore kvm timer. When
vcpu exit, we use kvm soft timer to emulate hardware timer. If
timeout happens, the vcpu timer interrupt will be set and it is
going to be handled at vcpu next entrance.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/timer.c | 200 +++++++++++++++++++++++++++++++++++++
 1 file changed, 200 insertions(+)
 create mode 100644 arch/loongarch/kvm/timer.c

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
new file mode 100644
index 0000000000..e084593c73
--- /dev/null
+++ b/arch/loongarch/kvm/timer.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_csr.h>
+#include <asm/kvm_vcpu.h>
+
+/*
+ * ktime_to_tick() - Scale ktime_t to timer tick value.
+ */
+static inline u64 ktime_to_tick(struct kvm_vcpu *vcpu, ktime_t now)
+{
+	u64 delta;
+
+	delta = ktime_to_ns(now);
+	return div_u64(delta * vcpu->arch.timer_mhz, MNSEC_PER_SEC);
+}
+
+static inline u64 tick_to_ns(struct kvm_vcpu *vcpu, u64 tick)
+{
+	return div_u64(tick * MNSEC_PER_SEC, vcpu->arch.timer_mhz);
+}
+
+/*
+ * Push timer forward on timeout.
+ * Handle an hrtimer event by push the hrtimer forward a period.
+ */
+static enum hrtimer_restart kvm_count_timeout(struct kvm_vcpu *vcpu)
+{
+	unsigned long cfg, period;
+
+	/* Add periodic tick to current expire time */
+	cfg = kvm_read_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG);
+	if (cfg & CSR_TCFG_PERIOD) {
+		period = tick_to_ns(vcpu, cfg & CSR_TCFG_VAL);
+		hrtimer_add_expires_ns(&vcpu->arch.swtimer, period);
+		return HRTIMER_RESTART;
+	} else
+		return HRTIMER_NORESTART;
+}
+
+/* low level hrtimer wake routine */
+enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = container_of(timer, struct kvm_vcpu, arch.swtimer);
+	kvm_queue_irq(vcpu, INT_TI);
+	rcuwait_wake_up(&vcpu->wait);
+	return kvm_count_timeout(vcpu);
+}
+
+/*
+ * Initialise the timer to the specified frequency, zero it
+ */
+void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long timer_hz)
+{
+	vcpu->arch.timer_mhz = timer_hz >> 20;
+
+	/* Starting at 0 */
+	kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TVAL, 0);
+}
+
+/*
+ * Restore soft timer state from saved context.
+ */
+void kvm_restore_timer(struct kvm_vcpu *vcpu)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	ktime_t expire, now;
+	unsigned long cfg, delta, period;
+
+	/*
+	 * Set guest stable timer cfg csr
+	 */
+	cfg = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TCFG);
+	if (!(cfg & CSR_TCFG_EN)) {
+		/* guest timer is disabled, just restore timer registers */
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TVAL);
+		return;
+	}
+
+	/*
+	 * set remainder tick value if not expired
+	 */
+	now = ktime_get();
+	expire = vcpu->arch.expire;
+	if (ktime_before(now, expire))
+		delta = ktime_to_tick(vcpu, ktime_sub(expire, now));
+	else {
+		if (cfg & CSR_TCFG_PERIOD) {
+			period = cfg & CSR_TCFG_VAL;
+			delta = ktime_to_tick(vcpu, ktime_sub(now, expire));
+			delta = period - (delta % period);
+		} else
+			delta = 0;
+		/*
+		 * inject timer here though sw timer should inject timer
+		 * interrupt async already, since sw timer may be cancelled
+		 * during injecting intr async in function kvm_acquire_timer
+		 */
+		kvm_queue_irq(vcpu, INT_TI);
+	}
+
+	write_gcsr_timertick(delta);
+}
+
+/*
+ *
+ * Restore hard timer state and enable guest to access timer registers
+ * without trap
+ *
+ * it is called with irq disabled
+ */
+void kvm_acquire_timer(struct kvm_vcpu *vcpu)
+{
+	unsigned long cfg;
+
+	cfg = read_csr_gcfg();
+	if (!(cfg & CSR_GCFG_TIT))
+		return;
+
+	/* enable guest access to hard timer */
+	write_csr_gcfg(cfg & ~CSR_GCFG_TIT);
+
+	/*
+	 * Freeze the soft-timer and sync the guest stable timer with it. We do
+	 * this with interrupts disabled to avoid latency.
+	 */
+	hrtimer_cancel(&vcpu->arch.swtimer);
+}
+
+/*
+ * Save guest timer state and switch to software emulation of guest
+ * timer. The hard timer must already be in use, so preemption should be
+ * disabled.
+ */
+static void _kvm_save_timer(struct kvm_vcpu *vcpu)
+{
+	unsigned long ticks, delta;
+	ktime_t expire;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	ticks = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TVAL);
+	delta = tick_to_ns(vcpu, ticks);
+	expire = ktime_add_ns(ktime_get(), delta);
+	vcpu->arch.expire = expire;
+	if (ticks) {
+		/*
+		 * Update hrtimer to use new timeout
+		 * HRTIMER_MODE_PINNED is suggested since vcpu may run in
+		 * the same physical cpu in next time
+		 */
+		hrtimer_cancel(&vcpu->arch.swtimer);
+		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
+	} else
+		/*
+		 * inject timer interrupt so that hall polling can dectect
+		 * and exit
+		 */
+		kvm_queue_irq(vcpu, INT_TI);
+}
+
+/*
+ * Save guest timer state and switch to soft guest timer if hard timer was in
+ * use.
+ */
+void kvm_save_timer(struct kvm_vcpu *vcpu)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	unsigned long cfg;
+
+	preempt_disable();
+	cfg = read_csr_gcfg();
+	if (!(cfg & CSR_GCFG_TIT)) {
+		/* disable guest use of hard timer */
+		write_csr_gcfg(cfg | CSR_GCFG_TIT);
+
+		/* save hard timer state */
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TCFG);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TVAL);
+		if (kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG) & CSR_TCFG_EN)
+			_kvm_save_timer(vcpu);
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
2.39.1

