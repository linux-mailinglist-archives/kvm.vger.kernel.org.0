Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5732D430
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241339AbhCDN3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:29:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233758AbhCDN24 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614864450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U25hfNafb9SuM5dJFfJmewNpYbdjseyyxBquOrBCTHM=;
        b=U9XOFaPixZ2WdhZIirGXv8lTq8BTIIE5Hv40PA6wGI3HhxJL5G393G76pzd84JN+uBUTbj
        jOihn1OQAO5HdOAQta5NN8WgYMZCVsj1cstZ18Hb9Jis7JPvAFvlCZRj82rQ5EZj0aCUtT
        NISWNmOVLkWry6lT84f0kTrROLpQFZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-P_KvLWMVMT21oGPPTfUxxw-1; Thu, 04 Mar 2021 08:27:26 -0500
X-MC-Unique: P_KvLWMVMT21oGPPTfUxxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1B4D800D53;
        Thu,  4 Mar 2021 13:27:25 +0000 (UTC)
Received: from gondolin.redhat.com (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D3C5175BD;
        Thu,  4 Mar 2021 13:27:24 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFC 1/2] virtio/s390: add parameter for minimum revision
Date:   Thu,  4 Mar 2021 14:27:14 +0100
Message-Id: <20210304132715.1587211-2-cohuck@redhat.com>
In-Reply-To: <20210304132715.1587211-1-cohuck@redhat.com>
References: <20210304132715.1587211-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We use transport revisions in virtio-ccw for introducing new commands
etc.; revision 1 denotes operating according to the standard. Legacy
devices do not understand the command to set a revision; for those, we
presume to operate at revision 0.

Add a parameter min_revision to be able to actively restrict use of
old transport revisions. In particular, setting a minimum revision
of 1 makes our driver act as a non-transitional driver.

With the default min_revision of 0, we continue to act as a
transitional driver.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/virtio/virtio_ccw.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 54e686dca6de..0d3971dbc109 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -34,6 +34,16 @@
 #include <asm/isc.h>
 #include <asm/airq.h>
 
+/*
+ * Provide a knob to turn off support for older revisions. This is useful
+ * if we want to act as a non-transitional virtio device driver: requiring
+ * a minimum revision of 1 turns off support for legacy devices.
+ */
+static int min_revision;
+
+module_param(min_revision, int, 0444);
+MODULE_PARM_DESC(min_revision, "minimum transport revision to accept");
+
 /*
  * virtio related functions
  */
@@ -1271,7 +1281,10 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 			else
 				vcdev->revision--;
 		}
-	} while (ret == -EOPNOTSUPP);
+	} while (vcdev->revision >= min_revision && ret == -EOPNOTSUPP);
+
+	if (ret == -EOPNOTSUPP && vcdev->revision < min_revision)
+		ret = -EINVAL;
 
 	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 	ccw_device_dma_free(vcdev->cdev, rev, sizeof(*rev));
@@ -1315,8 +1328,12 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 	vcdev->vdev.id.device = cdev->id.cu_model;
 
 	ret = virtio_ccw_set_transport_rev(vcdev);
-	if (ret)
+	if (ret) {
+		dev_warn(&cdev->dev,
+			 "Could not set a supported transport revision: %d\n",
+			 ret);
 		goto out_free;
+	}
 
 	ret = register_virtio_device(&vcdev->vdev);
 	if (ret) {
-- 
2.26.2

