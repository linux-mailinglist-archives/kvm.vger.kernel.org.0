Return-Path: <kvm+bounces-2958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EE4A7FF21A
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CB281C20E7D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F351751034;
	Thu, 30 Nov 2023 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nEiHRxRm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C06196
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354936; x=1732890936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ONngA8TQ7iwdQG2PpHP3CY/JQBJI2+erv4AqH9RU4Wo=;
  b=nEiHRxRm+x9Lvh2D5mp/R8nPCeOKudCG1MzZUJ2pk7p4MbVgWDk+1oI1
   3893LsGnfHbWts/HI+v9XK8TByW5jYxX8MIrRjnJcZ8jTa15eTtXQ+HhY
   RhvLe+443VYZJB2ng7zaJv0/p03ymbiGiSf/kfeTSiN2hQA5zEWr5vToG
   cIBeg9VvoWB9eFu7wgVaC+Ra0kzGH9tDqMX1+36WJgS3g4llBFeA3g8x8
   7C6B0dQIXrHFUDDrYNnGRk97SwZ4HtnqHWA0jdgbS2gQV4c4dk06LNRIc
   1XL8DxialJU1ZeSjBKbTWPzFWpfh3DaLJVGi7cPtslnv21Zkry6CMPD0U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532443"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532443"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:35:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730298"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730298"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:35:24 -0800
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
Subject: [RFC 32/41] hw/machine: Build smp topology tree from -smp
Date: Thu, 30 Nov 2023 22:41:54 +0800
Message-Id: <20231130144203.2307629-33-zhao1.liu@linux.intel.com>
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

For the architecture supports QOM topology (the field
MachineClass.possible_cpus_qom_granu is set), implement smp QOM topology
tree from MachineState.smp.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-slot.c         | 217 +++++++++++++++++++++++++++++++++++++
 hw/core/machine-smp.c      |   9 ++
 hw/cpu/core.c              |   1 -
 include/hw/boards.h        |  11 ++
 include/hw/core/cpu-slot.h |   5 +
 tests/unit/meson.build     |   5 +-
 6 files changed, 246 insertions(+), 2 deletions(-)

diff --git a/hw/core/cpu-slot.c b/hw/core/cpu-slot.c
index 4b148440ed3d..ade155baf60b 100644
--- a/hw/core/cpu-slot.c
+++ b/hw/core/cpu-slot.c
@@ -22,6 +22,11 @@
 
 #include "hw/boards.h"
 #include "hw/core/cpu-slot.h"
+#include "hw/cpu/book.h"
+#include "hw/cpu/cluster.h"
+#include "hw/cpu/die.h"
+#include "hw/cpu/drawer.h"
+#include "hw/cpu/socket.h"
 #include "qapi/error.h"
 
 static inline
@@ -196,3 +201,215 @@ void machine_plug_cpu_slot(MachineState *ms)
         clear_bit(CPU_TOPO_DRAWER, ms->topo->supported_levels);
     }
 }
