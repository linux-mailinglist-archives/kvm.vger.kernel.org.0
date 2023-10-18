Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F147CE8D6
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjJRU2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjJRU2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:28:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1AD1BF
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:28:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IImu88006144;
        Wed, 18 Oct 2023 20:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=ukrtsqw7yZwhwJu2jYLXyT+hU2HugCSnfGF2wRUjEGw=;
 b=c5bgPx3V0vIsAAogRfgggvUyXGaKjVir6BXUMhFYG8Bi/vzliD94ZsMJZ+Wr2kfkFs9Y
 erwuR4lrLyvjxR90F0mvoVMyOi4xBUZbKfNNBjjciGn+JG1x4nCo+95rzJeAG20nAiC+
 qy5YwT+KF2X0M49c1MMlehRRqeU3Qhi8DlgtPo1nPInFvVoYPiK0jL/4Y1orwjn4X54o
 8ttM9JgEse+SGLxRJMUNymzU9ysYgyxiLdNHcKYpsYN4K0fovpErWXW0EoMF8Apt/6AZ
 f7A8tjgAliNnpFEJhvEFzKOWQ6ee6QaWsdNwrB1M/QloRcK7zbW2yu6ahUBP4+8Sf9/b Gw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynghs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IKHnIE009668;
        Wed, 18 Oct 2023 20:27:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps75y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:52 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5b040635;
        Wed, 18 Oct 2023 20:27:51 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-8;
        Wed, 18 Oct 2023 20:27:51 +0000
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
Subject: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Date:   Wed, 18 Oct 2023 21:27:04 +0100
Message-Id: <20231018202715.69734-8-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-1-joao.m.martins@oracle.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=858 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180168
X-Proofpoint-GUID: dmiqNi1V4049-5jMscTTnJUmJN0fpsjt
X-Proofpoint-ORIG-GUID: dmiqNi1V4049-5jMscTTnJUmJN0fpsjt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Connect a hw_pagetable to the IOMMU core dirty tracking
read_and_clear_dirty iommu domain op. It exposes all of the functionality
for the UAPI that read the dirtied IOVAs while clearing the Dirty bits from
the PTEs.

In doing so, add an IO pagetable API iopt_read_and_clear_dirty_data() that
performs the reading of dirty IOPTEs for a given IOVA range and then
copying back to userspace bitmap.

Underneath it uses the IOMMU domain kernel API which will read the dirty
bits, as well as atomically clearing the IOPTE dirty bit and flushing the
IOTLB at the end. The IOVA bitmaps usage takes care of the iteration of the
bitmaps user pages efficiently and without copies. Within the iterator
function we iterate over io-pagetable contigous areas that have been
mapped.

Contrary to past incantation of a similar interface in VFIO the IOVA range
to be scanned is tied in to the bitmap size, thus the application needs to
pass a appropriately sized bitmap address taking into account the iova
range being passed *and* page size ... as opposed to allowing bitmap-iova
!= iova.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 51 ++++++++++++++
 drivers/iommu/iommufd/io_pagetable.c    | 91 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h | 10 +++
 drivers/iommu/iommufd/main.c            |  4 ++
 include/uapi/linux/iommufd.h            | 28 ++++++++
 5 files changed, 184 insertions(+)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 85a0f696c744..c954f91c3b7b 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -220,3 +220,54 @@ int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(&hwpt->obj);
 	return rc;
 }
+
+int iommufd_check_iova_range(struct iommufd_ioas *ioas,
+			     struct iommu_hwpt_get_dirty_iova *bitmap)
+{
+	unsigned long pgshift, npages;
+	size_t iommu_pgsize;
+	int rc = -EINVAL;
+
+	pgshift = __ffs(bitmap->page_size);
+	npages = bitmap->length >> pgshift;
+
+	if (!npages || (npages > ULONG_MAX))
+		return rc;
+
+	iommu_pgsize = ioas->iopt.iova_alignment;
+
+	if (bitmap->iova & (iommu_pgsize - 1))
+		return rc;
+
+	if (!bitmap->length || bitmap->length & (iommu_pgsize - 1))
+		return rc;
+
+	return 0;
+}
+
+int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_hwpt_get_dirty_iova *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_ioas *ioas;
+	int rc = -EOPNOTSUPP;
+
+	if ((cmd->flags || cmd->__reserved))
+		return -EOPNOTSUPP;
+
+	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	ioas = hwpt->ioas;
+	rc = iommufd_check_iova_range(ioas, cmd);
+	if (rc)
+		goto out_put;
+
+	rc = iopt_read_and_clear_dirty_data(&ioas->iopt, hwpt->domain,
+					    cmd->flags, cmd);
+
+out_put:
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 535d73466e15..0c08b3df1b6f 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <uapi/linux/iommufd.h>
 
 #include "io_pagetable.h"
 #include "double_span.h"
@@ -412,6 +413,96 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 	return 0;
 }
 
