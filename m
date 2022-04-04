Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32994F1FA3
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiDDWzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbiDDWxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6254BB85;
        Mon,  4 Apr 2022 15:12:02 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234LdtA3022310;
        Mon, 4 Apr 2022 22:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ylM6mZCmLxgj/fHt90aTLKLW2zOnz0ALa+cVOGYwblI=;
 b=qzMsKpvuyB0Pb5Wol+LOVem6c46k96Lj8WYKiUm0rFZFN2IppqXFJk4W7PfXnRoIl/pM
 bFm30/Flkty4lW8yLKJKxbUHPZEp2meQcmDWU2QUWSKH1+A59uubliIWqglm9fFlu0ex
 NJer64hqU4Tt9BpJO3O4o8ZcVZJ6jyo3Y8CmayaI7cVKfD8Jn1cu9pCBmfZ+bI7ExrZX
 /cT8oCXl9ocagMYvxW0laCY0sWIesrTFVpJUIntUMFraTkF5ht7doIR7JAQh8qh8Yxsl
 IQXGiFhnxoKkAS4AqiOlewt8ZLUMzUqcf46wnVxONfG198N4LJ/Lsi15X+yCxasQJWl9 ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f87jtanws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:00 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234LnBkn005898;
        Mon, 4 Apr 2022 22:12:00 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f87jtanw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:00 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234LrD9H017364;
        Mon, 4 Apr 2022 22:11:59 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3f6e48tp7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:59 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBwIw33620300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:58 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E92ED78063;
        Mon,  4 Apr 2022 22:11:57 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E393A78060;
        Mon,  4 Apr 2022 22:11:56 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:56 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 11/20] s390/vfio-ap: prepare for dynamic update of guest's APCB on queue probe/remove
Date:   Mon,  4 Apr 2022 18:10:30 -0400
Message-Id: <20220404221039.1272245-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: btX9duJUmWOtw1m-wm5-NEMzs6vPEJ_9
X-Proofpoint-ORIG-GUID: bTEjfwPVrssVuX4r5i6Is_z52-nJE-Yl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The callback functions for probing and removing a queue device must take
and release the locks required to perform a dynamic update of a guest's
APCB in the proper order.

The proper order for taking the locks is:

        matrix_dev->guests_lock => kvm->lock => matrix_dev->mdevs_lock

The proper order for releasing the locks is:

        matrix_dev->mdevs_lock => kvm->lock => matrix_dev->guests_lock

A new helper function is introduced to be used by the probe callback to
acquire the required locks. Since the probe callback only has
access to a queue device when it is called, the helper function will find
the ap_matrix_mdev object to which the queue device's APQN is assigned and
return it so the KVM guest to which the mdev is attached can be dynamically
updated.

Note that in order to find the ap_matrix_mdev (matrix_mdev) object, it is
necessary to search the matrix_dev->mdev_list. This presents a
locking order dilemma because the matrix_dev->mdevs_lock can't be taken to
protect against changes to the list while searching for the matrix_mdev to
which a queue device's APQN is assigned. This is due to the fact that the
proper locking order requires that the matrix_dev->mdevs_lock be taken
after both the matrix_mdev->kvm->lock and the matrix_dev->mdevs_lock.
Consequently, the matrix_dev->guests_lock will be used to protect against
removal of a matrix_mdev object from the list while a queue device is
being probed. This necessitates changes to the mdev probe/remove
callback functions to take the matrix_dev->guests_lock prior to removing
a matrix_mdev object from the list.

A new macro is also introduced to acquire the locks required to dynamically
update the guest's APCB in the proper order when a queue device is
removed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 126 +++++++++++++++++++++---------
 1 file changed, 88 insertions(+), 38 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 2219b1069ceb..080a733f7cd2 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -116,6 +116,74 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 	mutex_unlock(&matrix_dev->guests_lock);		\
 })
 
