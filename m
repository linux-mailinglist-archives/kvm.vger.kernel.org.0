Return-Path: <kvm+bounces-63527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 78501C686FB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:10:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 87B472A68E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A863090E2;
	Tue, 18 Nov 2025 09:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b="qOgfQ9+p"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023124.outbound.protection.outlook.com [40.107.44.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ECF2571BD;
	Tue, 18 Nov 2025 09:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763457011; cv=fail; b=fuQiKmmztk5se9MIVl8rCGQUyzTP7bi7EOzMpYnlflD7djbbz5EEIoSnwuizv50xWdUst7bwd+WMqO0sgWFWqUo2FObBJjKRNb/YQYv12zlcGJMo0MQpDCAVykO9i/hf/heqTVbvCOjYMeeuUmMXFJDz7mJN8xY5EkvmAm/bbMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763457011; c=relaxed/simple;
	bh=XxkEVvZj1DwAdW0jek5MKiALkGnKzeoeoUVHKy2k0Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XfGRge96lE+nCopaIv6H6gylXPPKEcpmSLqd/0GjbGlHDnp96yLVqYce+HtVAU9YSRFyJE/nYXf/k+GcdxFDmxOP4AKqELvY6RlCqBtWpk3Dh+scGxwVN0sc/iWvmE+EVxVgF28pBD/a4zc/Bfw/KVYY+m0T/BJvfY2KKPscuQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com; spf=pass smtp.mailfrom=jaguarmicro.com; dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b=qOgfQ9+p; arc=fail smtp.client-ip=40.107.44.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaguarmicro.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NBDh/UQzWGEWrp56FDntFj9Gqhm6s4k/6RJg9iHfsST+5wZUBMihTW9zNDDA+l5gMGzE8oic1zstLSk9T/RnfhfjTV5pxlsCBZN6lq+bBd5ebBLbO8lniVikmnfIL3EYedExkv2c4pnqixsqsDjbmgW0stL7ExkS/VXPbNgYwdr98NU4aVXlbDwrX2LgVGzBDM2PdsWdTMXVxgNGfsLqdZ7VYqTCkr1LO90aunwHfajj0X5fXjIwcKGBLQeI5AlrViMhd8PJcVB2uBjCB9+T/H2nWT9kFS0HZV5XVj3E9un7/9HcpwrlMQ1eUJtI6b0omre0oApjKn1GAQiwKAl6aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J3JbsAmV5B+NeJFmwJdE0LYXLLtQ+bT1fMQhjvhrKTo=;
 b=QNVbMvkgkkM2LVw6R/C/BmRj8Io3e4U68+90pKj1RgQA3lUEZV9QsyEQMJ9l39tPOWcCoB79nEghLiDzgKErpOYu/Ax1KSCcb7s6nPiWhMtcunWLBWVQtegd0NlgWI33h7DEWW4nfAcimK76YFg1pmqBQ1GNUpCgPhAYaUpi3fbBrEb3NHyKCpLs4rswfWiLvAbfcnmx6jVY1ANSWCGLRfmIMc7H4UtJOVx8ah/XS1gt+gagUtfyacbz3y+cQyDWEmMmg5DgJzgWdWL4XlzKTnx69HAi52FY4esrwm9zmKidqnfYj0daRgS/S+zC5bcFfW30OyaFbMZy1QdUrn7UlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3JbsAmV5B+NeJFmwJdE0LYXLLtQ+bT1fMQhjvhrKTo=;
 b=qOgfQ9+pOHY7ZfsVK/03Iqgl+pRLXXy4wYkhqJI0OZm+znw5Z8XG1d1X4jdfJkoNEvQQIYUdt2rXKDR2LdHq66LGUG9x7o5HLdfTDipVaGcMZj+S+kOpp6/aEXqb/q8gvi8jKQSzLpaHjhRvhiogTquOJS6aXtnwgRqx17EL8UT/q8nJyxtdzND8rxLV8O3wUDR0O4SDjiKJfVqDw6eNpOBbC6ZUAKwbz+edbTCwmwoP5p2m+nzD9NbVPrxQ8R5bk/3ZAs6BtveIkKLh12hR8zFEs8zeSCuAVYUnRwrszM0SaFEYNZmgtgvcJ5cN8crTIrnXJJV7tqmK7bt7oNf+pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by PUZPR06MB5902.apcprd06.prod.outlook.com (2603:1096:301:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 09:10:00 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881%5]) with mapi id 15.20.9320.013; Tue, 18 Nov 2025
 09:10:00 +0000
