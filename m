Return-Path: <kvm+bounces-21760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 504139335D0
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 723DB1C22D0E
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32416DDC7;
	Wed, 17 Jul 2024 03:47:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAEB538A
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 03:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721188064; cv=none; b=D7IarD2KIlV3k/ztYFYALJM2WCLraEXUFdfKxhyI85Mmzu9mbQ/8jzaqxqoMd5fvN/UBNOQYs8hD02hMo/nMhqTK9+FP/u9bKcKrAq19C1xZ40NcKNkQJHPatGHBdsjzX4mJxlskQ0SjxiUvLFW8wj4rAEwFH2LbN7BVx07yULw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721188064; c=relaxed/simple;
	bh=Z3hYQqtbZrVRD9dTiqidc83Dxxan2PLn+fEkH85imVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QYIGPgNJIFx6DeUoyT3IgDnHAcQDCBbWZ5bTBONlxyVx77As5TwAz8cHrRg8uCfYBdlOpiEG7YnUI7ZvuCbsTGz3AsK9LlFzTx4ADbpvST2RsSEa0SQC+iv4ENZFRVUQlHVZpcaOig2PHZ2ihnFims9HK+6tPx8JTbAwXNJOs1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxJeraPpdm2loFAA--.4573S3;
	Wed, 17 Jul 2024 11:47:38 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx08TYPpdmIgdMAA--.29770S4;
	Wed, 17 Jul 2024 11:47:37 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: qemu-devel@nongnu.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	kvm@vger.kernel.org,
	Bibo Mao <maobibo@loongson.cn>
Subject: [RFC 2/4] hw/loongarch: Add KVM extioi device support
Date: Wed, 17 Jul 2024 11:29:54 +0800
Message-Id: <4748bd1ea321dea8722605f9d66c2cbbff7e8883.1721186636.git.lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1721186636.git.lixianglai@loongson.cn>
References: <cover.1721186636.git.lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bx08TYPpdmIgdMAA--.29770S4
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Added extioi interrupt controller for kvm emulation.
The main process is to send the command word for
creating an extioi device to the kernel.
When the VM is saved, the ioctl obtains the related
data of the extioi interrupt controller in the kernel
and saves it. When the VM is recovered, the saved data
is sent to the kernel.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Song Gao <gaosong@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com> 
Cc: "Michael S. Tsirkin" <mst@redhat.com> 
Cc: Cornelia Huck <cohuck@redhat.com> 
Cc: kvm@vger.kernel.org 
Cc: Bibo Mao <maobibo@loongson.cn> 

 hw/intc/Kconfig                    |   4 +
 hw/intc/loongarch_extioi_kvm.c     | 141 +++++++++++++++++++++++++++++
 hw/intc/meson.build                |   1 +
 hw/loongarch/virt.c                |  48 +++++-----
 include/hw/intc/loongarch_extioi.h |  34 ++++++-
 include/hw/loongarch/virt.h        |  15 +++
 linux-headers/asm-loongarch/kvm.h  |   1 +
 linux-headers/linux/kvm.h          |   2 +
 8 files changed, 223 insertions(+), 23 deletions(-)
 create mode 100644 hw/intc/loongarch_extioi_kvm.c

diff --git a/hw/intc/Kconfig b/hw/intc/Kconfig
index 19d6809129..c672774c6e 100644
--- a/hw/intc/Kconfig
+++ b/hw/intc/Kconfig
@@ -105,3 +105,7 @@ config LOONGARCH_PCH_MSI
 
 config LOONGARCH_EXTIOI
     bool
