Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B64786F70
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbjHXMrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239266AbjHXMq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C4D10FA;
        Thu, 24 Aug 2023 05:46:25 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgklq028695;
        Thu, 24 Aug 2023 12:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=opiqjTNZE4ruIGrqTgkOVuRFOKUGjFLwyTiWzev31Cw=;
 b=D5DDI3erhC42ZzoucneV9IaEhWxnhgGOX6dPXecRY8OtYNJ8PKhiMFfFQfzPpNi2IhcF
 rXXAJHbLKMp8YhvaJ6oAohBw6nzUduOBIJQ1O75EHa4xE7F25e/J4xfBFGdJqAwGhfB1
 hVnp2iZP6k5KI37eoXWRembiT6OqCYMsZ3YkCew+Qv85xcm/5CztHETYxpgw06gbA1AK
 n5BKwTO7UJWa45E2tDBaOpv6n+ImxvdiT6dhZRFlPQgXQReUhEPMaO/SJEPiTQHZlNip
 hek8i+iXpVjF1g1YCRFWkvQ82TdUnMY8uDle2Am6fcSy9ra+j6r/nFcFCvQqwgNbp647 Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:22 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCh5UG029898;
        Thu, 24 Aug 2023 12:46:18 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0h73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:18 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCFaia026117;
        Thu, 24 Aug 2023 12:46:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3snqgt6c6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkDuQ28574234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A80E120043;
        Thu, 24 Aug 2023 12:46:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F306520040;
        Thu, 24 Aug 2023 12:46:12 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 07/22] s390/vfio-ap: no need to check the 'E' and 'I' bits in APQSW after TAPQ
Date:   Thu, 24 Aug 2023 14:43:16 +0200
Message-ID: <20230824124522.75408-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2FM6IlWzirUOBDHGBKTXHWCRD_5sa-x5
X-Proofpoint-GUID: zgs9U-0qyeg76WuiN4-tF6O4KPBpfUUi
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 3 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

After a ZAPQ is executed to reset a queue, if the queue is not empty or
interrupts are still enabled, the vfio_ap driver will wait for the reset
operation to complete by repeatedly executing the TAPQ instruction and
checking the 'E' and 'I' bits in the APQSW to verify that the queue is
empty and interrupts are disabled. This is unnecessary because it is
sufficient to check only the response code in the APQSW. If the reset is
still in progress, the response code will be 02; however, if the reset has
completed successfully, the response code will be 00.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-2-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b441745b0418..3fd80533194b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1608,19 +1608,10 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 {
 	switch (status->response_code) {
 	case AP_RESPONSE_NORMAL:
-	case AP_RESPONSE_RESET_IN_PROGRESS:
-		if (status->queue_empty && !status->irq_enabled)
-			return 0;
-		return -EBUSY;
 	case AP_RESPONSE_DECONFIGURED:
-		/*
-		 * If the AP queue is deconfigured, any subsequent AP command
-		 * targeting the queue will fail with the same response code. On the
-		 * other hand, when an AP adapter is deconfigured, the associated
-		 * queues are reset, so let's return a value indicating the reset
-		 * for which we're waiting completed successfully.
-		 */
 		return 0;
+	case AP_RESPONSE_RESET_IN_PROGRESS:
+		return -EBUSY;
 	default:
 		WARN(true,
 		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
-- 
2.41.0

