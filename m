Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8CA2DBB9B
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 07:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgLPGv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 01:51:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbgLPGv1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 01:51:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iOLs1mRhbWmbX130uRUjMNaI33yU1zNB3Qa1UK/ynRE=;
        b=GA8gDxDL2iRKsOJ3LJgPmHKdZCrYWA0xRk1rrDsCpwM4HU++7GuTLXaGZ6IAB5SzAR95GF
        10u2NV2OQOBFYqFNePRI8RGS8yBfzZCk8sBX9BbuRJRk1JNunRULZOiihzlAjDb4kEWIj/
        XwTUDNlsrmZNVx3rgA+gVxbzYcwH6Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-LmaTXx_lP6iuddb6DkuyHQ-1; Wed, 16 Dec 2020 01:49:57 -0500
X-MC-Unique: LmaTXx_lP6iuddb6DkuyHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C15D180A09E;
        Wed, 16 Dec 2020 06:49:56 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D4C610013C1;
        Wed, 16 Dec 2020 06:49:49 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 12/21] vhost-vdpa: introduce uAPI to get the number of virtqueue groups
Date:   Wed, 16 Dec 2020 14:48:09 +0800
Message-Id: <20201216064818.48239-13-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Follows the vDPA support for multiple address spaces, this patch
introduce uAPI for the userspace to know the number of virtqueue
groups supported by the vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 4 ++++
 include/uapi/linux/vhost.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 060d5b5b7e64..1ba5901b28e7 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -536,6 +536,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_VRING_NUM:
 		r = vhost_vdpa_get_vring_num(v, argp);
 		break;
+	case VHOST_VDPA_GET_GROUP_NUM:
+		r = copy_to_user(argp, &v->vdpa->ngroups,
+				 sizeof(v->vdpa->ngroups));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 59c6c0fbaba1..8a4e6e426bbf 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -145,4 +145,7 @@
 /* Get the valid iova range */
 #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
 					     struct vhost_vdpa_iova_range)
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x79, unsigned int)
+
 #endif
-- 
2.25.1

