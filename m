Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19F4183F69
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCMDRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:17:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:6435 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgCMDRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:17:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 20:17:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="278064811"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 Mar 2020 20:17:27 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 1/7] vfio: allow external user to get vfio group from device
Date:   Thu, 12 Mar 2020 23:07:55 -0400
Message-Id: <20200313030755.7767-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313030548.7705-1-yan.y.zhao@intel.com>
References: <20200313030548.7705-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

external user calls vfio_group_get_external_user_from_dev() with a device
pointer to get the VFIO group associated with this device.
The VFIO group is checked to be vialbe and have IOMMU set. Then
container user counter is increased and VFIO group reference is hold
to prevent the VFIO group from disposal before external user exits.

when the external user finishes using of the VFIO group, it calls
vfio_group_put_external_user() to dereference the VFIO group and the
container user counter.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio.c  | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c8482624ca34..97b972bfb735 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1720,6 +1720,44 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
 }
 EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
 
+/**
+ * External user API, exported by symbols to be linked dynamically.
+ * The external user passes in a device pointer
+ * to verify that:
+ *	- A VFIO group is assiciated with the device;
+ *	- IOMMU is set for the group.
+ * If both checks passed, vfio_group_get_external_user_from_dev()
+ * increments the container user counter to prevent the VFIO group
+ * from disposal before external user exits and returns the pointer
+ * to the VFIO group.
+ *
+ * When the external user finishes using the VFIO group, it calls
+ * vfio_group_put_external_user() to release the VFIO group and
+ * decrement the container user counter.
+ *
+ * @dev [in]	: device
+ * Return error PTR or pointer to VFIO group.
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
+	if (ret) {
+		vfio_group_put(group);
+		return ERR_PTR(ret);
+	}
+
+	return group;
+}
+EXPORT_SYMBOL_GPL(vfio_group_get_external_user_from_dev);
+
 void vfio_group_put_external_user(struct vfio_group *group)
 {
 	vfio_group_try_dissolve_container(group);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..fb71e0ac0e76 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -94,6 +94,8 @@ extern void vfio_unregister_iommu_driver(
  */
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
+extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
+								*dev);
 extern bool vfio_external_group_match_file(struct vfio_group *group,
 					   struct file *filep);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
-- 
2.17.1

