Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF117D5348
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbjJXNzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbjJXNzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AB16592
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCKOOE004493;
        Tue, 24 Oct 2023 13:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=G3LH5joEjfdIQULPBW9gKmaZ71wspPUFKWfasPsGEGU=;
 b=PO67p/FnUxhXeULfmRABEd1HKfyVAuIIsoWFb7j9EoSv1+Qy/0Ew2B7yi/9hMXWbztiH
 DMXL1P9c7m+i7dACy83zM/f+2py9KdUb722TX9bNTTTkREp1gv2wEVGcBM3ePe7WT/0O
 ywiF14L8X06HZXyG78/MTgkWP0YsbyD6wEb+ATOycdkTs2YU63emIXgF71nB4jAnRhq6
 NCFGbeOeXp/d55SiRQI3Rc8SSt7nOFslJx+EOq37jzPDmH7bgUj5qC1/elzbFyRKQ5pY
 7JACJ1bHLdQnVVGY7xQHcoJAwvl3ent5K3D0IeHnsrQGrEmM8F3VrL5sJaZe5uwCyDVb iQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv76u5fwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OD2CXU034525;
        Tue, 24 Oct 2023 13:51:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53592bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:50 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL94030007;
        Tue, 24 Oct 2023 13:51:49 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-8;
        Tue, 24 Oct 2023 13:51:49 +0000
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
Subject: [PATCH v6 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Date:   Tue, 24 Oct 2023 14:50:58 +0100
Message-Id: <20231024135109.73787-8-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: PI4acV2IR9hXjeKvZiIk49QAj-TOBi7W
X-Proofpoint-ORIG-GUID: PI4acV2IR9hXjeKvZiIk49QAj-TOBi7W
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    |  22 +++++
 drivers/iommu/iommufd/io_pagetable.c    | 113 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  10 +++
 drivers/iommu/iommufd/main.c            |   4 +
 include/uapi/linux/iommufd.h            |  35 ++++++++
 5 files changed, 184 insertions(+)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index c3b7bd9bfcbb..7316f69110ef 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -220,3 +220,25 @@ int iommufd_hwpt_set_dirty_tracking(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(&hwpt->obj);
 	return rc;
 }
+
+int iommufd_hwpt_get_dirty_bitmap(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_hwpt_get_dirty_bitmap *cmd = ucmd->cmd;
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
+	rc = iopt_read_and_clear_dirty_data(&ioas->iopt, hwpt->domain,
+					    cmd->flags, cmd);
+
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 41c2efb6ff15..255264e796fb 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <uapi/linux/iommufd.h>
 
 #include "io_pagetable.h"
 #include "double_span.h"
@@ -412,6 +413,118 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
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
+	int ret;
+
+	iopt_for_each_contig_area(&iter, area, arg->iopt, iova, last_iova) {
+		unsigned long last = min(last_iova, iopt_area_last_iova(area));
+
+		ret = ops->read_and_clear_dirty(domain, iter.cur_iova,
+						last - iter.cur_iova + 1, 0,
+						dirty);
+		if (ret)
+			return ret;
+	}
+
+	if (!iopt_area_contig_done(&iter))
+		return -EINVAL;
+	return 0;
+}
+
+static int
+iommu_read_and_clear_dirty(struct iommu_domain *domain,
+			   struct io_pagetable *iopt, unsigned long flags,
+			   struct iommu_hwpt_get_dirty_bitmap *bitmap)
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
+				 bitmap->page_size,
+				 u64_to_user_ptr(bitmap->data));
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
+int iommufd_check_iova_range(struct io_pagetable *iopt,
+			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
+{
+	size_t iommu_pgsize = iopt->iova_alignment;
+	u64 last_iova;
+
+	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
+		return -EOVERFLOW;
+
+	if (bitmap->iova > ULONG_MAX || last_iova > ULONG_MAX)
+		return -EOVERFLOW;
+
+	if ((bitmap->iova & (iommu_pgsize - 1)) ||
+	    ((last_iova + 1) & (iommu_pgsize - 1)))
+		return -EINVAL;
+
+	if (!bitmap->page_size)
+		return -EINVAL;
+
+	if ((bitmap->iova & (bitmap->page_size - 1)) ||
+	    ((last_iova + 1) & (bitmap->page_size - 1)))
+		return -EINVAL;
+
+	return 0;
+}
+
+int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
+				   struct iommu_domain *domain,
+				   unsigned long flags,
+				   struct iommu_hwpt_get_dirty_bitmap *bitmap)
+{
+	int ret;
+
+	ret = iommufd_check_iova_range(iopt, bitmap);
+	if (ret)
+		return ret;
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
index b09750848da6..034129130db3 100644
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
+				   struct iommu_hwpt_get_dirty_bitmap *bitmap);
 int iopt_set_dirty_tracking(struct io_pagetable *iopt,
 			    struct iommu_domain *domain, bool enable);
 
