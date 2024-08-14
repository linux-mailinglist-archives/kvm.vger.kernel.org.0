Return-Path: <kvm+bounces-24151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A21951D8F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F9A61F20F94
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED2A1B9B21;
	Wed, 14 Aug 2024 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EQcmIw1o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966861B8EA2;
	Wed, 14 Aug 2024 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646597; cv=fail; b=MmlYfLuCE6b3uLqlRi1IPwbTXJ28mAhPMEZ70UquDzO+Z73Gu8qF6/0VSLcP/k4/n1cWgwgwHbLPcfk4H6Pm5ISK6+Nw7fdoaTtZu0lJDSGR4lk2QSM74dcySXcZ09VvCtuVZQUuF1VIFJglFcB4ZVAnWYtNlgC5cl8foIgLSck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646597; c=relaxed/simple;
	bh=uaon1zMwrl21YV5V2WQlzCBeDrbOoFtGQFUCw9d/4qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dKXMMJSIURTdmjiHw+O+ZTHg5XXDz19VJVHzWD+u9P66bcGSQKwve2g1khVxTm/6xqZNbKAnLSKb6Rhqzoj9wyDGHXtK6o2Ocx/yewwnGDbBntDnrrhHSLPPW25lnWSffYGVYSKb+5TC0GnRISEaAjGMkuFixq5HYZEO9cKdqaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EQcmIw1o; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGy7V2IsBTcANEID+Jc4HZzooKdYApOl67Jvb+DZb30o6UjxQUzNVxSp4NPRCRbFcdc2HM/h658eTxGhK5au5ejTizREoaLr2JSkQX1Nnb3jyW4sYGqA2qQAtamjZ+2Ub/wFuiDCZQUbkaY0lUTPbOWhjXCQsNxr1LFjQbt3k7o0KhoN+SdGEp+iaVypzQReG8ky3VzuiwNX3FwEBtcl/OTL3/y4ddsOUwtZbWPlf0LStwhMsJisRAXD9nwLpWGq4Oj7on0VLxdnxltAFGhFN8zG4FjK3HASQ4AZ2xBXXJzb4h32EdsaoiX3YIEJRHHwzlz7kXpfrXlczxvPkBjmsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Jrz59kVtKBeQkFrldVlczGR7E19ulshJboNFDWEcHE=;
 b=PQTzU6EUU6JkAHb4IiFVZxdo+KsZu0z7zOLMsEAjIOt0iRp4G3MCXbLrjNSQ1oQUoWWT4pudryR6o2VHZLAxHAkYeHbVyekFEZxRc4pswrJOeGEhQkOHbPljWCnmYD1ds4lsmCOw38v2JlZHTFCOIeEm9sal+1XTMGgmt/uMqmBXQWOkNthLqb8d+JVzi8Kqm4MD8OJQkQo9NLlpccpd1PkAZIKD9nfFK13jY/Aawa5zIt3zsvpUzPg1PMbUHKpyDxfYR40+KAXx2/GeqRwN3l7m9VLkf9iH4YzjaTapmeTlefi8FF1H10BsEKm2UFVViD1aQYw6MyxiW6j3MnjmLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Jrz59kVtKBeQkFrldVlczGR7E19ulshJboNFDWEcHE=;
 b=EQcmIw1o9uh+mPj9O8tc1jkpArLV70lWLuLc6hMJXHqu2ed+Fcs5RgSmB3W6vEmLiQ8tGL6HLSi28/t1m0eStdXesN9D3eM9AZhVJiqDcY9zsWAmZ6j0JsFJoZMhw7vx6lrWu7thZR98vtI4HwtsoJGG6Xr/HsfKk+CP6HEPnTrR1Xsrp4bGDdGSbMW8LoMei/B3Eyt+DhWHCyYnDFaS20zRwE02IlhLIpIAaHlDD7I9heoX/4AlVnUHmPatxKYDhS7QQrFTPfQi78b8MR0K+n6sce0/+R4WVvm+28Ph/N7vwIFFT2rEfr7wT4nr3NFFh+3jJIhCaPCNSXhJD8b0Aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by DM4PR12MB7575.namprd12.prod.outlook.com (2603:10b6:8:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Wed, 14 Aug
 2024 14:43:08 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 14:43:08 +0000
Date: Wed, 14 Aug 2024 11:43:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Message-ID: <20240814144307.GP2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrzAlchCZx0ptSfR@google.com>
X-ClientProxiedBy: MN2PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:208:237::29) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|DM4PR12MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 967cf2da-8929-474b-8b5f-08dcbc6f69eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8tzLyTenTj/HThlvbuQx9i04VxPZeieoMHjQbibdd3MafxndoEkrWU+3hAul?=
 =?us-ascii?Q?3VRdkUOYqFfQ3LPDJcAWa/VAWcFkoqirmehAgrvv2eCsTqSH3za8ODhcPhew?=
 =?us-ascii?Q?vnc4lg/6AcdMXoxubMiL+6BHP81XNdFMdGviG7Ism2ONFCxIPGN69ale5F6e?=
 =?us-ascii?Q?rxoAqZqUuDHdNByIlp/JoUTVoeoZdToV44arxnjpKFXERT9PufHQllUe5e0Z?=
 =?us-ascii?Q?bCpju8Vk7J6vw1Zxi6Te/04Sdp0JeKae0/ohrRHLhix+O26MbOkZyFHn4CD1?=
 =?us-ascii?Q?VnN6J7DuyCq+4apHUYDBnibmuuihTulz6rXqVzJdruiuk5cW3JFwK2OIFeIe?=
 =?us-ascii?Q?3b3EGxLmgqDE0ig5JZJvL8PalpIjAOVkppaG7a29n/MIXwnZTmRN20uXOrVj?=
 =?us-ascii?Q?MlAqgvRNduaYBUWe2UbIOVGZ4gocgEPr8Pc9iIHXvuO/e3pqtEp8MXxt8h/E?=
 =?us-ascii?Q?lwU+pQon6VCjVv1VCi3eZNgXs3RN5Pw1S+F63Geojdts0Iz3Y4tqgm6s2ovu?=
 =?us-ascii?Q?S6XQVGH+ii3mzCOh07HKaNUY0gMXYl7fGdaTTo8xH21DHcIxiVNFnKGxjyHx?=
 =?us-ascii?Q?pUvZmlHzYbLNdR5HVxfXqSnYEELbi8QBaZbL9FnRbgeCr0GsOpVrRqEsbJ5E?=
 =?us-ascii?Q?zOl+ktoST1qxJJ261G/sHdwfAWbtktCowq1EsE0RW+OnClD7fH6ghaCfPISN?=
 =?us-ascii?Q?d+ALq3ALKum75XGhQ8wmb+QDfVtY2TUOHzIt5EL/sFJjDz2LaE3VgaoG8zru?=
 =?us-ascii?Q?DhT46UL4c/E93oXWT8HaIXixzXNC9MLyKRae89sz56/nfrklvn09NaknSJkS?=
 =?us-ascii?Q?zYZdz19lOlJYh/bUr8PYatsC4z22D6INBpQ1WmVY/EC8F3MiCfqI4zoauBQo?=
 =?us-ascii?Q?g7ldQhiDDGbniOV2dTq1MjENtCZtu44zPI055cHadyWWLAlIUShkU/akgA/7?=
 =?us-ascii?Q?GlPNJE6JAuS4gjr11tIsfd6UQwh3VZ2OaUV/CT15m+1+9ObEcu8J4XU2wVYg?=
 =?us-ascii?Q?vXtZkjTZdkqO3FrM2WPWF9iUu4hl5/niLX6vHZ7ZiGhFZpp988fPaQHV9FsL?=
 =?us-ascii?Q?w9/eXmS2RslCrjM/wiuUy1jyzSwSD18dSTN8JI8ZcEyNnCqbtN1A/LbNE6IL?=
 =?us-ascii?Q?qvvpRf+6ZwS9dOfnA3ymlaLzAAPSiLBXdrKuvzoW0kVKh5P3/94Pbj03o01U?=
 =?us-ascii?Q?TMrVEp/qfn/YdVO1qAG+qHnT63aT+Fh9z9eiFYmcWn2VNPU9mEdHcnzUbZAh?=
 =?us-ascii?Q?UspXmm/lgC1oTR4jPPLQTk1XO1bAS80KzpH9jjraCH7GtOie0KNY9tUTJ0Mt?=
 =?us-ascii?Q?4rM5EhTlfAra5CYFPoID6/kEBeGMH8o00fCWhlobX+dO4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NRwL3sBaTATkA1jTP1lD3jRfKPfc2xdOC3L1pFFRb5VySGQmGgc2oKMKL5uw?=
 =?us-ascii?Q?vTiOBHY34GK1Qrw5bs0F3YVT1alXI3NTBdDGLJ0YLMiEcET+sN5DMuA0M7Uj?=
 =?us-ascii?Q?i0XxArvpgussAnOl868Klvyp5OwCO7Tqpb39RJKf42Dz0pW7hHAzAQ9c2LOA?=
 =?us-ascii?Q?D6CoWVA1EP2x/jrSAV5N+c56OdyDsIAVTNMeNeaD2ocQjByWAxPiPYaGEtzB?=
 =?us-ascii?Q?B5pBQXjU3LSiXv8dts8u9sx5PGRh/GEaKbJ5QkixcHHAxUNUaYFKnFCmm2Zm?=
 =?us-ascii?Q?tyHqRmUCuLL61kCxSD5reBNKSixniOK7da4qrv2b0s4fubuKRN540ftp7fQY?=
 =?us-ascii?Q?LMkcj3CNFqXf3J4oeVAPRHpNG82LCekNSSjxXWr0gVHm78+ySsz/HtH9pAJ3?=
 =?us-ascii?Q?ASKQlj2laNjFtV1d6mafp4th343sUFdj+3+htwUandQD2N8dZorfheh/ZA63?=
 =?us-ascii?Q?pZ7mv2/25jInwXzrpiis5okN5f9AVRGeA/u0gD+B6Jx7TP8bx7ZXxAg4Wl93?=
 =?us-ascii?Q?GAAxbtqM7Em23j+gH547FaGUbuEWhyEjQtc9FJ0Jkg0OWmoMxrrFYmNEK5dl?=
 =?us-ascii?Q?1GGsqRWguJVQZZuyk5Ofu0HzHrl3UmDZRc/BTSA1Ms4bNyXq6gf/hnldtPGc?=
 =?us-ascii?Q?IGtWsdrvUBnURKuMtQfanxbCJ4ZsMIV0mI8ZMehFrQJzjBeyNLufDBvJdZWC?=
 =?us-ascii?Q?wQhqPt83d2wYQZhw9R5NeiGp4hAkansJVOO0/F8molqTCjzVICiYOR2h+flD?=
 =?us-ascii?Q?s2uKOL+zjl8VKY2K34Q5iNb9WyUbayfm3rEV1p4rZzGIDUsUHSWeog98y0BL?=
 =?us-ascii?Q?ntR2v/y+BitSP3xKnyUxPU9DTykUfmtax/UX1EdAsKBaE9R7H86EIKHITwOS?=
 =?us-ascii?Q?jMdZmt24dlrpZ47YNawD6y9xySm3ZxK6yOVVutbYlXewMT7EBXWAH5FjvJml?=
 =?us-ascii?Q?vN5IgBnP4AbJBBV4yoX8a2pflHc0TePhgamwGyqT75LiqMbDuc0/C9ouiIDE?=
 =?us-ascii?Q?ErA+g/KmQAW0ERNT5VqEMpx93ZhngdGEtj+6mtq9T+J+meHIW1wNZ6Y/E0d+?=
 =?us-ascii?Q?p8trn7j4KbtC3uAtjrDBHWjdlXz18ROMMEPB8Pm+y4LxOKuv+bn+mzZWkNI6?=
 =?us-ascii?Q?f1nQTWB7X4n1HVWbARUSA8+4W684QEuDzBVdN7lX3a/7QhfRutuzkSH8ODUd?=
 =?us-ascii?Q?RJgnZSbCGqfzPfBTK3jeQmmxGxV/Bl/+DWRF4uK27S6NyhychXjiCHRiW4hx?=
 =?us-ascii?Q?niIuymerzOGr98ZxltEZDTks8YqxkIq3krkywtGn0Janbb3u4P9Iiq/LNxno?=
 =?us-ascii?Q?y8Qw3W1d1rfzSzzM4JiT4G6WlAdv+YwLOBTg6BEkEjVO3w0+d8tchZ5YmnsM?=
 =?us-ascii?Q?UhGwS2aesYUUKhttGrMPGPfaf6DLkW9M8kcS3fg/7rSkV4z2hu9TZGo31L3r?=
 =?us-ascii?Q?SyVgVeCJy+dm5muiVZnCnam1V5QWp1m9FwYHFjdmthV9+1uTAZ8KG0TDuRGM?=
 =?us-ascii?Q?cjGXMduU6zo3a/tFurBYFkMsQ+3PgWy24RjSnQrLVKT8rluVCICrksq6QEy8?=
 =?us-ascii?Q?cu9ueafvHOtNToxEbn8wc+KGgM+qsjpbjOkNyYyk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967cf2da-8929-474b-8b5f-08dcbc6f69eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 14:43:08.5182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EwupXbeW34PT8QeppTdAKU4tLIJSiGUUjuKpGBmOtmadSLErDbOsR+HkOxsIe1VX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7575

