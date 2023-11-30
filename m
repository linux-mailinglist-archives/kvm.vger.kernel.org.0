Return-Path: <kvm+bounces-2940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5207FF1EB
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:33:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A9AF1C20DD1
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920CF51C36;
	Thu, 30 Nov 2023 14:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4wyMVjf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056F693
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354776; x=1732890776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ISMaXqLtdhEuyYCRvB604LjEvb5pWdCfmnGTYVK8V4c=;
  b=M4wyMVjfLOaX51ESNLdJy7fwspdP8Q0gy3XFYPEU7w8SlYVVUaiOCG+g
   s/qeuYh0UgCKoQOW/PKwSQjAmGVlicvbx8ND8k4nws9lpQLROYSd1hkff
   BZSo19KY4GthMK4pkksTA9zmw9OWGHfl2UB2JurAoIMBjTqbrX7SGe7lX
   g0J5EQcW3Qiv9W9L0EgrnD/nnw+cz5y2p24TllcwOnmMmWPrLBLTFBVlz
   bOUZt7PnD1uvXEhZKyISwvzzCBAQhM55ZpNyDH7z8qSEVNoYVGZmyYZkV
   y21BIgJYZjgismQAKZhg9pjplkFwzAhr2Hzb+HZv/NnOzJoMQaQYFV/pX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531743"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531743"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:32:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729902"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729902"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:32:36 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 14/41] PPC/ppc-core: Offload core-id to PPC specific core abstarction
Date: Thu, 30 Nov 2023 22:41:36 +0800
Message-Id: <20231130144203.2307629-15-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
References: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

PPC (spapr) supports hotplugs at the core granularity (spapr core) and
treats core-id as the global id for all cores.

But other architectures that support hotplugging at CPU granularity,
use core-id as the local id to indicate the core within the parent
topology container instand of the global index.

To remove potential ambiguity and make the core abstraction available to
other architectures, introduce the ppc core abstraction and define the
"global" core-id over the ppc specific core.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS                     |  2 +
 hw/cpu/core.c                   | 29 ------------
 hw/ppc/meson.build              |  1 +
 hw/ppc/pnv.c                    |  6 +--
 hw/ppc/pnv_core.c               |  5 ++-
 hw/ppc/ppc_core.c               | 79 +++++++++++++++++++++++++++++++++
 hw/ppc/spapr.c                  | 28 +++++++-----
 hw/ppc/spapr_cpu_core.c         |  6 +--
 include/hw/cpu/core.h           |  6 ---
 include/hw/ppc/pnv_core.h       |  8 ++--
 include/hw/ppc/ppc_core.h       | 57 ++++++++++++++++++++++++
 include/hw/ppc/spapr_cpu_core.h |  9 ++--
 12 files changed, 175 insertions(+), 61 deletions(-)
 create mode 100644 hw/ppc/ppc_core.c
 create mode 100644 include/hw/ppc/ppc_core.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 564cb776ae80..89e350866d6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1501,6 +1501,8 @@ F: include/hw/ppc/fdt.h
 F: hw/ppc/fdt.c
 F: include/hw/ppc/pef.h
 F: hw/ppc/pef.c
+F: include/hw/ppc/ppc_core.h
+F: hw/ppc/ppc_core.c
 F: pc-bios/slof.bin
 F: docs/system/ppc/pseries.rst
 F: docs/specs/ppc-spapr-*
diff --git a/hw/cpu/core.c b/hw/cpu/core.c
index 495a5c30ffe1..7e274d6aebb7 100644
--- a/hw/cpu/core.c
+++ b/hw/cpu/core.c
@@ -14,33 +14,6 @@
 #include "qapi/error.h"
 #include "qapi/visitor.h"
 
