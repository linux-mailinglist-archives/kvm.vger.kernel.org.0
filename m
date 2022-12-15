Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5930D64DA69
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLOLe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiLOLdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:33:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329752C657
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2MfiRtTFamLMgHlUz7mclmxu7zXNnIyauq4FC3uxYWE=;
        b=fP690I40x2vEzFeBFSzhJ98llyZv2oh/iGM9jWlqNjAbOr0sukARxcrDe/96TWwY77jRJS
        6DbwbWmAmz6LyT+j/WaMRR1HsUqIXr1SHP+yUxI34gUiJ8f8PbgcrILzjg86xUa4K+ozAr
        rGX7QM3qN3ilqP2x2tNOQ637DIFM6vs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-fZ0xZL_DOxuVUvxzLj1rcQ-1; Thu, 15 Dec 2022 06:32:29 -0500
X-MC-Unique: fZ0xZL_DOxuVUvxzLj1rcQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64C9E185A794;
        Thu, 15 Dec 2022 11:32:28 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBC592166B26;
        Thu, 15 Dec 2022 11:32:24 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Parav Pandit <parav@mellanox.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v9 09/12] vdpa: add asid parameter to vhost_vdpa_dma_map/unmap
Date:   Thu, 15 Dec 2022 12:31:41 +0100
Message-Id: <20221215113144.322011-10-eperezma@redhat.com>
In-Reply-To: <20221215113144.322011-1-eperezma@redhat.com>
References: <20221215113144.322011-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
Acked-by: Jason Wang <jasowang@redhat.com>
---
v7:
* Move comment on zero initailization of vhost_vdpa_dma_map above the
  functions.
* Add VHOST_VDPA_GUEST_PA_ASID macro.

v5:
* Solve conflict, now vhost_vdpa_svq_unmap_ring returns void
* Change comment on zero initialization.

v4: Add comment specifying behavior if device does not support _F_ASID

v3: Deleted unneeded space
---
 include/hw/virtio/vhost-vdpa.h | 14 ++++++++++---
 hw/virtio/vhost-vdpa.c         | 36 +++++++++++++++++++++++-----------
 net/vhost-vdpa.c               |  6 +++---
 hw/virtio/trace-events         |  4 ++--
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/hw/virtio/vhost-vdpa.h b/include/hw/virtio/vhost-vdpa.h
index 1111d85643..e57dfa1fd1 100644
--- a/include/hw/virtio/vhost-vdpa.h
+++ b/include/hw/virtio/vhost-vdpa.h
@@ -19,6 +19,12 @@
 #include "hw/virtio/virtio.h"
 #include "standard-headers/linux/vhost_types.h"
 
