Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FC564B8DD
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbiLMPpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiLMPow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:44:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7E6DEE;
        Tue, 13 Dec 2022 07:44:49 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDFPk3o025564;
        Tue, 13 Dec 2022 15:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/HQeFvFXqFV0XM1oj4U79Hhc3J2Khc8fBjlo8EEXLU0=;
 b=rCFXxpzEgJtvIJMvYKEki+51wPlzpD5luGAlc1YzJ9MvfcgSoLEkruEds5Y4gy8TWBVb
 qjFTciQ5a3UgiDFNQd2zR4ZkzM4lzb8FGxyi9PZylVpXoqJlKRtfuwcXX/f+aZd29jTg
 3Q2SiQBybMyNn8Nb6/BEvoTGekgk0uqdIOchm7rl1hgWASp9/XR6hvP3qPGVy7REAh3D
 5iH4dJGWD1+ykOKb8bZ6n9mPS1Mbr3F6xNDjMGguaa7BvzvZ6fVkKqTFkBjxZoLAt4XG
 wnU81njjZw1lHPqHdWjbJFveI//MJRh9kIG1YXNXBHHwWvsQ0qmtvcH4ObSRW/xbSF8M Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev1drke0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:46 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFRen9004108;
        Tue, 13 Dec 2022 15:44:46 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev1drkdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:46 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDhTav007534;
        Tue, 13 Dec 2022 15:44:45 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3mchr6mahp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:45 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFihEt36831664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:43 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 126AD58061;
        Tue, 13 Dec 2022 15:44:43 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 431AC58057;
        Tue, 13 Dec 2022 15:44:42 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:42 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 5/7] s390/vfio_ap: fix handling of error response codes
Date:   Tue, 13 Dec 2022 10:44:35 -0500
Message-Id: <20221213154437.15480-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 60Bbzj8n0Xmo-tq8yaMQBoTDtDz7-ier
X-Proofpoint-GUID: Xk6xYjLMjVrN-0e5DWApVh4e2gRCVC_9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 priorityscore=1501
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

Some response codes returned from the queue reset function are not being
handled correctly; this patch fixes them:

1. Response code 3, AP queue deconfigured: Deconfiguring an AP adapter
   resets all of its queues, so this is handled by indicating the reset
   verification completed successfully.

2. For all response codes other than 0 (normal reset completion), 2
   (queue reset in progress) and 3 (AP deconfigured), the -EIO error will
   be returned from the vfio_ap_mdev_reset_queue() function. In all cases,
   all fields of the status word other than the response code will be
   set to zero, so it makes no sense to check status bits.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index c0cf5050be59..dbf681715a6d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1659,17 +1659,15 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		if (ret)
 			break;
 		goto retry_zapq;
-	case AP_RESPONSE_Q_NOT_AVAIL:
 	case AP_RESPONSE_DECONFIGURED:
-	case AP_RESPONSE_CHECKSTOPPED:
-		WARN_ONCE(status.irq_enabled,
-			  "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ enabled",
-			  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
-			  status.response_code);
-		ret = -EBUSY;
-		goto free_resources;
+		/*
+		 * When an AP adapter is deconfigured, the associated
+		 * queues are reset, so let's return a value indicating the reset
+		 * completed successfully.
+		 */
+		ret = 0;
+		break;
 	default:
-		/* things are really broken, give up */
 		WARN(true,
 		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
 		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
@@ -1677,7 +1675,6 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		return -EIO;
 	}
 
-free_resources:
 	vfio_ap_free_aqic_resources(q);
 
 	return ret;
-- 
2.31.1

