Return-Path: <kvm+bounces-42995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE01A81F64
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 10:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38A1A19E1A18
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909A525B666;
	Wed,  9 Apr 2025 08:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LARmQwdk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F120D25A652
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 08:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185994; cv=none; b=nbaIAHKj5A8AV/ne3ffxF/KmHXtl59X1QaBkk6caeLMP4ZfyUgsStWw8TAbwuosuOnJEKhW9Oj8pFc2/gj56qx//FWFtLNRcfpwHgDfiU7+YnukyxZdzGGTluqYw6e2bJqxvhVi4VK9eZVrHz7jv1LVvddzbebs9mZzRP9GlwwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185994; c=relaxed/simple;
	bh=IooOrcGOLR5xKZ+Di0/EtLuoebHrm/6xV5IkllZH54w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ebglvFbyAj8AlmCeMxAyi/N9f5y4oU9aFU69gcFfZQSqxhVJ8ReUtVKuBYpyiGYYgvvLFX8GHLbewk668DVVgQ6G6gSS8CHm0FmK1DZWgkOaBJ8wuiMte1ohiJuJi7FioHxKQfA9Mwp31fVddIlIMcEOtQOc7KNW5OKA1LS0gmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LARmQwdk; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744185993; x=1775721993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IooOrcGOLR5xKZ+Di0/EtLuoebHrm/6xV5IkllZH54w=;
  b=LARmQwdk9s4FYAL4SqyEu8TuPPzU+Wr0ZsUJPqyqx09DDI+wg/W575oq
   Zup95y1ALD4W5jVoNwHI1l+wx0h7euVmkivKQtSpzA00OshpR97ZQkh0a
   Qmy8EetD4SY8TjBvywvMEaYX7qE7Zy2fcYQpXN2RatGHRCmsvGfwqHf6z
   wYCCo7s1rEmraCgtoQLwIvv/jbEHO1C3T5Rkg9rfkhwsCTAcW+5f2H70t
   nBEP/a/TVXQt0v6If71Ha+DJwpOrfIvmY7icExAvgtWWBzB7HBUj874ot
   sSX97Oo1X0sj4PHDT4gN6LJm/T1RvzF9zZhES1u749uErh5oZOezzOqt6
   Q==;
X-CSE-ConnectionGUID: ZsVx4Hx1QXqyQS6wpiOirg==
X-CSE-MsgGUID: cUUdk9tDT8GjEoyTQCNKXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45810033"
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="45810033"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 01:06:32 -0700
X-CSE-ConnectionGUID: rt3jFTj5SKKZ0sGxiRAkwA==
X-CSE-MsgGUID: XrJzuMe3QeOsDHHyN8mciQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,200,1739865600"; 
   d="scan'208";a="151702615"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 09 Apr 2025 01:06:20 -0700
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
Subject: [PATCH 2/5] i386/kvm: Support basic KVM PMU filter
Date: Wed,  9 Apr 2025 16:26:46 +0800
Message-Id: <20250409082649.14733-3-zhao1.liu@intel.com>
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

Filter PMU events with raw format in i386 code.

For i386, raw format indicates that the PMU event code is already
encoded according to the KVM ioctl requirements, and can be delivered
directly to KVM without additional encoding work.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
Changes since RFC v2:
 * Add documentation in qemu-options.hx.
 * Add Tested-by from Yi.

Changes since RFC v1:
 * Stop check whether per-event actions are the same, as "action" has
   been a global parameter. (Dapeng)
 * Make pmu filter related functions return int in
   target/i386/kvm/kvm.c.
---
 include/system/kvm_int.h |   2 +
 qemu-options.hx          |  47 ++++++++++++++-
 target/i386/kvm/kvm.c    | 127 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 4de6106869b0..743fed29b17b 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -17,6 +17,7 @@
 #include "hw/boards.h"
 #include "hw/i386/topology.h"
 #include "io/channel-socket.h"
+#include "system/kvm-pmu.h"
 
 typedef struct KVMSlot
 {
@@ -166,6 +167,7 @@ struct KVMState
     uint16_t xen_gnttab_max_frames;
     uint16_t xen_evtchn_max_pirq;
     char *device;
+    KVMPMUFilter *pmu_filter;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/qemu-options.hx b/qemu-options.hx
index dc694a99a30a..51a7c61ce0b0 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -232,7 +232,8 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n"
-    "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
+    "                device=path (KVM device path, default /dev/kvm)\n"
+    "                pmu-filter=id (configure KVM PMU filter)\n", QEMU_ARCH_ALL)
 SRST
 ``-accel name[,prop=value[,...]]``
     This is used to enable an accelerator. Depending on the target
@@ -318,6 +319,10 @@ SRST
         option can be used to pass the KVM device to use via a file descriptor
         by setting the value to ``/dev/fdset/NN``.
 
+    ``pmu-filter=id``
+        Sets the id of KVM PMU filter object. This option can be used to set
+        whitelist or blacklist of PMU events for Guest.
+
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
@@ -6144,6 +6149,46 @@ SRST
         ::
 
             (qemu) qom-set /objects/iothread1 poll-max-ns 100000
