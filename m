Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CF031C85B
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBPJsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:48:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhBPJrk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUO68bTCohFMIGXH82qxXbnohw7EihHHCgax44jVeHQ=;
        b=HuSw1D8Bc34sPEVU68ZQdqw2tVNsQDQvpxjQQpl0dC6PrRufdfdPBIcq9e5b3dKzHPjViz
        BM5kpW1dcVCKyAgcDNXEe1e8xXL9y+MCYwlweqhqRNh3/KYmohjtGgqRNWj5sl+v2rVtb+
        Jb1gtpjKfvJhILNOu7zJTGdFIym+xh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-nkQI-Q60Pt-r3dfjPIQN8w-1; Tue, 16 Feb 2021 04:46:10 -0500
X-MC-Unique: nkQI-Q60Pt-r3dfjPIQN8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76CD7107ACC7;
        Tue, 16 Feb 2021 09:46:09 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED4215C6AB;
        Tue, 16 Feb 2021 09:46:03 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 08/10] vhost/vdpa: allow user space to pass buffers bigger than config space
Date:   Tue, 16 Feb 2021 10:44:52 +0100
Message-Id: <20210216094454.82106-9-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vdpa_get_config() and vdpa_set_config() now are able to read/write
only the bytes available in the device configuration space, also if
the buffer provided is bigger than that.

Let's use this feature to allow the user space application to pass any
buffer. We limit the size of the internal bounce buffer allocated with
the device config size.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index cdd8f24168b2..544f8582a42b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -185,10 +185,10 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	return 0;
 }
 
-static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
-				      struct vhost_vdpa_config *c)
+static ssize_t vhost_vdpa_config_validate(struct vhost_vdpa *v,
+					  struct vhost_vdpa_config *c)
 {
-	long size = 0;
+	u32 size = 0;
 
 	switch (v->virtio_id) {
 	case VIRTIO_ID_NET:
@@ -199,10 +199,7 @@ static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
 	if (c->len == 0)
 		return -EINVAL;
 
-	if (c->len > size - c->off)
-		return -E2BIG;
-
-	return 0;
+	return min(c->len, size);
 }
 
 static long vhost_vdpa_get_config(struct vhost_vdpa *v,
@@ -211,19 +208,23 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
+	ssize_t config_size;
 	u8 *buf;
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
-		return -EINVAL;
-	buf = kvzalloc(config.len, GFP_KERNEL);
+
+	config_size = vhost_vdpa_config_validate(v, &config);
+	if (config_size <= 0)
+		return config_size;
+
+	buf = kvzalloc(config_size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	vdpa_get_config(vdpa, config.off, buf, config.len);
+	vdpa_get_config(vdpa, config.off, buf, config_size);
 
-	if (copy_to_user(c->buf, buf, config.len)) {
+	if (copy_to_user(c->buf, buf, config_size)) {
 		kvfree(buf);
 		return -EFAULT;
 	}
@@ -238,18 +239,21 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
+	ssize_t config_size;
 	u8 *buf;
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
-		return -EINVAL;
 
-	buf = vmemdup_user(c->buf, config.len);
+	config_size = vhost_vdpa_config_validate(v, &config);
+	if (config_size <= 0)
+		return config_size;
+
+	buf = vmemdup_user(c->buf, config_size);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	vdpa_set_config(vdpa, config.off, buf, config.len);
+	vdpa_set_config(vdpa, config.off, buf, config_size);
 
 	kvfree(buf);
 	return 0;
-- 
2.29.2

