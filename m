Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B1A786F8E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbjHXMul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240448AbjHXMuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:50:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72741FE9;
        Thu, 24 Aug 2023 05:49:50 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCfcM0001348;
        Thu, 24 Aug 2023 12:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=pdC8UfW+UsF2fc5n26MN79i/S9Z0t4NH8o6et5AJf3I=;
 b=XuyYQ2wL32FFDmoOxOdsblDx9+YWDurIxQhgTM4BU6Lvk8Wm5rdiC2gpcpY6Pc+7pjio
 NeBBmMm1FxMvVS4x4e7vZVp1dqNSPkdwlI5QY53izYRnEcz5gNW5TIq7BwFWMX7vAxtP
 AdWBN+fzbUKEvgyljqFHZ69TyIWue8658V+C/98/zf1d11r88Zw7MTOsxpeLMt/8jMKg
 r1tF219NWF6SH3mUN+Z9nio+MP6sGhqorbvezxFAdCpKExk1QJOfN16jXyDnyHoHyjGx
 dRxbSOub0vP0zI/W8jx0BYDBo2l7JanLalEEn+XMD6Zs6Djjex/4haFWKw0UK4C2f3nP Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp75xsfr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:49:07 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCfcbB001369;
        Thu, 24 Aug 2023 12:49:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp75xsfbq-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:49:07 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OC7mSo027398;
        Thu, 24 Aug 2023 12:46:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn20sq14g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkKmm28574248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECA632004B;
        Thu, 24 Aug 2023 12:46:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4289120040;
        Thu, 24 Aug 2023 12:46:19 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 15/22] s390/vfio-ap: check for TAPQ response codes 0x35 and 0x36
Date:   Thu, 24 Aug 2023 14:43:24 +0200
Message-ID: <20230824124522.75408-16-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Iojiinv-_VuvxrZfJ5WwwAAgzL9SB9kJ
X-Proofpoint-ORIG-GUID: 8GUtogPbyTBtIpoXOw0AhTQvRUKRFuLJ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

Check for response codes 0x35 and 0x36 which are asynchronous return codes
indicating a failure of the guest to associate a secret with a queue. Since
there can be no interaction with this queue from the guest (i.e., the vcpus
are out of SIE for hot unplug, the guest is being shut down or an emulated
subsystem reset of the guest is taking place), let's go ahead and re-issue
the ZAPQ to reset and zeroize the queue.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-10-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 43dea259fe23..8bda52c46df0 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1612,6 +1612,16 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 	case AP_RESPONSE_BUSY:
 		return -EBUSY;
+	case AP_RESPONSE_ASSOC_SECRET_NOT_UNIQUE:
+	case AP_RESPONSE_ASSOC_FAILED:
+		/*
+		 * These asynchronous response codes indicate a PQAP(AAPQ)
+		 * instruction to associate a secret with the guest failed. All
+		 * subsequent AP instructions will end with the asynchronous
+		 * response code until the AP queue is reset; so, let's return
+		 * a value indicating a reset needs to be performed again.
+		 */
+		return -EAGAIN;
 	default:
 		WARN(true,
 		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
@@ -1648,7 +1658,8 @@ static void apq_reset_check(struct work_struct *reset_work)
 		} else {
 			if (q->reset_status.response_code == AP_RESPONSE_RESET_IN_PROGRESS ||
 			    q->reset_status.response_code == AP_RESPONSE_BUSY ||
-			    q->reset_status.response_code == AP_RESPONSE_STATE_CHANGE_IN_PROGRESS) {
+			    q->reset_status.response_code == AP_RESPONSE_STATE_CHANGE_IN_PROGRESS ||
+			    ret == -EAGAIN) {
 				status = ap_zapq(q->apqn, 0);
 				memcpy(&q->reset_status, &status, sizeof(status));
 				continue;
-- 
2.41.0

