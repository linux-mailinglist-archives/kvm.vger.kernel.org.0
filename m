Return-Path: <kvm+bounces-52153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40457B01CE9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4407058024E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29D12D23B8;
	Fri, 11 Jul 2025 13:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XwmZTnSE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCA32E49B9
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239044; cv=none; b=V1ASRyX/gnSVWxWG7kEX432eX2w7KFFU00mDmR7VlV4H6uvaPwcR4Xbq44XrEEVHHBfz9ztlITKMwiD1B0JB7dcwnw4SF6Ri1M1K3qDYu+T7rFxZRqyQiePEgP+wSejsy056bPjfN+svAAtWyNCRPhHfxD1b2YInvHoHAMyJDmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239044; c=relaxed/simple;
	bh=41FWXR10HcAOPc/yLpLeKi8oQQ6ehEZQM+TX6SCk59Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsODGaA2UrYeUreo/tZaBfWpSdXfPzvcqu0YvIxiwNx4YfOnuHBPomd3llSOgMrhExgasoeEWI6LvG99ZoEJKTA7x316yUNxJznzPE6VaujxrQyH634tcA85yFMOvgMFsal06IPu0i467+hH53UU88ac0XjjdP6NIQH8mKSmqB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XwmZTnSE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752239041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VwICP7osbtCMDY8K14kNvPRMwTMtoYbzOjS9iaDvYOY=;
	b=XwmZTnSEgW/fufsDhKhWb0DM2FpGyiYaGKhdUthw4vyHHQPTsbFMRGxeOqLDOXsBZreWpB
	i015BY+B1t/hvuDg4SkESuIC0Z7yx0Vb/SoyeOFj+bEx5vY2sSnfNL1QHDtVnHYcE/lQiE
	fDr0LwH19Urjmr/4/E5x+7Fe8i3S9ZI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-4m2qcR0KN_WlbZiWsncZMA-1; Fri,
 11 Jul 2025 09:03:57 -0400
X-MC-Unique: 4m2qcR0KN_WlbZiWsncZMA-1
X-Mimecast-MFC-AGG-ID: 4m2qcR0KN_WlbZiWsncZMA_1752239036
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D9E01800368;
	Fri, 11 Jul 2025 13:03:56 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CB7419560A3;
	Fri, 11 Jul 2025 13:03:49 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Jason Wang <jasowang@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Luigi Rizzo <lrizzo@google.com>,
	Giuseppe Lettieri <g.lettieri@iet.unipi.it>,
	Vincenzo Maffione <v.maffione@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH RFC v2 11/13] virtio-net: implement extended features support
Date: Fri, 11 Jul 2025 15:02:16 +0200
Message-ID: <a8808b1e81204058ea0f9e5eacc267e93608bce1.1752229731.git.pabeni@redhat.com>
In-Reply-To: <cover.1752229731.git.pabeni@redhat.com>
References: <cover.1752229731.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Use the extended types and helpers to manipulate the virtio_net
features.

Note that offloads are still 64bits wide, as per specification,
and extended offloads will be mapped into such range.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - uint128_t -> uint64_t[]
  - more verbose macro definitions
---
 hw/net/virtio-net.c            | 125 +++++++++++++++++++--------------
 include/hw/virtio/virtio-net.h |   2 +-
 2 files changed, 75 insertions(+), 52 deletions(-)

diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 16df9e85c8..09d5ef1ece 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -90,6 +90,19 @@
                                          VIRTIO_NET_RSS_HASH_TYPE_TCP_EX | \
                                          VIRTIO_NET_RSS_HASH_TYPE_UDP_EX)
 
