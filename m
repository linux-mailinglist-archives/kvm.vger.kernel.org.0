Return-Path: <kvm+bounces-2960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C964F7FF21D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B671283749
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A58E51013;
	Thu, 30 Nov 2023 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l0pIDfZg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B53D50
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354954; x=1732890954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/v8heKKPYeoDkQz9adBaYazg44MH5EQbkce1fx19vRE=;
  b=l0pIDfZgboNahI+UlI3+k2pFRUdstp768V7QtapKssAhDvdcZ4hg5LwG
   1MHcVLsjh8a9rj74w1sbzYtTHTvW0HUIl3BZq4AaymKbtfcOlUUJVAkf7
   xM0wXdXmrMx3H9H7Okc7hiMa0RyY2a5yBtkI4cBCsBHWjn0tKZEhojXQB
   Gifd+Se7wthTHsFcYmo5MmvT/02sjGzKTcvmpAtTY5LojM8pjQm+u+M2U
   RZn3iXO8PG05ITMKfVKOqXF2cft4LePRfL0AW6A2CbFxs7CP6yWJbcdqa
   JXvqWBan4XuqF+42g9DNOMLFAnaa8c+XqaFWRFrDCoBl84gEk/aPIuaQI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532514"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532514"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:35:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730319"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730319"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:35:44 -0800
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
Subject: [RFC 34/41] hw/core/topo: Implement user-child to collect topology device from cli
Date: Thu, 30 Nov 2023 22:41:56 +0800
Message-Id: <20231130144203.2307629-35-zhao1.liu@linux.intel.com>
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

Support user-child for topology devices.

This will affect these 2 aspects:
1. For the basic topology device (with DEVICE_CATEGORY_CPU_DEF
   category), user could specify "parent" to build the topology
   relationship from cli. And cpu-slot will collect all topology
   devices.

2. For the hotplug topology devices (ppc-core or CPUs of other arches),
   user-child could help to search the correct topology parent in
   topology tree with the index properties. This is compatible with
   the original behavior of inserting CPU/core from cli. And this
   requires arch to support QOM topology with a few arch-specific
   modifications, before this support, hotplugged CPUs/cores are
   inserted into cpu-slot by default.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-slot.c         | 44 ++++++++++++++++++++++++++++++++++++++
 hw/core/cpu-topo.c         | 38 ++++++++++++++++++++++++++++++++
 include/hw/core/cpu-slot.h |  3 +++
 include/hw/core/cpu-topo.h |  4 ++++
 4 files changed, 89 insertions(+)

diff --git a/hw/core/cpu-slot.c b/hw/core/cpu-slot.c
index 45b6aef0750a..413daa66aaad 100644
--- a/hw/core/cpu-slot.c
+++ b/hw/core/cpu-slot.c
@@ -559,3 +559,47 @@ bool machine_validate_cpu_topology(MachineState *ms, Error **errp)
 
     return true;
 }
+
+Object *cpu_slot_get_free_parent(CPUTopoState *child, Error **errp)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    CPUTopoLevel level = CPU_TOPO_LEVEL(child);
+    CPUSlot *slot = ms->topo;
+
+    if (!slot) {
+        return NULL;
+    }
+
+    /*
+     * For CPUs and cores that support hotplug, the behavior is to specify
+     * some topology sub ids. This requires special handling.
+     */
+    if (level == mc->smp_props.possible_cpus_qom_granu) {
+        CPUTopoClass *child_tc = CPU_TOPO_GET_CLASS(child);
+
+        if (child_tc->search_parent_pre_plug) {
+            return child_tc->search_parent_pre_plug(child,
+                       CPU_TOPO(slot), errp);
+        }
+    }
+
+    /*
+     * For other topology devices, just collect them into CPU slot.
+     * The realize() of CPUTopoClass will check no "parent" option case.
+     */
+    return OBJECT(slot);
+}
+
+char *cpu_slot_name_future_child(CPUTopoState *child)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    CPUTopoLevel level = CPU_TOPO_LEVEL(child);
+    CPUSlot *slot = ms->topo;
+
+    if (!slot) {
+        return NULL;
+    }
+
+    return get_topo_global_name(&slot->stat, level);
+}
diff --git a/hw/core/cpu-topo.c b/hw/core/cpu-topo.c
index 351112ca7a73..143b0a148b17 100644
--- a/hw/core/cpu-topo.c
+++ b/hw/core/cpu-topo.c
@@ -20,8 +20,10 @@
 
 #include "qemu/osdep.h"
 
