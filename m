Return-Path: <kvm+bounces-50592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F8DAE735F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F9C94A0114
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B24626B093;
	Tue, 24 Jun 2025 23:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nqq+XII3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020C1219E0;
	Tue, 24 Jun 2025 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750808441; cv=fail; b=VwNpHLE1OpKHwcR7pJh0vt9G/YLmhmUx7yG7xIjsx27zx0G6eppcjXW/SwCx3TNjcO6lZPQM1JlIRtCBY7/oJXFp5HUMmtvjtQtum48tQCz/l+DlEZCISLfasLq69sJ1MfVVAAk7KWyq0kvcYEBViElIEojtl8TZeA/htTN89VU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750808441; c=relaxed/simple;
	bh=zY1dn03xG6O/pNPa+TEnhY11rm4AaIC2oF2lknkGNQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V3dEeWCsuFg19EvXwOMPHTiyafP33swfDpEYBDL8QT7T2ne0nangTK+rv+Io7Bg2eUr0KcmeJgyCgALzwfgdn1aIDK4uwnP9c6J9HZehz5h1AP3Se22AohwOQFQ8imRRBRofeJGJPC6vV/zP2lEOVcDWz01jB4Yba7wWLQt/Wzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nqq+XII3; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRH3uI7IFMpFV0bWmpJEbountPr6eAFKniryhN9RO1dNFNr+Fa7ZDVikOV8xxCVxVRZT8h6DD0Qbh3cPMVS4+3y5BELx4hwtyxvLqjF7ZyT+/ZEMyib42ScEdk1blWrDEWyKvciXhVNfmE45ame6GX+Kne6wUK63iTXpMfXI0DmmbcyF8mztg/U7krvLz6b2q73ZWxteIXlnseMCnYkZNz6Kjpcgpx1afMpe2uQ+BMKQQTtNKz+9kogXyGFBO3SfpI7yw1/nmleSz3rB9kQnGwLfVovkbRQOmjyhtoUQxFjKMzG0CUJ22Ox7JGAEnmrMB0f8oqtxz/Bk+mRgq38/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PwhEnGbytmuilaqqZR1D8Zgw7GngsgDs1vzu/8rYZM=;
 b=D92HntAOm5zZiERkwV5ztnZ6ZH16Oc9WT4ud6ZUkLj3vUeIlA5C4+PDZDmHi9SggGLc9rSbklYxYDkDWXdcrI8eLyemuLHy5/P3HTyUWXQMRuqrN26zret+qDAfbfA6q+Do01bSxpbplVuOnT6qu7qhZqGUaQf5F2zN0fI+MVtSlTCxNt91AEe4t0jyIF5LDd4SyLSB1xKIlM/qYciXu0BEF2vKnNsivXct5MAutGao0O8Wz+e/aa8DntZZY+xa5Z4oKlcHwK0L6ZF5VYtNQELM4nmx1thp6g7q9xI3UMTYcR55kyO8n248LWkr/viYvjO8A1n8VqJ8uRPztUdSndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PwhEnGbytmuilaqqZR1D8Zgw7GngsgDs1vzu/8rYZM=;
 b=nqq+XII3OzFxwXIqD9+Dvkj/GMzBAnHDkjYB0++86/kZP3UIJEFfmM5wmSKcCFJob3Nbj3yzJg81wKTvisHHRZJmn5XI7q8sUdnzpHEc34SJnfY08/mFoHRHdh/GRAIKrlGZiAVzwNnaoUCjI3VcF8SxWrktDvf/JJ2y/dGdZ3WuKHqQpLZHk/sqfvvEuN19+hZ027DE0kmoy+xCaqbwZeutqZqaHkuzTxRHiTIJCd3eujhBZ0Si9ygPSpY6oJg9ykH64JrwmYAei7lrq/WYPngiVg7nIXRln20inijy7yRJsjHbIxWX5QYmZ9mWeqbZTwao+1M32z03MkjluEJ/dA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Tue, 24 Jun
 2025 23:40:37 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Tue, 24 Jun 2025
 23:40:34 +0000
