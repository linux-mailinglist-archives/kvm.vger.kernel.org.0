Return-Path: <kvm+bounces-26265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D94B973789
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90E5F1C24BD7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5EC1925B4;
	Tue, 10 Sep 2024 12:36:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7E2191496
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 12:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971789; cv=none; b=ARjCQ4/Jj3521nd5nz1D/K0Qj3M4wCqkT/lPuevgbfLBKKCIDYyLFVmOHMWs1wIJ8RmDzW4jZ/v90YuX6yjvoUJLGxO/4kiJLkSOUbJ01PqO0VNnp/ayYg2y29UwVG356VB1/8ppd+Nyk8akSs+YONyTXpE0uF+ylpCVSFz0GTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971789; c=relaxed/simple;
	bh=wx8pYCyMzI7tRxcwtKJMQZIms2/4FMcnTDwLpJwCIBk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lEfaOLrSErqVQea7rdwYAnLPIUN23MB7hlui5TZP6SBmEFqGQCn1DjpMYprm77x+wzFjUBfZRV1W8eBw/otbcVzKjZQY8qI486CH3WQAoAIiXM5chdK8TOH5gn5l4vuHTlYdd95GGnhsgOvj9RLQPu/VwheuU+L2LEpY/V/hJUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxB+lIPeBmerkDAA--.7696S3;
	Tue, 10 Sep 2024 20:36:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMBx+cVCPeBmXGoDAA--.15753S6;
	Tue, 10 Sep 2024 20:36:23 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	kvm@vger.kernel.org,
	Bibo Mao <maobibo@loongson.cn>
Subject: [RFC PATCH V2 4/5] hw/loongarch: Add KVM pch pic device support
Date: Tue, 10 Sep 2024 20:18:31 +0800
Message-Id: <86f29d4f56b12f826e8a5817cdb1efbfb6007a08.1725969898.git.lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1725969898.git.lixianglai@loongson.cn>
References: <cover.1725969898.git.lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMBx+cVCPeBmXGoDAA--.15753S6
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Added pch_pic interrupt controller for kvm emulation.
The main process is to send the command word for
creating an pch_pic device to the kernel,
Delivers the pch pic interrupt controller configuration
register base address to the kernel.
When the VM is saved, the ioctl obtains the pch_pic
interrupt controller data in the kernel and saves it.
When the VM is recovered, the saved data is sent to the kernel.

Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Song Gao <gaosong@loongson.cn>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>

 hw/intc/Kconfig                 |   3 +
 hw/intc/loongarch_pch_pic.c     |  40 ++++---
 hw/intc/loongarch_pch_pic_kvm.c | 180 ++++++++++++++++++++++++++++++++
 hw/intc/meson.build             |   1 +
 hw/loongarch/Kconfig            |   1 +
 hw/loongarch/virt.c             |  67 ++++++------
 6 files changed, 249 insertions(+), 43 deletions(-)
 create mode 100644 hw/intc/loongarch_pch_pic_kvm.c

diff --git a/hw/intc/Kconfig b/hw/intc/Kconfig
index df9352d41d..1169926eec 100644
--- a/hw/intc/Kconfig
+++ b/hw/intc/Kconfig
@@ -105,6 +105,9 @@ config LOONGARCH_PCH_PIC
     bool
     select UNIMP
 
+config LOONGARCH_PCH_PIC_KVM
+    bool
+
 config LOONGARCH_PCH_MSI
     select MSI_NONBROKEN
     bool
diff --git a/hw/intc/loongarch_pch_pic.c b/hw/intc/loongarch_pch_pic.c
index 2d5e65abff..13934be7d9 100644
--- a/hw/intc/loongarch_pch_pic.c
+++ b/hw/intc/loongarch_pch_pic.c
@@ -16,18 +16,27 @@
 #include "migration/vmstate.h"
 #include "trace.h"
 #include "qapi/error.h"
