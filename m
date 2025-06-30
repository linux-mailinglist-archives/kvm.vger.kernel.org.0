Return-Path: <kvm+bounces-51098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 189B6AEE010
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 16:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C42A163C81
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 14:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8E928B7EA;
	Mon, 30 Jun 2025 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r3v3OKIJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9EF2EAE3;
	Mon, 30 Jun 2025 14:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751292344; cv=fail; b=Ly1N14NYGvO7ZG5TVnYZs560ddRpx8khjSRi/q13sn+KM5mszR5RbFUzM2QkNzXoq5ADaEiTSc4kD/fYIWMEdiV8RuKdPtscigqwJViC5h4jd8YC9w5PSWcUiDqJfQDSTx3cPdunXW6mpbESGMqQVPtYhtS8dQRyxG1bYMieRjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751292344; c=relaxed/simple;
	bh=5z/PR1+B2Ry1GbXAJQfG+8grFhIUkNBTa6a7LGT3CLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VeWVC8lY8ZSrWLZY3w7V8AAdBFENsF0dTZOWEFl14lm0ugI1OAGFxihha6EQLULqSGj3AxjFVXP8WDHOwd4mgt6ENGoAVndkgxXnI0XSU+ExQ+tMUBIZEILcl6J4PRF4RzCurQTon/I5ejycH2PKhHOAsGbAR8et7gdDGTjZ5D8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r3v3OKIJ; arc=fail smtp.client-ip=40.107.243.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFeZGBC44Eru4540YjSpKW26l0BgqYm455UNs4fTgzNtWGzF/E/7LhqT9ZfaqEHm874QgprMrdQsLPZAoMWaG05tYrQJAkjV1r3PeTzpN4nSAJ8CmF8yGQeqEssXv24NIa+zxRsVT2sf2znTUabllEYV3gl9glR3dJPFQKTpDjkU36GIY9Phao58F2sv4jomuJCqfYRYaA0cpbLzTsHJ+jVAO6MsFREdV2/2mTwLhpVk6WDuVbaLDwZW0uUKKVZaskQ55U/+F5zpyL/gKuqGGtEwKuvyVeGFl/CsPlNb4IhqJ0f8UkiFhyFmabAXC4rMlc3Mv9N7tnDxFGbzs0uCjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/KdEzzURSfQczH+RWTMDG580fTYDJA/Wb7a4rd0mps=;
 b=HWigZbvWXY8WJnDe/6HyLQ0SR1Mul3lrjK8dL2cBWRYv54x5UXlN/KRmFvXUOozkEaI3IekMQAdQvyA3fHDsxctzTiFNakY52SrpGi0IL92XXv0xYqttCczkL5GEVajoBKeT4NPKB5N6PmS27jf/FwYTeoYmJVVl9cYB//6xjgjoaWBLWks8OiJgeCRTeq3yWWo2CGyw+ypIjn6MXa4geB9PD6rJ7EgINMqO+n2YE3V7U0LdGP7WOWDxjZud1ClVM+QD1B2CBCF9q7iwuKPwfKFzjaBuSUAy5WBE/LGac2k9CCdKX+i4WQneQ9qceEKwR9BpVH0NH4HkQkEMZzPV2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/KdEzzURSfQczH+RWTMDG580fTYDJA/Wb7a4rd0mps=;
 b=r3v3OKIJAS13FBFqMVjkLbB9+gOXPkyRoSeq1UVvHbgtcqFaG6quDJ+LcRPkEcULNwqqfoxFoqMM63xPooi2DyDf7QQmkcSZvhryzYFI1kSI1QTXshd0iwygU1NeMBFmFx6zl/9Uu53derfS5lC+uNf2nBf7biaSXzyYC5qf9KBVW5u5apBYCO0scNR4Oe0GxoEODxA8HI+GyqbvzEo3fiIAQ5sum684/oVwA34RuOtDyLgl2gnOdmFMKsd44pEm3YMjDb2gf54cWUI9UB7OMToNPEsLkNrWVdgbEdIU80OTXkONF+2AwD1qKL8UPI56GRbK8xAXt08HD68pYCSqfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8035.namprd12.prod.outlook.com (2603:10b6:a03:4d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 30 Jun
 2025 14:05:39 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 14:05:39 +0000
Date: Mon, 30 Jun 2025 11:05:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <20250630140537.GW167785@nvidia.com>
References: <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
 <20250624234032.GC167785@nvidia.com>
 <aFtHbXFO1ZpAsnV8@x1.local>
 <20250625130711.GH167785@nvidia.com>
 <aFwt6wjuDzbWM4_C@x1.local>
 <20250625184154.GI167785@nvidia.com>
 <aFxNdDpIlx0fZoIN@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFxNdDpIlx0fZoIN@x1.local>
X-ClientProxiedBy: SA0PR11CA0153.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8035:EE_
X-MS-Office365-Filtering-Correlation-Id: 6718bb7c-90ff-4613-68fd-08ddb7df3128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XyUbJzKq6sjNvu8H4dsTArBcxEQMKC72uQrZcjIgh3xVLwrkAvWfJqzXpukX?=
 =?us-ascii?Q?B8SUr1GKvAjaCMCUNikAtQ6zLafHg2ETWOtKRNYfZYUjNTANrO1CkuCz93Ba?=
 =?us-ascii?Q?2Kcw7GwM7BcAyU5BRZb/rS5gXHtDh0gwIwu40IOHBWB6b3Yvd9u1fjDvXpTz?=
 =?us-ascii?Q?MEWnvX/1aJiU88niabF3RR28pl9/DBVjA1RoucNxITbfF/t0i33jJS5lnPvZ?=
 =?us-ascii?Q?W8AWSGFNdmz08U48T+pi80TiMS2tp8ST09zD3qPeIeb9Y1ExzqsOYi4emU4n?=
 =?us-ascii?Q?FczuqlRPiRBjBD0SRrSWrNVGq2PTD1Of5qA8o3TEdF5ETheu5SVfps+kWDdQ?=
 =?us-ascii?Q?osOoSOCnk+kP5Ne1MmAnLXitnwSlsTn6wp3QjJhOWErBbdExaQOUllHHfDl2?=
 =?us-ascii?Q?a4o3Dgza3B/U2M3gUbBS0xXE/PCytf6W0Lj6zkAd3KqCVpvd+hiZWhLikmn5?=
 =?us-ascii?Q?1fmdTHVK/Q3Xz+22MVnKuuaq2JjxOg5cQN32vpV1qsm6GAjWorqY8/z0P+O0?=
 =?us-ascii?Q?Sj86I5txqUMf5NwOkUHjETM6FI5QZunz1/yxeCtUPLxSL9m+k5lzgj7a/lHv?=
 =?us-ascii?Q?phh3bqjEP36yN6BdDX0YNePDHb1rkmjgotyyELRepJXV6e20J0D7yk5AANMJ?=
 =?us-ascii?Q?ORCY9Gja/LVx2+pWprLP3iRGKojRyygQrIoyAWPFRurVFTL1GeYUgGN+ZnMu?=
 =?us-ascii?Q?8gvVBdCqO7jWogWfS8DcR0slY5Q5gwxSVyFDVLZt4tH+zB79+GY6S55p1LEX?=
 =?us-ascii?Q?jeqhDyzmYP48WdIbSSqoEOAfXj/o2Iv6aOjULTPHDMVaY2Q8sznqmO1Ij5Ru?=
 =?us-ascii?Q?oRQHhDcRdpBGMV7bkg3KMTOTop037593CPaakFSNMDod/+toFh4KePTgaC1e?=
 =?us-ascii?Q?V3AzuaTjCvbdDy2P/KzdC+kyYJiI1gXmFEwtKR3WBXKAx2XlsU6yyhglp8dH?=
 =?us-ascii?Q?9/WpdVxBPkB8xydLlUad3nky/AoLk6RDdC3abbU81KwuxAtPxo158kaAo+Ap?=
 =?us-ascii?Q?ZI71Mz/lvcVfzyfPc7D+IaSEWcFKCCNjr9BN606zWxrnNj5u3jMIZPg4rBui?=
 =?us-ascii?Q?S0igI/FhqDbj/uMWR9RqpeVdrYLZ2E2W1rBWqYCkXHIx+ph9FAErfK/E9AYv?=
 =?us-ascii?Q?kYYLTxfHXdLNHfPDeRSHWeKvibzK5SzkGLaNN0ufnKKa0eLitsXy4SkcJsZh?=
 =?us-ascii?Q?4QM4fR6SU5d7X8XIlcQGmbT1CE0L+PGEbQ6bpGTFkb4fgjQPEzoqxw75Qmvj?=
 =?us-ascii?Q?n1KMRJyZwLrJU8vHAZg5MNp7fV8rQimp3TnWd6jFQn9R66GoSnnsXwDPXG22?=
 =?us-ascii?Q?tWV9Xnzeh7vfh7sKEgDE0ZbHBevY6lTK0Jfuaoqa6E/nlMFlAgIIjGl3OYCz?=
 =?us-ascii?Q?dknjffzonDV1mWQwH333cP43Bi9CerWeqEcKSZn4xqk7Ty0qLzVUBn8upKXb?=
 =?us-ascii?Q?IfJbDxHpTdk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6dDg1lTVI7Q8teQlTE6L45VvkgrJzda6vW/Us7bWi6Ck9xlHNl23fQMO0T7m?=
 =?us-ascii?Q?XurX5k7eleh34nFiLeSk9IM6azOzhAOPsk7FiNl8AmYGHQgFocdh0vrEm+an?=
 =?us-ascii?Q?TjxRP6eFAACNF2DiLhQeUxtZI0reqx5hl6yIW9wKnPgG8cQHv8OWfyUEc3io?=
 =?us-ascii?Q?67Pf6mzFDaixdGsD4KdSPL+Mf/FRK/QZKJYSsSPvSxSbU3M9xPm+QtPKax7Y?=
 =?us-ascii?Q?Ac4Q3XYezUAuDBRtExmeniKaQIV7QUZa2R/gcnAjOmqdtKTLZavHRSqSHZdP?=
 =?us-ascii?Q?rh6buc1LcDudfkCbHjWhlKpA7T3RKRfSxI48LjEVc4rLGvVD7NEOY/a9rqja?=
 =?us-ascii?Q?RCoq9PGoqJXehPPNxy7s/BEJw2ZZZxLJYZNSpi7sVhTiwK+WwgVdrkb0YvZa?=
 =?us-ascii?Q?h4f7133r4CKoI3zQW5emcRBsj8hgbO22mouW6O2ax9pGN6OZzvowEcaKF16i?=
 =?us-ascii?Q?y+/1eQ8NcGhh0tYKaNU+CogWQI6CcSjbNAUXJAAG11LmdjzoZE0Zlx8atejj?=
 =?us-ascii?Q?IyroL6j95poQkcuaCipus1o0DgzVNMeAlMOhG25RmD098p8AWPIaabL5r3vU?=
 =?us-ascii?Q?VY/6E7DZgKPTO4EVKz1pD6quNMRXncPaQxwNuEEkxpVzFcOw9G0b+TYB0N9e?=
 =?us-ascii?Q?dzDkI6Hmggwx+5i7TlTKazgRlOqr6J+wfIIN9MBW4OOL26V9ZajjIr5MFej1?=
 =?us-ascii?Q?YlAJppUbarZNnYXH7ceSA2869/Gw8721ADFMnbNYLnV1CsChTldz6naxsSn+?=
 =?us-ascii?Q?kn73F/BW+ENg/IVT8W9wk0JLzV5g6/z7EEMI2rTdA/tb8Nj/m17hNfEAB74C?=
 =?us-ascii?Q?fYciMxkMpwQaxld+S334RaUpEeq86/NTlnrM39XKv3d3XE595moslH3+wyS7?=
 =?us-ascii?Q?U+djZgCQNaSiADb9I0E/j3Pq/eH/PC/Ba9CfEFOVeN0uKjIwTz0zzNlEZe2g?=
 =?us-ascii?Q?/Mv1gk1adqEEIHihi+zjH27eHPTxFVyiWcruQBhBCx2AMb1iOgyoSJOwUWgs?=
 =?us-ascii?Q?CSPil0s3VL5kXbbhmM5K8PFBg5vmo/qjLHUnctqBRBnrLlYdFzPQJJgEyB2O?=
 =?us-ascii?Q?i1grj4FrxvZDuX8MA1RH5Y7p3+qN1xaLL8T6zGI8c6es5ehoJXIhnurx2s5S?=
 =?us-ascii?Q?OHsun+f7TjKvHxbyzVt9x0gYPZ6d4W/7AEZLFmGq2qR9USSwN81F5NLAailL?=
 =?us-ascii?Q?AEK/ipnAvTXnqURkWhqofmNiS7Sz1GM8wOYZ8NTRfuf/Hb70IT0tqhzu/8KS?=
 =?us-ascii?Q?UcWpu1zCSRaePVXSiuqkpBDjPEHmbSLocpQ3W9TTphXhJl6E2wNve6R33Os1?=
 =?us-ascii?Q?7HfJtI5Gyv6GIL5DDWtgayMWWAZiFBghFjPswr1E/u+FU3EEmSXioecu6nHj?=
 =?us-ascii?Q?SpM9jZxkj1mP1qrLaM2NblKRKAarbtmQ98tU8THiAzdUnfUMljWMYD2S9BJQ?=
 =?us-ascii?Q?dGx0Ddwu3zMZQgPfbNE9zJCoGjhx+D3jfBlcufcjXLNfW7+eNLkEyUZwZ7RK?=
 =?us-ascii?Q?4G6c98nsOx9kGmbD1m8FcxIwf10wQxej+kMAoXut5OR3HmqgFv5vKlCRH/El?=
 =?us-ascii?Q?ZlzErfqEnZERL7O8QrSS24ayNA4/lj83iTBkNb1V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6718bb7c-90ff-4613-68fd-08ddb7df3128
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 14:05:39.1007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/o2mCclrBU7G3sVSyrWr6bvj5XszJQoQIxPFDeKKFR/i2x9JJzosqxz4nuJJCsF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8035

On Wed, Jun 25, 2025 at 03:26:44PM -0400, Peter Xu wrote:
> On Wed, Jun 25, 2025 at 03:41:54PM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 25, 2025 at 01:12:11PM -0400, Peter Xu wrote:
> > 
> > > After I read the two use cases, I mostly agree.  Just one trivial thing to
> > > mention, it may not be direct map but vmap() (see io_region_init_ptr()).
> > 
> > If it is vmapped then this is all silly, you should vmap and mmmap
> > using the same cache colouring and, AFAIK, pgoff is how this works for
> > purely userspace.
> > 
> > Once vmap'd it should determine the cache colour and set the pgoff
> > properly, then everything should already work no?
> 
> I don't yet see how to set the pgoff.  Here pgoff is passed from the
> userspace, which follows io_uring's definition (per io_uring_mmap).

That's too bad

So you have to do it the other way and pass the pgoff to the vmap so
the vmap ends up with the same colouring as a user VMa holding the
same pages..

> So if we want the new API to be proposed here, and make VFIO use it first
> (while consider it to be applicable to all existing MMU users at least,
> which I checked all of them so far now), I'd think this proper:
> 
>     int (*mmap_va_hint)(struct file *file, unsigned long *pgoff, size_t len);
> 
> The changes comparing to previous:
> 
>     (1) merged pgoff and *phys_pgoff parameters into one unsigned long, so
>     the hook can adjust the pgoff for the va allocator to be used.  The
>     adjustment will not be visible to future mmap() when VMA is created.

It seems functional, but the above is better, IMHO.

>     (2) I renamed it to mmap_va_hint(), because *pgoff will be able to be
>     updated, so it's not only about ordering, but "order" and "pgoff
>     adjustment" hints that the core mm will use when calculating the VA.

Where does order come back though? Returns order?

It seems viable

Jason

