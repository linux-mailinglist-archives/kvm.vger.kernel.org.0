Return-Path: <kvm+bounces-30758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDEF9BD30C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D57C0281D47
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 17:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F04313D52E;
	Tue,  5 Nov 2024 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JJyS666V"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EED7DA7F;
	Tue,  5 Nov 2024 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730826222; cv=fail; b=VVLM4Tm0b5Okn6KDH2cM9IaqLPzn5yGbFzmbINQRvt9E/VRV6PvpfNNUGiCDSUNeVfjOQ08n8INPNNvVHAi5svAoHxYMlwNTxQq/XU4d87mcN01h6yVZkJJaATr3Vjn7tx6ieqCyh5pOymmvg4pecMGFnUWymuvC49OKD+4Zgq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730826222; c=relaxed/simple;
	bh=9FM1wzr4PTNMvpWWh52yAe2pMMzudufkx3LysPiZ2Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K6qw4jXAXFdgU+xt3YNQii054WykE4OVS4nk+VITgLII6ZqiNcPUhI4L9UBuZnA0Flp26pDVBAI28+PZ5ecGLxV64AbY3nz8OCZnNV+dvLoyLsarmVq1oxHhlRFwnmwD35bE0v16Sn8ki/cfbzmdt2kffvQsTJhWL0fmisQiwFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JJyS666V; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5Aw5XcfW6PMk6ArdZNX6X6dzbEukbiAw1Mnvdy7x7/JOm5Lx44l8V7MeJesx2GUoVkiMErUD8nlq0MMDOdoP50Ee5pIGyH3SC2FpCw6WPnL3sU6S/K7de9QSDAHDpP0fe07DDOT64lZiaO5UpkzaBVOOQsron1nBy/qtyXsX0geYaXOBATZwyFQ3me4/GuurErDF9c+MpLjf8oIQlNzV+aLUWbPRfGYfrMjMAAYmvjLN5LY5/B0GCSXnFtlBpgiB11eOxHaqbrMq1/9phfF2dEoXsTfXWzycrhj8/BOOg8kSYT58juoW6xMUvlq5V/DxuVxFWCeySIfXpoUfEscvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdOMPs1qCwRukWS7tOz8YmlCBn7hjh7crk9t6ssM8M8=;
 b=nWf0kwOKjjg/tx9Dkin5QHj6l9iEasI7ion411HygnbH3Bf1RKz1fcr3S4Iv/X+mpNef3lZj5OuwOntiW8n2Kau2iNse+yaCV3uBoIhQ/TRAXyZZX+MWlfWxJprPKawp76k+luikOqgQKlVHsDRxvdy3eTWncy0+qHiR8povT/fUZDPIfHlEW0sROKm0j8fVmdHxT4AHZrxk9Mw2laIILLp5XwoyrPYbOz7MCJJH0WRlMj3iFXpgpmKqnikTvE2p44WhQzlLcpFyMDQvnFgMWHi0IQxMvmDT5VEO620gIG7Fk6qDRxt+3bx6JioG74Ljmier3nBPr0O/tchIBfoncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdOMPs1qCwRukWS7tOz8YmlCBn7hjh7crk9t6ssM8M8=;
 b=JJyS666VTSUm2RmXJ9EMxXSPMhaxJGFRh+8qnYNO5XY+0AN9U4c6BcId90bmz/38x/5SvuoBHIBs13arZjeKthzrg+U8u6DmTFh6C/TJhpWpObKPt8CPwPdIBwjB4px6PIf45yT06/HBxIFQD1szmAtyXXHp/US7MxtUeattWh4NxD2gQ3qxKgpNLu1KRnndPoCkAJYyNsSEMO/P5kS549wd0hBEHozVYjBTFUNpDWReZ5z8Hcv+BtAgzrkd7I9l2d1IC9XND0BCOxBQxSKXWHGF49jwVqbqgBHf9mX23OEtRSdiErC+g4Y/IjRtoHuBpVzrWUvVytGiVWToE4iAMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH0PR12MB7080.namprd12.prod.outlook.com (2603:10b6:510:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 17:03:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 17:03:35 +0000
Date: Tue, 5 Nov 2024 13:03:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20241105170333.GL458827@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241101121849.GD8518@willie-the-truck>
 <20241101132503.GU10193@nvidia.com>
 <20241105164829.GA12923@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105164829.GA12923@willie-the-truck>
X-ClientProxiedBy: BN9PR03CA0842.namprd03.prod.outlook.com
 (2603:10b6:408:13d::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH0PR12MB7080:EE_
X-MS-Office365-Filtering-Correlation-Id: e1326d90-b04f-49a0-2a77-08dcfdbbc90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1t3MEA6q9AHUJDLx3FgT64c7A+ByP+vuL+2QZsgQoYDblgQYBk8kd/xyxd+6?=
 =?us-ascii?Q?7SAOf83z/qz2wz4DIfaRGLVQGH/Z25/H5sRiYrbZKi0JoTdVPJc7eQlbYDt9?=
 =?us-ascii?Q?w7zLp/GTQPof7cZkgIEmW++WiI5RONslw437xh0Q1NzZoyn0CTZ5AEikUEoR?=
 =?us-ascii?Q?iq83709vcDmEdR7paQpvkXoMydRCA3xZjb/dfb/sxIYm5EPqs289gDfqOPPQ?=
 =?us-ascii?Q?5MKfMtAVV3xpyMmB1XwST5DmkFLKYwC9JAOGnr3SxSVYzVKu2xja+hfU4U9q?=
 =?us-ascii?Q?dfQ+zDPI4aoVQHs+ZFVaFB6GzR7vQrfSrksa8VruKhwcc9F4mMuDVj1+4y2y?=
 =?us-ascii?Q?/7qdJjYx25TeYrGwIx9ZdViN7SfqOSPNkkJXCe4bYPE+Y/Jgv/Ku5BvWjmkf?=
 =?us-ascii?Q?4jyrSIQO7vxUAP60+6kpp3LnNhGqxNOfgjbSsWL+w5vcfPvQhQ6CBVKwysu4?=
 =?us-ascii?Q?jjVcI0TQY92uJjykb/q4dOzYPIs8W0Pjbgs8NdjsUJ2Tuvbf08cO5sPeAnNa?=
 =?us-ascii?Q?Jep8veeRooFCr96Dige64XPdT1tjcOsCPNKoVHT9g1+X2IzjzDVgEIrAZ8kV?=
 =?us-ascii?Q?FvD3uNWMp2lsWpXJ2Dig9klPIynwQXoT7ZcIdoXukC4glrTm/u/sArswe0Xj?=
 =?us-ascii?Q?CH9Z2d5IW0z18LOgtNVm8obWHamBlZpxIrjMI4nLxY7EcB1PTjIc0AvBBXcY?=
 =?us-ascii?Q?iLgZPmmo8F6WlOc9l1MT4z9oK0FmZQo3uNO2QBKlKjBPaT8VYspCZo1jZ4lO?=
 =?us-ascii?Q?AwVnqU1x+5pXfuWxjlxPNfoVMZFUJ1sHEBmiPuywqIy4nej11REW+O5gVFwv?=
 =?us-ascii?Q?1LNwTXORLMENtLTXZaIep45WJBjLDWdiL6TvEwFU0HIgOqR+SYawujFfSCC3?=
 =?us-ascii?Q?26ztZ8CwHSHFvteDUSPclNBVHAIToeQ8DcMlMUqnPsL8rmSwqeUi/eg5Zuhz?=
 =?us-ascii?Q?m1WzDwdgB/8XsnxoCqrAgGj2SBW5m8bfuGXhoO9vYQw0qiyUV9oq2cJ9riJH?=
 =?us-ascii?Q?TfCzL5BtdK1nPs2CCxkQLRmOfS5WMscz2Ywx6WDoDgUKmaJIFL+o/ZlKAO3b?=
 =?us-ascii?Q?9H76d2leb66oymUxXzdcGM8fpFyqmTtFMN9Mzulsb/V332gkdmjDpTkwcm/0?=
 =?us-ascii?Q?8ydzTrU/avJw4OcYV7U57lvypXrs9A0RErhIEySe/J3GiabKSDp/aBU8D2dy?=
 =?us-ascii?Q?JKxU3EeuJI7ZgeDZx66wYhZCrBkmFb51elPKofPwXIIn+BgLuqRaGX7XGLQM?=
 =?us-ascii?Q?q3MH9vZfBeRJdTugXCKli/vAYwM9cAyx/5mmfaZ4Ij6xPRu6t0pQ61se2rPk?=
 =?us-ascii?Q?e8get+4Ng36re0VWNwJbEG65?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MSldHey3iTbruUzW9Wvl5SEyuBZ9tlTzVOy/oVOKv79TC7FgoytuxBEA3IRN?=
 =?us-ascii?Q?5Pe3rt6l8D4H/0U5TWhXMOicei5G3vDqhXi3FudVs+Uvm7oitys70YXTVclM?=
 =?us-ascii?Q?msFhVxcn0O7w+3u2mqplmSAen6kuKqegOVFo6pQLeYjKQaDB5XFAJi2R7hRe?=
 =?us-ascii?Q?XZIqrYadATTMsmFWtGTdj3hm5CdhDad3D6zWQQZts+4z/LqTYFUHE5CM8ArM?=
 =?us-ascii?Q?9URAB23VrjMF8t4dcs8Sn+J8X9Soms/8Ps34f1+7rBN17SCEGcgL0SJT1RxV?=
 =?us-ascii?Q?Cf33fLbIEoqZ8y7TN8kNF2tnz5Ye4FupBex2t/BsikjSF06OBXhRqt2CJ5lu?=
 =?us-ascii?Q?rco0rIJCoqZkGrTkDAh8NO3TZbo+77OVPlr+TkQdYnLdl/7WYCGmn0/cHILh?=
 =?us-ascii?Q?xHW2B5VngYBJmJwjrqwM5SzUro2xiGzbA1LOyrACAWzd2QqJTffypq+aVPNe?=
 =?us-ascii?Q?OOpiZVSnuQ1QKsf3hSwx2u4bsU088AjAb2lickargsPo5Q64MrHc8QmiP9kZ?=
 =?us-ascii?Q?KKm0jlIKQOAvnL4S5GhH0+HpbfVSrO/9sD7gOeZnhLEC9lGf+YNLpaSqOeGP?=
 =?us-ascii?Q?gzv/+ClX2nfYUtXugSwnhUHWIZ9URdfJguvGcYq57HztxfwV/Gga0Go4Q9dl?=
 =?us-ascii?Q?BUQ1OHq6/BAkiPL8FtPoN7Ne4C3TWUgSqTyjo3Kc0DAc0VvOW3/Qt9OH+OBZ?=
 =?us-ascii?Q?Vmirv83MeXKTm3wFs4w+9MhVczB6KxRpGjcerfw/4/gD0aJ81L3CN7d6rVGN?=
 =?us-ascii?Q?FJDYIemxa/RzF31DMh9ZpvOXZtGjU9GhZL/BmhpfbENZs5u7PsNz3JYyz3fE?=
 =?us-ascii?Q?VnA1O4vdSMqWcR34Nezor2M4aCXrMn/TzWKrgufIu3QuKEMdaQN9tZUGgmqY?=
 =?us-ascii?Q?RHMl605D80PXxxZ5KzWQuZMQgX5dFrqCjy+qoZyNolttN4WwxgCz+NvAZ942?=
 =?us-ascii?Q?lTRz557HfXGX7NTYgNGaRLyBY/lAAWxP3/x1v+eQgfISzF8Lrlv5DH34alFd?=
 =?us-ascii?Q?n0cqGIEynbFvwhb03O+VyMkt2s5l1LUrCjbsNmmovr9zcNpPDFrXWo+rUuj0?=
 =?us-ascii?Q?bX1aFJkipXR8ZVkSrfZte2mg9jN2rQl5FToxIteWrDmhE0M8usAk4gDMgZIq?=
 =?us-ascii?Q?vVzktKMhbXsD84hW37oQa/eH44nxzrMSjgTb43l3im5YfxM9C3ZonibrTXfe?=
 =?us-ascii?Q?ug9f+acuuyeRYL2iMRg28k67E2O8Z7zLXE5Q0Yb1HZhF5jmVguBUxPh55vFw?=
 =?us-ascii?Q?Kqc/TbbiSxkcwbkydSQaEpapTKXzNuB0e3gTSWsgfMaCQuRntQSa1SygY9J4?=
 =?us-ascii?Q?LtEqxFs4zkSWmwel7R5m4Bc9d3BIE4LAQEWU4hgkpiH/SHWVllm0HjVa++En?=
 =?us-ascii?Q?A8TJgsViW+VSbi4R/coUvYvsNx+QCrTAdZBM/sE7Igq30paO3O3NtD0gu5G+?=
 =?us-ascii?Q?3UxrNrXwvf+AXXHmpLwhWOwG6pR9WjVOAMrDSyyHJ8Tp5kePhg2r75tJerIp?=
 =?us-ascii?Q?WOtDYAA2vW6GgPIVCnwPkgTFmF+fXb3e7JqwUUerSCa+QgxX1/xaeuS71ado?=
 =?us-ascii?Q?bVxB/tjUay803clYIbCbi4eoHSv/MW9e7jHjseZI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1326d90-b04f-49a0-2a77-08dcfdbbc90b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 17:03:35.5215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOMnHDVWgFeMojo0ynLAShJMJ++v7LgQn3tpvEiAO6/J8Hm1bzrZqKRXS8UE/1Vh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7080

On Tue, Nov 05, 2024 at 04:48:29PM +0000, Will Deacon wrote:
> Hi Jason,
> 
> On Fri, Nov 01, 2024 at 10:25:03AM -0300, Jason Gunthorpe wrote:
> > On Fri, Nov 01, 2024 at 12:18:50PM +0000, Will Deacon wrote:
> > > On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> > > > [This is now based on Nicolin's iommufd patches for vIOMMU and will need
> > > > to go through the iommufd tree, please ack]
> > > 
> > > Can't we separate out the SMMUv3 driver changes? They shouldn't depend on
> > > Nicolin's work afaict.
> > 
> > We can put everything before "iommu/arm-smmu-v3: Support
> > IOMMU_VIOMMU_ALLOC" directly on a rc and share a branch with your tree.
> > 
> > That patch and following all depend on Nicolin's work, as they rely on
> > the VIOMMU due to how different ARM is from Intel.
> > 
> > How about you take these patches:
> > 
> >  [PATCH v4 01/12] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
> >  [PATCH v4 02/12] ACPICA: IORT: Update for revision E.f
> >  [PATCH v4 03/12] ACPI/IORT: Support CANWBS memory access flag
> >  [PATCH v4 04/12] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
> >  [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
> >  [PATCH v4 06/12] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
> >  [PATCH v4 07/12] iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
> > 
> > Onto a branch.
> 
> I've pushed these onto a new branch in the IOMMU tree:
> 
> 	iommufd/arm-smmuv3-nested
> 
> However, please can you give it a day or two to get some exposure in
> -next before you merge that into iommufd? I'll ping back here later in
> the week.

Thanks, I will hope to put the other parts together on Friday then so
it can also get its time in -next, as we are running out of days
before the merge window

0-day is still complaining about some kconfig in Nicolin's patches so
we need to settle that anyhow.

Jason

