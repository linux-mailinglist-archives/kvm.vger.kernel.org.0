Return-Path: <kvm+bounces-14412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 471768A292D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68D601C23308
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED6950A63;
	Fri, 12 Apr 2024 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fTUcuxxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA9F50269
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910087; cv=none; b=ThVzsbZS2odYCORMh7yGszaHrGJd3aLvMNt8qu+z2ma+JC4MalOde3kSi+NNClJW15h3GYK57cy7BXHRW8WKuUzFLUbr58kRb1gwBnwt2n9RskeE/ztkqVv0yqHXtc9kRmWLh4zA2emX/nAcmae6Y9X0dirsgn2j6lJgdduQZW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910087; c=relaxed/simple;
	bh=xpCf82BSZgekIxtUm+EvMiqfVBz/KGSVCuqTnIOiUsU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cZCrLYXkDDo+/2iMK1ZbQFugxDBh5G+EN+Wf/SW05IjMalid82ZN29VrV/PCdrX9kW9WeIZnPUhmpTePheeGm1Y3NqREccLPXscwwlBjJ4InnW37fiXZCBX6MFlldUHaSBwL73B2uavbfAmaktQx3KWCXlnBNMeFTsu05hN2uMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fTUcuxxV; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712910086; x=1744446086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xpCf82BSZgekIxtUm+EvMiqfVBz/KGSVCuqTnIOiUsU=;
  b=fTUcuxxVoJhRi7+cDdNeU5iTSqWHY4ALstiPVSb+Wwd2bRpIzq+BR4Pt
   2cMzlJHp582Go8laSUXlXQpHuzueIMJcTAI0vy3awuHHXqpVEulIRv5Nh
   zHI09YlwEVnnpRjdhoT6sU3Pq+KJzzt0Zi7ZMdeFOymRN2QA7bUqjFxhy
   WaMLK9iDs7vFYo7QtIPgIfc0QMqTXYK9yBnfyttq6MZXRtzw6l/4J1Bef
   kM3frQxX7lSMByRNCwELYUqLifQITn9LnpOHYNtmfeyRcszdFc1prZE8y
   +HNiPDj0TjhwlMUQc8MWyUsi+MDCugKFMMjvBe4fxB3dNMNQHlRwR5XTt
   w==;
X-CSE-ConnectionGUID: ZNOxSoT6TyC0Ab4lUQbE1A==
X-CSE-MsgGUID: BgDPoQrYQ3uqlFiMOXjB+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19069421"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="19069421"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:21:25 -0700
X-CSE-ConnectionGUID: lKW4bZxaSaylcWWgUV/TUA==
X-CSE-MsgGUID: udEdc46zQk2cMlLb4kLCPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="25836273"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa003.jf.intel.com with ESMTP; 12 Apr 2024 01:21:25 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: joro@8bytes.org,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 3/4] vfio: Add VFIO_DEVICE_PASID_[AT|DE]TACH_IOMMUFD_PT
Date: Fri, 12 Apr 2024 01:21:20 -0700
Message-Id: <20240412082121.33382-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412082121.33382-1-yi.l.liu@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds ioctls for the userspace to attach/detach a given pasid of a
vfio device to/from an IOAS/HWPT.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/device_cdev.c | 51 +++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h        |  4 +++
 drivers/vfio/vfio_main.c   |  8 ++++++
 include/uapi/linux/vfio.h  | 55 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index e75da0a70d1f..5326f1608ace 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -210,6 +210,57 @@ int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
 	return 0;
 }
 
