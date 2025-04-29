Return-Path: <kvm+bounces-44760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF1CAA0AEE
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EE317ACDB7
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CB62C2AB3;
	Tue, 29 Apr 2025 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BX2BCRWM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3257E20969A;
	Tue, 29 Apr 2025 11:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745927639; cv=fail; b=oq1hQTdSpBjSKNvmwhLYR99qGHSX9OWjlO+86NvNkCQnSjqaUDrJ84oW1DLfYMvLEgee+lRKC9VW94sKMGdKmXfLfpuyA1fp/BvpAeDxMRu9xkJpiieQpm3IUOV0M4/sUhyPXOLc5QQzvHYThG2Xq8rT+/A55ME90CB65fizeeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745927639; c=relaxed/simple;
	bh=e0G3aqGKJS4HJV4ryjQvt216LRtg97h8NnYHn+7NO/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hZqdxcC3yr+/OyyyH5dvVgXspbw5LTwmo+HzEQSlyWOBRgzy5P/8loJO4a6CZe65UJYI0IJwmdry4fCMccZULPGGO/Wlb78MDgKaOloa1V/xdchLYlKFxJks1uXab7FBUYRUxNiE1J0tGmAOwPEagzcG6Git2VoNepEnFv0AbRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BX2BCRWM; arc=fail smtp.client-ip=40.107.93.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aHkK74+f2TvAAdmxtPjoqPaXr7vSbN7fyEARy8J3Knh0PCjStXQ4RsvpG4mG0PxvJymHZj0RqBwcEDcrPGAqPM/rTMOXdO5Q1MYZpx2VTqpvp/0lcDGPXI3gbZH0OWEhQ2G7Cgt8hGAxuHSiG71OZQZYLduxtogaZUN5OrRGKMPjJtb3NmuaaKr8i9ax8o/K8+vZU6JMuzlTk+FEdKHMXk+2vAlEFS/Ao1YLoZ4QemaUAT/BsMR2YVyTvg/2Vjsl20MRGT46TxNR0OsR6BUlfdvUNiuR5iNRoozllxQUuCGB3jfSAevEuPkvMBbdd3r6CAfa7BLxcyFAkxDbmKFPvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8fEZmgm5M6RSMETKWpbIYtmCdRPp4M+CCmDk7MXSVew=;
 b=xqcNqovjLqrIWb9viUNxQUqSKzUQAIiLhPpVhS9XlVAqHDOC3k8/r0tmyR6v3B5TEyUE1Oja5N35lwrmLpG1s9P+5XXh9e69UDJKaucDiNr/AiZQhvNTEWj+eWisFHw/b6l4JUf27iUO7CP3dHvDqYJ9lV+3Y7k154YK/o/gl0pKtZ0TPiiZpkWvC7oxX4xcp7YKbHnpTpBJYUo1HyXv4X41Qell4wDXbHfxKhqdd7FUfd2XRimvheWtH8Nxfg8vUUWVRGrrtzrLb0mp4dG5l5OAWDKvPQOxojzMzBZhyDxvhuLNBElOP7KXiTHBl729TP2VE9z6L7FWIEZYW7jzeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fEZmgm5M6RSMETKWpbIYtmCdRPp4M+CCmDk7MXSVew=;
 b=BX2BCRWMJwRVmNr31YulOR1zz3zXPrht9kYuzu7vieIGsOBOgZSLuCofUkkxRN0dWNLz/EezF6ohSZh/xN+sNtUVWrhHNUnzI5P7T088RfES/gYwmUbePrKhkHmB+RA4AQmIAWHT5OM/5chpWWNjfh3zrC6pkWPxZJmUE1aYQV9xxABEXIG9Z4nUpSJe322xo4wgb5ZORbRaVfmNE/caZmUYym1ZPiZRJ6+/eoN5XH+DYSuA8kqyxuyT3vJIBj9WSVoG2FEArDPRMdaufNu0u4ZXQvReNowpUiOlxbgbzEzqcTGe+JlkpR5iu/zVosiL64aVk5X5DiYgW6bFv3dfaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 29 Apr
 2025 11:53:56 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 11:53:55 +0000
