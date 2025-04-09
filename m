Return-Path: <kvm+bounces-42998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA75A81F67
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 10:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7827519E3BDE
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9704825B683;
	Wed,  9 Apr 2025 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q7sgayTs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F37525A65E
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 08:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744186005; cv=none; b=jZ5UQzvYVRl1ghx0/RMwBWf9ieqzybDaw2vPl6Gp5KL7o7qzoDgiSec6bkjMctJerSb7V7JdLBbNC9y2YaFUXcK5LL6UYPZBFbdverikP2a1E0FNkmbO6fNkS22t53EjLnX3Tm5J2WQ8xT4Tn706tD/tOQjSTn9sKYMdINedCAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744186005; c=relaxed/simple;
	bh=y/Ah2gIgHbe+sK/IOChNaZznI5EZIF+55b+SG00yUgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Li06zBnLkqwQVF3Xq6uf8i9zsFMGFpqCj44I5zw6MAEOalaptj/xRbJM+rc992n+5RogcJaRXmhkjf8hCjjoYbvnPBEWFb6XJ0Tc+6j2BazisFjdUB/P8PZQobDtA5uhMHydXzEhiVQqlMA1brfCYhVwhJ26pLSfPy83UZd+3Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q7sgayTs; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744186004; x=1775722004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y/Ah2gIgHbe+sK/IOChNaZznI5EZIF+55b+SG00yUgU=;
  b=Q7sgayTs31vVSE7e35pJ5/cQg0jAl9uih689PT5qLYXlxwm7m/Rdc2/n
   gIvQv23tfk1KG8BD3vzaARlk86rX1fkSXYlZ7mdU1g2g01ZKDNtqvgd3s
   m510FGlkKE4H400Z282W3S2voPRnWlAlMZjHqJENliYxXYGRLQ5HR0Jqi
   VbTth91bJKgr7UXz0dPfuJ2++lZppK4ifU0N7EvRWHyhEeLdA3KOazjVW
   mPyTswqNeGTwifxgjOn/AQyKmDp4Fp3+8NnkWC5C2Jt7yIhEJSLHmp+UW
   Zq/r220sJ/GKEW8Q4wP6XGpoHW7t5IIGVaZZzKyoH6K8Kj05tErMJpNHH
   g==;
X-CSE-ConnectionGUID: KzfK3yPTTYO2Escts37gcQ==
X-CSE-MsgGUID: 4CF4RmjGSIeqrXXfI/DAGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45810063"
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="45810063"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 01:06:43 -0700
X-CSE-ConnectionGUID: I97O+6i8RBm4yuoI5EFM2Q==
X-CSE-MsgGUID: eesw//O1SlG3FcXwB6y7cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="151702674"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 09 Apr 2025 01:06:38 -0700
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
Subject: [PATCH 5/5] i386/kvm: Support fixed counter in KVM PMU filter
Date: Wed,  9 Apr 2025 16:26:49 +0800
Message-Id: <20250409082649.14733-6-zhao1.liu@intel.com>
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

KVM_SET_PMU_EVENT_FILTER of x86 KVM allows user to configure x86 fixed
function counters by a bitmap.

Add the support of x86-fixed-counter in kvm-pmu-filter object and handle
this in i386 kvm codes.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
Changes since RFC v2:
 * Drop KVMPMUX86FixedCounter structure and use uint32_t to represent
   bitmap in QAPI directly.
 * Add Tested-by from Yi.
 * Add documentation in qemu-options.hx.
 * Bump up the supported QAPI version to v10.1.

Changes since RFC v1:
 * Make "action" as a global (per filter object) item, not a per-counter
   parameter. (Dapeng)
 * Bump up the supported QAPI version to v10.0.
---
 accel/kvm/kvm-pmu.c      | 31 +++++++++++++++++++++++++++++++
 include/system/kvm-pmu.h |  5 ++++-
 qapi/kvm.json            |  6 +++++-
 qemu-options.hx          |  6 +++++-
 target/i386/kvm/kvm.c    | 39 ++++++++++++++++++++++++---------------
 5 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
index 9205907d1779..509d69d9c515 100644
--- a/accel/kvm/kvm-pmu.c
+++ b/accel/kvm/kvm-pmu.c
@@ -101,6 +101,29 @@ fail:
     qapi_free_KvmPmuFilterEventList(head);
 }
 
+static void kvm_pmu_filter_get_fixed_counter(Object *obj, Visitor *v,
+                                             const char *name, void *opaque,
+                                             Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+
+    visit_type_uint32(v, name, &filter->x86_fixed_counter, errp);
+}
+
+static void kvm_pmu_filter_set_fixed_counter(Object *obj, Visitor *v,
+                                             const char *name, void *opaque,
+                                             Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+    uint32_t counter;
+
+    if (!visit_type_uint32(v, name, &counter, errp)) {
+        return;
+    }
+
+    filter->x86_fixed_counter = counter;
+}
+
 static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
 {
     object_class_property_add_enum(oc, "action", "KvmPmuFilterAction",
@@ -116,6 +139,14 @@ static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
                               NULL, NULL);
     object_class_property_set_description(oc, "events",
                                           "KVM PMU event list");
+
+    object_class_property_add(oc, "x86-fixed-counter", "uint32_t",
+                              kvm_pmu_filter_get_fixed_counter,
+                              kvm_pmu_filter_set_fixed_counter,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "x86-fixed-counter",
+                                          "Enablement bitmap of "
+                                          "x86 PMU fixed counter");
 }
 
 static void kvm_pmu_filter_instance_init(Object *obj)
