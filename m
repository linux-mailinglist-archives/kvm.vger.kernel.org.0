Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1784458AE48
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 18:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241114AbiHEQjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 12:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241091AbiHEQjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 12:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DBFF79EF8
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 09:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659717577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2qG/DrMQ1sR/wng6kjZ4mlPv6kuW7pRnO/xQHwpD34=;
        b=JCZDN35PYmnHkWDPKDsC9AvBxw6SF4UGtdxokG7P9BFZf2WI44a/Nhw++FO1UPHd/TeM9X
        u3ebOgSeuRsnAaq+Utz0G7hgG0Iq79bWcuO1UNaC45pXPNAfdM2YuS6g2Nvj2iipBsSQ7f
        Urjmh4hXw3zPzd3p24LYXYS9lKF5rtg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-GCdQiKavOOWsEevuDZr8EQ-1; Fri, 05 Aug 2022 12:39:33 -0400
X-MC-Unique: GCdQiKavOOWsEevuDZr8EQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A23DD38149BE;
        Fri,  5 Aug 2022 16:39:32 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F02872166B26;
        Fri,  5 Aug 2022 16:39:29 +0000 (UTC)
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
Subject: [PATCH v4 6/6] vdpa: Always start CVQ in SVQ mode
Date:   Fri,  5 Aug 2022 18:39:09 +0200
Message-Id: <20220805163909.872646-7-eperezma@redhat.com>
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

Isolate control virtqueue in its own group, allowing to intercept control
commands but letting dataplane run totally passthrough to the guest.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
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
 net/vhost-vdpa.c       | 124 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 3eb67b27b7..69f34f4cc5 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -678,7 +678,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
 {
     uint64_t features;
     uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
-        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
+        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
+        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
     int r;
 
     if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index bf78b1332f..c820a5fd9f 100644
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
@@ -100,6 +103,9 @@ static const uint64_t vdpa_svq_device_features =
     BIT_ULL(VIRTIO_NET_F_RSC_EXT) |
     BIT_ULL(VIRTIO_NET_F_STANDBY);
 
+#define VHOST_VDPA_NET_CVQ_PASSTHROUGH 0
+#define VHOST_VDPA_NET_CVQ_ASID 1
+
 VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
 {
     VhostVDPAState *s = DO_UPCAST(VhostVDPAState, nc, nc);
@@ -224,6 +230,37 @@ static NetClientInfo net_vhost_vdpa_info = {
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
@@ -298,11 +335,55 @@ dma_map_err:
 static int vhost_vdpa_net_cvq_prepare(NetClientState *nc)
 {
     VhostVDPAState *s;
+    struct vhost_vdpa *v;
+    struct vhost_vring_state cvq_group = {};
     int r;
 
     assert(nc->info->type == NET_CLIENT_DRIVER_VHOST_VDPA);
 
     s = DO_UPCAST(VhostVDPAState, nc, nc);
+    v = &s->vhost_vdpa;
+    cvq_group.index = v->dev->vq_index_end - 1;
+
+    /* Default values */
+    v->shadow_vqs_enabled = false;
+    s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_PASSTHROUGH;
+
+    if (s->always_svq) {
+        v->shadow_vqs_enabled = true;
+        goto out;
+    }
+
+    if (s->address_space_num < 2) {
+        return 0;
+    }
+
+    /**
+     * Check if all the virtqueues of the virtio device are in a different vq
+     * than the last vq. VQ group of last group passed in cvq_group.
+     */
+    vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
+    for (int i = 0; i < (v->dev->vq_index_end - 1); ++i) {
+        struct vhost_vring_state vq_group = {
+            .index = i,
+        };
+
+        vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
+        if (unlikely(vq_group.num == cvq_group.num)) {
+            warn_report("CVQ %u group is the same as VQ %u one (%u)",
+                         cvq_group.index, vq_group.index, cvq_group.num);
+            return 0;
+        }
+    }
+
+    r = vhost_vdpa_set_address_space_id(v, cvq_group.num,
+                                        VHOST_VDPA_NET_CVQ_ASID);
+    if (r == 0) {
+        v->shadow_vqs_enabled = true;
+        s->vhost_vdpa.address_space_id = VHOST_VDPA_NET_CVQ_ASID;
+    }
+
+out:
     if (!s->vhost_vdpa.shadow_vqs_enabled) {
         return 0;
     }
@@ -523,12 +604,38 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
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
@@ -547,6 +654,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
     s = DO_UPCAST(VhostVDPAState, nc, nc);
 
+    s->address_space_num = nas;
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
     s->always_svq = svq;
@@ -632,6 +740,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     g_autoptr(VhostIOVATree) iova_tree = NULL;
     NetClientState *nc;
     int queue_pairs, r, i = 0, has_cvq = 0;
+    unsigned num_as = 1;
+    bool svq_cvq;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
     opts = &netdev->u.vhost_vdpa;
@@ -656,7 +766,13 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
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
@@ -679,15 +795,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
 
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