+/*
+ * Features starting from VIRTIO_NET_FEATURES_MAP_MIN bit correspond
+ * to guest offloads in the VIRTIO_NET_OFFLOAD_MAP range
+ */
+#define VIRTIO_NET_OFFLOAD_MAP_MIN    46
+#define VIRTIO_NET_OFFLOAD_MAP_LENGTH 4
+#define VIRTIO_NET_OFFLOAD_MAP        MAKE_64BIT_MASK(                    \
+                                              VIRTIO_NET_OFFLOAD_MAP_MIN, \
+                                              VIRTIO_NET_OFFLOAD_MAP_LENGTH)
+#define VIRTIO_NET_FEATURES_MAP_MIN   65
+#define VIRTIO_NET_F2O_SHIFT          (VIRTIO_NET_OFFLOAD_MAP_MIN - \
+                                       VIRTIO_NET_FEATURES_MAP_MIN + 64)
+
 static const VirtIOFeature feature_sizes[] = {
     {.flags = 1ULL << VIRTIO_NET_F_MAC,
      .end = endof(struct virtio_net_config, mac)},
@@ -752,59 +765,59 @@ static void virtio_net_set_queue_pairs(VirtIONet *n)
 
 static void virtio_net_set_multiqueue(VirtIONet *n, int multiqueue);
 
-static uint64_t virtio_net_get_features(VirtIODevice *vdev, uint64_t features,
-                                        Error **errp)
+static void virtio_net_get_features(VirtIODevice *vdev, uint64_t *features,
+                                    Error **errp)
 {
     VirtIONet *n = VIRTIO_NET(vdev);
     NetClientState *nc = qemu_get_queue(n->nic);
 
     /* Firstly sync all virtio-net possible supported features */
-    features |= n->host_features;
+    virtio_features_or(features, features, n->host_features_array);
 
-    virtio_add_feature(&features, VIRTIO_NET_F_MAC);
+    virtio_add_feature_ex(features, VIRTIO_NET_F_MAC);
 
     if (!peer_has_vnet_hdr(n)) {
-        virtio_clear_feature(&features, VIRTIO_NET_F_CSUM);
-        virtio_clear_feature(&features, VIRTIO_NET_F_HOST_TSO4);
-        virtio_clear_feature(&features, VIRTIO_NET_F_HOST_TSO6);
-        virtio_clear_feature(&features, VIRTIO_NET_F_HOST_ECN);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_CSUM);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_TSO4);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_TSO6);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_ECN);
 
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_CSUM);
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_TSO4);
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_TSO6);
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_ECN);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_CSUM);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_TSO4);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_TSO6);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_ECN);
 
-        virtio_clear_feature(&features, VIRTIO_NET_F_HOST_USO);
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_USO4);
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_USO6);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_USO);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_USO4);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_USO6);
 
-        virtio_clear_feature(&features, VIRTIO_NET_F_HASH_REPORT);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HASH_REPORT);
     }
 
     if (!peer_has_vnet_hdr(n) || !peer_has_ufo(n)) {
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_UFO);
-        virtio_clear_feature(&features, VIRTIO_NET_F_HOST_UFO);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_UFO);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_UFO);
     }
 
     if (!peer_has_uso(n)) {
-        virtio_clear_feature(&features, VIRTIO_NET_F_HOST_USO);
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_USO4);
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_USO6);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_USO);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_USO4);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_USO6);
     }
 
     if (!get_vhost_net(nc->peer)) {
-        return features;
+        return;
     }
 
     if (!ebpf_rss_is_loaded(&n->ebpf_rss)) {
-        virtio_clear_feature(&features, VIRTIO_NET_F_RSS);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_RSS);
     }
-    features = vhost_net_get_features(get_vhost_net(nc->peer), features);
-    vdev->backend_features = features;
+    vhost_net_get_features_ex(get_vhost_net(nc->peer), features);
+    virtio_features_copy(vdev->backend_features_array, features);
 
     if (n->mtu_bypass_backend &&
             (n->host_features & 1ULL << VIRTIO_NET_F_MTU)) {
-        features |= (1ULL << VIRTIO_NET_F_MTU);
+        virtio_add_feature_ex(features, VIRTIO_NET_F_MTU);
     }
 
     /*
@@ -819,10 +832,8 @@ static uint64_t virtio_net_get_features(VirtIODevice *vdev, uint64_t features,
      * support it.
      */
     if (!virtio_has_feature(vdev->backend_features, VIRTIO_NET_F_CTRL_VQ)) {
-        virtio_clear_feature(&features, VIRTIO_NET_F_GUEST_ANNOUNCE);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_ANNOUNCE);
     }
