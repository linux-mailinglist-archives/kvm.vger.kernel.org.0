Return-Path: <kvm+bounces-66086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E5BCC4F75
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 19:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0C4DD302425D
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 18:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA7A33E360;
	Tue, 16 Dec 2025 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YAj2zp0P"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE652EF646;
	Tue, 16 Dec 2025 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911541; cv=fail; b=ed/Pp43V1zPxm4DWFnK6jgVdihD/Q0bpTPeBVVE2OYMjbv4EN1dlpb04iGX9F0HgGyi100SmoxKHhgS+pCQWDRIGKNiOQhdEihoh8c5xvPxjOEwk/bS2fHXg02XfI3FZgb35UYXVt6Wi+wKtss38XDuX6OeMJyV44UF6aUHPcRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911541; c=relaxed/simple;
	bh=czxUmOTFh2wNf+K8oXS5HTDMjS/Z/xt2D9n2vFfxphM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BQTP2Bbi0k+IV+PkC5B0ciJGUK9oaKldR/la00b9DEIZ9xru8PBBjjxyjguhVXtviIJGud5hffNBabU5alJ4b33IIGAujyi5/jHL32g3Kq8PNjQq05t5PP1fQKlQ3cullYy6Am6n5Nfb2cji+r9sFR1aeHd/VaA9sae8vRIXA1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YAj2zp0P; arc=fail smtp.client-ip=52.101.193.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afCAyiXpXPVo5NuqWBOwlfcQmI9rHuYISBecnWM+wBWn715w1IL+EDeC0KlyQhVyVFc4T1zFnE1hEOfD2z+76eU8PZwGGvzo84HRBl/4fV4kr53HxXU0/oRIsqISvRk5Umq4aGXRVJKr3pu0ZN0CvPCSfBRPMpKOAr7GZp7EZ/RZMP1RInA/RwPKUwZ0HS62i3il5/mWkxdke4Cb3WaRLyPmnO1UQsuMrQdP+oonP8k+9+vF93qt5+mgXUJRDT5O9M595r6meD7TvOppsK+znxCdq91x6f7HEkaoidYKyLCJRtdX9N5X52+aseq1qKiseTdObDNg2f/ZEfIFG2Pd7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfSd9oCgX8aOTJ/KD8FWS+mVEuX3VvBm/11ki+D7k6Y=;
 b=GJwXBBhImAyJHFFI3Zdy7aerhv0lU+Xadc6juxk7zvLyZ7uWBaQOshTKwYs5IPajpS6ZqtRT1gpX4xzOcEN0gZcosuB5S1QFb7GFr1xAgZb0GV9k4dElSexFBjlJUJrpL7798PRU8+eSGq+vMo2lzM0WvC4+dqJcbafsiSR2Eira3i0GZvYga0bt4zhjy9tKg/2w8L1gekWSF7XdmclB3NJGPr6St7jn2iz9dlHqKSz4OiQXZUaWy23YSH/tsuD68sUD1yGsLOtC6tLJUsgigjeLsWsm9l+Xr3O/4K+tU4Oh6ywF5AE51m0PC7srDWv/WfFiYHcr+0RlB9sjl9IVCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfSd9oCgX8aOTJ/KD8FWS+mVEuX3VvBm/11ki+D7k6Y=;
 b=YAj2zp0P6TfVSLn7B7r7ERvc+j05UfDWacyNlZx779Rj+y0sKFur8PaU0ox381KrBzZnpO+6fOqsjHCrX9cWIAL3AL6KXcw0VgCXsjlDy0P/dTUcFlrj25J9jgsPXWUSJgvDCiFMkmFBVnRe9fduAzqpAnwoUA59vnq7a6jpKd3DUbHT2QWIv1H90ZZKb0xw1pRV88S1wGPdQocOHfq4rGp1b1UzPnQ460JjCffqjZzCB4dVxRLFo3kDBvAnxKfzdEstS8YBvGzcM2wdY61hHK2TIUy1fLVmc3pg50TnTvCFXfrlrYK9gMtMyjChYJRRyjDCTsrofrCY2NMNWNwQ7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 18:58:52 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 18:58:52 +0000
