Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5CB7089DD
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjERUu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjERUuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:50:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04857189
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:50:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIxYl6012418;
        Thu, 18 May 2023 20:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=rarZQdWfoONRlaZJKhm0wS9rPiQ9FWSS3CiTbDMh+yU=;
 b=YVl0/JuyzGQPa3yhr/6wz2rnEVpyNvFWr1qXsIdvuyHB6eNJnQhhQtq1HJrvVX16R4AB
 zTva1YZxeRFqI2QpE2CAO1L+42y1vRDY6JGEWFa7erAhNLPmrPO9HRkvNxKjNgq1yVZJ
 tPJ7JfQ43xF73kjJoU/TQEEESUkpzcvJcoBF/Gtx04EQadqyvtPjejA05NuPexIGqCnn
 nmzmXBey0qeGvF5Jq1Z/Ey54X4mINOcLQQL3ue1LVjSQ5yY34hdWs6+/rLj8DeoPBwEy
 8VwTe6SBRcuW3SieAjDcVpe+G3W28lAGwCE4nCJlaac0pLhM9qVaeAOXS2E7Yo/QsF7u 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxfc3k04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJ1gqV032153;
        Thu, 18 May 2023 20:48:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10daffx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:53 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE3L033533;
        Thu, 18 May 2023 20:48:53 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-18;
        Thu, 18 May 2023 20:48:52 +0000
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
Subject: [PATCH RFCv2 17/24] iommu/amd: Access/Dirty bit support in IOPTEs
Date:   Thu, 18 May 2023 21:46:43 +0100
Message-Id: <20230518204650.14541-18-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: RaRMpkRs2DAbAA8PItrBG-mVO30-SbQQ
X-Proofpoint-ORIG-GUID: RaRMpkRs2DAbAA8PItrBG-mVO30-SbQQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU advertises Access/Dirty bits if the extended feature register
reports it. Relevant AMD IOMMU SDM ref[0]
"1.3.8 Enhanced Support for Access and Dirty Bits"

To enable it set the DTE flag in bits 7 and 8 to enable access, or
access+dirty. With that, the IOMMU starts marking the D and A flags on
every Memory Request or ATS translation request. It is on the VMM side
to steer whether to enable dirty tracking or not, rather than wrongly
doing in IOMMU. Relevant AMD IOMMU SDM ref [0], "Table 7. Device Table
Entry (DTE) Field Definitions" particularly the entry "HAD".

To actually toggle on and off it's relatively simple as it's setting
2 bits on DTE and flush the device DTE cache.

To get what's dirtied use existing AMD io-pgtable support, by walking
the pagetables over each IOVA, with fetch_pte().  The IOTLB flushing is
left to the caller (much like unmap), and iommu_dirty_bitmap_record() is
the one adding page-ranges to invalidate. This allows caller to batch
the flush over a big span of IOVA space, without the iommu wondering
about when to flush.

Worthwhile sections from AMD IOMMU SDM:

"2.2.3.1 Host Access Support"
"2.2.3.2 Host Dirty Support"

For details on how IOMMU hardware updates the dirty bit see,
and expects from its consequent clearing by CPU:

"2.2.7.4 Updating Accessed and Dirty Bits in the Guest Address Tables"
"2.2.7.5 Clearing Accessed and Dirty Bits"

Quoting the SDM:

"The setting of accessed and dirty status bits in the page tables is
visible to both the CPU and the peripheral when sharing guest page
tables. The IOMMU interlocked operations to update A and D bits must be
64-bit operations and naturally aligned on a 64-bit boundary"

.. and for the IOMMU update sequence to Dirty bit, essentially is states:

1. Decodes the read and write intent from the memory access.
2. If P=0 in the page descriptor, fail the access.
3. Compare the A & D bits in the descriptor with the read and write
intent in the request.
4. If the A or D bits need to be updated in the descriptor:
* Start atomic operation.
* Read the descriptor as a 64-bit access.
* If the descriptor no longer appears to require an update, release the
atomic lock with
no further action and continue to step 5.
* Calculate the new A & D bits.
* Write the descriptor as a 64-bit access.
* End atomic operation.
5. Continue to the next stage of translation or to the memory access.