+#include "hw/core/cpu-slot.h"
 #include "hw/core/cpu-topo.h"
 #include "hw/qdev-properties.h"
+#include "monitor/user-child.h"
 #include "qapi/error.h"
 
 const char *cpu_topo_level_to_string(CPUTopoLevel level)
@@ -272,10 +274,38 @@ static void cpu_topo_unrealize(DeviceState *dev)
     }
 }
 
+/*
+ * Prefer to insert topology device into topology tree where the CPU
+ * slot is the root.
+ */
+static Object *cpu_topo_get_parent(UserChild *uc, Error **errp)
+{
+    return cpu_slot_get_free_parent(CPU_TOPO(uc), errp);
+}
+
+static char *cpu_topo_get_child_name(UserChild *uc, Object *parent)
+{
+    return cpu_slot_name_future_child(CPU_TOPO(uc));
+}
+
+/* Only check type. Other topology details with be checked at realize(). */
+static bool cpu_topo_check_user_parent(UserChild *uc, Object *parent)
+{
+    CPUTopoState *topo;
+
+    topo = (CPUTopoState *)object_dynamic_cast(parent, TYPE_CPU_TOPO);
+    if (!topo) {
+        return false;
+    }
+
+    return true;
+}
+
 static void cpu_topo_class_init(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
     CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+    UserChildClass *ucc = USER_CHILD_CLASS(oc);
 
     /* All topology devices belong to CPU property. */
     set_bit(DEVICE_CATEGORY_CPU, dc->categories);
@@ -290,6 +320,10 @@ static void cpu_topo_class_init(ObjectClass *oc, void *data)
     dc->hotpluggable = false;
 
     tc->level = CPU_TOPO_UNKNOWN;
+
+    ucc->get_parent = cpu_topo_get_parent;
+    ucc->get_child_name = cpu_topo_get_child_name;
+    ucc->check_parent = cpu_topo_check_user_parent;
 }
 
 static void cpu_topo_instance_init(Object *obj)
@@ -310,6 +344,10 @@ static const TypeInfo cpu_topo_type_info = {
     .class_init = cpu_topo_class_init,
     .instance_size = sizeof(CPUTopoState),
     .instance_init = cpu_topo_instance_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_USER_CHILD },
+        { }
+    }
 };
 
 static void cpu_topo_register_types(void)
diff --git a/include/hw/core/cpu-slot.h b/include/hw/core/cpu-slot.h
index 9e1c6d6b7ff2..1a63f55f52c3 100644
--- a/include/hw/core/cpu-slot.h
+++ b/include/hw/core/cpu-slot.h
@@ -102,4 +102,7 @@ void machine_plug_cpu_slot(MachineState *ms);
 void machine_create_smp_topo_tree(MachineState *ms, Error **errp);
 bool machine_validate_cpu_topology(MachineState *ms, Error **errp);
 
+Object *cpu_slot_get_free_parent(CPUTopoState *child, Error **errp);
+char *cpu_slot_name_future_child(CPUTopoState *child);
+
 #endif /* CPU_SLOT_H */
diff --git a/include/hw/core/cpu-topo.h b/include/hw/core/cpu-topo.h
index d27da0335c42..6cef26cce0b7 100644
--- a/include/hw/core/cpu-topo.h
+++ b/include/hw/core/cpu-topo.h
@@ -48,6 +48,8 @@ OBJECT_DECLARE_TYPE(CPUTopoState, CPUTopoClass, CPU_TOPO)
  *     new child (including direct child and non-direct child) is added.
  * @check_topo_child: Method to check the support for new child (including
  *     direct child and non-direct child) to be added.
+ * @search_parent_pre_plug: Method to search proper topology parent of @child
+ *     from @root.
  */
 struct CPUTopoClass {
     /*< private >*/
@@ -59,6 +61,8 @@ struct CPUTopoClass {
                              bool is_realize);
     void (*check_topo_child)(CPUTopoState *parent, CPUTopoState *child,
                              Error **errp);
+    Object *(*search_parent_pre_plug)(CPUTopoState *child, CPUTopoState *root,
+                                      Error **errp);
 };
 
 /**
-- 
2.34.1


