Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760F538F3E3
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhEXT5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:57:05 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:17813 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhEXT5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 15:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621886136; x=1653422136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=mZIir676oMjXxkMnK5aSOC8G9jHVo4LGLAT1tTWIcP8=;
  b=sjTYOStwFVSahTHCmSc56Acd+MTyTMr/7BwIpV4wNuJjnW7dFIp8jTkb
   OHTW0FcIKe1B7y6ACIsuLyPw/LA+5CkgGxgFKRI3SWnSeQzf4WxCE47eo
   PIEQhJJUoXmhpmw29ej6LiYt3YkgJz4RXDwV2Ay8GQIP8uKsCKb253wMX
   w=;
X-IronPort-AV: E=Sophos;i="5.82,325,1613433600"; 
   d="scan'208";a="934795156"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 24 May 2021 19:55:29 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id D0105A047E;
        Mon, 24 May 2021 19:55:27 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.253) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 24 May 2021 19:55:23 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH 1/6] hyper-v: Overlay abstraction for synic event and msg pages
Date:   Mon, 24 May 2021 21:54:04 +0200
Message-ID: <a997ef48d649f553869b614ba7d256a97f59a48e.1621885749.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1621885749.git.sidcha@amazon.de>
References: <cover.1621885749.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture overlay page semantic variables into 'struct overlay_page' and
add methods that operate over it. Adapt existing synic event and mesage
pages to use these methods to setup and manage overlays.

Since all overlay pages use bit 0 of the GPA to indicate if the overlay
is enabled, the checks for this bit is moved into the unified overlaying
method hyperv_overlay_update() so the caller does not need to care about
it.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 hw/hyperv/hyperv.c         | 103 ++++++++++++++++++++-----------------
 include/hw/hyperv/hyperv.h |   9 ++++
 target/i386/kvm/hyperv.c   |  10 ++--
 3 files changed, 68 insertions(+), 54 deletions(-)

diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index cb1074f234..8d09206702 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -28,12 +28,8 @@ struct SynICState {
     CPUState *cs;
 
     bool enabled;
-    hwaddr msg_page_addr;
-    hwaddr event_page_addr;
-    MemoryRegion msg_page_mr;
-    MemoryRegion event_page_mr;
-    struct hyperv_message_page *msg_page;
-    struct hyperv_event_flags_page *event_page;
+    struct hyperv_overlay_page msg_page;
+    struct hyperv_overlay_page event_page;
 };
 
 #define TYPE_SYNIC "hyperv-synic"
@@ -41,43 +37,52 @@ OBJECT_DECLARE_SIMPLE_TYPE(SynICState, SYNIC)
 
 static bool synic_enabled;
 
-bool hyperv_is_synic_enabled(void)
+static void alloc_overlay_page(struct hyperv_overlay_page *overlay,
+                               Object *owner, const char *name)
 {
-    return synic_enabled;
+    memory_region_init_ram(&overlay->mr, owner, name,
+                           qemu_real_host_page_size, &error_abort);
+    overlay->ram_ptr = memory_region_get_ram_ptr(&overlay->mr);
+    overlay->addr = 0;
 }
 
