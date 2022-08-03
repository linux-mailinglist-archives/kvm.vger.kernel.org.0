Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAC1589126
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbiHCRTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237931AbiHCRTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B7945467C
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659547160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FS8WOWx2Mlz/EPB9nn2iUK0MkKtiWEii0lW9lgeSWZc=;
        b=Pfzv83jF5BUtKMV+VWTaidkRrwRqCq9QVsD2XTWKx654sbqIkIxNVE+mQagmikUV0CG94U
        j+SQv67ZAgKd1VpGIp2h2Z8x8+crJrM1DXW7ICZdOFSL5owC2/SV4jFgFCYvVj0y3FfTcV
        GdCZooxORr5UYO3eH9A5ZQ+q0QayxA8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-_Mgt6Ij6ORGrFasUXz0O6w-1; Wed, 03 Aug 2022 13:19:12 -0400
X-MC-Unique: _Mgt6Ij6ORGrFasUXz0O6w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B5EA1C04B64;
        Wed,  3 Aug 2022 17:18:47 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D103C1121314;
        Wed,  3 Aug 2022 17:18:44 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: [PATCH v3 7/7] vdpa: Always start CVQ in SVQ mode
Date:   Wed,  3 Aug 2022 19:18:21 +0200
Message-Id: <20220803171821.481336-8-eperezma@redhat.com>
In-Reply-To: <20220803171821.481336-1-eperezma@redhat.com>
References: <20220803171821.481336-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Isolate control virtqueue in its own group, allowing to intercept control
commands but letting dataplane run totally passthrough to the guest.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
v3:
* Make asid related queries print a warning instead of returning an
  error and stop the start of qemu.
---
 hw/virtio/vhost-vdpa.c |   3 +-
 net/vhost-vdpa.c       | 144 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 142 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 131100841c..a4cb68862b 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -674,7 +674,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
 {
     uint64_t features;
     uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
-        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
+        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
+        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
     int r;
 
     if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index e3b65ed546..5f39f0edb5 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -37,6 +37,9 @@ typedef struct VhostVDPAState {
     /* Control commands shadow buffers */
     void *cvq_cmd_out_buffer, *cvq_cmd_in_buffer;
 
+    /* Number of address spaces supported by the device */
+    unsigned address_space_num;
+
     /* The device always have SVQ enabled */
     bool always_svq;
     bool started;
@@ -100,6 +103,8 @@ static const uint64_t vdpa_svq_device_features =
     BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
     BIT_ULL(VIRTIO_NET_F_STANDBY);
 
+#define VHOST_VDPA_NET_CVQ_ASID 1
+
 VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
 {
     VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
@@ -224,6 +229,101 @@ static NetClientInfo net_vhost_vdpa_info = {
         .check_peer_type = vhost_vdpa_check_peer_type,
 };
 
+static void vhost_vdpa_get_vring_group(int device_fd,
+                                       struct vhost_vring_state *state)
+{
+    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);
+    if (unlikely(r < 0)) {
+        /*
+         * Assume all groups are 0, the consequences are the same and we will
+         * not abort device creation
+         */
+        state->num = 0;
+    }
+}
+
+/**
+ * Check if all the virtqueues of the virtio device are in a different vq than
+ * the last vq. VQ group of last group passed in cvq_group.
+ */
+static bool vhost_vdpa_cvq_group_is_independent(struct vhost_vdpa *v,
+                                            struct vhost_vring_state cvq_group)
+{
+    struct vhost_dev *dev = v->dev;
+
+    for (int i = 0; i < (dev->vq_index_end - 1); ++i) {
+        struct vhost_vring_state vq_group = {
+            .index = i,
+        };
+
+        vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
+        if (unlikely(vq_group.num == cvq_group.num)) {
+            warn_report("CVQ %u group is the same as VQ %u one (%u)",
+                         cvq_group.index, vq_group.index, cvq_group.num);
+            return false;
+        }
+    }
+
+    return true;
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
+static void vhost_vdpa_net_prepare(NetClientState *nc)
+{
+    VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
+    struct vhost_vdpa *v = &s->vhost_vdpa;
+    struct vhost_dev *dev = v->dev;
+    struct vhost_vring_state cvq_group = {
+        .index = v->dev->vq_index_end - 1,
+    };
+    int r;
+
+    assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
+
+    if (dev->nvqs != 1 || dev->vq_index + dev->nvqs != dev->vq_index_end) {
+        /* Only interested in CVQ */
+        return;
+    }
+
+    if (s->always_svq) {
+        /* SVQ is already enabled */
+        return;
+    }
+
+    if (s->address_space_num < 2) {
+        v->shadow_vqs_enabled = false;
+        return;
+    }
+
+    vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
+    if (!vhost_vdpa_cvq_group_is_independent(v, cvq_group)) {
+        v->shadow_vqs_enabled = false;
+        return;
+    }
+
+    r = vhost_vdpa_set_address_space_id(v, cvq_group.num,
+                                        VHOST_VDPA_NET_CVQ_ASID);
+    v->shadow_vqs_enabled = r == 0;
+    s->vhost_vdpa.address_space_id = r == 0 ? 1 : 0;
+}
+
 static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
 {
     VhostIOVATree *tree = v->iova_tree;
@@ -431,6 +531,7 @@ static NetClientInfo net_vhost_vdpa_cvq_info = {
     .type = NET_CLIENT_DRIVER_VHOST_VDPA,
     .size = sizeof(VhostVDPAState),
     .receive = vhost_vdpa_receive,
+    .prepare = vhost_vdpa_net_prepare,
     .load = vhost_vdpa_net_load,
     .cleanup = vhost_vdpa_cleanup,
     .has_vnet_hdr = vhost_vdpa_has_vnet_hdr,
@@ -541,12 +642,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
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
@@ -565,6 +692,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
     s = DO_UPCAST(VhostVDPAState, nc, nc);
 
+    s->address_space_num = nas;
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
     s->always_svq = svq;
@@ -650,6 +778,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     g_autoptr(VhostIOVATree) iova_tree = NULL;
     NetClientState *nc;
     int queue_pairs, r, i = 0, has_cvq = 0;
+    unsigned num_as = 1;
+    bool svq_cvq;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
     opts = &netdev->u.vhost_vdpa;
@@ -674,7 +804,13 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
         goto err;
     }
 
-    if (opts->x_svq) {
+    svq_cvq = opts->x_svq;
+    if (has_cvq && !opts->x_svq) {
+        num_as = vhost_vdpa_get_as_num(vdpa_device_fd);
+        svq_cvq = num_as > 1;
+    }
+
+    if (opts->x_svq || svq_cvq) {
         struct vhost_vdpa_iova_range iova_range;
 
         uint64_t invalid_dev_features =
@@ -697,15 +833,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
 
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

