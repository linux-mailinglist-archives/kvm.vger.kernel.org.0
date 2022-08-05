Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFF358AE46
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 18:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbiHEQjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 12:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241007AbiHEQjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 12:39:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31ED779EC6
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 09:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659717570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMwiy5aVxBgKjGDMKnTdjQTCSZqix2fK0WjvG8NBOVs=;
        b=ehHYdiN2nQpWJ8y//9FToIwRLP42WRmLhZ9wfZzdJeACDvzbMCyRlUweXG2IUcwdQYkiVS
        Ovxk253ACwful9Yotj08j/RNRBbzAED4cT0RgJwXrSYqCe6dXpK44xdQ/UEG8gwCkVsqv4
        zy0dN5qxkciNeVOZbFaDonwtQNNOpXQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-fkcsso5aMxK8N3HUoUQRTA-1; Fri, 05 Aug 2022 12:39:27 -0400
X-MC-Unique: fkcsso5aMxK8N3HUoUQRTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5A021C05AB0;
        Fri,  5 Aug 2022 16:39:26 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2472F2166B26;
        Fri,  5 Aug 2022 16:39:24 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>
Subject: [PATCH v4 4/6] vdpa: Add asid parameter to vhost_vdpa_dma_map/unmap
Date:   Fri,  5 Aug 2022 18:39:07 +0200
Message-Id: <20220805163909.872646-5-eperezma@redhat.com>
In-Reply-To: <20220805163909.872646-1-eperezma@redhat.com>
References: <20220805163909.872646-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So the caller can choose which ASID is destined.

No need to update the batch functions as they will always be called from
memory listener updates at the moment. Memory listener updates will
always update ASID 0, as it's the passthrough ASID.

All vhost devices's ASID are 0 at this moment.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
v4: Add comment specifying behavior if device does not support _F_ASID

v3: Deleted unneeded space
---
 include/hw/virtio/vhost-vdpa.h |  8 +++++---
 hw/virtio/vhost-vdpa.c         | 25 +++++++++++++++----------
 net/vhost-vdpa.c               |  6 +++---
 hw/virtio/trace-events         |  4 ++--
 4 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
index 1111d85643..6560bb9d78 100644
--- a/include/hw/virtio/vhost-vdpa.h
+++ b/include/hw/virtio/vhost-vdpa.h
@@ -29,6 +29,7 @@ typedef struct vhost_vdpa {
     int index;
     uint32_t msg_type;
     bool iotlb_batch_begin_sent;
+    uint32_t address_space_id;
     MemoryListener listener;
     struct vhost_vdpa_iova_range iova_range;
     uint64_t acked_features;
@@ -42,8 +43,9 @@ typedef struct vhost_vdpa {
     VhostVDPAHostNotifier notifier[VIRTIO_QUEUE_MAX];
 } VhostVDPA;
 
-int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
-                       void *vaddr, bool readonly);
-int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size);
+int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
+                       hwaddr size, void *vaddr, bool readonly);
+int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
+                         hwaddr size);
 
 #endif
diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 34922ec20d..3eb67b27b7 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -72,22 +72,24 @@ static bool vhost_vdpa_listener_skipped_section(MemoryRegionSection *section,
     return false;
 }
 
-int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
-                       void *vaddr, bool readonly)
+int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
+                       hwaddr size, void *vaddr, bool readonly)
 {
     struct vhost_msg_v2 msg = {};
     int fd = v->device_fd;
     int ret = 0;
 
     msg.type = v->msg_type;
+    msg.asid = asid; /* 0 if vdpa device does not support asid */
     msg.iotlb.iova = iova;
     msg.iotlb.size = size;
     msg.iotlb.uaddr = (uint64_t)(uintptr_t)vaddr;
     msg.iotlb.perm = readonly ? VHOST_ACCESS_RO : VHOST_ACCESS_RW;
     msg.iotlb.type = VHOST_IOTLB_UPDATE;
 
-   trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.iotlb.iova, msg.iotlb.size,
-                            msg.iotlb.uaddr, msg.iotlb.perm, msg.iotlb.type);
+    trace_vhost_vdpa_dma_map(v, fd, msg.type, msg.asid, msg.iotlb.iova,
+                             msg.iotlb.size, msg.iotlb.uaddr, msg.iotlb.perm,
+                             msg.iotlb.type);
 
     if (write(fd, &msg, sizeof(msg)) != sizeof(msg)) {
         error_report("failed to write, fd=%d, errno=%d (%s)",
@@ -98,18 +100,20 @@ int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
     return ret;
 }
 
-int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size)
+int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
+                         hwaddr size)
 {
     struct vhost_msg_v2 msg = {};
     int fd = v->device_fd;
     int ret = 0;
 
     msg.type = v->msg_type;
+    msg.asid = asid; /* 0 if vdpa device does not support asid */
     msg.iotlb.iova = iova;
     msg.iotlb.size = size;
     msg.iotlb.type = VHOST_IOTLB_INVALIDATE;
 
-    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.iotlb.iova,
+    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.asid, msg.iotlb.iova,
                                msg.iotlb.size, msg.iotlb.type);
 
     if (write(fd, &msg, sizeof(msg)) != sizeof(msg)) {
@@ -229,7 +233,7 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
     }
 
     vhost_vdpa_iotlb_batch_begin_once(v);
