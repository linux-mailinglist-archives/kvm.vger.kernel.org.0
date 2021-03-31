Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C55350342
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 17:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhCaPXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 11:23:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236261AbhCaPXZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 11:23:25 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VF3p6V048496;
        Wed, 31 Mar 2021 11:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=E+z47uhiUj7zVM5QjzW11YiQSIDzAXzB0oqDG1QBYO0=;
 b=dyfOAxZx7olYtgZVKb5sGq1BLA5kyMG5WTMavm/R6GtDMeIcF/I9K4/ihGmTnwwILvbT
 gGh5Qik6JeXz+Pi8Z0pPaapZ/SGf1AbrXU+XLxMe0L3P8sAxZEEZlDf2Kik8m/adFunj
 0ZUHo/yNb4WAA+uGtPrIGBs1/V3+ygG12tubYWv7kA9b74XjZl78vIPizSvxIeb2EC+8
 PnnzcfhH581axgKZNhrXueldDww+7Z2FEt854PMPH5wp4+5rrYAsIvDdNYm06eh+hzW9
 iriw5amvS8lVqJFnbK1AJzz3Zg8+X0CJLoTIzeOmA3Z0f+7RM5jEvujilwVLjzxGwZZM SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mtxuhukk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:23 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12VF5AFF055062;
        Wed, 31 Mar 2021 11:23:23 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mtxuhujp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:23 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12VFN8CL003574;
        Wed, 31 Mar 2021 15:23:22 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 37maae7eam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 15:23:22 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12VFNIES25559534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 15:23:18 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B13FA6E04C;
        Wed, 31 Mar 2021 15:23:18 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E039C6E058;
        Wed, 31 Mar 2021 15:23:16 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.146.149])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 31 Mar 2021 15:23:16 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v14 04/13] s390/vfio-ap: manage link between queue struct and matrix mdev
Date:   Wed, 31 Mar 2021 11:22:47 -0400
Message-Id: <20210331152256.28129-5-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210331152256.28129-1-akrowiak@linux.ibm.com>
References: <20210331152256.28129-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TIwsmCeLye9l5p4okH8VTHchJ-gPrcBQ
X-Proofpoint-GUID: btLCajezzoD6hIgvrjIEab8G1DMS7WGW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_06:2021-03-31,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's create links between each queue device bound to the vfio_ap device
driver and the matrix mdev to which the queue's APQN is assigned. The idea
is to facilitate efficient retrieval of the objects representing the queue
devices and matrix mdevs as well as to verify that a queue assigned to
a matrix mdev is bound to the driver.

The links will be created as follows:

 * When the queue device is probed, if its APQN is assigned to a matrix
   mdev, the structures representing the queue device and the matrix mdev
   will be linked.

 * When an adapter or domain is assigned to a matrix mdev, for each new
   APQN assigned that references a queue device bound to the vfio_ap
   device driver, the structures representing the queue device and the
   matrix mdev will be linked.

