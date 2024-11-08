Return-Path: <kvm+bounces-31221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3513B9C1505
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 04:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 596B01C242F2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB0C1CF5F4;
	Fri,  8 Nov 2024 03:57:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1580D1CF7D6;
	Fri,  8 Nov 2024 03:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731038251; cv=none; b=ClISKgmsrTEL2LlZMEDtZQuSTKWR9KhV6Y3MbsRSTc15YMjGGMImccW7yFmSXqUj4nXBAYSXRXPQ+IhkygPwq6jPdAVY3f/qI01c4yPqPNK1JuzSc/k0zIcpKZ/x9znbrplVWVHxDkMHnBqbXVOLQKHWqUDp6T2l/9YYJ0mbGFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731038251; c=relaxed/simple;
	bh=UqiTbETEd8jSp0gEVlsF2xAXR7rCYXT3xzLu5CiovHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pMwu6ekBD1F49NBai+txWxG0JYGEnVkfYl29/I/4FZNORvt0T2FQwIZHP5pNtpk6L0ueJT6juVDJSXoPYJzcDnqjF6jYeYAXF536AlOdLu6NiWrBlQnyHML+X7bLbyJO94UoywlJZv66kFvZJbOHRqS7qLxTnP86Wm4A86uJMYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxIK8mjC1nY9o4AA--.23205S3;
	Fri, 08 Nov 2024 11:57:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMBxbcIajC1n0jVMAA--.31622S6;
	Fri, 08 Nov 2024 11:57:24 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH V4 11/11] LoongArch: KVM: Add irqfd support
Date: Fri,  8 Nov 2024 11:38:52 +0800
Message-Id: <20241108033852.2727684-5-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20241108033852.2727684-1-lixianglai@loongson.cn>
References: <20241108033437.2727574-1-lixianglai@loongson.cn>
 <20241108033852.2727684-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxbcIajC1n0jVMAA--.31622S6
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Enable the KVM_IRQ_ROUTING/KVM_IRQCHIP/KVM_MSI configuration items,
add the KVM_CAP_IRQCHIP capability, and implement the query interface
of the in-kernel irqchip.

Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_host.h |  2 +
 arch/loongarch/kvm/Kconfig            |  5 +-
 arch/loongarch/kvm/Makefile           |  1 +
 arch/loongarch/kvm/intc/pch_pic.c     | 27 ++++++++
 arch/loongarch/kvm/irqfd.c            | 97 +++++++++++++++++++++++++++
 arch/loongarch/kvm/vm.c               |  8 +++
 6 files changed, 139 insertions(+), 1 deletion(-)
 create mode 100644 arch/loongarch/kvm/irqfd.c

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index d1f75b854107..7b8367c39da8 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -23,6 +23,8 @@
 #include <asm/kvm_pch_pic.h>
 #include <asm/loongarch.h>
 
+#define __KVM_HAVE_ARCH_INTC_INITIALIZED
+
 /* Loongarch KVM register ids */
 #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
 #define KVM_GET_IOC_CPUCFG_IDX(id)	((id & KVM_CPUCFG_IDX_MASK) >> LOONGARCH_REG_SHIFT)
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index 248744b4d086..97a811077ac3 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -21,13 +21,16 @@ config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on AS_HAS_LVZ_EXTENSION
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select HAVE_KVM_IRQ_ROUTING
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_MSI
+	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMIO
-	select HAVE_KVM_READONLY_MEM
 	select KVM_XFER_TO_GUEST_WORK
 	select SCHED_INFO
 	help
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index 97b2adf08206..3a01292f71cc 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -21,5 +21,6 @@ kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/eiointc.o
 kvm-y += intc/pch_pic.o
+kvm-y += irqfd.o
 
 CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index e7b5c23a7d56..8dca23fc589a 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -447,8 +447,31 @@ static int kvm_pch_pic_set_attr(struct kvm_device *dev,
 	return ret;
 }
 
