Return-Path: <kvm+bounces-7486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F96842A5D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 18:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01AEA1F26380
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E855E1292E0;
	Tue, 30 Jan 2024 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fjaVprrV"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.mail.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FC212837B
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634207; cv=fail; b=OKIobxjRUaaVU+u9TgIFcogMxt0KYhn0vkKlqCx/+AYn6IFAwxFn8La6UEJRlWNYzXUY2dRJsn64NH5OLqwCO4PA0jAQcs/I2C4gufqw6TQf5uvKMyGEItx6RA/eDDaPFq75rHxp7rig14J8sCd5gfPtMeEji6j3C+LzroUMA1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634207; c=relaxed/simple;
	bh=vXAQ3arLGXAcjAfseqeKXqrVqTSo+ohL501hDrJ5nxE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BmeLj1YYRHr0aSnwEMZV/efY7rnUWZaasGuZlsIEnHrgRVWhfOHEhsGHGCXwz5BopXrmS2mECEXMMVhNJvwqLr+OrjVuvEm9KUTCK2SMSUC+eg9u4PTdq9qvxzxan4B4rlEsMf5SqYcGBQg/IGyqnQyE31najLNNkgIS5+TsdlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fjaVprrV; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7TQCRBGvKi9NnBJtgCXC7N97DFVBaVcWmo0TzhiWBRL8NB3+rPDLR1QBFi941mmrItUSinvUjSZUvw7Wmk9in17eDWhmBjg/Ozq0nbO6h8vkc+y995PbRcYJof1UcoPg4TWYTeBlkTAYwqySkDFe1nDiTQ/s4DvXiHz1LpUtB4X9xKa5WPw1WIjllAR+lfDF2snM7OqaJs9aDVMAjmtGNGRXFgVz/6dN7fUAmK4rS+UmA74L4mTR2VW3n1vjf7wGr9yS90bpoyP0UVsCuILaNttHSdeT0WZcSwSe1GAsqgT+b5ba9ObEbeNomr9BeJaPDtJN6c5VdGkuXjzT4fY8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPP2RVDUq4jZZwq10z6VuvNVFz/9/DqDQa4YK2e3l4g=;
 b=R7lCXx5HooZk89H9U+5rITzEM3Hj/Tp2zb/HcYR38PAvlYDkq+OFvCMoYUxCxq6nCEOPIBAsFcGnqtVIcHbk6UiS7gk4wH7jfUD31boz8R5yuUvC1kTkux/DuLB8Lh5dRFm0X0wXKcJhEnfRWlbAeZu9qS16a4/iYdorfHjHP89rvY195nVEbK/MjoWEwXZElIaioFp8Uviw26zUQ/Djb8yN2hjXdbBQ7GHwXp8tjv0D8/8MRCxHeH5MKCpV9wXJVih9otpxhkJRa3fo9QM4fVkeqfiVM/O3fsRdOOQWiaWRGXGjAkrlt6X30GfwrQyY9JcSqjzwbXwRFOcu382a4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPP2RVDUq4jZZwq10z6VuvNVFz/9/DqDQa4YK2e3l4g=;
 b=fjaVprrV8evefQzcF2I37AY9GUSi9e9EsrHspcKWgjS4Iku0it2fm9VVL04crLkzF68i0AGm9Ob7SBas6C/DMZsuy00UCAKBQtEjnlcQB5aGkqZ4Q4qwvXHUMsFb7Es1f/cR5r9RDymR5q44w8RxMJsAZelF/nLnRyg/YrJy3qZXl/SFQ9XurMGv8zMclYpJRDr5jM7pwIKbT8qD1QCjBgwhzBBypFN22Zv8jUsCBluDG10ZxttaHm0PpNiI206SfIisrnC6h7iGXQslq4sXkDY5URyIPyN+mKpXgggBZD1tWOTXnOUtlQCA3DuSeaD160yfkbgQuku7fkyRllATMQ==
