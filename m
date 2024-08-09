Return-Path: <kvm+bounces-23701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A71994D302
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC6B61F21D38
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0CCB19883C;
	Fri,  9 Aug 2024 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s1y3S0qU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B85C12B71;
	Fri,  9 Aug 2024 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723216348; cv=fail; b=c69M2wBx1/vnzPXDGX/USXAaPOmHIrljYBoS0SmurT0OT987NmWoCDEs2A2wWWEewEJg38yxxc4HpU9cxej/UUt3q9S71qt5w7Il4+HOqgozAXIL7Yrv7dpemO+qlMIZn1CbTDogsuIfKOxKfRjt4rpZlJkHKJkz39VGeDpCvlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723216348; c=relaxed/simple;
	bh=k/hIr9B8rVcCinj9oVOONK532E3hwmSOR9bSkSOXVwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TZZJ96n79roEcWcFv0cMNNJ80ZaoLonoLJe6uO5X93XeYmOEADQ1v2MZLIcOM1Nx76caINkJFqeHuVGY4YweiZqSEkcZiLdMdeZl6MjPaHAbmZSRh1JiRlx2yAOgA5TQ5pBnq884wK1Kq3Q8xxsSINrFFozi0hW8Pwzm4sD2cxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s1y3S0qU; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LMxA7yiVgE18DDUhWrnvZe8sM3yWNcLKaOKRW1/Tg4KCI6AKMK6HlOwEJbYtIHjV4fKHv+9axBrqKkRedlVam3GPwUHS/CEpqwu+TMwHjfOBxDl3hqgUm5fotWJdudwFbX/RyK4AXLxg5o7rrQqpSsWCb9hQFAAAw8CHuzrlDhkrW8+RihzxiKQz6ycb8jHn1qieCWmB7PvizazcH0G7c0/vzRlWHKQRIRR62dqTahfPCipHIsZGk0znqQRcZtg4VuCCWJNP54s13RSIXWJv1SzUOkUrJcBR/7eJBxEYD0I/1Z1v9KnRzoCYJLoDRAJ/4KT5iwAJ4JyqONjFK0Erfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jc5zUipommyE8vCmoYt6DO9BtlndkRB/LCUhyY0Pyng=;
 b=Y7W9t5TGOwldUhdghUoLGrv7R4ndIMwIo7jsq9xWvvQbErgcagREwoOCoCXPizh/onlb1gcmlc5V2X+1qSzOEsSg9F+D/YDMZDtEbha7SRABpS6kPgkdVkwod8IxsDTwutw8YqM7/nLUDOEy0D4YIfY/6LoVyEomKFSGUB2eczqKO8U2axT72Mziu/G55zbNhaR+ecDGlKTmwkXilnyQhQ5PVXlEvTdGj09jaOqg0y5SkpfaVKVN5wU5p01hIb1bKOjA1FlupUtKEvbK4Lc298EoCh/ugFmtmSR+6wq1sspdTowCvjsVL3aKuUinnVKGNOtjt3KamcmyC22W0JALAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jc5zUipommyE8vCmoYt6DO9BtlndkRB/LCUhyY0Pyng=;
 b=s1y3S0qU01J0kEfwpXwFCWSIZqCyQ3K1Nu1z96tShrzQ/PvOMGtASZHYOnFRcAKzOYTsVmBidOoiwpEJCzUtQ8Ms30pPHg521fpx/C86TdiyNsOGtPveCkaV1ylsE4g0lUumLWjmGQuwvPPAnXTyXxL+Z+kNM2/krXWSBZJD6T/KP4CGKwTeQFWJv0qJhpDjNWM1G9/iSddeeQzLXQjTOjAroV6t01OzsI+M/OUTJFXdAXzXIgf6bGsirA5T5yQlaKb6s3dodP9zmbXuHV1Fq+7qbD95i5Rg4WrL7YupcapgJAH8YXunQw+2ss8jXWv91t+WaRB+8LJc2pqk+th9WA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB8358.namprd12.prod.outlook.com (2603:10b6:208:3fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Fri, 9 Aug
 2024 15:12:23 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 15:12:22 +0000
Date: Fri, 9 Aug 2024 12:12:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240809151219.GI8378@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <5af45a0c060c487fb41983c434de0ec6@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5af45a0c060c487fb41983c434de0ec6@huawei.com>
X-ClientProxiedBy: BLAPR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:208:329::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: c658036a-22e9-4356-595e-08dcb885ab7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/Bclx0RQZEVqNhmd6cO8QWSxnHMeziiexoz9WcrCNP7B8I1J4ceys/AI9j1A?=
 =?us-ascii?Q?3MoVrO5V5h/BsviyK2GijCemE1URRcjLd83FnAh0O6ipGM3Xp3ovBIy+X8Rh?=
 =?us-ascii?Q?MElUatGyRYHDd5CnP6i+Mvo6YHPScyuCJfIEJqJDlKii0IJYyZEnPtiTvfFE?=
 =?us-ascii?Q?tST9SeaueFATMlBBv6O3Cf1KQncAhpCtHsS43h0S8JLXi1HnZT71lLWpXDBC?=
 =?us-ascii?Q?ypDZwcqVtkfroPJ27ICx4Lty1wtk8n8C/JXKQ093drUxrPIxsLt+fHvIGrP+?=
 =?us-ascii?Q?3SWjtIsEvphmfD+YFjhqFP4Ph75rKimuKHRB/+m/tqqfYnXaQI42DFk08bLP?=
 =?us-ascii?Q?gqvUhqdK+DKbxO5uqcOzvoeZ2H4Pk8h5YclcG8nZtBU6EThG6KoVj+W0zf2L?=
 =?us-ascii?Q?N4JnVhJKUhrZ52jnMs2JzMS1fQTNMa0kadgAPGX2843wS/suSi5gnxlxGihD?=
 =?us-ascii?Q?cRF0UtsXc72svLQsVwPy0uQZjhASAzm38wOla6rHDcFMR8q9IgVjVebAYfXy?=
 =?us-ascii?Q?OzAcyXGTH7MC8MZ5lfSwMigURGaQGTKFlije/euEwNAdDCXEnktNkeDJjni9?=
 =?us-ascii?Q?6eIbTSmbDKmoxyFrAwT/wZs7+Q8G6+dk6hXObZJNyw7PptY4/5MLQyECuoIe?=
 =?us-ascii?Q?DwZ1PBMATmbB0wfPAa4f/LI08oakz1VvalqYcoucs7XSeVfk2nJKZdCt3fQK?=
 =?us-ascii?Q?uj+Iw6G1qky2OvIxyCersneepJnfTXhE0SqVBO2oq34NSkYDwu2tisGgzMdx?=
 =?us-ascii?Q?Bwik3/HxYAT8SxKnVt/e9xx7my5K67NaEAnw0RR+3Lm8ho8pr3bIMa6wMegG?=
 =?us-ascii?Q?LGPxtmp0HD8AwTJciv+w4yQTLh5miwLmkknGiDV+3WesT5Ko1NwWqlHCCyHm?=
 =?us-ascii?Q?ynTBRWsJzjVPfQeD5Q+IKX9rkvOd5seErHEWA4TLs6AXhE0tjfyQkK1/RSMb?=
 =?us-ascii?Q?ru/F/lPCCkKWN8YLuV/gn7uB/ch1w15UtdNL2pq8Bb/Sm6a4IBcmYPbQ7yeg?=
 =?us-ascii?Q?kXkHcphh9x+ltT6iWZybOQsEtu7LvzqpTZu8jR4AbuQ2vyFCoV05HqOuDgs0?=
 =?us-ascii?Q?EgnQsftdJLV+9q+fU8zZeWwasSktyzVWTE68iANJ2troxLOcFFziUFPqeu0t?=
 =?us-ascii?Q?AkzAQUUYX8au8+nGjQCnLLTg+NeY/ObCVm/62Feik+kiESO2qqZjOC3YND16?=
 =?us-ascii?Q?nYXQiJo1OcbU/LEVMG6E1CkNIvyid2jqZPY/zowl+m/gS7+CidmgsbDFovs/?=
 =?us-ascii?Q?3bcBo3A4c31e8trq41qw4s486AKyf5KmecXOhCs8urbKrorw31WUff8F3w8+?=
 =?us-ascii?Q?g/hDNxD0u8YIkBOx+l6w52L0+0KcMtKWwlgZX++aiLBqfA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BRF+rCU0PGIzp6YBBmzmoR1Pb7766ClSq96ZL0JyMPbIVBdIzKjpgmSjX6JN?=
 =?us-ascii?Q?sQe6xqcfL97QmKXcUsxQmwNrw0FuwDwLAwCurrkiWNjlKq6afAx5bdnH8Znj?=
 =?us-ascii?Q?vyCr+y0mIvjR8K8prGZy9vL0nKM+jV3AAB5JNLIeP5lZAkAgPCs0sAJBbMNN?=
 =?us-ascii?Q?0ZYmldO4LAG3XjfmbXIHY2giKzRpbF4TYZCPwVt+L5Gp4dYrUXCMSf+DuA5s?=
 =?us-ascii?Q?xhuZ9wCmP7Awyn/e/VN9IeUEBz/khqGR8cvE3lyigSjugaP+ikCvkydmMwbh?=
 =?us-ascii?Q?wPj62zehgUqD589KFQuwFQCj9qR46Sj5DfESmmmVL46xdRTvmIboCzfOAb83?=
 =?us-ascii?Q?ArKWyqKy0AOB/xPrQNxGbLWd1mn0KNqeSMc4ZtCMmRgLvBEX+frk8prH1SG6?=
 =?us-ascii?Q?F8UyMmH2u7A/15NaV6Z3JxQkvJ3eeZEqGQzF5RRW+Ioa0NULJfvlZcFl75hn?=
 =?us-ascii?Q?4SLif4J22W3mmZrsH+Z6T1J7rGxxALzq6SUYOPgsCqPHkVFMMfxdKuaT77x3?=
 =?us-ascii?Q?00bhY995qKBlcYuDqArC1dlQfXEI2ojKJKdYMJ+OnEw2jF+Qg8oBAtds5eZt?=
 =?us-ascii?Q?QNHoA36ejw5HosbnMPcQHeYxh0IqLAS90IsDtOXTYH/rdfyMMnaWWfzV0+b4?=
 =?us-ascii?Q?JueWW49ekof6YnEt0bBaaCvoujmI8VF6cIwPlCoDuECDC5xV9Lw070U81bzo?=
 =?us-ascii?Q?IwpstRu/degHnTikJNCvdb9C3o8FAvl2STSPuu9/YUsLcXTUA6UVnRp1pjiX?=
 =?us-ascii?Q?SFLRqTvAkOJEcfDDYyN5M08EzuEcm70hfaMWh0CT87yCwBnyy0EQ+d7zt2cM?=
 =?us-ascii?Q?pQagluT0GV7g3Hx01R5qMp6HFc7gB1Dg2VJ7GlJcAUmj0Pxrpy8xLJ9x8dok?=
 =?us-ascii?Q?a+H7mAY3NoOzODCCvC+qTZrSxOV71mP7n09ahk0awdv7Es4ZQTUXDkFjWHUi?=
 =?us-ascii?Q?KMmC+pZd28i3TyhehHorsUPfe1ZlTnkpxrr+vpe8XuljzUOBhRpvk9UgCPzM?=
 =?us-ascii?Q?ftSUaaLY8m+F6kIavKG7O1hgB8YUkacARcVqVAn4bXYtfsIWR7uxG6ntiBa4?=
 =?us-ascii?Q?5Z/W3le3cmyup0+6gFtCVY6Iww4JYW9H3Jv46ZBnm9Kejk2b03YrTAn75p4K?=
 =?us-ascii?Q?VSJORW18N9EaMjqd7bSoqiqJf8E8AaV47bEQy9Ol2nvFn3FcVOU5DJ403sCA?=
 =?us-ascii?Q?aTCM19rgP/+P7b+qUZ5LajhHmR0b4/KGM5zTQFpOO5gX5mXYAcI2LuYeFu3s?=
 =?us-ascii?Q?nFWtMUm2tez/KjLNZ5C9OcQNL9q+dgrrUDgA3n+NjA1CjXk2ByAgJYVzfk/q?=
 =?us-ascii?Q?Oat4mVEzuGx/h+Pp+K+EqgGBehO1HCuPqSRXyBul2Cz1xHLxZcBdm+rDMMzG?=
 =?us-ascii?Q?5x4JksNfJsKxlKCFWr/bLc9LCuIqMCE5QNSDW33yHNMMygBcVhjYzfDd90M9?=
 =?us-ascii?Q?I4Tw1aOLD4NKLA8PGu6RSQwYyzA8ytqsqhQbPynFobY1nW14hQeGAr9XPOfi?=
 =?us-ascii?Q?1ExiaUpPr69t5xNC4LEhSbw275oACtVgdbWtLW5ZoFou+MJsPvP/yGR60Rhh?=
 =?us-ascii?Q?VCYY8OOT+LZeMyueBLg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c658036a-22e9-4356-595e-08dcb885ab7d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 15:12:22.8644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXotpOfv6vg9mXV5nJzBLWjau9DZoOosw/MWGkzOEqkYOh4QObqK9qsK6lSoLEHz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8358

On Fri, Aug 09, 2024 at 02:26:13PM +0000, Shameerali Kolothum Thodi wrote:
> > +		if (smmu->features & ARM_SMMU_FEAT_S2FWB)
> > +			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
> 
> This probably requires an update in arm_64_lpae_alloc_pgtable_s2() quirks check.

Yep, fixed I was hoping you had HW to test this..

Thanks,
Jason

