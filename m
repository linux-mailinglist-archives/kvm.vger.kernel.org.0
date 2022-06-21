Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853435536B0
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353191AbiFUPvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353139AbiFUPvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FC72CE16;
        Tue, 21 Jun 2022 08:51:44 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFgcSL030350;
        Tue, 21 Jun 2022 15:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dXDBIJngFF3Ee7TFxsbG2o7il2A3tjDPMfOEIEBSE3M=;
 b=kLS1HOYLsh1+IvfFHWJSr296DC2uOOEo47cDq7ZbBdpkqW25LwchRsy2KbPQg3AzoDok
 GJ8LaStl+EOL9mf7uycNpMYPlfZIkwESPuk7UI9VOMXBBwbDL5RBLLPLOCTRInypcrVe
 YCumQVUwBsWPNLduUqARpQHbBZxfpozJqLZNZvrk8LXyBRc7TDsm3l5bNyv2l9L1bGJ8
 ebquMEa6Cr7rx5ND7HtttwZJjXL5KFdGxWHCfe2G4Evbn28JcdblbNdOGmFdUO5bQCFy
 MhTSiiAnoAr8F4+fUFL5vxQkb7RsC7G58JSolLuGaUkrACmRJAfg5osEYDYZcSd+WkPX uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugvag82c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:42 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFhQlf005064;
        Tue, 21 Jun 2022 15:51:41 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugvag820-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:41 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZvoN031799;
        Tue, 21 Jun 2022 15:51:41 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3gt0091y6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:40 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpd8132571778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:39 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72E7C136059;
        Tue, 21 Jun 2022 15:51:39 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64D7D136055;
        Tue, 21 Jun 2022 15:51:38 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:38 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 03/20] s390/vfio-ap: manage link between queue struct and matrix mdev
Date:   Tue, 21 Jun 2022 11:51:17 -0400
Message-Id: <20220621155134.1932383-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Rlbu5X72TH3xjbyQRu0FQyMlcxg5uMNb
X-Proofpoint-ORIG-GUID: CVhyWxpdhPLVg5Dt2cYAjFDqaCQRyKGX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 32d276c85079..77840d26220b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -35,32 +35,27 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
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
@@ -177,7 +172,6 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 		  status.response_code);
 end_free:
 	vfio_ap_free_aqic_resources(q);
-	q->matrix_mdev = NULL;
 	return status;
 }
 
@@ -422,7 +416,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	q = vfio_ap_get_queue(matrix_mdev, apqn);
+	q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
 	if (!q) {
 		VFIO_AP_DBF_WARN("%s: Queue %02x.%04x not bound to the vfio_ap driver\n",
 				 __func__, AP_QID_CARD(apqn),
@@ -472,6 +466,8 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	matrix_mdev->pqap_hook = handle_pqap;
+	hash_init(matrix_mdev->qtable.queues);
+	dev_set_drvdata(&mdev->dev, matrix_mdev);
 	mutex_lock(&matrix_dev->lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
@@ -493,6 +489,55 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
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
@@ -501,6 +546,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
+	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
@@ -709,6 +755,16 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
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
@@ -779,6 +835,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
 	ret = count;
 	goto done;
 
@@ -791,6 +848,20 @@ static ssize_t assign_adapter_store(struct device *dev,
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
@@ -832,6 +903,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
 	ret = count;
 done:
 	mutex_unlock(&matrix_dev->lock);
@@ -859,6 +931,16 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
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
@@ -924,6 +1006,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
 	ret = count;
 	goto done;
 
@@ -936,6 +1019,19 @@ static ssize_t assign_domain_store(struct device *dev,
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
@@ -978,6 +1074,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
 	ret = count;
 
 done:
@@ -1351,25 +1448,18 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 
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
@@ -1556,6 +1646,28 @@ void vfio_ap_mdev_unregister(void)
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
 	int ret;
@@ -1572,6 +1684,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	mutex_lock(&matrix_dev->lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
+	vfio_ap_queue_link_mdev(q);
 	dev_set_drvdata(&apdev->device, q);
 	mutex_unlock(&matrix_dev->lock);
 
@@ -1585,6 +1698,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	mutex_lock(&matrix_dev->lock);
 	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	q = dev_get_drvdata(&apdev->device);
+
+	if (q->matrix_mdev)
+		vfio_ap_unlink_queue_fr_mdev(q);
+
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 96655f2eb732..44d2eeb795a0 100644
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
@@ -87,6 +97,7 @@ struct ap_matrix {
  * @pqap_hook:	the function pointer to the interception handler for the
  *		PQAP(AQIC) instruction.
  * @mdev:	the mediated device
+ * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
  */
 struct ap_matrix_mdev {
 	struct vfio_device vdev;
@@ -96,6 +107,7 @@ struct ap_matrix_mdev {
 	struct kvm *kvm;
 	crypto_hook pqap_hook;
 	struct mdev_device *mdev;
+	struct ap_queue_table qtable;
 };
 
 /**
@@ -105,6 +117,7 @@ struct ap_matrix_mdev {
  * @saved_pfn: the guest PFN pinned for the guest
  * @apqn: the APQN of the AP queue device
  * @saved_isc: the guest ISC registered with the GIB interface
+ * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -112,6 +125,7 @@ struct vfio_ap_queue {
 	int	apqn;
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
+	struct hlist_node mdev_qnode;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.35.3

