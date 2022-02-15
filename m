Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A090A4B5F6D
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiBOAvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiBOAvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:51:22 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5716A141466;
        Mon, 14 Feb 2022 16:51:01 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ENndMx013067;
        Tue, 15 Feb 2022 00:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=caot0ZXlui/YM1FaXEuvSKb4VCU+lhLyLthph6S9AuU=;
 b=lT8q9rNs/9gpsHDcLZ4C+ee/pctZ0x9dvBQb8AXDYnd+X3p6DaCpxLSylCj2W2/arur1
 wos9VdbVZeas7vTIAyPpgkOPf4t9mZFgKQd1uwsci2ZMnij11hq7Y9qQYCZL4WTRfT+w
 bGqE/Kh9V4W3IxcRC66puFhijBIZ+959bnuAw5oiUJarry/bVP+5l7bBd5rMWZZomO/0
 ezauJlu7BApTKUP0G2YuVVQR5UtW+7usKSBYRF+tCk6Vec9MBtKIgdc5UsVmRBU7xSI0
 8Ka+4lEIQnNmeVFrEFL2KeJV5mgFd+VwEpK9JpMj26E4Z/bBmH7GmO9VG5r8YmJJZadH lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dvmm4n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:57 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0ouv6001281;
        Tue, 15 Feb 2022 00:50:56 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dvmm4n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:56 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0g6ZJ001606;
        Tue, 15 Feb 2022 00:50:54 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3e64hacn3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:54 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0os5w36307278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:54 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05AF4124055;
        Tue, 15 Feb 2022 00:50:54 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D374124054;
        Tue, 15 Feb 2022 00:50:53 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:53 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 12/18] s390/vfio-ap: reset queues after adapter/domain unassignment
Date:   Mon, 14 Feb 2022 19:50:34 -0500
Message-Id: <20220215005040.52697-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5T_vbloyUsYZko5x7eBtfaK0oM-Hv9Rr
X-Proofpoint-ORIG-GUID: grRdiMJWezcWJYhj85SP2elppJuZ_3dG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

When an adapter or domain is unassigned from an mdev providing the AP
configuration to a running KVM guest, one or more of the guest's queues may
get dynamically removed. Since the removed queues could get re-assigned to
another mdev, they need to be reset. So, when an adapter or domain is
unassigned from the mdev, the queues that are removed from the guest's
AP configuration will be reset.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 146 ++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 104 insertions(+), 44 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index f0fdfbbe2d29..e9f7ec6fc6a5 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -24,9 +24,10 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
-static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
+static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry);
 
 /**
  * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
@@ -356,6 +357,7 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(shadow_apm, AP_DEVICES);
 	DECLARE_BITMAP(shadow_aqm, AP_DOMAINS);
+	struct vfio_ap_queue *q;
 
 	ret = ap_qci(&matrix_dev->info);
 	if (ret)
@@ -386,8 +388,8 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 			 * hardware device.
 			 */
 			apqn = AP_MKQID(apid, apqi);
-
-			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
+			q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
+			if (!q || q->reset_rc) {
 				clear_bit_inv(apid,
 					      matrix_mdev->shadow_apcb.apm);
 				break;
@@ -471,12 +473,6 @@ static void vfio_ap_unlink_mdev_fr_queue(struct vfio_ap_queue *q)
 	q->matrix_mdev = NULL;
 }
 
-static void vfio_ap_mdev_unlink_queue(struct vfio_ap_queue *q)
-{
-	vfio_ap_unlink_queue_fr_mdev(q);
-	vfio_ap_unlink_mdev_fr_queue(q);
-}
-
 static void vfio_ap_mdev_unlink_fr_queues(struct ap_matrix_mdev *matrix_mdev)
 {
 	struct vfio_ap_queue *q;
@@ -501,7 +497,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
-	vfio_ap_mdev_reset_queues(matrix_mdev);
+	vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->mdevs_lock);
@@ -760,17 +756,61 @@ static ssize_t assign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static void vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long apid, unsigned long apqi,
+					struct ap_queue_table *qtable)
+{
+	struct vfio_ap_queue *q;
+
+	q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+	/* If the queue is assigned to the matrix mdev, unlink it. */
+	if (q)
+		vfio_ap_unlink_queue_fr_mdev(q);
+
+	/* If the queue is assigned to the APCB, store it in @qtable. */
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+	    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+		hash_add(qtable->queues, &q->mdev_qnode, q->apqn);
+}
+
+/**
+ * vfio_ap_mdev_unlink_adapter - unlink all queues associated with unassigned
+ *				 adapter from the matrix mdev to which the
+ *				 adapter was assigned.
+ * @matrix_mdev: the matrix mediated device to which the adapter was assigned.
+ * @apid: the APID of the unassigned adapter.
+ * @qtable: table for storing queues associated with unassigned adapter.
+ */
 static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
