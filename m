Return-Path: <kvm+bounces-26257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A359736C4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D41B28E3DF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E9D1991A3;
	Tue, 10 Sep 2024 12:02:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40EE19149F;
	Tue, 10 Sep 2024 12:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725969761; cv=none; b=DZQCrmVL7z3/6LVumiVzOZmREdDaZ0kzwC4nJwW/AMDrTU1s+OJ+R+tQ3DnKPoytGrgAvIwFjrmReu+E7XRoafFJTSz/YKelmvUqbSPMDU5tUvUIe8AHqkTW6HPRlqrELOCe9v4TjeWW99ea56qwiT+ExkqpjiveBItXVkq0b9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725969761; c=relaxed/simple;
	bh=vceDhtATsqMSGLG4EWA7M3NdtHSKJz5D0Q9r419fOwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eY0vZYb7Cr1+2bbeskryFbji0OWZpL5SzB1C0hHAhbM84Rot37I5/v50N1zGbRbotIi4hAeCqeSyT0LGfDx2ttwMejsGc8srf+7V2G3e5DZB8Bz9N2JQBQG0I/EUoJOSBYmGJwj75ndVVJihK4PoQ8F8zjfjquMxOCVppcMRngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxrupbNeBmqa8DAA--.9225S3;
	Tue, 10 Sep 2024 20:02:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMDx_OVVNeBmE2MDAA--.16225S4;
	Tue, 10 Sep 2024 20:02:32 +0800 (CST)
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
Subject: [PATCH V3 08/11] LoongArch: KVM: Add PCHPIC device support
Date: Tue, 10 Sep 2024 19:44:58 +0800
Message-Id: <20240910114501.4062476-3-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240910114501.4062476-1-lixianglai@loongson.cn>
References: <20240910114501.4062476-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMDx_OVVNeBmE2MDAA--.16225S4
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
index 41d37e0aaabd..a4feb1b9c816 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -21,6 +21,7 @@
 #include <asm/loongarch.h>
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_eiointc.h>
+#include <asm/kvm_pch_pic.h>
 
 /* Loongarch KVM register ids */
 #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
@@ -118,6 +119,7 @@ struct kvm_arch {
 	struct kvm_context __percpu *vmcs;
 	struct loongarch_ipi *ipi;
 	struct loongarch_eiointc *eiointc;
+	struct loongarch_pch_pic *pch_pic;
 };
 
 #define CSR_MAX_NUMS		0x800
diff --git a/arch/loongarch/include/asm/kvm_pch_pic.h b/arch/loongarch/include/asm/kvm_pch_pic.h
new file mode 100644
index 000000000000..c320f66c2004
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
+	uint8_t  route_entry[64]; /* default value 0, route to int0: eiointc */
+	uint8_t  htmsi_vector[64]; /* irq route table for routing to eiointc */
+	uint64_t pch_pic_base;
+};
+
+int kvm_loongarch_register_pch_pic_device(void);
+#endif /* LOONGARCH_PCH_PIC_H */
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index bb50fc799c29..97b2adf08206 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -20,5 +20,6 @@ kvm-y += vcpu.o
 kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/eiointc.o
+kvm-y += intc/pch_pic.o
 
 CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
new file mode 100644
index 000000000000..1888be1c9a8e
--- /dev/null
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include <asm/kvm_eiointc.h>
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
+					KVM_DEV_TYPE_LOONGARCH_IOAPIC);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index bc2d3a1a65b1..824c1d421f43 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -10,6 +10,7 @@
 #include <asm/cpufeature.h>
 #include <asm/kvm_csr.h>
 #include <asm/kvm_eiointc.h>
+#include <asm/kvm_pch_pic.h>
 #include "trace.h"
 
 unsigned long vpid_mask;
@@ -376,6 +377,11 @@ static int kvm_loongarch_env_init(void)
 
 	/* Register loongarch eiointc interrupt controller interface. */
 	ret = kvm_loongarch_register_eiointc_device();
+	if (ret)
+		return ret;
+
+	/* Register loongarch pch pic interrupt controller interface. */
+	ret = kvm_loongarch_register_pch_pic_device();
 	return ret;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5a6986fb16e8..28b9cde237b0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1158,6 +1158,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_RISCV_AIA,
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
+	KVM_DEV_TYPE_LOONGARCH_IOAPIC,
+#define KVM_DEV_TYPE_LOONGARCH_IOAPIC	KVM_DEV_TYPE_LOONGARCH_IOAPIC
 	KVM_DEV_TYPE_LOONGARCH_IPI,
 #define KVM_DEV_TYPE_LOONGARCH_IPI	KVM_DEV_TYPE_LOONGARCH_IPI
 	KVM_DEV_TYPE_LOONGARCH_EXTIOI,
-- 
2.39.1


