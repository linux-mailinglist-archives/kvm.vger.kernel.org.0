Return-Path: <kvm+bounces-23728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFF794D461
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 029D31C2161D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D01E1A00E3;
	Fri,  9 Aug 2024 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VihUyOHu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AFF1A00C5;
	Fri,  9 Aug 2024 16:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219807; cv=fail; b=PHs/hhDeAWT0e4LwvVQ/g20UVlRkJZatRrn1J73aaUCHud2WvMK8UT/cnUQCrjM3h8XNk4UKAW/+cJiqcMmMovd4zVnCwc/0AvoJywUYf0A1GKGIkjGwaaCajvmkc/IUL0Np1C3tkJLLKwNq1tocRFUFnXVBd0p7S/y5EYPvgVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219807; c=relaxed/simple;
	bh=cqQSZ6/O7yB85djSspPW8sK7fXuV4kPJxBx3cSZ6gjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jfoAu8qxGoPYZzJvUHO4AR9vupgT0eXNVFlfZ3JRjJseIU1KIfjZs5Yodq1D8HrYLfTbW7miaM2wjAiVL8VEP8qRg/0U/FKH4SrOoEIJSzPAfDmsjGZGamTa9YvYtnZWGJqO/Y+a5EsvyJ4KnLwoDQlrSPofK95he/qWumvQiJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VihUyOHu; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRg0BTJNW5p0UDeqoTzdt35pkMcBoA/k+dQPhNvfTI1hTm6SRNOUjnK7Sce4vqibbSIURiIHG0JGiHkyoGfdbBrgObcv4+8iVOMKCtefDpazfwBW/zVfIbHG+e8x8dUNfxxo3qJZMFaDBXZF394PQZMrrYOZ2kdc9KqLr0M40KKs7YdowTVX9wzsVXP/WMzJTlMncqyAIiy4I5a/eh+kWFaTLw9ax0O6YpZZkFqcd90EnYDt08OSrn2DPzdycYaBiniq5mXFK6tLScVJ3K2csUDuvNtRfoVumBkaEGghHd88GUEjnlcu6xfL6vCi/BVelXNVfF3PectHNXLD063WVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DrexOOdlf1UjKTYvIch7TPrjRc6vPMhDWUocBr0Lv2M=;
 b=uPO2fvBwLx5XITejoGiFy+hUTBkH7HxDWeYRqvj8reJSpPVOQYpOz/cn8L9M3TFscdzQ+I/fCNp8G+aljpy8WyBP9XpEbmNO2ax8JaNLbDOTWau2AJV8jhYqVMB5ro48nA4itpoxytujdRDm7K3GqCLzyFz8rtKdBO0C+BDxfUf0cOVkELuV2ezgKeGFKDTnrBDGLgBiOam/9MAMuGI1NFqSLikWl2LKSXlG43RAKDLN31eFHkKlV4/VSt2YO1h2nIK1MPtpa5cSmFtCFVsPlemah2aU/8LxqskBaDt/URIyGTXWC9A/YNSq2szRabUkTVzlOmqR2GDrfL8i5jdcLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrexOOdlf1UjKTYvIch7TPrjRc6vPMhDWUocBr0Lv2M=;
 b=VihUyOHuNSqhZXxUthdPEzhpkUwP3tghyc0XBcG9EQs4VjI9cnyyMnnKRiqBat3RmhJrZQ3hoPSx8QmbNCROrBt8ByjvFQek7yRb85RVouR/noZWGs3LDNYTMo3H5AWJDiYsWxu/V0g6+piHh4mtsLo8G49+QvrpyxTE5wAdEBJKg2PPr9lgy1HzOjyCiEgQ8BSIqV/wAMEmgNKXJT+WRpPLjaa1hP1OMtOiuVJ77USv/NgshojVU1CFCPkt4aidv5N39GeiEp+Wia4iQkgTkIhwAHqqraR6+r1naeuL/xhrzAylptTLgCMdVcCLDlkvQaZGrMRdCayQl02f3JmsAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.32; Fri, 9 Aug
 2024 16:10:02 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 16:10:02 +0000
