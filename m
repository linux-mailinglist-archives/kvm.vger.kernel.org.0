Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFED94B5F80
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiBOAv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiBOAvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69114141E08;
        Mon, 14 Feb 2022 16:51:00 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EMe5tt002568;
        Tue, 15 Feb 2022 00:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v1vtHv0sSoso3w+U2hii31/L8XLFvWRcXvVVELmGumY=;
 b=BwXFD4QZ1bOT4NPyPy/qwAS2M80niWCLVMiNJg4eB5qAPwqo1imQmUYD5VpLDENYT/xZ
 LFyvtXjC7AJXwT3K6buQ2CfXR4GHsKMwQyO6IA/grwuJjtB1oV2N5Coccy9aWunamrMS
 U037disjHjk7o0tOtYoLLzyzsko2UJyUnYvogtLjzgeKD8SabMorcPpK3IXjCRrn4qYZ
 o0TYjpqAb6zFaBc7LYwDE9z3EK111IqhceZJUp6/a2g/Xb1N+YsHyqDanA9UQ4BFRlUw
 M7P2Y6eJLNEp2hW5Ja5QFMI6byDNM1tykga+NxLdM18w3fnpc6qaWnhC/clzx62e3O42 /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7cjedvyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:58 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0ovAL020095;
        Tue, 15 Feb 2022 00:50:57 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7cjedvy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:57 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0g7El001617;
        Tue, 15 Feb 2022 00:50:56 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3e64hacn3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:56 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0orc634668866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:53 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DD69124052;
        Tue, 15 Feb 2022 00:50:53 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B827124055;
        Tue, 15 Feb 2022 00:50:52 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:52 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 11/18] s390/vfio-ap: hot plug/unplug of AP devices when probed/removed
Date:   Mon, 14 Feb 2022 19:50:33 -0500
Message-Id: <20220215005040.52697-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K7c2KY7WinkkSPkV07U6VRTjl0-iYKGb
X-Proofpoint-ORIG-GUID: Fl6yV7B1J5yDWqjyzVt2J_8-eKXJ_0dn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150001
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an AP queue device is probed or removed, if the mediated device is
passed through to a KVM guest, the mediated device's adapter, domain and
control domain bitmaps must be filtered to update the guest's APCB and if
any changes are detected, the guest's APCB must then be hot plugged into
the guest to reflect those changes to the guest.

The following locks must be taken in order to ensure the operation
can be validly executed and a lockdep splat prevented:

matrix_dev->guests_lock => matrix_mdev->kvm->lock => matrix_dev->mdevs_lock

Note: The matrix_mdev->kvm->lock can only be taken if the mediated device
      is passed through to a guest (i.e., matrix_mdev->kvm is not NULL).

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 136 +++++++++++++++++++++++++-----
 1 file changed, 113 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4c382cd3afc7..f0fdfbbe2d29 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1523,73 +1523,163 @@ void vfio_ap_mdev_unregister(void)
 	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
 
-/*
- * vfio_ap_queue_link_mdev
+
+
+/**
+ * vfio_ap_mdev_get_qlocks_4_probe: acquire all of the locks required to probe
+ *				    a queue device.
  *
- * @q: The queue to link with the matrix mdev.
+ * @apqn: the APQN of the queue device being probed
  *
- * Links @q with the matrix mdev to which the queue's APQN is assigned.
+ * Return: the matrix mdev to which @apqn is assigned.
  */
-static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
+static struct ap_matrix_mdev *vfio_ap_mdev_get_qlocks_4_probe(int apqn)
 {
-	unsigned long apid = AP_QID_CARD(q->apqn);
-	unsigned long apqi = AP_QID_QUEUE(q->apqn);
 	struct ap_matrix_mdev *matrix_mdev;
+	unsigned long apid = AP_QID_CARD(apqn);
+	unsigned long apqi = AP_QID_QUEUE(apqn);
+
+	/*
+	 * Lock the mutex required to access the list of mdevs under the control
+	 * of the vfio_ap device driver and access the KVM guest's state
+	 */
+	mutex_lock(&matrix_dev->guests_lock);
 
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
 		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
-			vfio_ap_mdev_link_queue(matrix_mdev, q);
-			break;
+			/*
+			 * If the KVM guest is running, lock the mutex required
+			 * to plug/unplug AP devices passed through to the
+			 * guest.
+			 */
+			if (matrix_mdev->kvm)
+				mutex_lock(&matrix_mdev->kvm->lock);
+
+			/*
+			 * Lock the mutex required to access the mdev's state.
+			 */
+			mutex_lock(&matrix_dev->mdevs_lock);
+
+			return matrix_mdev;
 		}
 	}
