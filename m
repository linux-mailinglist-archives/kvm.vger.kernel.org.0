Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DEA7D8852
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 20:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjJZSdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 14:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjJZSc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 14:32:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E8D1BE;
        Thu, 26 Oct 2023 11:32:57 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QIFQKP015661;
        Thu, 26 Oct 2023 18:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=X8kIrslWDOXWhoHJov+e3SPTeZxOhaqsDjB2N84baz0=;
 b=Ix0rOd7H4tJ0ZdJAOOuwTKKHYFnGP/qcHUG1mvoIGcRhsiPNgc91WEca7k6bTB3qSW8p
 UdgtuOvTWbGM10sm7ricY43N0R9hUp2xVlb7VfC3v45NbzyxEygq0yWteA0CiEeHf9zx
 1yx2hwtpgJMATJQqKbcerlRb8l/Ae9g3VkFZeMY2i8O8fPaFNH09RLNRRmr06O9poiYy
 V6rHSEEGAxJwg6zQ+3KGe0SLs+zr0PkjnnDCgmX5xK/DrX1dGW7BkaJiwNgU4KBga/bC
 TARKeBYRtfpp3hruhc1I1g1m6xSNmffGfHhOA/Rnx+S4cXG2rRcGvHbKYrzCga1ZRkxv Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyw7m0f1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:32:56 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39QIFMuk015541;
        Thu, 26 Oct 2023 18:32:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyw7m0f13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:32:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QGBP2n012349;
        Thu, 26 Oct 2023 18:32:55 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvup27kj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:32:55 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QIWsYu13894290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 18:32:54 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E30D58056;
        Thu, 26 Oct 2023 18:32:54 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8DAC58069;
        Thu, 26 Oct 2023 18:32:53 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.161.121])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Oct 2023 18:32:53 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        Anthony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v3 2/3] s390/vfio-ap: set status response code to 06 on gisc registration failure
Date:   Thu, 26 Oct 2023 14:32:44 -0400
Message-ID: <20231026183250.254432-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231026183250.254432-1-akrowiak@linux.ibm.com>
References: <20231026183250.254432-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FkXHtCBuRdeQsOfG9hp5LjZDNcL2H5w8
X-Proofpoint-GUID: pUlLq3ALkDV2hTItK4KMHKfbdQDwlZbt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_16,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310170001 definitions=main-2310260158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 drivers/s390/crypto/vfio_ap_ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9cb28978c186..25d7ce2094f8 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -393,8 +393,8 @@ static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
  * Register the guest ISC to GIB interface and retrieve the
  * host ISC to issue the host side PQAP/AQIC
  *
- * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case the
- * vfio_pin_pages failed.
+ * status.response_code may be set to AP_RESPONSE_INVALID_ADDRESS in case the
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

