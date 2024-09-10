Return-Path: <kvm+bounces-26263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA79F973784
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66F9A2847CF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63807191F9E;
	Tue, 10 Sep 2024 12:36:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AE019148D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 12:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971787; cv=none; b=W4jvTx7ZJd76LzbAFn2xqSHEXD8XR9fP2Lu1J4/m/aNZvGbZog8yEy0LKrOjqnSzQrubdsQ+rbAm4ZUhvXU1HH82kHMFBYo+ovEZH5AuzE3JTwTg4lxrSs+AcEFHd5VhuwgADM/0th1vCk4K51Y4k+Qla/0XmhpsS91g/qlk/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971787; c=relaxed/simple;
	bh=KBtJpcze//5uQbhFf8SOrRliWY4UfnxzceCJRa219kY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NBLDChkg9Fs/GqanKvaqVWH3PTZFpc7A844K+HuWMEk0vUQEGyN/5X59cyMXptKTYVvXbBXE50gmv22wtftlrdXHVIguIrlIzxCgPgNcHzDNypCVKnODZuyhiU4PWOOlPH8l5O/6ekBb37c1q4qgDffnU0C6nue4Dp79MbzHG5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxpuhHPeBmdLkDAA--.7536S3;
	Tue, 10 Sep 2024 20:36:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMBx+cVCPeBmXGoDAA--.15753S5;
	Tue, 10 Sep 2024 20:36:22 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: qemu-devel@nongnu.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	kvm@vger.kernel.org,
	Bibo Mao <maobibo@loongson.cn>
Subject: [RFC PATCH V2 3/5] hw/loongarch: Add KVM extioi device support
Date: Tue, 10 Sep 2024 20:18:30 +0800
Message-Id: <f359346bb865fcc4d52552c8c0fc27123c858aad.1725969898.git.lixianglai@loongson.cn>
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
X-CM-TRANSID:qciowMBx+cVCPeBmXGoDAA--.15753S5
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
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>

 hw/intc/Kconfig                |   3 +
 hw/intc/loongarch_extioi_kvm.c | 250 +++++++++++++++++++++++++++++++++
 hw/intc/meson.build            |   1 +
 hw/loongarch/Kconfig           |   1 +
 hw/loongarch/virt.c            |  51 ++++---
 5 files changed, 285 insertions(+), 21 deletions(-)
 create mode 100644 hw/intc/loongarch_extioi_kvm.c

diff --git a/hw/intc/Kconfig b/hw/intc/Kconfig
index 5201505f23..df9352d41d 100644
--- a/hw/intc/Kconfig
+++ b/hw/intc/Kconfig
@@ -112,3 +112,6 @@ config LOONGARCH_PCH_MSI
 
 config LOONGARCH_EXTIOI
     bool
