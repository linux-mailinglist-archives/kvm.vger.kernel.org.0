Return-Path: <kvm+bounces-30489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 209289BB0F1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44E731C21628
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781741B2181;
	Mon,  4 Nov 2024 10:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qtPu2qz4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C4F1B0F1F
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 10:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715806; cv=fail; b=EWkKnzUEqDX9CVIo8A3bmm3+5OGr1z/Hgu9D63a9Pe0AiymLpjDGW42kvc5L62jh/sOmIgQi+PUxvpJ5ytYB1w1HC6vzxW1s4+HqfQ4k1EdawhyfF2grbF6aHouaoj1nYTMSGySlem3GGWMKbgJvIW9p+kqaMDn/h4SstryZ9BA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715806; c=relaxed/simple;
	bh=FA06RX5dTr6PR1CdZngUAc2Qh39jk7rfkPoQpHfrec4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWw4VFGtnSFCcff2ceu6pFlHWYQOF+I0ImfVptC5JM3ZsZE7MW+i2f6YqxSmhLVnIl9EiCKp0qhBO58fyj25iIgHOx6LNIMQrdav4jkvqPujT3DpLCwB1Mu/fZFZyWrpBgEhXIX3cSIieYoo1mygKgbGe1H59UWZUXuH62UvFRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qtPu2qz4; arc=fail smtp.client-ip=40.107.96.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CtfeGjTOxfeFLxxWzyykgabAKHSPQlrtFYdhygS1AzjJekLV2XL4K03SX3JO7ZhI4eEbDEDslNqnYvob4ALl/fi8lOdgHhYqPyIAsQ1oyZxS58+3nP5J5AXo8GWRSpP3FUAg92j1bUAIFbS2ljhyvNVAjT6wi6QUOoJ+YcKOxFVopAilZrXM70hK2rfvRC+x51BpCZp8JSXbbQFhGUGNRqmnZrhRW9wfChPcXjz0nFqS6M9XBuLDjdEirqkQ5ZSoAtm1YX9eOKgIUmxVi5jvbPvP/wiIgq9SJqhWmjczmmJBEM7EQLY6/3zSUo6uS+LRbXMiztgvPD2XUtxaQAONyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Vo8wn7Egee49oMlo4DcNxn7WcPFtkU2J/snBXpTo38=;
 b=vhNb2fkUQgQfujRRodtuXac8yjEHjqCvCPnRleLvrPJpdQ78R07QpVQCZ/8LPiG0dH1fvRYi9mmup30bE9IKBGiroOJrg4beng3zJ5BEisikxu2dH+18ssHBih4/0LtidKEYdI48fzwe60bCpIOkBHTcUiyNAHAsGxGEq6MsaRwNyX9DMcdGWlfsGhwCkYHpF6n5kKfbKbHzU2TPiYvxTR4KQGjhEiDHw0jgV2PcE/Jb1saeBX1Auq9NPDF9odHBtB6WwHV8n09a/CCf2cK/HpTqcj2cHyxMjcbnSiFLVwn0WZLX7yNdb49/dbaHsRhwwVaUTnugdD+v+FSEDBAPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Vo8wn7Egee49oMlo4DcNxn7WcPFtkU2J/snBXpTo38=;
 b=qtPu2qz4jmrD7PLnv0s9kmL3HU2MrjWpMyG/IgfnxTbUdjAzWGu3lYToWOHHOiY3aJKsF0Dz0gQC0DPhxAOexQXlEz7VnhaMSFO8yMl8KGzqZMEvGxcmel7KF4bBA2lSmZSDK854CRwuCmfu5ZDImiGqHiBT8Xc8F8Si4cK5zCxtgm9xdeeF6LOVOVI6Esf6zzCrAqJX7pfkjbCd5RiDsA1JF/pC/MiqNjFfkEbdDtM7aVAv7Snmd86eM/EohP4aCIQ8IifBPAz76lXgO4FVQVH1CbW4P1cR/cizaYt6YeAmAZejRppSH/1kHYxiVyEKJOBjTwi720RULA644mBQ2Q==
