Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CD27ABCF7
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjIWB2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjIWB2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443F3136
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:00 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLXvkR031826;
        Sat, 23 Sep 2023 01:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=awm2nXz02nUImtP780qwRzOEHqDEh8VpmtxuJ/4LQwI=;
 b=AWrHJ1pOv4ZDhuZMdIZoIsxJNC0/j5+gTAyr1jgjGuA/1+gOi3Ps2ZNBC7C+HBWKiXzn
 ARe8KGajoiDTB3q98tvOPia2Xsdv4umjQKA/u7ITA093EiuCpQvkK6JBwQKs+Z0foq+F
 gdoyrOCos9+FCci5vu9aWiAczFiDXb/p1A8JtzLIMqKwZEzyQwwmKAPDZIDbxIbiP47Y
 6W7Fnr3E4QX3Ls2NX1ywdAqkDjLO4AAMovhI4g/lMN9xiwOyd07lEhoGm1pCDhqJMkLX
 WJFmjAZ5WmeNbOn022jTqSMcP+T/pb59kLijlIhfqmP1tAATNDydkU9CwA1Yj+ijnfK4 eA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvu445-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0j96o007602;
        Sat, 23 Sep 2023 01:27:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:14 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3h2040930;
        Sat, 23 Sep 2023 01:27:14 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-4;
        Sat, 23 Sep 2023 01:27:14 +0000
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 03/19] iommu: Add iommu_domain ops for dirty tracking
Date:   Sat, 23 Sep 2023 02:24:55 +0100
Message-Id: <20230923012511.10379-4-joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-GUID: Gk0I_LbyJFHa-nFJzF_n8b4Br5Y1e-CL
X-Proofpoint-ORIG-GUID: Gk0I_LbyJFHa-nFJzF_n8b4Br5Y1e-CL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add to iommu domain operations a set of callbacks to perform dirty
tracking, particulary to start and stop tracking and to read and clear the
dirty data.

Drivers are generally expected to dynamically change its translation
structures to toggle the tracking and flush some form of control state
structure that stands in the IOVA translation path. Though it's not
mandatory, as drivers can also enable dirty tracking at boot, and just
clear the dirty bits before setting dirty tracking. For each of the newly
added IOMMU core APIs:

iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
capabilities of the device.

.set_dirty_tracking(): an iommu driver is expected to change its
translation structures and enable dirty tracking for the devices in the
iommu_domain. For drivers making dirty tracking always-enabled, it should
just return 0.

.read_and_clear_dirty(): an iommu driver is expected to walk the pagetables
for the iova range passed in and use iommu_dirty_bitmap_record() to record
dirty info per IOVA. When detecting that a given IOVA is dirty it should
also clear its dirty state from the PTE, *unless* the flag
IOMMU_DIRTY_NO_CLEAR is passed in -- flushing is steered from the caller of
the domain_op via iotlb_gather. The iommu core APIs use the same data
structure in use for dirty tracking for VFIO device dirty (struct
iova_bitmap) abstracted by iommu_dirty_bitmap_record() helper function.

domain::dirty_ops: IOMMU domains will store the dirty ops depending on
whether the iommu device supports dirty tracking or not. iommu drivers can
then use this field to figure if the dirty tracking is supported+enforced
on attach. The enforcement is enable via domain_alloc_user() which is done
via IOMMUFD hwpt flag introduced later.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 include/linux/io-pgtable.h |  4 +++
 include/linux/iommu.h      | 56 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

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
index 660dc1931dc9..f3c27b1f2510 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/iova_bitmap.h>
 #include <uapi/linux/iommu.h>
 
 #define IOMMU_READ	(1 << 0)
@@ -37,6 +38,7 @@ struct bus_type;
 struct device;
 struct iommu_domain;
 struct iommu_domain_ops;
+struct iommu_dirty_ops;
 struct notifier_block;
 struct iommu_sva;
 struct iommu_fault_event;
@@ -95,6 +97,8 @@ struct iommu_domain_geometry {
 struct iommu_domain {
 	unsigned type;
 	const struct iommu_domain_ops *ops;
+	const struct iommu_dirty_ops *dirty_ops;
+
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
 	struct iommu_dma_cookie *iova_cookie;
@@ -133,6 +137,7 @@ enum iommu_cap {
 	 * usefully support the non-strict DMA flush queue.
 	 */
 	IOMMU_CAP_DEFERRED_FLUSH,
+	IOMMU_CAP_DIRTY,		/* IOMMU supports dirty tracking */
 };
 
 /* These are the possible reserved region types */
@@ -227,6 +232,32 @@ struct iommu_iotlb_gather {
 	bool			queued;
 };
 
+/**
+ * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
+ * @bitmap: IOVA bitmap
+ * @gather: Range information for a pending IOTLB flush
+ */
+struct iommu_dirty_bitmap {
+	struct iova_bitmap *bitmap;
+	struct iommu_iotlb_gather *gather;
+};
+
+/**
+ * struct iommu_dirty_ops - domain specific dirty tracking operations
+ * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
+ * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
+ *                        into a bitmap, with a bit represented as a page.
+ *                        Reads the dirty PTE bits and clears it from IO
+ *                        pagetables.
+ */
+struct iommu_dirty_ops {
+	int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
+	int (*read_and_clear_dirty)(struct iommu_domain *domain,
+				    unsigned long iova, size_t size,
+				    unsigned long flags,
+				    struct iommu_dirty_bitmap *dirty);
+};
+
 /**
  * struct iommu_ops - iommu ops and capabilities
  * @capable: check capability
@@ -640,6 +671,28 @@ static inline bool iommu_iotlb_gather_queued(struct iommu_iotlb_gather *gather)
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
@@ -670,6 +723,9 @@ struct iommu_fwspec {
 /* ATS is supported */
 #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
 
+/* Read but do not clear any dirty bits */
+#define IOMMU_DIRTY_NO_CLEAR			(1 << 0)
+
 /**
  * struct iommu_sva - handle to a device-mm bond
  */
-- 
2.17.2

