Return-Path: <kvm+bounces-1911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D65E07EEC21
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 465D21F24F63
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 06:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4991DD528;
	Fri, 17 Nov 2023 06:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RL9RiwcL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03126196
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 22:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700201333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dnx8Wy0kmvFz85ddxqlu+04DnnoUXIEIY79UvTlQTEo=;
	b=RL9RiwcLBfF0eAynd07i5TwA9tYf55ryqimjF8Ev81hpSggpmhry/YLVl9Kj4cdWx6uT97
	GjMQyftK49yetB8TccL+SM7pdNHMb6np2pXdte8LlNJV0qBWo8dr8UEpDPqB4o7Jrnxj7M
	AvfXPrJ65lPAXPKbCXgUUXhxQtNMfuw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-SGbQOF6ZNOq2i5k11GsxBw-1; Fri,
 17 Nov 2023 01:08:49 -0500
X-MC-Unique: SGbQOF6ZNOq2i5k11GsxBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 273B73C0BE2C;
	Fri, 17 Nov 2023 06:08:49 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 194765028;
	Fri, 17 Nov 2023 06:08:49 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: qemu-arm@nongnu.org
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Date: Fri, 17 Nov 2023 01:08:38 -0500
Message-Id: <20231117060838.39723-1-shahuang@redhat.com>
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

The `pmu-filter` has such format:

  pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"

The A means "allow" and D means "deny", start is the first event of the
range and the end is the last one. The first filter action defines if the whole
event list is an allow or deny list, if the first filter action is "allow", all
other events are denied except start-end; if the first filter action is "deny",
all other events are allowed except start-end. For example:

  pmu-filter="A:0x11-0x11;A:0x23-0x3a,D:0x30-0x30"

This will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
also allowed except the event 0x30 is denied, and all the other events
are disallowed.

Here is an real example shows how to use the PMU Event Filtering, when
we launch a guest by use kvm, add such command line:

  # qemu-system-aarch64 \
	-accel kvm,pmu-filter="D:0x11-0x11"

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
v1->v2:
  - Add more description for allow and deny meaning in 
    commit message.                                     [Sebastian]
  - Small improvement.                                  [Sebastian]

v1: https://lore.kernel.org/all/20231113081713.153615-1-shahuang@redhat.com/
---
 include/sysemu/kvm_int.h |  1 +
 qemu-options.hx          | 16 +++++++++++++
 target/arm/kvm.c         | 22 +++++++++++++++++
 target/arm/kvm64.c       | 51 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+)

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
index 42fd09e4de..dd3518092c 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                tb-size=n (TCG translation block cache size)\n"
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
+    "                pmu-filter={A,D}:start-end[;...] (KVM PMU Event Filter, default no filter. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
 SRST
@@ -259,6 +260,21 @@ SRST
         impact on the memory. By default, this feature is disabled
         (eager-split-size=0).
 
+    ``pmu-filter={A,D}:start-end[;...]``
+        KVM implements pmu event filtering to prevent a guest from being able to
+	sample certain events. It has the following format:
+
+	pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
+
+	The A means "allow" and D means "deny", start if the first event of the
+	range and the end is the last one. For example:
+
+	pmu-filter="A:0x11-0x11;A:0x23-0x3a,D:0x30-0x30"
+
+	This will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
+	also allowed except the event 0x30 is denied, and all the other events
+	are disallowed.
+
     ``notify-vmexit=run|internal-error|disable,notify-window=n``
         Enables or disables notify VM exit support on x86 host and specify
         the corresponding notify window to trigger the VM exit if enabled.
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7903e2ddde..74796de055 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1108,6 +1108,21 @@ static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
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
+    s->kvm_pmu_filter = g_strdup(pmu_filter);
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add(oc, "eager-split-size", "size",
@@ -1116,4 +1131,11 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
 
     object_class_property_set_description(oc, "eager-split-size",
         "Eager Page Split chunk size for hugepages. (default: 0, disabled)");
+
+    object_class_property_add_str(oc, "pmu-filter",
+                                  kvm_arch_get_pmu_filter,
+                                  kvm_arch_set_pmu_filter);
+
+    object_class_property_set_description(oc, "pmu-filter",
+        "PMU Event Filtering description for guest pmu. (default: NULL, disabled)");
 }
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 3c175c93a7..6eac328b48 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -10,6 +10,7 @@
  */
 
 #include "qemu/osdep.h"
+#include <asm-arm64/kvm.h>
 #include <sys/ioctl.h>
 #include <sys/ptrace.h>
 
@@ -131,6 +132,53 @@ static bool kvm_arm_set_device_attr(CPUState *cs, struct kvm_device_attr *attr,
     return true;
 }
 
+static void kvm_arm_pmu_filter_init(CPUState *cs)
+{
+    static bool pmu_filter_init = false;
+    struct kvm_pmu_event_filter filter;
+    struct kvm_device_attr attr = {
+        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
+        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
+        .addr       = (uint64_t)&filter,
+    };
+    KVMState *kvm_state = cs->kvm_state;
+    char *tmp;
+    char *str, act;
+
+    if (!kvm_state->kvm_pmu_filter)
+        return;
+
+    /* This only needs to be called for 1 vcpu. */
+    if (!pmu_filter_init)
+        pmu_filter_init = true;
+
+    tmp = g_strdup(kvm_state->kvm_pmu_filter);
+
+    for (str = strtok(tmp, ";"); str != NULL; str = strtok(NULL, ";")) {
+        unsigned short start = 0, end = 0;
+
+        sscanf(str, "%c:%hx-%hx", &act, &start, &end);
+        if ((act != 'A' && act != 'D') || (!start && !end)) {
+            error_report("skipping invalid filter %s\n", str);
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
+            error_report("Failed to init PMU Event Filter\n");
+            abort();
+        }
+    }
+
+    g_free(tmp);
+}
+
 void kvm_arm_pmu_init(CPUState *cs)
 {
     struct kvm_device_attr attr = {
@@ -141,6 +189,9 @@ void kvm_arm_pmu_init(CPUState *cs)
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


