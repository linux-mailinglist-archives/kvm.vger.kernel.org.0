Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD1477D230
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbjHOSoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbjHOSnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9105F1;
        Tue, 15 Aug 2023 11:43:45 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIWlsj009888;
        Tue, 15 Aug 2023 18:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9ewDPtH9ZFAhL4Awkwr5fEe5DG2YdKuVJVkLlCLMbME=;
 b=QR2fAlw15WKOx3T4ST5uUi/d99sdy7VX1ZgtIZ7eQOTzUKp+nxbENXtrylvIBqIa9+vj
 Y5wgdkXoa6KCrY8819opKVmtUl4PLRhoIDo1Dym9dYxr9IXc0gsgx3jZfdklv0mNvIQ3
 X0/pmZroaZrMY44O8qqeopTEq9aLO6WT4QN/xaFGMrsjHyIVDHgZBCbsi82FP6o6pxXV
 lQIDfixQc62qzpehV2FR2kEvwHRSZL3vdGafjuTTxdffZvGh95380r4xT0xnVtkr8Erw
 Admio5Izr1gOqjMYVIAUtYK/i9ZK0OVnSqmcqpKUB2lHsA6DVpeEyIOqXacMwm8DdmwE lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgeqv86p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:42 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIhLl7013204;
        Tue, 15 Aug 2023 18:43:42 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgeqv86ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:42 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FHnBhg002418;
        Tue, 15 Aug 2023 18:43:41 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sendn71pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:41 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIherx4260444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:40 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B2A35804E;
        Tue, 15 Aug 2023 18:43:40 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBD115803F;
        Tue, 15 Aug 2023 18:43:38 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:38 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 03/12] s390/vfio-ap: wait for response code 05 to clear on queue reset
Date:   Tue, 15 Aug 2023 14:43:24 -0400
Message-Id: <20230815184333.6554-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z_XPK4E-FL2ZodWomGtV8z65xVtiQ-Ku
X-Proofpoint-ORIG-GUID: qSuGlFPKWmaMh4_s5PSPw6XvjzgEzj1p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Response code 05, AP busy, is a valid response code for a ZAPQ or TAPQ.
Instead of returning error -EIO when a ZAPQ fails with response code 05,
let's wait until the queue is no longer busy and try the ZAPQ again.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index be92ba45226d..3f67cfb53d0c 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1611,6 +1611,7 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 	case AP_RESPONSE_DECONFIGURED:
 		return 0;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
+	case AP_RESPONSE_BUSY:
 		return -EBUSY;
 	default:
 		WARN(true,
@@ -1663,6 +1664,7 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		}
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
+	case AP_RESPONSE_BUSY:
 		/*
 		 * There is a reset issued by another process in progress. Let's wait
 		 * for that to complete. Since we have no idea whether it was a RAPQ or
-- 
2.39.3

