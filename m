Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC8457E27F
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 15:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiGVNnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 09:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbiGVNnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 09:43:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C1A47859F
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658497427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+d1YaUOb2Xz5MsGpJ1hi2AuJIoactnpJkhrLVcKrmxI=;
        b=SRbDsj/dq85gmjlBpNSaULfjw6XBjznJYElKZFwV2b48Dd49ig486YVSogCsbtfV6aWao8
        RYFmxbcsOhXubJim5c6r0hlaZ2In4OFy03bRdkRDeO1NZGhPHI6b1nQ3unGSSzlIVN7Lzc
        Dy2pCZi0qU6sjNMSGSNjyHLJTLWKDas=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-58qf-zb0PUS0dvNuFaXKfw-1; Fri, 22 Jul 2022 09:43:44 -0400
X-MC-Unique: 58qf-zb0PUS0dvNuFaXKfw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E1F8185A7B2;
        Fri, 22 Jul 2022 13:43:43 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB83A401E92;
        Fri, 22 Jul 2022 13:43:40 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Cindy Lu <lulu@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 7/7] vdpa: Always start CVQ in SVQ mode
Date:   Fri, 22 Jul 2022 15:43:18 +0200
Message-Id: <20220722134318.3430667-8-eperezma@redhat.com>
In-Reply-To: <20220722134318.3430667-1-eperezma@redhat.com>
References: <20220722134318.3430667-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 hw/virtio/vhost-vdpa.c |   3 +-
 net/vhost-vdpa.c       | 158 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 156 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 79623badf2..fe1c85b086 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -668,7 +668,8 @@ static int vhost_vdpa_set_backend_cap(struct vhost_dev *dev)
 {
     uint64_t features;
     uint64_t f = 0x1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2 |
-        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH;
+        0x1ULL << VHOST_BACKEND_F_IOTLB_BATCH |
+        0x1ULL << VHOST_BACKEND_F_IOTLB_ASID;
     int r;
 
     if (vhost_vdpa_call(dev, VHOST_GET_BACKEND_FEATURES, &features)) {
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 6c1c64f9b1..f5075ef487 100644
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
@@ -214,6 +219,109 @@ static ssize_t vhost_vdpa_receive(NetClientState *nc, const uint8_t *buf,
     return 0;
 }
 
+static int vhost_vdpa_get_vring_group(int device_fd,
+                                      struct vhost_vring_state *state)
+{
+    int r = ioctl(device_fd, VHOST_VDPA_GET_VRING_GROUP, state);
+    return r < 0 ? -errno : 0;
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
+    int ret;
+
+    for (int i = 0; i < (dev->vq_index_end - 1); ++i) {
+        struct vhost_vring_state vq_group = {
+            .index = i,
+        };
+
+        ret = vhost_vdpa_get_vring_group(v->device_fd, &vq_group);
+        if (unlikely(ret)) {
+            goto call_err;
+        }
+        if (unlikely(vq_group.num == cvq_group.num)) {
+            error_report("CVQ %u group is the same as VQ %u one (%u)",
+                         cvq_group.index, vq_group.index, cvq_group.num);
+            return false;
+        }
+    }
+
+    return true;
+
+call_err:
+    error_report("Can't read vq group, errno=%d (%s)", -ret, g_strerror(-ret));
+    return false;
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
+        error_report("Can't set vq group %u asid %u, errno=%d (%s)",
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
+    r = vhost_vdpa_get_vring_group(v->device_fd, &cvq_group);
+    if (unlikely(r)) {
+        error_report("Can't read cvq group, errno=%d (%s)", r, g_strerror(-r));
+        v->shadow_vqs_enabled = false;
+        return;
+    }
+
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
@@ -432,6 +540,7 @@ static NetClientInfo net_vhost_vdpa_info = {
         .type = NET_CLIENT_DRIVER_VHOST_VDPA,
         .size = sizeof(VhostVDPAState),
         .receive = vhost_vdpa_receive,
+        .prepare = vhost_vdpa_net_prepare,
         .start = vhost_vdpa_net_start,
         .cleanup = vhost_vdpa_cleanup,
         .has_vnet_hdr = vhost_vdpa_has_vnet_hdr,
@@ -542,12 +651,40 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
     .avail_handler = vhost_vdpa_net_handle_ctrl_avail,
 };
 
+static bool vhost_vdpa_get_as_num(int vdpa_device_fd, unsigned *num_as,
+                                  Error **errp)
+{
+    uint64_t features;
+    int r;
+
+    r = ioctl(vdpa_device_fd, VHOST_GET_BACKEND_FEATURES, &features);
+    if (unlikely(r < 0)) {
+        error_setg_errno(errp, errno, "Cannot get backend features");
+        return r;
+    }
+
+    if (!(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID))) {
+        *num_as = 1;
+        return 0;
+    }
+
+    r = ioctl(vdpa_device_fd, VHOST_VDPA_GET_AS_NUM, num_as);
+    if (unlikely(r < 0)) {
+        error_setg_errno(errp, errno,
+                         "Cannot retrieve number of supported ASs");
+        return r;
+    }
+
+    return 0;
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
@@ -566,6 +703,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     snprintf(nc->info_str, sizeof(nc->info_str), TYPE_VHOST_VDPA);
     s = DO_UPCAST(VhostVDPAState, nc, nc);
 
+    s->address_space_num = nas;
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
     s->always_svq = svq;
@@ -651,6 +789,8 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     g_autoptr(VhostIOVATree) iova_tree = NULL;
     NetClientState *nc;
     int queue_pairs, r, i, has_cvq = 0;
+    unsigned num_as = 1;
+    bool svq_cvq;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_VDPA);
     opts = &netdev->u.vhost_vdpa;
@@ -676,7 +816,17 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
         return queue_pairs;
     }
 
-    if (opts->x_svq) {
+    svq_cvq = opts->x_svq;
+    if (has_cvq && !opts->x_svq) {
+        r = vhost_vdpa_get_as_num(vdpa_device_fd, &num_as, errp);
+        if (unlikely(r < 0)) {
+            return r;
+        }
+
+        svq_cvq = num_as > 1;
+    }
+
+    if (opts->x_svq || svq_cvq) {
         struct vhost_vdpa_iova_range iova_range;
 
         uint64_t invalid_dev_features =
@@ -699,15 +849,15 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
 
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

