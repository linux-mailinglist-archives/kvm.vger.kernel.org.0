Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80B14F1F9C
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbiDDWzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiDDWxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0934B866;
        Mon,  4 Apr 2022 15:11:52 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234M8bYc025447;
        Mon, 4 Apr 2022 22:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kkbGMgbQIe4tg+6iET2AXWCkrgsMHaxK9B/SFFNVZg8=;
 b=fsBnwdfcF/Kgnfi73rWIzzZABK/Haechb2IzZzeDi00M2gTjtTgqA++UzHOSJcJLil3J
 0n4ck3YCP8pNDYYoPZ91zrbwWPMOSroBRZVOojWqSd1iaFUfVR06tyT1/g2OUsWTSTH/
 IYHoLBWcC1XeqoXkJAMITNfVqEI07JPc4b1ul6YPViiiPvnfpHrednblRL8dFUfwwbRi
 0cTmuR2d0udCr91P0SF4beBjtMWnW5/wW6fHIgTHlnAHzlPpcBjJA8qfDloZ7cdNh2zq
 Eo+CjQe3yPBFM7HhYO9VAa51r2c0j2hVnFI4wceDDWAz/i3itrLIaQa57l3CynSJOxLL HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy1at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:51 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234LsCIs009869;
        Mon, 4 Apr 2022 22:11:50 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy1ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:50 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lr2QS017275;
        Mon, 4 Apr 2022 22:11:49 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3f6e48tp6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:49 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBm2415925644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:48 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FBD37805F;
        Mon,  4 Apr 2022 22:11:48 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 686647805C;
        Mon,  4 Apr 2022 22:11:47 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:47 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 03/20] s390/vfio-ap: manage link between queue struct and matrix mdev
Date:   Mon,  4 Apr 2022 18:10:22 -0400
Message-Id: <20220404221039.1272245-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S6FsWadrK16Vni7a2iJu-o3MimvpVzWf
X-Proofpoint-ORIG-GUID: wDl1ooPSnyHyWJOivyAhmd6ZuKuckbbZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
   structure representing the queue will be removed. Since the storage
   allocated for the vfio_ap_queue will be freed, there is no need to
   remove the link to the matrix_mdev to which the queue's APQN is
   assigned.

 * When an adapter or domain is unassigned from a matrix mdev, for each
   APQN unassigned that references a queue device bound to the vfio_ap
   device driver, the structures representing the queue device and the
   matrix mdev will be unlinked.

 * When an mdev is removed, the link from any queues assigned to the mdev
   to the mdev will be removed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 191 +++++++++++++++++++++-----
 drivers/s390/crypto/vfio_ap_private.h |  14 ++
 2 files changed, 168 insertions(+), 37 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 16220157dbe3..9df7ceb50ed1 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -31,32 +31,27 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 
 /**
- * vfio_ap_get_queue - retrieve a queue with a specific APQN from a list
- * @matrix_mdev: the associated mediated matrix
- * @apqn: The queue APQN
+ * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
+ *			    hash table of queues assigned to a matrix mdev
+ * @matrix_mdev: the matrix mdev
+ * @apqn: The APQN of a queue device
  *
- * Retrieve a queue with a specific APQN from the list of the
- * devices of the vfio_ap_drv.
- * Verify that the APID and the APQI are set in the matrix.
- *
- * Return: the pointer to the associated vfio_ap_queue
+ * Return: the pointer to the vfio_ap_queue struct representing the queue or
+ *	   NULL if the queue is not assigned to @matrix_mdev
  */
