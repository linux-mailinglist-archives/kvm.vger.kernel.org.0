Return-Path: <kvm+bounces-31846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D908B9C8681
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 10:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 694A51F21579
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDF61F76C9;
	Thu, 14 Nov 2024 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oBLLKA5p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E321F6669
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 09:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731578045; cv=fail; b=VtTOO8wk6FcHpzgZKFTojEmcUlKHUkg2RIWRykJsNdlshU+arphqMgEi/omDJUxGMSRg5JNP4gdDBsyH45DyDoiLNbPuUKRPUOv3hlHApFWv2aQTO4eNBu5dxNa2o7FxRXAmsrLjZNb6piPFn71Cqin477HnzcBxJ312Xapofz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731578045; c=relaxed/simple;
	bh=kGTWq8EGcfQl+T0FdC2wyXKf8iNpX+XODGuqAHL+XgU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IQOgxlB7yWvUJtzVS0tL2h0wqwZX/o71D1+xwdPrXPABattn3WLQOTxeFHK4FMpm3l/NUQ1FFTnx/t3P3WSvsWFzvFD62zEQDatJYonKHuJzATxuVEbOmwl9V/tV/lIYT4IXIOnUcAhrSj8n5MUqVN0y9pkMYjiJD0wVInTqayQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oBLLKA5p; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DlbLrMND4OTp/1h4dS3tHPbYovJYXpXmpfRPlyXBIh/3syaXhYBOkwtZroNF/CK63CEHOJNV3XCU1ZI+4e8rHH8JCRhHQNXZG6oDGNSbJjrSz+FRbnNwONyQ6OPClL+ZQ+WvaLpFa8lEEdvXfgE+L3Jfom/ZmZvVoOQvJNCrujVIwGBktC/CSAXDcBMnbgsiTvzvilac30x1zpRuhY2DMAvanATCwgC3P9PxJsl7OmqY3N2Kd24MSniEbQ++GlMA4ukGZHUsVR6/+gqZ5U8GZn2ge+fUBn6FYneC9I5NGofRdzz9pBMH83jPQ7SgBlr+8KaiIw3LlGZYIITC/NY7DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5RvZBiS6rzTuNja893wvsiQFgYosuf0O1bsp+C4Q/E=;
 b=p1XG8RLaQQGe9hvQgJ14tYNM8ffhvncHUcAv41364qP8V58kUU08UXAA4ndnC7d+joeAonQcRQlsbvioc9BprJthXuSDKcmHoarmmXKp7R0q/LsA0NTNKQnaPaoyL18sw6cFpN0aA0gzAkNYQaxpCnO4nS0PJJJX2dG+va6QsfyVpDdkVw1BYVCbYq2zRTHU+S5Y72xR8UWwT3IH/oeoC/lfM2fiaiHwcFuC+xOb3N8vLy6m5yxot2GuVd51Km4KU+ZR9hIzPd5EGQ2Cbp0pmRWJw1CbRkmyIU0U9wSqe1IG3v5jKwuyf7/YV8+D8c97NUwHZ2QMXdeT0ESy05xiBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5RvZBiS6rzTuNja893wvsiQFgYosuf0O1bsp+C4Q/E=;
 b=oBLLKA5paZochSbN1i5oviSd7e0RfD6b/kKKUyCn4yetA5zTUQyhI9wFvjGBzqJQyOUF2vCaS7Wz2h9jmWfI5JE5qYPOakvhaEyLT6tu9joHU48h5E55q3e/abvCMozJOQB8yEhS0mGfCFgum4xdJttN/MK3FmqRbUM6iaiUoa7SVInkMkSl9TlEbG/N+wM60M1shLo3OPucDOHfQ+arq+LajsJhLOuL0b5ct+w2m75Yx0LPSlEc7W+FFxxwtbtkoTKybQwv24+738TI52C1qEYsXEtwKBcWTUZWYT1zZY14wPSNIUl9QNRx54wS1JHhYbgYtlrTz8RF1HoW20KgWg==
