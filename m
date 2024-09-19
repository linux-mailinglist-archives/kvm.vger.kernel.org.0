Return-Path: <kvm+bounces-27107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68ADC97C285
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BC301C218A9
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0556B18E11;
	Thu, 19 Sep 2024 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JDegS0+7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8961E1CFB9
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710020; cv=none; b=UcQ8EruAK+1EpOgn5OJhfJQuz2f+ZQRycGfGfXIuE0jjXThq8+mLj5ut1qt651DFTeOBc5OfQ7D04c6cLzFWw8nLwxeMbIcNsnaSbt7e+uIZjvlNEbXOnw4NzC3byEKyGflv60lWisOa259r2lRaP0XPcsu6fdHGflJ0KFsTUJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710020; c=relaxed/simple;
	bh=573w2DHmYSHZ5HLG8xM/Ws3MSekemg/qhlyIWizCQb0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fO6KD1sevXk5Dx5eZqloEgvoSAm1buAH3TpNVyk4VcwkjiOUUKxZsvA3ik1g5EdgO4thhNtS+VXH/HVUE/HVfL7Ou0vm8Q5+HT8jgf3CqzpxQGJAm6mvWxQeAmNFGpXwybyCUUYyeazXeILsAGk55KpWK2kQHaVyK3ulF53YgxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JDegS0+7; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710019; x=1758246019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=573w2DHmYSHZ5HLG8xM/Ws3MSekemg/qhlyIWizCQb0=;
  b=JDegS0+7UCsU9NHVN4M8SUUHyj+msUWItm/edgEpeXk/4+MohMt6QT+7
   dfZ8WdWCR/C5p2Eu1hmdpNvsHIV6iai4ucoDAZuF86C8+YTVh5gg8lLEY
   0uxZ0uWqm4CbVqwyvjCFjVpI/RHtG/S6UvDLfswprRen2/+FBWHG7xGKv
   iQv3/x83YigDMZT6j02d1dI/ZrOVgibuP70VG4ukmpzi0MJoTG2X2qu0q
   eBgPUYvVyjX/NuOKdPbJI68ZKkuur5f2Apcx8dDH6FjT6V3F+2QUeJPEr
   SgYOY9NE10YIx51FbXQdQ5s242TY9M4pe9WQZSZp0WDOOWonDD7TcIHfU
   g==;
X-CSE-ConnectionGUID: exJMhU+PSX6Ze/6LdDX9Fw==
X-CSE-MsgGUID: sZFo4IaZS0O5WfibxJQmBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25797867"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25797867"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:40:18 -0700
X-CSE-ConnectionGUID: VTAf9j9wSdmPPMQUWsdetg==
X-CSE-MsgGUID: O69kmvrZS0GmljFMm/GWdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058690"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:12 -0700
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
Subject: [RFC v2 05/15] qdev: Add method in BusClass to customize device index
Date: Thu, 19 Sep 2024 09:55:23 +0800
Message-Id: <20240919015533.766754-6-zhao1.liu@intel.com>
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

Currently, when the bus assigns an index to a child device, it relies on
a monotonically increasing max_index.

However, when a device is removed from the bus, its index is not
reassigned to new devices, leading to "holes" in child indices.

For topology devices, such as CPUs/cores, arches define custom
sub-topology IDs. Some of these IDs are global (e.g., core-id for core
devices), while others are local (e.g., thread-id/core-id/module-id for
x86 CPUs).

Local IDs are indexes under the same parent device and align with
BusChild's index meaning. Therefore, local IDs in a topology context
should use BusChild.index.

Considering that topology devices support hot-plug and local IDs often
have range constraints, add a new method (BusClass.assign_free_index) to
allow the bus to customize index assignment.

