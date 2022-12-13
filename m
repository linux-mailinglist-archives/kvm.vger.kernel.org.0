Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E49664B8DA
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbiLMPow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiLMPoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:44:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C570DEE;
        Tue, 13 Dec 2022 07:44:45 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDFdhRW020393;
        Tue, 13 Dec 2022 15:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aY1/43wckUfehCNKdJ6csQL39vDFoxi2MgSI0RBe/Ik=;
 b=gW9hPSIRrwOMgsplbH82K2zWm3PCf/7iUCVW9KK2yzPQrcsyEcf729DsDUjyynRQeVJa
 6/D9rPX9iwoi1r/PvinkL69eq5ULkhiU9caZj7dVMFOU5lePSx8HRSMGnpeZ+L0otfuT
 YGuw5bsH75/YXBpm5Rb+/t9iIIuiwMRaqheJqkRpw4Irt6TGiAp9qxqrpWq00vlx7tkU
 ACtZrdGsVbC3eTyORQSBCkYLw3HGJrkpWMaz3Quq1QXlkTzDugDuTQByTOlMyCePHxXz
 WJy/Z/nfxJLGJ2exn0pOs1cHKyM3s4T+UHDTNoAOvwmYFu9MuZixo+Hyomxxy7r1ztRy TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3meuttrpsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFeK4c022865;
        Tue, 13 Dec 2022 15:44:42 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3meuttrpsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:42 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDEqSvx014270;
        Tue, 13 Dec 2022 15:44:41 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mchr71aqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:41 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFie6P6488830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:40 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5048C58058;
        Tue, 13 Dec 2022 15:44:40 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EFA45805D;
        Tue, 13 Dec 2022 15:44:39 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:39 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 2/7] s390/vfio_ap: check TAPQ response code when waiting for queue reset
Date:   Tue, 13 Dec 2022 10:44:32 -0500
Message-Id: <20221213154437.15480-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fBTCK1OS6ezh9mZvsnQGLfrHTf9eQgcX
X-Proofpoint-GUID: Qyahk5nfIPWuFXMCVck2DnXnviXoiKJO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
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

The vfio_ap_mdev_reset_queue() function does not check the status
response code returned form the PQAP(TAPQ) function when verifying the
queue's status; consequently, there is no way of knowing whether
verification failed because the wait time was exceeded, or because the
PQAP(TAPQ) failed.

This patch adds a function to check the status response code from the
PQAP(TAPQ) instruction and logs an appropriate message if it fails.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 36 ++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 83ff94a38102..a5530a46cf31 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1587,23 +1587,49 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 	return q;
 }
 
+static int apq_status_check(int apqn, struct ap_queue_status *status)
+{
+	switch (status->response_code) {
+	case AP_RESPONSE_NORMAL:
+	case AP_RESPONSE_RESET_IN_PROGRESS:
+		if (status->queue_empty && !status->irq_enabled)
+			return 0;
+		return -EBUSY;
+	case AP_RESPONSE_DECONFIGURED:
+		/*
+		 * If the AP queue is deconfigured, any subsequent AP command
+		 * targeting the queue will fail with the same response code. On the
+		 * other hand, when an AP adapter is deconfigured, the associated
+		 * queues are reset, so let's return a value indicating the reset
+		 * for which we're waiting completed successfully.
+		 */
+		return 0;
+	default:
+		WARN(true,
+		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
+		     AP_QID_CARD(apqn), AP_QID_QUEUE(apqn),
+		     status->response_code);
+		return -EIO;
+	}
+}
+
 static int apq_reset_check(struct vfio_ap_queue *q)
 {
-	int iters = 2;
+	int iters = 2, ret;
 	struct ap_queue_status status;
 
 	while (iters--) {
 		msleep(20);
 		status = ap_tapq(q->apqn, NULL);
-		if (status.queue_empty && !status.irq_enabled)
-			return 0;
+		ret = apq_status_check(q->apqn, &status);
+		if (ret != -EBUSY)
+			return ret;
 	}
 	WARN_ONCE(iters <= 0,
 		  "timeout verifying reset of queue %02x.%04x (%u, %u, %u)",
 		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
 		  status.queue_empty, status.irq_enabled, status.response_code);
-
-	return -EBUSY;
+	return ret;
 }
 
 static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
-- 
2.31.1