Received: from SJ0PR13CA0220.namprd13.prod.outlook.com (2603:10b6:a03:2c1::15)
 by PH7PR12MB9253.namprd12.prod.outlook.com (2603:10b6:510:30d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 09:53:58 +0000
Received: from SJ5PEPF000001EC.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::8f) by SJ0PR13CA0220.outlook.office365.com
 (2603:10b6:a03:2c1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Thu, 14 Nov 2024 09:53:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001EC.mail.protection.outlook.com (10.167.242.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Thu, 14 Nov 2024 09:53:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 14 Nov
 2024 01:53:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 14 Nov 2024 01:53:48 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 14 Nov 2024 01:53:46 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 0/2] Fix several unwind issues in the mlx5/vfio driver 
Date: Thu, 14 Nov 2024 11:53:16 +0200
Message-ID: <20241114095318.16556-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EC:EE_|PH7PR12MB9253:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4d8bde-6e18-48f1-abda-08dd04924234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F4L/+aaGh9gLdtCKEIjeJi2qKy+w15AM4vmEjKGJ/00eUYi1LbBStptdj46p?=
 =?us-ascii?Q?6AF0+nnNn74iqOqPaTADZasWUtnLBhpKmR+T8K4RGkbNgG76Jy8Q1KzyYUo6?=
 =?us-ascii?Q?3hv36COEfHppmoia7xCK3KYrQoKoeWUHbPNtsC0c7uV+IKMQIyikvlyhaEg0?=
 =?us-ascii?Q?qM3wZBQiFE4ZB2SuDivxk0AjQfli4ytmqPb6+D8Qg2BlKvKi47w7Nrmyie7y?=
 =?us-ascii?Q?AvgTlgSyltWvbdmDg8SL1e0KnIRXhyQXHcLN1OloZnLdX+jYvsdpyudNCNb8?=
 =?us-ascii?Q?Ds6q9VHOs3lJmjC/wRdwGnviKJj+qKjXwmfW2tkDsxKEMmKY0B13o/3yYZGK?=
 =?us-ascii?Q?SZdHOj1p9qO1N59xCKw+CCAo/Gb7gZYm5SeoJ598/shFRmEGpXBQmOWd3vI1?=
 =?us-ascii?Q?A1Fh9LTWQaxVAJxobEE+peEGBay+pVxPpVxGGaJEJJ1XUPfNQ9/6oNerm6so?=
 =?us-ascii?Q?ZX2QNt2rHXXxh+21DP6wv75Mhpt2cGWjgL7XTvx02bfvETAzz6zeKjMLzOy9?=
 =?us-ascii?Q?rnNFwa8hzk/TAIePJwVQcKwkSOV9WpVecY7aWTy5Zdlf1VaxoWxNOh7uvMuo?=
 =?us-ascii?Q?6B2W1FPj1MAlvC4zWm2IGJnOCkNbl7FYPOZyV608LDXEeDFuqoRKVt+/zXQr?=
 =?us-ascii?Q?jjM/cPiJMyQkqNw9KZydhaShPqlTmR3mBfm9QWBOVGop3giW0p8gsu3kFHnm?=
 =?us-ascii?Q?InqsHuAp6Q0yVRTpCqPlZl2RqqiJvSX8jNjeF8M4gZmEu30TkiEsFCxRfsvy?=
 =?us-ascii?Q?CIsalRQ2hffka/EVHsMU2WOfmyIP8in0QXIKtoFMv3nInTn0w8hTPN85OWee?=
 =?us-ascii?Q?GuaL9e862rVI2KdMIURc95DOXbVIo5zH+njgvgmV9teOvX4ownOoR+UFptOS?=
 =?us-ascii?Q?SR8R9cnN7Z7V0lEKO7SKkpRIchnk/N3R8Z2CIwMPKVSSKfUCgRXInLQ90TYw?=
 =?us-ascii?Q?AqQRnn3PCTlh9Dfd5EyWh0qPPYvqFQa7ZNvL/dCJ7cZQuRjLyXIV/Hz6XTUG?=
 =?us-ascii?Q?uOvcpW6L+//FhjazfaFPQvFysixqmOzxJBS+US2dxg1+GPK+RMXCXT3C7hbX?=
 =?us-ascii?Q?PPqYzMMlRChEDi/dn1A0MtdpI9Bk/4+1xvg5wJSqCXNPsAYPaZtYwiDx4Bar?=
 =?us-ascii?Q?gc6PZfp5hk2fg9+Ko3rBRYhpEnZw8PnKPd0IUGKPXdurvxbZ/mniGtgOMG+Q?=
 =?us-ascii?Q?mo36iiNJzCvTliHFuOS2f7LLhx4+pGpKO7dJeEDlCkMQeia3Q6XeVmEgnl6v?=
 =?us-ascii?Q?XL5rFcoKPjyYLXL5SxpVplFeDnab2zQj7WIOdrjF3KK3Gbih7yJCVUu+b8hu?=
 =?us-ascii?Q?HdRkH7r+OsoldinDEXQIsb6fJ+Qk11KHtAzQjKKisOaDIlGdXF1W20nhgqrB?=
 =?us-ascii?Q?atMbUXk923XzU5XG/6yt1IHjPyliYyBySNydJkGWaU6aw4kOmQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 09:53:57.8494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4d8bde-6e18-48f1-abda-08dd04924234
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9253

This series fixes several unwind issues in the mlx5/vfio driver.

Further details are provided in the commit logs.

Yishai

Yishai Hadas (2):
  vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()
  vfio/mlx5: Fix unwind flows in mlx5vf_pci_save/resume_device_data()

 drivers/vfio/pci/mlx5/cmd.c  |  6 +++++-
 drivers/vfio/pci/mlx5/main.c | 35 +++++++++++++++++------------------
 2 files changed, 22 insertions(+), 19 deletions(-)

-- 
2.18.1


