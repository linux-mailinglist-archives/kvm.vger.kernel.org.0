Return-Path: <kvm+bounces-21025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E909280B3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A181C2410D
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8A0144D37;
	Fri,  5 Jul 2024 02:56:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E237C13AA2A;
	Fri,  5 Jul 2024 02:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148189; cv=none; b=cIZB8Cq51vYBQyfctsJG/M4+7yQ533wNL7P5uQ3nU6D/dBt2RHG/HQnW8rBO3SqkGRfrMPULdRJTNwMTVC15i6pDnO4qX0l1UCvZxRHBWf2PEdmlyihEdwRd8ehCwQRCqGAREStlqr8u9HJ0mvQO+AeXwicPrbflvb5Hxh5u2JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148189; c=relaxed/simple;
	bh=zEh8CazyeAJ7fjX2mBsNce6iZbQeiOQfmvW2pqjdL2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FEqnxh7aaBjgN9plYZCha/Dc5tyjm7xcOvrPB7iQqyEtzY7c0F/SJGLHR7ykS6WxKUH3oYZxBx8juPnhct3FK6kSqlIVXP4A+yFFmqycjPQeVY5VGCVIgHdsLfsjjGTIPWsJbR5YSAcClO9ngMm/u6ewC2qSZ4c1/DGvndbJse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxvfDYYIdmBSUBAA--.3765S3;
	Fri, 05 Jul 2024 10:56:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S11;
	Fri, 05 Jul 2024 10:56:23 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Min Zhou <zhoumin@loongson.cn>,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH 09/11] LoongArch: KVM: Add PCHPIC read and write functions
Date: Fri,  5 Jul 2024 10:38:52 +0800
Message-Id: <20240705023854.1005258-10-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240705023854.1005258-1-lixianglai@loongson.cn>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S11
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implementation of IPI interrupt controller address
space read and write function simulation.

Implement interrupt injection interface under loongarch.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Min Zhou <zhoumin@loongson.cn> 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_host.h    |  18 ++
 arch/loongarch/include/asm/kvm_pch_pic.h |  31 +++
 arch/loongarch/include/uapi/asm/kvm.h    |   1 +
 arch/loongarch/kvm/intc/ipi.c            |  46 ++--
 arch/loongarch/kvm/intc/pch_pic.c        | 290 ++++++++++++++++++++++-
 arch/loongarch/kvm/vm.c                  |  34 +++
 6 files changed, 402 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 31891f884cee..17f659b6e035 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -34,6 +34,22 @@
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
 
