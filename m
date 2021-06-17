Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73F23AB5DA
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhFQO0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 10:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhFQO0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 10:26:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597E2C061760;
        Thu, 17 Jun 2021 07:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=t/O9IctpOWccmO65WR/J5fnTqObhdoviyqdCUDuVG2k=; b=ZZmkR9uSJ6NSZqyx/rTqmWVvQS
        epBSGn7PV+yZzQApZY2GOSHXP8K85a6HT4hlL7oDTzUM7XAijAr1m/rKS1lUeQ7g+3MsJAMAb/yi1
        oNhQHRPFfBBFHBrG9JBSUNN2gsFhnqCtQLeQT4gNF/7p3dFv3R+zO7lZGxM+tKfeXf/NkOB2Oe7vE
        5+zOXmmdOEVf0Zt7D9+SImqX5hcu5vRWT6FQV0+rM/uoS/1ygoryWVXq4lVRgIQucEMNG6FUd5fG0
        22GOPFzNtFzMaemhzradsG8Dt+XY4xK/Cj6XJLe7LPkO8THLNAUR+Zu4sfg+G8qhzZC9tdJcRuEsq
        RFHFI1eQ==;
Received: from [2001:4bb8:19b:fdce:dccf:26cc:e207:71f6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltsvi-009Dbl-02; Thu, 17 Jun 2021 14:23:46 +0000
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
Subject: [PATCH 04/10] driver core: Don't return EPROBE_DEFER to userspace during sysfs bind
Date:   Thu, 17 Jun 2021 16:22:12 +0200
Message-Id: <20210617142218.1877096-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210617142218.1877096-1-hch@lst.de>
References: <20210617142218.1877096-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPROBE_DEFER is an internal kernel error code and it should not be leaked
to userspace via the bind_store() sysfs. Userspace doesn't have this
constant and cannot understand it.

Further, it doesn't really make sense to have userspace trigger a deferred
probe via bind_store(), which could eventually succeed, while
simultaneously returning an error back.

Resolve this by splitting driver_probe_device so that the version used
by the sysfs binding that turns EPROBE_DEFER into -EAGAIN, while the one
used for internally binding keeps the error code, and calls
driver_deferred_probe_add where needed.  This also allows to nicely split
out the defer_all_probes / probe_count checks so that they actually allow
for full device_{block,unblock}_probing protection while not bothering
the sysfs bind case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c | 84 +++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 25341f52198c..1d8012459587 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -491,15 +491,6 @@ EXPORT_SYMBOL_GPL(device_bind_driver);
 static atomic_t probe_count = ATOMIC_INIT(0);
 static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 
-static void driver_deferred_probe_add_trigger(struct device *dev,
-					      int local_trigger_count)
-{
-	driver_deferred_probe_add(dev);
-	/* Did a trigger occur while probing? Need to re-trigger if yes */
-	if (local_trigger_count != atomic_read(&deferred_trigger_count))
-		driver_deferred_probe_trigger();
-}
-
 static ssize_t state_synced_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -547,10 +538,9 @@ static int call_driver_probe(struct device *dev, struct device_driver *drv)
 
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
-	int local_trigger_count = atomic_read(&deferred_trigger_count);
 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
 			   !drv->suppress_bind_attrs;
-	int ret = -EPROBE_DEFER, probe_ret = 0;
+	int ret;
 
 	if (defer_all_probes) {
 		/*
@@ -559,17 +549,13 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		 * wait_for_device_probe() right after that to avoid any races.
 		 */
 		dev_dbg(dev, "Driver %s force probe deferral\n", drv->name);
-		driver_deferred_probe_add(dev);
-		return ret;
+		return -EPROBE_DEFER;
 	}
 
 	ret = device_links_check_suppliers(dev);
-	if (ret == -EPROBE_DEFER)
-		driver_deferred_probe_add_trigger(dev, local_trigger_count);
 	if (ret)
 		return ret;
 
-	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	if (!list_empty(&dev->devres_head)) {
@@ -604,13 +590,13 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			goto probe_failed;
 	}
 
-	probe_ret = call_driver_probe(dev, drv);
-	if (probe_ret) {
+	ret = call_driver_probe(dev, drv);
+	if (ret) {
 		/*
 		 * Return probe errors as positive values so that the callers
 		 * can distinguish them from other errors.
 		 */
-		ret = -probe_ret;
+		ret = -ret;
 		goto probe_failed;
 	}
 
@@ -681,11 +667,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		dev->pm_domain->dismiss(dev);
 	pm_runtime_reinit(dev);
 	dev_pm_set_driver_flags(dev, 0);
-	if (probe_ret == -EPROBE_DEFER)
-		driver_deferred_probe_add_trigger(dev, local_trigger_count);
 done:
-	atomic_dec(&probe_count);
-	wake_up_all(&probe_waitqueue);
 	return ret;
 }
 
@@ -739,21 +721,7 @@ void wait_for_device_probe(void)
 }
 EXPORT_SYMBOL_GPL(wait_for_device_probe);
 