Date: Fri, 9 Aug 2024 13:09:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 6/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <20240809160959.GJ8378@nvidia.com>
References: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
X-ClientProxiedBy: BN0PR04CA0135.namprd04.prod.outlook.com
 (2603:10b6:408:ed::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d92ecd6-5bb8-4a83-dcc3-08dcb88db922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PyofhfjmvXPp/IYl6O1vveLM4WykrnUpIzP6ISeYWNMelOuDo2sQsc7K6KkG?=
 =?us-ascii?Q?19v0uM/yTYlUG6giclo4egkY66nP9sORaHKvE4VRPObwgJaZAyabeNpXTUsu?=
 =?us-ascii?Q?8peeH0EYzCIA68mx5QKRHMQhDgHlszBi21ZT12CFAWChuoKYo0EPwtff42VX?=
 =?us-ascii?Q?wxGi5pb0qwhcgNrEwePfQbtpDuQ4Rj3f/SQHIr1N7C/kxldngtAyLXXvOnBE?=
 =?us-ascii?Q?SU/HteIbQPqtGOdwhXOllWV4Hxfkc1FxclCbb+QDBJYfPollL8KVk6DiX8jf?=
 =?us-ascii?Q?jaGChQZ9NJ/0MPxcLxaSYqLbYNCG8cHESZ1Rs69h1zZPyuowDJ6XkEpr6Vq9?=
 =?us-ascii?Q?vIoU4bSNnJ+t4wNrDf9axxYqXr5ujasD/vbN7XRegsXwPY7BUolNNFl1s6Ez?=
 =?us-ascii?Q?Ds2RMD4BZZCiSYGvfsEAFKf4ku3euDhATHsh6O31+OowTFoDY8QqG6P267T+?=
 =?us-ascii?Q?vWfeKxxxubQpb3dJ0zljCRFrbNrjq6RgcTm+m3cvcCB3XH4aXnre3eC4nq0C?=
 =?us-ascii?Q?0+dzRApEc/pyj1nVu0ckyYHYB8VOMbwEuenOQjbyX4JFeh+W43blF5dJZoA2?=
 =?us-ascii?Q?8rdYIILcswRn5WhcE3/3ZQ14dNOsSlvAnFxs9pWQoCn6f4MsL2pR48xWaxnk?=
 =?us-ascii?Q?XapX2SR30MThRwYEVVvBK7Gc+dHMuKrdFLNsM1YofIO9S3ubbnFuJg2gnkhl?=
 =?us-ascii?Q?PsR8nByP3JLf800AnkJ60bxIbdsnLP5UWusQMzHmP0827jD2SrL3Sg2bIYQE?=
 =?us-ascii?Q?pklGmb2zMxNGnn1PRwbP8LaIsFW+OymFgIvJKTggRtdvNOeLXpKknj5HHWY4?=
 =?us-ascii?Q?mTOcapQs6kpNmuqjc9QanPIvXOZ8KK0T/XXjd/sIqcNJeCDVbMckNZMDJoqO?=
 =?us-ascii?Q?cPW39Hk9CBIG4SCi/XKOdxCoqyhTje6E/4qTzAkR82tT3gTsWeOs3FkUavyX?=
 =?us-ascii?Q?WCSS+8OSLNspl0i4ySQt640sz6HbdIX8v3pXmhQyr6jq4ndWH+SkISsrAO8K?=
 =?us-ascii?Q?0SSe4lmfqpOdugnQAjzqwT7hBS7jDos7zqtzbATtkAZSVor8Uxakw1Mjlmju?=
 =?us-ascii?Q?TzbQ0WAqSo5jjm5B7PJ31pJlNXm92qWiLzG/gBgtG5xMtZ1xgoOvGX8ZoMPv?=
 =?us-ascii?Q?D+cN9JmyEp7Ssxzj/ssho99zYDPId+vFNoWdXNu2w/GJwLbWi5qtAGT+ZNQj?=
 =?us-ascii?Q?s+xaxd9gmOzWRHd+FptuWoWwAHDhJXMBEyTRW8w85PXSkCGDNpNfa86pQrBK?=
 =?us-ascii?Q?9je5zsDw9OVsfPB8/thIz30Lzx7cGTqVvklNvjoAKUICyowwt+IZ5b4WeAnJ?=
 =?us-ascii?Q?o0V5mvOvfn2NbbxiE+5P9OKZ9Bfd4LUzat3xauVtsRn+bQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jZhsmdsMFnA+Sr8bkx7bumbbx71mXfh38mseecYxCmubGmMK/ylzRJ1uzbsT?=
 =?us-ascii?Q?DQXWclL6hOyVhI6CQAXHyONY45KUzSlhWnJwUVcJein/d3SD+FSsonxdiLw7?=
 =?us-ascii?Q?ssuYq9HJ5wIjnMACTmIRE7JWRgN+hMdewnwCr9klk9YzGvKp/r4X8NzV54cA?=
 =?us-ascii?Q?3Vl1afj+ubxtL+yxLEXUeo8oNBheNFJJ8IBrBZNeAyxvn2Cp4et/6ZF3y6w1?=
 =?us-ascii?Q?Vmr04K0vhV7Dylr/WoX6W36e+LiAbLDkel8ZEBcPRBImPAXeCq0Vpps2ZmqA?=
 =?us-ascii?Q?CYJTAVx/mkzI9Uc05/l7JiAvHlFrtR0Pdu9AZnYclAQy+D8xS70DE6lZ9ED2?=
 =?us-ascii?Q?LvMQPRnaNEN/ey6q8q7pkGFMW2bJM29dm7UFfowpnUF1MWl1P26EnFGYABV0?=
 =?us-ascii?Q?P6WqvL5tLsDLVWzV/p4YKIM7H5QKm7cQ/dugKjFIm5m3DdgKMSLRk+LTXtOv?=
 =?us-ascii?Q?6hxnjS9a7vASOP00PfD+0saYFvgj3mZt2jNShaeCpeUdBTVUeyhe6GT2ULfq?=
 =?us-ascii?Q?VgRMdR3m6KjIolhsUqlCCZdzMkiNbqFvkzLU/8LG2ddp/9Mrs61KfHlnItoh?=
 =?us-ascii?Q?dmfgF1XdzccRTz/S0dvP54mA8fD6JafU+V71CuuJt5/C+F8EjaaeZNeHqIfq?=
 =?us-ascii?Q?TVbU6gc6pI4dKxK5Ltj71lJT5TUm9qhAgEk4RptyUcXsml+F/8EJSUzGFFfx?=
 =?us-ascii?Q?BVzQLNItPwY0LujEd23e8OkL5IXKNuxAXrOZ8d2O1IUS4Gv4/FtpZLOKTZnn?=
 =?us-ascii?Q?/lske5wIxs+iD3ThSuVvpGf572bVo75p5o4nqzkqcm5obL5sVOD+xHWmT2m3?=
 =?us-ascii?Q?p+X+m2KLZHH9PgdKYKLt3yS9IWwfVWqRk1boFyEX/vKjIkwUC4nnl7WViOWx?=
 =?us-ascii?Q?u7fTT/5ynWOMssdaj9g1DbJ2L2xxP/qzc6QtbpKWG97QSxKlkQBm8XFBR8Cu?=
 =?us-ascii?Q?XfJnKsYXTCBAWLIRiNUYF+4+cEO00LoH/dhEAFNvUB0+c6/y8cZvaNjB8RmF?=
 =?us-ascii?Q?fvdM9r2nU1cy1wNKr6F+b1ZKEztMmPZeCfrsPNW3+1AVh8MRz9YuIw4qmlQv?=
 =?us-ascii?Q?JwYDiEroesVgbUACY4VUd9seLvRihi8TLn659f4vhS/LOtJr3seMGuAzN9LE?=
 =?us-ascii?Q?thDzlAkhaGJ5kFcgEHNqrOXnXpOGfmT45CpSJQ5uAePUeSkH5TUQ13sRoEkP?=
 =?us-ascii?Q?qyIZwQn8o1UMbsweVj7Ik1RShDxzJuris47Rw+3s2yD01NfETQqjdrj1zMJB?=
 =?us-ascii?Q?JyIe4jqb4NMB2SMQHTHrUC2U5HoTS0qZl5017duVNYdHOlaWRFg5/GCusVUi?=
 =?us-ascii?Q?+UfVQr58wU3LH+HCHryXaUA7i2PhmOanjEkHxtQJsTLKj3WKCbtYGtaWJ+SB?=
 =?us-ascii?Q?Z2+KzmRsFDM9pEQBlJNqFcPZXOvzL125Mlc095gpoA4qUMO3cPGqrydHySNI?=
 =?us-ascii?Q?yTv2VCg3oRWvxrkEjHKyl7Tlx0hyT86aZCa9NAXHLjXwzCkAIqwj628umMfA?=
 =?us-ascii?Q?iZ1r3wvst1o98pEnd0swfWRRgP/Ss4TwHF7/ecCjGmnqsz2vXQlmnGrw2MDy?=
 =?us-ascii?Q?knx7RSuxfs/FQYivlP8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d92ecd6-5bb8-4a83-dcc3-08dcb88db922
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 16:10:01.6915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sxDmXM6ekYnq9dfDjvImNuB9L5eS4QWOcIT8JnvW9ZPjlQZI+1xDIQwaLDqNzRI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744

On Fri, Aug 09, 2024 at 04:06:22PM +0100, Robin Murphy wrote:
> On 2024-08-07 12:41 am, Jason Gunthorpe wrote:
> > For SMMUv3 the parent must be a S2 domain, which can be composed
> > into a IOMMU_DOMAIN_NESTED.
> > 
> > In future the S2 parent will also need a VMID linked to the VIOMMU and
> > even to KVM.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
> >   1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 6bbe4aa7b9511c..5faaccef707ef1 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> >   			   const struct iommu_user_data *user_data)
> >   {
> >   	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> > +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> > +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
> >   	struct arm_smmu_domain *smmu_domain;
> >   	int ret;
> > @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> >   	if (!smmu_domain)
> >   		return ERR_PTR(-ENOMEM);
> > +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> > +		if (!(master->smmu->features & ARM_SMMU_FEAT_TRANS_S2)) {
> 
> Nope, nesting needs to rely on FEAT_NESTING, that's why it exists. S2 alone
> isn't sufficient - without S1 there's nothing to expose to userspace, so
> zero point in having a "nested" domain with nothing to nest into it - but
> furthermore we need S2 *without* unsafe broken TLBs.

I do tend to agree we should fail earlier if IOMMU_DOMAIN_NESTED is
not possible so let's narrow it.

However, the above was matching how the driver already worked (ie the
old arm_smmu_enable_nesting()) where just asking for a normal S2 was
gated only by FEAT_S2.

This does add a CMDQ_OP_TLBI_NH_ALL, but I didn't think that hit an
errata?

The nesting specific stuff that touches things that FEAT_NESTING
covers in the driver is checked here:

static struct iommu_domain *
arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
			      struct iommu_domain *parent,
			      const struct iommu_user_data *user_data)
{
	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
		return ERR_PTR(-EOPNOTSUPP);

Which prevents creating a IOMMU_DOMAIN_NESTED, meaning you can't get a
CD table on top of the S2 or issue any S1 invalidations.

Thanks,
Jason

