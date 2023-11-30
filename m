Return-Path: <kvm+bounces-2948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B587FF1FC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C9632825CF
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BBB51039;
	Thu, 30 Nov 2023 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JSEo6s3z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A06196
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354841; x=1732890841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ojKaeiijveA4rQSsZpp2eyLul8UTXwtywNBoYac3pw0=;
  b=JSEo6s3zJQZR1TPM9mhrEh48U3LNRhbKsemyt6FKP7sjTnvZJ5LZkENw
   kYWgSvq6p+tyxSyiGIuyUTIk7QYVZxIQgt9jCn+uNV7h/yVPSwtJkRRD8
   ngoG//sH9Xi8bHPEnuKQJ2TlDaoHo6so8+dfGiXhERlX2OxJEc44VB5YX
   LVZVpLcCVv1uK6sr0one+bxL/Ibd8hZsZ1WqOH5O2zqH5z1tmC9rC7WhD
   rQl0b/2g7vTLFPhgJMaGhWSAiK/VFS+cMS+hLPoPNYG/mSIT7TWd8UDlG
   XDQHwWq83BWUpIyL3VGle3bRyn9yMN74kTP5Z7mORIVCM+YQwTb1JzPrq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532117"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532117"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:34:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730060"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730060"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:33:50 -0800
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
Subject: [RFC 22/41] hw/cpu/cluster: Convert cpu-cluster from general device to topology device
Date: Thu, 30 Nov 2023 22:41:44 +0800
Message-Id: <20231130144203.2307629-23-zhao1.liu@linux.intel.com>
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

Convert cpu-cluster to topology device then user could create cluster
level topology from cli and later the cpu-clusters could be added into
topology tree.

In addition, mark the cpu-cluster as DEVICE_CATEGORY_CPU_DEF category to
indicate it belongs to the basic CPU definition and should be created
from cli before board initialization.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/cpu/cluster.c         | 11 +++++++++--
 include/hw/cpu/cluster.h |  7 +++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/hw/cpu/cluster.c b/hw/cpu/cluster.c
index 8a666c27d151..adf0ef23e8d4 100644
--- a/hw/cpu/cluster.c
+++ b/hw/cpu/cluster.c
@@ -86,15 +86,21 @@ static void cpu_cluster_realize(DeviceState *dev, Error **errp)
     if (cc->tcg_clu_ops->collect_cpus) {
         cc->tcg_clu_ops->collect_cpus(cluster, errp);
     }
+
+    cc->parent_realize(dev, errp);
 }
 
 static void cpu_cluster_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(klass);
     CPUClusterClass *cc = CPU_CLUSTER_CLASS(klass);
 
+    set_bit(DEVICE_CATEGORY_CPU_DEF, dc->categories);
     device_class_set_props(dc, cpu_cluster_properties);
-    dc->realize = cpu_cluster_realize;
+    device_class_set_parent_realize(dc, cpu_cluster_realize,
+                                    &cc->parent_realize);
+    tc->level = CPU_TOPO_CLUSTER;
 
 #ifdef CONFIG_TCG
     cc->tcg_clu_ops = &common_cluster_tcg_ops;
@@ -103,8 +109,9 @@ static void cpu_cluster_class_init(ObjectClass *klass, void *data)
 
 static const TypeInfo cpu_cluster_type_info = {
     .name = TYPE_CPU_CLUSTER,
-    .parent = TYPE_DEVICE,
+    .parent = TYPE_CPU_TOPO,
     .instance_size = sizeof(CPUCluster),
+    .class_size = sizeof(CPUClusterClass),
     .class_init = cpu_cluster_class_init,
 };
 
diff --git a/include/hw/cpu/cluster.h b/include/hw/cpu/cluster.h
index b3185e2f2566..888993c36da4 100644
--- a/include/hw/cpu/cluster.h
+++ b/include/hw/cpu/cluster.h
@@ -20,6 +20,7 @@
 #ifndef HW_CPU_CLUSTER_H
 #define HW_CPU_CLUSTER_H
 
+#include "hw/core/cpu-topo.h"
 #include "hw/qdev-core.h"
 #include "qom/object.h"
 
@@ -84,11 +85,13 @@ struct TCGClusterOps {
 
 struct CPUClusterClass {
     /*< private >*/
-    DeviceClass parent_class;
+    CPUTopoClass parent_class;
 
     /*< public >*/
     /* when TCG is not available, this pointer is NULL */
     const struct TCGClusterOps *tcg_clu_ops;
+
+    DeviceRealize parent_realize;
 };
 
 /**
@@ -100,7 +103,7 @@ struct CPUClusterClass {
  */
 struct CPUCluster {
     /*< private >*/
-    DeviceState parent_obj;
+    CPUTopoState parent_obj;
 
     /*< public >*/
     uint32_t cluster_id;
-- 
2.34.1


