Return-Path: <kvm+bounces-27110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A4797C288
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08882B21BA6
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B1C18E11;
	Thu, 19 Sep 2024 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ma1un0rI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997751CFBE
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710040; cv=none; b=BL2Q+Bmr9jG89LNVQjy/DfGHOrkig9/3Ho14V8pFyIZwFR7UgVqp/JUSnQ9DVoDpQ9PWk+rj5EHy5DkNH7FkAQpjIW3iWoyGW1J16KQWLugch+RxmZa++fq9QeTKlXiX5e3SW/OABZwx8RKncPzYManbG/BJxOYPqwbfXErOJtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710040; c=relaxed/simple;
	bh=l1vQdeQ4queUGmdOva+Swsyp/QTxpMCGhTY2FBOIVyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tiTMao5O3agXkxY4JUardmmMnqewEha9r2OFIChyRpdvCDM9BdkyVsb62BwflcUjSniQRC8YGMxZi6tm4MFVHWXOK/d8gIVtC6Z3vwAB4/ndMvcfOimfaYjzE79ynUWW4heVKx9rdWRZNgNJC+0lgPtngnPz6EwPZIZl1cL2twc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ma1un0rI; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710039; x=1758246039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l1vQdeQ4queUGmdOva+Swsyp/QTxpMCGhTY2FBOIVyU=;
  b=ma1un0rITrvAObWhymG8Pmk3+AbdoAFEiy2j7C8Cb5fbT0kIEuUPaIiF
   Kt1eaT11h8pN6goV+9MslCQjfF7x/PvOnaG27D4Apr2HaiD1qYeY6VPeF
   oEytiefdMsNEQAiurJRSM7VlvVgOnQwDJDOAMuUWfXKQ6vkfWxd7QgS1L
   fS+YLXdrflJwmWy6e2tieLIK3CV9utXkSPDjV3PM3LzVXBUXgjetrrMVF
   MNZMHFyQo9ektVJ21LW5hRt0Bd1Jr5YUjZMiIhmCPcq/gq9w7vlOZVxZC
   akTm9CvpTTLuUvCACO671cTmY+p8Q+ez2t+0bOYofZb1FHP0A+d9lByls
   A==;
X-CSE-ConnectionGUID: Ru8WMYwzS0KsxvfhVBPaOQ==
X-CSE-MsgGUID: KUF7LsvxTFCcBzrI4Kxejw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797923"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797923"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:38 -0700
X-CSE-ConnectionGUID: YVSPOQ2tQWuH1my/Tb60Fw==
X-CSE-MsgGUID: DeBF+64uSSydM/DHzEmxhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058834"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:32 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 08/15] hw/cpu/core: Convert cpu-core from general device to topology device
Date: Thu, 19 Sep 2024 09:55:26 +0800
Message-Id: <20240919015533.766754-9-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919015533.766754-1-zhao1.liu@intel.com>
References: <20240919015533.766754-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert cpu-core to topology device then it can be added into topology
tree.

At present, only PPC is using cpu-core device. For topology tree, it's
necessary to add cpu-core in the tree as one of the topology
hierarchies.

The generic cpu-core is sufficient to express the core layer in a
topology tree without needing to consider any arch-specific feature, so
to reduce the support complexity of the topology tree and allow arch to
be able to use the abstract cpu-core directly, without further
derivation of the arch-specific core, remove the "abstract" restriction
from TypeInfo.

Because cpu-core then inherits properties and settings of topology
device, also make the following changes to take into account the special
case for cpu-core:

 * Omit setting category since topology device has already set.

 * Make realize() of topology device as the parent realize() for PPC
   cores.

 * Set cpu-core's topology level as core.

 * Mask bus_type for PPC cores as NULL to avoid PPC cores' creation
   failure since PPC currently doesn't support topology tree.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/cpu/core.c                   |  9 +++++----
 hw/ppc/pnv_core.c               | 11 ++++++++++-
 hw/ppc/spapr_cpu_core.c         | 12 +++++++++++-
 include/hw/cpu/core.h           |  3 ++-
 include/hw/ppc/pnv_core.h       |  3 ++-
 include/hw/ppc/spapr_cpu_core.h |  4 +++-
 6 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/hw/cpu/core.c b/hw/cpu/core.c
