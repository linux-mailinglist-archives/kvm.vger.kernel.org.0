Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44E064B8DE
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiLMPpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiLMPow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:44:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EF3BFE;
        Tue, 13 Dec 2022 07:44:50 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDFR2tM030522;
        Tue, 13 Dec 2022 15:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dfFEvzxcZTkwSQ/e3MtFp13igO39lEXpwrF8wYyyIak=;
 b=TSW4U4fgkvQjwCVTesfPQy8uo9QNaav5olbP0iucOICbujiI2TkZK1goU7s8nW3AthL7
 EIaWHmF5f5avrHWOBL6NB4vl/obAE2ZhTPriqqy3BaZypa9+DPraCNRhGW7c3DsZDyns
 KL8hkQjytSkYGlCi28H1S44q4Fpybu+0IkLKWgO1h1qrk0l4bLhLmxTSn9Q/AZpPKvAT
 O1Mh9/X+ip2QNYmFxFjQdrT81kzI+7zApH8R+YhUad2s89tt4ERH0ehqHQ3ow2rm1HBh
 lOp7gH1J9eVHE8/md2C+x+6awuWUIW49MZaN9Gl8xSn2OivSttIW7OFY0P+T3TeQJxZL rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev20ghjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:47 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFVlj4019383;
        Tue, 13 Dec 2022 15:44:47 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev20ghje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:47 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2BDDl6aV011447;
        Tue, 13 Dec 2022 15:44:46 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3mchr6m9a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:46 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFii5s6160908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:44 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0BF358058;
        Tue, 13 Dec 2022 15:44:43 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CFCD58063;
        Tue, 13 Dec 2022 15:44:43 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:43 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 6/7] s390/vfio_ap: increase max wait time for reset verification
Date:   Tue, 13 Dec 2022 10:44:36 -0500
Message-Id: <20221213154437.15480-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 30oDbVs1f4I-rMgOaXNxWr9Kx0pMScRV
X-Proofpoint-ORIG-GUID: T08x9ExxlZxzxJTzYMzDH47Yqi95saXt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
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

Increase the maximum time to wait for verification of a queue reset
operation to 200ms.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index dbf681715a6d..e80c5a6b91be 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -30,6 +30,9 @@
 #define AP_QUEUE_UNASSIGNED "unassigned"
 #define AP_QUEUE_IN_USE "in use"
 
+#define MAX_RESET_CHECK_WAIT	200	/* Sleep max 200ms for reset check	*/
+#define AP_RESET_INTERVAL		20	/* Reset sleep interval (20ms)		*/
+
 static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
@@ -1615,11 +1618,12 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 
 static int apq_reset_check(struct vfio_ap_queue *q)
 {
-	int iters = 2, ret;
+	int ret;
+	int iters = MAX_RESET_CHECK_WAIT / AP_RESET_INTERVAL;
 	struct ap_queue_status status;
 
-	while (iters--) {
-		msleep(20);
+	for (; iters > 0; iters--) {
+		msleep(AP_RESET_INTERVAL);
 		status = ap_tapq(q->apqn, NULL);
 		ret = apq_status_check(q->apqn, &status);
 		if (ret != -EBUSY)
-- 
2.31.1

