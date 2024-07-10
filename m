Return-Path: <kvm+bounces-21266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B15192C9F1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A59321F22AD6
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 04:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AC96AFAE;
	Wed, 10 Jul 2024 04:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLiSFBft"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5295A0F5
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 04:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720586186; cv=none; b=OoiwKZBXXgLgBe6GrzhCnCmfqt7xem/m5fU4T23CfZ5PQC/x1gIeNxJRtEmFyHBXMV84Sk5uD6Oia8vnljAnneRvw8QTFH2Go672aW/80TclBYZPcgioHqVEgp3TQjkJsNlWINYo16Tzf3G7y9qlZvaJ9b7UvL1QbLiN7A0Wmjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720586186; c=relaxed/simple;
	bh=6+OseQGpk2ndz6OpN+ZaTOVJXSOpCJ52+KKHCCTwnuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JpdaFnsJ2ztzX1drAjv3z7ufID4iauj6C0di+E/KNCTFMUuEmtZRITj5/EkK9A07qs2frvIyIRKCCjhPmAbuvMv+KyrMl3ajDKPGrs6AfFm7J0zAnOPXJY38IZcohL62B19KX3+KJBdZ9+qlAoBh82UVgQ9mb1IiZJETeHyV5Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PLiSFBft; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720586184; x=1752122184;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6+OseQGpk2ndz6OpN+ZaTOVJXSOpCJ52+KKHCCTwnuA=;
  b=PLiSFBftbaSmXtc4XIakB4nY5K+T5Af0a+eqWsU9Qm/sl44KfbhF+vUc
   hVowLMePgCg+fsK0rL8OsyjuQpAA/u47Xd1iTEE9qhIB3R9YRDe6ryXS9
   aG4OyzWruH4uK+JHzeVSns1e+9lkiBu6+2wGFk2s8Hevhh93MsKQqgc7s
   pkO1uS0wUYp9xnPoPVdQTNCnmJ+IbqMMiCUARJ38AUE+AtW1eDa/75xbk
   HLufUYiWPbAcw6N3lJjIru62a+93j/71KrpuAYFDUDF7LkiJ+XS11k2uD
   OaxdplbBOOI0LfvdzNMB4HduVwphWeMG9si0FVMlSL0FYJ8/G9SLsT2v8
   g==;
X-CSE-ConnectionGUID: eIOecysWS8uLW5J7I/4TVQ==
X-CSE-MsgGUID: 3FatIveWSca6oXMUMwhZ/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="28473824"
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="28473824"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 21:36:24 -0700
X-CSE-ConnectionGUID: Po2f5o8xT3y+ievXVp6YYg==
X-CSE-MsgGUID: LAxQ+A8ZQT+k+mRhg5v6ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="79238239"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 09 Jul 2024 21:36:18 -0700
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
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yuan Yao <yuan.yao@intel.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Jim Mattson <jmattson@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 5/5] i386/kvm: Support fixed counter in KVM PMU filter
Date: Wed, 10 Jul 2024 12:51:17 +0800
Message-Id: <20240710045117.3164577-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240710045117.3164577-1-zhao1.liu@intel.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
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
---
 accel/kvm/kvm-pmu.c      | 71 ++++++++++++++++++++++++++++++++++++++++
 include/sysemu/kvm-pmu.h |  1 +
 qapi/kvm.json            | 36 +++++++++++++++++++-
 target/i386/kvm/kvm.c    | 69 +++++++++++++++++++++++++-------------
 4 files changed, 153 insertions(+), 24 deletions(-)

diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
index 7a1720c68f8f..bad76482f426 100644
--- a/accel/kvm/kvm-pmu.c
+++ b/accel/kvm/kvm-pmu.c
@@ -256,6 +256,68 @@ fail:
     qapi_free_KVMPMUFilterEventList(head);
 }
 
