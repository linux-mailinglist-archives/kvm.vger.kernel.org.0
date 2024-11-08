Return-Path: <kvm+bounces-31215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3B89C14EA
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 04:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3117E1C22BC8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6007D1CFEBF;
	Fri,  8 Nov 2024 03:54:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE101C68BD;
	Fri,  8 Nov 2024 03:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731038071; cv=none; b=BxRrMT34I/7a+O2ozFd+Fk4rypw+l2C2BMb/dMDIkkDWPXPcqlCWcgI6RUWzh0ZHhwUnYiaF0xI0CcLBef+Zf0/tgrz4MAj1iGGOcgYs4loVpDswRbRjduxl0bucgh+1Ef1XvI1vOBY11mKe8n4BMT4xcLqZSQ8D0KCfTFle7Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731038071; c=relaxed/simple;
	bh=Y/GfIzeslLfQeOi5hrA84D9bSM7UPbMlfJtiorztGjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B0T/w/nX9wkaqhuYlf+pFQO75pPhFb1QTRxczkpy08o/K7QGArYI7CuXYkBwgNPXYWxsjevKyfZgKppMnLgvXqvV3o4Sl8BtP+1eT/kVmHQwQMxH6gLJjxgpIpDuFYyk8Dhb0QN7bsJ9wgogVn31Ns/dCGMgyQBURECOgjhGm9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxMK9ziy1ny9g4AA--.22601S3;
	Fri, 08 Nov 2024 11:54:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMBxrsJtiy1nITRMAA--.38809S6;
	Fri, 08 Nov 2024 11:54:26 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH V4 05/11] LoongArch: KVM: Add EIOINTC device support
Date: Fri,  8 Nov 2024 11:35:52 +0800
Message-Id: <20241108033558.2727612-5-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20241108033558.2727612-1-lixianglai@loongson.cn>
References: <20241108033437.2727574-1-lixianglai@loongson.cn>
 <20241108033558.2727612-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxrsJtiy1nITRMAA--.38809S6
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add device model for EIOINTC interrupt controller, implement basic
create & destroy interfaces, and register device model to kvm device
table.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_eiointc.h |  93 ++++++++++++++++
 arch/loongarch/include/asm/kvm_host.h    |   4 +-
 arch/loongarch/kvm/Makefile              |   1 +
 arch/loongarch/kvm/intc/eiointc.c        | 129 +++++++++++++++++++++++
 arch/loongarch/kvm/main.c                |   6 ++
 include/uapi/linux/kvm.h                 |   2 +
 6 files changed, 234 insertions(+), 1 deletion(-)
 create mode 100644 arch/loongarch/include/asm/kvm_eiointc.h
 create mode 100644 arch/loongarch/kvm/intc/eiointc.c

diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
new file mode 100644
index 000000000000..61a1d2c108b1
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#ifndef LOONGARCH_EIOINTC_H
+#define LOONGARCH_EIOINTC_H
+
+#include <kvm/iodev.h>
+
+#define EIOINTC_IRQS			256
+#define EIOINTC_ROUTE_MAX_VCPUS		256
+#define EIOINTC_IRQS_U8_NUMS		(EIOINTC_IRQS / 8)
+#define EIOINTC_IRQS_U16_NUMS		(EIOINTC_IRQS_U8_NUMS / 2)
+#define EIOINTC_IRQS_U32_NUMS		(EIOINTC_IRQS_U8_NUMS / 4)
+#define EIOINTC_IRQS_U64_NUMS		(EIOINTC_IRQS_U8_NUMS / 8)
+/* map to ipnum per 32 irqs */
+#define EIOINTC_IRQS_NODETYPE_COUNT	16
+
+#define EIOINTC_BASE			0x1400
+#define EIOINTC_SIZE			0x900
+
+#define EIOINTC_VIRT_BASE		(0x40000000)
+#define EIOINTC_VIRT_SIZE		(0x1000)
+
+#define LS3A_IP_NUM			8
+
+struct loongarch_eiointc {
+	spinlock_t lock;
+	struct kvm *kvm;
+	struct kvm_io_device device;
+	struct kvm_io_device device_vext;
+	uint32_t num_cpu;
+	uint32_t features;
+	uint32_t status;
+
+	/* hardware state */
+	union nodetype {
+		u64 reg_u64[EIOINTC_IRQS_NODETYPE_COUNT / 4];
+		u32 reg_u32[EIOINTC_IRQS_NODETYPE_COUNT / 2];
+		u16 reg_u16[EIOINTC_IRQS_NODETYPE_COUNT];
+		u8 reg_u8[EIOINTC_IRQS_NODETYPE_COUNT * 2];
+	} nodetype;
+
+	/* one bit shows the state of one irq */
+	union bounce {
+		u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
+		u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
+		u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
+		u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
+	} bounce;
+
+	union isr {
+		u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
+		u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
+		u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
+		u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
+	} isr;
+	union coreisr {
+		u64 reg_u64[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U64_NUMS];
+		u32 reg_u32[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U32_NUMS];
+		u16 reg_u16[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U16_NUMS];
+		u8 reg_u8[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U8_NUMS];
+	} coreisr;
+	union enable {
+		u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
+		u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
+		u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
+		u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
+	} enable;
+
+	/* use one byte to config ipmap for 32 irqs at once */
+	union ipmap {
+		u64 reg_u64;
+		u32 reg_u32[EIOINTC_IRQS_U32_NUMS / 4];
+		u16 reg_u16[EIOINTC_IRQS_U16_NUMS / 4];
+		u8 reg_u8[EIOINTC_IRQS_U8_NUMS / 4];
+	} ipmap;
+	/* use one byte to config coremap for one irq */
+	union coremap {
+		u64 reg_u64[EIOINTC_IRQS / 8];
+		u32 reg_u32[EIOINTC_IRQS / 4];
+		u16 reg_u16[EIOINTC_IRQS / 2];
+		u8 reg_u8[EIOINTC_IRQS];
+	} coremap;
+
+	DECLARE_BITMAP(sw_coreisr[EIOINTC_ROUTE_MAX_VCPUS][LS3A_IP_NUM], EIOINTC_IRQS);
+	uint8_t  sw_coremap[EIOINTC_IRQS];
+};
+
+void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level);
+int kvm_loongarch_register_eiointc_device(void);
+#endif /* LOONGARCH_EIOINTC_H */
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index a1de884ebb44..2d0476f05148 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #include <asm/inst.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_ipi.h>
+#include <asm/kvm_eiointc.h>
 #include <asm/loongarch.h>
 
 /* Loongarch KVM register ids */
