Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63DF43C9F5
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhJ0Ms3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237382AbhJ0Ms2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Icv29slOxUnH4zF0alx14tDkDXA6WVbCnInv3q9rhxo=;
        b=X+au1By8fyDbmyDzMnPDIxQmXlRJBAVAa0SDmr3eL5OWZT87cnt0UN62wXN+GEt8UMb8NE
        aS1zm7As4CmRmnins5EtJ0Lp3zGmnkDD2FqaDYcYpnlpxbmvIQZNVSWCB3/97KcYlQboSP
        /8rYpU59Iz/f0RIaXhKNO29ROhC8ywU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-0G5tDUYzOYCytiLAiGMnOQ-1; Wed, 27 Oct 2021 08:46:02 -0400
X-MC-Unique: 0G5tDUYzOYCytiLAiGMnOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C03FF802B52;
        Wed, 27 Oct 2021 12:46:00 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E61419D9F;
        Wed, 27 Oct 2021 12:45:57 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 06/12] memory-device: Generalize memory_device_used_region_size()
Date:   Wed, 27 Oct 2021 14:45:25 +0200
Message-Id: <20211027124531.57561-7-david@redhat.com>
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's generalize traversal of all plugged memory devices to collect
information in the context of memory_device_check_addable() to prepare for
future changes.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 68a2c3dbcc..a915894819 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -50,20 +50,24 @@ static int memory_device_build_list(Object *obj, void *opaque)
     return 0;
 }
 
-static int memory_device_used_region_size(Object *obj, void *opaque)
+struct memory_devices_info {
+    uint64_t region_size;
+};
+
+static int memory_devices_collect_info(Object *obj, void *opaque)
 {
-    uint64_t *size = opaque;
+    struct memory_devices_info *i = opaque;
 
     if (object_dynamic_cast(obj, TYPE_MEMORY_DEVICE)) {
         const DeviceState *dev = DEVICE(obj);
         const MemoryDeviceState *md = MEMORY_DEVICE(obj);
 
         if (dev->realized) {
-            *size += memory_device_get_region_size(md, &error_abort);
+            i->region_size += memory_device_get_region_size(md, &error_abort);
         }
     }
 
-    object_child_foreach(obj, memory_device_used_region_size, opaque);
+    object_child_foreach(obj, memory_devices_collect_info, opaque);
     return 0;
 }
 
@@ -71,7 +75,7 @@ static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
                                         Error **errp)
 {
     const uint64_t size = memory_region_size(mr);
-    uint64_t used_region_size = 0;
+    struct memory_devices_info info = {};
 
     /* we will need a new memory slot for kvm and vhost */
     if (kvm_enabled() && !kvm_get_free_memslots()) {
@@ -84,12 +88,12 @@ static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
     }
 
     /* will we exceed the total amount of memory specified */
-    memory_device_used_region_size(OBJECT(ms), &used_region_size);
-    if (used_region_size + size < used_region_size ||
-        used_region_size + size > ms->maxram_size - ms->ram_size) {
+    memory_devices_collect_info(OBJECT(ms), &info);
+    if (info.region_size + size < info.region_size ||
+        info.region_size + size > ms->maxram_size - ms->ram_size) {
         error_setg(errp, "not enough space, currently 0x%" PRIx64
                    " in use of total space for memory devices 0x" RAM_ADDR_FMT,
-                   used_region_size, ms->maxram_size - ms->ram_size);
+                   info.region_size, ms->maxram_size - ms->ram_size);
         return;
     }
 
-- 
2.31.1

