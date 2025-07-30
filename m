Return-Path: <kvm+bounces-53739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B27AEB16405
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 18:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE5471893814
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 16:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AB12DE1E4;
	Wed, 30 Jul 2025 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="poJxTL0+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34B4174EE4;
	Wed, 30 Jul 2025 16:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753891323; cv=fail; b=sR0jn2tIUrWaKJe1xlBR+EQ/QzAoOb9rkooLEYMcr/0Eph0UmZwI1HpXfyWkAyGldvBFpLsegh+hnQHGbP3Kqb/7mWRrtGD0anuFyPc69FgRsEZYEblEhGcqUsRD8XAX80fuA6KpIDZ/erQwks+5OTRbFbcJi9Mibnp/X0pRl1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753891323; c=relaxed/simple;
	bh=+yuHEFC08IDvYfqiyZNK3h/+YCxTMoCG0qIqmLvM+ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m3Zn0MFVAbyzQ8v/mNsAV5VSfruN1SOuz2Jy10eIsLCimnp7JzR1+lTSPRLtNIh9e0fNsUvc8EqIuzjxCFjkbf9sRPJPDE1ChLqMBF/rj8swzoluihSTfExwt4p26rrGi61qlS6EMRuZ9qPzxUpwUDzSOEhfK94bjbB2X1c5Yyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=poJxTL0+; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9ZGnRdUWVVTbcM6lDAc54b7Iz0qF/zSn5z8AVapL+Dw9+qZPFBV7jin1MES8MH9lmtEBGdGq0+VRN5iVd0lSA+Xyh/QU5PokH4Joslk19GXgpX83APjOg0Mi/9NUJqB/cKrf0cGpAPZ8But7LG+LApnSwEOapV+fZVuMCa8ExAXznNS8dvQjDuElon0vUEAj4KWSZXrbPuDagMpiykv3CVDcEmTlmMCcJYQWC4TUIxDK1VXfoI5EguCw+X5MSvCVK6P8/XpOjgtsafStGDLTk1UpfrR54yAnhr3R//qFqE9AN0M2YLLZruAzntA6IWH/EQ0FWViLOxoe7rB2LxY8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HH4uQ7brE0iQgVDUCu9Tq6HsEYeLjK5TCFH4yU2yNQ=;
 b=GkJYLr/8gIdfpfjy953n1q/PvUDB6Kptx59Hc6adta/T72qq3VaJkCYUqanDFn9Jgy2FpHFzlX1Ntc6dE9vO9YCJXgo4ZlSHM7wWDqAK504Yck1x8kWtkg3sM2Oo/IXMtkp5wz65DS6cxRBx1l5F6t+uclYAO/hjA7L8f4LK3D5023OliyfGRkjgohPR4u73xvfOS+aTY9+lfS3d1f9EiWrZb5Ox9v1ArZcj6kxXwcgG6a7mpIrtAjxmbI1eweHY4x5kyk7A3tXIUPfz111lglJv0l1mnaFvo/pLzxQ11ZOydho9YFQ2o9e/9v7NhjOYf/2Jg9KphKue5FkcR23l7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HH4uQ7brE0iQgVDUCu9Tq6HsEYeLjK5TCFH4yU2yNQ=;
 b=poJxTL0+LaVNtiOCUkA6ju26KbTnnGr5FDBJ8/rQ5IhRkRmtioBUm/d78nyiklIPzTnHinycl+logPbiNzDAWQo5ljlBP29Vu1V17NDxSCEHiZyZLE51IEDb3s8nEDGDDuBF+SU3qw5jR4DIBXOC+A2FkB8EfXMhPnHB9bxlOXFzWlXz1YqwORBevEyoDnx5+oSiilfG77jGmosbQTQIpDofjv3CPN7NLVhJ4l1iYh93EjAC/AAVbgXZJDHcDjBAOXDStI6VyWMqYbx/v7LgLq5RbX0m3bsdQgYxWkEW8niHBRGFYCUMwSUUwLZCKgTR/ozURDc92ndVD4Ed50cOmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 16:01:55 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8989.011; Wed, 30 Jul 2025
 16:01:54 +0000
