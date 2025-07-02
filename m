Return-Path: <kvm+bounces-51292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0BDAF160D
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EC3D4A0151
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 12:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE6D274674;
	Wed,  2 Jul 2025 12:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nZfw6g+g"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580894414;
	Wed,  2 Jul 2025 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751460483; cv=fail; b=TNULzme8kN7g7H3PKNB7o/VUUQdFuT7FERBfeXVUuKjUNZk3C9cLWODXNcBpgv8H+2n7aAJrWe3n3hufiK4FH+1nt8C06XS15VBM8VP8ZAuSN6wN3lu2MUx+Qsx8iIb3jXFD9dMXzr/05Eo+R3+BrzdkywNpyaqLxS5NUmnajlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751460483; c=relaxed/simple;
	bh=j6DautTJDlzLcqdza/jDCbSfPRfJy6IZewo0Azb1iL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=acf3eUJYj19f+O2gy62sB9YVKI900Yv3nrh3rkE3Qn1P50H8PKKUKJqR4hIjLQ4oMhCj46+9+VcFEAFnrFKuHXVnwbVSfWY1hblp+e9wCozLFPwuWql9KSVS9rbrD+Zdky7nzLKxJhKT4tBQ1zhrqrLJ1bwf6E4RzMHyPLX9bnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nZfw6g+g; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPOkYcwWbXml+8N4fj++hA3hUu967ltJe8d9KK78WEydivoatYHWkOXND6Nis9P1Nff4XbAeM661f+XCdE7ZgFHCcWwITo5i/90GbC2LbzcctzpgHbhvgnVxr8StXK1QB1QjW2oPDasM1BcQyHBp5+tZ7ZhJ90833YV/U3uB3JS6nNowwA34sC8ZFixfKMXwpT7i96APy5uWlwCfqouh/PEEowy34UPyYBL2I2LFH8cUhdAaSxmpIIKdmXC0ikmwj3GH0RXmqcmjzZ8jzV8RNi2OnjH8CH3xCS34raQO4rYp48Mm2t3ezBPIKOrJOXQI5+FaSHC3t74fSCMA7XI8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bn+rLloUHriCVKBVvh2k5/G5Kc7kAbN1lQpswSY5ep8=;
 b=vCao8eOIVp1hQePZMMOjBIqPAVJAfJpmehILNBjka2qU9ZkUNqR9vy2EZRM4jgDR2xyTBl2jQvosKOUykDZx3D5lig2f1uQgWx3xflw+6XwyhI53HMW9016zqgcfnRX2m7BBNYU+7tjJ0Z5ddGuTA0/FRl0T2F+YnmlCxLAe0ylxvb6CNVWqk/0UZQqSCDVoide6snpeoOy1kJpYo1nZZSLkYLmqRXuC/QNHCSGIsPGa5rZp+pYNgD8jGt4a6qYVrRY+b+xaoimWYq+iqOkAI4uo1ZCnf63doV0YKZHw3jWFOCBSLlQKCUbUHzUcIueAzjyGCqQ2r+IL6aTAcRKsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bn+rLloUHriCVKBVvh2k5/G5Kc7kAbN1lQpswSY5ep8=;
 b=nZfw6g+gO9lG885TOSubrEeXEMy0eGIpFklHbIttqYC75+PaoYJ8Z6Rn4RDqpyolSeJ9kjDg8C6OhZ2AcDBMsEYh1OsCTsQKLIemCEktsaa1WcN4dKGJWDLBR3qKtJU/QRcRXI9g2/8WSk6rO/pbxg/fVgi5WGkSmA88UTMr7aQ278JYWDzVhAP7x8BRNRjahiq1D5agYPMl5pwI8CwvHPoUp5VuQ2Cb4HgZq+sUb+xDY9FzKDkz6kLhBG9ZL7LCvN7Y4uIr/9Xw1jJJE14oc24+q62webkVO5HRRWmFs/OXqhmLDuIRktr3ks6dk0HVVgE+TmbOViHMfKTCv4ZurQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6236.namprd12.prod.outlook.com (2603:10b6:208:3e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Wed, 2 Jul
 2025 12:47:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 12:47:59 +0000
Date: Wed, 2 Jul 2025 09:47:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: lizhe.67@bytedance.com, alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and
 vfio_unpin_pages_remote() for large folio
Message-ID: <20250702124756.GE1051729@nvidia.com>
References: <6508ccf7-5ce0-4274-9afb-a41bf192d81b@redhat.com>
 <20250702093824.78538-1-lizhe.67@bytedance.com>
 <c1144447-6b67-48d3-b37c-5f1ca6a9b4a7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1144447-6b67-48d3-b37c-5f1ca6a9b4a7@redhat.com>
X-ClientProxiedBy: SA1P222CA0053.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6236:EE_
X-MS-Office365-Filtering-Correlation-Id: 13812077-58f0-49a6-ec8f-08ddb966ac6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ppXsagXbfkW/s1xYAf4m0AADcG1q4YIOfevkJvgejulopDvCsnUJ6sp9x1A+?=
 =?us-ascii?Q?Df5JXg1SB9hDw5OO5MyfRBJXlqSrTvzfUhdHat5sXMzT3nPNcWPYTvU9gnCP?=
 =?us-ascii?Q?08Bet3RH9/AbLdjo9BncyIqWog3NnSysVhXUoH0/ae5gKZBnkglZPB6NX/6K?=
 =?us-ascii?Q?KpSxYI97Yb+8vZUldTZDh9MrX8ROGe8VxNYDPmvQOwLJTsEl55MkPaDoouJO?=
 =?us-ascii?Q?xtjdFe7dBnf4W6tOy3gYeUYVJnhxBJ+X0Yz1wovT1VmQW+GcH1SdkvaeCoCG?=
 =?us-ascii?Q?sV1BDjSRA07VfTk1pxGiE45NOWafuxlBxen7mt3bb9cjy6tl973RMI3jhUF6?=
 =?us-ascii?Q?UY0CsZ3ipk3Uffk8qLTEhjGJNgWfWM25lNMBsjR7wXqeWeFdNKxctxXty7Q6?=
 =?us-ascii?Q?EgesyvEMUZKMKfsF8plzPUioVt6PCViL4vMTi9IT7zbaILU8ADay2n7xa2hq?=
 =?us-ascii?Q?too2iOXdxkB+yIasFYD0rYkIApvTSCz/dOsBqkNJCRr6Hs5bomdYRA9Vj1q1?=
 =?us-ascii?Q?CDVQzLb2yE10BA3KVAfbkhNpUpHQAPkzhIvOF8pL514ogra1Q3G9GKkmYNtK?=
 =?us-ascii?Q?QHDScF26mjPKM+8DxM8oUe16fxYVntlUAC1CrwDZWm6oSRWOythCPW1FQqB4?=
 =?us-ascii?Q?jPFEQQriePIO90NdoAuzDQFo0AxwvHNb2cpbanye/xqIIk3sRF1Vrz1gqT6V?=
 =?us-ascii?Q?Cd6NYKeJCSVkYWXF7NRSdIU/GgyTG8+RkV0i+wFc53FvK4NHFJDzwXxgEHBe?=
 =?us-ascii?Q?HN7dz50N/+o/dKeZ/AqdyKUFHrE7zAd7upXO7McqYqkDMG5D7D/2xdX499lx?=
 =?us-ascii?Q?tsbU3qhan95kTKKQNH8AZN1JoA4HnzOUAsrNAMu9dukWfgmSZOI786LFChHW?=
 =?us-ascii?Q?+ktLMKC9RoE1AyfPlJblK0hAmDGgXNOeb7VCIcRzE9TWO0DFPuxqdcBWmcwv?=
 =?us-ascii?Q?hTmtvUr6HNsVBGx/xxNAvktv7GN3EiunNwcsCHqeSzN9HKxbE2tH0Xgs5Ekq?=
 =?us-ascii?Q?7M9flWXeb+VTo+i6o3JIQGzXPV2G+/BbgeWexyZelhQsWtpv88EMuooVDPAy?=
 =?us-ascii?Q?7FGhuvDvJPeTu6Cnhl/shdeshHz/SOrEqS8NOkj7qWU1xmgfkwgXBMsKp1FT?=
 =?us-ascii?Q?NxTXx6HRDpAfOPHIZfszbdfAU+gI9Kz30MMHrNZ3bwVEYfYsL0fyTxMcC+F4?=
 =?us-ascii?Q?51CwOLcJiYWQVCVfl8fWMpOXjfDjukpKk6dRstMFgtMT4dyDMFhryBGGbMMe?=
 =?us-ascii?Q?U03thR6oA+06ZBntVh4WZokYw9PAC1Nov8ss5Z8u31sNpQ7Mqi8eL9kH3JGA?=
 =?us-ascii?Q?hZiK0gYwZesqHZgf9br94JgDKGWO/Sq8P8mA6t+R7RXT4FTL4uCg4fdGgVT1?=
 =?us-ascii?Q?BUNpNG1d4YnUWCW013KCoyGhHGu+YV8a0Dpt7yTfn9YZ0Yi9gHPtQS6fx1I7?=
 =?us-ascii?Q?irS1vZN3iI4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h21uzjuEKXmcOi+tcyWU0B0Jef4r4jFcPWcCY0iredos+/CmfUKCX74ZigK7?=
 =?us-ascii?Q?rsBt7gFrZxtARfMxZBWYohxHxHbNOto+VspSua45gimE9bEDtmBiWEAdq1wk?=
 =?us-ascii?Q?mAgTi7Gqwh/IXUuT9OZjMDpw7sBSntA6JEVdrTE0V2Seda8b+zBnYrCw7pAn?=
 =?us-ascii?Q?WZY76re1jb34NDgW4JJgj9lyg3mg1zvBK5k4Uryy+xImFCiMOio4uZzW+6r0?=
 =?us-ascii?Q?l//gencTnAmrrIGEcJGDmCFjjWN3TbS/DrQyWJ8jU9J71Lb+Y/BMVq9o/8M+?=
 =?us-ascii?Q?XKMxIMzir9gxJhixMtzWFVkvoqcYspUDxcTnIpsKNk92yTNtFh0HBFgYtwFf?=
 =?us-ascii?Q?2/ZMfaMy4yMEW+3TJ6GJ2qRFUW9IPxVh7b9ClpSMP3I723SbvjHhgsmiJvWn?=
 =?us-ascii?Q?hQYHLFkK4xsX7wiMY7XL9xu1zuiJqJU4X9M8Bf1rBaZ93sqoUN8N6F3yANTh?=
 =?us-ascii?Q?4DQqEIfJQ8VeUt9uKKpC7FDbb98yp7yktUmnW/MwoAv1ZITpBb1eMG6mOfVE?=
 =?us-ascii?Q?WgDFuetZYnZATeuiu7lBG/uPAqRc6oGo4/aT4w/QNHwxzrGo0CTXWoCRar90?=
 =?us-ascii?Q?NbCIFGT60thafhTn4CI4elIESR14RyqvC8t70hLal94EB3ZDOJI9n6UB2XJk?=
 =?us-ascii?Q?MKrPZG51Y4b/xoZ3CoP3++t7aXvKMyJN4H4wUKi/K1et0Yy09GNIXcARPXnz?=
 =?us-ascii?Q?/DEXhBE84ETeBBf5tjt8+uTvm+cmsGJcAIgUxPFtnupA9WgUIchvYtC1oO5G?=
 =?us-ascii?Q?ZmKoU+q39wFAICOLnvqhXOLM64umELHf48YTyeMH72Duzaj2WfeX2uAm6XKg?=
 =?us-ascii?Q?nefR8BKiKXOeTtar6m/kN814aqavkI6AHMhWxnTXIUlur+fUriMtPUxinfe5?=
 =?us-ascii?Q?p6jLh9Re+b1FMtJsDvK6PQk4789edKxUYSft+k4ivWVjFIbg/dvdZGVInMn6?=
 =?us-ascii?Q?F4xdRGojgnM4Knvkh5XyianN5HcMV6fVOo6Fxtf4L8VgyCkHqKw6/qoJq4x8?=
 =?us-ascii?Q?eXPhh8mduOGUCGH45cNHF68Bz0CSorlQCtTzYaD2nglj46J9ykSf329iAD06?=
 =?us-ascii?Q?u8EmwWU0TAyZU2V+60h0i68ONvltuRVv5vxw3ovxrgVCung2QgSFS5jPGGv7?=
 =?us-ascii?Q?rd/k7IqHlY+NwxcMtbmPQgv34vHJJ8IqmiBTO3a9mt9ydMpIySmXlpucJccF?=
 =?us-ascii?Q?2nzHNPIBcXfs2anF3dEwjenwL3ed4KhBNk1hH4OiKlFHvX8S2hrAAV/zFst6?=
 =?us-ascii?Q?yymUl1crlx2sZr++/9foRTVtwyYk9Jk8wOU4IFZ1d13b7Ate/0YI0k8mgMKC?=
 =?us-ascii?Q?imy2NreS9twOL1SotJDiRRsOtLUOeTchf5siwefLoSKJj/9tWD5xDTfNTtM9?=
 =?us-ascii?Q?KV18Wq+VRH81dyAtb4idEOtOzgb1azSLaJjXLZ1WCTjaiNjLN32hkjPzz2Ua?=
 =?us-ascii?Q?049f8qcZqUu6nObjPPIiEFMXj1qxwuyt3GVPdcLQ+eVESy98PnEyAQq3OeOM?=
 =?us-ascii?Q?Cn12kKCPlE5ttBSnjYJXUYqmHFJwb15U7r1EvDm+hSMUkYOcXoNbmFKepc+4?=
 =?us-ascii?Q?IpzcoSiljKJKMjb3K1wFWX0NcD+MIt9YSa+jLx8d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13812077-58f0-49a6-ec8f-08ddb966ac6a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 12:47:58.9894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aBTv1RKWfywceilxiGhuBmig3CqIoL0RFu8Y5MJDzQ2eWMyKdGE/o0Gd64jytJB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6236

On Wed, Jul 02, 2025 at 11:57:08AM +0200, David Hildenbrand wrote:
> On 02.07.25 11:38, lizhe.67@bytedance.com wrote:
> > On Wed, 2 Jul 2025 10:15:29 +0200, david@redhat.com wrote:
> > 
> > > Jason mentioned in reply to the other series that, ideally, vfio
> > > shouldn't be messing with folios at all.
> > > 
> > > While we now do that on the unpin side, we still do it at the pin side.
> > 
> > Yes.
> > 
> > > Which makes me wonder if we can avoid folios in patch #1 in
> > > contig_pages(), and simply collect pages that correspond to consecutive
> > > PFNs.
> > 
> > In my opinion, comparing whether the pfns of two pages are contiguous
> > is relatively inefficient. Using folios might be a more efficient
> > solution.
> 
> 	buffer[i + 1] == nth_page(buffer[i], 1)
>
> Is extremely efficient, except on

sg_alloc_append_table_from_pages() is using the

                next_pfn = (sg_phys(sgt_append->prv) + prv_len) / PAGE_SIZE;
                        last_pg = pfn_to_page(next_pfn - 1);

Approach to evaluate contiguity.

iommufd is also using very similar in batch_from_pages():

                if (!batch_add_pfn(batch, page_to_pfn(*pages)))

So we should not be trying to optimize this only in VFIO, I would drop
that from this series.

If it can be optimized we should try to have some kind of generic
helper for building a physical contiguous range from a struct page
list.

> If we obtained a page from GUP, is_invalid_reserved_pfn() would only trigger
> for the shared zeropage. but that one can no longer be returned from FOLL_LONGTERM.

AFAIK the use of "reserved" here means it is non-gupable memory that
was acquired through follow_pfn. When it is pulled back out of the
iommu_domain as a phys_addr_t the is_invalid_reserved_pfn() is used to
tell if the address came from GUP or if it came from follow_pfn.

Jason

