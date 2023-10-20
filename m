Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A1C7D191C
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjJTW3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjJTW3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:29:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A77D71
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:29:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD7fHQ013033;
        Fri, 20 Oct 2023 22:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Uq92Q66C7CwLLHTgGYtV5lkPGLFZWgABCaMc/Jv/kEU=;
 b=AFHHjDmwAg9fm3/5y4SA8ss2KZrwQCC5vcy71gLIHXPDBaHbPcSkh+v6I6jjtMfjKDFS
 /9mf19IqizfAxWYjakYlOdAF2kgO8JK56GGeijvsEuY+2dyZeyUPHFkiRMbzffeOkFhR
 PnxtaeJgw4sQAbCj24U6mpK07CUeyBZZpirBKNopq6pbWacN4ELdK06MjzDse/1nSiir
 jCKEMc2rg+P3NSBEXVFjb4jM330eq08auLX42bn9nGayBU709iYby/Ab3zoYfNlkXdvh
 gHV/oiZ0PQwqtdoUgFOlDEn8FkXtto3aoFOsmNqx3v9PRDDt1qlTPLnjk9wXvxrI3Afj SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwbasxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KLYHmI025705;
        Fri, 20 Oct 2023 22:28:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwdud09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:51 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KMSAsG018735;
        Fri, 20 Oct 2023 22:28:51 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-179-153.vpn.oracle.com [10.175.179.153])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tubwduch3-12;
        Fri, 20 Oct 2023 22:28:50 +0000
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
Subject: [PATCH v5 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Date:   Fri, 20 Oct 2023 23:27:57 +0100
Message-Id: <20231020222804.21850-12-joao.m.martins@oracle.com>
In-Reply-To: <20231020222804.21850-1-joao.m.martins@oracle.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200191
X-Proofpoint-GUID: jByRR0MtFcVdzBRRSquXUTGcyA6CqMTg
X-Proofpoint-ORIG-GUID: jByRR0MtFcVdzBRRSquXUTGcyA6CqMTg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU advertises Access/Dirty bits if the extended feature register reports
it. Relevant AMD IOMMU SDM ref[0] "1.3.8 Enhanced Support for Access and
Dirty Bits"

To enable it set the DTE flag in bits 7 and 8 to enable access, or
access+dirty. With that, the IOMMU starts marking the D and A flags on
every Memory Request or ATS translation request. It is on the VMM side to
steer whether to enable dirty tracking or not, rather than wrongly doing in
IOMMU. Relevant AMD IOMMU SDM ref [0], "Table 7. Device Table Entry (DTE)
Field Definitions" particularly the entry "HAD".

To actually toggle on and off it's relatively simple as it's setting 2 bits
on DTE and flush the device DTE cache.

To get what's dirtied use existing AMD io-pgtable support, by walking the
pagetables over each IOVA, with fetch_pte().  The IOTLB flushing is left to
the caller (much like unmap), and iommu_dirty_bitmap_record() is the one
adding page-ranges to invalidate. This allows caller to batch the flush
over a big span of IOVA space, without the iommu wondering about when to
flush.

Worthwhile sections from AMD IOMMU SDM:

"2.2.3.1 Host Access Support"
"2.2.3.2 Host Dirty Support"

For details on how IOMMU hardware updates the dirty bit see, and expects
from its consequent clearing by CPU:

"2.2.7.4 Updating Accessed and Dirty Bits in the Guest Address Tables"
"2.2.7.5 Clearing Accessed and Dirty Bits"

Quoting the SDM:

"The setting of accessed and dirty status bits in the page tables is
visible to both the CPU and the peripheral when sharing guest page tables.
The IOMMU interlocked operations to update A and D bits must be 64-bit
operations and naturally aligned on a 64-bit boundary"

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

Access/Dirty bits readout also need to consider the non-default page-sizes
(aka replicated PTEs as mentined by manual), as AMD supports all powers of
two (except 512G) page sizes.

Select IOMMUFD_DRIVER only if IOMMUFD is enabled considering that IOMMU
dirty tracking requires IOMMUFD.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/Kconfig           |   1 +
 drivers/iommu/amd/amd_iommu_types.h |  12 ++++
 drivers/iommu/amd/io_pgtable.c      |  69 +++++++++++++++++++
 drivers/iommu/amd/iommu.c           | 102 +++++++++++++++++++++++++++-
 4 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/Kconfig b/drivers/iommu/amd/Kconfig
index 9b5fc3356bf2..8bd4c3b183ec 100644
--- a/drivers/iommu/amd/Kconfig
+++ b/drivers/iommu/amd/Kconfig
@@ -10,6 +10,7 @@ config AMD_IOMMU
 	select IOMMU_API
 	select IOMMU_IOVA
 	select IOMMU_IO_PGTABLE
+	select IOMMUFD_DRIVER if IOMMUFD
 	depends on X86_64 && PCI && ACPI && HAVE_CMPXCHG_DOUBLE
 	help
 	  With this option you can enable support for AMD IOMMU hardware in
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 7dc30c2b56b3..dec4e5c2b66b 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -97,7 +97,9 @@
 #define FEATURE_GATS_MASK	(3ULL)
 #define FEATURE_GAM_VAPIC	BIT_ULL(21)
 #define FEATURE_GIOSUP		BIT_ULL(48)
+#define FEATURE_HASUP		BIT_ULL(49)
 #define FEATURE_EPHSUP		BIT_ULL(50)
+#define FEATURE_HDSUP		BIT_ULL(52)
 #define FEATURE_SNP		BIT_ULL(63)
 
 #define FEATURE_PASID_SHIFT	32
@@ -212,6 +214,7 @@
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
 #define DEV_ENTRY_TRANSLATION   0x01
+#define DEV_ENTRY_HAD           0x07
 #define DEV_ENTRY_PPR           0x34
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
@@ -370,10 +373,16 @@
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
 #define IOMMU_PTE_PR	BIT_ULL(0)
+#define IOMMU_PTE_HD	BIT_ULL(IOMMU_PTE_HD_BIT)
 #define IOMMU_PTE_U	BIT_ULL(59)
 #define IOMMU_PTE_FC	BIT_ULL(60)
 #define IOMMU_PTE_IR	BIT_ULL(61)
@@ -384,6 +393,7 @@
  */
 #define DTE_FLAG_V	BIT_ULL(0)
 #define DTE_FLAG_TV	BIT_ULL(1)
+#define DTE_FLAG_HAD	(3ULL << 7)
 #define DTE_FLAG_GIOV	BIT_ULL(54)
 #define DTE_FLAG_GV	BIT_ULL(55)
 #define DTE_GLX_SHIFT	(56)
@@ -413,6 +423,7 @@
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_PR)
+#define IOMMU_PTE_DIRTY(pte) ((pte) & IOMMU_PTE_HD)
 #define IOMMU_PTE_PAGE(pte) (iommu_phys_to_virt((pte) & IOMMU_PAGE_MASK))
 #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
 
