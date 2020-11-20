Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A8C2BB4A9
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgKTS5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:57:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729047AbgKTS5b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7NFTh5Kxb25Zit2Z09Dwayle5qrijF2SdCF72+OTF/8=;
        b=gfix5mH5ZtIhEDttf1Nc39m62DMRNKcOa2PG1Nz0KfublSxjHt8eHpnX3smXr+q8gbAc5K
        4/3zih0zMo7X5q/69dCsW2F+yQZCMJgYVZYq84w9fZnCJ/0wqtYWwsB62tvtlffzsV2itT
        J9qiLABP/TaLDecvqNePfKck3EwJR2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-APAVSU7rNfasUb3rHao7YA-1; Fri, 20 Nov 2020 13:57:26 -0500
X-MC-Unique: APAVSU7rNfasUb3rHao7YA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77F0D801B19;
        Fri, 20 Nov 2020 18:57:23 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 571CD5C1D5;
        Fri, 20 Nov 2020 18:57:14 +0000 (UTC)
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
Subject: [RFC PATCH 25/27] vhost: Do not commit vhost used idx on vhost_virtqueue_stop
Date:   Fri, 20 Nov 2020 19:51:03 +0100
Message-Id: <20201120185105.279030-26-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... if sw lm is enabled

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index cb44b9997f..cf000b979f 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1424,17 +1424,22 @@ static void vhost_virtqueue_stop(struct vhost_dev *dev,
     struct vhost_vring_state state = {
         .index = vhost_vq_index,
     };
-    int r;
+    int r = -1;
 
     if (virtio_queue_get_desc_addr(vdev, idx) == 0) {
         /* Don't stop the virtqueue which might have not been started */
         return;
     }
 
-    r = dev->vhost_ops->vhost_get_vring_base(dev, &state);
-    if (r < 0) {
-        VHOST_OPS_DEBUG("vhost VQ %u ring restore failed: %d", idx, r);
-        /* Connection to the backend is broken, so let's sync internal
+    if (!dev->sw_lm_enabled) {
+        r = dev->vhost_ops->vhost_get_vring_base(dev, &state);
+        if (r < 0) {
+            VHOST_OPS_DEBUG("vhost VQ %u ring restore failed: %d", idx, r);
+        }
+    }
+
+    if (!dev->sw_lm_enabled || r < 0) {
+        /* Connection to the backend is unusable, so let's sync internal
          * last avail idx to the device used idx.
          */
         virtio_queue_restore_last_avail_idx(vdev, idx);
-- 
2.18.4

