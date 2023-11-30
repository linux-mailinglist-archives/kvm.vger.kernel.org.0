Return-Path: <kvm+bounces-2936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4CA7FF1E6
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 969A7281E4F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937DE51C3E;
	Thu, 30 Nov 2023 14:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxGvZiYq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC8593
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354749; x=1732890749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rfkBnAETWygr5TaDQC+NvTNqfHDXa5mpCuKsaH8rIdY=;
  b=bxGvZiYqS3pq24Gp/zk1II5KK6OoOBQLZZTVo2P483ohWWTSgvGZtKeH
   C4s5+uG3wgKgSO2YvXR46huGPTMiIQlZcxvYrQN+Vo7CSdPdBnJW7ZSpg
   MIMw2185TLXTxuYJOtq/Bqr9JT99nBnjWl92Ar4Prwq6ndTqMctMWBVrr
   WNN7mC7SQVlUxiXi+TLdTizoicZmsbyq17qEnIxg4n9LHw5vIG92CeE4V
   6LcSpMKODI0PT2Q3/jrEDmu2cJk4cC5EVMNz72hf63fetY9ATHrsEr1AL
   m0RpvOBMe922gtYOpZ3ZW7rltIIFmMIpVAnlxAemyZnDlrWVy/pzn4cZY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531549"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531549"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:32:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729798"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729798"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:31:58 -0800
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
Subject: [RFC 10/41] hw/core/topo: Add virtual method to update topology info for parent
Date: Thu, 30 Nov 2023 22:41:32 +0800
Message-Id: <20231130144203.2307629-11-zhao1.liu@linux.intel.com>
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

When a new topology device is inserted into the topology tree,
its'parents (including non-direct parent) need to update topology
information.

Add the virtual method to help parents on topology tree update
topology information statistics.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-topo.c         | 20 ++++++++++++++++++++
 include/hw/core/cpu-topo.h |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/hw/core/cpu-topo.c b/hw/core/cpu-topo.c
index 3e0c183388d8..e244f0a3564e 100644
--- a/hw/core/cpu-topo.c
+++ b/hw/core/cpu-topo.c
@@ -154,6 +154,20 @@ static void cpu_topo_build_hierarchy(CPUTopoState *topo, Error **errp)
     cpu_topo_refresh_free_child_index(parent);
 }
 
+static void cpu_topo_update_info(CPUTopoState *topo, bool is_realize)
+{
+    CPUTopoState *parent = topo->parent;
+    CPUTopoClass *tc;
+
+    while (parent) {
+        tc = CPU_TOPO_GET_CLASS(parent);
+        if (tc->update_topo_info) {
+            tc->update_topo_info(parent, topo, is_realize);
+        }
+        parent = parent->parent;
+    }
+}
+
 static void cpu_topo_set_parent(CPUTopoState *topo, Error **errp)
 {
     Object *obj = OBJECT(topo);
@@ -178,6 +192,11 @@ static void cpu_topo_set_parent(CPUTopoState *topo, Error **errp)
 
     if (topo->parent) {
         cpu_topo_build_hierarchy(topo, errp);
+        if (*errp) {
+            return;
+        }
+
+        cpu_topo_update_info(topo, true);
     }
 }
 
@@ -203,6 +222,7 @@ static void cpu_topo_destroy_hierarchy(CPUTopoState *topo)
         return;
     }
 
+    cpu_topo_update_info(topo, false);
     QTAILQ_REMOVE(&parent->children, topo, sibling);
     parent->num_children--;
 
diff --git a/include/hw/core/cpu-topo.h b/include/hw/core/cpu-topo.h
index c0dfff9dc63b..79cd8606feca 100644
--- a/include/hw/core/cpu-topo.h
+++ b/include/hw/core/cpu-topo.h
@@ -44,6 +44,8 @@ OBJECT_DECLARE_TYPE(CPUTopoState, CPUTopoClass, CPU_TOPO)
 /**
  * CPUTopoClass:
  * @level: Topology level for this CPUTopoClass.
+ * @update_topo_info: Method to update topology information statistics when
+ *     new child (including direct child and non-direct child) is added.
  */
 struct CPUTopoClass {
     /*< private >*/
@@ -51,6 +53,8 @@ struct CPUTopoClass {
 
     /*< public >*/
     CPUTopoLevel level;
+    void (*update_topo_info)(CPUTopoState *parent, CPUTopoState *child,
+                             bool is_realize);
 };
 
 /**
-- 
2.34.1


