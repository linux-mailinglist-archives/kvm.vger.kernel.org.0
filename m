Return-Path: <kvm+bounces-29333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D83869A9829
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 07:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9476D284CC6
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 05:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5632412C522;
	Tue, 22 Oct 2024 05:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j6TFqEUK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01455770F1
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 05:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729573995; cv=fail; b=QERIMAHYl7lXwz4OCJkOEqbhlse/gEZMOK30NcrL3aTNIbqJ/o758H9OfRzXakR8WdX9DXIqJVWsKFGK6l6yf89fzZPHk5zhA5kPP/wrpaMqEK6D47QAh6m/YT79gc3z1YmLYOMNLjq2g+p8k1ZIKOONmS4H93e/OaOi8EYUPlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729573995; c=relaxed/simple;
	bh=Y5cIRS4m4dkG86ja7D4nF1ef5Lz1VKwsxhud2PBSROs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NjvA3KYUV9E6M8T7cEuZd3vgW9oDQvAObrreQc0pM+HlHxxMupeZ62TH0mo2j84UkP6gQUZD4EIBmlRY6CNSGWLGoLmCidbS8h5QAcRtPGu6Z1O8Az7Hb+PFCVpH1rhzIIygYcgFO3d0ilXk8Y7Zc6BDKY5tPo0Y1UsQlr2TeG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j6TFqEUK; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRopyJi/H6S/72lSDjWtTG0dn5TL6Kl6a6W9ZmP0HNh1nMzz6GzdVhDW8tM8h4FCSp9aTEchbnnCBoB34Mv521/ydujnR5LsEqJY/SCoFUOR9zgqxuCRJfR5co8hBeitI/AnuT6ynl07LRRb4M871mgkhHtLZ+qMhm0T+JesosQn0MIQrmaWO1PLgikhsh1uBceIsjdCHj7wYpHOUcJDhMmFyVQW1TkrAbN2WRoAh89aob/4hJVPTUQap0SZ1WHsyz7EwEHVh5197CG5K4jb9AKSfPhQuu2LTyjL8vge3I7DeG7JbKaweW3mRYIZAHOwX2NGQxFSDKRAF6rvVSD4vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8CngwPH0BMW7hVzDtfgIuyLCnUYlho9HYPi8znAqQc=;
 b=vhfqq57I1qLC45AJtGJKKelVDYfYTVrvneGq3mY0jqVDV9i8WfLqVLoKZpoqxXwHNpLJ/qU1uPoSIAWBqGyml3lYvGDcFAw1bLAmlwn7zo3+8HxnlmsLiEfnkxqF3KEvofrHR3pH4zKaHvDqxZD8b7NFFBcYBGPvUxeXTgdj4gp0XMfIXnZ1tFJ/qLii4zWpWV2VHxmyTLIghugowkPxF1JMlMUfk7o5aoQkHc97s3g8E0+VCqTdSx6VCHQqTEkITrr0kHpTSBzxpeZjY1OaCb55sM75G50MFDj7rhZa2TP+oa318qWuVwZYuTH7B+HEwxyZf6yZbmKE9kJaxZMQIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8CngwPH0BMW7hVzDtfgIuyLCnUYlho9HYPi8znAqQc=;
 b=j6TFqEUK0311QabImR7RC3Elk9m1udaN0tvMEo96ZJD1Oys8RiuSWUSwNvyYSGjpNqJm/ZmCOEBJIjMEls16XQrbnirE3qAZMLzbm3zL0eUQUh6tkFiyAzDQY2g3iPBJbCLYc62iUbMNzTysykidX0rKA+So6pGIZ+j0n110bo2llmI6sqOspFGjZpUm7diEdKR7y6NH+nvqotrzMTFqA0oizR/kP7hFBXrG4/K6pWkcj3ZZ98bvRiBMDxkhHwyS4+IU8vmaiAgs6XlXhIbA2oVlD8jPgT6yrPjs0j7Qyzi7bmUsrVAz4OV3vihJQs6mTq7hD0oGe0NWJHze/RrXIQ==
