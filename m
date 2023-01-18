Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687F7672978
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjARUcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjARUbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:31:42 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FCC5F395;
        Wed, 18 Jan 2023 12:31:20 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IJcXFn020232;
        Wed, 18 Jan 2023 20:31:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qsmgMKIfCvzFFP+MW1CT1qJ5I9c85Ggjf4gT7J2pj34=;
 b=ZnIhzh7fmOaXDn9gXPjpDlfcBk8gbgwnTKldks3GWAfl5Fo2g5JJGs2h6IwxTfyuLmiT
 Ya895bjFgp1Qtf4qhunOzQ+1Y+MFeSYls0UWUZAv3IKjiBusKzIOyEpJSvNq8DQAjFce
 Xj7y2DLmCjfpR8qJ1WQHRcmcaEjtOMoeSUl5L4qZSVGnQvIzGzVOOnagpKL89BeJ3FNV
 szfMGJQHMwAVnNPOaBGugLHAycq49x10nhj97rrgHylx4NCIf6RbajJ72sla5fEfBG+w
 uNMEnr3vr6N6D5PItld/1QtbUk7z9mAQPv+AWu6cGBMC76DMGWDYkneOGiC9VNLst1ol 3A== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6bu0ty8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:19 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IK2MJZ025991;
        Wed, 18 Jan 2023 20:31:18 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3n3m17ytp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 20:31:18 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IKVGc88782376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 20:31:17 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90C0358043;
        Wed, 18 Jan 2023 20:31:16 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14CDC58055;
        Wed, 18 Jan 2023 20:31:16 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 20:31:15 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, pasic@linux.ibm.com
Subject: [PATCH v2 6/6] s390/vfio_ap: increase max wait time for reset verification
Date:   Wed, 18 Jan 2023 15:31:11 -0500
Message-Id: <20230118203111.529766-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230118203111.529766-1-akrowiak@linux.ibm.com>
References: <20230118203111.529766-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6CsUgAbO6BkWfh49ecze4VLWjeB-MeTe
X-Proofpoint-ORIG-GUID: 6CsUgAbO6BkWfh49ecze4VLWjeB-MeTe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180169
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
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 68be34362680..d665e1bc494a 100644
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
@@ -1626,11 +1629,12 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 
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

