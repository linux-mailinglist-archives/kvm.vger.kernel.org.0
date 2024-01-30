Return-Path: <kvm+bounces-7487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDEC842A5E
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 18:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37B3428BB27
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D341292D7;
	Tue, 30 Jan 2024 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dWcPmKxQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18D712838F
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634209; cv=fail; b=MWi54qsNi7ajKNnU/t9nvPseAUnHNDRoW7UJp50vQJBei1P+Ye06rnaQDQZByUeBm/fGQo3IlUgV0p0heiQZ0Y5XSzT77G3FPRyCmd3cQiHi1pp4Az5ds7Yz3jBIeTVejZcwo1Wl/JPhARqI1vFiP9me+ftxINU2dCdUvT0UMFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634209; c=relaxed/simple;
	bh=bEStpGhp/jxgcocrPeRlB2Z2Aq4KVLJWW81SgF4OK+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEMjg6bAqDxpQ3skVfgEVI3ekmSMHLT5AaSgqAS5JZt4O4VwKeU4vs5Za+XTU+CGWJa51MKjjVgcycu8ZJZQSb1FnY2wkmI68ZOK80/eu9qruFEQWpNPro8phiLz2CctMsW5bwiiP/eqcA8Ra11n096hxqTwlAb+rt9qBQB/BE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dWcPmKxQ; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ly05MkkNnsXiBnVfKDjVFlPiC70qP7TER5yoemvlsjU99T3mcSDI1r97Co4JLj7/J3ex1rPlF8c79DIdpFgm4S2YlNW333b+5cLCtbWDWOuRnv+eBntyHv2KwjhG+IJJRocHynPzcNp/vA7Gg5JoqwPDRKrAXuLvg6UZjd1zKvWvtyBoOsa00yFIZZTLAL7OlrA8Zk+3S5ElgcY9pGIkRDbsk2TMpEQig8Svp7n3jQi7jz8UXAbxnCizovvf+KQ7vqUgkEnn7RmHYIcel6i3gKDU/CGy2BpBjZoG9/RrDjsZLKB21gCH6P9nWWkHdQoya3YZeADkSU/hg9CDXZ354g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9m5z4j22vPdJjJPs+MBTWAJbpLlAEXZmcstO+GhBDys=;
 b=NQIxWAXVMzvSZvn0PPvoNro0jWOMYZAmJoa2St0gTsP0mZMqsS94RlUvprcl3Q+kRNwKQiRm/7neSJ70B8rvS0P8gNwzeghEkaEVchNWhHu4Y5q73NvtaRA2IdUwmBtZ+UZrtp9kcgWsJ5m2LJR77+s1R81E4KLKqfIk3VZ1qyhXUzfhH9DZPGnmCDhvYx1LxRZQAzQI75u2MC4B/oyODNt1iCSCcuwvj0Er37Gyqkhc6BBOmFSWVWMylIN1gRvYO1JVBZYe9zE7i/J1i1rmSz649zqr3DwSwkvZ9P0RJPfsg15p5YRddLMBGT0WIJdNcHfWrHxaV/vwnrxd9jJtzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9m5z4j22vPdJjJPs+MBTWAJbpLlAEXZmcstO+GhBDys=;
 b=dWcPmKxQk0Ifw/oYmaoEtZ7miy+EN9WVoisuwA1/qv9N6gw+Fmcl6QGQjClpY237xc19Hf+MeT47uekeCn25DieoHdqBd4fpwr9h9yzj3qfMQHJTlghkKxT/VOZZC7j+u/3MYEmWDSWi2A20x4V4ZVmgK0DWKqFnA/fbP/CyL1k19TJBn5naVcEf9ydaL6E94hqmdF5Lkbd8zNv1fZTKmsPVUdzxuktThrUrS9m93sqeNn/8ZeuCun8FNVJTo9+NSNEYluDWYjbCtERr3Z3e6iYI5mYgekiTn8wra2kX6dZ4foUmM2KeAWEUtaXUkq53Y4rftLSCrLfNw0jo4AR+vQ==
