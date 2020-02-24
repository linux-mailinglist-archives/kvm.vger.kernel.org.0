Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457A216A0C0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 09:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgBXI4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 03:56:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:40096 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgBXI4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 03:56:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 00:56:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,479,1574150400"; 
   d="scan'208";a="231068681"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 24 Feb 2020 00:56:06 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     zhenyuw@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 1/7] vfio: allow external user to get vfio group from device
Date:   Mon, 24 Feb 2020 03:46:41 -0500
Message-Id: <20200224084641.31696-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224084350.31574-1-yan.y.zhao@intel.com>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

external user is able to
1. add a device into an vfio group
2. call vfio_group_get_external_user_from_dev() with the device pointer
to get vfio_group associated with this device and increments the container
user counter to prevent the VFIO group from disposal before KVM exits.
3. When the external KVM finishes, it calls vfio_group_put_external_user()
to release the VFIO group.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio.c  | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c8482624ca34..914bdf4b9d73 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1720,6 +1720,43 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
 }
 EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
 
+/**
+ * External user API, exported by symbols to be linked dynamically.
+ *
+ * The protocol includes:
+ * 1. External user add a device into a vfio group
+ *
+ * 2. The external user calls vfio_group_get_external_user_from_dev()
+ * with the device pointer
+ * to verify that:
+ *	- there's a vfio group associated with it and is initialized;
+ *	- IOMMU is set for the vfio group.
+ * If both checks passed, vfio_group_get_external_user_from_dev()
+ * increments the container user counter to prevent
+ * the VFIO group from disposal before KVM exits.
+ *
+ * 3. When the external KVM finishes, it calls
+ * vfio_group_put_external_user() to release the VFIO group.
+ * This call decrements the container user counter.
+ */
+
+struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev)
+{
+	struct vfio_group *group;
+	int ret;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return ERR_PTR(-ENODEV);
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return group;
+}
+EXPORT_SYMBOL_GPL(vfio_group_get_external_user_from_dev);
+
 void vfio_group_put_external_user(struct vfio_group *group)
 {
 	vfio_group_try_dissolve_container(group);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..2e1fa0c7396f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -94,6 +94,8 @@ extern void vfio_unregister_iommu_driver(
  */
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
+extern
+struct vfio_group *vfio_group_get_external_user_from_dev(struct device *dev);
 extern bool vfio_external_group_match_file(struct vfio_group *group,
 					   struct file *filep);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
-- 
2.17.1

