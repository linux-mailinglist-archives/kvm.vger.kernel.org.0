Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CAD7CE8CC
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjJRU2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjJRU2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:28:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02556D4B
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:27:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIor6x012508;
        Wed, 18 Oct 2023 20:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Lh3YmbxstaGC9PFtNgRoH6tK1uNXoccrZ6ltGZUGNoE=;
 b=yFh5ERTPbcC+nBSeQgxlAcAoJZp4RFYP5Jv5QC41GDaFPYhVrrNrPwx8q63DJ+UMNxZO
 QAag6A86wBm9PRTUNc4sKM7M31bPgSF36ZQ6K5jJK2naDRV3Zh1cF9TZ6q1bpDtWzWTl
 sh6KfKt2HVJ8glNIID+egztzmi04JkdaK01SF9Y6fRt1w0xGfHcYU6pDRPCSdNDvx4Pf
 /SQTBkmHmmEk5CnSEtgNFkH20kK50gKtQ0lRCGg2J9MnualhXqNwXNUKmbKmobQGjFzl
 qeEs7kFRV6JdvP/3BKwEo7OhEfw4hDe5nuYsDZVIWjsXn9mFvvDidXaw1Dg46bjxzY3i Jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jrjt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IKNnh5010461;
        Wed, 18 Oct 2023 20:27:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps6x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:33 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5R040635;
        Wed, 18 Oct 2023 20:27:33 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-3;
        Wed, 18 Oct 2023 20:27:32 +0000
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
        Brett Creeley <brett.creeley@amd.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v4 02/18] vfio: Move iova_bitmap into iommufd
Date:   Wed, 18 Oct 2023 21:26:59 +0100
Message-Id: <20231018202715.69734-3-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-1-joao.m.martins@oracle.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=838 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180168
X-Proofpoint-GUID: SKJEx42naB8QHxJzBxTi9t8NtwxheI5G
X-Proofpoint-ORIG-GUID: SKJEx42naB8QHxJzBxTi9t8NtwxheI5G
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