Date: Wed, 30 Jul 2025 13:01:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250730160153.GB89283@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
 <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
 <8f912671-f1d9-4f73-9c1d-e39938bfc09f@arm.com>
 <20250729201351.GA82395@nvidia.com>
 <6c5fb9f0-c608-4e19-8c60-5d8cef3efbdf@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c5fb9f0-c608-4e19-8c60-5d8cef3efbdf@arm.com>
X-ClientProxiedBy: YT4PR01CA0320.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BY5PR12MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ac4e616-1dcd-4f5e-2a07-08ddcf826762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xEvBAg7/x4C4du1gSjBRGUwm5zub2v4nodI3BAtiEVAXvnzz7Fl4BxMs8ULY?=
 =?us-ascii?Q?uYwqSzU7yZsaqStRgmiDWBTz2I+u5Eu2zfP52x09ZAx08u/zc3zQ/ovh2kAt?=
 =?us-ascii?Q?aX8H7EMc4KciS+ptEvS9dGBRF94VibgjrJDW67/qb98dxSP5Fb8ZdOzFQiej?=
 =?us-ascii?Q?pvREzX1BbyPKJiVKQRQ9w5mvglpSfqIxiV60+arana4Ndu6Dc3/bebwHcba8?=
 =?us-ascii?Q?twSP+VQzA9nSTii4J4XBLTEd/i88omp2fER/22t/YYEA8esamHE6oOFPLWCH?=
 =?us-ascii?Q?LXhgcWU6iWAwyYhGv/BAqXfqiX7PUV7OFNJ1hzCNF4jW0XYZP7k4cmPjw/L+?=
 =?us-ascii?Q?MdkT3k3WZbHX/70k9g1xGYIRVv+QFeNt7L1ap0JnV4Hnn1KT0kiVON/YwlDG?=
 =?us-ascii?Q?+PPqUUP1izVnFs2HDtwIcd2PIFMVqVAa5LHdw8CCqWGNQ4biuQ1A6+OLdAdu?=
 =?us-ascii?Q?e2/fcgBKQrBYiFCczpzcALzSxSJswI9AJxNZfwUBNtHw1P8giCEm5jthS3l+?=
 =?us-ascii?Q?Bvn5laEb4CcPaQpvuURuAiad2Lny71bd0o1tzfZCTGb9eW/QbA3UPAm3/JDW?=
 =?us-ascii?Q?52QZxZUTX1I4LIFb9g9R2V7drZYsh+qCvavfw0MkqvDIv0bvhP5XsRyg2ccP?=
 =?us-ascii?Q?oPwuXyQKssasD+fA0PPV20cGWvp3BXJdq9Hm7wp5z/adIl0Nf16iPAW/Qd1G?=
 =?us-ascii?Q?OPoiRmgN0WCDOwkzoPZiFgV1TH+6Qm77bjyaAiU7eGYNkU2BmTlmm6I1Tz+M?=
 =?us-ascii?Q?bKax+rqSiTxHhS3lopBiCCsNJhkq6UXiuqrBQjUJvD4hcKOrwfISo2RY5k3w?=
 =?us-ascii?Q?sWX50UEBNEK/XqxKPlIMm98xfeupfzkhaPTL6GlyngwpJGGiv3yFbfLwCjz2?=
 =?us-ascii?Q?E3cl+p0vOB9rsADFU65iZN5HHquSX8gskw1MIqJNr8urxQ2kSSQSGo6J29Fm?=
 =?us-ascii?Q?aCzErX+BuiYIVM7Wdjhboxu0KoKqU/PoLfHm6Tor7hDyKYZVUKnvhxJZnNuA?=
 =?us-ascii?Q?0YqUzgpggcCsOML1+/Gqma/DQZYxN0YXk1lBk37cG1Yj7+itrAK2CvpeRwiz?=
 =?us-ascii?Q?8WTyNaGCOEVPbJJoWFb6Qc/2dL5uePMspSwGdU8H66t7OHUUpue/i/XbeU15?=
 =?us-ascii?Q?6pzfLx2timBQen+FSSPoGuCEFqXACmQalSEfKJ52yI8Ep6uEw3hvD0Ivt8hM?=
 =?us-ascii?Q?4a156wsWYi+5ZO3LQ2x8tXbP+j3nOTV2ntIAF966m/UkuoD9Yd7Vvh9xXa/q?=
 =?us-ascii?Q?FjGuauEwdOVKajeSxqUNFMPjsGf+QZpCe0Iag7wgoCG95pEVNTCSbJlfpRan?=
 =?us-ascii?Q?RzHbwl2oYQ72QaeJydUlOHQ50gA5MyuO7nPgKw/UPyr8glYAFOQyhr0KzEH4?=
 =?us-ascii?Q?V7NC9jO5/lVVm0+8m2HFm+975l4k2yk6lvr3THr8iWrwgUTrFsjC4U/+siyW?=
 =?us-ascii?Q?tO47oQ5Bqys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?86nD5jkWgWdG2YKRaihzHSUvOnQxtUXRTnyq0//ELpWB5ZFuJM0n1qBA4/Lg?=
 =?us-ascii?Q?EHnxDoSW09TdOMxd6lI10WbKTBIZICYNwAoiUNT8R+ZkZEgKxerWHlLNErFL?=
 =?us-ascii?Q?HTb6iU3UUmwLhLGt+LL0WJmMgvaufEbp0o3CAcexmJ5RlVs58zgXtfXGbB6D?=
 =?us-ascii?Q?xi/pv6a5rzv7zlY0rbz6rzd/CygAyx52RhzqowwU5JUuq3yULLknwjhyNSh4?=
 =?us-ascii?Q?BgU1GhUjXtMEXOKRjqE8LQTeIxSyZVAGudMrQGMofKLWkHyryCWQlyqWSoYo?=
 =?us-ascii?Q?/F3KFKYU6TbpQfQwNZxUuTQw2hIY7TD5AAIM2yR9fGofu86qLAptq+CY4LpL?=
 =?us-ascii?Q?qRb2s88pgCUz+E/nbjWZ63qt4LuGtg+iDKN8POaev+xlJB6z+uW+B5l/gPSY?=
 =?us-ascii?Q?QSFnnVDO3tAoiT8Lnoepo3npm5XiVXyKp9uUKpJznp437CHIRt9x/ETjdJoU?=
 =?us-ascii?Q?L9I81x0+GBgT5Qf829bMHsBmQZwgzRdhygJx54M8z90jC9M4vOWImNxKj9ou?=
 =?us-ascii?Q?vvZATK5FhAhPqwDsaLV/G/JL58e1xTo3y+2sgWHH9nZHZ+5shHbGLjrl4Zub?=
 =?us-ascii?Q?NCBMYc4vfk1c9GyGvd8vzCxd3vsv2Ce5ggebcbSexjzDTQVXgzTg8szPXNvS?=
 =?us-ascii?Q?bVfr4JLwCj71kLp3ROnI3l6rDkpyHY6bSon3nRMvRwumqxvrSxpWq8dD7H3n?=
 =?us-ascii?Q?wFvRutS9XhrD7iJpBG+vHPp6lveN9OUlQKCigYuxrAQZHYIF67pqNTvmQx/E?=
 =?us-ascii?Q?vyDfI0cr9vL3O+cEpezr/gEoY7qH5XnuGvJ90LNPILFo4Ikyi5nHMpmpUgGb?=
 =?us-ascii?Q?Jz0o4cTRo5t51A82crepFT3L5sGAceaoVJrkEtNSTunb1vzJvyi2/RqkaUrZ?=
 =?us-ascii?Q?HkAsFTktP9e5xd0Haogrgs7rPy/4DV/UhZPW05GRViKm0vWypB4HR8CYzdli?=
 =?us-ascii?Q?zGBv0y4OMCX4m9mbAVSOWRJhGYwNisDywWBD8dnlXBQsPgfP5aZRq2AQG3j3?=
 =?us-ascii?Q?rQ5pzYUMIaW/VMyVlXVuBx/43dAMBjraN8E77+jpsrYRB+y9Kilt/j/bLE9V?=
 =?us-ascii?Q?0MLlMJ8vVx4vf97NSxAJEiDuO/xKHuBV1pTirEHQrkpTouZQwHN9tEhFuzPE?=
 =?us-ascii?Q?HttpVRPQDWpoImc9KGzaMbsQKqaPiiMYUSAISoZMOtWd6ryV/pxbUmakWyzD?=
 =?us-ascii?Q?3qNU0Y60ICxZ0aDNkgMt2lcOpZ/jnT0RiEc8/wBA2ErkUdA/1MsjicY5HImY?=
 =?us-ascii?Q?10t/n3oZsj2JWdn3r53159CG5Uu10/c/lMbMjjUMvPyDjoYhPbgv8XJ6IXXw?=
 =?us-ascii?Q?O32NuUE6+f2+hZBdFMqhDwBh0q0SyQ+3XbqX8YaPN7CtqfILfCmJbbqwbc6a?=
 =?us-ascii?Q?0eIuHqRqSuVxikDRPJ2toRIaC/dDWPK5zFxo4xVSSusvbL4ktYkDyl82PmtZ?=
 =?us-ascii?Q?i9DIxNLp+0abn16vkRRfGKjvzozv0ZkvvgWpJWYw9zTzXkN5IwXtHtZeh7mN?=
 =?us-ascii?Q?htMECF1UA7ISXDUlBrYjMc5wgHKXwg8/25sjrf8V9uw4DxV9FeI+iGJjHki0?=
 =?us-ascii?Q?elQKo/CZPZ3lmJRbc9A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac4e616-1dcd-4f5e-2a07-08ddcf826762
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 16:01:54.6342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63FIZpb6wwQmhNSiP08AmjsNyqAojI4z3eTWlBrD6yVI2vsRbua1H53DvnKjLmTo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116

