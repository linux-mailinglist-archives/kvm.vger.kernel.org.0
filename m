Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B45D7D5350
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343742AbjJXNzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbjJXNz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35516A77
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCJZDS003716;
        Tue, 24 Oct 2023 13:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=UMwgypmSJWi4FribI/ZYeQronIIpmVjaQBL2POreW+E=;
 b=b+xA2594qPFcf8FbYuI383cUpZVH+/656IFZ/1tODMB7scxv+7g/OzQEmSJ6BCs4Yb75
 IV4eIZgtt6YqUaxsXcg+jCiDBczV/ojlnRlQnRojPgraTxq4h0WKAzoU78C7CbyObOvB
 tPWx1LLZILlEgV/X30q8etqcwtyxt6hkMhcyZYPcbPBpf87AjdhaDDR1LqWhGLc+n1eu
 TGb4Qjjh316bQoiBkrdIWPOa9iqxF3ILaNs3vggWd5tevB2QLxgOIvKFmRb0IkW9d6Lx
 boVE3TfpwraIdmihr6OXCl6xN1FiseiY7VP+OcACHHXPPB0V7MWOyt36QdHAdIS6kFlO lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv52dwgnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OD1o5k034651;
        Tue, 24 Oct 2023 13:52:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53592ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:10 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL9E030007;
        Tue, 24 Oct 2023 13:52:09 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-13;
        Tue, 24 Oct 2023 13:52:09 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v6 12/18] iommu/vt-d: Access/Dirty bit support for SS domains
Date:   Tue, 24 Oct 2023 14:51:03 +0100
Message-Id: <20231024135109.73787-13-joao.m.martins@oracle.com>
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_14,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240118
X-Proofpoint-ORIG-GUID: k7aYbgUTdGCDFYHlu3wjjzE4FFguKImX
X-Proofpoint-GUID: k7aYbgUTdGCDFYHlu3wjjzE4FFguKImX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
tracking and no control bits needed, it just returns 0. To use SSADS, set
bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
via pasid_flush_caches() following the manual. Relevant SDM refs:

"3.7.2 Accessed and Dirty Flags"
"6.5.3.3 Guidance to Software for Invalidations,
 Table 23. Guidance to Software for Invalidations"

PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus the
caller of the iommu op will flush the IOTLB. Relevant manuals over the
hardware translation is chapter 6 with some special mention to:

"6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
"6.2.4 IOTLB"

Select IOMMUFD_DRIVER only if IOMMUFD is enabled, given that IOMMU dirty
tracking requires IOMMUFD.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/intel/Kconfig |   1 +
 drivers/iommu/intel/iommu.c | 103 +++++++++++++++++++++++++++++++++-
 drivers/iommu/intel/iommu.h |  16 ++++++
 drivers/iommu/intel/pasid.c | 109 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel/pasid.h |   4 ++
 5 files changed, 232 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index 2e56bd79f589..f5348b80652b 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -15,6 +15,7 @@ config INTEL_IOMMU
 	select DMA_OPS
 	select IOMMU_API
 	select IOMMU_IOVA
+	select IOMMUFD_DRIVER if IOMMUFD
 	select NEED_DMA_MAP_STATE
 	select DMAR_TABLE
 	select SWIOTLB
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 017aed5813d8..eb92a201cc0b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -300,6 +300,7 @@ static int iommu_skip_te_disable;
 #define IDENTMAP_AZALIA		4
 
 const struct iommu_ops intel_iommu_ops;
