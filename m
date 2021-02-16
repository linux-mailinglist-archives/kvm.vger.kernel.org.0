Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A021931C85F
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhBPJtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:49:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230081AbhBPJru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:47:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DqmUyCUnnwzMfzlfbC6vrvnV937tFThxMW/Rg8TVcvM=;
        b=Cz1gE34Ubg6zUA2ODCgpI4qgUdgWoCqE5N2yl5637S6YRDXKHaaDyqffyhpgjTZa8bRtKf
        dDxxRj1yI0eYVMcHF9hqQLuHrlQ04bKMa/1x1fZi4NE+xNl8nhE7yMXInrFqy3WiwlQfRT
        5dxE9Zn619WxsnwxTHYVAOVhhOVGfeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-EoGMOIL1PqOL3nSI57bJzQ-1; Tue, 16 Feb 2021 04:46:14 -0500
X-MC-Unique: EoGMOIL1PqOL3nSI57bJzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDC2B18A08BD;
        Tue, 16 Feb 2021 09:46:12 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81BDA63747;
        Tue, 16 Feb 2021 09:46:11 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 10/10] vhost/vdpa: return configuration bytes read and written to user space
Date:   Tue, 16 Feb 2021 10:44:54 +0100
Message-Id: <20210216094454.82106-11-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vdpa_get_config() and vdpa_set_config() now return the amount
of bytes read and written, so let's return them to the user space.

We also modify vhost_vdpa_config_validate() to return 0 (bytes read
or written) instead of an error, when the buffer length is 0.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 21eea2be5afa..b754c53171a7 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -191,9 +191,6 @@ static ssize_t vhost_vdpa_config_validate(struct vhost_vdpa *v,
 	struct vdpa_device *vdpa = v->vdpa;
 	u32 size = vdpa->config->get_config_size(vdpa);
 
-	if (c->len == 0)
-		return -EINVAL;
-
 	return min(c->len, size);
 }
 
@@ -204,6 +201,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
 	ssize_t config_size;
+	long ret;
 	u8 *buf;
 
 	if (copy_from_user(&config, c, size))
@@ -217,15 +215,18 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 	if (!buf)
 		return -ENOMEM;
 
-	vdpa_get_config(vdpa, config.off, buf, config_size);
-
-	if (copy_to_user(c->buf, buf, config_size)) {
-		kvfree(buf);
-		return -EFAULT;
+	ret = vdpa_get_config(vdpa, config.off, buf, config_size);
+	if (ret < 0) {
+		ret = -EFAULT;
+		goto out;
 	}
 
+	if (copy_to_user(c->buf, buf, config_size))
+		ret = -EFAULT;
+
+out:
 	kvfree(buf);
-	return 0;
+	return ret;
 }
 
 static long vhost_vdpa_set_config(struct vhost_vdpa *v,
@@ -235,6 +236,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
 	ssize_t config_size;
+	long ret;
 	u8 *buf;
 
 	if (copy_from_user(&config, c, size))
@@ -248,10 +250,12 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	vdpa_set_config(vdpa, config.off, buf, config_size);
+	ret = vdpa_set_config(vdpa, config.off, buf, config_size);
+	if (ret < 0)
+		ret = -EFAULT;
 
 	kvfree(buf);
-	return 0;
+	return ret;
 }
 
 static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
-- 
2.29.2

