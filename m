Return-Path: <kvm+bounces-56832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A74B44068
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 17:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 127E11C85E51
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 15:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553592417D9;
	Thu,  4 Sep 2025 15:21:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A7A21CC44;
	Thu,  4 Sep 2025 15:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999277; cv=none; b=jzL/4dC+YZK48aua7iFPJ5zImY95PpROFrC2u+Lg6bvy60KcuEindKQAdKybRWEY/1wct5+Z6/BjYvl1Trtlfz8yI6IFJmbtm6rXRCTdWXnPvrNBpHoUlF/RE6kWFPXsZoApnw+wXVKI/cwV7gIJhSBjLU6fv23ppqibsFy8cdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999277; c=relaxed/simple;
	bh=XQP96wM5JYZm0+Qe4GpN59XpWsfyMS0rQAHTl4lf9/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k6UcXWNrWANSQ2YQqsQoRRleuHA1a4JnLx4GDBQJ8fCtD7u92DO46pC58QmOTaG7hsnWSWBzqTZfCJebCkp/rKn5hFSPpgnGXubRoP5aws0zudkMKCpQNCReukqKqjRugnBid2VxL1C/jq5VmD0FPJXWNxSTzSALidBwvbMdvC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F8FC4CEF0;
	Thu,  4 Sep 2025 15:21:15 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pm@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] uio: uio_pdrv_genirq: Remove dummy PM handling
Date: Thu,  4 Sep 2025 17:21:12 +0200
Message-ID: <a5495b6068dd4e40ae7e0fb66b067fd5b5c210b2.1756999260.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 63d00be69348fda4 ("PM: runtime: Allow unassigned
->runtime_suspend|resume callbacks"), unassigned
.runtime_{suspend,resume}() callbacks are treated the same as dummy
callbacks that just return zero.

As the Runtime PM callbacks were the only driver-specific PM handling,
all PM handling can be removed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.
---
 drivers/uio/uio_pdrv_genirq.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 2ec7d25e82649099..bded5b9f9f3b3c93 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -249,28 +249,6 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int uio_pdrv_genirq_runtime_nop(struct device *dev)
-{
-	/* Runtime PM callback shared between ->runtime_suspend()
-	 * and ->runtime_resume(). Simply returns success.
-	 *
-	 * In this driver pm_runtime_get_sync() and pm_runtime_put_sync()
-	 * are used at open() and release() time. This allows the
-	 * Runtime PM code to turn off power to the device while the
-	 * device is unused, ie before open() and after release().
-	 *
-	 * This Runtime PM callback does not need to save or restore
-	 * any registers since user space is responsbile for hardware
-	 * register reinitialization after open().
-	 */
-	return 0;
-}
-
-static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
-	.runtime_suspend = uio_pdrv_genirq_runtime_nop,
-	.runtime_resume = uio_pdrv_genirq_runtime_nop,
-};
-
 #ifdef CONFIG_OF
 static struct of_device_id uio_of_genirq_match[] = {
 	{ /* This is filled with module_parm */ },
@@ -285,7 +263,6 @@ static struct platform_driver uio_pdrv_genirq = {
 	.probe = uio_pdrv_genirq_probe,
 	.driver = {
 		.name = DRIVER_NAME,
-		.pm = &uio_pdrv_genirq_dev_pm_ops,
 		.of_match_table = of_match_ptr(uio_of_genirq_match),
 	},
 };
-- 
2.43.0


