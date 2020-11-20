Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686F22BB491
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbgKTSyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:54:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729175AbgKTSyO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:54:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P54fNkbLFlDhwRYgmtpG8Llho8C34w4aU/D/fzEYMnA=;
        b=R5zHjq7tn3D7j+fjx8/YfqB+mxNQXtT7BN3NqhJ5BiyC/g2PaNPXjwsY8wx9gYI1zxkHCg
        Hp1qHrWio0wTkBF4cbHzqb0UBsSFTEDvJnVuXCNqn5X2BLxI2CwISqpfjon3sO/JkyF6HY
        YswnYeVOow6bjZEGaShk/zMMFUB88DU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-Ibt8zbtuMPKnozMX7xzKtA-1; Fri, 20 Nov 2020 13:54:11 -0500
X-MC-Unique: Ibt8zbtuMPKnozMX7xzKtA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 636981084423;
        Fri, 20 Nov 2020 18:54:08 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 375E35C1D5;
        Fri, 20 Nov 2020 18:53:55 +0000 (UTC)
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
Subject: [RFC PATCH 12/27] virtio: Add virtio_queue_full
Date:   Fri, 20 Nov 2020 19:50:50 +0100
Message-Id: <20201120185105.279030-13-eperezma@redhat.com>
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
 include/hw/virtio/virtio.h |  2 ++
 hw/virtio/virtio.c         | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index b9b8497ea0..0a7f5cc63e 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -233,6 +233,8 @@ int virtio_queue_ready(VirtQueue *vq);
 
 int virtio_queue_empty(VirtQueue *vq);
 
+bool virtio_queue_full(const VirtQueue *vq);
+
 /* Host binding interface.  */
 
 uint32_t virtio_config_readb(VirtIODevice *vdev, uint32_t addr);
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 3469946538..77ca5f6b6f 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -684,6 +684,17 @@ int virtio_queue_empty(VirtQueue *vq)
     }
 }
 
+static bool virtio_queue_full_rcu(const VirtQueue *vq)
+{
+    return vq->inuse >= vq->vring.num;
+}
+
+bool virtio_queue_full(const VirtQueue *vq)
+{
+    RCU_READ_LOCK_GUARD();
+    return virtio_queue_full_rcu(vq);
+}
+
 static void virtqueue_unmap_sg(VirtQueue *vq, const VirtQueueElement *elem,
                                unsigned int len)
 {
@@ -1453,7 +1464,7 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
 
     max = vq->vring.num;
 
-    if (vq->inuse >= vq->vring.num) {
+    if (unlikely(virtio_queue_full_rcu(vq))) {
         virtio_error(vdev, "Virtqueue size exceeded");
         goto done;
     }
@@ -1588,7 +1599,7 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
 
     max = vq->vring.num;
 
-    if (vq->inuse >= vq->vring.num) {
+    if (unlikely(virtio_queue_full_rcu(vq))) {
         virtio_error(vdev, "Virtqueue size exceeded");
         goto done;
     }
-- 
2.18.4

