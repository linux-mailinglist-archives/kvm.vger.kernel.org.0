Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8925F8B1
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 12:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgIGKoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 06:44:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35282 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728622AbgIGKn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 06:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599475437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c1vAH2sOnIecyBuC1bgws2niE0JgFrbZ244nIj8c+DU=;
        b=c+5E/3yDO70ZbiPkNa4L/2zeH2iwZBcd7wMROQUnARLBqwCuoRIH1UmMPM9MaCyL6hygbc
        /gKJh82BFaNuxRl/5qRvxwWHSpVbUVADcKZ4Q86TFfCxKrtESJvR0mnPyo1Wvcb10B72Sf
        om54B/+N5s8aC/YlCJ5Iy8E+eQPqFIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-uykzQjHlNiu2lD-lNSLY4w-1; Mon, 07 Sep 2020 06:43:54 -0400
X-MC-Unique: uykzQjHlNiu2lD-lNSLY4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA64E1084CA6;
        Mon,  7 Sep 2020 10:43:52 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-108.pek2.redhat.com [10.72.12.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BEAA60C0F;
        Mon,  7 Sep 2020 10:43:45 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lulu@redhat.com, Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] vhost-vdpa: fix backend feature ioctls
Date:   Mon,  7 Sep 2020 18:43:43 +0800
Message-Id: <20200907104343.31141-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 653055b9acd4 ("vhost-vdpa: support get/set backend features")
introduces two malfunction backend features ioctls:

1) the ioctls was blindly added to vring ioctl instead of vdpa device
   ioctl
2) vhost_set_backend_features() was called when dev mutex has already
   been held which will lead a deadlock

This patch fixes the above issues.

Cc: Eli Cohen <elic@nvidia.com>
Reported-by: Zhu Lingshan <lingshan.zhu@intel.com>
Fixes: 653055b9acd4 ("vhost-vdpa: support get/set backend features")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3fab94f88894..796fe979f997 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -353,8 +353,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	struct vdpa_callback cb;
 	struct vhost_virtqueue *vq;
 	struct vhost_vring_state s;
-	u64 __user *featurep = argp;
-	u64 features;
 	u32 idx;
 	long r;
 
@@ -381,18 +379,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 
 		vq->last_avail_idx = vq_state.avail_index;
 		break;
-	case VHOST_GET_BACKEND_FEATURES:
-		features = VHOST_VDPA_BACKEND_FEATURES;
-		if (copy_to_user(featurep, &features, sizeof(features)))
-			return -EFAULT;
-		return 0;
-	case VHOST_SET_BACKEND_FEATURES:
-		if (copy_from_user(&features, featurep, sizeof(features)))
-			return -EFAULT;
-		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
-			return -EOPNOTSUPP;
-		vhost_set_backend_features(&v->vdev, features);
-		return 0;
 	}
 
 	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
@@ -440,8 +426,20 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	struct vhost_vdpa *v = filep->private_data;
 	struct vhost_dev *d = &v->vdev;
 	void __user *argp = (void __user *)arg;
+	u64 __user *featurep = argp;
+	u64 features;
 	long r;
 
+	if (cmd == VHOST_SET_BACKEND_FEATURES) {
+		r = copy_from_user(&features, featurep, sizeof(features));
+		if (r)
+			return r;
+		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
+			return -EOPNOTSUPP;
+		vhost_set_backend_features(&v->vdev, features);
+		return 0;
+	}
+
 	mutex_lock(&d->mutex);
 
 	switch (cmd) {
@@ -476,6 +474,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_SET_CONFIG_CALL:
 		r = vhost_vdpa_set_config_call(v, argp);
 		break;
+	case VHOST_GET_BACKEND_FEATURES:
+		features = VHOST_VDPA_BACKEND_FEATURES;
+		r = copy_to_user(featurep, &features, sizeof(features));
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
-- 
2.20.1

