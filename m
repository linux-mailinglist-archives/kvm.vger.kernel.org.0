Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7F32BB46C
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732059AbgKTSxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:53:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732056AbgKTSxb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:53:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/Ojn4cpi7xAVMskNFT0feT7MkBDEW4NMg9WWPtVNhY=;
        b=LujBUSjBjD5fo6D7VGhFmcoZ39rpt+z0IoZYnO4gvMDCzbhtDkvdynwrCh0mZvCAQGAsjM
        qXp8n4s4Ip+WRSKigKDEoFISWgMNLhs5/SGtmxwrU3KfwVwomOTNkztgxYI6Oai/xyQdBJ
        dcpmwDD3aGAPU15XsSXkuXT53VI4RoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-syOVuANoOUy-jKfm_jOXDg-1; Fri, 20 Nov 2020 13:53:27 -0500
X-MC-Unique: syOVuANoOUy-jKfm_jOXDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EFBC8145E2;
        Fri, 20 Nov 2020 18:53:24 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66FD25C230;
        Fri, 20 Nov 2020 18:53:08 +0000 (UTC)
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
Subject: [RFC PATCH 09/27] vhost: Route host->guest notification through qemu
Date:   Fri, 20 Nov 2020 19:50:47 +0100
Message-Id: <20201120185105.279030-10-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost-sw-lm-ring.c |  3 +++
 hw/virtio/vhost.c            | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
index 0192e77831..cbf53965cd 100644
--- a/hw/virtio/vhost-sw-lm-ring.c
+++ b/hw/virtio/vhost-sw-lm-ring.c
@@ -50,6 +50,9 @@ VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int idx)
     r = dev->vhost_ops->vhost_set_vring_kick(dev, &file);
     assert(r == 0);
 
+    vhost_virtqueue_mask(dev, dev->vdev, idx, true);
+    vhost_virtqueue_pending(dev, idx);
+
     return svq;
 }
 
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 1d55e26d45..9352c56bfa 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -960,12 +960,29 @@ static void handle_sw_lm_vq(VirtIODevice *vdev, VirtQueue *vq)
     vhost_vring_kick(svq);
 }
 
+static void vhost_handle_call(EventNotifier *n)
+{
+    struct vhost_virtqueue *hvq = container_of(n,
+                                              struct vhost_virtqueue,
+                                              masked_notifier);
+    struct vhost_dev *vdev = hvq->dev;
+    int idx = vdev->vq_index + (hvq == &vdev->vqs[0] ? 0 : 1);
+    VirtQueue *vq = virtio_get_queue(vdev->vdev, idx);
+
+    if (event_notifier_test_and_clear(n)) {
+        virtio_queue_invalidate_signalled_used(vdev->vdev, idx);
+        virtio_notify_irqfd(vdev->vdev, vq);
+    }
+}
+
 static int vhost_sw_live_migration_stop(struct vhost_dev *dev)
 {
     int idx;
 
     vhost_dev_enable_notifiers(dev, dev->vdev);
     for (idx = 0; idx < dev->nvqs; ++idx) {
+        vhost_virtqueue_mask(dev, dev->vdev, idx, false);
+        vhost_virtqueue_pending(dev, idx);
         vhost_sw_lm_shadow_vq_free(dev->sw_lm_shadow_vq[idx]);
     }
 
@@ -977,7 +994,10 @@ static int vhost_sw_live_migration_start(struct vhost_dev *dev)
     int idx;
 
     for (idx = 0; idx < dev->nvqs; ++idx) {
+        struct vhost_virtqueue *vq = &dev->vqs[idx];
+
         dev->sw_lm_shadow_vq[idx] = vhost_sw_lm_shadow_vq(dev, idx);
+        event_notifier_set_handler(&vq->masked_notifier, vhost_handle_call);
     }
 
     vhost_dev_disable_notifiers(dev, dev->vdev);
-- 
2.18.4

