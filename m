Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE4038F3E5
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhEXT5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:57:10 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:22668 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbhEXT5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 15:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621886142; x=1653422142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=/cT7Nw140FNR31PuXevCkr1pgU1HbzKiOZ6t4fkkRnQ=;
  b=oMJZtJTZ9t+rxIc0sDCpIy/YJCHidx0EBt1fJI2WCYS2WdNSR/Lw90MQ
   enA5EVzhv7DfuDOJWO2SyLGX9f7t/9E/5MrCmUCM6jsx2QnIASHOTWszw
   5MR4cq7B8tb8EF4VJb0sv4vy5SVf5jY3VfTSR07eiwqFCjSGj7t3K4AXs
   A=;
X-IronPort-AV: E=Sophos;i="5.82,325,1613433600"; 
   d="scan'208";a="114312601"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 24 May 2021 19:55:35 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 2B9EAA20BC;
        Mon, 24 May 2021 19:55:32 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.253) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 24 May 2021 19:55:28 +0000
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
Subject: [PATCH 2/6] hyper-v: Use -1 as invalid overlay address
Date:   Mon, 24 May 2021 21:54:05 +0200
Message-ID: <13aa6b6a4434198ad3d43e48501bce1796266850.1621885749.git.sidcha@amazon.de>
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

When managing overlay pages, we used hwaddr 0 to signal an invalid
address (to disable a page). Although unlikely, 0 _could_ be a valid
overlay offset as Hyper-V TLFS does not specify anything about it.

Use -1 as the invalid address indicator as it can never be a valid
address.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 hw/hyperv/hyperv.c         | 15 +++++++++------
 include/hw/hyperv/hyperv.h |  1 +
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index 8d09206702..ac45e8e139 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -43,7 +43,7 @@ static void alloc_overlay_page(struct hyperv_overlay_page *overlay,
     memory_region_init_ram(&overlay->mr, owner, name,
                            qemu_real_host_page_size, &error_abort);
     overlay->ram_ptr = memory_region_get_ram_ptr(&overlay->mr);
-    overlay->addr = 0;
+    overlay->addr = HYPERV_INVALID_OVERLAY_GPA;
 }
 
 /**
@@ -52,14 +52,17 @@ static void alloc_overlay_page(struct hyperv_overlay_page *overlay,
  */
 static void hyperv_overlay_update(struct hyperv_overlay_page *overlay, hwaddr addr)
 {
-    /* check if overlay page is enabled */
-    addr = (addr & HYPERV_OVERLAY_ENABLED) ? (addr & TARGET_PAGE_MASK) : 0;
+    if (addr != HYPERV_INVALID_OVERLAY_GPA) {
+        /* check if overlay page is enabled */
+        addr = (addr & HYPERV_OVERLAY_ENABLED) ?
+                (addr & TARGET_PAGE_MASK) : HYPERV_INVALID_OVERLAY_GPA;
+    }
 
     if (overlay->addr != addr) {
-        if (overlay->addr) {
+        if (overlay->addr != HYPERV_INVALID_OVERLAY_GPA) {
             memory_region_del_subregion(get_system_memory(), &overlay->mr);
         }
-        if (addr) {
+        if (addr != HYPERV_INVALID_OVERLAY_GPA) {
             memory_region_add_subregion(get_system_memory(), addr, &overlay->mr);
             overlay->ram_ptr = memory_region_get_ram_ptr(&overlay->mr);
         }
@@ -121,7 +124,7 @@ static void synic_reset(DeviceState *dev)
     SynICState *synic = SYNIC(dev);
     memset(synic->msg_page.ram_ptr, 0, sizeof(struct hyperv_message_page));
     memset(synic->event_page.ram_ptr, 0, sizeof(struct hyperv_event_flags_page));
-    synic_update(synic, false, 0, 0);
+    synic_update(synic, false, HYPERV_INVALID_OVERLAY_GPA, HYPERV_INVALID_OVERLAY_GPA);
 }
 
 static void synic_class_init(ObjectClass *klass, void *data)
diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
index 3b2e0093b5..d989193e84 100644
--- a/include/hw/hyperv/hyperv.h
+++ b/include/hw/hyperv/hyperv.h
@@ -15,6 +15,7 @@
 #include "exec/memory.h"
 
 #define HYPERV_OVERLAY_ENABLED     (1u << 0)
+#define HYPERV_INVALID_OVERLAY_GPA ((hwaddr)-1)
 
 struct hyperv_overlay_page {
     hwaddr addr;
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



