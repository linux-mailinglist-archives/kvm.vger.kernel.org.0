Return-Path: <kvm+bounces-64547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B50B6C86CD5
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:25:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3682A3537A9
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73ED32D7E6;
	Tue, 25 Nov 2025 19:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gz562xCS"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010018.outbound.protection.outlook.com [52.101.61.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7104733345B;
	Tue, 25 Nov 2025 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098517; cv=fail; b=pSkitaU750+a2ncVq2qdPuQLWS2uUarkHDnq0RszRkGpnIMXq+e0d1VUSttVhVLNX2c6K0Xxu5faDv9HCGdXoBNM2Fiw8SoGsuTJPWkORG9+i0CZ90M48qpDxGAdtCLGVmLgPRiY/7s7bk+WkiDKOpa/SWe6yNo7Pl2VrUux/h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098517; c=relaxed/simple;
	bh=oGzcHpbzDnDJrrK8zOqVQQrockqqBul8/F5MtPXh0a8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rS74gG2WjbDnCO8iYyq/rNvx3B+YvpeDAopkQ9EnC7b8MmVnt8zAnXei22U4SNuiIbK5h0COxMDnJbgNmXOi8Yykqdy290X8UGwuYDd+1Vuh2EgkUQDcxYJquflAruukAo1T0vYBLtf//OvdEE67eIdLyDvE6JnXUg5xV/vH+tY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gz562xCS; arc=fail smtp.client-ip=52.101.61.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G0XbbfzIPirNH15z4A7Vpai7UYEcrY+0lZNHraGvjtTijMTwyNDuQDs+RuMoqlvKVwwSszNXmhvTErex5y6IHv6QYGg9z2+nj2kqCyvAcGpj4OGkqggIRpYFesxRvv4NS/8foagMr/PbSnF4REctgpMS5vfpoOwFhnwIMiuXmiXqnbkxsusrcUh7jPe0ln3HkuCsu+0EjMDXrkpsGE06nEJkePw1i8hxAltAWLjP6p3hqrQyesO7LfD+dATt+Kw4SMa0dhlXic3ziy20LD6CynbPfRDd6Z4pT7lfUU+n70Lx9I5stcG1+PB+09547mIrTFAASX9j3wDsc78O8Xj8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djQIZ/Ou+LLZA13MGZnqQmqqZsHF55Kz4GIeQAmrQOU=;
 b=hcsmN2YiwP8roIngdKej2PN+Ivk9QaSGNf9KaIwFk843xqEf7PdOcv+10IjyBrb6U+YCsLkWqna3BlEuBJIksCJUF+ui9Wh4v7deWBV4ms4u4IDyt2+QKwraILvCLZsVMJSGAcAm0jwdKM+xtz8GeuzOg8KDXCsvowVgZ1rpd9YQr6olHSvFbo/gVjlOV/ndIxwdagpXFaUEAi1G46sNM+LA8hzwdDDhA3ZdTDRY9RGubhigssdl1tsPXC3IgepTfFd8agyECtpwpV2qUJLiiPzP1OJmc3ifS8E0IJdq4KvTFhmBudmQgVP5NalCK5eBZeBe7wVD53LietkoJbFYlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djQIZ/Ou+LLZA13MGZnqQmqqZsHF55Kz4GIeQAmrQOU=;
 b=gz562xCSs1iUr0hqAxdre5Vnz7c3erBK5ZPe2TIIRwZg7iVKyJfkNgtfZz46xZSLSzuX8BHGEYGARoZ1YwN4GYNBAj/fjVIt/ZusgIftu1CI3m496EU04AQHJYpTUcavvl3XonfabdSDQW09YorFwx6R3WsZ2aVBBlwcKaUG9qJ9B/JITM96hSbz4XrX7gi0Q5VOMTpNMtWsHaD6a91kC75E//HT5WCsId81nQdkqwbgwn2v/W3X8HsHRuvUncXZ2Lj61lCYq8LWg0og0j6eZ64RnRnrPApqowVrkgC87kMO7dzIrXJbOdaPN5g5pyxR/4piaec40JwEFAmwqRFUjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DM4PR12MB7552.namprd12.prod.outlook.com (2603:10b6:8:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 19:21:47 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Tue, 25 Nov 2025
 19:21:47 +0000
Date: Tue, 25 Nov 2025 15:21:44 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, afael@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, will@kernel.org, robin.murphy@arm.com,
	lenb@kernel.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
	helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v7 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
