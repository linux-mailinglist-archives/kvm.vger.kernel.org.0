Return-Path: <kvm+bounces-24880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5958C95C9B5
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 11:53:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1892028879D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 09:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA19F187342;
	Fri, 23 Aug 2024 09:51:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DCC185B69;
	Fri, 23 Aug 2024 09:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724406703; cv=none; b=S8iJc0WSGh8C79E6g7BtdwttfwAs2dr2F27MIfvZUXipb+za3q5v7y9W40/Y0LVw2Ko14HEGvCc25S6JfSvuJJKKxdLLJRhndYL+8zBuRoeHEGteCC5+o7zoafqqMuWfbLsp6y/BwZPyvyr36WebBnVsQsKxYe7+yH8jd3C3D8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724406703; c=relaxed/simple;
	bh=fVOcDv9lR6Rld+W4kBGuXX4gQmL7Lwh7WQPMg42QENE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sOIH0SGRFOtvWUeoLMYqsS/5+bq3F4b2dVzjw5vavQIjatGyU1yB2kGjM54Fl6j8QOEAGKnGHnwlbcmWNatk5sEH2uOJIKJrI2gktRhXovsLyCVsbloBuWYW9KERyWn7hee+s2yvkSuCaM6PORBllukEV7I9TXCsv8y+DMN38KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Dxi+qqW8hmIkodAA--.62615S3;
	Fri, 23 Aug 2024 17:51:38 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMCxC2ekW8hm2SsfAA--.39816S7;
	Fri, 23 Aug 2024 17:51:37 +0800 (CST)
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
Subject: [[PATCH V2 05/10] LoongArch: KVM: Add EXTIOI device support
Date: Fri, 23 Aug 2024 17:33:59 +0800
Message-Id: <20240823093404.204450-6-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240823093404.204450-1-lixianglai@loongson.cn>
References: <20240823093404.204450-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxC2ekW8hm2SsfAA--.39816S7
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Added device model for EXTIOI interrupt controller,
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

 arch/loongarch/include/asm/kvm_extioi.h |  93 +++++++++++++++++
 arch/loongarch/include/asm/kvm_host.h   |   2 +
 arch/loongarch/kvm/Makefile             |   1 +
 arch/loongarch/kvm/intc/extioi.c        | 130 ++++++++++++++++++++++++
 arch/loongarch/kvm/main.c               |   6 ++
 include/uapi/linux/kvm.h                |   2 +
 6 files changed, 234 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_extioi.h
 create mode 100644 arch/loongarch/kvm/intc/extioi.c

diff --git a/arch/loongarch/include/asm/kvm_extioi.h b/arch/loongarch/include/asm/kvm_extioi.h
new file mode 100644
index 000000000000..d624b4aab73a
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_extioi.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#ifndef LOONGARCH_EXTIOI_H
+#define LOONGARCH_EXTIOI_H
+
+#include <kvm/iodev.h>
+
+#define EXTIOI_IRQS			256
+#define EXTIOI_ROUTE_MAX_VCPUS		256
+#define EXTIOI_IRQS_U8_NUMS		(EXTIOI_IRQS / 8)
+#define EXTIOI_IRQS_U16_NUMS		(EXTIOI_IRQS_U8_NUMS / 2)
+#define EXTIOI_IRQS_U32_NUMS		(EXTIOI_IRQS_U8_NUMS / 4)
+#define EXTIOI_IRQS_U64_NUMS		(EXTIOI_IRQS_U8_NUMS / 8)
+/* map to ipnum per 32 irqs */
+#define EXTIOI_IRQS_NODETYPE_COUNT	16
+
+#define EXTIOI_BASE			0x1400
+#define EXTIOI_SIZE			0x900
+
+#define EXTIOI_VIRT_BASE		(0x40000000)
+#define EXTIOI_VIRT_SIZE		(0x1000)
+
+#define LS3A_IP_NUM			8
+
+struct loongarch_extioi {
+	spinlock_t lock;
+	struct kvm *kvm;
+	struct kvm_io_device device;
+	struct kvm_io_device device_extern;
+	uint32_t num_cpu;
+	uint32_t features;
+	uint32_t status;
+
+	/* hardware state */
+	union nodetype {
+		u64 reg_u64[EXTIOI_IRQS_NODETYPE_COUNT / 4];
+		u32 reg_u32[EXTIOI_IRQS_NODETYPE_COUNT / 2];
+		u16 reg_u16[EXTIOI_IRQS_NODETYPE_COUNT];
+		u8 reg_u8[EXTIOI_IRQS_NODETYPE_COUNT * 2];
+	} nodetype;
+
+	/* one bit shows the state of one irq */
+	union bounce {
+		u64 reg_u64[EXTIOI_IRQS_U64_NUMS];
+		u32 reg_u32[EXTIOI_IRQS_U32_NUMS];
+		u16 reg_u16[EXTIOI_IRQS_U16_NUMS];
+		u8 reg_u8[EXTIOI_IRQS_U8_NUMS];
+	} bounce;
+
+	union isr {
+		u64 reg_u64[EXTIOI_IRQS_U64_NUMS];
+		u32 reg_u32[EXTIOI_IRQS_U32_NUMS];
+		u16 reg_u16[EXTIOI_IRQS_U16_NUMS];
+		u8 reg_u8[EXTIOI_IRQS_U8_NUMS];
+	} isr;
+	union coreisr {
+		u64 reg_u64[EXTIOI_ROUTE_MAX_VCPUS][EXTIOI_IRQS_U64_NUMS];
+		u32 reg_u32[EXTIOI_ROUTE_MAX_VCPUS][EXTIOI_IRQS_U32_NUMS];
+		u16 reg_u16[EXTIOI_ROUTE_MAX_VCPUS][EXTIOI_IRQS_U16_NUMS];
+		u8 reg_u8[EXTIOI_ROUTE_MAX_VCPUS][EXTIOI_IRQS_U8_NUMS];
+	} coreisr;
+	union enable {
+		u64 reg_u64[EXTIOI_IRQS_U64_NUMS];
+		u32 reg_u32[EXTIOI_IRQS_U32_NUMS];
+		u16 reg_u16[EXTIOI_IRQS_U16_NUMS];
+		u8 reg_u8[EXTIOI_IRQS_U8_NUMS];
+	} enable;
+
+	/* use one byte to config ipmap for 32 irqs at once */
+	union ipmap {
+		u64 reg_u64;
+		u32 reg_u32[EXTIOI_IRQS_U32_NUMS / 4];
+		u16 reg_u16[EXTIOI_IRQS_U16_NUMS / 4];
+		u8 reg_u8[EXTIOI_IRQS_U8_NUMS / 4];
+	} ipmap;
+	/* use one byte to config coremap for one irq */
+	union coremap {
+		u64 reg_u64[EXTIOI_IRQS / 8];
+		u32 reg_u32[EXTIOI_IRQS / 4];
+		u16 reg_u16[EXTIOI_IRQS / 2];
+		u8 reg_u8[EXTIOI_IRQS];
+	} coremap;
+
+	DECLARE_BITMAP(sw_coreisr[EXTIOI_ROUTE_MAX_VCPUS][LS3A_IP_NUM], EXTIOI_IRQS);
+	uint8_t  sw_coremap[EXTIOI_IRQS];
+};
+
+void extioi_set_irq(struct loongarch_extioi *s, int irq, int level);
+int kvm_loongarch_register_extioi_device(void);
+#endif /* LOONGARCH_EXTIOI_H */
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 7c89e26c23c3..fa2b2617e54d 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -20,6 +20,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/loongarch.h>
 #include <asm/kvm_ipi.h>
+#include <asm/kvm_extioi.h>
 
 /* Loongarch KVM register ids */
 #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
@@ -114,6 +115,7 @@ struct kvm_arch {
 	s64 time_offset;
 	struct kvm_context __percpu *vmcs;
 	struct loongarch_ipi *ipi;
+	struct loongarch_extioi *extioi;
 };
 
 #define CSR_MAX_NUMS		0x800
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index 36c3009fe89c..a481952e3855 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -19,5 +19,6 @@ kvm-y += tlb.o
 kvm-y += vcpu.o
 kvm-y += vm.o
 kvm-y += intc/ipi.o
+kvm-y += intc/extioi.o
 
 CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
diff --git a/arch/loongarch/kvm/intc/extioi.c b/arch/loongarch/kvm/intc/extioi.c
new file mode 100644
index 000000000000..b8c796c41a00
--- /dev/null
+++ b/arch/loongarch/kvm/intc/extioi.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include <asm/kvm_extioi.h>
+#include <asm/kvm_vcpu.h>
+#include <linux/count_zeros.h>
+
+static int kvm_extioi_write(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static int kvm_extioi_read(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_extioi_ops = {
+	.read	= kvm_extioi_read,
+	.write	= kvm_extioi_write,
+};
+
+static int kvm_extioi_virt_read(struct kvm_vcpu *vcpu,
+				struct kvm_io_device *dev,
+				gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static int kvm_extioi_virt_write(struct kvm_vcpu *vcpu,
+				struct kvm_io_device *dev,
+				gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_extioi_virt_ops = {
+	.read	= kvm_extioi_virt_read,
+	.write	= kvm_extioi_virt_write,
+};
+
+static int kvm_extioi_get_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static int kvm_extioi_set_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static void kvm_extioi_destroy(struct kvm_device *dev)
+{
+	struct kvm *kvm;
+	struct loongarch_extioi *extioi;
+
+	if (!dev || !dev->kvm || !dev->kvm->arch.extioi)
+		return;
+	kvm = dev->kvm;
+	extioi = kvm->arch.extioi;
+	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &extioi->device);
+	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &extioi->device_extern);
+	kfree(extioi);
+}
+
+static int kvm_extioi_create(struct kvm_device *dev, u32 type)
+{
+	int ret;
+	struct loongarch_extioi *s;
+	struct kvm_io_device *device, *device1;
+	struct kvm *kvm = dev->kvm;
+
+	/* extioi has been created */
+	if (kvm->arch.extioi)
+		return -EINVAL;
+
+	s = kzalloc(sizeof(struct loongarch_extioi), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+	spin_lock_init(&s->lock);
+	s->kvm = kvm;
+
+	/*
+	 * Initialize IOCSR device
+	 */
+	device = &s->device;
+	kvm_iodevice_init(device, &kvm_extioi_ops);
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
+			EXTIOI_BASE, EXTIOI_SIZE, device);
+	mutex_unlock(&kvm->slots_lock);
+	if (ret < 0) {
+		kfree(s);
+		return ret;
+	}
+
+	device1 = &s->device_extern;
+	kvm_iodevice_init(device1, &kvm_extioi_virt_ops);
+	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
+			EXTIOI_VIRT_BASE, EXTIOI_VIRT_SIZE, device1);
+	if (ret < 0) {
+		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
+		kfree(s);
+		return ret;
+	}
+	kvm->arch.extioi = s;
+	return 0;
+}
+
+static struct kvm_device_ops kvm_extioi_dev_ops = {
+	.name = "kvm-loongarch-extioi",
+	.create = kvm_extioi_create,
+	.destroy = kvm_extioi_destroy,
+	.set_attr = kvm_extioi_set_attr,
+	.get_attr = kvm_extioi_get_attr,
+};
+
+int kvm_loongarch_register_extioi_device(void)
+{
+	return kvm_register_device_ops(&kvm_extioi_dev_ops,
+					KVM_DEV_TYPE_LA_EXTIOI);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index a1cec0b1fd7f..0fae4f648554 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -9,6 +9,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/kvm_csr.h>
+#include <asm/kvm_extioi.h>
 #include "trace.h"
 
 unsigned long vpid_mask;
@@ -370,6 +371,11 @@ static int kvm_loongarch_env_init(void)
 
 	/* Register loongarch ipi interrupt controller interface. */
 	ret = kvm_loongarch_register_ipi_device();
+	if (ret)
+		return ret;
+
+	/* Register loongarch extioi interrupt controller interface. */
+	ret = kvm_loongarch_register_extioi_device();
 	return ret;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3c8b058ec522..cdb39aa01e95 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1160,6 +1160,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_LA_IPI,
 #define KVM_DEV_TYPE_LA_IPI		KVM_DEV_TYPE_LA_IPI
+	KVM_DEV_TYPE_LA_EXTIOI,
+#define KVM_DEV_TYPE_LA_EXTIOI		KVM_DEV_TYPE_LA_EXTIOI
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.39.1


