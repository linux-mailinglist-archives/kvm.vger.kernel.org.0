Return-Path: <kvm+bounces-21028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B58B9280B9
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D50091F24BF9
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023AE145B18;
	Fri,  5 Jul 2024 02:56:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15173139D04;
	Fri,  5 Jul 2024 02:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148191; cv=none; b=STdj1GpcZ+uzs8mmXb27CP2eFHhQa0du9IGq7S2/6RKvTa1+4eNVbTbKBq68Gloz9jF6DhPpgOU+kTBZ1YEAykqeUJ3b/XuPFSVZzlcOFVGyeBV9ObuTY0RC4fF3oCd5u7ejy6vmWhKE4cVMM6YeFrtO7xDGI52HsiQV75a77jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148191; c=relaxed/simple;
	bh=YylNxF37f0DRD5NJH36i/MtOFN8oFQ9OiCy97hBX+h0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L1gR7j0A3AVcAxBvfn29Bmrc+o4k5tRneIHVHdFcZCuLC+GSX3/b/dDyXxmVxcynM/EmVFhXlJg/kDgl84HhWWZT2AguukYGHFcfx4tKVw0sT05FNRCEtOcRuQkUsHe6kX3cGIDzCrOFS851oHdSj7gvBSU+qvkIBoz1tfylwxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxXevbYIdmDyUBAA--.3484S3;
	Fri, 05 Jul 2024 10:56:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S13;
	Fri, 05 Jul 2024 10:56:25 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Min Zhou <zhoumin@loongson.cn>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH 11/11] LoongArch: KVM: Add irqfd support
Date: Fri,  5 Jul 2024 10:38:54 +0800
Message-Id: <20240705023854.1005258-12-lixianglai@loongson.cn>
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
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S13
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Enable the KVM_IRQ_ROUTING KVM_IRQCHIP KVM_MSI configuration item,
increase the KVM_CAP_IRQCHIP capability, and implement the query
interface of the kernel irqchip.

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

 arch/loongarch/kvm/Kconfig        |  3 ++
 arch/loongarch/kvm/Makefile       |  1 +
 arch/loongarch/kvm/intc/pch_pic.c | 28 ++++++++++
 arch/loongarch/kvm/irqfd.c        | 87 +++++++++++++++++++++++++++++++
 arch/loongarch/kvm/vm.c           | 19 ++++++-
 5 files changed, 137 insertions(+), 1 deletion(-)
 create mode 100644 arch/loongarch/kvm/irqfd.c

diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index c4ef2b4d9797..c2ef17055995 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -29,6 +29,9 @@ config KVM
 	select KVM_MMIO
 	select HAVE_KVM_READONLY_MEM
 	select KVM_XFER_TO_GUEST_WORK
+	select HAVE_KVM_IRQ_ROUTING
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_MSI
 	help
 	  Support hosting virtualized guest machines using
 	  hardware virtualization extensions. You will need
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index 165ecb4d408f..619ab4969458 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -21,5 +21,6 @@ kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/extioi.o
 kvm-y += intc/pch_pic.o
+kvm-y += irqfd.o
 
 CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index abb7bab84f2d..e18e27992978 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -449,6 +449,29 @@ static int kvm_loongarch_pch_pic_set_attr(struct kvm_device *dev,
 	return ret;
 }
 
+static int kvm_setup_default_irq_routing(struct kvm *kvm)
+{
+	struct kvm_irq_routing_entry *entries;
+
+	u32 nr = KVM_IRQCHIP_NUM_PINS;
+	int i, ret;
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
+	return 0;
+}
+
 static void kvm_loongarch_pch_pic_destroy(struct kvm_device *dev)
 {
 	struct kvm *kvm;
@@ -474,6 +497,7 @@ static void kvm_loongarch_pch_pic_destroy(struct kvm_device *dev)
 
 static int kvm_loongarch_pch_pic_create(struct kvm_device *dev, u32 type)
 {
+	int ret;
 	struct loongarch_pch_pic *s;
 	struct kvm *kvm = dev->kvm;
 
@@ -481,6 +505,10 @@ static int kvm_loongarch_pch_pic_create(struct kvm_device *dev, u32 type)
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
index 000000000000..bf67f329ebc9
--- /dev/null
+++ b/arch/loongarch/kvm/irqfd.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <trace/events/kvm.h>
+#include <asm/kvm_pch_pic.h>
+
+static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
+					struct kvm *kvm, int irq_source_id,
+					int level, bool line_status)
+{
+	/* ioapic pin (0 ~ 64) <---> gsi(0 ~ 64) */
+	pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level);
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
+		e->set = kvm_set_ioapic_irq;
+
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
+		struct kvm *kvm, int irq_source_id,
+		int level, bool line_status)
+{
+	if (e->type == KVM_IRQ_ROUTING_MSI) {
+		pch_msi_set_irq(kvm, e->msi.data, 1);
+		return 0;
+	}
+
+	return -EWOULDBLOCK;
+}
+
+/**
+ * kvm_set_msi: inject the MSI corresponding to the
+ * MSI routing entry
+ *
+ * This is the entry point for irqfd MSI injection
+ * and userspace MSI injection.
+ */
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id,
+		int level, bool line_status)
+{
+	if (!level)
+		return -1;
+
+	pch_msi_set_irq(kvm, e->msi.data, level);
+	return 0;
+}
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index decfe11be46b..72ea4bb9f912 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -71,6 +71,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 
 	switch (ext) {
+	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_READONLY_MEM:
@@ -103,7 +104,18 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	int r;
+
+	switch (ioctl) {
+	case KVM_CREATE_IRQCHIP: {
+		r = 1;
+		break;
+	}
+	default:
+		r = -ENOIOCTLCMD;
+	}
+
+	return r;
 }
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *data,
@@ -137,3 +149,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *data,
 
 	return ret;
 }
+
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
+{
+	return (bool)((!!kvm->arch.extioi) && (!!kvm->arch.pch_pic));
+}
-- 
2.39.1