-static struct vfio_ap_queue *vfio_ap_get_queue(
+static struct vfio_ap_queue *vfio_ap_mdev_get_queue(
 					struct ap_matrix_mdev *matrix_mdev,
 					int apqn)
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
+	hash_for_each_possible(matrix_mdev->qtable.queues, q, mdev_qnode,
+			       apqn) {
+		if (q && q->apqn == apqn)
+			return q;
+	}
 
-	return q;
+	return NULL;
 }
 
 /**
@@ -174,7 +169,6 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 		  status.response_code);
 end_free:
 	vfio_ap_free_aqic_resources(q);
-	q->matrix_mdev = NULL;
 	return status;
 }
 
@@ -419,7 +413,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	q = vfio_ap_get_queue(matrix_mdev, apqn);
+	q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
 	if (!q) {
 		VFIO_AP_DBF_WARN("%s: Queue %02x.%04x not bound to the vfio_ap driver\n",
 				 __func__, AP_QID_CARD(apqn),
@@ -469,6 +463,8 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	matrix_mdev->pqap_hook = handle_pqap;
+	hash_init(matrix_mdev->qtable.queues);
+	mdev_set_drvdata(mdev, matrix_mdev);
 	mutex_lock(&matrix_dev->lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
@@ -490,6 +486,55 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	return ret;
 }
 
+static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
+				    struct vfio_ap_queue *q)
+{
+	if (q) {
+		q->matrix_mdev = matrix_mdev;
+		hash_add(matrix_mdev->qtable.queues, &q->mdev_qnode, q->apqn);
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
+static void vfio_ap_unlink_queue_fr_mdev(struct vfio_ap_queue *q)
+{
+	hash_del(&q->mdev_qnode);
+}
+
+static void vfio_ap_unlink_mdev_fr_queue(struct vfio_ap_queue *q)
+{
+	q->matrix_mdev = NULL;
+}
+
+static void vfio_ap_mdev_unlink_queue(struct vfio_ap_queue *q)
+{
+	vfio_ap_unlink_queue_fr_mdev(q);
+	vfio_ap_unlink_mdev_fr_queue(q);
+}
+
+static void vfio_ap_mdev_unlink_fr_queues(struct ap_matrix_mdev *matrix_mdev)
+{
+	struct vfio_ap_queue *q;
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
+				     AP_DOMAINS) {
+			q = vfio_ap_mdev_get_queue(matrix_mdev,
+						   AP_MKQID(apid, apqi));
+			if (q)
+				q->matrix_mdev = NULL;
+		}
+	}
+}
+
 static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(&mdev->dev);
@@ -498,6 +543,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
+	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
@@ -706,6 +752,16 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 	return 0;
 }
 
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
  * assign_adapter_store - parses the APID from @buf and sets the
  * corresponding bit in the mediated matrix device's APM
@@ -776,6 +832,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
 	ret = count;
 	goto done;
 
@@ -788,6 +845,20 @@ static ssize_t assign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long apid)
+{
+	unsigned long apqi;
+	struct vfio_ap_queue *q;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
+		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+
+		if (q)
+			vfio_ap_mdev_unlink_queue(q);
+	}
+}
+
 /**
  * unassign_adapter_store - parses the APID from @buf and clears the
  * corresponding bit in the mediated matrix device's APM
@@ -829,6 +900,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -856,6 +928,16 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
+				      unsigned long apqi)
+{
+	unsigned long apid;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
+		vfio_ap_mdev_link_apqn(matrix_mdev,
+				       AP_MKQID(apid, apqi));
+}
+
 /**
  * assign_domain_store - parses the APQI from @buf and sets the
  * corresponding bit in the mediated matrix device's AQM
@@ -921,6 +1003,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
 	ret = count;
 	goto done;
 
@@ -933,6 +1016,19 @@ static ssize_t assign_domain_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_domain);
 
+static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
+				       unsigned long apqi)
+{
+	unsigned long apid;
+	struct vfio_ap_queue *q;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
+		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+
+		if (q)
+			vfio_ap_mdev_unlink_queue(q);
+	}
+}
 
 /**
  * unassign_domain_store - parses the APQI from @buf and clears the
@@ -975,6 +1071,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
 	ret = count;
 
 done:
@@ -1366,25 +1463,18 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 
 static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev)
 {
-	int ret;
-	int rc = 0;
-	unsigned long apid, apqi;
+	int ret, loop_cursor, rc = 0;
 	struct vfio_ap_queue *q;
 
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
-			     matrix_mdev->matrix.apm_max + 1) {
-		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
-				     matrix_mdev->matrix.aqm_max + 1) {
-			q = vfio_ap_find_queue(AP_MKQID(apid, apqi));
-			ret = vfio_ap_mdev_reset_queue(q, 1);
-			/*
-			 * Regardless whether a queue turns out to be busy, or
-			 * is not operational, we need to continue resetting
-			 * the remaining queues.
-			 */
-			if (ret)
-				rc = ret;
-		}
+	hash_for_each(matrix_mdev->qtable.queues, loop_cursor, q, mdev_qnode) {
+		ret = vfio_ap_mdev_reset_queue(q, 1);
+		/*
+		 * Regardless whether a queue turns out to be busy, or
+		 * is not operational, we need to continue resetting
+		 * the remaining queues.
+		 */
+		if (ret)
+			rc = ret;
 	}
 
 	return rc;
@@ -1524,6 +1614,28 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
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
@@ -1534,6 +1646,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	mutex_lock(&matrix_dev->lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
+	vfio_ap_queue_link_mdev(q);
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1546,6 +1659,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&apdev->device);
+
+	if (q->matrix_mdev)
+		vfio_ap_unlink_queue_fr_mdev(q);
+
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 3cade25a1620..aea6a8b854b3 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
 #include <linux/vfio.h>
+#include <linux/hashtable.h>
 
 #include "ap_bus.h"
 
@@ -74,6 +75,15 @@ struct ap_matrix {
 	DECLARE_BITMAP(adm, 256);
 };
 
+/**
+ * struct ap_queue_table - a table of queue objects.
+ *
+ * @queues: a hashtable of queues (struct vfio_ap_queue).
+ */
+struct ap_queue_table {
+	DECLARE_HASHTABLE(queues, 8);
+};
+
 /**
  * struct ap_matrix_mdev - Contains the data associated with a matrix mediated
  *			   device.
@@ -89,6 +99,7 @@ struct ap_matrix {
  * @pqap_hook:	the function pointer to the interception handler for the
  *		PQAP(AQIC) instruction.
  * @mdev:	the mediated device
+ * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
  */
 struct ap_matrix_mdev {
 	struct vfio_device vdev;
@@ -99,6 +110,7 @@ struct ap_matrix_mdev {
 	struct kvm *kvm;
 	crypto_hook pqap_hook;
 	struct mdev_device *mdev;
+	struct ap_queue_table qtable;
 };
 
 /**
@@ -108,6 +120,7 @@ struct ap_matrix_mdev {
  * @saved_pfn: the guest PFN pinned for the guest
  * @apqn: the APQN of the AP queue device
  * @saved_isc: the guest ISC registered with the GIB interface
+ * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -115,6 +128,7 @@ struct vfio_ap_queue {
 	int	apqn;
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
+	struct hlist_node mdev_qnode;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.31.1