-static SynICState *get_synic(CPUState *cs)
+/**
+ * This method must be called with iothread lock taken as it modifies
+ * the memory hierarchy.
+ */
+static void hyperv_overlay_update(struct hyperv_overlay_page *overlay, hwaddr addr)
 {
-    return SYNIC(object_resolve_path_component(OBJECT(cs), "synic"));
+    /* check if overlay page is enabled */
+    addr = (addr & HYPERV_OVERLAY_ENABLED) ? (addr & TARGET_PAGE_MASK) : 0;
+
+    if (overlay->addr != addr) {
+        if (overlay->addr) {
+            memory_region_del_subregion(get_system_memory(), &overlay->mr);
+        }
+        if (addr) {
+            memory_region_add_subregion(get_system_memory(), addr, &overlay->mr);
+            overlay->ram_ptr = memory_region_get_ram_ptr(&overlay->mr);
+        }
+        overlay->addr = addr;
+    }
 }
 
 static void synic_update(SynICState *synic, bool enable,
                          hwaddr msg_page_addr, hwaddr event_page_addr)
 {
-
     synic->enabled = enable;
-    if (synic->msg_page_addr != msg_page_addr) {
-        if (synic->msg_page_addr) {
-            memory_region_del_subregion(get_system_memory(),
-                                        &synic->msg_page_mr);
-        }
-        if (msg_page_addr) {
-            memory_region_add_subregion(get_system_memory(), msg_page_addr,
-                                        &synic->msg_page_mr);
-        }
-        synic->msg_page_addr = msg_page_addr;
-    }
-    if (synic->event_page_addr != event_page_addr) {
-        if (synic->event_page_addr) {
-            memory_region_del_subregion(get_system_memory(),
-                                        &synic->event_page_mr);
-        }
-        if (event_page_addr) {
-            memory_region_add_subregion(get_system_memory(), event_page_addr,
-                                        &synic->event_page_mr);
-        }
-        synic->event_page_addr = event_page_addr;
-    }
+    hyperv_overlay_update(&synic->msg_page, msg_page_addr);
+    hyperv_overlay_update(&synic->event_page, event_page_addr);
+}
+
+bool hyperv_is_synic_enabled(void)
+{
+    return synic_enabled;
+}
+
+static SynICState *get_synic(CPUState *cs)
+{
+    return SYNIC(object_resolve_path_component(OBJECT(cs), "synic"));
 }
 
 void hyperv_synic_update(CPUState *cs, bool enable,
@@ -104,21 +109,18 @@ static void synic_realize(DeviceState *dev, Error **errp)
     msgp_name = g_strdup_printf("synic-%u-msg-page", vp_index);
     eventp_name = g_strdup_printf("synic-%u-event-page", vp_index);
 
-    memory_region_init_ram(&synic->msg_page_mr, obj, msgp_name,
-                           sizeof(*synic->msg_page), &error_abort);
-    memory_region_init_ram(&synic->event_page_mr, obj, eventp_name,
-                           sizeof(*synic->event_page), &error_abort);
-    synic->msg_page = memory_region_get_ram_ptr(&synic->msg_page_mr);
-    synic->event_page = memory_region_get_ram_ptr(&synic->event_page_mr);
+    alloc_overlay_page(&synic->msg_page, obj, msgp_name);
+    alloc_overlay_page(&synic->event_page, obj, eventp_name);
 
     g_free(msgp_name);
     g_free(eventp_name);
 }
+
 static void synic_reset(DeviceState *dev)
 {
     SynICState *synic = SYNIC(dev);
-    memset(synic->msg_page, 0, sizeof(*synic->msg_page));
-    memset(synic->event_page, 0, sizeof(*synic->event_page));
+    memset(synic->msg_page.ram_ptr, 0, sizeof(struct hyperv_message_page));
+    memset(synic->event_page.ram_ptr, 0, sizeof(struct hyperv_event_flags_page));
     synic_update(synic, false, 0, 0);
 }
 
@@ -254,17 +256,19 @@ static void cpu_post_msg(CPUState *cs, run_on_cpu_data data)
     HvSintRoute *sint_route = data.host_ptr;
     HvSintStagedMessage *staged_msg = sint_route->staged_msg;
     SynICState *synic = sint_route->synic;
+    struct hyperv_message_page *msg_page;
     struct hyperv_message *dst_msg;
     bool wait_for_sint_ack = false;
 
     assert(staged_msg->state == HV_STAGED_MSG_BUSY);
 
