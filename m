Return-Path: <kvm+bounces-52147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9805BB01CD2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 529EB3A8FAA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8012E03E1;
	Fri, 11 Jul 2025 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAYkXAke"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288D620B7FA
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239007; cv=none; b=dMyjqTb3jH2mTS8oh2p5jqt1XOP15pCX+AmEWnS3WwtxNU37h6nXR7I3am7xrnX9jwQtGgE0FroFwyB+iuITmIY2vPih6BCnllaXeVfjKXz87gTEs2Dnx2qQVGw6BFxLW1n2xzeZY5127FPJrgRUecdMR0F9nrtS3BFpH+3YAjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239007; c=relaxed/simple;
	bh=adCUKSFX1DTF6NsitqaZBDTnzFX8yJvoBEamCMHxW6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUhjzN0to7elzlZof5Vjjuj7Y+QXFGQwc0Il/4d/tcj0dhiObVQCTPu9G+sie39kbcU61yY/Ee9KC+ezOLAFonekOS5qagYRN4YfAVxouBO0XN/I2/mKOpfeBorw35bAxoez26aOL3wrnY02wSlZk7hR/89pAaU+g9ONzE+pacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AAYkXAke; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752239005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mdjKi7vRXbys/6LNGylQ64h3YF3P0vhP2xKR3H4sEIY=;
	b=AAYkXAkesJvtEaCQdO1XMlWUqkSskLSRMLlDgyE2LNKHnSJa/3pXRwAjDr9hTXtlp1TxAV
	iiiGnxmBzLBunwE2bS3pQ5idSsXnH6HjqpUdYBkxEif4ERRY7TP5AnYSAde3A3eDaUSSPI
	uD3aM4vKO52sgch7fsCqr5KlyQr1RtY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-KdUW7V-cOLSM7BzPLgwtnw-1; Fri,
 11 Jul 2025 09:03:21 -0400
X-MC-Unique: KdUW7V-cOLSM7BzPLgwtnw-1
X-Mimecast-MFC-AGG-ID: KdUW7V-cOLSM7BzPLgwtnw_1752239000
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B5CC180047F;
	Fri, 11 Jul 2025 13:03:20 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58A8519560A3;
	Fri, 11 Jul 2025 13:03:13 +0000 (UTC)
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
Subject: [PATCH RFC v2 06/13] virtio-pci: implement support for extended features
Date: Fri, 11 Jul 2025 15:02:11 +0200
Message-ID: <eb1aa9c8442d9b482b5c84fdca54b92c8a824495.1752229731.git.pabeni@redhat.com>
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

Extend the features configuration space to 128 bits, and allow the
common read/write operation to access all of it.

On migration, save the 128 bit version of the features only if the
upper bits are non zero; after load zero the upper bits if the extended
features were not loaded.

Note that we must clear the proxy-ed features on device reset, otherwise
a guest kernel not supporting extended features booted after an extended
features enabled one could end-up wrongly inheriting extended features.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - use separate VMStateDescription and pre/post load to avoid breaking
    migration
  - clear proxy features on device reset
---
 hw/virtio/virtio-pci.c         | 101 +++++++++++++++++++++++++++++----
 include/hw/virtio/virtio-pci.h |   6 +-
 2 files changed, 96 insertions(+), 11 deletions(-)

diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index fba2372c93..dc5e7eaf81 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -108,6 +108,39 @@ static const VMStateDescription vmstate_virtio_pci_modern_queue_state = {
     }
 };
 
+static bool virtio_pci_modern_state_features128_needed(void *opaque)
+{
+    VirtIOPCIProxy *proxy = opaque;
+    uint32_t features = 0;
+    int i;
+
+    for (i = 2; i < ARRAY_SIZE(proxy->guest_features128); ++i) {
+        features |= proxy->guest_features128[i];
+    }
+    return !!features;
+}
+
+static int virtio_pci_modern_state_features128_post_load(void *opaque,
+                                                         int version_id)
+{
+    VirtIOPCIProxy *proxy = opaque;
+
+    proxy->extended_features_loaded = true;
+    return 0;
+}
+
+static const VMStateDescription vmstate_virtio_pci_modern_state_features128 = {
+    .name = "virtio_pci/modern_state/features128",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .post_load = &virtio_pci_modern_state_features128_post_load,
+    .needed = &virtio_pci_modern_state_features128_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT32_ARRAY(guest_features128, VirtIOPCIProxy, 4),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool virtio_pci_modern_state_needed(void *opaque)
 {
     VirtIOPCIProxy *proxy = opaque;
@@ -115,10 +148,40 @@ static bool virtio_pci_modern_state_needed(void *opaque)
     return virtio_pci_modern(proxy);
 }
 
+static int virtio_pci_modern_state_pre_load(void *opaque)
+{
+    VirtIOPCIProxy *proxy = opaque;
+
+    proxy->extended_features_loaded = false;
+    return 0;
+}
+
+static int virtio_pci_modern_state_post_load(void *opaque, int version_id)
+{
+    VirtIOPCIProxy *proxy = opaque;
+    int i;
+
+    if (proxy->extended_features_loaded) {
+        return 0;
+    }
+
+    QEMU_BUILD_BUG_ON(offsetof(VirtIOPCIProxy, guest_features[0]) !=
+                      offsetof(VirtIOPCIProxy, guest_features128[0]));
+    QEMU_BUILD_BUG_ON(offsetof(VirtIOPCIProxy, guest_features[1]) !=
+                      offsetof(VirtIOPCIProxy, guest_features128[1]));
+
+    for (i = 2; i < ARRAY_SIZE(proxy->guest_features128); ++i) {
+        proxy->guest_features128[i] = 0;
+    }
+    return 0;
+}
+
 static const VMStateDescription vmstate_virtio_pci_modern_state_sub = {
     .name = "virtio_pci/modern_state",
     .version_id = 1,
     .minimum_version_id = 1,
+    .pre_load = &virtio_pci_modern_state_pre_load,
+    .post_load = &virtio_pci_modern_state_post_load,
     .needed = &virtio_pci_modern_state_needed,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT32(dfselect, VirtIOPCIProxy),
@@ -128,6 +191,10 @@ static const VMStateDescription vmstate_virtio_pci_modern_state_sub = {
                              vmstate_virtio_pci_modern_queue_state,
                              VirtIOPCIQueue),
         VMSTATE_END_OF_LIST()
+    },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_virtio_pci_modern_state_features128,
+        NULL
     }
 };
 
