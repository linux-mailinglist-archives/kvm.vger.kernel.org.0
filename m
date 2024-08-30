Return-Path: <kvm+bounces-25503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF6C965FD4
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35899284865
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C75A19ABCE;
	Fri, 30 Aug 2024 10:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S9SSCK9e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812B1199FC1;
	Fri, 30 Aug 2024 10:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015580; cv=fail; b=Hkya80ozpD2W3vjdjfep4u1dYlM5JOu2ITYTyuObEavPNb/wkC8Vzus073ed1ehSj4x/+RJZjYPVIf9JfUCMWF/S760DmRzH4tcJahKBtuKUw84j6e+q3Z9F31DCTa4e9H7X0yx9w9w5uGDwW8djSsWAi0lsJFu+NxA3Vx8FPeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015580; c=relaxed/simple;
	bh=/wwMlttLHDsVbK9xHunS0oIvPddiZWpVnj+K/dDI1KA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHeAJ8is4krAXeto89m+sUp5fLdSywwT6MYSK9ZTnpUb+1B1ZAgm5aYDl8en/ZnHsrV0hWuRMrzc0u59jClBBUc3EhZAqIry1E0QwSQdjalG3eug0ljSIAk+SiI0Ga6HjuOqiTFWTsb/gFPNLQYYDfI9/4EhvBBp/nbREr1L7oA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S9SSCK9e; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6F6eGqEyil4hS50nKp6H9knWVEWSaXOg4iO6OgmQI5dqffWlbV0J4mHhneE4ZtE9zhFAdgiND6HENU/q+xxNdL4evTEF00qyLlXPJAHnZXB5RwMKx3zZddbxnxX6SgR0HbvhjIpDOu4uIM2Dv5koTAYnKhneoagmzEiC2oGuVLtZFZv0ijS4Yv/30iglmvL4LEBJcQejKd+mChVnc7ZzenyULbGmecJBUCPtggBszvFpvmu6qK5spvWj3JOgkm/FGxhgYw4CaeeKCr8jUaYjJDKWPfE1x2O1OA0ncSuy2Ttvx5YaDSr62ZLZJZHJP29vle8ZsMO2Oud/ynvN0G8vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iU7Aq2rGDrL2GGGmhNzGacTGEuvMlo1x3owaHepnepA=;
 b=x5Il4ytPXV3lnUGQgMfvvKo9BbcwZvS6DDWGvbTEs/65IBqtwiPXu16SZIpb6kyve7W3eiiFBCim2TlwKfQE1O8vw1Es85ZSO0JbXDx0cTKrutJtuse5XyWQ3MnLr/dkCmEzExuQeVmQeQ24pcs4deulxpWgWFxJcoNCr2SfY90AyQ/5Wz72Y/X7bfFWeEJ7K8pz28ZV7ICojzlmXXl/JMgBXfdAbDgBtgBGNgL1R80gKtbq0SJvdKrLbefGFpHG4HlpwcXjSFU5v6kxB0Zo8b5CiEaymSZOl4I0vJa0zJ+ky5oRaI3PuK3vTjqo8kmidvlP7IL5f2ACJCfD2GhRbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iU7Aq2rGDrL2GGGmhNzGacTGEuvMlo1x3owaHepnepA=;
 b=S9SSCK9eg06casC8KAimRyd+VoSK/cIAFcfR1n07UlPtPhk9S6z//6DFLyjS8IHJdoKXrmDrmg/glfclL0dF0kXd9a+r1r9ZRUQ7hXFMDvCsbfOuKnkgaaa3jcnwIOYhZO6Jbprj8h9IeriLkCCRcouY+vgNJQo3ZY+VKsSGVsGqDATWoziqDdEDKrmoQ6pUZeD6frqP/2xFr5PZUfyDwc35GUEPLLc+xYH7irT0jvsQAaL0nfM0kMHpGxWgi967863/xN3173N64b/2Hm0p86LBAPl0V5RG7Yu8MXRcFisbmsOT8dB8mCvHRIxWgAUqRHXbPeGStSbA9s9R7FpozQ==