Date: Tue, 16 Dec 2025 14:58:50 -0400
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
Message-ID: <20251216185850.GH6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUGYjfE7mlSUfL_3@x1.local>
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f19088-ec0a-4dba-7b8a-08de3cd52767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LXFcGs5inIUV17h9onn7IGQLfunsjfPaeyDc4LgE7D/O2QlgmcGaY8MXS41H?=
 =?us-ascii?Q?hpm/wfHWYq1YOyjrQkALIOcgBPQjG53ef0piuUouZCi+wB9FxtmzALrpYtF+?=
 =?us-ascii?Q?JAPIBZuNEB+7oc0vIhDsCPy3NMtFGyHdy1dyfb+kOXWmT846wMwfRD5BNUr3?=
 =?us-ascii?Q?nHZCOnZfPcpzTgeBlI+xRukNKnZdVtOQRrXFzceGQiTG9Wv2ryBk55C5ejHI?=
 =?us-ascii?Q?2VKM9Bz7/VKOG6AxFcVsKubtbuBzySsUHGZ/ukExp3GnnJbcmqLeejjyd0Ah?=
 =?us-ascii?Q?Ryimd3RRn/Lq7cK6iQjqDjgPkJ/EubWdZr56IZDi6RmM9/Kl3wChoyddJoTu?=
 =?us-ascii?Q?R5rLIEFCxSzvirJNwHf2YLS0rhAFOYvnF5Mi67I8y71aeZOdBXhlg7CueF/+?=
 =?us-ascii?Q?XDvlhygKAB2FCuU+/dzDKRQQnPlRP5QFeOu011VmqnLjPvRzeXP8p5df9Fo0?=
 =?us-ascii?Q?8KfeQ1hrcXJSYt5BjjbSXEI4rWtK7ObNMxZXpmpN4NuboIWxfwvfrxFCsSRF?=
 =?us-ascii?Q?y3QwB+geO4vAeDuwOzmJZsDlk2681YK5fe0XObOTF6LhdAUHG2PTgwIzPl1J?=
 =?us-ascii?Q?b0bNJ6v/GaZ44uBoOq75CPl9+sfvtXJ328saW0NI8vhGHWLqy/uk6PeW8yNe?=
 =?us-ascii?Q?3ZCYa9u6t87fZjqiCTosVM0HcpYRt42k6YggnQJfo1akOehOfP9xsRPB/hxq?=
 =?us-ascii?Q?ryGkat5bUoSCSmYibbOc2e0AY8gDlGfqr1CgtrgErng1MOc1avJ6U65GvfWL?=
 =?us-ascii?Q?3CAtkvkDaJiLFavo+/BtFb99RoWXba8DEnogBRugniMYalZbea0afDkCeiGe?=
 =?us-ascii?Q?Crf5+B+2BG8vutO2sdO8PQtcxC5EFk48VFIk1V0L4xSi4ZH6M5fPyNkClrNu?=
 =?us-ascii?Q?LMxAcin6GD/HJGcG6SkRWGvrdeqcR+MPvzlWQszCKJy0v27SGsuD3jfTNBZZ?=
 =?us-ascii?Q?cYkILmaH3Rv7//AkLZLoHKHRI8pD1+VH/TSndOv9pGPQS4ZPHbIOQytmHpPl?=
 =?us-ascii?Q?7E6pOAQ4EwB+TFyru038jX0m08XAY5dyUxWxgjNrojBfSpu70k13T/yunN0E?=
 =?us-ascii?Q?mzDLjJiIR8CxAJh0biR3oBgmC/FNSKEfvqrhLu0BqYr7hqDF9mKFlyjEuXfC?=
 =?us-ascii?Q?lajMVdw3pJ16Um3bKDsx9vML7YlnGJZF37j71JLPsaDGCM3N3Je2q5B7n4D4?=
 =?us-ascii?Q?6VhZw1a1Aa3nvlfiAhPaip4q6Q7n0mYZw7KM1ggjAkB2Qk8tVCCVfeiEqE5A?=
 =?us-ascii?Q?DHz3EVQJMwOny8oB3EkzjYS1Q78KbEJs9kJF7xNcEueuSWA6TL4ojh9cc1Y2?=
 =?us-ascii?Q?nOUH+K2hQJJG/v2TeRcSpuUNUNSzMyjsu2wQ++GTPBHyzQkkvN/NiHkzlsEm?=
 =?us-ascii?Q?NQwiI3o6FW5+0RZDotwv0g2Qdc1PUBrLWix9qgCL2l5awuB1+VqfbAMJ1q5I?=
 =?us-ascii?Q?P4ZtM/6Dj5Q4ov7IS7wyzVtVT4VMbRE6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YEYfhPhbz3+7Edpqa19mNnKAmxxxcA3sXL+3wqsQMaIn3Rvkzb+9d+d5Rwms?=
 =?us-ascii?Q?LDhL99epMq4sUL1zNxdQuixG8fcy3ggGxaiH6kf0FBlPwqjeCjZKFQe5Eqrq?=
 =?us-ascii?Q?qiSjt9iTEpowH82gwxhktMFukjCpqytQ2qNQcY1juB7tABQH6yvf9kmEYDsJ?=
 =?us-ascii?Q?sl+qnJAOy90/8demnWf3epT00pAnYER4oxOZGYX382ssvVoCblCLMpYvWNVg?=
 =?us-ascii?Q?txPfnyYjxyqSHR0nL3uTgpgZ7f7Ovl94+fTHBjgpjGPHFuVSxgn+HK1FOHcD?=
 =?us-ascii?Q?wKHGkblJaKcNTbcaJfiNrTjN7u+Z7sNhJz4LODQ5vER0ftffDlFBlg6GssJL?=
 =?us-ascii?Q?raoEA5xM13rxrla2rUvkUM2hSQxO2i+w7A/Xnw6J6zK/YSn8r5SUkouFBUxa?=
 =?us-ascii?Q?6ZUsS54yf8qn0LsXvbqDfA5jccnItf2EHVXLFiKJbrLEygq7C1vDOCatHJrb?=
 =?us-ascii?Q?qu/PFErzwkODskdpVw1ZtHuvLLLLhlQc5ZoM6yaVkEmX8CSB32UxJdf78WoR?=
 =?us-ascii?Q?p1rHtM9jUS19Gn57pM50kwxYJ4+K4v5k9b90WCfeu2+ncdRA4Rf5KRVfRkon?=
 =?us-ascii?Q?kiWXhElrRttWk0C7dUDWVVLIG0CQvOvpVISLhqc3NaWBoddtYk0Wfqv78aUU?=
 =?us-ascii?Q?7d/NkGOs3E+SZsbxhFK4PlDDBuAodFauSoTwTz02xaVK2G6aUvvoFmtUqfZJ?=
 =?us-ascii?Q?Z49D68OtSMngMMiz7AmSqKkQzQnZf3ETl6Jwv+WgsKhQsA4X4MWnBfYMc+v2?=
 =?us-ascii?Q?luxi4Ie9UnwDtQer6p5VUaUc00XekIqf5TT6cHFrCgK/j8mPvqSyLAOCzUu0?=
 =?us-ascii?Q?XuKQXkx9KoyIyMWrmRsd7mJRlnGBled7bqAZLlujL3gcPfP3hW4qjJyPtp2a?=
 =?us-ascii?Q?nQUDf1BWy+/kp9OwMbHDtzcVRZurOZ8vlSVwL79UVOJEI/9VcZumemTxTW/3?=
 =?us-ascii?Q?HkQ1JTQzS1UAdgmrnyQBVzwIJYtD4SU1p2pbq4qGhvGZi2N8cBKfTW6oLVu4?=
 =?us-ascii?Q?JMusyGsHxDsESj3WsRX8SDMjsxfbUugQptAyGkOJ4JQ9ahSmhg6NOlObKt5M?=
 =?us-ascii?Q?lqdNgX5rAEK/0m0chHy8ASRHDdjfXhqJxGZk18zNgFwnh0u9o2SHK4vQGZ9s?=
 =?us-ascii?Q?pnra2jopMUAxgriAPCtGMGx43jipLekhrmxRap8ERAT/tamAZwvqWIvoLS2M?=
 =?us-ascii?Q?Qatk2l1NNd+t+kafoJwCzbygrTcAkJ96qhes4KZqNmxrJAcd3YC6ytavlbzt?=
 =?us-ascii?Q?PHo1F5J95LRWpeO6lZYJyw+K/FypuZYMnxwcA8VKBMXIqSaIumO24kkEbQ9k?=
 =?us-ascii?Q?mZJfqr13dSOjPyikMfY05Mt3sdJb4F6r6T95qnWdQNhW/Z2FKk31fpEALZGl?=
 =?us-ascii?Q?5jNWehnIX4QjTDupuPIHZZVcWqOKGBC+4fGaxaJ1VJhjI08ogcYqRGUx61UO?=
 =?us-ascii?Q?vj4Y6py36AhW+l3DrBsNCqeZr9UuNnKuFLzk74S8RpJdHLncaBJ/VqSCId4N?=
 =?us-ascii?Q?VlsxMUkfe0V6xcWiyNq71Na5foVYIjoKJD6Avmh3y+AMJiZM2OnzA4DeeoR2?=
 =?us-ascii?Q?ogWXYOyXVKlw892pJnIQ4YjHYjQA7eqVCzhUQbnb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f19088-ec0a-4dba-7b8a-08de3cd52767
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 18:58:52.1379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LLh5OUACPFl/UIQ4PjtqS+ZxeYy7nF3LoYxMzefstfE8rmv4XjIA+tk6bu0T2DR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689

On Tue, Dec 16, 2025 at 12:36:13PM -0500, Peter Xu wrote:
> On Tue, Dec 16, 2025 at 01:19:44PM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> > > Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> > > with len_pad (not len), and pad the retval at last.
> > > 
> > > Please let me know if it didn't work like it, then it might be a bug.
> > 
> > It should all be documented then in the kdoc for the new ops, in this
> > kind of language that the resulting VA flows from pgoff
> 
> IMHO that's one of the major benefits of this API, so that there's no need
> to mention impl details like this.

It needs to be clearly explained exactly how pgoff and the returned
order are related because it impacts how the drivers need to manage
their pgoff space.

> Here the point is, the driver should only care about the size of mapping,
> nothing else like how exactly the alignments will be calculated, and how
> that interacts with pgoff.  The kernel mm manages that. It's done exactly
> like what anon thp does already when len is pmd aligned.

The driver owns the pgoff number space, it has to care about how that
relates to the PTEs.

> Or maybe I misunderstood what you're suggesting to document?  If so, please
> let me know; some example would be greatly helpful.

Just document the 'VA % order = pgoff % order' equation in the kdoc
for the new op.

Jason

