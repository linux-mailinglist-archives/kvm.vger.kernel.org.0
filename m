Return-Path: <kvm+bounces-24367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAF5954514
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41685282C21
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F90148304;
	Fri, 16 Aug 2024 09:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KtPVMRf+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91816146000;
	Fri, 16 Aug 2024 09:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798975; cv=fail; b=HN8TVVXAaUKZTx6hKzozmlWN56MGRNdnzmRG6Mlm2YaTAHhVpy0iQ0b+ykPi70MIu7iwOVHCg2Z5VKUMhogYZx0bolm0x8ztdnaZaLjkv/Dh8lK41uB/UGiG7RPckYxCKUDos6VpMmFmU/8/nBeKPCRV9zieDBZGGXFbp8NXGNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798975; c=relaxed/simple;
	bh=1IZTLS6EWIllixTdyxPdXYqBRm1eXn4pXBNiyA/ISqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hu0mPkFTNBOlz0rZTGWAhlTvRcnX21XE4R6+c3Bp+6hDKqz9ZEshTiGhYYa1UgAkdugIU6F+SoapjKb8STCrSQvyCAP+4wAGSMdqmjz8cd2eFxm5xZ0ukDB6aWdESpEBoStvBXA3TvJvLlMGeatLTugJeXqu6xnORCpCgnZK/1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KtPVMRf+; arc=fail smtp.client-ip=40.107.95.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WU01ZR4pCln/ydfa9IRsP2V92AyPZdRAxuEZXy0lOmb67O7L/JHfODFDG9wiBbdpICoKYhtLHvWAz8HmKoEKnhf3wPQW8S9Wl2cez6fAarbpoPxRxmrfohJRf/uOlyZFM5Fk0h9dL6f/8Vny2pW32C7xOrc0l21DlDtMEfQy4l7gqtk9EO/ISNzWfwvDK0RsCShYxkcZhkpGKIDUx7bGbDXue8Ndmb03ZHztx69213jYoUF9Va+r8gDYVOPUR8EM4dGKieVEp8S3V7Yo3pMcARMsNNR2Z9zBjv9kfPNlr55BE/fCaf6BxBY073lB+DZ43S4E8QpTkdCcPJv16IsNbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIAJplQdvJEqiwsRH2lFpllSxV45XeFNw1hDiZBrKFE=;
 b=C1vlCiyMnZthPocRR4Q7Rk2pXncu0O5IfJckXnDoXLY2n6uSXhmsWa9UxzZiR9Z45tihki4yjccJ8EO++lVe+TVtCG4I6j71mxUeP49MMWrZawhQK8BDYirobVJm7Q1ZyghjiJsofEgmY161huVJMY/KZMDQRjVcGzD2bDgzX118/Bd3wNwSU2SX47bGphLXr73JIX9bfC1Ejj0Q+izRUIy/TujUVL4G/nQzthOm1IIhdG4nBvSl+nayBcH7LCzHgjieM0oX4/rAJQVm5fzIDzaO8YGI+EUHnyO47rF5Hn/+reC/H9h/1+N0vrPaTpvwBZ01qCSTj4OCFa8JdU1bkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIAJplQdvJEqiwsRH2lFpllSxV45XeFNw1hDiZBrKFE=;
 b=KtPVMRf+GPcYOA+omu0HFSuWiBaZCKLjwrVCnTgN52GmkCHQct3zl8+dq+kqyXSIH1VvCE5jhGQjYhxAW/5CCgb8dB+E3phAKKmvl8c4p5Z4tNhheVbodRExIpx3O35BdB6wJKm+Gfgdh2bm6ABZkxiK7P84syFNWydoZreMuTKb5T6ngLr2bW5BsdsszwZairNMVwE1CsUvjZGjGR5NAKqN/XSXzWD2bz8rGJHY82Vr5vpwCtvBdY80r77v3Os9urb2cRh+XiOEajd2MA5NXzHamMkhF9M3fmW067/LjgS7tDxHWmiUxbw+uXqFykmYlDLjqVUIMMUrh9UT9o7ROg==
