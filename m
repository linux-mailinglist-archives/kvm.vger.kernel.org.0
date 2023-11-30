Return-Path: <kvm+bounces-2944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F175E7FF1F5
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6E9B281E5B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE5A51C3E;
	Thu, 30 Nov 2023 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCstdPTa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B74D1B4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354803; x=1732890803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UIctuJN57ff0cGtb6JQuQGzOnsVqrF/BvG/lcB/CLAU=;
  b=oCstdPTaPq+WTeF9juI70c3mIzvhgwdosdFAs66SPRv9T7pNAW3WmD9W
   FiXIlqzO/5sDrEAFaNWWGEnlQmpyXomG5qpRrmgniCKUyv3CXH5Qc2YWD
   xIZ48HLmDaM1oBj+TbKvHuyqixU/2w/AWGUEemq7dZaN41zU/2l/zlLUC
   LKYqCQ/IuPY+5yYKFKuhffeyB0EavTletMm80sH/zXYBreaPlWXFK91mf
   NamIEfKzvH2Yq3mmR6uQXxMbQLy0NBGFb+rz5Oj1JQDZknKy75J/iAvUy
   gwO9rtbv54tcVLFR3WqYsio0w2dBRAMpxcGwK/sOXAsfKLae2+kLotaM6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531932"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531932"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:33:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730016"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730016"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:33:13 -0800
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
Subject: [RFC 18/41] hw/cpu/cluster: Rename CPUClusterState to CPUCluster
Date: Thu, 30 Nov 2023 22:41:40 +0800
Message-Id: <20231130144203.2307629-19-zhao1.liu@linux.intel.com>
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

To keep the same naming style as cpu-core, rename CPUClusterState to
CPUCluster.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 gdbstub/system.c                   | 2 +-
 hw/cpu/cluster.c                   | 8 ++++----
 include/hw/arm/armsse.h            | 2 +-
 include/hw/arm/xlnx-versal.h       | 4 ++--
 include/hw/arm/xlnx-zynqmp.h       | 4 ++--
 include/hw/cpu/cluster.h           | 6 +++---
 include/hw/riscv/microchip_pfsoc.h | 4 ++--
 include/hw/riscv/sifive_u.h        | 4 ++--
 8 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/gdbstub/system.c b/gdbstub/system.c
