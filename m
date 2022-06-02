Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228FC53BD2F
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiFBRUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbiFBRUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDB020E6DD;
        Thu,  2 Jun 2022 10:20:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252HA1GN018327;
        Thu, 2 Jun 2022 17:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hQS2awytVaLrRcLwusX4Naj8p/4VeHtYBOnKSbkHHsI=;
 b=LtU3Hid+oe9opKVcALAkgc3pk69G43jjPiqjZGq02bYRbabwcQF9qj9SxUu4QnFEzEv6
 B98xUyGMZ8r6XC708xnDS5Gtoqmo6AiCuYP6OtQrpVBKVaiyravf3Qbo8R0SDuyGIyAh
 iEPhbD1EzDpG+9ZwoVwHmQoj6XGMnsCNnj6jfmALb0RJfdiEnbPfAtz3IAhRdEN/cW5m
 YHggwLhqPBvfzNmAivcaGzGTlAfcnlapSgKNcS4v7NXEd4d7wtoqzyZx+DKDPShM3pom
 qoBfxUUJRHjWdWxThZPfK3wF3uWuHZC0ipgi8zvUJYRAa4q+thGhUd2cVbX4OvSLKVt0 MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gewxgcm54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:57 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252GdJXe003520;
        Thu, 2 Jun 2022 17:19:57 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gewxgcm4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H5d4I023584;
        Thu, 2 Jun 2022 17:19:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h7bxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJpQZ47645124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66299A405B;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44BDAA4054;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C82B3E126F; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 12/18] vfio/ccw: Move FSM open/close to MDEV open/close
Date:   Thu,  2 Jun 2022 19:19:42 +0200
Message-Id: <20220602171948.2790690-13-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wA4MyaEvka9TgKXV_z80D8hKyB5zwbRZ
X-Proofpoint-ORIG-GUID: uK8p1cvV1vu5KFntpJKJtPVePrv9EbnH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Part of the confusion that has existed is the FSM lifecycle of
subchannels between the common CSS driver and the vfio-ccw driver.
During configuration, the FSM state goes from NOT_OPER to STANDBY
to IDLE, but then back to NOT_OPER. For example:

	vfio_ccw_sch_probe:		VFIO_CCW_STATE_NOT_OPER
	vfio_ccw_sch_probe:		VFIO_CCW_STATE_STANDBY
	vfio_ccw_mdev_probe:		VFIO_CCW_STATE_IDLE
	vfio_ccw_mdev_remove:		VFIO_CCW_STATE_NOT_OPER
	vfio_ccw_sch_remove:		VFIO_CCW_STATE_NOT_OPER
	vfio_ccw_sch_shutdown:		VFIO_CCW_STATE_NOT_OPER

Rearrange the open/close events to align with the mdev open/close,
to better manage the memory and state of the devices as time
progresses. Specifically, make mdev_open() perform the FSM open,
and mdev_close() perform the FSM close instead of reset (which is
both close and open).

This makes the NOT_OPER state a dead-end path, indicating the
device is probably not recoverable without fully probing and
re-configuring the device.

This has the nice side-effect of removing a number of special-cases
where the FSM state is managed outside of the FSM itself (such as
the aforementioned mdev_close() routine).

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 11 +++--------
 drivers/s390/cio/vfio_ccw_fsm.c | 30 ++++++++++++++++++++++--------
 drivers/s390/cio/vfio_ccw_ops.c | 26 +++++++++++---------------
 3 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 34995ad00332..e4b285953a45 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -143,7 +143,7 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
 
 	private->sch = sch;
 	mutex_init(&private->io_mutex);
-	private->state = VFIO_CCW_STATE_NOT_OPER;
+	private->state = VFIO_CCW_STATE_STANDBY;
 	INIT_LIST_HEAD(&private->crw);
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
@@ -227,21 +227,15 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, private);
 
-	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
-	if (private->state == VFIO_CCW_STATE_NOT_OPER)
-		goto out_free;
-
 	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
 	if (ret)
-		goto out_disable;
+		goto out_free;
 
 	VFIO_CCW_MSG_EVENT(4, "bound to subchannel %x.%x.%04x\n",
 			   sch->schid.cssid, sch->schid.ssid,
 			   sch->schid.sch_no);
 	return 0;
 
-out_disable:
-	cio_disable_subchannel(sch);
 out_free:
 	dev_set_drvdata(&sch->dev, NULL);
 	vfio_ccw_free_private(private);
