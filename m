Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7597089C5
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjERUrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjERUrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:47:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13ACEE
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:47:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIxAv7015429;
        Thu, 18 May 2023 20:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Hs/FL0pNDu6fa17nEH3p23V6JtyjGWxlEHZV3Uz4db4=;
 b=uNyRKD9PnPQ6HpOvxUMSVqaTpiYTmjcXl8jqWJq3Yec+p3n3wuGZU49BmW/cW421PYaR
 OY1o4KumwMiReyjG43d5okYhTP/Qn6TzId8//It5i61KgDTXC4BitlyF8PhyHysV7NCG
 OeZ/0dtxnytYXTeNB6vcCwK7g4QGtnWLxrGyiB3yqV2KRjRJOxNhvz+KFu79yLx7pgp5
 oHA4BYytW7bvvBAdZifB6vKZ2M5193CmUzI+LP89QjUXGHqrZCXbm18HBmun2zNfQMGY
 2TXY5MHFzZJVlQedSxmoWTu3KMvOYkvq9lPfTK0EGj2pEelpQFxCBzSfPLtOSSiYHMo9 ug== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j3n3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJISCN032224;
        Thu, 18 May 2023 20:47:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dae96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE2p033533;
        Thu, 18 May 2023 20:47:23 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-3;
        Thu, 18 May 2023 20:47:22 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH RFCv2 02/24] iommu: Replace put_pages_list() with iommu_free_pgtbl_pages()
Date:   Thu, 18 May 2023 21:46:28 +0100
Message-Id: <20230518204650.14541-3-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-1-joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180170
X-Proofpoint-GUID: _DS4keRxAQIrfPtqBNEIZsJ7yZroPJ7f
X-Proofpoint-ORIG-GUID: _DS4keRxAQIrfPtqBNEIZsJ7yZroPJ7f
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

Therefore, RCU protected page free will take effect if necessary.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/amd/io_pgtable.c | 5 ++---
 drivers/iommu/dma-iommu.c      | 6 ++++--
 drivers/iommu/intel/iommu.c    | 4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 1b67116882be..666b643106f8 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -430,7 +430,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 	}
 
 	/* Everything flushed out, free pages now */
-	put_pages_list(&freelist);
+	iommu_free_pgtbl_pages(&dom->domain, &freelist);
 
 	return ret;
 }
@@ -511,8 +511,7 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 
 	/* Make changes visible to IOMMUs */
 	amd_iommu_domain_update(dom);
-
-	put_pages_list(&freelist);
+	iommu_free_pgtbl_pages(&dom->domain, &freelist);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7a9f0b0bddbd..33925b9249b3 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -136,7 +136,8 @@ static void fq_ring_free(struct iommu_dma_cookie *cookie, struct iova_fq *fq)
 		if (fq->entries[idx].counter >= counter)
 			break;
 
-		put_pages_list(&fq->entries[idx].freelist);
+		iommu_free_pgtbl_pages(cookie->fq_domain,
+				       &fq->entries[idx].freelist);
 		free_iova_fast(&cookie->iovad,
 			       fq->entries[idx].iova_pfn,
 			       fq->entries[idx].pages);
@@ -232,7 +233,8 @@ static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
 		struct iova_fq *fq = per_cpu_ptr(cookie->fq, cpu);
 
 		fq_ring_for_each(idx, fq)
-			put_pages_list(&fq->entries[idx].freelist);
+			iommu_free_pgtbl_pages(cookie->fq_domain,
+					       &fq->entries[idx].freelist);
 	}
 
 	free_percpu(cookie->fq);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b871a6afd803..4662292d60ba 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1827,7 +1827,7 @@ static void domain_exit(struct dmar_domain *domain)
 		LIST_HEAD(freelist);
 
 		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
-		put_pages_list(&freelist);
+		iommu_free_pgtbl_pages(&domain->domain, &freelist);
 	}
 
 	if (WARN_ON(!list_empty(&domain->devices)))
@@ -4286,7 +4286,7 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 				      start_pfn, nrpages,
 				      list_empty(&gather->freelist), 0);
 
-	put_pages_list(&gather->freelist);
+	iommu_free_pgtbl_pages(domain, &gather->freelist);
 }
 
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
-- 
2.17.2