-static void core_prop_get_core_id(Object *obj, Visitor *v, const char *name,
-                                  void *opaque, Error **errp)
-{
-    CPUCore *core = CPU_CORE(obj);
-    int64_t value = core->core_id;
-
-    visit_type_int(v, name, &value, errp);
-}
-
-static void core_prop_set_core_id(Object *obj, Visitor *v, const char *name,
-                                  void *opaque, Error **errp)
-{
-    CPUCore *core = CPU_CORE(obj);
-    int64_t value;
-
-    if (!visit_type_int(v, name, &value, errp)) {
-        return;
-    }
-
-    if (value < 0) {
-        error_setg(errp, "Invalid core id %"PRId64, value);
-        return;
-    }
-
-    core->core_id = value;
-}
-
 static void core_prop_get_nr_threads(Object *obj, Visitor *v, const char *name,
                                      void *opaque, Error **errp)
 {
@@ -82,8 +55,6 @@ static void cpu_core_class_init(ObjectClass *oc, void *data)
     DeviceClass *dc = DEVICE_CLASS(oc);
 
     set_bit(DEVICE_CATEGORY_CPU, dc->categories);
-    object_class_property_add(oc, "core-id", "int", core_prop_get_core_id,
-                              core_prop_set_core_id, NULL, NULL);
     object_class_property_add(oc, "nr-threads", "int", core_prop_get_nr_threads,
                               core_prop_set_nr_threads, NULL, NULL);
 }
