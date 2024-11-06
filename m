Return-Path: <kvm+bounces-31016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A207C9BF4CE
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05175B247E1
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13FC207A30;
	Wed,  6 Nov 2024 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ddl5SN7S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAE620696B;
	Wed,  6 Nov 2024 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730916343; cv=fail; b=X7+m4B8QVQI5/zOIjtCZHAEzZ54GolCKWFBe14iqX3GdFgyRQLcJAipH6dgAe+Qi0Enw35XhVWnwffJ6iMWLjHQxKaGigqN5Q1QCNRpT5lMWA/iG2weo0bOp2xkui7m0dp0xcefhDh385zqe2EItfhMmC6hsmCSBlqcK9zqBlLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730916343; c=relaxed/simple;
	bh=qBAKpKVnCmr3hqyqx60DCxz4QxfS+TaxUR6T3jZwYGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t+v7pNR9sj8LqGjtIFlDCEvcHkqPwx598Izw3avfy/b7IIcLx4JpTunnAWyb18r/2O1msB3cjXK3ear+UGHNd+P1lLzhBswMfrF4HhQatl3dsfPWlZ3SUyiKRyMUI9pDaEeTgsImlN6Zl+dnKMTsGST15doCt67AC3efq2M8LoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ddl5SN7S; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aFY9JefMzD4h77CL3NbN45A48qd3Gh4hv6XCkv2nUOTOC7QWFiCkTnlao56dF/K9x88fOyBQUVx7NtOoOuKUXt+heWDLGs7ivi/oVgZ6VhIZCKiV80EWfzV6HtBHpyihUIkraf6DVh5P1uFKPKXmlcrRLK48ROt/nKFaeXf34b70l40Hc9xwmYkMjHV1UBktlUJX4zTlz5lzuuP8uj3mfs2WKsvBFCgY6sbBt6UsLdHWPPFmPo5UALU+DvAnlG1oiZfLn2UJiZ7uLHZt5jPhwgxCuwg2Be+pBrwdApREfoy8B6WwmtDfpo92JkdasoDTKTDOXr9RyrSF4xLc13yTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBZKIZP+5/YrTlJyIHEBPZBPcKW+qV+eHVwcK53TyEw=;
 b=BGhggAnCNE4vhEkU7GMJyJjC2EyaQP8WZqVL6ZBR0zghxJ2vfx3iVUMoP0qVKEVu9v/ZHwSuYEhs2jg7fIaAAzfTE6vYE2sswxZLhGVMnnCwfmIpAJW4UP2fRE7GPMZCUPF8f/VejbTsMaBqWZ7YvntmLW5ZsI3ZwzRvTlIjDLvKP72JwRm6iaNUl20/bMs8rAt6R4axkcrUPsSWxrntONGqaYXNBcs4Pi9DE91ZpVb5hB0KPFHgPb6AU+HOzlZ2QtcZCBnlTHtQatfd8Bc8s9cWIwQDc62BE+U6E+f8jT/4uSelHoohJIcIeM3SDiZU5rMXmysxW93aV2sxofWXQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBZKIZP+5/YrTlJyIHEBPZBPcKW+qV+eHVwcK53TyEw=;
 b=ddl5SN7SmDoi7DxQGRIbVdXoDRBuwcgIrKOtobv+MOUo4V1IujwEuDe/M/k7xx2yOcz+SIJYJjV7WYwjsXF2P/Y6j930ydOFmk72wVMohKzOUzXAiUkUp+T92H6GsLJkpZhdT8eWCkxqRmBTeMdMikWfrijdVxcl+pYExFIiC/YG5A7z0YQPNmg7VYK/opetN4aUJYMcGLivi4Cc/mmSfK5gr9N++wXjb82DmOpDwZ6RQWXGfnOeKxhnuifC8T3DjaqZRGrMydl9Ax2GmqIFJueVeqXAXnxIKWNUrrG7CRjhCf50oywiwyr4z28fwX/+V1OzxuC7Ulhl3HUSrr0dCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8332.namprd12.prod.outlook.com (2603:10b6:610:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 18:05:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 18:05:32 +0000
Date: Wed, 6 Nov 2024 14:05:31 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
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
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <20241106180531.GA520535@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck>
 <20241104124102.GX10193@nvidia.com>
 <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
X-ClientProxiedBy: MN2PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:208:160::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8332:EE_
X-MS-Office365-Filtering-Correlation-Id: ac595f24-0ce0-44fe-d879-08dcfe8d9b14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NMWmcR9qrt5Ke7qSUfHyoo81MLf9n7254kDYu3ljXZgfQm4Z6Ds0QcaUXC4d?=
 =?us-ascii?Q?B2ijPNSCOyVId1wsjNu3FMLAsHYZwOcPOGccbB78WYAzxUCPpe302GrWVqgX?=
 =?us-ascii?Q?IZmJqkGRFKk1+nJA148jyEnsHu2Y6zVQZP+MkT6f4Un9AdAr2KJsmTOpczyi?=
 =?us-ascii?Q?3M2nWxp5Ji5OkBw/UPeWzh21urahsmCb1HbC5Y9zHwj7u5G8pXOw1IDMmApI?=
 =?us-ascii?Q?r3qoLjwnKJhSLoAVqUxEd2VPhe2aZ/OrlH2x1pHBL7rZfKSKHUwvWfo6VEQ6?=
 =?us-ascii?Q?dFtlFgA8EOQvBizXzkVzhfHjldIcgrf56Kt12btf/SWUQFYThAvlLVmFa2C3?=
 =?us-ascii?Q?X3ruQKc4kYMFYVxpaxcCI3mqFmmcx+j3SeTskGae0rVtXxTfgmszruvocm7q?=
 =?us-ascii?Q?mAdli1cZh3i8QJZem0RGNV7UDxTiFFlY8vWUSgR3p6ofs6kqT1xO8MF1KFfN?=
 =?us-ascii?Q?12TU4S381GmITirLUEo/VoX71wg5XIa1eDsPHviwYA5AwK6uNf8WcaDLvxUG?=
 =?us-ascii?Q?xW2euEt94prL7OzF6oTXHJKedco4bMxJrU8XvIQgHQHV//sJw4LZdmD/oSr3?=
 =?us-ascii?Q?w1dqltSYMJFRu3Ekdldo/5W66ecSBUwnHeV6/c5uO15k3TfeLfNZcIuD3oht?=
 =?us-ascii?Q?35HIfSMCkdvE/nuuo+DjyIeMPdy6K+VGk6PwoC2X8vYrJyJxpZdvQAHpQnX2?=
 =?us-ascii?Q?9V3/2e7bo/TUKxRI7AtnHS6mJmGbanmlqgZBaO5bL+K+KjOyzwbFZzVHzkhg?=
 =?us-ascii?Q?cVEyNBRYIgwpneEm1S51bnOKY57JP2QKSiJjSPFqETx1Hzod9n4xIHFNgG+w?=
 =?us-ascii?Q?9QsQIKuIaMSQrJIi+8PeH9BtNSRdrN8tuXoF8t3/YfMWq7Ge7ofgwpRShL6O?=
 =?us-ascii?Q?kaPtqc/tD3H59Jm3AafkomLv/6zQZsAPnQ+8J4F0ZtizqJrLHspD/ilvVm0r?=
 =?us-ascii?Q?C7/stRYxYdOvCctepCK7yeaewG4Qstiv5aaUiKdJGQoBGI4dBTGNULitDiiw?=
 =?us-ascii?Q?Cl3+id9BiKeXnCDwhsiKgmG/ILCi+qMKUkjtic0ppYBFjTxJLH0UZHTljt8a?=
 =?us-ascii?Q?7hm8NRWp364wFyYOVtIAOMMrpFgqX1DEpYlDg86tC97Vzv0mGgLNiq7Kz8Nu?=
 =?us-ascii?Q?VkMJlmzwvDaqZuW4PHmRCrL9F5+7oJ9Vh4909yeHEe5yAqXOjh2o9zWIXzJf?=
 =?us-ascii?Q?cDG8v7ZpzXBZJc8mZSY5Dr5gojQ6gRyJEVlblsAPCXr5bt9vhMZp/Gs3zX1r?=
 =?us-ascii?Q?LGk9QzSIi7hRpjaBKI7ylvA2zxG6Txfhpa++NvRuDczsu1KelAME+4DerImW?=
 =?us-ascii?Q?2l+t5er65954jXZXxdvu7NrH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z6brRClIiTvPeSIPpomh8AZ4HJD92XOsX3dYjzhrW856Hr8AzJDvCF+2q62U?=
 =?us-ascii?Q?Wzy1LbSW2n4k14NL2drmLCWi4B5JgMAnaaLjj+Z4LUvzcGBLHP29nMw6x8M4?=
 =?us-ascii?Q?rg1rD9r0rO4ED9gfox4uor5NkTJDjOi4lYfOBZCcGgUseOjRtK6ax6hIvYJL?=
 =?us-ascii?Q?qXCrzNt+rGpEzgV2++y+8iO3GqV7QMSFpFID2Siu8Bxm1yHt36ObEqJZ7zBb?=
 =?us-ascii?Q?JyQHMtwD34WtrHgDEHnHQqiZL6+8DsqxG7hhsHpMFff5bqMszDD9GBA9VBev?=
 =?us-ascii?Q?E6MsBO3vc2RY2aw0PGs2J7RqkAXeD0ttIh0WVNkIQ2efzpKWK59kqLMUqPGH?=
 =?us-ascii?Q?yZC6dF8qEHM81s59ibb4nCAisDM5iotg4K2DX3A83G4P/h+bdjA1eQywmSu6?=
 =?us-ascii?Q?8+VlrRehsxAEF6uLjSkhkWSiOLbkkTzLBOnA4cnf+51cDVP6Ux1alOrYNjHh?=
 =?us-ascii?Q?JUXdr07Bnj3PBQw58qC2oL/Vwl7EqWlVBvj74oGDDcHQVqMsxfk12Rtm7K/K?=
 =?us-ascii?Q?BzCjTBjypG46NPOHLZv93WUiVJBPKlu1nDgqFOg6GNezC0E19A/rofV1M3EA?=
 =?us-ascii?Q?3Bk1TZ4Rg35M8XZlYHpXd2IdfMHFkcsDh+bhHERyxOh+kl1wocdbv7QU39nX?=
 =?us-ascii?Q?GDCrY78W1mnRgGnzA2qHGDY4I1wp7XKsk4MWLyYrPv9wFNYPpq6WzoA0Cx0K?=
 =?us-ascii?Q?znOuzyUm8IMzS4H0+6BlAlfNKIy+Pc6DVxpO9KmNzX9AI6nJARnRA9QKAH4K?=
 =?us-ascii?Q?3sPE7TrzAsdIuvD0ybKQEvggqqxiNGtRO72zlSL9S3lbPTx3QSBC+AIx0yRW?=
 =?us-ascii?Q?JAxK/IYJK9MpbNXCGmlkt665RH5XjhXbsx47F72pBk1xKHtFz/oRuzfJeh3t?=
 =?us-ascii?Q?5ZUyKK39LiVjdY/ECImlWu4Gz7oTtsCmyU0UQidaqpK23+K41BQWsYdzgnNc?=
 =?us-ascii?Q?rbA0x8JgrWbBzQKlj53uHV1WDY+/RddpgmdovM5xkUnzYPRHaknhYeEcx/R7?=
 =?us-ascii?Q?31MdyNggk83Yi00yf5rs/+bRqKnlnNTIHuVzEK1izt4BVKT7Te3/Tffs5T4t?=
 =?us-ascii?Q?zpbEAzEzEb2WljMefP1AJpeLCv5nXbRNzD/ClwSfl/JifT1Nx586lTD8bwPB?=
 =?us-ascii?Q?2mEiZtqE6u12iriYHz2vrA9Wlb7vLu1yctx5XW5YAfaVFATeN2UT0+p3h8cl?=
 =?us-ascii?Q?rHSqFzImMT7ZzWTWu+dMt1DlbzlWd7LxbIMcoALrUptXUqCv2RXSMJH04WfY?=
 =?us-ascii?Q?VOAI1xCQMyuFWjJnzXdET23XbcXSKBKEQ/pstGnYNbuUS/6OK/HyPcOaA1ZA?=
 =?us-ascii?Q?+Y/xPLQ9g1az2HJ/CoWsPjNr/FC/qvmGT2WPVoOOw4rT4O6uAUUmdVRLRhdy?=
 =?us-ascii?Q?HuI39sAiIc1nmHXwvA3hvQs0EYGQU2bkTq4+hkBMha72u+OazWUbwr5boDC7?=
 =?us-ascii?Q?RGxtRrlBAOrbA3ZJPuvlfWT/7arXN4P7lvEk+BHX8rZ9kaPVtE/1Xw3KAzup?=
 =?us-ascii?Q?vlm5KHQkDpyWajm8t1tKALv6wvE+63zW/hzmv995Uo4AAHn4D4Upz4Smk2E6?=
 =?us-ascii?Q?8tCTmzWtxY6mV/Z0cq1pE0cMybgI1D4J1dVOAsEs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac595f24-0ce0-44fe-d879-08dcfe8d9b14
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 18:05:32.7402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yf227Xs1ltjVrYdksvjk75Z+FsdyYXyvpyYnadgEHqzqIEeEBM53rj58wDTY+e1I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8332

On Wed, Nov 06, 2024 at 04:37:53PM +0000, Robin Murphy wrote:
> On 2024-11-04 12:41 pm, Jason Gunthorpe wrote:
> > On Mon, Nov 04, 2024 at 11:47:24AM +0000, Will Deacon wrote:
> > > > +/**
> > > > + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> > > > + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> > > > + *
> > > > + * @flags: Must be set to 0
> > > > + * @__reserved: Must be 0
> > > > + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> > > > + * @iidr: Information about the implementation and implementer of ARM SMMU,
> > > > + *        and architecture version supported
> > > > + * @aidr: ARM SMMU architecture version
> > > > + *
> > > > + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> > > > + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> > > > + *
> > > > + * User space should read the underlying ARM SMMUv3 hardware information for
> > > > + * the list of supported features.
> > > > + *
> > > > + * Note that these values reflect the raw HW capability, without any insight if
> > > > + * any required kernel driver support is present. Bits may be set indicating the
> > > > + * HW has functionality that is lacking kernel software support, such as BTM. If
> > > > + * a VMM is using this information to construct emulated copies of these
> > > > + * registers it should only forward bits that it knows it can support.
> 
> But how *is* a VMM supposed to know what it can support?

I answered a related question to Mostafa with an example:

https://lore.kernel.org/linux-iommu/20240903235532.GJ3773488@nvidia.com/

"global" capabilities that are enabled directly from the CD entry
would follow the pattern.

> Are they all expected to grovel the host devicetree/ACPI tables and
> maintain their own knowledge of implementation errata to understand
> what's actually usable?

No, VMMs are expected to only implement base line features we have
working today and not blindly add new features based only HW registers
reported here.

Each future capability we want to enable at the VMM needs an analysis:

 1) Does it require kernel SW changes, ie like BTM? Then it needs a
    kernel_capabilities bit to say the kernel SW exists
 2) Does it require data from ACPI/DT/etc? Then it needs a
    kernel_capabilities bit
 3) Does it need to be "turned on" per VM, ie with a VMS enablement?
    Then it needs a new request flag in ALLOC_VIOMMU
 4) Otherwise it can be read directly from the idr[] array

This is why the comment above is so stern that the VMM "should only
forward bits that it knows it can support".

> S2 tables it its own business. AFAICS, unless the VMM wants to do some
> fiddly CD shadowing, it's going to be kinda hard to prevent the SMMU seeing
> a guest CD with CD.HA and/or CD.HD set if the guest expects S1 HTTU to work.

If the VMM wrongly indicates HTTU support to the VM, because it
wrongly inspected those bits in the idr report, then it is just
broken.

> I would say it does. Advertising a feature when we already know it's not
> usable at all puts a non-trivial and unnecessary burden on the VMM and VM to
> then have to somehow derive that information from other sources, at the risk
> of being confused by unexpected behaviour if they don't.

That is not the purpose here, the register report is not to be used as
"advertising features". It describes details of the raw HW that the
VMM may need to use *some* of the fields.

There are quite a few fields that fit #4 today: OAS, VAX, GRAN, BBML,
CD2L, etc.

Basically we will pass most of the bits and mask a few. If we get the
masking wrong and pass something we shouldn't, then we've improved
nothing compared to this proposal. I think we are likely to get the
masking wrong :)

> We sanitise CPU ID registers for userspace and KVM, so I see no compelling
> reason for SMMU ID registers to be different.

We discussed this already:

https://lore.kernel.org/linux-iommu/20240904120103.GB3915968@nvidia.com

It is a false comparison, for KVM the kernel is responsible to control
the CPU ID registers. Reporting the registers the VM sees to the VMM
makes alot of sense. For SMMU the VMM exclusively controls the VM's ID
registers.

If you still feel strongly about this please let me know by Friday and
I will drop the idr[] array from this cycle. We can continue to
discuss a solution for the next cycle.

Regards,
Jason