@@ -226,6 +232,8 @@ int iommufd_option_rlimit_mode(struct iommu_option *cmd,
 			       struct iommufd_ctx *ictx);
 
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
+int iommufd_check_iova_range(struct io_pagetable *iopt,
+			     struct iommu_hwpt_get_dirty_bitmap *bitmap);
 
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
@@ -252,6 +260,8 @@ iommufd_get_hwpt(struct iommufd_ucmd *ucmd, u32 id)
 			    struct iommufd_hw_pagetable, obj);
 }
 int iommufd_hwpt_set_dirty_tracking(struct iommufd_ucmd *ucmd);
+int iommufd_hwpt_get_dirty_bitmap(struct iommufd_ucmd *ucmd);
+
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			   struct iommufd_device *idev, u32 flags,
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 46fedd779714..d50f42a730aa 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -307,6 +307,7 @@ union ucmd_buffer {
 	struct iommu_destroy destroy;
 	struct iommu_hw_info info;
 	struct iommu_hwpt_alloc hwpt;
+	struct iommu_hwpt_get_dirty_bitmap get_dirty_bitmap;
 	struct iommu_hwpt_set_dirty_tracking set_dirty_tracking;
 	struct iommu_ioas_alloc alloc;
 	struct iommu_ioas_allow_iovas allow_iovas;
@@ -343,6 +344,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_HWPT_ALLOC, iommufd_hwpt_alloc, struct iommu_hwpt_alloc,
 		 __reserved),
+	IOCTL_OP(IOMMU_HWPT_GET_DIRTY_BITMAP, iommufd_hwpt_get_dirty_bitmap,
+		 struct iommu_hwpt_get_dirty_bitmap, data),
 	IOCTL_OP(IOMMU_HWPT_SET_DIRTY_TRACKING, iommufd_hwpt_set_dirty_tracking,
 		 struct iommu_hwpt_set_dirty_tracking, __reserved),
 	IOCTL_OP(IOMMU_IOAS_ALLOC, iommufd_ioas_alloc_ioctl,
@@ -555,5 +558,6 @@ MODULE_ALIAS_MISCDEV(VFIO_MINOR);
 MODULE_ALIAS("devname:vfio/vfio");
 #endif
 MODULE_IMPORT_NS(IOMMUFD_INTERNAL);
+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
 MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 5c82b68c88f3..dce38e32ca84 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -48,6 +48,7 @@ enum {
 	IOMMUFD_CMD_HWPT_ALLOC,
 	IOMMUFD_CMD_GET_HW_INFO,
 	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP,
 };
 
 /**
@@ -481,4 +482,38 @@ struct iommu_hwpt_set_dirty_tracking {
 };
 #define IOMMU_HWPT_SET_DIRTY_TRACKING _IO(IOMMUFD_TYPE, \
 					  IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING)
+
+/**
+ * struct iommu_hwpt_get_dirty_bitmap - ioctl(IOMMU_HWPT_GET_DIRTY_BITMAP)
+ * @size: sizeof(struct iommu_hwpt_get_dirty_bitmap)
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain
+ * @flags: Must be zero
+ * @__reserved: Must be 0
+ * @iova: base IOVA of the bitmap first bit
+ * @length: IOVA range size
+ * @page_size: page size granularity of each bit in the bitmap
+ * @data: bitmap where to set the dirty bits. The bitmap bits each
+ *        represent a page_size which you deviate from an arbitrary iova.
+ *
+ * Checking a given IOVA is dirty:
+ *
+ *  data[(iova / page_size) / 64] & (1ULL << ((iova / page_size) % 64))
+ *
+ * Walk the IOMMU pagetables for a given IOVA range to return a bitmap
+ * with the dirty IOVAs. In doing so it will also by default clear any
+ * dirty bit metadata set in the IOPTE.
+ */
+struct iommu_hwpt_get_dirty_bitmap {
+	__u32 size;
+	__u32 hwpt_id;
+	__u32 flags;
+	__u32 __reserved;
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 data;
+};
+#define IOMMU_HWPT_GET_DIRTY_BITMAP _IO(IOMMUFD_TYPE, \
+					IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP)
+
 #endif
-- 
2.17.2

