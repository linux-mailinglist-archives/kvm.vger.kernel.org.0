Return-Path: <kvm+bounces-3847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A65828085A8
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C72121C21ED5
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E4635289;
	Thu,  7 Dec 2023 10:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="he8mGmDT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2623128
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 02:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701945417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QvsWHGDFgv0/6IxU5OCp//kA2aPxlWchNyKCC6Vvtwk=;
	b=he8mGmDTa7X7UuvOZQpsV3jabCxuwPRq596ptHegmKXMY0+RG0K5t2ast7ZOROsqKqz9gX
	E0LDyh7ZRob5decbG+dXrCas3BFrmna/m/2TE5V9CmTuxtjdUf3X4quwUjjDvnrJPd80RA
	dZx2bpShxeULgvapMtVlpYoDk4CzDoQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-142-5lzXdSn6Oy-m1_K73HKHnA-1; Thu,
 07 Dec 2023 05:36:56 -0500
X-MC-Unique: 5lzXdSn6Oy-m1_K73HKHnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DED983C0F370;
	Thu,  7 Dec 2023 10:36:55 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF2DC8CD0;
	Thu,  7 Dec 2023 10:36:55 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: qemu-arm@nongnu.org
Cc: Eric Auger <eauger@redhat.com>,
	Gavin Shan <gshan@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Date: Thu,  7 Dec 2023 05:36:47 -0500
Message-Id: <20231207103648.2925112-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

The KVM_ARM_VCPU_PMU_V3_FILTER provide the ability to let the VMM decide
which PMU events are provided to the guest. Add a new option
`pmu-filter` as -accel sub-option to set the PMU Event Filtering.
Without the filter, the KVM will expose all events from the host to
guest by default.

The `pmu-filter` has such format:

  pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"

The A means "allow" and D means "deny", start is the first event of the
range and the end is the last one. The first registered range defines
the global policy(global ALLOW if the first @action is DENY, global DENY
if the first @action is ALLOW). The start and end only support hex
format now. For example:

  pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"

Since the first action is allow, we have a global deny policy. It
will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
also allowed except the event 0x30 is denied, and all the other events
are disallowed.

Here is an real example shows how to use the PMU Event Filtering, when
we launch a guest by use kvm, add such command line:

  # qemu-system-aarch64 \
	-accel kvm,pmu-filter="D:0x11-0x11"

Since the first action is deny, we have a global allow policy. This
disables the filtering of the cycle counter (event 0x11 being CPU_CYCLES).

And then in guest, use the perf to count the cycle:

  # perf stat sleep 1

   Performance counter stats for 'sleep 1':

              1.22 msec task-clock                       #    0.001 CPUs utilized
                 1      context-switches                 #  820.695 /sec
                 0      cpu-migrations                   #    0.000 /sec
                55      page-faults                      #   45.138 K/sec
   <not supported>      cycles
           1128954      instructions
            227031      branches                         #  186.323 M/sec
              8686      branch-misses                    #    3.83% of all branches

       1.002492480 seconds time elapsed

       0.001752000 seconds user
       0.000000000 seconds sys

As we can see, the cycle counter has been disabled in the guest, but
other pmu events are still work.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
v3->v4:
  - Fix the wrong check for pmu_filter_init.            [Sebastian]
  - Fix multiple alignment issue.                       [Gavin]
  - Report error by warn_report() instead of error_report(), and don't use
  abort() since the PMU Event Filter is an add-on and best-effort feature.
                                                        [Gavin]
  - Add several missing {  } for single line of code.   [Gavin]
  - Use the g_strsplit() to replace strtok().           [Gavin]

v2->v3:
  - Improve commits message, use kernel doc wording, add more explaination on
    filter example, fix some typo error.                [Eric]
  - Add g_free() in kvm_arch_set_pmu_filter() to prevent memory leak. [Eric]
  - Add more precise error message report.              [Eric]
  - In options doc, add pmu-filter rely on KVM_ARM_VCPU_PMU_V3_FILTER support in
    KVM.                                                [Eric]

v1->v2:
  - Add more description for allow and deny meaning in 
    commit message.                                     [Sebastian]
  - Small improvement.                                  [Sebastian]

v2: https://lore.kernel.org/all/20231117060838.39723-1-shahuang@redhat.com/
v1: https://lore.kernel.org/all/20231113081713.153615-1-shahuang@redhat.com/
---
 include/sysemu/kvm_int.h |  1 +
 qemu-options.hx          | 21 +++++++++++
 target/arm/kvm.c         | 23 ++++++++++++
 target/arm/kvm64.c       | 75 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 120 insertions(+)

diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index fd846394be..8f4601474f 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -120,6 +120,7 @@ struct KVMState
     uint32_t xen_caps;
     uint16_t xen_gnttab_max_frames;
     uint16_t xen_evtchn_max_pirq;
+    char *kvm_pmu_filter;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/qemu-options.hx b/qemu-options.hx
index 42fd09e4de..054865ba0d 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                tb-size=n (TCG translation block cache size)\n"
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
+    "                pmu-filter={A,D}:start-end[;{A,D}:start-end...] (KVM PMU Event Filter, default no filter. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
 SRST
@@ -259,6 +260,26 @@ SRST
         impact on the memory. By default, this feature is disabled
         (eager-split-size=0).
 
