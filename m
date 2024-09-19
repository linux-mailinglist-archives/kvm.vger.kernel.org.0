Return-Path: <kvm+bounces-27115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8A397C291
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0EF2286902
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996901CFBE;
	Thu, 19 Sep 2024 01:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IO/vTmAn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FD81DFD1
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710072; cv=none; b=o0wredrxrCc3BCiXqgQqDEjy+wtstl6XJVoqfVawllOIZfWJWSz1GxbXHZLzMeBwl+n6TNUz6ztz3prqYAZUfFRa80Q9p+VJHsByrFB1zFxcAReePQDC4v3Ua4SOgoV1sUycBnvyKSl0BnshXg5hmCXVd6zIUkFmJ9DbK9YhPfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710072; c=relaxed/simple;
	bh=XSgqmMkHJizZc4N1izUEEkjh5Xf8Kwzu+lddFS/lH2U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IaZdO4dV+2RNvYqfhVAPvqsQz5DgCtQfnFKBATR67O/Nxyx6F/KKr9iaQ/CpWvCpexOGbf1XAAeH+3gM/OVgsqhGPZWh6N1LdG+VpGta00aheRY+s1DKy90e3XTCqBW0UXo99Y6jw2/Pf/rcoG0F7pBEm0eOAo1XCKLpTTlh0vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IO/vTmAn; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710071; x=1758246071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XSgqmMkHJizZc4N1izUEEkjh5Xf8Kwzu+lddFS/lH2U=;
  b=IO/vTmAn/gDiz9mEpXuzBTOoetWarwaCDm7K1G0o5T8ALYsKTsOyjInr
   CWIf9dryMdzKbvPjniGmR6nFJhBN20/Q/5YCoKoMLzXHGN5Ia4decVVza
   mh+bPtNoebl4RUNYkAG+raT5r21mSisnNNhchRwCKgrkMG3wv9gkXerVQ
   sMZMTbqieMjcdrWQ/EKhtjVnbi2SfUf9+MGeU4/bFQoOJHA0ULdBY+gM0
   pbxuyvgnAI6mBbHeWoegRSrVjJ6ma/+qWkU8C2ykvlVt3lBISQQ01Fwmq
   xz0Gqsz8Iy7g1ZmrS8FhvEyDAW7ezJ/PWjdERRmulmmX11Ujc6rufayUn
   A==;
X-CSE-ConnectionGUID: cfjMxhugTcarzIdUSwCXQw==
X-CSE-MsgGUID: XEQD3gDDQ6qD1RSq3G6Puw==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25798074"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25798074"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:41:11 -0700
X-CSE-ConnectionGUID: S1ZKAEwsS6+xTFUMRz/CIg==
X-CSE-MsgGUID: 8BpNMzORS9K4jxsU5BqXGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058972"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:41:05 -0700
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
Subject: [RFC v2 13/15] system/qdev-monitor: Introduce bus-finder interface for compatibility with bus-less plug behavior
Date: Thu, 19 Sep 2024 09:55:31 +0800
Message-Id: <20240919015533.766754-14-zhao1.liu@intel.com>
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

Currently, cpu and core is located by topology IDs when plugging.

On a topology tree, each topology device will has a CPU bus. Once cpu
and core specify the bus_type, it's necessary to find accurate buses
for them based on topology IDs (if bus=* is not set in -device).

Therefore, we need a way to use traditional topology IDs for locating
specific bus in the topology tree. This is the bus-finder interface.

With bus-finder, qdev-monitor can locate the bus based on device
properties when "bus=*" is not specified.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS                  |  2 ++
 include/monitor/bus-finder.h | 41 ++++++++++++++++++++++++++++++++
 system/bus-finder.c          | 46 ++++++++++++++++++++++++++++++++++++
 system/meson.build           |  1 +
 system/qdev-monitor.c        | 41 ++++++++++++++++++++++++++++----
 5 files changed, 126 insertions(+), 5 deletions(-)
 create mode 100644 include/monitor/bus-finder.h
 create mode 100644 system/bus-finder.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 03c1a13de074..4608c3c6db8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3281,12 +3281,14 @@ F: hw/core/qdev*
 F: hw/core/bus.c
 F: hw/core/sysbus.c
 F: include/hw/qdev*
+F: include/monitor/bus-finder.h
 F: include/monitor/qdev.h
 F: include/qom/
 F: qapi/qom.json
 F: qapi/qdev.json
 F: scripts/coccinelle/qom-parent-type.cocci
 F: scripts/qom-cast-macro-clean-cocci-gen.py
+F: system/bus-finder.c
 F: system/qdev-monitor.c
 F: stubs/qdev.c
 F: qom/
