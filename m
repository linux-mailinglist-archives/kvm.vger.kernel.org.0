Return-Path: <kvm+bounces-42994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A00A2A81F39
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 10:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D5AC46164C
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A8125B68C;
	Wed,  9 Apr 2025 08:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKG/vBTE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0427E25C6EB
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 08:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185982; cv=none; b=MwFBViUZ/jU8kUAkB10IZ6ACMM9iC4d5y52EtO+kqzyUnX24Pj8+MqyyhVjxRVlnRnLESCyJ8A8hC5WD1qmR+FOq9PSVAvwkj7H1qfc303udIMts6SbW+yeUAafEvHE62neB/om9w3PBitx4fbcU5iuFxtZ22C+WwvAIyqjH1tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185982; c=relaxed/simple;
	bh=m7sVZ/4wIBYeTyDQv64Fe1AexRN6e7uu1A5Osea0uOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iiETbNdGPnIjf4izmdL7C0VDX1RskD45NQ16v4sRsSeIlUtfU5Dclx+w3WbpIAIE8yD2xZT0p9qXHyGBhktPiT9KbZKaeECsgERvZBMMO6Vi8Veaqyo5f/Lm2qXqqWC0FF0InZdxlfH1msIFIJ5r11kBh2QvqTNTyAnU4aJv9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKG/vBTE; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744185980; x=1775721980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7sVZ/4wIBYeTyDQv64Fe1AexRN6e7uu1A5Osea0uOI=;
  b=BKG/vBTECFEFd60wPx7GO2/sc6p4DtfB6uE0Rk3dghkU2oBamB5WkeWF
   xmJ+efMwGj0F65NUSmXaCUkkglscHFJd+MN8CKiX0/Mvgz0Xdm4UGHS/1
   FmvuSP5MMDb5pYYlidujIgtOaVtU/1tyIc/A2kKCWYMaIPTTFF1yq/Vgr
   gDc4k1dk9VjXxCrU5xzBxo0TUcNSwJgfJQ+5qnenwoqtPEy09giXwB8Sk
   2IYJJI1f0OmBbc0rhPeQhhrhQYTJeCijYnMFy730hwopxZ8quEFUYNgwA
   WeFBLWcHZn2HFepOBmCEBlp/u7tTsb4lNUhESf8SOzaROzfqwNN/13lfW
   A==;
X-CSE-ConnectionGUID: m3uymQVgT4O5eio+kSvrhg==
X-CSE-MsgGUID: /wSbFl1iSJ6Ri8KckxP1Hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45810010"
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="45810010"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 01:06:19 -0700
X-CSE-ConnectionGUID: rtXBXcpMQCuYyqsQQC2Eng==
X-CSE-MsgGUID: 82CxaB9nShGNx+eqY6YJ7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="151702590"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 09 Apr 2025 01:06:14 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
Date: Wed,  9 Apr 2025 16:26:45 +0800
Message-Id: <20250409082649.14733-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250409082649.14733-1-zhao1.liu@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the kvm-pmu-filter object and support the PMU event with raw
format.

The raw format, as a native PMU event code representation, can be used
for several architectures.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
Changes since RFC v2:
 * Drop hexadecimal variants and support numeric version in QAPI
   directly. (Daniel)
 * Define three-level sections with new accelerator.json. (Markus)
 * QAPI style fixes:
   - KVMPMU* stuff -> KvmPmu*.
   - KVMPMUFilterProperty -> KVMPMUFilterProperties.
   - KVMPMUEventEncodeFmt -> KvmPmuEventFormat.
   - drop prefix in KvmPmuFilterAction and KvmPmuEventFormat.
 * Bump up the supported QAPI version to v10.1.
 * Add Tested-by from Yi.

Changes since RFC v1:
 * Make "action" as a global (per filter object) item, not a per-event
   parameter. (Dapeng)
 * Bump up the supported QAPI version to v10.0.
---
 MAINTAINERS              |   2 +
 accel/kvm/kvm-pmu.c      | 114 +++++++++++++++++++++++++++++++++++++++
 accel/kvm/meson.build    |   1 +
 include/system/kvm-pmu.h |  35 ++++++++++++
 qapi/accelerator.json    |  14 +++++
 qapi/kvm.json            |  84 +++++++++++++++++++++++++++++
 qapi/meson.build         |   1 +
 qapi/qapi-schema.json    |   1 +
 qapi/qom.json            |   3 ++
 9 files changed, 255 insertions(+)
 create mode 100644 accel/kvm/kvm-pmu.c
 create mode 100644 include/system/kvm-pmu.h
 create mode 100644 qapi/accelerator.json
 create mode 100644 qapi/kvm.json

diff --git a/MAINTAINERS b/MAINTAINERS
index d54b5578f883..3ca551025fb8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -434,6 +434,7 @@ F: accel/kvm/
 F: accel/stubs/kvm-stub.c
 F: include/hw/kvm/
 F: include/system/kvm*.h
+F: qapi/kvm.json
 F: scripts/kvm/kvm_flightrecorder
 
 ARM KVM CPUs
