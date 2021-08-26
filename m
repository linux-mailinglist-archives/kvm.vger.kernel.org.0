Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20173F8948
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbhHZNpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhHZNph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:45:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99278C0613C1
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=F3Vr4Dqr//F1nYSM5embQqT99tUV1mTvIL5pJuuP3ik=; b=oXMZho98fxk3gliGmjvY18Fw4x
        +jTyynpWf5W1bH8ejKYcs7PRSReM1dVaUOCBq6fBtQI8yTePCZs3+kis5mtxNMPpyCiXClWvjtbKp
        HfQRyLD3OtUAMAxvX1eJBXn6Is3JpAzRiRUXqzwk4UnxSLwx5M7sIsZK6k2GFs0JWbNiWWF9D4lZA
        DQ5xTfzUFigql0Zl/iATJSH8ql5oOMvpjHedgs6saRLsbWeqoOP4TlTFnK4FxpbxLvQZpz6HQFNIj
        sUwx1H/gGayoegKEWV/d4YalcbjRFuHZVqA7iAxzhkDDyaCFeqaI34uK2wZmQGR9/t+3ATolXm6Es
        UaFz66LA==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFer-00DLPn-0Y; Thu, 26 Aug 2021 13:43:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 08/14] vfio: remove unused method from vfio_iommu_driver_ops
Date:   Thu, 26 Aug 2021 15:34:18 +0200
Message-Id: <20210826133424.3362-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The read, write and mmap methods are never implemented, so remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c  | 50 --------------------------------------------
 include/linux/vfio.h |  5 -----
 2 files changed, 55 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 467432379b91ef..8b815763f6dcf9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1266,62 +1266,12 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
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
index bbe29300862649..7a57a0077f9637 100644
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

