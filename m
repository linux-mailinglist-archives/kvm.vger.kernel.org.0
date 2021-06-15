Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589423A806E
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhFONk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhFONkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:40:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4178AC061574;
        Tue, 15 Jun 2021 06:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NvKrTegNJt6p9ts7Wx4ZCH5HpolsdcaWLfUZKxp8Ym0=; b=MGKJ4afA3hE7QZbybSgt+x3RSf
        SHGz+JwWUFKMROwY6XxNd/ClwtFZw+BkvFoKanLLyWcyPTYUMWpVU4vnOQF+wy7e1HySXzciQpNxj
        YgpqE4bz7K4myBaxQnFETcDTCdcbm2BPG/MPzKfCL+2oIX6SIdu5okPGuGf3oKa7EGhuFxSFw9827
        hO2LX34nZ7Ku4Z58qjH1URziQbGAlBBQlEl2sudXryKDuLu9EKbWYRvz//eLyaFvs/h6tJQkgWWGN
        K+h5hhel73haPEmX3OuHhxRjswvnqCXQ4OClqfTBXsumpaIa6AnttuhINCpHBY7chvTbUljVfDlxj
        Dh9SoIGA==;
Received: from [2001:4bb8:19b:fdce:9045:1e63:20f0:ca9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lt9Ep-006p1g-W0; Tue, 15 Jun 2021 13:36:34 +0000
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
Subject: [PATCH 01/10] driver core: Pull required checks into driver_probe_device()
Date:   Tue, 15 Jun 2021 15:35:10 +0200
Message-Id: <20210615133519.754763-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615133519.754763-1-hch@lst.de>
References: <20210615133519.754763-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Checking if the dev is dead or if the dev is already bound is a required
precondition to invoking driver_probe_device(). All the call chains
leading here duplicate these checks.

Add it directly to driver_probe_device() so the precondition is clear and
remove the checks from device_driver_attach() and
__driver_attach_async_helper().

The other call chain going through __device_attach_driver() does have
these same checks but they are inlined into logic higher up the call stack
and can't be removed.

The sysfs uAPI call chain starting at bind_store() is a bit confused
because it reads dev->driver unlocked and returns -ENODEV if it is !NULL,
otherwise it reads it again under lock and returns 0 if it is !NULL. Fix
this to always return -EBUSY and always read dev->driver under its lock.

Done in preparation for the next patches which will add additional
callers to driver_probe_device() and will need these checks as well.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[hch: drop the extra checks in device_driver_attach and bind_store]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/base/bus.c |  2 +-
 drivers/base/dd.c  | 32 ++++++++++----------------------
 2 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 36d0c654ea61..7de13302e8c8 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -210,7 +210,7 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
 	int err = -ENODEV;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
+	if (dev && driver_match_device(drv, dev)) {
 		err = device_driver_attach(drv, dev);
 
 		if (err > 0) {
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index ecd7cf848daf..7477d3322b3a 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -733,8 +733,9 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
  *
- * This function returns -ENODEV if the device is not registered,
- * 1 if the device is bound successfully and 0 otherwise.
+ * This function returns -ENODEV if the device is not registered, -EBUSY if it
+ * already has a driver, and 1 if the device is bound successfully and 0
+ * otherwise.
  *
  * This function must be called with @dev lock held.  When called for a
  * USB interface, @dev->parent lock must be held as well.
@@ -745,8 +746,10 @@ static int driver_probe_device(struct device_driver *drv, struct device *dev)
 {
 	int ret = 0;
 
-	if (!device_is_registered(dev))
+	if (dev->p->dead || !device_is_registered(dev))
 		return -ENODEV;
+	if (dev->driver)
+		return -EBUSY;
 
 	dev->can_match = true;
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
@@ -1027,17 +1030,10 @@ static void __device_driver_unlock(struct device *dev, struct device *parent)
  */
 int device_driver_attach(struct device_driver *drv, struct device *dev)
 {
-	int ret = 0;
+	int ret;
 
 	__device_driver_lock(dev, dev->parent);
-
-	/*
-	 * If device has been removed or someone has already successfully
-	 * bound a driver before us just skip the driver probe call.
-	 */
-	if (!dev->p->dead && !dev->driver)
-		ret = driver_probe_device(drv, dev);
-
+	ret = driver_probe_device(drv, dev);
 	__device_driver_unlock(dev, dev->parent);
 
 	return ret;
@@ -1047,19 +1043,11 @@ static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
 	struct device *dev = _dev;
 	struct device_driver *drv;
-	int ret = 0;
+	int ret;
 
 	__device_driver_lock(dev, dev->parent);
-
 	drv = dev->p->async_driver;
-
-	/*
-	 * If device has been removed or someone has already successfully
-	 * bound a driver before us just skip the driver probe call.
-	 */
-	if (!dev->p->dead && !dev->driver)
-		ret = driver_probe_device(drv, dev);
-
+	ret = driver_probe_device(drv, dev);
 	__device_driver_unlock(dev, dev->parent);
 
 	dev_dbg(dev, "driver %s async attach completed: %d\n", drv->name, ret);
-- 
2.30.2

