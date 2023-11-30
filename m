Return-Path: <kvm+bounces-2957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F33F17FF213
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADC02282E35
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D071A482CB;
	Thu, 30 Nov 2023 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YCpFVBr6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E21B5
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354925; x=1732890925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f8dzVIiaV15FUJhTAcShJBTihquI/MGo+GvFSgqbGOs=;
  b=YCpFVBr6n2t/Aq77RLSNbdfBF3e8MnBBnXxZaQeGMS58f5ZWT8cou6kV
   FZfEkpfh/G4c+xkaCP6tCbwtTGVivbIjq7RAtz/WakKy99/GVGn5V4KeU
   k7WkLHdEXrTYajfRYLvWfhgb1T5hN5Vf+oevP1hCznCRSfF0WwM7T6iyB
   Egg8qFH3Zorz89lxsld9j+KTCOWOpFNfpiagyp1MQYKpktJozz8SD7QWa
   DurKcjvqz/fVtw0IQCA7auMEsg4JjAMBk8pQ8nS+/N2/ja0QB1ZykMEi/
   Ruie2xAPhqaj5dI5/JCCoxyqs8D1tB1UrHSi3WZ4sYBxH2RA20SfgDEDV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532407"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532407"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:35:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730271"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730271"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:35:15 -0800
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
Subject: [RFC 31/41] hw/machine: Plug cpu-slot into machine to maintain topology tree
Date: Thu, 30 Nov 2023 22:41:53 +0800
Message-Id: <20231130144203.2307629-32-zhao1.liu@linux.intel.com>
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

Add a cpu-slot in machine as the root of topology tree to maintain the
QOM topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-slot.c         | 31 +++++++++++++++++++++++++++++++
 include/hw/boards.h        |  2 ++
 include/hw/core/cpu-slot.h |  7 +++++++
 system/vl.c                |  2 ++
 4 files changed, 42 insertions(+)

diff --git a/hw/core/cpu-slot.c b/hw/core/cpu-slot.c
index 2a796ad5b6e7..4b148440ed3d 100644
--- a/hw/core/cpu-slot.c
+++ b/hw/core/cpu-slot.c
@@ -20,6 +20,7 @@
 
 #include "qemu/osdep.h"
 
+#include "hw/boards.h"
 #include "hw/core/cpu-slot.h"
 #include "qapi/error.h"
 
@@ -165,3 +166,33 @@ static void cpu_slot_register_types(void)
 }
 
 type_init(cpu_slot_register_types)
+
+void machine_plug_cpu_slot(MachineState *ms)
+{
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+
+    ms->topo = CPU_SLOT(qdev_new(TYPE_CPU_SLOT));
+
+    object_property_add_child(container_get(OBJECT(ms), "/peripheral"),
+                              "cpu-slot", OBJECT(ms->topo));
+    DEVICE(ms->topo)->id = g_strdup_printf("%s", "cpu-slot");
+
+    qdev_realize_and_unref(DEVICE(ms->topo), NULL, &error_abort);
+    ms->topo->ms = ms;
+
+    if (!mc->smp_props.clusters_supported) {
+        clear_bit(CPU_TOPO_CLUSTER, ms->topo->supported_levels);
+    }
+
+    if (!mc->smp_props.dies_supported) {
+        clear_bit(CPU_TOPO_DIE, ms->topo->supported_levels);
+    }
+
+    if (!mc->smp_props.books_supported) {
+        clear_bit(CPU_TOPO_BOOK, ms->topo->supported_levels);
+    }
+
+    if (!mc->smp_props.drawers_supported) {
+        clear_bit(CPU_TOPO_DRAWER, ms->topo->supported_levels);
+    }
+}
diff --git a/include/hw/boards.h b/include/hw/boards.h
index da85f86efb91..81a7b04ece86 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -10,6 +10,7 @@
 #include "qemu/module.h"
 #include "qom/object.h"
 #include "hw/core/cpu.h"
+#include "hw/core/cpu-slot.h"
 
 #define TYPE_MACHINE_SUFFIX "-machine"
 
@@ -398,6 +399,7 @@ struct MachineState {
     AccelState *accelerator;
     CPUArchIdList *possible_cpus;
     CpuTopology smp;
+    CPUSlot *topo;
     struct NVDIMMState *nvdimms_state;
     struct NumaState *numa_state;
 };
diff --git a/include/hw/core/cpu-slot.h b/include/hw/core/cpu-slot.h
index 7bf51988afb3..1361af4ccfc0 100644
--- a/include/hw/core/cpu-slot.h
+++ b/include/hw/core/cpu-slot.h
@@ -78,6 +78,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
  *     when necessary.
  * @stat: Statistical topology information for topology tree.
  * @supported_levels: Supported topology levels for topology tree.
+ * @ms: Machine in which this cpu-slot is plugged.
  */
 struct CPUSlot {
     /*< private >*/
@@ -87,6 +88,12 @@ struct CPUSlot {
     QTAILQ_HEAD(, CPUCore) cores;
     CPUTopoStat stat;
     DECLARE_BITMAP(supported_levels, USER_AVAIL_LEVEL_NUM);
+    MachineState *ms;
 };
 
+#define MACHINE_CORE_FOREACH(ms, core) \
+    QTAILQ_FOREACH((core), &(ms)->topo->cores, node)
+
+void machine_plug_cpu_slot(MachineState *ms);
+
 #endif /* CPU_SLOT_H */
diff --git a/system/vl.c b/system/vl.c
index 65add2fb2460..637f708d2265 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -2128,6 +2128,8 @@ static void qemu_create_machine(QDict *qdict)
                                           false, &error_abort);
         qobject_unref(default_opts);
     }
+
+    machine_plug_cpu_slot(current_machine);
 }
 
 static int global_init_func(void *opaque, QemuOpts *opts, Error **errp)
-- 
2.34.1