+const struct iommu_dirty_ops intel_dirty_ops;
 
 static bool translation_pre_enabled(struct intel_iommu *iommu)
 {
@@ -4079,8 +4080,10 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
 {
 	struct iommu_domain *domain;
 	struct intel_iommu *iommu;
+	bool dirty_tracking;
 
-	if (flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT))
+	if (flags &
+	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	iommu = device_to_iommu(dev, NULL, NULL);
@@ -4090,6 +4093,10 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
 	if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ecap_nest(iommu->ecap))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	dirty_tracking = (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING);
+	if (dirty_tracking && !ssads_supported(iommu))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/*
 	 * domain_alloc_user op needs to fully initialize a domain
 	 * before return, so uses iommu_domain_alloc() here for
@@ -4098,6 +4105,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
 	domain = iommu_domain_alloc(dev->bus);
 	if (!domain)
 		domain = ERR_PTR(-ENOMEM);
+
+	if (!IS_ERR(domain) && dirty_tracking) {
+		if (to_dmar_domain(domain)->use_first_level) {
+			iommu_domain_free(domain);
+			return ERR_PTR(-EOPNOTSUPP);
+		}
+		domain->dirty_ops = &intel_dirty_ops;
+	}
+
 	return domain;
 }
 
@@ -4121,6 +4137,9 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
 		return -EINVAL;
 
+	if (domain->dirty_ops && !ssads_supported(iommu))
+		return -EINVAL;
+
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
 	if (addr_width > cap_mgaw(iommu->cap))
@@ -4375,6 +4394,8 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
 		return dmar_platform_optin();
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return ecap_sc_support(info->iommu->ecap);
+	case IOMMU_CAP_DIRTY_TRACKING:
+		return ssads_supported(info->iommu);
 	default:
 		return false;
 	}
@@ -4772,6 +4793,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 		return -EOPNOTSUPP;
 
+	if (domain->dirty_ops)
+		return -EINVAL;
+
 	if (context_copied(iommu, info->bus, info->devfn))
 		return -EBUSY;
 
@@ -4830,6 +4854,83 @@ static void *intel_iommu_hw_info(struct device *dev, u32 *length, u32 *type)
 	return vtd;
 }
 
+static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
+					  bool enable)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct device_domain_info *info;
+	int ret;
+
+	spin_lock(&dmar_domain->lock);
+	if (dmar_domain->dirty_tracking == enable)
+		goto out_unlock;
+
+	list_for_each_entry(info, &dmar_domain->devices, link) {
+		ret = intel_pasid_setup_dirty_tracking(info->iommu,
+						       info->domain, info->dev,
+						       IOMMU_NO_PASID, enable);
+		if (ret)
+			goto err_unwind;
+	}
+
+	dmar_domain->dirty_tracking = enable;
+out_unlock:
+	spin_unlock(&dmar_domain->lock);
+
+	return 0;
+
+err_unwind:
+	list_for_each_entry(info, &dmar_domain->devices, link)
+		intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
+						 info->dev, IOMMU_NO_PASID,
+						 dmar_domain->dirty_tracking);
+	spin_unlock(&dmar_domain->lock);
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
+
+	/*
+	 * IOMMUFD core calls into a dirty tracking disabled domain without an
+	 * IOVA bitmap set in order to clean dirty bits in all PTEs that might
+	 * have occurred when we stopped dirty tracking. This ensures that we
+	 * never inherit dirtied bits from a previous cycle.
+	 */
+	if (!dmar_domain->dirty_tracking && dirty->bitmap)
+		return -EINVAL;
+
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
+		if (dma_sl_pte_test_and_clear_dirty(pte, flags))
+			iommu_dirty_bitmap_record(dirty, iova, pgsize);
+		iova += pgsize;
+	} while (iova < end);
+
+	return 0;
+}
+
+const struct iommu_dirty_ops intel_dirty_ops = {
+	.set_dirty_tracking = intel_iommu_set_dirty_tracking,
+	.read_and_clear_dirty = intel_iommu_read_and_clear_dirty,
+};
+
 const struct iommu_ops intel_iommu_ops = {
 	.capable		= intel_iommu_capable,
 	.hw_info		= intel_iommu_hw_info,
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index c18fb699c87a..3bb569146229 100644
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
 
@@ -539,6 +542,8 @@ enum {
 #define sm_supported(iommu)	(intel_iommu_sm && ecap_smts((iommu)->ecap))
 #define pasid_supported(iommu)	(sm_supported(iommu) &&			\
 				 ecap_pasid((iommu)->ecap))
+#define ssads_supported(iommu) (sm_supported(iommu) &&                 \
+				ecap_slads((iommu)->ecap))
 
 struct pasid_entry;
 struct pasid_state_entry;
@@ -592,6 +597,7 @@ struct dmar_domain {
 					 * otherwise, goes through the second
 					 * level.
 					 */
+	u8 dirty_tracking:1;		/* Dirty tracking is enabled */
 
 	spinlock_t lock;		/* Protect device tracking lists */
 	struct list_head devices;	/* all devices' list */
@@ -781,6 +787,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 	return (pte->val & 3) != 0;
 }
 
+static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
+						   unsigned long flags)
+{
+	if (flags & IOMMU_DIRTY_NO_CLEAR)
+		return (pte->val & DMA_SL_PTE_DIRTY) != 0;
+
+	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
+				  (unsigned long *)&pte->val);
+}
+
 static inline bool dma_pte_superpage(struct dma_pte *pte)
 {
 	return (pte->val & DMA_PTE_LARGE_PAGE);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 8f92b92f3d2a..b9264b9174e8 100644
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
@@ -335,6 +340,36 @@ static inline void pasid_set_fault_enable(struct pasid_entry *pe)
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
+ * Disable second level A/D bits by clearing the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry.
+ */
+static inline void pasid_clear_ssade(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[0], 1 << 9, 0);
+}
+
+/*
+ * Checks if second level A/D bits specifically the SLADE (Second Level
+ * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
+ * entry is set.
+ */
+static inline bool pasid_get_ssade(struct pasid_entry *pe)
+{
+	return pasid_get_bits(&pe->val[0]) & (1 << 9);
+}
+
 /*
  * Setup the WPE(Write Protect Enable) field (Bit 132) of a
  * scalable mode PASID entry.
@@ -627,6 +662,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
 	pasid_set_fault_enable(pte);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	if (domain->dirty_tracking)
+		pasid_set_ssade(pte);
 
 	pasid_set_present(pte);
 	spin_unlock(&iommu->lock);
@@ -636,6 +673,78 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	return 0;
 }
 
+/*
+ * Set up dirty tracking on a second only or nested translation type.
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
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		dev_err_ratelimited(
+			dev, "Failed to get pasid entry of PASID %d\n", pasid);
+		return -ENODEV;
+	}
+
+	did = domain_id_iommu(domain, iommu);
+	pgtt = pasid_pte_get_pgtt(pte);
+	if (pgtt != PASID_ENTRY_PGTT_SL_ONLY &&
+	    pgtt != PASID_ENTRY_PGTT_NESTED) {
+		spin_unlock(&iommu->lock);
+		dev_err_ratelimited(
+			dev,
+			"Dirty tracking not supported on translation type %d\n",
+			pgtt);
+		return -EOPNOTSUPP;
+	}
+
+	if (pasid_get_ssade(pte) == enabled) {
+		spin_unlock(&iommu->lock);
+		return 0;
+	}
+
+	if (enabled)
+		pasid_set_ssade(pte);
+	else
+		pasid_clear_ssade(pte);
+	spin_unlock(&iommu->lock);
+
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(pte, sizeof(*pte));
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
+	iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
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
index 4e9e68c3c388..958050b093aa 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -106,6 +106,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
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