+#include "sysemu/kvm.h"
 
 static void pch_pic_update_irq(LoongArchPCHPIC *s, uint64_t mask, int level)
 {
     uint64_t val;
     int irq;
+    int kvm_irq;
 
     if (level) {
         val = mask & s->intirr & ~s->int_mask;
         if (val) {
             irq = ctz64(val);
             s->intisr |= MAKE_64BIT_MASK(irq, 1);
-            qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 1);
+            if (kvm_enabled() && kvm_irqchip_in_kernel()) {
+                kvm_irq = (
+                KVM_LOONGARCH_IRQ_TYPE_IOAPIC << KVM_LOONGARCH_IRQ_TYPE_SHIFT)
+                | (0 <<  KVM_LOONGARCH_IRQ_VCPU_SHIFT) | s->htmsi_vector[irq];
+                kvm_set_irq(kvm_state, kvm_irq, !!level);
+            } else {
+                qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 1);
+            }
         }
     } else {
         /*
@@ -38,7 +47,14 @@ static void pch_pic_update_irq(LoongArchPCHPIC *s, uint64_t mask, int level)
         if (val) {
             irq = ctz64(val);
             s->intisr &= ~MAKE_64BIT_MASK(irq, 1);
-            qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 0);
+            if (kvm_enabled() && kvm_irqchip_in_kernel()) {
+                kvm_irq = (
+                KVM_LOONGARCH_IRQ_TYPE_IOAPIC << KVM_LOONGARCH_IRQ_TYPE_SHIFT)
+                | (0 <<  KVM_LOONGARCH_IRQ_VCPU_SHIFT) | s->htmsi_vector[irq];
+                kvm_set_irq(kvm_state, kvm_irq, !!level);
+            } else {
+                qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 0);
+            }
         }
     }
 }
@@ -265,18 +281,18 @@ static uint64_t loongarch_pch_pic_readb(void *opaque, hwaddr addr,
 {
     LoongArchPCHPIC *s = LOONGARCH_PCH_PIC(opaque);
     uint64_t val = 0;
-    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_OFFSET;
+    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_START;
     int64_t offset_tmp;
 
     switch (offset) {
-    case PCH_PIC_HTMSI_VEC_OFFSET ... PCH_PIC_HTMSI_VEC_END:
-        offset_tmp = offset - PCH_PIC_HTMSI_VEC_OFFSET;
+    case PCH_PIC_HTMSI_VEC_START ... PCH_PIC_HTMSI_VEC_END:
+        offset_tmp = offset - PCH_PIC_HTMSI_VEC_START;
         if (offset_tmp >= 0 && offset_tmp < 64) {
             val = s->htmsi_vector[offset_tmp];
         }
         break;
-    case PCH_PIC_ROUTE_ENTRY_OFFSET ... PCH_PIC_ROUTE_ENTRY_END:
-        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_OFFSET;
+    case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
+        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_START;
         if (offset_tmp >= 0 && offset_tmp < 64) {
             val = s->route_entry[offset_tmp];
         }
@@ -294,19 +310,19 @@ static void loongarch_pch_pic_writeb(void *opaque, hwaddr addr,
 {
     LoongArchPCHPIC *s = LOONGARCH_PCH_PIC(opaque);
     int32_t offset_tmp;
-    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_OFFSET;
+    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_START;
 
     trace_loongarch_pch_pic_writeb(size, addr, data);
 
     switch (offset) {
-    case PCH_PIC_HTMSI_VEC_OFFSET ... PCH_PIC_HTMSI_VEC_END:
-        offset_tmp = offset - PCH_PIC_HTMSI_VEC_OFFSET;
+    case PCH_PIC_HTMSI_VEC_START ... PCH_PIC_HTMSI_VEC_END:
+        offset_tmp = offset - PCH_PIC_HTMSI_VEC_START;
         if (offset_tmp >= 0 && offset_tmp < 64) {
             s->htmsi_vector[offset_tmp] = (uint8_t)(data & 0xff);
         }
         break;
-    case PCH_PIC_ROUTE_ENTRY_OFFSET ... PCH_PIC_ROUTE_ENTRY_END:
-        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_OFFSET;
+    case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
+        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_START;
         if (offset_tmp >= 0 && offset_tmp < 64) {
             s->route_entry[offset_tmp] = (uint8_t)(data & 0xff);
         }
diff --git a/hw/intc/loongarch_pch_pic_kvm.c b/hw/intc/loongarch_pch_pic_kvm.c
new file mode 100644
index 0000000000..9b6a2f6784
--- /dev/null
+++ b/hw/intc/loongarch_pch_pic_kvm.c
@@ -0,0 +1,180 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * LoongArch kvm pch pic interrupt support
+ *
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include "qemu/osdep.h"
+#include "hw/qdev-properties.h"
+#include "qemu/typedefs.h"
+#include "hw/intc/loongarch_pch_pic.h"
+#include "hw/sysbus.h"
+#include "linux/kvm.h"
+#include "migration/vmstate.h"
+#include "qapi/error.h"
+#include "sysemu/kvm.h"
+#include "hw/loongarch/virt.h"
+#include "hw/pci-host/ls7a.h"
+#include "qemu/error-report.h"
+
+static void kvm_pch_pic_access_regs(int fd, uint64_t addr,
+                                       void *val, bool is_write)
+{
+        kvm_device_access(fd, KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS,
+                          addr, val, is_write, &error_abort);
+}
+
+static void kvm_loongarch_pch_pic_save_load(void *opaque, bool is_write)
+{
+    KVMLoongArchPCHPIC *s = (KVMLoongArchPCHPIC *)opaque;
+    KVMLoongArchPCHPICClass *class = KVM_LOONGARCH_PCH_PIC_GET_CLASS(s);
+    int fd = class->dev_fd;
+    int addr, offset;
+
+    kvm_pch_pic_access_regs(fd, PCH_PIC_MASK_START,
+                            (void *)&s->int_mask, is_write);
+    kvm_pch_pic_access_regs(fd, PCH_PIC_HTMSI_EN_START,
+                            (void *)&s->htmsi_en, is_write);
+    kvm_pch_pic_access_regs(fd, PCH_PIC_EDGE_START,
+                            (void *)&s->intedge, is_write);
+    kvm_pch_pic_access_regs(fd, PCH_PIC_AUTO_CTRL0_START,
+                            (void *)&s->auto_crtl0, is_write);
+    kvm_pch_pic_access_regs(fd, PCH_PIC_AUTO_CTRL1_START,
+                            (void *)&s->auto_crtl1, is_write);
+
+    for (addr = PCH_PIC_ROUTE_ENTRY_START;
+         addr < PCH_PIC_ROUTE_ENTRY_END; addr++) {
+        offset = addr - PCH_PIC_ROUTE_ENTRY_START;
+        kvm_pch_pic_access_regs(fd, addr,
+                                (void *)&s->route_entry[offset], is_write);
+    }
+
+    for (addr = PCH_PIC_HTMSI_VEC_START; addr < PCH_PIC_HTMSI_VEC_END; addr++) {
+        offset = addr - PCH_PIC_HTMSI_VEC_START;
+        kvm_pch_pic_access_regs(fd, addr,
+                                (void *)&s->htmsi_vector[offset], is_write);
+    }
+
+    kvm_pch_pic_access_regs(fd, PCH_PIC_INT_IRR_START,
+                            (void *)&s->intirr, is_write);
+    kvm_pch_pic_access_regs(fd, PCH_PIC_INT_ISR_START,
+                            (void *)&s->intisr, is_write);
+    kvm_pch_pic_access_regs(fd, PCH_PIC_POLARITY_START,
+                            (void *)&s->int_polarity, is_write);
+}
+
+static int kvm_loongarch_pch_pic_pre_save(void *opaque)
+{
+    kvm_loongarch_pch_pic_save_load(opaque, false);
+    return 0;
+}
+
+static int kvm_loongarch_pch_pic_post_load(void *opaque, int version_id)
+{
+    kvm_loongarch_pch_pic_save_load(opaque, true);
+    return 0;
+}
+
+static void kvm_pch_pic_handler(void *opaque, int irq, int level)
+{
+    int kvm_irq;
+
+    if (kvm_enabled()) {
+        kvm_irq = \
+            (KVM_LOONGARCH_IRQ_TYPE_IOAPIC << KVM_LOONGARCH_IRQ_TYPE_SHIFT)
+            | (0 <<  KVM_LOONGARCH_IRQ_VCPU_SHIFT) | irq;
+        kvm_set_irq(kvm_state, kvm_irq, !!level);
+    }
+}
+
+static void kvm_loongarch_pch_pic_realize(DeviceState *dev, Error **errp)
+{
+    KVMLoongArchPCHPICClass *pch_pic_class =
+            KVM_LOONGARCH_PCH_PIC_GET_CLASS(dev);
+    struct kvm_create_device cd = {0};
+    uint64_t pch_pic_base = VIRT_PCH_REG_BASE;
+    Error *err = NULL;
+    int ret;
+
+    pch_pic_class->parent_realize(dev, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+
+    if (!pch_pic_class->is_created) {
+        cd.type = KVM_DEV_TYPE_LOONGARCH_PCH_PIC;
+        ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_DEVICE, &cd);
+        if (ret < 0) {
+            error_setg_errno(errp, errno,
+                             "Creating the KVM pch pic device failed");
+            return;
+        }
+        pch_pic_class->is_created = true;
+        pch_pic_class->dev_fd = cd.fd;
+        fprintf(stdout, "Create LoongArch pch pic irqchip in KVM done!\n");
+
+        ret = kvm_device_access(cd.fd, KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL,
+                                KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT,
+                                &pch_pic_base, true, NULL);
+        if (ret < 0) {
+            error_report(
+                "KVM PCH_PIC: failed to set the base address of PCH PIC");
+            exit(1);
+        }
+
+        qdev_init_gpio_in(dev, kvm_pch_pic_handler, VIRT_PCH_PIC_IRQ_NUM);
+    }
+}
+
+static const VMStateDescription vmstate_kvm_loongarch_pch_pic = {
+    .name = TYPE_LOONGARCH_PCH_PIC,
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .pre_save = kvm_loongarch_pch_pic_pre_save,
+    .post_load = kvm_loongarch_pch_pic_post_load,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT64(int_mask, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(htmsi_en, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(intedge, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(intclr, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(auto_crtl0, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(auto_crtl1, KVMLoongArchPCHPIC),
+        VMSTATE_UINT8_ARRAY(route_entry, KVMLoongArchPCHPIC, 64),
+        VMSTATE_UINT8_ARRAY(htmsi_vector, KVMLoongArchPCHPIC, 64),
+        VMSTATE_UINT64(last_intirr, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(intirr, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(intisr, KVMLoongArchPCHPIC),
+        VMSTATE_UINT64(int_polarity, KVMLoongArchPCHPIC),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+
+static void kvm_loongarch_pch_pic_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    KVMLoongArchPCHPICClass *pch_pic_class = KVM_LOONGARCH_PCH_PIC_CLASS(oc);
+
+    pch_pic_class->parent_realize = dc->realize;
+    dc->realize = kvm_loongarch_pch_pic_realize;
+    pch_pic_class->is_created = false;
+    dc->vmsd = &vmstate_kvm_loongarch_pch_pic;
+
+}
+
+static const TypeInfo kvm_loongarch_pch_pic_info = {
+    .name = TYPE_KVM_LOONGARCH_PCH_PIC,
+    .parent = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(KVMLoongArchPCHPIC),
+    .class_size = sizeof(KVMLoongArchPCHPICClass),
+    .class_init = kvm_loongarch_pch_pic_class_init,
+};
+
+static void kvm_loongarch_pch_pic_register_types(void)
+{
+    type_register_static(&kvm_loongarch_pch_pic_info);
+}
+
+type_init(kvm_loongarch_pch_pic_register_types)
diff --git a/hw/intc/meson.build b/hw/intc/meson.build
index 85174d1af1..c20c0a2c05 100644
--- a/hw/intc/meson.build
+++ b/hw/intc/meson.build
@@ -77,3 +77,4 @@ specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC', if_true: files('loongarch_pch_
 specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_MSI', if_true: files('loongarch_pch_msi.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI', if_true: files('loongarch_extioi.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI_KVM', if_true: files('loongarch_extioi_kvm.c'))
+specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC_KVM', if_true: files('loongarch_pch_pic_kvm.c'))
diff --git a/hw/loongarch/Kconfig b/hw/loongarch/Kconfig
index 99a523171f..f909f799ad 100644
--- a/hw/loongarch/Kconfig
+++ b/hw/loongarch/Kconfig
@@ -17,6 +17,7 @@ config LOONGARCH_VIRT
     select LOONGARCH_PCH_MSI
     select LOONGARCH_EXTIOI
     select LOONGARCH_IPI_KVM if KVM
+    select LOONGARCH_PCH_PIC_KVM if KVM
     select LOONGARCH_EXTIOI_KVM if KVM
     select LS7A_RTC
     select SMBIOS
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 8ca7c09016..db0c08899b 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -865,40 +865,45 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
     /* Add Extend I/O Interrupt Controller node */
     fdt_add_eiointc_node(lvms, &cpuintc_phandle, &eiointc_phandle);
 
-    pch_pic = qdev_new(TYPE_LOONGARCH_PCH_PIC);
-    num = VIRT_PCH_PIC_IRQ_NUM;
-    qdev_prop_set_uint32(pch_pic, "pch_pic_irq_num", num);
-    d = SYS_BUS_DEVICE(pch_pic);
-    sysbus_realize_and_unref(d, &error_fatal);
-    memory_region_add_subregion(get_system_memory(), VIRT_IOAPIC_REG_BASE,
-                            sysbus_mmio_get_region(d, 0));
-    memory_region_add_subregion(get_system_memory(),
-                            VIRT_IOAPIC_REG_BASE + PCH_PIC_ROUTE_ENTRY_OFFSET,
+    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
+        pch_pic = qdev_new(TYPE_KVM_LOONGARCH_PCH_PIC);
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(pch_pic), &error_fatal);
+    } else {
+        pch_pic = qdev_new(TYPE_LOONGARCH_PCH_PIC);
+        num = VIRT_PCH_PIC_IRQ_NUM;
+        qdev_prop_set_uint32(pch_pic, "pch_pic_irq_num", num);
+        d = SYS_BUS_DEVICE(pch_pic);
+        sysbus_realize_and_unref(d, &error_fatal);
+        memory_region_add_subregion(get_system_memory(), VIRT_IOAPIC_REG_BASE,
+                                sysbus_mmio_get_region(d, 0));
+        memory_region_add_subregion(get_system_memory(),
+                            VIRT_IOAPIC_REG_BASE + PCH_PIC_ROUTE_ENTRY_START,
                             sysbus_mmio_get_region(d, 1));
-    memory_region_add_subregion(get_system_memory(),
-                            VIRT_IOAPIC_REG_BASE + PCH_PIC_INT_STATUS_LO,
-                            sysbus_mmio_get_region(d, 2));
-
-    /* Connect pch_pic irqs to extioi */
-    for (i = 0; i < num; i++) {
-        qdev_connect_gpio_out(DEVICE(d), i, qdev_get_gpio_in(extioi, i));
-    }
+        memory_region_add_subregion(get_system_memory(),
+                                VIRT_IOAPIC_REG_BASE + PCH_PIC_INT_STATUS_LO,
+                                sysbus_mmio_get_region(d, 2));
 
-    /* Add PCH PIC node */
-    fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
+        /* Connect pch_pic irqs to extioi */
+        for (i = 0; i < num; i++) {
+            qdev_connect_gpio_out(DEVICE(d), i, qdev_get_gpio_in(extioi, i));
+        }
 
-    pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
-    start   =  num;
-    num = EXTIOI_IRQS - start;
-    qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
-    qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
-    d = SYS_BUS_DEVICE(pch_msi);
-    sysbus_realize_and_unref(d, &error_fatal);
-    sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
-    for (i = 0; i < num; i++) {
-        /* Connect pch_msi irqs to extioi */
-        qdev_connect_gpio_out(DEVICE(d), i,
-                              qdev_get_gpio_in(extioi, i + start));
+        /* Add PCH PIC node */
+        fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
+
+        pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
+        start   =  num;
+        num = EXTIOI_IRQS - start;
+        qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
+        qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
+        d = SYS_BUS_DEVICE(pch_msi);
+        sysbus_realize_and_unref(d, &error_fatal);
+        sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
+        for (i = 0; i < num; i++) {
+            /* Connect pch_msi irqs to extioi */
+            qdev_connect_gpio_out(DEVICE(d), i,
+                                  qdev_get_gpio_in(extioi, i + start));
+        }
     }
 
     /* Add PCH MSI node */
-- 
2.39.1


