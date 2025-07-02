Return-Path: <kvm+bounces-51242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C21B2AF081A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 678361BC847E
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 01:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849B6191F74;
	Wed,  2 Jul 2025 01:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b="q4mTX8ly"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022123.outbound.protection.outlook.com [40.107.75.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A584D134CB;
	Wed,  2 Jul 2025 01:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751420511; cv=fail; b=e1Q32SGVblPEVu7bGz1D02yIDJvVSmR+3qVQjRCDZ2w/X44IaNkWkmUM8Vz0370MYBLtS2Lio7vYT6Uk07ZE7O/cljAbptYFTyP4jCO2StdpWBicxAa8J7cGoRmk8OOf/nZPgzidfEf3R0OOQHZZhtCKQ3JfAqhdHufKU/skUiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751420511; c=relaxed/simple;
	bh=AIzfzcVKGOnAW0Nzltwd9gM3GyivVQunp7CYq94VOfk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PmoqoMqAxEyQsLzYtHa8BJdk7OUUT+aSFhl0vi+ulLch9u0fAa8NlcLa6k8EKlYb7XGd+kXVhaXVKwVOo6SpmDpljZPKqoab+pXf/U+xkHN72OpfAZVTuzdJWoUEh5mLnFpeBrg70sJYZCNbxb1GK+z5Le6/vJY0xjOmVCIfgpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com; spf=pass smtp.mailfrom=jaguarmicro.com; dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b=q4mTX8ly; arc=fail smtp.client-ip=40.107.75.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaguarmicro.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C19ktOOE5nVAEP9oy5yuUxGAb0ZYyZ1MYbChXdpQQG8172d1ilY2iIWD4Wf8SNOrouemK57BkWand2UIOiRjzkYXClsgcGcLrTDV2bpfLWF3E6QXMrRR76v0N+bEHCN6dKuVNK5enTuNpHrU7EFJTNgLcVLcOMvraZlywKnG+sm0XVNa6VUQTqUiE2uDrlkWK6ttEFP1hL8BCdClxPp1Y/BjXQMx2hEbHP5vnAGlLRnN3luMcQ+L2k9QUVnH6pEb1ax96pHOCoa9snrLSOpqeXMQfe7HlF76cnHpsQfN6RAoCWBGTWVaGa0E3mLceUxwMOyIoozzpTWLQG2I9Bx6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBUh2HsGey91x4EekImtKLc6Qx+qit68hRcBI278qaM=;
 b=Q7qlsFnKz9lfm8G4NLyUnsXqPL/n4HYbPcndIQtYGvVZBnIatzyjy/aqWe5rW3tLbBOMNQ4n/67+21KR0hwJ6Pv20XWE+Zeb1iW7aCWEIH7F77APzc/te1yV8VvuVmGzzXEVq/H9LcxhZw1OufxvdpWfvEj5LIgXom6ydGZNPmrfg9yD7K4arN2r0e5i2iVdsNMw30JksROzuppIsLOALgKkXxEjLNCsBuKE3KNsGQ0asWtq/R9bQ9rThGTqqOsOOSHYeiHiHMrXB5HIWGCbqXfBsgyK59Y8PXDBdjPsNpgVl1HZlULoZR9VPL9GtCIKi08VFXRKvnb8ahlQ56xjtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBUh2HsGey91x4EekImtKLc6Qx+qit68hRcBI278qaM=;
 b=q4mTX8lyrjMqW1JrMthQ7PjX+eKhUOLtoG6cbtb+DTWCRgdEQjUCsyAzZ1vFACq+bUCRTdJOKriXw5KOtWiYKHZDos+1fNcR+oZu+vtc6D84y+yBYw9RaqxDDgqnYgH7mwH/PLCpx2pz2AS1cCjBrmtmMJ5X0K7arjFkQvyloqKU8t2UfKF55mTIqBzFrQEMgGJIGzo4ZtRL3Qct24CrRN6misgvaooFCtzLz7xA3RNA8J7R+StPhep8jMVUwY+HsVM8C/R7zDcQB/++gbxTwSKWhSp18qEFK2o7ChKqKftje6Fs9djZdYrOwx78MHvVPKu+aVAbTLouEuVd4iE2Uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by TYUPR06MB6077.apcprd06.prod.outlook.com (2603:1096:400:353::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 2 Jul
 2025 01:41:39 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881%3]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 01:41:39 +0000
From: liming.wu@jaguarmicro.com
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	angus.chen@jaguarmicro.com,
	Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH] virtio_net: simplify tx queue wake condition check
