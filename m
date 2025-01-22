Return-Path: <kvm+bounces-36229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0121EA18DBB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E415E1639FF
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3C42045BA;
	Wed, 22 Jan 2025 08:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fRl2YDjM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFF9188721
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737535579; cv=none; b=TQ3EihVpor9uB7krGu5+NwzAG3057oj0UOu6eWl1fOeSrlY5EsGrciemlCaklTI+gYDsCk/5qWM3INNamCIBcuoTPASEKwG5EEHoPIWz+o7p/zCw1TVfH6x7Z32xVKhs4yCV26/mXckfQMnu0Qku87W/ovKeITyaQPfFqU57fqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737535579; c=relaxed/simple;
	bh=VMFyzU7rJ0ERY+XN36rgAcSEcfJLdF/jbMtrra/GTKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fbVgMp1d/DGwEHa5wkXx31RRIsmB5L0ZB4+PiC0WV+1eW5e8aCzU91L31960Rw+/IeymizxwBmY342oHIVFpBHokckN5f47hHvCulgyNmHQDKRZdinMbJuR8e18Bt8sFOimYdfOBXWpq1Ub+Q4kQkOWADCzHu5ZBB0tHCWkcBg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fRl2YDjM; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737535578; x=1769071578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VMFyzU7rJ0ERY+XN36rgAcSEcfJLdF/jbMtrra/GTKA=;
  b=fRl2YDjMSKqIeuv1/omSOm2tVi9r9hArsXQ8mWvuL+mOQXjdk3gZIoBU
   lB+3x0ta14/cFoEwZdXXh5okRIok78DtYFsOKwynKYNtqZ9SJ9/ZjGNOJ
   /gc5UEh2ZJ+mxTpdpKT8Dx6nTS0KCm4A5D+nOkoyWIF8EmUhxcAQWyc1W
   N673nZbRiEf4PxvQMVIIkyGZjT4CprzSFqR/PLzKms2CjT1r6+i1jTjmh
   SdMJys1Q4pGllw9w1CN6Pa18wzm1RBAaHcOhCEn8BVb8FrrDMRCqV0OIC
   Gk+sU9AqVZRd9ykDm+x6M6Glei6YvsIZxiusmdlFiLpgMR2YqmmPkNtJO
   g==;
X-CSE-ConnectionGUID: QyY8lamYQcWKtQKqzdMUzA==
X-CSE-MsgGUID: RWlOPk9PQsi8aslW6jwnFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="60451559"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="60451559"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 00:46:17 -0800
X-CSE-ConnectionGUID: fA1qO0UsTNWEBq4maCd8bQ==
X-CSE-MsgGUID: bO2kWi3pSM6t8TGjTKIFOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="112049753"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 22 Jan 2025 00:46:13 -0800
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
Subject: [RFC v2 2/5] i386/kvm: Support basic KVM PMU filter
Date: Wed, 22 Jan 2025 17:05:14 +0800
Message-Id: <20250122090517.294083-3-zhao1.liu@intel.com>
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

Filter PMU events with raw format in i386 code.

For i386, raw format indicates that the PMU event code is already
encoded according to the KVM ioctl requirements, and can be delivered
directly to KVM without additional encoding work.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v1:
 * Stop check whether per-event actions are the same, as "action" has
   been a global parameter. (Dapeng)
 * Make pmu filter related functions return int in
   target/i386/kvm/kvm.c.
---
 include/system/kvm_int.h |   2 +
 target/i386/kvm/kvm.c    | 123 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

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
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c749d4ee812..b82adbed50f4 100644
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
@@ -3346,6 +3348,14 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
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
 
@@ -5942,6 +5952,82 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
     g_assert_not_reached();
 }
 
+static bool kvm_config_pmu_event(KVMPMUFilter *filter,
+                                 struct kvm_pmu_event_filter *kvm_filter)
+{
+    KVMPMUFilterEventList *events;
+    KVMPMUFilterEvent *event;
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
+        case KVM_PMU_EVENT_FMT_RAW:
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
@@ -6537,6 +6623,35 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
     s->xen_evtchn_max_pirq = value;
 }
 
+static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
+                                      Object *child, Error **errp)
+{
+    KVMPMUFilter *filter = KVM_PMU_FILTER(child);
+    KVMPMUFilterEventList *events = filter->events;
+
+    if (!filter->nevents) {
+        error_setg(errp,
+                   "Empty KVM PMU filter.");
+        return;
+    }
+
+    while (events) {
+        KVMPMUFilterEvent *event = events->value;
+
+        switch (event->format) {
+        case KVM_PMU_EVENT_FMT_RAW:
+            break;
+        default:
+            error_setg(errp,
+                       "Unsupported PMU event format %s.",
+                       KVMPMUEventEncodeFmt_str(events->value->format));
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
@@ -6576,6 +6691,14 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
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


