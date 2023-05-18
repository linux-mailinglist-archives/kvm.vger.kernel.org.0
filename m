Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A057089C7
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjERUr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjERUr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:47:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBBA121
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:47:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx7f8032103;
        Thu, 18 May 2023 20:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=glDG6s0ji8MaAa65dGHIt3BUdaE70T22AYrJcvt0ijo=;
 b=jfyk2w7a2vs2oYpU3NJKXmNBtljwu4APN55l/7V2zd4EMQZKpUp1YawVFdd7QGMP7T5l
 CAVhfVw+QYQT01HirXBJsD65P3dvjUpj5jK8G+MyIn4AMxf9A9TS2F0oe5/dv96oEQdq
 Gsy6j4IKy7mX/xy+CrAHKMYB/AG9jWkX9KjXRrn6p4/xSGbBu4u9uXOfEl+bNFcW6Cfr
 cxG0oSqnJMFtc2ivTIWiCg9nE4kmgSZYSr7WIHr/F7mkYlSyaxkY+HQwNMJv5pmcG2aO
 UBPxtNHs1GbA8RW25uIfQeesPlui/cLm++WPULpMSHNuftg40Pnyb+a49EDGbgbuGTxH DQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj33v0v9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IKXqw9032130;
        Thu, 18 May 2023 20:47:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10daec7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE2t033533;
        Thu, 18 May 2023 20:47:31 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-5;
        Thu, 18 May 2023 20:47:31 +0000
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
Subject: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty tracking
Date:   Thu, 18 May 2023 21:46:30 +0100
Message-Id: <20230518204650.14541-5-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: vxAUhsfdm4GWue53sJs6RVElhtq324AN
X-Proofpoint-ORIG-GUID: vxAUhsfdm4GWue53sJs6RVElhtq324AN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add to iommu domain operations a set of callbacks to perform dirty
tracking, particulary to start and stop tracking and finally to read and
clear the dirty data.

Drivers are generally expected to dynamically change its translation
structures to toggle the tracking and flush some form of control state
structure that stands in the IOVA translation path. Though it's not
mandatory, as drivers will be enable dirty tracking at boot, and just flush
the IO pagetables when setting dirty tracking.  For each of the newly added
IOMMU core APIs:

.supported_flags[IOMMU_DOMAIN_F_ENFORCE_DIRTY]: Introduce a set of flags
that enforce certain restrictions in the iommu_domain object. For dirty
tracking this means that when IOMMU_DOMAIN_F_ENFORCE_DIRTY is set via its
helper iommu_domain_set_flags(...) devices attached via attach_dev will
fail on devices that do *not* have dirty tracking supported. IOMMU drivers
that support dirty tracking should advertise this flag, while enforcing
that dirty tracking is supported by the device in its .attach_dev iommu op.

iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
capabilities of the device.

.set_dirty_tracking(): an iommu driver is expected to change its
translation structures and enable dirty tracking for the devices in the
iommu_domain. For drivers making dirty tracking always-enabled, it should
just return 0.

.read_and_clear_dirty(): an iommu driver is expected to walk the iova range
passed in and use iommu_dirty_bitmap_record() to record dirty info per
IOVA. When detecting a given IOVA is dirty it should also clear its dirty
state from the PTE, *unless* the flag IOMMU_DIRTY_NO_CLEAR is passed in --
flushing is steered from the caller of the domain_op via iotlb_gather. The
iommu core APIs use the same data structure in use for dirty tracking for
VFIO device dirty (struct iova_bitmap) abstracted by
iommu_dirty_bitmap_record() helper function.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommu.c      | 11 +++++++
 include/linux/io-pgtable.h |  4 +++
 include/linux/iommu.h      | 67 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2088caae5074..95acc543e8fb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2013,6 +2013,17 @@ struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus)
 }
 EXPORT_SYMBOL_GPL(iommu_domain_alloc);
 
+int iommu_domain_set_flags(struct iommu_domain *domain,
+			   const struct bus_type *bus, unsigned long val)
+{
+	if (!(val & bus->iommu_ops->supported_flags))
+		return -EINVAL;
+
+	domain->flags |= val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_domain_set_flags);
+
 void iommu_domain_free(struct iommu_domain *domain)
 {
 	if (domain->type == IOMMU_DOMAIN_SVA)
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 1b7a44b35616..25142a0e2fc2 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -166,6 +166,10 @@ struct io_pgtable_ops {
 			      struct iommu_iotlb_gather *gather);
 	phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
 				    unsigned long iova);
+	int (*read_and_clear_dirty)(struct io_pgtable_ops *ops,
+				    unsigned long iova, size_t size,
+				    unsigned long flags,
+				    struct iommu_dirty_bitmap *dirty);
 };
 
 /**
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 39d25645a5ab..992ea87f2f8e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/iova_bitmap.h>
 #include <uapi/linux/iommu.h>
 
 #define IOMMU_READ	(1 << 0)
@@ -65,6 +66,11 @@ struct iommu_domain_geometry {
 
 #define __IOMMU_DOMAIN_SVA	(1U << 4)  /* Shared process address space */
 
