Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DF5732B97
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjFPJak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344570AbjFPJaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4FD3593
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVJH1n7JWv+MjfEIK8HbJyiWIDdnfDhM0TQSsSGtsbg=;
        b=QgmeL89A9YO3E78g+OPj4dn/q/OyemP5/kdXCQ+wjMfzUfJUbZH/P26SQG8Y0WJNjmLWHI
        KXl3Ri9gH2vb95L1+6sib0JRdwKZwYkhz4jcmV12zXO3xB5iKk9IdnG36PpJPLx+81t47K
        kdWddRKHZduMVVqk0ZILr9FX4QfMyMY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-vqGrInqZOOOjPPBkdy13Sg-1; Fri, 16 Jun 2023 05:27:39 -0400
X-MC-Unique: vqGrInqZOOOjPPBkdy13Sg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59AB0800A15;
        Fri, 16 Jun 2023 09:27:39 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EB131121315;
        Fri, 16 Jun 2023 09:27:36 +0000 (UTC)
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
Subject: [PATCH v1 09/15] memory-device,vhost: Support memory devices that dynamically consume multiple memslots
Date:   Fri, 16 Jun 2023 11:26:48 +0200
Message-Id: <20230616092654.175518-10-david@redhat.com>
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

We want to support memory devices that have a dynamically managed memory
region container as device memory region. This device memory region maps
multiple RAM memory subregions (e.g., aliases to the same RAM memory region),
whereby these subregions can be (un)mapped on demand.

Each RAM subregion will consume a memslot in KVM and vhost, resulting in
such a new device consuming memslots dynamically, and initially usually
0. We already track the number of used vs. required memslots for all
memslots. From that, we can derive the number of reserved memslots that
must not be used. We only have to add a way for memory devices to expose
how many memslots they require, such that we can properly consider them as
required (and as reserved until actually used). Let's properly document
what's supported and what's not.

The target use case is virtio-mem, which will dynamically map parts of a
source RAM memory region into the container device region using aliases,
consuming one memslot per alias.

Extend the vhost memslot check accordingly and give a hint that adding
vhost devices before adding memory devices might make it work (especially
virtio-mem devices, once they determine the number of memslots to use
at runtime).

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c         | 36 +++++++++++++++++++++++++++++++++-
 hw/virtio/vhost.c              | 18 +++++++++++++----
 include/hw/mem/memory-device.h |  7 +++++++
 stubs/qmp_memory_device.c      |  5 +++++
 4 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 752258333b..2e6536c841 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -88,6 +88,40 @@ static unsigned int get_free_memslots(void)
     return MIN(vhost_get_free_memslots(), kvm_get_free_memslots());
 }
 
+/* Memslots that are reserved by memory devices (required but still unused). */
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
+/* Memslots that are still free but not reserved by memory devices yet. */
+static unsigned int get_available_memslots(MachineState *ms)
+{
+    const unsigned int free = get_free_memslots();
+    const unsigned int reserved = get_reserved_memslots(ms);
+
+    if (free < reserved) {
+        warn_report_once("The reserved memory slots (%u) exceed the free"
+                         " memory slots (%u)", reserved, free);
+        return 0;
+    }
+    return reserved - free;
+}
+
 /*
  * The memslot soft limit for memory devices. The soft limit might change at
  * runtime in corner cases (that should certainly be avoided), for example, when
@@ -146,7 +180,7 @@ static void memory_device_check_addable(MachineState *ms, MemoryDeviceState *md,
                                         MemoryRegion *mr, Error **errp)
 {
     const uint64_t used_region_size = ms->device_memory->used_region_size;
-    const unsigned int available_memslots = get_free_memslots();
+    const unsigned int available_memslots = get_available_memslots(ms);
     const uint64_t size = memory_region_size(mr);
     unsigned int required_memslots;
 
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 472ccba4ab..b1e2eca55d 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1422,7 +1422,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type, uint32_t busyloop_timeout,
                    Error **errp)
 {
-    unsigned int used;
+    unsigned int used, reserved, limit;
     uint64_t features;
     int i, r, n_initialized_vqs = 0;
 
@@ -1528,9 +1528,19 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     } else {
         used = used_memslots;
     }
-    if (used > hdev->vhost_ops->vhost_backend_memslots_limit(hdev)) {
-        error_setg(errp, "vhost backend memory slots limit is less"
-                   " than current number of present memory slots");
+    /*
+     * We simplify by assuming that reserved memslots are compatible with used
+     * vhost devices (if vhost only supports shared memory, the memory devices
+     * better use shared memory) and that reserved memslots are not used for
+     * ROM.
+     */
+    reserved = memory_devices_get_reserved_memslots();
+    limit = hdev->vhost_ops->vhost_backend_memslots_limit(hdev);
+    if (used + reserved > limit) {
+        error_setg(errp, "vhost backend memory slots limit (%d) is less"
+                   " than current number of used (%d) and reserved (%d)"
+                   " memory slots. Try adding vhost devices before memory"
+                   " devices.", limit, used, reserved);
         r = -EINVAL;
         goto fail_busyloop;
     }
diff --git a/include/hw/mem/memory-device.h b/include/hw/mem/memory-device.h
index 755f6304c6..7e8e4452cb 100644
--- a/include/hw/mem/memory-device.h
+++ b/include/hw/mem/memory-device.h
@@ -47,6 +47,12 @@ typedef struct MemoryDeviceState MemoryDeviceState;
  * single RAM/ROM memory region or a memory region container with subregions
  * that are RAM/ROM memory regions or aliases to RAM/ROM memory regions. Other
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
@@ -127,6 +133,7 @@ struct MemoryDeviceClass {
 MemoryDeviceInfoList *qmp_memory_device_list(void);
 uint64_t get_plugged_memory_size(void);
 void memory_devices_notify_vhost_device_added(void);
+unsigned int memory_devices_get_reserved_memslots(void);
 void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
                             const uint64_t *legacy_align, Error **errp);
 void memory_device_plug(MemoryDeviceState *md, MachineState *ms);
diff --git a/stubs/qmp_memory_device.c b/stubs/qmp_memory_device.c
index b0e3e34f85..74707ed9fd 100644
--- a/stubs/qmp_memory_device.c
+++ b/stubs/qmp_memory_device.c
@@ -14,3 +14,8 @@ uint64_t get_plugged_memory_size(void)
 void memory_devices_notify_vhost_device_added(void)
 {
 }
+
+unsigned int memory_devices_get_reserved_memslots(void)
+{
+    return 0;
+}
-- 
2.40.1

