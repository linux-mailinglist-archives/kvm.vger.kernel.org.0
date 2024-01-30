Return-Path: <kvm+bounces-7489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C47842A60
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 18:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C81F31C23D6F
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9936E12838B;
	Tue, 30 Jan 2024 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ROcY+PjY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B4F1947E
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634212; cv=fail; b=cVHLfBf7RZLiNPImERK6dch5wxurmFdKJ/pLFhTHbLZwI1PIlPdgPolE2ZCpJ9Vj52PgYYBou15Kp+IjeiZhUo0h9S1J3eUR2+p54MnlPDlkW+bitrHiRitUaXLucpmMsJLjum32LXJ9GUqrLIptgH7JhOKssZBKcw+5ihE1FM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634212; c=relaxed/simple;
	bh=itpqtQiR+i4bIu8JvhYCCEJZNENJMrkgDe41Hjy9RMA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSlv28mYZ4wQcCzhBfvmkaX03yXzj2dyUpt8ywF75K/qD5f/AutfKCWMQp5LOi8B6K/zmMOz1wigGUDCoDefAyISNELaFtC7L3YaNjs4x7YJfXn9TZubr0sTxG8czEv9KqRMURoloeYNqmps1fxTp2dM19kvYB7bbNxvjTIngcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ROcY+PjY; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhhVLzUylsF0UHoIO7MCsuKr1RyFIrWXwah0iXh/QioNO0x3U0GB/05QJFIxo8i/v+YSvgIDTmbDAinUHI3mxSdQ84ysbz8fU7LddkCt9ufPFqic5WMYP8rj02s/oxXj4dJy72DtwwaGMrXT1Mm3uNN3rPhm7D91E7bW+nFekpQPd5jZqViKw0uBPkVo20S+InERUr7/1iMraYsheuQ3vRzkvbIxA4orw7RJ/ezi3/16QlhfBdg1wSOQiucWiADSk4a5D+5tteclYN15+AE87lq9TwypQmtw0sp4ooGsh6cVevYl9ApMbU8ErEYA5LKK3iw0wVxk1mfVvyIKM+LdbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrZQZdKGxXTkM9EmnvPmx5VVc+WnnBBRaMEFHfSqs0Q=;
 b=PalheGOamdYhRKL8n4NbsQftLPM1KW9dit3E5KhOqo9Rcbqrkl+lFh0j60NzUncmzoalovrXW5OQyuluAscJhBhe+vDW1JlmvUtzE/aZDCEKtVIVDE0VkMU5yJSSjqfjBuZTT/FzAKDLU9dVLmGmQoVRLQ0e7KEx/aZ6ImUuQBdVtI2X2y701xXMzsP4GYI1h8co9kb4kaSUL7iVUzdY126Hij35wAnSjXeoXVtp7flpB6jeGVgEBihXGAZHwIYINL957+C6i8CWeWUreHKD0pm0y08MpwS0ZQBrXQxHsTZdn4xVL0MYDJYEF5aaMftSnkgLRXO63lPliNhA3lnWZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrZQZdKGxXTkM9EmnvPmx5VVc+WnnBBRaMEFHfSqs0Q=;
 b=ROcY+PjYZlxBU/dkI0dVpN3f20QSLR3MTRl3+drOOkMADwp+ccb/i/prpzgDh8Qx5jd8Xv9+HVtbgzdwHN9ZjWs85g7z/3vQQVPvJoU+s2wZIMpgWHYCFklarl/JE7rkI5OgRV256+WqQaKNCoOGZjts1rIN3prOQTYahXFrLswSos7zXqWIQpMmtWhzQ5WxxlgU0K1NiAh6jPOUjaoSxa+yRJikKB1dGw0C8s7xPLe8ZgKOxq6Y/04NlaZXVdu3v5x9w/M/ROBIc4iqAL1U1DNfZqzRo/YQVZjbjxb5RhDctwGrPSdSJ5/X5PYNbwYZj/2KJlR3k/aWgJBlwG+DcA==
