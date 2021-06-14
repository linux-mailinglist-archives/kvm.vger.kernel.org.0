Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9643A69CB
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhFNPLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhFNPLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:11:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5878C061574;
        Mon, 14 Jun 2021 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3Mri42DO3IIul1TDiKSrNcOZQmcpZst0/83S9YX/fuQ=; b=TcU7jIo0jjLWnPCQnPtFKArioS
        YgtefNvtFOXvN5dIij0RfEYafpmhjTRsbTiZUb1RxYgT8I7J/B43b1gb/li0ynYJZwy0vbrdYBHGM
        Z1gNhzUqT0nBMPFKSH8CgLyCmyn9D8ZbJegm2ZZtxPFIjjDsbD2U7jJAE3cNJ6Jq5F5pwAKRCeAh7
        XFiLj4vSwdq5HzCE1GiaupbgkGMvpNFDLXrS14V9VL3iEqYe6lyKH/gjosdcS1IuwgpsV37/JIXfZ
        Wt14sH9cL+x+GpqkR2x4VhgE8AkRUEVZj13g1PXOgqxRWv0iuMQZ6OQ6dfqhZDNmOr2ognYQ/7/2O
        wDYCNRHw==;
Received: from [2001:4bb8:19b:fdce:4b1a:b4aa:22d8:1629] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lsoDH-00Efpl-6Z; Mon, 14 Jun 2021 15:09:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 09/10] vfio/mdpy: Convert to use vfio_register_group_dev()
Date:   Mon, 14 Jun 2021 17:08:45 +0200
Message-Id: <20210614150846.4111871-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210614150846.4111871-1-hch@lst.de>
References: <20210614150846.4111871-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 samples/vfio-mdev/mdpy.c | 159 ++++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 71 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index e889c1cf8fd1..7e9c9df0f05b 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -85,9 +85,11 @@ static struct class	*mdpy_class;
 static struct cdev	mdpy_cdev;
 static struct device	mdpy_dev;
 static u32		mdpy_count;
+static const struct vfio_device_ops mdpy_dev_ops;
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	u8 *vconfig;
 	u32 bar_mask;
 	struct mutex ops_lock;
@@ -162,11 +164,9 @@ static void handle_pci_cfg_write(struct mdev_state *mdev_state, u16 offset,
 	}
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
-			   loff_t pos, bool is_write)
+static ssize_t mdev_access(struct mdev_state *mdev_state, char *buf,
+			   size_t count, loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
 	int ret = 0;
 
 	mutex_lock(&mdev_state->ops_lock);
@@ -187,8 +187,9 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 			memcpy(buf, mdev_state->memblk, count);
 
 	} else {
-		dev_info(dev, "%s: %s @0x%llx (unhandled)\n",
-			 __func__, is_write ? "WR" : "RD", pos);
+		dev_info(mdev_state->vdev.dev,
+			 "%s: %s @0x%llx (unhandled)\n", __func__,
+			 is_write ? "WR" : "RD", pos);
 		ret = -1;
 		goto accessfailed;
 	}
@@ -202,9 +203,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 	return ret;
 }
 
-static int mdpy_reset(struct mdev_device *mdev)
+static int mdpy_reset(struct mdev_state *mdev_state)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
 	u32 stride, i;
 
 	/* initialize with gray gradient */
@@ -216,13 +216,14 @@ static int mdpy_reset(struct mdev_device *mdev)
 	return 0;
 }
 
-static int mdpy_create(struct mdev_device *mdev)
+static int mdpy_probe(struct mdev_device *mdev)
 {
 	const struct mdpy_type *type =
 		&mdpy_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	u32 fbsize;
+	int ret;
 
 	if (mdpy_count >= max_devices)
 		return -ENOMEM;
@@ -230,6 +231,7 @@ static int mdpy_create(struct mdev_device *mdev)
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mdpy_dev_ops);
 
 	mdev_state->vconfig = kzalloc(MDPY_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (mdev_state->vconfig == NULL) {
@@ -250,36 +252,41 @@ static int mdpy_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
-
 	mdev_state->type    = type;
 	mdev_state->memsize = fbsize;
 	mdpy_create_config_space(mdev_state);
-	mdpy_reset(mdev);
+	mdpy_reset(mdev_state);
 
 	mdpy_count++;
+
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret) {
+		kfree(mdev_state);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 }
 
-static int mdpy_remove(struct mdev_device *mdev)
+static void mdpy_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
-	dev_info(dev, "%s\n", __func__);
+	dev_info(&mdev->dev, "%s\n", __func__);
 
-	mdev_set_drvdata(mdev, NULL);
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	vfree(mdev_state->memblk);
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
 
 	mdpy_count--;
-	return 0;
 }
 
-static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mdpy_read(struct vfio_device *vdev, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -289,8 +296,8 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (char *)&val, sizeof(val),
-					   *ppos, false);
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
+					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
 
@@ -301,7 +308,7 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -313,7 +320,7 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -336,9 +343,11 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mdpy_write(struct vfio_device *vdev, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -351,7 +360,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -363,7 +372,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -375,7 +384,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -393,9 +402,10 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 	return -EFAULT;
 }
 
-static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+static int mdpy_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	if (vma->vm_pgoff != MDPY_MEMORY_BAR_OFFSET >> PAGE_SHIFT)
 		return -EINVAL;
@@ -409,16 +419,10 @@ static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
 	return remap_vmalloc_range(vma, mdev_state->memblk, 0);
 }
 