Received: from MW4PR04CA0322.namprd04.prod.outlook.com (2603:10b6:303:82::27)
 by IA0PR12MB7532.namprd12.prod.outlook.com (2603:10b6:208:43e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 17:03:24 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:303:82:cafe::eb) by MW4PR04CA0322.outlook.office365.com
 (2603:10b6:303:82::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22 via Frontend
 Transport; Tue, 30 Jan 2024 17:03:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 30 Jan 2024 17:03:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 30 Jan
 2024 09:03:07 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 30 Jan 2024 09:03:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 30 Jan 2024 09:03:04 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 1/5] net/mlx5: Add the IFC related bits for query tracker
Date: Tue, 30 Jan 2024 19:02:23 +0200
Message-ID: <20240130170227.153464-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240130170227.153464-1-yishaih@nvidia.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: 84ee3e33-e7c8-4f1a-959f-08dc21b55eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A9W5CBP5Hr6Pik1Wa3FqFFGOzRLn///5l4U/1zbU4aTW1Uf86Zbf5iLstGYCwP5aeDbd30G+hFXnTCEatBxWEHpl1YfoZ9T+J7GoG43U11DDYSGGZl26NNOA+Z5ktPhGFQRfHHVSOeQQNPlvcUpz+HirhphzyU9VAyaFxslnON5ZCN+Jkhn9Ex4YlyExePx/FeEmon7+uTpmBiPxhyiS5ZRXUMuWmD/2Euuwdr0b5MtGbEZBWMHdp9CSbJ9yJNLAp9KCNhOdn8B5QsrMa/ID4V1O+zzH9W7n+0PE2KFIpUUQo7BlfzzNayj0zpNURth72tLQTBZlGnuhwjggmzPkKbkHNqdS/ph/U/OEF41X8SkV6swmp4Y6zZic7k4+zqyze0oAVB41+xXKQxgJiMxD0r174NsWGxv5f9I6vhkrLWph1awOQbUr46QBn5uZ5iyCBkiGAp//TkQ5xy4IpMnjx1tm62kV6rT/SdXCWKVwbEMda5anJ5kfo8nnUKhQHdmBPHZNVm5s8e0cZyVh+76yGWX/WsWjNzDcodnybwZ31/9vt82UWvkVohzjKQ6UYrSLnXNvS6z0VovDGiMq971ocf/ykx7QH5v7epE6uP8mbBRnCRbEej9HmMlA9DpGAiUkCEfeaJyG5T5NnpXKD/m5OP3+01nFvv+B/N9x3kcR8PuoNPo8KKn+W85L1tRzM1O/vCMyN6QTW8JWFxKpl4Mr/TBzZSvgGvg7uzsYO9Llps7yxLcmlJq2PH6D4CDiGUnK
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(136003)(39860400002)(230922051799003)(1800799012)(82310400011)(451199024)(64100799003)(186009)(36840700001)(40470700004)(46966006)(47076005)(2616005)(426003)(1076003)(107886003)(336012)(26005)(110136005)(7636003)(4326008)(8676002)(5660300002)(8936002)(478600001)(4744005)(36860700001)(7696005)(2906002)(6666004)(316002)(70586007)(70206006)(6636002)(82740400003)(54906003)(41300700001)(86362001)(356005)(36756003)(40460700003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 17:03:24.0651
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ee3e33-e7c8-4f1a-959f-08dc21b55eb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532

Add the IFC related bits for query tracker.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6f3631425f38..cb08b5e36c21 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12619,6 +12619,11 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
 	struct mlx5_ifc_page_track_bits obj_context;
 };
 
+struct mlx5_ifc_query_page_track_obj_out_bits {
+	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
+
 struct mlx5_ifc_msecq_reg_bits {
 	u8         reserved_at_0[0x20];
 
-- 
2.18.1


