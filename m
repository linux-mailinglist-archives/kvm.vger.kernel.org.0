Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E8544C57
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 21:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfFMTkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 15:40:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42022 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729307AbfFMTkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 15:40:22 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DJaave014366;
        Thu, 13 Jun 2019 15:40:01 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t3v8g1ffq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 15:40:01 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5DJbOH0029513;
        Thu, 13 Jun 2019 19:40:00 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 2t1xj30b4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 19:40:00 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5DJduTa21102880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 19:39:56 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECEDF6E050;
        Thu, 13 Jun 2019 19:39:55 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03C186E053;
        Thu, 13 Jun 2019 19:39:54 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.158.129])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jun 2019 19:39:53 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v4 2/7] s390: vfio-ap: wait for queue empty on queue reset
Date:   Thu, 13 Jun 2019 15:39:35 -0400
Message-Id: <1560454780-20359-3-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactors the AP queue reset function to wait until the queue is empty
after the PQAP(ZAPQ) instruction is executed to zero out the queue as
required by the AP architecture.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 49 +++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index bf2ab02b9a0b..60efd3d7896d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1128,23 +1128,46 @@ static void vfio_ap_irq_disable_apqn(int apqn)
 	}
 }
 
-int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
-			     unsigned int retry)
+static void vfio_ap_mdev_wait_for_qempty(ap_qid_t qid)
+{
+	struct ap_queue_status status;
+	int retry = 5;
+
+	do {
+		status = ap_tapq(qid, NULL);
+		switch (status.response_code) {
+		case AP_RESPONSE_NORMAL:
+			if (status.queue_empty)
+				return;
+		case AP_RESPONSE_RESET_IN_PROGRESS:
+		case AP_RESPONSE_BUSY:
+			msleep(20);
+			break;
+		default:
+			pr_warn("%s: tapq response %02x waiting for queue %04x.%02x empty\n",
+				__func__, status.response_code,
+				AP_QID_CARD(qid), AP_QID_QUEUE(qid));
+			return;
+		}
+	} while (--retry);
+
+	WARN_ON_ONCE(retry <= 0);
+}
+
+int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi)
 {
 	struct ap_queue_status status;
-	int retry2 = 2;
 	int apqn = AP_MKQID(apid, apqi);
+	int retry = 5;
 
 	do {
 		status = ap_zapq(apqn);
 		switch (status.response_code) {
 		case AP_RESPONSE_NORMAL:
-			while (!status.queue_empty && retry2--) {
-				msleep(20);
-				status = ap_tapq(apqn, NULL);
-			}
-			WARN_ON_ONCE(retry <= 0);
+			vfio_ap_mdev_wait_for_qempty(AP_MKQID(apid, apqi));
 			return 0;
+		case AP_RESPONSE_DECONFIGURED:
+			return -ENODEV;
 		case AP_RESPONSE_RESET_IN_PROGRESS:
 		case AP_RESPONSE_BUSY:
 			msleep(20);
@@ -1169,14 +1192,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			     matrix_mdev->matrix.apm_max + 1) {
 		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
 				     matrix_mdev->matrix.aqm_max + 1) {
-			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
-			/*
-			 * Regardless whether a queue turns out to be busy, or
-			 * is not operational, we need to continue resetting
-			 * the remaining queues.
-			 */
+			ret = vfio_ap_mdev_reset_queue(apid, apqi);
 			if (ret)
 				rc = ret;
+
 			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
 		}
 	}
@@ -1326,7 +1345,7 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 	dev_set_drvdata(&queue->ap_dev.device, NULL);
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
-	vfio_ap_mdev_reset_queue(apid, apqi, 1);
+	vfio_ap_mdev_reset_queue(apid, apqi);
 	vfio_ap_irq_disable(q);
 	kfree(q);
 }
-- 
2.7.4