+/* Domain feature flags that do not define domain types */
+#define IOMMU_DOMAIN_F_ENFORCE_DIRTY	(1U << 6)  /* Enforce attachment of
+						      dirty tracking supported
+						      devices		  */
+
 /*
  * This are the possible domain-types
  *
@@ -93,6 +99,7 @@ struct iommu_domain_geometry {
 
 struct iommu_domain {
 	unsigned type;
+	unsigned flags;
 	const struct iommu_domain_ops *ops;
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
@@ -128,6 +135,7 @@ enum iommu_cap {
 	 * this device.
 	 */
 	IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
+	IOMMU_CAP_DIRTY,		/* IOMMU supports dirty tracking */
 };
 
 /* These are the possible reserved region types */
@@ -220,6 +228,17 @@ struct iommu_iotlb_gather {
 	bool			queued;
 };
 
+/**
+ * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
+ *
+ * @bitmap: IOVA bitmap
+ * @gather: Range information for a pending IOTLB flush
+ */
+struct iommu_dirty_bitmap {
+	struct iova_bitmap *bitmap;
+	struct iommu_iotlb_gather *gather;
+};
+
 /**
  * struct iommu_ops - iommu ops and capabilities
  * @capable: check capability
@@ -248,6 +267,7 @@ struct iommu_iotlb_gather {
  *                    pasid, so that any DMA transactions with this pasid
  *                    will be blocked by the hardware.
  * @pgsize_bitmap: bitmap of all possible supported page sizes
+ * @flags: All non domain type supported features
  * @owner: Driver module providing these ops
  */
 struct iommu_ops {
@@ -281,6 +301,7 @@ struct iommu_ops {
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
+	unsigned long supported_flags;
 	struct module *owner;
 };
 
@@ -316,6 +337,11 @@ struct iommu_ops {
  * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
+ * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
+ * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
+ *                        into a bitmap, with a bit represented as a page.
+ *                        Reads the dirty PTE bits and clears it from IO
+ *                        pagetables.
  */
 struct iommu_domain_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
@@ -348,6 +374,12 @@ struct iommu_domain_ops {
 				  unsigned long quirks);
 
 	void (*free)(struct iommu_domain *domain);
+
+	int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
+	int (*read_and_clear_dirty)(struct iommu_domain *domain,
+				    unsigned long iova, size_t size,
+				    unsigned long flags,
+				    struct iommu_dirty_bitmap *dirty);
 };
 
 /**
@@ -461,6 +493,9 @@ extern bool iommu_present(const struct bus_type *bus);
 extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
 extern bool iommu_group_has_isolated_msi(struct iommu_group *group);
 extern struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus);
+extern int iommu_domain_set_flags(struct iommu_domain *domain,
+				  const struct bus_type *bus,
+				  unsigned long flags);
 extern void iommu_domain_free(struct iommu_domain *domain);
 extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
@@ -627,6 +662,28 @@ static inline bool iommu_iotlb_gather_queued(struct iommu_iotlb_gather *gather)
 	return gather && gather->queued;
 }
 
+static inline void iommu_dirty_bitmap_init(struct iommu_dirty_bitmap *dirty,
+					   struct iova_bitmap *bitmap,
+					   struct iommu_iotlb_gather *gather)
+{
+	if (gather)
+		iommu_iotlb_gather_init(gather);
+
+	dirty->bitmap = bitmap;
+	dirty->gather = gather;
+}
+
+static inline void
+iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty, unsigned long iova,
+			  unsigned long length)
+{
+	if (dirty->bitmap)
+		iova_bitmap_set(dirty->bitmap, iova, length);
+
+	if (dirty->gather)
+		iommu_iotlb_gather_add_range(dirty->gather, iova, length);
+}
+
 /* PCI device grouping function */
 extern struct iommu_group *pci_device_group(struct device *dev);
 /* Generic device grouping function */
@@ -657,6 +714,9 @@ struct iommu_fwspec {
 /* ATS is supported */
 #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
 
+/* Read but do not clear any dirty bits */
+#define IOMMU_DIRTY_NO_CLEAR			(1 << 0)
+
 /**
  * struct iommu_sva - handle to a device-mm bond
  */
@@ -755,6 +815,13 @@ static inline struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus
 	return NULL;
 }
 
+static inline int iommu_domain_set_flags(struct iommu_domain *domain,
+					 const struct bus_type *bus,
+					 unsigned long flags)
+{
+	return -ENODEV;
+}
+
 static inline void iommu_domain_free(struct iommu_domain *domain)
 {
 }
-- 
2.17.2