Date: Tue, 24 Jun 2025 20:40:32 -0300
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
Message-ID: <20250624234032.GC167785@nvidia.com>
References: <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFsMhnejq4fq6L8N@x1.local>
X-ClientProxiedBy: BL1PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 69dc79d3-d7b0-48a2-c95a-08ddb378835b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?luIrPdCSjxoBhP4TheG60CRoQ7jzhCit79qB8F5srxqG58Xep1649a+rbNaX?=
 =?us-ascii?Q?B78m2RadElH0JIqgc/KoURCP0NzXlMorlkwYGyPYzW3tI/lpwlo69C3Qla8W?=
 =?us-ascii?Q?Tq6QbpTiDWk8XEMgTQOGoDb+E9A9gHCR/uNnobH3V30PI2as4mv+0cb98yYs?=
 =?us-ascii?Q?3LnEgQOanyGXLhR5qL7q5ZCgXP1r7NuHZITHx0+n2YFKrKvbb0Lh3u+1/9JR?=
 =?us-ascii?Q?hWI1kMeHYwhJro0GiwiEoWbPLyUQgJaVxNpaRR6iytvH3MU8PFxbNQcu98x0?=
 =?us-ascii?Q?gSevUi8MP+bMepoNtfr4up5ACOMPYIvOXCjUwBFUIpXFTXtPUgkA/v0N9+Fd?=
 =?us-ascii?Q?pEOYcSyHaBXG333JY6I8iqBWkTV8c1MTVPZMxxyAwRxpJhcpwMaxdU8HBRQI?=
 =?us-ascii?Q?4GLCRdYMjI+BjbaIko04hflc09OMk25Exn0N0nqRPY9kdNkratXIjum7QvgM?=
 =?us-ascii?Q?Jzx3Oa6UJraUP6gm6gGrCElghls1e8Fnvu+bUv2LUdX0gGbNw21/jFF5/TI3?=
 =?us-ascii?Q?IIEtmFJi0M481eqj4gUOdcuthPd776qee3ZYKt/L2KQMy/N1k2LB/Z5k/vs4?=
 =?us-ascii?Q?BZgLi3rctkktW8EyKtsjvSHVd/iQv6laSoAwJUOXEdVhS7F9qnR2oQnzb4g8?=
 =?us-ascii?Q?QVcjFBKKQ15c930silG0LHEhY2cTkxN8YIF995B1TG5CE3hKJ8SL1wq3HoE8?=
 =?us-ascii?Q?UNxO4DSnpp5+iLzPYOyokJGMWkanhC1gCx7AjUADHh5fSVIj3DKhH03FdzBI?=
 =?us-ascii?Q?33z+QYSbx34yZTSZOIVaG/djNRL6Od9cWAYzzUouFd/PpzjGuP32slOergZ8?=
 =?us-ascii?Q?7snzmPITWy6dHfv2S9NoMChCuPeFxUTvtvKonkAIhytDolz7F7PbQya5Oj5N?=
 =?us-ascii?Q?lgA2rK2MdeakP458zWsUxwLrjowPOswtEMAzX8ZmDDEESr0MDGJHh0GyWybw?=
 =?us-ascii?Q?o1/dRPbpqUBNt0NNDhv4u6/nr8GWJ8e+TM5qI2mWI8Gnj1gPYDiv/4GbQFaj?=
 =?us-ascii?Q?iqtfhxDHOnaAbykIb8UKDnSQrxVk6g4GVJIvMuENGAL6FC6DeBDfWXg22kNU?=
 =?us-ascii?Q?HpwyARxGuzWJnKjp7NbjhFMv5c42+lbHxms/PpoyjsQPNShXUBwc34K7R7am?=
 =?us-ascii?Q?uYmORdxJWnlGlGm8Ycev9E4Dkk9YZv/ARNARbQqg3ZIbtBLWgfJXjkzy0Q9R?=
 =?us-ascii?Q?h+xui2BTND8G0adBa7Ykwh6woqFz8tAi5JNAzk3lhEb5+e0r8g5njBfuK4B+?=
 =?us-ascii?Q?x9HvL7S7xz7bDu37Xf15OgPbLgYBx515OPj3hvsNRsbptNRCoIIBbszZGNAJ?=
 =?us-ascii?Q?uHDKghVCgCnGV3rVDAKxcf0dlSWFSKqULsN/1qlO/v7ybS4Yq50ilKL7UrH8?=
 =?us-ascii?Q?2h2CG+OJd+FkAmk3czWRsRoDWqpovp0iDecl5+JHrL92krve3ZSPFZijc0bR?=
 =?us-ascii?Q?KdPMlLuZafM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jEqs23IPc+VpK1B/ZM7LQdzmLCiB3weurrJIAHJcQ0BLjE9whrRn4fSzrPil?=
 =?us-ascii?Q?jWyTb3crGQ5YhV2p+Mbh94uVOAo7wJ5HqegZvXfp9Xf08k9prpTQFiAJq3QA?=
 =?us-ascii?Q?Rbjvbv1FtOg+lbcDhtbwtmPUvZknlTHJOGS964c1OClD3vEmBt3LBFLcpt+f?=
 =?us-ascii?Q?xFF2SRtPiYrTWMvq6jSgwsak8fveUIc4LxkHL45U2kQl1PyAVbQnynVDt52A?=
 =?us-ascii?Q?2QCBi2pRavdp1ylNiAI3mjsahZCUznv0s/zvciLZS0JYm4eYhkRJv+pBASGo?=
 =?us-ascii?Q?Nh7KxDT40kpPuDNiniMkZ1XaDvUGUSoQnoaGo9IEWkH/hh5j9UVwYTa0pLIV?=
 =?us-ascii?Q?91JS4EWnJz1xN2ZSe19sv8HZ2IGJet3zW/n2SwPuyy7DmuJPZpr1j9IX0/WP?=
 =?us-ascii?Q?xAictcQf7sxbvQhq5Ci3Q0i3RgjdyJgFg/2c1oXe131izhqgzLEBJtlfLLde?=
 =?us-ascii?Q?IUo7ypKhRE2wxlc7xzZibl0r3MCYu7l9gYyaR8IyDJJ9+TEf/h6XLkcf6/PI?=
 =?us-ascii?Q?Vp3v8qd6TJwolV+OE9KJSrGqCoZ44YQ9fWyX0xnc7ToptCyQVpOdMdHS/RIO?=
 =?us-ascii?Q?PgIgclUqoIDEVwOCbnBgIVPPM4zIxujR8ZMXbXRWpwYqMushqJgXlc63c+tf?=
 =?us-ascii?Q?CXCgbCzLVbHQwh7ZZw62xUuhCcswq48/OFfQYih4rrKg5UP05gO+rYDBKe7L?=
 =?us-ascii?Q?jZQEyefFIIfMzWwedNZQ+8o7ZkWguhSnKPkueMUxJYF90+AN1aAzKKFsTpty?=
 =?us-ascii?Q?R8drdzKpO5oMUPOdx07bREldos+B/fdXBnirr+08AAnNqtHL6T5/V/dkEesC?=
 =?us-ascii?Q?rBZAXOOWcT/74Jk+ieLzSqOwr8W8DityqGAtYLt+Xpxn897mj15zp+AO2wRk?=
 =?us-ascii?Q?G89wWlbHixRf2USodR+h3HIlgqetIR2ix2uwyDPDSxYuL/P+MWoFL4H5UmXA?=
 =?us-ascii?Q?ej4W+SX+n4pVVVXgvic0R2wG5CJ0fWkBeh2lgcGIARUezGFqK40WAXWV3Gz8?=
 =?us-ascii?Q?tnxLsTVqYPEfev/+u0MADp4NqWZJHjavb/eq8FsVdM3hKsoSSxlGHnKq1sRM?=
 =?us-ascii?Q?becpwcmX5a2QOXomaFmRl1Vk1ian9FWFPR1VJegtYMq8ZXh5bcWXkUKNNdgt?=
 =?us-ascii?Q?JXqxq2ju+WP3LzGbtTybklc0Gt6k8Y721gC2rOqNBGpqSR8QgrDuVdhdLTeK?=
 =?us-ascii?Q?sjwzMVgVGGg8MoyWY7vHR2GCpyZpVfWhAaHS4Donkpxd4TOp7KgXGkAOwxI7?=
 =?us-ascii?Q?1DfKOcaYxP74lZUzxJqFA7jn+hOjchMo7A3UPPDKTFsQnCH/W85hMpAOP6sj?=
 =?us-ascii?Q?u7Kf7TI6FyODcTZwAtlasdPPqT95s/6JWuBsgtEQpEyWSbPKKMMFz1TLSFgR?=
 =?us-ascii?Q?4WRCt+Xe8gUnt25AbHpAjEvtaYbZcpS5P/LTmJNfzaHnCzwq3ON2Uu5NkvTW?=
 =?us-ascii?Q?IrUFQPV5wuKDPFKgbVIjeWtP6JYTaIzHgFuhMXei2k3aZNo6B32ZkuUbuX6N?=
 =?us-ascii?Q?M2+cqwn1XwPOkPNJWBELt8UYHMNhTBB3jjGrzVtM72ZDkhTn9fLO/L/wFMr6?=
 =?us-ascii?Q?1BA9hCBXCUvxK6GXgfmIgUJu90lVRKS5pj3kOQ7s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dc79d3-d7b0-48a2-c95a-08ddb378835b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 23:40:34.3905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5GCAQLx6Fx6pVv+Qc2ZUPqWeFzxm38DfQAAsk7ICuYg8z5GY7qD1y/8RJId0ZZEp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128