Date: Tue, 29 Apr 2025 08:53:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v10 03/24] iommu: generalize the batched sync after map
 interface
Message-ID: <20250429115354.GA2260709@nvidia.com>
References: <cover.1745831017.git.leon@kernel.org>
 <69da19d2cc5df0be5112f0cf2365a0337b00d873.1745831017.git.leon@kernel.org>
 <f8d86cde-d485-4e5a-a693-e9323679474f@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8d86cde-d485-4e5a-a693-e9323679474f@linux.intel.com>
X-ClientProxiedBy: BN0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:408:e6::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL4PR12MB9723:EE_
X-MS-Office365-Filtering-Correlation-Id: aad3d614-0e59-4958-fea9-08dd871484cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xQxr7PbUALSAzpW+8au/fVr2/1eTM4HMKyqQglZ7v+/SpDlzfFhMNvDB8T8+?=
 =?us-ascii?Q?LsKsaABb2ErClFVxRXrJ6lkA+5USMIhjWD86qBGXEe8qwfyskbVuR9hUoibZ?=
 =?us-ascii?Q?XnUCwvIiASurfL5IOgjiDOgJrWKRf8qLBbVXH6H90UxXK29/qvjJQWDbqpBK?=
 =?us-ascii?Q?EURf4LkMk5np9uLm1XqNoRBW/9RvaC9CgzmADgSSFOmB8Q0XNki/VEso1y7H?=
 =?us-ascii?Q?biG1V2ke0S9r21rfcvPHYYZ8XL/m7i1I+WXJk66V0yJzg8d0dNv5sp++PzCd?=
 =?us-ascii?Q?6+LIujpX/trAbxYSm7hM/Fcd0SRcHs2ldN7BUClu3BJ3oMJo5G4MaLq2sPau?=
 =?us-ascii?Q?3KjQcIUN9i55HWHIgBf+cjYG4SSiDy9Po5qQnVosCcJzVZYMU4MjMy4q0hzV?=
 =?us-ascii?Q?f0xyAOTgEKk+wha0w5hpPQqQp9NFapuo3itqThv7FI4xClmwowIUb0VrX2hw?=
 =?us-ascii?Q?vTatbUfA4s/wwzsBXGijmEdrYrMzM0Sn+Vb7HMTDp/qUa2UMBYCk92bwp+az?=
 =?us-ascii?Q?qineCr8ct7FL27Hl8LGptzaxqoOGCqyEQ1Q0w6BjkMrUk+42oK2V2T+by1Gc?=
 =?us-ascii?Q?XXcHE+NfEpx/8j9IK591sIIZ1NMel2hzW6AvrrJFvGw5E1gdHMEYLlpphtsD?=
 =?us-ascii?Q?pouGGFMwGicxlBwEPnhQvW9BCtEUf7wiHM0kBYfneSFfJCc18FiTTCBs8an4?=
 =?us-ascii?Q?XY5ioSSW4QottHkcJjS0hwISb+jqYT9Tj1kdwQZEYxhcoSQhoSu5+rn55VVG?=
 =?us-ascii?Q?9dRJ+j/uSFmvrfZ4/R8OkkBz5zt9EY2stBUZ0nbSBoLskf+1pmKbFDlpZ/tY?=
 =?us-ascii?Q?OyKicC8GtkCe9G2a7v7t4T5uPj5BGB0cCh2j8t7LfpvOFiaMcrCAhphNPBJk?=
 =?us-ascii?Q?UNRUJLFwJGhHcmPJRRUAVHxLUuX4Es6SdxzWkRjswhDqf0mVKlymhpWpM56G?=
 =?us-ascii?Q?MRkSjmYeuM6+tSHb5Umy1USbXI/wbnfwAV7+D+hmD+MMPNYHhd04OqDKHKPH?=
 =?us-ascii?Q?04MCFicpUqcObuF5x8GZYoUWicQXYNk40S9BJjrHKosLBAf7yiAE35FjXLU+?=
 =?us-ascii?Q?iO4bm4XKeFsrbCUu2aCN2UPLXhpvmlnAq+2eNG3At8p4MIbHZ5C8wiIuSF5Q?=
 =?us-ascii?Q?CYqdcKSTTqgLu5vk0HNVMlpj+cvOwCM6h6RIu8NMaw+KYjuZpCrXSYqz1dRy?=
 =?us-ascii?Q?kHlnJs4EyYpIwnjQVN8c0TrmdujhWNdiUjA2B9hSEMdUMYXougkBBCNmXnK+?=
 =?us-ascii?Q?hLNpMgR6SYmfhUA7gOp0NLio+Ir+BORNeKF+RzpEOILOJlzF2xvOAuK/VtFX?=
 =?us-ascii?Q?mgj67R1glaToAAtBMh4KBuxuSf1EJ7yIxweHItnByjxahj4iyxa4HPl5g+BH?=
 =?us-ascii?Q?A5fx0kWHp9Ryz17y8h+3ZZFCPfDPBA/6E3ooBPh9Glk5wI+qxREB6C4ZqpxT?=
 =?us-ascii?Q?Y/o7qM94tlk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wC3FIEAsz2w7nfXfG3Y9QutckGdvDqtgvT10ArxZrnBzJJ7IXU/PzVQsx7JW?=
 =?us-ascii?Q?fFZeHTa4SHWeclfkOJNBHFM2crgeD2O7RC/HS8YrPYJvGd3Jvxd3NzFdlSSU?=
 =?us-ascii?Q?s7C7UwSw80lBN9Oq8n/uHwoFMu0afo6BNu8NL/+pAx1hvmGzjhHjLYREZEyU?=
 =?us-ascii?Q?FebclJ3xXddoe1DAM6FExjVPy7sa5S3mTgsOEOyWF7JPkg6eEASx0cvAp7Fi?=
 =?us-ascii?Q?+xMaQGNkN3n44Bhv9ziHH0h3mqzxXspNe68TVtUwHw6pSV5Vf58y+fbsLH+e?=
 =?us-ascii?Q?p9kEtQ4aZhcAR3l81mDzfTwPPgYXYhbe9byQJ+jTJZyI2GftlrhdCqRESZ4r?=
 =?us-ascii?Q?TkzuzoJd6Fi1zYOkcUJV52K6jhC8x8ndvY7BiWugVGDrkbX9Gj5BSo8JwmN4?=
 =?us-ascii?Q?C/Emyx+70hhQYTfX3bj+9zs1MleKuaLRP1Ski4eQydIlqQyjb7WGkslDGcXV?=
 =?us-ascii?Q?E5u+I5ASOTgF2NELBLCP5ZxnrNQzwkViKTsq5IQpIrnGce4vdcyvs10A3e3a?=
 =?us-ascii?Q?ELxhtFEEIHHl52HeloAMuoxibCP9wccEpWPIQqVpX29i8+TwfmhREmcAmsur?=
 =?us-ascii?Q?o3FAoIk6fGEJcu1us7+14ObWMmq9vG5JG3yMAxhsuctSbimH8t9fpqZPv91g?=
 =?us-ascii?Q?XVEcvhOPT6WDZqi+50kU6vLemgqDF3sTOUDTNtJBh2LeeaPpsET586eTlTIt?=
 =?us-ascii?Q?PhPF9o4oFdPUQpAPxiM3QA/EQNQ7MwSyAeiSJLH/CI9iMoIopNM3uE/+c+mg?=
 =?us-ascii?Q?/c8Is05w6XIznajchzaLMt45TT+ydBIzjuIHLMSVxKo+WqNSL6JIEpXQm6vb?=
 =?us-ascii?Q?qLJGalJKUMPqRp9qkq8m2KnbmfIdSABHEKjW5mxDgAAAysIY+zSMHDv5jZ7L?=
 =?us-ascii?Q?VCyhEghaOhNd4gwzvp2t9XG5EIVUktp3oKDyYjAs5n2j3wLdaf3vt2JTSpDR?=
 =?us-ascii?Q?rLCGXVqG/eHi3CGhILTYs9wPR7SGXnFAiUMzQHDyfH5Qx6RU1UsI2bO0stwn?=
 =?us-ascii?Q?EmnX6Xkc0hnJKtNg1Ms9pTYRqZt42Sylijnuj8EmaT0vQhvSeKr1KLEYcJOf?=
 =?us-ascii?Q?WuMe9G9NNNtXX69mg/Ni7X3DnUdAOhK59421Pnj6+8Y6Pcx/+1rBVOX60uQY?=
 =?us-ascii?Q?26IWx6ExxXIzKOIQhHBOQaKrGlQnqZf34h/eAFKKKpIYNV+IDn3xhZ/FQVNG?=
 =?us-ascii?Q?VSoO0/RvoMeYWmybkgofExjLUYxZC43UBhDlOyB5EeAq2BmQfOWKtXiqsVzL?=
 =?us-ascii?Q?vaHNzKfqWnQ7vhSjTTFikLd9jWwq/Rr5SAw1UijcDgKKBo7geKf+CCGy978T?=
 =?us-ascii?Q?OtbdJ4xlQU4RNEMS2/FQWW/x+t3ueUyr+q61QrUEUZ7jDac37zWg7jThifjM?=
 =?us-ascii?Q?6jE23jMlBAUd1frQvffgPu2zWqu2Xe9pSnjea4xrthKtCIQCoPAZG4bKlxR3?=
 =?us-ascii?Q?aSZ7Ix6UgWF/hpkGlo6CPxWS38DJERZ3eIRFT6O54vZuKiQHUVXjR4GVzRM6?=
 =?us-ascii?Q?QmGUJgYi86vp5/ZesJFdwTXBUglM+MRZt4lX8nKigd0FvP3oVGw9uXj4sySt?=
 =?us-ascii?Q?JbTygTkkInjUO1J6SvNd5z+bUy9N4qVr94AP7tlM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad3d614-0e59-4958-fea9-08dd871484cd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 11:53:55.6003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q0j5hm7cJQm/YijapTFank/q+P2iDLcv55P2edOp/4Y+cgQK4R4AG59xlTVPLS8m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9723

