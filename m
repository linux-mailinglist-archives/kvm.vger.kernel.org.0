Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE112BB4A1
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbgKTSz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:55:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732177AbgKTSz1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0UHivzc6s/JNkkNVrXBKkPRfSO+gYprJIEU1Xp+Kgh8=;
        b=QWM/Vy++egcDcQqlX7DvSZZ9zN/B01vUeA9siEzqXmD4oSyfg0OIFM0eQPocRTvzRNH8AZ
        fk6k555VehMjef3F16Y5BW7T2yxN3EOSRipU6LCDnNo2KGlTkaPGKrLCO/R8eNVzu6/M5E
        PLvVxoZhRX83SqhOB+wtHAmgq4NNTM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-70ESR6YbNbOEQU5MD20vSA-1; Fri, 20 Nov 2020 13:55:23 -0500
X-MC-Unique: 70ESR6YbNbOEQU5MD20vSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22C821842159;
        Fri, 20 Nov 2020 18:55:21 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 130455C1D5;
        Fri, 20 Nov 2020 18:55:11 +0000 (UTC)
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
Subject: [RFC PATCH 17/27] vhost: add vhost_vring_set_notification_rcu
Date:   Fri, 20 Nov 2020 19:50:55 +0100
Message-Id: <20201120185105.279030-18-eperezma@redhat.com>
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
 hw/virtio/vhost-sw-lm-ring.h |  4 ++++
 hw/virtio/vhost-sw-lm-ring.c | 23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/hw/virtio/vhost-sw-lm-ring.h b/hw/virtio/vhost-sw-lm-ring.h
index 29d21feaf4..c537500d9e 100644
--- a/hw/virtio/vhost-sw-lm-ring.h
+++ b/hw/virtio/vhost-sw-lm-ring.h
@@ -19,6 +19,10 @@ typedef struct VhostShadowVirtqueue VhostShadowVirtqueue;
 
 bool vhost_vring_kick(VhostShadowVirtqueue *vq);
 int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem);
+
+/* Called within rcu_read_lock().  */
+void vhost_vring_set_notification_rcu(VhostShadowVirtqueue *vq, bool enable);
+
 void vhost_vring_write_addr(const VhostShadowVirtqueue *vq,
 	                    struct vhost_vring_addr *addr);
 
diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
index aed005c2d9..c3244c550e 100644
--- a/hw/virtio/vhost-sw-lm-ring.c
+++ b/hw/virtio/vhost-sw-lm-ring.c
@@ -34,6 +34,9 @@ typedef struct VhostShadowVirtqueue {
     /* Next free descriptor */
     uint16_t free_head;
 
+    /* Cache for exposed notification flag */
+    bool notification;
+
     vring_desc_t descs[];
 } VhostShadowVirtqueue;
 
@@ -60,6 +63,26 @@ bool vhost_vring_kick(VhostShadowVirtqueue *vq)
                                        : true;
 }
 
+void vhost_vring_set_notification_rcu(VhostShadowVirtqueue *vq, bool enable)
+{
+    uint16_t notification_flag;
+
+    if (vq->notification == enable) {
+        return;
+    }
+
+    notification_flag = virtio_tswap16(vq->vdev, VRING_AVAIL_F_NO_INTERRUPT);
+
+    vq->notification = enable;
+    if (enable) {
+        vq->vring.avail->flags &= ~notification_flag;
+    } else {
+        vq->vring.avail->flags |= notification_flag;
+    }
+
+    smp_mb();
+}
+
 static void vhost_vring_write_descs(VhostShadowVirtqueue *vq,
                                     const struct iovec *iovec,
                                     size_t num, bool more_descs, bool write)
-- 
2.18.4