Access/Dirty bits readout also need to consider the non-default
page-sizes (aka replicated PTEs as mentined by manual), as AMD
supports all powers of two (except 512G) page sizes.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/amd/amd_iommu.h       |  1 +
 drivers/iommu/amd/amd_iommu_types.h | 12 +++++
 drivers/iommu/amd/init.c            |  5 ++
 drivers/iommu/amd/io_pgtable.c      | 84 +++++++++++++++++++++++++++++
 drivers/iommu/amd/iommu.c           | 81 ++++++++++++++++++++++++++++
 5 files changed, 183 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index e98f20a9bdd8..62567f275878 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -35,6 +35,7 @@ extern int amd_iommu_enable_faulting(void);
 extern int amd_iommu_guest_ir;
 extern enum io_pgtable_fmt amd_iommu_pgtable;
 extern int amd_iommu_gpt_level;
+extern bool amd_iommu_had_support;
 
 /* IOMMUv2 specific functions */
 struct iommu_domain;
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 2ddbda3a4374..3138c257338d 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -97,7 +97,9 @@
 #define FEATURE_GATS_MASK	(3ULL)
 #define FEATURE_GAM_VAPIC	(1ULL<<21)
 #define FEATURE_GIOSUP		(1ULL<<48)
+#define FEATURE_HASUP		(1ULL<<49)
 #define FEATURE_EPHSUP		(1ULL<<50)
+#define FEATURE_HDSUP		(1ULL<<52)
 #define FEATURE_SNP		(1ULL<<63)
 
 #define FEATURE_PASID_SHIFT	32
@@ -208,6 +210,7 @@
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
 #define DEV_ENTRY_TRANSLATION   0x01
+#define DEV_ENTRY_HAD           0x07
 #define DEV_ENTRY_PPR           0x34
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
@@ -366,10 +369,16 @@
 #define PTE_LEVEL_PAGE_SIZE(level)			\
 	(1ULL << (12 + (9 * (level))))
 
+/*
+ * The IOPTE dirty bit
+ */
+#define IOMMU_PTE_HD_BIT (6)
+
 /*
  * Bit value definition for I/O PTE fields
  */
 #define IOMMU_PTE_PR (1ULL << 0)
+#define IOMMU_PTE_HD (1ULL << IOMMU_PTE_HD_BIT)
 #define IOMMU_PTE_U  (1ULL << 59)
 #define IOMMU_PTE_FC (1ULL << 60)
 #define IOMMU_PTE_IR (1ULL << 61)
@@ -380,6 +389,7 @@
  */
 #define DTE_FLAG_V  (1ULL << 0)
 #define DTE_FLAG_TV (1ULL << 1)
+#define DTE_FLAG_HAD (3ULL << 7)
 #define DTE_FLAG_IR (1ULL << 61)
 #define DTE_FLAG_IW (1ULL << 62)
 
@@ -409,6 +419,7 @@
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_PR)
+#define IOMMU_PTE_DIRTY(pte) ((pte) & IOMMU_PTE_HD)
 #define IOMMU_PTE_PAGE(pte) (iommu_phys_to_virt((pte) & IOMMU_PAGE_MASK))
 #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
 
@@ -559,6 +570,7 @@ struct protection_domain {
 	int nid;		/* Node ID */
 	u64 *gcr3_tbl;		/* Guest CR3 table */
 	unsigned long flags;	/* flags to find out type of domain */
+	bool dirty_tracking;	/* dirty tracking is enabled in the domain */
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
 };
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 329a406cc37d..082f47e22c6e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -151,6 +151,7 @@ struct ivmd_header {
 
 bool amd_iommu_dump;
 bool amd_iommu_irq_remap __read_mostly;
+bool amd_iommu_had_support __read_mostly;
 
 enum io_pgtable_fmt amd_iommu_pgtable = AMD_IOMMU_V1;
 /* Guest page table level */
@@ -2201,6 +2202,10 @@ static int __init amd_iommu_init_pci(void)
 	for_each_iommu(iommu)
 		iommu_flush_all_caches(iommu);
 
+	if (check_feature_on_all_iommus(FEATURE_HASUP) &&
+	    check_feature_on_all_iommus(FEATURE_HDSUP))
+		amd_iommu_had_support = true;
+
 	print_iommu_info();
 
 out:
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 666b643106f8..63b4b3ae7c71 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -486,6 +486,89 @@ static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable_ops *ops, unsigned lo
 	return (__pte & ~offset_mask) | (iova & offset_mask);
 }
 
