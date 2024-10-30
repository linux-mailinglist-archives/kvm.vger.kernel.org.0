Return-Path: <kvm+bounces-30074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF879B6BF0
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DE44B21A3E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A161C4616;
	Wed, 30 Oct 2024 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HT7DGIhV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C4319CC24;
	Wed, 30 Oct 2024 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730312116; cv=fail; b=kEeTfIjjYvmFHJOCZ8eomqz+QWGNGHd1U4zaliUNSsKpk9qaTdGoSwe5lWdXCN1PNFebrzERm+NzUyTWm/AF6o0aifrLXFx+FDPY632/OYgcR9F6GU4eUS3oIcTVqvlorCJ5ZrArs4PB6WnJJ4wva7BIxpFLX7wp+fmfvmLVlAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730312116; c=relaxed/simple;
	bh=jqqbbmZpcb1o03RUjocMBgEnt4NOqE+5EB1ukQjBdA0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYW1ueidlQRT4AE8wlRA/mQk2Kj99p4u4NU5Vzsxu52jLILvIOjan84BlY2c16V2SCjTzfQ9RMBmEyyxP3BX++uWgMiDC51Ddqy0DRH9u5Spu3WRJavGi2whozlYfY5zk9dA3qhU/2CvuQVHFYWKaoBV4IDtkJSJwbFbUWLKK8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HT7DGIhV; arc=fail smtp.client-ip=40.107.100.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2nubCJBbd/HE9LGKD0fuwApPNylo5Y6+5I75YIfi0+G6sMWfAe4OoLNhWr6VSoc8GFTFTHJsvf0ECQ8tB5BZH1KHnqCsbeX9BotcjRrZtBj3DsyD9Zbu16OQ14z5Soxvylfnn7eo6kdbIyEj/uM4HvbfTO8kJc2eEzdv1PIWpx/PNozHwgD7Lf+OlGdXVzA9/sXZq5EYELzF8klkF7MTNKah9s0J71y4w4Q8acNAOlSwnka+LlfcAML56276mnBI467FJ4fjpByDH1pO2lBFfNZjc+yORryf0ECxjXYrtjJ4xfd27roBC5sIKH6NeGdEaE1w8Dnk60LOFFiZICJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HO28bZ5Gg2rFGrwI//R4BquO0jRfn9h2OpIHOAgeWdw=;
 b=l04F6ueVL5GZUvwpszeH42+iNY5FzrGUmWJx6m31ytv7JlpfOkwEYdOXNAoSGhIv+Uw6wopgxKW/JKemjVMXHi2J2c6bZprTRdHTOFdm+o42+NscyYG7+Fw+uofBpCCdp3xF4S/6ja6oMcdoAgvBjPlpvPjRRZj58ZAto3KmIRdkjyv79N+uvLDfK3/VTEhoMeQqIb9tjLFiCv7bJKyM8CjkyQQBhGwEXmBQb9Usu8LhNVRc49IDULtkGObDXC5YoSG7l+XrCGJdYM/NbufhBZV776jOnN1cBTK55urnLG2hyRQ+PRVhw76dkyBtWSm5BhrSui3f07zBXYV2NaUb/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HO28bZ5Gg2rFGrwI//R4BquO0jRfn9h2OpIHOAgeWdw=;
 b=HT7DGIhVIg+WazqeFLpiq5+Jrlb7B7G17cct3oU7yaQW0jXjTkes1j1nRTzUZira9WsM2YVgdq/uNe1IcSJaWwUkJJg+IcONKSnX9rjAz9THX90SAWEnv39FPZXB9UDRrgm2XZ3kqn5aoUso0xaAFKTU45ZlY6/haHVEwDnmY05pBiOESwRyUds+vtzKvJLPXWI71diCnWdE6R36p0ja2D0rqEvKtBX2zFNBpe4wSpqO08vn/TOBfMiyathXkLPEadyrzEowpcGmgLHfmewW3E2tbH05Q0qin2Immp78HZ2TKvsnxcB4Q0CajHCcDi5ba0GkG7Q5A9BsUgScBMmLnQ==
