Return-Path: <kvm+bounces-52149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC6EB01CDF
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B8731718A6
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DC42E0939;
	Fri, 11 Jul 2025 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Icgpnvy+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A9A2E0416
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239021; cv=none; b=LFpYiaBhU/k9Zf9Mpe8lI6pU2a4V1xWvKaIIDmy0ODQxk0loNaUwL0GPquOWzlyyjGWA3rLkS11HnyeBCRjx3y1ToqUyBbwERjAuRdJCo5gqz1QAVTtU8gI7+0x1gv/oxJrsyzPEhi+XvOAe8hT24nfceLtCkXyrp2edVliJb4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239021; c=relaxed/simple;
	bh=Sfjh8dIhtkNCDMAbsBpWLH4AvNDJm+B5eNzRWw8qQbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peBaZQXS9dIrniY/7kdvtkd4ZjYnE0Y108XC5ixfhHVL+KBH8szyXx9ySGhqyqCdBK44zbZd4s0qkr69apsrc0Uyit7pYZePMomzCgLxInHGIdPEgrgcHQ8eGS2VPd4Z+EGyAx/ZOvUvh7IRFeJugm9dqSB13KcCgqN3sfsjiYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Icgpnvy+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752239018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WvUW8vTwKrJJdpY7LlUAnJucWFqBaXHVVKU4jDO0KTk=;
	b=Icgpnvy+2TDPPlMshSCtUp00xx+6udpj1dOlFnOJ3guu5i4t0PocyPQfEZWqB1nol/jE8M
	gGU5jBZ1MuM5O7jL6CEdWXTKqARyhu3YyZheKFszYo+hNhDBQi/oJHxbLPF8EKc26sNUbo
	aQ8FlKAvLCnwSWbbgrAmIZCQ1tWrvEw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-7RoPTxGxMLCFHANiUoqflw-1; Fri,
 11 Jul 2025 09:03:35 -0400
X-MC-Unique: 7RoPTxGxMLCFHANiUoqflw-1
X-Mimecast-MFC-AGG-ID: 7RoPTxGxMLCFHANiUoqflw_1752239013
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1ED4195608E;
	Fri, 11 Jul 2025 13:03:33 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9394B19560A3;
	Fri, 11 Jul 2025 13:03:27 +0000 (UTC)
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
Subject: [PATCH RFC v2 08/13] qmp: update virtio features map to support extended features
Date: Fri, 11 Jul 2025 15:02:13 +0200
Message-ID: <5f5a6718fa5ae82d5cd3b73523deea41089ffeb5.1752229731.git.pabeni@redhat.com>
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

Extend the VirtioDeviceFeatures struct with an additional u64
to track unknown features in the 65-128 bit range and decode
the full virtio features spaces for vhost and virtio devices.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
I'm unsure if it's actually legit to update a qapi struct
definition?

v1 -> v2:
  - uint128_t -> uint64_t[]
---
 hw/virtio/virtio-hmp-cmds.c |  3 +-
 hw/virtio/virtio-qmp.c      | 89 ++++++++++++++++++++++++++-----------
 hw/virtio/virtio-qmp.h      |  3 +-
 qapi/virtio.json            |  8 +++-
 4 files changed, 73 insertions(+), 30 deletions(-)

diff --git a/hw/virtio/virtio-hmp-cmds.c b/hw/virtio/virtio-hmp-cmds.c
index 7d8677bcf0..e8c2a76a2a 100644
--- a/hw/virtio/virtio-hmp-cmds.c
+++ b/hw/virtio/virtio-hmp-cmds.c
@@ -74,7 +74,8 @@ static void hmp_virtio_dump_features(Monitor *mon,
     }
 
     if (features->has_unknown_dev_features) {
-        monitor_printf(mon, "  unknown-features(0x%016"PRIx64")\n",
+        monitor_printf(mon, "  unknown-features(0x%016"PRIx64"%016"PRIx64")\n",
+                       features->unknown_dev_features_dword2,
                        features->unknown_dev_features);
     }
 }
