Return-Path: <kvm+bounces-24369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DF995451C
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EB921F22777
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4548F14D6ED;
	Fri, 16 Aug 2024 09:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fwiMMHjP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875E13DBBC;
	Fri, 16 Aug 2024 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798985; cv=fail; b=EJt3SJM0s1LLudtX27NSvico+gP8bLnet8r1jjPRCOoFavO/TnbzvEK36sBuo/lTGqfqLZQKZAl6zqeul/Pcnr7ZdwqVJ8h7kT61OB4aLqtkfhRLoQA1/p2ZzwcibR9YEfwNiro75oIpY52t7Apxw4llbUfSLPgrQwXHoTymjf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798985; c=relaxed/simple;
	bh=OU8XVr7W1x9AxBwFcPSy7J1EHxdyso+fzfxQs6OSfgk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXhqEkDrwu3CPPXLDjiNEmgVenZ9i5UTlywP6I5iBah0jgg/QFfJnbM4P2ZtaYM41/x2wsz83Q3Lx+JABoZVJCVXlREoCbVr+LkzBEpRt/5SuQ89pqhXxTM+7CvhA6ec0AAkITigo5zB8Jmu/2D14XtkeMW38F7sPQlBKA2q0m8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fwiMMHjP; arc=fail smtp.client-ip=40.107.92.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=op/uVxggXG0adf75UreguWOXs0PZAYYnFQaRjn7LIaYxieH2IQ24SDlyky3mD5JWUmOQccAnOY0XuVBiW0JieR64FPZYIENqrnDdKhLcp2bVEobFBMTT/VD7aVW/3tvf6/nkemYUgY+Bk9P4i050f71vj3+s16PvM+ZYCZ6ctGvXWK7l6zJmkcW3qRCChk1Z5MhY9HMOaX68Sgg066BHFbNDcP8o471PL4aylxIStSa79jTCXENM8B9tDzFhIAGZ2w0YS8I3a5HJqBoJ880MVlAMvUfQ18tteKk6QJeCEt+XDJ3jqtzHB0w4v8KuaMy7moOzsaxWKPUonPtEsaiAgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxCNbitpCqlU9s8TkazghQcJ1NdNMSLTLk9+3PbE+eQ=;
 b=rgCx9fKOtXtSzsaBZBQQQ+0W0gUEtfiq3UNjmYxWN7/Znb39nkiZ3xJcTLuT2mQtngx6YKrP+9NOtvcY+WZBYu/1/UOLOeFJExxNEETxo917pFn56X3PUOsN4Kw51wfjMdRwZvoyD4JNBiso7VIFRlvunoa9AycFUG/BucEtqYq4X+XG/Gho7pJE6GE94FDRcDmSZGtvSiZ3zetDyxAjZL3qcZLfTZJAv3sUZNiz/rXW2uJgQZGyoKBV/BTgxkIcRABtcQhT+9X/blsqrBBCimuIGkfbZyrw6mwM4jyJXN9ygJ5Qc3xDxebGchQXxtfH6c5GbZqs9cnyNllObb5sqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxCNbitpCqlU9s8TkazghQcJ1NdNMSLTLk9+3PbE+eQ=;
 b=fwiMMHjPiy+qieTZvoIY2lNctdf26vLxlOqEO5qBPsetMJqatn9xeMqOwa4HM5AN2NNeTCmZkI+S0viCjfkAoG90+ZbnzwiXoHKO/5Err9uyz/lxvTIhibvtwXF8VvcZZsc2J+ABcHwZDaV2Tqji9f5AkBpQ06bP/+ZnUurzwLCh0lafh/D/+KZ5ygp3sAbdIpYvnBoFIx91k4PNbRMOsELXnQ4MzJcvtKCZSgioP+0iXxusxFdExjZ4wj8RCB1QyhkMo6M1Tt+9G+nMOWhBZ7WdU4FMqy5ybOV2gTzltwA6bCVx9NXAxgn8o6sJs9zNDaN1TE4WIGgvjm/5XOdbyQ==
