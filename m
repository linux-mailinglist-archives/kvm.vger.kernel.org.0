Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A0B31C851
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBPJqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:46:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhBPJqj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sL2HoPks3VzKpFvhRVHLVH8gFjTz1o9yXUZfovhuAAk=;
        b=YwsF7jVw++VFQA6tE+GgpiaN2vSYiNvQSK7D1pD2VxI0raz88mHERQ6eD/ARGcDiOPDQgG
        rN0H2/sTpPbFbMndGIVrnKukWoU/KMuYVgNHY5niFT61wvRacMbk8MeAm5h66Pg4TXrrq9
        QfQUnd5a2OlbiwyT3si5+YNsC+DKEAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-lntx5zuyNCyODqqUmRpAag-1; Tue, 16 Feb 2021 04:45:09 -0500
X-MC-Unique: lntx5zuyNCyODqqUmRpAag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4367E801989;
        Tue, 16 Feb 2021 09:45:08 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBCD45D9C0;
        Tue, 16 Feb 2021 09:45:06 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 02/10] vdpa: check vdpa_get_config() parameters and return bytes read
Date:   Tue, 16 Feb 2021 10:44:46 +0100
Message-Id: <20210216094454.82106-3-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now we have the 'get_config_size()' callback available, so we can
check that 'offset' and 'len' parameters are valid.

When these exceed boundaries, we limit the reading to the available
configuration space in the device, and we return the amount of bytes
read.

We also move vdpa_get_config() implementation in drivers/vdpa/vdpa.c,
since the function are growing.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vdpa.h | 16 ++--------------
 drivers/vdpa/vdpa.c  | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index fddf42b17573..8a679c98f8b1 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -332,20 +332,8 @@ static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
         return ops->set_features(vdev, features);
 }
 
-
-static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
-				   void *buf, unsigned int len)
-{
-        const struct vdpa_config_ops *ops = vdev->config;
-
-	/*
-	 * Config accesses aren't supposed to trigger before features are set.
-	 * If it does happen we assume a legacy guest.
-	 */
-	if (!vdev->features_valid)
-		vdpa_set_features(vdev, 0);
-	ops->get_config(vdev, offset, buf, len);
-}
+int vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
+		    void *buf, unsigned int len);
 
 /**
  * vdpa_mgmtdev_ops - vdpa device ops
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 3d997b389345..9ed6c779c63c 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -51,6 +51,41 @@ static struct bus_type vdpa_bus = {
 	.remove = vdpa_dev_remove,
 };
 
+static int vdpa_config_size_wrap(struct vdpa_device *vdev, unsigned int offset,
+				 unsigned int len)
+{
+	const struct vdpa_config_ops *ops = vdev->config;
+	unsigned int config_size = ops->get_config_size(vdev);
+
+	if (offset > config_size || len > config_size)
+		return -1;
+
+	return min(len, config_size - offset);
+}
+
+int vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
+		    void *buf, unsigned int len)
+{
+	const struct vdpa_config_ops *ops = vdev->config;
+	int bytes_get;
+
+	bytes_get = vdpa_config_size_wrap(vdev, offset, len);
+	if (bytes_get <= 0)
+		return bytes_get;
+
+	/*
+	 * Config accesses aren't supposed to trigger before features are set.
+	 * If it does happen we assume a legacy guest.
+	 */
+	if (!vdev->features_valid)
+		vdpa_set_features(vdev, 0);
+
+	ops->get_config(vdev, offset, buf, bytes_get);
+
+	return bytes_get;
+}
+EXPORT_SYMBOL_GPL(vdpa_get_config);
+
 static void vdpa_release_dev(struct device *d)
 {
 	struct vdpa_device *vdev = dev_to_vdpa(d);
-- 
2.29.2

