Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F42BB45A
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbgKTSvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:51:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731980AbgKTSvt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hB04k6BmQFwa3NAoUh0c6SZfxRFuR9AWa1v2aVbfxk4=;
        b=ZjWmDbqbqGO48Xuf1lrA6/si62igtW/LfBy9BSaw0X3g2WdeHrLumUWw3qIBA6MS8KJNjX
        ZmL55X71GT4vD8H0tSLeOEIL4y0tdBbStkqfZvH71jcBKhf8KSxsIOX9PH/vrESmeSKQpB
        P588+IZuKZHHeZlC9gCb5SdYhAWQZRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-ZCnzaR28NEuQleuWtg2vfQ-1; Fri, 20 Nov 2020 13:51:46 -0500
X-MC-Unique: ZCnzaR28NEuQleuWtg2vfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 671DD1842159;
        Fri, 20 Nov 2020 18:51:43 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26B075C1D5;
        Fri, 20 Nov 2020 18:51:30 +0000 (UTC)
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
Subject: [RFC PATCH 02/27] vhost: Add device callback in vhost_migration_log
Date:   Fri, 20 Nov 2020 19:50:40 +0100
Message-Id: <20201120185105.279030-3-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows code to reuse the logic to not to re-enable or re-disable
migration mechanisms. Code works the same way as before.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 2bd8cdf893..2adb2718c1 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -862,7 +862,9 @@ err_features:
     return r;
 }
 
-static int vhost_migration_log(MemoryListener *listener, bool enable)
+static int vhost_migration_log(MemoryListener *listener,
+                               bool enable,
+                               int (*device_cb)(struct vhost_dev *, bool))
 {
     struct vhost_dev *dev = container_of(listener, struct vhost_dev,
                                          memory_listener);
@@ -877,14 +879,14 @@ static int vhost_migration_log(MemoryListener *listener, bool enable)
 
     r = 0;
     if (!enable) {
-        r = vhost_dev_set_log(dev, false);
+        r = device_cb(dev, false);
         if (r < 0) {
             goto check_dev_state;
         }
         vhost_log_put(dev, false);
     } else {
         vhost_dev_log_resize(dev, vhost_get_log_size(dev));
-        r = vhost_dev_set_log(dev, true);
+        r = device_cb(dev, true);
         if (r < 0) {
             goto check_dev_state;
         }
@@ -916,7 +918,7 @@ static void vhost_log_global_start(MemoryListener *listener)
 {
     int r;
 
-    r = vhost_migration_log(listener, true);
+    r = vhost_migration_log(listener, true, vhost_dev_set_log);
     if (r < 0) {
         abort();
     }
@@ -926,7 +928,7 @@ static void vhost_log_global_stop(MemoryListener *listener)
 {
     int r;
 
-    r = vhost_migration_log(listener, false);
+    r = vhost_migration_log(listener, false, vhost_dev_set_log);
     if (r < 0) {
         abort();
     }
-- 
2.18.4

