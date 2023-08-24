Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2731786F78
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240674AbjHXMrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239967AbjHXMqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF6E59;
        Thu, 24 Aug 2023 05:46:30 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgnYf019963;
        Thu, 24 Aug 2023 12:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=epQuVKG7RNIlL2VSofHR3gOE3FJryMDatCvarLkvL/w=;
 b=X3CPg28lkGxaQjLJsxMzdm/mHgbPD7GKjY0sOPRxKtUWYyVxHOitZEckI08mhnMoafQc
 up98hgDjGnN1LJGzou17/pW6m0aX+GTFBVopYxdoSNSSe5hTLmpIc01FrHErj4gtfzlX
 0ClTwAxvCLef4hHUGBJCbri7SkmpH0ZVMyuCfTJpDj10i3R27xIBVJFQz8EeoQLms6n5
 Mpk1KAQpVN5lagF4GnvXg5jshZHCLKPZ4Tb1C3Tsml/MzWedtyLiEWNDaF6+1Uz3SAbI
 l5PyImho7bAfEo4OVqlNRrMnfu8Ti3zzQTkvpjhBkBXUSSe0Hite+zZlTM8PZnGHZKWC /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0h4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:28 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OChtvr026181;
        Thu, 24 Aug 2023 12:46:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0grx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:24 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCcHuQ004042;
        Thu, 24 Aug 2023 12:46:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn21rpxm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkGAT21758576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCE862004D;
        Thu, 24 Aug 2023 12:46:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2545320040;
        Thu, 24 Aug 2023 12:46:16 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 11/22] s390/vfio-ap: remove upper limit on wait for queue reset to complete
Date:   Thu, 24 Aug 2023 14:43:20 +0200
Message-ID: <20230824124522.75408-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I780k44Hk5FSZLP76lqIVFNhsGfMl60n
X-Proofpoint-GUID: 6MpF_coLnfwk5PGE1pr07M3CkSBzIHl0
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

The architecture does not define an upper limit on how long a queue reset
(RAPQ/ZAPQ) can take to complete. In order to ensure both the security
requirements and prevent resource leakage and corruption in the hypervisor,
it is necessary to remove the upper limit (200ms) the vfio_ap driver
currently waits for a reset to complete. This, of course, may result in a
hang which is a less than desirable user experience, but until a firmware
solution is provided, this is a necessary evil.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-6-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 64 +++++++++++++++++--------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a489536c508a..2517868aad56 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -30,7 +30,6 @@
 #define AP_QUEUE_UNASSIGNED "unassigned"
 #define AP_QUEUE_IN_USE "in use"
 
-#define MAX_RESET_CHECK_WAIT	200	/* Sleep max 200ms for reset check	*/
 #define AP_RESET_INTERVAL		20	/* Reset sleep interval (20ms)		*/
 
 static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
@@ -1622,58 +1621,66 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 	}
 }
 
+#define WAIT_MSG "Waited %dms for reset of queue %02x.%04x (%u, %u, %u)"
+
 static int apq_reset_check(struct vfio_ap_queue *q)
 {
-	int ret;
-	int iters = MAX_RESET_CHECK_WAIT / AP_RESET_INTERVAL;
+	int ret = -EBUSY, elapsed = 0;
 	struct ap_queue_status status;
 
-	for (; iters > 0; iters--) {
+	while (true) {
 		msleep(AP_RESET_INTERVAL);
+		elapsed += AP_RESET_INTERVAL;
 		status = ap_tapq(q->apqn, NULL);
 		ret = apq_status_check(q->apqn, &status);
-		if (ret != -EBUSY)
+		if (ret == -EIO)
 			return ret;
+		if (ret == -EBUSY) {
+			pr_notice_ratelimited(WAIT_MSG, elapsed,
+					      AP_QID_CARD(q->apqn),
+					      AP_QID_QUEUE(q->apqn),
+					      status.response_code,
+					      status.queue_empty,
+					      status.irq_enabled);
+		} else {
+			if (q->reset_rc == AP_RESPONSE_RESET_IN_PROGRESS ||
+			    q->reset_rc == AP_RESPONSE_BUSY) {
+				status = ap_zapq(q->apqn, 0);
+				q->reset_rc = status.response_code;
+				continue;
+			}
+			/*
+			 * When an AP adapter is deconfigured, the associated
+			 * queues are reset, so let's set the status response
+			 * code to 0 so the queue may be passed through (i.e.,
+			 * not filtered).
+			 */
+			if (q->reset_rc == AP_RESPONSE_DECONFIGURED)
+				q->reset_rc = 0;
+			if (q->saved_isc != VFIO_AP_ISC_INVALID)
+				vfio_ap_free_aqic_resources(q);
+			break;
+		}
 	}
-	WARN_ONCE(iters <= 0,
-		  "timeout verifying reset of queue %02x.%04x (%u, %u, %u)",
-		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
-		  status.queue_empty, status.irq_enabled, status.response_code);
 	return ret;
 }
 
 static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 {
 	struct ap_queue_status status;
-	int ret;
+	int ret = 0;
 
 	if (!q)
 		return 0;
-retry_zapq:
 	status = ap_zapq(q->apqn, 0);
 	q->reset_rc = status.response_code;
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
-		ret = 0;
-		if (!status.irq_enabled)
-			vfio_ap_free_aqic_resources(q);
-		if (!status.queue_empty || status.irq_enabled) {
-			ret = apq_reset_check(q);
-			if (status.irq_enabled && ret == 0)
-				vfio_ap_free_aqic_resources(q);
-		}
-		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 	case AP_RESPONSE_BUSY:
-		/*
-		 * There is a reset issued by another process in progress. Let's wait
-		 * for that to complete. Since we have no idea whether it was a RAPQ or
-		 * ZAPQ, then if it completes successfully, let's issue the ZAPQ.
-		 */
+		/* Let's verify whether the ZAPQ completed successfully */
 		ret = apq_reset_check(q);
-		if (ret)
-			break;
-		goto retry_zapq;
+		break;
 	case AP_RESPONSE_DECONFIGURED:
 		/*
 		 * When an AP adapter is deconfigured, the associated
@@ -1682,7 +1689,6 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		 * return a value indicating the reset completed successfully.
 		 */
 		q->reset_rc = 0;
-		ret = 0;
 		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
-- 
2.41.0

