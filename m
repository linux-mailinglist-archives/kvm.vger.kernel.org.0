Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177D765410A
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 13:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiLVMdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 07:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbiLVMdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 07:33:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1694F25EB9;
        Thu, 22 Dec 2022 04:32:50 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BMCFHvE025679;
        Thu, 22 Dec 2022 12:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2Ud7qlUcdnoe8KhA2+Hd9TL+vFSLoW/2hQIjB8zlhco=;
 b=DIxAS70DDeNC2o9rYvyGkVlIbe9AP60vixNvQlykBJsDbbp4X6KBa2w+ABgq/jPWswgL
 dy6N8XGuOufxZQjJPx0eLabyHu9VAN1KkKAoYMjok/EXt+GyQ3eLXISzO2vTgKP5zXVW
 2HIvnK62RWsKRn9upUSqQc/RAAreCIn3R/kdK1zNM3JCyS6/a26Ray8G5lStu1qa5LlI
 mHyQDtRl5GANY98N7FRTbIQGBeaG1wDV+2fKwXhhdCfSRLcJQFlF81Jy7wj53iZU0IOO
 cLUQPl6tdolOt8rsHQR5TD61Xibn/u0YJsHqHI3QHzgsUYY3z8o8RmufAu2dbG51an1b VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mmq2t8cs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 12:32:49 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BMCLtvB019064;
        Thu, 22 Dec 2022 12:32:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mmq2t8cq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 12:32:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM2j3jR027376;
        Thu, 22 Dec 2022 12:32:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mh6ywq268-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 12:32:46 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BMCWhKq52429198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 12:32:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB50720040;
        Thu, 22 Dec 2022 12:32:42 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2E6F20049;
        Thu, 22 Dec 2022 12:32:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Dec 2022 12:32:42 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()
Date:   Thu, 22 Dec 2022 13:32:42 +0100
Message-Id: <20221222123242.1598848-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GxQMyUlwK-kb4nWNrV1hL-BuInFrstTt
X-Proofpoint-ORIG-GUID: X-Vh0qEZCrKQc7pK-0xInN1iuH8WTD8z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_06,2022-12-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=961 clxscore=1011 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212220100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
aperture shrinking") the s390 IOMMU driver uses a reserved region
instead of an artificially shrunk aperture to restrict IOMMU use based
on the system provided DMA ranges of devices. In particular on current
machines this prevents use of DMA addresses below 2^32 for all devices.
While usually just IOMMU mapping below these addresses is
harmless. However our virtual ISM PCI device looks at new mappings on
IOTLB flush and immediately goes into the error state if such a mapping
violates its allowed DMA ranges. This then breaks pass-through of the
ISM device to a KVM guest.

Analysing this we found that vfio_test_domain_fgsp() maps 2 pages at DMA
address 0 irrespective of the IOMMUs reserved regions. Even if usually
harmless this seems wrong in the general case so instead go through the
freshly updated IOVA list and try to find a range that isn't reserved
and fits 2 pages and use that for testing for fine grained super pages.

Fixes: 6fe1010d6d9c ("vfio/type1: DMA unmap chunking")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
- Testing: I tested this based on current master on both on s390 where it skips
  the reserved 0x0-0x100000000 range and on AMD Vi where it continues to do the
  test on DMA address 0 and sets domain->fgsp to true.

 drivers/vfio/vfio_iommu_type1.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..9395097897b8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1856,24 +1856,31 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
 
 	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!pages)
 		return;
 
-	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
-	if (!ret) {
-		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
+	list_for_each_entry(region, regions, list) {
+		if (region->end - region->start < PAGE_SIZE * 2)
+			continue;
 
-		if (unmapped == PAGE_SIZE)
-			iommu_unmap(domain->domain, PAGE_SIZE, PAGE_SIZE);
-		else
-			domain->fgsp = true;
+		ret = iommu_map(domain->domain, region->start, page_to_phys(pages), PAGE_SIZE * 2,
+				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
+		if (!ret) {
+			size_t unmapped = iommu_unmap(domain->domain, region->start, PAGE_SIZE);
+
+			if (unmapped == PAGE_SIZE)
+				iommu_unmap(domain->domain, region->start + PAGE_SIZE, PAGE_SIZE);
+			else
+				domain->fgsp = true;
+		}
+		break;
 	}
 
 	__free_pages(pages, order);
@@ -2326,7 +2333,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		}
 	}
 
-	vfio_test_domain_fgsp(domain);
+	vfio_test_domain_fgsp(domain, &iova_copy);
 
 	/* replay mappings on new domains */
 	ret = vfio_iommu_replay(iommu, domain);
-- 
2.34.1