Received: from CH3P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::24)
 by SN7PR12MB6888.namprd12.prod.outlook.com (2603:10b6:806:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 09:02:58 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:1e8:cafe::6e) by CH3P220CA0018.outlook.office365.com
 (2603:10b6:610:1e8::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Fri, 16 Aug 2024 09:02:57 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:45 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:45 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:41 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 08/10] vdpa/mlx5: Keep notifiers during suspend but ignore
Date: Fri, 16 Aug 2024 12:01:57 +0300
Message-ID: <20240816090159.1967650-9-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240816090159.1967650-1-dtatulea@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|SN7PR12MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 7978d7b4-8e93-49b7-4d7a-08dcbdd23942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SDFrenZHUjJMbjY3TzNJS2FWdWZxeDcvbUFNQ3ZRd0R1RnFLdGh5c0pROHhl?=
 =?utf-8?B?Z1o0NStVMVZYMVdxNG9CdlFEa0tnNWtVTFd4UHFRNjVLU2tnR0VzYnlGbk9U?=
 =?utf-8?B?eGpWcGo4VDBzS2JRQnVNcTNtaGZXbGZXMjgzSndtci92TVdBNkJYNmFQODFK?=
 =?utf-8?B?aGJOeEY2L1gxOW4wTXhQNTlNalpiUnZUdmVaTTVDSEI5SGUvRkE1Yi9Vc29F?=
 =?utf-8?B?TW04dnFTN1AwQmo1SitxWVNzZ0xOT0syVTZBNFhSRUREa0FkaWw1TldLcTh2?=
 =?utf-8?B?UXk3ZmpTUXRNQUttV2kzbklnc1dIRDFYazYxbVFxVXVxTENoSjVxK2dBRE5I?=
 =?utf-8?B?MThZS1owTDVUTmg5eGUveTZ5Y2pPb1daMktLYS9waW5SNExoQzRISkdOaGhD?=
 =?utf-8?B?MzR4bDB0a1A3OEx2VVJBMENEOExVeU5rSFgyK2dYQVQvclFlbkFFTE9rZm1J?=
 =?utf-8?B?YkxwSnJJbFpHYVFYU3RyOExyYnFjOE1jNEVvNXRlL29aM3ZZUUZFK0UzTGFE?=
 =?utf-8?B?WW9WaVRnNW03Z1g4ZVdaZUpBa2YzcVk0b0ZIY0pqcVN6dXl3a00xMG95TXZZ?=
 =?utf-8?B?dEw1OFBFMTkwUklpOTQ2MW9xRzJka0xFMS9leXJ5bTFmVTBWT1oyMVhId2lM?=
 =?utf-8?B?SlcreU5iQXp1ZHJEMGdGdDdEZXV6TWVybTdUMGJET1daZjJ0NGlvZmxSL296?=
 =?utf-8?B?bUh0d2JvS2h0MFNTZjFNQmpQNUI0ZHJINmV5SjVNVmlabGxaTGFtTTUvbU1X?=
 =?utf-8?B?MUlTZnVnTVMwM2dkVUQxZXNpSjlVcm9wLzJXQXRjSDdlR1dkTWUzWjB1eEgx?=
 =?utf-8?B?SC9BTkRTVmwzbStoUU4rblgzN04xNkEyWFA3alIrb080T1E2ZmptYXlCR3ZI?=
 =?utf-8?B?Nk8xcEtUV0lmQzVpWDNucDBIc2N5RXdITjBGNnJEd0tMc0UxeVNQLzlkQ1lQ?=
 =?utf-8?B?YldjYm5DUUdFWVNaTmZoMHArM1JzcGxSYitlQXkvUTloSUQzMngvck9TWWZB?=
 =?utf-8?B?Wk8vaTFOdzJhQVU3UVRiVlBDeUtYWWJZdlVLZkdmUGZRY2NidkttWFNVc0pr?=
 =?utf-8?B?dE1NbysyRTVDU1kvUThCNjFuclpVUzhkcmxlWXM1dC91eFUwZHVnM1o0UGlh?=
 =?utf-8?B?TU1HZHJqeWFDTG9pOXZyUXBlU2dzOHhLcXo5a1hzSkJ2alRNYkc5WWFNZFlw?=
 =?utf-8?B?bGVWbExvNUFicFQ2V01PeE5XSDZxTUp0V3pnWDRWTW9Gc1lRbitmQm8xMFgx?=
 =?utf-8?B?ZTJSMU9mNlFtY3Y3QUgzaG9JdmFhc3Z2L2E4SlFKOURnckNPRitlRlZPVlVO?=
 =?utf-8?B?Z0hMTFl5TzFrMGVPWFJwQjkybTBoeGVlMzEvQ0dZZTJVdVN0WDN0SFBHNloz?=
 =?utf-8?B?aWxWeml2MFVYUGZwc3lvZkVPclY1dWx4NnJBVXJ4dFlRZzE0NmZQUnFYbU9u?=
 =?utf-8?B?YzBXVGpVK2RqYThEQWZPdlpMNnAzUmRVbUQ5S1dwekNIaVZYVG10Z2FOa2tZ?=
 =?utf-8?B?d0dTSXZWY1hXaGJoWDFWVWRpWXFyM2htNU9GcTUvMUFwdjU1M2l6dmtQVFQ0?=
 =?utf-8?B?WmhHUjBhNzJVTXczT3NodWlOTEg0emwyWUJINGpTNGlldG9Sa2g4YTNYemZw?=
 =?utf-8?B?aWdGV1NQaXp6dWJiaEJWcXBvb2JCd1RCTFdGbFMzL0ovdGhIbnhDMlI2Zjli?=
 =?utf-8?B?eWJJL2ZoNjZpdnc3Smk5UHRoY21VNlM5bFNoZHJjL1VsOTh3eDVBOE04YWhV?=
 =?utf-8?B?cjZEWDFDWktxaCttWFdsRTNGL2g0by9idU5Oa0cvdHlyRnNMeE9BL2JybVdo?=
 =?utf-8?B?alZ0ZFFUQ1A2Qnl0ZThGaXFROUZDejNmMEZUS1VEQ3RXc0NmcVpsZkcrcmtw?=
 =?utf-8?B?M01KY3h0WVpDRmZ4WC9UOVhnV3JZL3lMbklISWtYTkpIUW90ZzZKMWxtVEZP?=
 =?utf-8?Q?SB0IjY1YXVuqAQyUnSaUJzwOspTEzx0W?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:57.9164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7978d7b4-8e93-49b7-4d7a-08dcbdd23942
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6888

