Return-Path: <kvm+bounces-63691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C70C6D9F3
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 10:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E2CEC4F71D5
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 09:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B024F334370;
	Wed, 19 Nov 2025 09:04:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CFB333751;
	Wed, 19 Nov 2025 09:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763543050; cv=none; b=aV60fy8pUHiDCVuV4uQDuIDlqK79lm7h0PGrEP9AahsK6G5FqRjtFdX8wKGfgheWNYnieA3FXmpunE4PG4qU2L2EVTaHe68DPCLfM0RjTj6WlEaxmBuuFZNvX6wHF72W7ZVmbSkdg8ndg03TVwnjwIGv4f4KxhOPDEgTP0vI7Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763543050; c=relaxed/simple;
	bh=ZyG95oS4409+LtBm4sRQ4JZp4vNNXcKMPozPiHERYc4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S+FX1zO0VipNEUFdCS7Xhc9FXTOa6BiYKxM39UukjE+0rxmmr4JjvbxygJkhyVb+5SncZsh4i1ukiU93uWOU6ln6YC1XzGXtpmMY741ZO3T3JeZNngLo2M7hzLCpUkVrKH9vDggZVem1rkD08N/3Of8F6KnSa98i7l+S3mqt4bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Cx5tD9hx1pOXglAA--.15283S3;
	Wed, 19 Nov 2025 17:03:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCxXMH8hx1pFUY4AQ--.37329S2;
	Wed, 19 Nov 2025 17:03:56 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add AVEC support irqchip in kernel
Date: Wed, 19 Nov 2025 16:39:46 +0800
Message-Id: <20251119083946.1864543-1-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxXMH8hx1pFUY4AQ--.37329S2
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add a dintc device to set dintc msg base and msg size.
implement deliver the msi to vcpu and inject irq to dest vcpu.
add some macros for AVEC.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/irq.h       |   7 ++
 arch/loongarch/include/asm/kvm_dintc.h |  22 +++++
 arch/loongarch/include/asm/kvm_host.h  |   8 ++
 arch/loongarch/include/uapi/asm/kvm.h  |   4 +
 arch/loongarch/kvm/Makefile            |   1 +
 arch/loongarch/kvm/intc/dintc.c        | 115 +++++++++++++++++++++++++
 arch/loongarch/kvm/interrupt.c         |   1 +
 arch/loongarch/kvm/irqfd.c             |  35 +++++++-
 arch/loongarch/kvm/main.c              |   5 ++
 arch/loongarch/kvm/vcpu.c              |  51 +++++++++++
 drivers/irqchip/irq-loongarch-avec.c   |   5 +-
 include/uapi/linux/kvm.h               |   2 +
 12 files changed, 252 insertions(+), 4 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_dintc.h
 create mode 100644 arch/loongarch/kvm/intc/dintc.c

diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/asm/irq.h
index 12bd15578c33..5ab8b91e9ae8 100644
--- a/arch/loongarch/include/asm/irq.h
+++ b/arch/loongarch/include/asm/irq.h
@@ -50,6 +50,13 @@ void spurious_interrupt(void);
 #define NR_LEGACY_VECTORS	16
 #define IRQ_MATRIX_BITS		NR_VECTORS
 
+#define AVEC_VIRQ_SHIFT		4
+#define AVEC_VIRQ_BIT		8
+#define AVEC_VIRQ_MASK		GENMASK(AVEC_VIRQ_BIT - 1, 0)
+#define AVEC_CPU_SHIFT		12
+#define AVEC_CPU_BIT		16
+#define AVEC_CPU_MASK		GENMASK(AVEC_CPU_BIT - 1, 0)
+
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 void arch_trigger_cpumask_backtrace(const struct cpumask *mask, int exclude_cpu);
 
diff --git a/arch/loongarch/include/asm/kvm_dintc.h b/arch/loongarch/include/asm/kvm_dintc.h
new file mode 100644
index 000000000000..0ec301fbb638
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_dintc.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_KVM_DINTC_H
+#define __ASM_KVM_DINTC_H
+
+
+struct loongarch_dintc  {
+	spinlock_t lock;
+	struct kvm *kvm;
+	uint64_t msg_addr_base;
+	uint64_t msg_addr_size;
+};
+
+struct dintc_state {
+	atomic64_t vector_map[4];
+};
+
+int kvm_loongarch_register_dintc_device(void);
+#endif
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 0cecbd038bb3..3806a71658c1 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -22,6 +22,7 @@
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_eiointc.h>
 #include <asm/kvm_pch_pic.h>
+#include <asm/kvm_dintc.h>
 #include <asm/loongarch.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -132,6 +133,7 @@ struct kvm_arch {
 	struct loongarch_ipi *ipi;
 	struct loongarch_eiointc *eiointc;
 	struct loongarch_pch_pic *pch_pic;
+	struct loongarch_dintc *dintc;
 };
 
 #define CSR_MAX_NUMS		0x800
@@ -242,6 +244,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mp_state mp_state;
 	/* ipi state */
 	struct ipi_state ipi_state;
