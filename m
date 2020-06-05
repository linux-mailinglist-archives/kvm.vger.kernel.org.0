Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568351F0246
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgFEVmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:42:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728844AbgFEVkT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:19 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LXIfc096021;
        Fri, 5 Jun 2020 17:40:14 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f9dcbff3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:13 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LXNaE096445;
        Fri, 5 Jun 2020 17:40:13 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f9dcbfet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:13 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055LYslb016853;
        Fri, 5 Jun 2020 21:40:12 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 31bf4b2mbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:12 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeAAB14484110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:10 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0E35AC05E;
        Fri,  5 Jun 2020 21:40:10 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6429EAC060;
        Fri,  5 Jun 2020 21:40:10 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:10 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 03/16] s390/vfio-ap: manage link between queue struct and matrix mdev
Date:   Fri,  5 Jun 2020 17:39:51 -0400
Message-Id: <20200605214004.14270-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=11 spamscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 cotscore=-2147483648 phishscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050157
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
 drivers/s390/crypto/vfio_ap_ops.c | 93 +++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 7c96b6fd9f70..21b98a392f36 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -160,7 +160,6 @@ struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 		  status.response_code);
 end_free:
 	vfio_ap_free_aqic_resources(q);
-	q->matrix_mdev = NULL;
 	return status;
 }
 
@@ -262,7 +261,6 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	struct vfio_ap_queue *q;
 	struct ap_queue_status qstatus = {
 			       .response_code = AP_RESPONSE_Q_NOT_AVAIL, };
-	struct ap_matrix_mdev *matrix_mdev;
 
 	/* If we do not use the AIV facility just go to userland */
 	if (!(vcpu->arch.sie_block->eca & ECA_AIV))
@@ -273,14 +271,11 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 
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
@@ -548,6 +543,67 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
 	return 0;
 }
 
+enum qlink_type {
+	LINK_APID,
+	LINK_APQI,
+	UNLINK_APID,
+	UNLINK_APQI,
+};
+
+/**
+ * vfio_ap_mdev_link_queues
+ *
+ * @matrix_mdev: The matrix mdev to link.
+ * @type:	 The type of link.
+ * @qlink_id:	 The APID or APQI of the queues to link.
+ *
+ * Sets the link from the queues with the specified @qlink_id (i.e., APID or
+ * APQI) to @matrix_mdev:
+ *	qlink_id == LINK_APID: Link @matrix_mdev to the queues with the
+ *		    specified APID>
+ *	qlink_id == UNLINK_APID: Unlink @matrix_mdev from the queues with the
+ *		    specified APID>
+ *	qlink_id == LINK_APQI: Link @matrix_mdev to the queues with the
+ *		    specified APQI>
+ *	qlink_id == UNLINK_APQI: Unlink @matrix_mdev from the queues with the
+ *		    specified APQI>
+ */
+static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
+				     enum qlink_type type,
+				     unsigned long qlink_id)
+{
+	unsigned long id;
+	struct vfio_ap_queue *q;
+
+	switch (type) {
+	case LINK_APID:
+	case UNLINK_APID:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
+				     matrix_mdev->matrix.aqm_max + 1) {
+			q = vfio_ap_get_queue(AP_MKQID(qlink_id, id));
+			if (q) {
+				if (type == LINK_APID)
+					q->matrix_mdev = matrix_mdev;
+				else
+					q->matrix_mdev = NULL;
+			}
+		}
+		break;
+	default:
+		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
+				     matrix_mdev->matrix.apm_max + 1) {
+			q = vfio_ap_get_queue(AP_MKQID(id, qlink_id));
+			if (q) {
+				if (type == LINK_APQI)
+					q->matrix_mdev = matrix_mdev;
+				else
+					q->matrix_mdev = NULL;
+			}
+		}
+		break;
+	}
+}
+
 /**
  * assign_adapter_store
  *
@@ -617,6 +673,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
 	ret = count;
 	goto done;
 
@@ -668,6 +725,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
+	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APID, apid);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -758,6 +816,7 @@ static ssize_t assign_domain_store(struct device *dev,
 	if (ret)
 		goto share_err;
 
+	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
 	ret = count;
 	goto done;
 
@@ -810,6 +869,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 
 	mutex_lock(&matrix_dev->lock);
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
+	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APQI, apqi);
 	mutex_unlock(&matrix_dev->lock);
 
 	return count;
@@ -1282,6 +1342,28 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 }
 
+/**
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
+			q->matrix_mdev = matrix_mdev;
+			break;
+		}
+	}
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1294,6 +1376,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 	dev_set_drvdata(&queue->ap_dev.device, q);
 	q->apqn = queue->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
+	vfio_ap_queue_link_mdev(q);
 	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
-- 
2.21.1