+
+config LOONGARCH_EXTIOI_KVM
+    bool
+    default y
diff --git a/hw/intc/loongarch_extioi_kvm.c b/hw/intc/loongarch_extioi_kvm.c
new file mode 100644
index 0000000000..36f6683615
--- /dev/null
+++ b/hw/intc/loongarch_extioi_kvm.c
@@ -0,0 +1,141 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * LoongArch kvm extioi interrupt support
+ *
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include "qemu/osdep.h"
+#include "hw/qdev-properties.h"
+#include "qemu/typedefs.h"
+#include "hw/intc/loongarch_extioi.h"
+#include "hw/sysbus.h"
+#include "linux/kvm.h"
+#include "migration/vmstate.h"
+#include "qapi/error.h"
+#include "sysemu/kvm.h"
+
+static void kvm_extioi_access_regs(int fd, uint64_t addr,
+                                       void *val, int is_write)
+{
+        kvm_device_access(fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS,
+                          addr, val, is_write, &error_abort);
+}
+
+static int kvm_loongarch_extioi_pre_save(void *opaque)
+{
+    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
+    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
+    int fd = class->dev_fd;
+
+    kvm_extioi_access_regs(fd, EXTIOI_NODETYPE_START,
+                           (void *)s->nodetype, false);
+    kvm_extioi_access_regs(fd, EXTIOI_IPMAP_START, (void *)s->ipmap, false);
+    kvm_extioi_access_regs(fd, EXTIOI_ENABLE_START, (void *)s->enable, false);
+    kvm_extioi_access_regs(fd, EXTIOI_BOUNCE_START, (void *)s->bounce, false);
+    kvm_extioi_access_regs(fd, EXTIOI_ISR_START, (void *)s->isr, false);
+    kvm_extioi_access_regs(fd, EXTIOI_COREMAP_START,
+                           (void *)s->coremap, false);
+    kvm_extioi_access_regs(fd, EXTIOI_SW_COREMAP_FLAG,
+                           (void *)s->sw_coremap, false);
+    kvm_extioi_access_regs(fd, EXTIOI_COREISR_START,
+                           (void *)s->coreisr, false);
+
+    return 0;
+}
+
+static int kvm_loongarch_extioi_post_load(void *opaque, int version_id)
+{
+    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
+    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
+    int fd = class->dev_fd;
+
+    kvm_extioi_access_regs(fd, EXTIOI_NODETYPE_START,
+                           (void *)s->nodetype, true);
+    kvm_extioi_access_regs(fd, EXTIOI_IPMAP_START, (void *)s->ipmap, true);
+    kvm_extioi_access_regs(fd, EXTIOI_ENABLE_START, (void *)s->enable, true);
+    kvm_extioi_access_regs(fd, EXTIOI_BOUNCE_START, (void *)s->bounce, true);
+    kvm_extioi_access_regs(fd, EXTIOI_ISR_START, (void *)s->isr, true);
+    kvm_extioi_access_regs(fd, EXTIOI_COREMAP_START, (void *)s->coremap, true);
+    kvm_extioi_access_regs(fd, EXTIOI_SW_COREMAP_FLAG,
+                           (void *)s->sw_coremap, true);
+    kvm_extioi_access_regs(fd, EXTIOI_COREISR_START, (void *)s->coreisr, true);
+
+    return 0;
+}
+
+static void kvm_loongarch_extioi_realize(DeviceState *dev, Error **errp)
+{
+    KVMLoongArchExtIOIClass *extioi_class = KVM_LOONGARCH_EXTIOI_GET_CLASS(dev);
+    struct kvm_create_device cd = {0};
+    Error *err = NULL;
+    int ret;
+
+    extioi_class->parent_realize(dev, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+
+    if (!extioi_class->is_created) {
+        cd.type = KVM_DEV_TYPE_LA_EXTIOI;
+        ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_DEVICE, &cd);
+        if (ret < 0) {
+            error_setg_errno(errp, errno,
+                             "Creating the KVM extioi device failed");
+            return;
+        }
+        extioi_class->is_created = true;
+        extioi_class->dev_fd = cd.fd;
+        fprintf(stdout, "Create LoongArch extioi irqchip in KVM done!\n");
+    }
+}
+
+static const VMStateDescription vmstate_kvm_extioi_core = {
+    .name = "kvm-extioi-single",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .pre_save = kvm_loongarch_extioi_pre_save,
+    .post_load = kvm_loongarch_extioi_post_load,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT32_ARRAY(nodetype, KVMLoongArchExtIOI,
+                             EXTIOI_IRQS_NODETYPE_COUNT / 2),
+        VMSTATE_UINT32_ARRAY(bounce, KVMLoongArchExtIOI,
+                             EXTIOI_IRQS_GROUP_COUNT),
+        VMSTATE_UINT32_ARRAY(isr, KVMLoongArchExtIOI, EXTIOI_IRQS / 32),
+        VMSTATE_UINT32_2DARRAY(coreisr, KVMLoongArchExtIOI, EXTIOI_CPUS,
+                               EXTIOI_IRQS_GROUP_COUNT),
+        VMSTATE_UINT32_ARRAY(enable, KVMLoongArchExtIOI, EXTIOI_IRQS / 32),
+        VMSTATE_UINT32_ARRAY(ipmap, KVMLoongArchExtIOI,
+                             EXTIOI_IRQS_IPMAP_SIZE / 4),
+        VMSTATE_UINT32_ARRAY(coremap, KVMLoongArchExtIOI, EXTIOI_IRQS / 4),
+        VMSTATE_UINT8_ARRAY(sw_coremap, KVMLoongArchExtIOI, EXTIOI_IRQS),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static void kvm_loongarch_extioi_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    KVMLoongArchExtIOIClass *extioi_class = KVM_LOONGARCH_EXTIOI_CLASS(oc);
+
+    extioi_class->parent_realize = dc->realize;
+    dc->realize = kvm_loongarch_extioi_realize;
+    extioi_class->is_created = false;
+    dc->vmsd = &vmstate_kvm_extioi_core;
+}
+
+static const TypeInfo kvm_loongarch_extioi_info = {
+    .name = TYPE_KVM_LOONGARCH_EXTIOI,
+    .parent = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(KVMLoongArchExtIOI),
+    .class_size = sizeof(KVMLoongArchExtIOIClass),
+    .class_init = kvm_loongarch_extioi_class_init,
+};
+
+static void kvm_loongarch_extioi_register_types(void)
+{
+    type_register_static(&kvm_loongarch_extioi_info);
+}
+
+type_init(kvm_loongarch_extioi_register_types)
diff --git a/hw/intc/meson.build b/hw/intc/meson.build
index 354d43b4f0..3f29b3f5fd 100644
--- a/hw/intc/meson.build
+++ b/hw/intc/meson.build
@@ -74,3 +74,4 @@ specific_ss.add(when: 'CONFIG_LOONGARCH_IPI_KVM', if_true: files('loongarch_ipi_
 specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC', if_true: files('loongarch_pch_pic.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_MSI', if_true: files('loongarch_pch_msi.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI', if_true: files('loongarch_extioi.c'))
+specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI_KVM', if_true: files('loongarch_extioi_kvm.c'))
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 2ae5298b62..288aac5822 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -828,28 +828,34 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
     }
 
     /* Create EXTIOI device */
-    extioi = qdev_new(TYPE_LOONGARCH_EXTIOI);
-    qdev_prop_set_uint32(extioi, "num-cpu", ms->smp.cpus);
-    if (virt_is_veiointc_enabled(lvms)) {
-        qdev_prop_set_bit(extioi, "has-virtualization-extension", true);
-    }
-    sysbus_realize_and_unref(SYS_BUS_DEVICE(extioi), &error_fatal);
-    memory_region_add_subregion(&lvms->system_iocsr, APIC_BASE,
-                    sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 0));
-    if (virt_is_veiointc_enabled(lvms)) {
-        memory_region_add_subregion(&lvms->system_iocsr, EXTIOI_VIRT_BASE,
-                    sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 1));
-    }
+    if (kvm_kernel_irqchip_allowed()) {
+        extioi = qdev_new(TYPE_KVM_LOONGARCH_EXTIOI);
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(extioi), &error_fatal);
+        kvm_async_interrupts_allowed = true;
+    } else {
+        extioi = qdev_new(TYPE_LOONGARCH_EXTIOI);
+        qdev_prop_set_uint32(extioi, "num-cpu", ms->smp.cpus);
+        if (virt_is_veiointc_enabled(lvms)) {
+            qdev_prop_set_bit(extioi, "has-virtualization-extension", true);
+        }
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(extioi), &error_fatal);
+        memory_region_add_subregion(&lvms->system_iocsr, APIC_BASE,
+                       sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 0));
+        if (virt_is_veiointc_enabled(lvms)) {
+            memory_region_add_subregion(&lvms->system_iocsr, EXTIOI_VIRT_BASE,
+                        sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 1));
+        }
 
