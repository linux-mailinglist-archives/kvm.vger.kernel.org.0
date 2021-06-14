Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692C03A69C8
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhFNPLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbhFNPL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:11:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3724C061574;
        Mon, 14 Jun 2021 08:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ETEU8kUUE0w2DoQrTzPUyzMa+AH9G9CR5Kmc0kFwWkc=; b=tj7XwvsrGLLjguCFL2eFQbZcAi
        3TYZclIKH5pffHoQ0sAGXBPReYPzfg8PVDubK6EjDpTMfnlpq8zmKSnAenr5mrfvnBHQmH9Hdhx0a
        F7NjBgwlt+InnpbrwOHDGi0dJ2JVQH7HXUEV8pWBAHmNKBWxJhWb32uqVSq+J6Dnews5J0XHVHHCO
        363u7+x1GjOwEFY2v1vCzVgW5VyQiThRUObL6T2z7pnVTD45GBYw/d22oSgdcc4DHj094AnXQuSnl
        4heHNZRrwk+WN8FeqG3Lmh+QBheDZnw1Er5rA+0PWlOnAatSPxB2iS+JCPrPAKm34dtmmcp6oSqtp
        AnybX8Mw==;
Received: from [2001:4bb8:19b:fdce:4b1a:b4aa:22d8:1629] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lsoDD-00EfoL-RC; Mon, 14 Jun 2021 15:09:16 +0000
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
Subject: [PATCH 08/10] vfio/mtty: Convert to use vfio_register_group_dev()
Date:   Mon, 14 Jun 2021 17:08:44 +0200
Message-Id: <20210614150846.4111871-9-hch@lst.de>
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
wonky dead code with a simple container_of()

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 samples/vfio-mdev/mtty.c | 185 ++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 102 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index b9b24be4abda..d2a168420b77 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -127,6 +127,7 @@ struct serial_port {
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	int irq_fd;
 	struct eventfd_ctx *intx_evtfd;
 	struct eventfd_ctx *msi_evtfd;
@@ -150,6 +151,8 @@ static const struct file_operations vd_fops = {
 	.owner          = THIS_MODULE,
 };
 
+static const struct vfio_device_ops mtty_dev_ops;
+
 /* function prototypes */
 
 static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
@@ -631,22 +634,15 @@ static void mdev_read_base(struct mdev_state *mdev_state)
 	}
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
+static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
 			   loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state;
 	unsigned int index;
 	loff_t offset;
 	int ret = 0;
 
-	if (!mdev || !buf)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state) {
-		pr_err("%s mdev_state not found\n", __func__);
+	if (!buf)
 		return -EINVAL;
-	}
 
 	mutex_lock(&mdev_state->ops_lock);
 
@@ -708,15 +704,18 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
 	return ret;
 }
 
-static int mtty_create(struct mdev_device *mdev)
+static int mtty_probe(struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state;
 	int nr_ports = mdev_get_type_group_id(mdev) + 1;
+	int ret;
 
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
 
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
+
 	mdev_state->nr_ports = nr_ports;
 	mdev_state->irq_index = -1;
 	mdev_state->s[0].max_fifo_size = MAX_FIFO_SIZE;
@@ -731,7 +730,6 @@ static int mtty_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
 
 	mtty_create_config_space(mdev_state);
 
@@ -739,50 +737,40 @@ static int mtty_create(struct mdev_device *mdev)
 	list_add(&mdev_state->next, &mdev_devices_list);
 	mutex_unlock(&mdev_list_lock);
 
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret) {
+		kfree(mdev_state);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 }
 
-static int mtty_remove(struct mdev_device *mdev)
+static void mtty_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mds, *tmp_mds;
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	int ret = -EINVAL;
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	mutex_lock(&mdev_list_lock);
-	list_for_each_entry_safe(mds, tmp_mds, &mdev_devices_list, next) {
-		if (mdev_state == mds) {
-			list_del(&mdev_state->next);
-			mdev_set_drvdata(mdev, NULL);
-			kfree(mdev_state->vconfig);
-			kfree(mdev_state);
-			ret = 0;
-			break;
-		}
-	}
+	list_del(&mdev_state->next);
 	mutex_unlock(&mdev_list_lock);
 
-	return ret;
+	kfree(mdev_state->vconfig);
+	kfree(mdev_state);
 }
 
-static int mtty_reset(struct mdev_device *mdev)
+static int mtty_reset(struct mdev_state *mdev_stte)
 {
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	pr_info("%s: called\n", __func__);
 
 	return 0;
 }
 
