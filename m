Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E986F307875
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhA1Ooq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:44:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231908AbhA1OoI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:44:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611844962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEbif7/ADZLMGVwqcPthCfeKHX7VDIqnCprYX3mORNQ=;
        b=VtkF/p3oHNSF7/5lQHgWh2NsSYH3ZrcD5tTxLZ6U9i9HiKkcanmZEe6aj98k94rYvQxVlU
        ys61GGONL2YEVQdcsHo10avnvgVU8ZWpAZ11pzio1Ib5b2oGZyd5eq7VV8GcPouo8mHt7H
        jU9eDoF+Dyx/eGah2e6amrnfREeVPJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-DNeStv0DNkC0ZZFM2w-a-Q-1; Thu, 28 Jan 2021 09:42:41 -0500
X-MC-Unique: DNeStv0DNkC0ZZFM2w-a-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B10EE1800D41;
        Thu, 28 Jan 2021 14:42:39 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-219.ams2.redhat.com [10.36.113.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9746D62686;
        Thu, 28 Jan 2021 14:42:35 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC v2 07/10] vdpa: Remove the restriction that only supports virtio-net devices
Date:   Thu, 28 Jan 2021 15:41:24 +0100
Message-Id: <20210128144127.113245-8-sgarzare@redhat.com>
In-Reply-To: <20210128144127.113245-1-sgarzare@redhat.com>
References: <20210128144127.113245-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

With VDUSE, we should be able to support all kinds of virtio devices.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e..28624cbfe6dd 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -185,26 +185,6 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	return 0;
 }
 
-static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
-				      struct vhost_vdpa_config *c)
-{
-	long size = 0;
-
-	switch (v->virtio_id) {
-	case VIRTIO_ID_NET:
-		size = sizeof(struct virtio_net_config);
-		break;
-	}
-
-	if (c->len == 0)
-		return -EINVAL;
-
-	if (c->len > size - c->off)
-		return -E2BIG;
-
-	return 0;
-}
-
 static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 				  struct vhost_vdpa_config __user *c)
 {
@@ -215,7 +195,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 	buf = kvzalloc(config.len, GFP_KERNEL);
 	if (!buf)
@@ -243,7 +223,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 
 	buf = vmemdup_user(c->buf, config.len);
@@ -1021,10 +1001,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
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

