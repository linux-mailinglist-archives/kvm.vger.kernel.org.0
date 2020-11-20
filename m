Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C5C2BB46D
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732060AbgKTSxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:53:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731358AbgKTSxo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=geMra6s2mk7qQGmiDf6FdjeAxAi7bQOlm3m+XgBp7eM=;
        b=C6sqfPQFxgXg0WLje1t+24Z6DDIPiM64FV0qbCn2GtvQIkQcm1kMOFl5OaK5ci4MNeOuUW
        3eKuy+hoYNaM9zrr4A1OVoLgSddcDnYsFez2dz3OQrWNUQEUmV9hOCjNsuxi9F0EcxyjrG
        1c7RdvcyCj+fK6i/O27b1iY4E3V3eXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-O0I0LkrQMrGPImdL7SOirQ-1; Fri, 20 Nov 2020 13:53:39 -0500
X-MC-Unique: O0I0LkrQMrGPImdL7SOirQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 437D1801AF1;
        Fri, 20 Nov 2020 18:53:36 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97F395C1D5;
        Fri, 20 Nov 2020 18:53:24 +0000 (UTC)
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
Subject: [RFC PATCH 10/27] vhost: Allocate shadow vring
Date:   Fri, 20 Nov 2020 19:50:48 +0100
Message-Id: <20201120185105.279030-11-eperezma@redhat.com>
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
 hw/virtio/vhost-sw-lm-ring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
index cbf53965cd..cd7b5ba772 100644
--- a/hw/virtio/vhost-sw-lm-ring.c
+++ b/hw/virtio/vhost-sw-lm-ring.c
@@ -16,8 +16,11 @@
 #include "qemu/event_notifier.h"
 
 typedef struct VhostShadowVirtqueue {
+    struct vring vring;
     EventNotifier hdev_notifier;
     VirtQueue *vq;
+
+    vring_desc_t descs[];
 } VhostShadowVirtqueue;
 
 static inline bool vhost_vring_should_kick(VhostShadowVirtqueue *vq)
@@ -37,10 +40,12 @@ VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int idx)
         .index = idx
     };
     VirtQueue *vq = virtio_get_queue(dev->vdev, idx);
+    unsigned num = virtio_queue_get_num(dev->vdev, idx);
+    size_t ring_size = vring_size(num, VRING_DESC_ALIGN_SIZE);
     VhostShadowVirtqueue *svq;
     int r;
 
-    svq = g_new0(VhostShadowVirtqueue, 1);
+    svq = g_malloc0(sizeof(*svq) + ring_size);
     svq->vq = vq;
 
     r = event_notifier_init(&svq->hdev_notifier, 0);
-- 
2.18.4

