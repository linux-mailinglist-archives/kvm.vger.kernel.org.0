Return-Path: <kvm+bounces-7488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 208DE842A5F
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 18:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D071928CE06
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEE212838F;
	Tue, 30 Jan 2024 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JKWTv5oQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EB91292DE
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634210; cv=fail; b=o/3lX6LOIrNaLYIAzM4vmealBMFXsQer+hy2YU++jmmAVxCfQZcM87sBXSiO6pZzRAHVXBIR4Zh3l85B/CX6IiumQwZudWF6cx9oN5kSWxPhFOMZt0Y+CaXQxeiVNLluoPg398J336pyj/bGYOsJU6ueaKoLEmIEYAMg6cKLNvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634210; c=relaxed/simple;
	bh=fmDV6O0A8bSm91lUtmtYy9SJDYRqtSEejmfL1OO65GE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m89emeps7lqWQRjN41qcNdibv6b+NkoY8xJ7s3qYfUV6B5xIXq6FbWYBDa7IM51Ee3dzdqin2Y/GQS1Td69uYhx4RsF9rxgRoyWk/tDgryDA7Ee/sphRWIhCsgDo9Rbmgb+AjAry/1r2HG1GLmo4G2Wq4qvq+oSikw638IKbLkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JKWTv5oQ; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4sV84aAw9Tv/P4VRPJo/9TK6W8NwEW7OBY0hVwSs3zXzV6w74ORgWIW11Gg86qAxyPPCxdlB74NSmUkvqIpDXFTosUk9wr/QYl9Qfm4B+HZiYf1kkncgh8DDAacb6A8xxs8GJEzjbazDr5JkKBOAmsdY2BKjC7E+oZJWLbPvz5V1woqrDhKrJf8yvK1J8jf+qfl8AJnCZbqfVwyO1Y+TOiX61UHSotK0bMwg6fyPjHRF694kzSBsS0j+bnuOYMN/REGTF3rR5giXGL4Mg7r1TDcrb/sl4yHuR3KAl8jLKbpZQ3oB4br7mYgKnDYhr4FiXCYmrzhjRCurnaDAajZUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/sEk1k9YtRPQfalPnXRXOZn57RWQOeRsPP5KWqcmeA=;
 b=lY4dZVI6GLVS2XDjXpS1poXT5XPHkKee4cs/TaoTAk0LKOkhiUd9zVkOUCGkb/LARtkB1LfbuE8oJNwhuDosqOQOFIvoCO48zK9l45lec4suKsIMboMwJXsNmKP+Ro/H1C2CMgVzus01ipNJk//DVdXGS/HOMsUwjZfucBTg3K2naKLTRCN2Ha/IT1JZPcHX/yRPu5JLzkWqt0LmGlcP+5Qj61hhVRUTAIDCzG4EadGxuWZ/EG7gMFaXIJd5n2C0nnS/8UuAdpRQfDviPEWlpuck0oJ+ZZNqMnZF+gpvM2mzrOj7/qOjLO0VDMTGbqj4sYMUgAe0SOit1H8KGN5f3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/sEk1k9YtRPQfalPnXRXOZn57RWQOeRsPP5KWqcmeA=;
 b=JKWTv5oQSLkxO6NYE9QsVvPQUW/obE/2wPmAj0+X/WROHO0KtoUv6gzywmP2PsrSmZ87BXypWu3eeNoHeNwSnBdnZXirlrmfDO14sPH9RJ/p8REnCLJx5riZHILJSYCRQLfKZ/fnavfCTtoGWCPt7kpUhVWHLq6JAN7y8QxzSUrenU5PDTpdxZJP7XS9ogMU0ZhWfBM7/x2XnGsZrT330Mz1l4WN+WlVjBIP/6rZkBo2MS17fwbizpkyy9x9VGi4H3snAqbKJ/mJGucMEEzXiWXfIfW/2KRwMkSrUBhKW1s0HOFg1g99YyegEa7J7/M+XEHfgOnclZQ/t71K6v8ilQ==
