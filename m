Return-Path: <kvm+bounces-17648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 968318C8A76
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AC6D1F24CA7
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFBBC13DB8A;
	Fri, 17 May 2024 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gCwN+ysh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EC112F5A3;
	Fri, 17 May 2024 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715965466; cv=fail; b=RWLUYIz+Jca7ECz/unHT9vZLh3nwHHfWowZUl7ctFWr7oxex1yh0z3PzkXVVfgSwMiC1rxhsO6A07RfTKxdq98cqyTqxuKcBPKHA8KR0sucarR3isp/Gq9P+QTMtQQ0lIbCpzDZFeIbczmkAMpoV1TrDHLhbOe3TD8dVlTTXj98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715965466; c=relaxed/simple;
	bh=1bS1qICTxMyL/tdyvQ0/+EEwvGrdYREzJI0+wfYgDm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HacQKFksRNkiS5ve5UVQbYOFA5LIvlhpwwXrlORGkAMy8Ac4xAJiJyMNtLKcQgAlYGREBx9KvuqpMuU3hF1hAy1w9GxhBqMoe7Ugo20AUYYXvDKXNAouRVCPyWBf2EYj3MObZkp+NPb7Q28EloNfA89VdOHI+CRT9EqgHdl5ZLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gCwN+ysh; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkFOeU2nqjaWdXj2joVHh949w/IqCqRjAizhhPIQxGwADE0s92pxHopH9l9AzY8LyyYzuvI98DfIfFQby2A5c3gb+hbevNobKLRut91TzkBZiO6ROVKzegg6VOuUgsa6FLBsVHgnjM5f9TO3vPs+vrahyS5FFdRC/CPBL2UoxYuVSV2h7iuOT7EuZLoQE6waltNyvYDBnKEExgODfTyUB02nukpj45ZW1ABGGkU3QV3r9SnChTLW98JbrBMnkEuEiJIdDtY1yG7Fy7w3HV0IvUIHwVtlGCfO2z/zzvt5LslQC7TDB65vibJCmkMPXkOf/k47rOyH2ueXYAPGQKybHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dsrsd2PVrcySksRQozuWfGsndKVBXRkUVmsL+TuBKAg=;
 b=G9JiWkZQ6/3TpXvzxDAdf3yHzVDVb2mhgR5QJWcp6OgHgL6AU7vA6krOmTb68pic6ZtQwvjUN3E++8ZU1W9U+8m2bZwnu91RsooXqe5teEMk+n+g8QJI2pyIQ76svd1fTqNAPjzYvyBhN1jrWNED59hYMWroMlwQkmfo/IkLTUY67WuVNlG92gosDxnV8qC1AtW9eXbXqEeGYsRVgf4jKkTPXy6duBGddjQ33L6M0pIeLNjBHd/+U4xEoTopTcF/sMEZ4M9HMaxKRAjUnV35Wwuuz11xKWAb8DOIAW1a1XbJEXPBda9rWDdnNB/IS+u2juxjr4sPZuenHkP3CCNv0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsrsd2PVrcySksRQozuWfGsndKVBXRkUVmsL+TuBKAg=;
 b=gCwN+yshCXSynWUdQO/DDljYqyJ0s6t0Y92lJBM+UelqjiA6jOgzFSqj1lJeQVM9O8uYTM2DJvKMtm5xVLxS+AOHwcHare4EyV3Nuo07eiZhmff2d48o26IcmNN4/JO0jZ64y+0N2NjAWWiWcaCyZFL8oDiBtuTY/v/jyFJg+yiPOC5kFo+oDqDyfCD5LCLiWbcK4Fym+finOrEQta45JQkJlacQO2C+EYf+fRt4twBBIBy7Bj9M7vkL0w8bN4VS9yhfXPuVIyXDjSp+JLhnusHFOswfUz8pulY7jk4oN4SHzwSucNmlcAFQ43u3g++SWS2avmQPFtvdzCk0BZvibw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV2PR12MB5824.namprd12.prod.outlook.com (2603:10b6:408:176::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Fri, 17 May
 2024 17:04:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 17:04:20 +0000
Date: Fri, 17 May 2024 14:04:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240517170418.GA20229@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: YTBP288CA0001.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::14) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV2PR12MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: 92312765-32f2-43cf-b1c2-08dc769364e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5oLwKuxoy6dbBf4HXxkOiAisBaoxquASHVpi8lDxidHIDXiU5Gh3aouZmBYV?=
 =?us-ascii?Q?XNl8PDNNso4BQTp8raZoF413dSdGvFIRrI0tNbIWqGK1DdpiwKKsJp8NoAEX?=
 =?us-ascii?Q?uwWNUj6ii6P0KSVOl21e4jukSJzxLOnSR7ma5R23z85KV03cMyqikV5SI7w1?=
 =?us-ascii?Q?4ZHT9k56w5v6ARNorx/+SE5Ca5rEo2XGDE5pplBhpXyOVgsMpAWo3P/LxMba?=
 =?us-ascii?Q?I8yuq7YeI1ECdHBxRk7gq4/WIxnBQcRVEtHMonbuDzt8Rdn0VKvYtOn/07I6?=
 =?us-ascii?Q?0YAPjr7Cwq3hqTuaG5m47gzlTp9TewpI8+5guDgtRXTz9D9aMscKmag64D5T?=
 =?us-ascii?Q?7SaCofqtwjDYlT8+TkZfZt67EsJNhT4IEn7TkXiuJIpjOWK1xMD/umrJNLdm?=
 =?us-ascii?Q?Eka/hC27HVmErVmL/LkScKsv36BTDVZ25nNB4DIZLVcWyj5ES6cM5tFxUYiL?=
 =?us-ascii?Q?wEx4LWnBkEFLR1yQn+m0/lV0IgmHPvw+mb/XvbOxF28qwY8XZsSV/nPuDXUm?=
 =?us-ascii?Q?AOWJh/AAQz/JqTsK0DXLSkQ31W0kOIqmu2F9YT1NsZDT2X2J3DXYN9wP0eiY?=
 =?us-ascii?Q?KTqT1dp39SSwZUVQWt2fREHHeQPQUNY8BDXtfRzqfMGbwgG1+B8T8mmEbc5g?=
 =?us-ascii?Q?3J9msGWj8IBAK862+ToGlV3g0zwyiIkXgf47FET6sMPo2q9Qm0Hh2dBCfdB5?=
 =?us-ascii?Q?dSxSRQ0N+SwseAgCeZw0CQv2FE3WJMzjjrENut5WrzthClX1qbzuyIaDPSiz?=
 =?us-ascii?Q?I9ZSkCaX4bC3z0RL0KlyJGBDff9tLOHLzsdx0y9s3etgPjZwhNKu7r47aHzU?=
 =?us-ascii?Q?/QlAUzUJSPT8BAm8mZJ3tCF1+8qSz3lbmjMZv+lCNCDpWpCEW2QYk+bNG6nV?=
 =?us-ascii?Q?jAxcnEv4Uz6Rr8UUpxf1PxCzyQFFvBzUyw0WlK+0TDI0kNTr+c+35bpznMEs?=
 =?us-ascii?Q?fFkcnsnqobuNMKkEku+0m9biJPgTciWN7VOT+Jn5HiBWjrHlUumq/pTSVFxK?=
 =?us-ascii?Q?sd4HIEBzeE6fdtqnvWlPcFJGC89K2iHB+ldrsDf3hFvm0jx0LMQ/RfyadgM4?=
 =?us-ascii?Q?2MMUbT13LJHlsdH37GkQezfQ9+usFY75SD2rOfPYhuyKFMIj7llbwTDhuuVr?=
 =?us-ascii?Q?fOzlmnnAkwUEyvBxy9PCFrF4syOohfNX/lDuE5S4OyRBiMQQNCrpCd/+FehR?=
 =?us-ascii?Q?sCmaRSwnCRTgYSBRUsyoZp9TSR2Crkoue5780O2r9mR7pFVpj3F2QD9YJ3K1?=
 =?us-ascii?Q?fZd0Jjyhs10FEEhbFnyhC79u+pTG1V90J/f1WvNdMg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2ubUwMZMQRgJ4pQY7pUEhPsCeI7s/UD1TmmBtMEreXiwX7SmbijzmUU6E45W?=
 =?us-ascii?Q?j+dUKHYj9JQ0M3zXf2w9iZtXIuHtrYUHk/+3rauiJplUmox2koMozNmkj3Mj?=
 =?us-ascii?Q?vYQaDJq8a1jfzooYRsWWyozDK5zDj0B/uJ3FhIn6W168SlwB2tcJeV6SeKZk?=
 =?us-ascii?Q?RblJIDvC3dbtwMfIOOxPTXvHsfjZZbzoWAYtzk/olTspIBh90aIIhz06g0ez?=
 =?us-ascii?Q?h1QWaQc09dTY7DotdEIL4FJRVHVFrQXYJczkJ2teKxjJczxrLZ7M8rROJFlw?=
 =?us-ascii?Q?0GUjCqW/gaclIkiZ7uBfd3dYNJdjRj5yGTHNiCbNLcxFPphQyp6ErQGOXJtS?=
 =?us-ascii?Q?R4WFzr5iflhqXcfMnkFtRhSF52BZfYg4Nu3hhIUeKHAqS7nD6dcew42gBOx3?=
 =?us-ascii?Q?EZuZyRaT2xLupgH/Rw958oTQdqWbN1tT84Gx9Hpa89EnhGXhYzc/vTomhodM?=
 =?us-ascii?Q?0ri+4ZqO44DLZo/xY/JhM2sIbGw074Dco2dMFL11SIY8sDCBWAgDLkgQZbau?=
 =?us-ascii?Q?jMQNhfkJsUfB8GWnu4unuRnqrInFcWIrFjkn8dUrnN0NVipwhP9zjiPgwbJK?=
 =?us-ascii?Q?vyoR2xWidH2SDnqrRXHAfxI2Y6nyWzDD511OCKQelVE0cag2toZHkPJTpKLj?=
 =?us-ascii?Q?iP9Fiks8TuFcbRgEQRNC3Oaed6rmmcOACYs76WAjQyq1I6e/HNqAlbd/Hvaw?=
 =?us-ascii?Q?eiL/bOKzXZDm29A9kjpKpAy4t0TXkA/LbHuGCUlVfAvDeiDQdxT+VVnV3RMA?=
 =?us-ascii?Q?7I1p5YDP8DDsQXqmx++aVyhkzQGwn4JK15hKKAdP9PjPSOYAj9jXm7JEuaqp?=
 =?us-ascii?Q?gGOHoFkR8LqiIEXhFi95/ZLKTrPdbA4vhDDWJ0Fo+0h4PlA2IPIdKjjI9q1i?=
 =?us-ascii?Q?9BJujp/wWOSvZjAPfzeGNQcELGpjNMwCjocqZhKufWT2Cm5sn7qB7UUA7iKY?=
 =?us-ascii?Q?ItOyV6x3cMpDlY0tQ3IhYw+07mnmZp0fuxzk1mw2awsVPZ/Oov1AKs0HWTds?=
 =?us-ascii?Q?jKE18OiGTaXwuk5N52MmY7JlWXGGwxysXu6D3lAYKVbjX6bT+eq4Md85wiy3?=
 =?us-ascii?Q?heXJPpsmE0zk7qjQtzCwXciNtEDUxbjH1X+Xpqq94qdAWl0F3XYgWrdRRa4j?=
 =?us-ascii?Q?qKD7jb/acGOlso/JD/1a3cfTteZWcOo7E1+JnHIlPe+cA32BwnsLoS0huS3n?=
 =?us-ascii?Q?nfRHMx0B2Cpm5AK5P25H+j8VRFq7B41fEAVPPZk4KKHm26peScL+o7uqF+s+?=
 =?us-ascii?Q?RN60KKFK4YekJ5xJZr0eXcVvkfCHZr0QENauv4lcqzzWNRkBaCU30Dvm0jdk?=
 =?us-ascii?Q?qnoUQiRs4CchbuAjW0GeSzqrOeTW9zKO99x7GmMNCuezOUAzjl75Is2QW2bn?=
 =?us-ascii?Q?50461CZ4XqGxU+cX9ugmou8cQ/zI7oUfLYX8Zx5Ic1L1uzDwkH4HYFGtaC1Y?=
 =?us-ascii?Q?MDJzgPwGmnDtvSMQcpPyGQLFNNDAzRVfVCdyD7XOIZeA8mML6LWgXeLARdgV?=
 =?us-ascii?Q?AO+maCYJ6IAk3HzAX57YcInDfrd3dIt1Dqsmu55ggETfJrq6BQYWfBRDhN3s?=
 =?us-ascii?Q?orktO4A03KKovXlHVZvQi+qLTqqd+9vVrKEi1BE3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92312765-32f2-43cf-b1c2-08dc769364e8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 17:04:20.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bM8Qj6a0KOAkiALWH6WLeV6h9sRFgL743SHMVQp843jEhJszWi8KjGgQTpoX9Kws
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5824

