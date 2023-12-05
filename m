Return-Path: <kvm+bounces-3506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69BE2805104
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22B5D281840
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD60759E4F;
	Tue,  5 Dec 2023 10:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QyMv4RwX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9340113;
	Tue,  5 Dec 2023 02:46:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kd8Ji78g1bHdflSqgDqY+vNsTMkQLbWZnJYHdSUZa2iCw07yOznGMvoh2lS2CRLKWy5Hxstswd+sNH9OI8J6pP/uEwoO5HKP3IMZSOne/0i6aoe40mr5+C6WcFUGQ0p6tWpSxIOvhz1Cqpp3/iFSTU5WPJmPMJtS4Ok/aQMXx5U/9ofSjXqxILVxdNOyGdbz02W7oTJ3nKflYN1wp+fk8E8NPeJ2YoUAyAd5JnhjMnnJR2+fSB/IxcKEhMWLbXrYHavLJXDc5hn6z5jnR6kegqp6by1mC0kfMrcIbe7OIrhJ4v/KzDZmMPBVQTBZ9c9BmruPhCrJn896mbMK1ufY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wS5MTVIMLhDRBwh0qlAFrF8E+Hyo1Jur/HfthTmKAA=;
 b=FXFzlzttpF/ejoHXBoYIeurZA66qmWp13EmuXKENE7Gsy/vRmw1qUGp8TYAQfPlo5zH2cO2kFiYC8X5FjCYZFqGQF/cJSk2HQp40y5cgALWBmlZz3UYOz7t4daPburJ3AZPBHWaK5mLn2RZ3LC5KWagFqsP8o4r27XFPhj42LS1wKerVLSnRtHLdWyRZv4WHkZNNjS2wSfweNJbu5rClXHdMta0hQLHFIHlW/au7qSx48nSmwrn2GGRJULWQX1A4HsufCeav1Q//puDhhUmkrj4gN3pJA/s8SsbzhD9POMKY3XbYVUjQbdOvB1IzXP6jA7Yi24b0rFd9KkhnxQNlAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wS5MTVIMLhDRBwh0qlAFrF8E+Hyo1Jur/HfthTmKAA=;
 b=QyMv4RwX0175InpUiemWVAD0LMH+6CDeLnoFajYqBJGuA7F03MPYxfT9TiDy85eyjgSEpAhU8MqHauXJ33FcdNdB+iIiie8r29mVWxp7B2/ytnhRWl/aygY+aSMi4R+uIhcl5lV8AdlTAxhv+0CTy9CDbJOBwJWs3Sm8m/F9B+y4IKYVD3bI3AxHrrLNfVjCQcsdGlfLGehzL4KCph7GvCC9nT69D5den9MhuQQHE+oKnidQJPPCUNxxagZH2otmct6jT1knhSLZjEas4/3jZSUrZRimPSXKcoF2ZDaariTO3knwBK/JZ0Ik/5Jou7jWUlSEsByGxWjhbrQP7gDfGQ==
Received: from SA1P222CA0178.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::26)
 by DS7PR12MB5813.namprd12.prod.outlook.com (2603:10b6:8:75::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:46:38 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:806:3c4:cafe::ae) by SA1P222CA0178.outlook.office365.com
 (2603:10b6:806:3c4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27 via Frontend
 Transport; Tue, 5 Dec 2023 10:46:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:46:38 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:24 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:23 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:20 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH mlx5-vhost v2 1/8] vdpa/mlx5: Expose resumable vq capability
Date: Tue, 5 Dec 2023 12:46:02 +0200
Message-ID: <20231205104609.876194-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231205104609.876194-1-dtatulea@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|DS7PR12MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: e4887589-6877-41c0-8a14-08dbf57f758a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OxPwki4y9ZrRscJaZc/zhR4r6xHrMqt3SdhOOIvcRdXPaw01JTfL2GRitwHqQdFQOues5obHl3PPI4RCCRDy2/DUU5J2Agx69I7qF1aLOlCti7rnfVo8MtcMkPzS111V+mQoOtH0qUWHaUlMvR3xKYWj1IRHTwLmN8IHBB8EVxMWZ/4qe9iM0mNhIk3pDs41T2rElgAl3gY2NnNKB7z86keaJ3ENg1YGxw9q1OXW4wcGtyKiN1wFpe1bZ7HJZkorJe2yfgTXFRr+mUdKzr4iV1PrxFmfSYWN7AxpjdqUckTfbvn9SAoE23pP/ImZQlrcDbhSBPXbETKCBmxXR6BHp3IpVjrtVLo7pOBDkeojgYdnOyLXsVlDNF+ipmId1InQqUxF77aU0INSWRrmtIF1qyr3nHV0Rj2PrM1kN1ZPVElhQIhXndq9MB0wvp+h6VvSz4pqb2HV6DTYJbnSU3S429jcvLeKT3gKxwDVPs86iWjy0JBJ6FshJ2pAbrH2jr7ciD7GxEw6iV+9oZtV523UuvZPbM3myCb4/CFQL8xOXsJMt6BFTABalqlR96MOwRRCHmlSf2wXis4Ramx/gT7nO1/wbzYRH1BQTo73hNsKpo3H6pSCjSMFV4q8wYdYAefKs0h9hV34fZ6hMlplWFsiIp5xafXVEk1rl/U9dKQr/c9BfLphpaTtumiCxZf1+qTFlY999OiHo30X38IQvVsd18KYqf1FLpoZxA4hlBNAKzNmbK8XQzkKAJCkNSHK5ZcR
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(396003)(376002)(230922051799003)(1800799012)(186009)(82310400011)(451199024)(64100799003)(36840700001)(46966006)(40470700004)(36860700001)(40480700001)(478600001)(6666004)(110136005)(54906003)(6636002)(356005)(7636003)(70586007)(70206006)(316002)(26005)(47076005)(2616005)(1076003)(83380400001)(4326008)(8676002)(8936002)(66574015)(426003)(336012)(82740400003)(40460700003)(5660300002)(2906002)(41300700001)(86362001)(4744005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:46:38.3316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4887589-6877-41c0-8a14-08dbf57f758a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5813

Necessary for checking if resumable vqs are supported by the hardware.
Actual support will be added in a downstream patch.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6f3631425f38..9eaceaf6bcb0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1236,7 +1236,8 @@ struct mlx5_ifc_virtio_emulation_cap_bits {
 
 	u8	   reserved_at_c0[0x13];
 	u8         desc_group_mkey_supported[0x1];
-	u8         reserved_at_d4[0xc];
+	u8         freeze_to_rdy_supported[0x1];
+	u8         reserved_at_d5[0xb];
 
 	u8         reserved_at_e0[0x20];
 
-- 
2.42.0