Date: Wed,  2 Jul 2025 09:41:39 +0800
Message-ID: <20250702014139.721-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.49.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TPYP295CA0044.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::18) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|TYUPR06MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c806100-5476-4b89-8748-08ddb90996cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eIdiwgFjv8Vf/ZMpT+1x993lKGa5vDDwuHZa3AKUfhjIyrEnSZKmj4cVX9ag?=
 =?us-ascii?Q?zr+Xf+mUIO/bOmH/Mhr1w6tn3NLLSW7AT9vGtdy9XkrlwqRWUpDhhSg4+hHp?=
 =?us-ascii?Q?zUht4nFjC7mJiM8rUQvtveQAxCEIk0ay0/y6Z70fp1aGUzSXOncfuVZhgpln?=
 =?us-ascii?Q?3aSPLHanhMdXa038z6ZZ4BEcfK0E/gu+chjWCF0npbXLaF/mpKo+ZC/TXn/H?=
 =?us-ascii?Q?Lr01R28vzIOzMqfxOxkXEe67MxgoBIMwwws3lgJ5nL/Q9/4MHgFAgg6dXkuP?=
 =?us-ascii?Q?pLO4AX2ZVcoMf7qCzOpr3dG4QxI0zoNwlqpalBvSLFetDQwt0y0P1XNNXj+Z?=
 =?us-ascii?Q?ufmu3tANGh6BGqJtXN3JVNfDZlFD+bZBppKN65Q2BLmJipDXyOyoiLLLDnas?=
 =?us-ascii?Q?vJ71NsTLjbGb//RRPd3RZSZyzIgR4xsRn8XUKP3tMAcoe8qLK1fbB0lM1z8Z?=
 =?us-ascii?Q?HmGS4R3/UZL8YIv0jF2t3gBR/sJs/NHuXYn+BXO6imEvSVt3J316+YfKcULd?=
 =?us-ascii?Q?GjfxSPTVjs63ZvSs/ydK06n2azjdfYpFj/o8jzRsNchKkdT8mBLQP/Fmgoq4?=
 =?us-ascii?Q?CBVzS0u+OR7W1gEVdTn5SrSOjBEat9hDEN0zibnSuplZYu2DgfxUwp+okFhh?=
 =?us-ascii?Q?ZFxEgGyTc9m0cBchVHoN+pqoMlbD6fPGhhSyXeoyv4HGiqZQTBbXQez0sp2z?=
 =?us-ascii?Q?Wd+tNjohjnx8iFtR7vh1K9/NbYGQkZG+MKvsnpUor/CYt/MuUGhNmN0i/910?=
 =?us-ascii?Q?rnZXei0ytYVw3L2jnhY3IDsIFHsJ7BUw/mTlcAnEAcJ9EV1QvZVvEjy32JeL?=
 =?us-ascii?Q?lMH/o6S8nDBGXgx2KZT8OIKjz6sKzqYDH+10AmQVYrEtO1sStuVaqo1+DEvR?=
 =?us-ascii?Q?TAoGBYovo9tPfwV+xU3GFJRXil8Nwb/yP37GdK3c/deyVWtqC5XbPG1VH3dh?=
 =?us-ascii?Q?DKQb1sLkeVL0UXfWoXx9+0QLfLn1RmhxxFcXq9SLTKIgQGRfwiDMJGRIiWAg?=
 =?us-ascii?Q?Mzbp3+v3k+ZFgZkybsT+ZPe/vr634zkxlIkAMZo4+xSl50PrSm+1/TW8x8y5?=
 =?us-ascii?Q?bZcfN1qbT7eELNNmQCyumJOtWHIjAqQ63xhFWeaOdnl2XNmoPik/LZpm8Uy5?=
 =?us-ascii?Q?1OtOSiWJ9LE3UN/bqkt1xILjYm0HvWoxzhF1cWpFpmH2P2tKlYh74ScwKFNU?=
 =?us-ascii?Q?L43Y5q0KrWxVqCWTTebpwwUWzRbu6QLQITAvHqazu5LdxbOe6Juk39iFhiLU?=
 =?us-ascii?Q?k0j+PcLS5VydfJXuzx18uhYwloYvyqYoa3VGYHqLXErtydfvnKc755i28QyX?=
 =?us-ascii?Q?2VeexG8veOwLwFThwrrikV9xkiSbM4re7XKlYbJuDYEZThuNL65VRGaYojQg?=
 =?us-ascii?Q?2PUiFLnuOL3YD/uzV/bb1mr48055FRQfntbbc6mzYO/3hNIH9L54WxL40LGG?=
 =?us-ascii?Q?TMc48R3At6Cfru0KHRhf+0aVf0PdOptMHZf+14p8Krpw0RMTHPuUAw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BDDNgadBZwxx998xyAsIOZo8f/4eRblsCgTMJPsUVRHFG0JgNGZe4xMLwegj?=
 =?us-ascii?Q?YueQM16jBvVZEUu38BlW505ZK2TxlTDaI9Pi1gx0kJ4l/c1xe8yzMDRk9CJa?=
 =?us-ascii?Q?DpuFlKvYKTI8dZhfQY30W+FRZg+gdRFxOBkZeOlAfNW/45Gw6pg++/TDgLH+?=
 =?us-ascii?Q?uuUhhXpzX5nL/3QxagzrLwXZXQXnqjf+2BwWVDJ0EpUNcvuy1DVn3zYI40li?=
 =?us-ascii?Q?YcN3E2AV07VI+UNpNEZcJkUUkxKEbk6j5lwrty8DTckEOLKpWDwspq0ZzHja?=
 =?us-ascii?Q?mw4lsQqJvHlV1qNbXfCCPfL4NgOz48ACdv4hgJAKQNg2K5ysGDp+kyFUSboa?=
 =?us-ascii?Q?Nw8sz8tsxfnnd6JB7TqGehrPvy7GgSMUlryV8zqvXch1SfNqR5qbRp4rh9gl?=
 =?us-ascii?Q?68ZE5FRXGFcVrNl6oA+R9gJ8SG4jAF5hg45lsePxgSyXUUjwNkJ3oL5Y8XTq?=
 =?us-ascii?Q?WQFfggHXSdTbR49UGWK2kjfnths9hs/IVxDa5yH4u0NDhbsDgyxUFfFeWe4q?=
 =?us-ascii?Q?uJ8e+MjDBsJROfP2DNMQaJ0aNbVTdW2T+7B19WOqI8aiERUpVHgGNmPAN62A?=
 =?us-ascii?Q?1eZKe37NwjsCDcYH9J8jHIEWdMT4OzkH/F1AC/XvimTkiSm59u0JC6vsOq3T?=
 =?us-ascii?Q?BjsH/gGNe/IDAnO+gPJctuYs191jzbE+AISw7R7pCpwsiPs3Cc9zxjui/jeN?=
 =?us-ascii?Q?NCk424St7njNCYAueuceMxPWv2bkfXzYWhn+JLTLNRpMMSaxdZDdmJyNMwmP?=
 =?us-ascii?Q?5dyLOv5xPssjCaNr4SghEtSOC/UdqPv4Rqp9Pr1snWw2PSAGjQOJD5K7Fqna?=
 =?us-ascii?Q?zb0iRU8KHZUsPGlHtA9iAVYCzHv7gPL4PUrEm3tQkZUnfwHEUySyyzHBMJ70?=
 =?us-ascii?Q?jDznQ99iFc/+peHpmTN599n/jDQqoS1hXRCCnmIny91y9CBYlIETkxSLgotr?=
 =?us-ascii?Q?JNFggmNpiNwCj6mDRTvHBd2SGrGLYd77+/1KbKECSF4gkMQ1W8+v30pcsVNt?=
 =?us-ascii?Q?Sig3dyuH6ywMyS+BAmbWAxndTLX+4G1AvprDRIlSKqi363wRu5D7Wum1+8d2?=
 =?us-ascii?Q?32cE8p/eEv1vItZQtZmu+2rCeRwj4KPvUFhYUXwQbwwgRpiGUaZNPElWV8OF?=
 =?us-ascii?Q?CKrtQP000ehqfXg3XGXwo1Bs0QRjxzMUiEZBkwGynZLnXf5idMcAiXTsh/WP?=
 =?us-ascii?Q?AzGmyvNNRxOPp09+RjFBTzSbkKUvkPRMwJ9ibNYZU04HIqsI8RIifQGyJ9rh?=
 =?us-ascii?Q?L1EOFBTUqz8eMfjIx+yMyo/XJvuAViKeu1n9CRGGbD7OPdFI5QhGFNFIuSZb?=
 =?us-ascii?Q?M6+KMEmqagMAa9RDzV5iUO/TM+ZxIEcZ68AVWNXprnTonBavyfxHUEKLger2?=
 =?us-ascii?Q?UpV9VEid+UmGXEducjSfnxsiPayBSPD2LK9869tBZgfDiN59z4YeHnPGPYEw?=
 =?us-ascii?Q?lK9ckceGwjR/B9x4QXzd7an6v7OPxOPzbm3DkyAvg9ATER4Bq0m6dT/ktCw6?=
 =?us-ascii?Q?1fzUdKXkgo3HCxUcoJH7UFtriT7h6DdV997a7BHa1HAZgGSlcg7zjYm6kjG2?=
 =?us-ascii?Q?KRpZQ+MjQmne76AVoeYB7RMXbrh/IHmwcSotcraQmBzxv+XP+fjoBHxASEfn?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c806100-5476-4b89-8748-08ddb90996cc
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 01:41:39.4514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7rizxYHPmJwUfn1wusl2WCtO4I+S3ZbqEzmdAGhK6I/U2twUjCbf11s3c4c0ld0yvX3PUdLPWPL2JskP4YFpvNGFPS50oj3gubDOLqLILs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR06MB6077