Based on this method, the CPU bus will search for free index "holes"
created by unplugging and assign these free indices to newly inserted
devices.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/qdev.c                |  8 +++++++-
 hw/cpu/cpu-topology.c         | 37 +++++++++++++++++++++++++++++++++++
 include/hw/cpu/cpu-topology.h |  1 +
 include/hw/qdev-core.h        |  2 ++
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/hw/core/qdev.c b/hw/core/qdev.c
index ff073cbff56d..e3e9f0f303d6 100644
--- a/hw/core/qdev.c
+++ b/hw/core/qdev.c
@@ -78,11 +78,17 @@ static void bus_remove_child(BusState *bus, DeviceState *child)
 
 static void bus_add_child(BusState *bus, DeviceState *child)
 {
+    BusClass *bc = BUS_GET_CLASS(bus);
     char name[32];
     BusChild *kid = g_malloc0(sizeof(*kid));
 
+    if (bc->assign_free_index) {
+        kid->index = bc->assign_free_index(bus);
+    } else {
+        kid->index = bus->max_index++;
+    }
+
     bus->num_children++;
-    kid->index = bus->max_index++;
     kid->child = child;
     child->bus_node = kid;
     object_ref(OBJECT(kid->child));
diff --git a/hw/cpu/cpu-topology.c b/hw/cpu/cpu-topology.c
index e68c06132e7d..3e8982ff7e6c 100644
--- a/hw/cpu/cpu-topology.c
+++ b/hw/cpu/cpu-topology.c
@@ -49,11 +49,40 @@ static bool cpu_bus_check_address(BusState *bus, DeviceState *dev,
     return cpu_parent_check_topology(bus->parent, dev, errp);
 }
 
+static int cpu_bus_assign_free_index(BusState *bus)
+{
+    BusChild *kid;
+    int index;
+
+    if (bus->num_children == bus->max_index) {
+        return bus->max_index++;
+    }
+
+    assert(bus->num_children < bus->max_index);
+    /* TODO: Introduce the list sorted by index */
+    for (index = 0; index < bus->num_children; index++) {
+        bool existed = false;
+
+        QTAILQ_FOREACH(kid, &bus->children, sibling) {
+            if (kid->index == index) {
+                existed = true;
+                break;
+            }
+        }
+
+        if (!existed) {
+            break;
+        }
+    }
+    return index;
+}
+
 static void cpu_bus_class_init(ObjectClass *oc, void *data)
 {
     BusClass *bc = BUS_CLASS(oc);
 
     bc->check_address = cpu_bus_check_address;
+    bc->assign_free_index = cpu_bus_assign_free_index;
 }
 
 static const TypeInfo cpu_bus_type_info = {
@@ -177,3 +206,11 @@ int cpu_topo_get_instances_num(CPUTopoState *topo)
 
     return bus ? bus->num_children : 1;
 }
+
+int cpu_topo_get_index(CPUTopoState *topo)
+{
+    BusChild *node = DEVICE(topo)->bus_node;
+
+    assert(node);
+    return node->index;
+}
diff --git a/include/hw/cpu/cpu-topology.h b/include/hw/cpu/cpu-topology.h
index 7a447ad16ee7..80aeff18baa3 100644
--- a/include/hw/cpu/cpu-topology.h
+++ b/include/hw/cpu/cpu-topology.h
@@ -64,5 +64,6 @@ struct CPUTopoState {
 #define GET_CPU_TOPO_LEVEL(topo)    (CPU_TOPO_GET_CLASS(topo)->level)
 
 int cpu_topo_get_instances_num(CPUTopoState *topo);
+int cpu_topo_get_index(CPUTopoState *topo);
 
 #endif /* CPU_TOPO_H */
diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 7cbc5fb97298..77223b28c788 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -342,6 +342,8 @@ struct BusClass {
      */
     bool (*check_address)(BusState *bus, DeviceState *dev, Error **errp);
 
+    int (*assign_free_index)(BusState *bus);
+
     BusRealize realize;
     BusUnrealize unrealize;
 
-- 
2.34.1


