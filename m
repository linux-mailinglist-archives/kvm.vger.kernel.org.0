Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14C3672963
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjARUcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjARUbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:31:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3F06049C;
        Wed, 18 Jan 2023 12:31:22 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IJLt32030550;
        Wed, 18 Jan 2023 20:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TFJMmKjzCRt8iI3VZPPzk6CozeeyVDrEDYww5FQJkyc=;
 b=brPPhWjlQA4VOEw/r6SP5GI3Py7rRo8/K+Nzuq/iYiEVoVE8QyROUnl77ZP3n6Wh/wuO
 w14OdXMMTZ3hIEen1yBk2HjSvdDOEEeMnoi7L3Xa2o+fHB+ToIaKWXwlLlz+vfxBR8k0
 13D43muRzbkC3lq4qJgPqqq+RxsY+s8DLKs2hEyVmhHKUqP9Gv+BeUY2EbfWo1hOLX4D
 wBcgWXBEMSqX6QtXz4RD3c1KFp3a7UELZ90XkWYWdzG8oB7T6dTbwy2u5L+6/ZctKaBp
 XvuuwRoih/wn1sJqUlUDiH1UB2EC1tfBTSfAvRIPbcA81gyJALpBIWCmiFgmBeCXizwo UA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6hem2m3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:21 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IJreTp027328;
        Wed, 18 Jan 2023 20:31:15 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3n3m17yvdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:15 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IKVEDN23790128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 20:31:14 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2354058043;
        Wed, 18 Jan 2023 20:31:14 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AC8558055;
        Wed, 18 Jan 2023 20:31:13 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 20:31:13 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, pasic@linux.ibm.com
Subject: [PATCH v2 2/6] s390/vfio_ap: check TAPQ response code when waiting for queue reset
Date:   Wed, 18 Jan 2023 15:31:07 -0500
Message-Id: <20230118203111.529766-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230118203111.529766-1-akrowiak@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x4JLYMCcdHVcaixHxQ2kvjqmtxEPpN-H
X-Proofpoint-GUID: x4JLYMCcdHVcaixHxQ2kvjqmtxEPpN-H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301180173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 36 ++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 7523496bfbae..b27daaaa79b4 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1598,23 +1598,49 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
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

