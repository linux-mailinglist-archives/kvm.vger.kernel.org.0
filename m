Return-Path: <kvm+bounces-21024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 045F39280B0
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A26131F241EA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767521442EA;
	Fri,  5 Jul 2024 02:56:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3157B74C02;
	Fri,  5 Jul 2024 02:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148187; cv=none; b=PN3sPN53RILWaxm7+NqYVCCXpDNPgR9G2Ozn/HnRrK/G/pA9OR9cg+D6b79fQtClnGCOduiZyb3jPicPc1kUKRJg+F5S/zsORMaSkZPjbOa22bjUZ775xGShM6ZM60njkVIm52aDxdEuoyyGutPaMCHqlE5v/V81483evOo0RrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148187; c=relaxed/simple;
	bh=u2eC/JkX4Qspug7K9jMNz1IXyL8TialaNzGFwlMbGgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g207X5McIKPjuedW67Qbn7Y3sypviKjnuwXAUwFgKdpVYsO0BKj4OzNr13fqjU42a4V8trpuBNDoUwwmX2eqdBLHJgLBKWKnSxeIKRH3MA61suUNPIDJouzLJhFdkGaURPl5bcVRJjrtWUlnfh8IJ32ECpmxDQzsnZ1aMbfBJAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxDOvXYIdmACUBAA--.3493S3;
	Fri, 05 Jul 2024 10:56:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S10;
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
Subject: [PATCH 08/11] LoongArch: KVM: Add PCHPIC device support
Date: Fri,  5 Jul 2024 10:38:51 +0800
Message-Id: <20240705023854.1005258-9-lixianglai@loongson.cn>
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
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S10
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Added device model for PCHPIC interrupt controller,
implemented basic create destroy interface,
and registered device model to kvm device table.

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

 arch/loongarch/include/asm/kvm_host.h    |   2 +
 arch/loongarch/include/asm/kvm_pch_pic.h |  30 +++++++
 arch/loongarch/kvm/Makefile              |   1 +
 arch/loongarch/kvm/intc/pch_pic.c        | 100 +++++++++++++++++++++++
 arch/loongarch/kvm/main.c                |   6 ++
 include/uapi/linux/kvm.h                 |   2 +
 6 files changed, 141 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
 create mode 100644 arch/loongarch/kvm/intc/pch_pic.c

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 5c2adebd16b2..31891f884cee 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -21,6 +21,7 @@
 #include <asm/loongarch.h>
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_extioi.h>
+#include <asm/kvm_pch_pic.h>
 
 /* Loongarch KVM register ids */
 #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
@@ -115,6 +116,7 @@ struct kvm_arch {
 	struct kvm_context __percpu *vmcs;
 	struct loongarch_ipi *ipi;
 	struct loongarch_extioi *extioi;
+	struct loongarch_pch_pic *pch_pic;
 };
 
 #define CSR_MAX_NUMS		0x800
diff --git a/arch/loongarch/include/asm/kvm_pch_pic.h b/arch/loongarch/include/asm/kvm_pch_pic.h
new file mode 100644
index 000000000000..5aef0e4e3863
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_pch_pic.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#ifndef LOONGARCH_PCH_PIC_H
+#define LOONGARCH_PCH_PIC_H
+
+#include <kvm/iodev.h>
+
+struct loongarch_pch_pic {
+	spinlock_t lock;
+	struct kvm *kvm;
+	struct kvm_io_device device;
+	uint64_t mask; /* 1:disable irq, 0:enable irq */
+	uint64_t htmsi_en; /* 1:msi */
+	uint64_t edge; /* 1:edge triggered, 0:level triggered */
+	uint64_t auto_ctrl0; /* only use default value 00b */
+	uint64_t auto_ctrl1; /* only use default value 00b */
+	uint64_t last_intirr; /* edge detection */
+	uint64_t irr; /* interrupt request register */
+	uint64_t isr; /* interrupt service register */
+	uint64_t polarity; /* 0: high level trigger, 1: low level trigger */
+	uint8_t  route_entry[64]; /* default value 0, route to int0: extioi */
+	uint8_t  htmsi_vector[64]; /* irq route table for routing to extioi */
+	uint64_t pch_pic_base;
+};
+
+int kvm_loongarch_register_pch_pic_device(void);
+#endif /* LOONGARCH_PCH_PIC_H */
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index a481952e3855..165ecb4d408f 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -20,5 +20,6 @@ kvm-y += vcpu.o
 kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/extioi.o