Received: from BN9PR03CA0701.namprd03.prod.outlook.com (2603:10b6:408:ef::16)
 by MW6PR12MB8900.namprd12.prod.outlook.com (2603:10b6:303:244::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:02:50 +0000
Received: from BN1PEPF00004688.namprd05.prod.outlook.com
 (2603:10b6:408:ef:cafe::af) by BN9PR03CA0701.outlook.office365.com
 (2603:10b6:408:ef::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004688.mail.protection.outlook.com (10.167.243.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:37 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:36 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:33 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 06/10] vdpa/mlx5: Parallelize device suspend
Date: Fri, 16 Aug 2024 12:01:55 +0300
Message-ID: <20240816090159.1967650-7-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004688:EE_|MW6PR12MB8900:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aece55c-94fd-42ab-a74a-08dcbdd23494
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sk01cVo5Rmk5ZmQ0bGpBUjhHelpGSTgyQ2ZnNW9PdW92SHJIN1NMZ3BLTjVF?=
 =?utf-8?B?TlpLcnNKdHpCbGsrdnVjOU5ZR25uTlBid3FOQ3RHakM4SUJNTzhqcEM0bTZT?=
 =?utf-8?B?Rzh3blQ4akl0clVtK2NGdWNjcjZWbVJBaDhuaU94SjUyNXcwMTJtdHBlcVB3?=
 =?utf-8?B?Y0xJYldRaklpc2E2RWoySkhoa0tid05HaHduUHlDa3dLbXZWNHd3SnpkQUI2?=
 =?utf-8?B?Vm9laWl4L2dVRU1ZYnQ3dUJHemliRjVEUFZVZ01IVXdtU0hxT29JSjMxK0VY?=
 =?utf-8?B?NFlvc05KL1o5T2ZXNzZsQXhrbHA0b04zUFVONlRnQmhsdGNTazdsSGhpa3R3?=
 =?utf-8?B?VVV2elEzN2UrTWNPc1psVVhvRS84bmV3b3JXVS9TMXdyaTZMK2pMVmV6Zi9V?=
 =?utf-8?B?ZTdaUFJJajlnT1A4MEFwbjdKQWliNFFXWkhTdVAyRHFvd21EWm9obldxeit6?=
 =?utf-8?B?ZDZ6cVVkMTRGKzNVaWZlZE5UNVZnNUZJOG1pOWQ0VkVUb09Vc1FtNVNWMDJj?=
 =?utf-8?B?VnVzN3VwQUFhMEtQM1B6SG1UMDhKMGN0aUFXY2dqRmxwcFRJM3dGNnFKWlg5?=
 =?utf-8?B?dlFkczJ3TDUyQmhpSHFodFVYNUVoc1p3V1BDZUhuSzJqUkdKUXord011MnFw?=
 =?utf-8?B?RzNsL09xaXBMZ2hLMlJwNk45YldvTm9EWXJMVE82TEVKaml2TWVoeUM0OGhX?=
 =?utf-8?B?QUc5RDBmdDNZK1djU0Y5ckw1QWR0anVVZkR5R1dkZDc3YUVlZktDVGN2VjNw?=
 =?utf-8?B?RFh1YTlHaUJRUGZHdHdTSTZCblEzZTRFdDJGMXFPUWhjSGxobTFhK2pXR1pO?=
 =?utf-8?B?Ty9wbEpqRDBpNVFvdjZsT2owOGF0bHAvekhneFM4QnVpbGx6a2gyUFJhMUts?=
 =?utf-8?B?dVdFUnJ4UmpOdDg5OTlVUzRFY0R3MTdvdnRZcll5R2lJQkFodFlCNHZieHYz?=
 =?utf-8?B?aEdQUnhtYUd4enN5WW1xTGpVdHFXaDVUTE1jd0lLaitndzVIaDlJUjh1SHlJ?=
 =?utf-8?B?dDJEMDZyeHVqKytKTFpTZDBPV0w2RlFCYkNzL1FlQXdUUGpxZ0dKWGxiY0I1?=
 =?utf-8?B?cXF3Mlg5cWxLMGhxWUVTcWN0TENEUGJlVENabEw3MEF4WTBNTkkyaXVxN1A0?=
 =?utf-8?B?T3NOSk9OSm14NzU2WXlpdWFWb2JUeW1pTHduT3BtUGtuRWdWVzQ3dVJQOWZ4?=
 =?utf-8?B?cE1YN2g4cHVkUHFoTDZESU9NYnYrR01PSnBBTmNsbGVRTEx0bmxRejhFbVdr?=
 =?utf-8?B?alNsM0dIK2pWUUlWL0htR2NpbEtxQUZlQ3lnbGtQWGhkeDNKTTBiU3lIRzhN?=
 =?utf-8?B?b2hIYmk5MFp0VU55NVlMVmlpeEQ4SjJLeHR0Q1BuOS9ESUIxK051Q3l3L25v?=
 =?utf-8?B?cm1oOUs4OW9Sb0FRMExUamE5RkVwWVlDZk5JdlVGMkUyYnVzeEk0TzhaV2xL?=
 =?utf-8?B?bEhsN0owSCtUOGxmUk9ObnM3KzJkM0RTVFY5Mkgya3RLSjl3M2crd1ZTNjVC?=
 =?utf-8?B?VEQyTkh4REhuTzJIdjlxQ21DdDFUQWJ0RnpjRWtwNlBTUHpoYkdPSnBCdFZh?=
 =?utf-8?B?OWxZSXhKSjFRSzArYW53U1RqcE9WaUJkcTVtNGFHUlMzYnpnQStyZFVmMkxO?=
 =?utf-8?B?c2pCYzUvTlcwdnVVN3NWS2ZkUG56Sk5XcC9xc1Z5NnhYRTMxUlZWSzhhZjhV?=
 =?utf-8?B?b2pNUXFDUGV0UEp0ckJqWDdWSXJQQy9kZ3FMZlFuZUZpUXowRGFnR0Q5S3Ay?=
 =?utf-8?B?KzdlZlRWdUZxeHBCU3hVQlZ5ZGNkQ0VlTTJnU1VzZ2RZMlpTWmhXUERqbFlK?=
 =?utf-8?B?OWxkVjNUMzBIWDJkWDR5T2duY1RNZUlxbW5VWk9RZi9tajB4dHpZN0txUWNw?=
 =?utf-8?B?c2syS2tIWGd3blAyT2tsQmRra2hXSHdiQWwvcjlicmMyUEdDNXJSTTFIQ0p5?=
 =?utf-8?Q?4CpDE4/17PukMLXVklgRvAHOm2RMO056?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:50.0206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aece55c-94fd-42ab-a74a-08dcbdd23494
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004688.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8900

Currently device suspend works on vqs serially. Building up on previous
changes that converted vq operations to the async api, this patch
parallelizes the device suspend:
1) Suspend all active vqs parallel.
2) Query suspended vqs in parallel.

