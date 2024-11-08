Return-Path: <kvm+bounces-31212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6BF9C14E4
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 04:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 538C21C2154B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEAC1C9ECE;
	Fri,  8 Nov 2024 03:54:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659EA1A2564;
	Fri,  8 Nov 2024 03:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731038069; cv=none; b=cd2CJ87s77f8qMlT9Rz5d1DvfCXWIXzJAnUJh7cXpYFt+KAWMY3vJ+833nT1JQBakTPK6wdRWDG+Qq9l4+yM4cafDSxV4VBynX3bdiDP+/ZKIuReAPdTPRaVM1Q8Fx/SkKesO0b9T8zRFSdJtZNIG4FbtRUcirGuESMPmry0+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731038069; c=relaxed/simple;
	bh=ZIkWKrzZ9kqm0OSG7/IKpScvOQGjTfb8Thrl/U/eArE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UGlkZf8JNH2u03M3MqTkvrTp7ET5GNazeUgilGdg2XeQGwF/hYrfoqmzcJWJgB61uCDn/Dy3Bd3cmaIw864DpSfDlMF1YNIR7W8jjyWp2j09bFv3ReO88NgOGmoAcSHN9ImXkaenKu+ppZj6NcnA0nn9pKQtsqsZlK0kIGEfbK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxPOJwiy1ntdg4AA--.46277S3;
	Fri, 08 Nov 2024 11:54:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMBxrsJtiy1nITRMAA--.38809S3;
	Fri, 08 Nov 2024 11:54:22 +0800 (CST)
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
Subject: [PATCH V4 02/11] LoongArch: KVM: Add IPI device support
Date: Fri,  8 Nov 2024 11:35:49 +0800
Message-Id: <20241108033558.2727612-2-lixianglai@loongson.cn>
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
X-CM-TRANSID:qMiowMBxrsJtiy1nITRMAA--.38809S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add device model for IPI interrupt controller, implement basic create &
destroy interfaces, and register device model to kvm device table.

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

 arch/loongarch/include/asm/kvm_host.h |   4 +
 arch/loongarch/include/asm/kvm_ipi.h  |  33 ++++++++
 arch/loongarch/kvm/Makefile           |   1 +
 arch/loongarch/kvm/intc/ipi.c         | 114 ++++++++++++++++++++++++++
 arch/loongarch/kvm/main.c             |   6 +-
 arch/loongarch/kvm/vcpu.c             |   3 +
 include/uapi/linux/kvm.h              |   4 +
 7 files changed, 163 insertions(+), 2 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
 create mode 100644 arch/loongarch/kvm/intc/ipi.c

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index d6bb72424027..8e5393d21fcb 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -18,6 +18,7 @@
 
 #include <asm/inst.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_ipi.h>
 #include <asm/loongarch.h>
 
 /* Loongarch KVM register ids */
@@ -117,6 +118,7 @@ struct kvm_arch {
 
 	s64 time_offset;
 	struct kvm_context __percpu *vmcs;
+	struct loongarch_ipi *ipi;
 };
 
 #define CSR_MAX_NUMS		0x800
