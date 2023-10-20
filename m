Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0779B7D1926
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjJTW3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjJTW25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:28:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC9E10DA
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:28:46 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KMFoQD019054;
        Fri, 20 Oct 2023 22:28:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=rNpBOMdmgF0NGt11zJzrP639qH+X/X5UZpJAx+WIUuQ=;
 b=rD+CtIs7dLHIAx9uqvxnGuVD+dQhFQ41PtU4r5zvLiJZt+AOeZvKp4gKmqDpSjRmjaEI
 2xFwSLGRxBbfSM9k0IhKsYdiCgKD+tp9BadJkRoa+1AWlAMYoq40MGZNPTHFCghmHchR
 1ylztvPpttGvdr7wMyRgVstQ8iJNOsxmqWqjv0FUDs/pmjVUEpYcpedrqD1wdQIcLt6t
 98amGNsq7finKb/A2WgbjKyeHHoUQdlnAyp/dGuBzgRp04rEI/fuQm7LWXnhRrpOvVZ3
 hDcdO3tw61P03AqDKAB6m/C/pEcITvf+XIFSWNDceTjrXvaceFlJ3NyA5XkN9elH+hZC 4w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubw82txd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KLVImB025921;
        Fri, 20 Oct 2023 22:28:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwducmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:18 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KMSArw018735;
        Fri, 20 Oct 2023 22:28:18 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-179-153.vpn.oracle.com [10.175.179.153])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tubwduch3-3;
        Fri, 20 Oct 2023 22:28:17 +0000
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
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [PATCH v5 02/18] vfio: Move iova_bitmap into iommufd
Date:   Fri, 20 Oct 2023 23:27:48 +0100
Message-Id: <20231020222804.21850-3-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: JEqdJJzNWKfFOCg_iZM1YQjRAcje6LZY
X-Proofpoint-ORIG-GUID: JEqdJJzNWKfFOCg_iZM1YQjRAcje6LZY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
the user bitmaps, so move to the common dependency into IOMMUFD.  In doing
so, create the symbol IOMMUFD_DRIVER which designates the builtin code that
will be used by drivers when selected. Today this means MLX5_VFIO_PCI and
PDS_VFIO_PCI. IOMMU drivers will do the same (in future patches) when
supporting dirty tracking and select IOMMUFD_DRIVER accordingly.

Given that the symbol maybe be disabled, add header definitions in
iova_bitmap.h for when IOMMUFD_DRIVER=n

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/iommufd/Kconfig                 |  4 +++
 drivers/iommu/iommufd/Makefile                |  1 +
 drivers/{vfio => iommu/iommufd}/iova_bitmap.c |  0
 drivers/vfio/Makefile                         |  3 +--
 drivers/vfio/pci/mlx5/Kconfig                 |  1 +
 drivers/vfio/pci/pds/Kconfig                  |  1 +
 include/linux/iova_bitmap.h                   | 26 +++++++++++++++++++
 7 files changed, 34 insertions(+), 2 deletions(-)
 rename drivers/{vfio => iommu/iommufd}/iova_bitmap.c (100%)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 99d4b075df49..1fa543204e89 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -11,6 +11,10 @@ config IOMMUFD
 
 	  If you don't know what to do here, say N.
 
+config IOMMUFD_DRIVER
+	bool
+	default n
+
 if IOMMUFD
 config IOMMUFD_VFIO_CONTAINER
 	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 8aeba81800c5..34b446146961 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -11,3 +11,4 @@ iommufd-y := \
 iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
 
 obj-$(CONFIG_IOMMUFD) += iommufd.o
+obj-$(CONFIG_IOMMUFD_DRIVER) += iova_bitmap.o
diff --git a/drivers/vfio/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
similarity index 100%
rename from drivers/vfio/iova_bitmap.c
rename to drivers/iommu/iommufd/iova_bitmap.c
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index c82ea032d352..68c05705200f 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,8 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_VFIO) += vfio.o
 
-vfio-y += vfio_main.o \
-	  iova_bitmap.o
+vfio-y += vfio_main.o
 vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
 vfio-$(CONFIG_VFIO_GROUP) += group.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
index 7088edc4fb28..c3ced56b7787 100644
--- a/drivers/vfio/pci/mlx5/Kconfig
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -3,6 +3,7 @@ config MLX5_VFIO_PCI
 	tristate "VFIO support for MLX5 PCI devices"
 	depends on MLX5_CORE
 	select VFIO_PCI_CORE
+	select IOMMUFD_DRIVER
 	help
 	  This provides migration support for MLX5 devices using the VFIO
 	  framework.
diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
index 407b3fd32733..fff368a8183b 100644
--- a/drivers/vfio/pci/pds/Kconfig
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -5,6 +5,7 @@ config PDS_VFIO_PCI
 	tristate "VFIO support for PDS PCI devices"
 	depends on PDS_CORE
 	select VFIO_PCI_CORE
+	select IOMMUFD_DRIVER
 	help
 	  This provides generic PCI support for PDS devices using the VFIO
 	  framework.
diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
index c006cf0a25f3..1c338f5e5b7a 100644
--- a/include/linux/iova_bitmap.h
+++ b/include/linux/iova_bitmap.h
@@ -7,6 +7,7 @@
 #define _IOVA_BITMAP_H_
 
 #include <linux/types.h>
+#include <linux/errno.h>
 
 struct iova_bitmap;
 
@@ -14,6 +15,7 @@ typedef int (*iova_bitmap_fn_t)(struct iova_bitmap *bitmap,
 				unsigned long iova, size_t length,
 				void *opaque);
 
+#if IS_ENABLED(CONFIG_IOMMUFD_DRIVER)
 struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 				      unsigned long page_size,
 				      u64 __user *data);
@@ -22,5 +24,29 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
 			 iova_bitmap_fn_t fn);
 void iova_bitmap_set(struct iova_bitmap *bitmap,
 		     unsigned long iova, size_t length);
+#else
+static inline struct iova_bitmap *iova_bitmap_alloc(unsigned long iova,
+						    size_t length,
+						    unsigned long page_size,
+						    u64 __user *data)
+{
+	return NULL;
+}
+
+static inline void iova_bitmap_free(struct iova_bitmap *bitmap)
+{
+}
+
+static inline int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
+				       iova_bitmap_fn_t fn)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iova_bitmap_set(struct iova_bitmap *bitmap,
+				   unsigned long iova, size_t length)
+{
+}
+#endif
 
 #endif
-- 
2.17.2

