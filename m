Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061F91A15D4
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgDGTVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:21:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727226AbgDGTUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:38 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J9Mv0100723;
        Tue, 7 Apr 2020 15:20:38 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 306mje1u4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:38 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037JA0Vr102439;
        Tue, 7 Apr 2020 15:20:37 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 306mje1u42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:37 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKVgC007987;
        Tue, 7 Apr 2020 19:20:36 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 306hv62fpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:36 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKYJO10092974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:35 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9C872805A;
        Tue,  7 Apr 2020 19:20:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 282DC28058;
        Tue,  7 Apr 2020 19:20:34 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:34 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 08/15] s390/vfio_ap: add qlink from ap_matrix_mdev struct to vfio_ap_queue struct
Date:   Tue,  7 Apr 2020 15:20:08 -0400
Message-Id: <20200407192015.19887-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 suspectscore=3 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, a vfio_ap_queue struct is created for every queue device probed
which is then added to a hash table of all queues probed by the vfio_ap
device driver. This list could get quite large making retrieval
expensive. In order to make retrieval of a vfio_ap_queue struct more
efficient when we already have a pointer to the ap_matrix_mdev to which the
queue's APQN is assigned, let's go ahead and add a link from the
ap_matrix_mdev struct to the vfio_ap_queue struct.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 29 +++++++++++++++++++++++----
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 25b7d978e3fd..6ee1ebe3f207 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -38,6 +38,19 @@ struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
 	return NULL;
 }
 
+struct vfio_ap_queue *vfio_ap_get_mdev_queue(struct ap_matrix_mdev *matrix_mdev,
+					     unsigned long apqn)
+{
+	struct vfio_ap_queue *q;
+
+	hash_for_each_possible(matrix_mdev->qtable, q, mdev_qnode, apqn) {
+		if (q->apqn == apqn)
+			return q;
+	}
+
+	return NULL;
+}
+
 /**
  * vfio_ap_wait_for_irqclear
  * @apqn: The AP Queue number
@@ -325,6 +338,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_crycb);
+	hash_init(matrix_mdev->qtable);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
 	matrix_mdev->pqap_hook.owner = THIS_MODULE;
@@ -594,7 +608,7 @@ static int vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 			 * filter the APQI.
 			 */
 			apqn = AP_MKQID(apid, apqi);
-			if (!vfio_ap_get_queue(apqn)) {
+			if (!vfio_ap_get_mdev_queue(matrix_mdev, apqn)) {
 				if (filter_apids)
 					clear_bit_inv(apid, shadow_crycb->apm);
 				else
@@ -624,7 +638,6 @@ static bool vfio_ap_mdev_configure_crycb(struct ap_matrix_mdev *matrix_mdev)
 	vfio_ap_matrix_init(&matrix_dev->info, &shadow_crycb);
 	napm = bitmap_weight(matrix_mdev->matrix.apm, AP_DEVICES);
 	naqm = bitmap_weight(matrix_mdev->matrix.aqm, AP_DOMAINS);
-
 	/*
 	 * If there are no APIDs or no APQIs assigned to the matrix mdev,
 	 * then no APQNs shall be assigned to the guest CRYCB.
@@ -636,6 +649,7 @@ static bool vfio_ap_mdev_configure_crycb(struct ap_matrix_mdev *matrix_mdev)
 		 */
 		napm = vfio_ap_mdev_filter_matrix(matrix_mdev, &shadow_crycb,
 						  true);
+
 		/*
 		 * If there are no APQNs that can be assigned to the guest's
 		 * CRYCB after filtering, then try filtering the APQIs.
@@ -697,8 +711,10 @@ static void vfio_ap_mdev_qlinks_for_apid(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
 			     matrix_mdev->matrix.aqm_max + 1) {
 		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
-		if (q)
+		if (q) {
 			q->matrix_mdev = matrix_mdev;
+			hash_add(matrix_mdev->qtable, &q->mdev_qnode, q->apqn);
+		}
 	}
 }
 
@@ -871,8 +887,10 @@ static void vfio_ap_mdev_qlinks_for_apqi(struct ap_matrix_mdev *matrix_mdev,
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
 			     matrix_mdev->matrix.apm_max + 1) {
 		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
-		if (q)
+		if (q) {
 			q->matrix_mdev = matrix_mdev;
+			hash_add(matrix_mdev->qtable, &q->mdev_qnode, q->apqn);
+		}
 	}
 }
 
@@ -1536,6 +1554,7 @@ static void vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)
 		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
 			q->matrix_mdev = matrix_mdev;
+			hash_add(matrix_mdev->qtable, &q->mdev_qnode, q->apqn);
 			break;
 		}
 	}
@@ -1573,6 +1592,8 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 	vfio_ap_mdev_reset_queue(apid, apqi, 1);
 	vfio_ap_irq_disable(q);
 	hash_del(&q->qnode);
+	if (q->matrix_mdev)
+		hash_del(&q->mdev_qnode);
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 87cc270c3212..794c60a767d2 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -89,6 +89,7 @@ struct ap_matrix_mdev {
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
+	DECLARE_HASHTABLE(qtable, 8);
 };
 
 extern int vfio_ap_mdev_register(void);
@@ -101,6 +102,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 	struct hlist_node qnode;
+	struct hlist_node mdev_qnode;
 };
 
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
-- 
2.21.1

