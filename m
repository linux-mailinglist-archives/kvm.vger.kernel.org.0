Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A34F1F85
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbiDDWyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbiDDWxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30454BB90;
        Mon,  4 Apr 2022 15:12:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234JeIQZ030003;
        Mon, 4 Apr 2022 22:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MfJACVPfqUsx7ti2qAgRqujjk7zOSg+o3/99iWYvZX4=;
 b=YCT3T0fVz+TJB3j3xcvcqNqnMYzHkd9LTjjWmK8vtq1LKsCIN0GhVI6cmQc3O6P/NAjC
 mJCy05G3uFevbmy9VplR0N+mp4tm1LZa0sD9SOu5QxNsroAPPeaKh7wrI5493d4zPMCg
 3NvKCUkO+/6IwzwwQ5cQoE1/sOvKkKUAJQ7eZQSQ5FgttKVD2SDS4Z1ULNHvZhTc9SUP
 HNJVzsE4k5NvS2Y4O3uFNScKpJ/CQCO11OvSHqU/GUCdcSoOCP7X4VVqj0TJjBPEYjF8
 iZtaXIsM4rTH4DfpKPT67uhUjshZpQhc9X0qotSGzu+QsR24PdVxCn0ONaQwWFqAQoOD cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f82rc3mfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:04 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234LwBxW011633;
        Mon, 4 Apr 2022 22:12:03 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f82rc3mfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:03 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234LqtML020755;
        Mon, 4 Apr 2022 22:12:03 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3f6e49f934-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:02 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MC1IQ24248790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:12:01 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6530178066;
        Mon,  4 Apr 2022 22:12:01 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 637FA7805C;
        Mon,  4 Apr 2022 22:12:00 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:12:00 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 14/20] s390/vfio-ap: reset queues after adapter/domain unassignment
Date:   Mon,  4 Apr 2022 18:10:33 -0400
Message-Id: <20220404221039.1272245-15-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MLEUAZ2vUGuW9XortXb7cFFSV0UrZEol
X-Proofpoint-ORIG-GUID: XLN8x2_PUpfAFVs03L3QcA0Pnd-Ldla1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an adapter or domain is unassigned from an mdev attached to a KVM
guest, one or more of the guest's queues may get dynamically removed. Since
the removed queues could get re-assigned to another mdev, they need to be
reset. So, when an adapter or domain is unassigned from the mdev, the
queues that are removed from the guest's AP configuration (APCB) will be
reset.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 152 +++++++++++++++++++-------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 114 insertions(+), 40 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index ec5f37d726ec..49ed54dc9e05 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -26,9 +26,10 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
-static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
+static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry);
 
 /**
  * get_update_locks_for_kvm: Acquire the locks required to dynamically update a
@@ -644,6 +645,7 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(prev_shadow_apm, AP_DEVICES);
 	DECLARE_BITMAP(prev_shadow_aqm, AP_DOMAINS);
+	struct vfio_ap_queue *q;
 
 	ret = ap_qci(&matrix_dev->info);
 	if (ret)
@@ -674,8 +676,8 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
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
@@ -756,12 +758,6 @@ static void vfio_ap_unlink_mdev_fr_queue(struct vfio_ap_queue *q)
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
@@ -786,7 +782,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
-	vfio_ap_mdev_reset_queues(matrix_mdev);
+	vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->mdevs_lock);
@@ -1000,18 +996,70 @@ static ssize_t assign_adapter_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(assign_adapter);
 
+static struct vfio_ap_queue
+*vfio_ap_unlink_apqn_fr_mdev(struct ap_matrix_mdev *matrix_mdev,
+			     unsigned long apid, unsigned long apqi)
+{
+	struct vfio_ap_queue *q = NULL;
+
+	q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+	/* If the queue is assigned to the matrix mdev, unlink it. */
+	if (q)
+		vfio_ap_unlink_queue_fr_mdev(q);
+
+	return q;
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
 	struct vfio_ap_queue *q;
 
 	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
-		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+		q = vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi);
+
+		if (q && qtable) {
+			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+				hash_add(qtable->queues, &q->mdev_qnode,
+					 q->apqn);
+		}
+	}
+}
+
+static void vfio_ap_mdev_hot_unplug_adapter(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apid)
+{
+	int loop_cursor;
+	struct vfio_ap_queue *q;
+	struct ap_queue_table *qtable = kzalloc(sizeof(*qtable), GFP_KERNEL);
+
+	hash_init(qtable->queues);
+	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid, qtable);
+
+	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
+		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+	}
+
+	vfio_ap_mdev_reset_queues(qtable);
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
+		vfio_ap_unlink_mdev_fr_queue(q);
+		hash_del(&q->mdev_qnode);
 	}
