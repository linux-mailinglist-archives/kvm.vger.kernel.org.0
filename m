Return-Path: <kvm+bounces-36228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2BAA18DB9
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A63921620DC
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C871F75B2;
	Wed, 22 Jan 2025 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hvgppxuy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FFA1C3C0B
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737535574; cv=none; b=ZB66EMl0ZgClms789ukwJTQL8UiM5lBqYP7rvnzJcN5kfaQ7hOT83MNfS9OidSD2fWbuYPaVm6Hyea0wyLB+HOOSWXCOsYolfHIEDpH8LV16GgyaaoT2v/UnPiPUf/zpRSAMmJWoQ/pSz1bywCmcSNZxIkx9HNr9OGki874lr30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737535574; c=relaxed/simple;
	bh=HP1zZWGiw1yE/RZYTSNmKOwsJodBHoq6Uwf30q0PM8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ASAYQwsQnwLgAzvk7wDDThzIPsOEc+2aSOeZxPXcHyGksafS6JLzVEw0eSfsd7ONOEQuZCg35FsoF6ZHohbw73MYqtOPn5RZ7juMJHH4fVpkIKhZa4INrHr9k0jwsZJ25gE43iGNWxfxvFhNwpg2MEeh/dUdF1G0ftaaK0RDtjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hvgppxuy; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737535573; x=1769071573;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HP1zZWGiw1yE/RZYTSNmKOwsJodBHoq6Uwf30q0PM8c=;
  b=hvgppxuyElZs9NCeT206eu3t6vrfAcek5pOrgp9jsVak32Mg+5aZSjQb
   6ZnGCbjl4eCY3cGFrz2MkeaAlxG/fvPD8B908WIOcFPef55Msen09NLLr
   /EPBj9Ft9HRsgjGfrfHhKI9cp4gpVT/KCPzpoaQQZVprOeHGodTEHwA++
   v69uOYedty+4oMEPe3CaLjrZEIR+B2ewYClE1O1XvTWRFUwPSQKpPq00x
   Q+XRKPFeIntg9LWjoGov3YeGKGKJbDZi9A1gRX3Uy/SEzGn78VIr2MKNH
   eCOcsHF9kYwZ3pgKiUwMnMFxu1HmfyWoQq0YtrzNG0dffHaVHPcjBmj2d
   Q==;
X-CSE-ConnectionGUID: RwLto7ygSg6RYIb/0+48DQ==
X-CSE-MsgGUID: p+kG/WJzQz2xEZyYDFL0kA==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="60451546"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="60451546"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 00:46:13 -0800
X-CSE-ConnectionGUID: xyizYcnKT1aXiu9Q3we+jw==
X-CSE-MsgGUID: mMCxGChuQ8KsZox6WG6UNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="112049682"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 22 Jan 2025 00:46:08 -0800
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
Subject: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
Date: Wed, 22 Jan 2025 17:05:13 +0800
Message-Id: <20250122090517.294083-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250122090517.294083-1-zhao1.liu@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
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

Considering that PMU event related fields are commonly used in
hexadecimal, define KVMPMURawEventVariant, KVMPMUFilterEventVariant, and
KVMPMUFilterPropertyVariant in kvm.json to support hexadecimal number
strings in JSON.

Additionally, define the corresponding numeric versions of
KVMPMURawEvent, KVMPMUFilterEvent, and KVMPMUFilterProperty in kvm.json.
This allows to handle numeric values more effectively and take advantage
of the qapi helpers.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v1:
 * Make "action" as a global (per filter object) item, not a per-event
   parameter. (Dapeng)
 * Bump up the supported QAPI version to 10.0.
---
 MAINTAINERS              |   1 +
 accel/kvm/kvm-pmu.c      | 164 +++++++++++++++++++++++++++++++++++++++
 accel/kvm/meson.build    |   1 +
 include/system/kvm-pmu.h |  30 +++++++
 qapi/kvm.json            | 116 +++++++++++++++++++++++++++
 qapi/meson.build         |   1 +
 qapi/qapi-schema.json    |   1 +
 qapi/qom.json            |   3 +
 8 files changed, 317 insertions(+)
 create mode 100644 accel/kvm/kvm-pmu.c
 create mode 100644 include/system/kvm-pmu.h
 create mode 100644 qapi/kvm.json