diff --git a/include/monitor/bus-finder.h b/include/monitor/bus-finder.h
new file mode 100644
index 000000000000..56f1e4791b66
--- /dev/null
+++ b/include/monitor/bus-finder.h
@@ -0,0 +1,41 @@
+/*
+ * Bus finder interface header
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef BUS_FINDER_H
+#define BUS_FINDER_H
+
+#include "hw/qdev-core.h"
+#include "qom/object.h"
+
+#define TYPE_BUS_FINDER "bus-finder"
+
+typedef struct BusFinderClass BusFinderClass;
+DECLARE_CLASS_CHECKERS(BusFinderClass, BUS_FINDER, TYPE_BUS_FINDER)
+#define BUS_FINDER(obj) INTERFACE_CHECK(BusFinder, (obj), TYPE_BUS_FINDER)
+
+typedef struct BusFinder BusFinder;
+
+/**
+ * BusFinderClass:
+ * @find_bus: Method to find bus.
+ */
+struct BusFinderClass {
+    /* <private> */
+    InterfaceClass parent_class;
+
+    /* <public> */
+    BusState *(*find_bus)(DeviceState *dev);
+};
+
+bool is_bus_finder_type(DeviceClass *dc);
+BusState *bus_finder_select_bus(DeviceState *dev);
+
+#endif /* BUS_FINDER_H */
diff --git a/system/bus-finder.c b/system/bus-finder.c
new file mode 100644
index 000000000000..097291a96bf3
--- /dev/null
+++ b/system/bus-finder.c
@@ -0,0 +1,46 @@
+/*
+ * Bus finder interface
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#include "qemu/osdep.h"
+
+#include "hw/qdev-core.h"
+#include "monitor/bus-finder.h"
+#include "qom/object.h"
+
+bool is_bus_finder_type(DeviceClass *dc)
+{
+    return !!object_class_dynamic_cast(OBJECT_CLASS(dc), TYPE_BUS_FINDER);
+}
+
+BusState *bus_finder_select_bus(DeviceState *dev)
+{
+    BusFinder *bf = BUS_FINDER(dev);
+    BusFinderClass *bfc = BUS_FINDER_GET_CLASS(bf);
+
+    if (bfc->find_bus) {
+        return bfc->find_bus(dev);
+    }
+
+    return NULL;
+}
+
+static const TypeInfo bus_finder_interface_info = {
+    .name          = TYPE_BUS_FINDER,
+    .parent        = TYPE_INTERFACE,
+    .class_size = sizeof(BusFinderClass),
+};
+
+static void bus_finder_register_types(void)
+{
+    type_register_static(&bus_finder_interface_info);
+}
+
+type_init(bus_finder_register_types)
diff --git a/system/meson.build b/system/meson.build
index a296270cb005..090716b81abd 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -9,6 +9,7 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
 system_ss.add(files(
   'balloon.c',
   'bootdevice.c',
+  'bus-finder.c',
   'cpus.c',
   'cpu-throttle.c',
   'cpu-timers.c',
diff --git a/system/qdev-monitor.c b/system/qdev-monitor.c
index 44994ea0e160..457dfd05115e 100644
--- a/system/qdev-monitor.c
+++ b/system/qdev-monitor.c
@@ -19,6 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "hw/sysbus.h"
+#include "monitor/bus-finder.h"
 #include "monitor/hmp.h"
 #include "monitor/monitor.h"
 #include "monitor/qdev.h"
@@ -589,6 +590,16 @@ static BusState *qbus_find(const char *path, Error **errp)
     return bus;
 }
 
+static inline bool qdev_post_find_bus(DeviceClass *dc)
+{
+    return is_bus_finder_type(dc);
+}
+
+static inline BusState *qdev_find_bus_post_device(DeviceState *dev)
+{
+    return bus_finder_select_bus(dev);
+}
+
 /* Takes ownership of @id, will be freed when deleting the device */
 const char *qdev_set_id(DeviceState *dev, char *id, Error **errp)
 {
@@ -630,6 +641,7 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts,
     char *id;
     DeviceState *dev = NULL;
     BusState *bus = NULL;
+    bool post_bus = false;
 
     driver = qdict_get_try_str(opts, "driver");
     if (!driver) {
@@ -656,11 +668,15 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts,
             return NULL;
         }
     } else if (dc->bus_type != NULL) {
-        bus = qbus_find_recursive(sysbus_get_default(), NULL, dc->bus_type);
-        if (!bus || qbus_is_full(bus)) {
-            error_setg(errp, "No '%s' bus found for device '%s'",
-                       dc->bus_type, driver);
-            return NULL;
+        if (qdev_post_find_bus(dc)) {
+            post_bus = true;             /* Wait for bus-finder to arbitrate. */
+        } else {
+            bus = qbus_find_recursive(sysbus_get_default(), NULL, dc->bus_type);
+            if (!bus || qbus_is_full(bus)) {
+                error_setg(errp, "No '%s' bus found for device '%s'",
+                           dc->bus_type, driver);
+                return NULL;
+            }
         }
     }
 
@@ -722,6 +738,21 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts,
         goto err_del_dev;
     }
 
+    if (post_bus) {
+        bus = qdev_find_bus_post_device(dev);
+        if (!bus) {
+            error_setg(errp, "No proper '%s' bus found for device '%s'",
+                       dc->bus_type, driver);
+            goto err_del_dev;
+        }
+
+        if (phase_check(PHASE_MACHINE_READY) && !qbus_is_hotpluggable(bus)) {
+            error_setg(errp, "Bus '%s' does not support hotplugging",
+                       bus->name);
+            goto err_del_dev;
+        }
+    }
+
     if (!qdev_realize(dev, bus, errp)) {
         goto err_del_dev;
     }
-- 
2.34.1