Received: from CH0PR03CA0389.namprd03.prod.outlook.com (2603:10b6:610:119::28)
 by DM4PR12MB6061.namprd12.prod.outlook.com (2603:10b6:8:b3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.32; Tue, 30 Jan 2024 17:03:25 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:610:119:cafe::9d) by CH0PR03CA0389.outlook.office365.com
 (2603:10b6:610:119::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34 via Frontend
 Transport; Tue, 30 Jan 2024 17:03:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 30 Jan 2024 17:03:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 30 Jan
 2024 09:03:14 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 30 Jan 2024 09:03:14 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 30 Jan 2024 09:03:12 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 4/5] vfio/mlx5: Block incremental query upon migf state error
Date: Tue, 30 Jan 2024 19:02:26 +0200
Message-ID: <20240130170227.153464-5-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|DM4PR12MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 42d848e5-a048-4e42-5ece-08dc21b55f95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7MN4Pic8kzgIdlEQEdZWKdDFYV59+f04WphiBNQr1cSK3O4z6+ljjoHAmzA7hlBMTJHUvjOhooozkco3carjMs6Jc5dPNhHEzFtEt4JB9E8GhZ3csqacriCMOqbcSe1ADHYHSxNAqlztJkCiHgVohg/oN+KkwDrLY6gw6yJNK58sHQa7l7y/zv3pki8wj2ZC2Dg3ut4cS+6VdfJb0QJyXy7sv1NEsWtEwr0fUrqnSOGUVM0+c0XSx//XLMKgl89KplXybgoNS9b1swXWwSGILqSLDojlannxwyUKilihXEvrnXGDRJ8c21CVW0V7u8kp8204mjRMS7XYPNYj72c1aFImmUDj1Kkt7aMi7zziSPUMESo9UO3K7j1IwK0PFbLNXlTPakYcC0UnXmEf4yBrJ+WhGc1TncL3D9Nasjbuq3lEyn/RxP5Yra+Y9HxXmvmSfnOn84WPhK/nF5t0V25bnFFnAPNECmUE28QvFqscRBuRiXQEs5WL1zEtF3/D8XrI0Dk2yLvR66T404rECdR3Qdr+6mpdQcXS6x7I/I4dtOeYyf7zZ7NUEKsBuS8v4pSYK+vRbIBApQNV2XsxQRx54mYdEzCxYth4QFqLdLvpKeyHv/Xtyc5vWjujMZ5GCusA7gVJW+2o1ZQBD/QUn7gXdPzJoFVwRrV4pWhUIBWEwbpEwEtfUFonLp6dykN0CA0BPKpEnJeR4gNPiuB0q50l+ErzewwiWRlT321pH9J9Etk/XTtvN8WuqC5c71vcAsnH
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(186009)(451199024)(1800799012)(82310400011)(64100799003)(46966006)(36840700001)(40470700004)(36860700001)(47076005)(110136005)(316002)(83380400001)(6636002)(54906003)(7696005)(70586007)(70206006)(8936002)(8676002)(26005)(4326008)(478600001)(2906002)(36756003)(1076003)(6666004)(4744005)(107886003)(336012)(426003)(86362001)(5660300002)(2616005)(41300700001)(40480700001)(40460700003)(82740400003)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 17:03:25.4939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d848e5-a048-4e42-5ece-08dc21b55f95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6061

Block incremental query which is state-dependent once the migration file
was previously marked with state error.

This may prevent redundant calls to firmware upon PRE_COPY which will
end-up with a failure and a syndrome printed in dmesg.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index bed1ba9f1bf5..65135c614b5e 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -121,6 +121,11 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 			}
 			query_flags &= ~MLX5VF_QUERY_INC;
 		}
+		/* Block incremental query which is state-dependent */
+		if (mvdev->saving_migf->state == MLX5_MIGF_STATE_ERROR) {
+			complete(&mvdev->saving_migf->save_comp);
+			return -ENODEV;
+		}
 	}
 
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
-- 
2.18.1


