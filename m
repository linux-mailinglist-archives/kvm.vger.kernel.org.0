Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829AD1F0215
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgFEVkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:40:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728842AbgFEVkS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:18 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LWbZp154352;
        Fri, 5 Jun 2020 17:40:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fr7rtdjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:16 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LamfY173701;
        Fri, 5 Jun 2020 17:40:16 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fr7rtdjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:16 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055LYc9L001948;
        Fri, 5 Jun 2020 21:40:15 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 31bf49njkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:15 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeEp049742316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:14 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2E63AC05E;
        Fri,  5 Jun 2020 21:40:13 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CFCCAC059;
        Fri,  5 Jun 2020 21:40:13 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:13 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 09/16] s390/vfio_ap: add qlink from ap_matrix_mdev struct to vfio_ap_queue struct
Date:   Fri,  5 Jun 2020 17:39:57 -0400
Message-Id: <20200605214004.14270-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 bulkscore=0 cotscore=-2147483648 suspectscore=3
 spamscore=0 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to make retrieval of a vfio_ap_queue struct more
efficient when we already have a pointer to the ap_matrix_mdev to which the
queue's APQN is assigned, let's go ahead and add a link from the
ap_matrix_mdev struct to the vfio_ap_queue struct.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 102 ++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 72 insertions(+), 32 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index add442977b9a..9a019b2b86f8 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -50,6 +50,19 @@ static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
 	return q;
 }
 
+struct vfio_ap_queue *vfio_ap_get_mdev_queue(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apqn)
+{
+	struct vfio_ap_queue *q;
+
+	hash_for_each_possible(matrix_mdev->qtable, q, mdev_qnode, apqn) {
+		if (q && (q->apqn == apqn))
+			return q;
+	}
+
+	return NULL;
+}
+
 /**
  * vfio_ap_wait_for_irqclear
  * @apqn: The AP Queue number
@@ -337,6 +350,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
+	hash_init(matrix_mdev->qtable);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
 	matrix_mdev->pqap_hook.owner = THIS_MODULE;
@@ -639,7 +653,7 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 			 * filter the APQI.
 			 */
 			apqn = AP_MKQID(apid, apqi);