-    /*
-     * connect ext irq to the cpu irq
-     * cpu_pin[9:2] <= intc_pin[7:0]
-     */
-    for (cpu = 0; cpu < ms->smp.cpus; cpu++) {
-        cpudev = DEVICE(qemu_get_cpu(cpu));
-        for (pin = 0; pin < LS3A_INTC_IP; pin++) {
-            qdev_connect_gpio_out(extioi, (cpu * 8 + pin),
-                                  qdev_get_gpio_in(cpudev, pin + 2));
+        /*
+         * connect ext irq to the cpu irq
+         * cpu_pin[9:2] <= intc_pin[7:0]
+         */
+        for (cpu = 0; cpu < ms->smp.cpus; cpu++) {
+            cpudev = DEVICE(qemu_get_cpu(cpu));
+            for (pin = 0; pin < LS3A_INTC_IP; pin++) {
+                qdev_connect_gpio_out(extioi, (cpu * 8 + pin),
+                                      qdev_get_gpio_in(cpudev, pin + 2));
+            }
         }
     }
 
diff --git a/include/hw/intc/loongarch_extioi.h b/include/hw/intc/loongarch_extioi.h
index eccc2e0d18..9f396f645c 100644
--- a/include/hw/intc/loongarch_extioi.h
+++ b/include/hw/intc/loongarch_extioi.h
@@ -15,7 +15,7 @@
 #define EXTIOI_IRQS                (256)
 #define EXTIOI_IRQS_BITMAP_SIZE    (256 / 8)
 /* irq from EXTIOI is routed to no more than 4 cpus */
-#define EXTIOI_CPUS                (4)
+#define EXTIOI_CPUS                (256)
 /* map to ipnum per 32 irqs */
 #define EXTIOI_IRQS_IPMAP_SIZE     (256 / 32)
 #define EXTIOI_IRQS_COREMAP_SIZE   256
@@ -59,13 +59,16 @@
 #define EXTIOI_VIRT_COREMAP_START    (0x40)
 #define EXTIOI_VIRT_COREMAP_END      (0x240)
 
+#define EXTIOI_SW_COREMAP_FLAG       (1 << 0)
+
 typedef struct ExtIOICore {
     uint32_t coreisr[EXTIOI_IRQS_GROUP_COUNT];
     DECLARE_BITMAP(sw_isr[LS3A_INTC_IP], EXTIOI_IRQS);
     qemu_irq parent_irq[LS3A_INTC_IP];
 } ExtIOICore;
 
-#define TYPE_LOONGARCH_EXTIOI "loongarch.extioi"
+#define TYPE_LOONGARCH_EXTIOI        "loongarch-extioi"
+#define TYPE_KVM_LOONGARCH_EXTIOI    "loongarch-kvm-extioi"
 OBJECT_DECLARE_SIMPLE_TYPE(LoongArchExtIOI, LOONGARCH_EXTIOI)
 struct LoongArchExtIOI {
     SysBusDevice parent_obj;
@@ -87,4 +90,31 @@ struct LoongArchExtIOI {
     MemoryRegion extioi_system_mem;
     MemoryRegion virt_extend;
 };
+
+struct KVMLoongArchExtIOI {
+    SysBusDevice parent_obj;
+    /* hardware state */
+    uint32_t nodetype[EXTIOI_IRQS_NODETYPE_COUNT / 2];
+    uint32_t bounce[EXTIOI_IRQS_GROUP_COUNT];
+    uint32_t isr[EXTIOI_IRQS / 32];
+    uint32_t coreisr[EXTIOI_CPUS][EXTIOI_IRQS_GROUP_COUNT];
+    uint32_t enable[EXTIOI_IRQS / 32];
+    uint32_t ipmap[EXTIOI_IRQS_IPMAP_SIZE / 4];
+    uint32_t coremap[EXTIOI_IRQS / 4];
+    uint8_t  sw_coremap[EXTIOI_IRQS];
+};
+typedef struct KVMLoongArchExtIOI KVMLoongArchExtIOI;
+DECLARE_INSTANCE_CHECKER(KVMLoongArchExtIOI, KVM_LOONGARCH_EXTIOI,
+                         TYPE_KVM_LOONGARCH_EXTIOI)
+
+struct KVMLoongArchExtIOIClass {
+    SysBusDeviceClass parent_class;
+    DeviceRealize parent_realize;
+
+    bool is_created;
+    int dev_fd;
+};
+typedef struct KVMLoongArchExtIOIClass KVMLoongArchExtIOIClass;
+DECLARE_CLASS_CHECKERS(KVMLoongArchExtIOIClass, KVM_LOONGARCH_EXTIOI,
+                       TYPE_KVM_LOONGARCH_EXTIOI)
 #endif /* LOONGARCH_EXTIOI_H */
diff --git a/include/hw/loongarch/virt.h b/include/hw/loongarch/virt.h
index 8fdfacf268..3f658356fa 100644
--- a/include/hw/loongarch/virt.h
+++ b/include/hw/loongarch/virt.h
@@ -37,6 +37,21 @@
 
 #define FDT_BASE                0x100000
 
+/* KVM_IRQ_LINE irq field index values */
+#define KVM_LOONGARCH_IRQ_TYPE_SHIFT            24
+#define KVM_LOONGARCH_IRQ_TYPE_MASK             0xff
+#define KVM_LOONGARCH_IRQ_VCPU_SHIFT            16
+#define KVM_LOONGARCH_IRQ_VCPU_MASK             0xff
+#define KVM_LOONGARCH_IRQ_NUM_SHIFT             0
+#define KVM_LOONGARCH_IRQ_NUM_MASK              0xffff
+
+/* irq_type field */
+#define KVM_LOONGARCH_IRQ_TYPE_CPU_IP           0
+#define KVM_LOONGARCH_IRQ_TYPE_CPU_IO           1
+#define KVM_LOONGARCH_IRQ_TYPE_HT               2
+#define KVM_LOONGARCH_IRQ_TYPE_MSI              3
+#define KVM_LOONGARCH_IRQ_TYPE_IOAPIC           4
+
 struct LoongArchVirtMachineState {
     /*< private >*/
     MachineState parent_obj;
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index 91c6f591fb..c71221d1b0 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -109,4 +109,5 @@ struct kvm_iocsr_entry {
 #define KVM_MAX_CORES		256
 
 #define KVM_DEV_LOONGARCH_IPI_GRP_REGS		1
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS	1
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 3714ff1a94..1dca283ecd 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1140,6 +1140,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_LA_IPI,
 #define KVM_DEV_TYPE_LA_IPI		KVM_DEV_TYPE_LA_IPI
+	KVM_DEV_TYPE_LA_EXTIOI,
+#define KVM_DEV_TYPE_LA_EXTIOI		KVM_DEV_TYPE_LA_EXTIOI
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.39.1


