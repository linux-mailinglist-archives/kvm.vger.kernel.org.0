Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80719408551
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237626AbhIMH1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237622AbhIMH1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 03:27:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17A2C061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=U6fD+0WohKQEaBHc3aYDjkoUaJaGHAZdpIUAhWpUM70=; b=TdinmvQsSaquYhjAtalCnujZyP
        hPD5oPG8yWlFRhAZFun+hYvfEonAijw5j4OL1fg0eKwSD5hxPxgjUnHWBmJwOCkc6v3Ut5y2W+Hwa
        AnJHUGACD19F+wwsJ06/nP8KhYX7KA/QOCMOI0TcABv+Y+AaPPSN+mzmJw1Oh+jM1gqVXH5bwbPU1
        Za+ukZG2YCy4Dv/sSH+NSRmDx8Oqt1uDat1S1dhfmyFn3XMoBCcU/T/hQm/plXRD1meE7iOc6n/uw
        f6ucu2uEKrnQUVRmA4vO2wAdflGeRVqJM0UgHPN7QqCG2hufprDMXPjlM9T69UUh1zBisbuxR9nWx
        lO1O/MPg==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPgJo-00DGad-CO; Mon, 13 Sep 2021 07:24:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 08/14] vfio: remove unused method from vfio_iommu_driver_ops
Date:   Mon, 13 Sep 2021 09:16:00 +0200
Message-Id: <20210913071606.2966-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913071606.2966-1-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
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
index 2508c8c3984091..2c1c7316aa192c 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1276,62 +1276,12 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
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