diff --git a/hw/ppc/meson.build b/hw/ppc/meson.build
index ea44856d43b0..2b40a91a4661 100644
--- a/hw/ppc/meson.build
+++ b/hw/ppc/meson.build
@@ -2,6 +2,7 @@ ppc_ss = ss.source_set()
 ppc_ss.add(files(
   'ppc.c',
   'ppc_booke.c',
+  'ppc_core.c',
 ))
 ppc_ss.add(when: 'CONFIG_FDT_PPC', if_true: [files(
   'fdt.c',
diff --git a/hw/ppc/pnv.c b/hw/ppc/pnv.c
index 0297871bdd5d..6e92ff8b4f64 100644
--- a/hw/ppc/pnv.c
+++ b/hw/ppc/pnv.c
@@ -1224,7 +1224,7 @@ static void pnv_chip_icp_realize(Pnv8Chip *chip8, Error **errp)
     /* Map the ICP registers for each thread */
     for (i = 0; i < chip->nr_cores; i++) {
         PnvCore *pnv_core = chip->cores[i];
-        int core_hwid = CPU_CORE(pnv_core)->core_id;
+        int core_hwid = POWERPC_CORE(pnv_core)->core_id;
 
         for (j = 0; j < CPU_CORE(pnv_core)->nr_threads; j++) {
             uint32_t pir = pcc->core_pir(chip, core_hwid) + j;
@@ -1443,7 +1443,7 @@ static void pnv_chip_quad_realize_one(PnvChip *chip, PnvQuad *eq,
                                       const char *type)
 {
     char eq_name[32];
-    int core_id = CPU_CORE(pnv_core)->core_id;
+    int core_id = POWERPC_CORE(pnv_core)->core_id;
 
     snprintf(eq_name, sizeof(eq_name), "eq[%d]", core_id);
     object_initialize_child_with_props(OBJECT(chip), eq_name, eq,
@@ -1983,7 +1983,7 @@ static void pnv_chip_core_realize(PnvChip *chip, Error **errp)
         chip->cores[i] = pnv_core;
         object_property_set_int(OBJECT(pnv_core), "nr-threads",
                                 chip->nr_threads, &error_fatal);
-        object_property_set_int(OBJECT(pnv_core), CPU_CORE_PROP_CORE_ID,
+        object_property_set_int(OBJECT(pnv_core), POWERPC_CORE_PROP_CORE_ID,
                                 core_hwid, &error_fatal);
         object_property_set_int(OBJECT(pnv_core), "pir",
                                 pcc->core_pir(chip, core_hwid), &error_fatal);
diff --git a/hw/ppc/pnv_core.c b/hw/ppc/pnv_core.c
index 8c7afe037f00..a90d1ec92bd8 100644
--- a/hw/ppc/pnv_core.c
+++ b/hw/ppc/pnv_core.c
@@ -267,6 +267,7 @@ static void pnv_core_realize(DeviceState *dev, Error **errp)
     PnvCore *pc = PNV_CORE(OBJECT(dev));
     PnvCoreClass *pcc = PNV_CORE_GET_CLASS(pc);
     CPUCore *cc = CPU_CORE(OBJECT(dev));
+    PowerPCCore *ppc = POWERPC_CORE(cc);
     const char *typename = pnv_core_cpu_typename(pc);
     Error *local_err = NULL;
     void *obj;
@@ -299,7 +300,7 @@ static void pnv_core_realize(DeviceState *dev, Error **errp)
         }
     }
 
-    snprintf(name, sizeof(name), "xscom-core.%d", cc->core_id);
+    snprintf(name, sizeof(name), "xscom-core.%d", ppc->core_id);
     pnv_xscom_region_init(&pc->xscom_regs, OBJECT(dev), pcc->xscom_ops,
                           pc, name, pcc->xscom_size);
 
@@ -392,7 +393,7 @@ static void pnv_core_class_init(ObjectClass *oc, void *data)
 static const TypeInfo pnv_core_infos[] = {
     {
         .name           = TYPE_PNV_CORE,
-        .parent         = TYPE_CPU_CORE,
+        .parent         = TYPE_POWERPC_CORE,
         .instance_size  = sizeof(PnvCore),
         .class_size     = sizeof(PnvCoreClass),
         .class_init = pnv_core_class_init,
diff --git a/hw/ppc/ppc_core.c b/hw/ppc/ppc_core.c
new file mode 100644
index 000000000000..4433b54af506
--- /dev/null
+++ b/hw/ppc/ppc_core.c
@@ -0,0 +1,79 @@
+/*
+ * Common PPC CPU core abstraction
+ *
+ * Copyright (c) 2023 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+
+#include "hw/ppc/ppc_core.h"
+#include "qapi/error.h"
+#include "qapi/visitor.h"
+
+static void powerpc_core_prop_get_core_id(Object *obj, Visitor *v,
+                                          const char *name, void *opaque,
+                                          Error **errp)
+{
+    PowerPCCore *core = POWERPC_CORE(obj);
+    int64_t value = core->core_id;
+
+    visit_type_int(v, name, &value, errp);
+}
+
+static void powerpc_core_prop_set_core_id(Object *obj, Visitor *v,
+                                          const char *name, void *opaque,
+                                          Error **errp)
+{
+    PowerPCCore *core = POWERPC_CORE(obj);
+    int64_t value;
+
+    if (!visit_type_int(v, name, &value, errp)) {
+        return;
+    }
+
+    if (value < 0) {
+        error_setg(errp, "Invalid core id %"PRId64, value);
+        return;
+    }
+
+    core->core_id = value;
+}
+
+static void powerpc_core_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+
+    object_class_property_add(oc, "core-id", "int",
+                              powerpc_core_prop_get_core_id,
+                              powerpc_core_prop_set_core_id,
+                              NULL, NULL);
+}
+
+static const TypeInfo powerpc_core_type_info = {
+    .name = TYPE_POWERPC_CORE,
+    .parent = TYPE_CPU_CORE,
+    .abstract = true,
+    .class_init = powerpc_core_class_init,
+    .instance_size = sizeof(PowerPCCore),
+};
+
+static void powerpc_core_register_types(void)
+{
+    type_register_static(&powerpc_core_type_info);
+}
+
+type_init(powerpc_core_register_types)
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index df09aa9d6a00..72e9f49da110 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -2713,7 +2713,7 @@ static void spapr_init_cpus(SpaprMachineState *spapr)
 
             object_property_set_int(core, "nr-threads", nr_threads,
                                     &error_fatal);
-            object_property_set_int(core, CPU_CORE_PROP_CORE_ID, core_id,
+            object_property_set_int(core, POWERPC_CORE_PROP_CORE_ID, core_id,
                                     &error_fatal);
             qdev_realize(DEVICE(core), NULL, &error_fatal);
 
@@ -3889,7 +3889,8 @@ static void spapr_core_unplug(HotplugHandler *hotplug_dev, DeviceState *dev)
     MachineState *ms = MACHINE(hotplug_dev);
     SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(ms);
     CPUCore *cc = CPU_CORE(dev);
-    CPUArchId *core_slot = spapr_find_cpu_slot(ms, cc->core_id, NULL);
+    PowerPCCore *ppc = POWERPC_CORE(cc);
+    CPUArchId *core_slot = spapr_find_cpu_slot(ms, ppc->core_id, NULL);
 
     if (smc->pre_2_10_has_unused_icps) {
         SpaprCpuCore *sc = SPAPR_CPU_CORE(OBJECT(dev));
@@ -3915,10 +3916,11 @@ void spapr_core_unplug_request(HotplugHandler *hotplug_dev, DeviceState *dev,
     int index;
     SpaprDrc *drc;
     CPUCore *cc = CPU_CORE(dev);
+    PowerPCCore *ppc = POWERPC_CORE(cc);
 
-    if (!spapr_find_cpu_slot(MACHINE(hotplug_dev), cc->core_id, &index)) {
+    if (!spapr_find_cpu_slot(MACHINE(hotplug_dev), ppc->core_id, &index)) {
         error_setg(errp, "Unable to find CPU core with core-id: %d",
-                   cc->core_id);
+                   ppc->core_id);
         return;
     }
     if (index == 0) {
@@ -3927,7 +3929,7 @@ void spapr_core_unplug_request(HotplugHandler *hotplug_dev, DeviceState *dev,
     }
 
     drc = spapr_drc_by_id(TYPE_SPAPR_DRC_CPU,
-                          spapr_vcpu_id(spapr, cc->core_id));
+                          spapr_vcpu_id(spapr, ppc->core_id));
     g_assert(drc);
 
     if (!spapr_drc_unplug_requested(drc)) {
@@ -3985,6 +3987,7 @@ static void spapr_core_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
     SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
     SpaprCpuCore *core = SPAPR_CPU_CORE(OBJECT(dev));
     CPUCore *cc = CPU_CORE(dev);
+    PowerPCCore *ppc = POWERPC_CORE(cc);
     CPUState *cs;
     SpaprDrc *drc;
     CPUArchId *core_slot;
@@ -3992,11 +3995,11 @@ static void spapr_core_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
     bool hotplugged = spapr_drc_hotplugged(dev);
     int i;
 
-    core_slot = spapr_find_cpu_slot(MACHINE(hotplug_dev), cc->core_id, &index);
+    core_slot = spapr_find_cpu_slot(MACHINE(hotplug_dev), ppc->core_id, &index);
     g_assert(core_slot); /* Already checked in spapr_core_pre_plug() */
 
     drc = spapr_drc_by_id(TYPE_SPAPR_DRC_CPU,
-                          spapr_vcpu_id(spapr, cc->core_id));
+                          spapr_vcpu_id(spapr, ppc->core_id));
 
     g_assert(drc || !mc->has_hotpluggable_cpus);
 
@@ -4047,6 +4050,7 @@ static void spapr_core_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
     MachineState *machine = MACHINE(OBJECT(hotplug_dev));
     MachineClass *mc = MACHINE_GET_CLASS(hotplug_dev);
     CPUCore *cc = CPU_CORE(dev);
+    PowerPCCore *ppc = POWERPC_CORE(cc);
     const char *base_core_type = spapr_get_cpu_core_type(machine->cpu_type);
     const char *type = object_get_typename(OBJECT(dev));
     CPUArchId *core_slot;
@@ -4063,8 +4067,8 @@ static void spapr_core_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         return;
     }
 
-    if (cc->core_id % smp_threads) {
-        error_setg(errp, "invalid core id %d", cc->core_id);
+    if (ppc->core_id % smp_threads) {
+        error_setg(errp, "invalid core id %d", ppc->core_id);
         return;
     }
 
@@ -4080,14 +4084,14 @@ static void spapr_core_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         return;
     }
 
-    core_slot = spapr_find_cpu_slot(MACHINE(hotplug_dev), cc->core_id, &index);
+    core_slot = spapr_find_cpu_slot(MACHINE(hotplug_dev), ppc->core_id, &index);
     if (!core_slot) {
-        error_setg(errp, "core id %d out of range", cc->core_id);
+        error_setg(errp, "core id %d out of range", ppc->core_id);
         return;
     }
 
     if (core_slot->cpu) {
-        error_setg(errp, "core %d already populated", cc->core_id);
+        error_setg(errp, "core %d already populated", ppc->core_id);
         return;
     }
 
diff --git a/hw/ppc/spapr_cpu_core.c b/hw/ppc/spapr_cpu_core.c
index 91fae56573ee..7c2ea1424747 100644
--- a/hw/ppc/spapr_cpu_core.c
+++ b/hw/ppc/spapr_cpu_core.c
@@ -292,7 +292,7 @@ static bool spapr_realize_vcpu(PowerPCCPU *cpu, SpaprMachineState *spapr,
 static PowerPCCPU *spapr_create_vcpu(SpaprCpuCore *sc, int i, Error **errp)
 {
     SpaprCpuCoreClass *scc = SPAPR_CPU_CORE_GET_CLASS(sc);
-    CPUCore *cc = CPU_CORE(sc);
+    PowerPCCore *ppc = POWERPC_CORE(sc);
     g_autoptr(Object) obj = NULL;
     g_autofree char *id = NULL;
     CPUState *cs;
@@ -307,7 +307,7 @@ static PowerPCCPU *spapr_create_vcpu(SpaprCpuCore *sc, int i, Error **errp)
      * and the rest are explicitly started up by the guest using an RTAS call.
      */
     cs->start_powered_off = true;
-    cs->cpu_index = cc->core_id + i;
+    cs->cpu_index = ppc->core_id + i;
     if (!spapr_set_vcpu_id(cpu, cs->cpu_index, errp)) {
         return NULL;
     }
@@ -381,7 +381,7 @@ static void spapr_cpu_core_class_init(ObjectClass *oc, void *data)
 static const TypeInfo spapr_cpu_core_type_infos[] = {
     {
         .name = TYPE_SPAPR_CPU_CORE,
-        .parent = TYPE_CPU_CORE,
+        .parent = TYPE_POWERPC_CORE,
         .abstract = true,
         .instance_size = sizeof(SpaprCpuCore),
         .class_size = sizeof(SpaprCpuCoreClass),
diff --git a/include/hw/cpu/core.h b/include/hw/cpu/core.h
index 98ab91647eb2..17f117bd5225 100644
--- a/include/hw/cpu/core.h
+++ b/include/hw/cpu/core.h
@@ -21,13 +21,7 @@ struct CPUCore {
     DeviceState parent_obj;
 
     /*< public >*/
-    int core_id;
     int nr_threads;
 };
 
-/* Note: topology field names need to be kept in sync with
- * 'CpuInstanceProperties' */
-
-#define CPU_CORE_PROP_CORE_ID "core-id"
-
 #endif
diff --git a/include/hw/ppc/pnv_core.h b/include/hw/ppc/pnv_core.h
index 4db21229a68b..56c3f6b51f2f 100644
--- a/include/hw/ppc/pnv_core.h
+++ b/include/hw/ppc/pnv_core.h
@@ -20,9 +20,9 @@
 #ifndef PPC_PNV_CORE_H
 #define PPC_PNV_CORE_H
 
-#include "hw/cpu/core.h"
 #include "target/ppc/cpu.h"
 #include "hw/ppc/pnv.h"
+#include "hw/ppc/ppc_core.h"
 #include "qom/object.h"
 
 #define TYPE_PNV_CORE "powernv-cpu-core"
@@ -31,7 +31,7 @@ OBJECT_DECLARE_TYPE(PnvCore, PnvCoreClass,
 
 struct PnvCore {
     /*< private >*/
-    CPUCore parent_obj;
+    PowerPCCore parent_obj;
 
     /*< public >*/
     PowerPCCPU **threads;
@@ -43,8 +43,10 @@ struct PnvCore {
 };
 
 struct PnvCoreClass {
-    DeviceClass parent_class;
+    /*< private >*/
+    PowerPCCoreClass parent_class;
 
+    /*< public >*/
     const MemoryRegionOps *xscom_ops;
     uint64_t xscom_size;
 };
diff --git a/include/hw/ppc/ppc_core.h b/include/hw/ppc/ppc_core.h
new file mode 100644
index 000000000000..bcc83e426e3f
--- /dev/null
+++ b/include/hw/ppc/ppc_core.h
@@ -0,0 +1,57 @@
+/*
+ * Common PPC CPU core abstraction header
+ *
+ * Copyright (c) 2023 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HW_PPC_CORE_H
+#define HW_PPC_CORE_H
+
+#include "hw/cpu/core.h"
+#include "hw/qdev-core.h"
+#include "qom/object.h"
+
+#define TYPE_POWERPC_CORE "powerpc-core"
+
+OBJECT_DECLARE_TYPE(PowerPCCore, PowerPCCoreClass, POWERPC_CORE)
+
+struct PowerPCCoreClass {
+    /*< private >*/
+    CPUCoreClass parent_class;
+
+    /*< public >*/
+};
+
+struct PowerPCCore {
+    /*< private >*/
+    CPUCore parent_obj;
+
+    /*< public >*/
+    /*
+     * The system-wide id for core, not the sub core-id within the
+     * parent container (which is above the core level).
+     */
+    int core_id;
+};
+
+/*
+ * Note: topology field names need to be kept in sync with
+ * 'CpuInstanceProperties'
+ */
+#define POWERPC_CORE_PROP_CORE_ID "core-id"
+
+#endif /* HW_PPC_CORE_H */
diff --git a/include/hw/ppc/spapr_cpu_core.h b/include/hw/ppc/spapr_cpu_core.h
index 69a52e39b850..db3e515051ca 100644
--- a/include/hw/ppc/spapr_cpu_core.h
+++ b/include/hw/ppc/spapr_cpu_core.h
@@ -9,7 +9,7 @@
 #ifndef HW_SPAPR_CPU_CORE_H
 #define HW_SPAPR_CPU_CORE_H
 
-#include "hw/cpu/core.h"
+#include "hw/ppc/ppc_core.h"
 #include "hw/qdev-core.h"
 #include "target/ppc/cpu-qom.h"
 #include "target/ppc/cpu.h"
@@ -23,7 +23,7 @@ OBJECT_DECLARE_TYPE(SpaprCpuCore, SpaprCpuCoreClass,
 
 struct SpaprCpuCore {
     /*< private >*/
-    CPUCore parent_obj;
+    PowerPCCore parent_obj;
 
     /*< public >*/
     PowerPCCPU **threads;
@@ -32,7 +32,10 @@ struct SpaprCpuCore {
 };
 
 struct SpaprCpuCoreClass {
-    DeviceClass parent_class;
+    /*< private >*/
+    PowerPCCoreClass parent_class;
+
+    /*< public >*/
     const char *cpu_type;
 };
 
-- 
2.34.1


