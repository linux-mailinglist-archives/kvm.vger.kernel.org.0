Return-Path: <kvm+bounces-52010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC6E5AFF6DC
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 04:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 145597B5A21
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 02:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D877127FB31;
	Thu, 10 Jul 2025 02:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b="RunCpia7"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022143.outbound.protection.outlook.com [40.107.75.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCB3221282;
	Thu, 10 Jul 2025 02:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.143
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752114750; cv=fail; b=f+fKp4mFISAdU/blaQbFrgJ3cP/98C9YinA9eo4Bvk8Lj/s/9yFicWRZC2pT5otPviiSm37BfFYYt/5sajm3Al+Dp71Ipl3mMnFhO5ehT5TgiPMSdmkr6sLin+es7PYtsZf4D9makIk2KYOsjODsGuMArD7iMNaw1jqlFs+y+Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752114750; c=relaxed/simple;
	bh=Cwe8qO9pQ7/9izpUfuBKmJrKDgxeGIeNFjthKxxsQX4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oN7WIDJf09TPVmWXQhJafAI0sInmSPfUtQyKQDhMJcj+a8oWvvmQERCBfriKOcL9cnVMPWebEWInlq3gcmdg71fJ8pGWB6Bg3HrZxxSZjWZTQmwM/z3Zf8bnFucGh0aBcLcPT6yi+HPrAaasjDqzwul0qKA7ZPHPHaXkyh+4g6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com; spf=pass smtp.mailfrom=jaguarmicro.com; dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b=RunCpia7; arc=fail smtp.client-ip=40.107.75.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaguarmicro.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N4UhVOZsKjdspDszZVFrY32XtscHbgHl54ruz2ByJ9cRMJnCJC/G7m3E4CqRCU+5tp2+9+YwxiAj6xUX+bmxb7rjKo0Fhwri5kwIeHO41HOVTxaNo6rnhtNGrvwKMyDgFp7gFOYXqQBhQ3jamyri5OLRtgA4MzXTNphGFcINM2o5U1/EcTztHeIHTAQFRKwj3OTBYd/VOR4Ql7e1saI5UxnAzqmfZNhd9+4NTk3bizho5gzdnAdadvLRPeQdF1gtZzQBZiwD358QB2ZjDNtc3NQlx6oJ2TCbuioppOeo01aotvGZ4xvRhjllH3qom3mAjviP7Ti9jZkqOv1rOzkgyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hE9pSHcs7Y6xFe6weOpVLN7ANjV+NpyipiXOOydxLhk=;
 b=WdFfhGVYroODbb7N535T/gWUyHvr/YckDk+2s0NAuPam4QEqbqtZ3rgvuEgnkJBm51IIo3ZfqMQTbGs5g0oTcreBCCFv7PnRN3dV+DQ4RxfLNP3nm+SLbVB//t+vP5TCOTneJCHRefwE/l0Clx6mPaQeTfkiFifFAOmKAuwps/dgkJFl+SuPThQikgZ6/MZ8UskaKW1XLzwA5pKXjdyzHA3msbTDZ2rbrvcxSt93QXOzbBe7f4tMggyps95WMuGA02dKu7NNSFwu530I1GLhjRwRg+Bqv3waTMBww2Shoape1InDFESxyLhILmwf8ow88ZsRjqJKmfxuxYwNR1v8+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hE9pSHcs7Y6xFe6weOpVLN7ANjV+NpyipiXOOydxLhk=;
 b=RunCpia77+2UavmeRReOBuF07OAU3Ta7OAT1A8jeJoYY3iepdSu3r3j5Vl4pgYJjTg4iL2wH6bdVKkofx/kMQ1DgN5EK20gPWiskbbFb2wBsky8LMp0LwAa4Rm/5WsavACdqhZ9pVMtdrLl0UpX+rk0zM2o9HTeGT89KCobu+TMFpM3K9kHWdH8/Ml2aAMbCjbDcko5bo5Baj6oNuxnFQU7p9FHebbDsh4IkEt2/N0K/nJEgh1VAkp4DSy60j8AAS6SY+FMcwbOkFl6gJBBVgWYjA6eTpoGsEgM289sBPz74o9vxLyqSpdtjfgYxO85OTltVtstWU+z8C3X09H6Lbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by KL1PR06MB6446.apcprd06.prod.outlook.com (2603:1096:820:f0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Thu, 10 Jul
 2025 02:32:22 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881%4]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 02:32:20 +0000
From: liming.wu@jaguarmicro.com
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	angus.chen@jaguarmicro.com,
	Liming Wu <liming.wu@jaguarmicro.com>,
	Lei Yang <leiyang@redhat.com>
Subject: [PATCH v2] virtio_net: simplify tx queue wake condition check
Date: Thu, 10 Jul 2025 10:32:08 +0800
Message-ID: <20250710023208.846-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.49.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0003.APCP153.PROD.OUTLOOK.COM (2603:1096::13) To
 PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|KL1PR06MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: d0111ec9-fd78-4ff7-9503-08ddbf59fed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nJ67+voyWGZZ+ajKG+bKWUz2XljiJsXjbtqZbCKT2lUnHewt+6al+EdLBUqy?=
 =?us-ascii?Q?FSHQ7iDQhbfY/64Hmvka2wTp/5HVWzjXIeKRAVKm2buB3DSJ14lJfODEbrgx?=
 =?us-ascii?Q?gwF0cPold1+35j4IOZA7BZkTp9ZKLdCS2ACHzAvZnIQN0IHvyod/VBM9j6fp?=
 =?us-ascii?Q?l4xIu4v6Nmr+BYnK9rEJqciMblcH/4FbVJm7bUFliLWIeH6GaAfKCk0Wn2K7?=
 =?us-ascii?Q?uMWvGCXlmk67xQ2rZSufDMfY068MZaxdyp89rc6+4lBD/NZjlXBrWgjfiuo1?=
 =?us-ascii?Q?FatkwVfMxCk51RHO/RnOkM8pCAwGjJGDgTGSsjmmn8uBh9JzN00gWcan6Jpw?=
 =?us-ascii?Q?SDibCx31eoZbBAHW8nNpwf1yb/LKPRk0noXkfzfDeSTAoJGWl6ks72kGMMEj?=
 =?us-ascii?Q?qvERrwc58sLBZAx48Yv6d6MUbdjdWbkHTmdry0blkGY8/X/n9Hz2XIRHq8lp?=
 =?us-ascii?Q?zC2JhaA7xHBb/TzQ7OuKy5E22VwsxHaXRyXSX4aEXc0yulDfdyWqYNjG3BpZ?=
 =?us-ascii?Q?1xk/ZoVj9MC27AhJSZ030sjZAP4Mrb9ap6ckHrcHVNZhjYxo8yHatluW3GlI?=
 =?us-ascii?Q?7NbO2EnCw3i73YTfIXXfmb1nY4J668hWgK5/soMMz1T7PZf43nmPUtGRNfnz?=
 =?us-ascii?Q?rDQB51tdvI+rLcsODckwjiAG2++OknlIfYmyVWJDs4hAeDUXcSVUcvLmnWbB?=
 =?us-ascii?Q?+oWsuZGlBkQhjzQVZZQPCYYYCD8ZlrhOFxYeGLn1vNOCNdrdpvLMDG/fokt8?=
 =?us-ascii?Q?NliFr7bCL7Fi3zSsNdnZAgNQGAuX9WEZCg+wG/4gg8BmfyUQTl2imWLaeF0x?=
 =?us-ascii?Q?sPb+Hw7MjxtpnCB4+ZNHzDg9bmJiZU4Pup3otcPlNIJ4vry/WMGkkEdkGSLR?=
 =?us-ascii?Q?pUOE97BNzdkk4vMnieFRpkrIn9G79mmuJcABKDqkHNVD4+O42pwQ7FLrDIiM?=
 =?us-ascii?Q?2Y2wJUKHUQyG2IQ8skm6sBmjJaVhj06/oRED6DM55e3AYKCUe3zDHP7pwkj+?=
 =?us-ascii?Q?r8KEi7k9pFSl+YGgFBUPX0HyvWZTbHtwJPUoqdi+VfZTOEDR6YgKE+2CmNwY?=
 =?us-ascii?Q?ZcuX3A6C+vMEfxyU0RgdepL4mZQHGpZqwOjrmy8Vf9gsZaV+wdNfH1TQ0mAU?=
 =?us-ascii?Q?4gbanyRKPw8zdHbpQ/xDvlFM2KhvzcwCgNYqZNRP3DZGPcMGBQwISteuKEmP?=
 =?us-ascii?Q?dt5xVkcIA0CTGbZd17zMgchVUej8gMm01/jlKqPTmYvUbIFMdBUEOccHpCaC?=
 =?us-ascii?Q?SyMAkpiuPYyhFAP2vJYJLig/lzq2rHda5Am4QLLguut3z68JHfzLJJrzs6No?=
 =?us-ascii?Q?ZFGIYBIeGaap3bZQVX+6yx7DyAF3/4+Vk9SrFma+GrVzVgdkDV13ptKVZ7tG?=
 =?us-ascii?Q?/+h4ZCPNhlVFDVynA52Lj+XO9kXx4+xm3oiN2cp1ImBdgiAOVY18dMai3T+U?=
 =?us-ascii?Q?iLJ+dlpDCUgik271k4cUKi4+JlKbqPybnH/KFdUZRwsYfaJr0YsiSQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cad7/yjBDb29qaIIh3rTQZ+kbEjqM8EdZySb7AHrEzgKGVk7zRQQODvZauWe?=
 =?us-ascii?Q?H4pdZz9F/Us0+Z7ITTk6YEhQCcHRaZS0IxnkrGT7dt/Q1vqMDaUcBlJ5B+uf?=
 =?us-ascii?Q?12Syj0UCz/Glygl2/C0ITymOOC5mR3prURJ3cSOrQrgtBTljkSQ0py8Lm9ye?=
 =?us-ascii?Q?B0ImrimkwBtO5yAKZGLJWJuZKAkMFbn7qHM9emhvY5LpIWEgJrHgBFA8L5j4?=
 =?us-ascii?Q?iLq6Hv4vlw9sIzVIzlYh8yLo1bDyEgOH7qseAXK6CGgRAopONA86t5kkXpt6?=
 =?us-ascii?Q?3LtA0o9OssMoYNm5EWySam9hitBdEIPhlwNyE0RHYLVBuJ0yIKEatxJRqIZ9?=
 =?us-ascii?Q?yAlsQzvrIS8z3I2vJgp8z5QoEILzbu0EP0XNvDn+3CyOrkTXbzLZcWzmmXDE?=
 =?us-ascii?Q?+o9b7ADon5qAjQLJ1/08aatK3S77IVMUP3ONO17tydLTeUFkAx7jvO2him1Q?=
 =?us-ascii?Q?X8HG173OpdAUryTeu6JicfFuUn6zDc1Tt0auoXdNImI9VjFc41m16jqT/aL6?=
 =?us-ascii?Q?jUNGs9E7LHHami3nGS8Kdi5chvk5KZw4hDmZ8Zk7yNxQuSLNpDOpSuyEU6Ls?=
 =?us-ascii?Q?OqZPQz24ObsJsFcd0S3wJSmBIwMeV+VwJ7IR31yJZg5e9pjiSlzO8QcW3bB+?=
 =?us-ascii?Q?/NtOPLBM5EQrvan6oppc0TZQX60z+3D7U3ZTMLpYf0Ieu0sYF2EYXUQ69bby?=
 =?us-ascii?Q?ArHOUX9JWtn13hRV9JK4o3l/+1PGImUnB7giCw1kHh0awXYj/JpenHhQIt5G?=
 =?us-ascii?Q?jam0ziw64QBL7jaRBGiKu+xoe4DAUwVaTjmDdHDJgkKW+1IwHPf4bC2tyqfg?=
 =?us-ascii?Q?ZslBEMsuZC4ww0DbeqpWIilRiRssTh6UvJUo5/Seoxa9J/8SJXQmz3aCB1ul?=
 =?us-ascii?Q?t8zoFQpDdzc985zlgU9Xqi8194MRyVIhdLIj+17Ej6AR5S7Ndpn3nzciwTuh?=
 =?us-ascii?Q?peFRzCz76Qt4yHj7eNg/+yQa5DytR94JjjfWeI1XtHy+Zdc3UEU96TtDG60T?=
 =?us-ascii?Q?c57+1+GNutxoNa4X/hyLAtCqUSK280noEi/l28Q2dDECNRdu3OgtTPLbbtNu?=
 =?us-ascii?Q?PtddMuvt0Ez/Zt0HyV+b+dLzc4EqJ3X59VF73G8OKagwbQWytgEsnbuT1CE0?=
 =?us-ascii?Q?6WDJHpzUbQ5gtHdyLNtNGMohO6Dk7e7SzD4bMrurZ9vsKYhUCJ2oS2GHs+Nl?=
 =?us-ascii?Q?QyZez5N1XcdtJmYDFaVgcRjRyMDOjgbXxxNaFP0HzgSlmBgRbLhNahv6apDJ?=
 =?us-ascii?Q?eyeymWWYvZHO+CxB1lOJpoyt8MMWlnkujB2gjJZ8QZMjBJKaIbKBP+9knyHN?=
 =?us-ascii?Q?PCMqHO5vcOGxKaPVqDBb/zyXbB6X+P9RDS9Dj1+7yfS+q5nuMW8SfpCAfaeL?=
 =?us-ascii?Q?91jmhsOMsoD8ytyKnOSPls/y3wCMaDYIL7hjaWfTxkT7W7WW4OagR0TagSa1?=
 =?us-ascii?Q?2AeYritz39nc+Y2U99tXkIo3MtNloal4FaNQagIkwT2yLRp8STlIwrKq3E65?=
 =?us-ascii?Q?H4Lxx4qaPpOyqj+kMrYmj5p5L54EwDGMVo+GqO6SmTQ5qwagjwKn1Gb5ik/x?=
 =?us-ascii?Q?DvJVLlHlDf2RrecQbjToiRspAts3KFk2bzWCEeuTUZOvs4v+gKQzriWxEu1r?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0111ec9-fd78-4ff7-9503-08ddbf59fed6
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 02:32:20.7022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urmxvM+SwKNRNizAOuhczeFg89sCW6OFioTB2S78JMcUXFzbqikeoS5fa+P10EgiqYH39atgEpu0Ci8360J23vybV1OXIarZywRqbc7VC1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6446

From: Liming Wu <liming.wu@jaguarmicro.com>

Consolidate the two nested if conditions for checking tx queue wake
conditions into a single combined condition. This improves code
readability without changing functionality. And move netif_tx_wake_queue
into if condition to reduce unnecessary checks for queue stops.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5d674eb9a0f2..07a378220643 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3021,12 +3021,11 @@ static void virtnet_poll_cleantx(struct receive_queue *rq, int budget)
 			free_old_xmit(sq, txq, !!budget);
 		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
-		if (sq->vq->num_free >= MAX_SKB_FRAGS + 2) {
-			if (netif_tx_queue_stopped(txq)) {
-				u64_stats_update_begin(&sq->stats.syncp);
-				u64_stats_inc(&sq->stats.wake);
-				u64_stats_update_end(&sq->stats.syncp);
-			}
+		if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
+		    netif_tx_queue_stopped(txq)) {
+			u64_stats_update_begin(&sq->stats.syncp);
+			u64_stats_inc(&sq->stats.wake);
+			u64_stats_update_end(&sq->stats.syncp);
 			netif_tx_wake_queue(txq);
 		}
 
@@ -3218,12 +3217,11 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	else
 		free_old_xmit(sq, txq, !!budget);
 
-	if (sq->vq->num_free >= MAX_SKB_FRAGS + 2) {
-		if (netif_tx_queue_stopped(txq)) {
-			u64_stats_update_begin(&sq->stats.syncp);
-			u64_stats_inc(&sq->stats.wake);
-			u64_stats_update_end(&sq->stats.syncp);
-		}
+	if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
+	    netif_tx_queue_stopped(txq)) {
+		u64_stats_update_begin(&sq->stats.syncp);
+		u64_stats_inc(&sq->stats.wake);
+		u64_stats_update_end(&sq->stats.syncp);
 		netif_tx_wake_queue(txq);
 	}
 
-- 
2.34.1


