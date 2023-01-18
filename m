Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9734D672971
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjARUci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjARUbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:31:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C51B5F3A4;
        Wed, 18 Jan 2023 12:31:20 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IIx2FL026784;
        Wed, 18 Jan 2023 20:31:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hDEE7oP/CybO1a98Cb/Ygms7KGm0GkxsYtYiDPJ7T6M=;
 b=f25+prfYVKxRo0wR1o+z6NTEmN+UjQN/RlJmho7XZWcVByZ+j2eTV1I1ZP1ZN7fXICv2
 4wsMB4622yqbVYOzuo3jZNFIhtUwo69Mj8f57niDGb1dt1t+onSrufkQSzRIjIbAm0WC
 BofEAniuyOmXxl880QdelmE6tbXKAuyoEFuwS2WObrQTzcBcqjf4NGLcHoD2zECX+tk9
 4bw+G1TeKs+IYgmmedhNzrXtZZPtiADXypAPD8R+nHDgAfF/CnyBh6tVzUyx8+IjM3a1
 qoaFnxxRaC2CjlOTVfa/SdzsleXYgs88SSbqfu6N2p9yHTGZAwWWQAxQvMOn/q8b05Yy kQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6j239h36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:19 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IK5HYD020235;
        Wed, 18 Jan 2023 20:31:18 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3n3m17qrfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:18 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IKVFP326477090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 20:31:15 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A4CB58043;
        Wed, 18 Jan 2023 20:31:15 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2B8E58055;
        Wed, 18 Jan 2023 20:31:14 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 20:31:14 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, pasic@linux.ibm.com
Subject: [PATCH v2 4/6] s390/vfio_ap: verify ZAPQ completion after return of response code zero
Date:   Wed, 18 Jan 2023 15:31:09 -0500
Message-Id: <20230118203111.529766-5-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230118203111.529766-1-akrowiak@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5TckCJiGnK0ukEAKVn9L0boblihpxX59
X-Proofpoint-ORIG-GUID: 5TckCJiGnK0ukEAKVn9L0boblihpxX59
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180169
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verification that the asynchronous ZAPQ function has completed only needs
to be done when the response code indicates the function was successfully
initiated; so, let's call the apq_reset_check function immediately after
the response code zero is returned from the ZAPQ.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a443ee5f7789..e1b05e749570 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1656,6 +1656,9 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
+		/* if the reset has not completed, wait for it to take effect */
+		if (!status.queue_empty || status.irq_enabled)
+			ret = apq_reset_check(q);
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		/*
@@ -1685,10 +1688,6 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		return -EIO;
 	}
 
-	/* wait for the reset to take effect */
-	if (!(status.queue_empty && !status.irq_enabled))
-		ret = apq_reset_check(q);
-
 free_resources:
 	vfio_ap_free_aqic_resources(q);
 
-- 
2.31.1

