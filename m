Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6FF7ABCF9
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjIWB2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjIWB2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DB41AB
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:00 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0u541031656;
        Sat, 23 Sep 2023 01:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=nFm9DoPUG2qbt13Ud0teYiIqTj9xm1q9T5RC6fAYHao=;
 b=2Pwkul/7jC7Xiwy+PSwfHZJSxwfAJuzwHEMFgjrlQgSLp4mbgxYrF8a/ppreYeiPFKnP
 vlZ7+sUGl+0QP314vpZXhve/5pvMPb0D2n+W5bk30ps4V4t53bbN+8NtIe98vpFmWOms
 k0cBLb1fj/ehykVp+pM/TQ5NuJg95icNIKSl6Yue149lKkUOASrp8wvAuYKfo4TVd04a
 RVq0MsBtQjq5R1+bJg9nFerF8RFvSCSWqjaCJVqbWvEym8B6M+UR5ogG8ZIYTFgjsK6c
 v7TAq3CDLNSkx0uqDcy3E0ps413OYFiEoxEYx3RjPWAfrcbof1Dz0ti/XIKosFD+x6S1 EQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsv32u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0Zu2K007691;
        Sat, 23 Sep 2023 01:27:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:28 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hA040930;
        Sat, 23 Sep 2023 01:27:27 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-8;
        Sat, 23 Sep 2023 01:27:27 +0000
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
Subject: [PATCH v3 07/19] iommufd: Dirty tracking data support
Date:   Sat, 23 Sep 2023 02:24:59 +0100
Message-Id: <20230923012511.10379-8-joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=814 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-ORIG-GUID: 0MwVENd_Gqhob9vnqF69uWJX0-nhCxMC
X-Proofpoint-GUID: 0MwVENd_Gqhob9vnqF69uWJX0-nhCxMC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an IO pagetable API iopt_read_and_clear_dirty_data() that performs the
reading of dirty IOPTEs for a given IOVA range and then copying back to
userspace bitmap.

Underneath it uses the IOMMU domain kernel API which will read the dirty
bits, as well as atomically clearing the IOPTE dirty bit and flushing the
IOTLB at the end. The IOVA bitmaps usage takes care of the iteration of the
bitmaps user pages efficiently and without copies.

This is in preparation for a set dirty tracking ioctl which will clear
the dirty bits before enabling it.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/io_pagetable.c    | 70 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h | 14 +++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 3a598182b761..d70617447392 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <uapi/linux/iommufd.h>
 
 #include "io_pagetable.h"
 #include "double_span.h"
@@ -412,6 +413,75 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 	return 0;
 }
 
+struct iova_bitmap_fn_arg {
+	struct iommu_domain *domain;
+	struct iommu_dirty_bitmap *dirty;
+};
+
+static int __iommu_read_and_clear_dirty(struct iova_bitmap *bitmap,
+					unsigned long iova, size_t length,
+					void *opaque)
+{
+	struct iova_bitmap_fn_arg *arg = opaque;
+	struct iommu_domain *domain = arg->domain;
+	struct iommu_dirty_bitmap *dirty = arg->dirty;
+	const struct iommu_dirty_ops *ops = domain->dirty_ops;
+
+	return ops->read_and_clear_dirty(domain, iova, length, 0, dirty);
+}
+
+static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
+				      unsigned long flags,
+				      struct iommufd_dirty_data *bitmap)
+{
+	const struct iommu_dirty_ops *ops = domain->dirty_ops;
+	struct iommu_iotlb_gather gather;
+	struct iommu_dirty_bitmap dirty;
+	struct iova_bitmap_fn_arg arg;
+	struct iova_bitmap *iter;
+	int ret = 0;
+
+	if (!ops || !ops->read_and_clear_dirty)
+		return -EOPNOTSUPP;
+
+	iter = iova_bitmap_alloc(bitmap->iova, bitmap->length,
+			     bitmap->page_size, bitmap->data);
+	if (IS_ERR(iter))
+		return -ENOMEM;
+
+	iommu_dirty_bitmap_init(&dirty, iter, &gather);
+
+	arg.domain = domain;
+	arg.dirty = &dirty;
+	iova_bitmap_for_each(iter, &arg, __iommu_read_and_clear_dirty);
+
+	iommu_iotlb_sync(domain, &gather);
+	iova_bitmap_free(iter);
+
+	return ret;
+}
+
+int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
+				   struct iommu_domain *domain,
+				   unsigned long flags,
+				   struct iommufd_dirty_data *bitmap)
+{
+	unsigned long last_iova, iova = bitmap->iova;
+	unsigned long length = bitmap->length;
+	int ret = -EOPNOTSUPP;
+
+	if ((iova & (iopt->iova_alignment - 1)))
+		return -EINVAL;
+
+	if (check_add_overflow(iova, length - 1, &last_iova))
+		return -EOVERFLOW;
+
+	down_read(&iopt->iova_rwsem);
+	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
+	up_read(&iopt->iova_rwsem);
+	return ret;
+}
+
 int iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
 		   unsigned long length, struct list_head *pages_list)
 {
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 3064997a0181..84ec1df29074 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -8,6 +8,8 @@
 #include <linux/xarray.h>
 #include <linux/refcount.h>
 #include <linux/uaccess.h>
+#include <linux/iommu.h>
+#include <linux/iova_bitmap.h>
 
 struct iommu_domain;
 struct iommu_group;
@@ -70,6 +72,18 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length, unsigned long *unmapped);
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);
 
+struct iommufd_dirty_data {
+	unsigned long iova;
+	unsigned long length;
+	unsigned long page_size;
+	unsigned long long *data;
+};
+
+int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
+				   struct iommu_domain *domain,
+				   unsigned long flags,
+				   struct iommufd_dirty_data *bitmap);
+
 void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
 				 unsigned long length);
 int iopt_table_add_domain(struct io_pagetable *iopt,
-- 
2.17.2

