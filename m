Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D404F6876F3
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjBBICc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbjBBICX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:02:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873E884B78
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 00:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675324936; x=1706860936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FaftxmN/xJr2F9AHFoNZ6UHlt5FL7jVRmLgqlnO6FZQ=;
  b=KKiwTzamOTBFKqq7xQD5ZiGH6ctPR3YqtKV6o9Ed7kHfIuaVfNnmVumm
   2req0tuaOi1E01lI5cYyAKbGj5+F4nS2DUlwVXXyUt5slWV17TVT43D4G
   ExbKY1ldD0fp2eavV8rySoTtaq4yzUNXvZ+cJG1y25a3eBB4omI0ERFuM
   fX/MJ/f7hH9sci2Itgg0t8ndS0JW0/k6rFfw4xKeLmWsRu1zzfccs53ar
   D1L38NpY5p9qzAaa2dqP7DYpzLenpWtEYtfLaUKOteibp1S95zIEI8hM9
   GNJH5V4eIOrAwFDZ2hAUa9R01aOFnUFQTtexJaUpVlWDkz7ZjLSILTXsS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="355722234"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="355722234"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 00:02:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993990695"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="993990695"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 02 Feb 2023 00:02:04 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Date:   Thu,  2 Feb 2023 00:02:01 -0800
Message-Id: <20230202080201.338571-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202080201.338571-1-yi.l.liu@intel.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

this imports the latest vfio_device_ops definition to vfio.rst.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 Documentation/driver-api/vfio.rst | 71 +++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index c663b6f97825..10d84f01fda1 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -249,19 +249,22 @@ VFIO bus driver API
 
 VFIO bus drivers, such as vfio-pci make use of only a few interfaces
 into VFIO core.  When devices are bound and unbound to the driver,
-the driver should call vfio_register_group_dev() and
-vfio_unregister_group_dev() respectively::
+the driver should call vfio_register_group_dev() or
+vfio_register_emulated_iommu_dev() and vfio_unregister_group_dev()
+respectively::
 
-	void vfio_init_group_dev(struct vfio_device *device,
-				struct device *dev,
-				const struct vfio_device_ops *ops);
-	void vfio_uninit_group_dev(struct vfio_device *device);
 	int vfio_register_group_dev(struct vfio_device *device);
+	int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 	void vfio_unregister_group_dev(struct vfio_device *device);
 
 The driver should embed the vfio_device in its own structure and call
-vfio_init_group_dev() to pre-configure it before going to registration
-and call vfio_uninit_group_dev() after completing the un-registration.
+vfio_alloc_device() or _vfio_alloc_device() to allocate the structure,
+and can register @init/@release callbacks to manage any private state
+wrapping the vfio_device.
+
+	vfio_alloc_device(dev_struct, member, dev, ops);
+	void vfio_put_device(struct vfio_device *device);
+
 vfio_register_group_dev() indicates to the core to begin tracking the
 iommu_group of the specified dev and register the dev as owned by a VFIO bus
 driver. Once vfio_register_group_dev() returns it is possible for userspace to
@@ -270,28 +273,50 @@ ready before calling it. The driver provides an ops structure for callbacks
 similar to a file operations structure::
 
 	struct vfio_device_ops {
-		int	(*open)(struct vfio_device *vdev);
+		char	*name;
+		int	(*init)(struct vfio_device *vdev);
 		void	(*release)(struct vfio_device *vdev);
+		int	(*bind_iommufd)(struct vfio_device *vdev,
+					struct iommufd_ctx *ictx, u32 *out_device_id);
+		void	(*unbind_iommufd)(struct vfio_device *vdev);
+		int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
+		int	(*open_device)(struct vfio_device *vdev);
+		void	(*close_device)(struct vfio_device *vdev);
 		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
 				size_t count, loff_t *ppos);
-		ssize_t	(*write)(struct vfio_device *vdev,
-				 const char __user *buf,
-				 size_t size, loff_t *ppos);
+		ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
+			 size_t count, loff_t *size);
 		long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
 				 unsigned long arg);
-		int	(*mmap)(struct vfio_device *vdev,
-				struct vm_area_struct *vma);
-	};
+		int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
+		void	(*request)(struct vfio_device *vdev, unsigned int count);
+		int	(*match)(struct vfio_device *vdev, char *buf);
+		void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
+		int	(*device_feature)(struct vfio_device *device, u32 flags,
+					  void __user *arg, size_t argsz);
+};
 
 Each function is passed the vdev that was originally registered
-in the vfio_register_group_dev() call above.  This allows the bus driver
-to obtain its private data using container_of().  The open/release
-callbacks are issued when a new file descriptor is created for a
-device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
-a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
-interfaces implement the device region access defined by the device's
-own VFIO_DEVICE_GET_REGION_INFO ioctl.
-
+in the vfio_register_group_dev() or vfio_register_emulated_iommu_dev()
+call above.  This allows the bus driver to obtain its private data using
+container_of().
+- The init/release callbacks are issued in the drivers's structure allocation
+  and put.
+- The open/close_device callbacks are issued when a new file descriptor is
+  created for a device (via VFIO_GROUP_GET_DEVICE_FD).
+- The ioctl interface provides a direct pass through for VFIO_DEVICE_* ioctls.
+- The [un]bind_iommufd callbacks are issued when the device is bound to iommufd.
+  'unbound' is implied if iommufd is being used.
+- The attach_ioas callback is issued when the device is attached to an IOAS
+  managed by the bound iommufd. The attached IOAS is automatically detached
+  when the device is unbound from the iommufd.
+- The read/write/mmap interfaces implement the device region access defined by
+  the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
+- The request callback is issued when device is going to be unregistered.
+- The dma_unmap callback is issued when a range of iova's are unmapped in
+  the container or IOAS attached by the device. Drivers which care about
+  DMA unmap can implement this callback and must tolerate receiving unmap
+  notifications before the device is opened.
 
 PPC64 sPAPR implementation note
 -------------------------------
-- 
2.34.1