Message-ID: <20251125192144.GE520526@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <71f3af9b3c1cd02eb92484d3d3e9fa89dbb2a928.1763775108.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71f3af9b3c1cd02eb92484d3d3e9fa89dbb2a928.1763775108.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0175.namprd03.prod.outlook.com
 (2603:10b6:208:32f::14) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DM4PR12MB7552:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c793da5-9c5c-4a66-beb7-08de2c57e037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aTTnE7pdcFTYU47kAEfiFLEn5YLv5TorPaVH6rqTWhevyCclACsV5pvupua/?=
 =?us-ascii?Q?j5Res5Joq13+zy09soklTNfyvw31+sqwIeag6Z71HR/eqvZEw7b/Sb8XZ1/t?=
 =?us-ascii?Q?zozMKfddZeDUVeJtngXxN9bYqgFTTdYcH1B1RUKdcAXD1IR6Ml7hJJ0ln3DP?=
 =?us-ascii?Q?+e0+aSF4tp5QRIM+oVb6S0yRYMBGEk9bm9T6facvYpfgoO9r3va6BNE8eW1N?=
 =?us-ascii?Q?ypbfs5VFFCiAUSKjBYEsBadq1CDlB70lYYM4E5wbU1gLi2cINAPczo63IAbV?=
 =?us-ascii?Q?IefE8nmo2znigLgdpWB0ihe6a7OpPAdwgsUMF0M1S/O+UWCBKj6wsA68vzz7?=
 =?us-ascii?Q?xdvuJNCF0Is1VJHfBF/XbVrqYQbtY4JjMlxgB18tSjX8xDKRpfb1ip2k8KuG?=
 =?us-ascii?Q?UK7Wo2FMNPLpMxyne7HqE2xOO52VDOfC/AXpIiq4zO8wF9aBtOM5yvRIFKGl?=
 =?us-ascii?Q?T9k16ypEmy5M8xhWzk2v4nbB1DHi9Yc0Dnz4ruwxMk3fJKf+qt2PiTFsUj1s?=
 =?us-ascii?Q?zrEnAnhba63L9xQ/yj0MzhdtaJ+f7G70tYMp+OT74WZN2aPJD28ebMWcAlWB?=
 =?us-ascii?Q?1eqanQWeTO/hy3txCylusXU7siL2I0GUS68kWe47pfVjWfvmJNpGLOQaZMCi?=
 =?us-ascii?Q?Gc6hb1893bC0I5Ow8GphYpNWWUf+Fe3Wzy8L+m56vASUhGNsmU53LMCuAxEF?=
 =?us-ascii?Q?Qi+g7ifBGbc9hJB5/KRdgJWAb8D7sg6/Tr8luqHmgsCe0t5Nsb07LvHDwQcY?=
 =?us-ascii?Q?DzgwaW4hr0RRHbXqac6QgR5VsYhm6RQn4W9UlLLrx0NY4xmwqFOZe3s5xWeJ?=
 =?us-ascii?Q?SBnFwSykjMYkK6ar+4pBHWV373qapF31oRaB0Exj4oupxKNrqtYII4quM+WT?=
 =?us-ascii?Q?4VdlPjy2EJ1rMgyxQFURIco2kGBNu4pjhcTUU2MuldDGmRMn/TxAyKuJEGT0?=
 =?us-ascii?Q?JgtUVFTxBBILrH5/LrVb3t/r0YttMOk7GtkitYKjDXnRE1R5JVGDu+/c3wRu?=
 =?us-ascii?Q?Brbx2STMW5TRZyVDmACfHkAcZPssi0+EGRymJNY09G1C6ZKIiPTqMO9a5Uuy?=
 =?us-ascii?Q?B7aQQI5LPCtWrlsdp/eZqGW0fiLCYziDqaux9UCpabUNJCzih2JxNyI8SKn/?=
 =?us-ascii?Q?0fDH8PYnEcpHPBABunyjiQTaFn/LFg2t5M9X2e2kBBYX1qOo9GQPtdKJ7xmZ?=
 =?us-ascii?Q?iSJILmzcXqpm0zz/vw9G+umZ7xl3ZEXFmNZWGqFLChuUGCJ7qrkaQwbqxk6E?=
 =?us-ascii?Q?2s3+vA17fleWpmR7JOyAnJOQfA6MFRtavsCNM11D4OWXefRQ/mQr6meDY+HT?=
 =?us-ascii?Q?javkdH5HYuYAK3RmkrxAyBfusTsu/znuEwNhItol/JU2SKXSgfY6wWYQjBRI?=
 =?us-ascii?Q?t/14u6Pu0kC6GVndZs4kst4AIe3eQjVMaNeK4Hoxukf7VH+4H/O+i3W7fMCV?=
 =?us-ascii?Q?1eAmh2NyzMhh8roCTumduOxLbjvuusoi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tht6KlZjfE8tnXC7IIOH+Rmb2i7iS/Lav9yOFXZRVFK8hRO9BymGOqJ5EwwC?=
 =?us-ascii?Q?CVQW0hgb5/W7Lx09GK24EqUNHmZj0ZKPy00CiY0r0hwIL+LwOyzM5riLmI+9?=
 =?us-ascii?Q?TbDC4d6hqBgVgxUszFDr4ZkiPwdSIPXbA39xjFkpvgS8I+nVWuBqT8Nn/Gsf?=
 =?us-ascii?Q?AwVmeauR3HE6bOB3t6EyEgmNI+VJtxfpDgerpOx7MWXvh6QHDlyH2WAfrU5P?=
 =?us-ascii?Q?tc4i708yMc4zDLPdglmm67CCR9A9jVhXP/GEz4JbZ8i8tjIAujg6AeTfV70Y?=
 =?us-ascii?Q?6kEPOHtxk1m3DUGYxxem8v0lg+CQwaS/o6QX9B8P62yBi0SZ4iJXDAm1m9V+?=
 =?us-ascii?Q?+ZprChIJ/UGLqJltIONif16pDhuaqpLW+4YaEv08sHNbqMoCRXAT6deLr6sd?=
 =?us-ascii?Q?k/rOcFmyjNRG/BNdrTqhJTyjvCdGfbhFgaMEp36SfTQkondGI3vi0SI/yajP?=
 =?us-ascii?Q?72Ni4twfOggfrcxMByUSYDn8lHX/p8RfRewljgdSLq16n/v+TRS5hKykvAJF?=
 =?us-ascii?Q?OF+4ckqTjvuLUayHd/UjMEqOMZtTeiAbYQKR2oVF4gaMQkCT31kijrLTjAuh?=
 =?us-ascii?Q?RLp+1tusQr9BKDhfbdmIQJTnbt5mupbTo+E1S9rBzbitTX5mMjDM6TNbxxfY?=
 =?us-ascii?Q?Si5/+D4j/S4LZS4SZJnUfp87HPTZuOCCF3b19ghXhKY/zMWrgt7aQlrKk4P0?=
 =?us-ascii?Q?9NRo0hbghRjMn9AA50XdYXfUIUrylpt9XWYWqz89BZiREYKRp3nFgenqom1T?=
 =?us-ascii?Q?o5JhsLwQ5BazCN2nUsfhdQqwqMN9xu+uDk1bmSAQqOu1A2YpaWbO78tFrezi?=
 =?us-ascii?Q?d7ipVmjcDtYnR5ZgNYNoA0RItL3aP9YxzandpgpOcrpIiptGoC0/YVT0VaQ2?=
 =?us-ascii?Q?ipxmBAZuX27PDsfQ1+A+k1QASeN9cUj6jTZ6nSwH3xKfyQiwzBgWHKyPL0CJ?=
 =?us-ascii?Q?IweELsAmEYgbpLuQnGE9XgseBfNjOA6wWGhYtyRdpxgg7O0FufeEjO5qsdWl?=
 =?us-ascii?Q?MyzaAnldcZRF1BFPs8MeopgJ05FeTRJDHmyh/PSQikVjq3Xjp6QV2K29L4mV?=
 =?us-ascii?Q?T9HFa5joRLhYUV4Sb6NKjejbAqLEuLFfJ5r9qOoBz52AxpJv0fEXQ09OZ4o1?=
 =?us-ascii?Q?oSf7avL0YdUTJTemKB58HxWxmzd3d2AhWW4LAWkHsqMX9+wnIIf1daBNA4BH?=
 =?us-ascii?Q?dY8v1x3Lt3i7KIXgZ9wUY1rWmYvJfsUFLbwFWODbHxSYMlQevFNodTL6mxZZ?=
 =?us-ascii?Q?jqV57Y/zmu2Bc5c+BOahgKCHan0oA++xcAwD1DDr1SMMDcpt1/9a5ETAStGp?=
 =?us-ascii?Q?SbPYe2sbtvANasQfgR3dTlJNgDRMLw3WhGBnwewMOMGMBlqPzzG0R8ZUxVif?=
 =?us-ascii?Q?pRvVrqyHQVGBXHptPMeiGVVt4szYeSbw1B3ZMqNxzCKlqGD5L447oggaAauo?=
 =?us-ascii?Q?gkCfqviiaWGDRdJjwCJNb2732Bc3uBW+cS5bTt0Eza45VE4io66GObbrLen+?=
 =?us-ascii?Q?VEQWBw2qOcvsQnLFZBaw1kJAHDQBGaZWrf8MHr8EmX/ueWilK+8MN1oDLuOQ?=
 =?us-ascii?Q?UX+NnFv+9ivi2lTA8Qs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c793da5-9c5c-4a66-beb7-08de2c57e037
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 19:21:47.1406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkf4CM/nJgLyysFQf4sjWLFtNixh6m0y/fabGWJumWvEfBvf6qTqpZ8wAl5ZXklm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7552

On Fri, Nov 21, 2025 at 05:57:30PM -0800, Nicolin Chen wrote:
> There is a need to stage a resetting PCI device to temporarily the blocked
> domain and then attach back to its previously attached domain after reset.
> 
> This can be simply done by keeping the "previously attached domain" in the
> iommu_group->domain pointer while adding an iommu_group->resetting_domain,
> which gives troubles to IOMMU drivers using the iommu_get_domain_for_dev()
> for a device's physical domain in order to program IOMMU hardware.
> 
> And in such for-driver use cases, the iommu_group->mutex must be held, so
> it doesn't fit in external callers that don't hold the iommu_group->mutex.
> 
> Introduce a new iommu_driver_get_domain_for_dev() helper, exclusively for
> driver use cases that hold the iommu_group->mutex, to separate from those
> external use cases.
> 
> Add a lockdep_assert_not_held to the existing iommu_get_domain_for_dev()
> and highlight that in a kdoc.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h                       |  1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  5 ++--
>  drivers/iommu/iommu.c                       | 28 +++++++++++++++++++++
>  3 files changed, 32 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

