Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A98A3BF315
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhGHA66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:23555 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhGHA6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231168451"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="231168451"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770117"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 39/44] ioapic: add property to disallow SMI delivery mode
Date:   Wed,  7 Jul 2021 17:55:09 -0700
Message-Id: <0855fc584f8ffe862760bc7ef076984b1f2c48a2.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a property to prevent ioapic from setting SMI delivery mode.  Without
this guard, qemu can result in unexpected behavior.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/intc/ioapic.c                  | 18 ++++++++++++++++++
 hw/intc/ioapic_common.c           | 20 ++++++++++++++++++++
 include/hw/i386/ioapic_internal.h |  1 +
 3 files changed, 39 insertions(+)

diff --git a/hw/intc/ioapic.c b/hw/intc/ioapic.c
index 6d61744961..1815fbd282 100644
--- a/hw/intc/ioapic.c
+++ b/hw/intc/ioapic.c
@@ -381,6 +381,21 @@ ioapic_fix_level_trigger_unsupported(uint64_t *entry)
     }
 }
 
+static inline void
+ioapic_fix_smi_unsupported(uint64_t *entry)
+{
+    if ((*entry & IOAPIC_LVT_DELIV_MODE) ==
+        IOAPIC_DM_PMI << IOAPIC_LVT_DELIV_MODE_SHIFT) {
+        /*
+         * ignore a request for delivery mode of lowest SMI
+         */
+        warn_report_once("attempting to set delivery mode to SMI"
+                         "which is not supported");
+        *entry &= ~IOAPIC_LVT_DELIV_MODE;
+        *entry |= IOAPIC_DM_FIXED << IOAPIC_LVT_DELIV_MODE_SHIFT;
+    }
+}
+
 static void
 ioapic_mem_write(void *opaque, hwaddr addr, uint64_t val,
                  unsigned int size)
@@ -424,6 +439,9 @@ ioapic_mem_write(void *opaque, hwaddr addr, uint64_t val,
                 if (s->level_trigger_unsupported) {
                     ioapic_fix_level_trigger_unsupported(&s->ioredtbl[index]);
                 }
+                if (s->smi_unsupported) {
+                    ioapic_fix_smi_unsupported(&s->ioredtbl[index]);
+                }
                 ioapic_fix_edge_remote_irr(&s->ioredtbl[index]);
                 ioapic_service(s);
             }
diff --git a/hw/intc/ioapic_common.c b/hw/intc/ioapic_common.c
index 07ee142470..b8ef7efbad 100644
--- a/hw/intc/ioapic_common.c
+++ b/hw/intc/ioapic_common.c
@@ -168,12 +168,32 @@ static void ioapic_common_set_level_trigger_unsupported(Object *obj, bool value,
     s->level_trigger_unsupported = value;
 }
 
+static bool ioapic_common_get_smi_unsupported(Object *obj, Error **errp)
+{
+    IOAPICCommonState *s = IOAPIC_COMMON(obj);
+    return s->smi_unsupported;
+}
+
+static void ioapic_common_set_smi_unsupported(Object *obj, bool value,
+                                                       Error **errp)
+{
+    DeviceState *dev = DEVICE(obj);
+    IOAPICCommonState *s = IOAPIC_COMMON(obj);
+    /* only disabling before realize is allowed */
+    assert(!dev->realized);
+    assert(!s->smi_unsupported);
+    s->smi_unsupported = value;
+}
+
 static void ioapic_common_init(Object *obj)
 {
     object_property_add_bool(obj, "level_trigger_unsupported",
                              ioapic_common_get_level_trigger_unsupported,
                              ioapic_common_set_level_trigger_unsupported);
 
+    object_property_add_bool(obj, "smi_unsupported",
+                             ioapic_common_get_smi_unsupported,
+                             ioapic_common_set_smi_unsupported);
 }
 
 static void ioapic_common_realize(DeviceState *dev, Error **errp)
diff --git a/include/hw/i386/ioapic_internal.h b/include/hw/i386/ioapic_internal.h
index 20f2fc7897..46f22a4f85 100644
--- a/include/hw/i386/ioapic_internal.h
+++ b/include/hw/i386/ioapic_internal.h
@@ -104,6 +104,7 @@ struct IOAPICCommonState {
     uint64_t ioredtbl[IOAPIC_NUM_PINS];
     Notifier machine_done;
     bool level_trigger_unsupported;
+    bool smi_unsupported;
     uint8_t version;
     uint64_t irq_count[IOAPIC_NUM_PINS];
     int irq_level[IOAPIC_NUM_PINS];
-- 
2.25.1

