Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA337089D9
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjERUtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjERUty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:49:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A5A173F
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:49:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx9kD015384;
        Thu, 18 May 2023 20:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=8dUdIZkk4mF1VFVAvcQyDH3mky5o3NyzbdKt58jwQPE=;
 b=G1AJwzMntb50af6hyzrfXVmuB/xeNfYb1rvfAKMSf+Kx5nquQDVXfKCga0ZLycKsN3PD
 /pC+ABaT7vfqmi/3Oleb4CInVueMiFsEbSC2/8W6sute7ZTJNvS/vBubIc/w+aaPaA9C
 YNQNAgjdvDIZZV8fya/dFPLO2WpX8i0bZzUZaA3lRJPuwBKcS7dbpCv55x3lxx+en9Eg
 fIniGY+Szu1wVJ9Z6SAlw1pR8rR1WfO+JRVIidisi29KmrXmnsOcRnAEQ1pf+iaAODkP
 0iPYdMZLtFHqHvvdreO1Kt7Ah2Q7byXNHGf+59WxI+IU7W2MZmoQh9rUa1l+JEUAEFJ1 3A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j3n69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:49:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJBdG1032190;
        Thu, 18 May 2023 20:49:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dafme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:49:01 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE3P033533;
        Thu, 18 May 2023 20:49:01 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-20;
        Thu, 18 May 2023 20:49:01 +0000
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
Subject: [PATCH RFCv2 19/24] iommu/intel: Access/Dirty bit support for SL domains
Date:   Thu, 18 May 2023 21:46:45 +0100
Message-Id: <20230518204650.14541-20-joao.m.martins@oracle.com>
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
 engine=8.12.0-2304280000 definitions=main-2305180171
X-Proofpoint-GUID: D0VI0rHUKneO4gbYsi5H0D4GtHTHxkbJ
X-Proofpoint-ORIG-GUID: D0VI0rHUKneO4gbYsi5H0D4GtHTHxkbJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU advertises Access/Dirty bits for second-stage page table if the
extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
The first stage table is compatible with CPU page table thus A/D bits are
implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
"3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
"3.7.2 Accessed and Dirty Flags".

First stage page table is enabled by default so it's allowed to set dirty
tracking and no control bits needed, we just return 0. To use SSADS, we set
bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
via pasid_flush_caches(). Relevant SDM refs:

"3.7.2 Accessed and Dirty Flags"
"6.5.3.3 Guidance to Software for Invalidations,
 Table 23. Guidance to Software for Invalidations"

PTE dirty bit is located in bit 9 and it's cached in the IOTLB so
we also need to flush IOTLB to make sure IOMMU attempts to set the
dirty bit again. Note that iommu_dirty_bitmap_record() will add the
IOVA to iotlb_gather and thus the caller of the iommu op will flush the
IOTLB. Relevant manuals over the hardware translation is
chapter 6 with some special mention to:

"6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
"6.2.4 IOTLB"

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
The IOPTE walker is still inneficient, but v3 will change that. Mainly
purpose here would be to make sure the UAPI/IOMMUFD is solid and agreed upon.
---
 drivers/iommu/intel/iommu.c |  88 ++++++++++++++++++++++++++++++
 drivers/iommu/intel/iommu.h |  15 ++++++
 drivers/iommu/intel/pasid.c | 103 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel/pasid.h |   4 ++
 4 files changed, 210 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 4662292d60ba..6cf9cbe4c299 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4112,6 +4112,10 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 	if (!iommu)
 		return -ENODEV;
 
+	if (domain->flags & IOMMU_DOMAIN_F_ENFORCE_DIRTY &&
+	    !ecap_slads(iommu->ecap))
+		return -EINVAL;
+
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
 		return -EINVAL;
 
@@ -4374,6 +4378,9 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
 		return dmar_platform_optin();
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return ecap_sc_support(info->iommu->ecap);
+	case IOMMU_CAP_DIRTY:
+		return sm_supported(info->iommu) &&
+			ecap_slads(info->iommu->ecap);
 	default:
 		return false;
 	}