Received: from DM6PR10CA0024.namprd10.prod.outlook.com (2603:10b6:5:60::37) by
 PH7PR12MB5878.namprd12.prod.outlook.com (2603:10b6:510:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Wed, 30 Oct
 2024 18:15:09 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:5:60:cafe::5) by DM6PR10CA0024.outlook.office365.com
 (2603:10b6:5:60::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20 via Frontend
 Transport; Wed, 30 Oct 2024 18:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.16 via Frontend Transport; Wed, 30 Oct 2024 18:15:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Oct
 2024 11:14:50 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Oct
 2024 11:14:50 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 30 Oct 2024 11:14:48 -0700
Date: Wed, 30 Oct 2024 11:14:47 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Mostafa Saleh <smostafa@google.com>, <acpica-devel@lists.linux.dev>,
	Hanjun Guo <guohanjun@huawei.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 5/9] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <ZyJ3l02hiHDgPZWQ@Asurada-Nvidia>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <5-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <ZyJdzBgiP70MOtcP@google.com>
 <20241030175615.GJ6956@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241030175615.GJ6956@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|PH7PR12MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 4af331e6-41ec-48f0-03ce-08dcf90eca1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mrTgAMmGDI8UCOv7xe+khNjL0oGVU51Q7MUk7suN289hI8nFrTwkyVr0q3uu?=
 =?us-ascii?Q?/mVMLsVxF6yrhJAWxfw1OGoE9tHT3RRfQL7ZppekvjczD2hwG+cO7GueLvFo?=
 =?us-ascii?Q?XFonV9bMb8ayADl5k19iyK+jD/YKde9tsDz7XDYyZUSEyqZpU0pSzxnFS/NY?=
 =?us-ascii?Q?tZkAM6xQUzMqf8lnF7QPQ20BjmVKDQNkZfwk/eYgQXgKXJRHGJYFIGf4VHFc?=
 =?us-ascii?Q?4N18PwdJ2oiKeO+EFGmuH0VWbdZrwicCZsz1YezJJtAn//jhaUedBe/ia5UT?=
 =?us-ascii?Q?OBgy45Za5ZMsuliEIxwR5aiZKvXVtDPJ6M01fQHo3dZKZPT6hRb4lkum8t+Q?=
 =?us-ascii?Q?X32y1S9L3wHZW0pchHOO2qRsStMlV8KWHDXWBDReodo8ZWsAG7Kf6tEO0qfl?=
 =?us-ascii?Q?PDzDiq6gMIVlDyNNDtJCLko2cF/03/Bny/C1jHHTaLx6eQoYk431E4/32Mtx?=
 =?us-ascii?Q?Pbko/YwUGeZiK5FqsLdDmeN4TsfPHoQJAc8tcTsKn5PA1dMc06IMahGJ+tTx?=
 =?us-ascii?Q?XJKYiKnTb3asxdOr2I3i6yMVL4oVoKkDKR8ibTC2mefG6MeATdWrgc1yl9GA?=
 =?us-ascii?Q?UjqiYChDkpuanr7axQLNCvxSovzz+DXQRYm7qLdeGcOGSreof8l376yO0eMi?=
 =?us-ascii?Q?acdroBGEsJQIGhdNhG5VbmQvAr13kTtA16TRDWm3UuDp9jv+l//Mzk4ZdtZx?=
 =?us-ascii?Q?Q3CCzBzBU8tMuS09VTadNPXOW9fXYd1wb74HkrZhMWPkuZ12m/Aa27TgEnkY?=
 =?us-ascii?Q?ZI5SQlX5O2QyYuAjJt+vkaTubf818QTF7UhifwbPbZvZ7ROs0Q3eWHOyNRcG?=
 =?us-ascii?Q?3QCfXNENiQ/UTCKxIXVXFVTlRtaxFoazG//r8JaGCdZDvhLN4n07x6IcMKB9?=
 =?us-ascii?Q?76yNKuK1o/Po/lTm1LZxAY0JMpyabGaUTBqoNoN8vyrWE9cC5mzfpWrZlyUU?=
 =?us-ascii?Q?w4Dum31adX7DH8wnsv4/2S0Iq2drkEHWvyKs1gjYY4rjM7Gqzhg93ILUBSQq?=
 =?us-ascii?Q?GoGZjjLNjACDexJCWN3MhoPWsp8DWMVWlg7HRFDlmhNZH+v0fSFnHbXnt6xg?=
 =?us-ascii?Q?03O80IueV+vmjO6oSIjPlMjdvpI1LswKuFIlmjAQid2DrqV4VhsXwioZhsgP?=
 =?us-ascii?Q?SyDbaU8KJkcH/6mG01OZZItCAeJe9I7iYy977S3T9Kqjhqa+sPXLCyz0NkKL?=
 =?us-ascii?Q?5+hV9pafNDsL0kwwXkTqbmlpvAsVSITJEsEj1llyZbIvVu9ljvUOzwhNCwum?=
 =?us-ascii?Q?bG4NheUmEtReIe5B3r7I1wSiwWoWIRKpIc9XEwbWMWzKSCcy+xbLCI/uKIrs?=
 =?us-ascii?Q?y53Vn8BTO6EzUEcQNxA8Ix1XhEnqB+lkOfV/Xnf5v7q5ugVI0OW+jumw4C1a?=
 =?us-ascii?Q?YdR9x5fP3EPGIIgP2Qb6lAzOt2R5uOjQUx+yEj34IgwYTT2+tg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 18:15:09.4342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af331e6-41ec-48f0-03ce-08dcf90eca1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5878

