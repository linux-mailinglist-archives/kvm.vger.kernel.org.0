Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2678331C852
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBPJrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:47:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229925AbhBPJqj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgJXmECmOauhfYDJPw4bn7OxQRQZ97Yc1PJaarzr/ps=;
        b=hoDqqolm4UfyS3nv8CooXswFswMsOF159g5b0hlFHIVXAiJE1vaf3Q+Tv8JxGhJ0dQAtiv
        6sDMdUGFEKKyM/yXoiJIbYpibTksZxyyIDnv1N/PAb02J+RKhrw449PyiPGDwlcDW7+8RV
        DlGtuEryGZen25NdIZFbyFbw5A82OuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-VmUvdcoDMjK1N8CpeqbGyA-1; Tue, 16 Feb 2021 04:45:11 -0500
X-MC-Unique: VmUvdcoDMjK1N8CpeqbGyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF698100AA21;
        Tue, 16 Feb 2021 09:45:09 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B2F35D9C0;
        Tue, 16 Feb 2021 09:45:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 03/10] vdpa: add vdpa_set_config() helper
Date:   Tue, 16 Feb 2021 10:44:47 +0100
Message-Id: <20210216094454.82106-4-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a function similar to vpda_get_config() to check the
'offset' and 'len' parameters, call the set_config() device callback,
and return the amount of bytes written.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vdpa.h |  2 ++
 drivers/vdpa/vdpa.c  | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 8a679c98f8b1..562fcd14f4b5 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -334,6 +334,8 @@ static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
 
 int vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
 		    void *buf, unsigned int len);
+int vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
+		    const void *buf, unsigned int len);
 
 /**
  * vdpa_mgmtdev_ops - vdpa device ops
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 9ed6c779c63c..825afc690a7e 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -86,6 +86,22 @@ int vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(vdpa_get_config);
 
+int vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
+		    const void *buf, unsigned int len)
+{
+	const struct vdpa_config_ops *ops = vdev->config;
+	int bytes_set;
+
+	bytes_set = vdpa_config_size_wrap(vdev, offset, len);
+	if (bytes_set <= 0)
+		return bytes_set;
+
+	ops->set_config(vdev, offset, buf, bytes_set);
+
+	return bytes_set;
+}
+EXPORT_SYMBOL_GPL(vdpa_set_config);
+
 static void vdpa_release_dev(struct device *d)
 {
 	struct vdpa_device *vdev = dev_to_vdpa(d);
-- 
2.29.2

