Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E9788877
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245104AbjHYNXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245043AbjHYNXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:23:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7393A1FDE
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692969750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eh5uGD7Mus1G/7pDXTdWmUCKHZK2TV62fP86YjEHQlI=;
        b=HFpnL1IvK+HZlk4yz2/1I+r1e0T2dmAsET3FVCqIKMFz3jt6ptTVzT7P7qKzd9+hE98lYy
        FcAtB6M7g5MDf+BKtVBJsqUflB7Jds/pOJLShyUg4ruv0hB22frtWUBax3slvUBzI7fcoL
        VeFmxRCtBgqwhMeqCMWY3GTC1r/ZVp8=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-tMNEQnaAMiuDSVvKRP691g-1; Fri, 25 Aug 2023 09:22:29 -0400
X-MC-Unique: tMNEQnaAMiuDSVvKRP691g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AED603C0C490;
        Fri, 25 Aug 2023 13:22:28 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5016F140E950;
        Fri, 25 Aug 2023 13:22:25 +0000 (UTC)
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
Subject: [PATCH v2 09/16] memory-device,vhost: Support memory devices that dynamically consume memslots
Date:   Fri, 25 Aug 2023 15:21:42 +0200
Message-ID: <20230825132149.366064-10-david@redhat.com>
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

We want to support memory devices that have a dynamically managed memory
region container as device memory region. This device memory region maps
multiple RAM memory subregions (e.g., aliases to the same RAM memory
region), whereby these subregions can be (un)mapped on demand.

Each RAM subregion will consume a memslot in KVM and vhost, resulting in
such a new device consuming memslots dynamically, and initially usually
0. We already track the number of used vs. required memslots for all
memslots. From that, we can derive the number of reserved memslots that
must not be used otherwise.

The target use case is virtio-mem and the hyper-v balloon, which will
dynamically map aliases to RAM memory region into their device memory
region container.

Properly document what's supported and what's not and extend the vhost
memslot check accordingly.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c         | 28 ++++++++++++++++++++++++++--
 hw/virtio/vhost.c              | 18 ++++++++++++++----
 include/hw/mem/memory-device.h |  7 +++++++
 stubs/memory_device.c          |  5 +++++
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index ee77f9d290..4f1f841517 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -62,19 +62,43 @@ static unsigned int memory_device_get_memslots(MemoryDeviceState *md)
     return 1;
 }
 
+/*
+ * Memslots that are reserved by memory devices (required but still reported
+ * as free from KVM / vhost).
+ */
+static unsigned int get_reserved_memslots(MachineState *ms)
+{
+    if (ms->device_memory->used_memslots >
+        ms->device_memory->required_memslots) {
+        /* This is unexpected, and we warned already in the memory notifier. */
+        return 0;
+    }
+    return ms->device_memory->required_memslots -
+           ms->device_memory->used_memslots;
+}
+
+unsigned int memory_devices_get_reserved_memslots(void)
+{
+    if (!current_machine->device_memory) {
+        return 0;
+    }
+    return get_reserved_memslots(current_machine);
+}
+
 static void memory_device_check_addable(MachineState *ms, MemoryDeviceState *md,
                                         MemoryRegion *mr, Error **errp)
 {
     const uint64_t used_region_size = ms->device_memory->used_region_size;
     const uint64_t size = memory_region_size(mr);
     const unsigned int required_memslots = memory_device_get_memslots(md);
+    const unsigned int reserved_memslots = get_reserved_memslots(ms);
 
     /* we will need memory slots for kvm and vhost */
-    if (kvm_get_free_memslots() < required_memslots) {
+    if (kvm_get_free_memslots() < required_memslots + reserved_memslots) {
         error_setg(errp, "hypervisor has not enough free memory slots left");
         return;
     }
-    if (vhost_get_free_memslots() < required_memslots) {
+    if (vhost_get_free_memslots() < required_memslots + reserved_memslots) {
         error_setg(errp, "a used vhost backend has not enough free memory slots left");
         return;
     }
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 8e84dca246..f7e1ac12a8 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -23,6 +23,7 @@
 #include "qemu/log.h"
 #include "standard-headers/linux/vhost_types.h"
 #include "hw/virtio/virtio-bus.h"
+#include "hw/mem/memory-device.h"
 #include "migration/blocker.h"
 #include "migration/qemu-file-types.h"
 #include "sysemu/dma.h"
@@ -1423,7 +1424,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type, uint32_t busyloop_timeout,
                    Error **errp)
 {
-    unsigned int used;
+    unsigned int used, reserved, limit;
     uint64_t features;
     int i, r, n_initialized_vqs = 0;
 
@@ -1529,9 +1530,18 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     } else {
         used = used_memslots;
     }
-    if (used > hdev->vhost_ops->vhost_backend_memslots_limit(hdev)) {
-        error_setg(errp, "vhost backend memory slots limit is less"
-                   " than current number of present memory slots");
+    /*
+     * We assume that all reserved memslots actually require a real memslot
+     * in our vhost backend. This might not be true, for example, if the
+     * memslot would be ROM. If ever relevant, we can optimize for that --
+     * but we'll need additional information about the reservations.
+     */
+    reserved = memory_devices_get_reserved_memslots();
+    limit = hdev->vhost_ops->vhost_backend_memslots_limit(hdev);
+    if (used + reserved > limit) {
+        error_setg(errp, "vhost backend memory slots limit (%d) is less"
+                   " than current number of used (%d) and reserved (%d)"
+                   " memory slots for memory devices.", limit, used, reserved);
         r = -EINVAL;
         goto fail_busyloop;
     }
diff --git a/include/hw/mem/memory-device.h b/include/hw/mem/memory-device.h
index b51a579fb9..c7b624da6a 100644
--- a/include/hw/mem/memory-device.h
+++ b/include/hw/mem/memory-device.h
@@ -46,6 +46,12 @@ typedef struct MemoryDeviceState MemoryDeviceState;
  * single RAM memory region or a memory region container with subregions
  * that are RAM memory regions or aliases to RAM memory regions. Other
  * memory regions or subregions are not supported.
+ *
+ * If the device memory region returned via @get_memory_region is a
+ * memory region container, it's supported to dynamically (un)map subregions
+ * as long as the number of memslots returned by @get_memslots() won't
+ * be exceeded and as long as all memory regions are of the same kind (e.g.,
+ * all RAM or all ROM).
  */
 struct MemoryDeviceClass {
     /* private */
@@ -125,6 +131,7 @@ struct MemoryDeviceClass {
 
 MemoryDeviceInfoList *qmp_memory_device_list(void);
 uint64_t get_plugged_memory_size(void);
+unsigned int memory_devices_get_reserved_memslots(void);
 void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
                             const uint64_t *legacy_align, Error **errp);
 void memory_device_plug(MemoryDeviceState *md, MachineState *ms);
diff --git a/stubs/memory_device.c b/stubs/memory_device.c
index e75cac62dc..318a5d4187 100644
--- a/stubs/memory_device.c
+++ b/stubs/memory_device.c
@@ -10,3 +10,8 @@ uint64_t get_plugged_memory_size(void)
 {
     return (uint64_t)-1;
 }
+
+unsigned int memory_devices_get_reserved_memslots(void)
+{
+    return 0;
+}
-- 
2.41.0

