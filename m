Return-Path: <kvm+bounces-58544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE168B9673E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34B01164551
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9913246BC6;
	Tue, 23 Sep 2025 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MBWtCqyH"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677941DF994;
	Tue, 23 Sep 2025 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639177; cv=fail; b=nI3Zk9r8dyVD6/7o9XiJ9LlqPNpeMfKAXqs7ezF91WAWOYMz0Q3jXRVLyIvcQgiM3tE45VPoVahv88jSsJluxOdNWe9HtZqDY3xlRTL3GXytwVbjlLU9a58RYWnKEL1LUUxQv/33d2dBkyQEOG2kUdFQaf4SWZKq/XgUhztD9Ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639177; c=relaxed/simple;
	bh=dVSbWC5zGgIq1D3j2h5S3+F+rcjctVx/vIpPJThBJjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rqGBYnW4Js4jPQ5HKeDrlyDcf1ZVyeMQnpTDRVG8BkG6qOx9fzuYIG4Sx8Cioh9Q8Co+KcnrjgGgwOej3TMEQ536J2DoHL4GtBvv0EonCjRk8cQFepw6RanRT4j7jk05F1k0jZPZE50v9Fzgftw+JlnVnSkvPTrp3jVPzYhhRJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MBWtCqyH; arc=fail smtp.client-ip=52.101.48.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+P0YcKnCMkHE0zz7MxcMP1EKeXGfY9GtRvIU8XnmeoXytucqVKugXi4Kjeg7yocAe+FY3JG9qAwXDDkukrY9K6dmIvebRq/hqABk1OshAP5LlKVgoQuTbFrUystOPLnxM0tajpQh8gOpNRdIULsh+bHo8TdEoE08pNDwroifsKFILAHiuVCwLdTaZG1Xh7JdJlryfaT2GEtrjVFADxoCEHyR483fVdKwipAcPKNJnsLs0THwQh9qYsWhnK63TVzQFIMqDPvLpLe1LRsEyn3/yFJvJBzzHGHH0fzSf45wjRcHjhgBufMfFxUZIzHVw8YXw5ZCaBdMdBv5BVxy4ChWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4tMvp1U6TKNNPa65VgapzPpbYOIxAws0E7Yrw7W08s=;
 b=jQ08odjMDkLhSgB+xusdj8lRfe+LSCSYDREYEVfWm0kLHToanooERkUeB5BMaQL3+69diopsJtS/WgFN3jnKyl9w9DADzoQECHhXSPpybhGmH5Gm/Wa+BzcoLZCQel4syv84pP5DSUalARMkQHmzdsVnGzxAbiPP0uLBfLqcX42HiBrZdBGZjfukXuvHX8vkGtQed6BoR0vsk9c2V6KtHWhR9Wm47I0gKeqBEJ2c/NI1r9VH6Zp9WRS12grjGIIYcWr79AhK5BUQG8npkbdj8kTyTuD0iOsWbn4ljaSywEEvE6WCMzurKdMFpX1RQrxcy8TtYSIuNbSBJlQORNOxQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4tMvp1U6TKNNPa65VgapzPpbYOIxAws0E7Yrw7W08s=;
 b=MBWtCqyHvBLyTK3uXkHSyUApaPTm/iNtwDNbYjKU7s1VOATOIZgRjt2yCupWBC1auUCe7+mAL5HstyANENT3J3WNXnO7XB2fJxOl/790Q8Z2YCljD3T4d9IGASHOpQkbQ6Uwm5Tn/WX//7xGg5uXYFAciNOg+gRGuDxechgVLeppME8DOOdhnu8S8s23nunpbi3v6rnO7g4cmd5nHrpLVYQTnODgqfz0zMGB5VhqfV4eNjml1thyZwCCXnBRKENrefJL7nTdCfYWs2jREJ+qPRT376FtebB2qZW/zjPgVnvDY9rB4ReOJWMqXfYSfiMrmJeVyvT6ASSUxHoHiiiafA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SN7PR12MB8169.namprd12.prod.outlook.com (2603:10b6:806:32f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 14:52:54 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 14:52:53 +0000
Date: Tue, 23 Sep 2025 11:52:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
	atish.patra@linux.dev, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250923145251.GP1391379@nvidia.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
 <87ecrx4guz.ffs@tglx>
 <20250923-de370be816db3ec12b3ae5d4@orel>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923-de370be816db3ec12b3ae5d4@orel>
