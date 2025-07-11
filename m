Return-Path: <kvm+bounces-52146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C39B01CD4
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30D571CA799B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D6A2DE71C;
	Fri, 11 Jul 2025 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cAqxGhNc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0B620B7FA
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239003; cv=none; b=ahSp9BT12j3vChNH+468W1XY5QBU7BgzWeDp7U/S1Vb0L5yYbrkuPFeSbCV9X6UgoP4Savn84+T18azeTnJdS0RmdTv3bj/xbLJClwhyVGVMULvZCF8C6i8QeSpRSlPlEoI2vMyW5r5853F3c2qpTgiA44EBrcK3cQcHARRYDF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239003; c=relaxed/simple;
	bh=Qk41Auv4wl7Q/K6fmpxxtyvfKO9rUUoJ38h4Qs12iKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRCO8/1T609EaY8lLP89FvkaCddojG9tjsOKyP1SL5qMpTWJYnsJfxIaMUkkKJ4LeSMadeY35HuWr1gmoTgsg8LKXnnDAnxKzHhSIzs5BHZtOTkSYSPhA2C8iuRBUFgE8q1hqHgGCjfTsNGmfJtm6qkpZYAuWvmV/HtyaPTuOt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cAqxGhNc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752238998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ou9+RkIukUjVmAsDD893wlvynk8pE6hE0EnR3MqKFWg=;
	b=cAqxGhNcoSFyeBnZx/hS4v+yRvkgcX1BJgSt5vfeLc8sB6fC9YtRWmG1/Czdx72/7I3nOl
	PgC7bbMTuNd6S7W8MZlP/v6ZbeUHHaAXYgoVMQ8gFB06ZAVgiqKUNBroBGYInQ7DZ/D1Pp
	Z82of5hYCeue9OgiafpzMUQsuXuzbSo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-dUadzoCAN9WYfDF2dEjOKw-1; Fri,
 11 Jul 2025 09:03:14 -0400
X-MC-Unique: dUadzoCAN9WYfDF2dEjOKw-1
X-Mimecast-MFC-AGG-ID: dUadzoCAN9WYfDF2dEjOKw_1752238993
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 531761956089;
	Fri, 11 Jul 2025 13:03:13 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6768419560A3;
	Fri, 11 Jul 2025 13:03:08 +0000 (UTC)
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
Subject: [PATCH RFC v2 05/13] virtio: add support for negotiating extended features
Date: Fri, 11 Jul 2025 15:02:10 +0200
Message-ID: <986e516359285ef5308a4b4be7c1ae3f8be0dad8.1752229731.git.pabeni@redhat.com>
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

The virtio specifications allows for up to 128 bits for the
device features. Soon we are going to use some of the 'extended'
bits features (above 64) for the virtio net driver.

Add support to allow extended features negotiation on a per
devices basis. Devices willing to negotiated extended features
need to implemented a new pair of features getter/setter, the
core will conditionally use them instead of the basic one.

Note that 'bad_features' don't need to be extended, as they are
bound to the 64 bits limit.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - uint128_t -> uint64_t[]
---
 hw/virtio/virtio-bus.c     | 11 ++++++++---
 hw/virtio/virtio.c         | 18 +++++++++++++-----
 include/hw/virtio/virtio.h |  4 ++++
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/hw/virtio/virtio-bus.c b/hw/virtio/virtio-bus.c
index 11adfbf3ab..4a80f0b4d0 100644
--- a/hw/virtio/virtio-bus.c
+++ b/hw/virtio/virtio-bus.c
@@ -62,9 +62,14 @@ void virtio_bus_device_plugged(VirtIODevice *vdev, Error **errp)
     }
 
     /* Get the features of the plugged device. */
-    assert(vdc->get_features != NULL);
-    vdev->host_features = vdc->get_features(vdev, vdev->host_features,
-                                            &local_err);
+    if (vdc->get_features_ex) {
+        vdc->get_features_ex(vdev, vdev->host_features_array, &local_err);
+    } else {
+        assert(vdc->get_features != NULL);
+        virtio_features_from_u64(vdev->host_features_array,
+                                 vdc->get_features(vdev, vdev->host_features,
+                                                   &local_err));
+    }
     if (local_err) {
         error_propagate(errp, local_err);
         return;
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 6a313313dd..dd876d058e 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -3089,7 +3089,9 @@ static int virtio_set_features_nocheck(VirtIODevice *vdev, const uint64_t *val)
 
     virtio_features_and(tmp, val, vdev->host_features_array);
 
-    if (k->set_features) {
+    if (k->set_features_ex) {
+        k->set_features_ex(vdev, val);
+    } else if (k->set_features) {
         bad = bad || virtio_features_use_extended(tmp);
         k->set_features(vdev, tmp[0]);
     }
@@ -3160,9 +3162,8 @@ virtio_set_128bit_features_nocheck_maybe_co(VirtIODevice *vdev,
     }
 }
 
-int virtio_set_features(VirtIODevice *vdev, uint64_t val)
+int virtio_set_features_ex(VirtIODevice *vdev, const uint64_t *features)
 {
-    uint64_t features[VIRTIO_FEATURES_DWORDS];
     int ret;
     /*
      * The driver must not attempt to set features after feature negotiation
@@ -3172,13 +3173,12 @@ int virtio_set_features(VirtIODevice *vdev, uint64_t val)
         return -EINVAL;
     }
 
-    if (val & (1ull << VIRTIO_F_BAD_FEATURE)) {
+    if (features[0] & (1ull << VIRTIO_F_BAD_FEATURE)) {
         qemu_log_mask(LOG_GUEST_ERROR,
                       "%s: guest driver for %s has enabled UNUSED(30) feature bit!\n",
                       __func__, vdev->name);
     }
 
-    virtio_features_from_u64(features, val);
     ret = virtio_set_features_nocheck(vdev, features);
     if (virtio_vdev_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX)) {
         /* VIRTIO_RING_F_EVENT_IDX changes the size of the caches.  */
@@ -3198,6 +3198,14 @@ int virtio_set_features(VirtIODevice *vdev, uint64_t val)
     return ret;
 }
 
+int virtio_set_features(VirtIODevice *vdev, uint64_t val)
+{
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
+
+    virtio_features_from_u64(features, val);
+    return virtio_set_features_ex(vdev, features);
+}
+
 void virtio_reset(void *opaque)
 {
     VirtIODevice *vdev = opaque;
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 0d1eb20489..6a22c28d82 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -178,6 +178,9 @@ struct VirtioDeviceClass {
     /* This is what a VirtioDevice must implement */
     DeviceRealize realize;
     DeviceUnrealize unrealize;
+    void (*get_features_ex)(VirtIODevice *vdev, uint64_t *requested_features,
+                            Error **errp);
+    void (*set_features_ex)(VirtIODevice *vdev, const uint64_t *val);
     uint64_t (*get_features)(VirtIODevice *vdev,
                              uint64_t requested_features,
                              Error **errp);
@@ -367,6 +370,7 @@ void virtio_queue_reset(VirtIODevice *vdev, uint32_t queue_index);
 void virtio_queue_enable(VirtIODevice *vdev, uint32_t queue_index);
 void virtio_update_irq(VirtIODevice *vdev);
 int virtio_set_features(VirtIODevice *vdev, uint64_t val);
+int virtio_set_features_ex(VirtIODevice *vdev, const uint64_t *val);
 
 /* Base devices.  */
 typedef struct VirtIOBlkConf VirtIOBlkConf;
-- 
2.50.0


