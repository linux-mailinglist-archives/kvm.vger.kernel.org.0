Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB65436614
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhJUP0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5282 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231992AbhJUP01 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:27 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEI2Jp012432;
        Thu, 21 Oct 2021 11:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D7hm2zAH0OQlC3ZqjKAngVZg5HevCVBT6DR2iUOtL8s=;
 b=REW/DkUO5eMhPkqEK06BMrR5QUjTMxvIJOS/nULEezXAVDOLdIgW34sjhxpdYnKSQfrc
 eLBel0QgZMXzfMXsf40Mkpv63zGEFdKfD+6fSqi847xr3+aQUXKRXsor7UzIPAeNc9wS
 LiCJ7a4ailBySLmeRS2qT+xmVy0goKe7zMd+1+pCDpkLjaAN40YQFt0pOI2k+wLm+Cha
 5OgQPPC7Y/TJi35+CXQsgfU8wLlt1+sF3qsz2C0Cmcf2APoopgu0jeLShS4T2DN4glV/
 ySqDUfF6DCzPAjXON9mFBAY1rhLe1y5UV4lucUho3SJ2XJlMa3Cpnxc3a4vw+lJ/SlU1 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btxuu05j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:07 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LEnQqh004170;
        Thu, 21 Oct 2021 11:24:07 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btxuu05hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:24:07 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF42Ip009635;
        Thu, 21 Oct 2021 15:24:06 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 3bqpccfqq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:24:06 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFO4rB44892588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:24:04 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98D9EBE065;
        Thu, 21 Oct 2021 15:24:04 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A904BE051;
        Thu, 21 Oct 2021 15:24:02 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:24:02 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 07/15] s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
Date:   Thu, 21 Oct 2021 11:23:24 -0400
Message-Id: <20211021152332.70455-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I99A1cc_c8lPwoFyzKmeGy3ORMgHC9D7
X-Proofpoint-GUID: -pYj0KzExDa9yYJgf9ulseWAg7WW8hW2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1015 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current implementation does not allow assignment of an AP adapter or
domain to an mdev device if each APQN resulting from the assignment
does not reference an AP queue device that is bound to the vfio_ap device
driver. This patch allows assignment of AP resources to the matrix mdev as
long as the APQNs resulting from the assignment:
   1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
   2. Are not assigned to another matrix mdev.

The rationale behind this is that the AP architecture does not preclude
assignment of APQNs to an AP configuration profile that are not available
to the system.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 224 +++++++-----------------------
 1 file changed, 53 insertions(+), 171 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 46c179363aca..6b40db6dab3c 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -520,141 +520,48 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
 	NULL,
 };
 
-struct vfio_ap_queue_reserved {
-	unsigned long *apid;
-	unsigned long *apqi;
-	bool reserved;
-};
+#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
+			 "already assigned to %s"
 
-/**
- * vfio_ap_has_queue - determines if the AP queue containing the target in @data
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
- * Return: 0 to indicate the input to function succeeded. Returns -EINVAL if
- * @data does not contain either an apid or apqi.
- */
-static int vfio_ap_has_queue(struct device *dev, void *data)
+static void vfio_ap_mdev_log_sharing_err(struct ap_matrix_mdev *matrix_mdev,
+					 unsigned long *apm,
+					 unsigned long *aqm)
 {
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
- * vfio_ap_verify_queue_reserved - verifies that the AP queue containing
- * @apid or @aqpi is reserved
- *
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
- * Return: 0 if the AP queue is reserved; otherwise, returns -EADDRNOTAVAIL.
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
+	unsigned long apid, apqi;
+	const struct device *dev = mdev_dev(matrix_mdev->mdev);
+	const char *mdev_name = dev_name(dev);
 
-	return 0;
+	for_each_set_bit_inv(apid, apm, AP_DEVICES)
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
+			dev_warn(dev, MDEV_SHARING_ERR, apid, apqi, mdev_name);
 }
 
 /**
- * vfio_ap_mdev_verify_no_sharing - verifies that the AP matrix is not configured
+ * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs
  *
- * @matrix_mdev: the mediated matrix device
+ * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
+ * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified
  *
- * Verifies that the APQNs derived from the cross product of the AP adapter IDs
- * and AP queue indexes comprising the AP matrix are not configured for another
+ * Verifies that each APQN derived from the Cartesian product of a bitmap of
+ * AP adapter IDs and AP queue indexes is not configured for any matrix
  * mediated device. AP queue sharing is not allowed.
  *
- * Return: 0 if the APQNs are not shared; otherwise returns -EADDRINUSE.
+ * Return: 0 if the APQNs are not shared; otherwise return -EADDRINUSE.
  */