+	struct dintc_state dintc_state;
 	/* cpucfg */
 	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
 
@@ -253,6 +256,11 @@ struct kvm_vcpu_arch {
 	} st;
 };
 
+void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu);
+int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
+				      struct kvm_vcpu *vcpu,
+				      u32 vector, int level);
+
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
 {
 	return csr->csrs[reg];
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index de6c3f18e40a..07da84f7002c 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
 #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	        0x40000006
 #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	        0
 
+#define KVM_DEV_LOONGARCH_DINTC_CTRL			0x40000007
+#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE		0x0
+#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE		0x1
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index cb41d9265662..fe984bf1cbdb 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -19,6 +19,7 @@ kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/eiointc.o
 kvm-y += intc/pch_pic.o
+kvm-y += intc/dintc.o
 kvm-y += irqfd.o
 
 CFLAGS_exit.o	+= $(call cc-disable-warning, override-init)
diff --git a/arch/loongarch/kvm/intc/dintc.c b/arch/loongarch/kvm/intc/dintc.c
new file mode 100644
index 000000000000..376c6e20ec04
--- /dev/null
+++ b/arch/loongarch/kvm/intc/dintc.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_dintc.h>
+#include <asm/kvm_vcpu.h>
+
+static int kvm_dintc_ctrl_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 bool is_write)
+{
+	int addr = attr->attr;
+	void __user *data;
+	struct loongarch_dintc *s = dev->kvm->arch.dintc;
+
+	data = (void __user *)attr->addr;
+	switch (addr) {
+	case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE:
+		if (is_write) {
+			if (copy_from_user(&(s->msg_addr_base), data, sizeof(s->msg_addr_base)))
+				return -EFAULT;
+		}
+		break;
+	case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE:
+		if (is_write) {
+			if (copy_from_user(&(s->msg_addr_size), data, sizeof(s->msg_addr_size)))
+				return -EFAULT;
+		}
+		break;
+	default:
+		kvm_err("%s: unknown dintc register, addr = %d\n", __func__, addr);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int kvm_dintc_get_attr(struct kvm_device *dev,
+			struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_LOONGARCH_DINTC_CTRL:
+		return kvm_dintc_ctrl_access(dev, attr, false);
+	default:
+		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
+		return -EINVAL;
+	}
+}
+
+static int kvm_dintc_set_attr(struct kvm_device *dev,
+			      struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_LOONGARCH_DINTC_CTRL:
+		return kvm_dintc_ctrl_access(dev, attr, true);
+	default:
+		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
+		return -EINVAL;
+	}
+}
+
+static int kvm_dintc_create(struct kvm_device *dev, u32 type)
+{
+	struct kvm *kvm;
+	struct loongarch_dintc *s;
+
+	if (!dev) {
+		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
+		return -EINVAL;
+	}
+
+	kvm = dev->kvm;
+	if (kvm->arch.dintc) {
+		kvm_err("%s: LoongArch DINTC has already been created!\n", __func__);
+		return -EINVAL;
+	}
+
+	s = kzalloc(sizeof(struct loongarch_dintc), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	spin_lock_init(&s->lock);
+	s->kvm = kvm;
+
+	kvm->arch.dintc = s;
+	return 0;
+}
+
+static void kvm_dintc_destroy(struct kvm_device *dev)
+{
+	struct kvm *kvm;
+	struct loongarch_dintc *dintc;
+
+	if (!dev || !dev->kvm || !dev->kvm->arch.dintc)
+		return;
+
+	kvm = dev->kvm;
+	dintc = kvm->arch.dintc;
+	kfree(dintc);
+}
+
+static struct kvm_device_ops kvm_dintc_dev_ops = {
+	.name = "kvm-loongarch-dintc",
+	.create = kvm_dintc_create,
+	.destroy = kvm_dintc_destroy,
+	.set_attr = kvm_dintc_set_attr,
+	.get_attr = kvm_dintc_get_attr,
+};
+
+int kvm_loongarch_register_dintc_device(void)
+{
+	return kvm_register_device_ops(&kvm_dintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DINTC);
+}
diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
index a6d42d399a59..c74e7af3e772 100644
--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 		irq = priority_to_irq[priority];
 
 	if (cpu_has_msgint && (priority == INT_AVEC)) {
+		loongarch_dintc_inject_irq(vcpu);
 		set_gcsr_estat(irq);
 		return 1;
 	}
diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
index 9a39627aecf0..a6f9342eaba1 100644
--- a/arch/loongarch/kvm/irqfd.c
+++ b/arch/loongarch/kvm/irqfd.c
@@ -2,7 +2,6 @@
 /*
  * Copyright (C) 2024 Loongson Technology Corporation Limited
  */
-
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
 #include <asm/kvm_pch_pic.h>
@@ -16,6 +15,27 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 	return 0;
 }
 