-			if (!vfio_ap_get_queue(apqn)) {
+			if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn)) {
 				if (filter_apids)
 					clear_bit_inv(apid, shadow_apcb->apm);
 				else
@@ -682,7 +696,6 @@ static bool vfio_ap_mdev_config_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
 	vfio_ap_matrix_init(&matrix_dev->info, &shadow_apcb);
 	napm = bitmap_weight(matrix_mdev->matrix.apm, AP_DEVICES);
 	naqm = bitmap_weight(matrix_mdev->matrix.aqm, AP_DOMAINS);
-
 	/*
 	 * If there are no APIDs or no APQIs assigned to the matrix mdev,
 	 * then no APQNs shall be assigned to the guest CRYCB.
@@ -694,6 +707,7 @@ static bool vfio_ap_mdev_config_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
 		 */
 		napm = vfio_ap_mdev_filter_matrix(matrix_mdev, &shadow_apcb,
 						  true);
+
 		/*
 		 * If there are no APQNs that can be assigned to the guest's
 		 * CRYCB after filtering, then try filtering the APQIs.
@@ -742,56 +756,75 @@ enum qlink_type {
 	UNLINK_APQI,
 };
 
+static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
+				    unsigned long apid, unsigned long apqi)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
+	if (q) {
+		q->matrix_mdev = matrix_mdev;
+		hash_add(matrix_mdev->qtable,
+			 &q->mdev_qnode, q->apqn);
+	}
+}
+
+static void vfio_ap_mdev_unlink_queue(unsigned long apid, unsigned long apqi)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
+	if (q) {
+		q->matrix_mdev = NULL;
+		hash_del(&q->mdev_qnode);
+	}
+}
+
 /**
  * vfio_ap_mdev_link_queues
  *
  * @matrix_mdev: The matrix mdev to link.
- * @type:	 The type of link.
+ * @type:	 The type of @qlink_id.
  * @qlink_id:	 The APID or APQI of the queues to link.
  *
- * Sets the link from the queues with the specified @qlink_id (i.e., APID or
- * APQI) to @matrix_mdev:
- *	qlink_id == LINK_APID: Link @matrix_mdev to the queues with the
- *		    specified APID>
- *	qlink_id == UNLINK_APID: Unlink @matrix_mdev from the queues with the
- *		    specified APID>
- *	qlink_id == LINK_APQI: Link @matrix_mdev to the queues with the
- *		    specified APQI>
- *	qlink_id == UNLINK_APQI: Unlink @matrix_mdev from the queues with the
- *		    specified APQI>
+ * Sets or clears the links between the queues with the specified @qlink_id
+ * and the @matrix_mdev:
+ *	@type == LINK_APID: Set the links between the @matrix_mdev and the
+ *			    queues with the specified @qlink_id (APID)
+ *	@type == LINK_APQI: Set the links between the @matrix_mdev and the
+ *			    queues with the specified @qlink_id (APQI)
+ *	@type == UNLINK_APID: Clear the links between the @matrix_mdev and the
+ *			      queues with the specified @qlink_id (APID)
+ *	@type == UNLINK_APQI: Clear the links between the @matrix_mdev and the
+ *			      queues with the specified @qlink_id (APQI)
  */
 static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
 				     enum qlink_type type,
 				     unsigned long qlink_id)
 {
 	unsigned long id;
-	struct vfio_ap_queue *q;
+
 
 	switch (type) {
 	case LINK_APID:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
+				     matrix_mdev->matrix.aqm_max + 1)
+			vfio_ap_mdev_link_queue(matrix_mdev, qlink_id, id);
+		break;
 	case UNLINK_APID:
 		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
-				     matrix_mdev->matrix.aqm_max + 1) {
-			q = vfio_ap_get_queue(AP_MKQID(qlink_id, id));
-			if (q) {
-				if (type == LINK_APID)
-					q->matrix_mdev = matrix_mdev;
-				else
-					q->matrix_mdev = NULL;
-			}
-		}
+				     matrix_mdev->matrix.aqm_max + 1)
+			vfio_ap_mdev_unlink_queue(qlink_id, id);
+		break;
+	case LINK_APQI:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
+				     matrix_mdev->matrix.apm_max + 1)
+			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
 		break;
 	default:
 		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
-				     matrix_mdev->matrix.apm_max + 1) {
-			q = vfio_ap_get_queue(AP_MKQID(id, qlink_id));
-			if (q) {
-				if (type == LINK_APQI)
-					q->matrix_mdev = matrix_mdev;
-				else
-					q->matrix_mdev = NULL;
-			}
-		}
+				     matrix_mdev->matrix.apm_max + 1)
+			vfio_ap_mdev_unlink_queue(id, qlink_id);
 		break;
 	}
 }
@@ -1612,6 +1645,7 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
 		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
 			q->matrix_mdev = matrix_mdev;
+			hash_add(matrix_mdev->qtable, &q->mdev_qnode, q->apqn);
 			break;
 		}
 	}
@@ -1647,6 +1681,10 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 	apqi = AP_QID_QUEUE(q->apqn);
 	vfio_ap_mdev_reset_queue(apid, apqi, 1);
 	vfio_ap_irq_disable(q);
+
+	if (q->matrix_mdev)
+		hash_del(&q->mdev_qnode);
+
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 8e24a073166b..055bce6d45db 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -89,6 +89,7 @@ struct ap_matrix_mdev {
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
+	DECLARE_HASHTABLE(qtable, 8);
 };
 
 extern int vfio_ap_mdev_register(void);
@@ -100,6 +101,7 @@ struct vfio_ap_queue {
 	int	apqn;
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
+	struct hlist_node mdev_qnode;
 };
 
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
-- 
2.21.1

