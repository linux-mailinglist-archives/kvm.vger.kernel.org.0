Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306F444C61
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 21:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfFMTkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 15:40:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729310AbfFMTkV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 15:40:21 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DJajcY079455;
        Thu, 13 Jun 2019 15:40:10 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t3v7thkba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 15:40:10 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5DJEUN9014463;
        Thu, 13 Jun 2019 19:17:01 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 2t1x6t0c8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 19:17:01 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5DJe3v229819214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 19:40:03 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 599966E054;
        Thu, 13 Jun 2019 19:40:03 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B78A26E04C;
        Thu, 13 Jun 2019 19:40:00 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.158.129])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jun 2019 19:40:00 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v4 5/7] s390: vfio-ap: allow assignment of unavailable AP resources to mdev device
Date:   Thu, 13 Jun 2019 15:39:38 -0400
Message-Id: <1560454780-20359-6-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AP architecture does not preclude assignment of AP resources that are
not available. Let's go ahead and implement this facet of the AP
architecture for linux guests.

The current implementation does not allow assignment of AP adapters or
domains to an mdev device if the APQNs resulting from the assignment
reference AP queue devices that are not bound to the vfio_ap device
driver. This patch allows assignment of AP resources to the mdev device as
long as the APQNs resulting from the assignment are not reserved by the AP
BUS for use by the zcrypt device drivers and the APQNs are not assigned to
another mdev device.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 231 ++++++++------------------------------
 1 file changed, 44 insertions(+), 187 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 60efd3d7896d..9db86c0db52e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -406,122 +406,6 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
 	NULL,
 };
 
-struct vfio_ap_queue_reserved {
-	unsigned long *apid;
-	unsigned long *apqi;
-	bool reserved;
-};
-
-/**
- * vfio_ap_has_queue
- *
- * @dev: an AP queue device
- * @data: a struct vfio_ap_queue_reserved reference
- *
- * Flags whether the AP queue device (@dev) has a queue ID containing the APQN,
- * apid or apqi specified in @data:
- *
- * - If @data contains both an apid and apqi value, then @data will be flagged
- *   as reserved if the APID and APQI fields for the AP queue device matches
- *
- * - If @data contains only an apid value, @data will be flagged as
- *   reserved if the APID field in the AP queue device matches
- *
- * - If @data contains only an apqi value, @data will be flagged as
- *   reserved if the APQI field in the AP queue device matches
- *
- * Returns 0 to indicate the input to function succeeded. Returns -EINVAL if
- * @data does not contain either an apid or apqi.
- */
-static int vfio_ap_has_queue(struct device *dev, void *data)
-{
-	struct vfio_ap_queue_reserved *qres = data;
-	struct ap_queue *ap_queue = to_ap_queue(dev);
-	ap_qid_t qid;
-	unsigned long id;
-
-	if (qres->apid && qres->apqi) {
-		qid = AP_MKQID(*qres->apid, *qres->apqi);
-		if (qid == ap_queue->qid)
-			qres->reserved = true;
-	} else if (qres->apid && !qres->apqi) {
-		id = AP_QID_CARD(ap_queue->qid);
-		if (id == *qres->apid)
-			qres->reserved = true;
-	} else if (!qres->apid && qres->apqi) {
-		id = AP_QID_QUEUE(ap_queue->qid);
-		if (id == *qres->apqi)
-			qres->reserved = true;
-	} else {
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
- * vfio_ap_verify_queue_reserved
- *
- * @matrix_dev: a mediated matrix device
- * @apid: an AP adapter ID
- * @apqi: an AP queue index
- *
- * Verifies that the AP queue with @apid/@apqi is reserved by the VFIO AP device
- * driver according to the following rules:
- *
- * - If both @apid and @apqi are not NULL, then there must be an AP queue
- *   device bound to the vfio_ap driver with the APQN identified by @apid and
- *   @apqi
- *
- * - If only @apid is not NULL, then there must be an AP queue device bound
- *   to the vfio_ap driver with an APQN containing @apid
- *
- * - If only @apqi is not NULL, then there must be an AP queue device bound
- *   to the vfio_ap driver with an APQN containing @apqi
- *
- * Returns 0 if the AP queue is reserved; otherwise, returns -EADDRNOTAVAIL.
- */
-static int vfio_ap_verify_queue_reserved(unsigned long *apid,
-					 unsigned long *apqi)
-{
-	int ret;
-	struct vfio_ap_queue_reserved qres;
-
-	qres.apid = apid;
-	qres.apqi = apqi;
-	qres.reserved = false;
-
-	ret = driver_for_each_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				     &qres, vfio_ap_has_queue);
-	if (ret)
-		return ret;
-
-	if (qres.reserved)
-		return 0;
-
-	return -EADDRNOTAVAIL;
-}
-
-static int
-vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
-					     unsigned long apid)
-{
-	int ret;
-	unsigned long apqi;
-	unsigned long nbits = matrix_mdev->matrix.aqm_max + 1;
-
-	if (find_first_bit_inv(matrix_mdev->matrix.aqm, nbits) >= nbits)
-		return vfio_ap_verify_queue_reserved(&apid, NULL);
-
-	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, nbits) {
-		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 /**
  * vfio_ap_mdev_verify_no_sharing
  *
@@ -529,18 +413,26 @@ vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
  * and AP queue indexes comprising the AP matrix are not configured for another
  * mediated device. AP queue sharing is not allowed.
  *
- * @matrix_mdev: the mediated matrix device
+ * @mdev_apm: the mask identifying the adapters assigned to mdev
+ * @mdev_apm: the mask identifying the adapters assigned to mdev
  *
  * Returns 0 if the APQNs are not shared, otherwise; returns -EADDRINUSE.
  */
-static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
+					  unsigned long *mdev_aqm)
 {
 	struct ap_matrix_mdev *lstdev;
 	DECLARE_BITMAP(apm, AP_DEVICES);
 	DECLARE_BITMAP(aqm, AP_DOMAINS);
 
 	list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
-		if (matrix_mdev == lstdev)
+		/*
+		 * If either of the input masks belongs to the mdev to which an
+		 * AP resource is being assigned, then we don't need to verify
+		 * that mdev's masks.
+		 */
+		if ((mdev_apm == lstdev->matrix.apm) ||
+		    (mdev_aqm == lstdev->matrix.aqm))
 			continue;
 
 		memset(apm, 0, sizeof(apm));
@@ -550,12 +442,10 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 		 * We work on full longs, as we can only exclude the leftover
 		 * bits in non-inverse order. The leftover is all zeros.
 		 */
-		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
-				lstdev->matrix.apm, AP_DEVICES))
+		if (!bitmap_and(apm, mdev_apm, lstdev->matrix.apm, AP_DEVICES))
 			continue;
 
