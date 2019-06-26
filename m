Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCF456D66
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfFZPNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 11:13:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19084 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728286AbfFZPNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 11:13:55 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 70573C767A71505CB4E9;
        Wed, 26 Jun 2019 23:13:52 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.202.227.237) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 26 Jun 2019 23:13:46 +0800
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
        <pmorel@linux.vnet.ibm.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <xuwei5@hisilicon.com>,
        <kevin.tian@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v7 5/6] vfio/type1: Add IOVA range capability support
Date:   Wed, 26 Jun 2019 16:12:47 +0100
Message-ID: <20190626151248.11776-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.237]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows the user-space to retrieve the supported IOVA
range(s), excluding any reserved regions. The implementation
is based on capability chains, added to VFIO_IOMMU_GET_INFO ioctl.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v6 --> v7

Addressed mdev case with empty iovas list(Suggested by Alex)
---
 drivers/vfio/vfio_iommu_type1.c | 101 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  23 ++++++++
 2 files changed, 124 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 89ad0da7152c..450081802dcd 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2141,6 +2141,73 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	return ret;
 }
 
+static int vfio_iommu_iova_add_cap(struct vfio_info_cap *caps,
+		 struct vfio_iommu_type1_info_cap_iova_range *cap_iovas,
+		 size_t size)
+{
+	struct vfio_info_cap_header *header;
+	struct vfio_iommu_type1_info_cap_iova_range *iova_cap;
+
+	header = vfio_info_cap_add(caps, size,
+				   VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE, 1);
+	if (IS_ERR(header))
+		return PTR_ERR(header);
+
+	iova_cap = container_of(header,
+				struct vfio_iommu_type1_info_cap_iova_range,
+				header);
+	iova_cap->nr_iovas = cap_iovas->nr_iovas;
+	memcpy(iova_cap->iova_ranges, cap_iovas->iova_ranges,
+	       cap_iovas->nr_iovas * sizeof(*cap_iovas->iova_ranges));
+	return 0;
+}
+
+static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
+				      struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_cap_iova_range *cap_iovas;
+	struct vfio_iova *iova;
+	size_t size;
+	int iovas = 0, i = 0, ret;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(iova, &iommu->iova_list, list)
+		iovas++;
+
+	if (!iovas) {
+		/*
+		 * Return 0 as a container with only an mdev device
+		 * will have an empty list
+		 */
+		ret = 0;
+		goto out_unlock;
+	}
+
+	size = sizeof(*cap_iovas) + (iovas * sizeof(*cap_iovas->iova_ranges));
+
+	cap_iovas = kzalloc(size, GFP_KERNEL);
+	if (!cap_iovas) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	cap_iovas->nr_iovas = iovas;
+
+	list_for_each_entry(iova, &iommu->iova_list, list) {
+		cap_iovas->iova_ranges[i].start = iova->start;
+		cap_iovas->iova_ranges[i].end = iova->end;
+		i++;
+	}
+
+	ret = vfio_iommu_iova_add_cap(caps, cap_iovas, size);
+
+	kfree(cap_iovas);
+out_unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2162,19 +2229,53 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		}
 	} else if (cmd == VFIO_IOMMU_GET_INFO) {
 		struct vfio_iommu_type1_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		unsigned long capsz;
+		int ret;
 
 		minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
 
+		/* For backward compatibility, cannot require this */
+		capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
+
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
 
 		if (info.argsz < minsz)
 			return -EINVAL;
 
+		if (info.argsz >= capsz) {
+			minsz = capsz;
+			info.cap_offset = 0; /* output, no-recopy necessary */
+		}
+
 		info.flags = VFIO_IOMMU_INFO_PGSIZES;
 
 		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
+		ret = vfio_iommu_iova_build_caps(iommu, &caps);
+		if (ret)
+			return ret;
+
+		if (caps.size) {
+			info.flags |= VFIO_IOMMU_INFO_CAPS;
+
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+						sizeof(info), caps.buf,
+						caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+				info.cap_offset = sizeof(info);
+			}
+
+			kfree(caps.buf);
+		}
+
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748dac79..1951d87115e8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -714,7 +714,30 @@ struct vfio_iommu_type1_info {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
+#define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
 	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
+	__u32   cap_offset;	/* Offset within info struct of first cap */
+};
+
+/*
+ * The IOVA capability allows to report the valid IOVA range(s)
+ * excluding any reserved regions associated with dev group. Any dma
+ * map attempt outside the valid iova range will return error.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE  1
+
+struct vfio_iova_range {
+	__u64	start;
+	__u64	end;
+};
+
+struct vfio_iommu_type1_info_cap_iova_range {
+	struct vfio_info_cap_header header;
+	__u32	nr_iovas;
+	__u32	reserved;
+	struct vfio_iova_range iova_ranges[];
 };
 
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
-- 
2.17.1


