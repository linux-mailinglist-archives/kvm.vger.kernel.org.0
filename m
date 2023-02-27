Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB9C6A4056
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjB0LM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjB0LM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:12:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27551E1DA;
        Mon, 27 Feb 2023 03:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677496344; x=1709032344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3CoemvlXXk3TqAKjyr9bF6aopFu28Us7QUXAZ6KXgUA=;
  b=ICIQdsItnRghXWNUd207ud+3hWiRJkt4dxE4dQqbvzCNN9pYV5iYMWv7
   uOhpanCJmTuffPLtKbAVlJiU022IHcL7Ze9igD4cMvB8fe6LBMQuqgOjb
   gYzytsDhrW+YeeQg1t45GKjW1Q1zBji/aLGf9L7zTrMcGazjzAqZ3Yd03
   a81hBwBLvHjjpIt/AWQJS4gIFp32snldBKdaQHAyVAQ3U4+fz84NF325g
   ACoZ44IQTfGwcCxUhGfYEaqQTjj0aJS6NCULtc5aZeNciJkRJeqdvgt0b
   VviI3Z23gUaLRbz2CizVoQ86o5G8hSuRPPxID/BqvH3uDS8mHcxpskyav
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="420097793"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="420097793"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 03:11:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651189628"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651189628"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 03:11:50 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v5 18/19] vfio: Compile group optionally
Date:   Mon, 27 Feb 2023 03:11:34 -0800
Message-Id: <20230227111135.61728-19-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227111135.61728-1-yi.l.liu@intel.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
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
introduced, the group infrastructures can be compiled out if only cdev
is needed.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/Kconfig  | 14 +++++++++
 drivers/vfio/Makefile |  2 +-
 drivers/vfio/vfio.h   | 72 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h  | 24 ++++++++++++++-
 4 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 169762316513..c3ab06c314ea 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -4,6 +4,8 @@ menuconfig VFIO
 	select IOMMU_API
 	depends on IOMMUFD || !IOMMUFD
 	select INTERVAL_TREE
+	select VFIO_GROUP if SPAPR_TCE_IOMMU
+	select VFIO_DEVICE_CDEV if !VFIO_GROUP && (X86 || S390 || ARM || ARM64)
 	select VFIO_CONTAINER if IOMMUFD=n
 	help
 	  VFIO provides a framework for secure userspace device drivers.
@@ -15,6 +17,7 @@ if VFIO
 config VFIO_DEVICE_CDEV
 	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
 	depends on IOMMUFD && (X86 || S390 || ARM || ARM64)
+	default !VFIO_GROUP
 	help
 	  The VFIO device cdev is another way for userspace to get device
 	  access. Userspace gets device fd by opening device cdev under
@@ -24,9 +27,20 @@ config VFIO_DEVICE_CDEV
 
 	  If you don't know what to do here, say N.
 
+config VFIO_GROUP
+	bool "Support for the VFIO group /dev/vfio/$group_id"
+	default y
+	help
+	   VFIO group support provides the traditional model for accessing
+	   devices through VFIO and is used by the majority of userspace
+	   applications and drivers making use of VFIO.
+
+	   If you don't know what to do here, say Y.
+
 config VFIO_CONTAINER
 	bool "Support for the VFIO container /dev/vfio/vfio"
 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	depends on VFIO_GROUP
 	default y
 	help
 	  The VFIO container is the classic interface to VFIO for establishing
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 245394aeb94b..57c3515af606 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -2,9 +2,9 @@
 obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
-	  group.o \
 	  iova_bitmap.o
 vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
+vfio-$(CONFIG_VFIO_GROUP) += group.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
 vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 5a1ceb014779..a7b88521bf48 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -62,6 +62,7 @@ enum vfio_group_type {
 	VFIO_NO_IOMMU,
 };
 
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 struct vfio_group {
 	struct device 			dev;
 	struct cdev			cdev;
@@ -107,6 +108,77 @@ void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
+#else
+struct vfio_group;
+
+static inline int vfio_device_block_group(struct vfio_device *device)
+{
+	return 0;
+}
+
+static inline void vfio_device_unblock_group(struct vfio_device *device)
+{
+}
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
+#endif /* CONFIG_VFIO_GROUP */
 
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /**
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ce390533cb30..d12384824656 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -43,7 +43,9 @@ struct vfio_device {
 	 */
 	const struct vfio_migration_ops *mig_ops;
 	const struct vfio_log_ops *log_ops;
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 	struct vfio_group *group;
+#endif
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
 	unsigned int migration_flags;
@@ -58,8 +60,10 @@ struct vfio_device {
 	refcount_t refcount;	/* user count on registered device*/
 	unsigned int open_count;
 	struct completion comp;
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 	struct list_head group_next;
 	struct list_head iommu_entry;
+#endif
 	struct iommufd_access *iommufd_access;
 	void (*put_kvm)(struct kvm *kvm);
 #if IS_ENABLED(CONFIG_IOMMUFD)
@@ -257,12 +261,30 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 /*
  * External user API
  */
+#if IS_ENABLED(CONFIG_VFIO_GROUP)
 struct iommu_group *vfio_file_iommu_group(struct file *file);
 bool vfio_file_is_group(struct file *file);
+bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
+#else
+static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
+{
+	return NULL;
+}
+
+static inline bool vfio_file_is_group(struct file *file)
+{
+	return false;
+}
+
+static inline bool vfio_file_has_dev(struct file *file,
+				     struct vfio_device *device)
+{
+	return false;
+}
+#endif
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
-bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.34.1

