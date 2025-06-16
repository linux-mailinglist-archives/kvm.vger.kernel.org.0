Return-Path: <kvm+bounces-49611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BCDADB025
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 715C1188F3D1
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EC0285C94;
	Mon, 16 Jun 2025 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="isQ9ZlTT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC1227A139;
	Mon, 16 Jun 2025 12:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750076799; cv=fail; b=jQamdjItUBnJI5XfyOZX7XCoAW44hOU9pNXPnk4oJXZGrVkYx8RCWmaPzS+ZhSrIvV1XaEbnjMw+wjdNKXQaN/4Ae9qMxWJ0S6JpZTzHJkgItIHGhRw7ulv3zX+HTckAaB+Y1cCV5t0XkKC8CfR2Oo6Kx1opg9EG373pLETnddU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750076799; c=relaxed/simple;
	bh=6ssqLimz159dAurYpC9qO3vbdyZHNCKASCeamPj8mo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RhoW1iSupuFOxb4MaoWe28Yt8zJ530uBQTYxcXuIZZSJK+UUjMN+RHNQtw8oewwRYGgF4dwFY+zDh7J/UaZ7QUCVN2yz9A4UF1F+XZKTngxN/+5LlSyLaY7xHFTLA1ZNmjV2GprPGUsALxd75OEi4UlhYnb32yahAPukoJwR4+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=isQ9ZlTT; arc=fail smtp.client-ip=40.107.244.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=risTlCxi4VVgh14pGNKrBM5syJZGODsl3qxlf0K++xteKvvpAzUSUwUERgwWKW1AehQhZtu3NEQkbUF6Px81MKjjBJw/FcVEA0dA7ipWtUvS2T4Lyw89M+TSsK09kLRTaLccNW60aroBUdYhl9AjgSkm6C5y3suEfvuNnts5Bj+Yyr/UMrge6Q3T+6ThT80C/L96cHLVfVtf4tzUkhvoaYF2RB8/pcdH617TbehTJEDpfuYmtN1eu1klv7vuk/fg+s9ne464BOvFWOD4atxN4h2nA0wQ5dbhHvrVfXwC6wgdS9S2Dftc73SjDsF9Is0K1YYZJK9AHyFog88Mp4Lxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lGHuOk/sSN3NyGHrcACFz2emWjxZkZMnyhaXranI38=;
 b=qSy618zYPyRMzzZt1tUxJFGni8qe1Nlh/y5oSs0wqzFCSXq/8auE2KUtFxHAy2vnDtwm09tVFTAH5AIK1a5nryWcUKAGOnYQ6gDoyZ34WYttzYSt7gl08UtBP/mzxWD4g+EJcaHAzH2ycgrC0MOdEP/uCxghk8wzCiT37euhaEWUCOHTH3bJKb289fK/JyL4EIwZZp7By2bEn03y5SVfR7gXIjsskKYOoHUVO0gjGf1TjLG3/dukE22CwQWCuWvxS2dVVUTTBTglLKnVaA7rPRuA2TqeFpXv6Q+YQHhRICb+trqGmLVjsYE/YqBYVJ6LzEfDZrKH+fyZwYHsJSz32w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lGHuOk/sSN3NyGHrcACFz2emWjxZkZMnyhaXranI38=;
 b=isQ9ZlTTmWvOfKV+VkerJkZ8SyyjEvBmEdEDJUag9/AVVgBps+QPvOqBXQqQu1Bg604mY+dO4l+9s5Hrxnz4S5WPllYtudUCtLkq3kvuZuAIYASFewFijETSvnQ4boeEtNWfji4qG1tbSKKA2RxjdNxz0UFjFl+eJWEX7qGxq1cj/Q6E5onGpvDLTJwPn8vPWcVhKdHv9CYiWs0Xf8wCozx++w73bN/rlAtxWgpMxup9O2HwJCUf3vA3dcZEFfITVUj6s+CghmmtWW5CniiiotYWqJJZrXreP7nmIe9aYWTmXO/mL7YY94F8bxrxp5aX4YkAArcIbZBFT0u4LODJ/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 12:26:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:26:32 +0000
Date: Mon, 16 Jun 2025 09:26:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <20250616122630.GT1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <77g4gj2l3w7osk2rsbrldgoxsnyqo4mq2ciltcb3exm5xtbjjk@wiz6qgzwhcjl>
 <20250616121428.GS1174925@nvidia.com>
 <bb6230a2-8a9d-4385-ab14-a40b273f4c60@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6230a2-8a9d-4385-ab14-a40b273f4c60@lucifer.local>