@@ -4739,6 +4746,84 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
 }
 
+static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
+					  bool enable)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct device_domain_info *info;
+	int ret = -EINVAL;
+
+	spin_lock(&dmar_domain->lock);
+	if (!(dmar_domain->dirty_tracking ^ enable) ||
+	    list_empty(&dmar_domain->devices)) {
+		spin_unlock(&dmar_domain->lock);
+		return 0;
+	}
+
+	list_for_each_entry(info, &dmar_domain->devices, link) {
+		/* First-level page table always enables dirty bit*/
+		if (dmar_domain->use_first_level) {
+			ret = 0;
+			break;
+		}
+
+		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
+						     info->dev, PASID_RID2PASID,
+						     enable);
+		if (ret)
+			break;
+
+	}
+
+	if (!ret)
+		dmar_domain->dirty_tracking = enable;
+	spin_unlock(&dmar_domain->lock);
+
+	return ret;
+}
+
+static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
+					    unsigned long iova, size_t size,
+					    unsigned long flags,
+					    struct iommu_dirty_bitmap *dirty)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	unsigned long end = iova + size - 1;
+	unsigned long pgsize;
+	bool ad_enabled;
+
+	spin_lock(&dmar_domain->lock);
+	ad_enabled = dmar_domain->dirty_tracking;
+	spin_unlock(&dmar_domain->lock);
+
+	if (!ad_enabled && dirty->bitmap)
+		return -EINVAL;
+
+	rcu_read_lock();
+	do {
+		struct dma_pte *pte;
+		int lvl = 0;
+
+		pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
+				     GFP_ATOMIC);
+		pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
+		if (!pte || !dma_pte_present(pte)) {
+			iova += pgsize;
+			continue;
+		}
+
+		/* It is writable, set the bitmap */
+		if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
+				dma_sl_pte_dirty(pte)) ||
+		    dma_sl_pte_test_and_clear_dirty(pte))
+			iommu_dirty_bitmap_record(dirty, iova, pgsize);
+		iova += pgsize;
+	} while (iova < end);
+	rcu_read_unlock();
+
+	return 0;
+}
+
 const struct iommu_ops intel_iommu_ops = {
 	.capable		= intel_iommu_capable,
 	.domain_alloc		= intel_iommu_domain_alloc,
@@ -4753,6 +4838,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.def_domain_type	= device_def_domain_type,
 	.remove_dev_pasid	= intel_iommu_remove_dev_pasid,
 	.pgsize_bitmap		= SZ_4K,
+	.supported_flags	= IOMMU_DOMAIN_F_ENFORCE_DIRTY,
 #ifdef CONFIG_INTEL_IOMMU_SVM
 	.page_response		= intel_svm_page_response,
 #endif
@@ -4766,6 +4852,8 @@ const struct iommu_ops intel_iommu_ops = {
 		.iova_to_phys		= intel_iommu_iova_to_phys,
 		.free			= intel_iommu_domain_free,
 		.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+		.set_dirty_tracking	= intel_iommu_set_dirty_tracking,
+		.read_and_clear_dirty   = intel_iommu_read_and_clear_dirty,
 	}
 };
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 1c5e1d88862b..56ee6ce2e09d 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -48,6 +48,9 @@
 #define DMA_FL_PTE_DIRTY	BIT_ULL(6)
 #define DMA_FL_PTE_XD		BIT_ULL(63)
 
+#define DMA_SL_PTE_DIRTY_BIT	9
+#define DMA_SL_PTE_DIRTY	BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
+
 #define ADDR_WIDTH_5LEVEL	(57)
 #define ADDR_WIDTH_4LEVEL	(48)
 
@@ -592,6 +595,7 @@ struct dmar_domain {
 					 * otherwise, goes through the second
 					 * level.
 					 */
+	u8 dirty_tracking:1;		/* Dirty tracking is enabled */
 
 	spinlock_t lock;		/* Protect device tracking lists */
 	struct list_head devices;	/* all devices' list */
@@ -774,6 +778,17 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 	return (pte->val & 3) != 0;
 }
 
