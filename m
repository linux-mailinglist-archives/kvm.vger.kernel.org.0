Return-Path: <kvm+bounces-2346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C37E7F568A
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 03:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E05F2817C4
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 02:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726FB4412;
	Thu, 23 Nov 2023 02:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35393DA;
	Wed, 22 Nov 2023 18:46:51 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxJugZvV5l_Co8AA--.60562S3;
	Thu, 23 Nov 2023 10:46:49 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxjNwYvV5lgkBKAA--.32617S2;
	Thu, 23 Nov 2023 10:46:48 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] LoongArch: KVM: Fix timer emulation with oneshot mode
Date: Thu, 23 Nov 2023 10:44:22 +0800
Message-Id: <20231123024422.3754234-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxjNwYvV5lgkBKAA--.32617S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKrW5tr1kWw47Gw4fGF47WrX_yoW7WF4kpF
	WSkFyI9r18GryDG3W3Xan8Zwnxt393t3WfGrsrWay2yrnxX345XFW0gryxXFW5ArWfJF1S
	vryrAwnIvF4rX3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU25EfUUUUU

When timer is fired with oneshot mode, CSR TVAL will be -1 rather than 0.
There needs special handing for this situation. There are two scenarios
when oneshot timer is fired. One scenario is that time is fired after
exiting to host, CSR TVAL is set with 0 in order to inject hw interrupt,
and -1 will assigned to CSR TVAL soon.

The other situation is that timer is fired in VM and guest kernel is
hanlding timer IRQ, IRQ is acked and is ready to set next expired timer
value, then vm exits to host. Timer interrupt should not be inject at
this point, else there will be spurious timer interrupt.

Here hw timer irq status in CSR ESTAT is used to judge these two
scenarios. If CSR TVAL is -1, the oneshot timer is fired; and if timer hw
irq is on in CSR ESTAT register, it happens after exiting to host; else
if timer hw irq is off, we think that it happens in vm and timer IRQ
handler has already acked IRQ.

With this patch, runltp with version ltp20230516 passes to run in vm.
And this patch is based on the patch series.
https://lore.kernel.org/lkml/20231116023036.2324371-1-maobibo@loongson.cn/

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
Changes in v2:

If vm is doing timer IRQ after timer is fired and then vm exits to host,
CSR LOONGARCH_CSR_TVAL is set with 0. HW will set CSR LOONGARCH_CSR_TVAL
with -1 and inject timer IRQ. KVM host clears timer IRQ then. With this
method value of CSR LOONGARCH_CSR_TVAL will be -1 unchanged. Previous
method will not inject timer IRQ, however LOONGARCH_CSR_TVAL will
conitnue to go down from -1.

---
 arch/loongarch/kvm/timer.c | 65 +++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index 711982f9eeb5..6bc3292e779f 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -70,13 +70,17 @@ void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long timer_hz)
 void kvm_restore_timer(struct kvm_vcpu *vcpu)
 {
 	unsigned long cfg, delta, period;
+	unsigned long ticks, estat;
 	ktime_t expire, now;
 	struct loongarch_csrs *csr = vcpu->arch.csr;
 
 	/*
 	 * Set guest stable timer cfg csr
+	 * Disable timer before restore estat CSR register, avoid to
+	 * get invalid timer interrupt for old timer cfg
 	 */
 	cfg = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG);
+	write_gcsr_timercfg(0);
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TCFG);
 	if (!(cfg & CSR_TCFG_EN)) {
@@ -90,20 +94,47 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
 	 */
 	hrtimer_cancel(&vcpu->arch.swtimer);
 
+	/*
+	 * From LoongArch Reference Manual Volume 1 Chapter 7.6.2
+	 * If oneshot timer is fired, CSR TVAL will be -1, there are two
+	 * conditions:
+	 *  1) timer is fired during exiting to host
+	 *  2) timer is fired and vm is doing timer irq, and then exiting to
+	 *     host. Host should not inject timer irq to avoid spurious
+	 *     timer interrupt again
+	 */
+	ticks = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TVAL);
+	estat = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
+	if (!(cfg & CSR_TCFG_PERIOD) && (ticks > cfg)) {
+		/*
+		 * Writing 0 to LOONGARCH_CSR_TVAL will inject timer irq
+		 * and set CSR TVAL with -1
+		 */
+		write_gcsr_timertick(0);
+
+		/*
+		 * Writing CSR_TINTCLR_TI to LOONGARCH_CSR_TINTCLR will clear
+		 * timer interrupt, and CSR TVAL keeps unchanged with -1,
+		 * it avoids spurious timer interrupt
+		 */
+		if ((estat & CPU_TIMER) == 0)
+			gcsr_write(CSR_TINTCLR_TI, LOONGARCH_CSR_TINTCLR);
+		return;
+	}
+
 	/*
 	 * Set remainder tick value if not expired
 	 */
 	now = ktime_get();
 	expire = vcpu->arch.expire;
+	delta = 0;
 	if (ktime_before(now, expire))
 		delta = ktime_to_tick(vcpu, ktime_sub(expire, now));
-	else {
-		if (cfg & CSR_TCFG_PERIOD) {
-			period = cfg & CSR_TCFG_VAL;
-			delta = ktime_to_tick(vcpu, ktime_sub(now, expire));
-			delta = period - (delta % period);
-		} else
-			delta = 0;
+	else if (cfg & CSR_TCFG_PERIOD) {
+		period = cfg & CSR_TCFG_VAL;
+		delta = ktime_to_tick(vcpu, ktime_sub(now, expire));
+		delta = period - (delta % period);
+
 		/*
 		 * Inject timer here though sw timer should inject timer
 		 * interrupt async already, since sw timer may be cancelled
@@ -122,15 +153,25 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
  */
 static void _kvm_save_timer(struct kvm_vcpu *vcpu)
 {
-	unsigned long ticks, delta;
+	unsigned long ticks, delta, cfg;
 	ktime_t expire;
 	struct loongarch_csrs *csr = vcpu->arch.csr;
 
 	ticks = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TVAL);
-	delta = tick_to_ns(vcpu, ticks);
-	expire = ktime_add_ns(ktime_get(), delta);
-	vcpu->arch.expire = expire;
-	if (ticks) {
+	cfg = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG);
+
+	/*
+	 * From LoongArch Reference Manual Volume 1 Chapter 7.6.2
+	 * If period timer is fired, CSR TVAL will be reloaded from CSR TCFG
+	 * If oneshot timer is fired, CSR TVAL will be -1
+	 * Here judge one shot timer fired by checking whether TVAL is larger
+	 * than TCFG
+	 */
+	if (ticks < cfg) {
+		delta = tick_to_ns(vcpu, ticks);
+		expire = ktime_add_ns(ktime_get(), delta);
+		vcpu->arch.expire = expire;
+
 		/*
 		 * HRTIMER_MODE_PINNED is suggested since vcpu may run in
 		 * the same physical cpu in next time

base-commit: c2d5304e6c648ebcf653bace7e51e0e6742e46c8
-- 
2.39.3