+static bool pte_test_dirty(u64 *ptep, unsigned long size)
+{
+       bool dirty = false;
+       int i, count;
+
+       /*
+        * 2.2.3.2 Host Dirty Support
+        * When a non-default page size is used , software must OR the
+        * Dirty bits in all of the replicated host PTEs used to map
+        * the page. The IOMMU does not guarantee the Dirty bits are
+        * set in all of the replicated PTEs. Any portion of the page
+        * may have been written even if the Dirty bit is set in only
+        * one of the replicated PTEs.
+        */
+       count = PAGE_SIZE_PTE_COUNT(size);
+       for (i = 0; i < count; i++) {
+               if (test_bit(IOMMU_PTE_HD_BIT, (unsigned long *) &ptep[i])) {
+                       dirty = true;
+                       break;
+               }
+       }
+
+       return dirty;
+}
+
+static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size)
+{
+	bool dirty = false;
+	int i, count;
+
+	/*
+	 * 2.2.3.2 Host Dirty Support
+	 * When a non-default page size is used , software must OR the
+	 * Dirty bits in all of the replicated host PTEs used to map
+	 * the page. The IOMMU does not guarantee the Dirty bits are
+	 * set in all of the replicated PTEs. Any portion of the page
+	 * may have been written even if the Dirty bit is set in only
+	 * one of the replicated PTEs.
+	 */
+	count = PAGE_SIZE_PTE_COUNT(size);
+	for (i = 0; i < count; i++)
+		if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
+					(unsigned long *) &ptep[i]))
+			dirty = true;
+
+	return dirty;
+}
+
+static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
+					 unsigned long iova, size_t size,
+					 unsigned long flags,
+					 struct iommu_dirty_bitmap *dirty)
+{
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
+	unsigned long end = iova + size - 1;
+
+	do {
+		unsigned long pgsize = 0;
+		u64 *ptep, pte;
+
+		ptep = fetch_pte(pgtable, iova, &pgsize);
+		if (ptep)
+			pte = READ_ONCE(*ptep);
+		if (!ptep || !IOMMU_PTE_PRESENT(pte)) {
+			pgsize = pgsize ?: PTE_LEVEL_PAGE_SIZE(0);
+			iova += pgsize;
+			continue;
+		}
+
+		/*
+		 * Mark the whole IOVA range as dirty even if only one of
+		 * the replicated PTEs were marked dirty.
+		 */
+		if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
+				pte_test_dirty(ptep, pgsize)) ||
+		    pte_test_and_clear_dirty(ptep, pgsize))
+			iommu_dirty_bitmap_record(dirty, iova, pgsize);
+		iova += pgsize;
+	} while (iova < end);
+
+	return 0;
+}
+
 /*
  * ----------------------------------------------------
  */
@@ -526,6 +609,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
 	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
 	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
+	pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
 
 	return &pgtable->iop;
 }
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4a314647d1f7..ddb92005f018 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1586,6 +1586,9 @@ static void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 			pte_root |= 1ULL << DEV_ENTRY_PPR;
 	}
 
+	if (domain->dirty_tracking)
+		pte_root |= DTE_FLAG_HAD;
+
 	if (domain->flags & PD_IOMMUV2_MASK) {
 		u64 gcr3 = iommu_virt_to_phys(domain->gcr3_tbl);
 		u64 glx  = domain->glx;
@@ -2177,6 +2180,10 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 
 	dev_data->defer_attach = false;
 
+	if (dom->flags & IOMMU_DOMAIN_F_ENFORCE_DIRTY &&
+	    (iommu && !(iommu->features & FEATURE_HDSUP)))
+		return -EINVAL;
+
 	if (dev_data->domain)
 		detach_device(dev);
 
@@ -2293,6 +2300,8 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 		return amdr_ivrs_remap_support;
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return true;
+	case IOMMU_CAP_DIRTY:
+		return amd_iommu_had_support;
 	default:
 		break;
 	}