index 495a5c30ffe1..bf1cbceea21b 100644
--- a/hw/cpu/core.c
+++ b/hw/cpu/core.c
@@ -79,19 +79,20 @@ static void cpu_core_instance_init(Object *obj)
 
 static void cpu_core_class_init(ObjectClass *oc, void *data)
 {
-    DeviceClass *dc = DEVICE_CLASS(oc);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
 
-    set_bit(DEVICE_CATEGORY_CPU, dc->categories);
+    /* TODO: Offload "core-id" and "nr-threads" to ppc-specific core. */
     object_class_property_add(oc, "core-id", "int", core_prop_get_core_id,
                               core_prop_set_core_id, NULL, NULL);
     object_class_property_add(oc, "nr-threads", "int", core_prop_get_nr_threads,
                               core_prop_set_nr_threads, NULL, NULL);
+
+    tc->level = CPU_TOPOLOGY_LEVEL_CORE;
 }
 
 static const TypeInfo cpu_core_type_info = {
     .name = TYPE_CPU_CORE,
-    .parent = TYPE_DEVICE,
-    .abstract = true,
+    .parent = TYPE_CPU_TOPO,
     .class_init = cpu_core_class_init,
     .instance_size = sizeof(CPUCore),
     .instance_init = cpu_core_instance_init,
diff --git a/hw/ppc/pnv_core.c b/hw/ppc/pnv_core.c
index a30693990b25..9be7a4b6c1a9 100644
--- a/hw/ppc/pnv_core.c
+++ b/hw/ppc/pnv_core.c
@@ -356,6 +356,8 @@ static void pnv_core_realize(DeviceState *dev, Error **errp)
 
     assert(pc->chip);
 
+    pcc->parent_realize(dev, errp);
+
     pc->threads = g_new(PowerPCCPU *, cc->nr_threads);
     for (i = 0; i < cc->nr_threads; i++) {
         PowerPCCPU *cpu;
@@ -466,11 +468,18 @@ static void pnv_core_power10_class_init(ObjectClass *oc, void *data)
 static void pnv_core_class_init(ObjectClass *oc, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(oc);
+    PnvCoreClass *pcc = PNV_CORE_CLASS(oc);
 
-    dc->realize = pnv_core_realize;
     dc->unrealize = pnv_core_unrealize;
     device_class_set_props(dc, pnv_core_properties);
     dc->user_creatable = false;
+    device_class_set_parent_realize(dc, pnv_core_realize,
+                                    &pcc->parent_realize);
+    /*
+     * Avoid ppc that do not support topology device trees from
+     * encountering error when creating cores.
+     */
+    dc->bus_type = NULL;
 }
 
 #define DEFINE_PNV_CORE_TYPE(family, cpu_model) \
diff --git a/hw/ppc/spapr_cpu_core.c b/hw/ppc/spapr_cpu_core.c
index 464224516881..49c440fc0e09 100644
--- a/hw/ppc/spapr_cpu_core.c
+++ b/hw/ppc/spapr_cpu_core.c
@@ -338,6 +338,7 @@ static void spapr_cpu_core_realize(DeviceState *dev, Error **errp)
         (SpaprMachineState *) object_dynamic_cast(qdev_get_machine(),
                                                   TYPE_SPAPR_MACHINE);
     SpaprCpuCore *sc = SPAPR_CPU_CORE(OBJECT(dev));
+    SpaprCpuCoreClass *scc = SPAPR_CPU_CORE_GET_CLASS(sc);
     CPUCore *cc = CPU_CORE(OBJECT(dev));
     int i;
 
@@ -346,6 +347,8 @@ static void spapr_cpu_core_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    scc->parent_realize(dev, errp);
+
     qemu_register_reset(spapr_cpu_core_reset_handler, sc);
     sc->threads = g_new0(PowerPCCPU *, cc->nr_threads);
     for (i = 0; i < cc->nr_threads; i++) {
@@ -376,11 +379,18 @@ static void spapr_cpu_core_class_init(ObjectClass *oc, void *data)
     DeviceClass *dc = DEVICE_CLASS(oc);
     SpaprCpuCoreClass *scc = SPAPR_CPU_CORE_CLASS(oc);
 
-    dc->realize = spapr_cpu_core_realize;
     dc->unrealize = spapr_cpu_core_unrealize;
     device_class_set_legacy_reset(dc, spapr_cpu_core_reset);
     device_class_set_props(dc, spapr_cpu_core_properties);
+    dc->hotpluggable = true;
     scc->cpu_type = data;
+    device_class_set_parent_realize(dc, spapr_cpu_core_realize,
+                                    &scc->parent_realize);
+    /*
+     * Avoid ppc that do not support topology device trees from
+     * encountering error when creating cores.
+     */
+    dc->bus_type = NULL;
 }
 
 #define DEFINE_SPAPR_CPU_CORE_TYPE(cpu_model) \
diff --git a/include/hw/cpu/core.h b/include/hw/cpu/core.h
index 98ab91647eb2..a451dcd2e4d8 100644
--- a/include/hw/cpu/core.h
+++ b/include/hw/cpu/core.h
@@ -9,6 +9,7 @@
 #ifndef HW_CPU_CORE_H
 #define HW_CPU_CORE_H
 
+#include "hw/cpu/cpu-topology.h"
 #include "hw/qdev-core.h"
 #include "qom/object.h"
 
@@ -18,7 +19,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(CPUCore, CPU_CORE)
 
 struct CPUCore {
     /*< private >*/
-    DeviceState parent_obj;
+    CPUTopoState parent_obj;
 
     /*< public >*/
     int core_id;
diff --git a/include/hw/ppc/pnv_core.h b/include/hw/ppc/pnv_core.h
index d8afb4f95f92..252b98ae20f9 100644
--- a/include/hw/ppc/pnv_core.h
+++ b/include/hw/ppc/pnv_core.h
@@ -71,10 +71,11 @@ struct PnvCore {
 };
 
 struct PnvCoreClass {
-    DeviceClass parent_class;
+    CPUTopoClass parent_class;
 
     const MemoryRegionOps *xscom_ops;
     uint64_t xscom_size;
+    DeviceRealize parent_realize;
 };
 
 #define PNV_CORE_TYPE_SUFFIX "-" TYPE_PNV_CORE
diff --git a/include/hw/ppc/spapr_cpu_core.h b/include/hw/ppc/spapr_cpu_core.h
index 69a52e39b850..fc6c15747a88 100644
--- a/include/hw/ppc/spapr_cpu_core.h
+++ b/include/hw/ppc/spapr_cpu_core.h
@@ -32,8 +32,10 @@ struct SpaprCpuCore {
 };
 
 struct SpaprCpuCoreClass {
-    DeviceClass parent_class;
+    CPUTopoClass parent_class;
+
     const char *cpu_type;
+    DeviceRealize parent_realize;
 };
 
 const char *spapr_get_cpu_core_type(const char *cpu_type);
-- 
2.34.1


