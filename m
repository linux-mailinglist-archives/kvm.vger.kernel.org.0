Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD2296365
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898702AbgJVRM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 13:12:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506063AbgJVRM1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 13:12:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MH2Mah030283;
        Thu, 22 Oct 2020 13:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9iz41qkKcI5UFyaLbfBJOVav71tdPjHy80191QGlZaE=;
 b=o/kz1s2Ig5M8/fQTmipfV5LItIYzun7+q8tt8Zn/1zw00ahvzXHgHHdvi5GsoW9PWINV
 /yMDlSoRMo9Ce62YH7WDKUbU56X59G2nub1bbCL8YlqGnXaZ+FRbmVWqWLd7VRn50JGT
 4iC+6wtV10cUAqgpgtGi4MpMhybz+SfiXr4aOTf4K/Ck6J1eZIIib1mR5mtW+8aZnX8/
 i/KYiwlB9cx19V0iibaA+SUzLLjz7ZZQVzMnTxp2l6jVxDf+xTSAKugVtQBNbqR5c5y0
 8na6p8dIK1CtZI/kduw1mtebIuSQV14Q8wxQTpRoO8W27WXD1Z38i/mCjVSNx7rsgXyX iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34b6n8r6k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:25 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MH2Sch030989;
        Thu, 22 Oct 2020 13:12:25 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34b6n8r6jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:25 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09MHCLav015337;
        Thu, 22 Oct 2020 17:12:24 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 347r89vb9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 17:12:24 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09MHCKCn7864646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 17:12:21 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7A2178064;
        Thu, 22 Oct 2020 17:12:20 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A9E37805C;
        Thu, 22 Oct 2020 17:12:19 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.170.177])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Oct 2020 17:12:19 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after queue reset
Date:   Thu, 22 Oct 2020 13:11:56 -0400
Message-Id: <20201022171209.19494-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201022171209.19494-1-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_12:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 spamscore=0 mlxlogscore=973 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The queues assigned to a matrix mediated device are currently reset when:

* The VFIO_DEVICE_RESET ioctl is invoked
* The mdev fd is closed by userspace (QEMU)
* The mdev is removed from sysfs.

Immediately after the reset of a queue, a call is made to disable
interrupts for the queue. This is entirely unnecessary because the reset of
a queue disables interrupts, so this will be removed.

Since interrupt processing may have been enabled by the guest, it may also
be necessary to clean up the resources used for interrupt processing. Part
of the cleanup operation requires a reference to KVM, so a check is also
being added to ensure the reference to KVM exists. The reason is because
the release callback - invoked when userspace closes the mdev fd - removes
the reference to KVM. When the remove callback - called when the mdev is
removed from sysfs - is subsequently invoked, there will be no reference to
KVM when the cleanup is performed.

