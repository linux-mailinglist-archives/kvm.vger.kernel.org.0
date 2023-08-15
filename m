Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D82177D22B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbjHOSoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239234AbjHOSno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFF410D8;
        Tue, 15 Aug 2023 11:43:43 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIRqL0014215;
        Tue, 15 Aug 2023 18:43:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2CkStjPAlQAVkiPuP5tL+7MDhNpBeV7ayR172+a3ONI=;
 b=WdES4AnB0HZp9lX8eSXkfEvM3/q1MzIO2+TAYQNrsnpzqctEd6sVT7pQdaxy2JI6Ftwy
 ZtDadVoqZ+76tuGok6/mW3vVgdYMgp4RhMdLYR7oiZFbdX9V1krHZhq0H80pomjo1T1f
 aFh5MMtWMUV0HLXiWB/OVzd8dDH7GEAi2rr+xi+3sutztYSF5xpR1bwO6q2D8xv2VF/F
 S0LLljlpXqfp5PPABojZyIInXsNO2pWKSzJ8gL2Hf3RYpC0a+QLleyETcLhkCu0f37Rj
 0sv5IhIbUTkNShj/R2gIniMD3o9sBvEchQFVKtBdRq2llltkx/PyFwQjgdm3MAy0AW/i 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenk0cv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:41 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIT0q6018520;
        Tue, 15 Aug 2023 18:43:40 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenk0cur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:40 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FHPTtf018891;
        Tue, 15 Aug 2023 18:43:40 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3seq41ec2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:39 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhcUP57147766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:38 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94D1458054;
        Tue, 15 Aug 2023 18:43:38 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B9FD5803F;
        Tue, 15 Aug 2023 18:43:37 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:37 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 02/12] s390/vfio-ap: clean up irq resources if possible
Date:   Tue, 15 Aug 2023 14:43:23 -0400
Message-Id: <20230815184333.6554-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: L-yVcUmL4o2O2Zoco0khWXvsdYXFA2hw
X-Proofpoint-ORIG-GUID: 26-Oomw0CIzOlxHr156qJcquq9zwljHE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The architecture does not specify whether interrupts are disabled as part
of the asynchronous reset or upon return from the PQAP/ZAPQ instruction.
If, however, PQAP/ZAPQ completes with APQSW response code 0 and the
interrupt bit in the status word is also 0, we know the interrupts are
disabled and we can go ahead and clean up the corresponding resources;
otherwise, we must wait until the asynchronous reset has completed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 3fd80533194b..be92ba45226d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1654,9 +1654,13 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
-		/* if the reset has not completed, wait for it to take effect */
-		if (!status.queue_empty || status.irq_enabled)
+		if (!status.irq_enabled)
+			vfio_ap_free_aqic_resources(q);
+		if (!status.queue_empty || status.irq_enabled) {
 			ret = apq_reset_check(q);
+			if (status.irq_enabled && ret == 0)
+				vfio_ap_free_aqic_resources(q);
+		}
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		/*
@@ -1675,6 +1679,7 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		 * completed successfully.
 		 */
 		ret = 0;
+		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
 		WARN(true,
@@ -1684,8 +1689,6 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		return -EIO;
 	}
 
-	vfio_ap_free_aqic_resources(q);
-
 	return ret;
 }
 
-- 
2.39.3

