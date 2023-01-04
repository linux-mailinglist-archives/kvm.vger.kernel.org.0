Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A41965D764
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbjADPmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 10:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbjADPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 10:42:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9385E32186;
        Wed,  4 Jan 2023 07:42:10 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304F0EQG029448;
        Wed, 4 Jan 2023 15:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=quDaVa99DaLInrnXMR/h2qSnYFHNuCut6AuCHIYMMiE=;
 b=S9UTVxwK/fZZvvw3zP5Wo6IuDPvBEjbgc+nctP/SqZjEG98g/XMZElIOvjkSe7sDqmam
 fg7FuK44ALuk3iYcviic+VYOtRHOJEb7mG+utNQZW3NtYtDD/JCCn8V2oY/QoaUvSGqY
 DQGZPp/qlZEEVKTmwOGQgOILPu++NL4sq+eBkuo5Y71GKuG9CzCJfC4L9OrXrX4pFVY6
 KnTV0fwATaKFbFHpOtukI2+AnLQbrN3nP5KMi79JwyWwD7k1VZgiB/M7Y2+GurmMEm1u
 /Uq/hIMnKG03s3FPzit45C5NdcPXPiafQ0iUTW66+JtAkR4+CEjVKK8/HhiwB5T/yOZk 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwbqeh4n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 15:42:09 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 304FTsgJ022826;
        Wed, 4 Jan 2023 15:42:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwbqeh4md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 15:42:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 304CX4uO001927;
        Wed, 4 Jan 2023 15:42:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mtcq6dh0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 15:42:06 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 304Fg3hs52298206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 15:42:03 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 673A920049;
        Wed,  4 Jan 2023 15:42:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19D9B20040;
        Wed,  4 Jan 2023 15:42:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  4 Jan 2023 15:42:03 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: [PATCH v2 1/1] vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()
Date:   Wed,  4 Jan 2023 16:42:02 +0100
Message-Id: <20230104154202.1152198-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104154202.1152198-1-schnelle@linux.ibm.com>
References: <20230104154202.1152198-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iu8PGGP6ldxfR2d2VLe6uwFS4htCa8Bc
X-Proofpoint-ORIG-GUID: HtcMWrHcZtob5hqcl4MEQe2xHm38sBu9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301040130
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

Fixes: 6fe1010d6d9c ("vfio/type1: DMA unmap chunking")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
v1 -> v2:
- Reworded commit message to hopefully explain things a bit better and
  highlight that usually just mapping but not issuing DMAs for IOVAs in
  a resverved region is harmless but still breaks things with ISM devices.
- Added a check for PAGE_SIZE * 2 alignment (Jason)

 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..87b27ffb93d0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1856,24 +1856,32 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
+		if (region->end - region->start < PAGE_SIZE * 2 ||
+				region->start % (PAGE_SIZE*2))
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
@@ -2326,7 +2334,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		}
 	}
 
-	vfio_test_domain_fgsp(domain);
+	vfio_test_domain_fgsp(domain, &iova_copy);
 
 	/* replay mappings on new domains */
 	ret = vfio_iommu_replay(iommu, domain);
-- 
2.34.1

