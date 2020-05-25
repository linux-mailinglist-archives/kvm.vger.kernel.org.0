Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3FF1E0AD7
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 11:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389640AbgEYJlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 05:41:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27874 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389621AbgEYJlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 05:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590399694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ty3Zy3HVUpbIRq8mB7Pi9NIOj6Gaawv8XKOFmSlnN68=;
        b=YvGqCbOWYIfr7vvksMmQ5i3Tt6A2aqqzGZ0mMcKQlvP8KtSeWbd8McHH53ztmQzoLo5wqE
        XuFZB2m0OxC9m6S50Dq6th6dArZHCvjnsefv6BCQQzfWftElS1r/IqYdi8R11WTkI3rZU/
        rNn+kbSxYHb4VqPHBxQIjI6GRucBCec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-3jBDDgGYMtOQyhCQt-oUjQ-1; Mon, 25 May 2020 05:41:31 -0400
X-MC-Unique: 3jBDDgGYMtOQyhCQt-oUjQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ADED846376;
        Mon, 25 May 2020 09:41:30 +0000 (UTC)
Received: from localhost (ovpn-112-215.ams2.redhat.com [10.36.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A65EF74EA9;
        Mon, 25 May 2020 09:41:28 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 03/10] vfio-ccw: Introduce new helper functions to free/destroy regions
Date:   Mon, 25 May 2020 11:41:08 +0200
Message-Id: <20200525094115.222299-4-cohuck@redhat.com>
In-Reply-To: <20200525094115.222299-1-cohuck@redhat.com>
References: <20200525094115.222299-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

Consolidate some of the cleanup code for the regions, so that
as more are added we reduce code duplication.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200505122745.53208-2-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 339a6bc0339b..8715c1c2f1e1 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -116,6 +116,14 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
 }
 
+static void vfio_ccw_free_regions(struct vfio_ccw_private *private)
+{
+	if (private->cmd_region)
+		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
+	if (private->io_region)
+		kmem_cache_free(vfio_ccw_io_region, private->io_region);
+}
+
 static int vfio_ccw_sch_probe(struct subchannel *sch)
 {
 	struct pmcw *pmcw = &sch->schib.pmcw;
@@ -181,10 +189,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	cio_disable_subchannel(sch);
 out_free:
 	dev_set_drvdata(&sch->dev, NULL);
-	if (private->cmd_region)
-		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
-	if (private->io_region)
-		kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	vfio_ccw_free_regions(private);
 	kfree(private->cp.guest_cp);
 	kfree(private);
 	return ret;
@@ -200,8 +205,7 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, NULL);
 
-	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
-	kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	vfio_ccw_free_regions(private);
 	kfree(private->cp.guest_cp);
 	kfree(private);
 
@@ -304,6 +308,12 @@ static void vfio_ccw_debug_exit(void)
 	debug_unregister(vfio_ccw_debug_trace_id);
 }
 
+static void vfio_ccw_destroy_regions(void)
+{
+	kmem_cache_destroy(vfio_ccw_cmd_region);
+	kmem_cache_destroy(vfio_ccw_io_region);
+}
+
 static int __init vfio_ccw_sch_init(void)
 {
 	int ret;
@@ -346,8 +356,7 @@ static int __init vfio_ccw_sch_init(void)
 	return ret;
 
 out_err:
-	kmem_cache_destroy(vfio_ccw_cmd_region);
-	kmem_cache_destroy(vfio_ccw_io_region);
+	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
 	vfio_ccw_debug_exit();
 	return ret;
@@ -357,8 +366,7 @@ static void __exit vfio_ccw_sch_exit(void)
 {
 	css_driver_unregister(&vfio_ccw_sch_driver);
 	isc_unregister(VFIO_CCW_ISC);
-	kmem_cache_destroy(vfio_ccw_io_region);
-	kmem_cache_destroy(vfio_ccw_cmd_region);
+	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
 	vfio_ccw_debug_exit();
 }
-- 
2.25.4