Received: from BN8PR03CA0030.namprd03.prod.outlook.com (2603:10b6:408:94::43)
 by IA1PR12MB7735.namprd12.prod.outlook.com (2603:10b6:208:421::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Fri, 30 Aug
 2024 10:59:34 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:94:cafe::55) by BN8PR03CA0030.outlook.office365.com
 (2603:10b6:408:94::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:21 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:59:20 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:59:17 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost v2 6/7] vdpa/mlx5: Introduce init/destroy for MR resources
Date: Fri, 30 Aug 2024 13:58:37 +0300
Message-ID: <20240830105838.2666587-8-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240830105838.2666587-2-dtatulea@nvidia.com>
References: <20240830105838.2666587-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|IA1PR12MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e60480-b286-4bef-7e22-08dcc8e2d500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AsJcyAW2sUnzy90Ba/QnUkav9ARmhiwLpQsd2LvVArQkeIb6/4Tkx9ncV2Y1?=
 =?us-ascii?Q?0Gu6Ymf2JixaRlaUeegLDtV1n13wrKuyztyZvxk3aJBMYKyxm/Zk3XEyO3nQ?=
 =?us-ascii?Q?lmhOeDwovBs0++oDISMOdkAetWSGzjf7LSijrQgUl3WAZOka7EkfPtuAeq5Z?=
 =?us-ascii?Q?IPNYSG1Xy+sHSGLpNsgHoGoyUO188uMksn4Fcy5bGkbySNxo/gE48EnzM8r7?=
 =?us-ascii?Q?aF+MFudLpBlRr5eyVwOELzp1O9OwukdEQo9ct88JYyYMMrqB8EICWgSaYAq0?=
 =?us-ascii?Q?GSZP2rlpoEHjYxaVfWfIeVlvBeN0KeaK7UAVS1IoO98m68r22tiwkWLSN9av?=
 =?us-ascii?Q?G0ZpVD1YeDL5BksYOzEcfOuIk7IC+V48fsmcQQ/n1Ed7DuAbl5BPOFJ8GZ7+?=
 =?us-ascii?Q?gNztH6EryT3Kufs9l13sOEVzEiKHClTRb128ujsejFaN7VthSfgD3koNICme?=
 =?us-ascii?Q?d8z319ixnDdmrLZDRqdmMaJ0kpFC2phLalRjCSIcz3alQ4Bu7XFDA0Tf5Br1?=
 =?us-ascii?Q?TOz1Gp6ZZtog6Fn6ZedfjfhRkcaxfz5PZmrfVzCTOg7VLsgU4P1smP9jUZ8H?=
 =?us-ascii?Q?C1K6vglwdi1dj4SEHfNp8M/zlXQ1DwFDwRv0i213ZYoGD5dQJvWyVaGCISDO?=
 =?us-ascii?Q?KEhoDQfmV9bZZLEh1udx6+BSoDjxJ71WWraCC0SRhMrLDUVLy1HuOaBVL24Y?=
 =?us-ascii?Q?+THGCGsy4ovawYDPSTGUt0WZf/iRjDlAMOVFKvBsdop8GS114eEj4zA3/Kn7?=
 =?us-ascii?Q?6892gKuHzljGFIf2R1yyfkQOJx97qcDfatmRYD8eRfU5nnlhvJltcv1AZNYL?=
 =?us-ascii?Q?qHYkSBumrjL9dTzRZ+AHrrdH/Zt/hHdEdr9kF4OVkxh5ZkKEi8ez1dSJ7v1X?=
 =?us-ascii?Q?AtcqdIDWE+Yg6aobTEaRq1Hwu16Q9Igjw5sv4Hd3tu9XPFkmJ162HrhnfWKa?=
 =?us-ascii?Q?d0chV6j4zQx7FYDvsjpm4qnqFWnO6n+K7NBJ05RuPTx+ZXrg4bZmwnQ7lj7L?=
 =?us-ascii?Q?nCo39GlPlyxqT3ncIlZ27Skrlfw4qLwH5d7NYQCo0HwD1kyiWy9eHt7snIlp?=
 =?us-ascii?Q?k7KYiIebuSCXkEI3n8kASn6TMGSY0fH8Cds2DO6On6QawIUt4LNfBnHEdceQ?=
 =?us-ascii?Q?HHBqUIIgqqdM6cbLEQ+pLT5TCfSgihfogHiuk3O6wPKflaNaYa0WpEqTUsZ0?=
 =?us-ascii?Q?3r1rh8GI9+VzCGe7Q0WP086ZJXKIjY1BMtYx+N0ea/XGGma4BgFOBzbSbfLf?=
 =?us-ascii?Q?biepE5c08qLDG1Hd/ROVqK+nwQoIwhQfpAblL2nf6A1AuDfrYaFM/HzBOQta?=
 =?us-ascii?Q?U6TLZwSgsaIaSz4EWTv7wUit43ItXyHmlouTIOYAhxLCmiqnN3HdA3+jrF/n?=
 =?us-ascii?Q?MnXMEPrHY72k7tuPtYMevjpu0QL096/Ze5rz2hpqnsEbvMl+MM+U4MTSE3bh?=
 =?us-ascii?Q?/8Sio3/ZmvVo/IL7+qakmbi8UeBYx4pT?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:33.9479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e60480-b286-4bef-7e22-08dcc8e2d500
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7735

