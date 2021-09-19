Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09C5410A57
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbhISGor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:44:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:31679 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238314AbhISGoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:44:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="284011077"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="284011077"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:42:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702058"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:42:44 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 12/20] iommu/iommufd: Add IOMMU_CHECK_EXTENSION
Date:   Sun, 19 Sep 2021 14:38:40 +0800
Message-Id: <20210919063848.1476776-13-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As aforementioned, userspace should check extension for what formats
can be specified when allocating an IOASID. This patch adds such
interface for userspace. In this RFC, iommufd reports EXT_MAP_TYPE1V2
support and no no-snoop support yet.

Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/iommufd.c |  7 +++++++
 include/uapi/linux/iommu.h      | 27 +++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iommufd.c
index 4839f128b24a..e45d76359e34 100644
--- a/drivers/iommu/iommufd/iommufd.c
+++ b/drivers/iommu/iommufd/iommufd.c
@@ -306,6 +306,13 @@ static long iommufd_fops_unl_ioctl(struct file *filep,
 		return ret;
 
 	switch (cmd) {
+	case IOMMU_CHECK_EXTENSION:
+		switch (arg) {
+		case EXT_MAP_TYPE1V2:
+			return 1;
+		default:
+			return 0;
+		}
 	case IOMMU_DEVICE_GET_INFO:
 		ret = iommufd_get_device_info(ictx, arg);
 		break;
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 5cbd300eb0ee..49731be71213 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -14,6 +14,33 @@
 #define IOMMU_TYPE	(';')
 #define IOMMU_BASE	100
 
+/*
+ * IOMMU_CHECK_EXTENSION - _IO(IOMMU_TYPE, IOMMU_BASE + 0)
+ *
+ * Check whether an uAPI extension is supported.
+ *
+ * It's unlikely that all planned capabilities in IOMMU fd will be ready
+ * in one breath. User should check which uAPI extension is supported
+ * according to its intended usage.
+ *
+ * A rough list of possible extensions may include:
+ *
+ *	- EXT_MAP_TYPE1V2 for vfio type1v2 map semantics;
+ *	- EXT_DMA_NO_SNOOP for no-snoop DMA support;
+ *	- EXT_MAP_NEWTYPE for an enhanced map semantics;
+ *	- EXT_MULTIDEV_GROUP for 1:N iommu group;
+ *	- EXT_IOASID_NESTING for what the name stands;
+ *	- EXT_USER_PAGE_TABLE for user managed page table;
+ *	- EXT_USER_PASID_TABLE for user managed PASID table;
+ *	- EXT_DIRTY_TRACKING for tracking pages dirtied by DMA;
+ *	- ...
+ *
+ * Return: 0 if not supported, 1 if supported.
+ */
+#define EXT_MAP_TYPE1V2		1
+#define EXT_DMA_NO_SNOOP	2
+#define IOMMU_CHECK_EXTENSION	_IO(IOMMU_TYPE, IOMMU_BASE + 0)
+
 /*
  * IOMMU_DEVICE_GET_INFO - _IOR(IOMMU_TYPE, IOMMU_BASE + 1,
  *				struct iommu_device_info)
-- 
2.25.1