-static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mtty_read(struct vfio_device *vdev, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -792,7 +780,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret =  mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					   *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -804,7 +792,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -816,7 +804,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -839,9 +827,11 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mtty_write(struct vfio_device *vdev, const char __user *buf,
 		   size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -854,7 +844,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -866,7 +856,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -878,7 +868,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -896,19 +886,11 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 	return -EFAULT;
 }
 
-static int mtty_set_irqs(struct mdev_device *mdev, uint32_t flags,
+static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 			 unsigned int index, unsigned int start,
 			 unsigned int count, void *data)
 {
 	int ret = 0;
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
 
 	mutex_lock(&mdev_state->ops_lock);
 	switch (index) {
@@ -1024,21 +1006,13 @@ static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
 	return ret;
 }
 
-static int mtty_get_region_info(struct mdev_device *mdev,
+static int mtty_get_region_info(struct mdev_state *mdev_state,
 			 struct vfio_region_info *region_info,
 			 u16 *cap_type_id, void **cap_type)
 {
 	unsigned int size = 0;
-	struct mdev_state *mdev_state;
 	u32 bar_index;
 
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	bar_index = region_info->index;
 	if (bar_index >= VFIO_PCI_NUM_REGIONS)
 		return -EINVAL;
@@ -1073,8 +1047,7 @@ static int mtty_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mtty_get_irq_info(struct mdev_device *mdev,
-			     struct vfio_irq_info *irq_info)
+static int mtty_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	switch (irq_info->index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
@@ -1098,8 +1071,7 @@ static int mtty_get_irq_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mtty_get_device_info(struct mdev_device *mdev,
-			 struct vfio_device_info *dev_info)
+static int mtty_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = VFIO_PCI_NUM_REGIONS;
@@ -1108,19 +1080,13 @@ static int mtty_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
+static long mtty_ioctl(struct vfio_device *vdev, unsigned int cmd,
 			unsigned long arg)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	int ret = 0;
 	unsigned long minsz;
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -ENODEV;
 
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
@@ -1135,7 +1101,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mtty_get_device_info(mdev, &info);
+		ret = mtty_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -1160,7 +1126,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mtty_get_region_info(mdev, &info, &cap_type_id,
+		ret = mtty_get_region_info(mdev_state, &info, &cap_type_id,
 					   &cap_type);
 		if (ret)
 			return ret;
@@ -1184,7 +1150,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= mdev_state->dev_info.num_irqs))
 			return -EINVAL;
 
-		ret = mtty_get_irq_info(mdev, &info);
+		ret = mtty_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -1218,25 +1184,25 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 				return PTR_ERR(data);
 		}
 
-		ret = mtty_set_irqs(mdev, hdr.flags, hdr.index, hdr.start,
+		ret = mtty_set_irqs(mdev_state, hdr.flags, hdr.index, hdr.start,
 				    hdr.count, data);
 
 		kfree(ptr);
 		return ret;
 	}
 	case VFIO_DEVICE_RESET:
-		return mtty_reset(mdev);
+		return mtty_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mtty_open(struct mdev_device *mdev)
+static int mtty_open(struct vfio_device *vdev)
 {
 	pr_info("%s\n", __func__);
 	return 0;
 }
 
-static void mtty_close(struct mdev_device *mdev)
+static void mtty_close(struct vfio_device *mdev)
 {
 	pr_info("%s\n", __func__);
 }
@@ -1351,18 +1317,31 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mtty_dev_ops = {
+	.name = "vfio-mdev",
+	.open = mtty_open,
+	.release = mtty_close,
+	.read = mtty_read,
+	.write = mtty_write,
+	.ioctl = mtty_ioctl,
+};
+
+static struct mdev_driver mtty_driver = {
+	.driver = {
+		.name = "mtty",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mtty_probe,
+	.remove	= mtty_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
+	.device_driver		= &mtty_driver,
 	.dev_attr_groups        = mtty_dev_groups,
-	.mdev_attr_groups       = mdev_dev_groups,
 	.supported_type_groups  = mdev_type_groups,
-	.create                 = mtty_create,
-	.remove			= mtty_remove,
-	.open                   = mtty_open,
-	.release                = mtty_close,
-	.read                   = mtty_read,
-	.write                  = mtty_write,
-	.ioctl		        = mtty_ioctl,
 };
 
 static void mtty_device_release(struct device *dev)
@@ -1393,12 +1372,16 @@ static int __init mtty_dev_init(void)
 
 	pr_info("major_number:%d\n", MAJOR(mtty_dev.vd_devt));
 
+	ret = mdev_register_driver(&mtty_driver);
+	if (ret)
+		goto err_cdev;
+
 	mtty_dev.vd_class = class_create(THIS_MODULE, MTTY_CLASS_NAME);
 
 	if (IS_ERR(mtty_dev.vd_class)) {
 		pr_err("Error: failed to register mtty_dev class\n");
 		ret = PTR_ERR(mtty_dev.vd_class);
-		goto failed1;
+		goto err_driver;
 	}
 
 	mtty_dev.dev.class = mtty_dev.vd_class;
@@ -1407,28 +1390,25 @@ static int __init mtty_dev_init(void)
 
 	ret = device_register(&mtty_dev.dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mtty_dev.dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	mutex_init(&mdev_list_lock);
 	INIT_LIST_HEAD(&mdev_devices_list);
+	return 0;
 
-	goto all_done;
-
-failed3:
-
+err_device:
 	device_unregister(&mtty_dev.dev);
-failed2:
+err_class:
 	class_destroy(mtty_dev.vd_class);
-
-failed1:
+err_driver:
+	mdev_unregister_driver(&mtty_driver);
+err_cdev:
 	cdev_del(&mtty_dev.vd_cdev);
 	unregister_chrdev_region(mtty_dev.vd_devt, MINORMASK + 1);
-
-all_done:
 	return ret;
 }
 
@@ -1439,6 +1419,7 @@ static void __exit mtty_dev_exit(void)
 
 	device_unregister(&mtty_dev.dev);
 	idr_destroy(&mtty_dev.vd_idr);
+	mdev_unregister_driver(&mtty_driver);
 	cdev_del(&mtty_dev.vd_cdev);
 	unregister_chrdev_region(mtty_dev.vd_devt, MINORMASK + 1);
 	class_destroy(mtty_dev.vd_class);
-- 
2.30.2

