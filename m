Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88711B274F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 23:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403795AbfIMV1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 17:27:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390051AbfIMV1L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Sep 2019 17:27:11 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8DLGvSx115148;
        Fri, 13 Sep 2019 17:27:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v0jt6gfk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 17:27:09 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8DLI9Tw117568;
        Fri, 13 Sep 2019 17:27:09 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v0jt6gfk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 17:27:09 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8DLK8cZ011572;
        Fri, 13 Sep 2019 21:27:08 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 2uytdx4g0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 21:27:08 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8DLR6Rl51315150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 21:27:06 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A832828058;
        Fri, 13 Sep 2019 21:27:06 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 345BD28059;
        Fri, 13 Sep 2019 21:27:06 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.152.57])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 13 Sep 2019 21:27:06 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v6 06/10] s390: vfio-ap: update guest CRYCB in vfio_ap probe and remove callbacks
Date:   Fri, 13 Sep 2019 17:26:54 -0400
Message-Id: <1568410018-10833-7-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568410018-10833-1-git-send-email-akrowiak@linux.ibm.com>
References: <1568410018-10833-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-13_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909130213
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the vfio_ap device driver's probe callback is invoked to bind a
an AP queue device, if its APQN has been assigned to a matrix mdev that is
in use by a guest, the queue will be hot plugged into the guest's AP
configuration if:

1. Each APQN derived from the APID and the APQIs already set in the
   guest's CRYCB references an AP queue device bound to the vfio_ap
   device driver.

2. Each APQN derived from the APQI and the APIDs already set in the
   guest's CRYCB references an AP queue device bound to the vfio_ap
   device driver.

When an AP adapter is removed from the AP configuration via the SE or an
'SCLP Deconfigure AP Adapter' instruction, each queue device associated
with the adapter will be unbound from device driver to which it is bound.
When the vfio_ap device driver's remove callback is invoked to unbind an
AP queue device, if the queue's APQN is assigned to a matrix mdev in use
by a guest, the adapter to which the queue is connected will be hot
unplugged from the guest's configuration. The reason for this is because
an adapter of a different type can be added back to the AP configuration
with the APID corresponding to the adapter being removed. If the new
adapter is not of the appropriate type, it will not get bound to the
vfio_ap driver. If we did not unplug it from the guest, both the guest
and the host would have access to all of the queues associated with the
adapter which is a no-no.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 93 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 14f221b7426b..f3332424670f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -507,6 +507,63 @@ static void vfio_ap_mdev_get_crycb_matrix(struct ap_matrix_mdev *matrix_mdev)
 	}
 }
 
+static bool vfio_ap_mdev_update_crycb_matrix(struct ap_matrix_mdev *matrix_mdev,
+					     struct vfio_ap_queue *q)
+{
+	unsigned long crycb_apid, crycb_apqi;
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+
+	/*
+	 * If the APID of the input queue is not already set in the guest's
+	 * CRYCB, then verify that all APQNs derived from Cartesian product of
+	 * the APID and each APQI set in the guest's CRYCB references a queue
+	 * that is bound to the vfio_ap driver.
+	 */
+	if (!test_bit_inv(apid, matrix_mdev->crycb.apm)) {
+		for_each_set_bit_inv(crycb_apqi, matrix_mdev->crycb.aqm,
+				     matrix_mdev->crycb.aqm_max + 1) {
+			/*
+			 * The APQN formulated from the APID and APQI of the
+			 * input queue is in the process of being bound to the
+			 * vfio_ap driver so there is no need to verify it.
+			 */
+			if (apqi == crycb_apqi)
+				continue;
+
+			if (!vfio_ap_find_queue(AP_MKQID(apid, crycb_apqi)))
+				return false;
+		}
+	}
+
+	/*
+	 * If the APQI of the input queue is not already set in the guest's
+	 * CRYCB, then verify that all APQNs derived from Cartesian product of
+	 * the APQI and each APID set in the guest's CRYCB references a queue
+	 * that is bound to the vfio_ap driver.
+	 */
+	if (!test_bit_inv(apqi, matrix_mdev->crycb.aqm)) {
+		for_each_set_bit_inv(crycb_apid, matrix_mdev->crycb.apm,
+				     matrix_mdev->crycb.apm_max + 1) {
+			/*
+			 * The APQN formulated from the APID and APQI of the
+			 * input queue is in the process of being bound to the
+			 * vfio_ap driver so there is no need to verify it.
+			 */
+			if (apid == crycb_apid)
+				continue;
+
+			if (!vfio_ap_find_queue(AP_MKQID(crycb_apid, apqi)))
+				return false;
+		}
+	}
+
+	set_bit_inv(apid, matrix_mdev->crycb.apm);
+	set_bit_inv(apqi, matrix_mdev->crycb.aqm);
+
+	return true;
+}
+
 static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
 {
 	return matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd;
@@ -1311,9 +1368,23 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_device(&matrix_dev->device);
 }
 
+static struct ap_matrix_mdev *vfio_ap_mdev_for_queue(int apqn)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm) &&
+		    test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
+			return matrix_mdev;
+	}
+
+	return NULL;
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
@@ -1322,18 +1393,40 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 	q->apqn = queue->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 
+	/*
+	 * If the APQN for the queue is assigned to a matrix mdev that is in
+	 * use by a guest, then plug the queue into the guest.
+	 */
+	matrix_mdev = vfio_ap_mdev_for_queue(queue->qid);
+	if (matrix_mdev && vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		vfio_ap_mdev_update_crycb_matrix(matrix_mdev, q);
+		vfio_ap_mdev_update_crycb(matrix_mdev);
+	}
+
 	return 0;
 }
 
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
 	int apid, apqi;
 
 	q = dev_get_drvdata(&queue->ap_dev.device);
 	dev_set_drvdata(&queue->ap_dev.device, NULL);
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
+
+	/*
+	 * If the APQN for the queue is assigned to a matrix mdev that is in
+	 * use by a guest, then unplug the adapter from the guest.
+	 */
+	matrix_mdev = vfio_ap_mdev_for_queue(queue->qid);
+	if (matrix_mdev && vfio_ap_mdev_has_crycb(matrix_mdev)) {
+		clear_bit_inv(apid, matrix_mdev->crycb.apm);
+		vfio_ap_mdev_update_crycb(matrix_mdev);
+	}
+
 	vfio_ap_mdev_reset_queue(apid, apqi);
 	vfio_ap_irq_disable(q);
 	kfree(q);
-- 
2.7.4

