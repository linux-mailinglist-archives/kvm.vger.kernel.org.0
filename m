Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F6F672976
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjARUcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjARUbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:31:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A5D604A6;
        Wed, 18 Jan 2023 12:31:22 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IISkuU014159;
        Wed, 18 Jan 2023 20:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jdRvS+madd8DlQ5LU7UCAXCRJMtHgcKoZrsJsowupOY=;
 b=SOQyPi2jnpAJxBk2KGwDN2XeXU6bbH1ZAE0ARDhgoaZ8SoNIcyITJ8APyXD0F51EPX/V
 eouhDLR/rmSRnKDzPwjX6+4+q0/ZFjfz0sNKxfBZMbLFVhb3PM8OGV2bDWfrTrunCGAM
 rhUi5Yh2tqIDTqxGUlP2ooVMK4iKc0uYLxIOfBa9FXE61MEOmzDm6S96TX6X5b/ERPsa
 YGgLer3/uYzSIe73ALklDzfEhtw0VUGyb4rnkwO6xgjZleph9IZOxSL2PNPiyGRnNEMu
 RRWFgS2o7zObKTe4EnIuTCNFV5Jqs7S/HoQZ0p6b2fQ7J/56Z6EgQqS4CoapC965wNu3 yQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6hvn9mn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:21 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IJdcN0024977;
        Wed, 18 Jan 2023 20:31:14 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3n3m17qurs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:14 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IKVD4152560292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 20:31:13 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 817FB58043;
        Wed, 18 Jan 2023 20:31:13 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04DD058055;
        Wed, 18 Jan 2023 20:31:13 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 20:31:12 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, pasic@linux.ibm.com
Subject: [PATCH v2 1/6] s390/vfio-ap: verify reset complete in separate function
Date:   Wed, 18 Jan 2023 15:31:06 -0500
Message-Id: <20230118203111.529766-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230118203111.529766-1-akrowiak@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cRCdHxEGCGt_7wf1WT_tnahTRg7G5NRu
X-Proofpoint-ORIG-GUID: cRCdHxEGCGt_7wf1WT_tnahTRg7G5NRu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_ap_mdev_reset_queue() function contains a loop to verify that the
reset successfully completes within 40ms. This patch moves that loop into
a separate function.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9c01957e56b3..7523496bfbae 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1598,12 +1598,30 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 	return q;
 }
 
+static int apq_reset_check(struct vfio_ap_queue *q)
+{
+	int iters = 2;
+	struct ap_queue_status status;
+
+	while (iters--) {
+		msleep(20);
+		status = ap_tapq(q->apqn, NULL);
+		if (status.queue_empty && !status.irq_enabled)
+			return 0;
+	}
+	WARN_ONCE(iters <= 0,
+		  "timeout verifying reset of queue %02x.%04x (%u, %u, %u)",
+		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+		  status.queue_empty, status.irq_enabled, status.response_code);
+
+	return -EBUSY;
+}
+
 static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 				    unsigned int retry)
 {
 	struct ap_queue_status status;
 	int ret;
-	int retry2 = 2;
 
 	if (!q)
 		return 0;
@@ -1640,14 +1658,8 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 	}
 
 	/* wait for the reset to take effect */
-	while (retry2--) {
-		if (status.queue_empty && !status.irq_enabled)
-			break;
-		msleep(20);
-		status = ap_tapq(q->apqn, NULL);
-	}
-	WARN_ONCE(retry2 <= 0, "unable to verify reset of queue %02x.%04x",
-		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
+	if (!(status.queue_empty && !status.irq_enabled))
+		ret = apq_reset_check(q);
 
 free_resources:
 	vfio_ap_free_aqic_resources(q);
-- 
2.31.1

