Return-Path: <kvm+bounces-6197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A34A82D43D
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 07:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A14E28165E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 06:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A855C98;
	Mon, 15 Jan 2024 06:34:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E65D522B;
	Mon, 15 Jan 2024 06:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 37fabb17f9ea4358ab45ae9f4848a456-20240115
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:5cdaf591-cd0d-448e-841a-60b734cb7632,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-10
X-CID-INFO: VERSION:1.1.35,REQID:5cdaf591-cd0d-448e-841a-60b734cb7632,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:5d391d7,CLOUDID:c7c35a7f-4f93-4875-95e7-8c66ea833d57,B
	ulkID:240115143441BZBJPDFA,BulkQuantity:0,Recheck:0,SF:44|66|24|17|19|102,
	TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR
X-UUID: 37fabb17f9ea4358ab45ae9f4848a456-20240115
X-User: chentao@kylinos.cn
Received: from kernel.. [(116.128.244.171)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 233800738; Mon, 15 Jan 2024 14:34:38 +0800
From: Kunwu Chan <chentao@kylinos.cn>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v2] vfio: Use WARN_ON for low-probability allocation failure issue in vfio_pci_bus_notifier
Date: Mon, 15 Jan 2024 14:34:34 +0800
Message-Id: <20240115063434.20278-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

This is a blocking notifier callback, so errno isn't a proper return
value. Use WARN_ON to small allocation failures.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
v2: Use WARN_ON instead of return errno
---
 drivers/vfio/pci/vfio_pci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1cbc990d42e0..61aa19666050 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2047,6 +2047,7 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 			 pci_name(pdev));
 		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
 						  vdev->vdev.ops->name);
+		WARN_ON(!pdev->driver_override);
 	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
 		   pdev->is_virtfn && physfn == vdev->pdev) {
 		struct pci_driver *drv = pci_dev_driver(pdev);
-- 
2.39.2


