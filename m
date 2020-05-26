Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249E11E1EB1
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 11:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgEZJgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 05:36:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30416 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728746AbgEZJgh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 05:36:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590485796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N9CrJGv37BpytimFY2SmZJooBun68CG0VTdXjYuGNU0=;
        b=PWR7Cth9u07JrBgfSp56LV8VnaHP7N0mMke59WoSm7H16g3T8NJJlZgJcVELktaM9iIpmQ
        gInkGf/Pi55RaK6Oxy3TK4cdcwc2rf7QzfXtUM30Y3ee6jAMjG2Z2VpGnuOFiO4aMs3dmG
        SYWoMWDt5iOks2ltqcL55g8xKO6g5lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-LiCUBOrPOJ2m6HPSepfNzQ-1; Tue, 26 May 2020 05:36:34 -0400
X-MC-Unique: LiCUBOrPOJ2m6HPSepfNzQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46F80100A8F2;
        Tue, 26 May 2020 09:36:33 +0000 (UTC)
Received: from localhost (ovpn-113-77.ams2.redhat.com [10.36.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D96596EF8C;
        Tue, 26 May 2020 09:36:32 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] s390/virtio: remove unused pm callbacks
Date:   Tue, 26 May 2020 11:36:29 +0200
Message-Id: <20200526093629.257649-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support for hibernation on s390 has been recently been removed with
commit 394216275c7d ("s390: remove broken hibernate / power management
support"), no need to keep unused code around.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/virtio/virtio_ccw.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 957889a42d2e..5730572b52cd 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1372,27 +1372,6 @@ static struct ccw_device_id virtio_ids[] = {
 	{},
 };
 
-#ifdef CONFIG_PM_SLEEP
-static int virtio_ccw_freeze(struct ccw_device *cdev)
-{
-	struct virtio_ccw_device *vcdev = dev_get_drvdata(&cdev->dev);
-
-	return virtio_device_freeze(&vcdev->vdev);
-}
-
-static int virtio_ccw_restore(struct ccw_device *cdev)
-{
-	struct virtio_ccw_device *vcdev = dev_get_drvdata(&cdev->dev);
-	int ret;
-
-	ret = virtio_ccw_set_transport_rev(vcdev);
-	if (ret)
-		return ret;
-
-	return virtio_device_restore(&vcdev->vdev);
-}
-#endif
-
 static struct ccw_driver virtio_ccw_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
@@ -1405,11 +1384,6 @@ static struct ccw_driver virtio_ccw_driver = {
 	.set_online = virtio_ccw_online,
 	.notify = virtio_ccw_cio_notify,
 	.int_class = IRQIO_VIR,
-#ifdef CONFIG_PM_SLEEP
-	.freeze = virtio_ccw_freeze,
-	.thaw = virtio_ccw_restore,
-	.restore = virtio_ccw_restore,
-#endif
 };
 
 static int __init pure_hex(char **cp, unsigned int *val, int min_digit,
-- 
2.25.4

