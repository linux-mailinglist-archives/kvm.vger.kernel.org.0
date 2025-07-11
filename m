Return-Path: <kvm+bounces-52148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4316FB01CDD
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D276EB449E9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634192E0403;
	Fri, 11 Jul 2025 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M10ozgKI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27E420B7FA
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239014; cv=none; b=dfCF3fM1EZBJWOtQvzmbUcIoe3jRABD+0EsgfZQOCLUjJebeGokoF69WV/j9RmEDtnPDbvxE87Gvgs6n/PLDCuyX6UB+4rIacASnekGX2LN+IAdRQH1MqSxEje+YnskXcaqJT9ggKryCiVOeALcW4cAZauLgMg6vNKT669Y05Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239014; c=relaxed/simple;
	bh=4SW2v1YdmjpbmaTXSnPCwA3Q+Zpv9THTysMLuD5/Sz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BanPYVeJ5vlFUcd8ZJosffBl/22pnybs3Me5BpGD4UjWs2XBCAbDdXSmVczuCqxlr63IF/3qhZmQ7b1QeLMI3L7lkOGLCpKWkMvkkmQyaMO1U80lhuMgBWTFmqLFQzbov48QKGMDWACU9MPXQrefaUj6jrmNYR/i0wXaOQ/lHlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M10ozgKI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752239012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A74KSagiDmeLeERxZbzbE0QC1iLL9VXm1a3so1YsgsU=;
	b=M10ozgKI3Z8GSnbipPXoX38YoCrro/3xSpa3FCRUUgsO5u4sDwlmuOHhHTaN3GyAne1yeY
	LiDgodMcS4vKaMTVm/GJ2sUVvQb8+i2PoIUiNXNKJ//wElQ7x0da9P1eBv97tJ+Gwoy5R1
	/8G8nTbQk7yCEJbdo6i6pLVnpXs/lPQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-K_eDt5L6Nh6W33tAcX_cyQ-1; Fri,
 11 Jul 2025 09:03:27 -0400
X-MC-Unique: K_eDt5L6Nh6W33tAcX_cyQ-1
X-Mimecast-MFC-AGG-ID: K_eDt5L6Nh6W33tAcX_cyQ_1752239006
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 099ED19560B3;
	Fri, 11 Jul 2025 13:03:26 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC47C19560A3;
	Fri, 11 Jul 2025 13:03:20 +0000 (UTC)
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
Subject: [PATCH RFC v2 07/13] vhost: add support for negotiating extended features
Date: Fri, 11 Jul 2025 15:02:12 +0200
Message-ID: <d59d97e07e2941f235dfa7d382161659bb845b79.1752229731.git.pabeni@redhat.com>
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

Similar to virtio infra, vhost core maintain the features status
in the full extended format and allow the devices to implement
extended version of the getter/setter.

Note that 'protocol_features' are not extended: they are only
used by vhost-user, and the latter device is not going to implement
extended features soon.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - uint128_t -> uint64_t[]
  - add _ex() variant of features manipulation helpers
