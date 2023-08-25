Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45812788871
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245088AbjHYNXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245136AbjHYNXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:23:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA662117
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692969724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2lWTPsgDvCfwCJwS9h9vAACqbsIOrrr2brotmfmJqM=;
        b=YyokGm2wFBQLKi++Xv2z/Fjb2vRLwhyHpYkLcu422AD08GLBu1ECkY0GBA23vVhz+NSANm
        2PsKmKLnX0Wa6MrYLHIeF65wU5Gg8EnjGyVhz79588DqgmOdEtw9yGeJjcNVW930FcsV4p
        TkFSpb3gQXf4BlJWaBHsVd/dG3LYUvw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-Ow2-8IoWNpG1dmRlxWza4Q-1; Fri, 25 Aug 2023 09:22:00 -0400
X-MC-Unique: Ow2-8IoWNpG1dmRlxWza4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B6498D40A7;
        Fri, 25 Aug 2023 13:21:59 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23C44140E950;
        Fri, 25 Aug 2023 13:21:55 +0000 (UTC)
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
        kvm@vger.kernel.org, Tiwei Bie <tiwei.bie@intel.com>
Subject: [PATCH v2 01/16] vhost: Rework memslot filtering and fix "used_memslot" tracking
Date:   Fri, 25 Aug 2023 15:21:34 +0200
Message-ID: <20230825132149.366064-2-david@redhat.com>
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

Having multiple vhost devices, some filtering out fd-less memslots and
some not, can mess up the "used_memslot" accounting. Consequently our
"free memslot" checks become unreliable and we might run out of free
memslots at runtime later.

An example sequence which can trigger a potential issue that involves
different vhost backends (vhost-kernel and vhost-user) and hotplugged
memory devices can be found at [1].

Let's make the filtering mechanism less generic and distinguish between
backends that support private memslots (without a fd) and ones that only
support shared memslots (with a fd). Track the used_memslots for both
cases separately and use the corresponding value when required.

Note: Most probably we should filter out MAP_PRIVATE fd-based RAM regions
(for example, via memory-backend-memfd,...,shared=off or as default with
 memory-backend-file) as well. When not using MAP_SHARED, it might not work
as expected. Add a TODO for now.

[1] https://lkml.kernel.org/r/fad9136f-08d3-3fd9-71a1-502069c000cf@redhat.com

Fixes: 988a27754bbb ("vhost: allow backends to filter memory sections")
Cc: Tiwei Bie <tiwei.bie@intel.com>
Acked-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/vhost-user.c            |  7 ++--
 hw/virtio/vhost.c                 | 56 ++++++++++++++++++++++++++-----
 include/hw/virtio/vhost-backend.h |  5 ++-
 3 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 8dcf049d42..1e7553352a 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -2500,10 +2500,9 @@ vhost_user_crypto_close_session(struct vhost_dev *dev, uint64_t session_id)
     return 0;
 }
 
