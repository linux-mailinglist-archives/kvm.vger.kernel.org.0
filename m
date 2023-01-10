Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5E5664668
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjAJQos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbjAJQog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:44:36 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C516B5EF;
        Tue, 10 Jan 2023 08:44:35 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AFl9gF036555;
        Tue, 10 Jan 2023 16:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hr8KyA79ZU+vuXyPWHbyJzgZiFjZHCGAIXdAWFyYiDA=;
 b=PXDu+9G0FL2MwcDuFzuOnaXR3hInN5ZZt3FmiK8Uekm18Z34wwmH97PmbcXf325mCYbM
 9fnIp1vEjM2zYhdBiPNB7L8DSxn8EhxwcYh+4im/0DOG697cxvnO43JS43bBgb8r7RnY
 54J9YEGgYUxLQ5gq6BsFKXmhsw0gxTczXTnH/kYBjyA2WFiUDxhaGh3Q6Lc7AW+8tosh
 y/5y1NUvQMbE2LphGp/hU5kvkcluIthXxF10e7yuxo5stnfr5Jx9pPW0oQPIbPtyJ2kU
 UEO0I7KpkF5kVnDBn7F6b3yzPcNhN1jLvAm4sZ3N8d8+MomLr3SavH/JpmndILuwa5IR hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1ay61gqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 16:44:34 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AFmuCP003117;
        Tue, 10 Jan 2023 16:44:33 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1ay61gqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 16:44:33 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30AE4Thj029818;
        Tue, 10 Jan 2023 16:44:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3my00fkraq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 16:44:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30AGiS5W44695992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:44:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E7520049;
        Tue, 10 Jan 2023 16:44:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B81952004D;
        Tue, 10 Jan 2023 16:44:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 16:44:27 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: [PATCH v3 1/1] vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()
Date:   Tue, 10 Jan 2023 17:44:27 +0100
Message-Id: <20230110164427.4051938-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230110164427.4051938-1-schnelle@linux.ibm.com>
References: <20230110164427.4051938-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: otQvjHaeYQ4O8WRmMErDR3uEoSeZjVA-
X-Proofpoint-ORIG-GUID: pcMWbnCo2Hz0BKcnrU_AH0BpZFj3ke0U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
aperture shrinking") the s390 IOMMU driver uses reserved regions for the
system provided DMA ranges of PCI devices. Previously it reduced the
size of the IOMMU aperture and checked it on each mapping operation.
On current machines the system denies use of DMA addresses below 2^32 for
all PCI devices.

Usually mapping IOVAs in a reserved regions is harmless until a DMA
actually tries to utilize the mapping. However on s390 there is
a virtual PCI device called ISM which is implemented in firmware and
used for cross LPAR communication. Unlike real PCI devices this device
does not use the hardware IOMMU but inspects IOMMU translation tables
directly on IOTLB flush (s390 RPCIT instruction). If it detects IOVA
mappings outside the allowed ranges it goes into an error state. This
error state then causes the device to be unavailable to the KVM guest.

Analysing this we found that vfio_test_domain_fgsp() maps 2 pages at DMA
address 0 irrespective of the IOMMUs reserved regions. Even if usually
harmless this seems wrong in the general case so instead go through the
freshly updated IOVA list and try to find a range that isn't reserved,
and fits 2 pages, is PAGE_SIZE * 2 aligned. If found use that for
testing for fine grained super pages.

Fixes: af029169b8fd ("vfio/type1: Check reserved region conflict and update iova list")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
v2 -> v3:
- Don't require region->start to be aligned but instead just that we can fit an
  aligned allocation (Alex)
- Use Fixes tag for the introduction of reserved regions as that came
  after the fine grained super pages test (Alex)
v1 -> v2:
- Reworded commit message to hopefully explain things a bit better and
  highlight that usually just mapping but not issuing DMAs for IOVAs in
  a resverved region is harmless but still breaks things with ISM devices.
- Added a check for PAGE_SIZE * 2 alignment (Jason)

 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..2209372f236d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1856,24 +1856,33 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
  * significantly boosts non-hugetlbfs mappings and doesn't seem to hurt when
  * hugetlbfs is in use.
  */
-static void vfio_test_domain_fgsp(struct vfio_domain *domain)
+static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *regions)
 {
-	struct page *pages;
 	int ret, order = get_order(PAGE_SIZE * 2);
+	struct vfio_iova *region;
+	struct page *pages;
+	dma_addr_t start;
 
 	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!pages)
 		return;
 
-	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
-	if (!ret) {
-		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
+	list_for_each_entry(region, regions, list) {
+		start = ALIGN(region->start, PAGE_SIZE * 2);
+		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
+			continue;
 
-		if (unmapped == PAGE_SIZE)
-			iommu_unmap(domain->domain, PAGE_SIZE, PAGE_SIZE);
-		else
-			domain->fgsp = true;
+		ret = iommu_map(domain->domain, start, page_to_phys(pages), PAGE_SIZE * 2,
+				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
+		if (!ret) {
+			size_t unmapped = iommu_unmap(domain->domain, start, PAGE_SIZE);
+
+			if (unmapped == PAGE_SIZE)
+				iommu_unmap(domain->domain, start + PAGE_SIZE, PAGE_SIZE);
+			else
+				domain->fgsp = true;
+		}
+		break;
 	}
 
 	__free_pages(pages, order);
@@ -2326,7 +2335,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		}
 	}
 
-	vfio_test_domain_fgsp(domain);
+	vfio_test_domain_fgsp(domain, &iova_copy);
 
 	/* replay mappings on new domains */
 	ret = vfio_iommu_replay(iommu, domain);
-- 
2.34.1

