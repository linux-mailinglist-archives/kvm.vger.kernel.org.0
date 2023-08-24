Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB518787078
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 15:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241300AbjHXNkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 09:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbjHXNji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 09:39:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17704C7;
        Thu, 24 Aug 2023 06:39:37 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37ODcOfh010433;
        Thu, 24 Aug 2023 13:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=WQdbeUFNy/objbgN/mqUYC4PaH/o4DUlr6OnFKbUFQo=;
 b=Kmzw/mR77iW+gZb2zCgwn2feBc4nXCGg5ND8QGFKXJbF3uZ+JJu6YIBPkbW7RDWCEovm
 9IkxZOkWthXK+Duww6s41x/U3IzP2WDnq2VVO2RmBo23ML7rzhbq26CQ4fy5oT4dPx4l
 PR6Y+kpbtpf6MPmQ5cPX9n1h6oIDrsxpgNLBKn2TxfLg0HFhxY0i/ngG/RMdEurYdDiR
 t8tqe6y67EMra1pKfji+vudhFXayEvOSoQnQsvX4e/+Dojbgn4CR9cFVqUslV/otiCdE
 Bxj88p6XHphKpYwUPmYUhDd+2iyzK68/jOtaOztg2ytIiL7kk4QC0lTCCdUOE0gb6AOq aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7qb2j3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 13:39:36 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37ODcod6012631;
        Thu, 24 Aug 2023 13:39:36 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7qb2j13-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 13:39:36 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OC7mSi027398;
        Thu, 24 Aug 2023 12:46:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn20sq131-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:17 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkERp17957520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 738F620043;
        Thu, 24 Aug 2023 12:46:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C084C20040;
        Thu, 24 Aug 2023 12:46:13 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 08/22] s390/vfio-ap: clean up irq resources if possible
Date:   Thu, 24 Aug 2023 14:43:17 +0200
Message-ID: <20230824124522.75408-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gybm8GEVS_cJlocAQ0KMGaIAeJ6Xo24v
X-Proofpoint-ORIG-GUID: QXGxHpVFI3KtjL6LYw0W6DLJWa-rkjD2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxlogscore=951 phishscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2308240112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

The architecture does not specify whether interrupts are disabled as part
of the asynchronous reset or upon return from the PQAP/ZAPQ instruction.
If, however, PQAP/ZAPQ completes with APQSW response code 0 and the
interrupt bit in the status word is also 0, we know the interrupts are
disabled and we can go ahead and clean up the corresponding resources;
otherwise, we must wait until the asynchronous reset has completed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-3-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 3fd80533194b..be92ba45226d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1654,9 +1654,13 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
-		/* if the reset has not completed, wait for it to take effect */
-		if (!status.queue_empty || status.irq_enabled)
+		if (!status.irq_enabled)
+			vfio_ap_free_aqic_resources(q);
+		if (!status.queue_empty || status.irq_enabled) {
 			ret = apq_reset_check(q);
+			if (status.irq_enabled && ret == 0)
+				vfio_ap_free_aqic_resources(q);
+		}
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		/*
@@ -1675,6 +1679,7 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		 * completed successfully.
 		 */
 		ret = 0;
+		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
 		WARN(true,
@@ -1684,8 +1689,6 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		return -EIO;
 	}
 
-	vfio_ap_free_aqic_resources(q);
-
 	return ret;
 }
 
-- 
2.41.0

