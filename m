Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38A30F9B3
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbhBDRZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:25:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238457AbhBDRZ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:25:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Ow8Ui/tFO/ZbkvTOqYO2hJWbYHjj15s4LcE1RVwnGY=;
        b=G+7J3irwKraUznUMhEGM5D04DQO2cH2pz+d16SSxmNM5juAsHbMtnXq+Ex8OabQKs3iOXU
        ZdsJYvMgfRaEj9vcqcP+hEku4bJsQjjb5nuZTncEgRjV99jJrj2hl1aS1Ba9sdGXvd3Nez
        y2Y82eGJl2X3h2OtZrCb25yMzZcwRnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-dyWXVz5TOyO19kX9PAThtQ-1; Thu, 04 Feb 2021 12:23:59 -0500
X-MC-Unique: dyWXVz5TOyO19kX9PAThtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B314801960;
        Thu,  4 Feb 2021 17:23:58 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12CB35D6D7;
        Thu,  4 Feb 2021 17:23:55 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 10/13] vhost/vdpa: Remove the restriction that only supports virtio-net devices
Date:   Thu,  4 Feb 2021 18:22:27 +0100
Message-Id: <20210204172230.85853-11-sgarzare@redhat.com>
In-Reply-To: <20210204172230.85853-1-sgarzare@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

Since the config checks are done by the vDPA drivers, we can remove the
virtio-net restriction and we should be able to support all kinds of
virtio devices.

<linux/virtio_net.h> is not needed anymore, but we need to include
<linux/slab.h> to avoid compilation failures.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d61e779000a8..3879b1ad12dd 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -16,12 +16,12 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/iommu.h>
 #include <linux/uuid.h>
 #include <linux/vdpa.h>
 #include <linux/nospec.h>
 #include <linux/vhost.h>
-#include <linux/virtio_net.h>
 
 #include "vhost.h"
 
@@ -1006,10 +1006,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int r;
 
-	/* Currently, we only accept the network devices. */
-	if (ops->get_device_id(vdpa) != VIRTIO_ID_NET)
-		return -ENOTSUPP;
-
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!v)
 		return -ENOMEM;
-- 
2.29.2