-    ret = vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
+    ret = vhost_vdpa_dma_map(v, 0, iova, int128_get64(llsize),
                              vaddr, section->readonly);
     if (ret) {
         error_report("vhost vdpa map fail!");
@@ -303,7 +307,7 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
         vhost_iova_tree_remove(v->iova_tree, result);
     }
     vhost_vdpa_iotlb_batch_begin_once(v);
-    ret = vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
+    ret = vhost_vdpa_dma_unmap(v, 0, iova, int128_get64(llsize));
     if (ret) {
         error_report("vhost_vdpa dma unmap error!");
     }
@@ -894,7 +898,7 @@ static bool vhost_vdpa_svq_unmap_ring(struct vhost_vdpa *v,
     }
 
     size = ROUND_UP(result->size, qemu_real_host_page_size());
-    r = vhost_vdpa_dma_unmap(v, result->iova, size);
+    r = vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, size);
     return r == 0;
 }
 
@@ -936,7 +940,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vdpa *v, DMAMap *needle,
         return false;
     }
 
-    r = vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
+    r = vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
+                           needle->size + 1,
                            (void *)(uintptr_t)needle->translated_addr,
                            needle->perm == IOMMU_RO);
     if (unlikely(r != 0)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 7c0d600aea..9b932442f0 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -239,7 +239,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
         return;
     }
 
-    r = vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
+    r = vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map->size + 1);
     if (unlikely(r != 0)) {
         error_report("Device cannot unmap: %s(%d)", g_strerror(r), r);
     }
@@ -279,8 +279,8 @@ static int vhost_vdpa_cvq_map_buf(struct vhost_vdpa *v, void *buf, size_t size,
         return r;
     }
 
-    r = vhost_vdpa_dma_map(v, map.iova, vhost_vdpa_net_cvq_cmd_page_len(), buf,
-                           !write);
+    r = vhost_vdpa_dma_map(v, v->address_space_id, map.iova,
+                           vhost_vdpa_net_cvq_cmd_page_len(), buf, !write);
     if (unlikely(r < 0)) {
         goto dma_map_err;
     }
diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
index 20af2e7ebd..36e5ae75f6 100644
--- a/hw/virtio/trace-events
+++ b/hw/virtio/trace-events
@@ -26,8 +26,8 @@ vhost_user_write(uint32_t req, uint32_t flags) "req:%d flags:0x%"PRIx32""
 vhost_user_create_notifier(int idx, void *n) "idx:%d n:%p"
 
 # vhost-vdpa.c
-vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
-vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
+vhost_vdpa_dma_map(void *vdpa, int fd, uint32_t msg_type, uint32_t asid, uint64_t iova, uint64_t size, uint64_t uaddr, uint8_t perm, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" uaddr: 0x%"PRIx64" perm: 0x%"PRIx8" type: %"PRIu8
+vhost_vdpa_dma_unmap(void *vdpa, int fd, uint32_t msg_type, uint32_t asid, uint64_t iova, uint64_t size, uint8_t type) "vdpa:%p fd: %d msg_type: %"PRIu32" asid: %"PRIu32" iova: 0x%"PRIx64" size: 0x%"PRIx64" type: %"PRIu8
 vhost_vdpa_listener_begin_batch(void *v, int fd, uint32_t msg_type, uint8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
 vhost_vdpa_listener_commit(void *v, int fd, uint32_t msg_type, uint8_t type)  "vdpa:%p fd: %d msg_type: %"PRIu32" type: %"PRIu8
 vhost_vdpa_listener_region_add(void *vdpa, uint64_t iova, uint64_t llend, void *vaddr, bool readonly) "vdpa: %p iova 0x%"PRIx64" llend 0x%"PRIx64" vaddr: %p read-only: %d"
-- 
2.31.1

