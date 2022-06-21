Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A55536D9
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353315AbiFUPwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353233AbiFUPvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A2B2CCA7;
        Tue, 21 Jun 2022 08:51:53 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEpvT3012976;
        Tue, 21 Jun 2022 15:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XduZ+URrfA2VQJzIjnk2nNBJzsUGoix3eQkoYluNFPU=;
 b=K8U7wqeSkyhNbyuxsKPlM7sud13fyCUlXQfiobYvkPuHb1KslAUuBLA9Xt1Jue6Td+r5
 iSV5l4t92ZlppSXCbeIED04KBEC4rorD5l6O46T4sxQNqE/5pAahfHaA36X7Fl8VFpkd
 Es/1Zb5sUo4WjSiH4NQopKhbo0hDgewrcQkVza6FXTkBQbsbzb48dfr9eevB86Wxu4nc
 c/ABR6xDvqo1jT64hAGKtB+7YzL9yd7+0p2UM1D9H6TSw1aP4KsZd7wXZfohkrC8NP0z
 qt166w5ee9n3YshBc7vRO0P9KfTWS4OWtOqMs7R20dSum+M5O1MBvozJMx7fh8nkiORK 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug489uf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:51 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEtS4i026123;
        Tue, 21 Jun 2022 15:51:51 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug489ueu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:51 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZtj8005563;
        Tue, 21 Jun 2022 15:51:50 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3gs6b9t4yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:50 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpm2u26149282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:48 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD4B013605D;
        Tue, 21 Jun 2022 15:51:48 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACF1A13604F;
        Tue, 21 Jun 2022 15:51:47 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:47 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 11/20] s390/vfio-ap: prepare for dynamic update of guest's APCB on queue probe/remove
Date:   Tue, 21 Jun 2022 11:51:25 -0400
Message-Id: <20220621155134.1932383-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kEOz7zlMerfwvRzKAM_3lqbFaIl_oTSH
X-Proofpoint-ORIG-GUID: mRhqMCpYs9XpcL9aJQrg7uc2Si358aSR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 123 ++++++++++++++++++++----------
 1 file changed, 84 insertions(+), 39 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b8f901e6b580..6d55713c7f7a 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -120,6 +120,71 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 	mutex_unlock(&matrix_dev->guests_lock);		\
 })
 
+/**
+ * get_update_locks_by_apqn: Find the mdev to which an APQN is assigned and
+ *			     acquire the locks required to update the APCB of
+ *			     the KVM guest to which the mdev is attached.
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
+static struct ap_matrix_mdev *get_update_locks_by_apqn(int apqn)
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
+ * @q: a pointer to a vfio_ap_queue object.
+ *
+ * The proper locking order is:
+ * 1. q->matrix_dev->guests_lock: required to use the KVM pointer to update a
+ *				  KVM guest's APCB.
+ * 2. q->matrix_mdev->kvm->lock:  required to update a guest's APCB
+ * 3. matrix_dev->mdevs_lock:	  required to access data stored in matrix_mdev
+ *
+ * Note: if @queue is not linked to an ap_matrix_mdev object, the KVM lock
+ *	  will not be taken.
+ */
+#define get_update_locks_for_queue(q) ({			\
+	mutex_lock(&matrix_dev->guests_lock);			\
+	if (q->matrix_mdev && q->matrix_mdev->kvm)		\
+		mutex_lock(&q->matrix_mdev->kvm->lock);		\
+	mutex_lock(&matrix_dev->mdevs_lock);			\
+})
+
 /**
  * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
  *			    hash table of queues assigned to a matrix mdev
@@ -618,21 +683,17 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	matrix_mdev->pqap_hook = handle_pqap;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
 	hash_init(matrix_mdev->qtable.queues);
-	dev_set_drvdata(&mdev->dev, matrix_mdev);
-	mutex_lock(&matrix_dev->mdevs_lock);
-	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
-	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
 		goto err_list;
 	dev_set_drvdata(&mdev->dev, matrix_mdev);
+	mutex_lock(&matrix_dev->mdevs_lock);
+	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
+	mutex_unlock(&matrix_dev->mdevs_lock);
 	return 0;
 
 err_list:
-	mutex_lock(&matrix_dev->mdevs_lock);
-	list_del(&matrix_mdev->node);
-	mutex_unlock(&matrix_dev->mdevs_lock);
 	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 err_dec_available:
@@ -695,11 +756,13 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
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
@@ -1697,32 +1760,11 @@ void vfio_ap_mdev_unregister(void)
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
 	int ret;
 	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
 
 	ret = sysfs_create_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	if (ret)
@@ -1732,17 +1774,18 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	if (!q)
 		return -ENOMEM;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
-	vfio_ap_queue_link_mdev(q);
-	if (q->matrix_mdev) {
-		vfio_ap_mdev_filter_matrix(q->matrix_mdev->matrix.apm,
-					   q->matrix_mdev->matrix.aqm,
-					   q->matrix_mdev);
+	matrix_mdev = get_update_locks_by_apqn(q->apqn);
+
+	if (matrix_mdev) {
+		vfio_ap_mdev_link_queue(matrix_mdev, q);
+		vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm,
+					   matrix_mdev->matrix.aqm,
+					   matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 
 	return 0;
 }
@@ -1751,12 +1794,14 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
 	unsigned long apid;
 	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
 	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	q = dev_get_drvdata(&apdev->device);
+	get_update_locks_for_queue(q);
+	matrix_mdev = q->matrix_mdev;
 
-	if (q->matrix_mdev) {
+	if (matrix_mdev) {
 		vfio_ap_unlink_queue_fr_mdev(q);
 
 		apid = AP_QID_CARD(q->apqn);
@@ -1767,5 +1812,5 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	release_update_locks_for_mdev(matrix_mdev);
 }
-- 
2.35.3

