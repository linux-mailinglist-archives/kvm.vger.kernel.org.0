Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E858732BC6
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343746AbjFPJbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344766AbjFPJaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AA63A9C
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXmqZ0NqwuS8jR7uBp7mMBXLm/o6YAZgNQHf3c5IcyA=;
        b=WJwn5iW5eF+ExMstxi0ci2LE3QbYxNziJ82rPQ5RVk5SvCS7dKm/q/jtFX8MR4R0GE8UPg
        is3djx+79S05ZeAgKnSN0mj/BvCWaojSid/7F5WNN4dypNebWnwjhrX8/Pb4tExSgbrkd3
        EhsiQF738lWXJEn1SODicPOM1FYPL+A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-HSZbfOTJO9arMAKckwDhAw-1; Fri, 16 Jun 2023 05:27:32 -0400
X-MC-Unique: HSZbfOTJO9arMAKckwDhAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 638198028AF;
        Fri, 16 Jun 2023 09:27:32 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EE4E1121314;
        Fri, 16 Jun 2023 09:27:29 +0000 (UTC)
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
Subject: [PATCH v1 07/15] memory-device: Support memory devices that statically consume multiple memslots
Date:   Fri, 16 Jun 2023 11:26:46 +0200
Message-Id: <20230616092654.175518-8-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to support memory devices that have a memory region container as
device memory region where they statically map multiple RAM memory
regions.

We already have one device that uses a container as device memory region:
NVDIMMs. However, a NVDIMM always ends up consuming exactly one memslot.

Let's add support for that by asking the memory device via a new
callback how many memslots it consumes.

While at it in memory_device_check_addable(), perform the region size
check first and don't check separately for KVM and vhost, both things will
come in handy later.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c         | 46 +++++++++++++++++++++++-----------
 include/hw/mem/memory-device.h | 18 +++++++++++++
 2 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 2f19183a25..a9dcc0c4ef 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -82,6 +82,12 @@ static unsigned int get_max_memslots(void)
     return MIN(vhost_get_max_memslots(), kvm_get_max_memslots());
 }
 
+/* Overall number of free memslots */
+static unsigned int get_free_memslots(void)
+{
+    return MIN(vhost_get_free_memslots(), kvm_get_free_memslots());
+}
+
 /*
  * The memslot soft limit for memory devices. The soft limit might change at
  * runtime in corner cases (that should certainly be avoided), for example, when
@@ -126,21 +132,23 @@ void memory_devices_notify_vhost_device_added(void)
     memory_devices_check_memslot_soft_limit(ms);
 }
 
-static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
-                                        Error **errp)
+static unsigned int memory_device_get_memslots(MemoryDeviceState *md)
 {
-    const uint64_t used_region_size = ms->device_memory->used_region_size;
-    const uint64_t size = memory_region_size(mr);
+    const MemoryDeviceClass *mdc = MEMORY_DEVICE_GET_CLASS(md);
 
-    /* we will need a new memory slot for kvm and vhost */
-    if (!kvm_get_free_memslots()) {
-        error_setg(errp, "hypervisor has no free memory slots left");
-        return;
-    }
-    if (!vhost_get_free_memslots()) {
-        error_setg(errp, "a used vhost backend has no free memory slots left");
-        return;
+    if (mdc->get_memslots) {
+        return mdc->get_memslots(md);
     }
+    return 1;
+}
+
+static void memory_device_check_addable(MachineState *ms, MemoryDeviceState *md,
+                                        MemoryRegion *mr, Error **errp)
+{
+    const uint64_t used_region_size = ms->device_memory->used_region_size;
+    const unsigned int available_memslots = get_free_memslots();
+    const uint64_t size = memory_region_size(mr);
+    unsigned int required_memslots;
 
     /* will we exceed the total amount of memory specified */
     if (used_region_size + size < used_region_size ||
@@ -151,6 +159,14 @@ static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
         return;
     }
 
+    /* ... are there still sufficient memslots available? */
+    required_memslots = memory_device_get_memslots(md);
+    if (available_memslots < required_memslots) {
+        error_setg(errp, "Insufficient memory slots for memory device"
+                   "available. Available: %u, Required: %u",
+                   available_memslots, required_memslots);
+        return;
+    }
 }
 
 static uint64_t memory_device_get_free_addr(MachineState *ms,
@@ -307,7 +323,7 @@ void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
         goto out;
     }
 
-    memory_device_check_addable(ms, mr, &local_err);
+    memory_device_check_addable(ms, md, mr, &local_err);
     if (local_err) {
         goto out;
     }
@@ -349,7 +365,7 @@ void memory_device_plug(MemoryDeviceState *md, MachineState *ms)
     g_assert(ms->device_memory);
 
     ms->device_memory->used_region_size += memory_region_size(mr);
-    ms->device_memory->required_memslots++;
+    ms->device_memory->required_memslots += memory_device_get_memslots(md);
     memory_devices_check_memslot_soft_limit(ms);
     memory_region_add_subregion(&ms->device_memory->mr,
                                 addr - ms->device_memory->base, mr);
@@ -370,7 +386,7 @@ void memory_device_unplug(MemoryDeviceState *md, MachineState *ms)
 
     memory_region_del_subregion(&ms->device_memory->mr, mr);
     ms->device_memory->used_region_size -= memory_region_size(mr);
-    ms->device_memory->required_memslots--;
+    ms->device_memory->required_memslots -= memory_device_get_memslots(md);
     trace_memory_device_unplug(DEVICE(md)->id ? DEVICE(md)->id : "",
                                mdc->get_addr(md));
 }
diff --git a/include/hw/mem/memory-device.h b/include/hw/mem/memory-device.h
index 813c3b9da6..755f6304c6 100644
--- a/include/hw/mem/memory-device.h
+++ b/include/hw/mem/memory-device.h
@@ -42,6 +42,11 @@ typedef struct MemoryDeviceState MemoryDeviceState;
  * successive memory regions are used, a covering memory region has to
  * be provided. Scattered memory regions are not supported for single
  * devices.
+ *
+ * The device memory region returned via @get_memory_region may either be a
+ * single RAM/ROM memory region or a memory region container with subregions
+ * that are RAM/ROM memory regions or aliases to RAM/ROM memory regions. Other
+ * memory regions or subregions are not supported.
  */
 struct MemoryDeviceClass {
     /* private */
@@ -89,6 +94,19 @@ struct MemoryDeviceClass {
      */
     MemoryRegion *(*get_memory_region)(MemoryDeviceState *md, Error **errp);
 
+    /*
+     * Optional for memory devices that consume only a single memslot,
+     * required for all other memory devices: Return the number of memslots
+     * (distinct RAM memory regions in the device memory region) that are
+     * required by the device.
+     *
+     * If this function is not implemented, the assumption is "1".
+     *
+     * Called when (un)plugging the memory device, to check if the requirements
+     * can be satisfied, and to do proper accounting.
+     */
+    unsigned int (*get_memslots)(MemoryDeviceState *md);
+
     /*
      * Optional: Return the desired minimum alignment of the device in guest
      * physical address space. The final alignment is computed based on this
-- 
2.40.1