+static int kvm_dintc_set_msi_irq(struct kvm *kvm, u32 addr, int data, int level)
+{
+	unsigned int virq, dest, cpu_bit;
+	struct kvm_vcpu *vcpu;
+
+	cpu_bit = find_first_bit((unsigned long *)&(kvm->arch.dintc->msg_addr_base), 64)
+				- AVEC_CPU_SHIFT;
+	cpu_bit = min(cpu_bit, AVEC_CPU_BIT);
+
+	virq = (addr >> AVEC_VIRQ_SHIFT)&AVEC_VIRQ_MASK;
+	dest = (addr >> AVEC_CPU_SHIFT)&GENMASK(cpu_bit - 1, 0);
+	if (dest > KVM_MAX_VCPUS)
+		return -EINVAL;
+	vcpu = kvm_get_vcpu_by_id(kvm, dest);
+
+	if (!vcpu)
+		return -EINVAL;
+	return kvm_loongarch_deliver_msi_to_vcpu(kvm, vcpu, virq, level);
+}
+
+
 /*
  * kvm_set_msi: inject the MSI corresponding to the
  * MSI routing entry
@@ -26,10 +46,21 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
 {
+	u64 msg_addr;
+
 	if (!level)
 		return -1;
 
-	pch_msi_set_irq(kvm, e->msi.data, level);
+	msg_addr = (((u64)e->msi.address_hi) << 32) | e->msi.address_lo;
+	if (cpu_has_msgint &&
+		msg_addr > kvm->arch.dintc->msg_addr_base &&
+		msg_addr <= (kvm->arch.dintc->msg_addr_base  + kvm->arch.dintc->msg_addr_size)) {
+		return kvm_dintc_set_msi_irq(kvm, e->msi.address_lo, e->msi.data, level);
+	} else if (e->msi.address_lo  == 0) {
+		pch_msi_set_irq(kvm, e->msi.data, level);
+	} else {
+		return 0;
+	}
 
 	return 0;
 }
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 80ea63d465b8..d18d9f4d485c 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -408,6 +408,11 @@ static int kvm_loongarch_env_init(void)
 
 	/* Register LoongArch PCH-PIC interrupt controller interface. */
 	ret = kvm_loongarch_register_pch_pic_device();
+	if (ret)
+		return ret;
+
+	/* Register LoongArch DINTC interrupt contrroller interface */
+	ret = kvm_loongarch_register_dintc_device();
 
 	return ret;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 1e7590fc1b47..4f13161be107 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -13,6 +13,57 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu)
+{
+	struct dintc_state *ds = &vcpu->arch.dintc_state;
+	unsigned int i;
+	unsigned long temp[4], old;
+
+	if (!ds)
+		return;
+
+	for (i = 0; i < 4; i++) {
+		old = atomic64_read(&(ds->vector_map[i]));
+		if (old)
+			temp[i] = atomic64_xchg(&(ds->vector_map[i]), 0);
+	}
+
+	if (temp[0]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR0);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR0, temp[0]|old);
+	}
+	if (temp[1]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
+	}
+	if (temp[2]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
+	}
+	if (temp[3]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR3);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR3, temp[3]|old);
+	}
+}
+int  kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
+					struct kvm_vcpu *vcpu,
+					u32 vector, int level)
+{
+	struct kvm_interrupt vcpu_irq;
+	struct dintc_state *ds;
+
+	if (!vcpu || vector >= 256)
+		return -EINVAL;
+	ds = &vcpu->arch.dintc_state;
+	if (!ds)
+		return -ENODEV;
+	set_bit(vector, (unsigned long *)&ds->vector_map);
+	vcpu_irq.irq = level ? INT_AVEC : -INT_AVEC;
+	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
+	kvm_vcpu_kick(vcpu);
+	return 0;
+}
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, int_exits),
diff --git a/drivers/irqchip/irq-loongarch-avec.c b/drivers/irqchip/irq-loongarch-avec.c
index bf52dc8345f5..2f0f704cfebb 100644
--- a/drivers/irqchip/irq-loongarch-avec.c
+++ b/drivers/irqchip/irq-loongarch-avec.c
@@ -209,8 +209,9 @@ static void avecintc_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	struct avecintc_data *adata = irq_data_get_irq_chip_data(d);
 
 	msg->address_hi = 0x0;
-	msg->address_lo = (loongarch_avec.msi_base_addr | (adata->vec & 0xff) << 4)
-			  | ((cpu_logical_map(adata->cpu & 0xffff)) << 12);
+	msg->address_lo = (loongarch_avec.msi_base_addr |
+			  (adata->vec & AVEC_VIRQ_MASK) << AVEC_VIRQ_SHIFT) |
+			  ((cpu_logical_map(adata->cpu & AVEC_CPU_MASK)) << AVEC_CPU_SHIFT);
 	msg->data = 0x0;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..738dd8d626a4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1198,6 +1198,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_LOONGARCH_DINTC,
+#define KVM_DEV_TYPE_LOONGARCH_DINTC	KVM_DEV_TYPE_LOONGARCH_DINTC
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.39.3


