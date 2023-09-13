Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726C779E89B
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240730AbjIMNHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 09:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240711AbjIMNHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 09:07:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2099019B6;
        Wed, 13 Sep 2023 06:07:06 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DCRWOI016469;
        Wed, 13 Sep 2023 13:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=U6m79bn53R80K62WnFpoCyhwSnR4yQVNhqrLWqqZQwk=;
 b=e96pzpA0D/LpdPvP69j0Grf4IDP3ysXoivr94YT+362omeS1wFuGjf/Ygv8J3vMJZJDK
 gq3B5JdYyEeczlYhKJ8RsOevvLti1KP+pC7eLYIhU43sH6iVnmW/PVsUHaD8gOllypV/
 BeBs/few4NGfsG9adVArhNt8Kymb6Pcb9qtem5p37UBRyzxSfyPY8UbmrJWbE7I7kBqp
 qqinfGg9xfR96FMqsT6O3gwtdnfH+/ikzBir9e3QjrnEduv02L94fofnKkns8J8ZOE5Z
 wpc85/02p7U9YuCrk/mjBR2oq1uIoaz6l0qW3bELb+UooHJGpx/fYhM87L/7GkrHfBnr Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3d3qs6cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:07:03 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38DCc9Gh002970;
        Wed, 13 Sep 2023 13:06:44 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3d3qs627-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:06:44 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DC14AA024021;
        Wed, 13 Sep 2023 13:06:30 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t131tbka0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:06:30 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DD6UOf2032354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 13:06:30 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3925D58059;
        Wed, 13 Sep 2023 13:06:30 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B58758058;
        Wed, 13 Sep 2023 13:06:29 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.101.13])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 13:06:29 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Anthony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH 2/2] s390/vfio-ap: set status response code to 06 on gisc registration failure
Date:   Wed, 13 Sep 2023 09:06:22 -0400
Message-ID: <20230913130626.217665-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913130626.217665-1-akrowiak@linux.ibm.com>
References: <20230913130626.217665-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lU2LQRYLG9tuGBlkzrvvtPDdHVoJbi4C
X-Proofpoint-ORIG-GUID: q5sFbLFVHWMbtwh9T3ABJjGAKtNL1md0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_06,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2308100000 definitions=main-2309130101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Anthony Krowiak <akrowiak@linux.ibm.com>

The interception handler for the PQAP(AQIC) command calls the
kvm_s390_gisc_register function to register the guest ISC with the channel
subsystem. If that call fails, the status response code 08 - indicating
Invalid ZONE/GISA designation - is returned to the guest. This response
code does not make sense because the non-zero return code from the
kvm_s390_gisc_register function can be due one of two things: Either the
ISC passed as a parameter by the guest to the PQAP(AQIC) command is greater
than the maximum ISC value allowed, or the guest is not using a GISA.

Since this scenario is very unlikely to happen and there is no status
response code to indicate an invalid ISC value, let's set the
response code to 06 indicating 'Invalid address of AP-queue notification
byte'. While this is not entirely accurate, it is better than indicating
that the ZONE/GISA designation is invalid which is something the guest
can do nothing about since those values are set by the hypervisor.

Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9cb28978c186..e7e4dbbf5ad3 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -394,7 +394,7 @@ static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
  * host ISC to issue the host side PQAP/AQIC
  *
  * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case the
- * vfio_pin_pages failed.
+ * vfio_pin_pages or kvm_s390_gisc_register failed.
  *
  * Otherwise return the ap_queue_status returned by the ap_aqic(),
  * all retry handling will be done by the guest.
@@ -458,7 +458,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 				 __func__, nisc, isc, q->apqn);
 
 		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
-		status.response_code = AP_RESPONSE_INVALID_GISA;
+		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
 		return status;
 	}
 
-- 
2.41.0

