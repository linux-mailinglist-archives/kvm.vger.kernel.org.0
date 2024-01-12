Return-Path: <kvm+bounces-6133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D34FC82BBAE
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 08:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 790DA288509
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 07:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F695DF2C;
	Fri, 12 Jan 2024 07:22:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054195D919;
	Fri, 12 Jan 2024 07:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 477e03e742094c3a81d7a56c68d3f3f1-20240112
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:bfa888c2-196b-4123-afef-3393926d8296,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:30
X-CID-INFO: VERSION:1.1.35,REQID:bfa888c2-196b-4123-afef-3393926d8296,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:30
X-CID-META: VersionHash:5d391d7,CLOUDID:f1f92c8e-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:2401121521451LMTVSBG,BulkQuantity:0,Recheck:0,SF:66|38|24|17|19|44|1
	02,TC:nil,Content:0,EDM:5,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 477e03e742094c3a81d7a56c68d3f3f1-20240112
X-User: chentao@kylinos.cn
Received: from kernel.. [(116.128.244.171)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1529031778; Fri, 12 Jan 2024 15:21:43 +0800
From: Kunwu Chan <chentao@kylinos.cn>
To: diana.craciun@oss.nxp.com,
	alex.williamson@redhat.com
Cc: eric.auger@redhat.com,
	Bharat.Bhushan@nxp.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] vfio/fsl-mc: Remove unnecessary free in vfio_set_trigger
Date: Fri, 12 Jan 2024 15:21:28 +0800
Message-Id: <20240112072128.141954-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'irq->name' is initialed by kasprintf, so there is no need
to free it before initializing.

Fixes: cc0ee20bd969 ("vfio/fsl-mc: trigger an interrupt via eventfd")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index d62fbfff20b8..31f0716e7ab3 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -69,7 +69,6 @@ static int vfio_set_trigger(struct vfio_fsl_mc_device *vdev,
 	hwirq = vdev->mc_dev->irqs[index]->virq;
 	if (irq->trigger) {
 		free_irq(hwirq, irq);
-		kfree(irq->name);
 		eventfd_ctx_put(irq->trigger);
 		irq->trigger = NULL;
 	}
-- 
2.39.2