@@ -563,6 +574,7 @@ struct protection_domain {
 	int nid;		/* Node ID */
 	u64 *gcr3_tbl;		/* Guest CR3 table */
 	unsigned long flags;	/* flags to find out type of domain */
+	bool dirty_tracking;	/* dirty tracking is enabled in the domain */
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
 };
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 2892aa1b4dc1..953f867b4943 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -486,6 +486,74 @@ static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable_ops *ops, unsigned lo
 	return (__pte & ~offset_mask) | (iova & offset_mask);
 }
 
+static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size,
+				     unsigned long flags)
+{
+	bool test_only = flags & IOMMU_DIRTY_NO_CLEAR;
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
+	for (i = 0; i < count && test_only; i++) {
+		if (test_bit(IOMMU_PTE_HD_BIT,
+			     (unsigned long *) &ptep[i])) {
+			dirty = true;
+			break;
+		}
+	}
+
+	for (i = 0; i < count && !test_only; i++) {
+		if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
+				       (unsigned long *) &ptep[i])) {
+			dirty = true;
+		}
+	}
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
+		if (pte_test_and_clear_dirty(ptep, pgsize, flags))
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
@@ -527,6 +595,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
 	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
 	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
+	pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
 
 	return &pgtable->iop;
 }
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 80d6670bb358..6db563956819 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -66,6 +66,7 @@ LIST_HEAD(hpet_map);
 LIST_HEAD(acpihid_map);
 
 const struct iommu_ops amd_iommu_ops;