-static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
+					  unsigned long *mdev_aqm)
 {
-	struct ap_matrix_mdev *lstdev;
+	struct ap_matrix_mdev *matrix_mdev;
 	DECLARE_BITMAP(apm, AP_DEVICES);
 	DECLARE_BITMAP(aqm, AP_DOMAINS);
 
-	list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
-		if (matrix_mdev == lstdev)
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		/*
+		 * If the input apm and aqm belong to the matrix_mdev's matrix,
+		 * then move on to the next.
+		 */
+		if (mdev_apm == matrix_mdev->matrix.apm &&
+		    mdev_aqm == matrix_mdev->matrix.aqm)
 			continue;
 
 		memset(apm, 0, sizeof(apm));
@@ -664,20 +571,32 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 		 * We work on full longs, as we can only exclude the leftover
 		 * bits in non-inverse order. The leftover is all zeros.
 		 */
-		if (!bitmap_and(apm, matrix_mdev->matrix.apm,
-				lstdev->matrix.apm, AP_DEVICES))
+		if (!bitmap_and(apm, mdev_apm, matrix_mdev->matrix.apm,
+				AP_DEVICES))
 			continue;
 
-		if (!bitmap_and(aqm, matrix_mdev->matrix.aqm,
-				lstdev->matrix.aqm, AP_DOMAINS))
+		if (!bitmap_and(aqm, mdev_aqm, matrix_mdev->matrix.aqm,
+				AP_DOMAINS))
 			continue;
 
+		vfio_ap_mdev_log_sharing_err(matrix_mdev, apm, aqm);
+
 		return -EADDRINUSE;
 	}
 
 	return 0;
 }
 
+static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev)
+{
+	if (ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
+					       matrix_mdev->matrix.aqm))
+		return -EADDRNOTAVAIL;
+
+	return vfio_ap_mdev_verify_no_sharing(matrix_mdev->matrix.apm,
+					      matrix_mdev->matrix.aqm);
+}
+
 static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
 				      unsigned long apid)
 {
@@ -743,28 +662,17 @@ static ssize_t assign_adapter_store(struct device *dev,
 		goto done;
 	}
 
-	/*
-	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
-	 * number (APID). The bits in the mask, from most significant to least
-	 * significant bit, correspond to APIDs 0-255.
-	 */
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
-	if (ret)
-		goto done;
-
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
-	if (ret)
-		goto share_err;
+	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
+	if (ret) {
+		clear_bit_inv(apid, matrix_mdev->matrix.apm);
+		goto done;
+	}
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
 	vfio_ap_mdev_filter_matrix(matrix_mdev);
 	ret = count;
-	goto done;
-
-share_err:
-	clear_bit_inv(apid, matrix_mdev->matrix.apm);
 done:
 	mutex_unlock(&matrix_dev->lock);
 
@@ -836,26 +744,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
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
 static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
 				      unsigned long apqi)
 {
@@ -921,23 +809,17 @@ static ssize_t assign_domain_store(struct device *dev,
 		goto done;
 	}
 
-	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
-	if (ret)
-		goto done;
-
 	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
 
-	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev);
-	if (ret)
-		goto share_err;
+	ret = vfio_ap_mdev_validate_masks(matrix_mdev);
+	if (ret) {
+		clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
+		goto done;
+	}
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
 	vfio_ap_mdev_filter_matrix(matrix_mdev);
 	ret = count;
-	goto done;
-
-share_err:
-	clear_bit_inv(apqi, matrix_mdev->matrix.aqm);
 done:
 	mutex_unlock(&matrix_dev->lock);
 
-- 
2.31.1

