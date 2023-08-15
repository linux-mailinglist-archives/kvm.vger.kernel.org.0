Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E9F77D231
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbjHOSoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239244AbjHOSnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28A0E63;
        Tue, 15 Aug 2023 11:43:47 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIatvw029446;
        Tue, 15 Aug 2023 18:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=l9Iy1ttodFtwjuCIspUavpR7DN6Dx0UTbq3hQ3mc8fc=;
 b=RYZ/INClfagNGjljFo5HR9M8z4haU4N0xT1xtvz02S67518c5JYL1iVqU5wMJcjFkU17
 PMKVXrbgwC+3ndqs8yyslCaz9kNsU+H+aTOpD8QDEyUK+J0PLGhGEseycWkMYPLe7qJf
 hCbTPxorOy9J4LjRiNBbDiN+i6lJg0EOgs8ykp9TJ58z5rfI+sKKSW5uaXijlKUIJmg2
 KmcgA/hvMIREufeeqj/SNASJB0eOrQkkvVhdDGlhmNSyfp0bt6RM144F6DXm/4EE/ajs
 5kPXdEBqYlhSQseic2COwoPMtEWdlIqApNsj5mrZe15odsiYjDz0Cq7Bbh3feV1tI1qn /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgene08rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:45 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIcPdj001638;
        Tue, 15 Aug 2023 18:43:45 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgene08rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:45 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FGw5jI018831;
        Tue, 15 Aug 2023 18:43:44 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3seq41ec34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:44 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhgW94391520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:43 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D24355803F;
        Tue, 15 Aug 2023 18:43:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D46958054;
        Tue, 15 Aug 2023 18:43:41 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:41 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 05/12] s390/vfio-ap: remove upper limit on wait for queue reset to complete
Date:   Tue, 15 Aug 2023 14:43:26 -0400
Message-Id: <20230815184333.6554-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6dE3cDMBM5xwUYVfwj9SM6wFPqYo-9st
X-Proofpoint-GUID: Hg_hx2GX26a6rWfNkunXPvGC0vSzZN8X
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
2.39.3

