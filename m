Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7E954D2B9
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348865AbiFOUeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346784AbiFOUda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:33:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791FD31900;
        Wed, 15 Jun 2022 13:33:28 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FImKvV020789;
        Wed, 15 Jun 2022 20:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I1j0Xf6CDOomjUHNMGRrarHSpTJsSQ9RHB78+ltIMGg=;
 b=M2+5JaPYYjIZQVnAjItr3ff+RUWyJOQ4aUshxvs1+oQQ/R5PS3okNutWxmWIvzpyW2yA
 BPI+3qJ/rqAU3Ygk+Oonin2iyvfIW1ERhg2gCYykavHajZyT7Pv56tt/ThNxyiAQusoF
 w2YjJQ+kMDwPa5oPQicB2V62148i389wNLIK8YjI1uZm0FjaTJ9YvNuC/BxO1b2Q+lQg
 sidPbJ/xBrlFjFqy6X+tPlfVHcxqLhBuCa+25g64yBwqN0KYZcGYlZv0bgbZ19zYPXDv
 B0lEMDjAx4C+oEsyTlDuXETCfAQjFlMo3d6C2NdNTCSwRl3cBhk2IVZHVyTXjl7+NQaL 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqjfc6p79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:26 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25FIp5Ce030898;
        Wed, 15 Jun 2022 20:33:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqjfc6p68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25FKKuIG000612;
        Wed, 15 Jun 2022 20:33:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3gmjp94vyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25FKXKMn23200236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 20:33:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93088A4040;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 727CCA4051;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 19004E00A2; Wed, 15 Jun 2022 22:33:20 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 08/10] vfio/ccw: Create a CLOSE FSM event
Date:   Wed, 15 Jun 2022 22:33:16 +0200
Message-Id: <20220615203318.3830778-9-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615203318.3830778-1-farman@linux.ibm.com>
References: <20220615203318.3830778-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c6sX0NIj9IVazlelGWGO8q-6jgpmBdJ-
X-Proofpoint-ORIG-GUID: bQ_C_HZvOEzJXWLzv30ZiHkFMzSHvE81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_16,2022-06-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=986 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the vfio_ccw_sch_quiesce() routine to extract the bit that
disables the subchannel and affects the FSM state. Use this to form
the basis of a CLOSE event that will mirror the OPEN event, and move
the subchannel back to NOT_OPER state.

A key difference with that mirroring is that while OPEN handles the
transition from NOT_OPER => STANDBY, the later probing of the mdev
handles the transition from STANDBY => IDLE. On the other hand,
the CLOSE event will move from one of the operating states {IDLE,
CP_PROCESSING, CP_PENDING} => NOT_OPER. That is, there is no stop
in a STANDBY state on the deconfigure path.

Add a call to cp_free() in this event, such that it is captured for
the various permutations of this event.

In the unlikely event that cio_disable_subchannel() returns -EBUSY,
the remaining logic of vfio_ccw_sch_quiesce() can still be used.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 17 +++++------------
 drivers/s390/cio/vfio_ccw_fsm.c     | 26 ++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c     | 14 ++------------
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 4 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 52249c40a565..62bd6f969b76 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -41,13 +41,6 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	int iretry, ret = 0;
 
-	spin_lock_irq(sch->lock);
-	if (!sch->schib.pmcw.ena)
-		goto out_unlock;
-	ret = cio_disable_subchannel(sch);
-	if (ret != -EBUSY)
-		goto out_unlock;
-
 	iretry = 255;
 	do {
 
@@ -74,9 +67,7 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 		spin_lock_irq(sch->lock);
 		ret = cio_disable_subchannel(sch);
 	} while (ret == -EBUSY);
-out_unlock:
-	private->state = VFIO_CCW_STATE_NOT_OPER;
-	spin_unlock_irq(sch->lock);
+
 	return ret;
 }
 
@@ -258,7 +249,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
-	vfio_ccw_sch_quiesce(sch);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	mdev_unregister_device(&sch->dev);
 
 	dev_set_drvdata(&sch->dev, NULL);
@@ -272,7 +263,9 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 
 static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 {
-	vfio_ccw_sch_quiesce(sch);
+	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 }
 
 /**
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 7e7ed69e1461..fa546d33e595 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -380,6 +380,27 @@ static void fsm_open(struct vfio_ccw_private *private,
 	spin_unlock_irq(sch->lock);
 }
 
+static void fsm_close(struct vfio_ccw_private *private,
+		      enum vfio_ccw_event event)
+{
+	struct subchannel *sch = private->sch;
+	int ret;
+
+	spin_lock_irq(sch->lock);
+
+	if (!sch->schib.pmcw.ena)
+		goto out_unlock;
+
+	ret = cio_disable_subchannel(sch);
+	if (ret == -EBUSY)
+		vfio_ccw_sch_quiesce(sch);
+
+out_unlock:
+	private->state = VFIO_CCW_STATE_NOT_OPER;
+	spin_unlock_irq(sch->lock);
+	cp_free(&private->cp);
+}
+
 /*
  * Device statemachine
  */
@@ -390,6 +411,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_nop,
 	},
 	[VFIO_CCW_STATE_STANDBY] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -397,6 +419,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_notoper,
 	},
 	[VFIO_CCW_STATE_IDLE] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -404,6 +427,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_close,
 	},
 	[VFIO_CCW_STATE_CP_PROCESSING] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -411,6 +435,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_retry,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_close,
 	},
 	[VFIO_CCW_STATE_CP_PENDING] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -418,5 +443,6 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_close,
 	},
 };
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index a7ea9358e461..fc5b83187bd9 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -33,9 +33,7 @@ static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
 	 * There are still a lot more instructions need to be handled. We
 	 * should come back here later.
 	 */
-	ret = vfio_ccw_sch_quiesce(sch);
-	if (ret)
-		return ret;
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 
 	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
 	if (!ret)
@@ -64,7 +62,6 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
 		if (vfio_ccw_mdev_reset(private))
 			return NOTIFY_BAD;
 
-		cp_free(&private->cp);
 		return NOTIFY_OK;
 	}
 
@@ -159,15 +156,9 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 
 	vfio_unregister_group_dev(&private->vdev);
 
-	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
-	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_sch_quiesce(private->sch))
-			private->state = VFIO_CCW_STATE_STANDBY;
-		/* The state will be NOT_OPER on error. */
-	}
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 
 	vfio_uninit_group_dev(&private->vdev);
-	cp_free(&private->cp);
 	atomic_inc(&private->avail);
 }
 
@@ -217,7 +208,6 @@ static void vfio_ccw_mdev_close_device(struct vfio_device *vdev)
 		/* The state will be NOT_OPER on error. */
 	}
 
-	cp_free(&private->cp);
 	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY, &private->nb);
 }
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 8dff1699a7d9..435d401b8fb9 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -143,6 +143,7 @@ enum vfio_ccw_event {
 	VFIO_CCW_EVENT_INTERRUPT,
 	VFIO_CCW_EVENT_ASYNC_REQ,
 	VFIO_CCW_EVENT_OPEN,
+	VFIO_CCW_EVENT_CLOSE,
 	/* last element! */
 	NR_VFIO_CCW_EVENTS
 };
-- 
2.32.0

