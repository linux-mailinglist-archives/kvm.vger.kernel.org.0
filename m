Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCB277D238
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbjHOSoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239249AbjHOSnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A91F1;
        Tue, 15 Aug 2023 11:43:51 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIRfAe013124;
        Tue, 15 Aug 2023 18:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J+SqeSbHqCyuyIkS150T7s7BPJ0sA2y2xDeSo7Ibqns=;
 b=sOq7B9v6/RjorvMjRw7V8KidA0MJq1JJqJDWXCuUVvxjphbMm30tcMoZOB8h5KTPh2DT
 W8CQihuM4nZ9RrUkxNGqXyvLnI8x2Ib14Bdo4lP+iyF2NJAgQhKlQchWkvfFffg1mint
 13EJr8O/5e7qRUeT3A1ZF/lhMB2v2SgdfWdXPrSdWVv9we7fOhoNQbuBmxTzQ0UojbG1
 idTicUwBvcpNOhBZJpCFJFj53PtgwD05OXBWVgJwkmhBsyagcZF367RDXWoIR/m1/JEe
 +mPm2b5vPga+RwE1gDvur5hMO1+2G3P/jnYu0nD9bo6gxMi47YpRZIxzdqnNDXI2tatD MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenk0cxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:49 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIS4dY015252;
        Tue, 15 Aug 2023 18:43:49 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgenk0cx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:49 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FHU6qM018843;
        Tue, 15 Aug 2023 18:43:48 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3seq41ec3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:48 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhlIR43844078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:47 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 146D45803F;
        Tue, 15 Aug 2023 18:43:47 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D340B58054;
        Tue, 15 Aug 2023 18:43:45 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:45 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 08/12] s390/vfio-ap: handle queue state change in progress on reset
Date:   Tue, 15 Aug 2023 14:43:29 -0400
Message-Id: <20230815184333.6554-9-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mWfnThElt8P3CZY6I1_CAubp3LTWmpDs
X-Proofpoint-ORIG-GUID: iwq3a0LH93lLaGB-fBVkn7NLYoQW3P58
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A new APQSW response code (0xA) indicating the designated queue is in the
process of being bound or associated to a configuration may be returned
from the PQAP(ZAPQ) command. This patch introduces code that will verify
when the PQAP(ZAPQ) command can be re-issued after receiving response code
0xA.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
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
2.39.3

