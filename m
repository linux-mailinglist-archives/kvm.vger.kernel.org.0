Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB57AF97E
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjI0Efv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjI0Eey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:34:54 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF9C61A7;
        Tue, 26 Sep 2023 20:10:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxRvENnRNlJBctAA--.20819S3;
        Wed, 27 Sep 2023 11:10:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S11;
        Wed, 27 Sep 2023 11:10:04 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 09/25] LoongArch: KVM: Implement vcpu interrupt operations
Date:   Wed, 27 Sep 2023 11:09:43 +0800
Message-Id: <20230927030959.3629941-10-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S11
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement vcpu interrupt operations such as vcpu set irq and vcpu
clear irq, using set_gcsr_estat() to set irq which is parsed by the
irq bitmap.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/interrupt.c | 183 +++++++++++++++++++++++++++++++++
 arch/loongarch/kvm/vcpu.c      |  38 +++++++
 2 files changed, 221 insertions(+)
 create mode 100644 arch/loongarch/kvm/interrupt.c

diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
new file mode 100644
index 0000000000..4c3f22de4b
--- /dev/null
+++ b/arch/loongarch/kvm/interrupt.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <asm/kvm_csr.h>
+#include <asm/kvm_vcpu.h>
+
+static unsigned int priority_to_irq[EXCCODE_INT_NUM] = {
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
+static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
+{
+	unsigned int irq = 0;
+
+	clear_bit(priority, &vcpu->arch.irq_pending);
+	if (priority < EXCCODE_INT_NUM)
+		irq = priority_to_irq[priority];
+
+	switch (priority) {
+	case INT_TI:
+	case INT_IPI:
+	case INT_SWI0:
+	case INT_SWI1:
+		set_gcsr_estat(irq);
+		break;
+
+	case INT_HWI0 ... INT_HWI7:
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
+static int kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
+{
+	unsigned int irq = 0;
+
+	clear_bit(priority, &vcpu->arch.irq_clear);
+	if (priority < EXCCODE_INT_NUM)
+		irq = priority_to_irq[priority];
+
+	switch (priority) {
+	case INT_TI:
+	case INT_IPI:
+	case INT_SWI0:
+	case INT_SWI1:
+		clear_gcsr_estat(irq);
+		break;
+
+	case INT_HWI0 ... INT_HWI7:
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
+void kvm_deliver_intr(struct kvm_vcpu *vcpu)
+{
+	unsigned int priority;
+	unsigned long *pending = &vcpu->arch.irq_pending;
+	unsigned long *pending_clr = &vcpu->arch.irq_clear;
+
+	if (!(*pending) && !(*pending_clr))
+		return;
+
+	if (*pending_clr) {
+		priority = __ffs(*pending_clr);
+		while (priority <= INT_IPI) {
+			kvm_irq_clear(vcpu, priority);
+			priority = find_next_bit(pending_clr,
+					BITS_PER_BYTE * sizeof(*pending_clr),
+					priority + 1);
+		}
+	}
+
+	if (*pending) {
+		priority = __ffs(*pending);
+		while (priority <= INT_IPI) {
+			kvm_irq_deliver(vcpu, priority);
+			priority = find_next_bit(pending,
+					BITS_PER_BYTE * sizeof(*pending),
+					priority + 1);
+		}
+	}
+}
+
+int kvm_pending_timer(struct kvm_vcpu *vcpu)
+{
+	return test_bit(INT_TI, &vcpu->arch.irq_pending);
+}
+
+/*
+ * Only support illegal instruction or illegal Address Error exception,
+ * Other exceptions are injected by hardware in kvm mode
+ */
+static void _kvm_deliver_exception(struct kvm_vcpu *vcpu,
+				unsigned int code, unsigned int subcode)
+{
+	unsigned long val, vec_size;
+
+	/*
+	 * BADV is added for EXCCODE_ADE exception
+	 *  Use PC register (GVA address) if it is instruction exeception
+	 *  Else use BADV from host side (GPA address) for data exeception
+	 */
+	if (code == EXCCODE_ADE) {
+		if (subcode == EXSUBCODE_ADEF)
+			val = vcpu->arch.pc;
+		else
+			val = vcpu->arch.badv;
+		kvm_write_hw_gcsr(LOONGARCH_CSR_BADV, val);
+	}
+
+	/* Set exception instruction */
+	kvm_write_hw_gcsr(LOONGARCH_CSR_BADI, vcpu->arch.badi);
+
+	/*
+	 * Save CRMD in PRMD
+	 * Set IRQ disabled and PLV0 with CRMD
+	 */
+	val = kvm_read_hw_gcsr(LOONGARCH_CSR_CRMD);
+	kvm_write_hw_gcsr(LOONGARCH_CSR_PRMD, val);
+	val = val & ~(CSR_CRMD_PLV | CSR_CRMD_IE);
+	kvm_write_hw_gcsr(LOONGARCH_CSR_CRMD, val);
+
+	/* Set exception PC address */
+	kvm_write_hw_gcsr(LOONGARCH_CSR_ERA, vcpu->arch.pc);
+
+	/*
+	 * Set exception code
+	 * Exception and interrupt can be inject at the same time
+	 * Hardware will handle exception first and then extern interrupt
+	 * Exception code is Ecode in ESTAT[16:21]
+	 * Interrupt code in ESTAT[0:12]
+	 */
+	val = kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT);
+	val = (val & ~CSR_ESTAT_EXC) | code;
+	kvm_write_hw_gcsr(LOONGARCH_CSR_ESTAT, val);
+
+	/* Calculate expcetion entry address */
+	val = kvm_read_hw_gcsr(LOONGARCH_CSR_ECFG);
+	vec_size = (val & CSR_ECFG_VS) >> CSR_ECFG_VS_SHIFT;
+	if (vec_size)
+		vec_size = (1 << vec_size) * 4;
+	val =  kvm_read_hw_gcsr(LOONGARCH_CSR_EENTRY);
+	vcpu->arch.pc = val + code * vec_size;
+}
+
+void kvm_deliver_exception(struct kvm_vcpu *vcpu)
+{
+	unsigned int code;
+	unsigned long *pending = &vcpu->arch.exception_pending;
+
+	if (*pending) {
+		code = __ffs(*pending);
+		_kvm_deliver_exception(vcpu, code, vcpu->arch.esubcode);
+		*pending = 0;
+		vcpu->arch.esubcode = 0;
+	}
+}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 0f19c8b0c0..7576f5a735 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -458,6 +458,44 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq)
+{
+	int intr = (int)irq->irq;
+
+	if (intr > 0)
+		kvm_queue_irq(vcpu, intr);
+	else if (intr < 0)
+		kvm_dequeue_irq(vcpu, -intr);
+	else {
+		kvm_err("%s: invalid interrupt ioctl %d\n", __func__, irq->irq);
+		return -EINVAL;
+	}
+
+	kvm_vcpu_kick(vcpu);
+
+	return 0;
+}
+
+long kvm_arch_vcpu_async_ioctl(struct file *filp,
+			       unsigned int ioctl, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct kvm_vcpu *vcpu = filp->private_data;
+
+	if (ioctl == KVM_INTERRUPT) {
+		struct kvm_interrupt irq;
+
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			return -EFAULT;
+
+		kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__, irq.irq);
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
2.39.3

