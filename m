Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29191A15E5
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgDGTVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:21:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726921AbgDGTUe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:34 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J3L9F129785;
        Tue, 7 Apr 2020 15:20:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3082hyk5w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:32 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J3N6S129912;
        Tue, 7 Apr 2020 15:20:32 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3082hyk5vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:32 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKC3h013711;
        Tue, 7 Apr 2020 19:20:31 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04wdc.us.ibm.com with ESMTP id 306hv6afgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:31 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKUrS41157052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:30 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11F6628060;
        Tue,  7 Apr 2020 19:20:30 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51E8D28068;
        Tue,  7 Apr 2020 19:20:29 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:29 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 02/15] s390/vfio-ap: manage link between queue struct and matrix mdev
Date:   Tue,  7 Apr 2020 15:20:02 -0400
Message-Id: <20200407192015.19887-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=11 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A vfio_ap_queue structure is created for each queue device probed. To
ensure that the matrix mdev to which a queue's APQN is assigned is linked
to the queue structure as long as the queue device is bound to the vfio_ap
device driver, let's go ahead and manage these links when the queue device
is probed and removed as well as whenever an adapter or domain is assigned
to or unassigned from the matrix mdev.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 134860934fe7..00699bd72d2b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -148,7 +148,6 @@ struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 		  status.response_code);
 end_free:
 	vfio_ap_free_aqic_resources(q);
-	q->matrix_mdev = NULL;
 	return status;
 }
 
@@ -250,7 +249,6 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	struct vfio_ap_queue *q;
 	struct ap_queue_status qstatus = {
 			       .response_code = AP_RESPONSE_Q_NOT_AVAIL, };
-	struct ap_matrix_mdev *matrix_mdev;
 
 	/* If we do not use the AIV facility just go to userland */
 	if (!(vcpu->arch.sie_block->eca & ECA_AIV))
@@ -261,14 +259,11 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 
 	if (!vcpu->kvm->arch.crypto.pqap_hook)
 		goto out_unlock;
-	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
-				   struct ap_matrix_mdev, pqap_hook);
 
 	q = vfio_ap_get_queue(apqn);
 	if (!q)
 		goto out_unlock;
 
-	q->matrix_mdev = matrix_mdev;
 	status = vcpu->run->s.regs.gprs[1];
 
 	/* If IR bit(16) is set we enable the interrupt */
@@ -536,6 +531,31 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 	return 0;
 }
 
+/**
+ * vfio_ap_mdev_qlinks_for_apid
+ *
+ * @matrix_mdev: a matrix mediated device
+ * @apqi:	 the APID of one or more APQNs assigned to @matrix_mdev
+ *
+ * Set the link to @matrix_mdev for each queue device bound to the vfio_ap
+ * device driver with an APQN assigned to @matrix_mdev with the specified @apid.
+ *
+ * Note: If @matrix_mdev is NULL, the link to @matrix_mdev will be severed.
+ */
+static void vfio_ap_mdev_qlinks_for_apid(struct ap_matrix_mdev *matrix_mdev,
+					 unsigned long apid)
+{
+	unsigned long apqi;
+	struct vfio_ap_queue *q;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
+			     matrix_mdev->matrix.aqm_max + 1) {
+		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
+		if (q)
+			q->matrix_mdev = matrix_mdev;
+	}
+}
+
 /**
  * assign_adapter_store
  *
@@ -605,6 +625,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_qlinks_for_apid(matrix_mdev, apid);
 	ret = count;
 	goto done;
 
@@ -656,6 +677,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_qlinks_for_apid(NULL, apid);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -682,6 +704,31 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+/**
+ * vfio_ap_mdev_qlinks_for_apqi
+ *
+ * @matrix_mdev: a matrix mediated device
+ * @apqi:	 the APQI of one or more APQNs assigned to @matrix_mdev
+ *
+ * Set the link to @matrix_mdev for each queue device bound to the vfio_ap
+ * device driver with an APQN assigned to @matrix_mdev with the specified @apqi.
+ *
+ * Note: If @matrix_mdev is NULL, the link to @matrix_mdev will be severed.
+ */
+static void vfio_ap_mdev_qlinks_for_apqi(struct ap_matrix_mdev *matrix_mdev,
+					 unsigned long apqi)
+{
+	unsigned long apid;
+	struct vfio_ap_queue *q;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
+			     matrix_mdev->matrix.apm_max + 1) {
+		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
+		if (q)
+			q->matrix_mdev = matrix_mdev;
+	}
+}
+
 /**
  * assign_domain_store
  *
@@ -746,6 +793,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_qlinks_for_apqi(matrix_mdev, apqi);
 	ret = count;
 	goto done;
 
@@ -798,6 +846,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_qlinks_for_apqi(NULL, apqi);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -1270,6 +1319,21 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 }
 
+static void vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)
+{
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+	struct ap_matrix_mdev *matrix_mdev;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
+			q->matrix_mdev = matrix_mdev;
+			break;
+		}
+	}
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1282,6 +1346,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 	dev_set_drvdata(&queue->ap_dev.device, q);
 	q->apqn = queue->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
+	vfio_ap_mdev_for_queue(q);
 	hash_add(matrix_dev->qtable, &q->qnode, q->apqn);
 	mutex_unlock(&matrix_dev->lock);
 
-- 
2.21.1