On Tue, Apr 29, 2025 at 10:19:46AM +0800, Baolu Lu wrote:
> > -int iommu_map(struct iommu_domain *domain, unsigned long iova,
> > -	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> > +int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
> >   {
> >   	const struct iommu_domain_ops *ops = domain->ops;
> > -	int ret;
> > -
> > -	might_sleep_if(gfpflags_allow_blocking(gfp));
> > -	/* Discourage passing strange GFP flags */
> > -	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> > -				__GFP_HIGHMEM)))
> > -		return -EINVAL;
> > +	if (!ops->iotlb_sync_map)
> > +		return 0;
> > +	return ops->iotlb_sync_map(domain, iova, size);
> > +}
> 
> I am wondering whether iommu_sync_map() needs a return value. The
> purpose of this callback is just to sync the TLB cache after new
> mappings are created, which should effectively be a no-fail operation.

Yeah, it is pretty much nonsense, the other flushes don't fail:

	void (*flush_iotlb_all)(struct iommu_domain *domain);
	int (*iotlb_sync_map)(struct iommu_domain *domain, unsigned long iova,
			      size_t size);
	void (*iotlb_sync)(struct iommu_domain *domain,
			   struct iommu_iotlb_gather *iotlb_gather);

> Furthermore, currently no iommu driver implements this callback in a way
> that returns a failure. 

Given s390 does weirdly fail sync_map but not sync this needs a bigger
touch than just that.

But what I really want to do is get rid of iotlb_sync_map and replace it
with iotlb_sync, and feed the gather through the iommu_map path.

It doesn't really make sense to have a special interface for this.

So I think this patch is fine as is..

Jason