---
 hw/virtio/vhost.c                 | 73 +++++++++++++++++++++++++++----
 include/hw/virtio/vhost-backend.h |  6 +++
 include/hw/virtio/vhost.h         | 36 +++++++++++++--
 3 files changed, 102 insertions(+), 13 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index fc43853704..2eee9b0886 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -985,20 +985,34 @@ static int vhost_virtqueue_set_addr(struct vhost_dev *dev,
 static int vhost_dev_set_features(struct vhost_dev *dev,
                                   bool enable_log)
 {
-    uint64_t features = dev->acked_features;
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
     int r;
+
+    virtio_features_copy(features, dev->acked_features_array);
     if (enable_log) {
-        features |= 0x1ULL << VHOST_F_LOG_ALL;
+        virtio_add_feature_ex(features, VHOST_F_LOG_ALL);
     }
     if (!vhost_dev_has_iommu(dev)) {
-        features &= ~(0x1ULL << VIRTIO_F_IOMMU_PLATFORM);
+        virtio_clear_feature_ex(features, VIRTIO_F_IOMMU_PLATFORM);
     }
     if (dev->vhost_ops->vhost_force_iommu) {
         if (dev->vhost_ops->vhost_force_iommu(dev) == true) {
-            features |= 0x1ULL << VIRTIO_F_IOMMU_PLATFORM;
+            virtio_add_feature_ex(features, VIRTIO_F_IOMMU_PLATFORM);
        }
     }
-    r = dev->vhost_ops->vhost_set_features(dev, features);
+
+    if (virtio_features_use_extended(features) &&
+        !dev->vhost_ops->vhost_set_features_ex) {
+        VHOST_OPS_DEBUG(r, "extended features without device support");
+        r = -EINVAL;
+        goto out;
+    }
+
+    if (dev->vhost_ops->vhost_set_features_ex) {
+        r = dev->vhost_ops->vhost_set_features_ex(dev, features);
+    } else {
+        r = dev->vhost_ops->vhost_set_features(dev, features[0]);
+    }
     if (r < 0) {
         VHOST_OPS_DEBUG(r, "vhost_set_features failed");
         goto out;
@@ -1506,12 +1520,27 @@ static void vhost_virtqueue_cleanup(struct vhost_virtqueue *vq)
     }
 }
 
+static int vhost_dev_get_features(struct vhost_dev *hdev,
+                                  uint64_t *features)
+{
+    uint64_t features64;
+    int r;
+
+    if (hdev->vhost_ops->vhost_get_features_ex) {
+        return hdev->vhost_ops->vhost_get_features_ex(hdev, features);
+    }
+
+    r = hdev->vhost_ops->vhost_get_features(hdev, &features64);
+    virtio_features_from_u64(features, features64);
+    return r;
+}
+
 int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type, uint32_t busyloop_timeout,
                    Error **errp)
 {
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
     unsigned int used, reserved, limit;
-    uint64_t features;
     int i, r, n_initialized_vqs = 0;
 
     hdev->vdev = NULL;
@@ -1531,7 +1560,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
         goto fail;
     }
 
-    r = hdev->vhost_ops->vhost_get_features(hdev, &features);
+    r = vhost_dev_get_features(hdev, features);
     if (r < 0) {
         error_setg_errno(errp, -r, "vhost_get_features failed");
         goto fail;
@@ -1569,7 +1598,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
         }
     }
 
