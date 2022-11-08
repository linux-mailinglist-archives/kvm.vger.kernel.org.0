Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79141621A20
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbiKHRJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiKHRJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:09:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90BFC78
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667927321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=If4S3cCeO2eUUCHpP9Nxu6qdTx4M0Bqp6cwVgH/vl/c=;
        b=CWAhb2zTWn3SPWva7CXaPOAUlNpAGt9pSmIWtx1Q1iHp3KysRvovxX3+Nz4jtNKSB98m+B
        uZTtKTFdLjyOopLfAH7I+0zu1Gl7bCepIBvj2SmW52QfxX1fOCAmu1aJG2IRJp27t0FcRB
        5WBU0pmUy95WxKRQUOu7M2//iK1g7BA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-bY95kl3AOZqyvMY6N3Tx7Q-1; Tue, 08 Nov 2022 12:08:36 -0500
X-MC-Unique: bY95kl3AOZqyvMY6N3Tx7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 864DD101A56C;
        Tue,  8 Nov 2022 17:08:35 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7988FC15BB5;
        Tue,  8 Nov 2022 17:08:32 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v6 10/10] vdpa: Always start CVQ in SVQ mode
Date:   Tue,  8 Nov 2022 18:07:55 +0100
Message-Id: <20221108170755.92768-11-eperezma@redhat.com>
In-Reply-To: <20221108170755.92768-1-eperezma@redhat.com>
References: <20221108170755.92768-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 net/vhost-vdpa.c       | 138 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index e3914fa40e..6401e7efb1 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -648,7 +648,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
 {
     uint64_t features;
     uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
-        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
+        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
+        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
     int r;
 
     if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 02780ee37b..7245ea70c6 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -38,6 +38,9 @@ typedef struct VhostVDPAState {
     void *cvq_cmd_out_buffer;
     virtio_net_ctrl_ack *status;
 
+    /* Number of address spaces supported by the device */
+    unsigned address_space_num;
+
     /* The device always have SVQ enabled */
     bool always_svq;
     bool started;
@@ -101,6 +104,9 @@ static const uint64_t vdpa_svq_device_features =
     BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
     BIT_ULL(VIRTIO_NET_F_STANDBY);
 
+#define VHOST_VDPA_NET_DATA_ASID 0
+#define VHOST_VDPA_NET_CVQ_ASID 1
+
 VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
 {
     VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
@@ -242,6 +248,34 @@ static NetClientInfo net_vhost_vdpa_info = {
         .check_peer_type = vhost_vdpa_check_peer_type,
 };
 
+static uint32_t vhost_vdpa_get_vring_group(int device_fd, unsigned vq_index)
+{
+    struct vhost_vring_state state = {
+        .index = vq_index,
+    };
+    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, &state);
+
+    return r < 0 ? 0 : state.num;
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
+    int ret;
+
+    ret = ioctl(v->device_fd, VHOST_VDPA_SET_GROUP_ASID, &asid);
+    if (unlikely(ret < 0)) {
+        warn_report("Can't set vq group %u asid %u, errno=%d (%s)",
+            asid.index, asid.num, errno, g_strerror(errno));
+    }
+    return ret;
+}
+
 static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
 {
     VhostIOVATree *tree = v->iova_tree;
@@ -316,11 +350,54 @@ dma_map_err:
 static int vhost_vdpa_net_cvq_start(NetClientState *nc)
 {
     VhostVDPAState *s;
-    int r;
+    struct vhost_vdpa *v;
+    uint32_t cvq_group;
+    int cvq_index, r;
 
     assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
 
     s = DO_UPCAST(VhostVDPAState, nc, nc);
+    v = &s->vhost_vdpa;
+
+    v->listener_shadow_vq = s->always_svq;
+    v->shadow_vqs_enabled = s->always_svq;
+    s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_DATA_ASID;
+
+    if (s->always_svq) {
+        goto out;
+    }
+
+    if (s->address_space_num < 2) {
+        return 0;
+    }
+
+    if (!vhost_vdpa_net_valid_svq_features(v->dev->features, NULL)) {
+        return 0;
+    }
+
+    /**
+     * Check if all the virtqueues of the virtio device are in a different vq
+     * than the last vq. VQ group of last group passed in cvq_group.
+     */
+    cvq_index = v->dev->vq_index_end - 1;
+    cvq_group = vhost_vdpa_get_vring_group(v->device_fd, cvq_index);
+    for (int i = 0; i < cvq_index; ++i) {
+        uint32_t group = vhost_vdpa_get_vring_group(v->device_fd, i);
+
+        if (unlikely(group == cvq_group)) {
+            warn_report("CVQ %u group is the same as VQ %u one (%u)", cvq_group,
+                        i, group);
+            return 0;
+        }
+    }
+
+    r = vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_CVQ_ASID);
+    if (r == 0) {
+        v->shadow_vqs_enabled = true;
+        s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
+    }
+
+out:
     if (!s->vhost_vdpa.shadow_vqs_enabled) {
         return 0;
     }
@@ -542,12 +619,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
     .avail_handler = vhost_vdpa_net_handle_ctrl_avail,
 };
 
+static uint32_t vhost_vdpa_get_as_num(int vdpa_device_fd)
+{
+    uint64_t features;
+    unsigned num_as;
+    int r;
+
+    r = ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features);
+    if (unlikely(r < 0)) {
+        warn_report("Cannot get backend features");
+        return 1;
+    }
+
+    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
+        return 1;
+    }
+
+    r = ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, &num_as);
+    if (unlikely(r < 0)) {
+        warn_report("Cannot retrieve number of supported ASs");
+        return 1;
+    }
+
+    return num_as;
+}
+
 static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
                                            const char *device,
                                            const char *name,
                                            int vdpa_device_fd,
                                            int queue_pair_index,
                                            int nvqs,