+static inline bool dma_sl_pte_dirty(struct dma_pte *pte)
+{
+	return (pte->val & DMA_SL_PTE_DIRTY) != 0;
+}
+
+static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte)
+{
+	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
+				  (unsigned long *)&pte->val);
+}
+
 static inline bool dma_pte_superpage(struct dma_pte *pte)
 {
 	return (pte->val & DMA_PTE_LARGE_PAGE);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index c5d479770e12..c7cfa0387277 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -277,6 +277,11 @@ static inline void pasid_set_bits(u64 *ptr, u64 mask, u64 bits)
 	WRITE_ONCE(*ptr, (old & ~mask) | bits);
 }
 
+static inline u64 pasid_get_bits(u64 *ptr)
+{
+	return READ_ONCE(*ptr);
+}
+
 /*
  * Setup the DID(Domain Identifier) field (Bit 64~79) of scalable mode
  * PASID entry.
@@ -335,6 +340,45 @@ static inline void pasid_set_fault_enable(struct pasid_entry *pe)
 	pasid_set_bits(&pe->val[0], 1 << 1, 0);
 }
 
+/*
+ * Enable second level A/D bits by setting the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry.
+ */
+static inline void pasid_set_ssade(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[0], 1 << 9, 1 << 9);
+}
+
+/*
+ * Enable second level A/D bits by setting the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry.
+ */
+static inline void pasid_clear_ssade(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[0], 1 << 9, 0);
+}
+
+/*
+ * Checks if second level A/D bits by setting the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry is enabled.
+ */
+static inline bool pasid_get_ssade(struct pasid_entry *pe)
+{
+	return pasid_get_bits(&pe->val[0]) & (1 << 9);
+}
+
+/*
+ * Setup the SRE(Supervisor Request Enable) field (Bit 128) of a
+ * scalable mode PASID entry.
+ */
+static inline void pasid_set_sre(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[2], 1 << 0, 1);
+}
+
 /*
  * Setup the WPE(Write Protect Enable) field (Bit 132) of a
  * scalable mode PASID entry.
@@ -627,6 +671,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
 	pasid_set_fault_enable(pte);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	if (domain->dirty_tracking)
+		pasid_set_ssade(pte);
 
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
@@ -636,6 +682,63 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	return 0;
 }
 
+/*
+ * Set up dirty tracking on a second only translation type.
+ */
+int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u32 pasid,
+				     bool enabled)
+{
+	struct pasid_entry *pte;
+	u16 did, pgtt;
+
+	spin_lock(&iommu->lock);
+
+	did = domain_id_iommu(domain, iommu);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);
+		return -ENODEV;
+	}
+
+	pgtt = pasid_pte_get_pgtt(pte);
+
+	if (enabled)
+		pasid_set_ssade(pte);
+	else
+		pasid_clear_ssade(pte);
+	spin_unlock(&iommu->lock);
+
+	/*
+	 * From VT-d spec table 25 "Guidance to Software for Invalidations":
+	 *
+	 * - PASID-selective-within-Domain PASID-cache invalidation
+	 *   If (PGTT=SS or Nested)
+	 *    - Domain-selective IOTLB invalidation
+	 *   Else
+	 *    - PASID-selective PASID-based IOTLB invalidation
+	 * - If (pasid is RID_PASID)
+	 *    - Global Device-TLB invalidation to affected functions
+	 *   Else
+	 *    - PASID-based Device-TLB invalidation (with S=1 and
+	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
+	 */
+	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
+
+	if (pgtt == PASID_ENTRY_PGTT_SL_ONLY || pgtt == PASID_ENTRY_PGTT_NESTED)
+		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
+	else
+		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+
+	/* Device IOTLB doesn't need to be flushed in caching mode. */
+	if (!cap_caching_mode(iommu->cap))
+		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+
+	return 0;
+}
+
 /*
  * Set up the scalable mode pasid entry for passthrough translation type.
  */
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index d6b7d21244b1..3fc5aba02971 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -108,6 +108,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid);
+int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u32 pasid,
+				     bool enabled);
 int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid);
-- 
2.17.2