Unregistering notifiers is a costly operation. Instead of removing
the notifiers during device suspend and adding them back at resume,
simply ignore the call when the device is suspended.

At resume time call queue_link_work() to make sure that the device state
is propagated in case there were changes.

For 1 vDPA device x 32 VQs (16 VQPs) attached to a large VM (256 GB RAM,
32 CPUs x 2 threads per core), the device suspend time is reduced from
~13 ms to ~2.5 ms.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 0773bec917be..65063c507130 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2850,6 +2850,9 @@ static int event_handler(struct notifier_block *nb, unsigned long event, void *p
 	struct mlx5_eqe *eqe = param;
 	int ret = NOTIFY_DONE;
 
+	if (ndev->mvdev.suspended)
+		return NOTIFY_DONE;
+
 	if (event == MLX5_EVENT_TYPE_PORT_CHANGE) {
 		switch (eqe->sub_type) {
 		case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
@@ -3595,7 +3598,6 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 	mlx5_vdpa_info(mvdev, "suspending device\n");
 
 	down_write(&ndev->reslock);
-	unregister_link_notifier(ndev);
 	err = suspend_vqs(ndev, 0, ndev->cur_num_vqs);
 	mlx5_vdpa_cvq_suspend(mvdev);
 	mvdev->suspended = true;
@@ -3617,7 +3619,7 @@ static int mlx5_vdpa_resume(struct vdpa_device *vdev)
 	down_write(&ndev->reslock);
 	mvdev->suspended = false;
 	err = resume_vqs(ndev, 0, ndev->cur_num_vqs);
-	register_link_notifier(ndev);
+	queue_link_work(ndev);
 	up_write(&ndev->reslock);
 
 	return err;
-- 
2.45.1


