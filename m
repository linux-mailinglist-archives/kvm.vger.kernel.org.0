Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A78D2BB4A2
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732177AbgKTSzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:55:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732154AbgKTSzh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:55:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XrOQ1s9JEtCDaxgd6vNOOY/KU2hMoYwe0eOTlPEs1LA=;
        b=eAD5dJsmR9nKwDQGhn4BIZD8VHoe0lrwwc1qBWAiaYSJl6w96SGRTt+flRpDWr91aCjclh
        0PKYjUZA6xUtMK/yzgPw9+KY9sBMnBjZvjZeuxtF5onHC8b8OQ0+dKeodnJCi/ryzzJjrm
        ZGaMBV0RgL3x2EVw9xGG1EgugNdz9Yk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-3a8sTKaMN8eKwFoqmbXgCw-1; Fri, 20 Nov 2020 13:55:33 -0500
X-MC-Unique: 3a8sTKaMN8eKwFoqmbXgCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF8875B365;
        Fri, 20 Nov 2020 18:55:30 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 798045C1D5;
        Fri, 20 Nov 2020 18:55:21 +0000 (UTC)
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
Subject: [RFC PATCH 18/27] vhost: add vhost_vring_poll_rcu
Date:   Fri, 20 Nov 2020 19:50:56 +0100
Message-Id: <20201120185105.279030-19-eperezma@redhat.com>
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
 hw/virtio/vhost-sw-lm-ring.h |  2 ++
 hw/virtio/vhost-sw-lm-ring.c | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/hw/virtio/vhost-sw-lm-ring.h b/hw/virtio/vhost-sw-lm-ring.h
index c537500d9e..03257d60c1 100644
--- a/hw/virtio/vhost-sw-lm-ring.h
+++ b/hw/virtio/vhost-sw-lm-ring.h
@@ -22,6 +22,8 @@ int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem);
 
 /* Called within rcu_read_lock().  */
 void vhost_vring_set_notification_rcu(VhostShadowVirtqueue *vq, bool enable);
+/* Called within rcu_read_lock().  */
+bool vhost_vring_poll_rcu(VhostShadowVirtqueue *vq);
 
 void vhost_vring_write_addr(const VhostShadowVirtqueue *vq,
 	                    struct vhost_vring_addr *addr);
diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
index c3244c550e..3652889d8e 100644
--- a/hw/virtio/vhost-sw-lm-ring.c
+++ b/hw/virtio/vhost-sw-lm-ring.c
@@ -34,6 +34,12 @@ typedef struct VhostShadowVirtqueue {
     /* Next free descriptor */
     uint16_t free_head;
 
+    /* Last seen used idx */
+    uint16_t shadow_used_idx;
+
+    /* Next head to consume from device */
+    uint16_t used_idx;
+
     /* Cache for exposed notification flag */
     bool notification;
 
@@ -83,6 +89,18 @@ void vhost_vring_set_notification_rcu(VhostShadowVirtqueue *vq, bool enable)
     smp_mb();
 }
 
+bool vhost_vring_poll_rcu(VhostShadowVirtqueue *vq)
+{
+    if (vq->used_idx != vq->shadow_used_idx) {
+        return true;
+    }
+
+    smp_rmb();
+    vq->shadow_used_idx = virtio_tswap16(vq->vdev, vq->vring.used->idx);
+
+    return vq->used_idx != vq->shadow_used_idx;
+}
+
 static void vhost_vring_write_descs(VhostShadowVirtqueue *vq,
                                     const struct iovec *iovec,
                                     size_t num, bool more_descs, bool write)
-- 
2.18.4

