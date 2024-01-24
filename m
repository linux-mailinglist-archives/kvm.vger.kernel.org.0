Return-Path: <kvm+bounces-6816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A44383A5A3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 10:38:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D65AB1F22042
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 09:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E492F18039;
	Wed, 24 Jan 2024 09:37:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4817BA4;
	Wed, 24 Jan 2024 09:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089079; cv=none; b=LkTwWd3bfegYXFqy1lgvOl/46t5mk16dXdn4MlcFvKIy0BqtpqQ9mdiLmVV6EzUX4UU93mgBNZGlFqkjlofjbDUdgcGSi8sA255F5gKsyMIMDqnStMlMqC29sutek4IWPQT+7P9m0qZSTqh17ske0nQUuKsASJ8WezIqSDYOczU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089079; c=relaxed/simple;
	bh=J3AT3+VejR+WAz1bRYnTL1EVN5BrIzTiyewXbvqaxUc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BU+tXrOFSiY5P60gDcr84E2cd1jMvb6Ndy6msv9Vb0iwfzjdCSLNN2LkQJdeVJ8E/fA7EisWgVbD7rm8DI6tGP4sc2MRBR8IfiLwnSl4yjsx1E4PbMTCTJ8dSUMEAVUZExbL0mVVjv1CA0Zx8r1F60Q4XeoX6X1mLYEyYvWHzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TKf3H4BLXz1gxs9;
	Wed, 24 Jan 2024 17:36:11 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id A1F841A0172;
	Wed, 24 Jan 2024 17:37:40 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 24 Jan
 2024 17:37:40 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <mst@redhat.com>, <willemdebruijn.kernel@gmail.com>,
	<jasowang@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
	<magnus.karlsson@intel.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next 1/2] xsk: Remove non-zero 'dma_page' check in xp_assign_dev
Date: Wed, 24 Jan 2024 17:37:38 +0800
Message-ID: <1706089058-1364-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500008.china.huawei.com (7.185.36.136)

Now dma mappings are used by the physical NICs. However the vNIC
maybe do not need them. So remove non-zero 'dma_page' check in
xp_assign_dev.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/xdp/xsk_buff_pool.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 28711cc44ced..939b6e7b59ff 100644
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
2.33.0