-
-    return features;
 }
 
 static uint64_t virtio_net_bad_features(VirtIODevice *vdev)
@@ -855,7 +866,14 @@ static void virtio_net_apply_guest_offloads(VirtIONet *n)
     qemu_set_offload(qemu_get_queue(n->nic)->peer, &ol);
 }
 
-static uint64_t virtio_net_guest_offloads_by_features(uint64_t features)
+static uint64_t virtio_net_features_to_offload(const uint64_t *features)
+{
+    return (features[0] & ~VIRTIO_NET_OFFLOAD_MAP) |
+           ((features[1] << VIRTIO_NET_F2O_SHIFT) & VIRTIO_NET_OFFLOAD_MAP);
+}
+
+static uint64_t
+virtio_net_guest_offloads_by_features(const uint64_t *features)
 {
     static const uint64_t guest_offloads_mask =
         (1ULL << VIRTIO_NET_F_GUEST_CSUM) |
@@ -866,13 +884,13 @@ static uint64_t virtio_net_guest_offloads_by_features(uint64_t features)
         (1ULL << VIRTIO_NET_F_GUEST_USO4) |
         (1ULL << VIRTIO_NET_F_GUEST_USO6);
 
-    return guest_offloads_mask & features;
+    return guest_offloads_mask & virtio_net_features_to_offload(features);
 }
 
 uint64_t virtio_net_supported_guest_offloads(const VirtIONet *n)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(n);
-    return virtio_net_guest_offloads_by_features(vdev->guest_features);
+    return virtio_net_guest_offloads_by_features(vdev->guest_features_array);
 }
 
 typedef struct {
@@ -951,34 +969,39 @@ static void failover_add_primary(VirtIONet *n, Error **errp)
     error_propagate(errp, err);
 }
 
