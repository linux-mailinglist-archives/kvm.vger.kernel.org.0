Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6129B3F612F
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbhHXO7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbhHXO7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 10:59:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05289C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9lpI5uac6WXoWkoMwpJNgbiZbEJb/hCKRRsSIiDv8Fc=; b=Dnxdee1T5xrLlyUqyc/+zdkLrb
        NQxWXBAXeTcfonWSvYa5Xf2BjnJYS817toZPpJ4g5lMqqwI371LBxKdPD0Y4gg//MeDuy3K1RgEMp
        XpZarCRiNOm+BIyvVYTRod6sPx2GJ6Px76MyDLTKfobJCd6FHPaxnqjZkTM4ihoalzvvbPSFsj0cw
        c1QFrf/Oj260UJrgIo5sifcnbYF0Ow5oEz1C4GYbTA5sX6tpT3600ikZKIUBzU0XkeZ7+Hk+2T436
        iCE7I8vXKk2GljMviOAXmStop5wdDbpq+QJTvkW+xjDVdljb8Oy0EJnuQBKheLm4YdmcEn+ra0hTZ
        PzmW3J1A==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXqk-00BCQo-Ar; Tue, 24 Aug 2021 14:56:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 08/14] vfio: remove unused method from vfio_iommu_driver_ops
Date:   Tue, 24 Aug 2021 16:46:43 +0200
Message-Id: <20210824144649.1488190-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824144649.1488190-1-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The read, write and mmap methods are never implemented, so remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio.c  | 50 --------------------------------------------
 include/linux/vfio.h |  5 -----
 2 files changed, 55 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 45987dc897179e..34621e0044e8b4 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1247,62 +1247,12 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
-/*
- * Once an iommu driver is set, we optionally pass read/write/mmap
- * on to the driver, allowing management interfaces beyond ioctl.
- */
-static ssize_t vfio_fops_read(struct file *filep, char __user *buf,
-			      size_t count, loff_t *ppos)
-{
-	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver;
-	ssize_t ret = -EINVAL;
-
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->read))
-		ret = driver->ops->read(container->iommu_data,
-					buf, count, ppos);
-
-	return ret;
-}
-
-static ssize_t vfio_fops_write(struct file *filep, const char __user *buf,
-			       size_t count, loff_t *ppos)
-{
-	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver;
-	ssize_t ret = -EINVAL;
-
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->write))
-		ret = driver->ops->write(container->iommu_data,
-					 buf, count, ppos);
-
-	return ret;
-}
-
-static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma)
-{
-	struct vfio_container *container = filep->private_data;
-	struct vfio_iommu_driver *driver;
-	int ret = -EINVAL;
-
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->mmap))
-		ret = driver->ops->mmap(container->iommu_data, vma);
-
-	return ret;
-}
-
 static const struct file_operations vfio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vfio_fops_open,
 	.release	= vfio_fops_release,
-	.read		= vfio_fops_read,
-	.write		= vfio_fops_write,
 	.unlocked_ioctl	= vfio_fops_unl_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
-	.mmap		= vfio_fops_mmap,
 };
 
 /**
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2ffbb2d02c9346..82042690d7978d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -95,13 +95,8 @@ struct vfio_iommu_driver_ops {
 	struct module	*owner;
 	void		*(*open)(unsigned long arg);
 	void		(*release)(void *iommu_data);
-	ssize_t		(*read)(void *iommu_data, char __user *buf,
-				size_t count, loff_t *ppos);
-	ssize_t		(*write)(void *iommu_data, const char __user *buf,
-				 size_t count, loff_t *size);
 	long		(*ioctl)(void *iommu_data, unsigned int cmd,
 				 unsigned long arg);
-	int		(*mmap)(void *iommu_data, struct vm_area_struct *vma);
 	int		(*attach_group)(void *iommu_data,
 					struct iommu_group *group);
 	void		(*detach_group)(void *iommu_data,
-- 
2.30.2

