Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35778B41B4
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 22:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391339AbfIPUWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 16:22:45 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:48783 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfIPUWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 16:22:45 -0400
Received: from localhost.localdomain ([90.126.97.183])
        by mwinf5d90 with ME
        id 2LNi2100K3xPcdm03LNisP; Mon, 16 Sep 2019 22:22:43 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 16 Sep 2019 22:22:43 +0200
X-ME-IP: 90.126.97.183
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kwankhede@nvidia.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] sample: vfio mdev display - Fix a missing error code in an error handling path
Date:   Mon, 16 Sep 2019 22:22:40 +0200
Message-Id: <20190916202240.30189-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'ret' is known to be 0 at this point. So explicitly set it to -ENOMEM if
'framebuffer_alloc()' fails.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 samples/vfio-mdev/mdpy-fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 2719bb259653..6fe0187f47a2 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -131,8 +131,10 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 		 width, height);
 
 	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
-	if (!info)
+	if (!info) {
+		ret = -ENOMEM;
 		goto err_release_regions;
+	}
 	pci_set_drvdata(pdev, info);
 	par = info->par;
 
-- 
2.20.1

