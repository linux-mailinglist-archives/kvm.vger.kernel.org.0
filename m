Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABE5788878
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbjHYNXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245098AbjHYNXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:23:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F72198A
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692969749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L85R7GIz9R2/Yb0UUS0uTXcZBPwafKkHQ29GXyW23G4=;
        b=f6NO8hDdgI6DSmlLaNb/TNXSyec4NP31N68PqeK09qf4hhDpbH4DFuSMbIO11Dbd8wB29I
        obz1O7vnAdvVcLFV2MqQ/BSNeRAjqEDX7CU5zk4QlrFnRP28Hi03iLo9VI3yOLnBkmdeXq
        Fc3Nk1VEoNMK8jWttobGc30bFia5piQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-5rr7NEMjNjyzMVX2c7fq0Q-1; Fri, 25 Aug 2023 09:22:25 -0400
X-MC-Unique: 5rr7NEMjNjyzMVX2c7fq0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 124B185CBE5;
        Fri, 25 Aug 2023 13:22:25 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B2A5140E950;
        Fri, 25 Aug 2023 13:22:21 +0000 (UTC)
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
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v2 08/16] memory-device: Track required and actually used memslots in DeviceMemoryState
Date:   Fri, 25 Aug 2023 15:21:41 +0200
Message-ID: <20230825132149.366064-9-david@redhat.com>
In-Reply-To: <20230825132149.366064-1-david@redhat.com>
References: <20230825132149.366064-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's track how many memslots are required by plugged memory devices and
how many are currently actually getting used by plugged memory
devices.

"required - used" is the number of reserved memslots. For now, the number
of used and required memslots is always equal, and there are no
reservations. This is a preparation for memory devices that want to
dynamically consume memslots after initially specifying how many they
require -- where we'll end up with reserved memslots.

To track the number of used memslots, create a new address space for
our device memory and register a memory listener (add/remove) for that
address space.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c | 54 ++++++++++++++++++++++++++++++++++++++++++
 include/hw/boards.h    | 10 +++++++-
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 4613a15e1f..ee77f9d290 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -286,6 +286,7 @@ void memory_device_plug(MemoryDeviceState *md, MachineState *ms)
     g_assert(ms->device_memory);
 
     ms->device_memory->used_region_size += memory_region_size(mr);
+    ms->device_memory->required_memslots += memory_device_get_memslots(md);
     memory_region_add_subregion(&ms->device_memory->mr,
                                 addr - ms->device_memory->base, mr);
     trace_memory_device_plug(DEVICE(md)->id ? DEVICE(md)->id : "", addr);
@@ -305,6 +306,7 @@ void memory_device_unplug(MemoryDeviceState *md, MachineState *ms)
 
     memory_region_del_subregion(&ms->device_memory->mr, mr);
     ms->device_memory->used_region_size -= memory_region_size(mr);
+    ms->device_memory->required_memslots -= memory_device_get_memslots(md);
     trace_memory_device_unplug(DEVICE(md)->id ? DEVICE(md)->id : "",
                                mdc->get_addr(md));
 }
@@ -324,6 +326,50 @@ uint64_t memory_device_get_region_size(const MemoryDeviceState *md,
     return memory_region_size(mr);
 }
 
+static void memory_devices_region_mod(MemoryListener *listener,
+                                      MemoryRegionSection *mrs, bool add)
+{
+    DeviceMemoryState *dms = container_of(listener, DeviceMemoryState,
+                                          listener);
+
+    if (!memory_region_is_ram(mrs->mr)) {
+        warn_report("Unexpected memory region mapped into device memory region.");
+        return;
+    }
+
+    /*
+     * The expectation is that each distinct RAM memory region section in
+     * our region for memory devices consumes exactly one memslot in KVM
+     * and in vhost. For vhost, this is true, except:
+     * * ROM memory regions don't consume a memslot. These get used very
+     *   rarely for memory devices (R/O NVDIMMs).
+     * * Memslots without a fd (memory-backend-ram) don't necessarily
+     *   consume a memslot. Such setups are quite rare and possibly bogus:
+     *   the memory would be inaccessible by such vhost devices.
+     *
+     * So for vhost, in corner cases we might over-estimate the number of
+     * memslots that are currently used or that might still be reserved
+     * (required - used).
+     */
+    dms->used_memslots += add ? 1 : -1;
+
+    if (dms->used_memslots > dms->required_memslots) {
+        warn_report("Memory devices use more memory slots than indicated as required.");
+    }
+}
+
+static void memory_devices_region_add(MemoryListener *listener,
+                                      MemoryRegionSection *mrs)
+{
+    return memory_devices_region_mod(listener, mrs, true);
+}
+
+static void memory_devices_region_del(MemoryListener *listener,
+                                      MemoryRegionSection *mrs)
+{
+    return memory_devices_region_mod(listener, mrs, false);
+}
+
 void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size)
 {
     g_assert(size);
@@ -333,8 +379,16 @@ void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size)
 
     memory_region_init(&ms->device_memory->mr, OBJECT(ms), "device-memory",
                        size);
+    address_space_init(&ms->device_memory->as, &ms->device_memory->mr,
+                       "device-memory");
     memory_region_add_subregion(get_system_memory(), ms->device_memory->base,
                                 &ms->device_memory->mr);
+
+    /* Track the number of memslots used by memory devices. */
+    ms->device_memory->listener.region_add = memory_devices_region_add;
+    ms->device_memory->listener.region_del = memory_devices_region_del;
+    memory_listener_register(&ms->device_memory->listener,
+                             &ms->device_memory->as);
 }
 
 static const TypeInfo memory_device_info = {
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 3b541ffd24..e344ded607 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -296,15 +296,23 @@ struct MachineClass {
  * DeviceMemoryState:
  * @base: address in guest physical address space where the memory
  * address space for memory devices starts
- * @mr: address space container for memory devices
+ * @mr: memory region container for memory devices
+ * @as: address space for memory devices
+ * @listener: memory listener used to track used memslots in the address space
  * @dimm_size: the sum of plugged DIMMs' sizes
  * @used_region_size: the part of @mr already used by memory devices
+ * @required_memslots: the number of memslots required by memory devices
+ * @used_memslots: the number of memslots currently used by memory devices
  */
 typedef struct DeviceMemoryState {
     hwaddr base;
     MemoryRegion mr;
+    AddressSpace as;
+    MemoryListener listener;
     uint64_t dimm_size;
     uint64_t used_region_size;
+    unsigned int required_memslots;
+    unsigned int used_memslots;
 } DeviceMemoryState;
 
 /**
-- 
2.41.0

