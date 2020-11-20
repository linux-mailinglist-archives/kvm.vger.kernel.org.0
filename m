Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB672BB4AB
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbgKTS5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:57:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730060AbgKTS5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:57:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+qiriFl30O5ZK13M3dH3aBYCSEg2kw5TfbYjHT/iYc=;
        b=iHL5Nl0iest7VSS05rFaJu8IoKGhwhaLrccFmkCio4hcqgs6nBAJhCqfeJR1i+hu1XNE2X
        CLxvi7hN+aM10S/eCC1VeROcXEVsoEipAHEma8nwYzatB7em00PRJTNiYB4Atti/4LvCDK
        96wrwNKkpa4WOkmUgyF4ljGeqNGD1lU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320--iW6dT1CPiib-6aLo2w7YA-1; Fri, 20 Nov 2020 13:57:42 -0500
X-MC-Unique: -iW6dT1CPiib-6aLo2w7YA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA5C21084422;
        Fri, 20 Nov 2020 18:57:38 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDD7B5C1D5;
        Fri, 20 Nov 2020 18:57:23 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: [RFC PATCH 26/27] vhost: Add vhost_hdev_can_sw_lm
Date:   Fri, 20 Nov 2020 19:51:04 +0100
Message-Id: <20201120185105.279030-27-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows a device to migrate if it meet a few requirements.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index cf000b979f..44a51ccf5e 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1529,6 +1529,37 @@ static void vhost_virtqueue_cleanup(struct vhost_virtqueue *vq)
     event_notifier_cleanup(&vq->masked_notifier);
 }
 
+static bool vhost_hdev_can_sw_lm(struct vhost_dev *hdev)
+{
+    const char *cause = NULL;
+
+    if (hdev->features & (VIRTIO_F_IOMMU_PLATFORM)) {
+        cause = "have iommu";
+    } else if (hdev->features & VIRTIO_F_RING_PACKED) {
+        cause = "is packed";
+    } else if (hdev->features & VIRTIO_RING_F_EVENT_IDX) {
+        cause = "Have event idx";
+    } else if (hdev->features & VIRTIO_RING_F_INDIRECT_DESC) {
+        cause = "Supports indirect descriptors";
+    } else if (hdev->nvqs != 2) {
+        cause = "!= 2 #vq supported";
+    } else if (!hdev->vhost_ops->vhost_net_set_backend) {
+        cause = "cannot pause device";
+    }
+
+    if (cause) {
+        if (!hdev->migration_blocker) {
+            error_setg(&hdev->migration_blocker,
+                "Migration disabled: vhost lacks VHOST_F_LOG_ALL feature and %s.",
+                cause);
+        }
+
+        return false;
+    }
+
+    return true;
+}
+
 int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type, uint32_t busyloop_timeout)
 {
@@ -1604,7 +1635,8 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     };
 
     if (hdev->migration_blocker == NULL) {
-        if (!vhost_dev_can_log(hdev)) {
+        if (!vhost_dev_can_log(hdev) && !vhost_hdev_can_sw_lm(hdev)
+            && hdev->migration_blocker == NULL) {
             error_setg(&hdev->migration_blocker,
                        "Migration disabled: vhost lacks VHOST_F_LOG_ALL feature.");
         } else if (vhost_dev_log_is_shared(hdev) && !qemu_memfd_alloc_check()) {
-- 
2.18.4

