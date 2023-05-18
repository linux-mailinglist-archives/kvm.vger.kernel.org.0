Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E21E7089C4
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjERUrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjERUrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:47:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F78F7
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:47:45 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx6iJ025284;
        Thu, 18 May 2023 20:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=lmBX3d6EEqid/HWfvIQqyMVUgRO0Wer5JoCL94qDets=;
 b=qA27Ed6TF7M4KQu1JB/enySS1cHu83hGHvO469u8Em4h0xp5F5DwbMaN4ETx0B+hWF0d
 uwWobPyMGVd4GNEM3DdLwhb/TKnrx6t8Y9Ft8yfOUJgHCBLDPxaQkYXv7oEtBQP29g34
 LouvDc2fZcBCz8SoEH+NJNZx9XxdvIOIVo0TCfkwZ2sbXBSTipnprj6ozTdK2NjZHHuo
 ZDtoqDiOkzibnQRd1qoKl9915Dit3fo3Ey10dOMeRdRY2XTV3nsACmzE48sUcdRWW3XY
 RQ208itkEi6pJ/lAwBtqRaiKpTrGFJtboQnJtrmyCpdwWwpE6fZLALPVFtZlyXzpXMZ+ Zw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fc97c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJ3Pn5032141;
        Thu, 18 May 2023 20:47:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dae7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:19 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE2n033533;
        Thu, 18 May 2023 20:47:18 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-2;
        Thu, 18 May 2023 20:47:18 +0000
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
Subject: [PATCH RFCv2 01/24] iommu: Add RCU-protected page free support
Date:   Thu, 18 May 2023 21:46:27 +0100
Message-Id: <20230518204650.14541-2-joao.m.martins@oracle.com>
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
X-Proofpoint-ORIG-GUID: dDDr2URMhFRURT5eRyrAX1r_Ov3r1IFZ
X-Proofpoint-GUID: dDDr2URMhFRURT5eRyrAX1r_Ov3r1IFZ
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

The IOMMU page tables are updated using iommu_map/unmap() interfaces.
Currently, there is no mandatory requirement for drivers to use locks
to ensure concurrent updates to page tables, because it's assumed that
overlapping IOVA ranges do not have concurrent updates. Therefore the
IOMMU drivers only need to take care of concurrent updates to level
page table entries.

But enabling new features challenges this assumption. For example, the
hardware assisted dirty page tracking feature requires scanning page
tables in interfaces other than mapping and unmapping. This might result
in a use-after-free scenario in which a level page table has been freed
by the unmap() interface, while another thread is scanning the next level
page table.

This adds RCU-protected page free support so that the pages are really
freed and reused after a RCU grace period. Hence, the page tables are
safe for scanning within a rcu_read_lock critical region. Considering
that scanning the page table is a rare case, this also adds a domain
flag and the RCU-protected page free is only used when this flat is set.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 23 +++++++++++++++++++++++
 include/linux/iommu.h | 10 ++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 91573efd9488..2088caae5074 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3432,3 +3432,26 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 
 	return domain;
 }
+
+static void pgtble_page_free_rcu(struct rcu_head *rcu)
+{
+	struct page *page = container_of(rcu, struct page, rcu_head);
+
+	__free_pages(page, 0);
+}
+
+void iommu_free_pgtbl_pages(struct iommu_domain *domain,
+			    struct list_head *pages)
+{
+	struct page *page, *next;
+
+	if (!domain->concurrent_traversal) {
+		put_pages_list(pages);
+		return;
+	}
+
+	list_for_each_entry_safe(page, next, pages, lru) {
+		list_del(&page->lru);
+		call_rcu(&page->rcu_head, pgtble_page_free_rcu);
+	}
+}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e8c9a7da1060..39d25645a5ab 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -110,6 +110,7 @@ struct iommu_domain {
 			int users;
 		};
 	};
+	unsigned long concurrent_traversal:1;
 };
 
 static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
@@ -697,6 +698,12 @@ static inline void dev_iommu_priv_set(struct device *dev, void *priv)
 	dev->iommu->priv = priv;
 }
 
+static inline void domain_set_concurrent_traversal(struct iommu_domain *domain,
+						   bool value)
+{
+	domain->concurrent_traversal = value;
+}
+
 int iommu_probe_device(struct device *dev);
 
 int iommu_dev_enable_feature(struct device *dev, enum iommu_dev_features f);
@@ -721,6 +728,9 @@ void iommu_detach_device_pasid(struct iommu_domain *domain,
 struct iommu_domain *
 iommu_get_domain_for_dev_pasid(struct device *dev, ioasid_t pasid,
 			       unsigned int type);
+
+void iommu_free_pgtbl_pages(struct iommu_domain *domain,
+			    struct list_head *pages);
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
-- 
2.17.2