From: Liming Wu <liming.wu@jaguarmicro.com>

Consolidate the two nested if conditions for checking tx queue wake
conditions into a single combined condition. This improves code
readability without changing functionality. And move netif_tx_wake_queue
into if condition to reduce unnecessary checks for queue stops.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 drivers/net/virtio_net.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e53ba600605a..6f3d69feb427 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2998,12 +2998,11 @@ static void virtnet_poll_cleantx(struct receive_queue *rq, int budget)
 			free_old_xmit(sq, txq, !!budget);
 		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
-		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) {
-			if (netif_tx_queue_stopped(txq)) {
-				u64_stats_update_begin(&sq->stats.syncp);
-				u64_stats_inc(&sq->stats.wake);
-				u64_stats_update_end(&sq->stats.syncp);
-			}
+		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS &&
+		    netif_tx_queue_stopped(txq)) {
+			u64_stats_update_begin(&sq->stats.syncp);
+			u64_stats_inc(&sq->stats.wake);
+			u64_stats_update_end(&sq->stats.syncp);
 			netif_tx_wake_queue(txq);
 		}
 
@@ -3195,12 +3194,11 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	else
 		free_old_xmit(sq, txq, !!budget);
 
-	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) {
-		if (netif_tx_queue_stopped(txq)) {
-			u64_stats_update_begin(&sq->stats.syncp);
-			u64_stats_inc(&sq->stats.wake);
-			u64_stats_update_end(&sq->stats.syncp);
-		}
+	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS &&
+	    netif_tx_queue_stopped(txq)) {
+		u64_stats_update_begin(&sq->stats.syncp);
+		u64_stats_inc(&sq->stats.wake);
+		u64_stats_update_end(&sq->stats.syncp);
 		netif_tx_wake_queue(txq);
 	}
 
-- 
2.34.1