-    hdev->features = features;
+    virtio_features_copy(hdev->features_array, features);
 
     hdev->memory_listener = (MemoryListener) {
         .name = "vhost",
@@ -1592,7 +1621,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     };
 
     if (hdev->migration_blocker == NULL) {
-        if (!(hdev->features & (0x1ULL << VHOST_F_LOG_ALL))) {
+        if (!virtio_has_feature_ex(hdev->features_array, VHOST_F_LOG_ALL)) {
             error_setg(&hdev->migration_blocker,
                        "Migration disabled: vhost lacks VHOST_F_LOG_ALL feature.");
         } else if (vhost_dev_log_is_shared(hdev) && !qemu_memfd_alloc_check()) {
@@ -1875,6 +1904,20 @@ uint64_t vhost_get_features(struct vhost_dev *hdev, const int *feature_bits,
     return features;
 }
 
+void vhost_get_features_ex(struct vhost_dev *hdev,
+                           const int *feature_bits,
+                           uint64_t *features)
+{
+    const int *bit = feature_bits;
+
+    while (*bit != VHOST_INVALID_FEATURE_BIT) {
+        if (!virtio_has_feature_ex(hdev->features_array, *bit)) {
+            virtio_clear_feature_ex(features, *bit);
+        }
+        bit++;
+    }
+}
+
 void vhost_ack_features(struct vhost_dev *hdev, const int *feature_bits,
                         uint64_t features)
 {
@@ -1888,6 +1931,18 @@ void vhost_ack_features(struct vhost_dev *hdev, const int *feature_bits,
     }
 }
 
+void vhost_ack_features_ex(struct vhost_dev *hdev, const int *feature_bits,
+                           const uint64_t *features)
+{
+    const int *bit = feature_bits;
+    while (*bit != VHOST_INVALID_FEATURE_BIT) {
+        if (virtio_has_feature_ex(features, *bit)) {
+            virtio_add_feature_ex(hdev->acked_features_array, *bit);
+        }
+        bit++;
+    }
+}
+
 int vhost_dev_get_config(struct vhost_dev *hdev, uint8_t *config,
                          uint32_t config_len, Error **errp)
 {
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index d6df209a2f..ff94fa1734 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -95,6 +95,10 @@ typedef int (*vhost_new_worker_op)(struct vhost_dev *dev,
                                    struct vhost_worker_state *worker);
 typedef int (*vhost_free_worker_op)(struct vhost_dev *dev,
                                     struct vhost_worker_state *worker);
+typedef int (*vhost_set_features_ex_op)(struct vhost_dev *dev,
+                                        const uint64_t *features);
+typedef int (*vhost_get_features_ex_op)(struct vhost_dev *dev,
+                                        uint64_t *features);
 typedef int (*vhost_set_features_op)(struct vhost_dev *dev,
                                      uint64_t features);
 typedef int (*vhost_get_features_op)(struct vhost_dev *dev,
@@ -186,6 +190,8 @@ typedef struct VhostOps {
     vhost_free_worker_op vhost_free_worker;
     vhost_get_vring_worker_op vhost_get_vring_worker;
     vhost_attach_vring_worker_op vhost_attach_vring_worker;
+    vhost_set_features_ex_op vhost_set_features_ex;
+    vhost_get_features_ex_op vhost_get_features_ex;
     vhost_set_features_op vhost_set_features;
     vhost_get_features_op vhost_get_features;
     vhost_set_backend_cap_op vhost_set_backend_cap;
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 38800a7156..2eec457559 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -106,9 +106,9 @@ struct vhost_dev {
      * future use should be discouraged and the variable retired as
      * its easy to confuse with the VirtIO backend_features.
      */
-    uint64_t features;
-    uint64_t acked_features;
-    uint64_t backend_features;
+    VIRTIO_DECLARE_FEATURES(features);
+    VIRTIO_DECLARE_FEATURES(acked_features);
+    VIRTIO_DECLARE_FEATURES(backend_features);
 
     /**
      * @protocol_features: is the vhost-user only feature set by
@@ -310,9 +310,25 @@ void vhost_virtqueue_mask(struct vhost_dev *hdev, VirtIODevice *vdev, int n,
  * is supported by the vhost backend (hdev->features), the supported
  * feature_bits and the requested feature set.
  */
-uint64_t vhost_get_features(struct vhost_dev *hdev, const int *feature_bits,
+uint64_t vhost_get_features(struct vhost_dev *hdev,
+                            const int *feature_bits,
                             uint64_t features);
 
+/**
+ * vhost_get_features_ex() - sanitize the extended features set
+ * @hdev: common vhost_dev structure
+ * @feature_bits: pointer to terminated table of feature bits
+ * @features: original features set, filtered out on return
+ *
+ * This is the extended variant of vhost_get_features(), supporting the
+ * the extended features set. Filter it with the intersection of what is
+ * supported by the vhost backend (hdev->features) and the supported
+ * feature_bits.
+ */
+void vhost_get_features_ex(struct vhost_dev *hdev,
+                           const int *feature_bits,
+                           uint64_t *features);
+
 /**
  * vhost_ack_features() - set vhost acked_features
  * @hdev: common vhost_dev structure
@@ -324,6 +340,18 @@ uint64_t vhost_get_features(struct vhost_dev *hdev, const int *feature_bits,
  */
 void vhost_ack_features(struct vhost_dev *hdev, const int *feature_bits,
                         uint64_t features);
+
+/**
+ * vhost_ack_features_ex() - set vhost full set of acked_features
+ * @hdev: common vhost_dev structure
+ * @feature_bits: pointer to terminated table of feature bits
+ * @features: requested feature set
+ *
+ * This sets the internal hdev->acked_features to the intersection of
+ * the backends advertised features and the supported feature_bits.
+ */
+void vhost_ack_features_ex(struct vhost_dev *hdev, const int *feature_bits,
+                           const uint64_t *features);
 unsigned int vhost_get_max_memslots(void);
 unsigned int vhost_get_free_memslots(void);
 
-- 
2.50.0


