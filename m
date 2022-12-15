Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F0B64DA71
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiLOLez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLOLeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:34:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A94C29361
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bgm13BxT3w9/bf/Q3/tjjDwn3ewco6Sm6e47Y2FWYg4=;
        b=hoMDoOPxsGDj9bPbgmKjJgLGiyW3KY98dsMYEVUjxXbOlO+FILC+Sx+DHpDHk8D/DkUZYj
        eNE2BV7ltyv5wmw+jF+bCwYhdoQ1YyikhEhV0V03JntukaiEbwjIXgPtOvdRG3iT8RZff7
        rEAvZamYrLL+b3UTAakCdJdqoGFN+mc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-zqpl_RVmMraUk_Kl-3M2Sg-1; Thu, 15 Dec 2022 06:32:39 -0500
X-MC-Unique: zqpl_RVmMraUk_Kl-3M2Sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8A02382C96F;
        Thu, 15 Dec 2022 11:32:38 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 903002166B26;
        Thu, 15 Dec 2022 11:32:35 +0000 (UTC)
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
Subject: [PATCH v9 12/12] vdpa: always start CVQ in SVQ mode if possible
Date:   Thu, 15 Dec 2022 12:31:44 +0100
Message-Id: <20221215113144.322011-13-eperezma@redhat.com>
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

Isolate control virtqueue in its own group, allowing to intercept control
commands but letting dataplane run totally passthrough to the guest.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
v9:
* Reuse iova_range fetched from the device at initialization, instead of
  fetch it again at vhost_vdpa_net_cvq_start.
* Add comment about how migration is blocked in case ASID does not met
  our expectations.
* Delete warning about CVQ group not being independent.

v8:
* Do not allocate iova_tree on net_init_vhost_vdpa if only CVQ is
  shadowed. Move the iova_tree handling in this case to
  vhost_vdpa_net_cvq_start and vhost_vdpa_net_cvq_stop.

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
 net/vhost-vdpa.c       | 110 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 48d8c60e76..8cd00f5a96 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -638,7 +638,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
 {
     uint64_t features;
     uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
-        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
+        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
+        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
     int r;
 
     if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 710c5efe96..d36664f33a 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -102,6 +102,8 @@ static const uint64_t vdpa_svq_device_features =
     BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
     BIT_ULL(VIRTIO_NET_F_STANDBY);
 
+#define VHOST_VDPA_NET_CVQ_ASID 1
+
 VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
 {
     VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
@@ -243,6 +245,40 @@ static NetClientInfo net_vhost_vdpa_info = {
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
@@ -317,11 +353,75 @@ dma_map_err:
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
+        /* SVQ is already configured for all virtqueues */
+        goto out;
+    }
+
+    /*
+     * If we early return in these cases SVQ will not be enabled. The migration
+     * will be blocked as long as vhost-vdpa backends will not offer _F_LOG.
+     *
+     * Calling VHOST_GET_BACKEND_FEATURES as they are not available in v->dev
+     * yet.
+     */
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
+    /*
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
+        if (group == cvq_group) {
+            return 0;
+        }
+    }
+
+    r = vhost_vdpa_set_address_space_id(v, cvq_group, VHOST_VDPA_NET_CVQ_ASID);
+    if (unlikely(r < 0)) {
+        return r;
+    }
+
+    v->iova_tree = vhost_iova_tree_new(v->iova_range.first,
+                                       v->iova_range.last);
+    v->shadow_vqs_enabled = true;
+    s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
+
+out:
     if (!s->vhost_vdpa.shadow_vqs_enabled) {
         return 0;
     }
@@ -350,6 +450,14 @@ static void vhost_vdpa_net_cvq_stop(NetClientState *nc)
     if (s->vhost_vdpa.shadow_vqs_enabled) {
         vhost_vdpa_cvq_unmap_buf(&s->vhost_vdpa, s->cvq_cmd_out_buffer);
         vhost_vdpa_cvq_unmap_buf(&s->vhost_vdpa, s->status);
+        if (!s->always_svq) {
+            /*
+             * If only the CVQ is shadowed we can delete this safely.
+             * If all the VQs are shadows this will be needed by the time the
+             * device is started again to register SVQ vrings and similar.
+             */
+            g_clear_pointer(&s->vhost_vdpa.iova_tree, vhost_iova_tree_delete);
+        }
     }
 }
 
-- 
2.31.1

