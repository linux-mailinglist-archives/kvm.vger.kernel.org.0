Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1678731C859
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhBPJrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:47:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhBPJrM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:47:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Z8IX9Mkudp3/Hl+TsF7v2vmeC6C7k+WY1X8lrddSYc=;
        b=MrBaGVQEpt+o3LyQZlMgS/efKRwwIRhBhlhdwadknDofr1Ck7WvRFHQpHbSeX5vBKf+Y8u
        E9/GBULpicOEVRDueIvxiV7lJNTIteFqjcdhedue0P4G9wsktPvgybNDSIlkgmHiVxzRcs
        /I55l5msXMvzthMfb3Ky9MsE3zrwxXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-_DVXtfshNqq4q2UNYiJkjg-1; Tue, 16 Feb 2021 04:45:43 -0500
X-MC-Unique: _DVXtfshNqq4q2UNYiJkjg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85B091005501;
        Tue, 16 Feb 2021 09:45:42 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73552163F1;
        Tue, 16 Feb 2021 09:45:39 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 07/10] vhost/vdpa: use vdpa_set_config()
Date:   Tue, 16 Feb 2021 10:44:51 +0100
Message-Id: <20210216094454.82106-8-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of calling the 'set_config' callback directly, we call the
new vdpa_set_config() helper which also checks the parameters.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e..cdd8f24168b2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -236,7 +236,6 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 				  struct vhost_vdpa_config __user *c)
 {
 	struct vdpa_device *vdpa = v->vdpa;
-	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
 	u8 *buf;
@@ -250,7 +249,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	ops->set_config(vdpa, config.off, buf, config.len);
+	vdpa_set_config(vdpa, config.off, buf, config.len);
 
 	kvfree(buf);
 	return 0;
-- 
2.29.2

