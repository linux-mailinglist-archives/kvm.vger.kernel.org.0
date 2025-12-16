Return-Path: <kvm+bounces-66073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 21376CC3C3E
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 903C730073E1
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 14:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859B72E040E;
	Tue, 16 Dec 2025 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E0qrQXyi"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4297E2D77E6;
	Tue, 16 Dec 2025 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765896274; cv=fail; b=sMT0Mrmi6ql7pw/gs6hnMCA4dEIZ5ACMfje/F7K8Ix4jojqIjhfslz/9+n1yHeMEh97IThW6goVs2vW7zLXhtBeToUdgCPJ6a0+zlfA3pNFgkUJdcjHOD9Y4kZP5tOhNeH1Q2jpXYpPquuU4eUpY1QuHFOVDpC5pcq40g79Gz0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765896274; c=relaxed/simple;
	bh=mZUXDglTq9OBpBe19Cq7q50YGvkuoFn67XsG5+yj5hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nReEt4Me2fG9HjeOYPewxKqd+kJtp21St69tnCu6NEkYmcj1YuMNNr1E7/nSmad753gFMzLe1un6coA5DhXjQRhjdcaAQA5gp2wwf4rmsWi8mzZJ431uhRO9nquTpWIENinng4pEL2aVVzpUtvzy4nsRqkyw1owNTkndSK6iHP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (0-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E0qrQXyi reason="key not found in DNS"; arc=fail smtp.client-ip=40.93.194.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJc8gNNEQGkcbt33fPIAwTfNaehDMyVAVHfU1EzjktGXZ7lXeaGyKiXFlbBF2eFmaYF3oDhpmqM9Xobvok35bZE6QPrfBHwS3MgFBiMmGdQme/PqRJXGLRxvCRFMsfr261pSDwfIAFtbwZfRXrEZjbZfLv/tNQoKoV9H7PQ9K9ZlJRb0vOkbE3jz9r3LaM5PBI7SZw0+Wf1d5QJpgzMKEGup9bQy7oEslRIBVkmFcYc0YZah8M0YXaR5XDI3dFL7LdzTvQm+3S2zjGAw5aNAXmDzzXZaa+hh81LgQcMWE0D0Je+fUrrUUWuH8hDC5WxK7LoA0O5QFQL4Z5WwiGJqeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJ2u+VCGECduRIev8/XcXF57fRrjs/kBTB/UCjmpB5k=;
 b=mpd2wodbWNTQdWMy/+7+4KAxQpphGPC2SYkGSBqTd/6p+eIRBuqoMADYujsifGuuoGuyc2Jw8qxZSKzF1X50R7weM0a7WpOUW1It9QHYT3mk00CFcFXlj7BNg45r8oXEmMGzinRPdALHaJfdSCQ0zCub0EnK7y1lawsXrKCFoqpN8GQTFw3h+HJfALmSaG95qhd5qh1BzlZnb5BU36hlspD9gviD8Fh4NgbkivJISHkoSA2JUABRyhJCIdzfjjP6b8JS4vuRH69YEeFR8PzRatkcespcMsBEr/j86UlHwe5YccZ82JOs5uOdo33Swc7CYWmTUQ16mXgrmaWHzPEr/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJ2u+VCGECduRIev8/XcXF57fRrjs/kBTB/UCjmpB5k=;
 b=E0qrQXyiXf9PIN0k+ER/7+HNLmTQlawkiqC5oiJWI7DryiHhDreqUWU/hfjkzjMVV8fIsUyzqdyUmDOzxJK9z141evmquS2lpbseVD32j8nKghj2CAzbbbIrd9CoYEbCm8iGHh1IiAKkbg5ThyhX/ZlzAWKGy7mxz5lgyRDGlET6zlRbRONpEmfkvsGbt+Lrph6DG3dLUSWnyCal6rA9MU0VneT4eO1/aLN2P0NUGZt+v0qu1IYiQiSVLn3ZyWIGyJy5YDib7aqc3Brxwj2b3UxGP9/nT/yFLZx3M+21wCJ89sNNvLe4caMa46jw/p/QFSRme7YRA4nIs3FVxTJGyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by IA1PR12MB8190.namprd12.prod.outlook.com (2603:10b6:208:3f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 14:44:28 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 14:44:28 +0000
Date: Tue, 16 Dec 2025 10:44:27 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <20251216144427.GF6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTnWphMGVwWl12FX@x1.local>
X-ClientProxiedBy: BL1PR13CA0256.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::21) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|IA1PR12MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f91431-e72f-484a-0fda-08de3cb19d86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W54rKtN+51Q/BjtH6tKpFaAp9uZRayGlzXQvek7h/+ZCy6zXr8IVayBnqLux?=
 =?us-ascii?Q?D+BtpbJ1BzG2A/jWplV8IJgAMI6yjZV8MS8iAJUBW0MmUUTo+ECOPHovVEcU?=
 =?us-ascii?Q?q8aJjLJaGr8exxLfsuGRge5EfiBOlTn66qjoziwDQNnh8VdN5xqoahFr/GRs?=
 =?us-ascii?Q?e+Ubc4Ynk4OoWIBJ4r5IQIXCivHLOKdFeVo0gvgVHE0jepduFuOlt88CpzL3?=
 =?us-ascii?Q?eTOxXxv9FUf/omxszB6AbUPvxvFdSLFHGZpS7X4SedaWQYFpRqoSYDpQAgrB?=
 =?us-ascii?Q?MGRYyTfUXbj7Msf3mwIGX+1hoH1Q43dL/7am4ZklG/H12R8MKfVyBwyfximR?=
 =?us-ascii?Q?bs+w4ssoSkyRk25Q430nZOH9SYsZiW7jjnt0nRRAehPzfFNujw1RSuFrd2UL?=
 =?us-ascii?Q?B+n5Jm0st9xL0hHxNYHsxuZp3685m+Li1cGX7g4NII1ulra6sFz42u+RmwM7?=
 =?us-ascii?Q?mgMYWElVa31W+Jk9kob1AA4NLWPKSsCJuvvSW7XL3mphriGpdvLav6ZkXq3v?=
 =?us-ascii?Q?iiFAQU5gQSht/bQQKnq+5llbc/Dn8TAHEPv2tyW6mMVNnMG97Tkaer8DsTAd?=
 =?us-ascii?Q?0X/Czh9xE8E/I7eZMJwxVL3n36eY4CIHiUjt/Qy0uDzOutUvwZpsLO0VKa8w?=
 =?us-ascii?Q?5lZihrszgp55e3FH2wI/5xV2zBZLMJp3Fv+4ugN2Szwk8+OI4TqjVNn78uSU?=
 =?us-ascii?Q?Aoe1aPpavqd6wnSPAX3EQRN/lhibESeVEW3hyILXKMZLwniHJmSZAZAgM83P?=
 =?us-ascii?Q?adClhPOaf3+8j9rhKBv3dq+VPCXnNBoePdPVnU9fqM0rTCeDZzwKTCXcZrZ5?=
 =?us-ascii?Q?7TDA51RYcg/5RLzZW4z3XnKftG70HHqAQ2xoED0J3RVqjhWmiclD/JDmgjou?=
 =?us-ascii?Q?gxR99qp34ljzHRQ90fn0u6RZK1FH+BGnZzi/Uqy/TVIGMjDwzRjRBbgPZ5me?=
 =?us-ascii?Q?7V6xPSKUi2RIawhgVNxA/YMXfjGxBS8bBxOtpTBC/ZHfud3lbNbiwr+6T66t?=
 =?us-ascii?Q?81Z6f/iTXKb+cGuG2QV6fQF+t/UAzWIVgbjskkwsHkliTLCuVAA+0BIo1T0s?=
 =?us-ascii?Q?VA/LT3QkL8sh0iaXQH7zBez+znnmEB63UIdMPaAPsiC1aXmuwZmHXzHMutgY?=
 =?us-ascii?Q?TrQojQIAEzAOx0bHTzJV1yfZOM/0+cmNuZ7RNIwO7XFvk7MqGdhUXXa00aaI?=
 =?us-ascii?Q?8ndH9vteIyGm5f3LAWHH3G+pDY3hRv7YRzYb/C4o1Ih6wEtjxwU4AbNC1Gab?=
 =?us-ascii?Q?+sAM0B65Z3ysoBj7sSMA68PGyZdtCuNwx3EgAmwOMZiB7QPicLAmVNFCBfZv?=
 =?us-ascii?Q?wKXixF14ZaQj3xedxUBAOfqE9mIYX1my2dHzxX9y/ItkGKo+fRdmDcR0tT8n?=
 =?us-ascii?Q?7B53Mtd9+2SEKzRIjkAt3pd1VaCOv5lcTerXDVnTOKUygYbZsGVBCorwN5AQ?=
 =?us-ascii?Q?HSq8OJf4o4Rab/9K70kByVBTaaeyY4HC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+yiks6A0JuFCn5kN8m6N5BjDI0R9mUV1zb+wu0AAxkVTBaASO6o4qEduNSLe?=
 =?us-ascii?Q?YMMpt26TLBTf9quqJvL8aHTL5Lo+6ffIbrviEuHmUNnMq82LiiNzDQVwqOfH?=
 =?us-ascii?Q?ay98xE99jVOSWW8VMycpLtwV580GQZJajULBdv4YDxmKXcVStBUTxQUUPEkp?=
 =?us-ascii?Q?qFP3P/DagAVfZ/POJPwcOVV21oy6eo/IGrPxdCZ61X3xP5mo8QaXNJg+3aV9?=
 =?us-ascii?Q?MlzTomQoRCubci+Af9sCGwYqL7/8cUEWra5xS0keF8NU4IVxahJxhYvCj8E5?=
 =?us-ascii?Q?dWz6b+EZGAlL84BocbPMEXaN7iurP7kqbpnUDlbU98r3hIWJOpwF3qFfow74?=
 =?us-ascii?Q?KcTBVdHCmZW8i/FytzSp/v5e1qw0TNFzouey1Clrmb4yrTY0d6AVnqixslEN?=
 =?us-ascii?Q?zFvaR+Fv507GahQVxftSFiZZjwCjNF8Aowu7qObmHNIOskvDtSQ9PRYtQBtS?=
 =?us-ascii?Q?S78Jo+lXU604gzKs6ka8K52nw5OiHS6kUNDP8e2Lh3ixoWsT6ZnYCzgd3P/5?=
 =?us-ascii?Q?neU4muR2trk1pNEN/2FhzLDeO/bpowh6QN8e+n2jCg5PWEtBvEMV/jCxBcM8?=
 =?us-ascii?Q?HHQ9YZ/t2UUPHHUEpWYd714s+nhfD2TEVnuf9lB7fzwUAgbQuRP+mS/pKhpu?=
 =?us-ascii?Q?sdyr/E2juZ1qEa6/JQUR5k5BfyrHXh6NvGLHekP/x8XqlKxvIa0a3XRA0QY9?=
 =?us-ascii?Q?qVLaYJ8kQPCJgb0PfO8iCiCw7D2yzd8qMiASpA3ARqkvPC56j+LgdhE8Rn7Z?=
 =?us-ascii?Q?UAZ4hOW7CXB/WP9edjQSFPE7jup4IeWa0q2IfnJMNlajyM5Iz6/ZATzElGRg?=
 =?us-ascii?Q?ZzCw9TIqC1X8nBXsvIlQHLBzUx5+AcdXbyXxsnjhe32lNIpyS5pddhCDBMbq?=
 =?us-ascii?Q?tDKrb+/DCGjLVLzZGtHCXqkTh2AV1LyTshpHFcuDLJgILiYGUQBVkdwiJXh1?=
 =?us-ascii?Q?0ARtqPRc5khNOz94n64LameLX9P7ZzI0QOYVEWgzkvoyB3Xtd+eBiWpC3mkn?=
 =?us-ascii?Q?Vp1ly9zFPS1tzFH3PVH64zvu5krNQs62elqnR7D2kVPjQ2TMZ9JHPBdKa27e?=
 =?us-ascii?Q?Z9j3X09/RhMMdJWHHWA+0c+IzqV47ku39u30s8Q7eswiJeECBv3gjFlKiIGf?=
 =?us-ascii?Q?wIjjcdHpyDP6GKK3A1Z2YJzONyk9qvdj7MQdj/d32x4zG1deNjDtE9pMCIIx?=
 =?us-ascii?Q?GyZTl2Mx8bGvrXNpYEnKq9vq7MzKQXe2Zk06ZGjlwwZAvx0K6VsZTb0pPnif?=
 =?us-ascii?Q?aoHorJiwapOm504PjDhMLFPpTpmXaGV06FLzpSTMbENpGE+tRvh4ae+dxrnU?=
 =?us-ascii?Q?rvbpmGuUSgUHdSH0/HLYJc1wZNpxnOYX+tecXFS6zAjx628JwI82o7S7qnt/?=
 =?us-ascii?Q?0EodJEtwrBpdXNM1Vt0eu/UTVtmoTv7nUcPq8uKRM48uXwXU7Gk5TsbyQTUh?=
 =?us-ascii?Q?1PrLdrrkIFdOYC/oN55EZqhAtv3tkUrixg6Buqt1fl5ZFmY0pJKZhpQprctK?=
 =?us-ascii?Q?QaXl1uG8JTQyi7tFm9doVztt+6bH5V52s69loTiXc6UgKJOvt3O0xcJRqPy0?=
 =?us-ascii?Q?G4OeqOQAyi9KOe8y/ys=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f91431-e72f-484a-0fda-08de3cb19d86
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 14:44:28.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jv+HTEfCu1/YZwNo+MkkGI+/3JcS3uy6DUf+RGTibIX735EhaK3bpc1CppDF+s/g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8190

On Wed, Dec 10, 2025 at 03:23:02PM -0500, Peter Xu wrote:
> On Sun, Dec 07, 2025 at 12:21:32PM -0400, Jason Gunthorpe wrote:
> > On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> > > Add one new file operation, get_mapping_order().  It can be used by file
> > > backends to report mapping order hints.
> > > 
> > > By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> > > the driver can report the possibility of mapping chunks that are larger
> > > than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> > > when allocating the VA ranges.
> > > 
> > > This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> > > VA alignment matters and it needs to be aligned with the size of the chunk
> > > to be mapped.
> > > 
> > > Said that, no matter what is the alignment used for the VA allocation, the
> > > driver can still decide which size to map the chunks.  It is also not an
> > > issue if it keeps mapping in PAGE_SIZE.
> > > 
> > > get_mapping_order() is defined to take three parameters.  Besides the 1st
> > > parameter which will be the file object pointer, the 2nd + 3rd parameters
> > > being the pgoff + size of the mmap() request.  Its retval is defined as the
> > > order, which must be non-negative to enable the alignment.  When zero is
> > > returned, it should behave like when the hint is not provided, IOW,
> > > alignment will still be PAGE_SIZE.
> > 
> > This should explain how it works when the incoming pgoff is not
> > aligned..
> 
> Hmm, I thought the charm of this new proposal (based on suggestions of your
> v1 reviews) is to not need to worry on this..  Or maybe you meant I should
> add some doc comments in the commit message?

It can't be ignored, I don't think I ever said that. I said the driver
shouldn't have to worry about it, the core MM should deal with this.

> > I think for dpdk we want to support mapping around the MSI hole so
> > something like
> > 
> >  pgoff 0 -> 2M
> >  skip 4k
> >  2m + 4k -> 64M
> > 
> > Should setup the last VMA to align to 2M + 4k so the first PMD is
> > fragmented to 4k pages but the remaning part is 2M sized or better.
> > 
> > We just noticed a bug very similer to this in qemu around it's manual
> > alignment scheme where it would de-align things around the MSI window
> > and spoil the PMDs.
> 
> Right, IIUC this series should work all fine exactly as you said.

Are you sure? I did not see code doing this. The second mapping needs
to select a VA such that

  VA % 2M == 4k

And I don't see it doing that.

Jason