+/**
+ * vfio_ap_mdev_get_update_locks_for_apqn: retrieve the matrix mdev to which an
+ *					   APQN is assigned and acquire the
+ *					   locks required to update the APCB of
+ *					   the KVM guest to which the mdev is
+ *					   attached.
+ *
+ * @apqn: the APQN of a queue device.
+ *
+ * The proper locking order is:
+ * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
+ *			       guest's APCB.
+ * 2. matrix_mdev->kvm->lock:  required to update a guest's APCB
+ * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
+ *
+ * Note: If @apqn is not assigned to a matrix_mdev, the matrix_mdev->kvm->lock
+ *	 will not be taken.
+ *
+ * Return: the ap_matrix_mdev object to which @apqn is assigned or NULL if @apqn
+ *	   is not assigned to an ap_matrix_mdev.
+ */
+static struct ap_matrix_mdev *vfio_ap_mdev_get_update_locks_for_apqn(int apqn)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	mutex_lock(&matrix_dev->guests_lock);
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm) &&
+		    test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm)) {
+			if (matrix_mdev->kvm)
+				mutex_lock(&matrix_mdev->kvm->lock);
+
+			mutex_lock(&matrix_dev->mdevs_lock);
+
+			return matrix_mdev;
+		}
+	}
+
+	mutex_lock(&matrix_dev->mdevs_lock);
+
+	return NULL;
+}
+
+/**
+ * get_update_locks_for_queue: get the locks required to update the APCB of the
+ *			       KVM guest to which the matrix mdev linked to a
+ *			       vfio_ap_queue object is attached.
+ *
+ * @queue: a pointer to a vfio_ap_queue object.
+ *
+ * The proper locking order is:
+ * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
+ *				guest's APCB.
+ * 2. queue->matrix_mdev->kvm->lock: required to update a guest's APCB
+ * 3. matrix_dev->mdevs_lock:	required to access data stored in a matrix_mdev
+ *
+ * Note: if @queue is not linked to an ap_matrix_mdev object, the KVM lock
+ *	  will not be taken.
+ */
+#define get_update_locks_for_queue(queue) ({			\
+	struct ap_matrix_mdev *matrix_mdev = q->matrix_mdev;	\
+	mutex_lock(&matrix_dev->guests_lock);			\
+	if (matrix_mdev && matrix_mdev->kvm)			\
+		mutex_lock(&matrix_mdev->kvm->lock);		\
+	mutex_lock(&matrix_dev->mdevs_lock);			\
+})
+
 /**
  * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
  *			    hash table of queues assigned to a matrix mdev
@@ -615,21 +683,18 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	matrix_mdev->pqap_hook = handle_pqap;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
-	mdev_set_drvdata(mdev, matrix_mdev);
-	mutex_lock(&matrix_dev->mdevs_lock);
-	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
-	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
 		goto err_list;
+	mdev_set_drvdata(mdev, matrix_mdev);
+	mutex_lock(&matrix_dev->mdevs_lock);
+	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	dev_set_drvdata(&mdev->dev, matrix_mdev);
 	return 0;
 
 err_list:
-	mutex_lock(&matrix_dev->mdevs_lock);
-	list_del(&matrix_mdev->node);
-	mutex_unlock(&matrix_dev->mdevs_lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 err_dec_available:
@@ -692,11 +757,13 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	vfio_unregister_group_dev(&matrix_mdev->vdev);
 
+	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 	atomic_inc(&matrix_dev->available_instances);
@@ -1665,49 +1732,30 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
 
-/*
- * vfio_ap_queue_link_mdev
- *
- * @q: The queue to link with the matrix mdev.
- *
- * Links @q with the matrix mdev to which the queue's APQN is assigned.
- */
-static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
-{
-	unsigned long apid = AP_QID_CARD(q->apqn);
-	unsigned long apqi = AP_QID_QUEUE(q->apqn);
-	struct ap_matrix_mdev *matrix_mdev;
-
-	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
-		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
-		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
-			vfio_ap_mdev_link_queue(matrix_mdev, q);
-			break;
-		}
-	}
-}
-
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
 	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
 	DECLARE_BITMAP(apm_delta, AP_DEVICES);
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
 		return -ENOMEM;
-	mutex_lock(&matrix_dev->mdevs_lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
-	vfio_ap_queue_link_mdev(q);
-	if (q->matrix_mdev) {
+
+	matrix_mdev = vfio_ap_mdev_get_update_locks_for_apqn(q->apqn);
+
+	if (matrix_mdev) {
+		vfio_ap_mdev_link_queue(matrix_mdev, q);
 		memset(apm_delta, 0, sizeof(apm_delta));
 		set_bit_inv(AP_QID_CARD(q->apqn), apm_delta);
 		vfio_ap_mdev_filter_matrix(apm_delta,
-					   q->matrix_mdev->matrix.aqm,
-					   q->matrix_mdev);
+					   matrix_mdev->matrix.aqm,
+					   matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 
 	return 0;
 }
@@ -1716,11 +1764,13 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
 	unsigned long apid;
 	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
+	get_update_locks_for_queue(q);
+	matrix_mdev = q->matrix_mdev;
 
-	if (q->matrix_mdev) {
+	if (matrix_mdev) {
 		vfio_ap_unlink_queue_fr_mdev(q);
 
 		apid = AP_QID_CARD(q->apqn);
@@ -1731,5 +1781,5 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 }
-- 
2.31.1