On Wed, Aug 14, 2024 at 07:35:01AM -0700, Sean Christopherson wrote:
> On Wed, Aug 14, 2024, Jason Gunthorpe wrote:
> > On Fri, Aug 09, 2024 at 12:08:50PM -0400, Peter Xu wrote:
> > > Overview
> > > ========
> > > 
> > > This series is based on mm-unstable, commit 98808d08fc0f of Aug 7th latest,
> > > plus dax 1g fix [1].  Note that this series should also apply if without
> > > the dax 1g fix series, but when without it, mprotect() will trigger similar
> > > errors otherwise on PUD mappings.
> > > 
> > > This series implements huge pfnmaps support for mm in general.  Huge pfnmap
> > > allows e.g. VM_PFNMAP vmas to map in either PMD or PUD levels, similar to
> > > what we do with dax / thp / hugetlb so far to benefit from TLB hits.  Now
> > > we extend that idea to PFN mappings, e.g. PCI MMIO bars where it can grow
> > > as large as 8GB or even bigger.
> > 
> > FWIW, I've started to hear people talk about needing this in the VFIO
> > context with VMs.
> > 
> > vfio/iommufd will reassemble the contiguous range from the 4k PFNs to
> > setup the IOMMU, but KVM is not able to do it so reliably.
> 
> Heh, KVM should very reliably do the exact opposite, i.e. KVM should never create
> a huge page unless the mapping is huge in the primary MMU.  And that's very much
> by design, as KVM has no knowledge of what actually resides at a given PFN, and
> thus can't determine whether or not its safe to create a huge page if KVM happens
> to realize the VM has access to a contiguous range of memory.

Oh? Someone told me recently x86 kvm had code to reassemble contiguous
ranges?

I don't quite understand your safety argument, if the VMA has 1G of
contiguous physical memory described with 4K it is definitely safe for
KVM to reassemble that same memory and represent it as 1G.

Jason

