Return-Path: <kvm+bounces-2937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E6D7FF1E7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADFA12826D6
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B530351C44;
	Thu, 30 Nov 2023 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUHBhGU+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA41185
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354753; x=1732890753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qW0hllcBGqseRYTHsmnEpW0X6HH9DmoP+0BU5Dr4Av4=;
  b=dUHBhGU+/1nnI1/vPshlXbuLn8PoBar2f9HkxQDszRrbx7uQxpohtHGA
   zXMXTAaW52iyp72df7/7K2/y+URa/SAGPyTGudRL4YFHmI6Ss2oYOugZi
   0RXAVX+IsMcrRRgvtcnzUjeE6HO3L0KRPzzszPO1mCfDVjItS7eTc0FHG
   Mzo6wt+jhu8DOny4zEG26pIEHjqZZZhxo3zpqXmwjjQg9iuaFfn4+qvRb
   g6drzo/0yfaXihqC3pBNGS+m7O50cjRJ6Ura8TSeR9YNelFUbnjDaBAo/
   OboSDuesBsVkYu9MdccCFnoUSLi5jd9LafXuOhYLu8iFeaQCSP7l3inif
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531596"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531596"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:32:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729823"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729823"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:32:07 -0800
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
Subject: [RFC 11/41] hw/core/topo: Add virtual method to check topology child
Date: Thu, 30 Nov 2023 22:41:33 +0800
Message-Id: <20231130144203.2307629-12-zhao1.liu@linux.intel.com>
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

When a new topology child is to be inserted into the topology tree, its
parents (including non-direct parents) need to check if this child is
supported.

Add the virtual method to allow topology device to check the support for
their topology children.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/cpu-topo.c         | 22 ++++++++++++++++++++++
 include/hw/core/cpu-topo.h |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/hw/core/cpu-topo.c b/hw/core/cpu-topo.c
index e244f0a3564e..cba2dc747e74 100644
--- a/hw/core/cpu-topo.c
+++ b/hw/core/cpu-topo.c
@@ -168,6 +168,23 @@ static void cpu_topo_update_info(CPUTopoState *topo, bool is_realize)
     }
 }
 
+static void cpu_topo_check_support(CPUTopoState *topo, Error **errp)
+{
+    CPUTopoState *parent = topo->parent;
+    CPUTopoClass *tc;
+
+    while (parent) {
+        tc = CPU_TOPO_GET_CLASS(parent);
+        if (tc->check_topo_child) {
+            tc->check_topo_child(parent, topo, errp);
+            if (*errp) {
+                return;
+            }
+        }
+        parent = parent->parent;
+    }
+}
+
 static void cpu_topo_set_parent(CPUTopoState *topo, Error **errp)
 {
     Object *obj = OBJECT(topo);
@@ -191,6 +208,11 @@ static void cpu_topo_set_parent(CPUTopoState *topo, Error **errp)
     }
 
     if (topo->parent) {
+        cpu_topo_check_support(topo, errp);
+        if (*errp) {
+            return;
+        }
+
         cpu_topo_build_hierarchy(topo, errp);
         if (*errp) {
             return;
diff --git a/include/hw/core/cpu-topo.h b/include/hw/core/cpu-topo.h
index 79cd8606feca..1ffdb0be6d38 100644
--- a/include/hw/core/cpu-topo.h
+++ b/include/hw/core/cpu-topo.h
@@ -46,6 +46,8 @@ OBJECT_DECLARE_TYPE(CPUTopoState, CPUTopoClass, CPU_TOPO)
  * @level: Topology level for this CPUTopoClass.
  * @update_topo_info: Method to update topology information statistics when
  *     new child (including direct child and non-direct child) is added.
+ * @check_topo_child: Method to check the support for new child (including
+ *     direct child and non-direct child) to be added.
  */
 struct CPUTopoClass {
     /*< private >*/
@@ -55,6 +57,8 @@ struct CPUTopoClass {
     CPUTopoLevel level;
     void (*update_topo_info)(CPUTopoState *parent, CPUTopoState *child,
                              bool is_realize);
+    void (*check_topo_child)(CPUTopoState *parent, CPUTopoState *child,
+                             Error **errp);
 };
 
 /**
-- 
2.34.1