@@ -1493,19 +1560,22 @@ static uint64_t virtio_pci_common_read(void *opaque, hwaddr addr,
         val = proxy->dfselect;
         break;
     case VIRTIO_PCI_COMMON_DF:
-        if (proxy->dfselect <= 1) {
+        if (proxy->dfselect < VIRTIO_FEATURES_WORDS) {
             VirtioDeviceClass *vdc = VIRTIO_DEVICE_GET_CLASS(vdev);
 
-            val = (vdev->host_features & ~vdc->legacy_features) >>
-                (32 * proxy->dfselect);
+            val = vdev->host_features_array[proxy->dfselect >> 1] >>
+                  (32 * (proxy->dfselect & 1));
+            if (proxy->dfselect <= 1) {
+                val &= (~vdc->legacy_features) >> (32 * proxy->dfselect);
+            }
         }
         break;
     case VIRTIO_PCI_COMMON_GFSELECT:
         val = proxy->gfselect;
         break;
     case VIRTIO_PCI_COMMON_GF:
-        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features)) {
-            val = proxy->guest_features[proxy->gfselect];
+        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features128)) {
+            val = proxy->guest_features128[proxy->gfselect];
         }
         break;
     case VIRTIO_PCI_COMMON_MSIX:
@@ -1587,11 +1657,18 @@ static void virtio_pci_common_write(void *opaque, hwaddr addr,
         proxy->gfselect = val;
         break;
     case VIRTIO_PCI_COMMON_GF:
-        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features)) {
-            proxy->guest_features[proxy->gfselect] = val;
-            virtio_set_features(vdev,
-                                (((uint64_t)proxy->guest_features[1]) << 32) |
-                                proxy->guest_features[0]);
+        if (proxy->gfselect < ARRAY_SIZE(proxy->guest_features128)) {
+            uint64_t features[VIRTIO_FEATURES_DWORDS];
+            int i;
+
+            proxy->guest_features128[proxy->gfselect] = val;
+            virtio_features_clear(features);
+            for (i = 0; i < ARRAY_SIZE(proxy->guest_features128); ++i) {
+                uint64_t cur = proxy->guest_features128[i];
+
+                features[i >> 1] |= cur << ((i & 1) * 32);
+            }
+            virtio_set_features_ex(vdev, features);
         }
         break;
     case VIRTIO_PCI_COMMON_MSIX:
@@ -2310,6 +2387,10 @@ static void virtio_pci_reset(DeviceState *qdev)
     virtio_bus_reset(bus);
     msix_unuse_all_vectors(&proxy->pci_dev);
 
+    /* be sure to not carry over any feature across reset */
+    memset(proxy->guest_features128, 0, sizeof(uint32_t) *
+           ARRAY_SIZE(proxy->guest_features128));
+
     for (i = 0; i < VIRTIO_QUEUE_MAX; i++) {
         proxy->vqs[i].enabled = 0;
         proxy->vqs[i].reset = 0;
diff --git a/include/hw/virtio/virtio-pci.h b/include/hw/virtio/virtio-pci.h
index eab5394898..1868e3b106 100644
--- a/include/hw/virtio/virtio-pci.h
+++ b/include/hw/virtio/virtio-pci.h
@@ -151,6 +151,7 @@ struct VirtIOPCIProxy {
     uint32_t flags;
     bool disable_modern;
     bool ignore_backend_features;
+    bool extended_features_loaded;
     OnOffAuto disable_legacy;
     /* Transitional device id */
     uint16_t trans_devid;
@@ -158,7 +159,10 @@ struct VirtIOPCIProxy {
     uint32_t nvectors;
     uint32_t dfselect;
     uint32_t gfselect;
-    uint32_t guest_features[2];
+    union {
+        uint32_t guest_features[2];
+        uint32_t guest_features128[4];
+    };
     VirtIOPCIQueue vqs[VIRTIO_QUEUE_MAX];
 
     VirtIOIRQFD *vector_irqfd;
-- 
2.50.0


