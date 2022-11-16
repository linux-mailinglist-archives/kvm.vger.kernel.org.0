Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EFE62C1DC
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 16:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbiKPPHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 10:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiKPPHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 10:07:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F6A248C1
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 07:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668611205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nG9yzz83gQ5M2uNRxZwrKtK54pcLyuqOza9Uz1EHlTE=;
        b=DSa9iqu7C/qkhEx30zxEdR0NkbAhg9wsud0mvtu5IIoEjdoc6qjxfmV3uGsXRSV+fMWNaL
        UAs7HfcowF55U9eq06mDEjJ6K/ZUN8+7gd+qAyfZZhOZ1H8cFmg1oNoINJfmUuaLqthoi/
        ybTXrVPV7sONl4j2yv/qlzClLAHBCAQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-L6xm2OMMOXyxA4KtA3Y_Lg-1; Wed, 16 Nov 2022 10:06:42 -0500
X-MC-Unique: L6xm2OMMOXyxA4KtA3Y_Lg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E6E1019C88;
        Wed, 16 Nov 2022 15:06:41 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1728140EBF3;
        Wed, 16 Nov 2022 15:06:37 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH for 8.0 v7 10/10] vdpa: Always start CVQ in SVQ mode if possible
Date:   Wed, 16 Nov 2022 16:05:56 +0100
Message-Id: <20221116150556.1294049-11-eperezma@redhat.com>
In-Reply-To: <20221116150556.1294049-1-eperezma@redhat.com>
References: <20221116150556.1294049-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Isolate control virtqueue in its own group, allowing to intercept control
commands but letting dataplane run totally passthrough to the guest.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
v7:
* Never ask for number of address spaces, just react if isolation is not
  possible.
* Return ASID ioctl errors instead of masking them as if the device has
  no asid.
* Simplify net_init_vhost_vdpa logic
* Add "if possible" suffix

v6:
* Disable control SVQ if the device does not support it because of
features.

v5:
* Fixing the not adding cvq buffers when x-svq=on is specified.
* Move vring state in vhost_vdpa_get_vring_group instead of using a
  parameter.
* Rename VHOST_VDPA_NET_CVQ_PASSTHROUGH to VHOST_VDPA_NET_DATA_ASID

v4:
* Squash vhost_vdpa_cvq_group_is_independent.
* Rebased on last CVQ start series, that allocated CVQ cmd bufs at load
* Do not check for cvq index on vhost_vdpa_net_prepare, we only have one
  that callback registered in that NetClientInfo.

v3:
* Make asid related queries print a warning instead of returning an
  error and stop the start of qemu.
