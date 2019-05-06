Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0173E14A9D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 15:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEFNLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 09:11:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbfEFNLV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 09:11:21 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46D75Xq001105
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 09:11:21 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2samgeu3n8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 09:11:21 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 6 May 2019 14:11:19 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 14:11:13 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46DBCX252035588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 13:11:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CB43A4055;
        Mon,  6 May 2019 13:11:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C523CA405E;
        Mon,  6 May 2019 13:11:11 +0000 (GMT)
Received: from morel-ThinkPad-W530.numericable.fr (unknown [9.145.46.119])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 13:11:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     cohuck@redhat.com
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        alifm@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v1 2/2] vfio-ccw: rework sch_event
Date:   Mon,  6 May 2019 15:11:10 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19050613-4275-0000-0000-00000331E776
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050613-4276-0000-0000-000038414EB5
Message-Id: <1557148270-19901-3-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=565 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the mediated device as non operational when the
subchannel went non operational.
Otherwise keep the current state.

Since we removed the last use of VFIO_CCW_STATE_STANDBY
remove this state from the state machine.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 11 +----------
 drivers/s390/cio/vfio_ccw_fsm.c     |  7 +------
 drivers/s390/cio/vfio_ccw_ops.c     |  2 +-
 drivers/s390/cio/vfio_ccw_private.h |  1 -
 4 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index a95b6c7..2f6140d5 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -210,17 +210,8 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	if (work_pending(&sch->todo_work))
 		goto out_unlock;
 
-	if (cio_update_schib(sch)) {
+	if (cio_update_schib(sch))
 		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
-		rc = 0;
-		goto out_unlock;
-	}
-
-	private = dev_get_drvdata(&sch->dev);
-	if (private->state == VFIO_CCW_STATE_NOT_OPER) {
-		private->state = private->mdev ? VFIO_CCW_STATE_IDLE :
-				 VFIO_CCW_STATE_STANDBY;
-	}
 	rc = 0;
 
 out_unlock:
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 49d9d3d..a6524ca 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -88,6 +88,7 @@ static int fsm_do_halt(struct vfio_ccw_private *private)
 
 	/* Issue "Halt Subchannel" */
 	ccode = hsch(sch->schid);
+	pr_warn("ccode = hsch(sch->schid);\n");
 
 	switch (ccode) {
 	case 0:
@@ -326,12 +327,6 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
 	},
-	[VFIO_CCW_STATE_STANDBY] = {
-		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
-		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
-		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
-		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
-	},
 	[VFIO_CCW_STATE_IDLE] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_request,
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 497419c..35445ca 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -162,7 +162,7 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
 	if (cio_enable_subchannel(sch, (u32)(unsigned long)sch))
 		goto error;
 
-	private->state = VFIO_CCW_STATE_STANDBY;
+	private->state = VFIO_CCW_STATE_IDLE;
 	spin_unlock_irq(sch->lock);
 	return 0;
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index f1092c3..ece6a75 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -105,7 +105,6 @@ extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
  */
 enum vfio_ccw_state {
 	VFIO_CCW_STATE_NOT_OPER,
-	VFIO_CCW_STATE_STANDBY,
 	VFIO_CCW_STATE_IDLE,
 	VFIO_CCW_STATE_CP_PROCESSING,
 	VFIO_CCW_STATE_CP_PENDING,
-- 
2.7.4