+const struct iommu_dirty_ops amd_dirty_ops;
 
 static ATOMIC_NOTIFIER_HEAD(ppr_notifier);
 int amd_iommu_max_glx_val = -1;
@@ -1611,6 +1612,9 @@ static void set_dte_entry(struct amd_iommu *iommu, u16 devid,
 			pte_root |= 1ULL << DEV_ENTRY_PPR;
 	}
 
+	if (domain->dirty_tracking)
+		pte_root |= DTE_FLAG_HAD;
+
 	if (domain->flags & PD_IOMMUV2_MASK) {
 		u64 gcr3 = iommu_virt_to_phys(domain->gcr3_tbl);
 		u64 glx  = domain->glx;
@@ -2156,10 +2160,16 @@ static inline u64 dma_max_address(void)
 	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
 }
 
+static bool amd_iommu_hd_support(struct amd_iommu *iommu)
+{
+	return iommu && (iommu->features & FEATURE_HDSUP);
+}
+
 static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 						  struct device *dev,
 						  u32 flags)
 {
+	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	struct protection_domain *domain;
 	struct amd_iommu *iommu = NULL;
 
@@ -2176,6 +2186,9 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
 		return ERR_PTR(-EINVAL);
 
+	if (dirty_tracking && !amd_iommu_hd_support(iommu))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	domain = protection_domain_alloc(type);
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
@@ -2190,6 +2203,9 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 			iommu->iommu.ops->pgsize_bitmap;
 		domain->domain.ops =
 			iommu->iommu.ops->default_domain_ops;
+
+		if (dirty_tracking)
+			domain->domain.dirty_ops = &amd_dirty_ops;
 	}
 
 	return &domain->domain;
@@ -2211,7 +2227,7 @@ static struct iommu_domain *amd_iommu_domain_alloc_user(struct device *dev,
 {
 	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
 
-	if (flags)
+	if (flags & ~IOMMU_HWPT_ALLOC_DIRTY_TRACKING)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	return do_iommu_domain_alloc(type, dev, flags);
@@ -2254,6 +2270,13 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 
 	dev_data->defer_attach = false;
 
+	/*
+	 * Restrict to devices with compatible IOMMU hardware support
+	 * when enforcement of dirty tracking is enabled.
+	 */
+	if (dom->dirty_ops && !amd_iommu_hd_support(iommu))
+		return -EINVAL;
+
 	if (dev_data->domain)
 		detach_device(dev);
 
@@ -2372,6 +2395,11 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 		return true;
 	case IOMMU_CAP_DEFERRED_FLUSH:
 		return true;
+	case IOMMU_CAP_DIRTY_TRACKING: {
+		struct amd_iommu *iommu = rlookup_amd_iommu(dev);
+
+		return amd_iommu_hd_support(iommu);
+	}
 	default:
 		break;
 	}
@@ -2379,6 +2407,73 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 	return false;
 }
 
+static int amd_iommu_set_dirty_tracking(struct iommu_domain *domain,
+					bool enable)
+{
+	struct protection_domain *pdomain = to_pdomain(domain);
+	struct dev_table_entry *dev_table;
+	struct iommu_dev_data *dev_data;
+	bool domain_flush = false;
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
+		domain_flush = true;
+	}
+
+	/* Flush IOTLB to mark IOPTE dirty on the next translation(s) */
+	if (domain_flush) {
+		amd_iommu_domain_flush_tlb_pde(pdomain);
+		amd_iommu_domain_flush_complete(pdomain);
+	}
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
+	return ops->read_and_clear_dirty(ops, iova, size, flags, dirty);
+}
+
 static void amd_iommu_get_resv_regions(struct device *dev,
 				       struct list_head *head)
 {
@@ -2501,6 +2596,11 @@ static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 	return true;
 }
 
+const struct iommu_dirty_ops amd_dirty_ops = {
+	.set_dirty_tracking = amd_iommu_set_dirty_tracking,
+	.read_and_clear_dirty = amd_iommu_read_and_clear_dirty,
+};
+
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
-- 
2.17.2

