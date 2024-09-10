Return-Path: <kvm+bounces-26262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA807973783
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03A4EB273AF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CCC191F88;
	Tue, 10 Sep 2024 12:36:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEC9191484
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 12:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971787; cv=none; b=ktXQfQt6eywsKunToX0CHZRppb7o6Re8dwMiKgI/7CxgYBbCMpFqo5RLlBS6fhfMb3GVWalRQLZ4MGIum/wTrRs21bHT3y+KvQq14Vte1H5d7nE9jNDuMd/lWZmsapmvzb5ZxuLeqBUozZG/H0MizRKM0ywrHumyuLexV11haLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971787; c=relaxed/simple;
	bh=ttSHtWmp4HDtZ4+pmTms3oqUsWRPHhUMuo+pTn9hbN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kNVousQOpcXUFaiknFFZZygXF9/hhcSykrHVSey9ytKsjt1I4vEndxI85KjXQ7mLlgs6GTwfexWig0AIR36BdT4O7YcMHw1ixZi/VpfkFMsV/8evPBNENq62jP0ZmWPaUA2lqQpWXqjerLOy2N+elrXHgAgJ3TDKVISciWKUtDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxlehGPeBmb7kDAA--.7651S3;
	Tue, 10 Sep 2024 20:36:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMBx+cVCPeBmXGoDAA--.15753S4;
	Tue, 10 Sep 2024 20:36:21 +0800 (CST)
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
Subject: [RFC PATCH V2 2/5] hw/loongarch: Add KVM IPI device support
Date: Tue, 10 Sep 2024 20:18:29 +0800
Message-Id: <b8a6f1958ba09f634bec9ee294815ac047dd1371.1725969898.git.lixianglai@loongson.cn>
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
X-CM-TRANSID:qciowMBx+cVCPeBmXGoDAA--.15753S4
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Added ipi interrupt controller for kvm emulation.
The main process is to send the command word for
creating an ipi device to the kernel.
When the VM is saved, the ioctl obtains the ipi
interrupt controller data in the kernel and saves it.
When the VM is recovered, the saved data is sent to the kernel.

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

 hw/intc/Kconfig               |   3 +
 hw/intc/loongarch_ipi_kvm.c   | 128 ++++++++++++++++++++++++++++++++++
 hw/intc/loongson_ipi_common.c |  28 ++++++++
 hw/intc/meson.build           |   1 +
 hw/loongarch/Kconfig          |   1 +
 hw/loongarch/virt.c           |  40 +++++++----
 target/loongarch/kvm/kvm.c    |   1 +
 7 files changed, 189 insertions(+), 13 deletions(-)
 create mode 100644 hw/intc/loongarch_ipi_kvm.c

diff --git a/hw/intc/Kconfig b/hw/intc/Kconfig
index dd405bdb5d..5201505f23 100644
--- a/hw/intc/Kconfig
+++ b/hw/intc/Kconfig
@@ -98,6 +98,9 @@ config LOONGARCH_IPI
     bool
     select LOONGSON_IPI_COMMON
 
+config LOONGARCH_IPI_KVM
+    bool
+
 config LOONGARCH_PCH_PIC
     bool
     select UNIMP