-/**
- * driver_probe_device - attempt to bind device & driver together
- * @drv: driver to bind a device to
- * @dev: device to try to bind to the driver
- *
- * This function returns -ENODEV if the device is not registered, -EBUSY if it
- * already has a driver, 0 if the device is bound successfully and a positive
- * (inverted) error code for failures from the ->probe method.
- *
- * This function must be called with @dev lock held.  When called for a
- * USB interface, @dev->parent lock must be held as well.
- *
- * If the device has a parent, runtime-resume the parent before driver probing.
- */
-static int driver_probe_device(struct device_driver *drv, struct device *dev)
+static int __driver_probe_device(struct device_driver *drv, struct device *dev)
 {
 	int ret = 0;
 
@@ -784,6 +752,42 @@ static int driver_probe_device(struct device_driver *drv, struct device *dev)
 	return ret;
 }
 
+/**
+ * driver_probe_device - attempt to bind device & driver together
+ * @drv: driver to bind a device to
+ * @dev: device to try to bind to the driver
+ *
+ * This function returns -ENODEV if the device is not registered, -EBUSY if it
+ * already has a driver, 0 if the device is bound successfully and a positive
+ * (inverted) error code for failures from the ->probe method.
+ *
+ * This function must be called with @dev lock held.  When called for a
+ * USB interface, @dev->parent lock must be held as well.
+ *
+ * If the device has a parent, runtime-resume the parent before driver probing.
+ */
+static int driver_probe_device(struct device_driver *drv, struct device *dev)
+{
+	int trigger_count = atomic_read(&deferred_trigger_count);
+	int ret;
+
+	atomic_inc(&probe_count);
+	ret = __driver_probe_device(drv, dev);
+	if (ret == -EPROBE_DEFER || ret == EPROBE_DEFER) {
+		driver_deferred_probe_add(dev);
+
+		/*
+		 * Did a trigger occur while probing? Need to re-trigger if yes
+		 */
+		if (trigger_count != atomic_read(&deferred_trigger_count) &&
+		    !defer_all_probes)
+			driver_deferred_probe_trigger();
+	}
+	atomic_dec(&probe_count);
+	wake_up_all(&probe_waitqueue);
+	return ret;
+}
+
 static inline bool cmdline_requested_async_probing(const char *drv_name)
 {
 	return parse_option_str(async_probe_drv_names, drv_name);
@@ -1051,12 +1055,14 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
 	int ret;
 
 	__device_driver_lock(dev, dev->parent);
-	ret = driver_probe_device(drv, dev);
+	ret = __driver_probe_device(drv, dev);
 	__device_driver_unlock(dev, dev->parent);
 
 	/* also return probe errors as normal negative errnos */
 	if (ret > 0)
 		ret = -ret;
+	if (ret == -EPROBE_DEFER)
+		return -EAGAIN;
 	return ret;
 }
 
-- 
2.30.2

