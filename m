Return-Path: <kvm+bounces-52152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A47E0B01CDA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54B153AA362
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC1A2E498C;
	Fri, 11 Jul 2025 13:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckLdCeom"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509FC2E3AF9
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239038; cv=none; b=U/kMJMenLka3qlsn1Z/qr2EKnYGZ4C01/musL//zzCuVbq5Fy0+XouiNXh7WdmHyYpy1k+Lg/D9ByL/Gi9L3Brf0KULWWHRe4kcIcz9wQU12XYKbAXOGizb65pEb06aqTPNOsgabcUR9bJJTYaxjdfDJ6Y8h/IYYyCaMgslMnp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239038; c=relaxed/simple;
	bh=v3z7SOdHSoYYU0hIsawK/CFL7ED7XD4Cb4M1FfsnIP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atWWTA2yS2aHqP8mzesgb3fxSvMA2Q2ZeUhq3L3QcU6jHIUSORcszhON0LuzHwOHUZjdeK9GvEeeWGaTIejE2cGk0dOtN+0NHhvH2NB1eNinIUSOS4kjL37EhhuJ81TbfNVMp4hnpl5sVwOTpIQ4MiYpuNs8nPyFK7ohme7OMGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ckLdCeom; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752239035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=32lZPJFOdTlazqMfP+4COXRGoU2Ht4q+BadMeycbCg0=;
	b=ckLdCeomKUGSfAYw+wpbYy/0rf2lKlaTvDvZJpoFN0btOu5F6o+tAU172EN7HXytmiOfLL
	MM1tpaxt+7UhJ+bZJJIcrpeXjb5FJc+6HorwgUTiEMFOwovzqwfMVsQAYT0mtKH0C7IXP0
	mPYEywLfAL1jzTO5PAijljkeFVr53xQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-eqARMib3Na28K_UUr0ZYHQ-1; Fri,
 11 Jul 2025 09:03:51 -0400
X-MC-Unique: eqARMib3Na28K_UUr0ZYHQ-1
X-Mimecast-MFC-AGG-ID: eqARMib3Na28K_UUr0ZYHQ_1752239029
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88FBC1808984;
	Fri, 11 Jul 2025 13:03:49 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BFD7D19560B6;
	Fri, 11 Jul 2025 13:03:43 +0000 (UTC)
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
Subject: [PATCH RFC v2 10/13] vhost-net: implement extended features support
Date: Fri, 11 Jul 2025 15:02:15 +0200
Message-ID: <ad97c548f4c5c169ac322d0beb23976f8353be28.1752229731.git.pabeni@redhat.com>
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

Provide extended version of the features manipulation helpers,
and let the device initialization deal with the full features space,
adjusting the relevant format strings accordingly.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - uint128_t -> uint64_t[]
  - provide extended variant of the features manipulation helpers
---
 hw/net/vhost_net-stub.c |  8 +++----
 hw/net/vhost_net.c      | 48 +++++++++++++++++++++++------------------
 include/net/vhost_net.h | 33 +++++++++++++++++++++++++---
 3 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/hw/net/vhost_net-stub.c b/hw/net/vhost_net-stub.c
index 72df6d757e..f20b8a216d 100644
--- a/hw/net/vhost_net-stub.c
+++ b/hw/net/vhost_net-stub.c
@@ -47,9 +47,8 @@ void vhost_net_cleanup(struct vhost_net *net)
 {
 }
 
-uint64_t vhost_net_get_features(struct vhost_net *net, uint64_t features)
+void vhost_net_get_features_ex(struct vhost_net *net, uint64_t *features)
 {
-    return features;
 }
 
 int vhost_net_get_config(struct vhost_net *net,  uint8_t *config,
@@ -63,13 +62,12 @@ int vhost_net_set_config(struct vhost_net *net, const uint8_t *data,
     return 0;
 }
 
-void vhost_net_ack_features(struct vhost_net *net, uint64_t features)
+void vhost_net_ack_features_ex(struct vhost_net *net, const uint64_t *features)
 {
 }
 
-uint64_t vhost_net_get_acked_features(VHostNetState *net)
+void vhost_net_get_acked_features_ex(VHostNetState *net, uint64_t *features)
 {
-    return 0;
 }
 
 bool vhost_net_virtqueue_pending(VHostNetState *net, int idx)
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index 891f235a0a..bae595607a 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -121,10 +121,9 @@ static const int *vhost_net_get_feature_bits(struct vhost_net *net)
     return feature_bits;
 }
 
