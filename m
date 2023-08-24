Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AA8786F7B
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240684AbjHXMrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239918AbjHXMqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4DF10FA;
        Thu, 24 Aug 2023 05:46:29 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgpbi020099;
        Thu, 24 Aug 2023 12:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=DqVFFAASRVuLUQwL3s0fu1Uxp7xwz+akm0tYPhoc/Fk=;
 b=bdkKbLrKIUkfG/JST6yXCMqpexdXaSr+W16mh8VB1Q8GhXQzOoWGr3z4dgY7O8jd33A0
 shCZoQXaJqEDwc5GJUC3MH+OdFvguqghRLhR1m9DMHY5//rKiE65Sr6oeYOCUbtnpw5s
 2zCe/INgSAH/pfGcpz5CrAOsJMi6+6NqbCF9a+NXGOuHW9LdPuWexqSntlNMtRZIDV3M
 Qa1H0mFy+T7pTRvvM7FrSVmjXalO3wyh2x0ajg3FQM71z7gVMSRaWja6arYLKUx8YkZp
 LTbx/82piVobeTXeomiWt7BgfFdN2Q+2W5G1cnFO7hl4tmHqV9XjaVCSwu4+H2YHPt76 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0h6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:27 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCgpdP020074;
        Thu, 24 Aug 2023 12:46:24 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0gvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:24 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCex6K010275;
        Thu, 24 Aug 2023 12:46:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn21sy07w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:21 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkIOw63635912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:18 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6120A2004B;
        Thu, 24 Aug 2023 12:46:18 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE23E20040;
        Thu, 24 Aug 2023 12:46:17 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 13/22] s390/vfio-ap: use work struct to verify queue reset
Date:   Thu, 24 Aug 2023 14:43:22 +0200
Message-ID: <20230824124522.75408-14-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: h6OSTpiW4Ti5zJiwiFsX0978n8lDvrbH
X-Proofpoint-GUID: giG1TwpHTc4EE3AqUUOCmran9_YjmZt6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

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
Link: https://lore.kernel.org/r/20230815184333.6554-8-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
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
2.41.0

