Return-Path: <kvm+bounces-2935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F1E7FF1E4
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C55311C20C67
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F5451014;
	Thu, 30 Nov 2023 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VgYisIiS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0046D46
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354743; x=1732890743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zcorAWDLgR7QueFdQsmIMfIxo58a5rqxmGG3Y6CdsHI=;
  b=VgYisIiSsbos+Sam4aKPEPGUxnfFbnknBxJu5NgdrxvxdOzYk3xcsP2e
   jWmhxxi3IeWau+eWxJdcmLiVsygBG5HHdHPLCFLzkguu3ndjMwryy8417
   rTzFGXEpS3w8mgES/x/4RloHdijezqTLmb0eVG4aRcPReDQbEQmo3Up2w
   3YbOWHh4m0kANh59wOWaZtGYLcyvZmmk3yXFGX8+eGL/DmcyEeIAS1MLI
   TldG/h/NPWRpzpPgjJ9fBhCU8fYed0nPnjiFGDgwyWUqSbMav+WuUkjTr
   inR911vtcxa0aDPELUxW0AHvhQF7byYS4tU51lq0FmJPFCJzwkC/3elgz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531484"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531484"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729745"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729745"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:31:48 -0800
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
Subject: [RFC 09/41] hw/core/topo: Support topology index for topology device
Date: Thu, 30 Nov 2023 22:41:31 +0800
Message-Id: <20231130144203.2307629-10-zhao1.liu@linux.intel.com>
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

Topology index is used to identify the topology child under the same
parent topology device.

This field corresponds to the topology sub index (e.g., socket-id/
core-id/thread-id) used for addressing.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-topo.c         | 77 ++++++++++++++++++++++++++++++++++++++
 include/hw/core/cpu-topo.h |  6 +++
 2 files changed, 83 insertions(+)

diff --git a/hw/core/cpu-topo.c b/hw/core/cpu-topo.c
index 4428b979a5dc..3e0c183388d8 100644
--- a/hw/core/cpu-topo.c
+++ b/hw/core/cpu-topo.c
@@ -50,6 +50,66 @@ static const char *cpu_topo_level_to_string(CPUTopoLevel level)
     return NULL;
 }
 
+static void cpu_topo_refresh_free_child_index(CPUTopoState *topo)
+{
+    CPUTopoState *child;
+
+    /*
+     * Fast way: Assume that the index grows sequentially and that there
+     * are no "index hole" in the previous children.
+     *
+     * The previous check on num_children ensures that free_child_index + 1
+     * does not hit the max_children limit.
+     */
+    if (topo->free_child_index + 1 == topo->num_children) {
+        topo->free_child_index++;
+        return;
+    }
+
+    /* Slow way: Search the "index hole". The index hole must be found. */
+    for (int index = 0; index < topo->num_children; index++) {
+        bool existed = false;
+
+        QTAILQ_FOREACH(child, &topo->children, sibling) {
+            if (child->index == index) {
+                existed = true;
+                break;
+            }
+        }
+
+        if (!existed) {
+            topo->free_child_index = index;
+            return;
+        }
+    }
+}
+
+static void cpu_topo_validate_index(CPUTopoState *topo, Error **errp)
+{
+    CPUTopoState *parent = topo->parent, *child;
+
+    if (topo->index < 0) {
+        error_setg(errp, "Invalid topology index (%d).",
+                   topo->index);
+        return;
+    }
+
+    if (parent->max_children && topo->index >= parent->max_children) {
+        error_setg(errp, "Invalid topology index (%d): "
+                   "The maximum index is %d.",
+                   topo->index, parent->max_children);
+        return;
+    }
+
+    QTAILQ_FOREACH(child, &topo->children, sibling) {
+        if (child->index == topo->index) {
+            error_setg(errp, "Duplicate topology index (%d)",
+                       topo->index);
+            return;
+        }
+    }
+}
+
 static void cpu_topo_build_hierarchy(CPUTopoState *topo, Error **errp)
 {
     CPUTopoState *parent = topo->parent;
@@ -80,7 +140,18 @@ static void cpu_topo_build_hierarchy(CPUTopoState *topo, Error **errp)
     }
 
     parent->num_children++;
+    if (topo->index == UNASSIGNED_TOPO_INDEX) {
+        topo->index = parent->free_child_index;
+    } else if (topo->index != parent->free_child_index) {
+        /* The index has been set, then we need to validate it. */
+        cpu_topo_validate_index(topo, errp);
+        if (*errp) {
+            return;
+        }
+    }
+
     QTAILQ_INSERT_TAIL(&parent->children, topo, sibling);
+    cpu_topo_refresh_free_child_index(parent);
 }
 
 static void cpu_topo_set_parent(CPUTopoState *topo, Error **errp)
@@ -135,6 +206,10 @@ static void cpu_topo_destroy_hierarchy(CPUTopoState *topo)
     QTAILQ_REMOVE(&parent->children, topo, sibling);
     parent->num_children--;
 
+    if (topo->index < parent->free_child_index) {
+        parent->free_child_index = topo->index;
+    }
+
     if (!parent->num_children) {
         parent->child_level = CPU_TOPO_UNKNOWN;
     }
@@ -180,6 +255,8 @@ static void cpu_topo_instance_init(Object *obj)
     CPUTopoState *topo = CPU_TOPO(obj);
     QTAILQ_INIT(&topo->children);
 
+    topo->index = UNASSIGNED_TOPO_INDEX;
+    topo->free_child_index = 0;
     topo->child_level = CPU_TOPO_UNKNOWN;
 }
 
diff --git a/include/hw/core/cpu-topo.h b/include/hw/core/cpu-topo.h
index ebcbdd854da5..c0dfff9dc63b 100644
--- a/include/hw/core/cpu-topo.h
+++ b/include/hw/core/cpu-topo.h
@@ -24,6 +24,8 @@
 #include "hw/qdev-core.h"
 #include "qemu/queue.h"
 
+#define UNASSIGNED_TOPO_INDEX -1
+
 typedef enum CPUTopoLevel {
     CPU_TOPO_UNKNOWN,
     CPU_TOPO_THREAD,
@@ -53,6 +55,8 @@ struct CPUTopoClass {
 
 /**
  * CPUTopoState:
+ * @index: Topology index within parent's topology queue.
+ * @free_child_index: Cached free index to be specified for next child.
  * @num_children: Number of topology children under this topology device.
  * @max_children: Maximum number of children allowed to be inserted under
  *     this topology device.
@@ -66,6 +70,8 @@ struct CPUTopoState {
     DeviceState parent_obj;
 
     /*< public >*/
+    int index;
+    int free_child_index;
     int num_children;
     int max_children;
     CPUTopoLevel child_level;
-- 
2.34.1


