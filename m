Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4130F9B8
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbhBDRac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:30:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238456AbhBDRZZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7+YO6T1R0kmKKdk9GhJcWQPpaLe0YYgd8d3NkF0BFAQ=;
        b=K5xb90v144s88Qfn1RJiBxc9th4t9ExyOT+r8FhgGnwss1qyirtAZtwgRD8QdSotEBegue
        QYs6K99GBVOjQSwGt68OpMGmExLwPGRm0KF5cfQ9rzPzQL+sEQERt6WzqN2q7D7nCVNRXL
        zxRGg5S+pPWYVg/RftblVqApYGUeTQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-8u2JPyhdOZiXujlP6p79jg-1; Thu, 04 Feb 2021 12:23:57 -0500
X-MC-Unique: 8u2JPyhdOZiXujlP6p79jg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7284100C612;
        Thu,  4 Feb 2021 17:23:55 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EB075D6D7;
        Thu,  4 Feb 2021 17:23:53 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 09/13] vhost/vdpa: remove vhost_vdpa_config_validate()
Date:   Thu,  4 Feb 2021 18:22:26 +0100
Message-Id: <20210204172230.85853-10-sgarzare@redhat.com>
In-Reply-To: <20210204172230.85853-1-sgarzare@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_config() and set_config() callbacks in the 'struct vdpa_config_ops'
usually already validated the inputs. Also now they can return an error,
so we don't need to validate them here anymore.

Let's use the return value of these callbacks and return it in case of
error in vhost_vdpa_get_config() and vhost_vdpa_set_config().

Originally-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e..d61e779000a8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -185,51 +185,35 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
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
 	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
+	long ret;
 	u8 *buf;
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 	buf = kvzalloc(config.len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	vdpa_get_config(vdpa, config.off, buf, config.len);
+	ret = vdpa_get_config(vdpa, config.off, buf, config.len);
+	if (ret)
+		goto out;
 
 	if (copy_to_user(c->buf, buf, config.len)) {
-		kvfree(buf);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto out;
 	}
 
+out:
 	kvfree(buf);
-	return 0;
+	return ret;
 }
 
 static long vhost_vdpa_set_config(struct vhost_vdpa *v,
@@ -239,21 +223,22 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
+	long ret;
 	u8 *buf;
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 
 	buf = vmemdup_user(c->buf, config.len);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	ops->set_config(vdpa, config.off, buf, config.len);
+	ret = ops->set_config(vdpa, config.off, buf, config.len);
 
 	kvfree(buf);
-	return 0;
+	return ret;
 }
 
 static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
-- 
2.29.2