+
+	return NULL;
+}
+
+/**
+ * vfio_ap_mdev_put_qlocks - unlock all of the locks acquired for probing or
+ *			     removing a queue device.
+ *
+ * @matrix_mdev: the mdev to which the queue being probed/removed is assigned.
+ */
+static void vfio_ap_mdev_put_qlocks(struct ap_matrix_mdev *matrix_mdev)
+{
+	if (matrix_mdev) {
+		/*
+		 * Unlock the queue required for accessing the state of
+		 * matrix_mdev
+		 */
+		mutex_unlock(&matrix_dev->mdevs_lock);
+
+		/*
+		 * If a KVM guest is currently running, unlock the mutex
+		 * required to plug/unplug AP devices passed through to the
+		 * guest.
+		 */
+		if (matrix_mdev && matrix_mdev->kvm)
+			mutex_unlock(&matrix_mdev->kvm->lock);
+	}
+
+	/* Unlock the mutex required to access the KVM guest's state */
+	mutex_unlock(&matrix_dev->guests_lock);
 }
 
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
 	struct vfio_ap_queue *q;
 	DECLARE_BITMAP(apm, AP_DEVICES);
+	struct ap_matrix_mdev *matrix_mdev;
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
 		return -ENOMEM;
 
-	mutex_lock(&matrix_dev->guests_lock);
-	mutex_lock(&matrix_dev->mdevs_lock);
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
-	vfio_ap_queue_link_mdev(q);
-	if (q->matrix_mdev) {
+	matrix_mdev = vfio_ap_mdev_get_qlocks_4_probe(q->apqn);
+	if (matrix_mdev) {
+		vfio_ap_mdev_link_queue(matrix_mdev, q);
 		memset(apm, 0, sizeof(apm));
 		set_bit_inv(AP_QID_CARD(q->apqn), apm);
-		vfio_ap_mdev_filter_matrix(apm, q->matrix_mdev->matrix.aqm,
-					   q->matrix_mdev);
+		if (vfio_ap_mdev_filter_matrix(apm, q->matrix_mdev->matrix.aqm,
+					       q->matrix_mdev))
+			vfio_ap_mdev_hotplug_apcb(q->matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
-	mutex_unlock(&matrix_dev->mdevs_lock);
-	mutex_unlock(&matrix_dev->guests_lock);
+	vfio_ap_mdev_put_qlocks(matrix_mdev);
 
 	return 0;
 }
 
-void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
+/**
+ * vfio_ap_get_qlocks_4_rem: acquire all of the locks required to remove a
+ *			     queue device.
+ *
+ * @matrix_mdev: the device to which the APQN of the queue device being removed is
+ *		 assigned.
+ */
+static struct vfio_ap_queue *vfio_ap_get_qlocks_4_rem(struct ap_device *apdev)
 {
-	unsigned long apid;
 	struct vfio_ap_queue *q;
 
-	mutex_lock(&matrix_dev->mdevs_lock);
+	/* Lock the mutex required to access the KVM guest's state */
+	mutex_lock(&matrix_dev->guests_lock);
+
 	q = dev_get_drvdata(&apdev->device);
 
+	/*
+	 * If the queue is assigned to a mediated device and a KVM guest is
+	 * currently running, lock the mutex required to plug/unplug AP devices
+	 * passed through to the guest.
+	 */
 	if (q->matrix_mdev) {
+		if (q->matrix_mdev->kvm)
+			mutex_lock(&q->matrix_mdev->kvm->lock);
+		/*
+		 * Lock the mutex required to access the state of the
+		 * matrix_mdev
+		 */
+		mutex_lock(&matrix_dev->mdevs_lock);
+	}
+
+	return q;
+}
+
+void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
+{
+	unsigned long apid, apqi;
+	struct vfio_ap_queue *q;
+	struct ap_matrix_mdev *matrix_mdev;
+
+	q = vfio_ap_get_qlocks_4_rem(apdev);
+	matrix_mdev = q->matrix_mdev;
+
+	if (matrix_mdev) {
 		vfio_ap_unlink_queue_fr_mdev(q);
 
 		apid = AP_QID_CARD(q->apqn);
-		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm))
-			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
+		apqi = AP_QID_QUEUE(q->apqn);
+		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+			vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+		}
 	}
 
 	vfio_ap_mdev_reset_queue(q, 1);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	vfio_ap_mdev_put_qlocks(matrix_mdev);
 }
-- 
2.31.1

