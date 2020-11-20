Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E402BB463
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732028AbgKTSwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:52:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731381AbgKTSwi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:52:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y17EVO/s0xg6tqcxCWG6nhFINdKj1LKpomp8rmt7L8A=;
        b=chx1PoKwHguedkukAvHrJivJv5Rwt98XLRA7ctOf0oCdpiyw+5LJEWeRcupj1lWtbT33uY
        AjHibdD8AZ68VGkEk4w2ag518WA7S+Zwd7poqC6n1gnGIRiWSssaVR/2OEJAqXoAOPG3U+
        aDY8Jcv/ogccym8TEi93Bq4joN3SJL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-H2Z1tymUMiSbaQlXOnSUjA-1; Fri, 20 Nov 2020 13:52:35 -0500
X-MC-Unique: H2Z1tymUMiSbaQlXOnSUjA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7889F8144EC;
        Fri, 20 Nov 2020 18:52:32 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C9F25C1D5;
        Fri, 20 Nov 2020 18:52:16 +0000 (UTC)
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
Subject: [RFC PATCH 06/27] virtio: Add virtio_queue_get_used_notify_split
Date:   Fri, 20 Nov 2020 19:50:44 +0100
Message-Id: <20201120185105.279030-7-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is just used for a few commits, so SW LM is developed
incrementally, and it is deleted after it is useful.

For a few commits, only the events (irqfd, eventfd) are forwarded.
This series adds descriptors forwarding on top of that.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/hw/virtio/virtio.h |  1 +
 hw/virtio/virtio.c         | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index b7ece7a6a8..b9b8497ea0 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -225,6 +225,7 @@ int virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id);
 
 void virtio_notify_config(VirtIODevice *vdev);
 
+bool virtio_queue_get_used_notify_split(VirtQueue *vq);
 bool virtio_queue_get_notification(VirtQueue *vq);
 void virtio_queue_set_notification(VirtQueue *vq, int enable);
 
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index ceb58fda6c..3469946538 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -377,6 +377,20 @@ static inline void vring_used_idx_set(VirtQueue *vq, uint16_t val)
     vq->used_idx = val;
 }
 
+bool virtio_queue_get_used_notify_split(VirtQueue *vq)
+{
+    VRingMemoryRegionCaches *caches;
+    hwaddr pa = offsetof(VRingUsed, flags);
+    uint16_t flags;
+
+    RCU_READ_LOCK_GUARD();
+
+    caches = vring_get_region_caches(vq);
+    assert(caches);
+    flags = virtio_lduw_phys_cached(vq->vdev, &caches->used, pa);
+    return !(VRING_USED_F_NO_NOTIFY & flags);
+}
+
 /* Called within rcu_read_lock().  */
 static inline void vring_used_flags_set_bit(VirtQueue *vq, int mask)
 {
-- 
2.18.4

