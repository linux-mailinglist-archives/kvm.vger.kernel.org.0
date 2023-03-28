Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA19E6CBF45
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjC1MhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjC1MhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:37:08 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29481A5CF;
        Tue, 28 Mar 2023 05:36:41 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cxjdob3iJkGRkTAA--.17789S3;
        Tue, 28 Mar 2023 20:31:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S14;
        Tue, 28 Mar 2023 20:31:22 +0800 (CST)
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
Subject: [PING PATCH v4 12/29] LoongArch: KVM: Implement vcpu interrupt operations
Date:   Tue, 28 Mar 2023 20:31:02 +0800
Message-Id: <20230328123119.3649361-13-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S14
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxCrWfAr1fKFWkWry3Gr1rJFb_yoWrKFWDpF
        W8Cw45Xw48Gr17G343ZFnYvr4Yqr1kKFZxCr97C3y3K347tr95XFyvyr98XF1UGw4UKF1f
        X34SqaykCa45JwUanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