-uint64_t vhost_net_get_features(struct vhost_net *net, uint64_t features)
+void vhost_net_get_features_ex(struct vhost_net *net, uint64_t *features)
 {
-    return vhost_get_features(&net->dev, vhost_net_get_feature_bits(net),
-            features);
+    vhost_get_features_ex(&net->dev, vhost_net_get_feature_bits(net), features);
 }
 int vhost_net_get_config(struct vhost_net *net,  uint8_t *config,
                          uint32_t config_len)
@@ -137,10 +136,11 @@ int vhost_net_set_config(struct vhost_net *net, const uint8_t *data,
     return vhost_dev_set_config(&net->dev, data, offset, size, flags);
 }
 
-void vhost_net_ack_features(struct vhost_net *net, uint64_t features)
+void vhost_net_ack_features_ex(struct vhost_net *net, const uint64_t *features)
 {
-    net->dev.acked_features = net->dev.backend_features;
-    vhost_ack_features(&net->dev, vhost_net_get_feature_bits(net), features);
+    virtio_features_copy(net->dev.acked_features_array,
+                         net->dev.backend_features_array);
+    vhost_ack_features_ex(&net->dev, vhost_net_get_feature_bits(net), features);
 }
 
 uint64_t vhost_net_get_max_queues(VHostNetState *net)
@@ -148,9 +148,9 @@ uint64_t vhost_net_get_max_queues(VHostNetState *net)
     return net->dev.max_queues;
 }
 
-uint64_t vhost_net_get_acked_features(VHostNetState *net)
+void vhost_net_get_acked_features_ex(VHostNetState *net, uint64_t *features)
 {
-    return net->dev.acked_features;
+    virtio_features_copy(features, net->dev.acked_features_array);
 }
 
 void vhost_net_save_acked_features(NetClientState *nc)
@@ -320,7 +320,8 @@ struct vhost_net *vhost_net_init(VhostNetOptions *options)
     int r;
     bool backend_kernel = options->backend_type == VHOST_BACKEND_TYPE_KERNEL;
     struct vhost_net *net = g_new0(struct vhost_net, 1);
