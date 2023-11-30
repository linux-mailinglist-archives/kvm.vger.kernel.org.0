Return-Path: <kvm+bounces-2932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D33A97FF1DA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 305E7B21317
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E2E51C2C;
	Thu, 30 Nov 2023 14:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NkuU7KJS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370DC85
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354719; x=1732890719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g5Zw3I63TJXvQFrzB5uJb/WUPaoeW0TH6JE9nfaHRvc=;
  b=NkuU7KJSgRdY64OVy56MYQSGozdjIyGvIGO3HySDZtXjCcClaQZpJ4gq
   HmnTclpQTRV6Jxb5C+lIMzH953OL2aYZFPU92ZPIYIjeTP4SWg1cC0A/E
   GCi5IR0bjXp6vx3ZRNjtIo3L+MKRhxwbDVckW0rTY3MzDVmRY3Lmomo8l
   f/ECgsIN9kBGlV5h2Cjk+4kAkuevhg0SnbChXmxm/MdeSY2UcDcxBDqQr
   ZJy+jV8Yl535UbxuWfG63bG8oZIhNKvCztOAvW7pyTVg1notRaPa8cUgm
   ixt2pKGswKm2v9MFU06zrB7fuSe8URyUmbFgVBJhEORAjZVhMZrWTq1Pn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479531249"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479531249"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:31:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942729699"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942729699"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:31:20 -0800
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
Subject: [RFC 06/41] qdev: Introduce user-child interface to collect devices from -device
Date: Thu, 30 Nov 2023 22:41:28 +0800
Message-Id: <20231130144203.2307629-7-zhao1.liu@linux.intel.com>
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

Topology relationship is based on child<> property, therefore introduce
a new user-child interface to help bus-less devices create child<>
property from cli.

User-child interface works in qdev_set_id(), where the child<> property
is created for cli devices.

With several methods, user-child could provide the specific "parent"
device other than the default peripheral/peripheral-anon container.

The topology root (cpu-slot) could collect topology devices based on
user-child implementation.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS                  |  2 +
 include/monitor/user-child.h | 57 +++++++++++++++++++++++
 include/qom/object.h         | 11 +++++
 qom/object.c                 | 13 ++++++
 system/meson.build           |  1 +
 system/qdev-monitor.c        | 89 +++++++++++++++++++++++++++++++++---
 system/user-child.c          | 72 +++++++++++++++++++++++++++++
 7 files changed, 239 insertions(+), 6 deletions(-)
 create mode 100644 include/monitor/user-child.h
 create mode 100644 system/user-child.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 695e0bd34fbb..fdbabaa983cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3208,12 +3208,14 @@ F: hw/core/bus.c
 F: hw/core/sysbus.c
 F: include/hw/qdev*
 F: include/monitor/qdev.h
+F: include/monitor/user-child.h
 F: include/qom/
 F: qapi/qom.json
 F: qapi/qdev.json
 F: scripts/coccinelle/qom-parent-type.cocci
 F: scripts/qom-cast-macro-clean-cocci-gen.py
 F: system/qdev-monitor.c
+F: system/user-child.c
 F: stubs/qdev.c
 F: qom/
 F: tests/unit/check-qom-interface.c
diff --git a/include/monitor/user-child.h b/include/monitor/user-child.h
new file mode 100644
index 000000000000..e246fcefe40a
--- /dev/null
+++ b/include/monitor/user-child.h
@@ -0,0 +1,57 @@
+/*
+ * Child configurable interface header.
+ *
+ * Copyright (c) 2023 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef USER_CHILD_H
+#define USER_CHILD_H
+
+#include "qom/object.h"
+
+#define TYPE_USER_CHILD "user-child"
+
+typedef struct UserChildClass UserChildClass;
+DECLARE_CLASS_CHECKERS(UserChildClass, USER_CHILD, TYPE_USER_CHILD)
+#define USER_CHILD(obj) INTERFACE_CHECK(UserChild, (obj), TYPE_USER_CHILD)
+
+typedef struct UserChild UserChild;
+
+/**
+ * UserChildClass:
+ * @get_parent: Method to get the default parent if user doesn't specify
+ *     the parent in cli.
+ * @get_child_name: Method to get the default device id for this device
+ *     if user doesn't specify id in cli.
+ * @check_parent: Method to check if the parent specified by user in cli
+ *     is valid.
+ */
+struct UserChildClass {
+    /* <private> */
+    InterfaceClass parent_class;
+
+    /* <public> */
+    Object *(*get_parent)(UserChild *uc, Error **errp);
+    char *(*get_child_name)(UserChild *uc, Object *parent);
+    bool (*check_parent)(UserChild *uc, Object *parent);
+};
+
+Object *uc_provide_default_parent(Object *obj, Error **errp);
+char *uc_name_future_child(Object *obj, Object *parent);
+bool uc_check_user_parent(Object *obj, Object *parent);
+
+#endif /* USER_CHILD_H */
diff --git a/include/qom/object.h b/include/qom/object.h
index 494eef801be3..f725d9452c76 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -1484,6 +1484,17 @@ Object *object_get_objects_root(void);
  */
 Object *object_get_internal_root(void);
 
