Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D534FD355
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 04:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfKOD2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 22:28:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726549AbfKOD2e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 22:28:34 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF3PdYd076986
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 22:28:33 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9jwqq5ec-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 22:28:32 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 15 Nov 2019 02:56:24 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 02:56:22 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAF2uL5e41222258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 02:56:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24B65A404D;
        Fri, 15 Nov 2019 02:56:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DE68A4040;
        Fri, 15 Nov 2019 02:56:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 15 Nov 2019 02:56:21 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 5F695E02BB; Fri, 15 Nov 2019 03:56:20 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 08/10] vfio-ccw: Wire up the CRW irq and CRW region
Date:   Fri, 15 Nov 2019 03:56:18 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115025620.19593-1-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111502-0028-0000-0000-000003B7024C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111502-0029-0000-0000-0000247A11BD
Message-Id: <20191115025620.19593-9-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=880
 lowpriorityscore=0 bulkscore=0 suspectscore=2 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150028
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
    v0->v1: [EF]
     - Place the non-refactoring changes from the previous patch here
     - Clean up checkpatch (whitespace) errors
     - s/chp_crw/crw/
     - Move acquire/release of io_mutex in vfio_ccw_crw_region_read()
       into patch that introduces that region
     - Remove duplicate include from vfio_ccw_drv.c
     - Reorder include in vfio_ccw_private.h

 drivers/s390/cio/vfio_ccw_drv.c     | 27 +++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c     |  4 ++++
 drivers/s390/cio/vfio_ccw_private.h |  4 ++++
 include/uapi/linux/vfio.h           |  1 +
 4 files changed, 36 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index d1b9020d037b..ab20c32e5319 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -108,6 +108,22 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		eventfd_signal(private->io_trigger, 1);
 }
 
+static void vfio_ccw_crw_todo(struct work_struct *work)
+{
+	struct vfio_ccw_private *private;
+	struct crw *crw;
+
+	private = container_of(work, struct vfio_ccw_private, crw_work);
+	crw = &private->crw;
+
+	mutex_lock(&private->io_mutex);
+	memcpy(&private->crw_region->crw0, crw, sizeof(*crw));
+	mutex_unlock(&private->io_mutex);
+
+	if (private->crw_trigger)
+		eventfd_signal(private->crw_trigger, 1);
+}
+
 /*
  * Css driver callbacks
  */
@@ -187,6 +203,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		goto out_free;
 
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
+	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
 	atomic_set(&private->avail, 1);
 	private->state = VFIO_CCW_STATE_STANDBY;
 
@@ -303,6 +320,11 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	case CHP_OFFLINE:
 		/* Path is gone */
 		cio_cancel_halt_clear(sch, &retry);
+		private->crw.rsc = CRW_RSC_CPATH;
+		private->crw.rsid = 0x0 | (link->chpid.cssid << 8) |
+				    link->chpid.id;
+		private->crw.erc = CRW_ERC_PERRN;
+		queue_work(vfio_ccw_work_q, &private->crw_work);
 		break;
 	case CHP_VARY_ON:
 		/* Path logically turned on */
@@ -312,6 +334,11 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	case CHP_ONLINE:
 		/* Path became available */
 		sch->lpm |= mask & sch->opm;
+		private->crw.rsc = CRW_RSC_CPATH;
+		private->crw.rsid = 0x0 | (link->chpid.cssid << 8) |
+				    link->chpid.id;
+		private->crw.erc = CRW_ERC_INIT;
+		queue_work(vfio_ccw_work_q, &private->crw_work);
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
index 8289b6850e59..558c658f3583 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -17,6 +17,7 @@
 #include <linux/eventfd.h>
 #include <linux/workqueue.h>
 #include <linux/vfio_ccw.h>
+#include <asm/crw.h>
 #include <asm/debug.h>
 
 #include "css.h"
@@ -98,9 +99,12 @@ struct vfio_ccw_private {
 	struct channel_program	cp;
 	struct irb		irb;
 	union scsw		scsw;
+	struct crw		crw;
 
 	struct eventfd_ctx	*io_trigger;
+	struct eventfd_ctx	*crw_trigger;
 	struct work_struct	io_work;
+	struct work_struct	crw_work;
 } __aligned(8);
 
 extern int vfio_ccw_mdev_reg(struct subchannel *sch);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5024636d7615..1bdf32772545 100644
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

