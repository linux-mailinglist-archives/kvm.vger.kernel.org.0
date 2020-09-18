Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2BF2702C6
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 19:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRRCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 13:02:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbgIRRCn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 13:02:43 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IGh6us040991;
        Fri, 18 Sep 2020 13:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=uJlQTyDJq/ZC9OYXSXamF5qHhTszIWLOwi4hkKQ8vJM=;
 b=aCdzapvwlWhTvcl/+zR0l4Pkh92kk2d7ENFlMAGpVhTpf3GbJEZyEJDWgD0o90TsdE9m
 if9/5LWP20bGC6dlecfDztYeKyaMsVc2a5FMdN/gqZrdFlsoi8luUZ1Ia6fRy5PCLkPB
 fVrLq9xRmq1pKRY5ITOPSf6OS4AW1FYY0INsBBSS0S8t6LUjUpY/2Bum2qzJ2A2snqa2
 xE7Y3Qq/uVrGsby1e4hS8H6bRCZgd/wmH2fiFGb2RF1UkRcNoffKTE0EG/Eb6ne4imDv
 AkidunNzmT8iD11ZsVXa8KBaxp7pKG8o45PwvnB8hS3zyzoQ60n13w7/nMDUOvrS5knL 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33n0nm0gj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 13:02:42 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08IGhkek041725;
        Fri, 18 Sep 2020 13:02:42 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33n0nm0ghu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 13:02:42 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08IGvUjU018423;
        Fri, 18 Sep 2020 17:02:41 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 33k5wcwre0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 17:02:41 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08IH2eJs61669728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 17:02:40 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B793C6055;
        Fri, 18 Sep 2020 17:02:40 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E81D3C6059;
        Fri, 18 Sep 2020 17:02:38 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.128.188])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 17:02:38 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kwankhede@nvidia.com, borntraeger@de.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already gone results in OOPS
Date:   Fri, 18 Sep 2020 13:02:34 -0400
Message-Id: <20200918170234.5807-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_15:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=2
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Attempting to unregister Guest Interruption Subclass (GISC) when the
link between the matrix mdev and KVM has been removed results in the
following:

   "Kernel panic -not syncing: Fatal exception: panic_on_oops"

This patch fixes this bug by verifying the matrix mdev and KVM are still
linked prior to unregistering the GISC.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e0bde8518745..847a88642644 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -119,11 +119,15 @@ static void vfio_ap_wait_for_irqclear(int apqn)
  */
 static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
 {
-	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)
-		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
-	if (q->saved_pfn && q->matrix_mdev)
-		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
-				 &q->saved_pfn, 1);
+	if (q->matrix_mdev) {
+		if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev->kvm)
+			kvm_s390_gisc_unregister(q->matrix_mdev->kvm,
+						 q->saved_isc);
+		if (q->saved_pfn)
+			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
+					 &q->saved_pfn, 1);
+	}
+
 	q->saved_pfn = 0;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 }
-- 
2.21.1