+/*
+ * ASID dedicated to map guest's addresses.  If SVQ is disabled it maps GPA to
+ * qemu's IOVA.  If SVQ is enabled it maps also the SVQ vring here
+ */
+#define VHOST_VDPA_GUEST_PA_ASID 0
+
 typedef struct VhostVDPAHostNotifier {
     MemoryRegion mr;
     void *addr;
@@ -29,6 +35,7 @@ typedef struct vhost_vdpa {
     int index;
     uint32_t msg_type;
     bool iotlb_batch_begin_sent;
+    uint32_t address_space_id;
     MemoryListener listener;
     struct vhost_vdpa_iova_range iova_range;
     uint64_t acked_features;
@@ -42,8 +49,9 @@ typedef struct vhost_vdpa {
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
index 86e1fa8e9e..5e591a8fda 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -72,22 +72,28 @@ static bool vhost_vdpa_listener_skipped_section(MemoryRegionSection *section,
     return false;
 }
 
-int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
-                       void *vaddr, bool readonly)
+/*
+ * The caller must set asid = 0 if the device does not support asid.
+ * This is not an ABI break since it is set to 0 by the initializer anyway.
+ */
+int vhost_vdpa_dma_map(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
+                       hwaddr size, void *vaddr, bool readonly)
 {
     struct vhost_msg_v2 msg = {};
     int fd = v->device_fd;
     int ret = 0;
 
     msg.type = v->msg_type;
+    msg.asid = asid;
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
@@ -98,18 +104,24 @@ int vhost_vdpa_dma_map(struct vhost_vdpa *v, hwaddr iova, hwaddr size,
     return ret;
 }
 
-int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, hwaddr iova, hwaddr size)
+/*
+ * The caller must set asid = 0 if the device does not support asid.
+ * This is not an ABI break since it is set to 0 by the initializer anyway.
+ */
+int vhost_vdpa_dma_unmap(struct vhost_vdpa *v, uint32_t asid, hwaddr iova,
+                         hwaddr size)
 {
     struct vhost_msg_v2 msg = {};
     int fd = v->device_fd;
     int ret = 0;
 
     msg.type = v->msg_type;
+    msg.asid = asid;
     msg.iotlb.iova = iova;
     msg.iotlb.size = size;
     msg.iotlb.type = VHOST_IOTLB_INVALIDATE;
 
-    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.iotlb.iova,
+    trace_vhost_vdpa_dma_unmap(v, fd, msg.type, msg.asid, msg.iotlb.iova,
                                msg.iotlb.size, msg.iotlb.type);
 
     if (write(fd, &msg, sizeof(msg)) != sizeof(msg)) {
@@ -229,8 +241,8 @@ static void vhost_vdpa_listener_region_add(MemoryListener *listener,
     }
 
     vhost_vdpa_iotlb_batch_begin_once(v);
-    ret = vhost_vdpa_dma_map(v, iova, int128_get64(llsize),
-                             vaddr, section->readonly);
+    ret = vhost_vdpa_dma_map(v, VHOST_VDPA_GUEST_PA_ASID, iova,
+                             int128_get64(llsize), vaddr, section->readonly);
     if (ret) {
         error_report("vhost vdpa map fail!");
         goto fail_map;
@@ -303,7 +315,8 @@ static void vhost_vdpa_listener_region_del(MemoryListener *listener,
         vhost_iova_tree_remove(v->iova_tree, *result);
     }
     vhost_vdpa_iotlb_batch_begin_once(v);
-    ret = vhost_vdpa_dma_unmap(v, iova, int128_get64(llsize));
+    ret = vhost_vdpa_dma_unmap(v, VHOST_VDPA_GUEST_PA_ASID, iova,
+                               int128_get64(llsize));
     if (ret) {
         error_report("vhost_vdpa dma unmap error!");
     }
@@ -869,7 +882,7 @@ static void vhost_vdpa_svq_unmap_ring(struct vhost_vdpa *v, hwaddr addr)
     }
 
     size = ROUND_UP(result->size, qemu_real_host_page_size());
-    r = vhost_vdpa_dma_unmap(v, result->iova, size);
+    r = vhost_vdpa_dma_unmap(v, v->address_space_id, result->iova, size);
     if (unlikely(r < 0)) {
         error_report("Unable to unmap SVQ vring: %s (%d)", g_strerror(-r), -r);
         return;
@@ -909,7 +922,8 @@ static bool vhost_vdpa_svq_map_ring(struct vhost_vdpa *v, DMAMap *needle,
         return false;
     }
 
-    r = vhost_vdpa_dma_map(v, needle->iova, needle->size + 1,
+    r = vhost_vdpa_dma_map(v, v->address_space_id, needle->iova,
+                           needle->size + 1,
                            (void *)(uintptr_t)needle->translated_addr,
                            needle->perm == IOMMU_RO);
     if (unlikely(r != 0)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index e829ef1f43..a592ee07ec 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -259,7 +259,7 @@ static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
         return;
     }
 
-    r = vhost_vdpa_dma_unmap(v, map->iova, map->size + 1);
+    r = vhost_vdpa_dma_unmap(v, v->address_space_id, map->iova, map->size + 1);
     if (unlikely(r != 0)) {
         error_report("Device cannot unmap: %s(%d)", g_strerror(r), r);
     }
@@ -299,8 +299,8 @@ static int vhost_vdpa_cvq_map_buf(struct vhost_vdpa *v, void *buf, size_t size,
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
index 14fc5b9bb2..96da58a41f 100644
--- a/hw/virtio/trace-events
+++ b/hw/virtio/trace-events
@@ -30,8 +30,8 @@ vhost_user_write(uint32_t req, uint32_t flags) "req:%d flags:0x%"PRIx32""
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

