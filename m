Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17422C2B29
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732602AbfJAACm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:02:42 -0400
Received: from alpha.anastas.io ([104.248.188.109]:43679 "EHLO
        alpha.anastas.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbfJAACl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:02:41 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2019 20:02:41 EDT
Received: from authenticated-user (alpha.anastas.io [104.248.188.109])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by alpha.anastas.io (Postfix) with ESMTPSA id 4DF007EC07;
        Mon, 30 Sep 2019 18:55:38 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=anastas.io; s=mail;
        t=1569887738; bh=GvYnlsVesAiHYZjV5MlMJU5gT3BJ0Z4zlCV8vKR/330=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbgLREB6VqsLgBZVYrrRbDB8dqvHqEVbohhxLHGdpXiKy7xmgJ7dYKjhrpPDshxwj
         NNi4ckbEH3FPuadXledXEVqwgtwiF3dRWwg5ppZ11xPIFSEmIIKhSSbXAH9yQcj/sq
         Y64Fan3kM2po/YBAhkLf+//HyyRZUOK/jSgsF0cqFHvqIuIS6APLnYn9COFmB5lKCY
         10PjVWi5LtD5ObLOHvMQaAEH/GqF3QjvRHrSDHvziY/R0JbGSw2AF4VLmUvICiRG9h
         DUKbWHDpDqe+RSP8ivpm4jYtytt2QisgTtmHaw+x3Roc2kv2VijPfP3XLOP7Qjoxtq
         oa51vKIsTo0gA==
From:   Shawn Anastasio <shawn@anastas.io>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/1] vfio/pci: Introduce region file descriptors
Date:   Mon, 30 Sep 2019 18:55:33 -0500
Message-Id: <20190930235533.2759-2-shawn@anastas.io>
In-Reply-To: <20190930235533.2759-1-shawn@anastas.io>
References: <20190930235533.2759-1-shawn@anastas.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new type of VFIO file descriptor that allows
memfd-style semantics for regions of a VFIO device.

Unlike VFIO device file descriptors, region file descriptors
are limited to a single region, and all offsets (read, etc.)
are relative to the start of the region.

This allows for finer granularity when sharing VFIO fds,
as applications can now choose to only share specific regions.

Signed-off-by: Shawn Anastasio <shawn@anastas.io>
---
 drivers/vfio/pci/vfio_pci.c         | 105 ++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |   5 ++
 include/uapi/linux/vfio.h           |  14 ++++
 3 files changed, 124 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 02206162eaa9..132ed245cd68 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -27,6 +27,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
+#include <linux/anon_inodes.h>
 
 #include "vfio_pci_private.h"
 
@@ -688,6 +689,9 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 	return 0;
 }
 
+
+static const struct file_operations vfio_region_fops;
+
 static long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
@@ -1137,6 +1141,54 @@ static long vfio_pci_ioctl(void *device_data,
 
 		return vfio_pci_ioeventfd(vdev, ioeventfd.offset,
 					  ioeventfd.data, count, ioeventfd.fd);
+	} else if (cmd == VFIO_DEVICE_GET_REGION_FD) {
+		struct pci_dev *pdev = vdev->pdev;
+		u32 index;
+		u32 len;
+		int ret;
+		struct file *filep;
+		struct vfio_pci_region_info *info;
+
+		if (copy_from_user(&index, (void __user *)arg, sizeof(u32)))
+			return -EFAULT;
+
+		/* Don't support non-BAR regions */
+		if (index > VFIO_PCI_BAR5_REGION_INDEX)
+			return -EINVAL;
+
+		len = pci_resource_len(pdev, index);
+		if (!len)
+			return -EINVAL;
+
+		if (!vdev->bar_mmap_supported[index])
+			return -EINVAL;
+
+		info = kzalloc(sizeof(*info), GFP_KERNEL);
+		if (!info)
+			return -ENOMEM;
+
+		info->index = index;
+		info->vdev = vdev;
+
+		ret = get_unused_fd_flags(O_CLOEXEC);
+		if (ret < 0) {
+			kfree(info);
+			return ret;
+		}
+
+		filep = anon_inode_getfile("[vfio-region]", &vfio_region_fops,
+					   info, O_RDWR);
+		if (IS_ERR(filep)) {
+			put_unused_fd(ret);
+			ret = PTR_ERR(filep);
+			kfree(info);
+			return ret;
+		}
+		filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
+
+		fd_install(ret, filep);
+
+		return ret;
 	}
 
 	return -ENOTTY;
@@ -1286,6 +1338,59 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.request	= vfio_pci_request,
 };
 
+static int vfio_region_fops_release(struct inode *inode, struct file *filep)
+{
+	kfree(filep->private_data);
+	return 0;
+}
+
+static ssize_t vfio_region_fops_read(struct file *filep, char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct vfio_pci_region_info *info = filep->private_data;
+
+	if (*ppos > VFIO_PCI_OFFSET_MASK)
+		return -EINVAL;
+
+	*ppos |= VFIO_PCI_INDEX_TO_OFFSET(info->index);
+
+	return vfio_pci_rw(info->vdev, buf, count, ppos, false);
+}
+
+static ssize_t vfio_region_fops_write(struct file *filep,
+				      const char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct vfio_pci_region_info *info = filep->private_data;
+
+	if (*ppos > VFIO_PCI_OFFSET_MASK)
+		return -EINVAL;
+
+	*ppos |= VFIO_PCI_INDEX_TO_OFFSET(info->index);
+
+	return vfio_pci_rw(info->vdev, (char __user *)buf, count, ppos, true);
+}
+
+static int vfio_region_fops_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	struct vfio_pci_region_info *info = filep->private_data;
+
+	if (vma->vm_pgoff > ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1))
+		return -EINVAL;
+
+	vma->vm_pgoff |= info->index << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
+	return vfio_pci_mmap(info->vdev, vma);
+}
+
+static const struct file_operations vfio_region_fops = {
+	.owner = THIS_MODULE,
+	.release = vfio_region_fops_release,
+	.read = vfio_region_fops_read,
+	.write = vfio_region_fops_write,
+	.mmap = vfio_region_fops_mmap
+};
+
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index ee6ee91718a4..318f42e9faa0 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -124,6 +124,11 @@ struct vfio_pci_device {
 	struct list_head	ioeventfds_list;
 };
 
+struct vfio_pci_region_info {
+	u32 index;
+	struct vfio_pci_device *vdev;
+};
+
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
 #define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
 #define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..9f9bafd41093 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -707,6 +707,20 @@ struct vfio_device_ioeventfd {
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_DEVICE_GET_REGION_FD - _IOW(VFIO_TYPE, VFIO_BASE + 17,
+ *				    __u32)
+ *
+ * Return a new file descriptor for the region specified by the provided
+ * index. The region must have a non-zero size and support mmap.
+ * The returned file descriptor may be used with standard read, write,
+ * and mmap operations. Provided offsets are relative to the region,
+ * unlike device file descriptors.
+ * Return: new file descriptor on success, -errno on failure.
+ */
+#define VFIO_DEVICE_GET_REGION_FD	_IO(VFIO_TYPE, VFIO_BASE + 17)
+
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.20.1

