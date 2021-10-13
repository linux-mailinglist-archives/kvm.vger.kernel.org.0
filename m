Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E515E42BCEE
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhJMKiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:38:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhJMKiv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:38:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ih+jDEDdCSReJb44DrIvYsF7h99Td6g1C16k8E/cins=;
        b=V8O9z058xXLaqyzZq0xxnpVTk7EDiNRU8sp4czzBpXVM56ypSgvgfSPeIAMhqMUb3iZJeV
        1/NnAJY0fxzqYXn/BTS+kDC1l0VReKPBdGCCzd001z3c9YT75pSp8uu4sQFLhUnnYhE/KQ
        U3gRpXWmdIS6RcZASLaGIjBG/QA3YUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-lfpmDYmLNYu6Z_BvezUuGw-1; Wed, 13 Oct 2021 06:36:45 -0400
X-MC-Unique: lfpmDYmLNYu6Z_BvezUuGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC63518D6A38;
        Wed, 13 Oct 2021 10:36:43 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABCED5D9D5;
        Wed, 13 Oct 2021 10:35:46 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH RFC 07/15] memory-device: Generalize memory_device_used_region_size()
Date:   Wed, 13 Oct 2021 12:33:22 +0200
Message-Id: <20211013103330.26869-8-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's generalize traversal of all plugged memory devices to collect
information to prepare for future changes.

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