+/* KVM_IRQ_LINE irq field index values */
+#define KVM_LOONGARCH_IRQ_TYPE_SHIFT	24
+#define KVM_LOONGARCH_IRQ_TYPE_MASK	0xff
+#define KVM_LOONGARCH_IRQ_VCPU_SHIFT	16
+#define KVM_LOONGARCH_IRQ_VCPU_MASK	0xff
+#define KVM_LOONGARCH_IRQ_NUM_SHIFT	0
+#define KVM_LOONGARCH_IRQ_NUM_MASK	0xffff
+
+/* irq_type field */
+#define KVM_LOONGARCH_IRQ_TYPE_CPU_IP	0
+#define KVM_LOONGARCH_IRQ_TYPE_CPU_IO	1
+#define KVM_LOONGARCH_IRQ_TYPE_HT	2
+#define KVM_LOONGARCH_IRQ_TYPE_MSI	3
+#define KVM_LOONGARCH_IRQ_TYPE_IOAPIC	4
+#define KVM_LOONGARCH_IRQ_TYPE_ROUTE	5
+
 #define KVM_GUESTDBG_SW_BP_MASK		\
 	(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
 #define KVM_GUESTDBG_VALID_MASK		\
@@ -47,6 +63,8 @@ struct kvm_vm_stat {
 	u64 ipi_write_exits;
 	u64 extioi_read_exits;
 	u64 extioi_write_exits;
+	u64 pch_pic_read_exits;
+	u64 pch_pic_write_exits;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/loongarch/include/asm/kvm_pch_pic.h b/arch/loongarch/include/asm/kvm_pch_pic.h
index 5aef0e4e3863..91bd5a5ec575 100644
--- a/arch/loongarch/include/asm/kvm_pch_pic.h
+++ b/arch/loongarch/include/asm/kvm_pch_pic.h
@@ -8,6 +8,35 @@
 
 #include <kvm/iodev.h>
 
+#define PCH_PIC_SIZE			0x3e8
+
+#define PCH_PIC_INT_ID_START		0x0
+#define PCH_PIC_INT_ID_END		0x7
+#define PCH_PIC_MASK_START		0x20
+#define PCH_PIC_MASK_END		0x27
+#define PCH_PIC_HTMSI_EN_START		0x40
+#define PCH_PIC_HTMSI_EN_END		0x47
+#define PCH_PIC_EDGE_START		0x60
+#define PCH_PIC_EDGE_END		0x67
+#define PCH_PIC_CLEAR_START		0x80
+#define PCH_PIC_CLEAR_END		0x87
+#define PCH_PIC_AUTO_CTRL0_START	0xc0
+#define PCH_PIC_AUTO_CTRL0_END		0xc7
+#define PCH_PIC_AUTO_CTRL1_START	0xe0
+#define PCH_PIC_AUTO_CTRL1_END		0xe7
+#define PCH_PIC_ROUTE_ENTRY_START	0x100
+#define PCH_PIC_ROUTE_ENTRY_END		0x13f
+#define PCH_PIC_HTMSI_VEC_START		0x200
+#define PCH_PIC_HTMSI_VEC_END		0x23f
+#define PCH_PIC_INT_IRR_START		0x380
+#define PCH_PIC_INT_IRR_END		0x38f
+#define PCH_PIC_INT_ISR_START		0x3a0
+#define PCH_PIC_INT_ISR_END		0x3af
+#define PCH_PIC_POLARITY_START		0x3e0
+#define PCH_PIC_POLARITY_END		0x3e7
+#define PCH_PIC_INT_ID_VAL		0x7000000UL
+#define PCH_PIC_INT_ID_VER		0x1UL
+
 struct loongarch_pch_pic {
 	spinlock_t lock;
 	struct kvm *kvm;
@@ -26,5 +55,7 @@ struct loongarch_pch_pic {
 	uint64_t pch_pic_base;
 };
 
+void pch_pic_set_irq(struct loongarch_pch_pic *s, int irq, int level);
+void pch_msi_set_irq(struct kvm *kvm, int irq, int level);
 int kvm_loongarch_register_pch_pic_device(void);
 #endif /* LOONGARCH_PCH_PIC_H */
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 9cdcb5e2a731..6d5ad95fcb75 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -16,6 +16,7 @@
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
+#define __KVM_HAVE_IRQ_LINE
 
 #define KVM_GUESTDBG_USE_SW_BP		0x00010000
 
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index fbf6f7e462cf..3acbcae7e5cb 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -223,9 +223,9 @@ static int kvm_loongarch_ipi_read(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static void send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
+static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 {
-	int i;
+	int i, ret;
 	uint32_t val = 0, mask = 0;
 	/*
 	 * Bit 27-30 is mask for byte writing.
@@ -233,8 +233,11 @@ static void send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 	 */
 	if ((data >> 27) & 0xf) {
 		/* Read the old val */
-		kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
-
+		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+		if (unlikely(ret)) {
+			kvm_err("%s: : read date from addr %llx failed\n", __func__, addr);
+			return ret;
+		}
 		/* Construct the mask by scanning the bit 27-30 */
 		for (i = 0; i < 4; i++) {
 			if (data & (0x1 << (27 + i)))
@@ -245,41 +248,49 @@ static void send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 	}
 
 	val |= ((uint32_t)(data >> 32) & ~mask);
-	kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+	if (unlikely(ret)) {
+		kvm_err("%s: : write date to addr %llx failed\n", __func__, addr);
+	}
+
+	return ret;
 }
 
-static void mail_send(struct kvm *kvm, uint64_t data)
+static int mail_send(struct kvm *kvm, uint64_t data)
 {
 	struct kvm_vcpu *vcpu;
 	int cpu, mailbox;
-	int offset;
+	int offset, ret;
 
 	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
 	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
 	if (unlikely(vcpu == NULL)) {
 		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
-		return;
+		return -EINVAL;
 	}
 
 	mailbox = ((data & 0xffffffff) >> 2) & 0x7;
 	offset = SMP_MAILBOX + CORE_BUF_20 + mailbox * 4;
-	send_ipi_data(vcpu, offset, data);
+	ret = send_ipi_data(vcpu, offset, data);
+
+	return ret;
 }
 
-static void any_send(struct kvm *kvm, uint64_t data)
+static int any_send(struct kvm *kvm, uint64_t data)
 {
 	struct kvm_vcpu *vcpu;
-	int cpu, offset;
+	int cpu, offset, ret;
 
 	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
 	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
 	if (unlikely(vcpu == NULL)) {
 		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
-		return;
+		return -EINVAL;
 	}
 
 	offset = data & 0xffff;
-	send_ipi_data(vcpu, offset, data);
+	ret = send_ipi_data(vcpu, offset, data);
+	return ret;
 }
 
 static int kvm_loongarch_mail_write(struct kvm_vcpu *vcpu,
@@ -287,6 +298,7 @@ static int kvm_loongarch_mail_write(struct kvm_vcpu *vcpu,
 			gpa_t addr, int len, const void *val)
 {
 	struct loongarch_ipi *ipi;
+	int ret;
 
 	ipi = vcpu->kvm->arch.ipi;
 	if (!ipi) {
@@ -299,16 +311,18 @@ static int kvm_loongarch_mail_write(struct kvm_vcpu *vcpu,
 
 	switch (addr) {
 	case MAIL_SEND_OFFSET:
-		mail_send(vcpu->kvm, *(uint64_t *)val);
+		ret = mail_send(vcpu->kvm, *(uint64_t *)val);
 		break;
 	case ANY_SEND_OFFSET:
-		any_send(vcpu->kvm, *(uint64_t *)val);
+		ret = any_send(vcpu->kvm, *(uint64_t *)val);
 		break;
 	default:
+		kvm_err("%s: invalid addr %llx!\n", __func__, addr);
+		ret = -EINVAL;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_loongarch_ipi_ops = {
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 4097c00e8294..4ad85277fced 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -8,18 +8,304 @@
 #include <asm/kvm_vcpu.h>
 #include <linux/count_zeros.h>
 
+/* update the isr according to irq level and route irq to extioi */
+static void pch_pic_update_irq(struct loongarch_pch_pic *s, int irq, int level)
+{
+	u64 mask = (1 << irq);
+
+	/*
+	 * set isr and route irq to extioi and
+	 * the route table is in htmsi_vector[]
+	 */
+	if (level) {
+		if (mask & s->irr & ~s->mask) {
+			s->isr |= mask;
+			irq = s->htmsi_vector[irq];
+			extioi_set_irq(s->kvm->arch.extioi, irq, level);
+		}
+	} else {
+		if (mask & s->isr & ~s->irr) {
+			s->isr &= ~mask;
+			irq = s->htmsi_vector[irq];
+			extioi_set_irq(s->kvm->arch.extioi, irq, level);
+		}
+	}
+}
+
+/* msi irq handler */
+void pch_msi_set_irq(struct kvm *kvm, int irq, int level)
+{
+	extioi_set_irq(kvm->arch.extioi, irq, level);
+}
+
+/* called when a irq is triggered in pch pic */
+void pch_pic_set_irq(struct loongarch_pch_pic *s, int irq, int level)
+{
+	u64 mask = (1 << irq);
+
+	spin_lock(&s->lock);
+	if (level)
+		/* set irr */
+		s->irr |= mask;
+	else {
+		/* 0 level signal in edge triggered irq does not mean to clear irq
+		 * The irr register variable is cleared when the cpu writes to the
+		 * PCH_PIC_CLEAR_START address area
+		 */
+		if (s->edge & mask)
+			return;
+		s->irr &= ~mask;
+	}
+	pch_pic_update_irq(s, irq, level);
+	spin_unlock(&s->lock);
+}
+
+/* update batch irqs, the irq_mask is a bitmap of irqs */
+static void pch_pic_update_batch_irqs(struct loongarch_pch_pic *s, u64 irq_mask, int level)
+{
+	int irq, bits;
+
+	/* find each irq by irqs bitmap and update each irq */
+	bits = sizeof(irq_mask) * 8;
+	irq = find_first_bit((void *)&irq_mask, bits);
+	while (irq < bits) {
+		pch_pic_update_irq(s, irq, level);
+		bitmap_clear((void *)&irq_mask, irq, 1);
+		irq = find_first_bit((void *)&irq_mask, bits);
+	}
+}
+
+/*
+ * pch pic register is 64-bit, but it is accessed by 32-bit,
+ * so we use high to get whether low or high 32 bits we want
+ * to read.
+ */
+static u32 pch_pic_read_reg(u64 *s, int high)
+{
+	u64 val = *s;
+
+	/* read the high 32 bits when the high is 1 */
+	return high ? (u32)(val >> 32) : (u32)val;
+}
+
+/*
+ * pch pic register is 64-bit, but it is accessed by 32-bit,
+ * so we use high to get whether low or high 32 bits we want
+ * to write.
+ */
+static u32 pch_pic_write_reg(u64 *s, int high, u32 v)
+{
+	u64 val = *s, data = v;
+
+	if (high) {
+		/*
+		 * Clear val high 32 bits
+		 * write the high 32 bits when the high is 1
+		 */
+		*s = (val << 32 >> 32) | (data << 32);
+		val >>= 32;
+	} else
+		/*
+		 * Clear val low 32 bits
+		 * write the low 32 bits when the high is 0
+		 */
+		*s = (val >> 32 << 32) | v;
+
+	return (u32)val;
+}
+
+static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
+					int len, const void *val)
+{
+	u32 old, data, offset, index;
+	u64 irq;
+	int ret;
+
+	ret = 0;
+	data = *(u32 *)val;
+	offset = addr - s->pch_pic_base;
+
+	spin_lock(&s->lock);
+	switch (offset) {
+	case PCH_PIC_MASK_START ... PCH_PIC_MASK_END:
+		offset -= PCH_PIC_MASK_START;
+		/* get whether high or low 32 bits we want to write */
+		index = offset >> 2;
+		old = pch_pic_write_reg(&s->mask, index, data);
+
+		/* enable irq when mask value change to 0 */
+		irq = (old & ~data) << (32 * index);
+		pch_pic_update_batch_irqs(s, irq, 1);
+
+		/* disable irq when mask value change to 1 */
+		irq = (~old & data) << (32 * index);
+		pch_pic_update_batch_irqs(s, irq, 0);
+		break;
+	case PCH_PIC_HTMSI_EN_START ... PCH_PIC_HTMSI_EN_END:
+		offset -= PCH_PIC_HTMSI_EN_START;
+		index = offset >> 2;
+		pch_pic_write_reg(&s->htmsi_en, index, data);
+		break;
+	case PCH_PIC_EDGE_START ... PCH_PIC_EDGE_END:
+		offset -= PCH_PIC_EDGE_START;
+		index = offset >> 2;
+		/* 1: edge triggered, 0: level triggered */
+		pch_pic_write_reg(&s->edge, index, data);
+		break;
+	case PCH_PIC_CLEAR_START ... PCH_PIC_CLEAR_END:
+		offset -= PCH_PIC_CLEAR_START;
+		index = offset >> 2;
+		/* write 1 to clear edge irq */
+		old = pch_pic_read_reg(&s->irr, index);
+		/*
+		 * get the irq bitmap which is edge triggered and
+		 * already set and to be cleared
+		 */
+		irq = old & pch_pic_read_reg(&s->edge, index) & data;
+		/* write irr to the new state where irqs have been cleared */
+		pch_pic_write_reg(&s->irr, index, old & ~irq);
+		/* update cleared irqs */
+		pch_pic_update_batch_irqs(s, irq, 0);
+		break;
+	case PCH_PIC_AUTO_CTRL0_START ... PCH_PIC_AUTO_CTRL0_END:
+		offset -= PCH_PIC_AUTO_CTRL0_START;
+		index = offset >> 2;
+		/* we only use default mode: fixed interrupt distribution mode */
+		pch_pic_write_reg(&s->auto_ctrl0, index, 0);
+		break;
+	case PCH_PIC_AUTO_CTRL1_START ... PCH_PIC_AUTO_CTRL1_END:
+		offset -= PCH_PIC_AUTO_CTRL1_START;
+		index = offset >> 2;
+		/* we only use default mode: fixed interrupt distribution mode */
+		pch_pic_write_reg(&s->auto_ctrl1, index, 0);
+		break;
+	case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
+		offset -= PCH_PIC_ROUTE_ENTRY_START;
+		/* only route to int0: extioi */
+		s->route_entry[offset] = 1;
+		break;
+	case PCH_PIC_HTMSI_VEC_START ... PCH_PIC_HTMSI_VEC_END:
+		/* route table to extioi */
+		offset -= PCH_PIC_HTMSI_VEC_START;
+		s->htmsi_vector[offset] = (u8)data;
+		break;
+	case PCH_PIC_POLARITY_START ... PCH_PIC_POLARITY_END:
+		offset -= PCH_PIC_POLARITY_START;
+		index = offset >> 2;
+
+		/* we only use defalut value 0: high level triggered */
+		pch_pic_write_reg(&s->polarity, index, 0);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	spin_unlock(&s->lock);
+	return ret;
+}
+
 static int kvm_loongarch_pch_pic_write(struct kvm_vcpu *vcpu,
 					struct kvm_io_device *dev,
 					gpa_t addr, int len, const void *val)
 {
-	return 0;
+	int ret;
+	struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
+
+	if (!s) {
+		kvm_err("%s: pch pic irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	/* statistics of pch pic writing */
+	vcpu->kvm->stat.pch_pic_write_exits++;
+	ret = loongarch_pch_pic_write(s, addr, len, val);
+
+	return ret;
+}
+
+static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int len, void *val)
+{
+	int offset, index, ret = 0;
+	u32 data = 0;
+	u64 int_id = 0;
+
+	offset = addr - s->pch_pic_base;
+
+	spin_lock(&s->lock);
+	switch (offset) {
+	case PCH_PIC_INT_ID_START ... PCH_PIC_INT_ID_END:
+		/* int id version */
+		int_id |= (u64)PCH_PIC_INT_ID_VER << 32;
+		/* irq number */
+		int_id |= (u64)31 << (32 + 16);
+		/* int id value */
+		int_id |= PCH_PIC_INT_ID_VAL;
+		*(u64 *)val = int_id;
+		break;
+	case PCH_PIC_MASK_START ... PCH_PIC_MASK_END:
+		offset -= PCH_PIC_MASK_START;
+		index = offset >> 2;
+		/* read mask reg */
+		data = pch_pic_read_reg(&s->mask, index);
+		*(u32 *)val = data;
+		break;
+	case PCH_PIC_HTMSI_EN_START ... PCH_PIC_HTMSI_EN_END:
+		offset -= PCH_PIC_HTMSI_EN_START;
+		index = offset >> 2;
+		/* read htmsi enable reg */
+		data = pch_pic_read_reg(&s->htmsi_en, index);
+		*(u32 *)val = data;
+		break;
+	case PCH_PIC_EDGE_START ... PCH_PIC_EDGE_END:
+		offset -= PCH_PIC_EDGE_START;
+		index = offset >> 2;
+		/* read edge enable reg */
+		data = pch_pic_read_reg(&s->edge, index);
+		*(u32 *)val = data;
+		break;
+	case PCH_PIC_AUTO_CTRL0_START ... PCH_PIC_AUTO_CTRL0_END:
+	case PCH_PIC_AUTO_CTRL1_START ... PCH_PIC_AUTO_CTRL1_END:
+		/* we only use default mode: fixed interrupt distribution mode */
+		*(u32 *)val = 0;
+		break;
+	case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
+		/* only route to int0: extioi */
+		*(u8 *)val = 1;
+		break;
+	case PCH_PIC_HTMSI_VEC_START ... PCH_PIC_HTMSI_VEC_END:
+		offset -= PCH_PIC_HTMSI_VEC_START;
+		/* read htmsi vector */
+		data = s->htmsi_vector[offset];
+		*(u8 *)val = data;
+		break;
+	case PCH_PIC_POLARITY_START ... PCH_PIC_POLARITY_END:
+		/* we only use defalut value 0: high level triggered */
+		*(u32 *)val = 0;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	spin_unlock(&s->lock);
+	return ret;
 }
 
 static int kvm_loongarch_pch_pic_read(struct kvm_vcpu *vcpu,
 					struct kvm_io_device *dev,
 					gpa_t addr, int len, void *val)
 {
-	return 0;
+	int ret;
+	struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
+
+	if (!s) {
+		kvm_err("%s: pch pic irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	/* statistics of pch pic reading */
+	vcpu->kvm->stat.pch_pic_read_exits++;
+	ret = loongarch_pch_pic_read(s, addr, len, val);
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_loongarch_pch_pic_ops = {
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 6b2e4f66ad26..decfe11be46b 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -5,6 +5,8 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_extioi.h>
+#include <asm/kvm_pch_pic.h>
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
@@ -103,3 +105,35 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	return -ENOIOCTLCMD;
 }
+
+int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *data,
+			  bool line_status)
+{
+	bool level;
+	struct loongarch_pch_pic *s;
+	int type, vcpu, irq, vcpus, val, ret = 0;
+
+	level = data->level;
+	val = data->irq;
+	s = kvm->arch.pch_pic;
+	vcpus = atomic_read(&kvm->online_vcpus);
+
+	type = (val >> KVM_LOONGARCH_IRQ_TYPE_SHIFT) & KVM_LOONGARCH_IRQ_TYPE_MASK;
+	vcpu = (val >> KVM_LOONGARCH_IRQ_VCPU_SHIFT) & KVM_LOONGARCH_IRQ_VCPU_MASK;
+	irq = (val >> KVM_LOONGARCH_IRQ_NUM_SHIFT) & KVM_LOONGARCH_IRQ_NUM_MASK;
+
+	switch (type) {
+	case KVM_LOONGARCH_IRQ_TYPE_IOAPIC:
+		if (irq < KVM_IRQCHIP_NUM_PINS)
+			pch_pic_set_irq(s, irq, level);
+		else if (irq < 256)
+			pch_msi_set_irq(kvm, irq, level);
+		else
+			ret = -EINVAL;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
-- 
2.39.1


