Return-Path: <kvm+bounces-49639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D4DADBD5A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 01:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D1777A6A1D
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 22:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9435B223DF6;
	Mon, 16 Jun 2025 23:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qBGWWgKq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392952A8D0;
	Mon, 16 Jun 2025 23:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750114819; cv=fail; b=iD67wHbCK0Qrer6Bjvj5ybxX+ouWnLrE3lyXFOajVQ28WU5BDIftMv6DVdUEY7CX05iLWxCOQkoGBVErXTd5UbUklAgaSvyx26OxmOk/GUgGew8Dl7T1RvMmtmDlWrCuXsBUrDo5JojuFagiViKQHiXFbWxQhTUeuQtUhkEojXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750114819; c=relaxed/simple;
	bh=muDMjaNhoKAT84AULJGHqZZyiw0kdbhkfqrVJHfPsjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FrKuD+6DcHgwUM0fgOdJSRLv71mhrVKJCuXVtz3SS2rv//jwX8YXg6cCHbQQ4bzLiaNLmkDjmMg3TkZqvvSlfWwTyNGt7ShZe3lqBhjB+b1lYzo9FG5b912pE6Gfmp83RPH6z5+kx87YZV27Ocj2ySaioc/VgvEUC2EKWetNX9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qBGWWgKq; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dp22pfNLu0NnQNlNBUxjzxTgWje4g0pP0HVyjEvIGJxPpFE7CVLrsBdl36jFy34Xzys2ha13vstcvBybFCau3aPIbdok+bagz1sOIEkmdsbcwPCi5ObdopGgPpjADoTc3GQMOG4+WmpXS1FImS6UKhnV53qgG4Gh5J8N7gaV4wdLHbvCLL1clkGgTc8JOEXIoY0Jf+KYYlufdIYGbCrGsW4k/JkRojhAgnqhCML5X8dNbMu1hvHfAoRQZtIG/iv2SVcraRnPJvkomsRuxwMzplDdlFRmVR0mTXKZtjSW+jJLazWSsWGKvE5ZsgyInZdNciGIy6emZaNQS8ufwDLmxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muDMjaNhoKAT84AULJGHqZZyiw0kdbhkfqrVJHfPsjg=;
 b=nu25PLHKv0mS22i2mdrrS0YYU6Xb5pnQIQTXoSGG6gowAK31qLEExfXsFC4Ti+cHv3wIFvud/iHmjlOdF1xKaR73Vs4KGhrNxLsUOWOFiF2YVLyscD2gT5cRWLJQ4bNimAiLzmuDOLmdmvluXa0CpBqCJjRR0ZsjlqS0Y+G3KvfDJAwT56G1KAAlqoxkx/ZSox1Ek2T/dSEfRZzMtzAo+lKJY652mNrOZad5O2SO0X28J3QezEm9mtYP/uX111Z0GHAG+RyWrmrTns9ZhtyqrO6rquRRDk7FDDqsBsJdiE8TJf9PBEU+D0HUgVpgI8oKvzkXuf3/Rw0jx8pj6j+lUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muDMjaNhoKAT84AULJGHqZZyiw0kdbhkfqrVJHfPsjg=;
 b=qBGWWgKqWwPdabWzZBTbE2nzAPQKRCsPRpx2L4NFFtsdl2/3kwVNu3fvIW+me6NrUpHt6qHJ6ttPsPcdqZpVKy9tvb4d+EFKRT2jE27e1m3lEkNRuhQBWkiwyAgC2HfVKkZp4j140LaV1TSDFmoskP7+eK0xYF/d41iIkNb4BHLDcG84qUpXqWpefNah+I1OmASl8oQApyPDiDnnYaCISovaRB8XY5so8xRSqtErUyBIaZhDiePIkwMeS6cDsmbjMi7DHHdtIwp7LOonR5iO/TkOP5CdChdDlSjyUlxEtdt75O9Z22nPm4We99d6rrKwwLbps3E1so9AjQ7WU/Iufg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB7566.namprd12.prod.outlook.com (2603:10b6:208:42e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 23:00:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 23:00:13 +0000
Date: Mon, 16 Jun 2025 20:00:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <20250616230011.GS1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
 <aExDMO5fZ_VkSPqP@x1.local>
 <20250613160956.GN1174925@nvidia.com>
 <aEx4x_tvXzgrIanl@x1.local>
 <20250613231657.GO1174925@nvidia.com>
 <aFCVX6ubmyCxyrNF@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFCVX6ubmyCxyrNF@x1.local>
X-ClientProxiedBy: MN2PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:23a::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB7566:EE_
X-MS-Office365-Filtering-Correlation-Id: ec76aae3-5e30-416b-869f-08ddad298d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tgYGT01hx+SyidQxbQx7qzd1e86DStbYt292R9SVGobnh7x1no0lC5Vy2kkf?=
 =?us-ascii?Q?5ygnMQADzKT/0cc+qyxP7OTOxYcbpEGBI5iKTl2QiXdkWNLF1jlZIvqKFBXd?=
 =?us-ascii?Q?B5V1OaJif1au6yl0d+MEpXHBD5Wh1ahXtuX54jpspC45Tps/DcbEsZjxc7xZ?=
 =?us-ascii?Q?9r9WpQI2/YQt/hGMKLf/CnZ89JiIIVVXjse3so6KF2rXSqghY/XRY54ugr9j?=
 =?us-ascii?Q?4BY2GRI146ks99I1kP8JZB3WjIC9a6nqBRUP5SCz8KyFionAbnVWDfs+daGg?=
 =?us-ascii?Q?aK2tzqXjjFpaE9/AqglyUfdXsdfHYbbqhyi+HBJ6PJd4GKL35207GMvnUe3/?=
 =?us-ascii?Q?YmH5TIQjWw7hYb1Y3KXN271gXhQZ4maknBs/ZXMjTVRg7tna9j+MLJ62J+Wl?=
 =?us-ascii?Q?JQHnLJZp2U1m0MTweHjdg9HdtfZoA3j1Z+zQnJlrbAvIoZFr+AF6QoAqV5p8?=
 =?us-ascii?Q?27LG2ZDv75FfJNcbMEX2CZlocWoHgKMlQ84ONrI2dwFMjd+UlomY2Kuwvhfa?=
 =?us-ascii?Q?ohgWKHiT0yNhMHALzg0tuZxk810OOp8x136vZeFbldq/U77y/swFr4pw9DKW?=
 =?us-ascii?Q?FJ8hM+q9o7dtDndKhwD3H1fgcIhIsLd2BiwsccKOhabvVKQGrwRdux+hIMxe?=
 =?us-ascii?Q?5GXfUOwhoWEekOqRX5mEiHm82AOsUi0qaD6auOaoc6ogT91wTXx2ijMsJ7oZ?=
 =?us-ascii?Q?+8j6qxhb4R0z1LO7UW1t7A/EPRaCfwDuf+lVenO2JstfsXYreqiLPbgtZzNC?=
 =?us-ascii?Q?KC8IhbOXgRVNzFncnjjVX2oB1YzLaetC8yuDdrubgYFeAezT5cRkxZvjx+EF?=
 =?us-ascii?Q?17UKO8RaMGUCoUCuibPiQHzDXw1kaB4Jl+9JotsLyXAuwJRKbrucOOdnP1XN?=
 =?us-ascii?Q?Ko7fUL8H+hwpfo7Zj5zjBg2Afs3pQgyZqnWy2YFU/gYh69w+7oildiIFUmU4?=
 =?us-ascii?Q?uxDeZcBmkMn6cL3c0iECvyEpBY5DLRf8xE6TFVEAB30UZ4XPRjW3WSX4hvhZ?=
 =?us-ascii?Q?6VBbBmnow/L/J9tUkSbu5hGpAwNinq6iFyoOrF2i9twCPNWbPmU3s9NSmeSf?=
 =?us-ascii?Q?vvoSHh/aN7Idcum+vMKn+Qa2eNSMs4ssvjEzNh3HsZHj9R+24/ivQkxnMsvo?=
 =?us-ascii?Q?SCvIAjkb9EFsDttHZ/xEV/Wr469GOqF5OClzRi6L1gzoHAC1cbJSUS6/CJwH?=
 =?us-ascii?Q?N0lbDsgjj3rNMPtWLQ1Y9g2vQ59GxRu1RamFSNhNQ5WaSBeX/kWXTtbBaSvI?=
 =?us-ascii?Q?lgX5IlEsTa6jzKEkrGIBKMXD09xifho0scgT0YVnkii3uihNkDG2Fj/5ZFbF?=
 =?us-ascii?Q?Cg9l5m4xiYQKyAWw//m1llKrYRAQ8wouHsbRKFWJ1wM+NVYhymb7COt/BCGB?=
 =?us-ascii?Q?WWzmVJtpvHqNg3k7CC7wveM4J2RgQE8vc/5UFAe6a5nO0rSsBVCwCuicYkR4?=
 =?us-ascii?Q?tITDnR32I9w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f26esCfIQ6iNSM2yyGttNvYjBCE/FaqodJSC6ULzSs/JPdTHZGvB1jb0EIob?=
 =?us-ascii?Q?Ne0hZ2kvuT01isBdfod6SnTUDqNE4K2P3eLnpdkPjkBDAYbLOSMan21zBDS8?=
 =?us-ascii?Q?HaFSmVaY+JT2nNJ4VaOzQb5jXGIyKfS3lGnKoHzYxKXVs+k3hO2Hf1EwGxtf?=
 =?us-ascii?Q?wWcQg5hB4GabW6R5241RS/88v33z7Uo7rLxX41gLhB0am1dvyBwDEjM7IdJs?=
 =?us-ascii?Q?Thr+hy0cXTp2kwOkTeBumreEkH57E/GE4FETBuBD3yq5eAwjPU1t0KzFl3KC?=
 =?us-ascii?Q?7RnX3jj8obo708PMEIjGHwWf+v3inKtxClpNMShVV10E+oXtlKX+or5zsisa?=
 =?us-ascii?Q?KLQfEsue1vkIGuM8hVW3bEVL5zeTlCRZINLmMeMAh04Rr2bhZaeaYXIXanRZ?=
 =?us-ascii?Q?y9TgTeXpERu2tkWNPELyJOp1YHXOt40M8SZqEmieVspgiaIWK23gXqORYq/E?=
 =?us-ascii?Q?s95kLMqs2TcqHoaveivFFf65kWqIiNjxSOIL0AxRpf69Bj9ciu6PdSPv6kil?=
 =?us-ascii?Q?APHrxzo2Uj5C0RigWpBwtecd/2QHfFrkAmXFblOWD1ykgOvCVG3vRv3FdspB?=
 =?us-ascii?Q?3Y+PXUk38lX2I+KstmUqSuMPoGMRLYwNI1iXoBTLcZx2WHwpfPaXz0jq0/br?=
 =?us-ascii?Q?NsT9wS9IS8E7afKooa9TpH1rFEhcJlGRgQnRAsu9j1MY0llDeCfYoErIPtHJ?=
 =?us-ascii?Q?sobcR+ymQcXbYg9sgtPhULrxWrZMNZ353JCOuYyRcpwoOVezuGQombYKUx1y?=
 =?us-ascii?Q?fvZA0s4evJ6lIDHx8UIRMohzuexFOGk48MAed3Q63lP2cj6TOTAQfvydlp4E?=
 =?us-ascii?Q?1+KKQ4hhINVP6mSxAelmPBmP9197yb3RP0vVOWMI0FFbGcez4qoaQvyVkGus?=
 =?us-ascii?Q?j3mtrzg5ZmxZkKnGe6lDNOcU/pZG6IOmAwT0la88IPcCwMiBU9O6myWwJKHr?=
 =?us-ascii?Q?hk+Mk4JxLbvP03SIslbkXwnV1BhobustXnADOax8FI6Tx/V/v/lTCPupXZZd?=
 =?us-ascii?Q?5BZtGXU0BDPIxc2TxwCwhb4pL0mu5LQsVw5VTwsmvfZAmLdlpledKdZ29d2R?=
 =?us-ascii?Q?p4tO/MvOkMRjYtbN8FpwjCTRYqhF3bB4SSHlAG1k/26+g/Voqj4x+fvbu7Pp?=
 =?us-ascii?Q?hj321O/zC0AEj+OfTdRGlao0TvPp7aSzisGk3wTnugnKCN0lk3C4+bGymwuR?=
 =?us-ascii?Q?QNSNFZzse0AmIxKImFjw5wozSM09gfvBeeG6sK6is87GlX8T3ODbPKEG1/0v?=
 =?us-ascii?Q?HQZAuOY6d6nN4Xp3VO5ojG75ysGT/kt4WR4pA9tqY5BfHVmwYfq+StJsVnrN?=
 =?us-ascii?Q?mKBorOClG/yC/SjujnqWttiX6PpVHUtlJIhO5A+HMJgU9eLAlKDmd9cNmgAf?=
 =?us-ascii?Q?XxhNltTwcZavrK15U1xoxvWko8pyuEhmxAEW+jled33gZYd4PuZFo5wJR66O?=
 =?us-ascii?Q?9ZdsnVLmqtC4CMD5qjRA2VSG2jrJBWZogtVwg2wgxCGBAZXnXOpFjilH3AgI?=
 =?us-ascii?Q?9GS+dr5icQ+drYKo/HDhVhddvyNIIPmio6vC9YYYYBMfcrB8BH6INqkoCYpq?=
 =?us-ascii?Q?PIKo9Dl5nCJuMdSR+Vo6YsTwlIe045JISje46n3y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec76aae3-5e30-416b-869f-08ddad298d0e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 23:00:13.4289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qb4DRb673GX+2nyNduuma+kwAhWReIsdQ/gSS6iYvhMiL81cwuDGUdwoPc14ztZ7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7566

On Mon, Jun 16, 2025 at 06:06:23PM -0400, Peter Xu wrote:

> Can I understand it as a suggestion to pass in a bitmask into the core mm
> API (e.g. keep the name of mm_get_unmapped_area_aligned()), instead of a
> constant "align", so that core mm would try to allocate from the largest
> size to smaller until it finds some working VA to use?

I don't think you need a bitmask.

Split the concerns, the caller knows what is inside it's FD. It only
needs to provide the highest pgoff aligned folio/pfn within the FD.

The mm knows what leaf page tables options exist. It should try to
align to the closest leaf page table size that is <= the FD's max
aligned folio.

Higher alignment would be wasteful of address space.

Lower alignment misses an opportunity to create large leaf PTEs.

Jason

