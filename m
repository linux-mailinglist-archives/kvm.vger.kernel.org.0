Return-Path: <kvm+bounces-52145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B58B01CF9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BADCFB425D0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8F92DE6F7;
	Fri, 11 Jul 2025 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Trhomgim"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFE62D0C67
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752238996; cv=none; b=tr3qRlnF7f9h8yPQt1ftGaGXUHnT5xsCEk/B0+lvyaOyzfeRIveUhvPnSgIqauZw2ir/AsitKe7eE8TQdcqOMETSRwpDBNH/2+FGEUfUnCdGdqsFUOXjoBg+x0iqtA5MENz8Nv+gRtAkmgKHgAkk4hbS83SpDQ4aVo49RhdkkdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752238996; c=relaxed/simple;
	bh=GIoFWolkCq0wwGUwrPyc+cB0emHfoywUG0eJP29m5w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlMa2qy/X99OFrefV4MR3f2JMQ7nbBKZhzyUrvxZAma2p7bcl8vqA6QCuUq9YBObBDSvOeo9msxkJUIjCoeg2tirATOQ8zUv31iA9NIelU+ZqxOceN87FvC0iIs865wXwHrfjV63tZ+JlrS6zSplYSEsyTWkaLhGpMQilnegioQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Trhomgim; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752238993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yv/e9TfGTNAXq5vppeKFNtoeq3WG3Gxymxnt/da3xBQ=;
	b=Trhomgim0g9CPCNkIwR16Kgoj3JhfHRMIhNKd7u0asaSVZFLzqD+TX+A7g2w9dJanXtRM5
	CUOT1LkybMWwLfIZ0bGOyzTMtw+5+zFY2s1aPYr1eJ4/CvXOv70wc5wUHPCmXPj8Z5Sdt8
	+7/fHK5w5X/Iay9uqxRlRFMxU7pZb9Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-M_7Cpp-BMBORHNtw_xWI-w-1; Fri,
 11 Jul 2025 09:03:09 -0400
X-MC-Unique: M_7Cpp-BMBORHNtw_xWI-w-1
X-Mimecast-MFC-AGG-ID: M_7Cpp-BMBORHNtw_xWI-w_1752238988
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D2B82195609F;
	Fri, 11 Jul 2025 13:03:07 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DDD5619560A3;
	Fri, 11 Jul 2025 13:03:01 +0000 (UTC)
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
Subject: [PATCH RFC v2 04/13] virtio: serialize extended features state
Date: Fri, 11 Jul 2025 15:02:09 +0200
Message-ID: <d0f97a8157c718dcb0799353394e1469153c6b22.1752229731.git.pabeni@redhat.com>
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

If the driver uses any of the extended features (i.e. above 64),
serialize the full features range (128 bits).

This is one of the few spots that need explicitly to know and set
in stone the extended features array size; add a build bug to prevent
breaking the migration should such size change again in the future:
more serialization plumbing will be needed.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
 - uint128_t -> u64[2]
---
 hw/virtio/virtio.c | 97 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 11 deletions(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 82a285a31d..6a313313dd 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -2954,6 +2954,24 @@ static const VMStateDescription vmstate_virtio_disabled = {
     }
 };
 
