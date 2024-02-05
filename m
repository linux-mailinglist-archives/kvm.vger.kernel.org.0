Return-Path: <kvm+bounces-8016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A472C849B1A
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19A3E1F26D5E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A223CF63;
	Mon,  5 Feb 2024 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uakoUYr6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2054.outbound.protection.outlook.com [40.107.101.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557DC3A1CF
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137356; cv=fail; b=NSCB10fjTNuRO2vhSEiSMPOcXsZkch0UjDQ15wayU66LeOPLBugw4wxdFdcVeDO02OHtNk10ovOoBWH7Ue20mPVvf+MDpmZXLUiF3Nw857xGK3BFx+PuPjArb0bTb0i3oBj+r53IsE9dUI5VYoxZXZux7LhNcgPJgOzcPqZclS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137356; c=relaxed/simple;
	bh=uHbudj+CLGNYYVRUkL+cHrG+mz1bcEvVpMkr1Qr2vdQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eguzYATOQpiaINlwqGqHeulM5H+BKXL4kC3gN/TkhyFdUCyeGQrpyL2w51uNe2SHv09aZBY8ZhjGQshPeDEXmlvCZBAKS449mxBqnjFBRncsk6kW+IJXF9Jq4hsq7gCfUV59slv/fQCY4hZbAwamee3g8bXwSBPqRKLPyMUTNhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uakoUYr6; arc=fail smtp.client-ip=40.107.101.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZ/73Z21k0S9+7cwgXKTQ4IyL/WTgDbXBqKck8Ez+UXWiYH30ISV1Wg+ycJFVft46KfpgK/hlFOKZsBdRGB/dD+ZzNb1oooa/gt5CvZdlB8M0W2Q5905/Ory1T0TT2xf2zpE3Vw1s2ImiwVTufNtnLSXHd0K3VYgpSxtRSu8QnP+Q6+sJUx81J5TEThpt3uRYsOoeSx0rpMJ4SnuVSjGK5TmKKsmNuaAOFctSbvFN+11h96h4039i/OYJckeMgQ4B6I5V5UlcSX1jDml+Wg2lTzNI0uMBREXIsNPjWa+QOMx4CZMfEIt8jDVvzG5rSHlELXcJDbhY8gVWZ9rhjPuQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7ddJGwq+KL68SjWmlKvzp36+D+y5O7Wo2ndtdkPdxc=;
 b=nXHFill+/ZxNQ3ELxkpqEP/+NTCms1yEHoquN4KGHUQ/+YVScED7CCvVN1sXsWsvZbjwYEnuFHefcXwjBqpOy3KQfzlJDPBeJBDS5ar6r/8I5qZ1vjlV10Qmpe80vtgjmX3JIW8Cw/Oonlp3Y2B3Xl05Ydhz7R+uVS2oz1oX0sD1eZMfmJCHop/XyJNkfeJUfxUAEd4xxtacr88RS2OFzQmCLSt2PwcQsTchl3My1qF9c+wlp7gq3Tb6sfuR2eVsN6jraEqGZJvJxmJBKKtvDtulbJ4Hi3+k/V+s2x04fw/VaITi1K/lWWRLTRDkjMdMo7JxNJyGsQcjaSAVB5JgqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7ddJGwq+KL68SjWmlKvzp36+D+y5O7Wo2ndtdkPdxc=;
 b=uakoUYr6ltGuU6ba5UnO+5DYmjcAjiu6h4OV5V4oTD9s73rxl0VYbqR2FNX07eB8Kl80DqmQSPbW+NpXpRt/XLUn9QgFj4+Ac19wg1cS/u/edb6cpbV/UHIddk0QlWUBgV8ZffifOkxEOf6NXXvmHlNrM7aIraF7Jt9ItBA/PQWoOTHOvD1OiSTA/Er15dSdTJvRgENTyyKYp0ah2uGHxNHEi70JlT68K6tAAHOj648q+xKKl8aAv0G63lscI3apYE46MakBqJYpVbip+pmM0+ePsRmb96reQDocDWav0xfE6BO+ncaegSqnlumadxf5YMykCA+KogD5Tgo0+v+hQQ==
Received: from BL1PR13CA0244.namprd13.prod.outlook.com (2603:10b6:208:2ba::9)
 by SJ2PR12MB8717.namprd12.prod.outlook.com (2603:10b6:a03:53d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Mon, 5 Feb
 2024 12:49:10 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::2e) by BL1PR13CA0244.outlook.office365.com
 (2603:10b6:208:2ba::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14 via Frontend
 Transport; Mon, 5 Feb 2024 12:49:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 12:49:10 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:56 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:55 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Mon, 5 Feb
 2024 04:48:53 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 3/5] vfio/mlx5: Handle the EREMOTEIO error upon the SAVE command
Date: Mon, 5 Feb 2024 14:48:26 +0200
Message-ID: <20240205124828.232701-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240205124828.232701-1-yishaih@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|SJ2PR12MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e4f8517-1e7e-498d-41cf-08dc2648d951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MvcQXCKo8NpNeJMs/O019sa2EH6nUpPL2muTFQDcKHW9PZgqArUH4n8ndtqxzbvZL8FMDzAZBlln8i2waT9GB7C8xKZP4xtf02gwkK+FkNTKZ0I38bCBVTPunFb17CoN2qigeWYhSci0EImd4DxEy6powGa2eaR8/JYBzKmKwMmBQzlkagIEsNgYUdvI0+Q8eUcA/iYuH7jdD4Vs+lwFxwiuERRohgmEwirKkcntUD0mSzagAxvy+Rb7eA4xfHRoRfMdgL5KngsUd03qfPsWigANqntXgUEeQRZZhoRiNC8laaDN9wS7NQUzLN3hOKRvsnp+sEYug3XKs1UzTZwNDp3YVL4QX5ATupHzjoqxR3Lu97+3LbEBGRohIY2pe3RjgDkqVCmJBKNimBkrzUJiSPjTNJii8te/QMiskeLCUGQ7ivCsG4mSS+fJykJ2ZODN6BsHVr4BGpGkIWIavQOAJtHy0VRgMCGXAkeziKScDA6qb+OWsHcfWhj4nUwSc6EZrhzSA/7dWthzNHWxevr44Goa8ozORRrDwK1cPcxA4f4Nl6AhjyuHpYHOIJUTusZd4CMXKfnZ33rHfuuYmNEfMon9RuUTATN7buaDDS737PVI1DlUclCJiFX8vX7oaW2kns8mGuKSIMqU3kMN254M0NoRZEP7MauqJIcMtmGpgMfPq2NJ2mqAv6IrrfiA3nocF9ATrwdZz28wndUkQtUtAHEV2qpc+2q0wKiK3xxv6Bc=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(396003)(376002)(230922051799003)(82310400011)(451199024)(64100799003)(186009)(1800799012)(46966006)(36840700001)(40470700004)(41300700001)(2906002)(8936002)(4326008)(8676002)(70586007)(5660300002)(70206006)(110136005)(6636002)(54906003)(316002)(36756003)(86362001)(36860700001)(356005)(82740400003)(7636003)(7696005)(336012)(478600001)(26005)(6666004)(83380400001)(426003)(47076005)(1076003)(107886003)(40480700001)(40460700003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 12:49:10.3218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4f8517-1e7e-498d-41cf-08dc2648d951
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8717

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
index 8a39ff19da28..6b45bd7d89ad 100644
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