@@ -275,6 +269,7 @@ static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 		return;
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 
 /**
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 926ae618c3fa..7ec64c1e076c 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -171,6 +171,7 @@ static void fsm_notoper(struct vfio_ccw_private *private,
 	 */
 	css_sched_sch_todo(sch, SCH_TODO_UNREG);
 	private->state = VFIO_CCW_STATE_NOT_OPER;
+	cp_free(&private->cp);
 }
 
 /*
@@ -376,9 +377,16 @@ static void fsm_open(struct vfio_ccw_private *private,
 	spin_lock_irq(sch->lock);
 	sch->isc = VFIO_CCW_ISC;
 	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
-	if (!ret)
-		private->state = VFIO_CCW_STATE_STANDBY;
+	if (ret)
+		goto err_unlock;
+
+	private->state = VFIO_CCW_STATE_IDLE;
 	spin_unlock_irq(sch->lock);
+	return;
+
+err_unlock:
+	spin_unlock_irq(sch->lock);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 
 static void fsm_close(struct vfio_ccw_private *private,
@@ -390,16 +398,22 @@ static void fsm_close(struct vfio_ccw_private *private,
 	spin_lock_irq(sch->lock);
 
 	if (!sch->schib.pmcw.ena)
-		goto out_unlock;
+		goto err_unlock;
 
 	ret = cio_disable_subchannel(sch);
 	if (ret == -EBUSY)
 		vfio_ccw_sch_quiesce(sch);
+	if (ret)
+		goto err_unlock;
 
-out_unlock:
-	private->state = VFIO_CCW_STATE_NOT_OPER;
+	private->state = VFIO_CCW_STATE_STANDBY;
 	spin_unlock_irq(sch->lock);
 	cp_free(&private->cp);
+	return;
+
+err_unlock:
+	spin_unlock_irq(sch->lock);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 
 /*
@@ -411,15 +425,15 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
-		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
 		[VFIO_CCW_EVENT_CLOSE]		= fsm_nop,
 	},
 	[VFIO_CCW_STATE_STANDBY] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
-		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
-		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
+		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
 		[VFIO_CCW_EVENT_CLOSE]		= fsm_notoper,
 	},
 	[VFIO_CCW_STATE_IDLE] = {
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 386eb74ce219..2afb8f13739f 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -24,17 +24,12 @@ static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
 	/*
 	 * If the FSM state is seen as Not Operational after closing
 	 * and re-opening the mdev, return an error.
-	 *
-	 * Otherwise, change the FSM from STANDBY to IDLE which is
-	 * normally done by vfio_ccw_mdev_probe() in current lifecycle.
 	 */
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
 	if (private->state == VFIO_CCW_STATE_NOT_OPER)
 		return -EINVAL;
 
-	private->state = VFIO_CCW_STATE_IDLE;
-
 	return 0;
 }
 
@@ -121,8 +116,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	vfio_init_group_dev(&private->vdev, &mdev->dev,
 			    &vfio_ccw_dev_ops);
 
-	private->state = VFIO_CCW_STATE_IDLE;
-
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
 			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
@@ -137,7 +130,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 err_atomic:
 	vfio_uninit_group_dev(&private->vdev);
 	atomic_inc(&private->avail);
-	private->state = VFIO_CCW_STATE_STANDBY;
 	return ret;
 }
 
@@ -169,6 +161,10 @@ static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
 	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
 	int ret;
 
+	/* Device cannot simply be opened again from this state */
+	if (private->state == VFIO_CCW_STATE_NOT_OPER)
+		return -EINVAL;
+
 	private->nb.notifier_call = vfio_ccw_mdev_notifier;
 
 	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
@@ -188,6 +184,12 @@ static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
 	if (ret)
 		goto out_unregister;
 
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
+	if (private->state == VFIO_CCW_STATE_NOT_OPER) {
+		ret = -EINVAL;
+		goto out_unregister;
+	}
+
 	return ret;
 
 out_unregister:
@@ -202,13 +204,7 @@ static void vfio_ccw_mdev_close_device(struct vfio_device *vdev)
 	struct vfio_ccw_private *private =
 		container_of(vdev, struct vfio_ccw_private, vdev);
 
-	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
-	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_mdev_reset(private))
-			private->state = VFIO_CCW_STATE_STANDBY;
-		/* The state will be NOT_OPER on error. */
-	}
-
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY, &private->nb);
 }
-- 
2.32.0

