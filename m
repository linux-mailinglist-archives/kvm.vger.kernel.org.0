Return-Path: <kvm+bounces-19767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB9990AA78
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 11:59:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AB18B38F1C
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 09:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DC8195978;
	Mon, 17 Jun 2024 09:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WsnOHV36"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB17194096;
	Mon, 17 Jun 2024 09:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718618080; cv=none; b=pgoLIaZ5JoGbq39GZ3+i5gcsjB53uk7geExJj664/rMf5m9mzcvFehUN4DNt0/203YTYfitKHDXtRB1ELhCwotcapP6vHCw6H3N5Nh40mGD/eMs0Gqya4ykGkoOaDIjneHn8TCYtdfubvY0ZYLm4QTH1e53SX2WYfvWpMtyy87Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718618080; c=relaxed/simple;
	bh=xBfj/K3M+SedkAwUcxBhbpFskjJE7BDhG4PBaIjvd/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M/hWkablxu2e2OjWDxkjsxoRjAFAZVwZ1d4k3rQUH2soMHYtJ/IwGGkn68FimFItGyxrdigsnBx7DqEQz1/9oWRb9ddcfAOuX/AEpzev7kwL2jo+dpejYClQFte9KhOWvwRLGR60uKTlmC2oimgXFWxtiV5GPEiCbYDYoubYdUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WsnOHV36; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718618079; x=1750154079;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xBfj/K3M+SedkAwUcxBhbpFskjJE7BDhG4PBaIjvd/M=;
  b=WsnOHV365NKSKFS919Ndih2hnLUBQzBeWoEsLfcIGtI4KomsoPCNl377
   PakFvvHPXZg0tWFL7yQMa1CgwlPQ6VSSRMMVcPMzGMw8X2U3KB7SC1uoZ
   p94NsmD3z9vw3InzPmjRnQ9iFnfaM7UgXNgM4WdA3C8dL9hxmQCdX5bH5
   t1Gc6AN//qBM5g32LOJDJr+LNjzOiro4ESi4LJdYbow58+TJpVyLBjA8m
   I8DYl0nz/orfZRZHKVPK82CO8WBLIpWfx38pInHO1mQ7aIJb/ln2iEw7i
   JxJnEDkTBxX+SvG/K3X0cV8Mj2YkYGToyH+Fg8B1XaBxqPBoXRsR9qtLw
   w==;
X-CSE-ConnectionGUID: kfgdLyAtTuqr1lI2X4Acmg==
X-CSE-MsgGUID: n3hnBKq0Qx2FZ6AbdDsxoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="15590064"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="15590064"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 02:54:38 -0700
X-CSE-ConnectionGUID: 6wrX0QQhSgWvIRrrUveZ8w==
X-CSE-MsgGUID: X2H9n8KxQEeEOu7u05ixyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="45514313"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 02:54:36 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	kevin.tian@intel.com,
	jgg@nvidia.com,
	peterx@redhat.com,
	ajones@ventanamicro.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio: Reuse file f_inode as vfio device inode
Date: Mon, 17 Jun 2024 17:53:32 +0800
Message-ID: <20240617095332.30543-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reuse file f_inode as vfio device inode and associate pseudo path file
directly to inode allocated in vfio fs.

Currently, vfio device is opened via 2 ways:
1) via cdev open
   vfio device is opened with a cdev device with file f_inode and address
   space associated with a cdev inode;
2) via VFIO_GROUP_GET_DEVICE_FD ioctl
   vfio device is opened via a pseudo path file with file f_inode and
   address space associated with an inode in anon_inode_fs.

In commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per device"),
an inode in vfio fs is allocated for each vfio device. However, this inode
in vfio fs is only used to assign its address space to that of a file
associated with another cdev inode or an inode in anon_inode_fs.

This patch
- reuses cdev device inode as the vfio device inode when it's opened via
  cdev way;
- allocates an inode in vfio fs, associate it to the pseudo path file,
  and save it as the vfio device inode when the vfio device is opened via
  VFIO_GROUP_GET_DEVICE_FD ioctl.

File address space will then point automatically to the address space of
the vfio device inode. Tools like unmap_mapping_range() can then zap all
vmas associated with the vfio device.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/device_cdev.c |  9 ++++---
 drivers/vfio/group.c       | 21 ++--------------
 drivers/vfio/vfio.h        |  2 ++
 drivers/vfio/vfio_main.c   | 49 +++++++++++++++++++++++++++-----------
 4 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..a4eec8e88f5c 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	filep->private_data = df;
 
 	/*
-	 * Use the pseudo fs inode on the device to link all mmaps
-	 * to the same address space, allowing us to unmap all vmas
-	 * associated to this device using unmap_mapping_range().
+	 * mmaps are linked to the address space of the inode of device cdev.
+	 * Save the inode of device cdev in device->inode to allow
+	 * unmap_mapping_range() to unmap all vmas.
 	 */
