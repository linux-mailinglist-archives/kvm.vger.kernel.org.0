Return-Path: <kvm+bounces-31618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9CD9C5BC1
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5821EB3BD05
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 13:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E01E1FBF56;
	Tue, 12 Nov 2024 13:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X2XCHFfW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921E21FC7D3
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731419635; cv=fail; b=su/TWdlvoGcm1isqhvBZTd3WcjoqvnVMDcLNPPpCAUa4/DISew2D5pOFm0BCXw2Ihm/G2WrwnAjer+9LpyKjOeodmz7cBvQlfpvHlUd5EqxRKLCvqrMlHo6d872dCFTbKNFwFyo58/UsH5XrU0bQraIw2qW1s/aa41yUs0fEV1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731419635; c=relaxed/simple;
	bh=WFmqyPY/P9S+w1mqtfXeQwYtlwGNDcvh+JGijyUSAuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a/y76xk+WjuB7x9ztqbfQv/JC/u3zBbRyDTLKucxQmuHaRYyqqeQoIV6lcCeQqIiEdJSRMgGI97rQinyhCROHoKNgWDXE8h4JQToj9fWATu9iZ0B8RkADg4l/1Ni3rXPYcfG1oYrX7fiHJH99GKVznqBoXC8KJWBKiZpOun617Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X2XCHFfW; arc=fail smtp.client-ip=40.107.243.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQV13tMP2QgsKGd+7PWqhBQ/+nzhHi0sB+4A3s2FKqRsYwMy/K3kpfryBQSOc/uxHQA8NrZBYUGmLEVzTkrJjTjw8QOZslmS2Vx9ff1W4Hc/9cVzbokdfC3YBnnMySYPz/yZU32c6CQXwoOdTIthkn8MHmZBDs9VxJokFrlTwPo0rwwF5ncZvWr9f7Qzxs06OtAssTg33xkUtPH/Yd6ImWU5I3GNaJlvxaKri2U0tEDQGiAtcaK54qGCoZXwbsJY/xEspG4mKvGY/ChY/Yzks1KLmru5Wi3Dt3wX6WsPHQlbSjcW/vLnGLJ9t+3DZOMnVO/GC/UQIlwI2Rt+8pDqZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opghbU6oAMMfc6HfTjG6/FLoqTyU0TQO3oegkA7AOIU=;
 b=WAW5YaJZ4fqIyDxTf+M17A13FrH1bMfkifnio+peofui8fFtqJv9uBX5KP39JfHmfdXmMCvDipOduJ3spizKIfU2adStBxfI+SLLhQzPNLP0sNq1WAkn3d1m8MWRUArYybIkrbEbjNRFZ8QTdWAVmI95E13y0DKuh1sBY/eQngjSWNiHENJna6Tg7NQh1+kNhRK9EoUkNbuaYdJw9p/E2331c5YNxilDJ+yVUF0Uylh7XdLrAeF8IejSi1Yj63r/WDm5cyute6WolZ0SJQJ3YWXZcPbi8NN7dtzee/zKFkb/ov691SujyRsXtDhk2HumHtPFFG21dQHIx4LoNZhEmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opghbU6oAMMfc6HfTjG6/FLoqTyU0TQO3oegkA7AOIU=;
 b=X2XCHFfWWmyUeVSv9bVr3dKhg79+y+CYUPHyKJbDQJd2MT2pEd3jYUC5pjldRHRmmTar7XvB8XLnYWAzvfosHhJtpDbnWjDe7bLIT3wh+VL8vo4M9NI343QQIQzNYOXP8qpLFvBoKbMpLM4AbxTO0jUQgRmA1M1Z9pYYoJZB2TAiG2/yGyAlzIhwqTolJVgREHPUVpSgitIZtWUysJBJtL+jk24nfEmzmxlW5zVgnjB4E8oGk7qZo/PNJNqIQNJl+QPHislEOHA1hZUt4V9AdM4h0l3+yql2iRhfsugSLR6lIX+a+psZIBlZv/U7HMVU+vwY6k71a0+J1AhsaWhg/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9183.namprd12.prod.outlook.com (2603:10b6:408:193::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 13:53:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 13:53:50 +0000
Date: Tue, 12 Nov 2024 09:53:48 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	rppt@kernel.org, jglisse@redhat.com, akpm@linux-foundation.org,
	muchun.song@linux.dev, simona@ffwll.ch, airlied@gmail.com,
	pbonzini@redhat.com, seanjc@google.com, jhubbard@nvidia.com,
	ackerleytng@google.com, vannapurve@google.com,
	mail@maciej.szmigiero.name, kirill.shutemov@linux.intel.com,
	quic_eberman@quicinc.com, maz@kernel.org, will@kernel.org,
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk
Subject: Re: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
Message-ID: <20241112135348.GA28228@nvidia.com>
References: <20241108162040.159038-1-tabba@google.com>
 <20241108170501.GI539304@nvidia.com>
 <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
 <CA+EHjTy3kNdg7pfN9HufgibE7qY1S+WdMZfRFRiF5sHtMzo64w@mail.gmail.com>
 <ZzLnFh1_4yYao_Yz@casper.infradead.org>
 <e82d7a46-8749-429c-82fa-0c996c858f4a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e82d7a46-8749-429c-82fa-0c996c858f4a@redhat.com>
X-ClientProxiedBy: BN9PR03CA0502.namprd03.prod.outlook.com
 (2603:10b6:408:130::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9183:EE_
X-MS-Office365-Filtering-Correlation-Id: 51798685-4496-4dd1-f3b6-08dd03216fad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fh5aiuL9ApCz3PR8hji5HZkAyQngXUEVqwk3qsmTn9ck9DILR7dtT/B7IR6n?=
 =?us-ascii?Q?XXmYzTGLB/o8S0wfpudHr9vOqwXNLbqUJdFwo+uq83HYfsix8MI7ukpDrx2J?=
 =?us-ascii?Q?Vlwe7EO9vg0fvlrwVAdfGqLy5UxtC7G7CQlq9CVHky6u1fOZ21AsW4grhOxV?=
 =?us-ascii?Q?+0ArSt4XTe9zlxHvAKwkVGq9h9DH9CoTHbkupFiicCQry2sc66faQhFidz0k?=
 =?us-ascii?Q?rF0061MRblAko3gvYsTlQLJ6n+NsuhntQxugbRPl59sqFeFZV37/OTz/Wl9t?=
 =?us-ascii?Q?GSlXUmcqWn3O4ikj8wHGGvn9mURY2DbGKW4PVN/TS9i/TYFQ4WG0ExCgHgO2?=
 =?us-ascii?Q?K3pN6Jrhd3i6KDjLWV6f3vjByuSmCb+LpGfjDzPha68v/X1mtiQUxU9n9XcS?=
 =?us-ascii?Q?UQLov6LEhm4KdnhQGzNZdKS0ZAjhJ0pDUMdStzUNwtgYqSFz/nGfM5sv5aAD?=
 =?us-ascii?Q?AUV2lO0Rk3Rxbs8BVf+bxQPinMSzyfifudScLEg8XInj4nOetKNR6qkIVH/f?=
 =?us-ascii?Q?R5dBlz8flRmKsViQxHANk3NtA6Z6n45AZwxOo3B5mNTc5qlydwFyidhHHoqa?=
 =?us-ascii?Q?RouQJTCFmznPdFPegEtYbKndaECscmad1AJEOOLgKxtmDoZ33ZxhjKiamcsV?=
 =?us-ascii?Q?Id2bqyU5zTctma1+yuxgEDzpNloaJR9lKhNd1Tt0HQ2AlwmYmEb3/5bBtRPu?=
 =?us-ascii?Q?VGhvanC+BXRZcFys8o0UOFoBypadfCfJ4IGzNT6SjcTEfqLahFNxkfsQ7+sX?=
 =?us-ascii?Q?uR+juj0jTtv1wa0sVehek7H+da5SaccgOKUNdw4/LV/0V/z6DX2Hfq+/wiR5?=
 =?us-ascii?Q?mpmFZIWseVDtcPtpFayOKsV2Njbc+KEJ/E7UB1ZTaFDIxH3Xh8HzkNqFTDSF?=
 =?us-ascii?Q?LPTFht/MGnVWvRWrdg40Y6ghuaLMhImG6UnyHoxu3g3oozzlD5AoEAQVuYBV?=
 =?us-ascii?Q?o/xl/SCMw2bJ0peSdGGUSfwSiAjdgEwIydK+jf2OAm9sG37bpPPCMSlwjob6?=
 =?us-ascii?Q?wfijAkcW2z+3OjO9y4W8epTASOJ7hTshU4kXeVRSgU16ado9PL/koAKSr2t5?=
 =?us-ascii?Q?2q6ts7vaqaIVIYXhFTexGuHm29RER1iXezfgIhg+iJ9sQnTb6v5pKc8CHOMx?=
 =?us-ascii?Q?A5uevevNV+dkflMgm+KPLVUz8AXMYnOMQzHtcCXUzHbj3TqKsfiREzcETriT?=
 =?us-ascii?Q?0eCS58nyfdF835NzRrR/aYw3WtFObfG2heG3yDPySe2Uv0c9S8AIRn+/fsyi?=
 =?us-ascii?Q?y8IRE15MdhbTmT+gslLA5Cb0pQReuOk1OY8j4xsx4J7CBfOGs3XIHSpxqMCm?=
 =?us-ascii?Q?e1c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DgZAwc+7HdNZuTQ2coJy1zHitMcs6D5lnTJS0Jw3M+f+mKV1joZhxqv+2TDC?=
 =?us-ascii?Q?Qr08Eznjo7s2PJ/TRWKI5WO5oIEn8vzaiUEMnQI6pAkXG5nLYLfOUxW3R7qQ?=
 =?us-ascii?Q?eTyPiQKVqB7RcEnENGJaCMF6iOyLpo7Q32NziBGuLnOwlvq2ca62m13YVeDN?=
 =?us-ascii?Q?hEFSelWBoa+1PxT/mmfH2kU+IgwYLcaYHY8qgIYn5Guc25PQO2JDAu4hvsPb?=
 =?us-ascii?Q?t1BfJR15jiQ9PdY5kIE71ZWb9ppko5z1NGHfc4nkM2ODvpQ6Q4GwFgT7+Dqi?=
 =?us-ascii?Q?N0FCo9fB51ooXRDH5Qpl9175m47RhpzNscw5pn+zAbP7KmzsT/wyjxMs5jhu?=
 =?us-ascii?Q?HMIZcsXgoHSgRgeP77TYMyzZffZqQj8Hgqp4Xkdv7eu8G06c0QFiEB0w2YGy?=
 =?us-ascii?Q?xYFjUdr9KTIMaOoUff8dA6sgjTmMpGWAat+9yXhJd4QohouqdmjnkLLWkfk+?=
 =?us-ascii?Q?3dCYs1ROU9X4hGPQTYhNidOw5m1nv+XJpL6l9gPbwUKCjkM+aRPzdt6wG4Tc?=
 =?us-ascii?Q?m0n9BCZGA7TQ9RG8dU9mjdI8bPyP81xUxqlHXsW+OSDBDgapd7hRhvK4xWaY?=
 =?us-ascii?Q?6mGxQqmJpKh4xSLPMTtzQgB3VL6MksB3cJJ7wwKav0tklnZrdl1BuUXUZy1A?=
 =?us-ascii?Q?lDmJxQbV9fLOse97p5IpGeN55sRhKU02NdY4yv+IUwfAAQL961/C/GMVOg6s?=
 =?us-ascii?Q?mzr/2f/P3Lgs/jZpUBQXwMR/LAsQhaARKeHMUQXqYs2NGF6ftkDL0mvFVBes?=
 =?us-ascii?Q?BQI3XEElo6kSMl5ycySGZfbVceNDLWxhyHeemn4GfJ3FKOJYgQWWJ1Yh6u56?=
 =?us-ascii?Q?XmFSA3abEOqK10x7tDWS4+WvG3J62we10qkoXslEvkB4AysEwGFYw1GcPsk4?=
 =?us-ascii?Q?Y9bN0tWk1oKyH4TYKivVcG12mnKGr7DAlQuoCvZlCnf0AlFKkglCrI8PL7e6?=
 =?us-ascii?Q?RDTvvtkGEXtAWfR9DiC5Sex492zfMuYQ9TsEfhDhnG8nCx2lsmlHye4NAM7w?=
 =?us-ascii?Q?py5jJwUFLHJSrBUjT2zW7L15cO3KwlONie7yXkHQnyfEbGx+hP60AtlhA8Cy?=
 =?us-ascii?Q?HUITTkul0EvZkqE+lHgqBHLMfysYsc70PX68l+LIDgzWQoaGqaW1M/xKC5s6?=
 =?us-ascii?Q?1Y81Mac3wa3EqBAowWby6rD0W7vPtUUhDFrVJF3tQfSzy9nXWhTVujs+qwmx?=
 =?us-ascii?Q?yjt1+H4t3RjdfAZwA70Xn9rHm0JLV3jye7um5OQQDvcQncnCohpFMreUG97l?=
 =?us-ascii?Q?Nmd8fKHg0l29p/VLfms+UZyNwZtoJGfpGtV4C/7HPYbgywG0pUWgnCbe4198?=
 =?us-ascii?Q?krTMZjypOS2JBrpE3FaR7JbqtHv48SEDs16spocQTUTPFyHewQpACUBG63sO?=
 =?us-ascii?Q?mbsU8GfcaWBDgfM6ArO8q2YvC8Ngm9dFyjWnDXV5rydbVboPvwSXQWBew8pU?=
 =?us-ascii?Q?qktO09Q+ysWTjmw7GOGdI1jxlYUyfBZMeyaFTWcc+ybFdzNygKT0aw0tfBsy?=
 =?us-ascii?Q?2YR9IIYeyyjL+Tp3cAMApnIrCITkV+IY+xrNiqkc83TlUcrDI/X1Ev6Utmp9?=
 =?us-ascii?Q?7GtgxOELkbUcI19fCwc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51798685-4496-4dd1-f3b6-08dd03216fad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 13:53:50.1448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7H19u9wYksbghhcOqsZ3RgmiO8oYloZUSywuTgv4DMVbE/nzG8tGe7L+HnJI6+p6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9183

On Tue, Nov 12, 2024 at 10:10:06AM +0100, David Hildenbrand wrote:
> On 12.11.24 06:26, Matthew Wilcox wrote:
> > On Mon, Nov 11, 2024 at 08:26:54AM +0000, Fuad Tabba wrote:
> > > Thanks for your comments Jason, and for clarifying my cover letter
> > > David. I think David has covered everything, and I'll make sure to
> > > clarify this in the cover letter when I respin.
> > 
> > I don't want you to respin.  I think this is a bad idea.
> 
> I'm hoping you'll find some more time to explain what exactly you don't
> like, because this series only refactors what we already have.
> 
> I enjoy seeing the special casing (especially hugetlb) gone from mm/swap.c.
> 
> I don't particularly enjoy overlaying folio->lru, primarily because we have
> to temporarily "evacuate" it when someone wants to make use of folio->lru
> (e.g., hugetlb isolation). So it's not completely "sticky", at least for
> hugetlb.

This is really the worst part of it though

And, IMHO, seems like overkill. We have only a handful of cases -
maybe we shouldn't be trying to get to full generality but just handle
a couple of cases directly? I don't really think it is such a bad
thing to have an if ladder on the free path if we have only a couple
things. Certainly it looks good instead of doing overlaying tricks.

Also how does this translate to Matthew's memdesc world? 

Jason

