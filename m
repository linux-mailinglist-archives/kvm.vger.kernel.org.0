Return-Path: <kvm+bounces-6131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 685A282BB55
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 07:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB861C24756
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 06:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FF25C8F9;
	Fri, 12 Jan 2024 06:41:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C004123C1;
	Fri, 12 Jan 2024 06:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7edd3f55c4fd4d69b495c600238d36e7-20240112
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:075eb1eb-e05a-47d9-b6d3-5f0bf1fca848,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:0
X-CID-INFO: VERSION:1.1.35,REQID:075eb1eb-e05a-47d9-b6d3-5f0bf1fca848,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:bd92457f-4f93-4875-95e7-8c66ea833d57,B
	ulkID:240112144115NLQS0K4F,BulkQuantity:0,Recheck:0,SF:19|44|66|24|17|102,
	TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 7edd3f55c4fd4d69b495c600238d36e7-20240112
X-User: chentao@kylinos.cn
Received: from kernel.. [(116.128.244.171)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 856514401; Fri, 12 Jan 2024 14:41:12 +0800
From: Kunwu Chan <chentao@kylinos.cn>
To: eric.auger@redhat.com,
	alex.williamson@redhat.com
Cc: a.motakis@virtualopensystems.com,
	b.reynal@virtualopensystems.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] vfio/platform: Remove unnecessary free in vfio_set_trigger
Date: Fri, 12 Jan 2024 14:41:07 +0800
Message-Id: <20240112064107.137384-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
add 'name' as member for vfio_platform_irq,it's initialed by kasprintf,
so there is no need to free it before initializing.

Fixes: 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 drivers/vfio/platform/vfio_platform_irq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 61a1bfb68ac7..5e3fd1926366 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -179,7 +179,6 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 	if (irq->trigger) {
 		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
 		free_irq(irq->hwirq, irq);
-		kfree(irq->name);
 		eventfd_ctx_put(irq->trigger);
 		irq->trigger = NULL;
 	}
-- 
2.39.2


