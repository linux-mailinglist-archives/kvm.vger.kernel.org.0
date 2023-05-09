Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C0B6FC0D8
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbjEIHyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbjEIHx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 03:53:56 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAC3D1FC2;
        Tue,  9 May 2023 00:53:54 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxCeoR_FlkBOMGAA--.11463S3;
        Tue, 09 May 2023 15:53:53 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxFLUK_FlkIEhSAA--.16908S14;
        Tue, 09 May 2023 15:53:53 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v9 12/30] LoongArch: KVM: Implement vcpu interrupt operations
Date:   Tue,  9 May 2023 15:53:28 +0800
Message-Id: <20230509075346.1023386-13-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
References: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxFLUK_FlkIEhSAA--.16908S14
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxCrWfAr1fKw17tFyUXF45GFg_yoWruF4Upr
        W8C3y5Zw4fJry7K343GanY9r4Yv3yvgrW7XrZ3t343KwnrtFn0vF1xKr98JFy7Gw4kGF1S
        gFWa9FWDCF4DJw7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
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
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_SBL_CSS,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
index 000000000000..c05177bad3d4
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
+static unsigned int int_to_coreint[EXCCODE_INT_NUM] = {
+	[INT_TI]	= CPU_TIMER,
+	[INT_IPI]	= CPU_IPI,
+	[INT_SWI0]	= CPU_SIP0,
+	[INT_SWI1]	= CPU_SIP1,
+	[INT_HWI0]	= CPU_IP0,
+	[INT_HWI1]	= CPU_IP1,
+	[INT_HWI2]	= CPU_IP2,
+	[INT_HWI3]	= CPU_IP3,
+	[INT_HWI4]	= CPU_IP4,
+	[INT_HWI5]	= CPU_IP5,
+	[INT_HWI6]	= CPU_IP6,
+	[INT_HWI7]	= CPU_IP7,
+};
+
+static int _kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
+{
+	unsigned int irq = 0;
+
+	clear_bit(priority, &vcpu->arch.irq_pending);
+	if (priority < EXCCODE_INT_NUM)
+		irq = int_to_coreint[priority];
+
+	switch (priority) {
+	case INT_TI:
+	case INT_IPI:
+	case INT_SWI0:
+	case INT_SWI1:
+		set_gcsr_estat(irq);
+		break;
+
+	case INT_HWI0:
+	case INT_HWI1:
+	case INT_HWI2:
+	case INT_HWI3:
+	case INT_HWI4:
+	case INT_HWI5:
+	case INT_HWI6:
+	case INT_HWI7:
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
+	if (priority < EXCCODE_INT_NUM)
+		irq = int_to_coreint[priority];
+
+	switch (priority) {
+	case INT_TI:
+	case INT_IPI:
+	case INT_SWI0:
+	case INT_SWI1:
+		clear_gcsr_estat(irq);
+		break;
+
+	case INT_HWI0:
+	case INT_HWI1:
+	case INT_HWI2:
+	case INT_HWI3:
+	case INT_HWI4:
+	case INT_HWI5:
+	case INT_HWI6:
+	case INT_HWI7:
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
+		while (priority <= INT_IPI) {
+			_kvm_irq_clear(vcpu, priority);
+			priority = find_next_bit(pending_clr,
+					BITS_PER_BYTE * sizeof(*pending_clr),
+					priority + 1);
+		}
+	}
+
+	if (*pending) {
+		priority = __ffs(*pending);
+		while (priority <= INT_IPI) {
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
+	return test_bit(INT_TI, &vcpu->arch.irq_pending);
+}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 60213f7f7bac..f661743dbe66 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -304,6 +304,51 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
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

