Return-Path: <kvm+bounces-24882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6BB395C9C3
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 11:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC1F31C2436C
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 09:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476C3187866;
	Fri, 23 Aug 2024 09:54:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DD5187563;
	Fri, 23 Aug 2024 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724406843; cv=none; b=eRrHwX3w59qDCu3lkRyGk8rCl60MUPVqpeafCACHQHIBMcxIElMB/wZ5z2+deaBHg5DfPdVdxoDAMdN1C8IBcHXEqDr7TVttEtU8FREgv8ARFc48Oh8XMYjxu4K9o/pHPhSNopLJQohom78eFQXl+zCPVnnQcktVbpFqF4JTyBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724406843; c=relaxed/simple;
	bh=W3IwCFJomc4rX6LppRccK6pOQUAes8sk6HvrNZZ7StM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ofGNEIAcumFxE6GjejeS/duyqYxg/9rPV/PwzQOZDRoGL7GNdTVx94Suzg/VufikeUUrN89kFvhuJfnJ0hvAt9WoDqhwTnXpT5ta60Ax7VDiDtK0EmnIsnXdFM7eixrmbxDs6aDmhx88cWvJMWZ7YRquNBaxEfZI/5ZR8SuTNWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Cx+ek3XMhmDksdAA--.61750S3;
	Fri, 23 Aug 2024 17:53:59 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMAx4+E1XMhmxSwfAA--.5930S2;
	Fri, 23 Aug 2024 17:53:57 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [[PATCH V2 07/10] LoongArch: KVM: Add PCHPIC device support
Date: Fri, 23 Aug 2024 17:36:32 +0800
Message-Id: <20240823093632.204537-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAx4+E1XMhmxSwfAA--.5930S2
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
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_host.h    |  2 +
 arch/loongarch/include/asm/kvm_pch_pic.h | 30 +++++++++
 arch/loongarch/kvm/Makefile              |  1 +
 arch/loongarch/kvm/intc/pch_pic.c        | 86 ++++++++++++++++++++++++
 arch/loongarch/kvm/main.c                |  6 ++
 include/uapi/linux/kvm.h                 |  2 +
 6 files changed, 127 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
 create mode 100644 arch/loongarch/kvm/intc/pch_pic.c

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index a06e559c16cd..99ff8b37f252 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -21,6 +21,7 @@
 #include <asm/loongarch.h>
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_extioi.h>
+#include <asm/kvm_pch_pic.h>
 
 /* Loongarch KVM register ids */
 #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
@@ -118,6 +119,7 @@ struct kvm_arch {
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
index 000000000000..075d354add0b
--- /dev/null
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -0,0 +1,86 @@
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
+static int kvm_pch_pic_write(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_pch_pic_ops = {
+	.read	= kvm_pch_pic_read,
+	.write	= kvm_pch_pic_write,
+};
+
+static int kvm_pch_pic_get_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static int kvm_pch_pic_set_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static void kvm_pch_pic_destroy(struct kvm_device *dev)
+{
+	struct kvm *kvm;
+	struct loongarch_pch_pic *s;
+
+	if (!dev || !dev->kvm || !dev->kvm->arch.pch_pic)
+		return;
+	kvm = dev->kvm;
+	s = kvm->arch.pch_pic;
+	/* unregister pch pic device and free it's memory */
+	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &s->device);
+	kfree(s);
+}
+
+static int kvm_pch_pic_create(struct kvm_device *dev, u32 type)
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
+	spin_lock_init(&s->lock);
+	s->kvm = kvm;
+	kvm->arch.pch_pic = s;
+	return 0;
+}
+
+static struct kvm_device_ops kvm_pch_pic_dev_ops = {
+	.name = "kvm-loongarch-pch-pic",
+	.create = kvm_pch_pic_create,
+	.destroy = kvm_pch_pic_destroy,
+	.set_attr = kvm_pch_pic_set_attr,
+	.get_attr = kvm_pch_pic_get_attr,
+};
+
+int kvm_loongarch_register_pch_pic_device(void)
+{
+	return kvm_register_device_ops(&kvm_pch_pic_dev_ops,
+					KVM_DEV_TYPE_LA_IOAPIC);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 0fae4f648554..62488773ea41 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -10,6 +10,7 @@
 #include <asm/cpufeature.h>
 #include <asm/kvm_csr.h>
 #include <asm/kvm_extioi.h>
+#include <asm/kvm_pch_pic.h>
 #include "trace.h"
 
 unsigned long vpid_mask;
@@ -376,6 +377,11 @@ static int kvm_loongarch_env_init(void)
 
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
index cdb39aa01e95..b3edefb9325c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1158,6 +1158,8 @@ enum kvm_device_type {
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


