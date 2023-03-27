Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF90E6C9FEE
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjC0JgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbjC0Jfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:35:42 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682A519B2;
        Mon, 27 Mar 2023 02:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679909738; x=1711445738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8gWbAJJlIuV/z8+WOO6T7u0CyD5t7kZGlKBcfpHfaUQ=;
  b=VHC7gzRUIcMpSquCftVNP3Lv/GY3xt92mIgfbflStgfLceTHrSSDRHAO
   myrgnsrP0eo5Gj2Y+nY/oeTjChyR3AZwcbWfgxDPItIxYF79JbH4d0saF
   2zRON3H/zVjll4pSBsdTEl6PXyooIlRvFCtFfwRU9hi1uOYBWNgGhvyBg
   AmrM56E6oj83vCeMkKppXPmg87Wu6Jb2ylkEbYkgMl7a7BND71vYOuycD
   nSXg6vJZmUwccL6imqqJJOZGkDc3ms27U/zCVNvyR+zW3OG9Uf9vbQRPe
   Pu8JlSLH1uH4crGYur1YpG2aGWDugYKu3eAOOtXXlpHycp5jYmPfaCybl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="319879604"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="319879604"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:35:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="633554687"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="633554687"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2023 02:35:10 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v2 10/10] vfio/pci: Add VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Date:   Mon, 27 Mar 2023 02:34:58 -0700
Message-Id: <20230327093458.44939-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327093458.44939-1-yi.l.liu@intel.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation for vfio device cdev as cdev gives userspace the
capability to open device cdev fd and management stack (e.g. libvirt)
could pass the device fd to the actual user (e.g. QEMU). As a result,
the actual user has no idea about the device's bus:devfn information.
This is a problem when user uses VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to
know the hot reset affected device scope as this ioctl returns bus:devfn
info. For the fd passing usage, the acutal user cannot map the bus:devfn
to the devices it has opened via the fd passed from management stack. So
a new ioctl is required.

This new ioctl reports the list of iommufd dev_id that is opened by the
user. If there is affected device that is not bound to vfio driver or
opened by another user, this command shall fail with -EPERM. For the
noiommu mode in the vfio device cdev path, this shall fail as no dev_id
would be generated, hence nothing to report.

This ioctl is useless to the users that open vfio group as such users
have no idea about the iommufd dev_id and it can use the existing
VFIO_DEVICE_GET_PCI_HOT_RESET_INFO. The user that uses the traditional
mode vfio group/container would be failed if invoking this ioctl. But
the user that uses the iommufd compat mode vfio group/container shall
succeed. This is harmless as long as user cannot make use of it and
should use VFIO_DEVICE_GET_PCI_HOT_RESET_INFO.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 98 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        | 47 +++++++++++++++
 2 files changed, 145 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 19f5b075d70a..45edf4e9b98b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1181,6 +1181,102 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+static struct pci_dev *
+vfio_pci_dev_set_resettable(struct vfio_device_set *dev_set);
+
+static int vfio_pci_ioctl_get_pci_hot_reset_group_info(
+	struct vfio_pci_core_device *vdev,
+	struct vfio_pci_hot_reset_group_info __user *arg)
+{
+	unsigned long minsz =
+		offsetofend(struct vfio_pci_hot_reset_group_info, count);
+	struct vfio_pci_hot_reset_group_info hdr;
+	struct iommufd_ctx *iommufd, *cur_iommufd;
+	u32 count = 0, index = 0, *devices = NULL;
+	struct vfio_pci_core_device *cur;
+	bool slot = false;
+	int ret = 0;
+
+	if (copy_from_user(&hdr, arg, minsz))
+		return -EFAULT;
+
+	if (hdr.argsz < minsz)
+		return -EINVAL;
+
+	hdr.flags = 0;
+
+	/* Can we do a slot or bus reset or neither? */
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot = true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return -ENODEV;
+
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	if (!vfio_pci_dev_set_resettable(vdev->vdev.dev_set)) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
+	if (!iommufd) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	/* How many devices are affected? */
+	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+					    &count, slot);
+	if (ret)
+		goto out_unlock;
+
+	WARN_ON(!count); /* Should always be at least one */
+
+	/*
+	 * If there's enough space, fill it now, otherwise return -ENOSPC and
+	 * the number of devices affected.
+	 */
+	if (hdr.argsz < sizeof(hdr) + (count * sizeof(*devices))) {
+		ret = -ENOSPC;
+		hdr.count = count;
+		goto reset_info_exit;
+	}
+
+	devices = kcalloc(count, sizeof(*devices), GFP_KERNEL);
+	if (!devices) {
+		ret = -ENOMEM;
+		goto reset_info_exit;
+	}
+
+	list_for_each_entry(cur, &vdev->vdev.dev_set->device_list, vdev.dev_set_list) {
+		cur_iommufd = vfio_iommufd_physical_ictx(&cur->vdev);
+		if (cur->vdev.open_count) {
+			if (cur_iommufd != iommufd) {
+				ret = -EPERM;
+				break;
+			}
+			ret = vfio_iommufd_physical_devid(&cur->vdev, &devices[index]);
+			if (ret)
+				break;
+			index++;
+		}
+	}
+
+reset_info_exit:
+	if (copy_to_user(arg, &hdr, minsz))
+		ret = -EFAULT;
+
+	if (!ret) {
+		if (copy_to_user(&arg->devices, devices,
+				 hdr.count * sizeof(*devices)))
+			ret = -EFAULT;
+	}
+
+	kfree(devices);
+out_unlock:
+	mutex_unlock(&vdev->vdev.dev_set->lock);
+	return ret;
+}
+
 static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	struct vfio_pci_core_device *vdev,
 	struct vfio_pci_hot_reset_info __user *arg)
