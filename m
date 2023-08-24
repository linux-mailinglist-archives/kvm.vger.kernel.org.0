Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80C4786F7E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbjHXMrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbjHXMqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C2910FA;
        Thu, 24 Aug 2023 05:46:39 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgkmG028695;
        Thu, 24 Aug 2023 12:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=hR0Hz8NsgMuF/FJLjmqTnSXGRqm1QD5M6FDfgey+Ke4=;
 b=aYw3vxObVKgeKMgajsXnFQQGQTqwTLIXJwCuL2Oh4GPKh2AnpaXY0MFv6Qg54zFxvYfI
 8cvqcMBDZ09aiNjtuX9tDK0648fBnHD0k5y8ZJumxIw2N4WkTQSa0bLI+Xa7IYGGSQOu
 JuKIKf3vmqkUONhgp8Y/oVSQ1fcqOWWaelKHY3vwb2UX/Coog0QCq1J7Ss76ujAZiMha
 LiTiT8wKLuaZhUUVbfDavQV6MBHShS+zI7tW3zfGIWJdA45Xr2ffndt226MVJnfdpcBL
 tioBwTMUEce3pspSOZ7Q4ULn3fSPssWKSkfa0cBWJAXsfungEt3Kq6cigEXwOnzIJ+QH Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0jbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:38 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCgnhi028796;
        Thu, 24 Aug 2023 12:46:28 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:27 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCTJVo027323;
        Thu, 24 Aug 2023 12:46:22 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn20sq14a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:22 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkJt619792520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B4492004B;
        Thu, 24 Aug 2023 12:46:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 787DD20040;
        Thu, 24 Aug 2023 12:46:18 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 14/22] s390/vfio-ap: handle queue state change in progress on reset
Date:   Thu, 24 Aug 2023 14:43:23 +0200
Message-ID: <20230824124522.75408-15-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R6Tuaj-H9mgX0W0fU0AR8iXXxB0hUZN1
X-Proofpoint-GUID: L4ADYVLeD1HqxYUNk4doO6WSGzNTNadw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
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

A new APQSW response code (0xA) indicating the designated queue is in the
process of being bound or associated to a configuration may be returned
from the PQAP(ZAPQ) command. This patch introduces code that will verify
when the PQAP(ZAPQ) command can be re-issued after receiving response code
0xA.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-9-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 3a59f1c5390f..43dea259fe23 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1647,7 +1647,8 @@ static void apq_reset_check(struct work_struct *reset_work)
 					      status.irq_enabled);
 		} else {
 			if (q->reset_status.response_code == AP_RESPONSE_RESET_IN_PROGRESS ||
-			    q->reset_status.response_code == AP_RESPONSE_BUSY) {
+			    q->reset_status.response_code == AP_RESPONSE_BUSY ||
+			    q->reset_status.response_code == AP_RESPONSE_STATE_CHANGE_IN_PROGRESS) {
 				status = ap_zapq(q->apqn, 0);
 				memcpy(&q->reset_status, &status, sizeof(status));
 				continue;
@@ -1679,6 +1680,7 @@ static void vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 	case AP_RESPONSE_NORMAL:
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 	case AP_RESPONSE_BUSY:
+	case AP_RESPONSE_STATE_CHANGE_IN_PROGRESS:
 		/*
 		 * Let's verify whether the ZAPQ completed successfully on a work queue.
 		 */
-- 
2.41.0