+static bool virtio_128bit_features_needed(void *opaque)
+{
+    VirtIODevice *vdev = opaque;
+
+    return virtio_features_use_extended(vdev->host_features_array);
+}
+
+static const VMStateDescription vmstate_virtio_128bit_features = {
+    .name = "virtio/128bit_features",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = &virtio_128bit_features_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT64_ARRAY(guest_features_array, VirtIODevice, 2),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static const VMStateDescription vmstate_virtio = {
     .name = "virtio",
     .version_id = 1,
@@ -2963,6 +2981,7 @@ static const VMStateDescription vmstate_virtio = {
     },
     .subsections = (const VMStateDescription * const []) {
         &vmstate_virtio_device_endian,
+        &vmstate_virtio_128bit_features,
         &vmstate_virtio_64bit_features,
         &vmstate_virtio_virtqueues,
         &vmstate_virtio_ringsize,
@@ -3059,23 +3078,30 @@ const VMStateInfo  virtio_vmstate_info = {
     .put = virtio_device_put,
 };
 
-static int virtio_set_features_nocheck(VirtIODevice *vdev, uint64_t val)
+static int virtio_set_features_nocheck(VirtIODevice *vdev, const uint64_t *val)
 {
     VirtioDeviceClass *k = VIRTIO_DEVICE_GET_CLASS(vdev);
-    bool bad = (val & ~(vdev->host_features)) != 0;
+    uint64_t tmp[VIRTIO_FEATURES_DWORDS];
+    bool bad;
+
+    virtio_features_andnot(tmp, val, vdev->host_features_array);
+    bad = !virtio_features_is_empty(tmp);
+
+    virtio_features_and(tmp, val, vdev->host_features_array);
 
-    val &= vdev->host_features;
     if (k->set_features) {
-        k->set_features(vdev, val);
+        bad = bad || virtio_features_use_extended(tmp);
+        k->set_features(vdev, tmp[0]);
     }
-    vdev->guest_features = val;
+
+    virtio_features_copy(vdev->guest_features_array, tmp);
     return bad ? -1 : 0;
 }
 
 typedef struct VirtioSetFeaturesNocheckData {
     Coroutine *co;
     VirtIODevice *vdev;
-    uint64_t val;
+    uint64_t val[VIRTIO_FEATURES_DWORDS];
     int ret;
 } VirtioSetFeaturesNocheckData;
 
@@ -3094,12 +3120,41 @@ virtio_set_features_nocheck_maybe_co(VirtIODevice *vdev, uint64_t val)
         VirtioSetFeaturesNocheckData data = {
             .co = qemu_coroutine_self(),
             .vdev = vdev,
-            .val = val,
         };
+        virtio_features_from_u64(data.val, val);
         aio_bh_schedule_oneshot(qemu_get_current_aio_context(),
                                 virtio_set_features_nocheck_bh, &data);
         qemu_coroutine_yield();
         return data.ret;
+    } else {
+        uint64_t features[VIRTIO_FEATURES_DWORDS];
+        virtio_features_from_u64(features, val);
+        return virtio_set_features_nocheck(vdev, features);
+    }
+}
+
+static void virtio_set_128bit_features_nocheck_bh(void *opaque)
+{
+    VirtioSetFeaturesNocheckData *data = opaque;
+
+    data->ret = virtio_set_features_nocheck(data->vdev, data->val);
+    aio_co_wake(data->co);
+}
+
+static int coroutine_mixed_fn
+virtio_set_128bit_features_nocheck_maybe_co(VirtIODevice *vdev,
+                                            const uint64_t *val)
+{
+    if (qemu_in_coroutine()) {
+        VirtioSetFeaturesNocheckData data = {
+            .co = qemu_coroutine_self(),
+            .vdev = vdev,
+        };
+        virtio_features_copy(data.val, val);
+        aio_bh_schedule_oneshot(qemu_get_current_aio_context(),
+                                virtio_set_128bit_features_nocheck_bh, &data);
+        qemu_coroutine_yield();
+        return data.ret;
     } else {
         return virtio_set_features_nocheck(vdev, val);
     }
@@ -3107,6 +3162,7 @@ virtio_set_features_nocheck_maybe_co(VirtIODevice *vdev, uint64_t val)
 
 int virtio_set_features(VirtIODevice *vdev, uint64_t val)
 {
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
     int ret;
     /*
      * The driver must not attempt to set features after feature negotiation
@@ -3122,7 +3178,8 @@ int virtio_set_features(VirtIODevice *vdev, uint64_t val)
                       __func__, vdev->name);
     }
 
-    ret = virtio_set_features_nocheck(vdev, val);
+    virtio_features_from_u64(features, val);
+    ret = virtio_set_features_nocheck(vdev, features);
     if (virtio_vdev_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX)) {
         /* VIRTIO_RING_F_EVENT_IDX changes the size of the caches.  */
         int i;
@@ -3145,6 +3202,7 @@ void virtio_reset(void *opaque)
 {
     VirtIODevice *vdev = opaque;
     VirtioDeviceClass *k = VIRTIO_DEVICE_GET_CLASS(vdev);
+    uint64_t features[VIRTIO_FEATURES_DWORDS];
     int i;
 
     virtio_set_status(vdev, 0);
@@ -3171,7 +3229,8 @@ void virtio_reset(void *opaque)
     vdev->start_on_kick = false;
     vdev->started = false;
     vdev->broken = false;
-    virtio_set_features_nocheck(vdev, 0);
+    virtio_features_clear(features);
+    virtio_set_features_nocheck(vdev, features);
     vdev->queue_sel = 0;
     vdev->status = 0;
     vdev->disabled = false;
@@ -3254,7 +3313,7 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
      * Note: devices should always test host features in future - don't create
      * new dependencies like this.
      */
-    vdev->guest_features = features;
+    virtio_features_from_u64(vdev->guest_features_array, features);
 
     config_len = qemu_get_be32(f);
 
@@ -3333,7 +3392,23 @@ virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id)
         vdev->device_endian = virtio_default_endian();
     }
 
-    if (virtio_64bit_features_needed(vdev)) {
+    /*
+     * Serialization needs constant size features array. Avoid
+     * silently breaking migration should the feature space increase
+     * even more in the (far away) future
+     */
+    QEMU_BUILD_BUG_ON(VIRTIO_FEATURES_DWORDS != 2);
+    if (virtio_128bit_features_needed(vdev)) {
+        uint64_t *val = vdev->guest_features_array;
+
+        if (virtio_set_128bit_features_nocheck_maybe_co(vdev, val) < 0) {
+            error_report("Features 0x" VIRTIO_FEATURES_FMT " unsupported. "
+                         "Allowed features: 0x" VIRTIO_FEATURES_FMT,
+                         VIRTIO_FEATURES_PR(val),
+                         VIRTIO_FEATURES_PR(vdev->host_features_array));
+            return -1;
+        }
+    } else if (virtio_64bit_features_needed(vdev)) {
         /*
          * Subsection load filled vdev->guest_features.  Run them
          * through virtio_set_features to sanity-check them against
-- 
2.50.0