+
+config LOONGARCH_EXTIOI_KVM
+    bool
diff --git a/hw/intc/loongarch_extioi_kvm.c b/hw/intc/loongarch_extioi_kvm.c
new file mode 100644
index 0000000000..139a00ac2a
--- /dev/null
+++ b/hw/intc/loongarch_extioi_kvm.c
@@ -0,0 +1,250 @@
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
+                                       void *val, bool is_write)
+{
+        kvm_device_access(fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS,
+                          addr, val, is_write, &error_abort);
+}
+
+static void kvm_extioi_access_sw_status(int fd, uint64_t addr,
+                                       void *val, bool is_write)
+{
+        kvm_device_access(fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS,
+                          addr, val, is_write, &error_abort);
+}
+
+static void kvm_extioi_save_load_sw_status(void *opaque, bool is_write)
+{
+    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
+    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
+    int fd = class->dev_fd;
+    int addr;
+
+    addr = KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU;
+    kvm_extioi_access_sw_status(fd, addr, (void *)&s->num_cpu, is_write);
+
+    addr = KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE;
+    kvm_extioi_access_sw_status(fd, addr, (void *)&s->features, is_write);
+
+    addr = KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE;
+    kvm_extioi_access_sw_status(fd, addr, (void *)&s->status, is_write);
+}
+
+static void kvm_extioi_save_load_regs(void *opaque, bool is_write)
+{
+    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
+    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
+    int fd = class->dev_fd;
+    int addr, offset, cpuid;
+
+    for (addr = EXTIOI_NODETYPE_START; addr < EXTIOI_NODETYPE_END; addr += 4) {
+        offset = (addr - EXTIOI_NODETYPE_START) / 4;
+        kvm_extioi_access_regs(fd, addr,
+                               (void *)&s->nodetype[offset], is_write);
+    }
+
+    for (addr = EXTIOI_IPMAP_START; addr < EXTIOI_IPMAP_END; addr += 4) {
+        offset = (addr - EXTIOI_IPMAP_START) / 4;
+        kvm_extioi_access_regs(fd, addr, (void *)&s->ipmap[offset], is_write);
+    }
+
+    for (addr = EXTIOI_ENABLE_START; addr < EXTIOI_ENABLE_END; addr += 4) {
+        offset = (addr - EXTIOI_ENABLE_START) / 4;
+        kvm_extioi_access_regs(fd, addr,
+                               (void *)&s->enable[offset], is_write);
+    }
+
+    for (addr = EXTIOI_BOUNCE_START; addr < EXTIOI_BOUNCE_END; addr += 4) {
+        offset = (addr - EXTIOI_BOUNCE_START) / 4;
+        kvm_extioi_access_regs(fd, addr,
+                               (void *)&s->bounce[offset], is_write);
+    }
+
+    for (addr = EXTIOI_ISR_START; addr < EXTIOI_ISR_END; addr += 4) {
+        offset = (addr - EXTIOI_ISR_START) / 4;
+        kvm_extioi_access_regs(fd, addr,
+                               (void *)&s->isr[offset], is_write);
+    }
+
+    for (addr = EXTIOI_COREMAP_START; addr < EXTIOI_COREMAP_END; addr += 4) {
+        offset = (addr - EXTIOI_COREMAP_START) / 4;
+        kvm_extioi_access_regs(fd, addr,
+                               (void *)&s->coremap[offset], is_write);
+    }
+
+    for (cpuid = 0; cpuid < s->num_cpu; cpuid++) {
+        for (addr = EXTIOI_COREISR_START;
+             addr < EXTIOI_COREISR_END; addr += 4) {
+            offset = (addr - EXTIOI_COREISR_START) / 4;
+            addr = (cpuid << 16) | addr;
+            kvm_extioi_access_regs(fd, addr,
+                              (void *)&s->coreisr[cpuid][offset], is_write);
+        }
+    }
+}
+
+static int kvm_loongarch_extioi_pre_save(void *opaque)
+{
+    kvm_extioi_save_load_regs(opaque, false);
+    kvm_extioi_save_load_sw_status(opaque, false);
+    return 0;
+}
+
+static int kvm_loongarch_extioi_post_load(void *opaque, int version_id)
+{
+    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
+    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
+    int fd = class->dev_fd;
+
+    kvm_extioi_save_load_regs(opaque, true);
+    kvm_extioi_save_load_sw_status(opaque, true);
+
+    kvm_device_access(fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL,
+                      KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED,
+                      NULL, true, &error_abort);
+    return 0;
+}
+
+static void kvm_loongarch_extioi_realize(DeviceState *dev, Error **errp)
+{
+    KVMLoongArchExtIOIClass *extioi_class = KVM_LOONGARCH_EXTIOI_GET_CLASS(dev);
+    KVMLoongArchExtIOI *s = KVM_LOONGARCH_EXTIOI(dev);
+    struct kvm_create_device cd = {0};
+    Error *err = NULL;
+    int ret, i;
+
+    extioi_class->parent_realize(dev, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+
+    if (s->num_cpu == 0) {
+        error_setg(errp, "num-cpu must be at least 1");
+        return;
+    }
+
+
+    if (extioi_class->is_created) {
+        error_setg(errp, "extioi had be created");
+        return;
+    }
+
+    if (s->features & BIT(EXTIOI_HAS_VIRT_EXTENSION)) {
+        s->features |= EXTIOI_VIRT_HAS_FEATURES;
+    }
+
+    cd.type = KVM_DEV_TYPE_LOONGARCH_EXTIOI;
+    ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_DEVICE, &cd);
+    if (ret < 0) {
+        error_setg_errno(errp, errno,
+                         "Creating the KVM extioi device failed");
+        return;
+    }
+    extioi_class->is_created = true;
+    extioi_class->dev_fd = cd.fd;
+
+    ret = kvm_device_access(cd.fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL,
+                            KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU,
+                            &s->num_cpu, true, NULL);
+    if (ret < 0) {
+        error_setg_errno(errp, errno,
+                         "KVM EXTIOI: failed to set the num-cpu of EXTIOI");
+        exit(1);
+    }
+
+    ret = kvm_device_access(cd.fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL,
+                            KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE,
+                            &s->features, true, NULL);
+    if (ret < 0) {
+        error_setg_errno(errp, errno,
+                         "KVM EXTIOI: failed to set the feature of EXTIOI");
+        exit(1);
+    }
+
+    fprintf(stdout, "Create LoongArch extioi irqchip in KVM done!\n");
+
+    kvm_async_interrupts_allowed = true;
+    kvm_msi_via_irqfd_allowed = kvm_irqfds_enabled();
+    if (kvm_has_gsi_routing()) {
+        for (i = 0; i < 64; ++i) {
+            kvm_irqchip_add_irq_route(kvm_state, i, 0, i);
+        }
+        kvm_gsi_routing_allowed = true;
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
+        VMSTATE_UINT32(features, KVMLoongArchExtIOI),
+        VMSTATE_UINT32(status, KVMLoongArchExtIOI),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static Property extioi_properties[] = {
+    DEFINE_PROP_UINT32("num-cpu", KVMLoongArchExtIOI, num_cpu, 1),
+    DEFINE_PROP_BIT("has-virtualization-extension", KVMLoongArchExtIOI,
+                    features, EXTIOI_HAS_VIRT_EXTENSION, 0),
+    DEFINE_PROP_END_OF_LIST(),
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
+    device_class_set_props(dc, extioi_properties);
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
index f55eb1b80b..85174d1af1 100644
--- a/hw/intc/meson.build
+++ b/hw/intc/meson.build
@@ -76,3 +76,4 @@ specific_ss.add(when: 'CONFIG_LOONGARCH_IPI_KVM', if_true: files('loongarch_ipi_
 specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC', if_true: files('loongarch_pch_pic.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_MSI', if_true: files('loongarch_pch_msi.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI', if_true: files('loongarch_extioi.c'))
+specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI_KVM', if_true: files('loongarch_extioi_kvm.c'))
diff --git a/hw/loongarch/Kconfig b/hw/loongarch/Kconfig
index f8fcac3e7b..99a523171f 100644
--- a/hw/loongarch/Kconfig
+++ b/hw/loongarch/Kconfig
@@ -17,6 +17,7 @@ config LOONGARCH_VIRT
     select LOONGARCH_PCH_MSI
     select LOONGARCH_EXTIOI
     select LOONGARCH_IPI_KVM if KVM
+    select LOONGARCH_EXTIOI_KVM if KVM
     select LS7A_RTC
     select SMBIOS
     select ACPI_PCI
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 3b28e8e671..8ca7c09016 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -828,28 +828,37 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
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
+    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
+        extioi = qdev_new(TYPE_KVM_LOONGARCH_EXTIOI);
+        qdev_prop_set_uint32(extioi, "num-cpu", ms->smp.cpus);
+        if (virt_is_veiointc_enabled(lvms)) {
+            qdev_prop_set_bit(extioi, "has-virtualization-extension", true);
+        }
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(extioi), &error_fatal);
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
 
-- 
2.39.1


