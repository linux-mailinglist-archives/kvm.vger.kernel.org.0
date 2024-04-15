Return-Path: <kvm+bounces-14609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 567FE8A46A2
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 03:50:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7A15282594
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 01:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA55BFBF0;
	Mon, 15 Apr 2024 01:49:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3057639;
	Mon, 15 Apr 2024 01:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713145796; cv=none; b=oIHEVUFB4Pw1sSUJXVedhoUVPjNaoik4X9mWUMBk7Lta0ee8avvXtCnCLoY2T/jLN+rl5MrWb+4HTlnDWDraexpU8pywbIKqhoptW9RrHXKuxF5+iXPMTSBq8WqvaurIo2ctFNs4PVDc9u+BatFj/QrlhDU+7uirG/5MFIzfhsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713145796; c=relaxed/simple;
	bh=Mv/80EYxGhF/H8SBXJeJUFeYkvjR2K8Dq5JVqInNFFk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c/Z2eIWTGAYiE9iB1YMBmtG7U97uqNA3a/GUJO0lH1BxlNZmwLSzHxcRsP4N/1glkkREiT0oPf2ieRlkYrCYbLvarDL2cCDf+VUrGyRhv5Jxgd7R7/GDFM+b3iKdV+ehAH1xbPjd5/je+ylcXKCYYTTvcA8q+pZxT3BxILaJK94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VHqpM67DLz1GHN2;
	Mon, 15 Apr 2024 09:48:59 +0800 (CST)
Received: from canpemm500010.china.huawei.com (unknown [7.192.105.118])
	by mail.maildlp.com (Postfix) with ESMTPS id 019BF180063;
	Mon, 15 Apr 2024 09:49:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 15 Apr
 2024 09:49:50 +0800
From: Ye Bin <yebin10@huawei.com>
To: <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<reinette.chatre@intel.com>, <tglx@linutronix.de>, <brauner@kernel.org>,
	<yebin10@huawei.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] vfio/pci: fix potential memory leak in vfio_intx_enable()
Date: Mon, 15 Apr 2024 09:50:29 +0800
Message-ID: <20240415015029.3699844-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)

If vfio_irq_ctx_alloc() failed will lead to 'name' memory leak.

Fixes: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index fb5392b749ff..e80c5d75b541 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -277,8 +277,10 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 		return -ENOMEM;
 
 	ctx = vfio_irq_ctx_alloc(vdev, 0);
-	if (!ctx)
+	if (!ctx) {
+		kfree(name);
 		return -ENOMEM;
+	}
 
 	ctx->name = name;
 	ctx->trigger = trigger;
-- 
2.31.1