-    if (!synic->enabled || !synic->msg_page_addr) {
+    if (!synic->enabled || !synic->msg_page.addr) {
         staged_msg->status = -ENXIO;
         goto posted;
     }
 
-    dst_msg = &synic->msg_page->slot[sint_route->sint];
+    msg_page = synic->msg_page.ram_ptr;
+    dst_msg = &msg_page->slot[sint_route->sint];
 
     if (dst_msg->header.message_type != HV_MESSAGE_NONE) {
         dst_msg->header.message_flags |= HV_MESSAGE_FLAG_PENDING;
@@ -275,7 +279,8 @@ static void cpu_post_msg(CPUState *cs, run_on_cpu_data data)
         staged_msg->status = hyperv_sint_route_set_sint(sint_route);
     }
 
-    memory_region_set_dirty(&synic->msg_page_mr, 0, sizeof(*synic->msg_page));
+    memory_region_set_dirty(&synic->msg_page.mr, 0,
+                            sizeof(struct hyperv_message_page));
 
 posted:
     qatomic_set(&staged_msg->state, HV_STAGED_MSG_POSTED);
@@ -338,22 +343,24 @@ int hyperv_set_event_flag(HvSintRoute *sint_route, unsigned eventno)
     int ret;
     SynICState *synic = sint_route->synic;
     unsigned long *flags, set_mask;
+    struct hyperv_event_flags_page *event_page;
     unsigned set_idx;
 
     if (eventno > HV_EVENT_FLAGS_COUNT) {
         return -EINVAL;
     }
-    if (!synic->enabled || !synic->event_page_addr) {
+    if (!synic->enabled || !synic->event_page.addr) {
         return -ENXIO;
     }
 
     set_idx = BIT_WORD(eventno);
     set_mask = BIT_MASK(eventno);
-    flags = synic->event_page->slot[sint_route->sint].flags;
+    event_page = synic->event_page.ram_ptr;
+    flags = event_page->slot[sint_route->sint].flags;
 
     if ((qatomic_fetch_or(&flags[set_idx], set_mask) & set_mask) != set_mask) {
-        memory_region_set_dirty(&synic->event_page_mr, 0,
-                                sizeof(*synic->event_page));
+        memory_region_set_dirty(&synic->event_page.mr, 0,
+                                sizeof(struct hyperv_event_flags_page));
         ret = hyperv_sint_route_set_sint(sint_route);
     } else {
         ret = 0;
diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
index a63ee0003c..3b2e0093b5 100644
--- a/include/hw/hyperv/hyperv.h
+++ b/include/hw/hyperv/hyperv.h
@@ -12,6 +12,15 @@
 
 #include "cpu-qom.h"
 #include "hw/hyperv/hyperv-proto.h"
+#include "exec/memory.h"
+
+#define HYPERV_OVERLAY_ENABLED     (1u << 0)
+
+struct hyperv_overlay_page {
+    hwaddr addr;
+    MemoryRegion mr;
+    void *ram_ptr;
+};
 
 typedef struct HvSintRoute HvSintRoute;
 
diff --git a/target/i386/kvm/hyperv.c b/target/i386/kvm/hyperv.c
index 26efc1e0e6..f49ed2621d 100644
--- a/target/i386/kvm/hyperv.c
+++ b/target/i386/kvm/hyperv.c
@@ -31,12 +31,10 @@ void hyperv_x86_synic_reset(X86CPU *cpu)
 void hyperv_x86_synic_update(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
-    bool enable = env->msr_hv_synic_control & HV_SYNIC_ENABLE;
-    hwaddr msg_page_addr = (env->msr_hv_synic_msg_page & HV_SIMP_ENABLE) ?
-        (env->msr_hv_synic_msg_page & TARGET_PAGE_MASK) : 0;
-    hwaddr event_page_addr = (env->msr_hv_synic_evt_page & HV_SIEFP_ENABLE) ?
-        (env->msr_hv_synic_evt_page & TARGET_PAGE_MASK) : 0;
-    hyperv_synic_update(CPU(cpu), enable, msg_page_addr, event_page_addr);
+
+    hyperv_synic_update(CPU(cpu), env->msr_hv_synic_control & HV_SYNIC_ENABLE,
+                        env->msr_hv_synic_msg_page,
+                        env->msr_hv_synic_evt_page);
 }
 
 static void async_synic_update(CPUState *cs, run_on_cpu_data data)
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



