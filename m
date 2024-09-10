Return-Path: <kvm+bounces-26264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F38E7973787
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23F331C2525A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286D51922EB;
	Tue, 10 Sep 2024 12:36:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C309E1917F6
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971788; cv=none; b=iyOJUKs5b8MFNCJHx6Ibp5DrSUOpmU4C60dsduDwEihmPauWyR9IvkqIc0wBvs6O/WGiCEtG/XvTV5fh9jrzJYLOTkxCZFPSRyFDPT61cRvo/DD9fBd2n9rl72kOETqNLkn0qknGdJEni6hWzoysMbLGxfnWFFiu6xOdrnNLG+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971788; c=relaxed/simple;
	bh=jEHWujaR/6Id0Mda1zToipvSoWwHbCg0aMS0Lf5OJqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PQFoZbD577d1WXvwStRfDg42PTZSjVdbmGMoeraSNU53TAAbldh38j9QpGror9AbclUJnZY55AvgSaECYiZdbzA7QKBZnH+DuokN4QON0eUJz9auaon4wA83pfuL4eh0pfLRIIJ8H2NPGT1OKaV5vYPvGJ73a6LxDfNeU1p9wxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxrupJPeBmf7kDAA--.9334S3;
	Tue, 10 Sep 2024 20:36:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMBx+cVCPeBmXGoDAA--.15753S7;
	Tue, 10 Sep 2024 20:36:24 +0800 (CST)
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
Subject: [RFC PATCH V2 5/5] hw/loongarch: Add KVM pch msi device support
Date: Tue, 10 Sep 2024 20:18:32 +0800
Message-Id: <8c81313bd4a5c53db5c889f19c9415994a9e007d.1725969898.git.lixianglai@loongson.cn>
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
X-CM-TRANSID:qciowMBx+cVCPeBmXGoDAA--.15753S7
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Added pch_msi interrupt controller handling
during kernel emulation of irq chip.

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

 hw/intc/loongarch_pch_msi.c | 42 +++++++++++++++++++++++++++----------
 hw/loongarch/virt.c         | 26 +++++++++++++----------
 target/loongarch/kvm/kvm.c  |  1 -
 3 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/hw/intc/loongarch_pch_msi.c b/hw/intc/loongarch_pch_msi.c
index ecf3ed0267..bab6f852f8 100644
--- a/hw/intc/loongarch_pch_msi.c
+++ b/hw/intc/loongarch_pch_msi.c
@@ -2,7 +2,7 @@
 /*
  * QEMU Loongson 7A1000 msi interrupt controller.
  *
- * Copyright (C) 2021 Loongson Technology Corporation Limited
+ * Copyright (C) 2024 Loongson Technology Corporation Limited
  */
 
 #include "qemu/osdep.h"
@@ -14,6 +14,8 @@
 #include "hw/misc/unimp.h"
 #include "migration/vmstate.h"
 #include "trace.h"
+#include "sysemu/kvm.h"
+#include "hw/loongarch/virt.h"
 
 static uint64_t loongarch_msi_mem_read(void *opaque, hwaddr addr, unsigned size)
 {
@@ -26,14 +28,24 @@ static void loongarch_msi_mem_write(void *opaque, hwaddr addr,
     LoongArchPCHMSI *s = (LoongArchPCHMSI *)opaque;
     int irq_num;
 
-    /*
-     * vector number is irq number from upper extioi intc
-     * need subtract irq base to get msi vector offset
-     */
-    irq_num = (val & 0xff) - s->irq_base;
-    trace_loongarch_msi_set_irq(irq_num);
-    assert(irq_num < s->irq_num);
-    qemu_set_irq(s->pch_msi_irq[irq_num], 1);
+    MSIMessage msg = {
+        .address = addr,
+        .data = val,
+    };
+
+    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
+        kvm_irqchip_send_msi(kvm_state, msg);
+    } else {
+        /*
+         * vector number is irq number from upper extioi intc
+         * need subtract irq base to get msi vector offset
+         */
+        irq_num = (val & 0xff) - s->irq_base;
+        trace_loongarch_msi_set_irq(irq_num);
+        assert(irq_num < s->irq_num);
+
+        qemu_set_irq(s->pch_msi_irq[irq_num], 1);
+    }
 }
 
 static const MemoryRegionOps loongarch_pch_msi_ops = {
@@ -45,8 +57,16 @@ static const MemoryRegionOps loongarch_pch_msi_ops = {
 static void pch_msi_irq_handler(void *opaque, int irq, int level)
 {
     LoongArchPCHMSI *s = LOONGARCH_PCH_MSI(opaque);
-
-    qemu_set_irq(s->pch_msi_irq[irq], level);
+    MSIMessage msg = {
+        .address = 0,
+        .data = irq,
+    };
+
+    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
+        kvm_irqchip_send_msi(kvm_state, msg);
+    } else {
+        qemu_set_irq(s->pch_msi_irq[irq], level);
+    }
 }
 
 static void loongarch_pch_msi_realize(DeviceState *dev, Error **errp)
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index db0c08899b..b42cf7e5af 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -887,24 +887,28 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
         for (i = 0; i < num; i++) {
             qdev_connect_gpio_out(DEVICE(d), i, qdev_get_gpio_in(extioi, i));
         }
+    }
 
-        /* Add PCH PIC node */
-        fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
+    /* Add PCH PIC node */
+    fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
 
-        pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
-        start   =  num;
-        num = EXTIOI_IRQS - start;
-        qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
-        qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
-        d = SYS_BUS_DEVICE(pch_msi);
-        sysbus_realize_and_unref(d, &error_fatal);
-        sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
+    pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
+    num = VIRT_PCH_PIC_IRQ_NUM;
+    start   =  num;
+    num = EXTIOI_IRQS - start;
+    qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
+    qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
+    d = SYS_BUS_DEVICE(pch_msi);
+    sysbus_realize_and_unref(d, &error_fatal);
+
+    if (!(kvm_enabled() && kvm_irqchip_in_kernel())) {
+        /* Connect pch_msi irqs to extioi */
         for (i = 0; i < num; i++) {
-            /* Connect pch_msi irqs to extioi */
             qdev_connect_gpio_out(DEVICE(d), i,
                                   qdev_get_gpio_in(extioi, i + start));
         }
     }
+    sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
 
     /* Add PCH MSI node */
     fdt_add_pch_msi_node(lvms, &eiointc_phandle, &pch_msi_phandle);
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index c07dcfd85f..e1be6a6959 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -719,7 +719,6 @@ int kvm_arch_get_default_type(MachineState *ms)
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
-    s->kernel_irqchip_allowed = false;
     cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
     return 0;
 }
-- 
2.39.1


