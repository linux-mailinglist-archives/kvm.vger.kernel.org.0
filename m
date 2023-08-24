Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A474786F6D
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbjHXMrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbjHXMq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2437E59;
        Thu, 24 Aug 2023 05:46:24 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgluE028728;
        Thu, 24 Aug 2023 12:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6rvllxeWG4ZKOiuw0X/JUUiJiptKnW0LQrh7eAvfO1E=;
 b=bW/9Xy+JerkGS83PcalMtAI62pLu1uRi8xlX1AxsP8CX7s90jMY69UsDxCBZ42ICkP5n
 oMXw18bJ2M1b9VLSKRuk3Ot8jc0WSli21p94AiR6GHfB+uZKNwvaJkZ8A/QYZ8s7IIhP
 hwSo0UF+RtDhc9GinjSwtrHEZtJt6maTVjiWxvHvGDC5/8OkVhr5Xm22EONwHeLzGLsp
 DKPKTUAJY8GjB/iWjU2dx0lGp9u62JbQuLz61iXjaek4W/8Zl4EFsACtfmzWvgIYlkB7
 QIP7vlCOnQ8n1pwSlzd+mI6yTfzr3TislKsd6soSWkOxM+uUtxc1XP4RDPsiGjhdoWjg HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:23 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCguRo029242;
        Thu, 24 Aug 2023 12:46:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7eu0hem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:21 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCDdW7026128;
        Thu, 24 Aug 2023 12:46:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3snqgt6c6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:18 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkGh43998454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D80120043;
        Thu, 24 Aug 2023 12:46:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AF5720040;
        Thu, 24 Aug 2023 12:46:15 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 10/22] s390/vfio-ap: allow deconfigured queue to be passed through to a guest
Date:   Thu, 24 Aug 2023 14:43:19 +0200
Message-ID: <20230824124522.75408-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DuiAUoToqQ1OuBi3eFkRWwhX2I47wKgJ
X-Proofpoint-GUID: BXCDRa53fp1-DeO-6EQc6iXSIjXuy30b
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

When a queue is reset, the status response code returned from the reset
operation is stored in the reset_rc field of the vfio_ap_queue structure
representing the queue being reset. This field is later used to decide
whether the queue should be passed through to a guest. If the reset_rc
field is a non-zero value, the queue will be filtered from the list of
queues passed through.

When an adapter is deconfigured, all queues associated with that adapter
are reset. That being the case, it is not necessary to filter those queues;
so, if the status response code returned from a reset operation indicates
the queue is deconfigured, the reset_rc field of the vfio_ap_queue
structure will be set to zero so it will be passed through (i.e., not
filtered).

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815184333.6554-5-akrowiak@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 3f67cfb53d0c..a489536c508a 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1677,9 +1677,11 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 	case AP_RESPONSE_DECONFIGURED:
 		/*
 		 * When an AP adapter is deconfigured, the associated
-		 * queues are reset, so let's return a value indicating the reset
-		 * completed successfully.
+		 * queues are reset, so let's set the status response code to 0
+		 * so the queue may be passed through (i.e., not filtered) and
+		 * return a value indicating the reset completed successfully.
 		 */
+		q->reset_rc = 0;
 		ret = 0;
 		vfio_ap_free_aqic_resources(q);
 		break;
-- 
2.41.0

