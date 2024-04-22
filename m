Return-Path: <kvm+bounces-15489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2315F8ACC59
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEE7A285BDA
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 11:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538BA146A76;
	Mon, 22 Apr 2024 11:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b+lPfdhW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2080.outbound.protection.outlook.com [40.107.95.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9BF146A6A
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 11:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713786771; cv=fail; b=A2qoz9gS7/kcYEchQsC4kZXskiwC5ezhNQcdz3qHjZ+1UZK9a6L6rXco6H2VgrGd/8shbFmMsFFFa/Jn1lMlB6JkgCn4v1ex+ckvi2LWY6r7OiRTVe1D/H4weK3f/4tLUTuPffrf2N0rK+Pow/e9XZ9/uZeiDNEdV4fArsSb9KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713786771; c=relaxed/simple;
	bh=ExCuKiWuRXfv54fAdSyUIbzGt8OIcjkPahlvfRBheVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kc+8ozJZUe0fSx1PLmgslA5lZKeuhNImaKbtmObbSMFtFWwdArNXymVQ8WKAMKwz5uKWHc32ksdkFa/yh/9RvNsrHWuRt8T/rDHBIpZLv8DIlnCfzBxIT2eb51FtoOP6OMBbx0WwGzHS4MgFLqcfeeDKuHSKpAe/N77BnLWMmoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b+lPfdhW; arc=fail smtp.client-ip=40.107.95.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYIf4rfGNpNPVoZJMOOyuXKvKCwGhIOxCZOi6+jiZhb8Sgts6LeleLJghlRaMDUzoy8jcptmYMRSc61TtOsWU8HB5sUApCTAjFyiImotAt9VhvoWzCAyTC/BKgmNpRvihlSbEA5kSdqslwnsNaDUlkfCWaQWTiTnnrZ3QsfxYAnGR2kz7kqKmaIxsnjR75vlChDE5HiNHd9cxFNUIuo5OygGB+pGiV5sXsM+VRJCDDHFiookoGqAuSpaZx5pTPSHcPjndW3A27DNpWslwRs5hzGB7aJaakT34lxOLPvh22UQ4g3PTH0ZPsBSnQXn1Eoqba9UwBhEBXzeBL9Z6ylkog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wPaIirBj/NXo1uMC4LwJM0kWsbIldgoKsfZhQnxCww=;
 b=D3FplMn6GDl4cnVxHLTfz7iBSLcoHcK7zJWewMnXLA7GJ1NGbi5p9cGTz2Orwl92AJFWGZ/T2YHrGZ+rBRx0300KxsQLgt6qNYAV3qk7JocT7cZK9XnjCqdIqMw3Azy81b8mfEOV6XizoKWgdqguIMevy7hbDpsGRYFKTR1YJtRPtI0vFyQZGvdglGlSOZZtrpV8uoyGTZj9I8veBzKZh5Hz7de8pocC/EMOLY3XDftyBacMCSYXWr2AbQKi5F1Gms9VA5fdktKZcpdQU//9MW6ArxiI0zI6500sIQ+RZ7jMvZUJLGRav4wpIyz1QBKXXpGaRXcsVjqeZAz6m9uEjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wPaIirBj/NXo1uMC4LwJM0kWsbIldgoKsfZhQnxCww=;
 b=b+lPfdhWbbotQ4G+uRVIRio1fJw6GQi+rJCyVemGowNcnT4CH1N5TYxcByhXWqKZc7XUOyuWvmIva05l89YmJP05F7yaMZIgiIrGUyFHa9HlbUEOWxg/0PK7ku6JokDlu50NEYpIu3K3BbdyNcNXj16rDgOSShmXHUEkKFgASNk8+bU5D0yiNzbaAOVYqtL9oh8e+CTs32S38DjK/BSTXlJD9mNfZVJ4pNnic04HOoxwmVF24xRfPLq9sNWhej8NuuNp7Ec5qaeHjX0B66mPqUmRKfm4z3sS7k15VYTqc1BE/1fvdYqQkNLoiKVfsMjWZlyQ2O1/nqD1hYNl2dmSiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9266.namprd12.prod.outlook.com (2603:10b6:408:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 11:52:44 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 11:52:44 +0000
Date: Mon, 22 Apr 2024 08:52:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 05/12] iommu: Allow iommu driver to populate the
 max_pasids
Message-ID: <20240422115243.GA45353@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-6-yi.l.liu@intel.com>
 <ef76c9bc-cafb-43a8-9b1c-f832043b8330@linux.intel.com>
 <BN9PR11MB52766AFD83D662181A4AE09E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <fa27cf95-1be0-4d98-be72-8892f9cc003b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa27cf95-1be0-4d98-be72-8892f9cc003b@intel.com>
X-ClientProxiedBy: BL1PR13CA0182.namprd13.prod.outlook.com
 (2603:10b6:208:2be::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9266:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d02b8a3-cafd-42fb-db6f-08dc62c2b90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lgGtFe2LwrHfHQovpBGqOkYFFGWpdEIwIii5lHq87qrSeBmAkyT+CBDDJhx/?=
 =?us-ascii?Q?Q/jF3QOkhmk/WnGrxAhSs7Lvku2Bb3baz9wVpY2Hl56lLnktenTwLOZypCex?=
 =?us-ascii?Q?ok0Y6BAonaQBmOayDBJoYPHnNVuMLrFeKoycljj6U3KkQ8Qb53X85yHfPTwv?=
 =?us-ascii?Q?uya0Kly1LtK7/8RyI/TlP3zOIvvA2uC0HjR2nuJBBv3/i0NaFa+JrgkckyR3?=
 =?us-ascii?Q?DQ18V0IprgNQg2yAmMYb1+EFK4naMtRsfkoRe2FXlygm5cXVv7+SuWxORVIj?=
 =?us-ascii?Q?WquWygr8hiPOyLWQMC1kjFlMj2BYzqTfhT6grGu+mIfD729Kavaz528U1osc?=
 =?us-ascii?Q?uWjkf2xrwQFzExQwSq6ud3sgHsQ309iYxn9/z9XPCzLvWpUGsP7eR+2dhK+/?=
 =?us-ascii?Q?TV5hN60azcqkWpLt5jO48LXUAvW++el/EiZEz7uCJkZ5SlMjKEagYHlhU7sC?=
 =?us-ascii?Q?2Lz0b65V/XwXOixf7usEvMiAVs7Yyap+7cjEecAYoeqdRkvCNHMs5/GVAmOK?=
 =?us-ascii?Q?nnheai0GNfHMWuC1651mmWYDSDA8vmj8X057ZZWlxtfTFWzwyWErvXxfvhD/?=
 =?us-ascii?Q?PZkbHKTFZHUWKQyJFebY21LOdem5Em5oMr0IR0xK6zg6aQPe+k+T7cj5lxt3?=
 =?us-ascii?Q?9pRnSvxuMpEAnwhdXdq5nhbF+laH2f1JEDhbyp0b9HhDfrfUS9ChmpSywcpk?=
 =?us-ascii?Q?ucBRPNvre2VxR8Lbls+sqdEu0Rb5na2jUciweay34B+hRfshgvDYd577KLXo?=
 =?us-ascii?Q?B1/UZaKYlWml3TaLHBe67tzxxXX23eR13KSFT9YynjIKdt05GFAi+NfYVQEg?=
 =?us-ascii?Q?SffaosVrF6OanK3rhjl1V+yMr0kyjiudngbEOFEDNj9++8VC1zQxZQfesKKo?=
 =?us-ascii?Q?vFJxbWpa3+6MjteD7ShrcI6/5Z2GVcDxQ7BLad8MyTlmwGKfWiqfuEArim9W?=
 =?us-ascii?Q?tXhP+b71Ys+OeXdnPzt34sNaU/8JQFiuq5SOsRdM2NtRZsbWiGmjcUFrwJoe?=
 =?us-ascii?Q?gO8QvB5ATD97gFayS8Uv/pbJdQdLdvWiWQIOmo9rWgRb0/KxydF9k5TUyJxq?=
 =?us-ascii?Q?kOJQm5JrXpnkPONmwmFMQe9oBfiiOglBzTcYJIFtGp7YG+Whe5aOCGiKjeW1?=
 =?us-ascii?Q?OBDMKXa/pnlpl9fm/Ea6aKH2aKruW70UzuKRnS5goAiaJdUOj4ToF5/Q4ROi?=
 =?us-ascii?Q?Ida2pKEU+Wg3Tp2BJdB55Q7TLvQ6DzdLJnsHQQzDscYKDScZEDlWyUvise5p?=
 =?us-ascii?Q?7QE1BmR2nYv0fEzoOiVtYJxp5VwemYLvuW4kVuryQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XvmQJu1VDYkldofHRIBzoPVDQwvzEo/TFrfNiN7DCha0YK9uL97EyVzex5v9?=
 =?us-ascii?Q?rtz1SDgNmRS8VuytD4VHOazHCFH28+5H+pUP0/gKHSm2XOit7ugdY8d8+wam?=
 =?us-ascii?Q?Tmh9vQ2x8WXRuEWHanH44lp5NUk1Y2EzAOYbY8eRHG6uNlznCcosYOpmfskG?=
 =?us-ascii?Q?GyIK0trMr7SA1F0NTJTr5XIoByEbqFo24APPpv/ddh8Dh++kM+8B3tZpBda1?=
 =?us-ascii?Q?35inJKenm12fQUwZCwkhq4kAeZzdh9qRkq+7scmYdtvvTOL3sltTENtM6aRV?=
 =?us-ascii?Q?Qc6HrrmMMheH7hr5ltglkGpL9RRPxtjBfQANQauYwXfHVqQFiu4Nz36w6WFl?=
 =?us-ascii?Q?AJ7Kiqbs94H0CsdZN1FyBAI5bJcfjRIy4T2zy2bq1w/E9+SpbE1P39VMBOYM?=
 =?us-ascii?Q?fBfBFYxVOOYTcwhRshMWz9bcCgjsBoI8+dmWiob4ExnJcndaPvXDGx3VPjuD?=
 =?us-ascii?Q?GXeSZO9hE5uWKkU2fmFX5mnIb6TXQNLJTgLa5eJykSTszdXkYhBTBGzSdVyg?=
 =?us-ascii?Q?HrpW34f2N4N/TZJd2t8qe+9fnfnx+oZSRTN7LMpY3MFBr435Pz4aqIhH6HLC?=
 =?us-ascii?Q?dC0vFcQc6z2Ez7tRUSbGdDcON3oKWOCWgg7R+zyoICUXuBv943NNHTCq/nOK?=
 =?us-ascii?Q?CtIYHe5yABzf3Y++wfAM5Wm13Hh4VaJt0V2lBEE92lpVNL2LsYIHOtz/YSWG?=
 =?us-ascii?Q?X22MQ1bx82cTSjbxjgcCKzBak2OzKbrz+HphzhZ/fBDqpqraBdKPF8nkL/tm?=
 =?us-ascii?Q?ft59bxfS+IF2+Z3RMGkPNMJOd/S77VpgKM8hL0DZB1XdlweJ68hnyw/Ujgg7?=
 =?us-ascii?Q?woL6q+dGU34hnw0+ZlwC+id16Bd8bs6v0WVo9YPOGRPq/ikdor7MTllo0aFO?=
 =?us-ascii?Q?rhfRL0WzDbEtqFxXCFP6Tfvzgv57qlioJHxGhnzhAkk7bOVMISgH9sTg6zi5?=
 =?us-ascii?Q?TM7/hOziCSkwkoAsB4rS9JfURCj9JEqjAckiaBICBhXNAsrV86k1UEjdH4Zg?=
 =?us-ascii?Q?k3Ax/yu3qD5dGRGWoN/ge3EqgTd3ik+ytgMuH8JyNzzm73UOG3G378SLign4?=
 =?us-ascii?Q?ZzldUpMWEGio33oacjDEM6X4oYnz6kKPdvLhH5lSt/HkoVk20rHCBcWEDf4l?=
 =?us-ascii?Q?ruIpxnEvxl5nu20j/hokeD55NyeHXaFpHbTheObuq0xVfWNFMYTIpFmnSvuj?=
 =?us-ascii?Q?EQALXTq3mX7RJwgc0g13q3WJJnRQsHQKIvL/x21XKVTMsnkc54wkSMaBqRMK?=
 =?us-ascii?Q?nH6Cg6lUaJgxYHJqlkl1oq05zeVEmgf2iyUW5UPLOEng88QHUqveh9ft1Rjk?=
 =?us-ascii?Q?h6NvPy9Hg5j8rmBpgJm2EpaM+bVfeiBjb4Kx4IwrX7wy44PPVrp/+RwOd4Fv?=
 =?us-ascii?Q?F4NhNrk8HqrElAzohzN1wzU2As+HceUEr43rUH7O8gxuUvvAj5r8V+CN8ejx?=
 =?us-ascii?Q?oA/DN4RrqYn4F8Au20OQl9BronpsddcVH1IQ5G2UTmrZtxb8x5i6As/WPpgt?=
 =?us-ascii?Q?0E4x3AgkGIHbwX3lMQkuFiQR433NNseRGCj/WTl6U+uc6vKV945N/A/esVSe?=
 =?us-ascii?Q?Z+uBuulhIq4BDmJ97sw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d02b8a3-cafd-42fb-db6f-08dc62c2b90b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 11:52:44.9048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJfSJRLvP5brIQhN3+RT18dXeA6YEnGg5X1Ek7CxI3qOn0VvEFm6/KNqceSMCHbV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9266

On Sat, Apr 20, 2024 at 01:45:57PM +0800, Yi Liu wrote:
> On 2024/4/17 16:49, Tian, Kevin wrote:
> > > From: Baolu Lu <baolu.lu@linux.intel.com>
> > > Sent: Monday, April 15, 2024 1:42 PM
> > > 
> > > On 4/12/24 4:15 PM, Yi Liu wrote:
> > > > Today, the iommu layer gets the max_pasids by pci_max_pasids() or
> > > reading
> > > > the "pasid-num-bits" property. This requires the non-PCI devices to have a
> > > > "pasid-num-bits" property. Like the mock device used in iommufd selftest,
> > > > otherwise the max_pasids check would fail in iommu layer.
> > > > 
> > > > While there is an alternative, the iommu layer can allow the iommu driver
> > > > to set the max_pasids in its probe_device() callback and populate it. This
> > > > is simpler and has no impact on the existing cases.
> > > > 
> > > > Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> > > > Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> > > > ---
> > > >    drivers/iommu/iommu.c | 9 +++++----
> > > >    1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > The code does not appear to match the commit message here.
> > > 
> > > The code in change is a refactoring by folding the max_pasid assignment
> > > into its helper. However, the commit message suggests a desire to expose
> > > some kind of kAPI for device drivers.
> > > 
> > 
> > it's not about exposing a new kAPI. Instead it allows the driver to
> > manually set dev->iommu->max_pasids before calling
> > iommu_init_device(). kind of another contract to convey the
> > max pasid.
> > 
> > But as how you are confused, I prefer to defining a "pasid-num-bits"
> > property in the mock driver. It's easier to understand.
> 
> @Jason, how about your thought? :) Adding a "pasid-num-bits" may be
> more straightforward.

Sure, just make sure it doesn't leak memory...

Jason 