-static void virtio_net_set_features(VirtIODevice *vdev, uint64_t features)
+static void virtio_net_set_features(VirtIODevice *vdev,
+                                    const uint64_t *in_features)
 {
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
     VirtIONet *n = VIRTIO_NET(vdev);
     Error *err = NULL;
     int i;
 
+    virtio_features_copy(features, in_features);
     if (n->mtu_bypass_backend &&
             !virtio_has_feature(vdev->backend_features, VIRTIO_NET_F_MTU)) {
-        features &= ~(1ULL << VIRTIO_NET_F_MTU);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_MTU);
     }
 
     virtio_net_set_multiqueue(n,
-                              virtio_has_feature(features, VIRTIO_NET_F_RSS) ||
-                              virtio_has_feature(features, VIRTIO_NET_F_MQ));
+                              virtio_has_feature_ex(features,
+                                                    VIRTIO_NET_F_RSS) ||
+                              virtio_has_feature_ex(features,
+                                                    VIRTIO_NET_F_MQ));
 
     virtio_net_set_mrg_rx_bufs(n,
-                               virtio_has_feature(features,
+                               virtio_has_feature_ex(features,
                                                   VIRTIO_NET_F_MRG_RXBUF),
-                               virtio_has_feature(features,
+                               virtio_has_feature_ex(features,
                                                   VIRTIO_F_VERSION_1),
-                               virtio_has_feature(features,
+                               virtio_has_feature_ex(features,
                                                   VIRTIO_NET_F_HASH_REPORT));
 
-    n->rsc4_enabled = virtio_has_feature(features, VIRTIO_NET_F_RSC_EXT) &&
-        virtio_has_feature(features, VIRTIO_NET_F_GUEST_TSO4);
-    n->rsc6_enabled = virtio_has_feature(features, VIRTIO_NET_F_RSC_EXT) &&
-        virtio_has_feature(features, VIRTIO_NET_F_GUEST_TSO6);
-    n->rss_data.redirect = virtio_has_feature(features, VIRTIO_NET_F_RSS);
+    n->rsc4_enabled = virtio_has_feature_ex(features, VIRTIO_NET_F_RSC_EXT) &&
+        virtio_has_feature_ex(features, VIRTIO_NET_F_GUEST_TSO4);
+    n->rsc6_enabled = virtio_has_feature_ex(features, VIRTIO_NET_F_RSC_EXT) &&
+        virtio_has_feature_ex(features, VIRTIO_NET_F_GUEST_TSO6);
+    n->rss_data.redirect = virtio_has_feature_ex(features, VIRTIO_NET_F_RSS);
 
     if (n->has_vnet_hdr) {
         n->curr_guest_offloads =
@@ -992,7 +1015,7 @@ static void virtio_net_set_features(VirtIODevice *vdev, uint64_t features)
         if (!get_vhost_net(nc->peer)) {
             continue;
         }
-        vhost_net_ack_features(get_vhost_net(nc->peer), features);
+        vhost_net_ack_features_ex(get_vhost_net(nc->peer), features);
 
         /*
          * keep acked_features in NetVhostUserState up-to-date so it
@@ -1001,11 +1024,11 @@ static void virtio_net_set_features(VirtIODevice *vdev, uint64_t features)
         vhost_net_save_acked_features(nc->peer);
     }
 
-    if (!virtio_has_feature(features, VIRTIO_NET_F_CTRL_VLAN)) {
+    if (!virtio_has_feature_ex(features, VIRTIO_NET_F_CTRL_VLAN)) {
         memset(n->vlans, 0xff, MAX_VLAN >> 3);
     }
 
-    if (virtio_has_feature(features, VIRTIO_NET_F_STANDBY)) {
+    if (virtio_has_feature_ex(features, VIRTIO_NET_F_STANDBY)) {
         qapi_event_send_failover_negotiated(n->netclient_name);
         qatomic_set(&n->failover_primary_hidden, false);
         failover_add_primary(n, &err);
@@ -1966,10 +1989,10 @@ static ssize_t virtio_net_receive_rcu(NetClientState *nc, const uint8_t *buf,
                 virtio_error(vdev, "virtio-net unexpected empty queue: "
                              "i %zd mergeable %d offset %zd, size %zd, "
                              "guest hdr len %zd, host hdr len %zd "
-                             "guest features 0x%" PRIx64,
+                             "guest features 0x" VIRTIO_FEATURES_FMT,
                              i, n->mergeable_rx_bufs, offset, size,
                              n->guest_hdr_len, n->host_hdr_len,
-                             vdev->guest_features);
+                             VIRTIO_FEATURES_PR(vdev->guest_features_array));
             }
             err = -1;
             goto err;
@@ -4150,8 +4173,8 @@ static void virtio_net_class_init(ObjectClass *klass, const void *data)
     vdc->unrealize = virtio_net_device_unrealize;
     vdc->get_config = virtio_net_get_config;
     vdc->set_config = virtio_net_set_config;
-    vdc->get_features = virtio_net_get_features;
-    vdc->set_features = virtio_net_set_features;
+    vdc->get_features_ex = virtio_net_get_features;
+    vdc->set_features_ex = virtio_net_set_features;
     vdc->bad_features = virtio_net_bad_features;
     vdc->reset = virtio_net_reset;
     vdc->queue_reset = virtio_net_queue_reset;
diff --git a/include/hw/virtio/virtio-net.h b/include/hw/virtio/virtio-net.h
index b9ea9e824e..5168027267 100644
--- a/include/hw/virtio/virtio-net.h
+++ b/include/hw/virtio/virtio-net.h
@@ -178,7 +178,7 @@ struct VirtIONet {
     uint32_t has_vnet_hdr;
     size_t host_hdr_len;
     size_t guest_hdr_len;
-    uint64_t host_features;
+    VIRTIO_DECLARE_FEATURES(host_features);
     uint32_t rsc_timeout;
     uint8_t rsc4_enabled;
     uint8_t rsc6_enabled;
-- 
2.50.0


