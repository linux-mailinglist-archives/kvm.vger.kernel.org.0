Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8768E5536D7
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353379AbiFUPwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353182AbiFUPv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:51:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494952C67C;
        Tue, 21 Jun 2022 08:51:56 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LFOjPm019976;
        Tue, 21 Jun 2022 15:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nBloUJ+Su90N18fOcGpDM6MWkRGyQX19LrZmmNNmWVc=;
 b=B5VCAQu7doSIW3Dz9D29A5eggJSdagMoHjtIEIOoGf4QYITgRv2nsg49m69Ey3q0xdWx
 DoTvbDkRodgWSCY6kE/1OnEZSTrng80WUVI+4XZ2Hf66g4C7yNmEyI+RINaDTz+pxYda
 MgqRe7HycJiySC1EiBuA+Z7647aeDYLjgcF+/YsMdSTCP0PbRMgxDyhUWZVMzasc2TI5
 ysOFvOBDBaR1HWvMKCCfYl32lxoCVwv7USiU1Z5WDNGtfdXuM3ypuceu7PuoqZrkMjrn
 7UF0jlA3JtQ0lfRt0pqaCfhDaNSYvp0YAfhVJxaUShXsITWScdtp78LMkl2nxnQv0bfW UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugkxgwwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:55 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LFoABI003391;
        Tue, 21 Jun 2022 15:51:54 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gugkxgwwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:54 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZONu014744;
        Tue, 21 Jun 2022 15:51:53 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3gs6bacw2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:53 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFpqd929491588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:52 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29443136059;
        Tue, 21 Jun 2022 15:51:52 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 245F2136053;
        Tue, 21 Jun 2022 15:51:51 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:51 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 14/20] s390/vfio-ap: reset queues after adapter/domain unassignment
Date:   Tue, 21 Jun 2022 11:51:28 -0400
Message-Id: <20220621155134.1932383-15-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -g674oGU0xcySXO9K7K9V2D7RgHuD4u6
X-Proofpoint-GUID: Eajadv1zB7CskP8jnfWWj0NaW_jjjk-O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 152 +++++++++++++++++++-------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 114 insertions(+), 40 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 090e033cff69..479e83e54cce 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -30,9 +30,10 @@
 #define AP_QUEUE_UNASSIGNED "unassigned"
 #define AP_QUEUE_IN_USE "in use"
 
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
@@ -755,12 +757,6 @@ static void vfio_ap_unlink_mdev_fr_queue(struct vfio_ap_queue *q)
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
@@ -785,7 +781,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 
 	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
-	vfio_ap_mdev_reset_queues(matrix_mdev);
+	vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 	vfio_ap_mdev_unlink_fr_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->mdevs_lock);
@@ -999,18 +995,70 @@ static ssize_t assign_adapter_store(struct device *dev,
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
@@ -1048,13 +1096,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
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
@@ -1147,19 +1189,49 @@ static ssize_t assign_domain_store(struct device *dev,
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
@@ -1195,13 +1267,7 @@ static ssize_t unassign_domain_store(struct device *dev,
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
@@ -1486,7 +1552,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		get_update_locks_for_kvm(kvm);
 
 		kvm_arch_crypto_clear_masks(kvm);
-		vfio_ap_mdev_reset_queues(matrix_mdev);
+		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
@@ -1520,9 +1586,9 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 
 	if (!q)
 		return 0;
-
 retry_zapq:
 	status = ap_zapq(q->apqn);
+	q->reset_rc = status.response_code;
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
@@ -1537,12 +1603,17 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
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
@@ -1554,7 +1625,8 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 		msleep(20);
 		status = ap_tapq(q->apqn, NULL);
 	}
-	WARN_ON_ONCE(retry2 <= 0);
+	WARN_ONCE(retry2 <= 0, "unable to verify reset of queue %02x.%04x",
+		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
 
 free_resources:
 	vfio_ap_free_aqic_resources(q);
@@ -1562,12 +1634,12 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
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
@@ -1651,7 +1723,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		ret = vfio_ap_mdev_reset_queues(matrix_mdev);
+		ret = vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 82ac74e83e13..7110288fab68 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -126,6 +126,7 @@ struct ap_matrix_mdev {
  * @apqn: the APQN of the AP queue device
  * @saved_isc: the guest ISC registered with the GIB interface
  * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
+ * @reset_rc: the status response code from the last reset of the queue
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -134,6 +135,7 @@ struct vfio_ap_queue {
 #define VFIO_AP_ISC_INVALID 0xff
 	unsigned char saved_isc;
 	struct hlist_node mdev_qnode;
+	unsigned int reset_rc;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.35.3

