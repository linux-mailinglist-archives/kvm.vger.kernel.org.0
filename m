Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C492BB45E
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgKTSwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:52:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731381AbgKTSwQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1xuNkaaPUcrhHGAqp8H+FXDGPjhfJDXls907UFvbJo=;
        b=g54XMXCCRdOh7wxzq8edRmtDXM/MfH/UxkG1FkPv+qHs3qMX+qVCkqfcL3ZedSEHnHmi2l
        RopbTdT5fFDH++GYZjotreCCN4ULRN023dNRp5fS3MVtulYLqt/oSZrorl9HgO/JRLAh3p
        THEq89Jrqgl+qJ1x1y9b4HGRT2e57c4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-BqEhkUiMPp2_cG8WPQgPOg-1; Fri, 20 Nov 2020 13:52:13 -0500
X-MC-Unique: BqEhkUiMPp2_cG8WPQgPOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38DCE8030BC;
        Fri, 20 Nov 2020 18:52:10 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DEE05C1D5;
        Fri, 20 Nov 2020 18:51:52 +0000 (UTC)
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
Subject: [RFC PATCH 04/27] vhost: add vhost_kernel_set_vring_enable
Date:   Fri, 20 Nov 2020 19:50:42 +0100
Message-Id: <20201120185105.279030-5-eperezma@redhat.com>
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
 hw/virtio/vhost-backend.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
index 222bbcc62d..317f1f96fa 100644
--- a/hw/virtio/vhost-backend.c
+++ b/hw/virtio/vhost-backend.c
@@ -201,6 +201,34 @@ static int vhost_kernel_get_vq_index(struct vhost_dev *dev, int idx)
     return idx - dev->vq_index;
 }
 
+static int vhost_kernel_set_vq_enable(struct vhost_dev *dev, unsigned idx,
+                                      bool enable)
+{
+    struct vhost_vring_file file = {
+        .index = idx,
+    };
+
+    if (!enable) {
+        file.fd = -1; /* Pass -1 to unbind from file. */
+    } else {
+        struct vhost_net *vn_dev = container_of(dev, struct vhost_net, dev);
+        file.fd = vn_dev->backend;
+    }
+
+    return vhost_kernel_net_set_backend(dev, &file);
+}
+
+static int vhost_kernel_set_vring_enable(struct vhost_dev *dev, int enable)
+{
+    int i;
+
+    for (i = 0; i < dev->nvqs; ++i) {
+        vhost_kernel_set_vq_enable(dev, i, enable);
+    }
+
+    return 0;
+}
+
 #ifdef CONFIG_VHOST_VSOCK
 static int vhost_kernel_vsock_set_guest_cid(struct vhost_dev *dev,
                                             uint64_t guest_cid)
@@ -317,6 +345,7 @@ static const VhostOps kernel_ops = {
         .vhost_set_owner = vhost_kernel_set_owner,
         .vhost_reset_device = vhost_kernel_reset_device,
         .vhost_get_vq_index = vhost_kernel_get_vq_index,
+        .vhost_set_vring_enable = vhost_kernel_set_vring_enable,
 #ifdef CONFIG_VHOST_VSOCK
         .vhost_vsock_set_guest_cid = vhost_kernel_vsock_set_guest_cid,
         .vhost_vsock_set_running = vhost_kernel_vsock_set_running,
-- 
2.18.4

