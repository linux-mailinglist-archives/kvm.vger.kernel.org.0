Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C725E92CF
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 23:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfJ2WJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 18:09:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbfJ2WJO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Oct 2019 18:09:14 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9TM37IZ068340;
        Tue, 29 Oct 2019 18:09:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vxwnegg0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 18:09:13 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9TM7n0b108292;
        Tue, 29 Oct 2019 18:09:12 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vxwnegg08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 18:09:12 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9TM8YAE009965;
        Tue, 29 Oct 2019 22:09:11 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 2vxwh5r5vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Oct 2019 22:09:11 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9TM99SQ33620394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 22:09:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6CBEAE48A;
        Tue, 29 Oct 2019 22:09:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6334EAE487;
        Tue, 29 Oct 2019 22:09:09 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.endicott.ibm.com (unknown [9.60.75.238])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 29 Oct 2019 22:09:09 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, freude@linux.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, aekrowia <akrowiak@linux.ibm.com>
Subject: [PATCH] s390: vfio-ap: disable IRQ in remove callback results in kernel OOPS
Date:   Tue, 29 Oct 2019 18:09:06 -0400
Message-Id: <1572386946-22566-1-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-29_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910290190
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: aekrowia <akrowiak@linux.ibm.com>

When an AP adapter card is configured off via the SE or the SCLP
Deconfigure Adjunct Processor command and the AP bus subsequently detects
that the adapter card is no longer in the AP configuration, the card
device representing the adapter card as well as each of its associated
AP queue devices will be removed by the AP bus. If one or more of the
affected queue devices is bound to the VFIO AP device driver, its remove
callback will be invoked for each queue to be removed. The remove callback
resets the queue and disables IRQ processing. If interrupt processing was
never enabled for the queue, disabling IRQ processing will fail resulting
in a kernel OOPS.

This patch verifies IRQ processing is enabled before attempting to disable
interrupts for the queue.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: aekrowia <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index be2520cc010b..42d8308fd3a1 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -79,7 +79,8 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
 	vfio_ap_mdev_reset_queue(apid, apqi, 1);
-	vfio_ap_irq_disable(q);
+	if (q->saved_isc != VFIO_AP_ISC_INVALID)
+		vfio_ap_irq_disable(q);
 	kfree(q);
 	mutex_unlock(&matrix_dev->lock);
 }
-- 
2.7.4