This patch will also do a bit of refactoring due to the fact that the
remove callback, implemented in vfio_ap_drv.c, disables the queue after
resetting it. Instead of the remove callback making a call into the
vfio_ap_ops.c to clean up the resources used for interrupt processing,
let's move the probe and remove callbacks into the vfio_ap_ops.c
file keep all code related to managing queues in a single file.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     | 45 +------------------
 drivers/s390/crypto/vfio_ap_ops.c     | 63 +++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |  7 +--
 3 files changed, 52 insertions(+), 63 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index be2520cc010b..73bd073fd5d3 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -43,47 +43,6 @@ static struct ap_device_id ap_queue_ids[] = {
 
 MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
 
-/**
- * vfio_ap_queue_dev_probe:
- *
- * Allocate a vfio_ap_queue structure and associate it
- * with the device as driver_data.
- */
-static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
-{
-	struct vfio_ap_queue *q;
-
-	q = kzalloc(sizeof(*q), GFP_KERNEL);
-	if (!q)
-		return -ENOMEM;
-	dev_set_drvdata(&apdev->device, q);
-	q->apqn = to_ap_queue(&apdev->device)->qid;
-	q->saved_isc = VFIO_AP_ISC_INVALID;
-	return 0;
-}
-
-/**
- * vfio_ap_queue_dev_remove:
- *
- * Takes the matrix lock to avoid actions on this device while removing
- * Free the associated vfio_ap_queue structure
- */
-static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
-{
-	struct vfio_ap_queue *q;
-	int apid, apqi;
-
-	mutex_lock(&matrix_dev->lock);
-	q = dev_get_drvdata(&apdev->device);
-	dev_set_drvdata(&apdev->device, NULL);
-	apid = AP_QID_CARD(q->apqn);
-	apqi = AP_QID_QUEUE(q->apqn);
-	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	vfio_ap_irq_disable(q);
-	kfree(q);
-	mutex_unlock(&matrix_dev->lock);
-}
-
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
 	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
@@ -186,8 +145,8 @@ static int __init vfio_ap_init(void)
 		return ret;
 
 	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
-	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
-	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
+	vfio_ap_drv.probe = vfio_ap_mdev_probe_queue;
+	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..c471832f0a30 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -119,7 +119,8 @@ static void vfio_ap_wait_for_irqclear(int apqn)
  */
 static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
 {
-	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
+	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev &&
+	    q->matrix_mdev->kvm)
 		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
 	if (q->saved_pfn && q->matrix_mdev)
 		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
@@ -144,7 +145,7 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
  * Returns if ap_aqic function failed with invalid, deconfigured or
  * checkstopped AP.
  */
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
+static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 {
 	struct ap_qirq_ctrl aqic_gisa = {};
 	struct ap_queue_status status;
@@ -297,6 +298,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	if (!q)
 		goto out_unlock;
 
+	q->matrix_mdev = matrix_mdev;
 	status = vcpu->run->s.regs.gprs[1];
 
 	/* If IR bit(16) is set we enable the interrupt */
@@ -1114,20 +1116,6 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static void vfio_ap_irq_disable_apqn(int apqn)
-{
-	struct device *dev;
-	struct vfio_ap_queue *q;
-
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (dev) {
-		q = dev_get_drvdata(dev);
-		vfio_ap_irq_disable(q);
-		put_device(dev);
-	}
-}
-
 int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
 			     unsigned int retry)
 {
@@ -1162,6 +1150,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 {
 	int ret;
 	int rc = 0;
+	struct vfio_ap_queue *q;
 	unsigned long apid, apqi;
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
@@ -1177,7 +1166,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			 */
 			if (ret)
 				rc = ret;
-			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
+			q = vfio_ap_get_queue(matrix_mdev,
+					      AP_MKQID(apid, apqi));
+			if (q)
+				vfio_ap_free_aqic_resources(q);
 		}
 	}
 
@@ -1302,3 +1294,40 @@ void vfio_ap_mdev_unregister(void)
 {
 	mdev_unregister_device(&matrix_dev->device);
 }
+
+int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+	struct ap_queue *queue;
+
+	queue = to_ap_queue(&apdev->device);
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return -ENOMEM;
+
+	dev_set_drvdata(&queue->ap_dev.device, q);
+	q->apqn = queue->qid;
+	q->saved_isc = VFIO_AP_ISC_INVALID;
+
+	return 0;
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
+{
+	struct vfio_ap_queue *q;
+	struct ap_queue *queue;
+	int apid, apqi;
+
+	queue = to_ap_queue(&apdev->device);
+
+	mutex_lock(&matrix_dev->lock);
+	q = dev_get_drvdata(&queue->ap_dev.device);
+	dev_set_drvdata(&queue->ap_dev.device, NULL);
+	apid = AP_QID_CARD(q->apqn);
+	apqi = AP_QID_QUEUE(q->apqn);
+	vfio_ap_mdev_reset_queue(apid, apqi, 1);
+	vfio_ap_free_aqic_resources(q);
+	kfree(q);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f46dde56b464..d9003de4fbad 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -90,8 +90,6 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry);
 
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -100,5 +98,8 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 };
-struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
+
+int vfio_ap_mdev_probe_queue(struct ap_device *queue);
+void vfio_ap_mdev_remove_queue(struct ap_device *queue);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

