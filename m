Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36363B4A23
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 23:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhFYV3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 17:29:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229940AbhFYV3E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 17:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624656402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U5JMFqwvnJzjcO6eOQllRPvApgbp6PzTgwXB8WE2yLw=;
        b=fYAE475nHOEmBseyxIJ2AeXEPAi2kIORBJYc/E1TKbaq4gw+U137lpoACVpzlyKIQ1sKzl
        vt00M6alpR3yh+CP37BYRCLYhJs9b8yrQWv0ejizfxLX4DXpR0ERT9jjWKCz8Gl5podh7K
        3yEbu6Hj3HPbG571gECjNaPYc2glBAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-QZHdCQNiNXuqdRC_v7fxhQ-1; Fri, 25 Jun 2021 17:26:38 -0400
X-MC-Unique: QZHdCQNiNXuqdRC_v7fxhQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B735618A0765;
        Fri, 25 Jun 2021 21:26:37 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-112-106.phx2.redhat.com [10.3.112.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA68869290;
        Fri, 25 Jun 2021 21:26:11 +0000 (UTC)
Subject: [PATCH] vfio/mtty: Enforce available_instances
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kwankhede@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@nvidia.com
Date:   Fri, 25 Jun 2021 15:26:11 -0600
Message-ID: <162465624894.3338367.12935940647049917981.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sample mtty mdev driver doesn't actually enforce the number of
device instances it claims are available.  Implement this properly.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Applies to vfio next branch + Jason's atomic conversion

 samples/vfio-mdev/mtty.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index ffbaf07a17ea..8b26fecc4afe 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -144,7 +144,7 @@ struct mdev_state {
 	int nr_ports;
 };
 
-static atomic_t mdev_used_ports;
+static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
 
 static const struct file_operations vd_fops = {
 	.owner          = THIS_MODULE,
@@ -707,11 +707,20 @@ static int mtty_probe(struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state;
 	int nr_ports = mdev_get_type_group_id(mdev) + 1;
+	int avail_ports = atomic_read(&mdev_avail_ports);
 	int ret;
 
+	do {
+		if (avail_ports < nr_ports)
+			return -ENOSPC;
+	} while (!atomic_try_cmpxchg(&mdev_avail_ports,
+				     &avail_ports, avail_ports - nr_ports));
+
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
-	if (mdev_state == NULL)
+	if (mdev_state == NULL) {
+		atomic_add(nr_ports, &mdev_avail_ports);
 		return -ENOMEM;
+	}
 
 	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
 
@@ -724,6 +733,7 @@ static int mtty_probe(struct mdev_device *mdev)
 
 	if (mdev_state->vconfig == NULL) {
 		kfree(mdev_state);
+		atomic_add(nr_ports, &mdev_avail_ports);
 		return -ENOMEM;
 	}
 
@@ -735,9 +745,9 @@ static int mtty_probe(struct mdev_device *mdev)
 	ret = vfio_register_group_dev(&mdev_state->vdev);
 	if (ret) {
 		kfree(mdev_state);
+		atomic_add(nr_ports, &mdev_avail_ports);
 		return ret;
 	}
-	atomic_add(mdev_state->nr_ports, &mdev_used_ports);
 
 	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
@@ -746,12 +756,13 @@ static int mtty_probe(struct mdev_device *mdev)
 static void mtty_remove(struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
+	int nr_ports = mdev_state->nr_ports;
 
-	atomic_sub(mdev_state->nr_ports, &mdev_used_ports);
 	vfio_unregister_group_dev(&mdev_state->vdev);
 
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
+	atomic_add(nr_ports, &mdev_avail_ports);
 }
 
 static int mtty_reset(struct mdev_state *mdev_state)
@@ -1271,8 +1282,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
 {
 	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
 
-	return sprintf(buf, "%d\n",
-		       (MAX_MTTYS - atomic_read(&mdev_used_ports)) / ports);
+	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) / ports);
 }
 
 static MDEV_TYPE_ATTR_RO(available_instances);