-		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
-				lstdev->matrix.aqm, AP_DOMAINS))
+		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
 			continue;
 
 		return -EADDRINUSE;
@@ -564,6 +454,17 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 	return 0;
 }
 
+static int vfio_ap_mdev_validate_masks(unsigned long *apm, unsigned long *aqm)
+{
+	int ret;
+
+	ret = ap_apqn_in_matrix_owned_by_def_drv(apm, aqm);
+	if (ret)
+		return (ret == 1) ? -EADDRNOTAVAIL : ret;
+
+	return vfio_ap_mdev_verify_no_sharing(apm, aqm);
+}
+
 /**
  * assign_adapter_store
  *
@@ -602,6 +503,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
+	DECLARE_BITMAP(apm, AP_DEVICES);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
@@ -616,32 +518,19 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (apid > matrix_mdev->matrix.apm_max)
 		return -ENODEV;
 
-	/*
-	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
-	 * number (APID). The bits in the mask, from most significant to least
-	 * significant bit, correspond to APIDs 0-255.
-	 */
-	mutex_lock(&matrix_dev->lock);
-
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
-	if (ret)
-		goto done;
+	memset(apm, 0, ARRAY_SIZE(apm) * sizeof(*apm));
+	set_bit_inv(apid, apm);
 
+	mutex_lock(&matrix_dev->lock);
+	ret = vfio_ap_mdev_validate_masks(apm, matrix_mdev->matrix.aqm);
+	if (ret) {
+		mutex_unlock(&matrix_dev->lock);
+		return ret;
+	}
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
-
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
-	if (ret)
-		goto share_err;
-
-	ret = count;
-	goto done;
-
-share_err:
-	clear_bit_inv(apid, matrix_mdev->matrix.apm);
-done:
 	mutex_unlock(&matrix_dev->lock);
 
-	return ret;
+	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
@@ -690,26 +579,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(unassign_adapter);
 
-static int
-vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
-					     unsigned long apqi)
-{
-	int ret;
-	unsigned long apid;
-	unsigned long nbits = matrix_mdev->matrix.apm_max + 1;
-
-	if (find_first_bit_inv(matrix_mdev->matrix.apm, nbits) >= nbits)
-		return vfio_ap_verify_queue_reserved(NULL, &apqi);
-
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, nbits) {
-		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 /**
  * assign_domain_store
  *
@@ -748,6 +617,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
+	DECLARE_BITMAP(aqm, AP_DEVICES);
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
@@ -762,27 +632,19 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (apqi > max_apqi)
 		return -ENODEV;
 
-	mutex_lock(&matrix_dev->lock);
-
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
-	if (ret)
-		goto done;
+	memset(aqm, 0, ARRAY_SIZE(aqm) * sizeof(*aqm));
+	set_bit_inv(apqi, aqm);
 
+	mutex_lock(&matrix_dev->lock);
+	ret = vfio_ap_mdev_validate_masks(matrix_mdev->matrix.apm, aqm);
+	if (ret) {
+		mutex_unlock(&matrix_dev->lock);
+		return ret;
+	}
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
-
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
-	if (ret)
-		goto share_err;
-
-	ret = count;
-	goto done;
-
-share_err:
-	clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
-done:
 	mutex_unlock(&matrix_dev->lock);
 
-	return ret;
+	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
 
@@ -868,11 +730,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	if (id > matrix_mdev->matrix.adm_max)
 		return -ENODEV;
 
-	/* Set the bit in the ADM (bitmask) corresponding to the AP control
-	 * domain number (id). The bits in the mask, from most significant to
-	 * least significant, correspond to IDs 0 up to the one less than the
-	 * number of control domains that can be assigned.
-	 */
 	mutex_lock(&matrix_dev->lock);
 	set_bit_inv(id, matrix_mdev->matrix.adm);
 	mutex_unlock(&matrix_dev->lock);
-- 
2.7.4

