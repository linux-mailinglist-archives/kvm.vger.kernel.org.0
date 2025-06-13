Return-Path: <kvm+bounces-49452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA00AD9248
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA7207A80E2
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B214E20E030;
	Fri, 13 Jun 2025 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KxFZQnu5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2074.outbound.protection.outlook.com [40.107.102.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A34432C85;
	Fri, 13 Jun 2025 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749830428; cv=fail; b=Q3fwH2wR9oHyJKjZUwNsPBoVsTYnwsfybhpQvh5+5+aVf9tvYObTELVOJoQzsiv2toattuGiVp47fL6cbQj8C5Zv0MemEmwn2FxmrZE/Hl091StRMjbUZ8I4f4tnv4EoG45ALBeiLSfpqHKmfCU/7ebHwcLJFpecDv8Gp1/Fd3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749830428; c=relaxed/simple;
	bh=7IlkeCVyY+BCkI1dP/XVobZwdKmhQ1J31IxP5fcRc0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F8uN8m4/WzktaM3J0ZblNfgJky9JfwCT6m9h3Ani1qDnk7v6izWqGhAZmnmyl38UYZofY4NUGWJ6ddAYpKw9ISa0Mg9o4ts5LXs92HNaAv6GM+Cm4XnKkX8o5z6czDCzr7CspCZMgL5KJfXx4koULj4tFBcr3UzqFt8wLZ3HFno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KxFZQnu5; arc=fail smtp.client-ip=40.107.102.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5/GQBga8XiD82WtK252RZjdBxMEpCnBiafDXiKOyJ3uNS3a1nEg95ptAHm+zB+7u/Aywh9CBabBmbav5dHTNRhG0WSP5gni+ds9wBXxbfEhbTIE46stCRp4xkuhjwE/FFoCX8QF1rlLALSywWOvN1uDQ7NgjK+adfQr68xM+zsW15Ct8pEvgY1QJnCxc/agV/41ugAUFGkr1CWmlcOb5XLfuJjEDSDxPuOeNDa7sNG7P0OU5Jl/DoprnF0sHDuVslVpmmzxj39001P50veLJoKOkMIv07LaBJDaYXNkGHk5OiyjqNrKpHP5CIBE6fEa4mmat4mUJ2S5TdQOBxHi0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+epYEKfTJJFcX9siql/UVZ96PAapwlvMTVCYN1Gra4=;
 b=LK1SwpQj/i1dou436tOQc4y+up7KioYF/9/I+ac36WA5jmF8UtI03O+FyvqYFMblFoXIb0MOgrqzozN04bhPX/8cQS4haeU6rvTobDiGdg1UpQ+z4Y/ffnAHMHevdHgRCmk6BQJX5cLeUfwTpvdN1j8jyEb6YCNM8GD+kEtqTNZIki9LVFJcs3kXw/Q1QRqYIv7d0Q40+06c/kZa2PUaWZKNv50FA8hoYGUU9dHgbxOU7+KnKeuYS7WcIQK9uwY8gGwFQ+DDcJvphmCNWVvEewzz328lsfJ3G5eCn6Ap9pfc1Apn4JdUCbJy8RBKTsIxhcXm8RaST09SNl9H2sSBrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+epYEKfTJJFcX9siql/UVZ96PAapwlvMTVCYN1Gra4=;
 b=KxFZQnu5ePofR2vDK4f0YC44MWxfyXcWmIRck7dgFuw9Kgx7wX8WTnk5y4htmfWrbSL9BEj9WQpnIJ7HKSCmsied2qAgLpuZxGtAUBCvFLs5SYPC08FXIAXMNmpyrtdHTk+DAPto8Ouh34+q6kPujyq2UDJELw3gNZ2n8JZPkfWH6KDJeKo+jCpFN1Bknk062txTlPAEUjuD8YO+EqZPItvg5hzuiddGArEWTINR8XSYyfN0/qJ6DYIxnSOD1hQnO4eZNvl0FF8JOoplylHRRhyece9NikMfLRfNHBknSpUjTTyRbi4eA018Lol1zvT88xpUfgNacoA45K9oyAvsCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM3PR12MB9286.namprd12.prod.outlook.com (2603:10b6:8:1ae::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Fri, 13 Jun
 2025 16:00:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 16:00:22 +0000
Date: Fri, 13 Jun 2025 13:00:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <20250613160020.GM1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <20250613141745.GJ1174925@nvidia.com>
 <aExANjUUpmkpo3p4@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aExANjUUpmkpo3p4@x1.local>
X-ClientProxiedBy: YT4P288CA0095.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM3PR12MB9286:EE_
X-MS-Office365-Filtering-Correlation-Id: acc28684-b6c3-4139-85b9-08ddaa9366c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gv3YaRVwAFevUlu3wAAL21Erd8EZ/pM2GTFZ6yp355yRgWFE5QXeLGMF1pg8?=
 =?us-ascii?Q?+8wWatkdCVF0F8r4Go4FwYNUQpnb36T9Z+6x1sea1AKCHknCPUQGjfCu/tak?=
 =?us-ascii?Q?VzSwQHm6cgKxABP4Q+LMwZcaFAllkBvBzaP823LeFUNumL+E3A+oVfA8jgXm?=
 =?us-ascii?Q?d3OnaFFCljVnt7zmbmFpL/4aA7al9vDjteQbtn3vJQcpcJ+deSS2PQzBnZtP?=
 =?us-ascii?Q?qSYN6JUpR37EZPvvwChZPLnkA6khE9LNwhpYubxCh9zR5K3LIypPOnKXHIrr?=
 =?us-ascii?Q?pZNpepkA7qf9AkQ5Tf3cpODq+yCCrtYOShmXSDiadjHh7XQwUNvHs+jxoXBG?=
 =?us-ascii?Q?kVQIkqtvAbC1pLA4VqSwWCjTtHUPPFXzlYErMyTHPj9ewWH30a0q05qObzgB?=
 =?us-ascii?Q?fr74ETgXcZF9BSmwIkziEMhmXKooYLf7Zsh9GHhdX8yQjd5kPvLy2G15qDwI?=
 =?us-ascii?Q?HZqonOWtBGF04sRd28/GSHyCYWRPzrqLxfaVx1o1BaquBDVTtZ1HZ0lRKsHc?=
 =?us-ascii?Q?jOhxydfU9Np6RVt7vmWE7DUDdSnRRBOh7nb1gkIv6yBpDL+6vKUpveT2M86L?=
 =?us-ascii?Q?/9cqyd8MUMeaPgHmfsRcbucMviWdw1CljSq5OjP0u4KKLLuoJc4t3mYAkTb1?=
 =?us-ascii?Q?6mGI43gotxdTsBRp9BxtRpmOVmWVbtGaq3h04LYDaFHviY6+UpSFfP6fageb?=
 =?us-ascii?Q?9g6c5cR52NQYKpbIZcbFzVi68SWRXa9G3KjDSkEnk4PiXoCtP91Qs56a+agg?=
 =?us-ascii?Q?KTwFFvYAOi0BDvWex/U6tGGMIBBf8Lkf6tDxXvKgJhTaDdmaMK3KwM/k3yxu?=
 =?us-ascii?Q?jEO/azidqhiIofvh2P3H/ddheIJyWHJDAX+XIfAxTYZRP/kvZkyfDxWRBU8h?=
 =?us-ascii?Q?Y2oya9MH5NfITmdZ8p5xzUBkodbvfFYtEi8IS95KKNhauifE2Ioiq1DK+XTs?=
 =?us-ascii?Q?vEsHrlKkh8/E5XJzxtk92Y9g//nhIpurE6ejptii88394NM42DuY5eQbvc/x?=
 =?us-ascii?Q?23836Yrc8XVljvNRAtfvGOWs0+Ex05nkt6z9eXlrCvHGG+Ai4tQyvJK7OWOd?=
 =?us-ascii?Q?Ls0bRAjM2gkewRey9tdxREc9q+qGJGai7lRopTm1O7/B9kt7G4wb/7lA7uXk?=
 =?us-ascii?Q?PuNYUcgcr6L8ChBMm8egG1bBHHhHR3NWCpFXezAysYv9LIzDdwK96Ww0+Zxf?=
 =?us-ascii?Q?xRH5OlQgYn2nfUkojTxmzYIZ/s38up7LOHTYEfuqnJyF6yeghAfWv2TZMpWq?=
 =?us-ascii?Q?uCfy0uPlZ7tWkgZw4Zodjr+QdVl/JUs/Y9kTF/zag/x5hPbet/uWsiQ+7Zvz?=
 =?us-ascii?Q?yMtjwg5JGPbjpBJJZtQ5ijMHRmVKBsAb4BGYHTsh3Ys66iv3D1SaP6HW+WsN?=
 =?us-ascii?Q?Wi6lRwFxpAYMujOveCfLNlx+wSPy6mGVtbvbfxOu7y7nQzkWv2iGcQ+T7d1L?=
 =?us-ascii?Q?4WUHl0AVq7U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?drplbR4EtmIL+ztQE8yE4nrP9FsUJRsXdF5zlZ9bcK2tDl8RT6Enl7MSySbA?=
 =?us-ascii?Q?kcDGVWwAGhF2ICwgO7+p3CnzIKsgDZ8zhh9u/Wt2pYfSyIGOvNt/KakKde01?=
 =?us-ascii?Q?AbN9eRHKVL+ReE2qJWymA4Y2jsHaNXFnn8qBpX3botsbSTI3qUai2AIy0exh?=
 =?us-ascii?Q?qiEY8gETHRqAoKlq6wKDENRwnxl+fsxcaKwGfbEdQLlLk057BBw3xoW0FwYT?=
 =?us-ascii?Q?mR5d54fzC5vqlpODjk2elKHqvxs7BmsAeXgVzERDjJM0KridxaOpRJA/g3hz?=
 =?us-ascii?Q?RHPd7Tuw7F4XBoGwjrN7dH3Mb/XKx9XKB5+RsenKZItWsl7s74M3ihZ3I22u?=
 =?us-ascii?Q?iWjimBdkCc/EXJHAXNhSfGRVvSx4DAP2OSj3yxtrpTkUK2eREQWjIKZHDHwZ?=
 =?us-ascii?Q?vNmmmkWk71jgf/qeFCtHmyI0gY5FoBZAGv6yPx3NbWsYr6ppG4F8cXSsRjQN?=
 =?us-ascii?Q?8F1T7+l33WIlvlbm0yymaPff20JD9qIgBmbY9eY0MZvFr6bYIeorSSguUZQk?=
 =?us-ascii?Q?mmMa1mC4jLMVQ0q3Ey90OXyP2jA8QTFN81/FV4yDLZmnzaDXifDy12MSnv/M?=
 =?us-ascii?Q?4MSp7nH1EJ+0uXXKBGb+RGsHY7+60KQz9/ugkY9gS1TrkrVAgLzHhp+ciFIi?=
 =?us-ascii?Q?1zyfFA3AHmuNJeUxXLIFrsvFHvBSYHjegnUF3dZ1/ePGW7cxhAuOpi3t+kuv?=
 =?us-ascii?Q?15ieOOu4vima2jhaJd3j2WGXxpmlD5onWZqPEMAkcZyVP4axCbAsIieEiIMF?=
 =?us-ascii?Q?OsGy/nvcSczBO1ghh2vA2zIc6eUyIZa6MhfSg7GzZHdITiHyG7w9otR5OVtr?=
 =?us-ascii?Q?pkPusCb0rdqivwoQs+KVHnsvsECQPlWfhexPXZAg0nw3g2NsydVkvQbBPvq6?=
 =?us-ascii?Q?4qvj+WiIcE6v/75cet0rR3TUpF8QSYaynvO/2dcogvEdSwC56tfGBRn7AEDw?=
 =?us-ascii?Q?xPEd9cf/Bwt/iqGePFnZVdM5oyuL+YEVLpHX+cAtKZum6C5mNd96Kzx48niA?=
 =?us-ascii?Q?cxYkp5F1HlbF7GHRd78biYIAbidicbkFXu3Qm7FChfps5MCuDn+SW/5bAJf6?=
 =?us-ascii?Q?/vH7M19YD6j05QUEYNC2VK4MiOrg4yB7Iwfyz2Ddqic26xJlgkt/dNrVTLI5?=
 =?us-ascii?Q?WnfDXasT9xn9YYvCM0fvpWSj3wYUxj0eLq/KMSGLxIr/CDDHeX0Qyn2WdqQg?=
 =?us-ascii?Q?VxezroZeLBW1htJ1k9/nSsLRTFSsIfsvBjPcdswQat1lN52lBwuURCkjjwZ3?=
 =?us-ascii?Q?wXl0RQIjLU2c4rSsW+R2G48wz+rz15tjOQjG5zWb8QE6QpUsgigri901+k+4?=
 =?us-ascii?Q?M55c3RZSLS5qtgreYiH7yAO1QFSure3ltoP9BDfzN/dYi4NUGxkVlT9zR5AQ?=
 =?us-ascii?Q?lFwfB+xcFsKPL1U65cVbJKkfbbBul0HONG+66KLHUoBW0xcaDWN1lquaK7gv?=
 =?us-ascii?Q?nQdqnHyVdciX72Q1zChAVbQBTcqHZqCsKW1mkgoprAy7iIGzW3W6XbTxojpq?=
 =?us-ascii?Q?c40J3R1+ON1E1bNVFRdHyw/hhh+LuGp2zTZJxjngqvMLVpEZnY2CHqIcUAQ7?=
 =?us-ascii?Q?IuCXYBrPnzy34aSoBCgJEkLu6Bp150V1Y34X1yhr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc28684-b6c3-4139-85b9-08ddaa9366c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 16:00:22.3762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UU4OVI0mztj+dHKRRR8ki5V/Jpmh76+YRpF2v0Waoo7ZDgYwPeNFY/MTUOqV74Vu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9286

On Fri, Jun 13, 2025 at 11:13:58AM -0400, Peter Xu wrote:
> > I didn't intuitively guess how it works or why there are two
> > length/size arguments. It seems to have an exciting return code as
> > well.
> > 
> > I suppose size is the alignment target? Maybe rename the parameter too?
> 
> Yes, when the kdoc is there it'll be more obvious.  So far "size" is ok to
> me, but if you have better suggestion please shoot - whatever I came up
> with so far seems to be too long, and maybe not necessary when kdoc will be
> available too.

I would call it align not size

> > For the purposes of VFIO do we need to be careful about math overflow here:
> > 
> > 	loff_t off_end = off + len;
> > 	loff_t off_align = round_up(off, size);
> > 
> > ?
> 
> IIUC the 1st one was covered by the latter check here:
> 
>         (off + len_pad) < off
> 
> Indeed I didn't see what makes sure the 2nd won't overflow.

I'm not sure the < tests are safe in this modern world. I would use
the overflow helpers directly and remove the < overflow checks.

> +/**
> + * mm_get_unmapped_area_aligned - Allocate an aligned virtual address
> + * @filp: file target of the mmap() request
> + * @addr: hint address from mmap() request
> + * @len: len of the mmap() request
> + * @off: file offset of the mmap() request
> + * @flags: flags of the mmap() request
> + * @size: the size of alignment the caller requests

Just "the alignment the caller requests"

> + * @vm_flags: the vm_flags passed from get_unmapped_area() caller
> + *
> + * This function should normally be used by a driver's specific
> + * get_unmapped_area() handler to provide a properly aligned virtual
> + * address for a specific mmap() request.  The caller should pass in most
> + * of the parameters from the get_unmapped_area() request, but properly
> + * specify @size as the alignment needed.

 .. "The function willl try to return a VMA starting address such that
 ret % size == 0"

Jason