@@ -2300,6 +2309,75 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 	return false;
 }
 
+static int amd_iommu_set_dirty_tracking(struct iommu_domain *domain,
+					bool enable)
+{
+	struct protection_domain *pdomain = to_pdomain(domain);
+	struct dev_table_entry *dev_table;
+	struct iommu_dev_data *dev_data;
+	struct amd_iommu *iommu;
+	unsigned long flags;
+	u64 pte_root;
+
+	spin_lock_irqsave(&pdomain->lock, flags);
+	if (!(pdomain->dirty_tracking ^ enable)) {
+		spin_unlock_irqrestore(&pdomain->lock, flags);
+		return 0;
+	}
+
+	list_for_each_entry(dev_data, &pdomain->dev_list, list) {
+		iommu = rlookup_amd_iommu(dev_data->dev);
+		if (!iommu)
+			continue;
+
+		dev_table = get_dev_table(iommu);
+		pte_root = dev_table[dev_data->devid].data[0];
+
+		pte_root = (enable ?
+			pte_root | DTE_FLAG_HAD : pte_root & ~DTE_FLAG_HAD);
+
+		/* Flush device DTE */
+		dev_table[dev_data->devid].data[0] = pte_root;
+		device_flush_dte(dev_data);
+	}
+
+	/* Flush IOTLB to mark IOPTE dirty on the next translation(s) */
+	amd_iommu_domain_flush_tlb_pde(pdomain);
+	amd_iommu_domain_flush_complete(pdomain);
+	pdomain->dirty_tracking = enable;
+	spin_unlock_irqrestore(&pdomain->lock, flags);
+
+	return 0;
+}
+
+static int amd_iommu_read_and_clear_dirty(struct iommu_domain *domain,
+					  unsigned long iova, size_t size,
+					  unsigned long flags,
+					  struct iommu_dirty_bitmap *dirty)
+{
+	struct protection_domain *pdomain = to_pdomain(domain);
+	struct io_pgtable_ops *ops = &pdomain->iop.iop.ops;
+	unsigned long lflags;
+	int ret;
+
+	if (!ops || !ops->read_and_clear_dirty)
+		return -EOPNOTSUPP;
+
+	spin_lock_irqsave(&pdomain->lock, lflags);
+	if (!pdomain->dirty_tracking && dirty->bitmap) {
+		spin_unlock_irqrestore(&pdomain->lock, lflags);
+		return -EINVAL;
+	}
+	spin_unlock_irqrestore(&pdomain->lock, lflags);
+
+	rcu_read_lock();
+	ret = ops->read_and_clear_dirty(ops, iova, size, flags, dirty);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+
 static void amd_iommu_get_resv_regions(struct device *dev,
 				       struct list_head *head)
 {
@@ -2432,6 +2510,7 @@ const struct iommu_ops amd_iommu_ops = {
 	.get_resv_regions = amd_iommu_get_resv_regions,
 	.is_attach_deferred = amd_iommu_is_attach_deferred,
 	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
+	.supported_flags = IOMMU_DOMAIN_F_ENFORCE_DIRTY,
 	.def_domain_type = amd_iommu_def_domain_type,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= amd_iommu_attach_device,
@@ -2443,6 +2522,8 @@ const struct iommu_ops amd_iommu_ops = {
 		.iotlb_sync	= amd_iommu_iotlb_sync,
 		.free		= amd_iommu_domain_free,
 		.enforce_cache_coherency = amd_iommu_enforce_cache_coherency,
+		.set_dirty_tracking = amd_iommu_set_dirty_tracking,
+		.read_and_clear_dirty = amd_iommu_read_and_clear_dirty,
 	}
 };
 
-- 
2.17.2

