Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AFD305D5D
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313158AbhAZWcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730313AbhAZRAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:00:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912C7C061D7F
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 08:59:21 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l4Rg8-00045s-5B; Tue, 26 Jan 2021 17:58:56 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1l4Rg4-0003hh-Ph; Tue, 26 Jan 2021 17:58:52 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Russell King <linux@armlinux.org.uk>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 3/5] vfio: platform: simplify device removal
Date:   Tue, 26 Jan 2021 17:58:33 +0100
Message-Id: <20210126165835.687514-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126165835.687514-1-u.kleine-koenig@pengutronix.de>
References: <20210126165835.687514-1-u.kleine-koenig@pengutronix.de>
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

vfio_platform_remove_common() cannot return non-NULL in
vfio_amba_remove() as the latter is only called if vfio_amba_probe()
returned success.

Diagnosed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/vfio/platform/vfio_amba.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index 9636a2afaecd..7b3ebf1558e1 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -73,16 +73,12 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
 
 static int vfio_amba_remove(struct amba_device *adev)
 {
-	struct vfio_platform_device *vdev;
-
-	vdev = vfio_platform_remove_common(&adev->dev);
-	if (vdev) {
-		kfree(vdev->name);
-		kfree(vdev);
-		return 0;
-	}
+	struct vfio_platform_device *vdev =
+		vfio_platform_remove_common(&adev->dev);
 
-	return -EINVAL;
+	kfree(vdev->name);
+	kfree(vdev);
+	return 0;
 }
 
 static const struct amba_id pl330_ids[] = {
-- 
2.29.2