-static bool vhost_user_mem_section_filter(struct vhost_dev *dev,
-                                          MemoryRegionSection *section)
+static bool vhost_user_no_private_memslots(struct vhost_dev *dev)
 {
-    return memory_region_get_fd(section->mr) >= 0;
+    return true;
 }
 
 static int vhost_user_get_inflight_fd(struct vhost_dev *dev,
@@ -2746,6 +2745,7 @@ const VhostOps user_ops = {
         .vhost_backend_init = vhost_user_backend_init,
         .vhost_backend_cleanup = vhost_user_backend_cleanup,
         .vhost_backend_memslots_limit = vhost_user_memslots_limit,
+        .vhost_backend_no_private_memslots = vhost_user_no_private_memslots,
         .vhost_set_log_base = vhost_user_set_log_base,
         .vhost_set_mem_table = vhost_user_set_mem_table,
         .vhost_set_vring_addr = vhost_user_set_vring_addr,
@@ -2772,7 +2772,6 @@ const VhostOps user_ops = {
         .vhost_set_config = vhost_user_set_config,
         .vhost_crypto_create_session = vhost_user_crypto_create_session,
         .vhost_crypto_close_session = vhost_user_crypto_close_session,
-        .vhost_backend_mem_section_filter = vhost_user_mem_section_filter,
         .vhost_get_inflight_fd = vhost_user_get_inflight_fd,
         .vhost_set_inflight_fd = vhost_user_set_inflight_fd,
         .vhost_dev_start = vhost_user_dev_start,
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index e2f6ffb446..c1e6148833 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -45,20 +45,33 @@
 static struct vhost_log *vhost_log;
 static struct vhost_log *vhost_log_shm;
 
+/* Memslots used by backends that support private memslots (without an fd). */
 static unsigned int used_memslots;
+
+/* Memslots used by backends that only support shared memslots (with an fd). */
+static unsigned int used_shared_memslots;
+
 static QLIST_HEAD(, vhost_dev) vhost_devices =
     QLIST_HEAD_INITIALIZER(vhost_devices);
 
 bool vhost_has_free_slot(void)
 {
-    unsigned int slots_limit = ~0U;
+    unsigned int free = UINT_MAX;
     struct vhost_dev *hdev;
 
     QLIST_FOREACH(hdev, &vhost_devices, entry) {
         unsigned int r = hdev->vhost_ops->vhost_backend_memslots_limit(hdev);
-        slots_limit = MIN(slots_limit, r);
+        unsigned int cur_free;
+
+        if (hdev->vhost_ops->vhost_backend_no_private_memslots &&
+            hdev->vhost_ops->vhost_backend_no_private_memslots(hdev)) {
+            cur_free = r - used_shared_memslots;
+        } else {
+            cur_free = r - used_memslots;
+        }
+        free = MIN(free, cur_free);
     }
-    return slots_limit > used_memslots;
+    return free > 0;
 }
 
 static void vhost_dev_sync_region(struct vhost_dev *dev,
@@ -474,8 +487,7 @@ static int vhost_verify_ring_mappings(struct vhost_dev *dev,
  * vhost_section: identify sections needed for vhost access
  *
  * We only care about RAM sections here (where virtqueue and guest
- * internals accessed by virtio might live). If we find one we still
- * allow the backend to potentially filter it out of our list.
+ * internals accessed by virtio might live).
  */
 static bool vhost_section(struct vhost_dev *dev, MemoryRegionSection *section)
 {
@@ -502,8 +514,16 @@ static bool vhost_section(struct vhost_dev *dev, MemoryRegionSection *section)
             return false;
         }
 
-        if (dev->vhost_ops->vhost_backend_mem_section_filter &&
-            !dev->vhost_ops->vhost_backend_mem_section_filter(dev, section)) {
+        /*
+         * Some backends (like vhost-user) can only handle memory regions
+         * that have an fd (can be mapped into a different process). Filter
+         * the ones without an fd out, if requested.
+         *
+         * TODO: we might have to limit to MAP_SHARED as well.
+         */
+        if (memory_region_get_fd(section->mr) < 0 &&
+            dev->vhost_ops->vhost_backend_no_private_memslots &&
+            dev->vhost_ops->vhost_backend_no_private_memslots(dev)) {
             trace_vhost_reject_section(mr->name, 2);
             return false;
         }
@@ -568,7 +588,14 @@ static void vhost_commit(MemoryListener *listener)
                        dev->n_mem_sections * sizeof dev->mem->regions[0];
     dev->mem = g_realloc(dev->mem, regions_size);
     dev->mem->nregions = dev->n_mem_sections;
-    used_memslots = dev->mem->nregions;
+
+    if (dev->vhost_ops->vhost_backend_no_private_memslots &&
+        dev->vhost_ops->vhost_backend_no_private_memslots(dev)) {
+        used_shared_memslots = dev->mem->nregions;
+    } else {
+        used_memslots = dev->mem->nregions;
+    }
+
     for (i = 0; i < dev->n_mem_sections; i++) {
         struct vhost_memory_region *cur_vmr = dev->mem->regions + i;
         struct MemoryRegionSection *mrs = dev->mem_sections + i;
@@ -1400,6 +1427,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type, uint32_t busyloop_timeout,
                    Error **errp)
 {
+    unsigned int used;
     uint64_t features;
     int i, r, n_initialized_vqs = 0;
 
@@ -1495,7 +1523,17 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     memory_listener_register(&hdev->memory_listener, &address_space_memory);
     QLIST_INSERT_HEAD(&vhost_devices, hdev, entry);
 
-    if (used_memslots > hdev->vhost_ops->vhost_backend_memslots_limit(hdev)) {
+    /*
+     * The listener we registered properly updated the corresponding counter.
+     * So we can trust that these values are accurate.
+     */
+    if (hdev->vhost_ops->vhost_backend_no_private_memslots &&
+        hdev->vhost_ops->vhost_backend_no_private_memslots(hdev)) {
+        used = used_shared_memslots;
+    } else {
+        used = used_memslots;
+    }
+    if (used > hdev->vhost_ops->vhost_backend_memslots_limit(hdev)) {
         error_setg(errp, "vhost backend memory slots limit is less"
                    " than current number of present memory slots");
         r = -EINVAL;
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index 31a251a9f5..df2821ddae 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -108,8 +108,7 @@ typedef int (*vhost_crypto_create_session_op)(struct vhost_dev *dev,
 typedef int (*vhost_crypto_close_session_op)(struct vhost_dev *dev,
                                              uint64_t session_id);
 
-typedef bool (*vhost_backend_mem_section_filter_op)(struct vhost_dev *dev,
-                                                MemoryRegionSection *section);
+typedef bool (*vhost_backend_no_private_memslots_op)(struct vhost_dev *dev);
 
 typedef int (*vhost_get_inflight_fd_op)(struct vhost_dev *dev,
                                         uint16_t queue_size,
@@ -138,6 +137,7 @@ typedef struct VhostOps {
     vhost_backend_init vhost_backend_init;
     vhost_backend_cleanup vhost_backend_cleanup;
     vhost_backend_memslots_limit vhost_backend_memslots_limit;
+    vhost_backend_no_private_memslots_op vhost_backend_no_private_memslots;
     vhost_net_set_backend_op vhost_net_set_backend;
     vhost_net_set_mtu_op vhost_net_set_mtu;
     vhost_scsi_set_endpoint_op vhost_scsi_set_endpoint;
@@ -172,7 +172,6 @@ typedef struct VhostOps {
     vhost_set_config_op vhost_set_config;
     vhost_crypto_create_session_op vhost_crypto_create_session;
     vhost_crypto_close_session_op vhost_crypto_close_session;
-    vhost_backend_mem_section_filter_op vhost_backend_mem_section_filter;
     vhost_get_inflight_fd_op vhost_get_inflight_fd;
     vhost_set_inflight_fd_op vhost_set_inflight_fd;
     vhost_dev_start_op vhost_dev_start;
-- 
2.41.0

