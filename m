Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638053AB5D3
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 16:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhFQO0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 10:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhFQO0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 10:26:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D93C061574;
        Thu, 17 Jun 2021 07:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=d7/SHH64i5BdcLs3/ebzd5l7J+2MvEZOf4W0U1G8pE0=; b=ssK52wkHCfKhanmtMcOmHY/Vjd
        NZ4jY8lGNqXJLixpB86pLZvCUYwt1huIWJsIz2l3dA5iGH4EiZcVuGR5zqmheVnCLwG3lUo4RtLRd
        HpT4tQyTQ9BPxqzL2eLaHY6iIzPYjUcvmX9aF6jZUD+mLf1zcjTuzdIs/Tvxfho6x56Q3o3f89d8S
        FEHvq5RSOxvNJvV287Z/h6ydz1lRxPmYH4t++OWORYolJv7Aztp/03t7Etz2KXBy1hcHWoiVzGnjZ
        a+Z62dsv9l+ArOdE1QmjYe3xbAN4aiDLwjIIglU3GXgDuhoK9/KyMf1uc3TM2SNatEhDZKmKO8f+9
        eqjlBsAw==;
Received: from [2001:4bb8:19b:fdce:dccf:26cc:e207:71f6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltsv6-009DYC-7B; Thu, 17 Jun 2021 14:23:06 +0000
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
Subject: [PATCH 02/10] driver core: Better distinguish probe errors in really_probe
Date:   Thu, 17 Jun 2021 16:22:10 +0200
Message-Id: <20210617142218.1877096-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210617142218.1877096-1-hch@lst.de>
References: <20210617142218.1877096-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

really_probe tries to special case errors from ->probe, but due to all
other initialization added to the function over time now a lot of
internal errors hit that code path as well.  Untangle that by adding
a new probe_err local variable and apply the special casing only to
that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 drivers/base/dd.c | 72 +++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 7477d3322b3a..fd83817240e6 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -513,12 +513,44 @@ static ssize_t state_synced_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(state_synced);
 
+
+static int call_driver_probe(struct device *dev, struct device_driver *drv)
+{
+	int ret = 0;
+
+	if (dev->bus->probe)
+		ret = dev->bus->probe(dev);
+	else if (drv->probe)
+		ret = drv->probe(dev);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -EPROBE_DEFER:
+		/* Driver requested deferred probing */
+		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
+		break;
+	case -ENODEV:
+	case -ENXIO:
+		pr_debug("%s: probe of %s rejects match %d\n",
+			 drv->name, dev_name(dev), ret);
+		break;
+	default:
+		/* driver matched but the probe failed */
+		pr_warn("%s: probe of %s failed with error %d\n",
+			drv->name, dev_name(dev), ret);
+		break;
+	}
+
+	return ret;
+}
+
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
-	int ret = -EPROBE_DEFER;
 	int local_trigger_count = atomic_read(&deferred_trigger_count);
 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
 			   !drv->suppress_bind_attrs;
+	int ret = -EPROBE_DEFER, probe_ret = 0;
 
 	if (defer_all_probes) {
 		/*
@@ -572,14 +604,14 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			goto probe_failed;
 	}
 
-	if (dev->bus->probe) {
-		ret = dev->bus->probe(dev);
-		if (ret)
-			goto probe_failed;
-	} else if (drv->probe) {
-		ret = drv->probe(dev);
-		if (ret)
-			goto probe_failed;
+	probe_ret = call_driver_probe(dev, drv);
+	if (probe_ret) {
+		/*
+		 * Ignore errors returned by ->probe so that the next driver can
+		 * try its luck.
+		 */
+		ret = 0;
+		goto probe_failed;
 	}
 
 	if (device_add_groups(dev, drv->dev_groups)) {
@@ -650,28 +682,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 		dev->pm_domain->dismiss(dev);
 	pm_runtime_reinit(dev);
 	dev_pm_set_driver_flags(dev, 0);
-
-	switch (ret) {
-	case -EPROBE_DEFER:
-		/* Driver requested deferred probing */
-		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
+	if (probe_ret == -EPROBE_DEFER)
 		driver_deferred_probe_add_trigger(dev, local_trigger_count);
-		break;
-	case -ENODEV:
-	case -ENXIO:
-		pr_debug("%s: probe of %s rejects match %d\n",
-			 drv->name, dev_name(dev), ret);
-		break;
-	default:
-		/* driver matched but the probe failed */
-		pr_warn("%s: probe of %s failed with error %d\n",
-			drv->name, dev_name(dev), ret);
-	}
-	/*
-	 * Ignore errors returned by ->probe so that the next driver can try
-	 * its luck.
-	 */
-	ret = 0;
 done:
 	atomic_dec(&probe_count);
 	wake_up_all(&probe_waitqueue);
-- 
2.30.2

