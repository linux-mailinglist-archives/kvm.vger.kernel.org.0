Return-Path: <kvm+bounces-52151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B059B01CF6
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5815CB44D95
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE0C2E5411;
	Fri, 11 Jul 2025 13:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUnxpXTj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3902BEFFF
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239036; cv=none; b=iGMyWV2t8dR1fH3j8BsA3G7SNUErOdL47ZeGiS5r3JjAtxV4p+CaMXDLi3hQ1i44/SbW9Ci+0fgntR8oZyZvU0m1JrEJPouhSZqdeYZdPczVBwjZllR379PApGNZUerVMrBA/L/Gbfd8/+e3M98xPQZvZs391VdPZRo5O+9QH8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239036; c=relaxed/simple;
	bh=3XR1so+NNpWyLP+JcYoj3wWNf0102gV7hz4EmUkHOag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjce0NzfXHp+PBBgvBrRwzfZapJf8bhc3BaQwALOnxHf9ChWaOBKenMn1nFmEffet4PHLEh6Iez8Jx8PNjAhQqqkfFdR4wGPPfyUgN9wlA1ZLSimcSyC1bmu5HmClgsbfg7e29kH2lafuNnxvWqMO4RuMRbzjmoiDyAGMvrZhx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aUnxpXTj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752239033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SL+GETdKban5g91ExaSvmecQrNfHVSXJ9ooj81M5Q9A=;
	b=aUnxpXTjUKt1Api3XetFW1r3I2pBfcXHX2DFM/Rb6fbBKGv1F9IMipNec6CRc2HyPhwaoL
	7J42n4XSQ8QUM3H9ojHvLpKULYhbhKZb3Kl7Y7FJsCwrEjG2ZW035AFrsKcU9OpLRYMiTW
	1X3cn/FB6XMmXX1IkFxa5BTvx//MUBk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-stT_G9KlOmu-eoVRCM3kpg-1; Fri,
 11 Jul 2025 09:03:46 -0400
X-MC-Unique: stT_G9KlOmu-eoVRCM3kpg-1
X-Mimecast-MFC-AGG-ID: stT_G9KlOmu-eoVRCM3kpg_1752239023
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35ECD180029F;
	Fri, 11 Jul 2025 13:03:43 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C0A819560A3;
	Fri, 11 Jul 2025 13:03:33 +0000 (UTC)
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
Subject: [PATCH RFC v2 09/13] vhost-backend: implement extended features support
Date: Fri, 11 Jul 2025 15:02:14 +0200
Message-ID: <3570448af479dad6056bfc95f37d7c0614ed87e8.1752229731.git.pabeni@redhat.com>
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

Leverage the kernel extended features manipulation ioctls(), if
available, and fallback to old ops otherwise. Error out when setting
extended features but kernel support is not available.

Note that extended support for get/set backend features is not needed,
as the only feature that can be changed belongs to the 64 bit range.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - synced with kernel ioctl changes
---
 hw/virtio/vhost-backend.c | 62 ++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 11 deletions(-)

diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
index 833804dd40..6fde994403 100644
--- a/hw/virtio/vhost-backend.c
+++ b/hw/virtio/vhost-backend.c
@@ -20,6 +20,11 @@
 #include <linux/vhost.h>
 #include <sys/ioctl.h>
 
+struct vhost_features {
+    uint64_t count;
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
+};
+
 static int vhost_kernel_call(struct vhost_dev *dev, unsigned long int request,
                              void *arg)
 {
@@ -182,12 +187,6 @@ static int vhost_kernel_get_vring_worker(struct vhost_dev *dev,
     return vhost_kernel_call(dev, VHOST_GET_VRING_WORKER, worker);
 }
 
-static int vhost_kernel_set_features(struct vhost_dev *dev,
-                                     uint64_t features)
-{
-    return vhost_kernel_call(dev, VHOST_SET_FEATURES, &features);
-}
-
 static int vhost_kernel_set_backend_cap(struct vhost_dev *dev)
 {
     uint64_t features;
@@ -210,10 +209,51 @@ static int vhost_kernel_set_backend_cap(struct vhost_dev *dev)
     return 0;
 }
 
-static int vhost_kernel_get_features(struct vhost_dev *dev,
-                                     uint64_t *features)
+static int vhost_kernel_set_features(struct vhost_dev *dev,
+                                     const uint64_t *features)
 {
-    return vhost_kernel_call(dev, VHOST_GET_FEATURES, features);
+    struct vhost_features farray;
+    bool extended_in_use;
+    int r;
+
+    farray.count = VIRTIO_FEATURES_DWORDS;
+    virtio_features_copy(farray.features, features);
+    extended_in_use = virtio_features_use_extended(farray.features);
+
+    /*
+     * Can't check for ENOTTY: for unknown ioctls the kernel interprets
+     * the argument as a virtio queue id and most likely errors out validating
+     * such id, instead of reporting an unknown operation.
+     */
+    r = vhost_kernel_call(dev, VHOST_SET_FEATURES_ARRAY, &farray);
+    if (!r) {
+        return 0;
+    }
+
+    if (extended_in_use) {
+        error_report("Trying to set extended features without kernel support");
+        return -EINVAL;
+    }
+    return vhost_kernel_call(dev, VHOST_SET_FEATURES, &farray.features[0]);
+}
+
+static int vhost_kernel_get_features(struct vhost_dev *dev, uint64_t *features)
+{
+    struct vhost_features farray;
+    int r;
+
+    farray.count = VIRTIO_FEATURES_DWORDS;
+    r = vhost_kernel_call(dev, VHOST_GET_FEATURES_ARRAY, &farray);
+    if (r) {
+        memset(&farray, 0, sizeof(farray));
+        r = vhost_kernel_call(dev, VHOST_GET_FEATURES, &farray.features[0]);
+    }
+    if (r) {
+        return r;
+    }
+
+    virtio_features_copy(features, farray.features);
+    return 0;
 }
 
 static int vhost_kernel_set_owner(struct vhost_dev *dev)
@@ -341,8 +381,8 @@ const VhostOps kernel_ops = {
         .vhost_attach_vring_worker = vhost_kernel_attach_vring_worker,
         .vhost_new_worker = vhost_kernel_new_worker,
         .vhost_free_worker = vhost_kernel_free_worker,
-        .vhost_set_features = vhost_kernel_set_features,
-        .vhost_get_features = vhost_kernel_get_features,
+        .vhost_set_features_ex = vhost_kernel_set_features,
+        .vhost_get_features_ex = vhost_kernel_get_features,
         .vhost_set_backend_cap = vhost_kernel_set_backend_cap,
         .vhost_set_owner = vhost_kernel_set_owner,
         .vhost_get_vq_index = vhost_kernel_get_vq_index,
-- 
2.50.0