From: liming.wu@jaguarmicro.com
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	angus.chen@jaguarmicro.com,
	Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH] virtio_net: enhance wake/stop tx queue statistics accounting
Date: Tue, 18 Nov 2025 17:09:42 +0800
Message-ID: <20251118090942.1369-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.49.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KUZPR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:34::18) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|PUZPR06MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 66c5b884-76d7-46e4-aa59-08de26823fb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9A8+7xEIuhspZTUq9sfaf2R0AqLE3O0cpbHiJuj3uW91zXhTwd7HsCdxNOdO?=
 =?us-ascii?Q?o3F91L6YMs9TvQ4eEb2zEKEJo8LR1/69U2bW5kFP8rwgzahXUJAWg1Adde+0?=
 =?us-ascii?Q?X2NsfP/jEiq7UWDUmu56BehoA6Om7MnDeNWBdSJigdcfKPLGoxN1Vd8xEvam?=
 =?us-ascii?Q?QgvU1S6bWtJjpBlOpwga5FIC+vZXNq4ANOToggtu5NpOCYaWjm7fU+Zmkduf?=
 =?us-ascii?Q?6AlQbv4iwmS9OcB0x0nUc2cq45rDddyO+MD6xzFr0zFRWLU0pPSqbyvZyeKb?=
 =?us-ascii?Q?N6AClRC3rOmckvr/h4RvD3CC9NJQGQ1Auxh/HeepljPQiV6096eNpKx56e3M?=
 =?us-ascii?Q?SXdyTY6svNGzI2/shxdu7gvbdqREeGm2zcmlCxWa/8S1Ak0kMXMsxrM59ecr?=
 =?us-ascii?Q?06eWlSGH9pE6+tS09kVTf8u1T1ejIpUDZ8sKP5fux8z/TZb8tqEzig9lCctS?=
 =?us-ascii?Q?AB/9xrkKL+W6Km+17VWjo+PkcXps2lttNh2EoF6gL3+uil9dGXIqusi8Q1ov?=
 =?us-ascii?Q?fxmOh8JgEvLS9xqzXoskdfgbWxNmOaQYV68ypRMdmuIxwSMkSwWBEg/VsUkT?=
 =?us-ascii?Q?JPEWe3Med4pRv0+QSdglASKpsb15t1VK1y77d0KJYSGy7XaFViJaL9A1YDel?=
 =?us-ascii?Q?WbhJvBSGWZXAUDzISfb0ZkELnOiiMVETURdSE/ErxVlVG/pQitBfBgeE0hCv?=
 =?us-ascii?Q?EYJSoazmzo3poBKcHKvQiCc95DsDC7Lfm4j8McteoGb+dPQegU+R0onLtYsL?=
 =?us-ascii?Q?+5Xc9l0dE9pQqjMdet7ly6r+UtGGEZ/8m1G6QhyCELXchRP4+1qvMZKwamKq?=
 =?us-ascii?Q?/5mEvs4ClzD1RRe3FWWLb8CNVhiIqDYY5Al/yaifZbv9I6ancxNUt/QnWMJm?=
 =?us-ascii?Q?ibvIJ7A4qgumaS7GhiY6E9Uc3/oTM3JxUvDRDisr60PRT2HJDUvE8O8NOpNi?=
 =?us-ascii?Q?T89m9ojV6q1QNXU6BpE46RWBXdhd0wCp+AauGDxxEQ9/cDhsaZ+L2P5q56wY?=
 =?us-ascii?Q?HYJcfluRC5ePjyt+hgP6bvWMcGRcfwVarWGzfNCKc20nLCRdBApB2PS0r1n+?=
 =?us-ascii?Q?jHq1MeYi8CLDJ4R2TVrABIYCKt88L3GjzZfit0IIQpG6c3o82LV7bXvjBcv/?=
 =?us-ascii?Q?C5Ncm6q/2C4ZpWL2YDaPlC8AAz9wsPzBccMo84xoFwJpSceznGqC0sN55nUc?=
 =?us-ascii?Q?lvFYQzt+udUrKsxsfZKY8GGmbTiAoYC8m9jmzDtrkuQtso6R7R8FxIbLqY+T?=
 =?us-ascii?Q?6byuJY+b4zs1dp4eKT31x55o3jSqfGnj+iBJMjcCOgp2vXn/AVHJ+fGgmwrn?=
 =?us-ascii?Q?pMdJWPr2SLkwcPNzHfSqGMyan+/1eXEGIFGqmlrR0LwEpvJewDDwAcqB9VV1?=
 =?us-ascii?Q?SEtg9yZIGeqArt2pO/OQkAqsYfnZ3nrZgCz3L6+IdjNrIU0agKMrZTBAqnvD?=
 =?us-ascii?Q?4RbU0TIyzniAF/G9cdd0FwqsUiTJJ77cgOWjXkxJz2pKWCFtfI6KdLzeNwwZ?=
 =?us-ascii?Q?FjBtJ/nepSw4j58VZZWncM9ahKrTfKqzud0F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kWaiVluYrVtpkUxnJX9Xn7a2cfayvXOUZ2ETcdOneayRxmC/qQCrJBPn2a8s?=
 =?us-ascii?Q?OUJrIUPpyHU0g6NQxM2/0B3DN/rQc9Th2FJLTAAuosy1OQYGiJ9u/+zxrj9Q?=
 =?us-ascii?Q?8Hvh6tGsIiLhlo1me0UUhvN/sNkvV0KY6SFf7BRmTHQNjEd/NJufulP6GTqN?=
 =?us-ascii?Q?JGgJb3DC4HwDV77pgVSKQd4xdfoIbJStZSwr13IV67EyEoGaICltXFuah0DJ?=
 =?us-ascii?Q?OVhnXdL3H+B1NDdSxUKHnt/ApUtl0fapRQBDGZgkwC5aAw8pQAihHjaSfYUe?=
 =?us-ascii?Q?HxcVyl9UjuInwZFiv/dKE2dyFicrxwQ7Qv972mTE+GtP2wgKNN70dBzbLJZM?=
 =?us-ascii?Q?97YmY44V3I8FsvExgv0rV51Hn9k4gEKS6zbudc7KK0WQUIbfLtvPWYXd2FXw?=
 =?us-ascii?Q?WT7V9cZiiEdTCUbSggpHJ1n7FujXiDj+whjUwucCXPXp2F3ln5k8RwScb1IP?=
 =?us-ascii?Q?8NSjOAoYVEfa2Vo8YJVQ+4JKH3ThkYK63v2tbRtk9HzHHyGX/zmnnPXPBGgx?=
 =?us-ascii?Q?hn6X/abC95S8coHtF6JqfTKplH1kEzJeJ0XXDfT2+pLswDt/ZJl61AaHeX7J?=
 =?us-ascii?Q?0XJlFYqsoDv7yDdYwa1eBfbCRKzPPq/PRgJ9lcTD20CCcz9awH+snZE9SVbu?=
 =?us-ascii?Q?nAowrVK4ySMe3VKQssp07uF1NABu1Zx5SoGX27Vj2bJnq9cfV81YcBDTf4XI?=
 =?us-ascii?Q?C9FpUxaAFdVMHXbDnJTziKR+fjz46ciw3JMKVeHsP3fiseqwdVEPH+1by83Z?=
 =?us-ascii?Q?DBLXhGNgk3GQ7FwxaOih4+R94TnKN46ucdWd7kk92DlvNanVA8Yu5tRJjF/q?=
 =?us-ascii?Q?Iwby/ZgEQMdHDxYva2OyrkIE7/6tZp2KDFB/OkerW2RQWW3JN37+9x19waVW?=
 =?us-ascii?Q?LTGZqAANplkbkANXCBk6NT7taKTRjqQn1SGsQAQ8apj4LVcpsCY/NgmrgMqd?=
 =?us-ascii?Q?RysL/nPsymW+0Ns5fdkxfmKVqEitAMpY6dsuL7TCGVZ8MOit+X3lxfeObrJ0?=
 =?us-ascii?Q?nvr0Nxip3g+0l3c/2GALmALpgTzgHT/Cv4vvhBHin7GYt9Uh9F+GU09Elspz?=
 =?us-ascii?Q?rFE2KJcjOC0M9gWWvE4IeRAsYw7ShzbyhFPvWwqqt9Zb2KDFir/ngdFmTb5s?=
 =?us-ascii?Q?OMk6N4vko6/y91+1DhlRaAweR6l5JuUvH16uctJxHeIf+Dg9J4NC+94JXkyA?=
 =?us-ascii?Q?xptgfDd78mR4lefcadovxruYJXl4sHjQSLFWHJPpoqy5kPfNz6Idi2mhzTyD?=
 =?us-ascii?Q?pXVe39TT71gK5KhgRgS5xMZisyHE42rXlYN8/f05mu9K/aPzs7HzWbusur9q?=
 =?us-ascii?Q?qUQaXsW1tgxBmoKhLRdzD4R8QomKIzvhFJW5Nu4UXI6rNT4vto3fatCUQis7?=
 =?us-ascii?Q?1ogekf1nQGE6JgWrG7wn5vmF+bEbrJLjBs403yZFzybZ+7lzpWJj5LCBhOKr?=
 =?us-ascii?Q?dWZ/Uzi+5SGo8xGUzTcjSPodY7dobxqRxY5o8XsU1LZeo2mnEXXTEnoTUXW2?=
 =?us-ascii?Q?lZ8ugiAYWBr0D7z03cfjYNUrJ6cbAeTn9x9rroQo3mGHrKDwTVMgtesMBAq9?=
 =?us-ascii?Q?gv1ArmHPFp3DSj3mwOk8gQWvaVa4Z5bh37NyvDJFokns0K9bVaT/J1TdL7jb?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c5b884-76d7-46e4-aa59-08de26823fb5
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 09:09:59.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWRMa2oAeoETjSGKVTTl/icQJTLTnc2Z0BHpmStNX5NcmgF9igOC2X/oPJ0t2c84yZoaQahfIhpLJvdQdbXTmO1BH8DaQuptxEuBxJxYqmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5902

