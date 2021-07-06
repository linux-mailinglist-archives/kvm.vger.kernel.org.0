Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615533BDA8D
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 17:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhGFPz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 11:55:29 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36941 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbhGFPz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 11:55:28 -0400
X-Greylist: delayed 20067 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jul 2021 11:55:28 EDT
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0nL8-0007mM-BN; Tue, 06 Jul 2021 17:50:26 +0200
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0nL6-0005Sm-5I; Tue, 06 Jul 2021 17:50:24 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kernel@pengutronix.de, Cornelia Huck <cohuck@redhat.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 1/4] s390/cio: Make struct css_driver::remove return void
Date:   Tue,  6 Jul 2021 17:48:00 +0200
Message-Id: <20210706154803.1631813-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The driver core ignores the return value of css_remove()
(because there is only little it can do when a device disappears) and
there are no pci_epf_drivers with a remove callback.

So make it impossible for future drivers to return an unused error code
by changing the remove prototype to return void.

The real motivation for this change is the quest to make struct
bus_type::remove return void, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/s390/cio/chsc_sch.c     | 3 +--
 drivers/s390/cio/css.c          | 7 ++++---
 drivers/s390/cio/css.h          | 2 +-
 drivers/s390/cio/device.c       | 5 ++---
 drivers/s390/cio/eadm_sch.c     | 4 +---
 drivers/s390/cio/vfio_ccw_drv.c | 3 +--
 6 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index c42405c620b5..684348d82f08 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -100,7 +100,7 @@ static int chsc_subchannel_probe(struct subchannel *sch)
 	return ret;
 }
 
-static int chsc_subchannel_remove(struct subchannel *sch)
+static void chsc_subchannel_remove(struct subchannel *sch)
 {
 	struct chsc_private *private;
 
@@ -112,7 +112,6 @@ static int chsc_subchannel_remove(struct subchannel *sch)
 		put_device(&sch->dev);
 	}
 	kfree(private);
-	return 0;
 }
 
 static void chsc_subchannel_shutdown(struct subchannel *sch)
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index a974943c27da..092fd1ea5799 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1374,12 +1374,13 @@ static int css_probe(struct device *dev)
 static int css_remove(struct device *dev)
 {
 	struct subchannel *sch;
-	int ret;
 
 	sch = to_subchannel(dev);
-	ret = sch->driver->remove ? sch->driver->remove(sch) : 0;
+	if (sch->driver->remove)
+		sch->driver->remove(sch);
 	sch->driver = NULL;
-	return ret;
+
+	return 0;
 }
 
 static void css_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/css.h b/drivers/s390/cio/css.h
index 2eddfc47f687..c98522cbe276 100644
--- a/drivers/s390/cio/css.h
+++ b/drivers/s390/cio/css.h
@@ -81,7 +81,7 @@ struct css_driver {
 	int (*chp_event)(struct subchannel *, struct chp_link *, int);
 	int (*sch_event)(struct subchannel *, int);
 	int (*probe)(struct subchannel *);
-	int (*remove)(struct subchannel *);
+	void (*remove)(struct subchannel *);
 	void (*shutdown)(struct subchannel *);
 	int (*settle)(void);
 };
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 84f659cafe76..cd5d2d4d8e46 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -137,7 +137,7 @@ static int ccw_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static void io_subchannel_irq(struct subchannel *);
 static int io_subchannel_probe(struct subchannel *);
-static int io_subchannel_remove(struct subchannel *);
+static void io_subchannel_remove(struct subchannel *);
 static void io_subchannel_shutdown(struct subchannel *);
 static int io_subchannel_sch_event(struct subchannel *, int);
 static int io_subchannel_chp_event(struct subchannel *, struct chp_link *,
@@ -1101,7 +1101,7 @@ static int io_subchannel_probe(struct subchannel *sch)
 	return 0;
 }
 
-static int io_subchannel_remove(struct subchannel *sch)
+static void io_subchannel_remove(struct subchannel *sch)
 {
 	struct io_subchannel_private *io_priv = to_io_private(sch);
 	struct ccw_device *cdev;
@@ -1120,7 +1120,6 @@ static int io_subchannel_remove(struct subchannel *sch)
 			  io_priv->dma_area, io_priv->dma_area_dma);
 	kfree(io_priv);
 	sysfs_remove_group(&sch->dev.kobj, &io_subchannel_attr_group);
-	return 0;
 }
 
 static void io_subchannel_verify(struct subchannel *sch)
diff --git a/drivers/s390/cio/eadm_sch.c b/drivers/s390/cio/eadm_sch.c
index c8964e0a23e7..15bdae5981ca 100644
--- a/drivers/s390/cio/eadm_sch.c
+++ b/drivers/s390/cio/eadm_sch.c
@@ -282,7 +282,7 @@ static void eadm_quiesce(struct subchannel *sch)
 	spin_unlock_irq(sch->lock);
 }
 
-static int eadm_subchannel_remove(struct subchannel *sch)
+static void eadm_subchannel_remove(struct subchannel *sch)
 {
 	struct eadm_private *private = get_eadm_private(sch);
 
@@ -297,8 +297,6 @@ static int eadm_subchannel_remove(struct subchannel *sch)
 	spin_unlock_irq(sch->lock);
 
 	kfree(private);
-
-	return 0;
 }
 
 static void eadm_subchannel_shutdown(struct subchannel *sch)
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9b61e9b131ad..76099bcb765b 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -234,7 +234,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	return ret;
 }
 
-static int vfio_ccw_sch_remove(struct subchannel *sch)
+static void vfio_ccw_sch_remove(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 	struct vfio_ccw_crw *crw, *temp;
@@ -257,7 +257,6 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 	VFIO_CCW_MSG_EVENT(4, "unbound from subchannel %x.%x.%04x\n",
 			   sch->schid.cssid, sch->schid.ssid,
 			   sch->schid.sch_no);
-	return 0;
 }
 
 static void vfio_ccw_sch_shutdown(struct subchannel *sch)
-- 
2.30.2