diff --git a/hw/intc/loongarch_ipi_kvm.c b/hw/intc/loongarch_ipi_kvm.c
new file mode 100644
index 0000000000..74ed83d89f
--- /dev/null
+++ b/hw/intc/loongarch_ipi_kvm.c
@@ -0,0 +1,128 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * LoongArch IPI interrupt support
+ *
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
+ */
+
+#include "qemu/osdep.h"
+#include "hw/boards.h"
+#include "sysemu/kvm.h"
+#include "qapi/error.h"
+#include "hw/intc/loongarch_ipi.h"
+#include "target/loongarch/cpu.h"
+
+static AddressSpace *get_iocsr_as(CPUState *cpu)
+{
+    return LOONGARCH_CPU(cpu)->env.address_space_iocsr;
+}
+
+static void kvm_ipi_access_regs(int fd, uint64_t addr,
+                                uint32_t *val, bool is_write)
+{
+    kvm_device_access(fd, KVM_DEV_LOONGARCH_IPI_GRP_REGS,
+                          addr, val, is_write, &error_abort);
+}
+static void kvm_loongarch_ipi_save_load_regs(void *opaque, bool is_write)
+{
+    LoongsonIPICommonState *ipi = (LoongsonIPICommonState *)opaque;
+    KVMLoongarchIPIState *s = KVM_LOONGARCH_IPI(opaque);
+    IPICore *cpu;
+    uint64_t attr;
+    int cpu_id = 0;
+    int fd = s->dev_fd;
+
+    for (cpu_id = 0; cpu_id < ipi->num_cpu; cpu_id++) {
+        cpu = &ipi->cpu[cpu_id];
+        attr = (cpu_id << 16) | CORE_STATUS_OFF;
+        kvm_ipi_access_regs(fd, attr, &cpu->status, is_write);
+
+        attr = (cpu_id << 16) | CORE_EN_OFF;
+        kvm_ipi_access_regs(fd, attr, &cpu->en, is_write);
+
+        attr = (cpu_id << 16) | CORE_SET_OFF;
+        kvm_ipi_access_regs(fd, attr, &cpu->set, is_write);
+
+        attr = (cpu_id << 16) | CORE_CLEAR_OFF;
+        kvm_ipi_access_regs(fd, attr, &cpu->clear, is_write);
+
+        attr = (cpu_id << 16) | CORE_BUF_20;
+        kvm_ipi_access_regs(fd, attr, &cpu->buf[0], is_write);
+
+        attr = (cpu_id << 16) | CORE_BUF_28;
+        kvm_ipi_access_regs(fd, attr, &cpu->buf[2], is_write);
+
+        attr = (cpu_id << 16) | CORE_BUF_30;
+        kvm_ipi_access_regs(fd, attr, &cpu->buf[4], is_write);
+
+        attr = (cpu_id << 16) | CORE_BUF_38;
+        kvm_ipi_access_regs(fd, attr, &cpu->buf[6], is_write);
+    }
+}
+
+static void kvm_loongarch_ipi_pre_save(LoongsonIPICommonState *opaque)
+{
+    kvm_loongarch_ipi_save_load_regs(opaque, false);
+}
+
+static void kvm_loongarch_ipi_post_load(LoongsonIPICommonState *opaque,
+                                        int version_id)
+{
+    kvm_loongarch_ipi_save_load_regs(opaque, true);
+}
+
+static void kvm_loongarch_ipi_realize(DeviceState *dev, Error **errp)
+{
+    KVMLoongarchIPIState *s = KVM_LOONGARCH_IPI(dev);
+    KVMLoongArchIPIClass *klic = KVM_LOONGARCH_IPI_GET_CLASS(dev);
+    struct kvm_create_device cd = {0};
+    Error *local_err = NULL;
+    int ret;
+
+    klic->parent_realize(dev, &local_err);
+    if (local_err) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+    cd.type = KVM_DEV_TYPE_LOONGARCH_IPI;
+    ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_DEVICE, &cd);
+    if (ret < 0) {
+        error_setg_errno(errp, errno, "Creating the KVM device failed");
+        return;
+    }
+    s->dev_fd = cd.fd;
+}
+
+static void kvm_loongarch_ipi_unrealize(DeviceState *dev)
+{
+    KVMLoongArchIPIClass *klic = KVM_LOONGARCH_IPI_GET_CLASS(dev);
+    klic->parent_unrealize(dev);
+}
+
+static void kvm_loongarch_ipi_class_init(ObjectClass *klass, void *data)
+{
+    LoongsonIPICommonClass *licc = LOONGSON_IPI_COMMON_CLASS(klass);
+    KVMLoongArchIPIClass *klic = KVM_LOONGARCH_IPI_CLASS(klass);
+    DeviceClass *dc = DEVICE_CLASS(klass);
+
+    device_class_set_parent_realize(dc, kvm_loongarch_ipi_realize,
+                                    &klic->parent_realize);
+    device_class_set_parent_unrealize(dc, kvm_loongarch_ipi_unrealize,
+                                    &klic->parent_unrealize);
+
+    licc->get_iocsr_as = get_iocsr_as;
+    licc->cpu_by_arch_id = cpu_by_arch_id;
+    licc->pre_save =  kvm_loongarch_ipi_pre_save;
+    licc->post_load = kvm_loongarch_ipi_post_load;
+}
+
+static const TypeInfo kvm_loongarch_ipi_types[] = {
+    {
+        .name               = TYPE_KVM_LOONGARCH_IPI,
+        .parent             = TYPE_LOONGSON_IPI_COMMON,
+        .class_init         = kvm_loongarch_ipi_class_init,
+    }
+};
+
+DEFINE_TYPES(kvm_loongarch_ipi_types)
diff --git a/hw/intc/loongson_ipi_common.c b/hw/intc/loongson_ipi_common.c
index a6ce0181f6..8b0683bd40 100644
--- a/hw/intc/loongson_ipi_common.c
+++ b/hw/intc/loongson_ipi_common.c
@@ -289,10 +289,38 @@ static void loongson_ipi_common_unrealize(DeviceState *dev)
     g_free(s->cpu);
 }
 
