Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDDF134C5
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 23:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfECVPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 17:15:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727225AbfECVOs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 May 2019 17:14:48 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x43LBvj5125209
        for <kvm@vger.kernel.org>; Fri, 3 May 2019 17:14:47 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s8tb4ewt6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 17:14:47 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Fri, 3 May 2019 22:14:46 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 May 2019 22:14:43 +0100
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x43LEeEr24772852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 May 2019 21:14:40 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C5D4124053;
        Fri,  3 May 2019 21:14:40 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAC77124052;
        Fri,  3 May 2019 21:14:39 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.193.92])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri,  3 May 2019 21:14:39 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v2 6/7] s390: vfio-ap: handle bind and unbind of AP queue device
Date:   Fri,  3 May 2019 17:14:32 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19050321-0072-0000-0000-00000424BCFC
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011043; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01198143; UDB=6.00628476; IPR=6.00979005;
 MB=3.00026720; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-03 21:14:45
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050321-0073-0000-0000-00004C10C1F5
Message-Id: <1556918073-13171-7-git-send-email-akrowiak@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-03_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=968 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905030137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is nothing preventing a root user from inadvertently unbinding an
AP queue device that is in use by a guest from the vfio_ap device driver
and binding it to a zcrypt driver. This can result in a queue being
accessible from both the host and a guest.

This patch introduces safeguards that prevent sharing of an AP queue
between the host when a queue device is unbound from the vfio_ap device
driver. In addition, this patch restores guest access to AP queue devices
bound to the vfio_ap driver if the queue's APQN is assigned to an mdev
device in use by a guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  12 +++-
 drivers/s390/crypto/vfio_ap_ops.c     | 100 +++++++++++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 3 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index e9824c35c34f..c215978daf39 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -42,12 +42,22 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
 
 static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
 {
+	struct ap_queue *queue = to_ap_queue(&apdev->device);
+
+	mutex_lock(&matrix_dev->lock);
+	vfio_ap_mdev_probe_queue(queue);
+	mutex_unlock(&matrix_dev->lock);
+
 	return 0;
 }
 
 static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 {
-	/* Nothing to do yet */
+	struct ap_queue *queue = to_ap_queue(&apdev->device);
+
+	mutex_lock(&matrix_dev->lock);
+	vfio_ap_mdev_remove_queue(queue);
+	mutex_unlock(&matrix_dev->lock);
 }
 
 static void vfio_ap_matrix_dev_release(struct device *dev)
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index ede45184eb67..40324951bd37 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -226,8 +226,6 @@ static struct device *vfio_ap_get_queue_dev(unsigned long apid,
 				  &apqn, match_apqn);
 }
 
-
-
 static int vfio_ap_mdev_validate_masks(unsigned long *apm, unsigned long *aqm)
 {
 	int ret;
@@ -259,6 +257,27 @@ static bool vfio_ap_queues_on_drv(unsigned long *apm, unsigned long *aqm)
 	return true;
 }
 
+static bool vfio_ap_card_on_drv(struct ap_queue *queue, unsigned long *aqm)
+{
+	unsigned long apid, apqi;
+	struct device *dev;
+
+	apid = AP_QID_CARD(queue->qid);
+
+	for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+		if (queue->qid == AP_MKQID(apid, apqi))
+			continue;
+
+		dev = vfio_ap_get_queue_dev(apid, apqi);
+		if (!dev)
+			return false;
+
+		put_device(dev);
+	}
+
+	return true;
+}
+
 /**
  * assign_adapter_store
  *
@@ -1017,3 +1036,80 @@ void vfio_ap_mdev_unregister(void)
 {
 	mdev_unregister_device(&matrix_dev->device);
 }
+
+static struct ap_matrix_mdev *vfio_ap_mdev_find_matrix_mdev(unsigned long apid,
+							    unsigned long apqi)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->matrix.aqm))
+			return matrix_mdev;
+	}
+
+	return NULL;
+}
+
+void vfio_ap_mdev_probe_queue(struct ap_queue *queue)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+	unsigned long *shadow_apm, *shadow_aqm;
+	unsigned long apid = AP_QID_CARD(queue->qid);
+	unsigned long apqi = AP_QID_QUEUE(queue->qid);
+
+	/*
+	 * Find the mdev device to which the APQN of the queue device being
+	 * probed is assigned
+	 */
+	matrix_mdev = vfio_ap_mdev_find_matrix_mdev(apid, apqi);
+
+	/* Check whether we found an mdev device and it is in use by a guest */
+	if (matrix_mdev && matrix_mdev->kvm) {
+		shadow_apm = matrix_mdev->shadow_crycb->apm;
+		shadow_aqm = matrix_mdev->shadow_crycb->aqm;
+		/*
+		 * If the guest already has access to the adapter card
+		 * referenced by APID or does not have access to the queues
+		 * referenced by APQI, there is nothing to do here.
+		 */
+		if (test_bit_inv(apid, shadow_apm) ||
+		    !test_bit_inv(apqi, shadow_aqm))
+			return;
+
+		/*
+		 * If each APQN with the APID of the queue being probed and an
+		 * APQI in the shadow CRYCB references a queue device that is
+		 * bound to the vfio_ap driver, then plug the adapter into the
+		 * guest.
+		 */
+		if (vfio_ap_card_on_drv(queue, shadow_aqm)) {
+			set_bit_inv(apid, shadow_apm);
+			vfio_ap_mdev_update_crycb(matrix_mdev);
+		}
+	}
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+	unsigned long apid = AP_QID_CARD(queue->qid);
+	unsigned long apqi = AP_QID_QUEUE(queue->qid);
+
+	matrix_mdev = vfio_ap_mdev_find_matrix_mdev(apid, apqi);
+
+	/*
+	 * If the queue is assigned to the mdev device and the mdev device
+	 * is in use by a guest, unplug the adapter referred to by the APID
+	 * of the APQN of the queue being removed.
+	 */
+	if (matrix_mdev && matrix_mdev->kvm) {
+		if (!test_bit_inv(apid, matrix_mdev->shadow_crycb->apm))
+			return;
+
+		clear_bit_inv(apid, matrix_mdev->shadow_crycb->apm);
+		vfio_ap_mdev_update_crycb(matrix_mdev);
+	}
+
+	vfio_ap_mdev_reset_queue(apid, apqi);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index e8457aa61976..6b1f7df5b979 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -87,5 +87,7 @@ struct ap_matrix_mdev {
 
 extern int vfio_ap_mdev_register(void);
 extern void vfio_ap_mdev_unregister(void);
+void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
+void vfio_ap_mdev_probe_queue(struct ap_queue *queue);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.7.4