index 783ac140b982..1c0b55d3ebe7 100644
--- a/gdbstub/system.c
+++ b/gdbstub/system.c
@@ -277,7 +277,7 @@ static int find_cpu_clusters(Object *child, void *opaque)
 {
     if (object_dynamic_cast(child, TYPE_CPU_CLUSTER)) {
         GDBState *s = (GDBState *) opaque;
-        CPUClusterState *cluster = CPU_CLUSTER(child);
+        CPUCluster *cluster = CPU_CLUSTER(child);
         GDBProcess *process;
 
         s->processes = g_renew(GDBProcess, s->processes, ++s->process_num);
diff --git a/hw/cpu/cluster.c b/hw/cpu/cluster.c
index 61289a840d46..fd978a543e40 100644
--- a/hw/cpu/cluster.c
+++ b/hw/cpu/cluster.c
@@ -26,12 +26,12 @@
 #include "qapi/error.h"
 
 static Property cpu_cluster_properties[] = {
-    DEFINE_PROP_UINT32("cluster-id", CPUClusterState, cluster_id, 0),
+    DEFINE_PROP_UINT32("cluster-id", CPUCluster, cluster_id, 0),
     DEFINE_PROP_END_OF_LIST()
 };
 
 typedef struct CallbackData {
-    CPUClusterState *cluster;
+    CPUCluster *cluster;
     int cpu_count;
 } CallbackData;
 
@@ -50,7 +50,7 @@ static int add_cpu_to_cluster(Object *obj, void *opaque)
 static void cpu_cluster_realize(DeviceState *dev, Error **errp)
 {
     /* Iterate through all our CPU children and set their cluster_index */
-    CPUClusterState *cluster = CPU_CLUSTER(dev);
+    CPUCluster *cluster = CPU_CLUSTER(dev);
     Object *cluster_obj = OBJECT(dev);
     CallbackData cbdata = {
         .cluster = cluster,
@@ -87,7 +87,7 @@ static void cpu_cluster_class_init(ObjectClass *klass, void *data)
 static const TypeInfo cpu_cluster_type_info = {
     .name = TYPE_CPU_CLUSTER,
     .parent = TYPE_DEVICE,
-    .instance_size = sizeof(CPUClusterState),
+    .instance_size = sizeof(CPUCluster),
     .class_init = cpu_cluster_class_init,
 };
 
diff --git a/include/hw/arm/armsse.h b/include/hw/arm/armsse.h
index 88b3b759c5a8..886586a3bed4 100644
--- a/include/hw/arm/armsse.h
+++ b/include/hw/arm/armsse.h
@@ -153,7 +153,7 @@ struct ARMSSE {
 
     /*< public >*/
     ARMv7MState armv7m[SSE_MAX_CPUS];
-    CPUClusterState cluster[SSE_MAX_CPUS];
+    CPUCluster cluster[SSE_MAX_CPUS];
     IoTKitSecCtl secctl;
     TZPPC apb_ppc[NUM_INTERNAL_PPCS];
     TZMPC mpc[IOTS_NUM_MPC];
diff --git a/include/hw/arm/xlnx-versal.h b/include/hw/arm/xlnx-versal.h
index b24fa64557fd..61bde52b6af5 100644
--- a/include/hw/arm/xlnx-versal.h
+++ b/include/hw/arm/xlnx-versal.h
@@ -58,7 +58,7 @@ struct Versal {
     struct {
         struct {
             MemoryRegion mr;
-            CPUClusterState cluster;
+            CPUCluster cluster;
             ARMCPU cpu[XLNX_VERSAL_NR_ACPUS];
             GICv3State gic;
         } apu;
@@ -88,7 +88,7 @@ struct Versal {
             MemoryRegion mr;
             MemoryRegion mr_ps_alias;
 
-            CPUClusterState cluster;
+            CPUCluster cluster;
             ARMCPU cpu[XLNX_VERSAL_NR_RCPUS];
         } rpu;
 
diff --git a/include/hw/arm/xlnx-zynqmp.h b/include/hw/arm/xlnx-zynqmp.h
index 96358d51ebb7..5eea765ea76c 100644
--- a/include/hw/arm/xlnx-zynqmp.h
+++ b/include/hw/arm/xlnx-zynqmp.h
@@ -98,8 +98,8 @@ struct XlnxZynqMPState {
     DeviceState parent_obj;
 
     /*< public >*/
-    CPUClusterState apu_cluster;
-    CPUClusterState rpu_cluster;
+    CPUCluster apu_cluster;
+    CPUCluster rpu_cluster;
     ARMCPU apu_cpu[XLNX_ZYNQMP_NUM_APU_CPUS];
     ARMCPU rpu_cpu[XLNX_ZYNQMP_NUM_RPU_CPUS];
     GICState gic;
diff --git a/include/hw/cpu/cluster.h b/include/hw/cpu/cluster.h
index 53fbf36af542..644b87350268 100644
--- a/include/hw/cpu/cluster.h
+++ b/include/hw/cpu/cluster.h
@@ -55,7 +55,7 @@
  */
 
 #define TYPE_CPU_CLUSTER "cpu-cluster"
-OBJECT_DECLARE_SIMPLE_TYPE(CPUClusterState, CPU_CLUSTER)
+OBJECT_DECLARE_SIMPLE_TYPE(CPUCluster, CPU_CLUSTER)
 
 /*
  * This limit is imposed by TCG, which puts the cluster ID into an
@@ -64,13 +64,13 @@ OBJECT_DECLARE_SIMPLE_TYPE(CPUClusterState, CPU_CLUSTER)
 #define MAX_CLUSTERS 255
 
 /**
- * CPUClusterState:
+ * CPUCluster:
  * @cluster_id: The cluster ID. This value is for internal use only and should
  *   not be exposed directly to the user or to the guest.
  *
  * State of a CPU cluster.
  */
-struct CPUClusterState {
+struct CPUCluster {
     /*< private >*/
     DeviceState parent_obj;
 
diff --git a/include/hw/riscv/microchip_pfsoc.h b/include/hw/riscv/microchip_pfsoc.h
index daef086da602..c9ac14e35625 100644
--- a/include/hw/riscv/microchip_pfsoc.h
+++ b/include/hw/riscv/microchip_pfsoc.h
@@ -38,8 +38,8 @@ typedef struct MicrochipPFSoCState {
     DeviceState parent_obj;
 
     /*< public >*/
-    CPUClusterState e_cluster;
-    CPUClusterState u_cluster;
+    CPUCluster e_cluster;
+    CPUCluster u_cluster;
     RISCVHartArrayState e_cpus;
     RISCVHartArrayState u_cpus;
     DeviceState *plic;
diff --git a/include/hw/riscv/sifive_u.h b/include/hw/riscv/sifive_u.h
index 0696f8594277..fda4a708e960 100644
--- a/include/hw/riscv/sifive_u.h
+++ b/include/hw/riscv/sifive_u.h
@@ -40,8 +40,8 @@ typedef struct SiFiveUSoCState {
     DeviceState parent_obj;
 
     /*< public >*/
-    CPUClusterState e_cluster;
-    CPUClusterState u_cluster;
+    CPUCluster e_cluster;
+    CPUCluster u_cluster;
     RISCVHartArrayState e_cpus;
     RISCVHartArrayState u_cpus;
     DeviceState *plic;
-- 
2.34.1