+int vfio_df_ioctl_pasid_attach_pt(struct vfio_device_file *df,
+				  struct vfio_device_pasid_attach_iommufd_pt __user *arg)
+{
+	struct vfio_device_pasid_attach_iommufd_pt attach;
+	struct vfio_device *device = df->device;
+	unsigned long minsz;
+	int ret;
+
+	minsz = offsetofend(struct vfio_device_pasid_attach_iommufd_pt, pt_id);
+
+	if (copy_from_user(&attach, arg, minsz))
+		return -EFAULT;
+
+	if (attach.argsz < minsz || attach.flags)
+		return -EINVAL;
+
+	if (!device->ops->pasid_attach_ioas)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&device->dev_set->lock);
+	ret = device->ops->pasid_attach_ioas(device, attach.pasid, &attach.pt_id);
+	mutex_unlock(&device->dev_set->lock);
+
+	return ret;
+}
+
+int vfio_df_ioctl_pasid_detach_pt(struct vfio_device_file *df,
+				  struct vfio_device_pasid_detach_iommufd_pt __user *arg)
+{
+	struct vfio_device_pasid_detach_iommufd_pt detach;
+	struct vfio_device *device = df->device;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct vfio_device_pasid_detach_iommufd_pt, pasid);
+
+	if (copy_from_user(&detach, arg, minsz))
+		return -EFAULT;
+
+	if (detach.argsz < minsz || detach.flags)
+		return -EINVAL;
+
+	if (!device->ops->pasid_detach_ioas)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&device->dev_set->lock);
+	device->ops->pasid_detach_ioas(device, detach.pasid);
+	mutex_unlock(&device->dev_set->lock);
+
+	return 0;
+}
+
 static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..20d3cb283ba0 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -353,6 +353,10 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
 			    struct vfio_device_attach_iommufd_pt __user *arg);
 int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
 			    struct vfio_device_detach_iommufd_pt __user *arg);
+int vfio_df_ioctl_pasid_attach_pt(struct vfio_device_file *df,
+				  struct vfio_device_pasid_attach_iommufd_pt __user *arg);
+int vfio_df_ioctl_pasid_detach_pt(struct vfio_device_file *df,
+				  struct vfio_device_pasid_detach_iommufd_pt __user *arg);
 
 #if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
 void vfio_init_device_cdev(struct vfio_device *device);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e97d796a54fb..a5cece9fff5e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1242,6 +1242,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 		case VFIO_DEVICE_DETACH_IOMMUFD_PT:
 			ret = vfio_df_ioctl_detach_pt(df, uptr);
 			goto out;
+
+		case VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT:
+			ret = vfio_df_ioctl_pasid_attach_pt(df, uptr);
+			goto out;
+
+		case VFIO_DEVICE_PASID_DETACH_IOMMUFD_PT:
+			ret = vfio_df_ioctl_pasid_detach_pt(df, uptr);
+			goto out;
 		}
 	}
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf190..9591dc24b75c 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -977,6 +977,61 @@ struct vfio_device_detach_iommufd_pt {
 
 #define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)
 
+/*
+ * VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 21,
+ *					      struct vfio_device_pasid_attach_iommufd_pt)
+ * @argsz:	User filled size of this data.
+ * @flags:	Must be 0.
+ * @pasid:	The pasid to be attached.
+ * @pt_id:	Input the target id which can represent an ioas or a hwpt
+ *		allocated via iommufd subsystem.
+ *		Output the input ioas id or the attached hwpt id which could
+ *		be the specified hwpt itself or a hwpt automatically created
+ *		for the specified ioas by kernel during the attachment.
+ *
+ * Associate a pasid (of a cdev device) with an address space within the
+ * bound iommufd. Undo by VFIO_DEVICE_PASID_DETACH_IOMMUFD_PT or device fd
+ * close. This is only allowed on cdev fds.
+ *
+ * If a pasid is currently attached to a valid hw_pagetable (hwpt), without
+ * doing a VFIO_DEVICE_PASID_DETACH_IOMMUFD_PT, a second
+ * VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT ioctl passing in another hwpt id is
+ * allowed. This action, also known as a hwpt replacement, will replace the
+ * pasid's currently attached hwpt with a new hwpt corresponding to the given
+ * @pt_id.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_pasid_attach_iommufd_pt {
+	__u32	argsz;
+	__u32	flags;
+	__u32	pasid;
+	__u32	pt_id;
+};
+
+#define VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT	_IO(VFIO_TYPE, VFIO_BASE + 21)
+
+/*
+ * VFIO_DEVICE_PASID_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 22,
+ *					      struct vfio_device_pasid_detach_iommufd_pt)
+ * @argsz:	User filled size of this data.
+ * @flags:	Must be 0.
+ * @pasid:	The pasid to be detached.
+ *
+ * Remove the association of a pasid (of a cdev device) and its current
+ * associated address space.  After it, the pasid of the device should be
+ * in a blocking DMA state.  This is only allowed on cdev fds.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_device_pasid_detach_iommufd_pt {
+	__u32	argsz;
+	__u32	flags;
+	__u32	pasid;
+};
+
+#define VFIO_DEVICE_PASID_DETACH_IOMMUFD_PT	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
 /*
  * Provide support for setting a PCI VF Token, which is used as a shared
  * secret between PF and VF drivers.  This feature may only be set on a
-- 
2.34.1


