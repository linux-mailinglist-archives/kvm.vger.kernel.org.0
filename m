Return-Path: <kvm+bounces-11365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 910EC87603C
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 09:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2F121C2249A
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABC654667;
	Fri,  8 Mar 2024 08:52:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F38537FA
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709887921; cv=none; b=uTIIYZ4nZ2sK9AQhRr9lUSPHa5cuLfa6L/h/z0jN5y2nLK8q4LqL5HGoWpP11vjCa2BoqiwABzq7UZhBw2IPfhsePXnww07+vte3EWiD5yt11JZQPJmBIzbMolHtmVcXEM86PHNcE1RWZy9WR6o4VDtZEe1tjHzbtZKQo6C/7Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709887921; c=relaxed/simple;
	bh=7OCLVxrivuYmBWk05zflwh6tyIz/ojGTwINI4ZjhP8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g9wVvVNhNxA6IEVTW60OdOE0zclGpGseevINT5TqyW2N7YW7OnnzuyrSFXC8o6z02IaeQ1RiwkOg9nKwIxtZ7z6LpVK3E2Zg6NfftYbUKQTQ0CsMjK5bcVPbv6ddYY7zyF57sL146MFKx7PsR8lgMVpCviI+BVx9yxrG2/yhCgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1riVxH-000715-Gh; Fri, 08 Mar 2024 09:51:51 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1riVxG-0056Np-RX; Fri, 08 Mar 2024 09:51:50 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1riVxG-00246H-2V;
	Fri, 08 Mar 2024 09:51:50 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH] vfio/platform: Convert to platform remove callback returning void
Date: Fri,  8 Mar 2024 09:51:19 +0100
Message-ID:  <79d3df42fe5b359a05b8061631e72e5ed249b234.1709886922.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1977; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=7OCLVxrivuYmBWk05zflwh6tyIz/ojGTwINI4ZjhP8E=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBl6tGMgaK2CFwPxc5pX6qTJ3t2nFbKByfd+MBTp zD4dEerIZqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZerRjAAKCRCPgPtYfRL+ Tnm6B/9wbKuxZH8Iq5kW6nqia3XxDzITOFF2mOl9GS1N2houBxJ9+F+U3GbUz5Ci7tEi3B2TeqH lTrerTlIslZwfKvS8XGegnnPq7/zWE4DCjW6ZKlcNdD6KMeu3eKEyWZdRlIGwdfbTlMTHsbnx4u znimkqSEvJQl1AiLsMJxnGLaCxCyv1cG2r8S0wxrizctthfaPnx0l8AWiqFoBuxv8Kjqgzgvp2B U8vMm8Qh3FslkMnh7DE7k2YdPPtgc07G1B9qSWgvGlDauwoLokrwo2cz+lXuyusHENYI+qrMGpe yjrwm86sstOs0BPptHzaqZ2rXIWao7762AkJpp7uEUep7t+B
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/vfio/platform/vfio_platform.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 8cf22fa65baa..42d1462c5e19 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -85,14 +85,13 @@ static void vfio_platform_release_dev(struct vfio_device *core_vdev)
 	vfio_platform_release_common(vdev);
 }
 
-static int vfio_platform_remove(struct platform_device *pdev)
+static void vfio_platform_remove(struct platform_device *pdev)
 {
 	struct vfio_platform_device *vdev = dev_get_drvdata(&pdev->dev);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 	pm_runtime_disable(vdev->device);
 	vfio_put_device(&vdev->vdev);
-	return 0;
 }
 
 static const struct vfio_device_ops vfio_platform_ops = {
@@ -113,7 +112,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
 
 static struct platform_driver vfio_platform_driver = {
 	.probe		= vfio_platform_probe,
-	.remove		= vfio_platform_remove,
+	.remove_new	= vfio_platform_remove,
 	.driver	= {
 		.name	= "vfio-platform",
 	},

base-commit: 8ffc8b1bbd505e27e2c8439d326b6059c906c9dd
-- 
2.43.0


