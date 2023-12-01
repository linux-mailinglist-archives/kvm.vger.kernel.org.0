Return-Path: <kvm+bounces-3092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4FB8008EF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61BDF281A32
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5709D20B21;
	Fri,  1 Dec 2023 10:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CrMptfkL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974EC10DF;
	Fri,  1 Dec 2023 02:49:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5adrPuLaMD2fPz/ToNnO23Hpg1439ZWtLXFaEQy1pwsDRQtq8gDt5CWNdBgZJWNQyOc4GRH6wRW3gmShE2OUBYBcRoGl7hml6KKlecxtdT4yH9Ujz98a7Jdr3TLf72vN6Rt01Rk3DTq6vu30dlSGWrqteA6+jZxCdSnWDZOlvgSiIMmdBUEeJTg3anYeEkOrm3YseuOhRFrr2YYlX+bAwJDiJShphi0YxK73K+PthK18QxKwlVTOlH9okMmEpHvEyvJShGoWpmVIiv68iq/Q9piltiXFRBYAuIfBrXygBHEWma37kfRCU6fv+SGXLlUvfXj+3FcI8CzWZWPw3s+6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLndcNIvbHaL6btQSx+smp5PpDwR7TaSywJapj3aEO8=;
 b=SuEeg15CurT8PI361zSeSiVWVrMbP9h40Tx/LEriwxGzG18uyRL0OaVcuIIDiDyVP3niusiuleSjslqC0E9C2aFytc4zQQsl4d6Xaqi7haxij8IZWBwEMGPm8E4vSwU60StbKeykUWFiC2ZZ+lhE14uMU2YZ6JoR0FzgBcZ1WVGgbiOHJ4BjAWGztBzvY/Fi3sK2dhDJEeO2fOro+Jvd2Xze8VwjnaZrfLif/LW0JtXmP7dLX94M5bUIP+gyFeHDbX79JbAAEttSkpGV6WZRVRSOcoezkldINzwZZ4AnXOYo0w+aQFKSqr/6JyMrR8Norz4EO1WVdOalKtB3gdIl/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLndcNIvbHaL6btQSx+smp5PpDwR7TaSywJapj3aEO8=;
 b=CrMptfkLOfF0i46iHFH1yBzyAXDe5sKzq5aU7CxkbQdLlySllZ+JInZxyL972URmiaWdd+APo7jVP8ZVVdCFV84obkbWSAa3Ssq+MrEVmZtnOTuuK5Ai7I96avI/LruO/df128/bXDD+csvqE2nu4MUgTnRCqTqP6I892q7/KN3qVNeiS4nmKNBBKILC8vwBkLSN36RKXSWuRqmqstnePgarjZ/M955wck+PKxE1JaV/eAwRQH1etTM/zQNqRJpeBM/v4RAFwiifs3A0AVsNwr1rZ1UwHOfYcIOh/p7QPQKWI14OttRnzc+yQWTUdIuFItYRxj5mcl0Bbb32qV3Qmg==
Received: from MN2PR20CA0063.namprd20.prod.outlook.com (2603:10b6:208:235::32)
 by SJ2PR12MB8831.namprd12.prod.outlook.com (2603:10b6:a03:4d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Fri, 1 Dec
 2023 10:49:40 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:235::4) by MN2PR20CA0063.outlook.office365.com
 (2603:10b6:208:235::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28 via Frontend
 Transport; Fri, 1 Dec 2023 10:49:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:49:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:22 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:22 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:18 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH mlx5-vhost 1/7] vdpa/mlx5: Expose resumable vq capability
Date: Fri, 1 Dec 2023 12:48:51 +0200
Message-ID: <20231201104857.665737-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231201104857.665737-1-dtatulea@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|SJ2PR12MB8831:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d504498-a8bc-48a5-7653-08dbf25b37fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	O7Z1MNOFn+dnL8jzlmONFP++umlm3SVksvhoychYLULUWaDc6HOCaXevpVjgJ7OvPLChbtyHGBlAjWOjJKuP41lm8UuIJmFS3WS3tyNg5k9BqmAzZF5cwxDjLiGWat33vaLalzrsjWaN+CDAhKoVyKAFVfhJbsTvfmz6GCriJLCyDB2rkpF4STq9vEVTiiJ2DBbuoQXnaZQYDpRfwDV5+vE/qHyEH5C7a+9+2hYVf8B2eUBc1t3tV0phMseFvNSouYiTxA6J6fTMYRlJlOM+cOxUo7cxNx+m7eCJQvZxUpHqOul4l9XBExv09D3rlwa4UWisVEPfZtcjne9dMijCeJEhlCLhLko5kO0nrkCb13r+9HpTRXFum9DAgN1P7LxrFoXksIOe8FkYAiRaeC/YlwAbtpfyEYG5Ti15IuwO0KqmLqJVi4mAs/kTMJtsbcoyb95iKMhshnjinuAleI91tkYLD9j4WVv6khcB7e7N/2InWz3UGLVzt49026G6Cs7T39cp+VwId3uxSw6DpOsR08fIgmGb9XLE34WtPd9T/XEWYIZZKIG2TVqBAM5zyp3BmB/+heb79ck6o2Duz8uTRMuTroF7yDutRpZ/jqoRrexdG03QqHQbZTuwMK40UryVcHO7KNIA64jvAY8ks15FIBYxtv5z6MtdpgatTW6riS8A5BERIEw4L6GoQctlo8LlenvDuTWDb8OPz4RkbBmUrA5YK+7wpiqoebAKGz+7CNIwgipRq+/ca6Yh7miMTfvm
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(186009)(451199024)(82310400011)(64100799003)(1800799012)(46966006)(40470700004)(36840700001)(40460700003)(356005)(7636003)(82740400003)(86362001)(36756003)(478600001)(2906002)(6666004)(4744005)(4326008)(5660300002)(336012)(41300700001)(426003)(2616005)(40480700001)(26005)(1076003)(316002)(8936002)(8676002)(110136005)(70586007)(54906003)(47076005)(36860700001)(70206006)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:49:39.6329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d504498-a8bc-48a5-7653-08dbf25b37fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8831

Necessary for checking if resumable vqs are supported by the hardware.
Actual support will be added in a downstream patch.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3388007c645f..21dcfa034b7b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1235,7 +1235,8 @@ struct mlx5_ifc_virtio_emulation_cap_bits {
 
 	u8	   reserved_at_c0[0x13];
 	u8         desc_group_mkey_supported[0x1];
-	u8         reserved_at_d4[0xc];
+	u8         freeze_to_rdy_supported[0x1];
+	u8         reserved_at_d5[0xb];
 
 	u8         reserved_at_e0[0x20];
 
-- 
2.42.0