@@ -87,7 +88,7 @@ struct kvm_world_switch {
  *
  *  For LOONGARCH_CSR_CPUID register, max CPUID size if 512
  *  For IPI hardware, max destination CPUID size 1024
- *  For extioi interrupt controller, max destination CPUID size is 256
+ *  For eiointc interrupt controller, max destination CPUID size is 256
  *  For msgint interrupt controller, max supported CPUID size is 65536
  *
  * Currently max CPUID is defined as 256 for KVM hypervisor, in future
@@ -121,6 +122,7 @@ struct kvm_arch {
 	s64 time_offset;
 	struct kvm_context __percpu *vmcs;
 	struct loongarch_ipi *ipi;
+	struct loongarch_eiointc *eiointc;
 };
 
 #define CSR_MAX_NUMS		0x800
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index 36c3009fe89c..bb50fc799c29 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -19,5 +19,6 @@ kvm-y += tlb.o
 kvm-y += vcpu.o
 kvm-y += vm.o
 kvm-y += intc/ipi.o
+kvm-y += intc/eiointc.o
 
 CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
new file mode 100644
index 000000000000..93752fa07536
--- /dev/null
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include <asm/kvm_eiointc.h>
+#include <asm/kvm_vcpu.h>
+#include <linux/count_zeros.h>
+
+static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_eiointc_ops = {
+	.read	= kvm_eiointc_read,
+	.write	= kvm_eiointc_write,
+};
+
+static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
+				struct kvm_io_device *dev,
+				gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static int kvm_eiointc_virt_write(struct kvm_vcpu *vcpu,
+				struct kvm_io_device *dev,
+				gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_eiointc_virt_ops = {
+	.read	= kvm_eiointc_virt_read,
+	.write	= kvm_eiointc_virt_write,
+};
+
+static int kvm_eiointc_get_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static int kvm_eiointc_set_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static void kvm_eiointc_destroy(struct kvm_device *dev)
+{
+	struct kvm *kvm;
+	struct loongarch_eiointc *eiointc;
+
+	if (!dev || !dev->kvm || !dev->kvm->arch.eiointc)
+		return;
+	kvm = dev->kvm;
+	eiointc = kvm->arch.eiointc;
+	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
+	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_vext);
+	kfree(eiointc);
+}
+
+static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
+{
+	int ret;
+	struct loongarch_eiointc *s;
+	struct kvm_io_device *device, *device1;
+	struct kvm *kvm = dev->kvm;
+
+	/* eiointc has been created */
+	if (kvm->arch.eiointc)
+		return -EINVAL;
+
+	s = kzalloc(sizeof(struct loongarch_eiointc), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+	spin_lock_init(&s->lock);
+	s->kvm = kvm;
+
+	/*
+	 * Initialize IOCSR device
+	 */
+	device = &s->device;
+	kvm_iodevice_init(device, &kvm_eiointc_ops);
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
+			EXTIOI_BASE, EXTIOI_SIZE, device);
+	mutex_unlock(&kvm->slots_lock);
+	if (ret < 0) {
+		kfree(s);
+		return ret;
+	}
+
+	device1 = &s->device_vext;
+	kvm_iodevice_init(device1, &kvm_eiointc_virt_ops);
+	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
+			EXTIOI_VIRT_BASE, EXTIOI_VIRT_SIZE, device1);
+	if (ret < 0) {
+		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
+		kfree(s);
+		return ret;
+	}
+	kvm->arch.eiointc = s;
+	return 0;
+}
+
+static struct kvm_device_ops kvm_eiointc_dev_ops = {
+	.name = "kvm-loongarch-eiointc",
+	.create = kvm_eiointc_create,
+	.destroy = kvm_eiointc_destroy,
+	.set_attr = kvm_eiointc_set_attr,
+	.get_attr = kvm_eiointc_get_attr,
+};
+
+int kvm_loongarch_register_eiointc_device(void)
+{
+	return kvm_register_device_ops(&kvm_eiointc_dev_ops, KVM_DEV_TYPE_LOONGARCH_EIOINTC);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 7dabee7705a4..c389ea8cc359 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -9,6 +9,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/kvm_csr.h>
+#include <asm/kvm_eiointc.h>
 #include "trace.h"
 
 unsigned long vpid_mask;
@@ -370,6 +371,11 @@ static int kvm_loongarch_env_init(void)
 
 	/* Register LoongArch IPI interrupt controller interface. */
 	ret = kvm_loongarch_register_ipi_device();
+	if (ret)
+		return ret;
+
+	/* Register LoongArch EIOINTC interrupt controller interface. */
+	ret = kvm_loongarch_register_eiointc_device();
 	return ret;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9fff439c30ea..0ec5c631d9e9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1160,6 +1160,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_LOONGARCH_IPI,
 #define KVM_DEV_TYPE_LOONGARCH_IPI	KVM_DEV_TYPE_LOONGARCH_IPI
+	KVM_DEV_TYPE_LOONGARCH_EIOINTC,
+#define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.39.1


