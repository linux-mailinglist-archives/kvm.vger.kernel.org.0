Return-Path: <kvm+bounces-51352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B3FAF664A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 01:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC0311C428AA
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC4525486A;
	Wed,  2 Jul 2025 23:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rilW9YQv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6952DE708;
	Wed,  2 Jul 2025 23:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751499171; cv=fail; b=SKcO3J0Q6FBYaBQcb/28klrNTt97LD/DD9LOMKW7fm6Hbb4B7fdS4rMBps+s0EfOUnEf+US9W5mhpiTtCortZamd6Q2TGPfZVhw4RboSQfVuehsmhB9cBpUD8GM8P9aoo+YJtD6Sy5b2E/dmK+nQNb4igPyA4Bg+uz22/xskED8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751499171; c=relaxed/simple;
	bh=E93BVmxY++t1mVFUdxtOp9Pf+Tc/j3QNB9sw1rfLGk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DdTm++u1nsxu0vMJtaL3AbcRsqZ+r3s1nKbTjefZgSaQZnniQOiD3CjqxBTV8h+sUhqboiAjnU3d9F/y2OPWfgoOd/CSBA97yzFXnm+zlLFKlSkwGyhaL4dkSW4Sxx4X2q3jTQElovTEWbCoVyfgYY5vcPrpE/sb6k3i0xQXWxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rilW9YQv; arc=fail smtp.client-ip=40.107.92.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVV7+MjOAhivYJw3ls0eE5bPSckI7wRYG2o5un8vU+m9GVEDl8bfJWNsFn+BLRAOIR/FIHF1O/iSPnuhoACpNz3kQjnSRn7ftWLdoYmFmabLq7IcmfWrNh6BQ1McX0JIXGPhNPrbunvw/tkEHaBSPgsIucQb5HtFUheO5/gOwrfMX63vrAGUGP9Uf0p5f6Dcm9wSlSvt85kqah9SDydGLVE94GFi9lRVb4S52itJCVw9+EN9W4VYCJE8y0IysBwItW3nhCrFVsz8nXBDrlrFCpUCW78XfQNkHK/ZllsZZr7cyP3chhRGs3TEMb2v9ViaZJk5GgHfO6bkqcHQQ6+jJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbbfBeRJHGy34KfgKAUtanWUQv7IW3qYqgVFTE0Ezj0=;
 b=QJNZmlVwWFdV17VCHDccXfVRRq9/JnX5AhXidn4fy0kPVDf98kWvQhywweyOK9jRQxoP2bijcYVuoAbAUKp65cFYYmBMw5dnmLJLL/DUblNCh0t1vBl5AHmAOJrcsabYX7hp7XBxlXCt3k9Vk8ulW4QFtYmeW7iYRJ2ru3KQNO3t6149qeGVZ6h8tEE9Im8a6ejZh9vtck9MQg/LGLj6pOoaqFzQfkS489o4uV4/II5W8tcD1p+qaLhl1sxfcv6QbKmewZvDRWq44WaISaiBeMAqI5BQGBvp1L+548iEpdiG3IcGeW6oPf05ioU8iPB9tUFLRrhxzq7fdGouMJaLzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbbfBeRJHGy34KfgKAUtanWUQv7IW3qYqgVFTE0Ezj0=;
 b=rilW9YQvrRGc2Q+s8WDKSzLppU5Zlo+HkQQZeyWrE2l0C6fHjPCm7pS+mFywhJ/yCI9mGMmVjBphyEm4NL7uGMCLIyCyuV52wjobl0tohm3BuqS5ROE/OcGLBk8BKUZRAvE7w03c+vYUMJLo4YTa6XYqZmGKY/VYyYQV32ZmZ5ZCAlZyHZSC0T7m7ZOJUpMBS3O4mzPlPG0pneK5Wpd79PWRlNdnxOwa3+7N2wtV6AS/hfUm3eH607U0KQvkemfsFaXSn+p1+q6S38288zZ7StQ/vY2dNpknPtIaRNGMgl90n/s1Cre20AAOFqno0d0wfPpr8L/EFUcyFkFWvyj+1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6082.namprd12.prod.outlook.com (2603:10b6:930:2a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Wed, 2 Jul
 2025 23:32:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 23:32:46 +0000
Date: Wed, 2 Jul 2025 20:32:44 -0300
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
Message-ID: <20250702233244.GG1139770@nvidia.com>
References: <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
 <20250624234032.GC167785@nvidia.com>
 <aFtHbXFO1ZpAsnV8@x1.local>
 <20250625130711.GH167785@nvidia.com>
 <aFwt6wjuDzbWM4_C@x1.local>
 <20250625184154.GI167785@nvidia.com>
 <aFxNdDpIlx0fZoIN@x1.local>
 <20250630140537.GW167785@nvidia.com>
 <aGWdhnw7TKZKH5WM@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGWdhnw7TKZKH5WM@x1.local>
X-ClientProxiedBy: BL1PR13CA0198.namprd13.prod.outlook.com
 (2603:10b6:208:2be::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6082:EE_
X-MS-Office365-Filtering-Correlation-Id: 78ac3229-4645-4ff3-a7f9-08ddb9c0bfe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v70MC5PxZPGeS3wof1Nd9p+7x57zCDAW118lYcBlSknK+cILuz+SpfdUUHlt?=
 =?us-ascii?Q?a6ILgGb/jIrKcM4hVxVETCy7xLZTLtv/JZAlmu4WjRQd8+KEJF0ISSbmtQLt?=
 =?us-ascii?Q?sAaWe0SLbCIFT6caIKoCxAdUPfjCix0eJebqO5O/KKS+ikdtAq7s/umyUnuI?=
 =?us-ascii?Q?k1aqKvsGspv8wRI72/9tQSh0mHayxWt+aYfO4pZT57s1htEneus8McwaSfCt?=
 =?us-ascii?Q?MQvxE/w2Ed670THTKvviOkL9qDmVRnM9ZWyJbvKBgXic03Z+jAwxNVKKwZPg?=
 =?us-ascii?Q?+7yjKsqqHbM0AgL9I6jSm+d65965G1Urfhazk1o4le3+JrSSPXOBq+YmFqQX?=
 =?us-ascii?Q?D8+SqeAVigg+dMcNYwZJHx3jYAnNfW26kNfY4Pfuw7KRxmMRUnTCEyKPwiW0?=
 =?us-ascii?Q?VJPfHfoA2Iue4V5BQVboe1aLzQBKEXqO1/5CCFXvsm1gHLvhyN9r/PD1frJ7?=
 =?us-ascii?Q?QxtEbZ5/WOjTtbbc8jUPmClpERqcMpCaF9CfYQ7TmJtkt6Zk6c9Om32P7FNQ?=
 =?us-ascii?Q?klU1yH1U53tK/3sfvBWVmrIuyp26hTXswVb6Q146RcnRwa7JRDjstwQezBFP?=
 =?us-ascii?Q?VBh3m03xSgg8TJV2IhZhf8L33p+cBgF7/wgb9EglSCAC85Pr1+rEeX1aQgTL?=
 =?us-ascii?Q?xBs9FSFwK0vNcKuGYPKiw0bhLA1B8575vsZiikauXPVkU2DhpadZjOxfo7Ak?=
 =?us-ascii?Q?yQvDqRfjfUNG79uRnElSz9RmZ1aPmA4UhkJ/N5Pjdrv27kScBvDupLN+id61?=
 =?us-ascii?Q?BnPdbiVIXZjcFQco8jmn8TTBsdq0kV6Dj44A7liV8Xo8a9kL1og4f1BnyHJq?=
 =?us-ascii?Q?Li39dcPW323P5Du8VtVZZQSvq94P7G25h37PCZSNHETb9Bq1zoD1AAZHEBYQ?=
 =?us-ascii?Q?+sCesxtRpiRY6vsRPvdzvoDfLIy4sRoirXoxIGuqbFwuNE8K5MGjrHpoZhjo?=
 =?us-ascii?Q?GWv3LqlpLGZ1rAnKytx3nQbcG4osTHKLdUBV9bbIuFqOcTgxYONoTdDq6L3E?=
 =?us-ascii?Q?ttKAgUDdsOtFA/2yRMKyRnR0pftKSWMYkSPiW9E6nlUrCDClC60uWfDuovMn?=
 =?us-ascii?Q?XSCyKjhSO2L2CyEqfaDbHrDSeu3wIcK3O16bCJ77kACnbeRN2R3okgyAvt/V?=
 =?us-ascii?Q?8+pBpDphD6TALnJnpHoJ8+XgxOpFPBytRB3yoM/YS2pO+IbVJ5JBf2/Ugcg6?=
 =?us-ascii?Q?XDGnhkHAHYV/+cm/V1s0pqaxsezzynFdWRUMU6JZxb7EoOnrGPcg3kYcYpUz?=
 =?us-ascii?Q?ACbJsOICUraNzHWdvvKijjj8FNmewxQWipN6B+HlvPZN3qSsfnQpKpZddv7y?=
 =?us-ascii?Q?yS383X0H/RuILMUoX5i4XZmcHD+BBbmScdo5hNxHmzaFEcHJBeg3dJ4NRsRL?=
 =?us-ascii?Q?R1QBFMYDX5R3+FA/z/Mr+NOR8pzVbXD2KIMeWwibBQJIGVZXdk+4s5+7M/Ee?=
 =?us-ascii?Q?if3FZIIIivc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6CSZqVHl5skAiDAZI+FwlvRSHi/5r+wRGf/eQhlpKqyM9Z41nWcEmfiUjlql?=
 =?us-ascii?Q?xAjQ/C4Qmn19X2ks1kKNHour44OZrzm37OQFYL9B2IfSKT0MBnZirm58KqNY?=
 =?us-ascii?Q?REddYQaG18uwUp5tMfUm0oOI5YfoUu+1uxkpsgSlGRc7suOoQjBVBNZGrDqD?=
 =?us-ascii?Q?y+0Sq8L+VB/Vd2nNdmeYr83yDnbEAxHJ76Y9KAErDSehMXrQm/gKja64TB9q?=
 =?us-ascii?Q?VXf0uNHJrrA9Qu6uWfXmkyFKPK7bJ8hkft8MbzdBBRYLhylM/eY5cmppmR6P?=
 =?us-ascii?Q?IpGayKnEX3H3+Txk6Ypg2+ri2h849AbQTcj+SJWu/TdtUmLGAluFSQRg1UYO?=
 =?us-ascii?Q?+oMR0LBEnuKnht6uh9NdAq/RQ8r9tOAZ6jTEXpVOG+Y+E39iFnxQcIOOKbJ+?=
 =?us-ascii?Q?tkJnxkba5QxoZ+Cd4s09NPLzY38w0jJFoxK92dBD3u4FUoUy9odyy3sNk642?=
 =?us-ascii?Q?pkqKpm8qqzOWMCHvLLxlTr2Fov+YmAiAcxBf19UOajG7g74Ft/5GU5sWlvqe?=
 =?us-ascii?Q?ksds39rMZrAWeRNkEagFEfvBUFlQIM85941Rz8IaAcgesTPXJR7TmQFFK6ho?=
 =?us-ascii?Q?50UdnD6PooNqyUOU9hnFSAr3xg1KvcVctKjI/sYWP2RTuHe9hvoTIr0AFD6V?=
 =?us-ascii?Q?QKQGrJXuFvJPLKB5N0GgQEl3bPgX6JXOgM9SiQD15ZqpbuVuofVO3RnDXJ4Q?=
 =?us-ascii?Q?xgrF0boyXbp2qJGzsiegKBOPckREEdCO8WONPmXw5+Z35GPFCj5ehzTsz9lm?=
 =?us-ascii?Q?5eWRFXEQCUu4ZbajkI6PK7pjKBCqh40zuErXINdGwYME9NA9wKHznTM0kjWJ?=
 =?us-ascii?Q?zLq4cRJ7j4g4y/xgjACNY7mUU+PzhzB2P+0b+7jtweb+3HebzwGHbU6VEFwr?=
 =?us-ascii?Q?xHxTYbQolum5z2JQ5wUnCjOlbck23Q+AmBBWieb+KgE5PajFcoodi6euXYv0?=
 =?us-ascii?Q?PCLUJx0xPn2HXaMX+c2C9s4h0jWDNhYtzkL/DOgCpVFuDrb03k6yj7ek3TsK?=
 =?us-ascii?Q?3EvReB2bGP5X/dXTowlfbopfxm96r/MJGdhy0RovE7VNJYUDQ/Di5c9Uz5Lx?=
 =?us-ascii?Q?BceWgf7ggAvrFYPTmoG1Aq1UaKTIxecxKKuBxGH9ql4eILkeodt0Lm2RclhI?=
 =?us-ascii?Q?Mv9Vkf6PI+ljbejs2HbKdkdLct657uIwoWO00scL+7CNDWQDgYRzd+N+B2z5?=
 =?us-ascii?Q?Msr/nZKnz6kum9wXJ62hjk/642px6JsPtGYqI+5vXDPIozIvQwr37GMCzaFs?=
 =?us-ascii?Q?F502pxh2XPFxLM0K5Ov6+HZGmorFlUr0vuEZYTn8pcVFr96OUFFAegB6F08B?=
 =?us-ascii?Q?8h1DOuQ+T3FmN611WsKzq+2kyO6j//VqoEFCb3m40KPf+GBDpeP44YKHxgn+?=
 =?us-ascii?Q?ha+yvfwlLm9mmI/9yNTGEa2GXmpUC+8tTlsVkIL1rIk0nEwlTUOoCl3BdCur?=
 =?us-ascii?Q?BiUPbfntn6bqpVbiU2zoxxjtyKPcPam1WieLP/gEssXn2yyhvF/QPdmB9v0D?=
 =?us-ascii?Q?XlxJSgirSljGPfrqTxfNXM7wNkMdtzXsRcFe2km0xhmmIibZiQAQqgGnbxVy?=
 =?us-ascii?Q?u7LgUUql+rV3QKOClLTrVsgEQ16rSQV2EZKkzTkY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ac3229-4645-4ff3-a7f9-08ddb9c0bfe0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 23:32:46.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpes7mgQOp+CuY5PBJ6rOO3bUcP9D2KZoX3wU4sh3OVAbyzEF9PJd1ZElT7nNmfS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6082

On Wed, Jul 02, 2025 at 04:58:46PM -0400, Peter Xu wrote:
> > So you have to do it the other way and pass the pgoff to the vmap so
> > the vmap ends up with the same colouring as a user VMa holding the
> > same pages..
> 
> Not sure if I get that point, but.. it'll be hard to achieve at least.
> 
> The vmap() happens (submit/complete queues initializes) when io_uring
> instance is created.  The mmap() happens later, and it can also happen
> multiple times, so that all of the VAs got mmap()ed need to share the same
> colouring with the vmap()..  In this case it sounds reasonable to me to
> have the alignment done at mmap(), against the vmap() results.

The way this usually works is the memory is bound to a mmap "cookie"
- the pgoff - which userspace can use as many times as it likes.

Usually you know the thing being allocated will be mmap'd and what
it's pgoff will be because it is 1:1 with the cookie/pgoff.

Didn't try to guess what io_uring has done here, but, IMHO, it would
be weird if the pgoffs are not 1:1 with the vmaps.

Since you said the pgoff was constant and not exchanged user/kernel
then presumably the vmap just needs to use that constant pgoff for its
colouring.

> > > The changes comparing to previous:
> > > 
> > >     (1) merged pgoff and *phys_pgoff parameters into one unsigned long, so
> > >     the hook can adjust the pgoff for the va allocator to be used.  The
> > >     adjustment will not be visible to future mmap() when VMA is created.
> > 
> > It seems functional, but the above is better, IMHO.
> 
> Do you mean we can start with no modification allowed on *pgoff?  I'd
> prefer having *pgoff modifiable from the start, as it'll not only work for
> io_uring / parisc above since the 1st day (so we don't need to introduce it
> on top, modifying existing users..), but it'll also be cleaner to be used
> in the current VFIO's use case.

I think modifiably pgoff is really a weird concept... Especially if it
is only modified for the alignment calculation.

But if it is the only way so be it

Jason

