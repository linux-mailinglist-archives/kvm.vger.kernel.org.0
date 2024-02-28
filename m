Return-Path: <kvm+bounces-10227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD9F86AC90
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:06:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FEF9B25605
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085C713A874;
	Wed, 28 Feb 2024 11:05:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB00F1384A8;
	Wed, 28 Feb 2024 11:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709118337; cv=none; b=NBf3M3UjYUF9+V5WCE/s27Dy91/aveKz8Wry8vssY2Dsk+g2Kuu6F8/lTZjMGznV9W0FDeTo8zfwDEtiAqBsWUe1OUkjIDMmUSJfqMGjo1NEzvfQIhvGBVvbJ0sjtDi2bXHbYYjn3x2xeME0NrCgiUVzMnkeJqwKHovb8Y3Qa+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709118337; c=relaxed/simple;
	bh=vvPzA5m67iNmEEVtRfGj6EfkA8sicGIPKVEKqQRXXaQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fYE7P5tvVMxw0qzQPF6ZuLxe4E133EyKJVoEJDOxyXzRAz/nQXyheQA0JmBaFU3OUxBiEhfRbOOX+Xh8GjoX6b+ohogvLE9+Gd+F483OArEwhZJeMk7/nRS3hfmLqJh1rC1uGItbFHCljcEzyCV6L6pj5m79npONNlEp3zpt4uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4TlBL24VBszpStF;
	Wed, 28 Feb 2024 19:03:38 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EEE2140414;
	Wed, 28 Feb 2024 19:05:27 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 28 Feb
 2024 19:05:27 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <mst@redhat.com>, <willemdebruijn.kernel@gmail.com>,
	<jasowang@redhat.com>, <kuba@kernel.org>, <bjorn@kernel.org>,
	<magnus.karlsson@intel.com>, <maciej.fijalkowski@intel.com>,
	<jonathan.lemon@gmail.com>, <davem@davemloft.net>
CC: <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <xudingke@huawei.com>,
	<liwei395@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next v2 1/3] xsk: Remove non-zero 'dma_page' check in xp_assign_dev
Date: Wed, 28 Feb 2024 19:05:25 +0800
Message-ID: <1709118325-120336-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500008.china.huawei.com (7.185.36.136)

Now dma mappings are used by the physical NICs. However the vNIC
maybe do not need them. So remove non-zero 'dma_page' check in
xp_assign_dev.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/xdp/xsk_buff_pool.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index ce60ecd48a4d..a5af75b1f43c 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -219,16 +219,9 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		goto err_unreg_pool;
 
-	if (!pool->dma_pages) {
-		WARN(1, "Driver did not DMA map zero-copy buffers");
-		err = -EINVAL;
-		goto err_unreg_xsk;
-	}
 	pool->umem->zc = true;
 	return 0;
 
-err_unreg_xsk:
-	xp_disable_drv_zc(pool);
 err_unreg_pool:
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
-- 
2.41.0


