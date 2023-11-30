Return-Path: <kvm+bounces-2955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FBDB7FF210
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64EC3B21920
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30ACE51C3B;
	Thu, 30 Nov 2023 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9SOKEu0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F2B85
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354906; x=1732890906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3aKtyhn4HEa/g5VVCwXVJ9czPMzUH1bTJvhs1x/p4jk=;
  b=l9SOKEu08yC/3E38zgJCIC5E3FXU2pMI6fGt8PcdJWp8GFH2r+/9dWzH
   diNbgMJwlknoSBA9gOKIAktOgg+wKXQ87azId/rpKPp8w1bEXlSVWial1
   7t23oFgPGl2MWA/VSyksAX/Iubyby0PxHIllIkNeF/kTsMz27toJVZdLD
   XjTmPD7fVbav/qhHXridV33oLyAaYh1+pqykAvznDmXU5qtyqgMd77wyF
   /kbaPb1JN2X8KBJDmBqjbXwLC1VhzeMwKVQ8Cnhgcmle3sA+dZ/gFsSIE
   2hgHsyFbW/p/tnnXNYFys20zW2QnHYbX/aoWyGbWbxIyxpWAVOG5jaK/s
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532330"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532330"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:35:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730181"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730181"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:34:56 -0800
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
Subject: [RFC 29/41] hw/core/slot: Statistics topology information in CPU slot
Date: Thu, 30 Nov 2023 22:41:51 +0800
Message-Id: <20231130144203.2307629-30-zhao1.liu@linux.intel.com>
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

The CPU slot, as the root of the topology tree, is responsible for
global topology information collection and updates.

When a new topology device is added to/deleted from the topology tree,
update the corresponding information in the slot.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-slot.c         | 41 +++++++++++++++++++++++++++++++++++-
 include/hw/core/cpu-slot.h | 43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/hw/core/cpu-slot.c b/hw/core/cpu-slot.c
index a6b7d98dea18..e8e6f4d25532 100644
--- a/hw/core/cpu-slot.c
+++ b/hw/core/cpu-slot.c
@@ -22,14 +22,44 @@
 
 #include "hw/core/cpu-slot.h"
 
+static inline
+CPUTopoStatEntry *get_topo_stat_entry(CPUTopoStat *stat,
+                                      CPUTopoLevel level)
+{
+    assert(level != CPU_TOPO_UNKNOWN);
+
+    return &stat->entries[TOPO_STAT_ENTRY_IDX(level)];
+}
+
 static void cpu_slot_add_topo_info(CPUTopoState *root, CPUTopoState *child)
 {
     CPUSlot *slot = CPU_SLOT(root);
     CPUTopoLevel level = CPU_TOPO_LEVEL(child);
+    CPUTopoStatEntry *entry;
 
     if (level == CPU_TOPO_CORE) {
-        QTAILQ_INSERT_TAIL(&slot->cores, CPU_CORE(child), node);
+        CPUCore *core = CPU_CORE(child);
+        CPUTopoStatEntry *thread_entry;
+
+        QTAILQ_INSERT_TAIL(&slot->cores, core, node);
+
+        /* Max CPUs per core is pre-configured by "nr-threads". */
+        slot->stat.max_cpus += core->nr_threads;
+        slot->stat.pre_plugged_cpus += core->plugged_threads;
+
+        thread_entry = get_topo_stat_entry(&slot->stat, CPU_TOPO_THREAD);
+        if (child->max_children > thread_entry->max_units) {
+            thread_entry->max_units = child->max_children;
+        }
     }
+
+    entry = get_topo_stat_entry(&slot->stat, level);
+    entry->total_units++;
+    if (child->parent->num_children > entry->max_units) {
+        entry->max_units = child->parent->num_children;
+    }
+
+    set_bit(level, slot->stat.curr_levels);
     return;
 }
 
@@ -37,10 +67,18 @@ static void cpu_slot_del_topo_info(CPUTopoState *root, CPUTopoState *child)
 {
     CPUSlot *slot = CPU_SLOT(root);
     CPUTopoLevel level = CPU_TOPO_LEVEL(child);
+    CPUTopoStatEntry *entry;
+
+    assert(level != CPU_TOPO_UNKNOWN);
 
     if (level == CPU_TOPO_CORE) {
         QTAILQ_REMOVE(&slot->cores, CPU_CORE(child), node);
     }
+
+    entry = get_topo_stat_entry(&slot->stat, level);
+    entry->total_units--;
+
+    /* No need to update entries[*].max_units and curr_levels. */
     return;
 }
 
@@ -73,6 +111,7 @@ static void cpu_slot_instance_init(Object *obj)
     CPUSlot *slot = CPU_SLOT(obj);
 
     QTAILQ_INIT(&slot->cores);
+    set_bit(CPU_TOPO_ROOT, slot->stat.curr_levels);
 }
 
 static const TypeInfo cpu_slot_type_info = {
diff --git a/include/hw/core/cpu-slot.h b/include/hw/core/cpu-slot.h
index d2a1160562be..fa2bd4af247d 100644
--- a/include/hw/core/cpu-slot.h
+++ b/include/hw/core/cpu-slot.h
@@ -25,6 +25,47 @@
 #include "hw/cpu/core.h"
 #include "hw/qdev-core.h"
 
+/**
+ * @USER_AVAIL_LEVEL_NUM: the number of total topology levels in topology
+ *                        bitmap, which includes CPU_TOPO_UNKNOWN.
+ */
+#define USER_AVAIL_LEVEL_NUM (CPU_TOPO_ROOT + 1)
+
+/**
+ * @VALID_LEVEL_NUM: the number of valid topology levels, which excludes
+ *                   CPU_TOPO_UNKNOWN and CPU_TOPO_ROOT.
+ */
+#define VALID_LEVEL_NUM (CPU_TOPO_ROOT - 1)
+
+#define TOPO_STAT_ENTRY_IDX(level) ((level) - 1)
+
+/**
+ * CPUTopoStatEntry:
+ * @total: Total number of topological units at the same level that are
+ *         currently inserted in CPU slot
+ * @max: Maximum number of topological units at the same level under the
+ *       parent topolofical container
+ */
+typedef struct CPUTopoStatEntry {
+    unsigned int total_units;
+    unsigned int max_units;
+} CPUTopoStatEntry;
+
+/**
+ * CPUTopoStat:
+ * @max_cpus: Maximum number of CPUs in CPU slot.
+ * @pre_plugged_cpus: Number of pre-plugged CPUs in CPU slot.
+ * @entries: Detail count information for valid topology levels under
+ *           CPU slot
+ * @curr_levels: Current CPU topology levels inserted in CPU slot
+ */
+typedef struct CPUTopoStat {
+    unsigned int max_cpus;
+    unsigned int pre_plugged_cpus;
+    CPUTopoStatEntry entries[VALID_LEVEL_NUM];
+    DECLARE_BITMAP(curr_levels, USER_AVAIL_LEVEL_NUM);
+} CPUTopoStat;
+
 #define TYPE_CPU_SLOT "cpu-slot"
 
 OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
@@ -35,6 +76,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
  *     where the cpu-slot is the root. cpu-slot can maintain similar
  *     queues for other topology levels to facilitate traversal
  *     when necessary.
+ * @stat: Statistical topology information for topology tree.
  */
 struct CPUSlot {
     /*< private >*/
@@ -42,6 +84,7 @@ struct CPUSlot {
 
     /*< public >*/
     QTAILQ_HEAD(, CPUCore) cores;
+    CPUTopoStat stat;
 };
 
 #endif /* CPU_SLOT_H */
-- 
2.34.1


