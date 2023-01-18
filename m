Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55221672974
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjARUcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjARUbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:31:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ABD5F3B5;
        Wed, 18 Jan 2023 12:31:22 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IIaER0014142;
        Wed, 18 Jan 2023 20:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+YxVYTXd8FjVV1zFFNPP5+lwoxTTu+Ov7bPEzx1bIag=;
 b=D6w/XFBwZeaUiubqS+DRCi2TB6CqIvs6EXVQr3Dmjs0G4fKktuHwNkvBITlaZm+QppyA
 Iu7xY3FqnbCwyRAi/DTGuMKsZBaAuNIYZfKrGvxBq6M97aztuI4HYE+FDEJCBRL9yLwv
 TTU8g4GHS1W+6Y+yJD0nnpPWH/Wixk+C6EU9+5laawHQzXe3s8hnGDmjpwGyYrmmUgyp
 tcDTGNW9FrlcOVOiyO8AyLdYByBwpBBKo/OZfi067VQvdc608rgSZKDrH9jMNTnDZdew
 4gcHn9Ve2lgoZRP6jc9c0eC5zW8V53MrTZpenOlc6pLUJQou1I1fJJNJNQL9QPbW3Scl Aw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6hvn9mnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:21 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IJdcN2024977;
        Wed, 18 Jan 2023 20:31:16 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3n3m17quru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:16 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IKVEKQ35913992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 20:31:15 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B946E58043;
        Wed, 18 Jan 2023 20:31:14 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CC4B58059;
        Wed, 18 Jan 2023 20:31:14 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 20:31:14 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, pasic@linux.ibm.com
Subject: [PATCH v2 3/6] s390/vfio_ap: use TAPQ to verify reset in progress completes
Date:   Wed, 18 Jan 2023 15:31:08 -0500
Message-Id: <20230118203111.529766-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230118203111.529766-1-akrowiak@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xRySWNIXIEBFdWl4UEpJbBc4_iYCbM8p
X-Proofpoint-ORIG-GUID: xRySWNIXIEBFdWl4UEpJbBc4_iYCbM8p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b27daaaa79b4..a443ee5f7789 100644
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
@@ -1643,8 +1643,7 @@ static int apq_reset_check(struct vfio_ap_queue *q)
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-				    unsigned int retry)
+static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 {
 	struct ap_queue_status status;
 	int ret;
@@ -1659,12 +1658,15 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
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
@@ -1699,7 +1701,7 @@ static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable)
 	struct vfio_ap_queue *q;
 
 	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
-		ret = vfio_ap_mdev_reset_queue(q, 1);
+		ret = vfio_ap_mdev_reset_queue(q);
 		/*
 		 * Regardless whether a queue turns out to be busy, or
 		 * is not operational, we need to continue resetting
@@ -1944,7 +1946,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 		}
 	}
 
-	vfio_ap_mdev_reset_queue(q, 1);
+	vfio_ap_mdev_reset_queue(q);
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
 	release_update_locks_for_mdev(matrix_mdev);
-- 
2.31.1

