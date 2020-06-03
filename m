Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0982C1ECE52
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 13:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgFCL1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 07:27:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40023 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726154AbgFCL1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 07:27:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591183659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VQzZGD05jnANKwSpBQAA3BytYLRzk4CX+8TzT6uKnxQ=;
        b=ZM8dOrhJVz1Tm2UA4dFkoPecPeRX80PF7eKI1CtKI9naXkK55iRy+zDYZEPfY30qqWSzsS
        YLpK+5JtIN4sZ5M42SZ5vNGDTl3hrMSWJLMwA/nSboKveSQ/ouXoAMY3DfJ99T+KEDa6d4
        QqhPdBecipgOGp7sTjbmUBulCUS69mA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-I22hqFETM_i9V5SXKsHqtw-1; Wed, 03 Jun 2020 07:27:36 -0400
X-MC-Unique: I22hqFETM_i9V5SXKsHqtw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77D321883608;
        Wed,  3 Jun 2020 11:27:35 +0000 (UTC)
Received: from localhost (ovpn-112-182.ams2.redhat.com [10.36.112.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C09B5C48E;
        Wed,  3 Jun 2020 11:27:34 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL v2 07/10] vfio-ccw: Refactor IRQ handlers
Date:   Wed,  3 Jun 2020 13:27:13 +0200
Message-Id: <20200603112716.332801-8-cohuck@redhat.com>
In-Reply-To: <20200603112716.332801-1-cohuck@redhat.com>
References: <20200603112716.332801-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

To simplify future expansion.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200505122745.53208-6-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_ops.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 22988d67b6bb..c3a74ab7bb86 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -387,17 +387,21 @@ static int vfio_ccw_mdev_get_region_info(struct vfio_region_info *info,
 
 static int vfio_ccw_mdev_get_irq_info(struct vfio_irq_info *info)
 {
-	if (info->index != VFIO_CCW_IO_IRQ_INDEX)
+	switch (info->index) {
+	case VFIO_CCW_IO_IRQ_INDEX:
+		info->count = 1;
+		info->flags = VFIO_IRQ_INFO_EVENTFD;
+		break;
+	default:
 		return -EINVAL;
-
-	info->count = 1;
-	info->flags = VFIO_IRQ_INFO_EVENTFD;
+	}
 
 	return 0;
 }
 
 static int vfio_ccw_mdev_set_irqs(struct mdev_device *mdev,
 				  uint32_t flags,
+				  uint32_t index,
 				  void __user *data)
 {
 	struct vfio_ccw_private *private;
@@ -407,7 +411,14 @@ static int vfio_ccw_mdev_set_irqs(struct mdev_device *mdev,
 		return -EINVAL;
 
 	private = dev_get_drvdata(mdev_parent_dev(mdev));
-	ctx = &private->io_trigger;
+
+	switch (index) {
+	case VFIO_CCW_IO_IRQ_INDEX:
+		ctx = &private->io_trigger;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
 	case VFIO_IRQ_SET_DATA_NONE:
@@ -579,7 +590,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 			return ret;
 
 		data = (void __user *)(arg + minsz);
-		return vfio_ccw_mdev_set_irqs(mdev, hdr.flags, data);
+		return vfio_ccw_mdev_set_irqs(mdev, hdr.flags, hdr.index, data);
 	}
 	case VFIO_DEVICE_RESET:
 		return vfio_ccw_mdev_reset(mdev);
-- 
2.25.4