+                                           unsigned nas,
                                            bool is_datapath,
                                            bool svq,
                                            VhostIOVATree *iova_tree)
@@ -566,6 +669,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     qemu_set_info_str(nc, TYPE_VHOST_VDPA);
     s = DO_UPCAST(VhostVDPAState, nc, nc);
 
+    s->address_space_num = nas;
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
     s->always_svq = svq;
@@ -652,6 +756,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     g_autoptr(VhostIOVATree) iova_tree = NULL;
     NetClientState *nc;
     int queue_pairs, r, i = 0, has_cvq = 0;
+    unsigned num_as = 1;
+    bool svq_cvq;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
     opts = &netdev->u.vhost_vdpa;
@@ -693,12 +799,28 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
         return queue_pairs;
     }
 
-    if (opts->x_svq) {
-        struct vhost_vdpa_iova_range iova_range;
+    svq_cvq = opts->x_svq;
+    if (has_cvq && !opts->x_svq) {
+        num_as = vhost_vdpa_get_as_num(vdpa_device_fd);
+        svq_cvq = num_as > 1;
+    }
+
+    if (opts->x_svq || svq_cvq) {
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
+    if (opts->x_svq || svq_cvq) {
+        struct vhost_vdpa_iova_range iova_range;
 
         vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
         iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);
@@ -708,15 +830,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
 
     for (i = 0; i < queue_pairs; i++) {
         ncs[i] = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
-                                     vdpa_device_fd, i, 2, true, opts->x_svq,
-                                     iova_tree);
+                                     vdpa_device_fd, i, 2, num_as, true,
+                                     opts->x_svq, iova_tree);
         if (!ncs[i])
             goto err;
     }
 
     if (has_cvq) {
         nc = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
-                                 vdpa_device_fd, i, 1, false,
+                                 vdpa_device_fd, i, 1, num_as, false,
                                  opts->x_svq, iova_tree);
         if (!nc)
             goto err;
-- 
2.31.1