On Wed, Jul 30, 2025 at 03:49:45PM +0100, Robin Murphy wrote:
> On 2025-07-29 9:13 pm, Jason Gunthorpe wrote:
> > On Tue, Jul 29, 2025 at 08:44:21PM +0100, Robin Murphy wrote:
> > 
> > > In this case with just one single
> > > contiguous mapping, it is clearly objectively worse to have to bounce in and
> > > out of the IOMMU layer 3 separate times and store a dma_map_state,
> > 
> > The non-contiguous mappings are comming back, it was in earlier drafts
> > of this. Regardless, the point is to show how to use the general API
> > that we would want to bring into the DRM drivers that don't have
> > contiguity even though VFIO is a bit special.
> > 
> > > Oh yeah, and mapping MMIO with regular memory attributes (IOMMU_CACHE)
> > > rather than appropriate ones (IOMMU_MMIO), as this will end up doing, isn't
> > > guaranteed not to end badly either (e.g. if the system interconnect ends up
> > > merging consecutive write bursts and exceeding the target root port's MPS.)
> > 
> > Yes, I recently noticed this too, it should be fixed..
> > 
> > But so we are all on the same page, alot of the PCI P2P systems are
> > setup so P2P does not transit through the iommu. It either takes the
> > ACS path through a switch or it uses ATS and takes a different ACS
> > path through a switch. It only transits through the iommu in
> > misconfigured systems or in the rarer case of P2P between root ports.
> 
> For non-ATS (and ATS Untranslated traffic), my understanding is that we rely
> on ACS upstream redirect to send transactions all the way up to the root
> port for translation (and without that then they are indeed pure bus
> addresses, take the pci_p2pdma_bus_addr_map() case,

My point is it is common for real systems to take the pci_p2pdma_bus_addr_map()
path. Going through the RP is too slow.

> all irrelevant). In Arm system terms, simpler root ports may well have to
> run that traffic out to an external SMMU TBU, at which point any P2P would
> loop back externally through the memory space window in the system

Many real systems simply don't support this at all :(

> But of course, if it's not dma-direct because we're on POWER with TCE,
> rather than VFIO Type1 implying an iommu-dma/dma-direct arch, then who
> knows? I imagine the complete absence of any mention means this hasn't been
> tried, or possibly even considered?

POWER uses dma_ops and the point of this design is that dma_may_phys()
will still call the dma_ops. See below.

> I don't get what you mean by "not be a full no-op", can you clarify exactly
> what you think it should be doing? Even if it's just the dma_capable() mask
> check equivalent to dma_direct_map_resource(), you don't actually want that
> here either - in that case you'd want to fail the entire attachment to begin
> with since it can never work.

The expectation would be if the dma mapping can't succeed then the
phys map should fail. So if dma_capable() or whatever is not OK then
fail inside the loop and unwind back to failing the whole attach.

> > It should be failing for cases where it is not supported (ie
> > swiotlb=force), it should still be calling the legacy dma_ops, and it
> > should be undoing any CC mangling with the address. (also the
> > pci_p2pdma_bus_addr_map() needs to deal with any CC issues too)
> 
> Um, my whole point is that the "legacy DMA ops" cannot be called, because
> they still assume page-backed memory, so at best are guaranteed to fail; any
> "CC mangling" assumed for memory is most likely wrong for MMIO, and there
> simply is no "deal with" at this point.

I think we all agreed it should use the resource path. So legacy DMA
ops, including POWER, should end up calling

struct dma_map_ops {
	dma_addr_t (*map_resource)(struct device *dev, phys_addr_t phys_addr,
			size_t size, enum dma_data_direction dir,
			unsigned long attrs);

And if that is NULL it should fail.

> A device BAR is simply not under control of the trusted hypervisor the same
> way memory is;

I'm not sure what you mean? I think it is, at least for CC I expect
ACS to be setup to force translation and this squarly puts access to
the MMIO BAR under control of the the S2 translation.

In ARM terms I expect that the RMM's S2 will contain the MMIO BAR at
the shared IPA (ie top bit set), which will match where the CPU should
access it? Linux's IOMMU S2 should mirror this and put the MMIO BAR at
the shared IPA. Meaning upon locking the MMIO phys_addr_t effectively
moves?

At least I would be surprised to hear that shared MMIO was placed in
the private IPA space??

Outside CC we do have a rare configuration where the ACS is not
forcing translation and then your remarks are true. Hypervisor must
enfroce IPA == GPA == bus addr. It's a painful configuration to make
work.

> Sticking to Arm CCA terminology for example, if a device in shared
> state tries to import a BAR from a device in locked/private state,
> there is no notion of touching the shared alias and hoping it
> somehow magically works (at best it might throw the exporting device
> into TDISP error state terminally);

Right, we don't support T=1 DMA yet, or locked devices, but when we do
the p2pdma layer needs to be fixed up to catch this and reject it.

I think it is pretty easy, the p2pdma_provider struct can record if
the exporting struct device has shared or private MMIO. Then when
doing the mapping we require that private MMIO be accessed from T=1.

This should be addressed as part of enabling PCI T=1 support, eg in
ARM terms along with Aneesh's series "ARM CCA Device Assignment
support"

> simply cannot be allowed. If an shared resource exists in the shared IPA
> space to begin with, dma_to_phys() will do the wrong thing, and even
> phys_to_dma() would technically not walk dma_range_map correctly, because
> both assume "phys" represents kernel memory. 

As above for CC I am expecting that translation will always be
required. The S2 in both the RMM and hypervisor SMMUs should both have
shared accessiblity for whatever phys_addr the CPU is using.

So phys_to_dma() just needs to return the normal CPU phys_addr_t to
work, and this looks believable to me. ARM forces the shared IPA
through dma_addr_unencrypted(), but it is already wrong for the core
code to call that function for "encrypted" MMIO.

Not sure about the ranges or dma_to_phys(), I doubt anyone has ever
tested this so it probably doesn't work - but I don't see anything
architecturally catastrophic here, just some bugs.

> However it's also all moot since any attempt at any combination will
> fail anyway due to SWIOTLB being forced by is_realm_world().

Yep.

Basically P2P for ARM CCA today needs some bug fixing and testing -
not surprising. ARM CCA is already rare, and even we don't use P2P
under any CC architecture today.

I'm sure it will be fixed as a separate work, at least we will soon
care about P2P on ARM CCA working.

Regardless, from a driver perspective none of the CC detail should
leak into VFIO. The P2P APIs and the DMA APIs are the right place to
abstract it away, and yes they probably fail to do so right now.

I'm guessing that if DMA_ATTR_MMIO is agreed then a
DMA_ATTR_MMIO_ENCRYPTED would be the logical step. That should provide
enough detail that the DMA API can compute correct addressing.

Maybe this whole discussion improves the case for DMA_ATTR_MMIO.

Jason