+
+	kfree(qtable);
 }
 
 /**
@@ -1049,13 +1097,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
-	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
-
-	if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm)) {
-		clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
-		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
-	}
-
+	vfio_ap_mdev_hot_unplug_adapter(matrix_mdev, apid);
 	ret = count;
 done:
 	release_update_locks_for_mdev(matrix_mdev);
@@ -1148,19 +1190,49 @@ static ssize_t assign_domain_store(struct device *dev,
 static DEVICE_ATTR_WO(assign_domain);
 
 static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
-				       unsigned long apqi)
+				       unsigned long apqi,
+				       struct ap_queue_table *qtable)
 {
 	unsigned long apid;
 	struct vfio_ap_queue *q;
 
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
-		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+		q = vfio_ap_unlink_apqn_fr_mdev(matrix_mdev, apid, apqi);
 
-		if (q)
-			vfio_ap_mdev_unlink_queue(q);
+		if (q && qtable) {
+			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
+				hash_add(qtable->queues, &q->mdev_qnode,
+					 q->apqn);
+		}
 	}
 }
 
+static void vfio_ap_mdev_hot_unplug_domain(struct ap_matrix_mdev *matrix_mdev,
+					   unsigned long apqi)
+{
+	int loop_cursor;
+	struct vfio_ap_queue *q;
+	struct ap_queue_table *qtable = kzalloc(sizeof(*qtable), GFP_KERNEL);
+
+	hash_init(qtable->queues);
+	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi, qtable);
+
+	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+	}
+
+	vfio_ap_mdev_reset_queues(qtable);
+
+	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
+		vfio_ap_unlink_mdev_fr_queue(q);
+		hash_del(&q->mdev_qnode);
+	}
+
+	kfree(qtable);
+}
+
 /**
  * unassign_domain_store - parses the APQI from @buf and clears the
  * corresponding bit in the mediated matrix device's AQM
@@ -1196,13 +1268,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 	}
 
 	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
-	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
-
-	if (test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
-		clear_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
-		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
-	}
-
+	vfio_ap_mdev_hot_unplug_domain(matrix_mdev, apqi);
 	ret = count;
 
 done:
@@ -1487,7 +1553,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		get_update_locks_for_kvm(kvm);
 
 		kvm_arch_crypto_clear_masks(kvm);
-		vfio_ap_mdev_reset_queues(matrix_mdev);
+		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
@@ -1539,9 +1605,9 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 
 	if (!q)
 		return 0;
-
 retry_zapq:
 	status = ap_zapq(q->apqn);
+	q->reset_rc = status.response_code;
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
@@ -1556,12 +1622,17 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 	case AP_RESPONSE_Q_NOT_AVAIL:
 	case AP_RESPONSE_DECONFIGURED:
 	case AP_RESPONSE_CHECKSTOPPED:
-		WARN_ON_ONCE(status.irq_enabled);
+		WARN_ONCE(status.irq_enabled,
+			  "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ enabled",
+			  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+			  status.response_code);
 		ret = -EBUSY;
 		goto free_resources;
 	default:
 		/* things are really broken, give up */
-		WARN(true, "PQAP/ZAPQ completed with invalid rc (%x)\n",
+		WARN(true,
+		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
+		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
 		     status.response_code);
 		return -EIO;
 	}
@@ -1573,7 +1644,8 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 		msleep(20);
 		status = ap_tapq(q->apqn, NULL);
 	}
-	WARN_ON_ONCE(retry2 <= 0);
+	WARN_ONCE(retry2 <= 0, "unable to verify reset of queue %02x.%04x",
+		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
 
 free_resources:
 	vfio_ap_free_aqic_resources(q);
@@ -1581,12 +1653,12 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev)
+static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable)
 {
 	int ret, loop_cursor, rc = 0;
 	struct vfio_ap_queue *q;
 
-	hash_for_each(matrix_mdev->qtable.queues, loop_cursor, q, mdev_qnode) {
+	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
 		ret = vfio_ap_mdev_reset_queue(q, 1);
 		/*
 		 * Regardless whether a queue turns out to be busy, or
@@ -1674,7 +1746,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		ret = vfio_ap_mdev_reset_queues(matrix_mdev);
+		ret = vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index ec926f2f2930..6d4ca39f783b 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -129,6 +129,7 @@ struct ap_matrix_mdev {
  * @apqn: the APQN of the AP queue device
  * @saved_isc: the guest ISC registered with the GIB interface
  * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
+ * @reset_rc: the status response code from the last reset of the queue
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -137,6 +138,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 	struct hlist_node mdev_qnode;
+	unsigned int reset_rc;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.31.1

