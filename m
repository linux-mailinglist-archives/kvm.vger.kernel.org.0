Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97492BB4A8
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgKTS5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728378AbgKTS5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:57:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ryEh3kyaXHqK19Bj8UjCon+CnIrYqmewzumtOEVqPsQ=;
        b=H3kjDMtdWUV1rYRruexbHqgbOsphrs5gegTpkCA3jDr9UmI6h+46lQ92aUxSZUBHC0dcJo
        iHhDngJ1Dir6s//vijMeZv7dk5tVxZkFDznyWOElxVVACCTGQ8qyXPov8pzVF5Z3BWf9vJ
        yusqNHEhxwHGpEPZYJebk5PK0m6wJ54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-OefOQcNqNjmjp4PHqy7Kmg-1; Fri, 20 Nov 2020 13:57:17 -0500
X-MC-Unique: OefOQcNqNjmjp4PHqy7Kmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F365B1084425;
        Fri, 20 Nov 2020 18:57:13 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A90BD5C1D5;
        Fri, 20 Nov 2020 18:56:58 +0000 (UTC)
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
Subject: [RFC PATCH 24/27] vhost: iommu changes
Date:   Fri, 20 Nov 2020 19:51:02 +0100
Message-Id: <20201120185105.279030-25-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since vhost is now asking for qemu's VA, iommu needs to be bypassed.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index eebfac4455..cb44b9997f 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1109,6 +1109,10 @@ static int vhost_sw_live_migration_start(struct vhost_dev *dev)
 
     assert(dev->vhost_ops->vhost_set_vring_enable);
     dev->vhost_ops->vhost_set_vring_enable(dev, false);
+    if (vhost_dev_has_iommu(dev)) {
+        r = vhost_backend_invalidate_device_iotlb(dev, 0, -1ULL);
+        assert(r == 0);
+    }
 
     for (idx = 0; idx < dev->nvqs; ++idx) {
         struct vhost_virtqueue *vq = &dev->vqs[idx];
@@ -1269,6 +1273,19 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, uint64_t iova, int write)
 
     trace_vhost_iotlb_miss(dev, 1);
 
+    if (dev->sw_lm_enabled) {
+        uaddr = iova;
+        len = 4096;
+        ret = vhost_backend_update_device_iotlb(dev, iova, uaddr, len,
+                                                IOMMU_RW);
+        if (ret) {
+            trace_vhost_iotlb_miss(dev, 2);
+            error_report("Fail to update device iotlb");
+        }
+
+        return ret;
+    }
+
     iotlb = address_space_get_iotlb_entry(dev->vdev->dma_as,
                                           iova, write,
                                           MEMTXATTRS_UNSPECIFIED);
-- 
2.18.4

