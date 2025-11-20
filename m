Return-Path: <kvm+bounces-63761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D142C71BC3
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 02:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B17B03517D4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 01:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE6326FA6F;
	Thu, 20 Nov 2025 01:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b="qwJbjdav"
X-Original-To: kvm@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023093.outbound.protection.outlook.com [52.101.127.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA142620F5;
	Thu, 20 Nov 2025 01:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763603669; cv=fail; b=WfAFjx/RHg9myM5ZS+ISGExYshHWh1wnbXiIMwpZiQyF+TDi41k2Qf5B7tGRFYtfLW1NeYIOEcLao+zBgL5QaM7ud8th3G3CBGGqtMEzMOCKsmegRBNFWLmWlc9oehFQvZXdRIcPrxmIOb2xoc0hTNUz/OnNrL7TiGG5cVQ+5s4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763603669; c=relaxed/simple;
	bh=U5FhyJU4N0YHKfkKNLFW119hHFkzS89w48hGp56Zvcc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YirrcO4OzwPSMSUYkIdrWeQjBLo1yQxr3A/NXRRgdfhW4iJtVewcdepDJXWa3HMyfH2J3Ii7an+fRklmrY0RrgnoYO9b7Q9uu8Bx3716SzA/N43rvoRkJkt27TnUoqUNz1xyUUXCAoXDk3cJYlXLmBjEs6LxyOHlVfqatikGO+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com; spf=pass smtp.mailfrom=jaguarmicro.com; dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b=qwJbjdav; arc=fail smtp.client-ip=52.101.127.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaguarmicro.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RWvxdwWNsWI4veT9f6/9l7hmXJ2AiVJHvHWUipapCpkU8senJWF2MI9HDaIzFfBjWNel84jttrSpVcE2cMjFbmgRzw7JPcJCNlwW7NAeIWx0LRMbyPMPMnGspGNaEtuqz6OiLOZTnIItIgqUSs+zFf8CMZESpHRiOGa18mmueLZ1hDWMIyPsWI0wBjAh8sYAGh8UOucb87soxZvnq453f7HPcZtWVQbolXOFF+G9bVUb44kctyiXR+ec8SXvth/2/A4rzF88vlmop8+cn+AeHfh8u+Nb6ycsqRjqtA73LGy/a6sb+N9DKL1jpxhIMRq3oiDwhz5P88V2/FGI76JLuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDVvC4v5wLvP65UynYCWkQsr1yvWZkjwbm7DHTQigVo=;
 b=e1qlx3tE7SbX2+PTZF74XlqvLRXUd4ar2dlLrMMKNdU2alsj+evuk+bW3JzBg3bAaYQ4YNGQ8w6aVenmEADMko0T8qZfcSGuJnOuEGq1Y6xgvwVkKYvt68+fvn3FUHBvDW+h54+7jwa36ucigC/NVDhyjHuVMg1FkpmmhHa9N0dQenpH399ZYMSYgimhf56XOQuXpysWXt5zvZVyWFIIyixYCHsW6bdSqo32iw3s0qJoDLJHhFyueSwqRiDKN58KS88opn1NY5vEIe6O4bWlrSGxTnkIH7dG/kSAWrNIo5kZ7NwywMZ2ZuO71IaOCdNKIygReMqDfNzfOe+8wZvL2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDVvC4v5wLvP65UynYCWkQsr1yvWZkjwbm7DHTQigVo=;
 b=qwJbjdavHDvQdWgV2xsV462sTDYy/B0nXPP3owBg5EzMiMUAsqkXyZXV6/em+H6EY708++QUuDxpVSkt6OFOQ/UR9lLO1xmFVef3pfc2xq6YRGAVuQbJ/GNm7jzAaaPYj0VsuS3wpth7Xwurzxo+pJ5kZAvP1W8NVVx/rVkq8lVqM96nR8805VOjRqPYpE43hxTmO5g85DbAt3kFyrKx/FyWiZ9M0Wewvau4W87dvIhXPTrzHkZdHJLaciEDMiVIGo+BRJvqdi7fJGu0Q5wWhOGUlWietOWZtx2z/YH1o8Uk5/G+YCoRT1pGuq7sTuhhXRwUUSttfJvSHHr59dhgdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by JH0PR06MB7233.apcprd06.prod.outlook.com (2603:1096:990:94::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 01:54:18 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 01:54:18 +0000
From: liming.wu@jaguarmicro.com
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	angus.chen@jaguarmicro.com,
	Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH v2] virtio_net: enhance wake/stop tx queue statistics accounting
Date: Thu, 20 Nov 2025 09:53:20 +0800
Message-ID: <20251120015320.1418-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.49.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0209.apcprd06.prod.outlook.com
 (2603:1096:4:68::17) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|JH0PR06MB7233:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8d6b10-29f9-4900-0231-08de27d7b747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X7OOxFn2NngjijCvs9YWc9iIELEyPoFKYy7Y+8En/ZD2nN+qh/YKqXWxKTGZ?=
 =?us-ascii?Q?a+GC0NyuTSJU2ILI2pyRRr/dPY4SiovEaqX+aFeJi6jh63u7SkiAdOJQ1cDP?=
 =?us-ascii?Q?ijvZW5UXfs3mPOkx/5/eHed4G0lc19p9srC8rq0hCjyoSi1lKSuEBRS3T8SJ?=
 =?us-ascii?Q?zonRXnzqjhVhsmK0n/K9UPgyQvZp3ZmHbvA2RFxDvboXDZwD9y3og/Ax5G1a?=
 =?us-ascii?Q?yEOsMYBJM9qEd7f2L0MmAUAvCVr7HiiTNAbIY2zjS88Lf2Txf6PJz0urdaS9?=
 =?us-ascii?Q?IEfscET2TjpqNSWLq+F6xJ+JzuwbcCEGZ6JJS7TndPCIhR6UxPRY20F/RUMq?=
 =?us-ascii?Q?YNMV+VkDxmannvgpGIf6GBXfyb2hRGPXQSVBAtyfA4Dr6pACmnShNxpyok6p?=
 =?us-ascii?Q?NDMihnaCvEGvzUOt29WfPeX7OZyUabKyGRu6vSATNvErUvIs+qvjQeIr4sCS?=
 =?us-ascii?Q?GpgyZU3x5azz35wucLOVSFOW3KxGDDxfHf6+tMFey2yyDwQJEgdi7YyCx/bm?=
 =?us-ascii?Q?phjE1VnFIxW9hYdrI/ma0MgE1ygXgJPX0yjaBh+NEP3pp+EsNJESMrZSPAfa?=
 =?us-ascii?Q?3vie7/vfvBfKJtHfIuC93GbrNx7wK2l838tS1QqWSGsQauQyu6adXUyivDon?=
 =?us-ascii?Q?LuM23udmixuOCakTA/tef4/1ksHnNT14dwhNcKRuC4y9otAciZWMKHvB4dFr?=
 =?us-ascii?Q?xRg568SUxGEo2K2IEum0tjpE9bDHHusC62lTE1wO+LVysgoSTNnIWQNOCc/i?=
 =?us-ascii?Q?rEaKdVygd3WBCnHT6h8KW27u0pXqJYowIMjQVZhhJkHXcZxMqRSAs5Qio0HC?=
 =?us-ascii?Q?z82LoXpWdStkux0xylijWTJLUFjlHgqbtls2VwCkLCFZzYhDy0DsgD8qNDfN?=
 =?us-ascii?Q?8PuPuL93etUxBR8t7gjk8mgQ0VuEr5JZhVwNoHB/QLjPeZvRfpSivpwRsKA2?=
 =?us-ascii?Q?5DDQIDvTlvoMRFuhrgWuixl0j/HbRFrU59ttldoX3firf0mkxzDiXBc2gy60?=
 =?us-ascii?Q?2gZtPz0exKz+dKhykQ6UwHH5Ys3kNw5DsJ8oTLFG3G1351sAp+0kp9fwQtYp?=
 =?us-ascii?Q?8H2FWrzzzS2m97vNLq4+s/Ix5+hs8vQzeDyfVSkKZuet1hMniXm0A5nT//2Q?=
 =?us-ascii?Q?mHOh01snVS+qlZRMwkxiHnf9hri5QzurgUdoWwBsoeF9bMBGpa9ZNAVB+zGS?=
 =?us-ascii?Q?PDmGxRspJCxDjq2rr3TT3YK5cNWZ3VZeAnj8hl/2IyPRRvZD5bls9UVyEf4m?=
 =?us-ascii?Q?muF0CQcbJkwmYr5b4NykFTGKzegXAOswri1zwMRlBOn4pUa8eGK+ez47jsuV?=
 =?us-ascii?Q?lyIj6YG5yhDgwwhG9X4+REiPti09P7JzK31TK0PgSxRkD/n9ENM7LjqjVBa7?=
 =?us-ascii?Q?h0hF9MFVfNlvO34lR8Z1KibAgmcbROmbqf3vIawmzhTBmUSKPfIKN5oLsY3O?=
 =?us-ascii?Q?UJBS3TphIHQuthmBGm4YbUT46UiGRGlukLo4dZyNnovweTahONZUxgbpQAlV?=
 =?us-ascii?Q?vQC3IdnWsNlsRU5BiYDkhkg+JlZtBEtE6S6c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mb8lnjzPnWt2dk5v2sdnj1HhzR/VYCNW68MQD5PyYNAj8VVR7V2wiEtVc3ub?=
 =?us-ascii?Q?Q3d6D/QW9h/FM71H6wzorOX1itQghF4phvTtaKQbl18+oU6GMRJupf5JjpM1?=
 =?us-ascii?Q?wd9RMAYs40gt3t0azkB61w3PuamttpYTiYfe1VdNlME4o601c25crMjmymBy?=
 =?us-ascii?Q?7M5HsZZ0I9WTLDYWLQPOZXKrsfjx4QIzIUlE6uMzn/VWWRUgKv/rvb4LzdxN?=
 =?us-ascii?Q?wtfPDEMj0fUauYEy+XUQziKBTGgGm7BIUWaHv9sXLIlq9G/KRPvgFI2ruhVG?=
 =?us-ascii?Q?dQq4QpzeKZeHAPdr9XK78i/IJX+MZFj/5Sp/YS1HcWwn9kqQbj2iL0eBPeo8?=
 =?us-ascii?Q?4LU2077I1SVdlnYpeiD2jyd8hhfLGh9chC2VQ/sCFfmcIPwGiPzHKJYkUdo+?=
 =?us-ascii?Q?J+EmtpU2YhlxKAwWJX3oKHJYWzOHF6R9WgxiVGer82fpEnFqurSTZ77j3kv5?=
 =?us-ascii?Q?bKrHH5ai5zWnIPCPCB5THwmmsG1VE/BKnQqlKlYg9+FjSNCyYfLHIq3eOIiQ?=
 =?us-ascii?Q?tvzIgCHywFGyP0jbKSWck1TfxaxhR342Q22LLhJBIgJjXKeBSBGE2bwJbBUG?=
 =?us-ascii?Q?i2vNCAxP2cI9jqO9l2a9K9xvvfD3T+E12vP1qcZL3NeDUvQJHuc6tOQTbaW8?=
 =?us-ascii?Q?E9sTLiOYWRo8NPhPIQyY1IoRbinWEGQWFy5QdlQnlU9DtuBNN0BTzlLG1GuO?=
 =?us-ascii?Q?DdMBwXrVc2blPhwMrx2aox6aY0xgLuF6sWgJq4eqkob4I6A8QkyNNmqYvOCv?=
 =?us-ascii?Q?BKg+LGte5zFRROam0PQAJdtSh2LjaPYWmVCPxnR+wG7KMaG+HGvj46sXlnZ8?=
 =?us-ascii?Q?Zpsic0TLLpHW1XtdSYvfQn5GdEN+jxG1iIcg0MhDRYJl5RX1lWyd+aCRMwM8?=
 =?us-ascii?Q?zfNBt+SIUcSrBRh2lR7APP5rgt36I2LlB42zEZcC1lso9RP0J0S11y06ZY0T?=
 =?us-ascii?Q?18iwq3rSJYSn0YEvj9LXinK7VH4ZF102DVajn4egyuu0ieC17uc2KCYj0TXC?=
 =?us-ascii?Q?sNiOh1qDUwHtn4ci3y0vx0KWUxHQMClZmuerw0a+3J7buVNGw0gny0iQav5B?=
 =?us-ascii?Q?aOPmPebi25uYVYfgUrjwuVUp8u6L5J4ntisEr5ashABu+/TL7G6amXs7/zgL?=
 =?us-ascii?Q?8C0i5DNYhWGJOc4JcN5Bgz9NREpXxaFiVDu/6OgX6iWxMfMrFRo8hNNtF7sq?=
 =?us-ascii?Q?H8PVEhvxWQyln9lfLM7ECf+Jnm+z5hMcgAeXjxVXtm0KtM1aSdkBIarCiRt3?=
 =?us-ascii?Q?OeztEMhp9xTvMRWFhMyoDU2l8d9bZaPbpxekNj0NMNV3MZ7xcgZSd4+IgdEv?=
 =?us-ascii?Q?MvmtKPosOBIgmuCnMjB8bo0U39FRuS3U9um4XQQpqXan0Hvc7z/xXnze8FYD?=
 =?us-ascii?Q?8VXELAl4v7i3U/VOxgcUJfADAY6jDErPfdX5ls6IKNsTbqOhvo+tccdZj0d4?=
 =?us-ascii?Q?CycyY76RShYFwjwUJkXAtb6Az/l5OuJ1gqlz5RbSncJD95zgiYuUESPyfmh0?=
 =?us-ascii?Q?VmLa7KYtRfT2dtuTMtA+NhIL7x4quEZlKM+m7C0Y3Sn8zExNaclDYbMAkaDm?=
 =?us-ascii?Q?BFuUF/3YlSGYVyMMhcNO4K43A9dgI0Hdc0XZtggjPgvRtxtvsVMBC9xjLymR?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8d6b10-29f9-4900-0231-08de27d7b747
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 01:54:18.2231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIIiFkZeM09mUPmNQJH62bJWUje+/9yCxgwyhbwx+Nn6TwyysxaHewF20Ox4KJNu+eOzVOfd4NmbU1Qn6NkZSc2lc0q+ZUa556nU2L7mxlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB7233

From: Liming Wu <liming.wu@jaguarmicro.com>

This patch refines and strengthens the statistics collection of TX queue
wake/stop events introduced by commit c39add9b2423 ("virtio_net: Add TX
stopped and wake counters").

Previously, the driver only recorded partial wake/stop statistics
for TX queues. Some wake events triggered by 'skb_xmit_done()' or resume
operations were not counted, which made the per-queue metrics incomplete.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 drivers/net/virtio_net.c | 44 ++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8e8a179aaa49..b714b190db2a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -775,10 +775,26 @@ static bool virtqueue_napi_complete(struct napi_struct *napi,
 	return false;
 }
 
+static void virtnet_tx_wake_queue(struct virtnet_info *vi,
+				struct send_queue *sq)
+{
+	unsigned int index = vq2txq(sq->vq);
+	struct netdev_queue *txq = netdev_get_tx_queue(vi->dev, index);
+
+	if (netif_tx_queue_stopped(txq)) {
+		u64_stats_update_begin(&sq->stats.syncp);
+		u64_stats_inc(&sq->stats.wake);
+		u64_stats_update_end(&sq->stats.syncp);
+		netif_tx_wake_queue(txq);
+	}
+}
+
 static void skb_xmit_done(struct virtqueue *vq)
 {
 	struct virtnet_info *vi = vq->vdev->priv;
-	struct napi_struct *napi = &vi->sq[vq2txq(vq)].napi;
+	unsigned int index = vq2txq(vq);
+	struct send_queue *sq = &vi->sq[index];
+	struct napi_struct *napi = &sq->napi;
 
 	/* Suppress further interrupts. */
 	virtqueue_disable_cb(vq);
@@ -786,8 +802,7 @@ static void skb_xmit_done(struct virtqueue *vq)
 	if (napi->weight)
 		virtqueue_napi_schedule(napi, vq);
 	else
-		/* We were probably waiting for more output buffers. */
-		netif_wake_subqueue(vi->dev, vq2txq(vq));
+		virtnet_tx_wake_queue(vi, sq);
 }
 
 #define MRG_CTX_HEADER_SHIFT 22
@@ -3068,13 +3083,8 @@ static void virtnet_poll_cleantx(struct receive_queue *rq, int budget)
 			free_old_xmit(sq, txq, !!budget);
 		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
-		if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
-		    netif_tx_queue_stopped(txq)) {
-			u64_stats_update_begin(&sq->stats.syncp);
-			u64_stats_inc(&sq->stats.wake);
-			u64_stats_update_end(&sq->stats.syncp);
-			netif_tx_wake_queue(txq);
-		}
+		if (sq->vq->num_free >= MAX_SKB_FRAGS + 2)
+			virtnet_tx_wake_queue(vi, sq);
 
 		__netif_tx_unlock(txq);
 	}
