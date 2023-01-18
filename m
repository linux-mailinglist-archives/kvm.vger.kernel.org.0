Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE73D672966
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjARUc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjARUbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:31:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0041B5EFA8;
        Wed, 18 Jan 2023 12:31:19 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IIh1df013535;
        Wed, 18 Jan 2023 20:31:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4J4belgMp4AtpP1svwpQWhXS+xPp/xtdvz4Ufhu5SDM=;
 b=c5DL3qfTQP3nfwX7637cEJQ4+lVTIgeRMyL6Tav3hC8Bs3EV8w84+S/3qVMdomqtCT22
 KMaZMvLt8ygaocha5Gt9AKiCIJSVNP6XZ1KUrmsLOeAAA/sJn/bE21omF48xiYK3+TWs
 c/WaelSU463ImNxIw+PlEPyQrEamWVmicMbAN2+OyPXL88HDEEmIBSZnDE4l4JcFhxZq
 liwqd6Bom+lIaqhtuXYAieDEIgk+09UdoiRmK9NwuVtrh9z494kBW+mkekBTEZj8Pssj
 iX5MMKsG68xair1In2rdzCC2Ww245fBTM+nHZjWkBYB5A+wdUb+nDCzMTbyyru/GWWkd KA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jbyguh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:18 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IKNlII009318;
        Wed, 18 Jan 2023 20:31:18 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3n3m17yrnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:18 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IKVGuW3211816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 20:31:16 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF6AA58043;
        Wed, 18 Jan 2023 20:31:15 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 737C158055;
        Wed, 18 Jan 2023 20:31:15 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 20:31:15 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, pasic@linux.ibm.com
Subject: [PATCH v2 5/6] s390/vfio_ap: fix handling of error response codes
Date:   Wed, 18 Jan 2023 15:31:10 -0500
Message-Id: <20230118203111.529766-6-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230118203111.529766-1-akrowiak@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: amG6DJKbHgfk4hO-AaxEPoMLbmas6_SJ
X-Proofpoint-GUID: amG6DJKbHgfk4hO-AaxEPoMLbmas6_SJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180169
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
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e1b05e749570..68be34362680 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1670,17 +1670,15 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
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
@@ -1688,7 +1686,6 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		return -EIO;
 	}
 
-free_resources:
 	vfio_ap_free_aqic_resources(q);
 
 	return ret;
-- 
2.31.1

