Return-Path: <kvm+bounces-3513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 344E480511A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE420281976
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF085D908;
	Tue,  5 Dec 2023 10:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XZYo0Dl1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F833B9;
	Tue,  5 Dec 2023 02:47:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWJfSXBxhHLPtpCWsZ35T4cNkw4LDqTxrPSpzIk5SmM70V88Vn8+Qq7INVoN/gxUBjKoO8W9VkWEzbl8jVIXM5mPlsdv/4qKiXZsGzVXXWbxWHhY3z443Y1xXmEpW5XiPQ4VBINjiyAxXlLZTDQ7jWzbZzyyvbS+4lbU06F/yIxwqP3+prONYMo0EoEWjMXXviFa452z5MnK8tLdhHBtBTab0nX3ZT1DE2i2cToitBLSvGaW7Zbo+M2rcKYWwSLlI3mojw+uUxcxEZL/0N7IT3ya+wsQXe469fuOzMavFVI08jx86M3C7SJYoBK3eBGbqIFvAXEhQs/kvV2klxw4Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cW138V3/fZ5TxTAkYoTkM9wdibA2aaBfTJwyExACtWI=;
 b=DZxZoSRzu6zaWpoWKZq2kcnsGestbSpCD5qO7x9dY59ev3GaHc/KxQW1/5Lqp5dP9zO+3yyZxUwl3f1G28oz1bXK86nr0hhP//QpD+JlfzvBAOIQz1PQgAiwBzsTqq1RnIEF232yQ5EpR8n+qjq9kIz0vjubg++Nm5OPo+SWfbNGT+mqUgvzswGRzwedMMouzmj0+mHsPkI7ic2cx6dsW7Thji8XkZiVd6eptnKnfKky8O//O6MMYFf2eD9rk4AUKoQwSrGwdnFhiKXxt8bink9vkg+LgNCCpXRlOPYPM5YI6kHwk/i05MRE6RzKN9IUtvjnT5F2Tcm06HKi+HuUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW138V3/fZ5TxTAkYoTkM9wdibA2aaBfTJwyExACtWI=;
 b=XZYo0Dl1io6DNWXp3MQtJJgRKd1jSpg79+XMJ18iHHOwN40sucVu4Y6SRphC+LG3leOoyRSGW/gdANLPbz0rPXy1NFTS3BR1HVNX8jADM9G2IvNCw5hitbfD/r/IPjgFq6FMxoMNheVd3VWlGmnQ6UWGya00SciB10ZqKmM93P5tpnAum7kr7qQ2mUtE+rooSYR5YGubpZB3ZJI9rVkP0vlgSXPpXLbyq7cK0dPr+O3Dskx481UYW697pM+8/5F9DTuZ9ua15heQpjz8AxRJn6TNI36zQnh604A94uLNm5w4pwj+MdSI1sdJICL1iVO4Gy2VEMnfzCEZVio8agkQ9g==
Received: from PH0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::11)
 by SJ2PR12MB8184.namprd12.prod.outlook.com (2603:10b6:a03:4f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:47:06 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:510:d3:cafe::a6) by PH0P220CA0013.outlook.office365.com
 (2603:10b6:510:d3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 10:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:47:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:49 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:49 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:46 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 8/8] vdpa/mlx5: Add mkey leak detection
