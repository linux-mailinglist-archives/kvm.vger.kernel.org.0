Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82852DCCB
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 20:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbiESS3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 14:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243896AbiESS3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 14:29:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92213EC31A;
        Thu, 19 May 2022 11:29:46 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JHnMi6011493;
        Thu, 19 May 2022 18:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=xrNctW9hVKbrU4W6AMqU2wLjNusMYTB/FYWs1L1y5aQ=;
 b=jcmKmAuWXdoMkK8OykiBQWPVLx8rf31qjOnBo+YuWvZaKZFn6h6zCiW49Ftu+O9sqd0K
 88Z5/Fz+yzzC5rjdgHa86D6KZ5I5ZS6umEM4ojtpRIipIjom6bPSHskQ8vWWA6Y4aOiW
 6TUx7GL5h/G9c0sVX2Vptc40cZLECagSeAXDHFxHUVef5+eL7HxQ1CVqrEh5iEpqi8oS
 QCnOA5Qg1wpMIPEJd1nIBJMykJCFtfeTBbRDYRguEj3rP+L4hpqw/UEF/hvrBGXKyk/t
 XfHVRu7IUXYYnsaBgcMTzhDzXOp0yCroW8Y+A+J0p6YN4NRLxvDg1YMi8wSjLTME1h0+ WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5tmkrtff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 18:29:38 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24JHq8FO020578;
        Thu, 19 May 2022 18:29:37 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5tmkrtf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 18:29:37 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24JISpgC008710;
        Thu, 19 May 2022 18:29:37 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 3g242a5k8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 18:29:37 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24JITaFW23134634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 18:29:36 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8FF4136059;
        Thu, 19 May 2022 18:29:35 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A007B136051;
        Thu, 19 May 2022 18:29:34 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.37.97])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 May 2022 18:29:34 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     jgg@nvidia.com, joro@8bytes.org
Cc:     will@kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, schnelle@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, farman@linux.ibm.com,
        iommu@lists.linux-foundation.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/s390: tolerate repeat attach_dev calls
Date:   Thu, 19 May 2022 14:29:29 -0400
Message-Id: <20220519182929.581898-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t1RilyYolHsJLOPLBzO2pxdNqh7SgUYc
X-Proofpoint-ORIG-GUID: gjzwgNJ_9iqSM-ohudG6p3A8_pmMDcsd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_05,2022-05-19_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 bulkscore=0 clxscore=1011
 mlxlogscore=999 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 0286300e6045 ("iommu: iommu_group_claim_dma_owner() must
always assign a domain") s390-iommu will get called to allocate multiple
unmanaged iommu domains for a vfio-pci device -- however the current
s390-iommu logic tolerates only one.  Recognize that multiple domains can
be allocated and handle switching between DMA or different iommu domain
tables during attach_dev.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/iommu/s390-iommu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 3833e86c6e7b..c898bcbbce11 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -99,7 +99,7 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	if (!domain_device)
 		return -ENOMEM;
 
-	if (zdev->dma_table) {
+	if (zdev->dma_table && !zdev->s390_domain) {
 		cc = zpci_dma_exit_device(zdev);
 		if (cc) {
 			rc = -EIO;
@@ -107,6 +107,9 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 		}
 	}
 
+	if (zdev->s390_domain)
+		zpci_unregister_ioat(zdev, 0);
+
 	zdev->dma_table = s390_domain->dma_table;
 	cc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
 				virt_to_phys(zdev->dma_table));
@@ -136,7 +139,13 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	return 0;
 
 out_restore:
-	zpci_dma_init_device(zdev);
+	if (!zdev->s390_domain) {
+		zpci_dma_init_device(zdev);
+	} else {
+		zdev->dma_table = zdev->s390_domain->dma_table;
+		zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
+				   virt_to_phys(zdev->dma_table));
+	}
 out_free:
 	kfree(domain_device);
 
@@ -167,7 +176,7 @@ static void s390_iommu_detach_device(struct iommu_domain *domain,
 	}
 	spin_unlock_irqrestore(&s390_domain->list_lock, flags);
 
-	if (found) {
+	if (found && (zdev->s390_domain == s390_domain)) {
 		zdev->s390_domain = NULL;
 		zpci_unregister_ioat(zdev, 0);
 		zpci_dma_init_device(zdev);
-- 
2.27.0