@@ -3264,13 +3274,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	else
 		free_old_xmit(sq, txq, !!budget);
 
-	if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
-	    netif_tx_queue_stopped(txq)) {
-		u64_stats_update_begin(&sq->stats.syncp);
-		u64_stats_inc(&sq->stats.wake);
-		u64_stats_update_end(&sq->stats.syncp);
-		netif_tx_wake_queue(txq);
-	}
+	if (sq->vq->num_free >= MAX_SKB_FRAGS + 2)
+		virtnet_tx_wake_queue(vi, sq);
 
 	if (xsk_done >= budget) {
 		__netif_tx_unlock(txq);
@@ -3521,6 +3526,9 @@ static void virtnet_tx_pause(struct virtnet_info *vi, struct send_queue *sq)
 
 	/* Prevent the upper layer from trying to send packets. */
 	netif_stop_subqueue(vi->dev, qindex);
+	u64_stats_update_begin(&sq->stats.syncp);
+	u64_stats_inc(&sq->stats.stop);
+	u64_stats_update_end(&sq->stats.syncp);
 
 	__netif_tx_unlock_bh(txq);
 }
@@ -3537,7 +3545,7 @@ static void virtnet_tx_resume(struct virtnet_info *vi, struct send_queue *sq)
 
 	__netif_tx_lock_bh(txq);
 	sq->reset = false;
-	netif_tx_wake_queue(txq);
+	virtnet_tx_wake_queue(vi, sq);
 	__netif_tx_unlock_bh(txq);
 
 	if (running)
-- 
2.34.1