Date: Tue, 5 Dec 2023 12:46:09 +0200
Message-ID: <20231205104609.876194-9-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231205104609.876194-1-dtatulea@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|SJ2PR12MB8184:EE_
X-MS-Office365-Filtering-Correlation-Id: ed47a027-13f1-4325-7edf-08dbf57f8620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8YP7t7SmWJdgN2feMpXljMTk2SBdWvrHKb0gu+BK0HWrxbX6LN+hwoM08zSlqOxg0vMPwPcjyfNPAvaTHxU1j4Bj9ZYPu8jJwG/JDlAar51TWkySrtIY8mfSIdniF296vl33W0oJGaxIiDYbPc844n7Z/PmTXQ3vL5ernW/gyUiHRMrZJk/bYa//equayAgsLb9+wWJEPUtN+g3MjOz7+xZ5RF0hqbAJ8lCpoyEr++i8fxxh3UaIAT/jp/JbuU7dyjFFzRA+vAILa/TyijExmcRI1iy+/n99gysXtWKHfqoz/JKK/ftelE7f1xgBys6S7G+CoRwYPDaflW47v5DnabRxlt8XtPrejRfqsSinML3girpFdWd6d4Fe36JzfyGOn8+oP2+BJLeSvoo7Ppa2ViufLYtpIT3y7k/ciG9CRWw5qTohyQQWuuvhWd/dSplEsh/BvO8rEBe4hhHi8euKs/T3QMVXDkxYIQLokOICOdhXJJx+1SG0+9/UIa64OdMzUBtIQmFysYq4iNudKJLXWZDsPRNgIyVqxpI1YFoDJG3XUsiBs/Ad0Gh9UxhP4nIc3ilwXk+I2G1RDGkpHCCuvb8+1fQDgOZA9I+IeC5UVeTxIyjt8oDKtTzr27XtNcR2g5sI7nm8M3uOedAMmo5bvUs1eJE4DWzCEFOQYVMJeAbVAJN0KIFAnlL1wi8U/SeCaEtpVV8Ql26WSCcrVu9j5qVm5XMkX0Vw0xOwBWwsexiEyqKgTcJJDyWwmPRHuh2i3k5pvUGY29noT+sGQpFtas5J6mLd4nwmwQrZ1Ib7dRw=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(136003)(376002)(230922051799003)(230173577357003)(230273577357003)(451199024)(186009)(64100799003)(82310400011)(1800799012)(46966006)(40470700004)(36840700001)(1076003)(2616005)(41300700001)(36756003)(86362001)(426003)(40460700003)(83380400001)(26005)(336012)(316002)(70586007)(110136005)(6636002)(70206006)(54906003)(6666004)(4326008)(8676002)(8936002)(478600001)(82740400003)(356005)(36860700001)(2906002)(7636003)(40480700001)(47076005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:47:06.1579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed47a027-13f1-4325-7edf-08dbf57f8620
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8184

Track allocated mrs in a list and show warning when leaks are detected
on device free or reset.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
 drivers/vdpa/mlx5/core/mr.c        | 23 +++++++++++++++++++++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 1a0d27b6e09a..50aac8fe57ef 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -37,6 +37,7 @@ struct mlx5_vdpa_mr {
 	bool user_mr;
 
 	refcount_t refcount;
+	struct list_head mr_list;
 };
 
 struct mlx5_vdpa_resources {
@@ -95,6 +96,7 @@ struct mlx5_vdpa_dev {
 	u32 generation;
 
 	struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
+	struct list_head mr_list_head;
 	/* serialize mr access */
 	struct mutex mr_mtx;
 	struct mlx5_control_vq cvq;
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index c7dc8914354a..4758914ccf86 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -508,6 +508,8 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_
 
 	vhost_iotlb_free(mr->iotlb);
 
+	list_del(&mr->mr_list);
+
 	kfree(mr);
 }
 
@@ -560,12 +562,31 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
 	mutex_unlock(&mvdev->mr_mtx);
 }
 
+static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_vdpa_mr *mr;
+
+	mutex_lock(&mvdev->mr_mtx);
+
+	list_for_each_entry(mr, &mvdev->mr_list_head, mr_list) {
+
+		mlx5_vdpa_warn(mvdev, "mkey still alive after resource delete: "
+				      "mr: %p, mkey: 0x%x, refcount: %u\n",
+				       mr, mr->mkey, refcount_read(&mr->refcount));
+	}
+
+	mutex_unlock(&mvdev->mr_mtx);
+
+}
+
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_update_mr(mvdev, NULL, i);
 
 	prune_iotlb(mvdev->cvq.iotlb);
+
+	mlx5_vdpa_show_mr_leaks(mvdev);
 }
 
 static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
@@ -592,6 +613,8 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
 	if (err)
 		goto err_iotlb;
 
+	list_add_tail(&mr->mr_list, &mvdev->mr_list_head);
+
 	return 0;
 
 err_iotlb:
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 133cbb66dcfe..778821bab7d9 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3722,6 +3722,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mpfs;
 
+	INIT_LIST_HEAD(&mvdev->mr_list_head);
+
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
-- 
2.42.0