-					unsigned long apid)
+					unsigned long apid,
+					struct ap_queue_table *qtable)
 {
 	unsigned long apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
+		vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);
+}
+
+static void vfio_ap_mdev_hot_unplug_adapter(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apid)
+{
+	int bkt;
 	struct vfio_ap_queue *q;
+	struct ap_queue_table qtable;
+
+	hash_init(qtable.queues);
+	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid, &qtable);
+
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
+		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+	}
 
-	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
-		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+	vfio_ap_mdev_reset_queues(&qtable);
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+	hash_for_each(qtable.queues, bkt, q, mdev_qnode) {
+		vfio_ap_unlink_mdev_fr_queue(q);
+		hash_del(&q->mdev_qnode);
 	}
 }
 
@@ -809,13 +849,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
-	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
-
-	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
-		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
-		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
-	}
-
+	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
 	ret = count;
 done:
 	vfio_ap_mdev_put_locks(matrix_mdev);
@@ -909,16 +943,35 @@ static ssize_t assign_domain_store(struct device *dev,
 static DEVICE_ATTR_WO(assign_domain);
 
 static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
-				       unsigned long apqi)
+				       unsigned long apqi,
+				       struct ap_queue_table *qtable)
 {
 	unsigned long apid;
+
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
+		vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi, qtable);
+}
+
+static void vfio_ap_mdev_hot_unplug_domain(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long apqi)
+{
+	int bkt;
 	struct vfio_ap_queue *q;
+	struct ap_queue_table qtable;
 
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
-		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+	hash_init(qtable.queues);
+	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi, &qtable);
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
+	}
+
+	vfio_ap_mdev_reset_queues(&qtable);
+
+	hash_for_each(qtable.queues, bkt, q, mdev_qnode) {
+		vfio_ap_unlink_mdev_fr_queue(q);
+		hash_del(&q->mdev_qnode);
 	}
 }
 
@@ -957,13 +1010,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
-	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
-
-	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
-		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
-		vfio_ap_mdev_hotplug_apcb(matrix_mdev);
-	}
-
+	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
 	ret = count;
 done:
 	vfio_ap_mdev_put_locks(matrix_mdev);
@@ -1273,9 +1320,9 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
 		mutex_lock(&kvm->lock);
 		mutex_lock(&matrix_dev->mdevs_lock);
 
-		kvm_arch_crypto_clear_masks(kvm);
-		vfio_ap_mdev_reset_queues(matrix_mdev);
-		kvm_put_kvm(kvm);
+		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
+		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
+		kvm_put_kvm(matrix_mdev->kvm);
 		matrix_mdev->kvm = NULL;
 
 		mutex_unlock(&matrix_dev->mdevs_lock);
@@ -1328,14 +1375,17 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 
 	if (!q)
 		return 0;
+	q->reset_rc = 0;
 
 retry_zapq:
 	status = ap_zapq(q->apqn);
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
+		q->reset_rc = status.response_code;
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
+		q->reset_rc = status.response_code;
 		if (retry--) {
 			msleep(20);
 			goto retry_zapq;
@@ -1345,13 +1395,20 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 	case AP_RESPONSE_Q_NOT_AVAIL:
 	case AP_RESPONSE_DECONFIGURED:
 	case AP_RESPONSE_CHECKSTOPPED:
-		WARN_ON_ONCE(status.irq_enabled);
+		WARN_ONCE(status.irq_enabled,
+			  "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ enabled",
+			  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+			  status.response_code);
+		q->reset_rc = status.response_code;
 		ret = -EBUSY;
 		goto free_resources;
 	default:
 		/* things are really broken, give up */
-		WARN(true, "PQAP/ZAPQ completed with invalid rc (%x)\n",
+		WARN(true,
+		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
+		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
 		     status.response_code);
+		q->reset_rc = status.response_code;
 		return -EIO;
 	}
 
@@ -1362,7 +1419,8 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 		msleep(20);
 		status = ap_tapq(q->apqn, NULL);
 	}
-	WARN_ON_ONCE(retry2 <= 0);
+	WARN_ONCE(retry2 <= 0, "unable to verify reset of queue %02x.%04x",
+		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
 
 free_resources:
 	vfio_ap_free_aqic_resources(q);
@@ -1370,12 +1428,12 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable)
 {
-	int ret, bkt, rc = 0;
+	int rc = 0, ret, bkt;
 	struct vfio_ap_queue *q;
 
-	hash_for_each(matrix_mdev->qtable.queues, bkt, q, mdev_qnode) {
+	hash_for_each(qtable->queues, bkt, q, mdev_qnode) {
 		ret = vfio_ap_mdev_reset_queue(q, 1);
 		/*
 		 * Regardless whether a queue turns out to be busy, or
@@ -1463,7 +1521,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		ret = vfio_ap_mdev_reset_queues(matrix_mdev);
+		ret = vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 7e82a72d2083..a3811cd9852d 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -128,6 +128,7 @@ struct ap_matrix_mdev {
  * @apqn: the APQN of the AP queue device
  * @saved_isc: the guest ISC registered with the GIB interface
  * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
+ * @reset_rc: the status response code from the last reset of the queue
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -136,6 +137,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 	struct hlist_node mdev_qnode;
+	unsigned int reset_rc;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.31.1

