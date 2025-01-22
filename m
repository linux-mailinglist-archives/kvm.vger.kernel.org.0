Return-Path: <kvm+bounces-36232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08744A18DBE
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAC757A4BE3
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569C020FA85;
	Wed, 22 Jan 2025 08:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MJVDnUgO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBA11C3C1F
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737535594; cv=none; b=mTsLRqTAqX7Be8+Cm4NKzGnz6MCeylSa8UfO5PejXo/LCwOgfpxsUrk7F4uBH+9PGRrzat0Lo10fJjS5q3pkRKam32P929QzT0o/c8F0NngqgIZ+vEGJwqUERszXgwfR40Y1gJkN6PB2M4s2UDjo5jdjA8pt802nUt8Bg2OzSAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737535594; c=relaxed/simple;
	bh=tx3RGOKpgLyLZ7GXDq98/4kQnth6yPo3Tpolx+oTmh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FpdZ0OucluCn7ysP2xIL1qu4tig7Vf3qg9iy27vgLsn+ZItUYnmHwwDhwrW/p47SdRGWogL6p93QtsuB+exdIZj69HeV6gKcoNhFdDkNMGJFAGYK1zeHKjIsFqBfGymq9C9XWDOhDEQfczCORqti47+3HS56rdQNQaYkJRLn9oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MJVDnUgO; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737535593; x=1769071593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tx3RGOKpgLyLZ7GXDq98/4kQnth6yPo3Tpolx+oTmh8=;
  b=MJVDnUgOBm3fiOCxClubxmJu/7ogMmeBc6IEQjciGvbMMGVKw1F/oDLu
   OFh8DhumYilt0O/Yzb+FgcDGpCd4ui99G4O4HM7OtK8pWERhbvtjORX5d
   Qe7fN2SOOKi/IhTZyMhgbRv7EfvuqbIbiUep/L3tVztFXBR+BzS/NawPV
   oz+y3dD0DANN/IuelDUdIyo6eQvnOgTRZ4+GBrjBqdIO5VSGbUoSl4T2d
   AHlQJd9bhuSvI3HBbTZYLIikbHAf/Mp7W10L+9MfzVXfMIN8fSL9BLIsm
   XbYDBh0an4SGLgpJN016/cEU0HGQFU+ckyBU1IhraGkPk3ByouG5xTH7B
   A==;
X-CSE-ConnectionGUID: 7gbg7otdRr6m5N3gQT8k4w==
X-CSE-MsgGUID: 4FXk4QSYSHW09Fy0vfoG7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="60451601"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="60451601"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 00:46:33 -0800
X-CSE-ConnectionGUID: wzwRvwuNTkGoUHIrSuVrPg==
X-CSE-MsgGUID: WmOy/5HuR/WwhfHG2pABlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="112050019"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 22 Jan 2025 00:46:28 -0800
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
Subject: [RFC v2 5/5] i386/kvm: Support fixed counter in KVM PMU filter
Date: Wed, 22 Jan 2025 17:05:17 +0800
Message-Id: <20250122090517.294083-6-zhao1.liu@intel.com>
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

KVM_SET_PMU_EVENT_FILTER of x86 KVM allows user to configure x86 fixed
function counters by a bitmap.

Add the support of x86-fixed-counter in kvm-pmu-filter object and handle
this in i386 kvm codes.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v1:
 * Make "action" as a global (per filter object) item, not a per-counter
   parameter. (Dapeng)
 * Bump up the supported QAPI version to 10.0.
---
 accel/kvm/kvm-pmu.c      | 69 ++++++++++++++++++++++++++++++++++++++++
 include/system/kvm-pmu.h |  1 +
 qapi/kvm.json            | 30 ++++++++++++++++-
 target/i386/kvm/kvm.c    | 47 ++++++++++++++++-----------
 4 files changed, 127 insertions(+), 20 deletions(-)

diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
index 9d68cd15e477..b5e6f430632f 100644
--- a/accel/kvm/kvm-pmu.c
+++ b/accel/kvm/kvm-pmu.c
@@ -271,6 +271,66 @@ fail:
     qapi_free_KVMPMUFilterEventList(head);
 }
 
+static void kvm_pmu_filter_get_fixed_counter(Object *obj, Visitor *v,
+                                             const char *name, void *opaque,
+                                             Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(obj);
+    KVMPMUX86FixedCounterVariant *str_counter;
+
+    str_counter = g_new(KVMPMUX86FixedCounterVariant, 1);
+    str_counter->bitmap = g_strdup_printf("0x%x",
+                                          filter->x86_fixed_counter->bitmap);
+
+    visit_type_KVMPMUX86FixedCounterVariant(v, name, &str_counter, errp);
+    qapi_free_KVMPMUX86FixedCounterVariant(str_counter);
+}
+
+static void kvm_pmu_filter_set_fixed_counter(Object *obj, Visitor *v,
+                                             const char *name, void *opaque,
+                                             Error **errp)
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
 static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
 {
     object_class_property_add_enum(oc, "action", "KVMPMUFilterAction",
@@ -286,6 +346,15 @@ static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
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
diff --git a/include/system/kvm-pmu.h b/include/system/kvm-pmu.h
index 63402f75cfdc..1a1da37b6304 100644
--- a/include/system/kvm-pmu.h
+++ b/include/system/kvm-pmu.h
@@ -25,6 +25,7 @@ struct KVMPMUFilter {
     KVMPMUFilterAction action;
     uint32_t nevents;
     KVMPMUFilterEventList *events;
+    KVMPMUX86FixedCounter *x86_fixed_counter;
 };
 
 /*
diff --git a/qapi/kvm.json b/qapi/kvm.json
index a673e499e7ea..31447dfeffb0 100644
--- a/qapi/kvm.json
+++ b/qapi/kvm.json
@@ -120,6 +120,18 @@
             'x86-default': 'KVMPMUX86DefalutEvent',
             'x86-masked-entry': 'KVMPMUX86MaskedEntry' } }
 
+##
+# @KVMPMUX86FixedCounter:
+#
+# x86 fixed counter that KVM PMU filter supports.
+#
+# @bitmap: x86 fixed counter bitmap.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMUX86FixedCounter',
+  'data': { 'bitmap': 'uint32' } }
+
 ##
 # @KVMPMUFilterProperty:
 #
@@ -202,6 +214,19 @@
             'x86-default': 'KVMPMUX86DefalutEventVariant',
             'x86-masked-entry': 'KVMPMUX86MaskedEntryVariant' } }
 
+##
+# @KVMPMUX86FixedCounterVariant:
+#
+# The variant of KVMPMUX86FixedCounter with the string, rather than
+# the numeric value.
+#
+# @bitmap: x86 fixed counter bitmap.  This field is a uint32 string.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMUX86FixedCounterVariant',
+  'data': { 'bitmap': 'str' } }
+
 ##
 # @KVMPMUFilterPropertyVariant:
 #
@@ -211,8 +236,11 @@
 #
 # @events: the KVMPMUFilterEventVariant list.
 #
+# @x86-fixed-counter: enablement bitmap of x86 fixed counters.
+#
 # Since 10.0
 ##
 { 'struct': 'KVMPMUFilterPropertyVariant',
   'data': { 'action': 'KVMPMUFilterAction',
-            '*events': ['KVMPMUFilterEventVariant'] } }
+            '*events': ['KVMPMUFilterEventVariant'],
+            '*x86-fixed-counter': 'KVMPMUX86FixedCounterVariant' } }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 97b94c331271..56094361cb8f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6012,23 +6012,29 @@ static int kvm_install_pmu_event_filter(KVMState *s)
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
@@ -6656,16 +6662,19 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
     KVMPMUFilterEventList *events = filter->events;
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
     while (events) {
         KVMPMUFilterEvent *event = events->value;
         uint32_t flag;
-- 
2.34.1