+static void
+kvm_pmu_filter_get_fixed_counter(Object *obj, Visitor *v, const char *name,
+                                 void *opaque, Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+    KVMPMUX86FixedCounterVariant *str_counter;
+
+    str_counter = g_new(KVMPMUX86FixedCounterVariant, 1);
+    str_counter->action = filter->x86_fixed_counter->action;
+    str_counter->bitmap = g_strdup_printf("0x%x",
+                                          filter->x86_fixed_counter->bitmap);
+
+    visit_type_KVMPMUX86FixedCounterVariant(v, name, &str_counter, errp);
+    qapi_free_KVMPMUX86FixedCounterVariant(str_counter);
+}
+
+static void
+kvm_pmu_filter_set_fixed_counter(Object *obj, Visitor *v, const char *name,
+                                 void *opaque, Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+    KVMPMUX86FixedCounterVariant *str_counter;
+    KVMPMUX86FixedCounter *new_counter, *old_counter;
+    uint64_t bitmap;
+    int ret;
+
+    old_counter = filter->x86_fixed_counter;
+    if (!visit_type_KVMPMUX86FixedCounterVariant(v, name,
+                                                 &str_counter, errp)) {
+        return;
+    }
+
+    new_counter  = g_new(KVMPMUX86FixedCounter, 1);
+    new_counter->action = str_counter->action;
+
+    ret = qemu_strtou64(str_counter->bitmap, NULL,
+                        0, &bitmap);
+    if (ret < 0) {
+        error_setg(errp,
+                   "Invalid x86 fixed counter (bitmap: %s): %s. "
+                   "The bitmap must be a uint32 string.",
+                   str_counter->bitmap, strerror(-ret));
+        g_free(new_counter);
+        goto fail;
+    }
+    if (bitmap > UINT32_MAX) {
+        error_setg(errp,
+                   "Invalid x86 fixed counter (bitmap: %s): "
+                   "Numerical result out of range. "
+                   "The bitmap must be a uint32 string.",
+                   str_counter->bitmap);
+        g_free(new_counter);
+        goto fail;
+    }
+    new_counter->bitmap = bitmap;
+    filter->x86_fixed_counter = new_counter;
+    qapi_free_KVMPMUX86FixedCounter(old_counter);
+
+fail:
+    qapi_free_KVMPMUX86FixedCounterVariant(str_counter);
+}
+
 static void
 kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
 {
@@ -266,6 +328,15 @@ kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
                               NULL, NULL);
     object_class_property_set_description(oc, "events",
                                           "KVM PMU event list");
+
+    object_class_property_add(oc, "x86-fixed-counter",
+                              "KVMPMUX86FixedCounter",
+                              kvm_pmu_filter_get_fixed_counter,
+                              kvm_pmu_filter_set_fixed_counter,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "x86-fixed-counter",
+                                          "Enablement bitmap of "
+                                          "x86 PMU fixed counter");
 }
 
 static void kvm_pmu_filter_instance_init(Object *obj)
diff --git a/include/sysemu/kvm-pmu.h b/include/sysemu/kvm-pmu.h
index 707f33d604fd..e74a6a665565 100644
--- a/include/sysemu/kvm-pmu.h
+++ b/include/sysemu/kvm-pmu.h
@@ -24,6 +24,7 @@ struct KVMPMUFilter {
 
     uint32_t nevents;
     KVMPMUFilterEventList *events;
+    KVMPMUX86FixedCounter *x86_fixed_counter;
 };
 
 /*
diff --git a/qapi/kvm.json b/qapi/kvm.json
index f4e8854fa6c6..fe9a9ec940be 100644
--- a/qapi/kvm.json
+++ b/qapi/kvm.json
@@ -123,6 +123,21 @@
             'x86-default': 'KVMPMUX86DefalutEvent',
             'x86-masked-entry': 'KVMPMUX86MaskedEntry' } }
 
+##
+# @KVMPMUX86FixedCounter:
+#
+# x86 fixed counter that KVM PMU filter supports.
+#
+# @action: action that KVM PMU filter will take.
+#
+# @bitmap: x86 fixed counter bitmap.
+#
+# Since 9.1
+##
+{ 'struct': 'KVMPMUX86FixedCounter',
+  'data': { 'action': 'KVMPMUFilterAction',
+            'bitmap': 'uint32' } }
+
 ##
 # @KVMPMUFilterProperty:
 #
@@ -208,6 +223,22 @@
             'x86-default': 'KVMPMUX86DefalutEventVariant',
             'x86-masked-entry': 'KVMPMUX86MaskedEntryVariant' } }
 
+##
+# @KVMPMUX86FixedCounterVariant:
+#
+# The variant of KVMPMUX86FixedCounter with the string, rather than
+# the numeric value.
+#
+# @action: action that KVM PMU filter will take.
+#
+# @bitmap: x86 fixed counter bitmap.  This field is a uint32 string.
+#
+# Since 9.1
+##
+{ 'struct': 'KVMPMUX86FixedCounterVariant',
+  'data': { 'action': 'KVMPMUFilterAction',
+            'bitmap': 'str' } }
+
 ##
 # @KVMPMUFilterPropertyVariant:
 #
@@ -215,7 +246,10 @@
 #
 # @events: the KVMPMUFilterEventVariant list.
 #
+# @x86-fixed-counter: enablement bitmap of x86 fixed counters.
+#
 # Since 9.1
 ##
 { 'struct': 'KVMPMUFilterPropertyVariant',
-  'data': { '*events': ['KVMPMUFilterEventVariant'] } }
+  'data': { '*events': ['KVMPMUFilterEventVariant'],
+            '*x86-fixed-counter': 'KVMPMUX86FixedCounterVariant' } }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 396a93efe745..b350c4123ea2 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5419,6 +5419,7 @@ static bool kvm_install_pmu_event_filter(KVMState *s)
 {
     struct kvm_pmu_event_filter *kvm_filter;
     KVMPMUFilter *filter = s->pmu_filter;
+    KVMPMUFilterAction action;
     int ret;
 
     kvm_filter = g_malloc0(sizeof(struct kvm_pmu_event_filter) +
@@ -5426,9 +5427,14 @@ static bool kvm_install_pmu_event_filter(KVMState *s)
 
     /*
      * Currently, kvm-pmu-filter only supports configuring the same
-     * action for PMU events.
+     * action for PMU fixed-counters/events.
      */