+static int kvm_setup_default_irq_routing(struct kvm *kvm)
+{
+	int i, ret;
+	u32 nr = KVM_IRQCHIP_NUM_PINS;
+	struct kvm_irq_routing_entry *entries;
+
+	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	for (i = 0; i < nr; i++) {
+		entries[i].gsi = i;
+		entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
+		entries[i].u.irqchip.irqchip = 0;
+		entries[i].u.irqchip.pin = i;
+	}
+	ret = kvm_set_irq_routing(kvm, entries, nr, 0);
+	kfree(entries);
+
+	return ret;
+}
+
 static int kvm_pch_pic_create(struct kvm_device *dev, u32 type)
 {
+	int ret;
 	struct loongarch_pch_pic *s;
 	struct kvm *kvm = dev->kvm;
 
@@ -456,6 +479,10 @@ static int kvm_pch_pic_create(struct kvm_device *dev, u32 type)
 	if (kvm->arch.pch_pic)
 		return -EINVAL;
 
+	ret = kvm_setup_default_irq_routing(kvm);
+	if (ret)
+		return -ENOMEM;
+
 	s = kzalloc(sizeof(struct loongarch_pch_pic), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
new file mode 100644
index 000000000000..01efeda22107
--- /dev/null
+++ b/arch/loongarch/kvm/irqfd.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <trace/events/kvm.h>
+#include <asm/kvm_pch_pic.h>
+
+static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id, int level, bool line_status)
+{
+	/* PCH-PIC pin (0 ~ 64) <---> GSI (0 ~ 64) */
+	pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level);
+
+	return 0;
+}
+
+/*
+ * kvm_set_msi: inject the MSI corresponding to the
+ * MSI routing entry
+ *
+ * This is the entry point for irqfd MSI injection
+ * and userspace MSI injection.
+ */
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id, int level, bool line_status)
+{
+	if (!level)
+		return -1;
+
+	pch_msi_set_irq(kvm, e->msi.data, level);
+
+	return 0;
+}
+
+/*
+ * kvm_set_routing_entry: populate a kvm routing entry
+ * from a user routing entry
+ *
+ * @kvm: the VM this entry is applied to
+ * @e: kvm kernel routing entry handle
+ * @ue: user api routing entry handle
+ * return 0 on success, -EINVAL on errors.
+ */
+int kvm_set_routing_entry(struct kvm *kvm,
+			struct kvm_kernel_irq_routing_entry *e,
+			const struct kvm_irq_routing_entry *ue)
+{
+	int r = -EINVAL;
+
+	switch (ue->type) {
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		e->set = kvm_set_pic_irq;
+		e->irqchip.irqchip = ue->u.irqchip.irqchip;
+		e->irqchip.pin = ue->u.irqchip.pin;
+
+		if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS)
+			goto out;
+		break;
+	case KVM_IRQ_ROUTING_MSI:
+		e->set = kvm_set_msi;
+		e->msi.address_lo = ue->u.msi.address_lo;
+		e->msi.address_hi = ue->u.msi.address_hi;
+		e->msi.data = ue->u.msi.data;
+		break;
+	default:
+		goto out;
+	}
+	r = 0;
+out:
+	return r;
+}
+
+int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id, int level, bool line_status)
+{
+	if (e->type == KVM_IRQ_ROUTING_IRQCHIP) {
+		kvm_set_pic_irq(e, kvm, irq_source_id, level, line_status);
+		return 0;
+	}
+
+	if (e->type == KVM_IRQ_ROUTING_MSI) {
+		pch_msi_set_irq(kvm, e->msi.data, level);
+		return 0;
+	}
+
+	return -EWOULDBLOCK;
+}
+
+bool kvm_arch_intc_initialized(struct kvm *kvm)
+{
+	if (kvm->arch.eiointc && kvm->arch.ipi && kvm->arch.pch_pic)
+		return true;
+
+	return false;
+}
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index d93d098246ed..e0968f132a2c 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -78,6 +78,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 
 	switch (ext) {
+	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_READONLY_MEM:
@@ -163,6 +164,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	struct kvm_device_attr attr;
 
 	switch (ioctl) {
+	case KVM_CREATE_IRQCHIP:
+		return 0;
 	case KVM_HAS_DEVICE_ATTR:
 		if (copy_from_user(&attr, argp, sizeof(attr)))
 			return -EFAULT;
@@ -184,3 +187,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 					line_status);
 	return 0;
 }
+
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
+{
+	return (bool)((!!kvm->arch.eiointc) && (!!kvm->arch.pch_pic));
+}
-- 
2.39.1