+
+static unsigned int *get_smp_info_by_level(CpuTopology *smp_info,
+                                           CPUTopoLevel child_level)
+{
+    switch (child_level) {
+    case CPU_TOPO_THREAD:
+        return &smp_info->threads;
+    case CPU_TOPO_CORE:
+        return &smp_info->cores;
+    case CPU_TOPO_CLUSTER:
+        return &smp_info->clusters;
+    case CPU_TOPO_DIE:
+        return &smp_info->dies;
+    case CPU_TOPO_SOCKET:
+        return &smp_info->sockets;
+    case CPU_TOPO_BOOK:
+        return &smp_info->books;
+    case CPU_TOPO_DRAWER:
+        return &smp_info->drawers;
+    default:
+        /* No need to consider CPU_TOPO_UNKNOWN, and CPU_TOPO_ROOT. */
+        g_assert_not_reached();
+    }
+
+    return NULL;
+}
+
+static const char *get_topo_typename_by_level(CPUTopoLevel level)
+{
+    switch (level) {
+    case CPU_TOPO_CORE:
+        return TYPE_CPU_CORE;
+    case CPU_TOPO_CLUSTER:
+        return TYPE_CPU_CLUSTER;
+    case CPU_TOPO_DIE:
+        return TYPE_CPU_DIE;
+    case CPU_TOPO_SOCKET:
+        return TYPE_CPU_SOCKET;
+    case CPU_TOPO_BOOK:
+        return TYPE_CPU_BOOK;
+    case CPU_TOPO_DRAWER:
+        return TYPE_CPU_DRAWER;
+    default:
+        /*
+         * No need to consider CPU_TOPO_UNKNOWN, CPU_TOPO_THREAD
+         * and CPU_TOPO_ROOT.
+         */
+        g_assert_not_reached();
+    }
+
+    return NULL;
+}
+
+static char *get_topo_global_name(CPUTopoStat *stat,
+                                  CPUTopoLevel level)
+{
+    const char *type = NULL;
+    CPUTopoStatEntry *entry;
+
+    type = cpu_topo_level_to_string(level);
+    entry = get_topo_stat_entry(stat, level);
+    return g_strdup_printf("%s[%d]", type, entry->total_units);
+}
+
+typedef struct SMPBuildCbData {
+    unsigned long *supported_levels;
+    unsigned int plugged_cpus;
+    CpuTopology *smp_info;
+    CPUTopoStat *stat;
+    Error **errp;
+} SMPBuildCbData;
+
+static int smp_core_set_threads(Object *core, unsigned int max_threads,
+                                unsigned int *plugged_cpus, Error **errp)
+{
+    if (!object_property_set_int(core, "nr-threads", max_threads, errp)) {
+        object_unref(core);
+        return TOPO_FOREACH_ERR;
+    }
+
+    if (*plugged_cpus > max_threads) {
+        if (!object_property_set_int(core, "plugged-threads",
+                                     max_threads, errp)) {
+            object_unref(core);
+            return TOPO_FOREACH_ERR;
+        }
+        *plugged_cpus -= max_threads;
+    } else{
+        if (!object_property_set_int(core, "plugged-threads",
+                                     *plugged_cpus, errp)) {
+            object_unref(core);
+            return TOPO_FOREACH_ERR;
+        }
+        *plugged_cpus = 0;
+    }
+
+    return TOPO_FOREACH_CONTINUE;
+}
+
+static int add_smp_topo_child(CPUTopoState *topo, void *opaque)
+{
+    CPUTopoLevel level, child_level;
+    Object *parent = OBJECT(topo);
+    SMPBuildCbData *cb = opaque;
+    unsigned int *nr_children;
+    Error **errp = cb->errp;
+
+    level = CPU_TOPO_LEVEL(topo);
+    child_level = find_last_bit(cb->supported_levels, level);
+
+    /*
+     * child_level equals to level, that means no child needs to create.
+     * This shouldn't happen.
+     */
+    g_assert(child_level != level);
+
+    nr_children = get_smp_info_by_level(cb->smp_info, child_level);
+    topo->max_children = *nr_children;
+
+    for (int i = 0; i < topo->max_children; i++) {
+        ObjectProperty *prop;
+        Object *child;
+        gchar *name;
+
+        child = object_new(get_topo_typename_by_level(child_level));
+        name = get_topo_global_name(cb->stat, child_level);
+
+        prop = object_property_try_add_child(parent, name, child, errp);
+        g_free(name);
+        if (!prop) {
+            return TOPO_FOREACH_ERR;
+        }
+
+        if (child_level == CPU_TOPO_CORE) {
+            int ret = smp_core_set_threads(child, cb->smp_info->threads,
+                                           &cb->plugged_cpus, errp);
+
+            if (ret == TOPO_FOREACH_ERR) {
+                return ret;
+            }
+        }
+
+        qdev_realize(DEVICE(child), NULL, errp);
+        if (*errp) {
+            return TOPO_FOREACH_ERR;
+        }
+    }
+
+    return TOPO_FOREACH_CONTINUE;
+}
+
+void machine_create_smp_topo_tree(MachineState *ms, Error **errp)
+{
+    DECLARE_BITMAP(foreach_bitmap, USER_AVAIL_LEVEL_NUM);
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    CPUSlot *slot = ms->topo;
+    SMPBuildCbData cb;
+
+    if (!slot) {
+        error_setg(errp, "Invalid machine: "
+                   "the cpu-slot of machine is not initialized.");
+        return;
+    }
+
+    if (mc->smp_props.possible_cpus_qom_granu != CPU_TOPO_CORE &&
+        mc->smp_props.possible_cpus_qom_granu != CPU_TOPO_THREAD) {
+        error_setg(errp, "Invalid machine: Only support building "
+                   "qom smp topology with core/thread granularity. "
+                   "Not support %s granularity.",
+                   cpu_topo_level_to_string(
+                       mc->smp_props.possible_cpus_qom_granu));
+        return;
+    }
+
+    cb.supported_levels = slot->supported_levels;
+    cb.plugged_cpus = ms->smp.cpus;
+    cb.smp_info = &ms->smp;
+    cb.stat = &slot->stat;
+    cb.errp = errp;
+
+    if (add_smp_topo_child(CPU_TOPO(slot), &cb) < 0) {
+        return;
+    }
+
+    bitmap_copy(foreach_bitmap, slot->supported_levels, USER_AVAIL_LEVEL_NUM);
+
+    /*
+     * Don't create threads from -smp, and just record threads
+     * number in core.
+     */
+    clear_bit(CPU_TOPO_CORE, foreach_bitmap);
+    clear_bit(CPU_TOPO_THREAD, foreach_bitmap);
+
+    /*
+     * If the core level is inserted by hotplug way, don't create cores
+     * from -smp ethier.
+     */
+    if (mc->smp_props.possible_cpus_qom_granu == CPU_TOPO_CORE) {
+        CPUTopoLevel next_level;
+
+        next_level = find_next_bit(foreach_bitmap, USER_AVAIL_LEVEL_NUM,
+                                   CPU_TOPO_CORE + 1);
+        clear_bit(next_level, foreach_bitmap);
+    }
+
+    cpu_topo_child_foreach_recursive(CPU_TOPO(slot), foreach_bitmap,
+                                     add_smp_topo_child, &cb);
+    if (*errp) {
+        return;
+    }
+    slot->smp_parsed = true;
+}
diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 25019c91ee36..a0d091b23b97 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -19,6 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "hw/boards.h"
+#include "hw/core/cpu-slot.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 
@@ -230,6 +231,14 @@ void machine_parse_smp_config(MachineState *ms,
                    mc->name, mc->max_cpus);
         return;
     }