+/**
+ * object_is_child_from:
+ * @child: the object.
+ * @parent: the parent/non-direct parent object.
+ *
+ * Check whether @parent is the parent/non-direct parent of @child.
+ *
+ * Returns: true iff @parent is the parent/non-direct parent of @child.
+ */
+bool object_is_child_from(const Object *child, const Object *parent);
+
 /**
  * object_get_canonical_path_component:
  * @obj: the object
diff --git a/qom/object.c b/qom/object.c
index da29e88816b5..d6f55aa59504 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -2024,6 +2024,19 @@ object_property_add_const_link(Object *obj, const char *name,
                                 NULL, OBJ_PROP_LINK_DIRECT);
 }
 
+bool object_is_child_from(const Object *child, const Object *parent)
+{
+    Object *obj = child->parent;
+
+    while (obj) {
+        if (obj == parent) {
+            return true;
+        }
+        obj = obj->parent;
+    }
+    return false;
+}
+
 const char *object_get_canonical_path_component(const Object *obj)
 {
     ObjectProperty *prop = NULL;
diff --git a/system/meson.build b/system/meson.build
index 3a64dd89de1f..ac682a3ca9e1 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -24,6 +24,7 @@ system_ss.add(files(
   'runstate-hmp-cmds.c',
   'runstate.c',
   'tpm-hmp-cmds.c',
+  'user-child.c',
   'vl.c',
 ), sdl, libpmem, libdaxctl)
 
diff --git a/system/qdev-monitor.c b/system/qdev-monitor.c
index 107411bb50cc..0261937b8462 100644
--- a/system/qdev-monitor.c
+++ b/system/qdev-monitor.c
@@ -22,6 +22,7 @@
 #include "monitor/hmp.h"
 #include "monitor/monitor.h"
 #include "monitor/qdev.h"
+#include "monitor/user-child.h"
 #include "sysemu/arch_init.h"
 #include "qapi/error.h"
 #include "qapi/qapi-commands-qdev.h"
@@ -585,26 +586,93 @@ static BusState *qbus_find(const char *path, Error **errp)
     return bus;
 }
 
+static Object *qdev_find_peripheral_parent(DeviceState *dev,
+                                           Error **errp)
+{
+    Object *parent_obj, *obj = OBJECT(dev);
+
+    parent_obj = uc_provide_default_parent(obj, errp);
+    if (*errp) {
+        return NULL;
+    }
+
+    if (parent_obj) {
+        /*
+         * Non-anonymous parents (under "/peripheral") are allowed to
+         * be accessed to create child<> properties.
+         */
+        if (object_is_child_from(parent_obj, qdev_get_peripheral())) {
+            return parent_obj;
+        }
+    }
+
+    return NULL;
+}
+
+static bool qdev_pre_check_device_id(char *id, Error **errp)
+{
+    bool ambiguous = false;
+    Object *obj;
+
+    if (!id) {
+        return true;
+    }
+
+    obj = object_resolve_path_from(qdev_get_peripheral(), id, &ambiguous);
+    if (obj || ambiguous) {
+        error_setg(errp, "Duplicate device default ID '%s'. "
+                   "Please specify another 'id'", id);
+        return false;
+    }
+    return true;
+}
+
 /* Takes ownership of @id, will be freed when deleting the device */
 const char *qdev_set_id(DeviceState *dev, char *id, Error **errp)
 {
+    Object *parent_obj = NULL;
     ObjectProperty *prop;
+    UserChild *uc;
 
     assert(!dev->id && !dev->realized);
 
+    uc = (UserChild *)object_dynamic_cast(OBJECT(dev), TYPE_USER_CHILD);
+
+    if (uc) {
+        parent_obj = qdev_find_peripheral_parent(dev, errp);
+        if (*errp) {
+            goto err;
+        }
+
+        if (!id && parent_obj) {
+            /*
+             * Covert anonymous device with user-child interface to
+             * non-anonymous, then it will be insert under "/peripheral"
+             * path.
+             */
+            id = uc_name_future_child(OBJECT(dev), parent_obj);
+            if (!qdev_pre_check_device_id(id, errp)) {
+                goto err;
+            }
+        }
+    }
+
     /*
      * object_property_[try_]add_child() below will assert the device
      * has no parent
      */
     if (id) {
-        prop = object_property_try_add_child(qdev_get_peripheral(), id,
+        if (!parent_obj) {
+            parent_obj = qdev_get_peripheral();
+        }
+
+        prop = object_property_try_add_child(parent_obj, id,
                                              OBJECT(dev), NULL);
         if (prop) {
             dev->id = id;
         } else {
             error_setg(errp, "Duplicate device ID '%s'", id);
-            g_free(id);
-            return NULL;
+            goto err;
         }
     } else {
         static int anon_count;
@@ -615,6 +683,9 @@ const char *qdev_set_id(DeviceState *dev, char *id, Error **errp)
     }
 
     return prop->name;
+err:
+    g_free(id);
+    return NULL;
 }
 
 DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
@@ -885,12 +956,18 @@ void qmp_device_add(QDict *qdict, QObject **ret_data, Error **errp)
 
 static DeviceState *find_device_state(const char *id, Error **errp)
 {
-    Object *obj = object_resolve_path_at(qdev_get_peripheral(), id);
+    bool ambiguous = false;
     DeviceState *dev;
+    Object *obj;
 
+    obj = object_resolve_path_from(qdev_get_peripheral(), id, &ambiguous);
     if (!obj) {
-        error_set(errp, ERROR_CLASS_DEVICE_NOT_FOUND,
-                  "Device '%s' not found", id);
+        if (ambiguous) {
+            error_setg(errp, "Device ID '%s' is ambiguous", id);
+        } else {
+            error_set(errp, ERROR_CLASS_DEVICE_NOT_FOUND,
+                      "Device '%s' not found", id);
+        }
         return NULL;
     }
 
diff --git a/system/user-child.c b/system/user-child.c
new file mode 100644
index 000000000000..1e667f09cc87
--- /dev/null
+++ b/system/user-child.c
@@ -0,0 +1,72 @@
+/*
+ * Child configurable interface.
+ *
+ * Copyright (c) 2023 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+
+#include "monitor/user-child.h"
+
+Object *uc_provide_default_parent(Object *obj, Error **errp)
+{
+    UserChild *uc = USER_CHILD(obj);
+    UserChildClass *ucc = USER_CHILD_GET_CLASS(uc);
+
+    if (ucc->get_parent) {
+        return ucc->get_parent(uc, errp);
+    }
+
+    return NULL;
+}
+
+char *uc_name_future_child(Object *obj, Object *parent)
+{
+    UserChild *uc = USER_CHILD(obj);
+    UserChildClass *ucc = USER_CHILD_GET_CLASS(uc);
+
+    if (ucc->get_child_name) {
+        return ucc->get_child_name(uc, parent);
+    }
+
+    return NULL;
+}
+
+bool uc_check_user_parent(Object *obj, Object *parent)
+{
+    UserChild *uc = USER_CHILD(obj);
+    UserChildClass *ucc = USER_CHILD_GET_CLASS(uc);
+
+    if (ucc->check_parent) {
+        ucc->check_parent(uc, parent);
+    }
+
+    return true;
+}
+
+static const TypeInfo user_child_interface_info = {
+    .name          = TYPE_USER_CHILD,
+    .parent        = TYPE_INTERFACE,
+    .class_size = sizeof(UserChildClass),
+};
+
+static void user_child_register_types(void)
+{
+    type_register_static(&user_child_interface_info);
+}
+
+type_init(user_child_register_types)
-- 
2.34.1