X-ClientProxiedBy: YTBP288CA0002.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: 6833142b-3c9c-400d-200c-08ddacd106e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PNs8TvvcwiWHmBViR7GXtRadktwmBIT6OOtSI9SC/RfnDTGf7WcWeUUsx5Z3?=
 =?us-ascii?Q?/nB28KtWkkaYltvQ2m/5E4D87Y6793ZCB4XApxvyP8glBCC6mjRYwh1Qog8t?=
 =?us-ascii?Q?TUU9gtOjZBG5AlxwscHDq5L6tJ7YnIk0Jc5wwPA3LBbRduXL+1m0ri168yHH?=
 =?us-ascii?Q?/WE5mfLW7wdYcq9cVGtELEpKIrvaePipcmCDyuRnjmVQ6Lveeos6i/pYWEJm?=
 =?us-ascii?Q?AAmvR0tTsJ8BmiQ+ZAOr1U16I9uBS1m6rZZiSezpQSOJGJfM7JpP8UNy6Eih?=
 =?us-ascii?Q?/Po/TMG1W8fTR8cXk0OANSZiFLQac6grc8nrpdBFczV9ylGIGmp17Jess7Lq?=
 =?us-ascii?Q?qXIL7Qdp4LR8Z7HG3Uxy6im954NM14yxKOh53z+OPcupwBquEmwzEruxwaYv?=
 =?us-ascii?Q?d7Elh8AQ0kcgzv6Cj8RQoEiD7ub87eGhmgWBWt86A9yYuMB40w81LkkSTjtE?=
 =?us-ascii?Q?o3c51cF9eYAxlTsmBx42DiuTDk8/YuNzxwZ1n/Jm5FkJYP8FJ/jYkni8K+Iq?=
 =?us-ascii?Q?5dIboA5ijBKWI8WthxUMAIeCwq+DIC1LfPK1vMzamo886QzIK13q1A7SxHQD?=
 =?us-ascii?Q?Ty6Nc6PQWQRXKC1/qWh1ZdOQKUfmRjMUR1Px3BRRRy/tXmHe0Hj6YPIbTO39?=
 =?us-ascii?Q?wVyencAKFQiKWTL2c4DOtRFnwZG1PM60P+AWmXUXSzEJ02AbMmM4bsZ6sd+R?=
 =?us-ascii?Q?JFlp11FvxoxJPU1iJvCWRY49jqvkPCGcPOYcvTvFAD87aow0NnydM8gyy7MX?=
 =?us-ascii?Q?KyqjfyYaLq9pMXnvOkQTuYPKeyJz30CfyX7h16GdTaTLJYWxR2My0xCCgNlQ?=
 =?us-ascii?Q?Px6oLZ2oxB22J8o2+6DK47qbfbv+eUkhGP6ggQXtTN2YxhCxIWDyxwJ7pAmS?=
 =?us-ascii?Q?LMG/GxmnCANJzWu7RPmLByuh2REiswBku4Ur+mJR8/DvRPqjDI62Q1Z9qMow?=
 =?us-ascii?Q?FNdLhPqU2xYTmwbYWfzaADmaih8FuOQnE4tc0D5VN0++4SqacN9nMU77rl/R?=
 =?us-ascii?Q?XMOi1OCQ7+ZSLNwSY2pZ3r89KkRaO5Cljfe5rjMgcazGW2MbmqdJ5EBM93St?=
 =?us-ascii?Q?77v310ZP9d7rHOeFS2AKYjSRHKwxZq0ZeHHKZ5AfHxFh32ek+xfFQQZxDHTz?=
 =?us-ascii?Q?sBat+rKZ50fijwY7iSFbpxgffikAVgBG/z3Imn0PIAgwqQT/py6nryO64UYk?=
 =?us-ascii?Q?8P1mnnW+/FrnAR4EXAu/utZ9MKEpCbV1f3g+BsDgVqZoTOrL2ll35sF9OSeQ?=
 =?us-ascii?Q?HCpflKmM0QRoA6JvSumRhmOc1ti6FPSDTwqYWV/VQ7gTg8H+rG5WYGEoNLFt?=
 =?us-ascii?Q?JFBcWhdHZ/6AvZkXesVN/WKY4w18CZeLZpKSWa5IqSe95P3BHAPpGn+V8BVl?=
 =?us-ascii?Q?RW492vJYR/IeyHdKQEU3ELRUHByrW0RXqTThD8e34ImbalZw1ZE/N5O2HSUd?=
 =?us-ascii?Q?13t7b06OFxE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9+Athj50RZuisRjTkFDnEsNZEJ++H8N2ZoaoFC/W7dYU9XGe4A3TqbD/COHr?=
 =?us-ascii?Q?PxVbCU+qBuP5YI3u3PT+ZnM9b/vjC7xVy5rpy/VRU+CH+P4Kk2In4yOYtnYP?=
 =?us-ascii?Q?XeudcjWOqhYZKUCNAwrweSHt/e58WrS1dc+uhI8uTILgMhzVPzURPFxR06n0?=
 =?us-ascii?Q?e5YwRDkPlyTpSloMF5zmTU4BS1u+eiE26NToIzCFK8UrNSxD/3zc4eMscP+G?=
 =?us-ascii?Q?w8sClvHOJoFawVyAdDcLnrbLZc6TgRfDrCeOZ+P5psPBBKG3uZULmXebl6Xw?=
 =?us-ascii?Q?pPLev3G7inTDQujyy39S38jTAwD4nNZeOLYv8nJfg60sF7Lj7aFHB8q0EdYS?=
 =?us-ascii?Q?jx7009o2gSSePkzlMZuJZDp++nu0mx8z5hZS1bGww8RpaL6dH92J7ypcuTCl?=
 =?us-ascii?Q?+VRwDuAuUSuwaKAAp54Q9Wpllgrc1y2OHPnSGO1+Jk9+tHPV87m3akkaq/RY?=
 =?us-ascii?Q?UgOcaq8wPQrfTzoIGHY2TIOoHJeACI72DdQzdI/TL0w/YPVqUtBITW+AQGsq?=
 =?us-ascii?Q?cNQYwbHyvW3moZxpm4L47w5YxC/S8OPL4SljR/JcK3pYg2+OHQ4oySGJpz1Y?=
 =?us-ascii?Q?x8x7KIHVnblZvafpLFP3Wt0DWmYIkCmruEfbfLRtCpv3SonEjnsO0rwhJ209?=
 =?us-ascii?Q?DaePv8fOTkaR9ynVHNomB6MFpR/uV4/tRz3fwV3gzST6GMju3ZV3vZl+KMkF?=
 =?us-ascii?Q?Tl7+98rwq8218XtmGnwsNEkMbfyR0Aca1n3Lz8pZz8cljVudxAN5mUe6hu7p?=
 =?us-ascii?Q?+3Ej669plI2R6ZIdueqLNjdGQkpDghExTy9/5P7Bjxd/bXCgWmak2QPifxdE?=
 =?us-ascii?Q?GDCMTe2oFSDHtAFJ0bN8jluY92DpgCbfETtZsWZTJS64kNCnSTGgih09tdbE?=
 =?us-ascii?Q?hokngsCH7WNaveQl4AhUWS83R84YlCaHCmb6MNZsSJ2Vv0D2f1O3U9FS6rGX?=
 =?us-ascii?Q?WVd7Z0c1zAvThlCDheL1tNP1rgFyp2DXlSN+Sz4SV4BNjB6uKcQ2Jzt81DD7?=
 =?us-ascii?Q?9ViCTA7SvpVB+mwZNNt1qDasMKoZG0aapTL9u+Vez4Dj8iF6qnCyx5EveRUD?=
 =?us-ascii?Q?qvmN+GNOZWkfJ/QpxX6MD55C9aeuThFd4NpSg4Y5ItJJrh7iQnbAhnCuWS8p?=
 =?us-ascii?Q?teKmyD1g5IKUHvJDYOJfW2mczYOIpN1g1L6OUc6wV48OvdgvXsB7pB1pPNAG?=
 =?us-ascii?Q?GItjWn94E6GwYtJNE5Ti3sDqVx5TzFj9XSQh2WqagN2Kyc+S0lsfGT0o6+Xu?=
 =?us-ascii?Q?i3UXzKyFN5CxmEkWWPJmHBk1vIAf6lCrW9rWn26CmerY1crthXREgyrV56p4?=
 =?us-ascii?Q?s1DvL21VxC1GkRxa/5xdrdedJ8X1On3AvZSqVoGOshhQtDymw06+HvWIL0/l?=
 =?us-ascii?Q?u6q3w2bGO25lKvSEGNIs05GFEt8ltDeD45eoKFHVHxTzNc9q588prPOwWpu8?=
 =?us-ascii?Q?uSY4tF49+JaYcH7SisDJ06ltsvv+aLrtXL7xwgP2z4Dqw7acHgm+DJXOon8j?=
 =?us-ascii?Q?UcRZRWRy8JxNy3nD22+ZxUAzdSkNgp9B1wUvssmFuV/kXl+VklcsYDvyCwlA?=
 =?us-ascii?Q?MR8hVBzjp57eXd9dicg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6833142b-3c9c-400d-200c-08ddacd106e7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:26:32.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cG26vsdtJcbyW7DFTZQgqVW5lHzBYdDFfFGPq8zNc8yrqoweaysVgpo6h5D9L+rU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060

On Mon, Jun 16, 2025 at 01:20:55PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 16, 2025 at 09:14:28AM -0300, Jason Gunthorpe wrote:
> > Also, probably 'aligned' is not the right name. This new function
> > should be called by VMA owners that know they have pgoff aligned high
> > order folios/pfns inside their mapping. The 'align' argument is the
> > max order of their pgoff aligned folio/pfns.
> >
> > The purpose of the function is to adjust the resulting area to
> > optimize for the high order folios that are present while following
> > the uAPI rules for mmap.
> >
> > Maybe call it something like _order and document it like the above?
> 
> Right, if it were made clear this is explicitly related to higher order
> folios that would go a long way to making the generalisation more
> acceptable.
> 
> But we definitely need to have it not filter errors if it's generic.
> 
> >
> >
> > > I also am not okay to export it for no reason.
> >
> > The next patches are the reason.
> 
> Regardless exporting it like this raises the bar for quality here.

Yes, it is also possible we have the wrong op, I know
get_unmapped_area() pre-exists, but if we are really cleaning this
stuff then something like get_max_pte_order() is probably a saner op.

It would return the size of the biggest pgoff aligned folio/pfn within
the file. Then the core code would do the special logic without
exporting this function.

Jason