+static int loongson_ipi_pre_save(void *opaque)
+{
+    IPICore *ipicore = (IPICore *)opaque;
+    LoongsonIPICommonState *s = ipicore->ipi;
+    LoongsonIPICommonClass *licc = LOONGSON_IPI_COMMON_GET_CLASS(s);
+
+    if (licc->pre_save) {
+        licc->pre_save(s);
+    }
+
+    return 0;
+}
+
+static int loongson_ipi_post_load(void *opaque, int version_id)
+{
+    IPICore *ipicore = (IPICore *)opaque;
+    LoongsonIPICommonState *s = ipicore->ipi;
+    LoongsonIPICommonClass *licc = LOONGSON_IPI_COMMON_GET_CLASS(s);
+
+    if (licc->post_load) {
+        licc->post_load(s, version_id);
+    }
+
+    return 0;
+}
+
 static const VMStateDescription vmstate_ipi_core = {
     .name = "ipi-single",
     .version_id = 2,
     .minimum_version_id = 2,
+    .pre_save  = loongson_ipi_pre_save,
+    .post_load = loongson_ipi_post_load,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT32(status, IPICore),
         VMSTATE_UINT32(en, IPICore),
diff --git a/hw/intc/meson.build b/hw/intc/meson.build
index f4d81eb8e4..f55eb1b80b 100644
--- a/hw/intc/meson.build
+++ b/hw/intc/meson.build
@@ -72,6 +72,7 @@ specific_ss.add(when: 'CONFIG_M68K_IRQC', if_true: files('m68k_irqc.c'))
 specific_ss.add(when: 'CONFIG_LOONGSON_IPI_COMMON', if_true: files('loongson_ipi_common.c'))
 specific_ss.add(when: 'CONFIG_LOONGSON_IPI', if_true: files('loongson_ipi.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_IPI', if_true: files('loongarch_ipi.c'))
+specific_ss.add(when: 'CONFIG_LOONGARCH_IPI_KVM', if_true: files('loongarch_ipi_kvm.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC', if_true: files('loongarch_pch_pic.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_MSI', if_true: files('loongarch_pch_msi.c'))
 specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI', if_true: files('loongarch_extioi.c'))
diff --git a/hw/loongarch/Kconfig b/hw/loongarch/Kconfig
index 0de713a439..f8fcac3e7b 100644
--- a/hw/loongarch/Kconfig
+++ b/hw/loongarch/Kconfig
@@ -16,6 +16,7 @@ config LOONGARCH_VIRT
     select LOONGARCH_PCH_PIC
     select LOONGARCH_PCH_MSI
     select LOONGARCH_EXTIOI
+    select LOONGARCH_IPI_KVM if KVM
     select LS7A_RTC
     select SMBIOS
     select ACPI_PCI
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 29040422aa..3b28e8e671 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -48,6 +48,7 @@
 #include "hw/block/flash.h"
 #include "hw/virtio/virtio-iommu.h"
 #include "qemu/error-report.h"
+#include "sysemu/kvm.h"
 
 static bool virt_is_veiointc_enabled(LoongArchVirtMachineState *lvms)
 {
@@ -788,15 +789,32 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
      */
 
     /* Create IPI device */
-    ipi = qdev_new(TYPE_LOONGARCH_IPI);
-    qdev_prop_set_uint32(ipi, "num-cpu", ms->smp.cpus);
-    sysbus_realize_and_unref(SYS_BUS_DEVICE(ipi), &error_fatal);
-
-    /* IPI iocsr memory region */
-    memory_region_add_subregion(&lvms->system_iocsr, SMP_IPI_MAILBOX,
-                   sysbus_mmio_get_region(SYS_BUS_DEVICE(ipi), 0));
-    memory_region_add_subregion(&lvms->system_iocsr, MAIL_SEND_ADDR,
-                   sysbus_mmio_get_region(SYS_BUS_DEVICE(ipi), 1));
+    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
+        ipi = qdev_new(TYPE_KVM_LOONGARCH_IPI);
+        qdev_prop_set_int32(ipi, "num-cpu", ms->smp.cpus);
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(ipi), &error_fatal);
+    } else {
+        ipi = qdev_new(TYPE_LOONGARCH_IPI);
+        qdev_prop_set_uint32(ipi, "num-cpu", ms->smp.cpus);
+        sysbus_realize_and_unref(SYS_BUS_DEVICE(ipi), &error_fatal);
+
+        /* IPI iocsr memory region */
+        memory_region_add_subregion(&lvms->system_iocsr, SMP_IPI_MAILBOX,
+                       sysbus_mmio_get_region(SYS_BUS_DEVICE(ipi), 0));
+        memory_region_add_subregion(&lvms->system_iocsr, MAIL_SEND_ADDR,
+                       sysbus_mmio_get_region(SYS_BUS_DEVICE(ipi), 1));
+
+        for (cpu = 0; cpu < ms->smp.cpus; cpu++) {
+            cpu_state = qemu_get_cpu(cpu);
+            cpudev = DEVICE(cpu_state);
+            lacpu = LOONGARCH_CPU(cpu_state);
+            env = &(lacpu->env);
+
+            /* connect ipi irq to cpu irq */
+            qdev_connect_gpio_out(ipi, cpu, qdev_get_gpio_in(cpudev, IRQ_IPI));
+            env->ipistate = ipi;
+        }
+    }
 
     /* Add cpu interrupt-controller */
     fdt_add_cpuic_node(lvms, &cpuintc_phandle);
@@ -807,10 +825,6 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
         lacpu = LOONGARCH_CPU(cpu_state);
         env = &(lacpu->env);
         env->address_space_iocsr = &lvms->as_iocsr;
-
-        /* connect ipi irq to cpu irq */
-        qdev_connect_gpio_out(ipi, cpu, qdev_get_gpio_in(cpudev, IRQ_IPI));
-        env->ipistate = ipi;
     }
 
     /* Create EXTIOI device */
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index e1be6a6959..c07dcfd85f 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -719,6 +719,7 @@ int kvm_arch_get_default_type(MachineState *ms)
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
+    s->kernel_irqchip_allowed = false;
     cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
     return 0;
 }
-- 
2.39.1


