Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B129254200
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 11:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgH0JX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 05:23:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728400AbgH0JWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 05:22:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B6E1D77AE83A698E6BD4;
        Thu, 27 Aug 2020 17:22:42 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 17:22:33 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v3 10/14] target/riscv: Add sifive_plic vmstate
Date:   Thu, 27 Aug 2020 17:21:33 +0800
Message-ID: <20200827092137.479-11-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200827092137.479-1-jiangyifei@huawei.com>
References: <20200827092137.479-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.187.31]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add sifive_plic vmstate for supporting sifive_plic migration.
Current vmstate framework only supports one structure parameter
as num field to describe variable length arrays, so introduce
num_enables.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 hw/riscv/sifive_plic.c         | 24 +++++++++++++++++++++++-
 include/hw/riscv/sifive_plic.h |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/hw/riscv/sifive_plic.c b/hw/riscv/sifive_plic.c
index 9c5a131e0f..897dc289a0 100644
--- a/hw/riscv/sifive_plic.c
+++ b/hw/riscv/sifive_plic.c
@@ -32,6 +32,7 @@
 #include "hw/riscv/sifive_plic.h"
 #include "sysemu/kvm.h"
 #include "kvm_riscv.h"
+#include "migration/vmstate.h"
 
 #define RISCV_DEBUG_PLIC 0
 
@@ -460,11 +461,12 @@ static void sifive_plic_realize(DeviceState *dev, Error **errp)
                           TYPE_SIFIVE_PLIC, plic->aperture_size);
     parse_hart_config(plic);
     plic->bitfield_words = (plic->num_sources + 31) >> 5;
+    plic->num_enables = plic->bitfield_words * plic->num_addrs;
     plic->source_priority = g_new0(uint32_t, plic->num_sources);
     plic->target_priority = g_new(uint32_t, plic->num_addrs);
     plic->pending = g_new0(uint32_t, plic->bitfield_words);
     plic->claimed = g_new0(uint32_t, plic->bitfield_words);
-    plic->enable = g_new0(uint32_t, plic->bitfield_words * plic->num_addrs);
+    plic->enable = g_new0(uint32_t, plic->num_enables);
     sysbus_init_mmio(SYS_BUS_DEVICE(dev), &plic->mmio);
     qdev_init_gpio_in(dev, sifive_plic_irq_request, plic->num_sources);
 
@@ -484,12 +486,32 @@ static void sifive_plic_realize(DeviceState *dev, Error **errp)
     msi_nonbroken = true;
 }
 
+static const VMStateDescription vmstate_sifive_plic = {
+    .name = "riscv_sifive_plic",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .fields = (VMStateField[]) {
+            VMSTATE_VARRAY_UINT32(source_priority, SiFivePLICState, num_sources, 0,
+                                  vmstate_info_uint32, uint32_t),
+            VMSTATE_VARRAY_UINT32(target_priority, SiFivePLICState, num_addrs, 0,
+                                  vmstate_info_uint32, uint32_t),
+            VMSTATE_VARRAY_UINT32(pending, SiFivePLICState, bitfield_words, 0,
+                                  vmstate_info_uint32, uint32_t),
+            VMSTATE_VARRAY_UINT32(claimed, SiFivePLICState, bitfield_words, 0,
+                                  vmstate_info_uint32, uint32_t),
+            VMSTATE_VARRAY_UINT32(enable, SiFivePLICState, num_enables, 0,
+                                  vmstate_info_uint32, uint32_t),
+            VMSTATE_END_OF_LIST()
+        }
+};
+
 static void sifive_plic_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
 
     device_class_set_props(dc, sifive_plic_properties);
     dc->realize = sifive_plic_realize;
+    dc->vmsd = &vmstate_sifive_plic;
 }
 
 static const TypeInfo sifive_plic_info = {
diff --git a/include/hw/riscv/sifive_plic.h b/include/hw/riscv/sifive_plic.h
index 4421e81249..130df0cf1c 100644
--- a/include/hw/riscv/sifive_plic.h
+++ b/include/hw/riscv/sifive_plic.h
@@ -49,6 +49,7 @@ typedef struct SiFivePLICState {
     MemoryRegion mmio;
     uint32_t num_addrs;
     uint32_t bitfield_words;
+    uint32_t num_enables;
     PLICAddr *addr_config;
     uint32_t *source_priority;
     uint32_t *target_priority;
-- 
2.19.1