From: Liming Wu <liming.wu@jaguarmicro.com>

This patch refines and strengthens the statistics collection of TX queue
wake/stop events introduced by a previous patch.

Previously, the driver only recorded partial wake/stop statistics
for TX queues. Some wake events triggered by 'skb_xmit_done()' or resume
operations were not counted, which made the per-queue metrics incomplete.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 drivers/net/virtio_net.c | 49 ++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8e8a179aaa49..f92a90dde2b3 100644
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
@@ -1166,10 +1181,7 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
 			/* More just got used, free them then recheck. */
 			free_old_xmit(sq, txq, false);
 			if (sq->vq->num_free >= MAX_SKB_FRAGS + 2) {
-				netif_start_subqueue(dev, qnum);
-				u64_stats_update_begin(&sq->stats.syncp);
-				u64_stats_inc(&sq->stats.wake);
-				u64_stats_update_end(&sq->stats.syncp);
+				virtnet_tx_wake_queue(vi, sq);
 				virtqueue_disable_cb(sq->vq);
 			}
 		}
@@ -3068,13 +3080,8 @@ static void virtnet_poll_cleantx(struct receive_queue *rq, int budget)
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
@@ -3264,13 +3271,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
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
@@ -3521,6 +3523,9 @@ static void virtnet_tx_pause(struct virtnet_info *vi, struct send_queue *sq)
 
 	/* Prevent the upper layer from trying to send packets. */
 	netif_stop_subqueue(vi->dev, qindex);
+	u64_stats_update_begin(&sq->stats.syncp);
+	u64_stats_inc(&sq->stats.stop);
+	u64_stats_update_end(&sq->stats.syncp);
 
 	__netif_tx_unlock_bh(txq);
 }
@@ -3537,7 +3542,7 @@ static void virtnet_tx_resume(struct virtnet_info *vi, struct send_queue *sq)
 
 	__netif_tx_lock_bh(txq);
 	sq->reset = false;
-	netif_tx_wake_queue(txq);
+	virtnet_tx_wake_queue(vi, sq);
 	__netif_tx_unlock_bh(txq);
 
 	if (running)
-- 
2.34.1