+    ``pmu-filter={A,D}:start-end[;{A,D}:start-end...]``
+        KVM implements PMU Event Filtering to prevent a guest from being able to
+        sample certain events. It depends on the KVM_ARM_VCPU_PMU_V3_FILTER
+        attribute supported in KVM. It has the following format:
+
+        pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
+
+        The A means "allow" and D means "deny", start is the first event of the
+        range and the end is the last one. The first registered range defines
+        the global policy(global ALLOW if the first @action is DENY, global DENY
+        if the first @action is ALLOW). The start and end only support hex
+        format now. For example:
+
+        pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
+
+        Since the first action is allow, we have a global deny policy. It
+        will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
+        also allowed except the event 0x30 is denied, and all the other events
+        are disallowed.
+
     ``notify-vmexit=run|internal-error|disable,notify-window=n``
         Enables or disables notify VM exit support on x86 host and specify
         the corresponding notify window to trigger the VM exit if enabled.
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7903e2ddde..1f73b83674 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1108,6 +1108,22 @@ static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
     s->kvm_eager_split_size = value;
 }
 
+static char *kvm_arch_get_pmu_filter(Object *obj, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+
+    return g_strdup(s->kvm_pmu_filter);
+}
+
+static void kvm_arch_set_pmu_filter(Object *obj, const char *pmu_filter,
+                                    Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+
+    g_free(s->kvm_pmu_filter);
+    s->kvm_pmu_filter = g_strdup(pmu_filter);
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add(oc, "eager-split-size", "size",
@@ -1116,4 +1132,11 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
 
     object_class_property_set_description(oc, "eager-split-size",
         "Eager Page Split chunk size for hugepages. (default: 0, disabled)");
+
+    object_class_property_add_str(oc, "pmu-filter",
+                                  kvm_arch_get_pmu_filter,
+                                  kvm_arch_set_pmu_filter);
+
+    object_class_property_set_description(oc, "pmu-filter",
+        "PMU Event Filtering description for guest PMU. (default: NULL, disabled)");
 }
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 3c175c93a7..0ed6744057 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -10,6 +10,7 @@
  */
 
 #include "qemu/osdep.h"
+#include <asm-arm64/kvm.h>
 #include <sys/ioctl.h>
 #include <sys/ptrace.h>
 
@@ -131,6 +132,77 @@ static bool kvm_arm_set_device_attr(CPUState *cs, struct kvm_device_attr *attr,
     return true;
 }
 
+static void kvm_arm_pmu_filter_init(CPUState *cs)
+{
+    KVMState *kvm_state = cs->kvm_state;
+    static bool pmu_filter_init = false;
+    struct kvm_pmu_event_filter filter;
+    struct kvm_device_attr attr = {
+        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
+        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
+        .addr       = (uint64_t)&filter,
+    };
+    char act;
+    int i;
+    gchar **event_filters;
+
+    if (!kvm_state->kvm_pmu_filter)
+        return;
+
+    if (kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, &attr)) {
+        warn_report("The kernel doesn't support the PMU Event Filter!\n");
+        return;
+    }
+
+    /* The filter only needs to be initialized for 1 vcpu. */
+    if (pmu_filter_init) {
+        return;
+    }
+    pmu_filter_init = true;
+
+    event_filters = g_strsplit(kvm_state->kvm_pmu_filter, ";", -1);
+
+    for (i = 0; event_filters[i]; i++) {
+        unsigned short start = 0, end = 0;
+
+        sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end);
+        if ((act != 'A' && act != 'D') || (!start && !end)) {
+            warn_report("Skipping invalid PMU filter %s\n", event_filters[i]);
+            continue;
+        }
+
+        filter = (struct kvm_pmu_event_filter) {
+            .base_event     = start,
+            .nevents        = end - start + 1,
+            .action         = act == 'A' ? KVM_PMU_EVENT_ALLOW :
+                                           KVM_PMU_EVENT_DENY,
+        };
+
+        if (!kvm_arm_set_device_attr(cs, &attr, "PMU Event Filter")) {
+            if (errno == EINVAL) {
+                warn_report("Invalid PMU filter range [0x%x-0x%x]. "
+                             "ARMv8.0 support 10 bits event space, "
+                             "ARMv8.1 support 16 bits event space",
+                             start, end);
+            }
+            else if (errno == ENODEV) {
+                warn_report("GIC not initialized");
+            }
+            else if (errno == ENXIO) {
+                warn_report("PMUv3 not properly configured or in-kernel irqchip "
+                            "not configured.");
+            }
+            else if (errno == EBUSY) {
+                warn_report("PMUv3 already initialized or a VCPU has already run");
+            }
+
+            break;
+        }
+    }
+
+    g_strfreev(event_filters);
+}
+
 void kvm_arm_pmu_init(CPUState *cs)
 {
     struct kvm_device_attr attr = {
@@ -141,6 +213,9 @@ void kvm_arm_pmu_init(CPUState *cs)
     if (!ARM_CPU(cs)->has_pmu) {
         return;
     }
+
+    kvm_arm_pmu_filter_init(cs);
+
     if (!kvm_arm_set_device_attr(cs, &attr, "PMU")) {
         error_report("failed to init PMU");
         abort();
-- 
2.40.1


