Return-Path: <kvm+bounces-49940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4E2ADFE80
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 09:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5D24167B7F
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 07:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1D325B2E1;
	Thu, 19 Jun 2025 07:15:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5218E24E01D;
	Thu, 19 Jun 2025 07:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750317304; cv=none; b=CCoh0PaMJUBGmif1BaDWRU+Wp6nnpw+v7FEE9sR4o1ayUShPyUrsCmfNP2SAjjHgIkHQGD2aaQY7wUx4qq38Tp5olQEQyP00BMVg63vc8kLyhTDvrDZ0qx83bJyYXgIaJbTDArRQx4z9hex+/ee59uOk3yAW0FaiIhruEWrMFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750317304; c=relaxed/simple;
	bh=Zq2xSoi9krA08q/eYDoaq3S9x2iXHUHzx9Ou9tVRU3w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pojBS14VtSgQct5BKzGAUozLnBthtpOjFpJO864ZTESpFuC5JylFM1amuIaKgjFYJAnozQkB4bj3UJVXGlYqkGPBjxKmy0H5d45nIRZ67BJh8v6ItXWKTP0dPQretrNNN3KAzRDAcg4MG0Bnxl6FeUWN94QnH3uG+Ned5BVlpm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxlnDtuFNo5agZAQ--.58049S3;
	Thu, 19 Jun 2025 15:14:53 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxLsfquFNok74gAQ--.38277S2;
	Thu, 19 Jun 2025 15:14:50 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] LoongArch: KVM: INTC: Add IOCSR MISC register emulation
Date: Thu, 19 Jun 2025 15:14:49 +0800
Message-Id: <20250619071449.1714869-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLsfquFNok74gAQ--.38277S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

IOCSR MISC register 0x420 controlls some features of eiointc, such as
BIT 48 enables eiointc and BIT 49 set interrupt encoding mode.

When kernel irqchip is set, IOCSR MISC register should be emulated in
kernel also. Here add IOCSR MISC register emulation in kernel side.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
v1 ... v2:
  1. Add separate file arch/loongarch/kvm/intc/misc.c for IOCSR MISC
     register 0x420 emulation, since it controls feature about AVEC
     irqchip also.

  2. Define macro MISC_BASE as LOONGARCH_IOCSR_MISC_FUNC rather than
     hard coded 0x420
---
 arch/loongarch/include/asm/kvm_eiointc.h |   2 +
 arch/loongarch/include/asm/kvm_host.h    |   2 +
 arch/loongarch/include/asm/kvm_misc.h    |  17 +++
 arch/loongarch/include/asm/loongarch.h   |   1 +
 arch/loongarch/kvm/Makefile              |   1 +
 arch/loongarch/kvm/intc/eiointc.c        |  61 +++++++++++
 arch/loongarch/kvm/intc/misc.c           | 125 +++++++++++++++++++++++
 7 files changed, 209 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_misc.h
 create mode 100644 arch/loongarch/kvm/intc/misc.c

diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
index a3a40aba8acf..2d1c183f2b1b 100644
--- a/arch/loongarch/include/asm/kvm_eiointc.h
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -119,5 +119,7 @@ struct loongarch_eiointc {
 
 int kvm_loongarch_register_eiointc_device(void);
 void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level);
+int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *value);
+int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long value, unsigned long mask);
 
 #endif /* __ASM_KVM_EIOINTC_H */
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index a3c4cc46c892..f463ec52d86c 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -132,6 +132,8 @@ struct kvm_arch {
 	struct loongarch_ipi *ipi;
 	struct loongarch_eiointc *eiointc;
 	struct loongarch_pch_pic *pch_pic;
+	struct kvm_io_device misc;
+	bool   misc_created;
 };
 
 #define CSR_MAX_NUMS		0x800
diff --git a/arch/loongarch/include/asm/kvm_misc.h b/arch/loongarch/include/asm/kvm_misc.h
new file mode 100644
index 000000000000..621e4228dea2
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_misc.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_KVM_MISC_H
+#define __ASM_KVM_MISC_H
+
+#include <asm/loongarch.h>
+
+#define MISC_BASE		LOONGARCH_IOCSR_MISC_FUNC
+#define MISC_SIZE		0x8
+
+int kvm_loongarch_create_misc(struct kvm *kvm);
+void kvm_loongarch_destroy_misc(struct kvm *kvm);
+
+#endif /* __ASM_KVM_MISC_H */
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index d84dac88a584..e30d330d497e 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1141,6 +1141,7 @@
 #define  IOCSR_MISC_FUNC_SOFT_INT	BIT_ULL(10)
 #define  IOCSR_MISC_FUNC_TIMER_RESET	BIT_ULL(21)
 #define  IOCSR_MISC_FUNC_EXT_IOI_EN	BIT_ULL(48)
+#define  IOCSR_MISC_FUNC_INT_ENCODE	BIT_ULL(49)
 #define  IOCSR_MISC_FUNC_AVEC_EN	BIT_ULL(51)
 
 #define LOONGARCH_IOCSR_CPUTEMP		0x428
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index cb41d9265662..25fa3866613d 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -18,6 +18,7 @@ kvm-y += vcpu.o
 kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/eiointc.o
+kvm-y += intc/misc.o
 kvm-y += intc/pch_pic.o
 kvm-y += irqfd.o
 
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index f39929d7bf8a..87d01521e92f 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -4,6 +4,7 @@
  */
 
 #include <asm/kvm_eiointc.h>
