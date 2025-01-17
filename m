Return-Path: <kvm+bounces-35783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CC9A1511A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1DA73AA10F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 14:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FC41FF601;
	Fri, 17 Jan 2025 14:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UBsF8TPr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EBCD530;
	Fri, 17 Jan 2025 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737122457; cv=fail; b=QrwtJWvb1khQu3dCOaoU94v74YNK7CYmIMCu70oqgjr/MQiRDkMxsCGXmX9mIB+AILiLyykHL+/MwEB5Y0809dbztmz4pBjEM/fTbJTOzl83aqx6x0MDm6sqkOAMPJdlkJCu15asggXhtdO37iPCiBIhTmXsN92yeLasxo9cCxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737122457; c=relaxed/simple;
	bh=T38IK8xSDMQanxMTFzcI3BKO9wY3CMt+0YCVQYBgreM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tWGByTHEAemJubccWFNolPqnuYG/H2GmLtjuDq3RTLcRkpO+CP2xAPU2Ubi4l9f3uVwadix1CwWDKboSQA4M2sOetrqLRKhrPUC5l8HoYs9uJFzWifSZ5Xh9SZ+VSMVDyYD/lPJInI6EwZqVCgWi0uq2nL+i0gCb0FDS8KlZxM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UBsF8TPr; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4eRhOvhk0h52buDjCvL0gTcXi6EdAgA5+nub2whZq1/j7qABUTnSGfW0kDchPtPtbiUE545QhCTTgAR+8fEB0sGpGTokI9tXmrKQXDMido/L5lW6Vqz3IXEZPq7qoFJEJaeLDZ1+N/rMuq7yUZKJ6BAyX0STFOU7JjKJEBWrv9xucrYPj4QP40ieARA7JtldkWsUyBqGRKNFqeKD28dpThB8vJ1Zv1ARHL/cZU2yUvJy2BfaM1CUWJ8HEPBvp1H4guDlor0lcXZioSQVlZBX9YiLN9LFege1XxYS3RXhcrGnLpaNGvYu0HYgGVX8V56XxKu5gIFu02fDChPADVr3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpOSIhRVZ87Q/TNV6Hbw2Br500R0LtxYlQTdNITClds=;
 b=ycNkMpl0PYtsKqfNKxzswtde7UBMxHXnG1Koxi65CIQk2Lx3zKz4W3j6wzEz1120vp7LqnXs0DBE9CuEk6C0eMZJ70T3UWlYfFmKnPVX6VADaDYvGYBTHv+dgSxPJNPthgkG9aefs1RuKbubPixrIecXvNa7znymyKtw5IKB59uIOpQbClLfasvtWYel3t+EFq8e07iYFFQ7Rbh3MCFeLlKwGHKgNoMrwz4AbI8va3YUQ52en4wOs3GbVdoZ1byjmKEm9d7J9IDhP4HRdgKrOZyqpLBkblXpRt/uxO+qs7RB5ypiqM+bOr+K+H37BJx5O/kM6+mnEzOk9sbPH0fKqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpOSIhRVZ87Q/TNV6Hbw2Br500R0LtxYlQTdNITClds=;
 b=UBsF8TPrZU4RyZQWjIBo9GNi2Gnc6R6EkZKQj4eSSmx3TkS06aUPmT4Sk2qIGwF9g/b1e8P7Is2CmBFhwmepsshuX6SaBCyyGkRnj63hg9rYDGRJdqQSPe/x+ZbN9UT8e6HfMN800INiYiLkg2awqFwacF/+gK5XwVs6oAgms1+ivNE6cLGj9n5QWyviCbvEGjTgYdN1hCl6vpfwFUEwAzYTW92JXZPPJbeSOnj4jyCvlNHZOSigZ13tDrNf/i4rZO/hj8RVi0/S6Ofeyw0kOptNscDgbhVI2qJaNl1ODAYSDmrRAgikUer4G/tygPTpyyhIHFWXZI4k+S2OK98QXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9110.namprd12.prod.outlook.com (2603:10b6:408:18b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Fri, 17 Jan
 2025 14:00:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 14:00:52 +0000
Date: Fri, 17 Jan 2025 10:00:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, David Hildenbrand <david@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250117140050.GC5556@nvidia.com>
References: <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
 <20250114133145.GA5556@nvidia.com>
 <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250115143213.GQ5556@nvidia.com>
 <Z4mIIA5UuFcHNUwL@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4mIIA5UuFcHNUwL@arm.com>
X-ClientProxiedBy: MN2PR15CA0047.namprd15.prod.outlook.com
 (2603:10b6:208:237::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9110:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b68104-35c8-45b9-9c01-08dd36ff5a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pT8lspFztMkx1UyM6r52SQp0+G8mdmIvXvofEeXJ1Tf0RU4qV8Mext1Xghzf?=
 =?us-ascii?Q?lXfUwCRx8w2dzdRzoc7HPrxVv5JnnYFBgvWXnuw3S2gZXs4DcxlVlt2xCnxY?=
 =?us-ascii?Q?dgKPDY2r4z/AOXP3hAKT7X1Y5s4ssui/bfMbEw3sw5jToARa7AHs+gIzaDat?=
 =?us-ascii?Q?vuI4wkOFzaeq1hVFC4W7MK5goUhIKROWYhhbZcbjJK4mnCOV52I54l4NgwfI?=
 =?us-ascii?Q?+xL39P4fm6QVy/T2PCpfa7rXcxtPwoBPjyr4HvQlnIT+qBUe/fOmAHrkJkxL?=
 =?us-ascii?Q?dfmSrd7qm4WmIm+4XRo3gJ5/YWeOdCrHiVHv8SbwSQsIxinke15ru/3pUAuz?=
 =?us-ascii?Q?eo1wJKIPv8RQfNqIelf91tfi9KkFzS5ZrVCIK9KLbN93ZFHaAkkezCZoTM9s?=
 =?us-ascii?Q?8B7zvvHupNlhjB89fzYRC5uutxhkMGUtBQ8BbOPSN8ODOMyOPAc5T3tWw4QF?=
 =?us-ascii?Q?923xec/nMgKBh/1qPAZYZJrsMnrJ3v0xJfJLpDAt7Dy6LJf3EPg6j3v9yRFu?=
 =?us-ascii?Q?YKga9+xsNwfJTT9Y7I2Iy+yOl9Joolr0H9B+aBnrSm3mPruksukpA8VVPic1?=
 =?us-ascii?Q?iUbQhTsxPITDrQqTf5WKIhIjiuDW4UgDQyRTMISI83i1gKmYBJYiI/ZEGtIL?=
 =?us-ascii?Q?CWvA9vaMgxN13q1tsWCGaUdlUOYes2N8NWYaC9p8dZlSahUYrtCp9gMhM8AT?=
 =?us-ascii?Q?giV6QuAfquDyZCtc8JlKGMdHfsL3gVRVP+EBlD3kQo8q9QL7z5H02ln0t64W?=
 =?us-ascii?Q?pSIcG8CJWb6nQKFjHo/TTU4MMSRmrb+SKhF3H5nK6PCxV7EbmKZuusl3SfPQ?=
 =?us-ascii?Q?5gxiCgI7BxQY6+v0zM+Krc2d/xo5Xn/Qnl2n4DhLBgUBS/R21LWK6haw/1zj?=
 =?us-ascii?Q?AgfbjR5IDo5aHmt6TVeWRYrCgifeKmdK9GxRAPQnmxb+g/3NeZ5IA3DtHIxu?=
 =?us-ascii?Q?UtjkHQyeNs/QCxDu6yCrNrpX8lz7WSDpdyeSjWTmEitUkiG3PHlt6Pyg6R/i?=
 =?us-ascii?Q?kiPZhHaJD73aTyise93UUuRW3WwjbA5U211eRfMv0U8JNUsODLr/ygWqRzFW?=
 =?us-ascii?Q?PLrlQ+iVQdx5qGwApAy2q1VBQoX5tmEWryl3onGgycsjb7c+JcOE7AqimZ/w?=
 =?us-ascii?Q?DNPyTEygXAEtP0bi1x9mDlEhnDfBsXj1tluFi+1Pkgr/A7hS3FQGfRZ7AQ2h?=
 =?us-ascii?Q?2aMdMLjSawkQE09MbCRItDoaoTKvyY8dDctfbgvNhLoXmLBgbgrSxA1mexgv?=
 =?us-ascii?Q?iF6/E0BRIHZruesaPDZvsJe1+484nlkewqiJdc4eE0DCbt+lWlUR3dzlp1+y?=
 =?us-ascii?Q?964UD0geClul5xIXOlTmXGGyP8Z5/46RxrtFzD82CZV+KiSWB/o0MXHXALkL?=
 =?us-ascii?Q?NWOvuIvT1mVfzFabyEVULMvY7p36?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f79iYav8f5oe5kfkCoFpnU6AyWaAjgIGQN64JI02qGwjbH3wvJTM+kh51Mux?=
 =?us-ascii?Q?3CPBesmc3FxhimIVU0LChXdJMTuQKLp5RQewX+qayiFDqT0mu86H2HFnQf4w?=
 =?us-ascii?Q?uKmb47AE4ixiYKHHrt922Rva7s/5EQRm/U2ZemDKiDGgUZhvCieKdV7BGWwU?=
 =?us-ascii?Q?WJHZ4gIiETthtCsF3c8wEyZaqDPXO6Ev1c32yve+44tCBzZQYph1yVdZSJt5?=
 =?us-ascii?Q?t8rMZ7b7HhHVQfdSKVNJ1F8GayHiAKGVQoILXMi0DZ3OolaDpAsBsEiOuuIS?=
 =?us-ascii?Q?ZAIpSO/APtY8xr+LIMGYXz/0yCnZy5hD9KBV5dA9UPzvs7H/V2gzGZaCvipi?=
 =?us-ascii?Q?c448T5N+hYBD2gZJO//YzhjfRNn+46nYUuUSHbi+ll1mrhftUC/bhvvXA0RU?=
 =?us-ascii?Q?S3k8KUqEijtrzntBk5ux4KhnZhmRaOStwpHu8bT79O++gBuANlTWG0vmQ16X?=
 =?us-ascii?Q?witgWd/nLr4/9tj0UXsxS8UlqnHl1BzWCh2MmBg+SrK5IVPu8yU9tq8nuNwL?=
 =?us-ascii?Q?DZN2AhydmEjv9UDjapIOyMAmYzY8UcaAWDXGl6hUHPm1Q5JIVPjdDEm+MiXv?=
 =?us-ascii?Q?o49DP+Dq3gZyJSIomLVTqawnto+CG/y42S0PH++wGBZJJbvdh20BMC2ueSIB?=
 =?us-ascii?Q?6tsHTBkA9FbO/BLT8F9b4APb1xACk/uenYTQS/Ye41ojRRmRBzWTlRl+V4eZ?=
 =?us-ascii?Q?o9neqErrg72eYvCOXAR9d3D3f72Dt7fxb/61vDMx+p+AvwhUTzlcipJqdl7Y?=
 =?us-ascii?Q?OLLcb692Cw/du19cBIbYP5/gOcQxFKXrNaANlUyGByW1DAVuh+zZBVjL6zYv?=
 =?us-ascii?Q?hPxFBrHtj7mjzUdvj+ryVufB3D+PQwnjBXiGAmd7OTaRGN0pTYg0vemOueRg?=
 =?us-ascii?Q?hjNa2ekrkpia71p+eEjG1FrXyVUSezTK4ZAj9n6U/jlGS4I0f8gYkEqBh+oT?=
 =?us-ascii?Q?CImf+YImjx/XwuzIuE17TSTXzs2FbbVPrgYS/SKZcQQ7sW8BOtms2ZO2Wj4X?=
 =?us-ascii?Q?lTS+J2EnzE9DdRRYyiConVqX433carlKLq+T8lXQUR1bnaUMMmxnCTbuSuDm?=
 =?us-ascii?Q?J88EBaa/7WBxRYnleHjaAF40i0jJzQjLrtNZz51eoAdQKXSat08DCdPitdro?=
 =?us-ascii?Q?ARgc52BO/hzAiMoEcQxoTEY7yNMp5zCRQ2R1vnKwoPE9suioX+UUDXb+dszB?=
 =?us-ascii?Q?r2ghdBfsx9A8G9gzAuwgKlKVrx5JgHddE1Mo592L8C5r/kJMugnkR6vcLvUb?=
 =?us-ascii?Q?YCcUhA252Cf7+GgFDnaiDVKkwv7ZDVBdBGXYJP0hgoJ4kujUEgtl69t5c6Nr?=
 =?us-ascii?Q?XPAwSsm+UWbUBK2cHYpO6Cwmw2bgu/vHvKrWLZarjWBfn7N1kPf8MbjxkXsU?=
 =?us-ascii?Q?wcMiSGlLpd9oNy9mzt7GryFksYd9wT4BDAv0M7DKI4uNiBPn706OL/S5aJgG?=
 =?us-ascii?Q?+NUgYiQh1uTMfEUp1tf0Tkm/melZOksP0UVT53Whb7BM77JxnVXoVzXK2UFU?=
 =?us-ascii?Q?gPTFPO7lZrdGUTyB6BUwgNUbyMcO7zupCJgwwXLOAyk57abuAQW/pGPNoXMr?=
 =?us-ascii?Q?CU5VRijGTSN1wCJqJXHmlOOv4bAzNwzYdIfjlDoe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b68104-35c8-45b9-9c01-08dd36ff5a6b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 14:00:52.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRCTAY8r5aE1A+HkofBsduWzJ8yhRSihpWjpb/gM5oLoqcrdksVFOXH1hO/w4RHS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9110

On Thu, Jan 16, 2025 at 10:28:48PM +0000, Catalin Marinas wrote:

> Basically I don't care whether MTE is supported on such vma, I doubt
> you'd want to enable MTE anyway. But the way MTE was designed in the Arm
> architecture, prior to FEAT_MTE_PERM, it allows a guest to enable MTE at
> Stage 1 when Stage 2 is Normal WB Cacheable. We have no idea what enable
> MTE at Stage 1 means if the memory range doesn't support it.

I'm reading Aneesh's cover letter (Add support for NoTagAccess memory
attribute) and it seems like we already have exactly the behavior we
want. If MTE is enabled in the KVM then memory types, like from VFIO,
are not permitted - this looks like it happens during memslot
creation, not in the fault handler.

So I think at this point Ankit's series should rely on that. We never
have a fault on a PFNMAP VMA in a MTE enabled KVM in the first place
because you can't even create a memslot.

After Aneesh's series it would make the memory NoTagAccess (though I
don't understand from the cover letter how this works for MMIO) amd
faults will be fully contained.

> with FEAT_MTE_PERM (patches from Aneesh on the list). Or, a bigger
> happen, disable MTE in guests (well, not that big, not many platforms
> supporting MTE, especially in the enterprise space).

As above, it seems we already effectively disable MTE in guests to use
VFIO.

> A second problem, similar to relaxing to Normal NC we merged last year,
> we can't tell what allowing Stage 2 cacheable means (SError etc).

That was a very different argument. On that series KVM was upgrading a
VM with pgprot noncached to Normal NC, that upgrade was what triggered
the discussions about SError.

For this case the VMA is already pgprot cache. KVM is not changing
anything. The KVM S2 will have the same Normal NC memory type as the
VMA has in the S1.  Thus KVM has no additional responsibility for
safety here.

If using Normal Cachable on this memory is unsafe then VFIO must not
create such a VMA in the first place.

Today the vfio-grace driver is the only place that creates cachable
VMAs in VFIO and it is doing so with platform specific knowledge that
this memory is fully cachable safe.

> information. Checking vm_page_prot instead of a VM_* flag may work if
> it's mapped in user space but this might not always be the case. 

For this series it is only about mapping VMAs. Some future FD based
mapping for CC is going to also need similar metadata.. I have another
thread about that :)

> I don't see how VM_PFNMAP alone can tell us anything about the
> access properties supported by a device address range. Either way,
> it's the driver setting vm_page_prot or some VM_* flag. KVM has no
> clue, it's just a memory slot.

I think David's point about VM_PFNMAP was to avoid some of the
pfn_valid() logic. If we get VM_PFNMAP we just assume it is non-struct
page and follow the VMA's pgprot.

> A third aspect, more of a simplification when reasoning about this, was
> to use FWB at Stage 2 to force cacheability and not care about cache
> maintenance, especially when such range might be mapped both in user
> space and in the guest.

Yes, I thought we needed this anyhow as KVM can't cache invalidate
non-struct page memory..

Jason