@@ -503,6 +504,7 @@ F: accel/Makefile.objs
 F: accel/stubs/Makefile.objs
 F: cpu-common.c
 F: cpu-target.c
+F: qapi/accelerator.c
 F: system/cpus.c
 
 Apple Silicon HVF CPUs
diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
new file mode 100644
index 000000000000..22f749bf9183
--- /dev/null
+++ b/accel/kvm/kvm-pmu.c
@@ -0,0 +1,114 @@
+/*
+ * QEMU KVM PMU Related Abstractions
+ *
+ * Copyright (C) 2025 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+
+#include "qapi/error.h"
+#include "qapi/qapi-visit-kvm.h"
+#include "qemu/cutils.h"
+#include "qom/object_interfaces.h"
+#include "system/kvm-pmu.h"
+
+static void kvm_pmu_filter_set_action(Object *obj, int value,
+                                      Error **errp G_GNUC_UNUSED)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+
+    filter->action = value;
+}
+
+static int kvm_pmu_filter_get_action(Object *obj,
+                                     Error **errp G_GNUC_UNUSED)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+
+    return filter->action;
+}
+
+static void kvm_pmu_filter_get_event(Object *obj, Visitor *v, const char *name,
+                                     void *opaque, Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+
+    visit_type_KvmPmuFilterEventList(v, name, &filter->events, errp);
+}
+
+static void kvm_pmu_filter_set_event(Object *obj, Visitor *v, const char *name,
+                                     void *opaque, Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+    KvmPmuFilterEventList *head = NULL, *old_head, *node;
+    int nevents = 0;
+
+    old_head = filter->events;
+    if (!visit_type_KvmPmuFilterEventList(v, name, &head, errp)) {
+        return;
+    }
+
+    for (node = head; node; node = node->next) {
+        switch (node->value->format) {
+        case KVM_PMU_EVENT_FORMAT_RAW:
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        nevents++;
+    }
+
+    filter->nevents = nevents;
+    filter->events = head;
+    qapi_free_KvmPmuFilterEventList(old_head);
+    return;
+}
+
+static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
+{
+    object_class_property_add_enum(oc, "action", "KvmPmuFilterAction",
+                                   &KvmPmuFilterAction_lookup,
+                                   kvm_pmu_filter_get_action,
+                                   kvm_pmu_filter_set_action);
+    object_class_property_set_description(oc, "action",
+                                          "KVM PMU event action");
+
+    object_class_property_add(oc, "events", "KvmPmuFilterEventList",
+                              kvm_pmu_filter_get_event,
+                              kvm_pmu_filter_set_event,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "events",
+                                          "KVM PMU event list");
+}
+
+static void kvm_pmu_filter_instance_init(Object *obj)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+
+    filter->action = KVM_PMU_FILTER_ACTION_ALLOW;
+    filter->nevents = 0;
+}
+
+static const TypeInfo kvm_pmu_filter_info = {
+    .parent = TYPE_OBJECT,
+    .name = TYPE_KVM_PMU_FILTER,
+    .class_init = kvm_pmu_filter_class_init,
+    .instance_size = sizeof(KVMPMUFilter),
+    .instance_init = kvm_pmu_filter_instance_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
+static void kvm_pmu_event_register_type(void)
+{
+    type_register_static(&kvm_pmu_filter_info);
+}
+
+type_init(kvm_pmu_event_register_type);
diff --git a/accel/kvm/meson.build b/accel/kvm/meson.build
index 397a1fe1fd1e..dfab2854f3a8 100644
--- a/accel/kvm/meson.build
+++ b/accel/kvm/meson.build
@@ -2,6 +2,7 @@ kvm_ss = ss.source_set()
 kvm_ss.add(files(
   'kvm-all.c',
   'kvm-accel-ops.c',
+  'kvm-pmu.c',
 ))
 
 specific_ss.add_all(when: 'CONFIG_KVM', if_true: kvm_ss)
diff --git a/include/system/kvm-pmu.h b/include/system/kvm-pmu.h
new file mode 100644
index 000000000000..818fa309c191
--- /dev/null
+++ b/include/system/kvm-pmu.h
@@ -0,0 +1,35 @@
+/*
+ * QEMU KVM PMU Related Abstraction Header
+ *
+ * Copyright (C) 2025 Intel Corporation.
+ *
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef KVM_PMU_H
+#define KVM_PMU_H
+
+#include "qapi/qapi-types-kvm.h"
+#include "qom/object.h"
+
+#define TYPE_KVM_PMU_FILTER "kvm-pmu-filter"
+OBJECT_DECLARE_SIMPLE_TYPE(KVMPMUFilter, KVM_PMU_FILTER)
+
+/**
+ * KVMPMUFilter:
+ * @action: action that KVM PMU filter will take for selected PMU events.
+ * @nevents: number of PMU event entries listed in @events
+ * @events: list of PMU event entries.  A PMU event entry may represent one
+ *    event or multiple events due to its format.
+ */
+struct KVMPMUFilter {
+    Object parent_obj;
+
+    KvmPmuFilterAction action;
+    uint32_t nevents;
+    KvmPmuFilterEventList *events;
+};
+
+#endif /* KVM_PMU_H */
diff --git a/qapi/accelerator.json b/qapi/accelerator.json
new file mode 100644
index 000000000000..1fe0d64be113
--- /dev/null
+++ b/qapi/accelerator.json
@@ -0,0 +1,14 @@
+# -*- Mode: Python -*-
+# vim: filetype=python
+#
+# Copyright (C) 2025 Intel Corporation.
+#
+# Author: Zhao Liu <zhao1.liu@intel.com>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+##
+# = Accelerators
+##
+
+{ 'include': 'kvm.json' }
diff --git a/qapi/kvm.json b/qapi/kvm.json
new file mode 100644
index 000000000000..1861d86a9726
--- /dev/null
+++ b/qapi/kvm.json
@@ -0,0 +1,84 @@
+# -*- Mode: Python -*-
+# vim: filetype=python
+#
+# Copyright (C) 2025 Intel Corporation.
+#
+# Author: Zhao Liu <zhao1.liu@intel.com>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+##
+# == KVM
+##
+
+##
+# === PMU stuff (KVM related)
+##
+
+##
+# @KvmPmuFilterAction:
+#
+# Actions that KVM PMU filter supports.
+#
+# @deny: disable the PMU event/counter in KVM PMU filter.
+#
+# @allow: enable the PMU event/counter in KVM PMU filter.
+#
+# Since 10.1
+##
+{ 'enum': 'KvmPmuFilterAction',
+  'data': ['allow', 'deny'] }
+
+##
+# @KvmPmuEventFormat:
+#
+# Encoding formats of PMU event that QEMU/KVM supports.
+#
+# @raw: the encoded event code that KVM can directly consume.
+#
+# Since 10.1
+##
+{ 'enum': 'KvmPmuEventFormat',
+  'data': ['raw'] }
+
+##
+# @KvmPmuRawEvent:
+#
+# Raw PMU event code.
+#
+# @code: the raw value that has been encoded, and QEMU could deliver
+#     to KVM directly.
+#
+# Since 10.1
+##
+{ 'struct': 'KvmPmuRawEvent',
+  'data': { 'code': 'uint64' } }
+
+##
+# @KvmPmuFilterEvent:
+#
+# PMU event filtered by KVM.
+#
+# @format: PMU event format.
+#
+# Since 10.1
+##
+{ 'union': 'KvmPmuFilterEvent',
+  'base': { 'format': 'KvmPmuEventFormat' },
+  'discriminator': 'format',
+  'data': { 'raw': 'KvmPmuRawEvent' } }
+
+##
+# @KvmPmuFilterProperties:
+#
+# Properties of KVM PMU Filter.
+#
+# @action: action that KVM PMU filter will take for selected PMU events.
+#
+# @events: list of selected PMU events.
+#
+# Since 10.1
+##
+{ 'struct': 'KvmPmuFilterProperties',
+  'data': { 'action': 'KvmPmuFilterAction',
+            '*events': ['KvmPmuFilterEvent'] } }
diff --git a/qapi/meson.build b/qapi/meson.build
index eadde4db307f..dba27ebc7489 100644
--- a/qapi/meson.build
+++ b/qapi/meson.build
@@ -37,6 +37,7 @@ qapi_all_modules = [
   'error',
   'introspect',
   'job',
+  'kvm',
   'machine-common',
   'machine',
   'machine-target',
diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
index c41c01eb2ab9..c7fed7940af7 100644
--- a/qapi/qapi-schema.json
+++ b/qapi/qapi-schema.json
@@ -66,6 +66,7 @@
 { 'include': 'compat.json' }
 { 'include': 'control.json' }
 { 'include': 'introspect.json' }
+{ 'include': 'accelerator.json' }
 { 'include': 'qom.json' }
 { 'include': 'qdev.json' }
 { 'include': 'machine-common.json' }
diff --git a/qapi/qom.json b/qapi/qom.json
index 28ce24cd8d08..517f4c06c260 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -8,6 +8,7 @@
 { 'include': 'block-core.json' }
 { 'include': 'common.json' }
 { 'include': 'crypto.json' }
+{ 'include': 'kvm.json' }
 
 ##
 # = QEMU Object Model (QOM)
@@ -1108,6 +1109,7 @@
       'if': 'CONFIG_LINUX' },
     'iommufd',
     'iothread',
+    'kvm-pmu-filter',
     'main-loop',
     { 'name': 'memory-backend-epc',
       'if': 'CONFIG_LINUX' },
@@ -1183,6 +1185,7 @@
                                       'if': 'CONFIG_LINUX' },
       'iommufd':                    'IOMMUFDProperties',
       'iothread':                   'IothreadProperties',
+      'kvm-pmu-filter':             'KvmPmuFilterProperties',
       'main-loop':                  'MainLoopProperties',
       'memory-backend-epc':         { 'type': 'MemoryBackendEpcProperties',
                                       'if': 'CONFIG_LINUX' },
-- 
2.34.1


