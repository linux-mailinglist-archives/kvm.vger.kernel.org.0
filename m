Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B463C2BB45B
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732001AbgKTSwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:52:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731397AbgKTSwA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4varrbTkFQFU3BGiSDv77OV+Am6FgvunCFxXqhYibgk=;
        b=TnUoj5tlsNT0shyl+zdVVBGZ/18D3iyeTOEN8LWCVhHzNSHp8id6wWT0zq73779kJ3AkPZ
        oemY6TirrHp4RV97AAtIy187A48jnRsZ1WW/ABNyNQU1SG7vdTgmW27QtsjVx7HDNgQYb0
        KhzHcyp04YOHLZuvuVYfuj6ezyyuT+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-icKHBA9mMzOymkuJgqFU_Q-1; Fri, 20 Nov 2020 13:51:55 -0500
X-MC-Unique: icKHBA9mMzOymkuJgqFU_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA084107AD30;
        Fri, 20 Nov 2020 18:51:52 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B5435C1D5;
        Fri, 20 Nov 2020 18:51:43 +0000 (UTC)
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
Subject: [RFC PATCH 03/27] vhost: Move log resize/put to vhost_dev_set_log
Date:   Fri, 20 Nov 2020 19:50:41 +0100
Message-Id: <20201120185105.279030-4-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Software assisted live migration does not allocate vhost log.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 2adb2718c1..9cbd52a7f1 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -828,6 +828,10 @@ static int vhost_dev_set_log(struct vhost_dev *dev, bool enable_log)
     int r, i, idx;
     hwaddr addr;
 
+    if (enable_log) {
+        vhost_dev_log_resize(dev, vhost_get_log_size(dev));
+    }
+
     r = vhost_dev_set_features(dev, enable_log);
     if (r < 0) {
         goto err_features;
@@ -850,6 +854,10 @@ static int vhost_dev_set_log(struct vhost_dev *dev, bool enable_log)
             goto err_vq;
         }
     }
+
+    if (!enable_log) {
+        vhost_log_put(dev, false);
+    }
     return 0;
 err_vq:
     for (; i >= 0; --i) {
@@ -877,22 +885,8 @@ static int vhost_migration_log(MemoryListener *listener,
         return 0;
     }
 
-    r = 0;
-    if (!enable) {
-        r = device_cb(dev, false);
-        if (r < 0) {
-            goto check_dev_state;
-        }
-        vhost_log_put(dev, false);
-    } else {
-        vhost_dev_log_resize(dev, vhost_get_log_size(dev));
-        r = device_cb(dev, true);
-        if (r < 0) {
-            goto check_dev_state;
-        }
-    }
+    r = device_cb(dev, enable);
 
-check_dev_state:
     dev->log_enabled = enable;
     /*
      * vhost-user-* devices could change their state during log
-- 
2.18.4