diff --git a/MAINTAINERS b/MAINTAINERS
index 846b81e3ec03..21adc1c10607 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -440,6 +440,7 @@ F: accel/kvm/
 F: accel/stubs/kvm-stub.c
 F: include/hw/kvm/
 F: include/system/kvm*.h
+F: qapi/kvm.json
 F: scripts/kvm/kvm_flightrecorder
 
 ARM KVM CPUs
diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
new file mode 100644
index 000000000000..4d0d4e7a452b
--- /dev/null
+++ b/accel/kvm/kvm-pmu.c
@@ -0,0 +1,164 @@
+/*
+ * QEMU KVM PMU Abstractions
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
+    KVMPMUFilterEventList *node;
+    KVMPMUFilterEventVariantList *head = NULL;
+    KVMPMUFilterEventVariantList **tail = &head;
+
+    for (node = filter->events; node; node = node->next) {
+        KVMPMUFilterEventVariant *str_event;
+        KVMPMUFilterEvent *event = node->value;
+
+        str_event = g_new(KVMPMUFilterEventVariant, 1);
+        str_event->format = event->format;
+
+        switch (event->format) {
+        case KVM_PMU_EVENT_FMT_RAW:
+            str_event->u.raw.code = g_strdup_printf("0x%lx",
+                                                    event->u.raw.code);
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        QAPI_LIST_APPEND(tail, str_event);
+    }
+
+    visit_type_KVMPMUFilterEventVariantList(v, name, &head, errp);
+    qapi_free_KVMPMUFilterEventVariantList(head);
+}
+
+static void kvm_pmu_filter_set_event(Object *obj, Visitor *v, const char *name,
+                                     void *opaque, Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+    KVMPMUFilterEventVariantList *list, *node;
+    KVMPMUFilterEventList *head = NULL, *old_head;
+    KVMPMUFilterEventList **tail = &head;
+    int ret, nevents = 0;
+
+    if (!visit_type_KVMPMUFilterEventVariantList(v, name, &list, errp)) {
+        return;
+    }
+
+    for (node = list; node; node = node->next) {
+        KVMPMUFilterEvent *event = g_new(KVMPMUFilterEvent, 1);
+        KVMPMUFilterEventVariant *str_event = node->value;
+
+        event->format = str_event->format;
+
+        switch (str_event->format) {
+        case KVM_PMU_EVENT_FMT_RAW:
+            ret = qemu_strtou64(str_event->u.raw.code, NULL,
+                                0, &event->u.raw.code);
+            if (ret < 0) {
+                error_setg(errp,
+                           "Invalid %s PMU event (code: %s): %s. "
+                           "The code must be a uint64 string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.raw.code, strerror(-ret));
+                g_free(event);
+                goto fail;
+            }
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        nevents++;
+        QAPI_LIST_APPEND(tail, event);
+    }
+
+    old_head = filter->events;
+    filter->events = head;
+    filter->nevents = nevents;
+
+    qapi_free_KVMPMUFilterEventVariantList(list);
+    qapi_free_KVMPMUFilterEventList(old_head);
+    return;
+
+fail:
+    qapi_free_KVMPMUFilterEventList(head);
+}
+
+static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
+{
+    object_class_property_add_enum(oc, "action", "KVMPMUFilterAction",
+                                   &KVMPMUFilterAction_lookup,
+                                   kvm_pmu_filter_get_action,
+                                   kvm_pmu_filter_set_action);
+    object_class_property_set_description(oc, "action",
+                                          "KVM PMU event action");
+
+    object_class_property_add(oc, "events", "KVMPMUFilterEvent",
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
+    /* Initial state, 0 events allowed. */
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
index 000000000000..b09f70d3a370
--- /dev/null
+++ b/include/system/kvm-pmu.h
@@ -0,0 +1,30 @@
+/*
+ * QEMU KVM PMU Abstraction Header
+ *
+ * Copyright (C) 2024 Intel Corporation.
+ *
+ * Authors:
+ *  Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
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
+struct KVMPMUFilter {
+    Object parent_obj;
+
+    KVMPMUFilterAction action;
+    uint32_t nevents;
+    KVMPMUFilterEventList *events;
+};
+
+#endif /* KVM_PMU_H */
diff --git a/qapi/kvm.json b/qapi/kvm.json
new file mode 100644
index 000000000000..d51aeeba7cd8
--- /dev/null
+++ b/qapi/kvm.json
@@ -0,0 +1,116 @@
+# -*- Mode: Python -*-
+# vim: filetype=python
+
+##
+# = KVM based feature API
+##
+
+##
+# @KVMPMUFilterAction:
+#
+# Actions that KVM PMU filter supports.
+#
+# @deny: disable the PMU event/counter in KVM PMU filter.
+#
+# @allow: enable the PMU event/counter in KVM PMU filter.
+#
+# Since 10.0
+##
+{ 'enum': 'KVMPMUFilterAction',
+  'prefix': 'KVM_PMU_FILTER_ACTION',
+  'data': ['allow', 'deny'] }
+
+##
+# @KVMPMUEventEncodeFmt:
+#
+# Encoding formats of PMU event that QEMU/KVM supports.
+#
+# @raw: the encoded event code that KVM can directly consume.
+#
+# Since 10.0
+##
+{ 'enum': 'KVMPMUEventEncodeFmt',
+  'prefix': 'KVM_PMU_EVENT_FMT',
+  'data': ['raw'] }
+
+##
+# @KVMPMURawEvent:
+#
+# Raw PMU event code.
+#
+# @code: the raw value that has been encoded, and QEMU could deliver
+#     to KVM directly.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMURawEvent',
+  'data': { 'code': 'uint64' } }
+
+##
+# @KVMPMUFilterEvent:
+#
+# PMU event filtered by KVM.
+#
+# @format: PMU event format.
+#
+# Since 10.0
+##
+{ 'union': 'KVMPMUFilterEvent',
+  'base': { 'format': 'KVMPMUEventEncodeFmt' },
+  'discriminator': 'format',
+  'data': { 'raw': 'KVMPMURawEvent' } }
+
+##
+# @KVMPMUFilterProperty:
+#
+# Property of KVM PMU Filter.
+#
+# @events: the KVMPMUFilterEvent list.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMUFilterProperty',
+  'data': { '*events': ['KVMPMUFilterEvent'] } }
+
+##
+# @KVMPMURawEventVariant:
+#
+# The variant of KVMPMURawEvent with the string, rather than the
+# numeric value.
+#
+# @code: the raw value that has been encoded, and QEMU could deliver
+#     to KVM directly.  This field is a uint64 string.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMURawEventVariant',
+  'data': { 'code': 'str' } }
+
+##
+# @KVMPMUFilterEventVariant:
+#
+# The variant of KVMPMUFilterEvent.
+#
+# @format: PMU event format.
+#
+# Since 10.0
+##
+{ 'union': 'KVMPMUFilterEventVariant',
+  'base': { 'format': 'KVMPMUEventEncodeFmt' },
+  'discriminator': 'format',
+  'data': { 'raw': 'KVMPMURawEventVariant' } }
+
+##
+# @KVMPMUFilterPropertyVariant:
+#
+# The variant of KVMPMUFilterProperty.
+#
+# @action: action that KVM PMU filter will take.
+#
+# @events: the KVMPMUFilterEventVariant list.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMUFilterPropertyVariant',
+  'data': { 'action': 'KVMPMUFilterAction',
+            '*events': ['KVMPMUFilterEventVariant'] } }
diff --git a/qapi/meson.build b/qapi/meson.build
index e7bc54e5d047..856439c76b67 100644
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
index b1581988e4eb..742818d16e45 100644
--- a/qapi/qapi-schema.json
+++ b/qapi/qapi-schema.json
@@ -64,6 +64,7 @@
 { 'include': 'compat.json' }
 { 'include': 'control.json' }
 { 'include': 'introspect.json' }
+{ 'include': 'kvm.json' }
 { 'include': 'qom.json' }
 { 'include': 'qdev.json' }
 { 'include': 'machine-common.json' }
diff --git a/qapi/qom.json b/qapi/qom.json
index 28ce24cd8d08..c75ec4b21e95 100644
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
+      'kvm-pmu-filter':             'KVMPMUFilterPropertyVariant',
       'main-loop':                  'MainLoopProperties',
       'memory-backend-epc':         { 'type': 'MemoryBackendEpcProperties',
                                       'if': 'CONFIG_LINUX' },
-- 
2.34.1


