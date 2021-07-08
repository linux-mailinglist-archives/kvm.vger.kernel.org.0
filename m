Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0083BF31F
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhGHA7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:23555 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhGHA6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231168454"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="231168454"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770123"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 41/44] ioapic: add property to disallow INIT/SIPI delivery mode
Date:   Wed,  7 Jul 2021 17:55:11 -0700
Message-Id: <a48dcb44623ece9ad543583d7e76c24885ca0c93.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a property to prevent ioapic from setting INIT/SIPI delivery mode.
Without this guard, qemu can result in unexpected behavior.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/intc/ioapic.c                  | 19 +++++++++++++++++++
 hw/intc/ioapic_common.c           | 21 +++++++++++++++++++++
 include/hw/i386/ioapic_internal.h |  1 +
 3 files changed, 41 insertions(+)

diff --git a/hw/intc/ioapic.c b/hw/intc/ioapic.c
index 1815fbd282..f7eb9f7146 100644
--- a/hw/intc/ioapic.c
+++ b/hw/intc/ioapic.c
@@ -396,6 +396,22 @@ ioapic_fix_smi_unsupported(uint64_t *entry)
     }
 }
 
+static inline void
+ioapic_fix_init_sipi_unsupported(uint64_t *entry)
+{
+    uint64_t delmode = *entry & IOAPIC_LVT_DELIV_MODE;
+    if (delmode == IOAPIC_DM_INIT << IOAPIC_LVT_DELIV_MODE_SHIFT ||
+        delmode == IOAPIC_DM_SIPI << IOAPIC_LVT_DELIV_MODE_SHIFT) {
+        /*
+         * ignore a request for delivery mode of lowest SMI
+         */
+        warn_report_once("attempting to set delivery mode to INIT/SIPI"
+                         "which is not supported");
+        *entry &= ~IOAPIC_LVT_DELIV_MODE;
+        *entry |= IOAPIC_DM_FIXED << IOAPIC_LVT_DELIV_MODE_SHIFT;
+    }
+}
+
 static void
 ioapic_mem_write(void *opaque, hwaddr addr, uint64_t val,
                  unsigned int size)
@@ -442,6 +458,9 @@ ioapic_mem_write(void *opaque, hwaddr addr, uint64_t val,
                 if (s->smi_unsupported) {
                     ioapic_fix_smi_unsupported(&s->ioredtbl[index]);
                 }
+                if (s->init_sipi_unsupported) {
+                    ioapic_fix_init_sipi_unsupported(&s->ioredtbl[index]);
+                }
                 ioapic_fix_edge_remote_irr(&s->ioredtbl[index]);
                 ioapic_service(s);
             }
diff --git a/hw/intc/ioapic_common.c b/hw/intc/ioapic_common.c
index b8ef7efbad..018bacbf96 100644
--- a/hw/intc/ioapic_common.c
+++ b/hw/intc/ioapic_common.c
@@ -185,6 +185,23 @@ static void ioapic_common_set_smi_unsupported(Object *obj, bool value,
     s->smi_unsupported = value;
 }
 
+static bool ioapic_common_get_init_sipi_unsupported(Object *obj, Error **errp)
+{
+    IOAPICCommonState *s = IOAPIC_COMMON(obj);
+    return s->init_sipi_unsupported;
+}
+
+static void ioapic_common_set_init_sipi_unsupported(Object *obj, bool value,
+                                                       Error **errp)
+{
+    DeviceState *dev = DEVICE(obj);
+    IOAPICCommonState *s = IOAPIC_COMMON(obj);
+    /* only disabling before realize is allowed */
+    assert(!dev->realized);
+    assert(!s->init_sipi_unsupported);
+    s->init_sipi_unsupported = value;
+}
+
 static void ioapic_common_init(Object *obj)
 {
     object_property_add_bool(obj, "level_trigger_unsupported",
@@ -194,6 +211,10 @@ static void ioapic_common_init(Object *obj)
     object_property_add_bool(obj, "smi_unsupported",
                              ioapic_common_get_smi_unsupported,
                              ioapic_common_set_smi_unsupported);
+
+    object_property_add_bool(obj, "init_sipi_unsupported",
+                             ioapic_common_get_init_sipi_unsupported,
+                             ioapic_common_set_init_sipi_unsupported);
 }
 
 static void ioapic_common_realize(DeviceState *dev, Error **errp)
diff --git a/include/hw/i386/ioapic_internal.h b/include/hw/i386/ioapic_internal.h
index 46f22a4f85..634b97426d 100644
--- a/include/hw/i386/ioapic_internal.h
+++ b/include/hw/i386/ioapic_internal.h
@@ -105,6 +105,7 @@ struct IOAPICCommonState {
     Notifier machine_done;
     bool level_trigger_unsupported;
     bool smi_unsupported;
+    bool init_sipi_unsupported;
     uint8_t version;
     uint64_t irq_count[IOAPIC_NUM_PINS];
     int irq_level[IOAPIC_NUM_PINS];
-- 
2.25.1

