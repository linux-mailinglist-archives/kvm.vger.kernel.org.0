Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57A6C28C5
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 04:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjCUD51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 23:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCUD5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 23:57:03 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1EF92DE60;
        Mon, 20 Mar 2023 20:57:01 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxMI8MKxlkYjYPAA--.22750S3;
        Tue, 21 Mar 2023 11:57:00 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxD78EKxlkQB4IAA--.33942S14;
        Tue, 21 Mar 2023 11:56:59 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH v4 12/29] LoongArch: KVM: Implement vcpu interrupt operations
Date:   Tue, 21 Mar 2023 11:56:34 +0800
Message-Id: <20230321035651.598505-13-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230321035651.598505-1-zhaotianrui@loongson.cn>
References: <20230321035651.598505-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxD78EKxlkQB4IAA--.33942S14
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxCrWfAr1fKFWkWry3Gr1rJFb_yoWrKFWDpF
        W8Cw45Xw48Gr17G343ZFnYvr4Yqr1kKFZxCr97C3y3K347tr95XFyvyr98XF1UGw4UKF1f
        X34SqaykCa45JwUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bxxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487
        Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1s
        IEY20_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_
        JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4
        AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26w1j6s0DMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE
        42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement vcpu interrupt operations such as vcpu set irq and
vcpu clear irq, using set_gcsr_estat to set irq which is
parsed by the irq bitmap.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/interrupt.c | 126 +++++++++++++++++++++++++++++++++
 arch/loongarch/kvm/vcpu.c      |  45 ++++++++++++
 2 files changed, 171 insertions(+)
 create mode 100644 arch/loongarch/kvm/interrupt.c

diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
new file mode 100644
index 000000000..02267a71d
--- /dev/null
+++ b/arch/loongarch/kvm/interrupt.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <asm/kvm_vcpu.h>
+
+static unsigned int int_to_coreint[LOONGARCH_EXC_MAX] = {
+	[LARCH_INT_TIMER]	= CPU_TIMER,
+	[LARCH_INT_IPI]		= CPU_IPI,
+	[LARCH_INT_SIP0]	= CPU_SIP0,
+	[LARCH_INT_SIP1]	= CPU_SIP1,
+	[LARCH_INT_IP0]		= CPU_IP0,
+	[LARCH_INT_IP1]		= CPU_IP1,
+	[LARCH_INT_IP2]		= CPU_IP2,
+	[LARCH_INT_IP3]		= CPU_IP3,
+	[LARCH_INT_IP4]		= CPU_IP4,
+	[LARCH_INT_IP5]		= CPU_IP5,
+	[LARCH_INT_IP6]		= CPU_IP6,
+	[LARCH_INT_IP7]		= CPU_IP7,
+};
+
+static int _kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
+{
+	unsigned int irq = 0;
+
+	clear_bit(priority, &vcpu->arch.irq_pending);
+	if (priority < LOONGARCH_EXC_MAX)
+		irq = int_to_coreint[priority];
+
+	switch (priority) {
+	case LARCH_INT_TIMER:
+	case LARCH_INT_IPI:
+	case LARCH_INT_SIP0:
+	case LARCH_INT_SIP1:
+		set_gcsr_estat(irq);
+		break;
+
+	case LARCH_INT_IP0:
+	case LARCH_INT_IP1:
+	case LARCH_INT_IP2:
+	case LARCH_INT_IP3:
+	case LARCH_INT_IP4:
+	case LARCH_INT_IP5:
+	case LARCH_INT_IP6:
+	case LARCH_INT_IP7:
+		set_csr_gintc(irq);
+		break;
+
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+static int _kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
+{
+	unsigned int irq = 0;
+
+	clear_bit(priority, &vcpu->arch.irq_clear);
+	if (priority < LOONGARCH_EXC_MAX)
+		irq = int_to_coreint[priority];
+
+	switch (priority) {
+	case LARCH_INT_TIMER:
+	case LARCH_INT_IPI:
+	case LARCH_INT_SIP0:
+	case LARCH_INT_SIP1:
+		clear_gcsr_estat(irq);
+		break;
+
+	case LARCH_INT_IP0:
+	case LARCH_INT_IP1:
+	case LARCH_INT_IP2:
+	case LARCH_INT_IP3:
+	case LARCH_INT_IP4:
+	case LARCH_INT_IP5:
+	case LARCH_INT_IP6:
+	case LARCH_INT_IP7:
+		clear_csr_gintc(irq);
+		break;
+
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+void _kvm_deliver_intr(struct kvm_vcpu *vcpu)
+{
+	unsigned long *pending = &vcpu->arch.irq_pending;
+	unsigned long *pending_clr = &vcpu->arch.irq_clear;
+	unsigned int priority;
+
+	if (!(*pending) && !(*pending_clr))
+		return;
+
+	if (*pending_clr) {
+		priority = __ffs(*pending_clr);
+		while (priority <= LOONGARCH_EXC_IPNUM) {
+			_kvm_irq_clear(vcpu, priority);
+			priority = find_next_bit(pending_clr,
+					BITS_PER_BYTE * sizeof(*pending_clr),
+					priority + 1);
+		}
+	}
+
+	if (*pending) {
+		priority = __ffs(*pending);
+		while (priority <= LOONGARCH_EXC_IPNUM) {
+			_kvm_irq_deliver(vcpu, priority);
+			priority = find_next_bit(pending,
+					BITS_PER_BYTE * sizeof(*pending),
+					priority + 1);
+		}
+	}
+}
+
+int _kvm_pending_timer(struct kvm_vcpu *vcpu)
+{
+	return test_bit(LARCH_INT_TIMER, &vcpu->arch.irq_pending);
+}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 2709ab43d..4c3b41fd1 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -327,6 +327,51 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
+			     struct kvm_loongarch_interrupt *irq)
+{
+	int intr = (int)irq->irq;
+	struct kvm_vcpu *dvcpu = NULL;
+
+	if (irq->cpu == -1)
+		dvcpu = vcpu;
+	else
+		dvcpu = kvm_get_vcpu(vcpu->kvm, irq->cpu);
+
+	if (intr > 0)
+		_kvm_queue_irq(dvcpu, intr);
+	else if (intr < 0)
+		_kvm_dequeue_irq(dvcpu, -intr);
+	else {
+		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
+				irq->cpu, irq->irq);
+		return -EINVAL;
+	}
+
+	kvm_vcpu_kick(dvcpu);
+	return 0;
+}
+
+long kvm_arch_vcpu_async_ioctl(struct file *filp,
+			       unsigned int ioctl, unsigned long arg)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+
+	if (ioctl == KVM_INTERRUPT) {
+		struct kvm_loongarch_interrupt irq;
+
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			return -EFAULT;
+		kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__,
+			  irq.irq);
+
+		return kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+	}
+
+	return -ENOIOCTLCMD;
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
-- 
2.31.1

