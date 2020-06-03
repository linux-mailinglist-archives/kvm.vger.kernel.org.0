Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53D91ECE59
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 13:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgFCL1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 07:27:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27861 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbgFCL1x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 07:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591183672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A04X/Re2W89LOosDysttEBjCFG0m2CTyUc3A8x/i19c=;
        b=JLSMcYeQJUyk/aPovx9i0opZ5OmPQ9hqin099d1EhWUrdFMV3dc3nqfbUU+js6W3dk3dsa
        EmHDjPiU3KGx0J1G/bDNJ+6DA41MQkHRwRpFd2DtvtYMjzLXJoVS0xz9mS9gGKPp1MuUeg
        8XZt1umunYxoPLWAjm1ci6WLthQUqJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-196vs6aAPeSh_Q8g5THmyg-1; Wed, 03 Jun 2020 07:27:41 -0400
X-MC-Unique: 196vs6aAPeSh_Q8g5THmyg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEB98835B48;
        Wed,  3 Jun 2020 11:27:39 +0000 (UTC)
Received: from localhost (ovpn-112-182.ams2.redhat.com [10.36.112.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 837535C220;
        Wed,  3 Jun 2020 11:27:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PULL v2 09/10] vfio-ccw: Wire up the CRW irq and CRW region
Date:   Wed,  3 Jun 2020 13:27:15 +0200
Message-Id: <20200603112716.332801-10-cohuck@redhat.com>
In-Reply-To: <20200603112716.332801-1-cohuck@redhat.com>
References: <20200603112716.332801-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

Use the IRQ to notify userspace that there is a CRW
pending in the region, related to path-availability
changes on the passthrough subchannel.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200505122745.53208-8-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_chp.c     | 17 ++++++++++
 drivers/s390/cio/vfio_ccw_drv.c     | 49 +++++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |  8 +++++
 3 files changed, 74 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
index 37ea344a4d72..876f6ade51cc 100644
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -82,14 +82,24 @@ static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
 	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
 	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
 	struct ccw_crw_region *region;
+	struct vfio_ccw_crw *crw;
 	int ret;
 
 	if (pos + count > sizeof(*region))
 		return -EINVAL;
 
+	crw = list_first_entry_or_null(&private->crw,
+				       struct vfio_ccw_crw, next);
+
+	if (crw)
+		list_del(&crw->next);
+
 	mutex_lock(&private->io_mutex);
 	region = private->region[i].data;
 
+	if (crw)
+		memcpy(&region->crw, &crw->crw, sizeof(region->crw));
+
 	if (copy_to_user(buf, (void *)region + pos, count))
 		ret = -EFAULT;
 	else
@@ -98,6 +108,13 @@ static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
 	region->crw = 0;
 
 	mutex_unlock(&private->io_mutex);
+
+	kfree(crw);
+
+	/* Notify the guest if more CRWs are on our queue */
+	if (!list_empty(&private->crw) && private->crw_trigger)
+		eventfd_signal(private->crw_trigger, 1);
+
 	return ret;
 }
 
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index e4deae6fd525..9144360851ed 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -108,6 +108,16 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		eventfd_signal(private->io_trigger, 1);
 }
 
+static void vfio_ccw_crw_todo(struct work_struct *work)
+{
+	struct vfio_ccw_private *private;
+
+	private = container_of(work, struct vfio_ccw_private, crw_work);
+
+	if (!list_empty(&private->crw) && private->crw_trigger)
+		eventfd_signal(private->crw_trigger, 1);
+}
+
 /*
  * Css driver callbacks
  */
@@ -186,7 +196,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (ret)
 		goto out_free;
 
+	INIT_LIST_HEAD(&private->crw);
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
+	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
 	atomic_set(&private->avail, 1);
 	private->state = VFIO_CCW_STATE_STANDBY;
 
@@ -217,9 +229,15 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 static int vfio_ccw_sch_remove(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+	struct vfio_ccw_crw *crw, *temp;
 
 	vfio_ccw_sch_quiesce(sch);
 
+	list_for_each_entry_safe(crw, temp, &private->crw, next) {
+		list_del(&crw->next);
+		kfree(crw);
+	}
+
 	vfio_ccw_mdev_unreg(sch);
 
 	dev_set_drvdata(&sch->dev, NULL);
@@ -281,6 +299,33 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	return rc;
 }
 
+static void vfio_ccw_queue_crw(struct vfio_ccw_private *private,
+			       unsigned int rsc,
+			       unsigned int erc,
+			       unsigned int rsid)
+{
+	struct vfio_ccw_crw *crw;
+
+	/*
+	 * If unable to allocate a CRW, just drop the event and
+	 * carry on.  The guest will either see a later one or
+	 * learn when it issues its own store subchannel.
+	 */
+	crw = kzalloc(sizeof(*crw), GFP_ATOMIC);
+	if (!crw)
+		return;
+
+	/*
+	 * Build the CRW based on the inputs given to us.
+	 */
+	crw->crw.rsc = rsc;
+	crw->crw.erc = erc;
+	crw->crw.rsid = rsid;
+
+	list_add_tail(&crw->next, &private->crw);
+	queue_work(vfio_ccw_work_q, &private->crw_work);
+}
+
 static int vfio_ccw_chp_event(struct subchannel *sch,
 			      struct chp_link *link, int event)
 {
@@ -311,6 +356,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 		/* Path is gone */
 		if (sch->schib.pmcw.lpum & mask)
 			cio_cancel_halt_clear(sch, &retry);
+		vfio_ccw_queue_crw(private, CRW_RSC_CPATH, CRW_ERC_PERRN,
+				   link->chpid.id);
 		break;
 	case CHP_VARY_ON:
 		/* Path logically turned on */
@@ -320,6 +367,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	case CHP_ONLINE:
 		/* Path became available */
 		sch->lpm |= mask & sch->opm;
+		vfio_ccw_queue_crw(private, CRW_RSC_CPATH, CRW_ERC_INIT,
+				   link->chpid.id);
 		break;
 	}
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 97131b4df0b9..8723156b29ea 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -17,6 +17,7 @@
 #include <linux/eventfd.h>
 #include <linux/workqueue.h>
 #include <linux/vfio_ccw.h>
+#include <asm/crw.h>
 #include <asm/debug.h>
 
 #include "css.h"
@@ -59,6 +60,11 @@ int vfio_ccw_register_async_dev_regions(struct vfio_ccw_private *private);
 int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private);
 int vfio_ccw_register_crw_dev_regions(struct vfio_ccw_private *private);
 
+struct vfio_ccw_crw {
+	struct list_head	next;
+	struct crw		crw;
+};
+
 /**
  * struct vfio_ccw_private
  * @sch: pointer to the subchannel
@@ -98,10 +104,12 @@ struct vfio_ccw_private {
 	struct channel_program	cp;
 	struct irb		irb;
 	union scsw		scsw;
+	struct list_head	crw;
 
 	struct eventfd_ctx	*io_trigger;
 	struct eventfd_ctx	*crw_trigger;
 	struct work_struct	io_work;
+	struct work_struct	crw_work;
 } __aligned(8);
 
 extern int vfio_ccw_mdev_reg(struct subchannel *sch);
-- 
2.25.4