-static int mdpy_get_region_info(struct mdev_device *mdev,
+static int mdpy_get_region_info(struct mdev_state *mdev_state,
 				struct vfio_region_info *region_info,
 				u16 *cap_type_id, void **cap_type)
 {
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	if (region_info->index >= VFIO_PCI_NUM_REGIONS &&
 	    region_info->index != MDPY_DISPLAY_REGION)
 		return -EINVAL;
@@ -447,15 +451,13 @@ static int mdpy_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mdpy_get_irq_info(struct mdev_device *mdev,
-			     struct vfio_irq_info *irq_info)
+static int mdpy_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	irq_info->count = 0;
 	return 0;
 }
 
-static int mdpy_get_device_info(struct mdev_device *mdev,
-				struct vfio_device_info *dev_info)
+static int mdpy_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = VFIO_PCI_NUM_REGIONS;
@@ -463,11 +465,9 @@ static int mdpy_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mdpy_query_gfx_plane(struct mdev_device *mdev,
+static int mdpy_query_gfx_plane(struct mdev_state *mdev_state,
 				struct vfio_device_gfx_plane_info *plane)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-
 	if (plane->flags & VFIO_GFX_PLANE_TYPE_PROBE) {
 		if (plane->flags == (VFIO_GFX_PLANE_TYPE_PROBE |
 				     VFIO_GFX_PLANE_TYPE_REGION))
@@ -496,14 +496,13 @@ static int mdpy_query_gfx_plane(struct mdev_device *mdev,
 	return 0;
 }
 
-static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
+static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 		       unsigned long arg)
 {
 	int ret = 0;
 	unsigned long minsz;
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
@@ -518,7 +517,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_device_info(mdev, &info);
+		ret = mdpy_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -543,7 +542,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_region_info(mdev, &info, &cap_type_id,
+		ret = mdpy_get_region_info(mdev_state, &info, &cap_type_id,
 					   &cap_type);
 		if (ret)
 			return ret;
@@ -567,7 +566,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= mdev_state->dev_info.num_irqs))
 			return -EINVAL;
 
-		ret = mdpy_get_irq_info(mdev, &info);
+		ret = mdpy_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -590,7 +589,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_query_gfx_plane(mdev, &plane);
+		ret = mdpy_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
@@ -604,12 +603,12 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		return -EINVAL;
 
 	case VFIO_DEVICE_RESET:
-		return mdpy_reset(mdev);
+		return mdpy_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mdpy_open(struct mdev_device *mdev)
+static int mdpy_open(struct vfio_device *vdev)
 {
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
@@ -617,7 +616,7 @@ static int mdpy_open(struct mdev_device *mdev)
 	return 0;
 }
 
-static void mdpy_close(struct mdev_device *mdev)
+static void mdpy_close(struct vfio_device *vdev)
 {
 	module_put(THIS_MODULE);
 }
@@ -626,8 +625,7 @@ static ssize_t
 resolution_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%dx%d\n",
 		       mdev_state->type->width,
@@ -716,18 +714,30 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mdpy_dev_ops = {
+	.open = mdpy_open,
+	.release = mdpy_close,
+	.read = mdpy_read,
+	.write = mdpy_write,
+	.ioctl = mdpy_ioctl,
+	.mmap = mdpy_mmap,
+};
+
+static struct mdev_driver mdpy_driver = {
+	.driver = {
+		.name = "mdpy",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mdpy_probe,
+	.remove	= mdpy_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
+	.device_driver          = &mdpy_driver,
 	.supported_type_groups	= mdev_type_groups,
-	.create			= mdpy_create,
-	.remove			= mdpy_remove,
-	.open			= mdpy_open,
-	.release		= mdpy_close,
-	.read			= mdpy_read,
-	.write			= mdpy_write,
-	.ioctl			= mdpy_ioctl,
-	.mmap			= mdpy_mmap,
 };
 
 static const struct file_operations vd_fops = {
@@ -752,11 +762,15 @@ static int __init mdpy_dev_init(void)
 	cdev_add(&mdpy_cdev, mdpy_devt, MINORMASK + 1);
 	pr_info("%s: major %d\n", __func__, MAJOR(mdpy_devt));
 
+	ret = mdev_register_driver(&mdpy_driver);
+	if (ret)
+		goto err_cdev;
+
 	mdpy_class = class_create(THIS_MODULE, MDPY_CLASS_NAME);
 	if (IS_ERR(mdpy_class)) {
 		pr_err("Error: failed to register mdpy_dev class\n");
 		ret = PTR_ERR(mdpy_class);
-		goto failed1;
+		goto err_driver;
 	}
 	mdpy_dev.class = mdpy_class;
 	mdpy_dev.release = mdpy_device_release;
@@ -764,19 +778,21 @@ static int __init mdpy_dev_init(void)
 
 	ret = device_register(&mdpy_dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mdpy_dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	return 0;
 
-failed3:
+err_device:
 	device_unregister(&mdpy_dev);
-failed2:
+err_class:
 	class_destroy(mdpy_class);
-failed1:
+err_driver:
+	mdev_unregister_driver(&mdpy_driver);
+err_cdev:
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
 	return ret;
@@ -788,6 +804,7 @@ static void __exit mdpy_dev_exit(void)
 	mdev_unregister_device(&mdpy_dev);
 
 	device_unregister(&mdpy_dev);
+	mdev_unregister_driver(&mdpy_driver);
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
 	class_destroy(mdpy_class);
-- 
2.30.2

