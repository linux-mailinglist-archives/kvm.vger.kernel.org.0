Return-Path: <kvm+bounces-49993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 431C0AE0D19
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 20:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AEBE1886F9D
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 18:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B17242923;
	Thu, 19 Jun 2025 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ubSsC6Xk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830B830E850;
	Thu, 19 Jun 2025 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750358453; cv=fail; b=YDV0wFFTBW/flQeiiDPysmteyk0lLzHR0lq7YIifaDoG8aJPfFa8rCdkfaEMXXBEwLesK+CKHHHlQiVDGXbmLv6/eWGPOuEzSNR85S6uxekKPuqxmvi2AtTp4kU5ijKXyySgm+zikMAUBGFEH4I4z1DtXBSjglBSROz+nHh2rKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750358453; c=relaxed/simple;
	bh=haDt+doWgsqAmtu+QSTtezL4P1Zc1nhEYMt7FnZjVHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SfJQGmJzLMfH4XatTU3BSzvsyFkdkdSZEp5Jg4mOUXi08b2zMIVUhp88b+GQwTuva/DX3vlevIOBcyG6otB6bRc6sVZSlxb3i67NXl6mk/q16ddODM8uwnPWylzCBaybBTGShuKphfbw9c0uN2YLL3pahHOy2ANWB4W9d80Kglk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ubSsC6Xk; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qAKl9ctQ5whXFAAgCKVf5NW5yWK5UTK+DA9Sj384GNRLxiQufZHsTRgUXC84p32MtKLTS2/17DNxKqpEBBmSSPkpv0kXJjhk1ths3Uev0mHlcwe2MPhtHqt0EgFTnTg8d9J7JtqPdT9yKkrzMeRjeWQA8Y6zbNFIN56ce0HyPsX6y+d6ZA+94Te3HV2d+GP4K6yIbLYcvtmPOax5z8E6djBve/VthDBHgEFpn0rY+DDRzpAbHO+x9Xj6Crnpxlp73dP4nVqyS5zh0jxVKq96PJwGWYONSQeRwUZcw2Pb6mv9ALLtPMspjJb7ISNz6GPaFAwdHe5qPt6PyluTLTNk/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwrbRhSITiFUmkTz2iXOX5glx7JheCBiKAgbaR8OW64=;
 b=u+tdZL8+VjLvBAkhCCozez0g4bE2bxoKuJpofzGZNycQklxYSfN9suA30wz7+PCPJGocwTw+Jja2RfZ7ED7VS/Oq8CMkn3z+QI0jiS5ylVWqGwi1Z3IhLewjqx7MmwtaHBxhfhQcn+Kwih+UkkvQTSaVyxiKjdhDJQtbo1M8gWhll8YEi8/AM4jNacg4slnzwiMJjHwvRWe3gFCEOd7QaD+LvRDBqt5hPrLJBlJZLIGR1zr7FXpHNxWnR2ll/IYjvUa+KHkmtWJX4XwVOjoI4pxLMIOUwPyKX9E9UelgPOlXfx+5Gn0WYXC2sLl+AljeWVkgfkd1Tt77cLH3oora7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwrbRhSITiFUmkTz2iXOX5glx7JheCBiKAgbaR8OW64=;
 b=ubSsC6Xk4f3stOb1kNSCrl0hsH83m11uTSxv5yOPRf/BmQ9MxswBbj14nbtsI5Xt/mR31SbvCLoLXvNe4qIo8sS6/zp3vw2Li4fD8/e/x/HNh7mxBJ+AC/c8YLQxqmJtR1UI1uU58pczAL1bSZg8gIRsoiZ+Q1qQCOhI29o5xOmodW6fQZeew5eG9TUJG3hB1fsRlSfGQzqfDITNLXQd++F+tnk3spwkQJMaDLKhc/ZXDXKQakUyS1U36UWHBfilL3xWhN+JfyhLgeB3lgi+hhYKEJYusrmSTQoiMmSYX4HclOZy4hfZ1N8RtylTpRmMw1d8RXrAGZbGzpIIQj+MRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB7183.namprd12.prod.outlook.com (2603:10b6:510:228::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 19 Jun
 2025 18:40:48 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 18:40:48 +0000
Date: Thu, 19 Jun 2025 15:40:41 -0300
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
Message-ID: <20250619184041.GA10191@nvidia.com>
References: <aFCVX6ubmyCxyrNF@x1.local>
 <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFQkxg08fs7jwXnJ@x1.local>
X-ClientProxiedBy: YT4PR01CA0214.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB7183:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f7e6f7e-092b-4187-0d95-08ddaf60ceca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zIVT1Cims04YIorFZdNI/xoGcaG/DvRDrNdO3hHNVKbk+RHhDLJYbjwaxwCO?=
 =?us-ascii?Q?w/MGiRNaqwQ6YuRfe2z8xYiJS3T/HtG1McJe70o4FK1iIaWk3fJCc2J3WwGm?=
 =?us-ascii?Q?e2XZlEI5tIOiARMdGJ3OLOeaNUflE5Qjk8mdXLxk+pIsdyOaRH1vv8tLxVEK?=
 =?us-ascii?Q?csoJHXA5ZZQYWmf0kL7tdBy2gsc8tVt3KYC1hWHAcyGnezUz3pdEsvHOEmoS?=
 =?us-ascii?Q?DugMJmEdrDUHpY9VMAf/zefJwSROcUesYFxJ9gNlheUnyE+4gzoRUez4IguN?=
 =?us-ascii?Q?bLaTQc0AaWYixlJpGbT2i+qFn6cEAS8Ai/FJ5h/yr4Cgoin4nRPl7SOzLt/T?=
 =?us-ascii?Q?oJSfAYBZAJehh9PjDkIQROXxR4Vd4ACgfoo/QuxRpnjC6Cbc/KMEnMu0nGgK?=
 =?us-ascii?Q?pTqG0xFYChwEDIuUzjDWtbTXyj6h+ws+leajlSkIiqe00pquPccLhVHR5TGH?=
 =?us-ascii?Q?4evvYZLzpGCpe059VU+CkJ4VuMSJ3XNvuXBPumYsvOUgtEZWatNOBOfKUBGi?=
 =?us-ascii?Q?CNxEmJDChxXnJqTfLmylAJTewVY7kynptNkJut+G2CSgO1+LJfxu4AgQlk+Y?=
 =?us-ascii?Q?FawXPEcKTXJad4SFLyOswKQzjEBGJqxLc7YSAwSDExGT7ewF/GHfkftBSW6m?=
 =?us-ascii?Q?6D0GZt2SyG60ms342XRqntyHv6Y4V9VE4hn3MFUsH72KgfgQ96POfS27rX41?=
 =?us-ascii?Q?0voioIhJ9LONLGvN8dAzhUDK5QwsLuDbIKpn7Gd0DG2pvO4QM8cmk0DG6GHJ?=
 =?us-ascii?Q?jnuP3S7TKaMcpy6u7lcX9i0E861uGA71inhfzMSmZnx6Dd+gwF8vq14pT3Z1?=
 =?us-ascii?Q?Yn5f8BwLFmMrUFRqM1sb84+SvTl9Wu19mVTh6czXXcIAo3FvrAZU9iXB2zFy?=
 =?us-ascii?Q?Pbqf/fEERoE7IZ0m2CYTfzYHmxyenVotawsNarL/SJleYuiF/MPbpIib65CR?=
 =?us-ascii?Q?MvkET1t8ThZtXxVwNKo5NLS5HOI01yN1C0+0/39tvK245Sj1El9v8jSV7tvj?=
 =?us-ascii?Q?yPThL2bmMG6tWYaPRGruS+Vgkexu3BndhZpLFfVv+nZdlY7NX9TmHzzeKVx8?=
 =?us-ascii?Q?ZVgtsnBWDDtzcyfEbKQRS0Bm0rCY4XHhTcjoIh+fKqFmU9kPnoub+xw09H2N?=
 =?us-ascii?Q?WSlSbR6mfoEfR893lvbIynxjPMMrrAW7X39v9WdH1aCTVWyI1hahlzU5oHIW?=
 =?us-ascii?Q?+jV/ro7NekbDQpoTuvbyv8lo5As1fSj4pqhR3Qcfoy9eo/kX8Fpc4XqS5kWd?=
 =?us-ascii?Q?JK+k15rxNCh29iA7bBzZzvfivgkbPH88PNwh7AzWLHizrN/wx5Z6fcVl9kh4?=
 =?us-ascii?Q?4zmVuxDV2nCHHEK1Dwi9ChD+tGOMPyPKzEQ9KlXW1Bzd96lFUQtpSXYF329L?=
 =?us-ascii?Q?ka3pEy0RBC9iJQgcDLSa0xarLdAqrpfYlzOWKX0OVqDHO3wh9pkVMlOmjjjP?=
 =?us-ascii?Q?Wv/5/cgCltg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d/PeYEXJFQG4kudz9j+wskDr7m8aNQUucIeYxwq9Py1Vr9Pu4PJJiA/avuWA?=
 =?us-ascii?Q?k+hKQD/+BJHRporxYXLC//vBarFiBqZgh2HS8p2DmLVQgwLaOiD8R7ugYr9X?=
 =?us-ascii?Q?Mv2DrmgdnXnTk0uTW69z2CnRTJx02bQewsWd/Ay8WTppzYo+DnOIhRAn3ctP?=
 =?us-ascii?Q?CsOKOQ2FpaAt0X8K8F6gaBo+LhqTKbp15mRu+fjeOGQPKmocIq90xYMgx1GZ?=
 =?us-ascii?Q?0C4IY2JzNnGGEp1C6ktDgB+d5UPAyqoRGfMQD3Z8X6lFKFFP3dvXfMpEWud/?=
 =?us-ascii?Q?BtGyh3D+CL69tGPh6slZjzfZX5srRdJ+vvGuGvOkEyL418RVAhHXKyUEwvKb?=
 =?us-ascii?Q?TFFQWMbAWJrLSZWgENqrtfaq9M1+4xpSkFSSrTCHYREKzwp1O1vI5aSxOek5?=
 =?us-ascii?Q?9+t/QoStkfIbwYMqLzEQO9oSO0TpkaBJpIVnKt2aBGK1k7Mj/afdehghgzth?=
 =?us-ascii?Q?/BBiEBYQkI+6LqNEkfpghogKZck94SBvwJ1AwiJe1rz4/Xzg1Ih0t4V8iJmw?=
 =?us-ascii?Q?N6CatvJidA4ZlWRdQgHMrrBPzqf/oEddj53dcWxsFPyc4gySo/3UTUyoujmM?=
 =?us-ascii?Q?DhkGa9CUSKYOZBSzPHlPkfewmTlLEP+BvoqJubiOZIS/majz50cSxZk9SeE8?=
 =?us-ascii?Q?SDK6vAJP0LzvdNcNCdzD/l09T0aLfGBJwj+JaoSERHnFb83u/PXRPGfCqumI?=
 =?us-ascii?Q?cb5pf7tg1pJo9dVQVnzmeCSGB3Bg7d/oR1yok12RarHfFEKFgrNRkYKyCfYV?=
 =?us-ascii?Q?YWWybe7KN4HgU0AbCdEck2XHNNb/21G5lOiBNL77egaRUfW5UQmT+s7O0u51?=
 =?us-ascii?Q?a4ThEJ0MaKUr7inapJgWJhcWRhzDMb2FhjSICiCwslOLNxWIySVytf6/3ujT?=
 =?us-ascii?Q?hoB/f+/319aBgckLa7X3lSqfv6KuPJT6I1ze2IBopNWSxGPSNUCxPS8k1VTo?=
 =?us-ascii?Q?IqsJRVuuj3IhdzN7aeRQTpKc62r4dUpexVI96O8e2sdeqSbaxTZtPpA0TVzb?=
 =?us-ascii?Q?kH139SeilTPT4iNSZkquENhuk1AlIP/5WKQMYj4dWcAwzgLGj/WomWNqyRLT?=
 =?us-ascii?Q?jnDHeSohe1NpR9AWmqS+gtOjpfhxbSsh0n0+vbLmLy5H3Kcp0ssPU8q0lAze?=
 =?us-ascii?Q?X/wAGjOLVnts6oucnwj/Sdz9fe2l6Zh2oj+Gpj1bKDhIpAXhjHTz1raXFx6t?=
 =?us-ascii?Q?v1ak6JWNxsGviB7JAz7AKa/jpmldMSdE+S6ucNEsYWwkicWDAsjTnz0EBS5T?=
 =?us-ascii?Q?zzLp6JvgsS/BBEgoqZMBnMpAfqAHe0Xe81B/lPrehJgyzyfmyqSffxmXA0o0?=
 =?us-ascii?Q?uvNtdJuCPRnK40kOHUJiRYTz80egSQCOamok64UD9k0bAr90qAnDgBSVJWWJ?=
 =?us-ascii?Q?TKpcVmQW6LFkzLyKNrdrrvKX+jVk2yhchYV0sHxChHMdtVuou4v/YLrIZfqU?=
 =?us-ascii?Q?5O6AEtOejExuEH3S8CDVrnKePqKYAkkFkRs5sqiNKV7kNyv8j7Zkp8k2+1ss?=
 =?us-ascii?Q?JAaoUuFzV5l+HZ9ZQvvHocI+XwmXXHLFPL5gqyNzG/84RoKPHC0S1AJR0qlY?=
 =?us-ascii?Q?MN98wfGEA6rp+pqS2TyZkicbeqfX659AYMCRx3Xd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7e6f7e-092b-4187-0d95-08ddaf60ceca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 18:40:48.1777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5zFIBb7MvgRYM47JH2+g4UgeUNhNIoOzrxnDlIIyXidXFLHWCHRBbjZeA1e5OkS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7183

On Thu, Jun 19, 2025 at 10:55:02AM -0400, Peter Xu wrote:
> On Thu, Jun 19, 2025 at 10:58:52AM -0300, Jason Gunthorpe wrote:
> > On Wed, Jun 18, 2025 at 03:15:50PM -0400, Peter Xu wrote:
> > > > > So I changed my mind, slightly.  I can still have the "order" parameter to
> > > > > make the API cleaner (even if it'll be a pure overhead.. because all
> > > > > existing caller will pass in PUD_SIZE as of now), 
> > > > 
> > > > That doesn't seem right, the callers should report the real value not
> > > > artifically cap it.. Like ARM does have page sizes greater than PUD
> > > > that might be interesting to enable someday for PFN users.
> > > 
> > > It needs to pass in PUD_SIZE to match what vfio-pci currently supports in
> > > its huge_fault().
> > 
> > Hm, OK that does make sense. I would add a small comment though as it
> > is not so intuitive and may not apply to something using ioremap..
> 
> Sure, I'll remember to add some comment if I'll go back to the old
> interface.  I hope it won't happen..

Even with this new version you have to decide to return PUD_SIZE or
bar_size in pci and your same reasoning that PUD_SIZE make sense
applies (though I would probably return bar_size and just let the core
code cap it to PUD_SIZE)

> I'm a bit refrained to touch all of the files just for this, but I can
> definitely add very verbose explanation into the commit log when I'll
> introduce the new API, on not only the relationship of that and the old
> APIs, also possible future works.

Yeah, I wouldn't grow this work any more. It does highlight there is
alot of room to improve the arch interface though.

> OTOH, one other thought (which may not need to monitor all archs) is it
> does look confusing to have two layers of alignment operation, which is at
> least the case of THP right now.  So it might be good to at least punch it
> through to use vm_unmapped_area_info.align_mask / etc. if possible, to
> avoid double-padding: after all, unmapped_area() also did align paddings.
> It smells like something we overlooked when initially support THP.

I would not address that in this series, THP has been abusing this for
a long time, may as well keep it for now.

Either the arch code should return the info struct or the order should
be passed down to arch code. This would give enough information to the
maple tree algorithm to be able to do one operation.

Jason

