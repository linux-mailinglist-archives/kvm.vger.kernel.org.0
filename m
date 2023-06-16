Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958FA732BB8
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343928AbjFPJbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344707AbjFPJaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6AC448F
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hAWEbuOoJIfCBYKOU4fdhfU8su5N6z8gqggRVHf2zIk=;
        b=Sd1lkqH6zaZC4JALvyl6gMAvXzCWn9FDmmE/w/WBkrVHUYeVU2pcnpcvBPIauRaBl0j0Za
        Aj2nGvQxreHNJRGVknrRcvHfSfzISLRqeGKNaYz0ADyVYDdJcIW2YtKwoSwhby8bafYXKB
        Qv9DlwBlXr6XScBj7g2iDPZfP+Jl324=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-nxneG7QxNQGHyfmE1QxJwg-1; Fri, 16 Jun 2023 05:27:46 -0400
X-MC-Unique: nxneG7QxNQGHyfmE1QxJwg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C951680123E;
        Fri, 16 Jun 2023 09:27:45 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 998921121314;
        Fri, 16 Jun 2023 09:27:42 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 11/15] memory-device: Support memory-devices with auto-detection of the number of memslots
Date:   Fri, 16 Jun 2023 11:26:50 +0200
Message-Id: <20230616092654.175518-12-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to support memory devices that detect at runtime how many
memslots they will use. The target use case is virtio-mem.

Let's suggest a memslot limit to the device, such that the device can
use that number to determine the number of memslots it wants to use.

To make a sane suggestion that doesn't cause trouble elsewhere, implement
a heuristic that considers
* The memslot soft-limit for all memory devices
* Unpopulated DIMM slots
* Actually still free and not reserved memslots
* The percentage of the remaining device memory region that memory device
  will occupy.

For example, if existing memory devices require 100 memslots, we have
>= 256 free (and not reserved) memslot and we have 28 unpopulated DIMM
slots, a device that occupies half of the device memory region would get a
suggestion of (256 - 100 - 28) * 1/2 = 64. [note that our soft-limit is
256]

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c         | 66 +++++++++++++++++++++++++++++++++-
 include/hw/mem/memory-device.h | 10 ++++++
 2 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 2e6536c841..3099d346d7 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -12,6 +12,7 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "hw/mem/memory-device.h"
+#include "hw/mem/pc-dimm.h"
 #include "qapi/error.h"
 #include "hw/boards.h"
 #include "qemu/range.h"
@@ -166,6 +167,16 @@ void memory_devices_notify_vhost_device_added(void)
     memory_devices_check_memslot_soft_limit(ms);
 }
 
+static void memory_device_set_suggested_memslot_limit(MemoryDeviceState *md,
+                                                      unsigned int limit)
+{
+    const MemoryDeviceClass *mdc = MEMORY_DEVICE_GET_CLASS(md);
+
+    if (mdc->set_suggested_memslot_limit) {
+        mdc->set_suggested_memslot_limit(md, limit);
+    }
+}
+
 static unsigned int memory_device_get_memslots(MemoryDeviceState *md)
 {
     const MemoryDeviceClass *mdc = MEMORY_DEVICE_GET_CLASS(md);
@@ -176,13 +187,58 @@ static unsigned int memory_device_get_memslots(MemoryDeviceState *md)
     return 1;
 }
 
+/*
+ * Suggested maximum number of memslots for a memory device with the given
+ * region size. Not exceeding this number will make most setups not run
+ * into the soft limit or even out of available memslots, even when multiple
+ * memory devices automatically determine the number of memslots to use.
+ */
+static unsigned int memory_device_suggested_memslot_limit(MachineState *ms,
+                                                          MemoryRegion *mr)
+{
+    const unsigned int soft_limit = memory_devices_memslot_soft_limit(ms);
+    const unsigned int free_dimm_slots = pc_dimm_get_free_slots(ms);
+    const uint64_t size = memory_region_size(mr);
+    uint64_t available_space;
+    unsigned int memslots;
+
+    /* Consider the soft-limit for all memory devices. */
+    if (soft_limit <= ms->device_memory->required_memslots) {
+        return 1;
+    }
+    memslots = soft_limit - ms->device_memory->required_memslots;
+
+    /* Consider the actually available memslots. */
+    memslots = MIN(memslots, get_available_memslots(ms));
+
+    /* It's the single memory device? We cannot plug something else. */
+    if (size == ms->maxram_size - ms->ram_size) {
+        return memslots;
+    }
+
+    /* Try setting one memmemslots for each empty DIMM slot aside. */
+    if (memslots <= free_dimm_slots) {
+        return 1;
+    }
+    memslots -= free_dimm_slots;
+
+    /*
+     * Simple heuristic: equally distribute the memslots over the space
+     * still available for memory devices.
+     */
+    available_space = ms->maxram_size - ms->ram_size -
+                      ms->device_memory->used_region_size;
+    memslots = (double)memslots * size / available_space;
+    return memslots < 1 ? 1 : memslots;
+}
+
 static void memory_device_check_addable(MachineState *ms, MemoryDeviceState *md,
                                         MemoryRegion *mr, Error **errp)
 {
     const uint64_t used_region_size = ms->device_memory->used_region_size;
     const unsigned int available_memslots = get_available_memslots(ms);
     const uint64_t size = memory_region_size(mr);
-    unsigned int required_memslots;
+    unsigned int required_memslots, suggested_memslot_limit;
 
     /* will we exceed the total amount of memory specified */
     if (used_region_size + size < used_region_size ||
@@ -193,6 +249,14 @@ static void memory_device_check_addable(MachineState *ms, MemoryDeviceState *md,
         return;
     }
 
+    /*
+     * Determine the per-device memslot limit for this device and
+     * communicate it to the device such that it can determine the number
+     * of memslots to use before we query them.
+     */
+    suggested_memslot_limit = memory_device_suggested_memslot_limit(ms, mr);
+    memory_device_set_suggested_memslot_limit(md, suggested_memslot_limit);
+
     /* ... are there still sufficient memslots available? */
     required_memslots = memory_device_get_memslots(md);
     if (available_memslots < required_memslots) {
diff --git a/include/hw/mem/memory-device.h b/include/hw/mem/memory-device.h
index 7e8e4452cb..c09a2f0a7c 100644
--- a/include/hw/mem/memory-device.h
+++ b/include/hw/mem/memory-device.h
@@ -100,6 +100,16 @@ struct MemoryDeviceClass {
      */
     MemoryRegion *(*get_memory_region)(MemoryDeviceState *md, Error **errp);
 
+    /*
+     * Optional: Set the suggested memslot limit, such that a device than
+     * can auto-detect the number of memslots to use based on this limit.
+     *
+     * Called exactly once when pre-plugging the memory device, before
+     * querying the number of memslots using @get_memslots the first time.
+     */
+    void (*set_suggested_memslot_limit)(MemoryDeviceState *md,
+                                        unsigned int limit);
+
     /*
      * Optional for memory devices that consume only a single memslot,
      * required for all other memory devices: Return the number of memslots
-- 
2.40.1

