Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757DC53BD2A
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbiFBRUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237441AbiFBRUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAAA20E6D4;
        Thu,  2 Jun 2022 10:19:59 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252FnHBj000801;
        Thu, 2 Jun 2022 17:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FvAIKt56Y2f1Ssb5PGT5JLil2xzVlsoOVBS9mtjG+CA=;
 b=WSPZuhbvE4Oorlc/p+CWQa0VdNCQAo24iPdLjQ/XE242koiRY2ESNR7mv8XD8ZgT4GzU
 yX49dlxAX/ixV5t+bXKPr4dX15lB9uOD56MUUcTTzLn33CdDgLKdLuU1Qoc9R5EvxdXD
 NPzhJoqz1gYy95cJXdfJhVQPrTcpZ/BDw0Z2Fr/lXnmPh8MSjpzBDGU8YdVDnbUCmj4j
 bEgaLxJNNyRqq5ELmKIdis/a5ALoJO1FW7/zmmxXErv6xIr2VBvI8VmZfXVUa/GLgEHY
 qB79pWeiHSMmPpNkTwynGG4yfV12IL5whjyiuMIvNrQaDF2Hk4sJ+w6aVRmLXeCM8Y1L 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gewfa5bqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252HJu8H027344;
        Thu, 2 Jun 2022 17:19:56 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gewfa5bq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H5jNX023221;
        Thu, 2 Jun 2022 17:19:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gbcaknkvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJp4I22675722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E20E5204F;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 378265204E;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C2F06E0A10; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 10/18] vfio/ccw: Create a CLOSE FSM event
Date:   Thu,  2 Jun 2022 19:19:40 +0200
Message-Id: <20220602171948.2790690-11-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SJUZDamjkszBH3EA1mrf8Ifz8JMFullx
X-Proofpoint-GUID: jnoMNYYcrt11K_faayv_96XqrZffy3hy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
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
 drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++------------
 drivers/s390/cio/vfio_ccw_fsm.c     | 26 ++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c     | 14 ++------------
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 4 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 2d816dd01713..34995ad00332 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -44,13 +44,6 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 	if (!private)
 		return 0;
 
-	spin_lock_irq(sch->lock);
-	if (!sch->schib.pmcw.ena)
-		goto out_unlock;
-	ret = cio_disable_subchannel(sch);
-	if (ret != -EBUSY)
-		goto out_unlock;
-
 	iretry = 255;
 	do {
 
@@ -77,9 +70,7 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 		spin_lock_irq(sch->lock);
 		ret = cio_disable_subchannel(sch);
 	} while (ret == -EBUSY);
-out_unlock:
-	private->state = VFIO_CCW_STATE_NOT_OPER;
-	spin_unlock_irq(sch->lock);
+
 	return ret;
 }
 
@@ -264,7 +255,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 	if (!private)
 		return;
 
-	vfio_ccw_sch_quiesce(sch);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	mdev_unregister_device(&sch->dev);
 
 	dev_set_drvdata(&sch->dev, NULL);
@@ -278,7 +269,12 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 
 static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 {
-	vfio_ccw_sch_quiesce(sch);
+	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+
+	if (!private)
+		return;
+
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 }
 
 /**
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 25db8534ded0..926ae618c3fa 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -381,6 +381,27 @@ static void fsm_open(struct vfio_ccw_private *private,
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
@@ -391,6 +412,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_nop,
 	},
 	[VFIO_CCW_STATE_STANDBY] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -398,6 +420,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_notoper,
 	},
 	[VFIO_CCW_STATE_IDLE] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -405,6 +428,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_close,
 	},
 	[VFIO_CCW_STATE_CP_PROCESSING] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -412,6 +436,7 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_retry,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_close,
 	},
 	[VFIO_CCW_STATE_CP_PENDING] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
@@ -419,5 +444,6 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
 		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_close,
 	},
 };
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 9e5c184eab89..38c715da61c6 100644
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
 
@@ -163,15 +160,9 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 	dev_set_drvdata(&mdev->dev, NULL);
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
 
@@ -222,7 +213,6 @@ static void vfio_ccw_mdev_close_device(struct vfio_device *vdev)
 		/* The state will be NOT_OPER on error. */
 	}
 
-	cp_free(&private->cp);
 	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY, &private->nb);
 }
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index d7ba6846e5c5..02a4a5edd00c 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -144,6 +144,7 @@ enum vfio_ccw_event {
 	VFIO_CCW_EVENT_INTERRUPT,
 	VFIO_CCW_EVENT_ASYNC_REQ,
 	VFIO_CCW_EVENT_OPEN,
+	VFIO_CCW_EVENT_CLOSE,
 	/* last element! */
 	NR_VFIO_CCW_EVENTS
 };
-- 
2.32.0

