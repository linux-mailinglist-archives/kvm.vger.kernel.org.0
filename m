Return-Path: <kvm+bounces-29343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E82E9A9934
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 08:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E3FBB2232B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF60813AA5F;
	Tue, 22 Oct 2024 06:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BDwc1R4c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8D83232
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 06:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729577230; cv=fail; b=b+4brUSm5DsoJSQ64uywLbbGOTgEzoKcx0GkTUYZcA+VouI6rvWHUuiw4y1nG34UgaHR3WvZhf8KbF90us1LWsE40KFPO8jTQDnc4yKqOkDROvEDkkWEj1MJHrWlMW4rc8o9GM6t578EGWvatEAZiK6Ws+6hdbZOLMfME26tkzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729577230; c=relaxed/simple;
	bh=6I+3zzwcgXYSPE15CRjvmQbZTHhC6AgfNmjM13v6tv4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYbWtiqbIY/iwgKkqzybMVvw3nj0L/Qhs3fl7s6v7ob/6ZmONDZQQZqXCOew/jwiA6CoIoGJuzxuCN+2fgl6nwjw/dFEkHfEP23rwiLFp0Q2KZkUBmg6SmxxB4fm0F6pz2s0WQnSwjqJTg33m5KOT0b6MR7DfRjfDymdhwlsuQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BDwc1R4c; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F51zJ7nkWMgqryaHfchjxp9NHk/ZudCstyc4svbO9GLMtIs7I0O4eG06zbrMK92AHTHoyDH5+XirsY3uCcAnJNPkMuXyfSTmpG/mBCH/JkTHFvwusB8CzKhciPlIQu8sevd1KPi+HKr/X2yFTtlRb8FBL3jWPx+mUIF1Q/wWBNkL5LufFipxHIEcEowOBtP9RtUMrrUJr+wO/kpGiMKoOEEfKO00g5W+H0vaNzOkIRQUysw9KEVjS1PUe4W9/o7y3+ezbdxcAijjvllY8vebK3yeLdSbE7j8Cl4pmtbv644cCFICdAiFj7j9mJenizEdhJFzyvUapw/QVscODuKA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h38qc7Ra1SODGfQCKKUHnBcIsoBn5ITeB6oI6QqrKAM=;
 b=DpWu7is/Ynj74hWrCSS5hvdlCkJVnBaB1s+NyqubadVl7y4TC6+sDcXQMpYT80AAHo83beoYU8HkSbS8YEeW7CP4+H71Fu/Ny0wHbywwDIpcRknkYnJDpWp+HXrID4fek0IllhnM3P2RtvPKCL3N0VozUPGwVMZ1kbkWR0FrPkT04rwzwoSc47kSDvbJQs8BqtWcPA/2yiPSLDcsU2r5X5eAPvWOcRgZ5xpRq7OCoqp5u5677EBs+UMfSMVQYEx3Lxi+0pY6w5lXFjFoFFxJW/jQhb9cg2ZgRudwDq27CCuhlFW1lgP7YIGXGwTZXbFyM6dhwgr1E0Usm9kFIYLuWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h38qc7Ra1SODGfQCKKUHnBcIsoBn5ITeB6oI6QqrKAM=;
 b=BDwc1R4c4v2b0aExOp+8SUGwP5JjubDhQxiAIVxRgcBmX47WEWBzqLVMTyARZt5zhOcvsFMr8lXJz/YxNWfIpVkk40G/gfVnhJZtn7eIzjI+KG0dlfCOH0qTayDSP7T9fMS/XPPr53kAroTwof49jTBLSLJX1fZMmTyOQ+dswqgyZ/ykvxU8Pa72Z7iQkLgo9GeboYLbRh89DIujTQi1+/AFzQB8yv6NxxKOOEAuPJJfjNefAt9+l2CveCS0G0C/YQU9FbmdZw5+3ta9IAdAOxCyTGMbbd5ptq1kMzlDmJVAHNNFa+wHQkwBt25viIbKatShRqKAIs64ghllWa8o2w==
Received: from PH7P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::24)
 by DS0PR12MB7852.namprd12.prod.outlook.com (2603:10b6:8:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Tue, 22 Oct
 2024 06:07:06 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:510:326:cafe::13) by PH7P220CA0018.outlook.office365.com
 (2603:10b6:510:326::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Tue, 22 Oct 2024 06:07:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 22 Oct 2024 06:07:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 23:06:48 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 23:06:47 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 21 Oct 2024 23:06:46 -0700
Date: Mon, 21 Oct 2024 23:06:45 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <joro@8bytes.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v2 2/3] iommu/arm-smmu-v3: Make the blocked domain
 support PASID