There's currently not a lot of action happening during
the init/destroy of MR resources. But more will be added
in the upcoming patches.

As the mr mutex lock init/destroy has been moved to these
new functions, the lifetime has now shifted away from
mlx5_vdpa_alloc_resources() / mlx5_vdpa_free_resources()
into these new functions. However, the lifetime at the
outer scope remains the same:
mlx5_vdpa_dev_add() / mlx5_vdpa_dev_free()

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
 drivers/vdpa/mlx5/core/mr.c        | 17 +++++++++++++++++
 drivers/vdpa/mlx5/core/resources.c |  3 ---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  9 +++++++--
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 89b564cecddf..c3e17bc888e8 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -138,6 +138,8 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 					 struct vhost_iotlb *iotlb);
+int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev);
+void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
 		      struct mlx5_vdpa_mr *mr);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index e0412297bae5..0bc99f159046 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -843,3 +843,20 @@ int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
 
 	return 0;
 }
+
+int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
+
+	INIT_LIST_HEAD(&mres->mr_list_head);
+	mutex_init(&mres->lock);
+
+	return 0;
+}
+
+void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
+
+	mutex_destroy(&mres->lock);
+}
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index fe2ca3458f6c..aeae31d0cefa 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -256,7 +256,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 		mlx5_vdpa_warn(mvdev, "resources already allocated\n");
 		return -EINVAL;
 	}
-	mutex_init(&mvdev->mres.lock);
 	res->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(res->uar)) {
 		err = PTR_ERR(res->uar);
@@ -301,7 +300,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 err_uctx:
 	mlx5_put_uars_page(mdev, res->uar);
 err_uars:
-	mutex_destroy(&mvdev->mres.lock);
 	return err;
 }
 
@@ -318,7 +316,6 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
 	dealloc_pd(mvdev, res->pdn, res->uid);
 	destroy_uctx(mvdev, res->uid);
 	mlx5_put_uars_page(mvdev->mdev, res->uar);
-	mutex_destroy(&mvdev->mres.lock);
 	res->valid = false;
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 8a51c492a62a..fc86e33e620a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3434,6 +3434,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 
 	free_fixed_resources(ndev);
 	mlx5_vdpa_clean_mrs(mvdev);
+	mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
 	if (!is_zero_ether_addr(ndev->config.mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
 		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
@@ -3962,12 +3963,14 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mpfs;
 
-	INIT_LIST_HEAD(&mvdev->mres.mr_list_head);
+	err = mlx5_vdpa_init_mr_resources(mvdev);
+	if (err)
+		goto err_res;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
-			goto err_res;
+			goto err_mr_res;
 	}
 
 	err = alloc_fixed_resources(ndev);
@@ -4009,6 +4012,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	free_fixed_resources(ndev);
 err_mr:
 	mlx5_vdpa_clean_mrs(mvdev);
+err_mr_res:
+	mlx5_vdpa_destroy_mr_resources(mvdev);
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 err_mpfs:
-- 
2.45.1


