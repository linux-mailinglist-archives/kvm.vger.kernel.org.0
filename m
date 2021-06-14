Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E153A69AD
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 17:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhFNPLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 11:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhFNPLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 11:11:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DADC061574;
        Mon, 14 Jun 2021 08:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0UZYutylZAO0gsqyAK3ojNeQU42jX94G62t3cTWvHK0=; b=cRATyJNe96rfo7uP7adQ4850L5
        qAphbvw0aa8CZpRDpFjre60gQkABETEVq38mOsm+xlDaCg1nzOqgnQPnSVrIvvOK9e8rhLpmMXSGL
        e+PMW0C5s72SE0HB/3NfWhJA0tJQnwrYXgLGgzR/bVKh6JkLrew05oyiJCTlBCKmzfb1q/jmEwbBG
        IFyMBVhFs7UGNgZ0DcXErtBstt2hP+J9OCXLiAtE+fMndTkUNe2l1C9wTYdZIeY+dXGBiv2+BM4uy
        3C6mI7uasoHm52nBg6eznDwHjW3N8yOZmBXN+CTEm7aw5ngWqg8RfpZD/p8v0HS6LmGhkqUXfL2Jm
        CaqAt5Kw==;
Received: from [2001:4bb8:19b:fdce:4b1a:b4aa:22d8:1629] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lsoCt-00EffU-V6; Mon, 14 Jun 2021 15:08:56 +0000
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
Date:   Mon, 14 Jun 2021 17:08:38 +0200
Message-Id: <20210614150846.4111871-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210614150846.4111871-1-hch@lst.de>
References: <20210614150846.4111871-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

really_probe tries to special case errors from ->probe, but due to all
other initialization added to the function over time now a lot of
internal errors hit that code path as well.  Untangle that by adding
a new probe_err local variable and apply the special casing only to
that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/dd.c | 72 +++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 7477d3322b3a..999bc737a8f0 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -513,12 +513,42 @@ static ssize_t state_synced_show(struct device *dev,
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
@@ -572,15 +602,15 @@ static int really_probe(struct device *dev, struct device_driver *drv)
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
-	}
+	probe_ret = call_driver_probe(dev, drv);
+	if (probe_ret) {
+		/*
+		 * Ignore errors returned by ->probe so that the next driver can
+		 * try its luck.
+		   */
+		ret = 0;
+		goto probe_failed;
+	} 
 
 	if (device_add_groups(dev, drv->dev_groups)) {
 		dev_err(dev, "device_add_groups() failed\n");
@@ -650,28 +680,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
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