@@ -1404,6 +1500,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		return vfio_pci_ioctl_get_irq_info(vdev, uarg);
 	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
 		return vfio_pci_ioctl_get_pci_hot_reset_info(vdev, uarg);
+	case VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO:
+		return vfio_pci_ioctl_get_pci_hot_reset_group_info(vdev, uarg);
 	case VFIO_DEVICE_GET_REGION_INFO:
 		return vfio_pci_ioctl_get_region_info(vdev, uarg);
 	case VFIO_DEVICE_IOEVENTFD:
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 25432ef213ee..61b801dfd40b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -669,6 +669,53 @@ struct vfio_pci_hot_reset_info {
 
 #define VFIO_DEVICE_GET_PCI_HOT_RESET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
 
+/**
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
+ *						    struct vfio_pci_hot_reset_group_info)
+ *
+ * This is used in the vfio device cdev mode.  It returns the list of
+ * affected devices (represented by iommufd dev_id) when hot reset is
+ * issued on the current device with which this ioctl is invoked.  It
+ * only includes the devices that are opened by the current user in the
+ * time of this command is invoked.  This list may change when user opens
+ * new device or close opened device, hence user should re-invoke it
+ * after open/close devices.  This command has no guarantee on the result
+ * of VFIO_DEVICE_PCI_HOT_RESET since the not-opened affected device can
+ * be by other users in the window between the two ioctls.  If the affected
+ * devices are opened by multiple users, the VFIO_DEVICE_PCI_HOT_RESET
+ * shall fail, detail can check the description of VFIO_DEVICE_PCI_HOT_RESET.
+ *
+ * For the users that open vfio group/container, this ioctl is useless as
+ * they have no idea about the iommufd dev_id returned by this ioctl.  For
+ * the users of the traditional mode vfio group/container, this ioctl will
+ * fail as this mode does not use iommufd hence no dev_id to report back.
+ * For the users of the iommufd compat mode vfio group/container, this ioctl
+ * would succeed as this mode uses iommufd as container fd.  But such users
+ * still have no idea about the iommufd dev_id as the dev_id is only stored
+ * in kernel in this mode.  For the users of the vfio group/container, the
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO should be used to know the hot reset
+ * affected devices.
+ *
+ * Return: 0 on success, -errno on failure:
+ *	-enospc = insufficient buffer;
+ *	-enodev = unsupported for device;
+ *	-eperm = no permission for device, this error comes:
+ *		 - when there are affected devices that are opened but
+ *		   not bound to the same iommufd with the current device
+ *		   with which this ioctl is invoked,
+ *		 - there are affected devices that are not bound to vfio
+ *		   driver yet.
+ *		 - no valid iommufd is bound (e.g. noiommu mode)
+ */
+struct vfio_pci_hot_reset_group_info {
+	__u32	argsz;
+	__u32	flags;
+	__u32	count;
+	__u32	devices[];
+};
+
+#define VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO	_IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /**
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
-- 
2.34.1