Received: from MN2PR06CA0008.namprd06.prod.outlook.com (2603:10b6:208:23d::13)
 by CYXPR12MB9426.namprd12.prod.outlook.com (2603:10b6:930:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 05:13:10 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::63) by MN2PR06CA0008.outlook.office365.com
 (2603:10b6:208:23d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29 via Frontend
 Transport; Tue, 22 Oct 2024 05:13:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 22 Oct 2024 05:13:09 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 22:12:56 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 22:12:56 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 21 Oct 2024 22:12:55 -0700
Date: Mon, 21 Oct 2024 22:12:54 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <joro@8bytes.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 1/9] iommu: Pass old domain to set_dev_pasid op
Message-ID: <Zxc0VkaT5ADTgIzm@nvidia.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-2-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241018055402.23277-2-yi.l.liu@intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|CYXPR12MB9426:EE_
X-MS-Office365-Filtering-Correlation-Id: c263124d-e4dc-489f-3323-08dcf2583899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MbwIwi+GB3KMSACUa09V/4NpVaHioxDAs0TFFyQr7zT5EDy4QTzhKqwL+FsS?=
 =?us-ascii?Q?3l8v2MYU+5Yol3Xm/g4ifl/zsv/KBskIJJdz4ffWCdeQvgq7eDs/Xo9VN0Lg?=
 =?us-ascii?Q?G1GIQ8m9nBiWYQCM/AAa1pJU3zn32LtBXJirOF2VYw3FhuHyJeBHVuMFpixz?=
 =?us-ascii?Q?/KwwHdcF4y8wQv123pBMaIz25iOV7NKVi9rm+IA8f6MGhlfcnDo4HQ5WywVx?=
 =?us-ascii?Q?Ao9Aw3Lkm8LoeOEzmswENVR8L2Z2TJbcWxZXfWndAsAqUszZpsggCRfQIu+J?=
 =?us-ascii?Q?a6+9A+eyEtdLAuT/tsnRR+61cTrY91ZXZh25GUWJdCM0P6aw1DfWsMSWZr39?=
 =?us-ascii?Q?zD7UF2E2bGCKhoOte3to4o9KrA+h05iAPpRxwW8aQsVUS+DRqskur7mp9XsX?=
 =?us-ascii?Q?6vEyR9S0z3uzqU6xvv21iAOuKc+8VVMM4UcRRTrska8cmx086xWFZC2jFTg3?=
 =?us-ascii?Q?bSX687KCcV80mJxm5uHfgEhNXxR/3Eu674eHTr9KgQAZfCzzzsvbHdsUyNTt?=
 =?us-ascii?Q?hLN4cC/y6NImRucXqXWvS7RnHMvzCrFZB9U7qa/EiTR+7/wG672HL7DPOpDe?=
 =?us-ascii?Q?T9aBQnAdgMKtEbcQWtMEvEIi14oCi1xc55KhraZfSde3n2cWrXZR/74ry/zt?=
 =?us-ascii?Q?DtzbTiw3BIaHyhu0/YH6M7B4QFucXsuJ0x64gOQUlb6EdmpZWoQ/HkY+B/fQ?=
 =?us-ascii?Q?U0MT2EJCJc9DWNbI1nejjo6w9bBo36dh7bR1dukWtNP9x6TJheRnJ70vM5Rk?=
 =?us-ascii?Q?xntQdezGw0Qach2w4WQrMBMGufsa4WVMw1XL2ldcQ9sJogg7nS3f6C7GRhBJ?=
 =?us-ascii?Q?fR318WintLLg8Un5FLz8NI4afUAsiZ4aWp14krhaNLjuyaqCrRptj3if4i1M?=
 =?us-ascii?Q?HymbGqpgkjI3hATHBCMQhi7ZMJYF1Cx5xC5ux+pflHSytkmPOqVMjWp//ChC?=
 =?us-ascii?Q?8vj081lDvmP8bLG/OOszG06sLbE7RKg7GXtp+yjsTtjNq6P1W13nS8dMPvYV?=
 =?us-ascii?Q?8B5jZapeOby7rhpzBsgK2QRHmDbDdgdJDFMT7APl27S72Fkl6zaRN7R+KhHA?=
 =?us-ascii?Q?GGe9MdmGRANfSqe6ZVKo37ggDzhmR8q4bF2+D6WB/Kw1DLQr8geKGR3oMsJO?=
 =?us-ascii?Q?eD5sGY0E4A89dGFmeVTVwGp4Cut2vsUNILTENBoYc+NNv+ijaIOzeHyxb0w0?=
 =?us-ascii?Q?cjA5GKBGtPpOFAwQI1L3ptuB0ommzHenGr7mYefX0gCi1xvnv4aBPpuVcfbZ?=
 =?us-ascii?Q?msCrZJwIbNBj/n+go53okeTmqtlHqqQg1tZ5fOROLVBAr896ijCrYXAmwMcT?=
 =?us-ascii?Q?ULrUHCI+fuYzXjPI4v02OjxNYz1JusQvzQNk5behrnmqi8D6FXah0DtiKilY?=
 =?us-ascii?Q?ekxc17qotKgknho3odjmcmkbC0spynAALXfLOOBDhsKOrq93bw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 05:13:09.8344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c263124d-e4dc-489f-3323-08dcf2583899
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9426

On Thu, Oct 17, 2024 at 10:53:54PM -0700, Yi Liu wrote:
> To support domain replacement for pasid, the underlying iommu driver needs
> to know the old domain hence be able to clean up the existing attachment.
> It would be much convenient for iommu layer to pass down the old domain.
> Otherwise, iommu drivers would need to track domain for pasids by themselves,
> this would duplicate code among the iommu drivers. Or iommu drivers would
> rely group->pasid_array to get domain, which may not always the correct
> one.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