diff --git a/include/system/kvm-pmu.h b/include/system/kvm-pmu.h
index 6abc0d037aee..5238b2b4dcc7 100644
--- a/include/system/kvm-pmu.h
+++ b/include/system/kvm-pmu.h
@@ -19,10 +19,12 @@ OBJECT_DECLARE_SIMPLE_TYPE(KVMPMUFilter, KVM_PMU_FILTER)
 
 /**
  * KVMPMUFilter:
- * @action: action that KVM PMU filter will take for selected PMU events.
+ * @action: action that KVM PMU filter will take for selected PMU events
+ *    and counters.
  * @nevents: number of PMU event entries listed in @events
  * @events: list of PMU event entries.  A PMU event entry may represent one
  *    event or multiple events due to its format.
+ * @x86_fixed_counter: bitmap of x86 fixed counter.
  */
 struct KVMPMUFilter {
     Object parent_obj;
@@ -30,6 +32,7 @@ struct KVMPMUFilter {
     KvmPmuFilterAction action;
     uint32_t nevents;
     KvmPmuFilterEventList *events;
+    uint32_t x86_fixed_counter;
 };
 
 /*
diff --git a/qapi/kvm.json b/qapi/kvm.json
index 1b523e058731..5374c8340e5a 100644
--- a/qapi/kvm.json
+++ b/qapi/kvm.json
@@ -115,7 +115,10 @@
 #
 # Properties of KVM PMU Filter.
 #
-# @action: action that KVM PMU filter will take for selected PMU events.
+# @action: action that KVM PMU filter will take for selected PMU events
+#     and counters.
+#
+# @x86-fixed-counter: enablement bitmap of x86 fixed counters.
 #
 # @events: list of selected PMU events.
 #
@@ -123,4 +126,5 @@
 ##
 { 'struct': 'KvmPmuFilterProperties',
   'data': { 'action': 'KvmPmuFilterAction',
+            '*x86-fixed-counter': 'uint32',
             '*events': ['KvmPmuFilterEvent'] } }
diff --git a/qemu-options.hx b/qemu-options.hx
index bb89198971e0..eadfb69c8876 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -6150,7 +6150,7 @@ SRST
 
             (qemu) qom-set /objects/iothread1 poll-max-ns 100000
 
-    ``-object '{"qom-type":"kvm-pmu-filter","id":id,"action":action,"events":[entry_list]}'``
+    ``-object '{"qom-type":"kvm-pmu-filter","id":id,"x86-fixed-counter":bitmap,"action":action,"events":[entry_list]}'``
         Create a kvm-pmu-filter object that configures KVM to filter
         selected PMU events for Guest.
 
@@ -6165,6 +6165,10 @@ SRST
         will be denied, while all other events can be accessed normally
         in the Guest.
 
+        The ``x86-fixed-counter`` parameter sets a bitmap of x86 fixed
+        counters, and ``action`` will also take effect on the selected
+        fixed counters.
+
         The ``events`` parameter accepts a list of PMU event entries in
         JSON format. Event entries, based on different encoding formats,
         have the following types:
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8786501e9c7e..8b916dbb5d6f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6016,19 +6016,25 @@ static int kvm_install_pmu_event_filter(KVMState *s)
         g_assert_not_reached();
     }
 
-    kvm_filter->flags = filter->events->value->format ==
-                        KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY ?
-                        KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
-
-    if (kvm_filter->flags == KVM_PMU_EVENT_FLAG_MASKED_EVENTS &&
-        !kvm_vm_check_extension(s, KVM_CAP_PMU_EVENT_MASKED_EVENTS)) {
-        error_report("Masked entry format of PMU event "
-                     "is not supported by Host.");
-        goto fail;
+    if (filter->x86_fixed_counter) {
+        kvm_filter->fixed_counter_bitmap = filter->x86_fixed_counter;
     }
 
-    if (!kvm_config_pmu_event(filter, kvm_filter)) {
-        goto fail;
+    if (filter->nevents) {
+        kvm_filter->flags = filter->events->value->format ==
+                            KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY ?
+                            KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
+
+        if (kvm_filter->flags == KVM_PMU_EVENT_FLAG_MASKED_EVENTS &&
+            !kvm_vm_check_extension(s, KVM_CAP_PMU_EVENT_MASKED_EVENTS)) {
+            error_report("Masked entry format of PMU event "
+                         "is not supported by Host.");
+            goto fail;
+        }
+
+        if (!kvm_config_pmu_event(filter, kvm_filter)) {
+            goto fail;
+        }
     }
 
     ret = kvm_vm_ioctl(s, KVM_SET_PMU_EVENT_FILTER, kvm_filter);
@@ -6656,16 +6662,19 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
     KvmPmuFilterEventList *events = filter->events;
     uint32_t base_flag;
 
-    if (!filter->nevents) {
+    if (!filter->x86_fixed_counter && !filter->nevents) {
         error_setg(errp,
                    "Empty KVM PMU filter.");
         return;
     }
 
     /* Pick the first event's flag as the base one. */
-    base_flag = events->value->format ==
-                KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY ?
-                KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
+    base_flag = 0;
+    if (filter->nevents &&
+        events->value->format == KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY) {
+        base_flag = KVM_PMU_EVENT_FLAG_MASKED_EVENTS;
+    }
+
     while (events) {
         KvmPmuFilterEvent *event = events->value;
         uint32_t flag;
-- 
2.34.1


