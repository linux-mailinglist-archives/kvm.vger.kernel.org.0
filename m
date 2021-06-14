Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8BB3A69B2
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhFNPLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbhFNPLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:11:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11827C061766;
        Mon, 14 Jun 2021 08:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bU6H+JtmYwvm81L7dg3u7Ddx8PA6sxQw9HC7VnNm9hA=; b=e0p2YjwFOfTHIY4mwHe/TJCsim
        06ORr6F7a0dWPPIzGhg8ig67AKarNwRvMBJv3+9RDR8W9++3eC8mTT5SVj4yYGnXYSobfZnTBnKj4
        tVQ8S+WyNv3fdZc5a5gsFRKjtn0NilWMPDBqWyYEBS7cK+PrBkunsjn3gcx7QMOow3Il3NerPlmJz
        RWa+eRvhkYM1Nev3+MBRf/7/RRg8WVdMCKncS/cOK91p8dF3YT4Rv6FB2dEpfKMfGXg2hYeFlUrjA
        Ri76VRad1qiJibYrVomKRYq+jo8EyvP9rqY3K0+LvFxWqQcm7KPq2UwayxqTvsvdPpIVZl0H7L4Y0
        35/ns5bA==;
Received: from [2001:4bb8:19b:fdce:4b1a:b4aa:22d8:1629] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lsoCx-00EfgX-8C; Mon, 14 Jun 2021 15:08:59 +0000
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
Subject: [PATCH 03/10] driver core: Flow the return code from ->probe() through to sysfs bind
Date:   Mon, 14 Jun 2021 17:08:39 +0200
Message-Id: <20210614150846.4111871-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210614150846.4111871-1-hch@lst.de>
References: <20210614150846.4111871-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently really_probe() returns 1 on success and 0 if the probe() call
fails. This return code arrangement is designed to be useful for
__device_attach_driver() which is walking the device list and trying every
driver. 0 means to keep trying.

However, it is not useful for the other places that call through to
really_probe() that do actually want to see the probe() return code.

For instance bind_store() would be better to return the actual error code
from the driver's probe method, not discarding it and returning -ENODEV.

Reorganize things so that really_probe() returns the error code from
->probe as a (inverted) positive number, and 0 for successful attach.

With this, __device_attach_driver can ignore the (positive) probe errors,
return 1 to exit the loop for a successful binding and pass on the
other negative errors, while device_driver_attach simplify inverts the
positive errors and returns all errors to the sysfs code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/bus.c |  6 +-----
 drivers/base/dd.c  | 29 ++++++++++++++++++++---------
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 7de13302e8c8..1f6b4bd61056 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -212,13 +212,9 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
 	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (dev && driver_match_device(drv, dev)) {
 		err = device_driver_attach(drv, dev);
-
-		if (err > 0) {
+		if (!err) {
 			/* success */
 			err = count;
-		} else if (err == 0) {
-			/* driver didn't accept device */
-			err = -ENODEV;
 		}
 	}
 	put_device(dev);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 999bc737a8f0..4c6af8c062c8 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -605,10 +605,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	probe_ret = call_driver_probe(dev, drv);
 	if (probe_ret) {
 		/*
-		 * Ignore errors returned by ->probe so that the next driver can
-		 * try its luck.
+		 * Return probe errors as positive values so that the callers
+		 * can distinguish them from other errors.
 		   */
-		ret = 0;
+		ret = -probe_ret;
 		goto probe_failed;
 	} 
 
@@ -651,7 +651,6 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		dev->pm_domain->sync(dev);
 
 	driver_bound(dev);
-	ret = 1;
 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 	goto done;
@@ -744,8 +743,8 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * @dev: device to try to bind to the driver
  *
  * This function returns -ENODEV if the device is not registered, -EBUSY if it
- * already has a driver, and 1 if the device is bound successfully and 0
- * otherwise.
+ * already has a driver, 0 if the device is bound successfully and a positive
+ * (inverted) error code for failures from the ->probe method.
  *
  * This function must be called with @dev lock held.  When called for a
  * USB interface, @dev->parent lock must be held as well.
@@ -880,7 +879,14 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	if (data->check_async && async_allowed != data->want_async)
 		return 0;
 
-	return driver_probe_device(drv, dev);
+	/*
+	 * Ignore errors returned by ->probe so that the next driver can try
+	 * its luck.
+	 */
+	ret = driver_probe_device(drv, dev);
+	if (ret < 0)
+		return ret;
+	return ret == 0;
 }
 
 static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
@@ -1036,7 +1042,7 @@ static void __device_driver_unlock(struct device *dev, struct device *parent)
  * @dev: Device to attach it to
  *
  * Manually attach driver to a device. Will acquire both @dev lock and
- * @dev->parent lock if needed.
+ * @dev->parent lock if needed. Returns 0 on success, -ERR on failure.
  */
 int device_driver_attach(struct device_driver *drv, struct device *dev)
 {
@@ -1046,6 +1052,9 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 	ret = driver_probe_device(drv, dev);
 	__device_driver_unlock(dev, dev->parent);
 
+	/* also return probe errors as normal negative errnos */
+	if (ret > 0)
+		ret = -ret;
 	return ret;
 }
 
@@ -1112,7 +1121,9 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	}
 
-	device_driver_attach(drv, dev);
+	__device_driver_lock(dev, dev->parent);
+	driver_probe_device(drv, dev);
+	__device_driver_unlock(dev, dev->parent);
 
 	return 0;
 }
-- 
2.30.2