Received: from BN9PR03CA0504.namprd03.prod.outlook.com (2603:10b6:408:130::29)
 by MW4PR12MB7309.namprd12.prod.outlook.com (2603:10b6:303:22f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:23:20 +0000
Received: from BN1PEPF00004687.namprd05.prod.outlook.com
 (2603:10b6:408:130:cafe::98) by BN9PR03CA0504.outlook.office365.com
 (2603:10b6:408:130::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Mon, 4 Nov 2024 10:23:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00004687.mail.protection.outlook.com (10.167.243.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 10:23:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 4 Nov 2024
 02:23:10 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 4 Nov 2024 02:23:10 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 4 Nov 2024 02:23:07 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 2/7] virtio: Extend the admin command to include the result size
Date: Mon, 4 Nov 2024 12:21:26 +0200
Message-ID: <20241104102131.184193-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241104102131.184193-1-yishaih@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004687:EE_|MW4PR12MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: 2053c76b-c686-457c-62b2-08dcfcbab46d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VJY6Lc573UKsZB59RoqOb8DXC/Oflo1ltt43vqOLXntM7LcJOPh7vnmaI92j?=
 =?us-ascii?Q?/O2vj5OxYMwzKNUKIeIbQ9YF4OYFE8vN1pXixHQw1eUZrtg0+lEnx1szOggR?=
 =?us-ascii?Q?oLNrSq6INNO9FlwVbOZXtUsr3d37CIFietEKyM9Mio1LlQL/OW3UhSRXYo3e?=
 =?us-ascii?Q?0cpnzOuhMYFulgz6mEx5GhrldMr+nsFtBAO1fXt8xoZjnj1neJrWAphsMBVe?=
 =?us-ascii?Q?Kw5A6TH8JCXtRtm5r7lqSJFG+pAijTzSjtssWNyuxOSBGD+hY2U11F8DRYCY?=
 =?us-ascii?Q?HO+AhijBHh1WkBlETjo/QSW64Kz6ixpluiJYJDPqaVXge/rdbSUWv0FPCOH1?=
 =?us-ascii?Q?5j57E4f/lhTUm/4HSDulh0tX7MDhoLtEsd5SlX4hsQES7PA4jIqWfDbcTZ1M?=
 =?us-ascii?Q?GGfnZQ7OlT7JFH/KHm8T7EAZU1VfGDJdfya1ip0jo87+rtREYfHVwlrcCJ+p?=
 =?us-ascii?Q?VJCtMO0diPdH17hMfLhz1EtQvVS2+r3khRQ+UHMIR7v+hpBR3GmyYzdYNjjb?=
 =?us-ascii?Q?8CiIIKsf/O4JE1FLycSXMdAQaVHZG3iyUJwRhswJcROxu75BgIC4ck+PwQHW?=
 =?us-ascii?Q?GJY4O6swps5b/COHAbFutAkync+5s+R1bKtwhUKuf5NHBm9E+vB/qifW/+4c?=
 =?us-ascii?Q?LSEVIwh7CevcM3qHs3bPiZPA3Ik3pukhUxqDHPsKtY6y2oFwH9tW+8CoNHFZ?=
 =?us-ascii?Q?S7Bd1zU+9PSxmM9yH3ORWhvfKB+shkAsBtpIA1gLBdnra5KuUnuVwCHTM7zd?=
 =?us-ascii?Q?C8fWorglEhw7AxEp3M1dGrEbp1oK6RYiWdz0fA9K1ncPPRiRiiLNt/8qXTr8?=
 =?us-ascii?Q?f2JOoOm13tgVNBH+f/cTeC+HG0z19c/EahzDxScY0m+NAaQQ3725vJs3F0xc?=
 =?us-ascii?Q?vNLbm+gJH+a2swfi48AyRnaVH+Ix3FLvkSop/9nTBYdG2OBNsKS/OlmbENth?=
 =?us-ascii?Q?6mUySq9D9soo/Ym3E/x2fu4MeFcYw4bWT6cK5UByUaiyn8/tpbR6yZr9/2zL?=
 =?us-ascii?Q?Mlp41d/l9cREVgUiPFneaLBmPwZH1JsuzxegKNh63T7uPkf0me1e1JRw46PQ?=
 =?us-ascii?Q?Um/KKwXph9GJkl1bDOcnz5NQtSZaQix4scnxalZ+asDGSgFIXIeQ3PfkrqVR?=
 =?us-ascii?Q?RNGyFhgepyiZRvgwpyC8BAWKJ8cAuvI93ZVsJ7bRPqRBuiZgMKZVPfYu9EkX?=
 =?us-ascii?Q?MMPOK/Kez9bluqyoUdlxmF4/1oVvz1zm81MzF3jBVebMMlmZqLf4LXOuBxZn?=
 =?us-ascii?Q?BjSAScTtHuMbl4330hEqNynIYJvRxFCidqjs36LPL5p+X6TJmiJUO9hC2dx1?=
 =?us-ascii?Q?22atdlsL4WLSSwPNIDxuWSECNJVjpGqdMMaHtTat6TKx5gudIuHQyLu8Exz5?=
 =?us-ascii?Q?N3K1EVMplB5FWYf6LhhWtk7NV4ZSbdCFF/1qoc/CbE5QS0iYWA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 10:23:19.9077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2053c76b-c686-457c-62b2-08dcfcbab46d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004687.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7309

Extend the admin command by incorporating a result size field.

This allows higher layers to determine the actual result size from the
backend when this information is not included in the result_sg.

The additional information introduced here will be used in subsequent
patches of this series.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_modern.c | 4 +++-
 include/linux/virtio.h             | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9193c30d640a..487d04610ecb 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -64,8 +64,10 @@ void vp_modern_avq_done(struct virtqueue *vq)
 	spin_lock_irqsave(&admin_vq->lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
-		while ((cmd = virtqueue_get_buf(vq, &len)))
+		while ((cmd = virtqueue_get_buf(vq, &len))) {
+			cmd->result_sg_size = len;
 			complete(&cmd->completion);
+		}
 	} while (!virtqueue_enable_cb(vq));
 	spin_unlock_irqrestore(&admin_vq->lock, flags);
 }
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 306137a15d07..b5f7a611715a 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -111,6 +111,7 @@ struct virtio_admin_cmd {
 	struct scatterlist *data_sg;
 	struct scatterlist *result_sg;
 	struct completion completion;
+	u32 result_sg_size;
 	int ret;
 };
 
-- 
2.27.0