-    switch (filter->events->value->action) {
+    if (filter->x86_fixed_counter) {
+        action = filter->x86_fixed_counter->action;
+    } else {
+        action = filter->events->value->action;
+    }
+    switch (action) {
     case KVM_PMU_FILTER_ACTION_ALLOW:
         kvm_filter->action = KVM_PMU_EVENT_ALLOW;
         break;
@@ -5439,23 +5445,29 @@ static bool kvm_install_pmu_event_filter(KVMState *s)
         g_assert_not_reached();
     }
 
-    /*
-     * The check in kvm_arch_check_pmu_filter() ensures masked entry
-     * format won't be mixed with other formats.
-     */
-    kvm_filter->flags = filter->events->value->format ==
-                        KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY ?
-                        KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
-
-    if (kvm_filter->flags == KVM_PMU_EVENT_FLAG_MASKED_EVENTS &&
-        !kvm_vm_check_extension(s, KVM_CAP_PMU_EVENT_MASKED_EVENTS)) {
-        error_report("Masked entry format of PMU event "
-                     "is not supported by Host.");
-        goto fail;
+    if (filter->x86_fixed_counter) {
+        kvm_filter->fixed_counter_bitmap = filter->x86_fixed_counter->bitmap;
     }
 
-    if (!kvm_config_pmu_event(filter, kvm_filter)) {
-        goto fail;
+    if (filter->nevents) {
+        /*
+         * The check in kvm_arch_check_pmu_filter() ensures masked entry
+         * format won't be mixed with other formats.
+         */
+        kvm_filter->flags = filter->events->value->format ==
+                            KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY ?
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
@@ -6088,17 +6100,24 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
     KVMPMUFilterAction action;
     uint32_t base_flag;
 
-    if (!filter->nevents) {
+    if (!filter->x86_fixed_counter && !filter->nevents) {
         error_setg(errp,
                    "Empty KVM PMU filter.");
         return;
     }
 
     /* Pick the first event's flag as the base one. */
-    base_flag = events->value->format ==
-                KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY ?
-                KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
+    base_flag = 0;
+    if (filter->nevents &&
+        events->value->format == KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY) {
+        base_flag = KVM_PMU_EVENT_FLAG_MASKED_EVENTS;
+    }
+
     action = KVM_PMU_FILTER_ACTION__MAX;
+    if (filter->x86_fixed_counter) {
+        action = filter->x86_fixed_counter->action;
+    }
+
     while (events) {
         KVMPMUFilterEvent *event = events->value;
         uint32_t flag;
@@ -6128,9 +6147,13 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
         if (action == KVM_PMU_FILTER_ACTION__MAX) {
             action = event->action;
         } else if (action != event->action) {
-            /* TODO: Support events with different actions if necessary. */
+            /*
+             * TODO: Support fixed-counters/events with different actions
+             * if necessary.
+             */
             error_setg(errp,
-                       "Only support PMU events with the same action");
+                       "Only support PMU fixed-counters/events "
+                       "with the same action");
             return;
         }
 
-- 
2.34.1


