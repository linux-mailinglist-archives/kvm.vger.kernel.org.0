Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF3766DF5F
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjAQNuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjAQNuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:50:05 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7061839B8A
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963400; x=1705499400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhfleG4+0HR7xoEzBCw2e2eD1CHN9Wk9VZ5QjQ1CUeo=;
  b=XRvfckeNkTl1r8O7AdUVe5CAB7Pn8scddhNs4zgc68YyPn5nrz8gGmPV
   9lUYrEeOnjlrZkvYM0MXdhHecBa9AN5kT3rELmq2iIQcYhUji8u7hF3MX
   jsZv9KIf40kGrEGse9Bry0Aa4nav7jhJ0G1fMZx0ORRz/0XCeFKMlhsFP
   H8KMCdiBVnoRc9Od/D5lgFoib5JVI+5sKZcUru3XbqcuhYp13+FyiEfE7
   SpPQE362tipTLzWYru5sblUgUYupe3E9helVJxtXt4BoWnAPQVN91EPRC
   R2PzqYlX+p76PfP+Y4hjd95nERyHOQ/QItVbRAa+1/Zwl9pui2EzmLxVA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766482"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766482"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:50:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551104"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551104"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:59 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 13/13] vfio: Compile group optionally
Date:   Tue, 17 Jan 2023 05:49:42 -0800
Message-Id: <20230117134942.101112-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117134942.101112-1-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

group code is not needed for vfio device cdev, so with vfio device cdev
introduced, the group infrastructures can be compiled out.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/Kconfig  | 17 +++++++++++
 drivers/vfio/Makefile |  3 +-
 drivers/vfio/vfio.h   | 69 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h  | 11 +++++++
 4 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index a8f544629467..7e3f6249fa15 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -12,9 +12,26 @@ menuconfig VFIO
 	  If you don't know what to do here, say N.
 
 if VFIO
+config VFIO_ENABLE_GROUP
+	bool
+	default !IOMMUFD
+
+config VFIO_GROUP
+	bool "Support for the VFIO group /dev/vfio/$group_id"
+	select VFIO_ENABLE_GROUP
+	default y
+	help
+	   VFIO group is legacy interface for userspace. For userspaces
+	   adapted to iommufd and vfio device cdev, this can be N. For
+	   now, before iommufd is ready and userspace applications fully
+	   converted to iommufd and vfio device cdev, this should be Y.
+
+	   If you don't know what to do here, say Y.
+
 config VFIO_CONTAINER
 	bool "Support for the VFIO container /dev/vfio/vfio"
 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	depends on VFIO_ENABLE_GROUP
 	default y
 	help
 	  The VFIO container is the classic interface to VFIO for establishing
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 70e7dcb302ef..bb3fec9ea6bf 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -2,8 +2,9 @@
 obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
-	  group.o \
 	  iova_bitmap.o
+
+vfio-$(CONFIG_VFIO_ENABLE_GROUP) += group.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
 vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 444be924c915..cd282e5c07bb 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -63,6 +63,7 @@ enum vfio_group_type {
 	VFIO_NO_IOMMU,
 };
 
+#if IS_ENABLED(CONFIG_VFIO_ENABLE_GROUP)
 struct vfio_group {
 	struct device 			dev;
 	struct cdev			cdev;
@@ -105,6 +106,74 @@ bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
 bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
+#else
+struct vfio_group;
+
+static inline int vfio_device_set_group(struct vfio_device *device,
+					enum vfio_group_type type)
+{
+	return 0;
+}
+
+static inline void vfio_device_remove_group(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_group_register(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_group_unregister(struct vfio_device *device)
+{
+}
+
+static inline int vfio_device_group_use_iommu(struct vfio_device *device)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_device_group_unuse_iommu(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_group_close(struct vfio_device_file *df)
+{
+}
+
+static inline struct vfio_group *vfio_group_from_file(struct file *file)
+{
+	return NULL;
+}
+
+static inline bool vfio_group_enforced_coherent(struct vfio_group *group)
+{
+	return true;
+}
+
+static inline void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
+{
+}
+
+static inline bool vfio_group_has_dev(struct vfio_group *group,
+				      struct vfio_device *device)
+{
+	return false;
+}
+
+static inline bool vfio_device_has_container(struct vfio_device *device)
+{
+	return false;
+}
+
+static inline int __init vfio_group_init(void)
+{
+	return 0;
+}
+
+static inline void vfio_group_cleanup(void)
+{
+}
+#endif /* CONFIG_VFIO_ENABLE_GROUP */
 
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /* events for the backend driver notify callback */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4a31842ebe0b..eb4dc3dfab03 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -43,7 +43,9 @@ struct vfio_device {
 	 */
 	const struct vfio_migration_ops *mig_ops;
 	const struct vfio_log_ops *log_ops;
+#if IS_ENABLED(CONFIG_VFIO_ENABLE_GROUP)
 	struct vfio_group *group;
+#endif
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
 	unsigned int migration_flags;
@@ -60,8 +62,10 @@ struct vfio_device {
 	refcount_t refcount;	/* user count on registered device*/
 	unsigned int open_count;
 	struct completion comp;
+#if IS_ENABLED(CONFIG_VFIO_ENABLE_GROUP)
 	struct list_head group_next;
 	struct list_head iommu_entry;
+#endif
 	struct iommufd_access *iommufd_access;
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
@@ -246,7 +250,14 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 /*
  * External user API
  */
+#if IS_ENABLED(CONFIG_VFIO_ENABLE_GROUP)
 struct iommu_group *vfio_file_iommu_group(struct file *file);
+#else
+static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
+{
+	return NULL;
+}
+#endif
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
-- 
2.34.1