diff --git a/hw/virtio/virtio-qmp.c b/hw/virtio/virtio-qmp.c
index 3b6377cf0d..0d06e7a7db 100644
--- a/hw/virtio/virtio-qmp.c
+++ b/hw/virtio/virtio-qmp.c
@@ -325,6 +325,20 @@ static const qmp_virtio_feature_map_t virtio_net_feature_map[] = {
     FEATURE_ENTRY(VHOST_USER_F_PROTOCOL_FEATURES, \
             "VHOST_USER_F_PROTOCOL_FEATURES: Vhost-user protocol features "
             "negotiation supported"),
+    FEATURE_ENTRY(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO, \
+            "VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO: Driver can receive GSO over "
+            "UDP tunnel packets"),
+    FEATURE_ENTRY(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM, \
+            "VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO: Driver can receive GSO over "
+            "UDP tunnel packets requiring checksum offload for the outer "
+            "header"),
+    FEATURE_ENTRY(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO, \
+            "VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO: Device can receive GSO over "
+            "UDP tunnel packets"),
+    FEATURE_ENTRY(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM, \
+            "VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO: Device can receive GSO over "
+            "UDP tunnel packets requiring checksum offload for the outer "
+            "header"),
     { -1, "" }
 };
 #endif
@@ -510,6 +524,24 @@ static const qmp_virtio_feature_map_t virtio_gpio_feature_map[] = {
         list;                                            \
     })
 
+#define CONVERT_FEATURES_EX(type, map, bitmap)           \
+    ({                                                   \
+        type *list = NULL;                               \
+        type *node;                                      \
+        for (i = 0; map[i].virtio_bit != -1; i++) {      \
+            bit = map[i].virtio_bit;                     \
+            if (!virtio_has_feature_ex(bitmap, bit)) {   \
+                continue;                                \
+            }                                            \
+            node = g_new0(type, 1);                      \
+            node->value = g_strdup(map[i].feature_desc); \
+            node->next = list;                           \
+            list = node;                                 \
+            virtio_clear_feature_ex(bitmap, bit);        \
+        }                                                \
+        list;                                            \
+    })
+
 VirtioDeviceStatus *qmp_decode_status(uint8_t bitmap)
 {
     VirtioDeviceStatus *status;
@@ -545,109 +577,112 @@ VhostDeviceProtocols *qmp_decode_protocols(uint64_t bitmap)
     return vhu_protocols;
 }
 
-VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id, uint64_t bitmap)
+VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id,
+                                          const uint64_t *bmap)
 {
+    uint64_t bitmap[VIRTIO_FEATURES_DWORDS];
     VirtioDeviceFeatures *features;
     uint64_t bit;
     int i;
 
+    virtio_features_copy(bitmap, bmap);
     features = g_new0(VirtioDeviceFeatures, 1);
     features->has_dev_features = true;
 
     /* transport features */
-    features->transports = CONVERT_FEATURES(strList, virtio_transport_map, 0,
-                                            bitmap);
+    features->transports = CONVERT_FEATURES_EX(strList, virtio_transport_map,
+                                               bitmap);
 
     /* device features */
     switch (device_id) {
 #ifdef CONFIG_VIRTIO_SERIAL
     case VIRTIO_ID_CONSOLE:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_serial_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_serial_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_BLK
     case VIRTIO_ID_BLOCK:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_blk_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_blk_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_GPU
     case VIRTIO_ID_GPU:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_gpu_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_gpu_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_NET
     case VIRTIO_ID_NET:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_net_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_net_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_SCSI
     case VIRTIO_ID_SCSI:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_scsi_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_scsi_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_BALLOON
     case VIRTIO_ID_BALLOON:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_balloon_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_balloon_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_IOMMU
     case VIRTIO_ID_IOMMU:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_iommu_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_iommu_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_INPUT
     case VIRTIO_ID_INPUT:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_input_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_input_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VHOST_USER_FS
     case VIRTIO_ID_FS:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_fs_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_fs_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VHOST_VSOCK
     case VIRTIO_ID_VSOCK:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_vsock_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_vsock_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_CRYPTO
     case VIRTIO_ID_CRYPTO:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_crypto_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_crypto_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_MEM
     case VIRTIO_ID_MEM:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_mem_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_mem_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_I2C_ADAPTER
     case VIRTIO_ID_I2C_ADAPTER:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_i2c_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_i2c_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VIRTIO_RNG
     case VIRTIO_ID_RNG:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_rng_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_rng_feature_map, bitmap);
         break;
 #endif
 #ifdef CONFIG_VHOST_USER_GPIO
     case VIRTIO_ID_GPIO:
         features->dev_features =
-            CONVERT_FEATURES(strList, virtio_gpio_feature_map, 0, bitmap);
+            CONVERT_FEATURES_EX(strList, virtio_gpio_feature_map, bitmap);
         break;
 #endif
     /* No features */
@@ -680,9 +715,10 @@ VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id, uint64_t bitmap)
         g_assert_not_reached();
     }
 
