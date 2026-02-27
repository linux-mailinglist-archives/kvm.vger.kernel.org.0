Return-Path: <kvm+bounces-72234-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iIe9AHMVomk0zAQAu9opvQ
	(envelope-from <kvm+bounces-72234-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:06:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FBBA1BE776
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FC52314998D
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BEE47A0D6;
	Fri, 27 Feb 2026 22:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oKb3IEgt"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E9A286889;
	Fri, 27 Feb 2026 22:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772229877; cv=fail; b=VwlHIBBKbX0S02Do7pJjIZNh9U34OQoErnKYJnQ0CKf7cwrmA41rMPIa1yerciEPW4B3EuveyaB6HkY97ogNoxLmtN4x61jzYoiqMfZCl+Aq3u4gQ+XAKUBF3iZO1FY+e5cfgm0G3K9r0QAKfFXjcMb21f/vXtZkaHKkVLYIi2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772229877; c=relaxed/simple;
	bh=QwYybhAVn9bpMFxz/PaU8nBWYC6It4mEV+yJcLCUflU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vEInSbrhWkOTar2MB5z64ntrUCYufmr5HNI5/2TTFyomSKGWD5HLWHIts3sd2IarUT6mCg/zmle6x2QESDhpOqKXq/07dD4ntTihqJeOOAFupSpxvfMLh6QDmuCZrdslr5MKHSIN9tfVdFLD8ZiTT1eBGgqVtRvSejZASrqMTz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oKb3IEgt; arc=fail smtp.client-ip=40.107.200.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzK1P+xFG8Bw6NBn5F3Pl5UUnfF5yPTqeKi6gJxru9uArnvvks+rHhclP9IrDU13FOdiXqIzrQFSOOla2/02E0fDXsM69BgnFrHXgeA2dB14gBD/L1XgYO5x3FPKbWqqw6WZgiboeGHneX43MNusHGpetPheALeBoajz5nE5Yk0DjQHSwKzmARRC6lqqBfyBtKKbajxXomt4xZag+cTeWOx1Njz9+ul6G3tCH7KQULbFKtiiWW7DfSEt31bXa5vd1oEKT+Fin6BZvB5fKmd6fv3CBBBWhDJg56R2rggYLCihFVbAFNABlIdBDvrvtfqt7GrDniD9X2mF0+IrZHGZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tn+R7lYy6ZjU0H6eZiFtx5LQYH79IO/7HTDEdlPRtl4=;
 b=QvuuyQdPi3FDywmq5IhKJRwJbwo5puMrMbVRcjdTM6UKs+6OlCibJOIU8v0Xcz5U7eyjblyQGy2G8pXgxlnkwql/6xRoNJNDPs0FjtOeVtks7VZbgVS1LJffG6hwFqzKfCxr+D0LPcQSA5bF3v9ktS1ZTCB2ePahDu282ofallz3O/1s1fGoHxT/idVh90buwIW7S2d/w1M1q7TvvST6xcPFdWyrz54dnkJsLdWwj5uCUp/Lm6krbMKYHME6zmKFJKOxZffmR7zoPYphcyrmKyUC3J07zg/7XOD6XMV7obKKySCQTeOT/UmN3MDiUWKgQnt7m8lGGpt+K2sRrDnNRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tn+R7lYy6ZjU0H6eZiFtx5LQYH79IO/7HTDEdlPRtl4=;
 b=oKb3IEgt4gv2eavITl5rHa1QzkA7l31D8PuBklWNH9kx/qC8R7CGv21v0vDkxw7Tngpuktd75lXoQtTo6+s8GZuMNdWTPLUIFjWVdEz0+9BImP5mWeKa6r5/zVLAEMKe33mK9vvM0kaIgrblNc4h5/vUOhg5zvY67w1vSVns35a94zk30inbxBInrAMYdWqgzcofVVL+4jZRbASuK5P5R+2txIDXuNghRvey4iyQ44heaiYgrQvJ03H6xlgxkZGtDo9lHbhdJTwFOu1JyvgwQsE6nfD5T8OgVAgBatk+ofyn8YOdpTPacxmoyiGMdc0QAGMRRRx5ZK5GMfuPf+9m6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB6654.namprd12.prod.outlook.com (2603:10b6:8:d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 22:04:28 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 22:04:28 +0000
Date: Fri, 27 Feb 2026 18:04:27 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Mastro <amastro@fb.com>
Cc: Matt Evans <mattev@meta.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Mahmoud Adam <mngyadam@amazon.de>,
	David Matlack <dmatlack@google.com>,
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] vfio/pci: Support mmap() of a DMABUF
Message-ID: <20260227220427.GM5933@nvidia.com>
References: <20260226202211.929005-1-mattev@meta.com>
 <20260226202211.929005-4-mattev@meta.com>
 <90bd4185-1e87-4393-b9e1-1318a656a7d9@amd.com>
 <20260227125109.GH5933@nvidia.com>
 <c5a8f318-20af-4d80-a279-2393192108c3@meta.com>
 <20260227194807.GL5933@nvidia.com>
 <aaISD4mw1XzQl1S8@devgpu015.cco6.facebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaISD4mw1XzQl1S8@devgpu015.cco6.facebook.com>
X-ClientProxiedBy: BL1PR13CA0287.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: c40c9cae-b326-43a8-64f8-08de764c2d4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	xDXQbgpoLbH8oWyN9bbildDSV/HnaSJa6TRipngZBHmk2B+EdynokXJ2FcG6MSqyy8TYdVaqI0ntKw7jWTb2rLWG0ZZHMC9s4+hVokQXo4IFSo5b03jkFTx/mfNB/jA6HTfqwbNiuTyRm/pSeLRT7mxXOSGiIwk5sP/0NVS6Qya+eRIgpPB2Fo9pJJ4FQzveywNbUZ9AVMMK8iHrrDMQKFTCGCYqe7M1ybU0vmKAjXHWx+j6lJgvlJXzcr/PLeaN8gjL2r+jMZtpDNkTVh6HidbdmDuQbypCyoHMMBeiXqDHPg/aF/YcmdNCQbeX/lUH6S4RqpipOnVNGmo2Gdn4sRz6Bnlu/X4EzgUEcg90Vgyn5sebqp9QywRqt7unxyiQdetkuX5LKw7NwQoqIvGhXatDuY9o0KN+CXqeVq/UIMZ0nxK6RX70uRbsJn5PGxS7y/zcXWOszUFSlSDUMLYDExtj7/AUljSfkd2KuqDdct37fYzti9RcFJ8BmRz8kNW/VU3zJ3SkyoHofJp699bRBn/gKQhH+L+QcwzTZH64f+unSP2m9zlEae5bWk37o0k25xmgAraTTE3oRTQTYCWj8nJ8mc+1tDmJh5dSdZy7QNb9L50Y4Jzeaq/u9iWONz/UaC0q3VaaAtVzraj09xpJ8v/Z+suNjpfb0okwtMu0WS5eXg6RDAFBOqjq+8qaJAazQNIx11/653AwfBwHavg0dwXVK0Vlz/aJVymskckCB00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/U2ACUaOMh/nsuFmNKVaYdkscFJ3H2uZEEnmtjkFdzuuLRN+nD9Osf+DTzJO?=
 =?us-ascii?Q?gf4pu3Ki6bTi8kC1Bzrde2pepwW/nuIrmuhO4IcKqAW9WHfDC2xLBgUCegTS?=
 =?us-ascii?Q?KFWV8OrOqaixAH3qNlhvJx4vEeYCk2WSkcD1k++YC1klHkfyiLypsZ16b7kP?=
 =?us-ascii?Q?W5xxxdwPbLAazQ/r7WrFrrUJTXyBGRfUBQQxcNcRvi3nGQUKsN6S+MqeKGi8?=
 =?us-ascii?Q?yATRhHR10VoqW1dsIfiUxSx4eNg7BZUYyKo7vac5wr3bCEDecawPg24Am0bX?=
 =?us-ascii?Q?pD6rGfmjvkFw0MnosSgZOFMGtzeQAavaZw4xAg7fEsDzXAGaagkGDgYv2kRZ?=
 =?us-ascii?Q?DiNzC8FFGfA5PWtuc8bgh0nvNkV1q3Lnxx3XjT6WqpQo9l5dFTRbSmE6/baq?=
 =?us-ascii?Q?1a8MPipNqyjyH2SuOPd5FoC0hSRl5Sm1GRw0TuTkJ01Go6nDHSR8SnVfC7zo?=
 =?us-ascii?Q?yn3SXsCKCabU7TgehCvxOgMe2tspwGuPrz0crCZZPzjJvmYp59+zI2I0zZ2A?=
 =?us-ascii?Q?UniSut3MN1PJubJXtyaCL9hhVHzAWvPSRXwmmpn2/EaNfMvUh6mMRHEX64qC?=
 =?us-ascii?Q?NcEzFMhzuRhz3XsG+bjbzzG2FcJUtEGynkkjkS5GwwE1qBuWpQPSBjV2bNUW?=
 =?us-ascii?Q?A0zCKc6z3loNHZXsRaJQZvf77/ns8RtDz16M3chcpl+7CO8WbnPjhzxQE/td?=
 =?us-ascii?Q?7O1U8Ut+V4uhAN3pefaugo2PplKHvDPrC1TFIUlIhH2mzwtzlB4gp9IBNDx5?=
 =?us-ascii?Q?6YOM+uQtOGshz2zipR6ejhW0HSniWw6SMjU+M1Kyn95YPROjlOfZgeUwZeso?=
 =?us-ascii?Q?1ZC/n3Bo9PMjSjPqoiyb0lirDQ1LVyu2MRYCi2I8cSjT/ISs3Rj9ckpIWEmz?=
 =?us-ascii?Q?Ot/3rKie0iEkmSS0XZYM4mwhH/DuUfmCRFFXqpaQiYhoNjDSvoaNHrmIZHJc?=
 =?us-ascii?Q?toDo+ZRMHs+hqsqG2ps12EexJ4oORqbZ3iFbz+42ABQrmvrv0sYxWegth9Vq?=
 =?us-ascii?Q?JhJ/p7slF68wnR6ejbhYHug5MZ0Y64RhCs1Wbi3/XX3zwuHezNdXVtEzfurN?=
 =?us-ascii?Q?feHngX+f0Y1ruMuwQcKgcjK1KDq6ancvF/OMp90ybxaH19gU0rtpuhMNAPf8?=
 =?us-ascii?Q?KUJsW7DbmN3zKpWd59BV6+9V00el25BGhvMYtWbC4IWIFh8nwnFe+O2BgwVp?=
 =?us-ascii?Q?T7oA4pMlVvRsyavSoS78/9Unb91Yx4mEJ6Y+6/sqpQ5Iv0Po9RKw4TwgKXcH?=
 =?us-ascii?Q?axM9ajnZRWQnamlwyPtauEcSsaJG645aTSJAOTfqjBZ9RwKakwEapMB96rnh?=
 =?us-ascii?Q?HkMY0SitCDXVCq/JdPsWsVwlsJxfXLE/FPdP5iTn/gsmEzyyDg84ULAXW9e6?=
 =?us-ascii?Q?bfoTFX4tb+KFGbyUJal+lZBx4dASVyuKAdjvfm6f9FPGxRUYjGlYIGxEEPf2?=
 =?us-ascii?Q?uZX2zT9w2lxVelbIGUvlPJbqp/9x3eCnr/rwBnN5WNm+0E47DLlK5uYyska2?=
 =?us-ascii?Q?BnEYuK4m5B0/ZEBoxCE7BeM1bg+K4nsskbg8l5WxTOCDO7bAl0Dy21nMlfZQ?=
 =?us-ascii?Q?pYMKiBDrXydlfm5qL9ahIh9NyDKnj21MIe1UwBNhe66wCr7g2y+lMplvHcMv?=
 =?us-ascii?Q?9Jvw1bDQH3RCSaqjFJTtC34hT7PJiYHllLwsAYvOgUrboTWNjj/a25hZ5kqQ?=
 =?us-ascii?Q?2g6JhaLORKVn7cSnxFTqOU+3btyMnJKnHd1FPSVOEa5WfeLggW6eZv/HTH5u?=
 =?us-ascii?Q?KCWzUgCsfw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40c9cae-b326-43a8-64f8-08de764c2d4a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 22:04:28.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzZLenXnMcipM0rt06bUc98paZj/OJii8lKDxy6XTg+EWQ2xlY41tY1ZR7F7e4Hq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6654
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72234-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim,nvidia.com:mid]
X-Rspamd-Queue-Id: 9FBBA1BE776
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 01:52:15PM -0800, Alex Mastro wrote:
> On Fri, Feb 27, 2026 at 03:48:07PM -0400, Jason Gunthorpe wrote:
> > > > I actually would like to go the other way and have VFIO always have a
> > > > DMABUF under the VMA's it mmaps because that will make it easy to
> > > > finish the type1 emulation which requires finding dmabufs for the
> > > > VMAs.
> > 
> > This is a still better idea since it avoid duplicating the VMA flow
> > into two parts..
> 
> I suppose this would also compose with your idea to use dma-buf for
> iommufd_compat support of VFIO_IOMMU_MAP_DMA of vfio device fd-backed mmap()s
> [1]? Instead of needing to materialize a new dma-buf, you could use the existing
> backing one?

Yeah, that too

I think it is a fairly easy progression:

1) mmap_prepare() allocates a new dmabuf file * and sticks it in
   desc->vm_file. Rework so all the vma_ops are using vm_file that is
   a dmabuf. The allocated dmabuf has a singleton range
2) Teach the fault handlers to support full range semantics
3) Use dmabuf revoke variables/etc in the mmap fault handlers
4) Move the address space from the vfio to the dmabuf
5) Allow mmaping the dmabuf fd directly which is now only a couple lines

I forget how all the different mmap implementations in vfio interact
though - but I think the above is good for vfio-pci

Jason