Message-ID: <ZxdA9SZAP0JsW8MT@nvidia.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-3-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241018055824.24880-3-yi.l.liu@intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|DS0PR12MB7852:EE_
X-MS-Office365-Filtering-Correlation-Id: 706bf2e8-7def-4872-2602-08dcf25fc106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ioB75pAr/40TJGil4Tkp4PAetQhwHsOlgRDCEwR60yC9Lhu5A9lGIMxa6wmg?=
 =?us-ascii?Q?ziLKcDICthg/vBX/3h/MyFRs1sAJJmQHrvSCpBfFPsduomdU1dQ5lUKYK8Af?=
 =?us-ascii?Q?ghld7gv2YK8rUna97+eUDTK8zUIl8aR91K1eXwr4ch0fr+w9/ChA1Qxrb0B5?=
 =?us-ascii?Q?UjKt9KvsFr9eO+NuMHVmVYnOYPjeN5dp7TJFGhbzF2VMbtDnHiXGZjV06Yqa?=
 =?us-ascii?Q?NJ9LjGPEavRCmjPRGNfFiFuhCh3lH+KVnHQm1PiQ8u7oApHXRp430veL5W5R?=
 =?us-ascii?Q?kFdGDLmm9f15WNmzB1UTtQegM/LWkniS+F3nR8mlQ7lMxDze7IYBS89V4v62?=
 =?us-ascii?Q?coOAbH79Vc/Ig/hxTZ0F16GkPhnHNwrKDz/HPCuVxfGfaGzCrjavjeRH1bfM?=
 =?us-ascii?Q?FnQEkH1P5cmhIFGFOKT/Zgthev5z0Iofglsv7NHfZk1TTmdS8E4qNSE/LmBB?=
 =?us-ascii?Q?+sHTO/8+nmKg7MaWJYvUcqOZBD971ckl+Ufeux3SnA91SgrBjdn2tL2NPfNB?=
 =?us-ascii?Q?UDr+vTr5c2wik+k5XZLJUseP2Aa71k00lX6AfMcGmzO0c8K2VECSWVyh7IP2?=
 =?us-ascii?Q?rho2IIIlR8eWg7r4uG/XFHOphFLwzUK4Cjy2E8ZIwFxTka3ACP0759Qp7Swu?=
 =?us-ascii?Q?kaN/cV2JYr6CraocZNGvUup/D/ZMGmFuiu/SLL5ueoCp72KMV53LwtYe/Zcj?=
 =?us-ascii?Q?2sYTvlB9BUYKwfgqroc52YItBk7fjvd0nY2PU+DJNqkFiZ517FVLC4a/oKrV?=
 =?us-ascii?Q?wo5YbTEY9Y3tWKXy33T335n3WQHuUSjjAnRv/eRMF1kssOmJ5FUeQx5ggj3A?=
 =?us-ascii?Q?HA5w50xRTXvrtZ9nwNnZyYLMvv5878KZznuBVkNy1VmBeqgjtE3S5T0IF3/Q?=
 =?us-ascii?Q?HYWWau9rBbl7geCSLFJOsueiZbnuvzgdX3MLLZ2TM0Z86IQ09Cr8+l40skmx?=
 =?us-ascii?Q?TdyL9JPg4sPmJsYo3HLEOSWnUN71o9AcvcRsfFKdgPfglyGTrz++z6xq/vE3?=
 =?us-ascii?Q?yeiM54wxbVTca6nOSl+bwtFLOreRKtW7Or0K2h4AbDkUnhfrs4bkLAFoAJ5t?=
 =?us-ascii?Q?S0T9M6jJQhfNFqcPfihrwYdBDwSIlgfCHJ99NN4W5N5EtcHL6tPfE7BD6IOF?=
 =?us-ascii?Q?Ss/Feqi+OUVFqy0+cSRNFY8ItKtcw84vaZO9GIV1PV+pygVL7toUVvgBPI6y?=
 =?us-ascii?Q?UgR5QpVDBuiP3L03yM74b9nWA+O6XBm4CcRZMb/qFHl0pBXhy4jaJDMxQ1MI?=
 =?us-ascii?Q?ZBuzua5DP1Z+QI2C92C67NbzfR4KG9VKUFk5u4pJyV9eJARewwKN7o1DA065?=
 =?us-ascii?Q?Ld8owWD7roeTGnwel/4I8yGQ9kys3fh2b+/J+/8w60g25GcS9nEQFLTkm6oh?=
 =?us-ascii?Q?peRNon4amDMGOgbYfWiqE4tQmMMJWdDEqPcjlq9hQ9JwOwVz4w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 06:07:05.2894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 706bf2e8-7def-4872-2602-08dcf25fc106
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7852

On Thu, Oct 17, 2024 at 10:58:23PM -0700, Yi Liu wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> The blocked domain is used to park RID to be blocking DMA state. This
> can be extended to PASID as well. By this, the remove_dev_pasid() op
> of ARM SMMUv3 can be dropped.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