-    features->has_unknown_dev_features = bitmap != 0;
+    features->has_unknown_dev_features = virtio_features_is_empty(bitmap);
     if (features->has_unknown_dev_features) {
-        features->unknown_dev_features = bitmap;
+        features->unknown_dev_features = bitmap[0];
+        features->unknown_dev_features_dword2 = bitmap[1];
     }
 
     return features;
@@ -743,11 +779,11 @@ VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
     status->device_id = vdev->device_id;
     status->vhost_started = vdev->vhost_started;
     status->guest_features = qmp_decode_features(vdev->device_id,
-                                                 vdev->guest_features);
+                                                 vdev->guest_features_array);
     status->host_features = qmp_decode_features(vdev->device_id,
-                                                vdev->host_features);
+                                                vdev->host_features_array);
     status->backend_features = qmp_decode_features(vdev->device_id,
-                                                   vdev->backend_features);
+                                                 vdev->backend_features_array);
 
     switch (vdev->device_endian) {
     case VIRTIO_DEVICE_ENDIAN_LITTLE:
@@ -785,11 +821,12 @@ VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
         status->vhost_dev->nvqs = hdev->nvqs;
         status->vhost_dev->vq_index = hdev->vq_index;
         status->vhost_dev->features =
-            qmp_decode_features(vdev->device_id, hdev->features);
+            qmp_decode_features(vdev->device_id, hdev->features_array);
         status->vhost_dev->acked_features =
-            qmp_decode_features(vdev->device_id, hdev->acked_features);
+            qmp_decode_features(vdev->device_id, hdev->acked_features_array);
         status->vhost_dev->backend_features =
-            qmp_decode_features(vdev->device_id, hdev->backend_features);
+            qmp_decode_features(vdev->device_id, hdev->backend_features_array);
+
         status->vhost_dev->protocol_features =
             qmp_decode_protocols(hdev->protocol_features);
         status->vhost_dev->max_queues = hdev->max_queues;
diff --git a/hw/virtio/virtio-qmp.h b/hw/virtio/virtio-qmp.h
index 245a446a56..e0a1e49035 100644
--- a/hw/virtio/virtio-qmp.h
+++ b/hw/virtio/virtio-qmp.h
@@ -18,6 +18,7 @@
 VirtIODevice *qmp_find_virtio_device(const char *path);
 VirtioDeviceStatus *qmp_decode_status(uint8_t bitmap);
 VhostDeviceProtocols *qmp_decode_protocols(uint64_t bitmap);
-VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id, uint64_t bitmap);
+VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id,
+                                          const uint64_t *bitmap);
 
 #endif
diff --git a/qapi/virtio.json b/qapi/virtio.json
index 73df718a26..f0442e144b 100644
--- a/qapi/virtio.json
+++ b/qapi/virtio.json
@@ -488,14 +488,18 @@
 #     unique features)
 #
 # @unknown-dev-features: Virtio device features bitmap that have not
-#     been decoded
+#     been decoded (lower 64 bit)
+#
+# @unknown-dev-features-dword2: Virtio device features bitmap that have not
+#     been decoded (bits 65-128)
 #
 # Since: 7.2
 ##
 { 'struct': 'VirtioDeviceFeatures',
   'data': { 'transports': [ 'str' ],
             '*dev-features': [ 'str' ],
-            '*unknown-dev-features': 'uint64' } }
+            '*unknown-dev-features': 'uint64',
+            '*unknown-dev-features-dword2': 'uint64' } }
 
 ##
 # @VirtQueueStatus:
-- 
2.50.0


