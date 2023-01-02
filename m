Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC41065AEB5
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 10:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjABJfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 04:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjABJfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 04:35:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C903E2DEA;
        Mon,  2 Jan 2023 01:34:59 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3027vqTB023461;
        Mon, 2 Jan 2023 09:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0sH2OClJMuiQ+Q3697XUzelUOPV7noQzi+3Z+aWXozA=;
 b=hc17bzfSEH/73n9N3pG/VH0OwnOOa7SecEKz6rPhcjSgM43QBJ+U2KqB6RDy1bNRw5Qq
 EJXl/qKrvpoMJFs6OsukytDOTPECyyKlsgHUd4F1J3/Bn8xJymonzsw+oIam+6Cd8w7b
 V5aM+hW0F9CIcVMC+/8vRhG72Ielq2aTbf2UQhUdzfu1NGxEK5XsDqOh/AR9v8pPXTGj
 a/jtpMQMR3UGcMyzkl4dWEUro1qgG5IXdhWEynJ6jOb+ITTbEFJOoDWyUMSpRW4wpb8a
 YJNiy8olmb61rL6p8T0UdTHGboxVka17vdglL4u0m2GCbyDuK0BJDNBxXYQDZtvbqK/4 Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mtxrk5k5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 09:34:58 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30290OSK006031;
        Mon, 2 Jan 2023 09:34:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mtxrk5k4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 09:34:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 301LdM9m010837;
        Mon, 2 Jan 2023 09:34:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3mtcq6hmjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Jan 2023 09:34:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3029YqQ846530832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Jan 2023 09:34:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA3F320040;
        Mon,  2 Jan 2023 09:34:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 956CF2004D;
        Mon,  2 Jan 2023 09:34:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  2 Jan 2023 09:34:52 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: [PATCH 1/1] vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()
Date:   Mon,  2 Jan 2023 10:34:52 +0100
Message-Id: <20230102093452.761185-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230102093452.761185-1-schnelle@linux.ibm.com>
References: <20230102093452.761185-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 07p5n3680Fn2fYulR3YsSrKIJk7VNA_1
X-Proofpoint-ORIG-GUID: 3CS8UoRij973fcADqOuihuhWfA0a1F9j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-02_05,2022-12-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301020086
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

