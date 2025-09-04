Return-Path: <kvm+bounces-56831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FB1B44067
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 17:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 368361C85F60
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 15:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555F523BD1A;
	Thu,  4 Sep 2025 15:20:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF9BC8F0;
	Thu,  4 Sep 2025 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999252; cv=none; b=kBo+GbhWeunrLy48bnO6+IBzsBNhYWuNs6HBQhmdm/JvLhHyJDSzYHTwGGznvukx9Hn0YU1cRI9LApyQyzHnxkXaRcUH3orzeDH6RWheUpMigIFGeOHAFrqNe5+9feOfTs/1oQI3xW5Q7TlQFEs37stFZOjk8IyjORM5Qt1axSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999252; c=relaxed/simple;
	bh=ZJ9jJK3FfUsiMwQrx/J/AG7qSfMtjkMFIYkoHaU9Toc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dm0jZmd76A4NxhAvNov+wFHQE1vuBohIgx81GP9dSKnogAAKY6DwLGsrS/wj5QrgBe65MCgKqp1s9zctpDSljsdFLxSsUdOqH1gfv035e3bumWWRMx2uxQbdhPIQ2/c7uQrlcf5VqQQLRUOdN1YPxKsUq5E85qkQLg3VSeq4bDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5EEC4CEF0;
	Thu,  4 Sep 2025 15:20:50 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pm@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] uio: uio_dmem_genirq: Remove dummy PM handling
Date: Thu,  4 Sep 2025 17:20:44 +0200
Message-ID: <121921f66a2baa125ea62be9436e8b5b12a4ad4d.1756999182.git.geert+renesas@glider.be>
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
 drivers/uio/uio_dmem_genirq.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 31aa75110ba5916a..41c18ec62a4530ac 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -297,28 +297,6 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
 	return devm_uio_register_device(&pdev->dev, priv->uioinfo);
 }
 
-static int uio_dmem_genirq_runtime_nop(struct device *dev)
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
-static const struct dev_pm_ops uio_dmem_genirq_dev_pm_ops = {
-	.runtime_suspend = uio_dmem_genirq_runtime_nop,
-	.runtime_resume = uio_dmem_genirq_runtime_nop,
-};
-
 #ifdef CONFIG_OF
 static const struct of_device_id uio_of_genirq_match[] = {
 	{ /* empty for now */ },
@@ -330,7 +308,6 @@ static struct platform_driver uio_dmem_genirq = {
 	.probe = uio_dmem_genirq_probe,
 	.driver = {
 		.name = DRIVER_NAME,
-		.pm = &uio_dmem_genirq_dev_pm_ops,
 		.of_match_table = of_match_ptr(uio_of_genirq_match),
 	},
 };
-- 
2.43.0