+kvm-y += intc/pch_pic.o
 
 CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
new file mode 100644
index 000000000000..4097c00e8294
--- /dev/null
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include <asm/kvm_extioi.h>
+#include <asm/kvm_pch_pic.h>
+#include <asm/kvm_vcpu.h>
+#include <linux/count_zeros.h>
+
+static int kvm_loongarch_pch_pic_write(struct kvm_vcpu *vcpu,
+					struct kvm_io_device *dev,
+					gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static int kvm_loongarch_pch_pic_read(struct kvm_vcpu *vcpu,
+					struct kvm_io_device *dev,
+					gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_loongarch_pch_pic_ops = {
+	.read	= kvm_loongarch_pch_pic_read,
+	.write	= kvm_loongarch_pch_pic_write,
+};
+
+static int kvm_loongarch_pch_pic_get_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static int kvm_loongarch_pch_pic_set_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static void kvm_loongarch_pch_pic_destroy(struct kvm_device *dev)
+{
+	struct kvm *kvm;
+	struct loongarch_pch_pic *s;
+	struct kvm_io_device *device;
+
+	if (!dev)
+		return;
+
+	kvm = dev->kvm;
+	if (!kvm)
+		return;
+
+	s = kvm->arch.pch_pic;
+	if (!s)
+		return;
+
+	device = &s->device;
+	/* unregister pch pic device and free it's memory */
+	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, device);
+	kfree(s);
+}
+
+static int kvm_loongarch_pch_pic_create(struct kvm_device *dev, u32 type)
+{
+	struct loongarch_pch_pic *s;
+	struct kvm *kvm = dev->kvm;
+
+	/* pch pic should not has been created */
+	if (kvm->arch.pch_pic)
+		return -EINVAL;
+
+	s = kzalloc(sizeof(struct loongarch_pch_pic), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	spin_lock_init(&s->lock);
+	s->kvm = kvm;
+
+
+	kvm->arch.pch_pic = s;
+
+	kvm_info("create pch pic device successfully\n");
+	return 0;
+}
+
+static struct kvm_device_ops kvm_loongarch_pch_pic_dev_ops = {
+	.name = "kvm-loongarch-pch-pic",
+	.create = kvm_loongarch_pch_pic_create,
+	.destroy = kvm_loongarch_pch_pic_destroy,
+	.set_attr = kvm_loongarch_pch_pic_set_attr,
+	.get_attr = kvm_loongarch_pch_pic_get_attr,
+};
+
+int kvm_loongarch_register_pch_pic_device(void)
+{
+	return kvm_register_device_ops(&kvm_loongarch_pch_pic_dev_ops,
+					KVM_DEV_TYPE_LA_IOAPIC);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index b5da4341006a..285bd4126e54 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -10,6 +10,7 @@
 #include <asm/cpufeature.h>
 #include <asm/kvm_csr.h>
 #include <asm/kvm_extioi.h>
+#include <asm/kvm_pch_pic.h>
 #include "trace.h"
 
 unsigned long vpid_mask;
@@ -375,6 +376,11 @@ static int kvm_loongarch_env_init(void)
 
 	/* Register loongarch extioi interrupt controller interface. */
 	ret = kvm_loongarch_register_extioi_device();
+	if (ret)
+		return ret;
+
+	/* Register loongarch pch pic interrupt controller interface. */
+	ret = kvm_loongarch_register_pch_pic_device();
 
 	return ret;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 607895ea450f..35560522a252 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1142,6 +1142,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_RISCV_AIA,
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
+	KVM_DEV_TYPE_LA_IOAPIC,
+#define KVM_DEV_TYPE_LA_IOAPIC		KVM_DEV_TYPE_LA_IOAPIC
 	KVM_DEV_TYPE_LA_IPI,
 #define KVM_DEV_TYPE_LA_IPI		KVM_DEV_TYPE_LA_IPI
 	KVM_DEV_TYPE_LA_EXTIOI,
-- 
2.39.1