X-ClientProxiedBy: SJ0PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:334::18) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SN7PR12MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: ebedd93e-4671-4809-f035-08ddfab0e00f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iIHZ/YPTFkVpTAFzsinVviVglnl4MclsmsGp82KYXH/R5h7fLJZhzqbg9LXw?=
 =?us-ascii?Q?rD7L10VOnkXu5h3t5aIurByHlccSKV8+vLlUahGW2EwVk0ShcSSQ97DSWCyX?=
 =?us-ascii?Q?jrqwNp+1mz81V8x+O+J4xui6AB1ECSHKGSKuDbYAA1ezgL9LfuIjOXOHwWav?=
 =?us-ascii?Q?ogq96ObgLhSFBrcLdH8tLKpnM9lnqumbARxYPeQWpHfj68AAUhQ3mnEcUiCQ?=
 =?us-ascii?Q?Fc0hDDao+XJ95yWdJEt9n4rIjVKpht0Tsg/H4wP8P9YHelQ+UAxlLu90kTR6?=
 =?us-ascii?Q?66zgOXx/5tQehn+9pU4pdg8ULqvtjCiOKujnXejlfHSWtqpPq/nZTtZWRwDZ?=
 =?us-ascii?Q?G7wKp7wf6ouuu9cVYrv9FQhktvJitwzipJ+Ak7lxxDj+ee3vrqTgZiqMUQKe?=
 =?us-ascii?Q?RdFojMre3v293ej5DMB+kD2Coq4thFQvjc6VJDUwdkJmuigX3tujtd+//AQc?=
 =?us-ascii?Q?+6hXOmW2JiG3RAyHTTwdljElKVwoaJfVd54upzsTAgIOxTHL3kNmBsHZ45ec?=
 =?us-ascii?Q?Co8QEHjELGSM6hZ9yAXOQQFktG1YUWu6LakEc1Veq+B9C1vM12yyqcTAl597?=
 =?us-ascii?Q?9oETNbQFDAXKmLU/tNDdeiOIjbLMXZ0VI3OFmdfLSWQ3JtQLSb7rrx/6pZyZ?=
 =?us-ascii?Q?rkHXpYHEDx89DV2fnTbfOaBEZXBAzA6wSx2sCFw+rw7M9SGDCfdD9dSSaJQc?=
 =?us-ascii?Q?4kJ4ywK57CUT0bt0/bDe+mZ4bKQp3Xb75T7LqRBbgLNIMmg5oZeNGFxsYnqR?=
 =?us-ascii?Q?preBgwM+DDMUD9lm5yRXq8ofCyrzmQ+lgm5XAMWtAuWAF1g/LW9qqUsRunCR?=
 =?us-ascii?Q?klO7qDL1cpeDxF6QFXaGQmvA20Og2LmuoGkeSpcpFwNrHYMWRFBG3q9N42/G?=
 =?us-ascii?Q?D93zo9oZfGkQFUmLwckpmOV9jUBWzQL1zuBDKmFd4oY/jN875JZICqeNfWZ+?=
 =?us-ascii?Q?/ZNW/U/3/bTC0ut+lJtttAiai7ics/bxcGgVP5CICdQxa0khPQXHzNWbKySv?=
 =?us-ascii?Q?GBKzI2YPsoqU6D+wm3gKW+orqWSzJKlJpdSyPIfPQqYYPfKOadPG7VqQIadu?=
 =?us-ascii?Q?3Kx0lWCuXAPSjCjcwZVMusCy43jQuWpHDcDQJ0IKDkutfWAjnvlbQHEubnkO?=
 =?us-ascii?Q?8K4ieA3S3NxA9jrLDAhCNw6HQLVEBz2vPjJhBzfvTc4knTHymR8Q1NPNooHC?=
 =?us-ascii?Q?MAvywnuMRicap/kwQJ8eq8YyZsnju90zSrX+lhjN+jmy0NxnwMawO4kHGgmz?=
 =?us-ascii?Q?KYlEWtc19tGg9VMqBMLvL9gtTwnhuQ5CZJ3ihLRKS20CeBTV942rneFBSu43?=
 =?us-ascii?Q?p2S1B7pnNUjbSqumdvzwm363jLkB5HjgDh0Isy8wEBq4PCCoEViu9ptjnuu9?=
 =?us-ascii?Q?gAKloRd5sm3R6CtVRMr3b4N05UGxqg5r/RXdBj3cE2FGBvduoD4nURmVJXNf?=
 =?us-ascii?Q?KZav8V9X6bA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rj2g0oMIfbIMLUSmdswAH4d+lV9Yxoy3u33B7OhUOYg6z+jjlSnQMxkd32k2?=
 =?us-ascii?Q?l6SOodSCfhlhjTVb3nUSKu9yQYC5+xpfQiXDyh8LK07sQudbXWZE1qVA1zg4?=
 =?us-ascii?Q?X52kDmmUAQvAUeBdSajmBJVdZ7seCHO2EhLYLjref4pQ5n1FGYf4dfejfoJi?=
 =?us-ascii?Q?PUZ3mrENxgDDF3utcg3XjxlOxOSJZ5aIR1xsolwke+8fwJIWYvrxIRiSSOIs?=
 =?us-ascii?Q?4ThQY28fkrNTPPWJsCnyFPe+PqSZym7vwAa+Hq3eCU1SmtQUlAJlyNOcjMUS?=
 =?us-ascii?Q?nUq3iRoSyeQIz3DzmENnbNESB/OQTMEDfiRSBxy+Ha4fn8HqTe2HpGeuFBQW?=
 =?us-ascii?Q?4eBlEAFkyDmIt+t/HQGtCmTyib/yZ65uDku2hk8Nxzj6DWb3SwJYiepTYHIt?=
 =?us-ascii?Q?DpUmaoS3nKE9E/5J8B6XZ5Ct4hdNfqqDPxjlaitcJO/jZOwOV6I/iW1Cr4wk?=
 =?us-ascii?Q?fvxVuBfR1FDwv9NHdq89raDe5CJL8mU3FjmWU4XI3yzUEGgAEkyzLTA7QSEc?=
 =?us-ascii?Q?0v6RmavRAZ2DzCJt5tpj9Ppe/FfgTLUhMNc4yAg4mXh1DvY5vHBv/mKCm7Sk?=
 =?us-ascii?Q?iU35p72dNO+nNlzq3lPLTSorIuo2dxTg7CiZvmDY3+8vNmPmt+5/ymkP83l0?=
 =?us-ascii?Q?N7dGQ1V28NMcKqDRuyZkBrk1y7NBWEnjIN9d+CBvD/hOXi2psW4DJ+Xt12Y1?=
 =?us-ascii?Q?kyiOT4cXgjyNT8Rh2utr1eBFnO9OXLd0qt2aBsNiP0pwQ9ax9C9FOr5+1STW?=
 =?us-ascii?Q?Afzh64C2zxFux1ny2Nz4gUlgSU6FoJTTCh94hGwvIKyLq9mO37pRnp6dlOwQ?=
 =?us-ascii?Q?nc1CeGmIuQZWLDRE1zIijSRPhaU9sFuSUONh3THLT6UVcE/F5IoK+L76pxjc?=
 =?us-ascii?Q?Qz61Fd0TnTP5pAvayf1MZJz2gKiCUO8ez+kshf6oWvHJ83pWJEbZynQckNNj?=
 =?us-ascii?Q?6bSK9poXq1B886L7LmnJPTD9UvQahpcZEuZvtnxY8H+bKi7vKb5aICmpi4x0?=
 =?us-ascii?Q?ZPBLotgG4yxEKAy5Cs/ZE+jf8n28aG3MbNzCyUgR6rQE05dyWtueP0SVilit?=
 =?us-ascii?Q?PCAdiPVUZcapPCNqOhITkAYihdXijzfAd7WmNoY47iv0G5k7Ln77YYIV2wWj?=
 =?us-ascii?Q?ZEackG9E1b323QHD0ndenO15Mfcs91rhlwH3uE92n3xHijx0OvaqWhFL87jd?=
 =?us-ascii?Q?Fc8097oHF/V0gAuvPfZMwqf0NHCpCwjeJUe15BzJySEyptgr5rcn8v6HNlRs?=
 =?us-ascii?Q?MNfv/OBFxoXIU9w8vJLw+4HwttaVKh0PtSHOdl+1ZazPblN4G2dp21YFOHq/?=
 =?us-ascii?Q?Agh9Ieo6Y3PKJcQ8+5y6xVgGCL4gkodC6SZ/ebWx2aJLRvKESt9pYl6AOEOu?=
 =?us-ascii?Q?DWYQ2AfQu5vkyLuYP3zm8YMScpww9nBiXQodaOjb1b645NqcuvK38cIBcW2X?=
 =?us-ascii?Q?wdNoywGy7k1IoNtHLe5mtxuwbS/y0FvLQY3+IR/sFRqXJjZVBO8kqYXefzRY?=
 =?us-ascii?Q?GyT1ueFkknOsKbjyYTGJ4RwquCYnqK85QWZbMg3BCneVziQq79Tp6rcJx/2X?=
 =?us-ascii?Q?Jg2vp/Vrpi/oicYuQEQjuiqMIQ7zmuE5KNopfn/a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebedd93e-4671-4809-f035-08ddfab0e00f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 14:52:53.8930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+4DGr4oc6GccENxHyIsmue0uXQqiw9huPi4cYjWX6ec2AjdB60z+f62YgC6KI1d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8169

On Tue, Sep 23, 2025 at 09:37:31AM -0500, Andrew Jones wrote:
> undergoes a specified translation into an index of the MSI table. For the
> non-virt use case we skip the "composes a new address/data pair, which
> points at the remap table entry" step since we just forward the original
> with an identity mapping. For the virt case we do write a new addr,data
> pair (Patch15) since we need to map guest addresses to host addresses (but
> data is still just forwarded since the RISC-V IOMMU doesn't support data
> remapping). 

You should banish thinking of non-virt/virt from your lexicon. Linux
doesn't work that way, and trying to force it too is a loosing battle.

If you have a remap domain then it should always be remapping. There
is no such idea in Linux as a conditional IRQ domain dependent on
external factors (like how the IOMMU is configured, if the device is
"virt" or not, etc).

Be specific what you mean.

Jason