---
 hw/virtio/vhost-vdpa.c |   3 +-
 net/vhost-vdpa.c       | 117 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 114 insertions(+), 6 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 852baf8b2c..a29a18a6a9 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -653,7 +653,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
 {
     uint64_t features;
     uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
-        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
+        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
+        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
     int r;
 
     if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index a9c864741a..dc13a49311 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -101,6 +101,8 @@ static const uint64_t vdpa_svq_device_features =
     BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
     BIT_ULL(VIRTIO_NET_F_STANDBY);
 
+#define VHOST_VDPA_NET_CVQ_ASID 1
+
 VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
 {
     VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
@@ -242,6 +244,40 @@ static NetClientInfo net_vhost_vdpa_info = {
         .check_peer_type = vhost_vdpa_check_peer_type,
 };
 
+static int64_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_index)
+{
+    struct vhost_vring_state state = {
+        .index = vq_index,
+    };
+    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
+
+    if (unlikely(r < 0)) {
+        error_report("Cannot get VQ %u group: %s", vq_index,
+                     g_strerror(errno));
+        return r;
+    }
+
+    return state.num;
+}
+
+static int vhost_vdpa_set_address_space_id(struct vhost_vdpa *v,
+                                           unsigned vq_group,
+                                           unsigned asid_num)
+{
+    struct vhost_vring_state asid = {
+        .index = vq_group,
+        .num = asid_num,
+    };
+    int r;
+
+    r = ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
+    if (unlikely(r < 0)) {
+        error_report("Can't set vq group %u asid %u, errno=%d (%s)",
+                     asid.index, asid.num, errno, g_strerror(errno));
+    }
+    return r;
+}
+
 static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
 {
     VhostIOVATree *tree = v->iova_tree;
@@ -316,11 +352,69 @@ dma_map_err:
 static int vhost_vdpa_net_cvq_start(NetClientState *nc)
 {
     VhostVDPAState *s;
-    int r;
+    struct vhost_vdpa *v;
+    uint64_t backend_features;
+    int64_t cvq_group;
+    int cvq_index, r;
 
     assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
 
     s = DO_UPCAST(VhostVDPAState, nc, nc);
+    v = &s->vhost_vdpa;
+
+    v->shadow_data = s->always_svq;
+    v->shadow_vqs_enabled = s->always_svq;
+    s->vhost_vdpa.address_space_id = VHOST_VDPA_GUEST_PA_ASID;
+
+    if (s->always_svq) {
+        goto out;
+    }
+
+    /* Backend features are not available in v->dev yet. */
+    r = ioctl(v->device_fd, VHOST_GET_BACKEND_FEATURES, &backend_features);
+    if (unlikely(r < 0)) {
+        error_report("Cannot get vdpa backend_features: %s(%d)",
+            g_strerror(errno), errno);
+        return -1;
+    }
+    if (!(backend_features & VHOST_BACKEND_F_IOTLB_ASID) ||
+        !vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
+        return 0;
+    }
+
+    /**
+     * Check if all the virtqueues of the virtio device are in a different vq
+     * than the last vq. VQ group of last group passed in cvq_group.
+     */
+    cvq_index = v->dev->vq_index_end - 1;
+    cvq_group = vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
+    if (unlikely(cvq_group < 0)) {
+        return cvq_group;
+    }
+    for (int i = 0; i < cvq_index; ++i) {
+        int64_t group = vhost_vdpa_get_vring_group(v->device_fd, i);
+
+        if (unlikely(group < 0)) {
+            return group;
+        }
+
+        if (unlikely(group == cvq_group)) {
+            warn_report(
+                "CVQ %"PRId64" group is the same as VQ %d one (%"PRId64")",
+                cvq_group, i, group);
+            return 0;
+        }
+    }
+
+    r = vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_CVQ_ASID);
+    if (unlikely(r < 0)) {
+        return r;
+    } else {
+        v->shadow_vqs_enabled = true;
+        s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
+    }
+
+out:
     if (!s->vhost_vdpa.shadow_vqs_enabled) {
         return 0;
     }
@@ -652,6 +746,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     g_autoptr(VhostIOVATree) iova_tree = NULL;
     NetClientState *nc;
     int queue_pairs, r, i = 0, has_cvq = 0;
+    bool svq_cvq;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
     opts = &netdev->u.vhost_vdpa;
@@ -693,12 +788,24 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
         return queue_pairs;
     }
 
-    if (opts->x_svq) {
-        struct vhost_vdpa_iova_range iova_range;
+    svq_cvq = opts->x_svq || has_cvq;
+    if (svq_cvq) {
+        Error *warn = NULL;
 
-        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
-            goto err_svq;
+        svq_cvq = vhost_vdpa_net_valid_svq_features(features,
+                                                   opts->x_svq ? errp : &warn);
+        if (!svq_cvq) {
+            if (opts->x_svq) {
+                goto err_svq;
+            } else {
+                warn_reportf_err(warn, "Cannot shadow CVQ: ");
+            }
         }
+    }
+
+    if (svq_cvq) {
+        /* Allocate a common iova tree if there is a possibility of SVQ */
+        struct vhost_vdpa_iova_range iova_range;
 
         vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
         iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);
-- 
2.31.1

