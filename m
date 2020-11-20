Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0DA2BB4A7
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgKTS5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:57:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728378AbgKTS5D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CrZ8HzqKH9jvP8Zbz9rlbrynGHpm+xBKQyRidhhC+ks=;
        b=JODFRAB5AGFUsX6SEnxeUozM0HOQzKVxDixChQuzJZX5zk5ukmdEr/VjOXafDSMY6UbqTW
        3qOf+Zht98YDcncGML6Q1tApaRmOJ9qK5hFVR6knNlb2GVugWv6810U3RLbJd53XIF3ExL
        fJ/w5hOmT41UJrQ2GR0/Ylp+WP+dgeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-Fp2Ve2KaObiDeZeZtu8-8A-1; Fri, 20 Nov 2020 13:57:00 -0500
X-MC-Unique: Fp2Ve2KaObiDeZeZtu8-8A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5123B10059A4;
        Fri, 20 Nov 2020 18:56:58 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FE645C1D5;
        Fri, 20 Nov 2020 18:56:36 +0000 (UTC)
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
Subject: [RFC PATCH 23/27] vhost: unmap qemu's shadow virtqueues on sw live migration
Date:   Fri, 20 Nov 2020 19:51:01 +0100
Message-Id: <20201120185105.279030-24-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since vhost does not need to access it, it has no sense to keep it
mapped.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index f640d4edf0..eebfac4455 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1124,6 +1124,7 @@ static int vhost_sw_live_migration_start(struct vhost_dev *dev)
 
         dev->sw_lm_shadow_vq[idx] = vhost_sw_lm_shadow_vq(dev, idx);
         event_notifier_set_handler(&vq->masked_notifier, vhost_handle_call);
+        vhost_virtqueue_memory_unmap(dev, &dev->vqs[idx], true);
 
         vhost_vring_write_addr(dev->sw_lm_shadow_vq[idx], &addr);
         r = dev->vhost_ops->vhost_set_vring_addr(dev, &addr);
-- 
2.18.4