For 1 vDPA device x 32 VQs (16 VQPs) attached to a large VM (256 GB RAM,
32 CPUs x 2 threads per core), the device suspend time is reduced from
~37 ms to ~13 ms.

A later patch will remove the link unregister operation which will make
it even faster.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 56 ++++++++++++++++---------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 9be7a88d71a7..5fba16c80dbb 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1630,49 +1630,51 @@ static int modify_virtqueues(struct mlx5_vdpa_net *ndev, int start_vq, int num_v
 	return err;
 }
 
-static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
+static int suspend_vqs(struct mlx5_vdpa_net *ndev, int start_vq, int num_vqs)
 {
-	struct mlx5_virtq_attr attr;
+	struct mlx5_vdpa_virtqueue *mvq;
+	struct mlx5_virtq_attr *attrs;
+	int vq_idx, i;
 	int err;
 
+	if (start_vq >= ndev->cur_num_vqs)
+		return -EINVAL;
+
+	mvq = &ndev->vqs[start_vq];
 	if (!mvq->initialized)
 		return 0;
 
 	if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
 		return 0;
 
-	err = modify_virtqueues(ndev, mvq->index, 1, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND);
-	if (err) {
-		mlx5_vdpa_err(&ndev->mvdev, "modify to suspend failed, err: %d\n", err);
-		return err;
-	}
-
-	err = query_virtqueues(ndev, mvq->index, 1, &attr);
-	if (err) {
-		mlx5_vdpa_err(&ndev->mvdev, "failed to query virtqueue, err: %d\n", err);
+	err = modify_virtqueues(ndev, start_vq, num_vqs, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND);
+	if (err)
 		return err;
-	}
-
-	mvq->avail_idx = attr.available_index;
-	mvq->used_idx = attr.used_index;
-
-	return 0;
-}
 
-static int suspend_vqs(struct mlx5_vdpa_net *ndev)
-{
-	int err = 0;
-	int i;
+	attrs = kcalloc(num_vqs, sizeof(struct mlx5_virtq_attr), GFP_KERNEL);
+	if (!attrs)
+		return -ENOMEM;
 
-	for (i = 0; i < ndev->cur_num_vqs; i++) {
-		int local_err = suspend_vq(ndev, &ndev->vqs[i]);
+	err = query_virtqueues(ndev, start_vq, num_vqs, attrs);
+	if (err)
+		goto done;
 
-		err = local_err ? local_err : err;
+	for (i = 0, vq_idx = start_vq; i < num_vqs; i++, vq_idx++) {
+		mvq = &ndev->vqs[vq_idx];
+		mvq->avail_idx = attrs[i].available_index;
+		mvq->used_idx = attrs[i].used_index;
 	}
 
+done:
+	kfree(attrs);
 	return err;
 }
 
+static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
+{
+	return suspend_vqs(ndev, mvq->index, 1);
+}
+
 static int resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
 	int err;
@@ -3053,7 +3055,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 	bool teardown = !is_resumable(ndev);
 	int err;
 
-	suspend_vqs(ndev);
+	suspend_vqs(ndev, 0, ndev->cur_num_vqs);
 	if (teardown) {
 		err = save_channels_info(ndev);
 		if (err)
@@ -3606,7 +3608,7 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 
 	down_write(&ndev->reslock);
 	unregister_link_notifier(ndev);
-	err = suspend_vqs(ndev);
+	err = suspend_vqs(ndev, 0, ndev->cur_num_vqs);
 	mlx5_vdpa_cvq_suspend(mvdev);
 	mvdev->suspended = true;
 	up_write(&ndev->reslock);
-- 
2.45.1


