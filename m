Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C81E16A0D3
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 09:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgBXI4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 03:56:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:25344 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgBXI4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 03:56:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 00:56:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,479,1574150400"; 
   d="scan'208";a="231068782"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 24 Feb 2020 00:56:50 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     zhenyuw@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 3/7] vfio: avoid inefficient lookup of VFIO group in vfio_pin/unpin_pages
Date:   Mon, 24 Feb 2020 03:47:26 -0500
Message-Id: <20200224084726.31800-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224084350.31574-1-yan.y.zhao@intel.com>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

in vfio_pin_pages() and vfio_unpin_pages(), before calling into iommu
driver, vfio group for the device is first searched and gets reference
count increased; and after calling into iommu driver, the vfio group is
dereference.

This searching/ref/deref operations can be combined for several calls by
invoking  holding reference of the VFIO group prior to use it and not
releasing the VFIO group until finishing using it.

vfio_pin_pages_from_group() and vfio_unpin_pages_from_group() are
introduced to avoid the above inefficient lookup of VFIO group.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio.c  | 89 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |  6 +++
 2 files changed, 95 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 902867627cbf..08d9e8fb33e5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1998,6 +1998,95 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
 }
 EXPORT_SYMBOL(vfio_unpin_pages);
 
+/*
+ * Pin a set of guest PFNs and return their associated host PFNs for local
+ * domain only.
+ *
+ * The caller needs to call vfio_group_get_external_user() or
+ * vfio_group_get_external_user_from_dev() prior to calling this interface,
+ * so as to prevent the VFIO group from disposal in the middle of the call.
+ * But it can keep the reference to the VFIO group for several calls into
+ * this interface.
+ * After finishing using of the VFIO group, the caller needs to release the
+ * VFIO group by calling vfio_group_put_external_user().
+ *
+ * @group [in]   : VFIO group of a device
+ * @user_pfn [in]: array of user/guest PFNs to be pinned.
+ * @npage [in]   : count of elements in user_pfn array.  This count should not
+ *		   be greater VFIO_PIN_PAGES_MAX_ENTRIES.
+ * @prot [in]    : protection flags
+ * @phys_pfn[out]: array of host PFNs
+ * Return error or number of pages pinned.
+ */
+int vfio_pin_pages_from_group(struct vfio_group *group,
+			      unsigned long *user_pfn, int npage,
+			      int prot, unsigned long *phys_pfn)
+{
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!group || !user_pfn || !phys_pfn || !npage)
+		return -EINVAL;
+
+	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
+		return -E2BIG;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->pin_pages))
+		ret = driver->ops->pin_pages(container->iommu_data, user_pfn,
+					     npage, prot, phys_pfn);
+	else
+		ret = -ENOTTY;
+
+	return ret;
+}
+EXPORT_SYMBOL(vfio_pin_pages_from_group);
+
+/*
+ * Unpin set of host PFNs for local domain only.
+ *
+ * The caller needs to call vfio_group_get_external_user() or
+ * vfio_group_get_external_user_from_dev() prior to calling this interface,
+ * so as to prevent the VFIO group from disposal in the middle of the call.
+ * But it can keep the reference to the VFIO group for several calls into
+ * this interface.
+ * After finishing using of the VFIO group, the caller needs to release the
+ * VFIO group by calling vfio_group_put_external_user().
+ *
+ * @group [in]   : vfio group of a device
+ * @user_pfn [in]: array of user/guest PFNs to be unpinned. Number of user/guest
+ *		   PFNs should not be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ * @npage [in]   : count of elements in user_pfn array.  This count should not
+ *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ * Return error or number of pages unpinned.
+ */
+int vfio_unpin_pages_from_group(struct vfio_group *group,
+				unsigned long *user_pfn, int npage)
+{
+	struct vfio_container *container;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!group || !user_pfn || !npage)
+		return -EINVAL;
+
+	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
+		return -E2BIG;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->unpin_pages))
+		ret = driver->ops->unpin_pages(container->iommu_data, user_pfn,
+					       npage);
+	else
+		ret = -ENOTTY;
+
+	return ret;
+}
+EXPORT_SYMBOL(vfio_unpin_pages_from_group);
+
 
 /*
  * This interface allows the CPUs to perform some sort of virtual DMA on
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index fea0cb1e61d2..aacf6611c084 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -111,6 +111,12 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
 extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
 			    int npage);
 
+extern int vfio_pin_pages_from_group(struct vfio_group *group,
+				     unsigned long *user_pfn, int npage,
+				     int prot, unsigned long *phys_pfn);
+extern int vfio_unpin_pages_from_group(struct vfio_group *group,
+				       unsigned long *user_pfn, int npage);
+
 extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t iova, void *data,
 		       size_t len, bool write);
 
-- 
2.17.1