Received: from MW4PR04CA0302.namprd04.prod.outlook.com (2603:10b6:303:82::7)
 by MW4PR12MB7120.namprd12.prod.outlook.com (2603:10b6:303:222::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Tue, 30 Jan
 2024 17:03:20 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:303:82:cafe::ca) by MW4PR04CA0302.outlook.office365.com
 (2603:10b6:303:82::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22 via Frontend
 Transport; Tue, 30 Jan 2024 17:03:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 30 Jan 2024 17:03:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 30 Jan
 2024 09:03:04 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 30 Jan 2024 09:03:04 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 30 Jan 2024 09:03:02 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 0/5] Improve mlx5 driver to better handle some error cases
Date: Tue, 30 Jan 2024 19:02:22 +0200
Message-ID: <20240130170227.153464-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|MW4PR12MB7120:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fb1c2df-a9cd-4472-9f3a-08dc21b55c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6GPFbBzVb/YHLgg9nSq864Yt57xUeSp4i2hN4vBxIrqkscx6ZxJRbdXfoif7B447sDym4TrOcqYlfPIT2yY1cqOsf6sy1QKENcfvFdMS+JwOTjav7JiZdsCha91lzh4c5FnbjkNELEQLh62QuNB+IBNKgg4ofb2KvCLgo/rQDaVzdyQVf/Ex/8+yJ/D5dkiiV+zJTVyvIz8bSdjuR5nqwoxqYuu5cV1EATIWTIq8aC8cbNT+Z0OyhQB0kszofAim52EPhzkvWTFgEGGf2+/QMMidn+YXpTDKq2cHrl2Wa3hhSPrGejR5Xx9pIBsxCPnjxecWezeRmaPyyZcG9vNtGCfbGlExQBG9htaCB31iJuq7TvWYw4wZkN8QLgb9T4A7khQWvOoH+1C6DSxTGSdISU8ChEq4J26lGmrjhni7gMYywT7P2lctagvIVU0FPO3i/C9Z2syaLixf7SvrYqfirKb6cRpm7DRca1rjHcezoKIYieqRQYSUT0DLtuJR6ktuThABT+vuK9QSGXCIRje4/6lAjK7PDVr4BPXRpIPEma0ANgRlETPwIVgYgGDW3s5ocd0WDrNM5sh2nt9EhhbBCVGvzGYUWC15Sw6k6YGn3p8/XO2kS1p7kK80b2vg87YZ9loixhwzlH7EwHZj84paEOm9rc3IID3gm2GY5NIzan4A+M43bpMMdkhmR8YTO1DsBKQBiqd56TjHMvYS4H3TTg4fWEULSLnyGLsUHDvgYFCc7C9hFEzWDmI58BuY1dsx
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(82310400011)(40470700004)(46966006)(36840700001)(41300700001)(478600001)(6666004)(86362001)(2616005)(54906003)(7696005)(5660300002)(107886003)(2906002)(4326008)(8936002)(110136005)(8676002)(6636002)(70586007)(316002)(70206006)(36860700001)(1076003)(83380400001)(47076005)(426003)(7636003)(356005)(26005)(336012)(36756003)(40480700001)(82740400003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 17:03:19.8932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb1c2df-a9cd-4472-9f3a-08dc21b55c37
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7120

This series improves the mlx5 driver to better handle some error cases
as of below.

The first two patches let the driver recognize whether the firmware
moved the tracker object to an error state. In that case, the driver
will skip/block any usage of that object.

The next two patches (#3, #4), improve the driver to better include the
proper firmware syndrome in dmesg upon a failure in some firmware
commands.

The last patch follows the device specification to let the firmware know
upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
migration cancellation, etc.).

This will let the firmware clean its internal resources that were turned
on upon PRE_COPY.

Note:
As the first patch should go to net/mlx5, we may need to send it as a
pull request format to vfio before acceptance of the series, to avoid
conflicts.

Yishai

Yishai Hadas (5):
  net/mlx5: Add the IFC related bits for query tracker
  vfio/mlx5: Add support for tracker object events
  vfio/mlx5: Handle the EREMOTEIO error upon the SAVE command
  vfio/mlx5: Block incremental query upon migf state error
  vfio/mlx5: Let firmware knows upon leaving PRE_COPY back to RUNNING

 drivers/vfio/pci/mlx5/cmd.c   | 74 ++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/mlx5/cmd.h   |  5 ++-
 drivers/vfio/pci/mlx5/main.c  | 39 ++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h |  5 +++
 4 files changed, 110 insertions(+), 13 deletions(-)

-- 
2.18.1