@@ -221,6 +223,8 @@ struct kvm_vcpu_arch {
 	int last_sched_cpu;
 	/* mp state */
 	struct kvm_mp_state mp_state;
+	/* ipi state */
+	struct ipi_state ipi_state;
 	/* cpucfg */
 	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
 
diff --git a/arch/loongarch/include/asm/kvm_ipi.h b/arch/loongarch/include/asm/kvm_ipi.h
new file mode 100644
index 000000000000..714c51626a19
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_ipi.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_KVM_IPI_H
+#define __ASM_KVM_IPI_H
+
+#include <kvm/iodev.h>
+
+#define LARCH_INT_IPI			12
+
+struct loongarch_ipi {
+	spinlock_t lock;
+	struct kvm *kvm;
+	struct kvm_io_device device;
+};
+
+struct ipi_state {
+	spinlock_t lock;
+	uint32_t status;
+	uint32_t en;
+	uint32_t set;
+	uint32_t clear;
+	uint64_t buf[4];
+};
+
+#define SMP_MAILBOX			0x1000
+#define KVM_IOCSR_IPI_ADDR_SIZE		0x160
+
+int kvm_loongarch_register_ipi_device(void);
+
+#endif
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index b2f4cbe01ae8..36c3009fe89c 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -18,5 +18,6 @@ kvm-y += timer.o
 kvm-y += tlb.o
 kvm-y += vcpu.o
 kvm-y += vm.o
+kvm-y += intc/ipi.o
 
 CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
new file mode 100644
index 000000000000..541b54a558e6
--- /dev/null
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_ipi.h>
+#include <asm/kvm_vcpu.h>
+
+static int kvm_ipi_write(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static int kvm_ipi_read(struct kvm_vcpu *vcpu,
+			struct kvm_io_device *dev,
+			gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_ipi_ops = {
+	.read	= kvm_ipi_read,
+	.write	= kvm_ipi_write,
+};
+
+static int kvm_ipi_get_attr(struct kvm_device *dev,
+			struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static int kvm_ipi_set_attr(struct kvm_device *dev,
+			struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static int kvm_ipi_create(struct kvm_device *dev, u32 type)
+{
+	int ret;
+	unsigned long addr;
+	struct kvm *kvm;
+	struct kvm_io_device *device;
+	struct loongarch_ipi *s;
+
+	if (!dev) {
+		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
+		return -EINVAL;
+	}
+
+	kvm = dev->kvm;
+	if (kvm->arch.ipi) {
+		kvm_err("%s: LoongArch IPI has already been created!\n", __func__);
+		return -EINVAL;
+	}
+
+	s = kzalloc(sizeof(struct loongarch_ipi), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	spin_lock_init(&s->lock);
+	s->kvm = kvm;
+
+	/*
+	 * Initialize IOCSR device
+	 */
+	device = &s->device;
+	kvm_iodevice_init(device, &kvm_ipi_ops);
+	addr = SMP_MAILBOX;
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, addr, KVM_IOCSR_IPI_ADDR_SIZE, device);
+	mutex_unlock(&kvm->slots_lock);
+	if (ret < 0) {
+		kvm_err("%s: Initialize IOCSR dev failed, ret = %d\n", __func__, ret);
+		goto err;
+	}
+
+	kvm->arch.ipi = s;
+	return 0;
+
+err:
+	kfree(s);
+	return -EFAULT;
+}
+
+static void kvm_ipi_destroy(struct kvm_device *dev)
+{
+	struct kvm *kvm;
+	struct loongarch_ipi *ipi;
+
+	if (!dev || !dev->kvm || !dev->kvm->arch.ipi)
+		return;
+
+	kvm = dev->kvm;
+	ipi = kvm->arch.ipi;
+	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &ipi->device);
+	kfree(ipi);
+}
+
+static struct kvm_device_ops kvm_ipi_dev_ops = {
+	.name = "kvm-loongarch-ipi",
+	.create = kvm_ipi_create,
+	.destroy = kvm_ipi_destroy,
+	.set_attr = kvm_ipi_set_attr,
+	.get_attr = kvm_ipi_get_attr,
+};
+
+int kvm_loongarch_register_ipi_device(void)
+{
+	return kvm_register_device_ops(&kvm_ipi_dev_ops, KVM_DEV_TYPE_LOONGARCH_IPI);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 27e9b94c0a0b..7dabee7705a4 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -313,7 +313,7 @@ void kvm_arch_disable_virtualization_cpu(void)
 
 static int kvm_loongarch_env_init(void)
 {
-	int cpu, order;
+	int cpu, order, ret;
 	void *addr;
 	struct kvm_context *context;
 
@@ -368,7 +368,9 @@ static int kvm_loongarch_env_init(void)
 
 	kvm_init_gcsr_flag();
 
-	return 0;
+	/* Register LoongArch IPI interrupt controller interface. */
+	ret = kvm_loongarch_register_ipi_device();
+	return ret;
 }
 
 static void kvm_loongarch_env_exit(void)
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 174734a23d0a..cab1818be68d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1475,6 +1475,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Init */
 	vcpu->arch.last_sched_cpu = -1;
 
+	/* Init ipi_state lock */
+	spin_lock_init(&vcpu->arch.ipi_state.lock);
+
 	/*
 	 * Initialize guest register state to valid architectural reset state.
 	 */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..9fff439c30ea 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1158,7 +1158,11 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_RISCV_AIA,
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
+	KVM_DEV_TYPE_LOONGARCH_IPI,
+#define KVM_DEV_TYPE_LOONGARCH_IPI	KVM_DEV_TYPE_LOONGARCH_IPI
+
 	KVM_DEV_TYPE_MAX,
+
 };
 
 struct kvm_vfio_spapr_tce {
-- 
2.39.1