-    uint64_t features = 0;
+    uint64_t missing_features[VIRTIO_FEATURES_DWORDS];
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
     Error *local_err = NULL;
 
     if (!options->net_backend) {
@@ -343,7 +344,7 @@ struct vhost_net *vhost_net_init(VhostNetOptions *options)
         net->backend = r;
         net->dev.protocol_features = 0;
     } else {
-        net->dev.backend_features = 0;
+        virtio_features_clear(net->dev.backend_features_array);
         net->dev.protocol_features = 0;
         net->backend = -1;
 
@@ -361,12 +362,15 @@ struct vhost_net *vhost_net_init(VhostNetOptions *options)
     if (backend_kernel) {
         if (!qemu_has_vnet_hdr_len(options->net_backend,
                                sizeof(struct virtio_net_hdr_mrg_rxbuf))) {
-            net->dev.features &= ~(1ULL << VIRTIO_NET_F_MRG_RXBUF);
+            net->dev.features &= ~VIRTIO_BIT(VIRTIO_NET_F_MRG_RXBUF);
         }
-        if (~net->dev.features & net->dev.backend_features) {
-            fprintf(stderr, "vhost lacks feature mask 0x%" PRIx64
-                   " for backend\n",
-                   (uint64_t)(~net->dev.features & net->dev.backend_features));
+
+        virtio_features_andnot(missing_features,
+                               net->dev.backend_features_array,
+                               net->dev.features_array);
+        if (!virtio_features_is_empty(missing_features)) {
+            fprintf(stderr, "vhost lacks feature mask 0x" VIRTIO_FEATURES_FMT
+                   " for backend\n", VIRTIO_FEATURES_PR(missing_features));
             goto fail;
         }
     }
@@ -374,17 +378,19 @@ struct vhost_net *vhost_net_init(VhostNetOptions *options)
     /* Set sane init value. Override when guest acks. */
 #ifdef CONFIG_VHOST_NET_USER
     if (net->nc->info->type == NET_CLIENT_DRIVER_VHOST_USER) {
-        features = vhost_user_get_acked_features(net->nc);
-        if (~net->dev.features & features) {
-            fprintf(stderr, "vhost lacks feature mask 0x%" PRIx64
-                    " for backend\n",
-                    (uint64_t)(~net->dev.features & features));
+        virtio_features_from_u64(features,
+                                 vhost_user_get_acked_features(net->nc));
+        virtio_features_andnot(missing_features, features,
+                               net->dev.features_array);
+        if (!virtio_features_is_empty(missing_features)) {
+            fprintf(stderr, "vhost lacks feature mask 0x" VIRTIO_FEATURES_FMT
+                    " for backend\n", VIRTIO_FEATURES_PR(missing_features));
             goto fail;
         }
     }
 #endif
 
-    vhost_net_ack_features(net, features);
+    vhost_net_ack_features_ex(net, features);
 
     return net;
 
diff --git a/include/net/vhost_net.h b/include/net/vhost_net.h
index c6a5361a2a..f30a206e73 100644
--- a/include/net/vhost_net.h
+++ b/include/net/vhost_net.h
@@ -2,6 +2,7 @@
 #define VHOST_NET_H
 
 #include "net/net.h"
+#include "hw/virtio/virtio-features.h"
 #include "hw/virtio/vhost-backend.h"
 
 struct vhost_net;
@@ -25,8 +26,26 @@ void vhost_net_stop(VirtIODevice *dev, NetClientState *ncs,
 
 void vhost_net_cleanup(VHostNetState *net);
 
-uint64_t vhost_net_get_features(VHostNetState *net, uint64_t features);
-void vhost_net_ack_features(VHostNetState *net, uint64_t features);
+void vhost_net_get_features_ex(VHostNetState *net, uint64_t *features);
+static inline uint64_t vhost_net_get_features(VHostNetState *net,
+                                              uint64_t features)
+{
+    uint64_t features_array[VIRTIO_FEATURES_DWORDS];
+
+    virtio_features_from_u64(features_array, features);
+    vhost_net_get_features_ex(net, features_array);
+    return features_array[0];
+}
+
+void vhost_net_ack_features_ex(VHostNetState *net, const uint64_t *features);
+static inline void vhost_net_ack_features(VHostNetState *net,
+                                          uint64_t features)
+{
+    uint64_t features_array[VIRTIO_FEATURES_DWORDS];
+
+    virtio_features_from_u64(features_array, features);
+    vhost_net_ack_features_ex(net, features_array);
+}
 
 int vhost_net_get_config(struct vhost_net *net,  uint8_t *config,
                          uint32_t config_len);
@@ -43,7 +62,15 @@ VHostNetState *get_vhost_net(NetClientState *nc);
 
 int vhost_set_vring_enable(NetClientState * nc, int enable);
 
-uint64_t vhost_net_get_acked_features(VHostNetState *net);
+void vhost_net_get_acked_features_ex(VHostNetState *net, uint64_t *features);
+static inline uint64_t vhost_net_get_acked_features(VHostNetState *net)
+{
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
+
+    vhost_net_get_acked_features_ex(net, features);
+    assert(!virtio_features_use_extended(features));
+    return features[0];
+}
 
 int vhost_net_set_mtu(struct vhost_net *net, uint16_t mtu);
 
-- 
2.50.0


