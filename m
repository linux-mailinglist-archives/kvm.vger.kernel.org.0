Return-Path: <kvm+bounces-17179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B81B48C25B1
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19DF2B2237F
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B780612C47D;
	Fri, 10 May 2024 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OjP2GbiW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4F168BE;
	Fri, 10 May 2024 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715347775; cv=fail; b=Ls5VRSZVGEaTG5XVg48gQcNYaykv87XAH3qis+yq51o9RktyOru3QiYWopfdG34IbmDVJ9ab8xUhEvuvrJA/x9vG0b2yehLXYyqcGNhF4EuZKJO7KtQmQhF8XcGt33wvf23UGvY9pIPqyW3OZo/dliPgh0GBe0NLYQCZZ/JO9bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715347775; c=relaxed/simple;
	bh=hzc6BWpvh7kgJ3nqir54Sk4Y/osZTmHzsVCOMCleURg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cd0vnV3nxK0+ZhqHC1ltEtWsi4crne3A2+dFcE5RBQ/MvhtIccosdcFx1j4G0pGSWyBkrPbkep047YtF4oSQ+HVSbPHFSVBa9pFWgNfv7+Mh8eG7cUaGXKLZcNFTQUdRcD3YUuh6CsGn65bgP5TYBmtAZjRCSJxGsZ616RU2WTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OjP2GbiW; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+vcdG6lGuZRXnpXO6e5OsfJNnwYADIh5ZoFn83mLfRWUlvfEy4fbkrXwmrHNUDbIDnMmbvDgTbH7C/Xpjn7xBf9Rq213ZNmyBSZMEjicTz0bTBJ5GIYASFlTVlpLkqjIb25kunzVBuTJx/Qs3T78Qybf1AK3ClyjcEsvGhSAD1NZGbtTFlW7LTUsmyqFzoZCydlg8cJQSPsOjJ+P9ASq+k6TbLoftZpXeSfSkuy7CNkTmkI8yD35V6HNg65OgOxDNVT5NUM4lh0rhXGQvtPkIPL4ygVj2kb5SEbFIu7bqiXrePGx4FFA18Mh2QHKORtXBCsdEdq4ncDHCYnxlWtfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwtxmPMcIxuT4mDO+fChe19CHAw9k9OzD1WDaieIBk0=;
 b=n00yrT+e1e0BcF6Juth2hJtE1j1sxpGM9ptUM/HqbPcG/ir1VQR3JA/q+yE2Gq6q5SfAkSR1Zj727tCewF9/oYCx1Na4+yKViZRsn7q7t/2MyWaIXDwEe1hTd95GFTUPPROC8uOp4ZzEjKKTz+J9PzXrV3FLrFbUQl8McOh3rZDcEczD6quPTM9nR/yh+L/yGb25Nl6umLdXPz2y6VY9PRc+hr917Yv/T7wiDycz3hiGeeB1DGEGYPQSTstzIYnkFJpjGRjMJQocMm1IW4tYP/bWTsrr5DjPVaKE8S+fgEdP0MAcf6YyDHa8pfYQldrNf2B8iiKpRRSKPCsaW4i7iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwtxmPMcIxuT4mDO+fChe19CHAw9k9OzD1WDaieIBk0=;
 b=OjP2GbiWfH87Zj2Kt8Lwe+NgDaTUGqzDqgiEUo5RpfdzxNec9rvYWPDwMszApCQB85ezQMHJbdsigFN5TY4eDEukUfEf7bGGKUHu3zEqKIAT87A9GpCtJHDhD2QxoGeSTIjOTmprLDsbU5q/P79hsi+7AfTouChSfF+aCU77xz20V7hBSXTDTiCnzTL2kjp1vqI/Ujgic1zXrI8a3rWZUe/H6PnbGNZR7RX+Zxt+s5W7zFMxECJN5FcMEEciz9nuXuTv9UsTjYLCBPxExCwTW4AEioSntuC8fomZ03/TNg3LVTQSWnCZlpZOT9NLaKFpwGZb1TIAy0oXSGW+XrC7zA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB8287.namprd12.prod.outlook.com (2603:10b6:208:3f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45; Fri, 10 May
 2024 13:29:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.048; Fri, 10 May 2024
 13:29:29 +0000
Date: Fri, 10 May 2024 10:29:28 -0300
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
Message-ID: <20240510132928.GS4650@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BLAPR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:208:329::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB8287:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e4d62f3-7fce-41fb-9837-08dc70f53853
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XDN29k5xO5jUhKjrpn4F9XdUoY+NYiKo+03JByeG329J5RxVE+CLrmMnxOzA?=
 =?us-ascii?Q?Y+9r6i+YWasxT5iJIyENKBCL0CswWBLAp65mZJgRgpHTpxXOFcZKQgtiFDGi?=
 =?us-ascii?Q?Lj48sj2ZClRHcUAKQNOOibCL4I8kdH6XX/pwaMLF8ItYgF5Zh842yWDtBtKI?=
 =?us-ascii?Q?VwRUji2cHRULrZlIxG/gqG2qNCjKslNffiX7azCQ+d1GZKP026FKlvJhJQoj?=
 =?us-ascii?Q?CZbU7ITvhcI448Y2a8RRtQstDPMHSBBdS7oMy1OiCktlCf8WPuWyYh9Pw7JT?=
 =?us-ascii?Q?IjnYgYBOND3VBCAT6oY+e9J7pJ2HF15zQMZrsC/6NdcjRA/julZHWc3o154o?=
 =?us-ascii?Q?Jq2PA5+HgLdwqeHxNS8M21tVIr74pweeakBhoLAMtum1wqPmiBnqLG+gI0kS?=
 =?us-ascii?Q?fL+yWNm2WolsmVHBz5reDewkIoD0ivwDE56uWge49+6sWmjDm6kMCbhL+ZiA?=
 =?us-ascii?Q?6St5DcvDb/Sl6gHBUjS8LQMUkkXa3UNm5KdxTOn4hHRzYYIYrJ+789o3nHYh?=
 =?us-ascii?Q?3OcdgLVwwAXmTnyR0cYDaQrhRFlScdocMgkyBPC46rUi8yRaxEFNAz8wyVCJ?=
 =?us-ascii?Q?b0MqtNWIw8/zr8T35ngi93UcvlhiyIhH5vP17Gktxhj33aUl3KgTCmL3uNtF?=
 =?us-ascii?Q?QALTXYBLkYJRNX1km36j8YuPnrqSGdRdJ1TzSF+ygHfts3zy8HWZ1SOsYsfj?=
 =?us-ascii?Q?uZ5DWto+k3tE6gC9XzNKUIgcRbTqlPItKwLIjxkWAb9EHM7yT+dtQuymXvdM?=
 =?us-ascii?Q?Z8xAytKnXqjSVhkE3mkdGtWhlf5DbGRhAOYfgBtsflC5Nfhfvsqeoa6J0CpQ?=
 =?us-ascii?Q?wQZJZUsqKtayWs9iRpZjRlkFJmjTBFGZ3lq80kz6Z5hnU8xwFqFkhgoQxgeb?=
 =?us-ascii?Q?yDHQItANovkekpM/vZhGCJoLA5Sd0qzlaIDwXty+25fiHPNejoGsaQU9qSaz?=
 =?us-ascii?Q?offJ+5U6WB78smudDuh+59cFtvhN5XKABs6Cu7XiYwuUfmXMVLIkBCzDLQPF?=
 =?us-ascii?Q?kBcV1kJjchEUwZC80zW3TOoa9gllDsHHfrqdELqikgGDkaYh1gxJgc4ROfNd?=
 =?us-ascii?Q?4Nzynr+Q+Kj7lRl0DPqwc3RVUYkrVWRyyuqGdfByYEUP04+RnsuGlVKbu+s9?=
 =?us-ascii?Q?QdzdFg4gojWfIvmDA4ztLxGwCEY2FmH4u++4dUdWDO6YIqcxo4tvfnMsEWn/?=
 =?us-ascii?Q?vvBk5bKK59QYmZ7Wlt5lJMM2uoVa87xwrPst3uFg7x8LNfOJQn8gHG9gBBch?=
 =?us-ascii?Q?fGLxkqh26RKGC+fc5LSBsUUvrHNZGxtt3RqmNRnMog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aonQCCqaBEMSadhJzwW5Anz3552NQq5JCOKwbvWAu3Iq3FG6T8cF9E4XmrQW?=
 =?us-ascii?Q?UYCKyz4imeENrWee1nfO4PyS+BFm5nKVblgPOF6fAoBAGOWKkFUF1DoNPvia?=
 =?us-ascii?Q?YpRm85rV4YeVcqNrHZBvwg9qTDDKmaDZdjtuO+PGEB8gUg7jJGh4JWxK5gg2?=
 =?us-ascii?Q?YRk/tmy+raojtZ8mWCYUL/OpXlVN4ydMwwZJsp/2XkZn9k1o2duZTA2LgUkN?=
 =?us-ascii?Q?rEEwe2i1c3TCjkGyBGW75CGAejC1ebXSfhPhJIx0taYDwFQod8YisSdNKrno?=
 =?us-ascii?Q?T7EX4lHnGU8M1CZwtAfbheCuPafiR0Zw0Ep4umDpmd68h+uy42ILVKd6tZ6k?=
 =?us-ascii?Q?Say/6O2dCc/EB2aCq0Fd0GXFqg9tTmRZRYFKXZEwDC4roEDC0zwWEToEYoAp?=
 =?us-ascii?Q?LqkTe1O9BwruIGMuxH8CZvjwQY+UOxVUxkaZ3cCEn1FkvvXxh7DEcdQKotzD?=
 =?us-ascii?Q?VVmz0nUONxWCTenwAcmVBzjUmvPhgLdCLGfYAJ7Wb/IVSwpbZ6+NwEjBeMfl?=
 =?us-ascii?Q?cjwpULS+UUUyEhxkGr7/DUApFNCSfaAeqmYANnkPnmZ68YOv8z4vOp01uPE2?=
 =?us-ascii?Q?QazyU1fSs7KDFn8R1VAxiYW/YqJN54w1We59LXQCF+E3IdAWRM081fPiqGcn?=
 =?us-ascii?Q?AdvFObHLPRjro7DFZHwgUk8Px+7ttljWApZH4SZLGqX3hCFNfmZwCTKbgtQZ?=
 =?us-ascii?Q?JMUHdARXFFbRgHT+ZNAMjtEBDJ+MVmeZbJIZ5rUeYKFts90+uvDxpuNatwyr?=
 =?us-ascii?Q?ZDX8COn9LCaUmr+IAuTxK5OWncxjW2HQKSuCq4492BY1hFbgzS0yEZT9dpti?=
 =?us-ascii?Q?wHXz4Ve0mDowjpSzMYme18OrfO3u3N314FijNlbIiLenpgG+biM7d7qkDGkC?=
 =?us-ascii?Q?GPx3C0Om3edO9Jt9dHPMd2UsI4yUbnLnILS1VPoaIkU8X9QQasASF9Re1DNU?=
 =?us-ascii?Q?VG2+VfGBlF5djRAdA/iRIrEvH3kaJqRkA49UK3/hfM61xRqCN9acZurBGpxN?=
 =?us-ascii?Q?vMhjA/bBphLdoS1M5B6Rtr4vaxj7GsOA/JXtZ7iwnRB2+MLpisJ8w/hOCk63?=
 =?us-ascii?Q?0jxG9e8L3jemYNseaLjDb1kuT7mbUgp3FpmYtPyayr43+3g3GOjE3nEa1Tzv?=
 =?us-ascii?Q?oX5o9sVM4MAicOjtCvVtUpM05YTdqPgur1xGdOqnn9f07t/PoGY9su3sMVV+?=
 =?us-ascii?Q?24HZYZpqBYh/u47X3/ytPpENOlKgGWPVVnondGgbmBD/hFXn3P7su8mVuptL?=
 =?us-ascii?Q?Uo+y3JMjzIooge9VVw7cNrqbZ3tLydnVUVgofCNOAw+Xnd49a0q9hVfCfc0F?=
 =?us-ascii?Q?d8eGIY6+Cz5dtYjBVcf1eR7DnsoMaSBEDO/+uXFm5CgMs6E11Hr7yLRlDMNO?=
 =?us-ascii?Q?VHbz5yQS67eyS89OGHt4+elUxoQZzvCrfHEnAgJHPqtbHyt2GHUPxpJyeCIR?=
 =?us-ascii?Q?0MCIswIUKCJx1IZBxnlmAO9v+0eRQpm+ygxDQoz6Mbwd8vipVdiZGP6qtvXl?=
 =?us-ascii?Q?pU0h+Dn23aqX37/4wCSQ8fMjjzmUc9VO6SfvpFWKcW04xDDsLGP3HyYfzKIA?=
 =?us-ascii?Q?PCzaBfBT7AgzFqj1+5guhk13Eks026+lgB8EGfnU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4d62f3-7fce-41fb-9837-08dc70f53853
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 13:29:29.5476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJjTQuoVMEBFCEcNqhcQJ7CsKY5H722z1IMlbsKOTLAeqsUFXJAPXBdQhD/eYN/h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8287

On Fri, May 10, 2024 at 04:03:04PM +0800, Yan Zhao wrote:
> > > @@ -1358,10 +1377,17 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > >  {
> > >  	unsigned long done_end_index;
> > >  	struct pfn_reader pfns;
> > > +	bool cache_flush_required;
> > >  	int rc;
> > >  
> > >  	lockdep_assert_held(&area->pages->mutex);
> > >  
> > > +	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
> > > +			       !area->pages->cache_flush_required;
> > > +
> > > +	if (cache_flush_required)
> > > +		area->pages->cache_flush_required = true;
> > > +
> > >  	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
> > >  			      iopt_area_last_index(area));
> > >  	if (rc)
> > > @@ -1369,6 +1395,9 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > >  
> > >  	while (!pfn_reader_done(&pfns)) {
> > >  		done_end_index = pfns.batch_start_index;
> > > +		if (cache_flush_required)
> > > +			iopt_cache_flush_pfn_batch(&pfns.batch);
> > > +
> > 
> > This is a bit unfortunate, it means we are going to flush for every
> > domain, even though it is not required. I don't see any easy way out
> > of that :(
> Yes. Do you think it's possible to add an op get_cache_coherency_enforced
> to iommu_domain_ops?

Do we need that? The hwpt already keeps track of that? the enforced could be
copied into the area along side storage_domain

Then I guess you could avoid flushing in the case the page came from
the storage_domain...

You'd want the storage_domain to preferentially point to any
non-enforced domain.

Is it worth it? How slow is this stuff?

Jason