-	filep->f_mapping = device->inode->i_mapping;
-
+	device->inode = inode;
 	return 0;
 
 err_put_registration:
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index ded364588d29..aaef188003b6 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -268,31 +268,14 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
 	if (ret)
 		goto err_free;
 
-	/*
-	 * We can't use anon_inode_getfd() because we need to modify
-	 * the f_mode flags directly to allow more than just ioctls
-	 */
-	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
-				   df, O_RDWR);
+	filep = vfio_device_get_pseudo_file(device);
 	if (IS_ERR(filep)) {
 		ret = PTR_ERR(filep);
 		goto err_close_device;
 	}
-
-	/*
-	 * TODO: add an anon_inode interface to do this.
-	 * Appears to be missing by lack of need rather than
-	 * explicitly prevented.  Now there's need.
-	 */
+	filep->private_data = df;
 	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
 
-	/*
-	 * Use the pseudo fs inode on the device to link all mmaps
-	 * to the same address space, allowing us to unmap all vmas
-	 * associated to this device using unmap_mapping_range().
-	 */
-	filep->f_mapping = device->inode->i_mapping;
-
 	if (device->group->type == VFIO_NO_IOMMU)
 		dev_warn(device->dev, "vfio-noiommu device opened by user "
 			 "(%s:%d)\n", current->comm, task_pid_nr(current));
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..1f8915f79fbb 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -35,6 +35,7 @@ struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device);
 
 extern const struct file_operations vfio_device_fops;
+struct file *vfio_device_get_pseudo_file(struct vfio_device *device);
 
 #ifdef CONFIG_VFIO_NOIOMMU
 extern bool vfio_noiommu __read_mostly;
@@ -420,6 +421,7 @@ static inline void vfio_cdev_cleanup(void)
 {
 }
 #endif /* CONFIG_VFIO_DEVICE_CDEV */
+struct file *vfio_device_get_pseduo_file(struct vfio_device *device);
 
 #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
 int __init vfio_virqfd_init(void);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a5a62d9d963f..e81d0f910c70 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -192,7 +192,6 @@ static void vfio_device_release(struct device *dev)
 	if (device->ops->release)
 		device->ops->release(device);
 
-	iput(device->inode);
 	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
 	kvfree(device);
 }
@@ -248,20 +247,50 @@ static struct file_system_type vfio_fs_type = {
 	.kill_sb = kill_anon_super,
 };
 
-static struct inode *vfio_fs_inode_new(void)
+/*
+ * Alloc pseudo file from inode associated of vfio.vfs_mount.
+ * This is called when vfio device is opened via pseudo file.
+ * mmaps are linked to the address space of the inode of the pseudo file.
+ * Save the inode in device->inode for unmap_mapping_range() to unmap all vmas.
+ */
+struct file *vfio_device_get_pseudo_file(struct vfio_device *device)
 {
+	const struct file_operations *fops = &vfio_device_fops;
 	struct inode *inode;
+	struct file *filep;
 	int ret;
 
+	if (!fops_get(fops))
+		return ERR_PTR(-ENODEV);
+
 	ret = simple_pin_fs(&vfio_fs_type, &vfio.vfs_mount, &vfio.fs_count);
 	if (ret)
-		return ERR_PTR(ret);
+		goto err_pin_fs;
 
 	inode = alloc_anon_inode(vfio.vfs_mount->mnt_sb);
-	if (IS_ERR(inode))
-		simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto err_inode;
+	}
+
+	filep = alloc_file_pseudo(inode, vfio.vfs_mount, "[vfio-device]",
+				  O_RDWR, fops);
+
+	if (IS_ERR(filep)) {
+		ret = PTR_ERR(filep);
+		goto err_file;
+	}
+	device->inode = inode;
+	return filep;
+
+err_file:
+	iput(inode);
+err_inode:
+	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
+err_pin_fs:
+	fops_put(fops);
 
-	return inode;
+	return ERR_PTR(ret);
 }
 
 /*
@@ -282,11 +311,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
 	init_completion(&device->comp);
 	device->dev = dev;
 	device->ops = ops;
-	device->inode = vfio_fs_inode_new();
-	if (IS_ERR(device->inode)) {
-		ret = PTR_ERR(device->inode);
-		goto out_inode;
-	}
 
 	if (ops->init) {
 		ret = ops->init(device);
@@ -301,9 +325,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
 	return 0;
 
 out_uninit:
-	iput(device->inode);
-	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
-out_inode:
 	vfio_release_device_set(device);
 	ida_free(&vfio.device_ida, device->index);
 	return ret;

base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f
-- 
2.43.2