+
+    ``-object '{"qom-type":"kvm-pmu-filter","id":id,"action":action,"events":[entry_list]}'``
+        Create a kvm-pmu-filter object that configures KVM to filter
+        selected PMU events for Guest.
+
+        This option must be written in JSON format to support ``events``
+        JSON list.
+
+        The ``action`` parameter sets the action that KVM will take for
+        the selected PMU events. It accepts ``allow`` or ``deny``. If
+        the action is set to ``allow``, all PMU events except the
+        selected ones will be disabled and blocked in the Guest. But if
+        the action is set to ``deny``, then only the selected events
+        will be denied, while all other events can be accessed normally
+        in the Guest.
+
+        The ``events`` parameter accepts a list of PMU event entries in
+        JSON format. Event entries, based on different encoding formats,
+        have the following types:
+
+        ``{"format":"raw","code":raw_code}``
+            Encode the single PMU event with raw format. The ``code``
+            parameter accepts raw code of a PMU event. For x86, the raw
+            code represents a combination of umask and event select:
+
+        ::
+
+            (((select & 0xf00UL) << 24) | \
+             ((select) & 0xff) | \
+             ((umask) & 0xff) << 8)
+
+        An example KVM PMU filter object would look like:
+
+        .. parsed-literal::
+
+             # |qemu_system| \\
+                 ... \\
+                 -accel kvm,pmu-filter=id \\
+                 -object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":196}]}' \\
+                 ...
 ERST
 
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee812..fa3a696654cb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -34,6 +34,7 @@
 #include "system/system.h"
 #include "system/hw_accel.h"
 #include "system/kvm_int.h"
+#include "system/kvm-pmu.h"
 #include "system/runstate.h"
 #include "kvm_i386.h"
 #include "../confidential-guest.h"
@@ -110,6 +111,7 @@ typedef struct {
 static void kvm_init_msrs(X86CPU *cpu);
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr);
+static int kvm_filter_pmu_event(KVMState *s);
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -3346,6 +3348,18 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    /*
+     * TODO: Move this chunk to kvm_arch_pre_create_vcpu() and check
+     * whether pmu is enabled there.
+     */
+    if (s->pmu_filter) {
+        ret = kvm_filter_pmu_event(s);
+        if (ret < 0) {
+            error_report("Could not set KVM PMU filter");
+            return ret;
+        }
+    }
+
     return 0;
 }
 
@@ -5942,6 +5956,82 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
     g_assert_not_reached();
 }
 
+static bool kvm_config_pmu_event(KVMPMUFilter *filter,
+                                 struct kvm_pmu_event_filter *kvm_filter)
+{
+    KvmPmuFilterEventList *events;
+    KvmPmuFilterEvent *event;
+    uint64_t code;
+    int idx = 0;
+
+    kvm_filter->nevents = filter->nevents;
+    events = filter->events;
+    while (events) {
+        assert(idx < kvm_filter->nevents);
+
+        event = events->value;
+        switch (event->format) {
+        case KVM_PMU_EVENT_FORMAT_RAW:
+            code = event->u.raw.code;
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        kvm_filter->events[idx++] = code;
+        events = events->next;
+    }
+
+    return true;
+}
+
+static int kvm_install_pmu_event_filter(KVMState *s)
+{
+    struct kvm_pmu_event_filter *kvm_filter;
+    KVMPMUFilter *filter = s->pmu_filter;
+    int ret;
+
+    kvm_filter = g_malloc0(sizeof(struct kvm_pmu_event_filter) +
+                           filter->nevents * sizeof(uint64_t));
+
+    switch (filter->action) {
+    case KVM_PMU_FILTER_ACTION_ALLOW:
+        kvm_filter->action = KVM_PMU_EVENT_ALLOW;
+        break;
+    case KVM_PMU_FILTER_ACTION_DENY:
+        kvm_filter->action = KVM_PMU_EVENT_DENY;
+        break;
+    default:
+        g_assert_not_reached();
+    }
+
+    if (!kvm_config_pmu_event(filter, kvm_filter)) {
+        goto fail;
+    }
+
+    ret = kvm_vm_ioctl(s, KVM_SET_PMU_EVENT_FILTER, kvm_filter);
+    if (ret) {
+        error_report("KVM_SET_PMU_EVENT_FILTER fails (%s)", strerror(-ret));
+        goto fail;
+    }
+
+    g_free(kvm_filter);
+    return 0;
+fail:
+    g_free(kvm_filter);
+    return -EINVAL;
+}
+
+static int kvm_filter_pmu_event(KVMState *s)
+{
+    if (!kvm_vm_check_extension(s, KVM_CAP_PMU_EVENT_FILTER)) {
+        error_report("KVM PMU filter is not supported by Host.");
+        return -1;
+    }
+
+    return kvm_install_pmu_event_filter(s);
+}
+
 static bool has_sgx_provisioning;
 
 static bool __kvm_enable_sgx_provisioning(KVMState *s)
@@ -6537,6 +6627,35 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
     s->xen_evtchn_max_pirq = value;
 }
 
+static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
+                                      Object *child, Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(child);
+    KvmPmuFilterEventList *events = filter->events;
+
+    if (!filter->nevents) {
+        error_setg(errp,
+                   "Empty KVM PMU filter.");
+        return;
+    }
+
+    while (events) {
+        KvmPmuFilterEvent *event = events->value;
+
+        switch (event->format) {
+        case KVM_PMU_EVENT_FORMAT_RAW:
+            break;
+        default:
+            error_setg(errp,
+                       "Unsupported PMU event format %s.",
+                       KvmPmuEventFormat_str(events->value->format));
+            return;
+        }
+
+        events = events->next;
+    }
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
@@ -6576,6 +6695,14 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
                               NULL, NULL);
     object_class_property_set_description(oc, "xen-evtchn-max-pirq",
                                           "Maximum number of Xen PIRQs");
+
+    object_class_property_add_link(oc, "pmu-filter",
+                                   TYPE_KVM_PMU_FILTER,
+                                   offsetof(KVMState, pmu_filter),
+                                   kvm_arch_check_pmu_filter,
+                                   OBJ_PROP_LINK_STRONG);
+    object_class_property_set_description(oc, "pmu-filter",
+                                          "Set the KVM PMU filter");
 }
 
 void kvm_set_max_apic_id(uint32_t max_apic_id)
-- 
2.34.1