+struct iova_bitmap_fn_arg {
+	struct io_pagetable *iopt;
+	struct iommu_domain *domain;
+	struct iommu_dirty_bitmap *dirty;
+};
+
+static int __iommu_read_and_clear_dirty(struct iova_bitmap *bitmap,
+					unsigned long iova, size_t length,
+					void *opaque)
+{
+	struct iopt_area *area;
+	struct iopt_area_contig_iter iter;
+	struct iova_bitmap_fn_arg *arg = opaque;
+	struct iommu_domain *domain = arg->domain;
+	struct iommu_dirty_bitmap *dirty = arg->dirty;
+	const struct iommu_dirty_ops *ops = domain->dirty_ops;
+	unsigned long last_iova = iova + length - 1;
+	int ret = -EINVAL;
+
+	iopt_for_each_contig_area(&iter, area, arg->iopt, iova, last_iova) {
+		unsigned long last = min(last_iova, iopt_area_last_iova(area));
+
+		ret = ops->read_and_clear_dirty(domain, iter.cur_iova,
+						last - iter.cur_iova + 1,
+						0, dirty);
+		if (ret)
+			break;
+	}
+
+	if (!iopt_area_contig_done(&iter))
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
+				      struct io_pagetable *iopt,
+				      unsigned long flags,
+				      struct iommu_hwpt_get_dirty_iova *bitmap)
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
+	arg.iopt = iopt;
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
+				   struct iommu_hwpt_get_dirty_iova *bitmap)
+{
+	unsigned long last_iova, iova = bitmap->iova;
+	unsigned long length = bitmap->length;
+	int ret = -EINVAL;
+
+	if ((iova & (iopt->iova_alignment - 1)))
+		return -EINVAL;
+
+	if (check_add_overflow(iova, length - 1, &last_iova))
+		return -EOVERFLOW;
+
+	down_read(&iopt->iova_rwsem);
+	ret = iommu_read_and_clear_dirty(domain, iopt, flags, bitmap);
+	up_read(&iopt->iova_rwsem);
+
+	return ret;
+}
+
 static int iopt_clear_dirty_data(struct io_pagetable *iopt,
 				 struct iommu_domain *domain)
 {
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index d42e01cc1105..daceedcc91ec 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -8,6 +8,8 @@
 #include <linux/xarray.h>
 #include <linux/refcount.h>
 #include <linux/uaccess.h>
+#include <linux/iommu.h>
+#include <linux/iova_bitmap.h>
 #include <uapi/linux/iommufd.h>
 
 struct iommu_domain;
@@ -71,6 +73,10 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length, unsigned long *unmapped);
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);
 
+int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
+				   struct iommu_domain *domain,
+				   unsigned long flags,
+				   struct iommu_hwpt_get_dirty_iova *bitmap);
 int iopt_set_dirty_tracking(struct io_pagetable *iopt,
 			    struct iommu_domain *domain, bool enable);
 
@@ -226,6 +232,8 @@ int iommufd_option_rlimit_mode(struct iommu_option *cmd,
 			       struct iommufd_ctx *ictx);
 
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
+int iommufd_check_iova_range(struct iommufd_ioas *ioas,
+			     struct iommu_hwpt_get_dirty_iova *bitmap);
 
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
@@ -252,6 +260,8 @@ static inline struct iommufd_hw_pagetable *iommufd_get_hwpt(
 			    struct iommufd_hw_pagetable, obj);
 }
 int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd);
+int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd);
+
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			   struct iommufd_device *idev, u32 flags,
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 2e625b280d61..30f1656ac5da 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -307,6 +307,7 @@ union ucmd_buffer {
 	struct iommu_destroy destroy;
 	struct iommu_hw_info info;
 	struct iommu_hwpt_alloc hwpt;
+	struct iommu_hwpt_get_dirty_iova get_dirty_iova;
 	struct iommu_hwpt_set_dirty set_dirty;
 	struct iommu_ioas_alloc alloc;
 	struct iommu_ioas_allow_iovas allow_iovas;
@@ -343,6 +344,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_HWPT_ALLOC, iommufd_hwpt_alloc, struct iommu_hwpt_alloc,
 		 __reserved),
+	IOCTL_OP(IOMMU_HWPT_GET_DIRTY_IOVA, iommufd_hwpt_get_dirty_iova,
+		 struct iommu_hwpt_get_dirty_iova, data),
 	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
 		 struct iommu_hwpt_set_dirty, __reserved),
 	IOCTL_OP(IOMMU_IOAS_ALLOC, iommufd_ioas_alloc_ioctl,
@@ -555,5 +558,6 @@ MODULE_ALIAS_MISCDEV(VFIO_MINOR);
 MODULE_ALIAS("devname:vfio/vfio");
 #endif
 MODULE_IMPORT_NS(IOMMUFD_INTERNAL);
+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
 MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 9e1721e38819..efeb12c1aaeb 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -48,6 +48,7 @@ enum {
 	IOMMUFD_CMD_HWPT_ALLOC,
 	IOMMUFD_CMD_GET_HW_INFO,
 	IOMMUFD_CMD_HWPT_SET_DIRTY,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
 };
 
 /**
@@ -479,4 +480,31 @@ struct iommu_hwpt_set_dirty {
 	__u32 __reserved;
 };
 #define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
+
+/**
+ * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
+ * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
+ * @flags: Flags to control dirty tracking status.
+ * @iova: base IOVA of the bitmap first bit
+ * @length: IOVA range size
+ * @page_size: page size granularity of each bit in the bitmap
+ * @data: bitmap where to set the dirty bits. The bitmap bits each
+ * represent a page_size which you deviate from an arbitrary iova.
+ * Checking a given IOVA is dirty:
+ *
+ *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
+ */
+struct iommu_hwpt_get_dirty_iova {
+	__u32 size;
+	__u32 hwpt_id;
+	__u32 flags;
+	__u32 __reserved;
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 *data;
+};
+#define IOMMU_HWPT_GET_DIRTY_IOVA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA)
+
 #endif
-- 
2.17.2