+
+    /*
+     * TODO: drop this check and convert "smp" to QOM topology tree by
+     * default when all arches support QOM topology.
+     */
+    if (mc->smp_props.possible_cpus_qom_granu) {
+        machine_create_smp_topo_tree(ms, errp);
+    }
 }
 
 unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
diff --git a/hw/cpu/core.c b/hw/cpu/core.c
index 261b15fa8171..07100754e9d1 100644
--- a/hw/cpu/core.c
+++ b/hw/cpu/core.c
@@ -107,7 +107,6 @@ static void cpu_core_class_init(ObjectClass *oc, void *data)
 static const TypeInfo cpu_core_type_info = {
     .name = TYPE_CPU_CORE,
     .parent = TYPE_CPU_TOPO,
-    .abstract = true,
     .class_init = cpu_core_class_init,
     .class_size = sizeof(CPUCoreClass),
     .instance_size = sizeof(CPUCore),
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 81a7b04ece86..88de08d98f9f 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -138,6 +138,11 @@ typedef struct {
  *                 provided SMP configuration
  * @books_supported - whether books are supported by the machine
  * @drawers_supported - whether drawers are supported by the machine
+ * @possible_cpus_qom_granu - the topology granularity for possible_cpus[]
+ *                            based on QOM CPU topology to plug CPUs.
+ *                            Note this flag indicates the support for QOM CPU
+ *                            topology. If QOM CPU topology is not supported,
+ *                            must set this field as CPU_TOPO_UNKNOWN.
  */
 typedef struct {
     bool prefer_sockets;
@@ -146,6 +151,7 @@ typedef struct {
     bool has_clusters;
     bool books_supported;
     bool drawers_supported;
+    CPUTopoLevel possible_cpus_qom_granu;
 } SMPCompatProps;
 
 /**
@@ -187,6 +193,9 @@ typedef struct {
  *    specifies default CPU_TYPE, which will be used for parsing target
  *    specific features and for creating CPUs if CPU name wasn't provided
  *    explicitly at CLI
+ * @default_core_tyep:
+ *    specifies default CORE_TYPE, which will be used to create default core
+ *    topology device for smp topology tree from -smp
  * @minimum_page_bits:
  *    If non-zero, the board promises never to create a CPU with a page size
  *    smaller than this, so QEMU can use a more efficient larger page
@@ -267,6 +276,7 @@ struct MachineClass {
     const char *hw_version;
     ram_addr_t default_ram_size;
     const char *default_cpu_type;
+    const char *default_core_type;
     bool default_kernel_irqchip_split;
     bool option_rom_has_mr;
     bool rom_file_has_mr;
@@ -398,6 +408,7 @@ struct MachineState {
     const char *cpu_type;
     AccelState *accelerator;
     CPUArchIdList *possible_cpus;
+    /* TODO: get rid of "smp" when all arches support QOM topology. */
     CpuTopology smp;
     CPUSlot *topo;
     struct NVDIMMState *nvdimms_state;
diff --git a/include/hw/core/cpu-slot.h b/include/hw/core/cpu-slot.h
index 1361af4ccfc0..de3d08fcb2ac 100644
--- a/include/hw/core/cpu-slot.h
+++ b/include/hw/core/cpu-slot.h
@@ -79,6 +79,9 @@ OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
  * @stat: Statistical topology information for topology tree.
  * @supported_levels: Supported topology levels for topology tree.
  * @ms: Machine in which this cpu-slot is plugged.
+ * @smp_parsed: Flag indicates if topology tree is derived from "-smp".
+ *      If not, MachineState.smp needs to be initialized based on
+ *      topology tree.
  */
 struct CPUSlot {
     /*< private >*/
@@ -89,11 +92,13 @@ struct CPUSlot {
     CPUTopoStat stat;
     DECLARE_BITMAP(supported_levels, USER_AVAIL_LEVEL_NUM);
     MachineState *ms;
+    bool smp_parsed;
 };
 
 #define MACHINE_CORE_FOREACH(ms, core) \
     QTAILQ_FOREACH((core), &(ms)->topo->cores, node)
 
 void machine_plug_cpu_slot(MachineState *ms);
+void machine_create_smp_topo_tree(MachineState *ms, Error **errp);
 
 #endif /* CPU_SLOT_H */
diff --git a/tests/unit/meson.build b/tests/unit/meson.build
index a05d47109040..5806dc5d813c 100644
--- a/tests/unit/meson.build
+++ b/tests/unit/meson.build
@@ -138,7 +138,10 @@ if have_system
     'test-util-sockets': ['socket-helpers.c'],
     'test-base64': [],
     'test-bufferiszero': [],
-    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machine-smp.c'],
+    'test-smp-parse': [qom, meson.project_source_root() / 'hw/core/machine-smp.c',
+                       meson.project_source_root() / 'hw/core/cpu-slot.c',
+                       meson.project_source_root() / 'hw/core/cpu-topo.c',
+                       hwcore],
     'test-vmstate': [migration, io],
     'test-yank': ['socket-helpers.c', qom, io, chardev]
   }
-- 
2.34.1


