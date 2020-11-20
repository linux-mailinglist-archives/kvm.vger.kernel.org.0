Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F032BB46B
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbgKTSxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:53:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729154AbgKTSxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qu8CTJiydQcChlxQWTNmkAEwFHT33IJLluEvEtsX/ss=;
        b=X0UqFWHt5Y5UpnjR+b0lXwVdmCbdlm94xDVTuttICwnEHuseS3etSoJRxZ0qMMX/nhUPHG
        V9qfpmvprls5onSjJ+PajPwGl9lprPgYuz3aRhAnmIrBQ021BJr12pNFcPNN81eoYnZXDY
        MHxjGMuW9MyO5B31HkrAlvmwBtk1paA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-_JNmgddUNyaRjjXM5pQgFA-1; Fri, 20 Nov 2020 13:53:10 -0500
X-MC-Unique: _JNmgddUNyaRjjXM5pQgFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10C3C8797E8;
        Fri, 20 Nov 2020 18:53:08 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAD965C1D5;
        Fri, 20 Nov 2020 18:52:48 +0000 (UTC)
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
Subject: [RFC PATCH 08/27] vhost: Add a flag for software assisted Live Migration
Date:   Fri, 20 Nov 2020 19:50:46 +0100
Message-Id: <20201120185105.279030-9-eperezma@redhat.com>
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
 include/hw/virtio/vhost.h |  1 +
 hw/virtio/vhost.c         | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 93cc3f1ae3..ef920a8076 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -84,6 +84,7 @@ struct vhost_dev {
     uint64_t backend_cap;
     bool started;
     bool log_enabled;
+    bool sw_lm_enabled;
     uint64_t log_size;
     VhostShadowVirtqueue *sw_lm_shadow_vq[2];
     VirtIOHandleOutput sw_lm_vq_handler;
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index a55b684b5f..1d55e26d45 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -988,11 +988,16 @@ static int vhost_sw_live_migration_start(struct vhost_dev *dev)
 static int vhost_sw_live_migration_enable(struct vhost_dev *dev,
                                           bool enable_lm)
 {
+    int r;
+
     if (enable_lm) {
-        return vhost_sw_live_migration_start(dev);
+        r = vhost_sw_live_migration_start(dev);
     } else {
-        return vhost_sw_live_migration_stop(dev);
+        r = vhost_sw_live_migration_stop(dev);
     }
+
+    dev->sw_lm_enabled = enable_lm;
+    return r;
 }
 
 static void vhost_sw_lm_global_start(MemoryListener *listener)
@@ -1466,6 +1471,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     hdev->log = NULL;
     hdev->log_size = 0;
     hdev->log_enabled = false;
+    hdev->sw_lm_enabled = false;
     hdev->started = false;
     memory_listener_register(&hdev->memory_listener, &address_space_memory);
     QLIST_INSERT_HEAD(&vhost_devices, hdev, entry);
@@ -1571,6 +1577,13 @@ void vhost_dev_disable_notifiers(struct vhost_dev *hdev, VirtIODevice *vdev)
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     int i, r;
 
+    if (hdev->sw_lm_enabled) {
+        /* We've been called after migration is completed, so no need to
+           disable it again
+        */
+        return;
+    }
+
     for (i = 0; i < hdev->nvqs; ++i) {
         r = virtio_bus_set_host_notifier(VIRTIO_BUS(qbus), hdev->vq_index + i,
                                          false);
-- 
2.18.4