On Wed, Oct 30, 2024 at 02:56:15PM -0300, Jason Gunthorpe wrote:
> On Wed, Oct 30, 2024 at 04:24:44PM +0000, Mostafa Saleh wrote:
> > > +void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
> > > +{
> > > +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > > +	struct iommu_hw_info_arm_smmuv3 *info;
> > > +	u32 __iomem *base_idr;
> > > +	unsigned int i;
> > > +
> > > +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> > > +	if (!info)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	base_idr = master->smmu->base + ARM_SMMU_IDR0;
> > > +	for (i = 0; i <= 5; i++)
> > > +		info->idr[i] = readl_relaxed(base_idr + i);
> > > +	info->iidr = readl_relaxed(master->smmu->base + ARM_SMMU_IIDR);
> > > +	info->aidr = readl_relaxed(master->smmu->base + ARM_SMMU_AIDR);
> > 
> > I wonder if passing the IDRs is enough for the VMM, for example in some
> > cases, firmware can override the coherency, also the IIDR can override
> > some features (as MMU700 and BTM), although, the VMM can deal with.
> 
> I'm confident it is not enough
> 
> BTM support requires special kernel vBTM support which will need a
> dedicated flag someday
> 
> ATS is linked to the kernel per-device enable_ats, that will have to
> flow to ACPI/etc tables on a per-device basis
> 
> PRI is linked to the ability to attach a fault capable domain..
> 
> And so on.
> 
> Nicolin, what do your qemu patches even use IIDR for today?

Not yet.

I think this is a very good point. Checking IIDR in VMM as the
kernel driver does is doable with the iommu_hw_info_arm_smmuv3
while a firmware override like IORT might not..

Thanks
Nicolin

> It wouldn't surprise me if we end up only using a few bits of the raw
> physical information.
> 
> > Maybe for those(coherency, ATS, PRI) we would need to keep the VMM view and
> > the kernel in sync?
> 
> Definately
> 
> Jason

