Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23F2BB49C
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgKTSzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:55:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732158AbgKTSzG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4wp9YwTYGJnUKm2v8rubzSiDU/VoJ3Bb1DJ/6lk+2es=;
        b=OGwTUoY0ZbWHvLDtCRfDAfbzluKzXjFl+sTW/D3U57HC6gjuNIa59+ocRgwhUodCXxQNOI
        PeNkydEUr2mkKQV2k+PXNBTkL+CVQiRQE5oaAFCTLwGOMeL5Wt24Y0tpat1bgAjX+9SrG7
        FSpfojOTUUnbCjoFmdg7M2MA94pdW4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-vhU3u-tTOGC90Zymqu4hTA-1; Fri, 20 Nov 2020 13:55:01 -0500
X-MC-Unique: vhU3u-tTOGC90Zymqu4hTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 951ED8030AD;
        Fri, 20 Nov 2020 18:54:58 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7628E5C1D5;
        Fri, 20 Nov 2020 18:54:49 +0000 (UTC)
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
Subject: [RFC PATCH 15/27] vhost: Do not invalidate signalled used
Date:   Fri, 20 Nov 2020 19:50:53 +0100
Message-Id: <20201120185105.279030-16-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we are in control of guest' VQ again, we can trust on it.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 304e0baa61..ac2bc14190 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -996,7 +996,6 @@ static void vhost_handle_call(EventNotifier *n)
     VirtQueue *vq = virtio_get_queue(vdev->vdev, idx);
 
     if (event_notifier_test_and_clear(n)) {
-        virtio_queue_invalidate_signalled_used(vdev->vdev, idx);
         virtio_notify_irqfd(vdev->vdev, vq);
     }
 }
-- 
2.18.4

