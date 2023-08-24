Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F768786F68
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240550AbjHXMrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239396AbjHXMq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9819510FC;
        Thu, 24 Aug 2023 05:46:25 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgl5n028742;
        Thu, 24 Aug 2023 12:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=lrSanGjCAtF8Xw0z/BFamfJIiVAupEAP3cDT6ZFfGVE=;
 b=C+GUD7q+AjU1yuZO6D17lEpKUkYL48NFANS4LBjYFZDy7tNuzB7SR4l216oF9+0Quzd2
 k/bGA+0LgQOBHkFbtIPKjZ3OBAClXIxdVTuh6UcK0ZRWas3/HsY8itToFYsdnuh4yn8j
 yVbkAr2KByXnlj50Y9RluXCt/loMlWuvUuE9ZEa1bM6dPdNEhceuL7ukzScjOdD6oV0Y
 UECTSngDB+3Lf5wzUMuPYk7G9eyAu760p45a9ManbH9mPUef/Goxbwlug+hNZSxnHbUk
 /nGVy2/pn1ZBGacOZ+hyMgi1pBfkPg2Zg8SAHb4umt3CdtqUAtVeBLJuo+MayvFcRLNh Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:24 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCh5UM029898;
        Thu, 24 Aug 2023 12:46:22 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:21 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCM2ee010414;
        Thu, 24 Aug 2023 12:46:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn21sy075-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:18 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkFUZ34406952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:15 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 417FC20043;
        Thu, 24 Aug 2023 12:46:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C0AD20040;
        Thu, 24 Aug 2023 12:46:14 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 09/22] s390/vfio-ap: wait for response code 05 to clear on queue reset
Date:   Thu, 24 Aug 2023 14:43:18 +0200
Message-ID: <20230824124522.75408-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KOXxtaM1rnapC3NIZI3zZtjNYcztq44M
X-Proofpoint-GUID: C-zAYyCfG6opTnL-dcN6XSnr0HTa7O3E
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

Response code 05, AP busy, is a valid response code for a ZAPQ or TAPQ.
Instead of returning error -EIO when a ZAPQ fails with response code 05,
let's wait until the queue is no longer busy and try the ZAPQ again.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-4-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
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
2.41.0

