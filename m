Return-Path: <kvm+bounces-28294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA6299736D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6253C286C6F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4B41E1C04;
	Wed,  9 Oct 2024 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YZ9d7Cvy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4120B1E1029;
	Wed,  9 Oct 2024 17:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728495741; cv=fail; b=rjx5z6KmOuAkJ4wVP3KuM5Ykkev6qkTvuzkFCkoKp3zGnYcpVMvTZBAh2s4SMJsHTdkqfRdkeKA3f39ShVDn3dRegyJLWQAdRvoJGkPPpI9gdn6V0QLZbOTku0sJdr4zfCrO94TqV6NfFpo4C1q3Uia5eUvb0XFjJpfAsOa48HY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728495741; c=relaxed/simple;
	bh=vL5DxngJ9PLNlLfWbroI0u8rGPsY7ZAQnqTT37UKKFc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seXjvRxq3qz+7IxL5Xpr/WXO2BMUWPz44XjsoVP6Qh36ga3nVJSTlG0vjEJHVr8L8Z2txcyybO7rkMl1XhVtTRAiaM47uyHfs2+rdUvC+WDUsazm3QNH/uasgHenZx0foCn4RdWPS4ZwYECuj7mW5yZxC91dFmCm9+gZBXlz2y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YZ9d7Cvy; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxM9+wU7qjKpRd1BLVhNddFTJr30Ka8BtGToQhmRLDkyd/FXuO5MKktuLTtwejHiXZ88eyGR58nQEtnDzzWH3Rr1iScY1XUHaeaFnWUOeIqmadZRljOK+1Ywfi0usmWQCPp4KBYX6GT/eZxx9Fh/rFokttXEtFcWP3hCrG0woYo8KXW8ve12cvHZty8CqsfZUnB8DWSONaA/9xeam7cynk7sjWGdM2lC+G7YyACC9jy44Q2btREaOPkhU6Rf1z+TNlqYMXlINt0syAM01+Kmhhilkvj5LzGIUTVypK4XBr+tFXNplZSvSWgfFKewuaLZ8RDsKjJ2nBqIm5HPZ8lWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9ZKIuOK4iZhsHIBaXMeJFajxEL4x0ph137LVivp9Io=;
 b=saNRrAeGnVFcCtWDDmoOVJ3KPf38bflJIerCJkz2gFW6sXyaPq3/4APwOhx4cgfH9Bgv0SjaLEgpeMjRyAREy9+VF2pL8rGzjICvfqtjRfSJeHIk22/tdvtbnW8Mt74XHXkt8XvdVMjhHEH52UOiv3gqvUlNfNxRXNGcUt34oJzLNa4ClheL3Zgq7tpicWkL8h6IwM+IsshWcr/UxAIH1LKyXHYOOoodkL2EH4PshzXdIgWJ646S6i9HTK21OxWsR/VAbkruVoGR3DKi2l4pwJT/A6e97hmqxlV4e52GY06EanhUyakhR3WGi857JVzM7vWhMIE1QKu12tcpr77JyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9ZKIuOK4iZhsHIBaXMeJFajxEL4x0ph137LVivp9Io=;
 b=YZ9d7CvyMqqn2QycS5rQPfWn18+G1J7e6qGBso+ux2LzxwKlKKWv+hU06NDkXZ+Iq6rxIO+oaBaseUdQNAP6qHUgJR9PbrOI9TaXIG/151kyMBT9aRBi3RN3V6itMQ6fAEsxlefy9VPkw7CkteW+gbeWtrQOd2mw+s/3Y0EzbZU7cySuAX2CxM8CL4T5P9ZE6Gwp93frmaarI7J6Sk8t/0tZqhSyX3Xx3b2HjnTv60WUI+cFZ2EmRCaSHdlsciyaAgV49S70SYZSEwdLnZH4qV7fQA9zmYyQF0aERRBQKTzOWgV04hFav8Af1ubAv6UiyHmxLQG2BJwKuK2Qf43xiA==