+#include <asm/kvm_misc.h>
 #include <asm/kvm_vcpu.h>
 #include <linux/count_zeros.h>
 
@@ -708,6 +709,56 @@ static const struct kvm_io_device_ops kvm_eiointc_ops = {
 	.write	= kvm_eiointc_write,
 };
 
+int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *value)
+{
+	unsigned long data, flags;
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	data = 0;
+	spin_lock_irqsave(&eiointc->lock, flags);
+	if (eiointc->status & BIT(EIOINTC_ENABLE))
+		data |= IOCSR_MISC_FUNC_EXT_IOI_EN;
+
+	if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
+		data |= IOCSR_MISC_FUNC_INT_ENCODE;
+	spin_unlock_irqrestore(&eiointc->lock, flags);
+
+	*value = data;
+	return 0;
+}
+
+int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long value, unsigned long mask)
+{
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+	unsigned long old, flags;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	old = 0;
+	spin_lock_irqsave(&eiointc->lock, flags);
+	if (eiointc->status & BIT(EIOINTC_ENABLE))
+		old |= IOCSR_MISC_FUNC_EXT_IOI_EN;
+	if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
+		old |= IOCSR_MISC_FUNC_INT_ENCODE;
+
+	value |= (old & ~mask);
+	eiointc->status &= ~(BIT(EIOINTC_ENABLE_INT_ENCODE) | BIT(EIOINTC_ENABLE));
+	if (value & IOCSR_MISC_FUNC_INT_ENCODE)
+		eiointc->status |= BIT(EIOINTC_ENABLE_INT_ENCODE);
+	if (value & IOCSR_MISC_FUNC_EXT_IOI_EN)
+		eiointc->status |= BIT(EIOINTC_ENABLE);
+	spin_unlock_irqrestore(&eiointc->lock, flags);
+	return 0;
+}
+
 static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
 				struct kvm_io_device *dev,
 				gpa_t addr, int len, void *val)
@@ -993,6 +1044,15 @@ static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
 		kfree(s);
 		return ret;
 	}
+
+	ret = kvm_loongarch_create_misc(kvm);
+	if (ret < 0) {
+		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
+		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device_vext);
+		kfree(s);
+		return ret;
+	}
+
 	kvm->arch.eiointc = s;
 
 	return 0;
@@ -1010,6 +1070,7 @@ static void kvm_eiointc_destroy(struct kvm_device *dev)
 	eiointc = kvm->arch.eiointc;
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_vext);
+	kvm_loongarch_destroy_misc(kvm);
 	kfree(eiointc);
 }
 
diff --git a/arch/loongarch/kvm/intc/misc.c b/arch/loongarch/kvm/intc/misc.c
new file mode 100644
index 000000000000..edee66afa36e
--- /dev/null
+++ b/arch/loongarch/kvm/intc/misc.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+#include <asm/kvm_vcpu.h>
+#include <asm/kvm_eiointc.h>
+#include <asm/kvm_misc.h>
+
+static int kvm_misc_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			gpa_t addr, int len, void *val)
+{
+	unsigned long data;
+	unsigned int ret;
+
+	addr -= MISC_BASE;
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
+	ret = kvm_eiointc_get_status(vcpu, &data);
+	if (ret)
+		return ret;
+
+	data = data >> ((addr & 7) * 8);
+	switch (len) {
+	case 1:
+		*(unsigned char *)val = (unsigned char)data;
+		break;
+
+	case 2:
+		*(unsigned short *)val = (unsigned short)data;
+		break;
+
+	case 4:
+		*(unsigned int *)val = (unsigned int)data;
+		break;
+
+	default:
+		*(unsigned long *)val = data;
+		break;
+	}
+
+	return 0;
+}
+
+static int kvm_misc_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+		gpa_t addr, int len, const void *val)
+{
+	unsigned long data, mask;
+	unsigned int shift;
+
+	addr -= MISC_BASE;
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
+	shift = (addr & 7) * 8;
+	switch (len) {
+	case 1:
+		data = *(unsigned char *)val;
+		mask = 0xFF;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+
+	case 2:
+		data = *(unsigned short *)val;
+		mask = 0xFFFF;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+
+	case 4:
+		data = *(unsigned int *)val;
+		mask = UINT_MAX;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+
+	default:
+		data = *(unsigned long *)val;
+		mask = ULONG_MAX;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+	}
+
+	return kvm_eiointc_update_status(vcpu, data, mask);
+}
+
+static const struct kvm_io_device_ops kvm_misc_ops = {
+	.read   = kvm_misc_read,
+	.write  = kvm_misc_write,
+};
+
+int kvm_loongarch_create_misc(struct kvm *kvm)
+{
+	struct kvm_io_device *device;
+	int ret;
+
+	if (kvm->arch.misc_created)
+		return 0;
+
+	device = &kvm->arch.misc;
+	kvm_iodevice_init(device, &kvm_misc_ops);
+	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, MISC_BASE, MISC_SIZE, device);
+	if (ret < 0)
+		return ret;
+
+	kvm->arch.misc_created = true;
+	return 0;
+}
+
+void kvm_loongarch_destroy_misc(struct kvm *kvm)
+{
+	struct kvm_io_device *device;
+
+	if (kvm->arch.misc_created) {
+		device = &kvm->arch.misc;
+		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
+		kvm->arch.misc_created = false;
+	}
+}

base-commit: 52da431bf03b5506203bca27fe14a97895c80faf
-- 
2.39.3