The links will be removed as follows:

 * When the queue device is removed, if its APQN is assigned to a matrix
   mdev, the link from the structure representing the matrix mdev to the
   structure representing the queue will be removed. The link from the
   queue to the matrix mdev will be maintained because if the queue device
   is being removed due to a manual sysfs unbind, it may be needed after
   the queue is reset to clean up the IRQ resources allocated to enable AP
   interrupts for the KVM guest. Since the storage for the structure
   representing the queue device is ultimately freed by the remove
   callback, keeping the reference shouldn't be a problem.

 * When an adapter or domain is unassigned from a matrix mdev, for each
   APQN unassigned that references a queue device bound to the vfio_ap
   device driver, the structures representing the queue device and the
   matrix mdev will be unlinked.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 145 +++++++++++++++++++++-----
 drivers/s390/crypto/vfio_ap_private.h |   3 +
 2 files changed, 123 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index c630abac81d0..28266165eb75 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -27,33 +27,17 @@
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 
-/**
- * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
- * @matrix_mdev: the associated mediated matrix
- * @apqn: The queue APQN
- *
- * Retrieve a queue with a specific APQN from the list of the
- * devices of the vfio_ap_drv.
- * Verify that the APID and the APQI are set in the matrix.
- *
- * Returns the pointer to the associated vfio_ap_queue
- */
-static struct vfio_ap_queue *vfio_ap_get_queue(
-					struct ap_matrix_mdev *matrix_mdev,
-					int apqn)
+static struct vfio_ap_queue *
+vfio_ap_mdev_get_queue(struct ap_matrix_mdev *matrix_mdev, unsigned long apqn)
 {
 	struct vfio_ap_queue *q;
 
-	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
-		return NULL;
-	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
-		return NULL;
-
-	q = vfio_ap_find_queue(apqn);
-	if (q)
-		q->matrix_mdev = matrix_mdev;
+	hash_for_each_possible(matrix_mdev->qtable, q, mdev_qnode, apqn) {
+		if (q && q->apqn == apqn)
+			return q;
+	}
 
-	return q;
+	return NULL;
 }
 
 /**
@@ -171,7 +155,6 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 		  status.response_code);
 end_free:
 	vfio_ap_free_aqic_resources(q);
-	q->matrix_mdev = NULL;
 	return status;
 }
 
@@ -300,7 +283,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	if (!matrix_mdev->kvm)
 		goto out_unlock;
 
-	q = vfio_ap_get_queue(matrix_mdev, apqn);
+	q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
 	if (!q)
 		goto out_unlock;
 
@@ -344,6 +327,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	init_waitqueue_head(&matrix_mdev->wait_for_kvm);
+	hash_init(matrix_mdev->qtable);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
 	matrix_mdev->pqap_hook.owner = THIS_MODULE;
@@ -578,6 +562,60 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 	return 0;
 }
 
+static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
+				    struct vfio_ap_queue *q)
+{
+	if (q) {
+		q->matrix_mdev = matrix_mdev;
+		hash_add(matrix_mdev->qtable,
+			 &q->mdev_qnode, q->apqn);
+	}
+}
+
+static void vfio_ap_mdev_link_apqn(struct ap_matrix_mdev *matrix_mdev, int apqn)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_find_queue(apqn);
+	vfio_ap_mdev_link_queue(matrix_mdev, q);
+}
+
+static void vfio_ap_mdev_unlink_queue_fr_mdev(struct vfio_ap_queue *q)
+{
+	hash_del(&q->mdev_qnode);
+}
+
+static void vfio_ap_mdev_unlink_mdev_fr_queue(struct vfio_ap_queue *q)
+{
+	q->matrix_mdev = NULL;
+}
+
+static void vfio_ap_mdev_unlink_queue(struct vfio_ap_queue *q)
+{
+	if (q) {
+		vfio_ap_mdev_unlink_queue_fr_mdev(q);
+		vfio_ap_mdev_unlink_mdev_fr_queue(q);
+	}
+}
+
+static void vfio_ap_mdev_unlink_apqn(int apqn)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_find_queue(apqn);
+	vfio_ap_mdev_unlink_queue(q);
+}
+
+static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
+				      unsigned long apid)
+{
+	unsigned long apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
+		vfio_ap_mdev_link_apqn(matrix_mdev,
+				       AP_MKQID(apid, apqi));
+}
+
 /**
  * assign_adapter_store
  *
@@ -654,6 +692,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
 	ret = count;
 	goto done;
 
@@ -666,6 +705,15 @@ static ssize_t assign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long apid)
+{
+	unsigned long apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
+		vfio_ap_mdev_unlink_apqn(AP_MKQID(apid, apqi));
+}
+
 /**
  * unassign_adapter_store
  *
@@ -713,6 +761,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -740,6 +789,15 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
+				     unsigned long apqi)
+{
+	unsigned long apid;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
+		vfio_ap_mdev_link_apqn(matrix_mdev, AP_MKQID(apid, apqi));
+}
+
 /**
  * assign_domain_store
  *
@@ -811,6 +869,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
 	ret = count;
 	goto done;
 
@@ -823,6 +882,14 @@ static ssize_t assign_domain_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_domain);
 
+static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
+				       unsigned long apqi)
+{
+	unsigned long apid;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
+		vfio_ap_mdev_unlink_apqn(AP_MKQID(apid, apqi));
+}
 
 /**
  * unassign_domain_store
@@ -871,6 +938,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
 	ret = count;
 
 done:
@@ -1447,6 +1515,28 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 }
 
+/*
+ * vfio_ap_queue_link_mdev
+ *
+ * @q: The queue to link with the matrix mdev.
+ *
+ * Links @q with the matrix mdev to which the queue's APQN is assigned.
+ */
+static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
+{
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+	struct ap_matrix_mdev *matrix_mdev;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
+			vfio_ap_mdev_link_queue(matrix_mdev, q);
+			break;
+		}
+	}
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
 	struct vfio_ap_queue *q;
@@ -1457,6 +1547,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	mutex_lock(&matrix_dev->lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
+	vfio_ap_queue_link_mdev(q);
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1469,6 +1560,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&apdev->device);
+
+	if (q->matrix_mdev)
+		vfio_ap_mdev_unlink_queue_fr_mdev(q);
+
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 3ca2da62bdee..af3f53a3ea4c 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
+#include <linux/hashtable.h>
 
 #include "ap_bus.h"
 
@@ -88,6 +89,7 @@ struct ap_matrix_mdev {
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
+	DECLARE_HASHTABLE(qtable, 8);
 };
 
 struct vfio_ap_queue {
@@ -96,6 +98,7 @@ struct vfio_ap_queue {
 	int	apqn;
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
+	struct hlist_node mdev_qnode;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.21.3

