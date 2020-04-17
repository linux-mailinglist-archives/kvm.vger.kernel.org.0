Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6B61AD47E
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 04:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgDQCaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 22:30:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728923AbgDQCaK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 22:30:10 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03H24CNb042280
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:30:07 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f1w1ah7f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:30:07 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 17 Apr 2020 03:29:36 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Apr 2020 03:29:34 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03H2U2UA59244606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 02:30:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C5BAE051;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EF89AE045;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C0089E089A; Fri, 17 Apr 2020 04:30:01 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 7/8] vfio-ccw: Wire up the CRW irq and CRW region
Date:   Fri, 17 Apr 2020 04:30:00 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417023001.65006-1-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20041702-0008-0000-0000-00000372142A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041702-0009-0000-0000-00004A93CE10
Message-Id: <20200417023001.65006-8-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_10:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 suspectscore=2
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004170010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

Use an IRQ to notify userspace that there is a CRW
pending in the region, related to path-availability
changes on the passthrough subchannel.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---

Notes:
    v2->v3:
     - Refactor vfio_ccw_alloc_crw() to accept rsc, erc, and rsid fields
       of a CRW as input [CH]
     - Copy the right amount of CRWs to the crw_region [EF]
     - Use sizeof(target) for the memcpy, rather than sizeof(source) [EF]
     - Ensure the CRW region is empty if no CRW is present [EF/CH]
     - Refactor how data goes from private-to-region-to-user [CH]
     - Reduce the number of CRWs from two to one [CH]
     - s/vc_crw/crw/ [EF]
    
    v1->v2:
     - Remove extraneous 0x0 in crw.rsid assignment [CH]
     - Refactor the building/queueing of a crw into its own routine [EF]
    
    v0->v1: [EF]
     - Place the non-refactoring changes from the previous patch here
     - Clean up checkpatch (whitespace) errors
     - s/chp_crw/crw/
     - Move acquire/release of io_mutex in vfio_ccw_crw_region_read()
       into patch that introduces that region
     - Remove duplicate include from vfio_ccw_drv.c
     - Reorder include in vfio_ccw_private.h

 drivers/s390/cio/vfio_ccw_chp.c     | 19 +++++++++++
 drivers/s390/cio/vfio_ccw_drv.c     | 49 +++++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c     |  4 +++
 drivers/s390/cio/vfio_ccw_private.h |  9 ++++++
 include/uapi/linux/vfio.h           |  1 +
 5 files changed, 82 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
index c1362aae61f5..fbadd5cf1b5c 100644
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -82,20 +82,39 @@ static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
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
+	else
+		region->crw = 0;
+
 	if (copy_to_user(buf, (void *)region + pos, count))
 		ret = -EFAULT;
 	else
 		ret = count;
 
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
index 7893027c3a8f..a0d8d2560c12 100644
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
 
+static void vfio_ccw_alloc_crw(struct vfio_ccw_private *private,
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
@@ -309,6 +354,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	case CHP_OFFLINE:
 		/* Path is gone */
 		cio_cancel_halt_clear(sch, &retry);
+		vfio_ccw_alloc_crw(private, CRW_RSC_CPATH, CRW_ERC_PERRN,
+				   (link->chpid.cssid << 8) | link->chpid.id);
 		break;
 	case CHP_VARY_ON:
 		/* Path logically turned on */
@@ -318,6 +365,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	case CHP_ONLINE:
 		/* Path became available */
 		sch->lpm |= mask & sch->opm;
+		vfio_ccw_alloc_crw(private, CRW_RSC_CPATH, CRW_ERC_INIT,
+				   (link->chpid.cssid << 8) | link->chpid.id);
 		break;
 	}
 
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index f3033f8fc96d..8b3ed5b45277 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -393,6 +393,7 @@ static int vfio_ccw_mdev_get_irq_info(struct vfio_irq_info *info)
 {
 	switch (info->index) {
 	case VFIO_CCW_IO_IRQ_INDEX:
+	case VFIO_CCW_CRW_IRQ_INDEX:
 		info->count = 1;
 		info->flags = VFIO_IRQ_INFO_EVENTFD;
 		break;
@@ -420,6 +421,9 @@ static int vfio_ccw_mdev_set_irqs(struct mdev_device *mdev,
 	case VFIO_CCW_IO_IRQ_INDEX:
 		ctx = &private->io_trigger;
 		break;
+	case VFIO_CCW_CRW_IRQ_INDEX:
+		ctx = &private->crw_trigger;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 8289b6850e59..8723156b29ea 100644
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
@@ -98,9 +104,12 @@ struct vfio_ccw_private {
 	struct channel_program	cp;
 	struct irb		irb;
 	union scsw		scsw;
+	struct list_head	crw;
 
 	struct eventfd_ctx	*io_trigger;
+	struct eventfd_ctx	*crw_trigger;
 	struct work_struct	io_work;
+	struct work_struct	crw_work;
 } __aligned(8);
 
 extern int vfio_ccw_mdev_reg(struct subchannel *sch);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 469f813749f1..907758cf6d60 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -579,6 +579,7 @@ enum {
 
 enum {
 	VFIO_CCW_IO_IRQ_INDEX,
+	VFIO_CCW_CRW_IRQ_INDEX,
 	VFIO_CCW_NUM_IRQS
 };
 
-- 
2.17.1

