Return-Path: <kvm+bounces-2956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 645FD7FF212
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA71AB2196D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D093C063;
	Thu, 30 Nov 2023 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gES64vdQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F209E93
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354915; x=1732890915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HnOAO3NMx1dRMWQIeSpDRtg/0be+6N1pOpK/5nWbTXE=;
  b=gES64vdQ2C88+sfEpHpL2svpTZ/OYw+BIJnl2BVHgyEklxqU7Qso7S1f
   P7+01tXzYG6CKD+XV5HmgIWHluoa9DnbB0kVr38ZjWMrAil6uHmLRLvc/
   Ee78GGzsx9cRP2ftLlrZmP90hN0+LPEL+DtMoFAewib+pda8SPkpf4C4d
   sEC9EiuzGCEqOsnEJsDivo551H+xVZ6/vKutf7Ut6haR1isGR0v3gQAWD
   0KqyuNJsfzK4uTUW1x7nQqFKxmXPIexBXyHK44UvJL97rbA/+TIYdX4JJ
   MSal1E6oSaPa5gNE4t3+hnyIiuryte6yYwsiao64USaAXL1thmGMIcphG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532376"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532376"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:35:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730225"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730225"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:35:05 -0800
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
Subject: [RFC 30/41] hw/core/slot: Check topology child to be added under CPU slot
Date: Thu, 30 Nov 2023 22:41:52 +0800
Message-Id: <20231130144203.2307629-31-zhao1.liu@linux.intel.com>
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

Implement CPUTopoClass.check_topo_child() in cpu-slot to be compatible
with the limitations of the current smp topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-slot.c         | 37 +++++++++++++++++++++++++++++++++++++
 hw/core/cpu-topo.c         |  2 +-
 include/hw/core/cpu-slot.h |  2 ++
 include/hw/core/cpu-topo.h |  1 +
 4 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/hw/core/cpu-slot.c b/hw/core/cpu-slot.c
index e8e6f4d25532..2a796ad5b6e7 100644
--- a/hw/core/cpu-slot.c
+++ b/hw/core/cpu-slot.c
@@ -21,6 +21,7 @@
 #include "qemu/osdep.h"
 
 #include "hw/core/cpu-slot.h"
+#include "qapi/error.h"
 
 static inline
 CPUTopoStatEntry *get_topo_stat_entry(CPUTopoStat *stat,
@@ -94,6 +95,37 @@ static void cpu_slot_update_topo_info(CPUTopoState *root, CPUTopoState *child,
     }
 }
 
+static void cpu_slot_check_topo_support(CPUTopoState *root, CPUTopoState *child,
+                                        Error **errp)
+{
+    CPUSlot *slot = CPU_SLOT(root);
+    CPUTopoLevel child_level = CPU_TOPO_LEVEL(child);
+
+    if (!test_bit(child_level, slot->supported_levels)) {
+        error_setg(errp, "cpu topo: the level %s is not supported",
+                   cpu_topo_level_to_string(child_level));
+        return;
+    }
+
+    /*
+     * Currently we doesn't support hybrid topology. For SMP topology,
+     * each child under the same parent are same type.
+     */
+    if (child->parent->num_children) {
+        CPUTopoState *sibling = QTAILQ_FIRST(&child->parent->children);
+        const char *sibling_type = object_get_typename(OBJECT(sibling));
+        const char *child_type = object_get_typename(OBJECT(child));
+
+        if (strcmp(sibling_type, child_type)) {
+            error_setg(errp, "Invalid smp topology: different CPU "
+                       "topology types (%s child vs %s sibling) "
+                       "under the same parent (%s).",
+                       child_type, sibling_type,
+                       object_get_typename(OBJECT(child->parent)));
+        }
+    }
+}
+
 static void cpu_slot_class_init(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
@@ -104,6 +136,7 @@ static void cpu_slot_class_init(ObjectClass *oc, void *data)
 
     tc->level = CPU_TOPO_ROOT;
     tc->update_topo_info = cpu_slot_update_topo_info;
+    tc->check_topo_child = cpu_slot_check_topo_support;
 }
 
 static void cpu_slot_instance_init(Object *obj)
@@ -112,6 +145,10 @@ static void cpu_slot_instance_init(Object *obj)
 
     QTAILQ_INIT(&slot->cores);
     set_bit(CPU_TOPO_ROOT, slot->stat.curr_levels);
+
+    /* Set all levels by default. */
+    bitmap_fill(slot->supported_levels, USER_AVAIL_LEVEL_NUM);
+    clear_bit(CPU_TOPO_UNKNOWN, slot->supported_levels);
 }
 
 static const TypeInfo cpu_slot_type_info = {
diff --git a/hw/core/cpu-topo.c b/hw/core/cpu-topo.c
index 687a4cc566ec..351112ca7a73 100644
--- a/hw/core/cpu-topo.c
+++ b/hw/core/cpu-topo.c
@@ -24,7 +24,7 @@
 #include "hw/qdev-properties.h"
 #include "qapi/error.h"
 
-static const char *cpu_topo_level_to_string(CPUTopoLevel level)
+const char *cpu_topo_level_to_string(CPUTopoLevel level)
 {
     switch (level) {
     case CPU_TOPO_UNKNOWN:
diff --git a/include/hw/core/cpu-slot.h b/include/hw/core/cpu-slot.h
index fa2bd4af247d..7bf51988afb3 100644
--- a/include/hw/core/cpu-slot.h
+++ b/include/hw/core/cpu-slot.h
@@ -77,6 +77,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
  *     queues for other topology levels to facilitate traversal
  *     when necessary.
  * @stat: Statistical topology information for topology tree.
+ * @supported_levels: Supported topology levels for topology tree.
  */
 struct CPUSlot {
     /*< private >*/
@@ -85,6 +86,7 @@ struct CPUSlot {
     /*< public >*/
     QTAILQ_HEAD(, CPUCore) cores;
     CPUTopoStat stat;
+    DECLARE_BITMAP(supported_levels, USER_AVAIL_LEVEL_NUM);
 };
 
 #endif /* CPU_SLOT_H */
diff --git a/include/hw/core/cpu-topo.h b/include/hw/core/cpu-topo.h
index 453bacbb558b..d27da0335c42 100644
--- a/include/hw/core/cpu-topo.h
+++ b/include/hw/core/cpu-topo.h
@@ -102,5 +102,6 @@ int cpu_topo_child_foreach(CPUTopoState *topo, unsigned long *levels,
 int cpu_topo_child_foreach_recursive(CPUTopoState *topo,
                                      unsigned long *levels,
                                      topo_fn fn, void *opaque);
+const char *cpu_topo_level_to_string(CPUTopoLevel level);
 
 #endif /* CPU_TOPO_H */
-- 
2.34.1


