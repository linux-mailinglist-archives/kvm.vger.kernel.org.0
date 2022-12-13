Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7E64B8CB
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbiLMPpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLMPor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:44:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5068E6586;
        Tue, 13 Dec 2022 07:44:46 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDFR7jU031180;
        Tue, 13 Dec 2022 15:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=15/G/vmJBxZeYg70tSxJkS6nwvsvKmMgrgz76AKrT+c=;
 b=p57ZPW9cUHwI1JT7Lfe3LF6k5NzolBsOy4shEhYFHma258122KoJhHyxuOVQRAPPxy2Q
 hbYVqbz0W3Ow+bcvUudSfi29WPqbFSl9FWThkfkL2PT6iMEhdjxLKF/N4HtpO6AkgH1T
 3MvEIT/WwoRG+lLxP4/C8qXaYbEVj+jIgCmY26jPJuX6IhIZm8MA9a2m6kOuEs1NtwBU
 pNI8KHFBW5lyv64/RcDcjcCCZw8Z5saFjR/YZGiRevyrDkWuetGgvD/4Q4hhRHx+T2X1
 6BvxY57//S2cdWFs1YvDhP1tAxmEj6HjxJ4h5iWtVaUhkXuhIzlD0fkZq2pET8cjgxkV pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev20ghhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:44 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFRNoF031576;
        Tue, 13 Dec 2022 15:44:43 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev20ghh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:43 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDF01Fo014276;
        Tue, 13 Dec 2022 15:44:42 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mchr71aqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:42 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFifTa53674472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:41 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B52358057;
        Tue, 13 Dec 2022 15:44:41 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AFF45805D;
        Tue, 13 Dec 2022 15:44:40 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 3/7] s390/vfio_ap: use TAPQ to verify reset in progress completes
Date:   Tue, 13 Dec 2022 10:44:33 -0500
Message-Id: <20221213154437.15480-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Gq0kmsOSed9vtqKp1dAXQNDz5l_ohQCv
X-Proofpoint-ORIG-GUID: Vuv56c3rfqBjdwcTwHFqEDmtgVYBCyde
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1011 mlxscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To eliminate the repeated calls to the PQAP(ZAPQ) function to verify that
a reset in progress completed successfully and ensure that error response
codes get appropriately logged, let's call the apq_reset_check() function
when the ZAPQ response code indicates that a reset that is already in
progress.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a5530a46cf31..5bf2d93ae8af 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -33,7 +33,7 @@
 static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
-static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry);
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q);
 
 /**
  * get_update_locks_for_kvm: Acquire the locks required to dynamically update a
@@ -1632,8 +1632,7 @@ static int apq_reset_check(struct vfio_ap_queue *q)
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-				    unsigned int retry)
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 {
 	struct ap_queue_status status;
 	int ret;
@@ -1648,12 +1647,15 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 		ret = 0;
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
-		if (retry--) {
-			msleep(20);
-			goto retry_zapq;
-		}
-		ret = -EBUSY;
-		break;
+		/*
+		 * There is a reset issued by another process in progress. Let's wait
+		 * for that to complete. Since we have no idea whether it was a RAPQ or
+		 * ZAPQ, then if it completes successfully, let's issue the ZAPQ.
+		 */
+		ret = apq_reset_check(q);
+		if (ret)
+			break;
+		goto retry_zapq;
 	case AP_RESPONSE_Q_NOT_AVAIL:
 	case AP_RESPONSE_DECONFIGURED:
 	case AP_RESPONSE_CHECKSTOPPED:
@@ -1688,7 +1690,7 @@ static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable)
 	struct vfio_ap_queue *q;
 
 	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
-		ret = vfio_ap_mdev_reset_queue(q, 1);
+		ret = vfio_ap_mdev_reset_queue(q);
 		/*
 		 * Regardless whether a queue turns out to be busy, or
 		 * is not operational, we need to continue resetting
@@ -1931,7 +1933,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 		}
 	}
 
-	vfio_ap_mdev_reset_queue(q, 1);
+	vfio_ap_mdev_reset_queue(q);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
 	release_update_locks_for_mdev(matrix_mdev);
-- 
2.31.1

