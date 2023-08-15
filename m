Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E71677D233
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbjHOSoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbjHOSnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CC3E63;
        Tue, 15 Aug 2023 11:43:50 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIarYp029298;
        Tue, 15 Aug 2023 18:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6Yp6lVQ3fWYMmRXvEzv5w5HMaY3nu8YvHEEhEFA98NQ=;
 b=QQymXKG/HlU8fiuJXkMhMIDbJMkcSzZt7rOHqq1vbQpQx9rEdxjxuFxyBOfyAFsFc8Tr
 91bW1TlvnbPUE5Rz3f+G4dJORdw4X7nCS4cRmBQew+XMfBcUd8ddrdXzkiQucivDe127
 45yijmKfYlvw/1YCd/hlevc9cwqZSYGEtDY+sFbhaB1HOKXhd+I2epypIQQZzBxyNS0T
 wlMbewzTnsoypSlO0QbXZa+Beo6PfuVP310zH0C4cxUEFFM3fQyiyyOB2i7bKu2Y1Nhu
 QiLGBfTMCGcGIvJU92fttZGquom28ysy3sAAi7CRfjc5Va8U6xVvWwlUlmhOHRtm41Ty Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgene08se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:48 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIcPdl001638;
        Tue, 15 Aug 2023 18:43:47 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgene08s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:47 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIUgO0007828;
        Tue, 15 Aug 2023 18:43:46 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwk6vhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:46 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhjlE23921148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:45 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC20958055;
        Tue, 15 Aug 2023 18:43:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6312C5804E;
        Tue, 15 Aug 2023 18:43:44 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 07/12] s390/vfio-ap: use work struct to verify queue reset
Date:   Tue, 15 Aug 2023 14:43:28 -0400
Message-Id: <20230815184333.6554-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5QLxme6olYJg5VYZ_PDJu30ApgtRKvWY
X-Proofpoint-GUID: TaMbkCEljr1hY83SsjU4K-bFftxRSlew
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of waiting to verify that a queue is reset in the
vfio_ap_mdev_reset_queue function, let's use a wait queue to check the
the state of the reset. This way, when resetting all of the queues assigned
to a matrix mdev, we don't have to wait for each queue to be reset before
initiating a reset on the next queue to be reset.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 48 +++++++++++++--------------
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 43224f7a40ea..3a59f1c5390f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -35,7 +35,7 @@
 static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
-static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q);
+static void vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q);
 
 /**
  * get_update_locks_for_kvm: Acquire the locks required to dynamically update a
@@ -1623,11 +1623,13 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 
 #define WAIT_MSG "Waited %dms for reset of queue %02x.%04x (%u, %u, %u)"
 
-static int apq_reset_check(struct vfio_ap_queue *q)
+static void apq_reset_check(struct work_struct *reset_work)
 {
 	int ret = -EBUSY, elapsed = 0;
 	struct ap_queue_status status;
+	struct vfio_ap_queue *q;
 
+	q = container_of(reset_work, struct vfio_ap_queue, reset_work);
 	memcpy(&status, &q->reset_status, sizeof(status));
 	while (true) {
 		msleep(AP_RESET_INTERVAL);
@@ -1635,7 +1637,7 @@ static int apq_reset_check(struct vfio_ap_queue *q)
 		status = ap_tapq(q->apqn, NULL);
 		ret = apq_status_check(q->apqn, &status);
 		if (ret == -EIO)
-			return ret;
+			return;
 		if (ret == -EBUSY) {
 			pr_notice_ratelimited(WAIT_MSG, elapsed,
 					      AP_QID_CARD(q->apqn),
@@ -1663,34 +1665,32 @@ static int apq_reset_check(struct vfio_ap_queue *q)
 			break;
 		}
 	}
-	return ret;
 }
 
-static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
+static void vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 {
 	struct ap_queue_status status;
-	int ret = 0;
 
 	if (!q)
-		return 0;
+		return;
 	status = ap_zapq(q->apqn, 0);
 	memcpy(&q->reset_status, &status, sizeof(status));
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 	case AP_RESPONSE_BUSY:
-		/* Let's verify whether the ZAPQ completed successfully */
-		ret = apq_reset_check(q);
+		/*
+		 * Let's verify whether the ZAPQ completed successfully on a work queue.
+		 */
+		queue_work(system_long_wq, &q->reset_work);
 		break;
 	case AP_RESPONSE_DECONFIGURED:
 		/*
 		 * When an AP adapter is deconfigured, the associated
 		 * queues are reset, so let's set the status response code to 0
-		 * so the queue may be passed through (i.e., not filtered) and
-		 * return a value indicating the reset completed successfully.
+		 * so the queue may be passed through (i.e., not filtered).
 		 */
 		q->reset_status.response_code = 0;
-		ret = 0;
 		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
@@ -1698,29 +1698,25 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
 		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
 		     status.response_code);
-		return -EIO;
 	}
-
-	return ret;
 }
 
 static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable)
 {
-	int ret, loop_cursor, rc = 0;
+	int ret = 0, loop_cursor;
 	struct vfio_ap_queue *q;
 
+	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode)
+		vfio_ap_mdev_reset_queue(q);
+
 	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
-		ret = vfio_ap_mdev_reset_queue(q);
-		/*
-		 * Regardless whether a queue turns out to be busy, or
-		 * is not operational, we need to continue resetting
-		 * the remaining queues.
-		 */
-		if (ret)
-			rc = ret;
+		flush_work(&q->reset_work);
+
+		if (q->reset_status.response_code)
+			ret = -EIO;
 	}
 
-	return rc;
+	return ret;
 }
 
 static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
@@ -2045,6 +2041,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	memset(&q->reset_status, 0, sizeof(q->reset_status));
+	INIT_WORK(&q->reset_work, apq_reset_check);
 	matrix_mdev = get_update_locks_by_apqn(q->apqn);
 
 	if (matrix_mdev) {
@@ -2094,6 +2091,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	}
 
 	vfio_ap_mdev_reset_queue(q);
+	flush_work(&q->reset_work);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
 	release_update_locks_for_mdev(matrix_mdev);
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index d6eb3527e056..88aff8b81f2f 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -134,6 +134,7 @@ struct ap_matrix_mdev {
  * @saved_isc: the guest ISC registered with the GIB interface
  * @mdev_qnode: allows the vfio_ap_queue struct to be added to a hashtable
  * @reset_status: the status from the last reset of the queue
+ * @reset_work: work to wait for queue reset to complete
  */
 struct vfio_ap_queue {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -143,6 +144,7 @@ struct vfio_ap_queue {
 	unsigned char saved_isc;
 	struct hlist_node mdev_qnode;
 	struct ap_queue_status reset_status;
+	struct work_struct reset_work;
 };
 
 int vfio_ap_mdev_register(void);
-- 
2.39.3

