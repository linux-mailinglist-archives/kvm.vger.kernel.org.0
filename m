Return-Path: <kvm+bounces-2945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 563327FF1F8
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB479B21B25
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85EE4A9A8;
	Thu, 30 Nov 2023 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k+mfnReA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E9885
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354813; x=1732890813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ewTMs2u73zZUV2zJblGAkkri1EYaJm+RSs7ZWl9w7g8=;
  b=k+mfnReAG8WJahvaxs5SaRmLGE9WfD7cQahFCkTB3Km5VUKnC5JmbaV0
   tF7vZhIHgiI10f1uMiw7OQOsqz8Pe6f1JXpuELzlaOqJreZR3pQr0AHI0
   cG0pWkEQh/bsM7qH//10dLS3U3j4yJVxmMXuu52p3hCdfekEwSU7FEnsJ
   mi2L8YaLeBUOk6bDC1uC3yMegekyYMK0FnEUV6tLzYKFDYf9F5sHW5Udt
   BVVKkEO3Tk7FiFok3Qcir7Acfd7frFRFrwPk6QmsmOotghaqcnT2mpkPP
   d66CALXIMBn6T46iHj8WCKDXfvygmkNlk/8K6T8yxVZHMqEe+RUod7xoi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531980"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531980"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:33:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730032"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730032"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:33:22 -0800
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
Subject: [RFC 19/41] hw/cpu/cluster: Wrap TCG related ops and props into CONFIG_TCG
Date: Thu, 30 Nov 2023 22:41:41 +0800
Message-Id: <20231130144203.2307629-20-zhao1.liu@linux.intel.com>
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

Currenltly cpu-cluster is used in TCG case to organize CPUs with the
same type.

Wrap 2 things into TCG specific areas:
1. cluster-id:

   The cluster-id in TCG case is global, since no higher topology
   container above cluster. To simplify the logic of cluster topology
   in virtualization, move the cluster-id into CONFIG_TCG, then it
   won't be exposed in cli.

2. CPU collection in realize():

   In TCG case, the CPUs are added into cluster directly via child<>
   property. But in virtualization case, the CPU topology will be built
   via topology tree. Thus, wrap CPU collection as the TCG operation.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/cpu/cluster.c         | 30 +++++++++++++++++++++++++-----
 include/hw/cpu/cluster.h | 22 ++++++++++++++++++++--
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/hw/cpu/cluster.c b/hw/cpu/cluster.c
index fd978a543e40..340cfad9f8f1 100644
--- a/hw/cpu/cluster.c
+++ b/hw/cpu/cluster.c
@@ -26,7 +26,9 @@
 #include "qapi/error.h"
 
 static Property cpu_cluster_properties[] = {
+#ifdef CONFIG_TCG
     DEFINE_PROP_UINT32("cluster-id", CPUCluster, cluster_id, 0),
+#endif
     DEFINE_PROP_END_OF_LIST()
 };
 
@@ -47,18 +49,17 @@ static int add_cpu_to_cluster(Object *obj, void *opaque)
     return 0;
 }
 
-static void cpu_cluster_realize(DeviceState *dev, Error **errp)
+static void cpu_cluster_common_collect_cpus(CPUCluster *cluster, Error **errp)
 {
     /* Iterate through all our CPU children and set their cluster_index */
-    CPUCluster *cluster = CPU_CLUSTER(dev);
-    Object *cluster_obj = OBJECT(dev);
+    Object *cluster_obj = OBJECT(cluster);
     CallbackData cbdata = {
         .cluster = cluster,
         .cpu_count = 0,
     };
 
-    if (cluster->cluster_id >= MAX_CLUSTERS) {
-        error_setg(errp, "cluster-id must be less than %d", MAX_CLUSTERS);
+    if (cluster->cluster_id >= MAX_TCG_CLUSTERS) {
+        error_setg(errp, "cluster-id must be less than %d", MAX_TCG_CLUSTERS);
         return;
     }
 
@@ -73,15 +74,34 @@ static void cpu_cluster_realize(DeviceState *dev, Error **errp)
     assert(cbdata.cpu_count > 0);
 }
 
+static const struct TCGClusterOps common_cluster_tcg_ops = {
+    .collect_cpus = cpu_cluster_common_collect_cpus,
+};
+
+static void cpu_cluster_realize(DeviceState *dev, Error **errp)
+{
+    CPUCluster *cluster = CPU_CLUSTER(dev);
+    CPUClusterClass *cc = CPU_CLUSTER_GET_CLASS(dev);
+
+    if (cc->tcg_clu_ops->collect_cpus) {
+        cc->tcg_clu_ops->collect_cpus(cluster, errp);
+    }
+}
+
 static void cpu_cluster_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
+    CPUClusterClass *cc = CPU_CLUSTER_CLASS(klass);
 
     device_class_set_props(dc, cpu_cluster_properties);
     dc->realize = cpu_cluster_realize;
 
     /* This is not directly for users, CPU children must be attached by code */
     dc->user_creatable = false;
+
+#ifdef CONFIG_TCG
+    cc->tcg_clu_ops = &common_cluster_tcg_ops;
+#endif
 }
 
 static const TypeInfo cpu_cluster_type_info = {
diff --git a/include/hw/cpu/cluster.h b/include/hw/cpu/cluster.h
index 644b87350268..c038f05ddc9f 100644
--- a/include/hw/cpu/cluster.h
+++ b/include/hw/cpu/cluster.h
@@ -55,13 +55,31 @@
  */
 
 #define TYPE_CPU_CLUSTER "cpu-cluster"
-OBJECT_DECLARE_SIMPLE_TYPE(CPUCluster, CPU_CLUSTER)
+OBJECT_DECLARE_TYPE(CPUCluster, CPUClusterClass, CPU_CLUSTER)
 
 /*
  * This limit is imposed by TCG, which puts the cluster ID into an
  * 8 bit field (and uses all-1s for the default "not in any cluster").
  */
-#define MAX_CLUSTERS 255
+#define MAX_TCG_CLUSTERS 255
+
+struct TCGClusterOps {
+    /**
+     * @collect_cpus: Iterate children CPUs and set cluser_index.
+     *
+     * Called when the cluster is realized.
+     */
+    void (*collect_cpus)(CPUCluster *cluster, Error **errp);
+};
+
+struct CPUClusterClass {
+    /*< private >*/
+    DeviceClass parent_class;
+
+    /*< public >*/
+    /* when TCG is not available, this pointer is NULL */
+    const struct TCGClusterOps *tcg_clu_ops;
+};
 
 /**
  * CPUCluster:
-- 
2.34.1