On Thu, May 16, 2024 at 10:32:43AM +0800, Yan Zhao wrote:
> On Wed, May 15, 2024 at 05:43:04PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:
> > 
> > > > So it has to be calculated on closer to a page by page basis (really a
> > > > span by span basis) if flushing of that span is needed based on where
> > > > the pages came from. Only pages that came from a hwpt that is
> > > > non-coherent can skip the flushing.
> > > Is area by area basis also good?
> > > Isn't an area either not mapped to any domain or mapped into all domains?
> > 
> > Yes, this is what the span iterator turns into in the background, it
> > goes area by area to cover things.
> > 
> > > But, yes, considering the limited number of non-coherent domains, it appears
> > > more robust and clean to always flush for non-coherent domain in
> > > iopt_area_fill_domain().
> > > It eliminates the need to decide whether to retain the area flag during a split.
> > 
> > And flush for pin user pages, so you basically always flush because
> > you can't tell where the pages came from.
> As a summary, do you think it's good to flush in below way?
> 
> 1. in iopt_area_fill_domains(), flush before mapping a page into domains when
>    iopt->noncoherent_domain_cnt > 0, no matter where the page is from.
>    Record cache_flush_required in pages for unpin.
> 2. in iopt_area_fill_domain(), pass in hwpt to check domain non-coherency.
>    flush before mapping a page into a non-coherent domain, no matter where the
>    page is from.
>    Record cache_flush_required in pages for unpin.
> 3. in batch_unpin(), flush if pages->cache_flush_required before
>    unpin_user_pages.

It does not quite sound right, there should be no tracking in the
pages of this stuff.

If pfn_reader_fill_span() does batch_from_domain() and
the source domain's storage_domain is non-coherent then you can skip
the flush. This is not pedantically perfect in skipping all flushes, but
in practice it is probably good enough.

__iopt_area_unfill_domain() (and children) must flush after
iopt_area_unmap_domain_range() if the area's domain is
non-coherent. This is also not perfect, but probably good enough.

Doing better in both cases would require inspecting the areas under
the used span to see what is there. This is not so easy.

Jason