Received: from MW3PR05CA0017.namprd05.prod.outlook.com (2603:10b6:303:2b::22)
 by SJ2PR12MB7895.namprd12.prod.outlook.com (2603:10b6:a03:4c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.24; Wed, 9 Oct
 2024 17:42:14 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:303:2b:cafe::a0) by MW3PR05CA0017.outlook.office365.com
 (2603:10b6:303:2b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 17:42:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 17:42:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 10:42:07 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 9 Oct 2024 10:42:07 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 10:42:06 -0700
Date: Wed, 9 Oct 2024 10:42:04 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: Re: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Message-ID: <ZwbAbK0HkYHs1cza@Asurada-Nvidia>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|SJ2PR12MB7895:EE_
X-MS-Office365-Filtering-Correlation-Id: e067db65-c355-4efe-e41e-08dce889b632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CLRKC4y09NmhaZkzXriHO3vMFlYMpjovpUm7k6y1hPLLPLVEDHVFPCgmcz3T?=
 =?us-ascii?Q?wRLKI2oiChycUWmDUdAXGYI3Oz+Ql67lCATAROcF0lVqoeiLk0w5PwFpFXff?=
 =?us-ascii?Q?GW4EMt85h6T3CfsiSNL5COFr7ACdg2/XvC2pKvLnfSDtHKe6/uLKQdBG1CeR?=
 =?us-ascii?Q?pS7VYvwTGof5/EdtKLgI1Fhf/O/UFy6eq5RMOVE0NBwE2ec9wpOwZiXbHUJH?=
 =?us-ascii?Q?Dpa32Urxm3+5Lmp0m4G9clY8SG97rpnK+MYyDdi2IHuDJhH+8CFjGf8YL2G4?=
 =?us-ascii?Q?EVrnZfXu0/rJ48Q2av2+j+76hCVvhbWLv00jldPU/YXCqibZECoufx57PtxI?=
 =?us-ascii?Q?MkEvEPdtiXL1ryUSXUJERMNRhsHCkRHd519Zx8N3rE2HyFF1B7ue6V7a5o+6?=
 =?us-ascii?Q?glA3ufFeSa7lToCSxO3cuQY7/wOJ1HwDAQ1ckbsGWHwYJM4KgLeiPbsICyWh?=
 =?us-ascii?Q?ETORpX2ROvTIvXhh0VAr3WURSLEFqG/Dghnw+vrwRlzGbwXI5Gjj40fCIEba?=
 =?us-ascii?Q?qtzBlqiDxUTCJhygcgBk01/ghPW+7bxegXd95y7ioY2qH9D3AkqdMczV0C6i?=
 =?us-ascii?Q?z/z5K7IeyJv92wsto3jAp79//WM/CqdpUQzdLm+DGKMOFxKkkGaMJbGXGuqq?=
 =?us-ascii?Q?5RX8fbdNHBQsiUHFHrAqlRy3pUrbBF/7w6MOynJnUJpHUF2WN5HWvhMQlLQa?=
 =?us-ascii?Q?n+MYrLcWYbU/TEhXJTb9Ou5/+LNHcwqNWlLbtW9bvHcp9tuHZ/vXy7MaLVNL?=
 =?us-ascii?Q?Vf+9zeFMoREIND75pibjM/ckR3hHIyt23UomnAPCFohBf5gttPkLcqs/TA6G?=
 =?us-ascii?Q?9F0sGicCI9FKucLxSek0ts+rX/6XXf40GjDe2C5PeDF4ZZo9NlCsmL7t1plQ?=
 =?us-ascii?Q?FH5Qug61SSlMdc9WIpvyhI7pHsXGSqd2DgTTiY3b2tuHQiVqeJ11Ddr8ES5r?=
 =?us-ascii?Q?VbBYl5HGKM9ZH6MrOsacjmfPB2QEaa+uq40zfXeAIDIFQuOdBQ5ux8h9/tPR?=
 =?us-ascii?Q?QW/aIzkD6xJgGG1uFtMiTL/jVy0xevXl/39UUydLn8fK75M+15aKrDA7cXx9?=
 =?us-ascii?Q?NYFD7p4cSQrRRJxJapW2Xx+QxQCfe81gxIsekKSvWWnhkh96nBB6rdFo2tJK?=
 =?us-ascii?Q?svqc9uJwr9NMMZLpFLIX05ykFQf42xfohFxGQJpIs6OJbFHchPCBaRLYe3Be?=
 =?us-ascii?Q?+D87n9IcvKb2MtT1I4/RBOrMSpxPi96KakhjbBnT9h0p4OVuH9hXglm2lCfP?=
 =?us-ascii?Q?6xHF30FLtG3bD9cIewngybxqzAK4ka0yobYArUqCND+kJ26H+cgYjy+zvogk?=
 =?us-ascii?Q?sJiiAiUMAj1kJDl16GWj26XGRhJxeK1dYEEXbEdB23O5aEZ9T4tn6YgXhBMt?=
 =?us-ascii?Q?pBps0JA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 17:42:14.4407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e067db65-c355-4efe-e41e-08dce889b632
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7895

On Wed, Oct 09, 2024 at 01:23:15PM -0300, Jason Gunthorpe wrote:
> Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> works. When S2FWB is supported and enabled the IOPTE will force cachable
> access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
> access otherwise.
> 
> When using a single stage of translation, a simple S2 domain, it doesn't
> change things for PCI devices as it is just a different encoding for the
> existing mapping of the IOMMU protection flags to cachability attributes.
> For non-PCI it also changes the combining rules when incoming transactions
> have inconsistent attributes.
> 
> However, when used with a nested S1, FWB has the effect of preventing the
> guest from choosing a MemAttr in it's S1 that would cause ordinary DMA to
> bypass the cache. Consistent with KVM we wish to deny the guest the
> ability to become incoherent with cached memory the hypervisor believes is
> cachable so we don't have to flush it.
> 
> Allow NESTED domains to be created if the SMMU has S2FWB support and use
> S2FWB for NESTING_PARENTS. This is an additional option to CANWBS.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

My HW doesn't support this S2FWB for testing, but the patch LGTM.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> @@ -265,6 +266,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
>  #define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
>  
>  #define STRTAB_STE_1_S1STALLD		(1UL << 27)
> +#define STRTAB_STE_1_S2FWB		(1UL << 25)

Nit: seems that it should be in ascending order.

Thanks
Nicolin

