Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E744331C85D
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhBPJs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:48:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230060AbhBPJru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:47:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ULZ9mxEQQ5U088rlkJrSxlHpglsfEQ5hn0PApjo9dE8=;
        b=U8lPKLEhsAvIy5Qo4aWfWBaf8DhJiGvwPG7c/kCPPtVzUL7lzJLuKp53REfBHlJWfzVF8g
        VvAKm76a3xCLWA/joCZUMw220oET3p2RXmTdLxVQGf7LJBNZVP+gJ+eIte/6YGVXK+y3sI
        FC+9o2CCDXIA46F2A3JrL8FrJER4EJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-cX6kWrRxOIm8XKId-k-NiA-1; Tue, 16 Feb 2021 04:46:12 -0500
X-MC-Unique: cX6kWrRxOIm8XKId-k-NiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DB02801965;
        Tue, 16 Feb 2021 09:46:11 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B745C5C6AB;
        Tue, 16 Feb 2021 09:46:09 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 09/10] vhost/vdpa: use get_config_size callback in vhost_vdpa_config_validate()
Date:   Tue, 16 Feb 2021 10:44:53 +0100
Message-Id: <20210216094454.82106-10-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's use the new 'get_config_size()' callback available instead of
using the 'virtio_id' to get the size of the device config space.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 544f8582a42b..21eea2be5afa 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -188,13 +188,8 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 static ssize_t vhost_vdpa_config_validate(struct vhost_vdpa *v,
 					  struct vhost_vdpa_config *c)
 {
-	u32 size = 0;
-
-	switch (v->virtio_id) {
-	case VIRTIO_ID_NET:
-		size = sizeof(struct virtio_net_config);
-		break;
-	}
+	struct vdpa_device *vdpa = v->vdpa;
+	u32 size = vdpa->config->get_config_size(vdpa);
 
 	if (c->len == 0)
 		return -EINVAL;
-- 
2.29.2