On Tue, Jun 24, 2025 at 04:37:26PM -0400, Peter Xu wrote:
> On Thu, Jun 19, 2025 at 03:40:41PM -0300, Jason Gunthorpe wrote:
> > Even with this new version you have to decide to return PUD_SIZE or
> > bar_size in pci and your same reasoning that PUD_SIZE make sense
> > applies (though I would probably return bar_size and just let the core
> > code cap it to PUD_SIZE)
> 
> Yes.
> 
> Today I went back to look at this, I was trying to introduce this for
> file_operations:
> 
> 	int (*get_mapping_order)(struct file *, unsigned long, size_t);
> 
> It looks almost good, except that it so far has no way to return the
> physical address for further calculation on the alignment.
> 
> For THP, VA is always calculated against pgoff not physical address on the
> alignment.  I think it's OK for THP, because every 2M THP folio will be
> naturally 2M aligned on the physical address, so it fits when e.g. pgoff=0
> in the calculation of thp_get_unmapped_area_vmflags().
> 
> Logically it should even also work for vfio-pci, as long as VFIO keeps
> using the lower 40 bits of the device_fd to represent the bar offset,
> meanwhile it'll also require PCIe spec asking the PCI bars to be mapped
> aligned with bar sizes.
> 
> But from an API POV, get_mapping_order() logically should return something
> for further calculation of the alignment to get the VA.  pgoff here may not
> always be the right thing to use to align to the VA: after all, pgtable
> mapping is about VA -> PA, the only reasonable and reliable way is to align
> VA to the PA to be mappped, and as an API we shouldn't assume pgoff is
> always aligned to PA address space.

My feeling, and the reason I used the phrase "pgoff aligned address",
is that the owner of the file should already ensure that for the large
PTEs/folios:
 pgoff % 2**order == 0
 physical % 2**order == 0

So, things like VFIO do need to hand out high alignment pgoffs to make
this work - which it already does.

To me this just keeps thing simpler. I guess if someone comes up with
a case where they really can't get a pgoff alignment and really need a
high order mapping then maybe we can add a new return field of some
kind (pgoff adjustment?) but that is so weird I'd leave it to the
future person to come and justfiy it.

Jason

