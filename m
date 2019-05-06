Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C414A9C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 15:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEFNLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 09:11:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbfEFNLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 09:11:19 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46D73SL143477
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 09:11:18 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sanexgagw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 09:11:17 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 6 May 2019 14:11:15 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 14:11:13 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46DBBNH42991636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 13:11:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5168A4040;
        Mon,  6 May 2019 13:11:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67FD5A405E;
        Mon,  6 May 2019 13:11:11 +0000 (GMT)
Received: from morel-ThinkPad-W530.numericable.fr (unknown [9.145.46.119])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 13:11:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     cohuck@redhat.com
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        alifm@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v1 1/2] vfio-ccw: Set subchannel state STANDBY on open
Date:   Mon,  6 May 2019 15:11:09 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19050613-0016-0000-0000-00000278D6B0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050613-0017-0000-0000-000032D57B4E
Message-Id: <1557148270-19901-2-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=879 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When no guest is associated with the mediated device,
i.e. the mediated device is not opened, the state of
the mediated device is VFIO_CCW_STATE_NOT_OPER.

The subchannel enablement and the according setting to the
VFIO_CCW_STATE_STANDBY state should only be done when all
parts of the VFIO mediated device have been initialized
i.e. after the mediated device has been successfully opened.

Let's stay in VFIO_CCW_STATE_NOT_OPER until the mediated
device has been opened.

When the mediated device is closed, disable the sub channel
by calling vfio_ccw_sch_quiesce() no reset needs to be done
the mediated devce will be enable on next open.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 10 +---------
 drivers/s390/cio/vfio_ccw_ops.c | 36 ++++++++++++++++++------------------
 2 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index ee8767f..a95b6c7 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -143,26 +143,18 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	dev_set_drvdata(&sch->dev, private);
 	mutex_init(&private->io_mutex);
 
-	spin_lock_irq(sch->lock);
 	private->state = VFIO_CCW_STATE_NOT_OPER;
 	sch->isc = VFIO_CCW_ISC;
-	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
-	spin_unlock_irq(sch->lock);
-	if (ret)
-		goto out_free;
 
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	atomic_set(&private->avail, 1);
-	private->state = VFIO_CCW_STATE_STANDBY;
 
 	ret = vfio_ccw_mdev_reg(sch);
 	if (ret)
-		goto out_disable;
+		goto out_free;
 
 	return 0;
 
-out_disable:
-	cio_disable_subchannel(sch);
 out_free:
 	dev_set_drvdata(&sch->dev, NULL);
 	if (private->cmd_region)
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 5eb6111..497419c 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -115,14 +115,10 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
 
-	if (private->state == VFIO_CCW_STATE_NOT_OPER)
-		return -ENODEV;
-
 	if (atomic_dec_if_positive(&private->avail) < 0)
 		return -EPERM;
 
 	private->mdev = mdev;
-	private->state = VFIO_CCW_STATE_IDLE;
 
 	return 0;
 }
@@ -132,12 +128,7 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
 
-	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
-	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_sch_quiesce(private->sch))
-			private->state = VFIO_CCW_STATE_STANDBY;
-		/* The state will be NOT_OPER on error. */
-	}
+	vfio_ccw_sch_quiesce(private->sch);
 
 	cp_free(&private->cp);
 	private->mdev = NULL;
@@ -151,6 +142,7 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
 	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
+	struct subchannel *sch = private->sch;
 	int ret;
 
 	private->nb.notifier_call = vfio_ccw_mdev_notifier;
@@ -165,6 +157,20 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
 		vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 					 &private->nb);
 	return ret;
+
+	spin_lock_irq(private->sch->lock);
+	if (cio_enable_subchannel(sch, (u32)(unsigned long)sch))
+		goto error;
+
+	private->state = VFIO_CCW_STATE_STANDBY;
+	spin_unlock_irq(sch->lock);
+	return 0;
+
+error:
+	spin_unlock_irq(sch->lock);
+	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+				 &private->nb);
+	return -EFAULT;
 }
 
 static void vfio_ccw_mdev_release(struct mdev_device *mdev)
@@ -173,20 +179,14 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
 		dev_get_drvdata(mdev_parent_dev(mdev));
 	int i;
 
-	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
-	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_mdev_reset(mdev))
-			private->state = VFIO_CCW_STATE_STANDBY;
-		/* The state will be NOT_OPER on error. */
-	}
-
-	cp_free(&private->cp);
+	vfio_ccw_sch_quiesce(private->sch);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &private->nb);
 
 	for (i = 0; i < private->num_regions; i++)
 		private->region[i].ops->release(private, &private->region[i]);
 
+	cp_free(&private->cp);
 	private->num_regions = 0;
 	kfree(private->region);
 	private->region = NULL;
-- 
2.7.4

