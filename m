Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D058777D229
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbjHOSoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbjHOSno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C1119B5;
        Tue, 15 Aug 2023 11:43:41 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIS6VB009853;
        Tue, 15 Aug 2023 18:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HH6sZpvsrqd+ghN/dxoQr6XNtiZthX/6XKMetRau/1Q=;
 b=HP4NC/AerLl71VjhK/q4nZ+P/S7rZy3T6NNp5j0Wc3ItC4uUSXZjTcNIkfMjrjrHYm89
 aRjshYhANmhG3TSHHkfQeu1OP70HyaWapO66Lc1G0qFl1MHtxW9rArtMT3+Zcskt0Egg
 wd97LcrEnOT7Vp58KW6E0MYuX/tOg9nVmWUlLuu0ONktW6//U0aqidG82YJW8Nbz/j4S
 aXkKKxRz0dI1RDNtmrshuHa8zdN3YLM8EFr9eq2u8YwZNUJEc6Jx212jrsx57HBwYUux
 zNmTZRdP4ovWG38iBBj5gIRdH870Wd5NVxQ7r7PM70lbJGQWu1ayJ9z0S65gbC3JbDhe jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenvrbjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:39 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FITunH027291;
        Tue, 15 Aug 2023 18:43:39 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenvrbjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FGsLbj003446;
        Tue, 15 Aug 2023 18:43:38 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3semdsffnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:38 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhbqF46989654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:37 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 256205804E;
        Tue, 15 Aug 2023 18:43:37 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEBAA5803F;
        Tue, 15 Aug 2023 18:43:35 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:35 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 01/12] s390/vfio-ap: No need to check the 'E' and 'I' bits in APQSW after TAPQ
Date:   Tue, 15 Aug 2023 14:43:22 -0400
Message-Id: <20230815184333.6554-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3OnY-MvL3nZ-3dINqD-IfsouQlC9j2d3
X-Proofpoint-GUID: 0BpmklMiZ2TPr1AuvwL7iuydcG-Sy1gu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 clxscore=1015 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.39.3

