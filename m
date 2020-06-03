Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C6D1ECE4C
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 13:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgFCL1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 07:27:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51408 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726123AbgFCL1g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 07:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591183654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agGbileAyveSVSjqQ0MWJ/AA8cD69ahdKkFpP9z6C9s=;
        b=jW1TkAdMSIhiVc1ucOfkdDdojgXJ6wBc2DnFYipCvV7VVFNoKSJ5PazVBi7bPqQQneyPI5
        njMZZEQvnQvZIG0Oc5pzsP1Z5YGRBfxaM2jOspsyQdLt3nPNFen1SP4izBAvlZWcJj+0Sj
        kdtB+9Uu525Iaa4yDORdbKoCjo+4hdE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-RAMeJjf6ODmNf1NCoDjfLw-1; Wed, 03 Jun 2020 07:27:32 -0400
X-MC-Unique: RAMeJjf6ODmNf1NCoDjfLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EF95107ACCA;
        Wed,  3 Jun 2020 11:27:31 +0000 (UTC)
Received: from localhost (ovpn-112-182.ams2.redhat.com [10.36.112.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A70FD6AD00;
        Wed,  3 Jun 2020 11:27:30 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL v2 05/10] vfio-ccw: Refactor the unregister of the async regions
Date:   Wed,  3 Jun 2020 13:27:11 +0200
Message-Id: <20200603112716.332801-6-cohuck@redhat.com>
In-Reply-To: <20200603112716.332801-1-cohuck@redhat.com>
References: <20200603112716.332801-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

This is mostly for the purposes of a later patch, since
we'll need to do the same thing later.

While we are at it, move the resulting function call to ahead
of the unregistering of the IOMMU notifier, so that it's done
in the reverse order of how it was created.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200505122745.53208-4-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_ops.c     | 20 ++++++++++++--------
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index f0d71ab77c50..d4fc84b8867f 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -181,7 +181,6 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
-	int i;
 
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
@@ -191,15 +190,9 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
 	}
 
 	cp_free(&private->cp);
+	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &private->nb);
-
-	for (i = 0; i < private->num_regions; i++)
-		private->region[i].ops->release(private, &private->region[i]);
-
-	private->num_regions = 0;
-	kfree(private->region);
-	private->region = NULL;
 }
 
 static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
@@ -482,6 +475,17 @@ int vfio_ccw_register_dev_region(struct vfio_ccw_private *private,
 	return 0;
 }
 
+void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private)
+{
+	int i;
+
+	for (i = 0; i < private->num_regions; i++)
+		private->region[i].ops->release(private, &private->region[i]);
+	private->num_regions = 0;
+	kfree(private->region);
+	private->region = NULL;
+}
+
 static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 				   unsigned int cmd,
 				   unsigned long arg)
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 9b9bb4982972..ce3834159d98 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -53,6 +53,7 @@ int vfio_ccw_register_dev_region(struct vfio_ccw_private *private,
 				 unsigned int subtype,
 				 const struct vfio_ccw_regops *ops,
 				 size_t size, u32 flags, void *data);
+void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private);
 
 int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
 
-- 
2.25.4