Received: from DS7P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::13) by
 BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.35; Tue, 30 Jan
 2024 17:03:24 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:8:2e:cafe::f4) by DS7P222CA0024.outlook.office365.com
 (2603:10b6:8:2e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34 via Frontend
 Transport; Tue, 30 Jan 2024 17:03:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 30 Jan 2024 17:03:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 30 Jan
 2024 09:03:12 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 30 Jan 2024 09:03:11 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 30 Jan 2024 09:03:09 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 3/5] vfio/mlx5: Handle the EREMOTEIO error upon the SAVE command
Date: Tue, 30 Jan 2024 19:02:25 +0200
Message-ID: <20240130170227.153464-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|BL1PR12MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: 4abdcf87-3387-409a-d72e-08dc21b55e81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vdt8ZNNPMy4Py0O5XykIdi/12YviD8VU8q3RLTfwudZRONhH06RNdLNL8TElLe2CLdF2EQX5F1DTfK2sqZEitXiueQK/IHJ0qkeIW0RoPMuHlanwtaD0zPqfg8c9/57hXfvcr2tB7DK7p6ZTzv+EhR+owIm4b7tB26cjhljVwWj1efRnfGfvb0y8w5+yLJKmt+GJNnMmvclaqpKq7hFij2zlmWuqGUFQ4BQJOYLRj7xgb0hHFVcLky5K61niR70Wr2OGk6egVOSMD2Kyl4iZu5duF9TAq/ofmHU7/sClXrvxjNjPc3f5fb6gaYm3DqRi5MxTb3rBE8NR13+xaK6kneSJvxu+g6JygjkQ2swIcNSBIb/i6Aw1k6ptxD1RhiBsatQt8FJwM4ToInONQEzgCwXg4BvWLVzn1hUPGVtryboaGqi2Mye4dLBDoUXyQsNKIHeThkrT01frneMRd+9nnwIuFqiyKBYmYsWcW+QaG+bmah3nZPJuDsIc7Q/yYVjNLf2azGJw9/oV9bZTCiAVfkabwuly+JrzoF6Atrk/vouUTRa/4EIKx+/TijR9VGm3gXQ0ICEN6eJ8HxoatXcxLAFsu7nH5kbg50UeBnSz1KO4CtmoWegMlAiEP8ZtHVSoEQqNMW/gIWNFtpnP5sHaX3yEtFRCflhXA+sdDs93L3USn1r9zqRkXlNENT0AYe6yVIcUeKGdfV/ThezrDC8n9lbD6Svl750koV4Y4dshYzRP3l94rORYoodvTv/VeIJp
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(136003)(396003)(230922051799003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(8936002)(4326008)(8676002)(5660300002)(86362001)(70586007)(110136005)(2906002)(70206006)(316002)(6636002)(26005)(7636003)(36756003)(47076005)(54906003)(36860700001)(82740400003)(356005)(478600001)(6666004)(7696005)(83380400001)(1076003)(107886003)(336012)(426003)(41300700001)(2616005)(40480700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 17:03:23.6726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abdcf87-3387-409a-d72e-08dc21b55e81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239

The SAVE command uses the async command interface over the PF.

Upon a failure in the firmware -EREMOTEIO is returned.

In that case call mlx5_cmd_out_err() to let it print the command failure
details including the firmware syndrome.

Note:
The other commands in the driver use the sync command interface in a way
that a firmware syndrome is printed upon an error inside mlx5_core.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 55ba02c70093..bed1ba9f1bf5 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -614,8 +614,13 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 
 err:
 	/* The error flow can't run from an interrupt context */
-	if (status == -EREMOTEIO)
+	if (status == -EREMOTEIO) {
 		status = MLX5_GET(save_vhca_state_out, async_data->out, status);
+		/* Failed in FW, print cmd out failure details */
+		mlx5_cmd_out_err(migf->mvdev->mdev, MLX5_CMD_OP_SAVE_VHCA_STATE, 0,
+				 async_data->out);
+	}
+
 	async_data->status = status;
 	queue_work(migf->mvdev->cb_wq, &async_data->work);
 }
-- 
2.18.1


