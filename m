Return-Path: <kvm+bounces-39072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F384A431CA
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 01:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 538CD176A6B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DAD610D;
	Tue, 25 Feb 2025 00:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LmlkO9DA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D241862;
	Tue, 25 Feb 2025 00:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740442658; cv=fail; b=GegXf3uYKVFBTMbvnJbpDb0b/87G9f/7LWmPGymqRL40XYUn0Gvf8H30mUCWk8MfOgaWi2cdasWq1D5PUnYpcbJz8sPc+5SjDIyAsrr/V+z4REenetOMfYT0N4tAVIXPyM/mxxO6eGjVXkgUGO2OLA4+OGKsaLl1FmXDnXpREO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740442658; c=relaxed/simple;
	bh=fc1KUJkN5J2fjw3AzNLHiEChBgfdrbJprEe+sVXthAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X16sKG+dAgp9VIA+m0cj1TjgpCpBnbBGb+QIo9ydxoffZF+tVOK4yHUuwQnfgVc+PAZVc7R2Z0/qrzHbbUsdeVaX8j+A/y2yFNqRf4AHjvNIEqr2k5aMohEyM/f/Vq5f9rVnuLNS9HC24pwQq3xCxNWCVp5yas7zkSw0CaflXIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LmlkO9DA; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPT68gNoVmY3cDUBUvp6bA7/U7gYuUsM2haNnTVUfztvbqoZn8G90Vnc52L16yNt+mCu7jko1fcqw1Eqiq+OPKCfNC7F+wyNAvWaXVW8kwtResDlW53/ll0lmgkZznv7LLFg9j0+AkqaRS6Y4RTiRakTDT76oG2NTAmuhNMT99e7OmCM9edQWNyPn5Ofg1CNwyS56zbblwFthGgjOGnCrt4W58S8Vh6o2cvIEbh9sw1UXm2OSgyOnKL/zoqNEEdsfaC5ClVsBdtW4dM0cVEUN2oBmdTQkukcKEqL79xDmJxjS17EOuQ7fiFjPUOpL3k20TZ77QOd05skIYT5LeFAMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gm9vfkBjTQ+hNAt66k/Vq2Ai96U20fmbKKnXFHik4Ww=;
 b=IlUU21ZiasJwtmEaHTCZcnEFZkt+slnu4eaNMTTXYjKL1ghb7Vhp6kigucth7I09yrXo5h1WaRUox2NDCDlBsgfXC5iTsoq8vQBTXMSsaKHNC0t2eBiFZ0W27IblU4imtFVmQxyAoCgxgt3kpV2SLhEjIu2tOf4Fat+YKC4IhSIXBYNYUPcfx8A0o31HUvLHOcrputaBbTZX0zRnlhbCc9GE5nWq4gFCpXVRl+yqu7hFF0XLy5ZYOJxiBXLy+xMvfP+eHfYcD1Hivn9fkhbrdMdntMJX5LHbn3vC6hTb2mJJyThaWnpSnr/vWqP+ncpWZpTjAx99x8A25XrGxkXqcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm9vfkBjTQ+hNAt66k/Vq2Ai96U20fmbKKnXFHik4Ww=;
 b=LmlkO9DAl1cyLJ19G7tqosqwf4sjdIlejM7xRMuqAGDEAmKz3qmL34xy5S8Ab8vazJ1y39x6HyMh6tSBhUesxP/KSIReCyKObRATJs/lknXGxLBZsAPqi23aCGPz7942d5sXu02bZVYI9+tkjQsgIWYNiIXDEjv0J3HiYLGXVDZuoMM6d6m3CBZp5Pga6ijsBjUDWgDBh0H9T9LDAluSyYWqUPXyTQJwrTOKOt4f0xJKFLibKMaP8pV9KogAEKL+Qgsf5XsK1JKS6D8sZXd9fy7ohVFzANFPSGCMnUSibQgu7GCzVEk7SrcB4Alqmow9/74EI9e6pbjPVN6kk7Bm4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ0PR12MB6903.namprd12.prod.outlook.com (2603:10b6:a03:485::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 00:17:32 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 00:17:31 +0000
Date: Mon, 24 Feb 2025 20:17:29 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
	mitchell.augustin@canonical.com, clg@redhat.com
Subject: Re: [PATCH v2 4/6] vfio/type1: Use consistent types for page counts
Message-ID: <20250225001729.GK520155@nvidia.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-5-alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218222209.1382449-5-alex.williamson@redhat.com>
X-ClientProxiedBy: YQBPR0101CA0101.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ0PR12MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: 16240e62-6565-4b2d-fc7c-08dd5531cbbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VdP8CGxpdM2mcBDOsusjB568IA5ugQp8Fxoh2xJSyu/GBa5zRnFPOorJpB2t?=
 =?us-ascii?Q?UaxH2bqcifETFs1qzFjTwDk7drUKZvHLCMAxxcHi/jkHK9HlyhnMgSv9NYt0?=
 =?us-ascii?Q?nKTY3U7YXwLQnlWRFoi+FDowSM6T3Gedt3E7eAAhXHl08BgOnAe9btlsxrav?=
 =?us-ascii?Q?Bf8N+N3pJILpECG9v5QP6z4NrzuPOiLi9H+WHzj3tBGKTlmwNVOA9h7YaVmL?=
 =?us-ascii?Q?GMa3YRI6pBJHAGlOHWF4cA9Lt2INmV/nRch9KgZ9Peh1L+ge32wKqYNhj+zv?=
 =?us-ascii?Q?kuMYAeUzOYeR1BNq6Vv5iIsueEdzuvjYkN6HRi7uuKWJ3VxBUR/w2xgJ8n8H?=
 =?us-ascii?Q?6BJWvsfcK5HhDdlefRYlEBsRm9M0UO0rE4bAi657jOc87qlKNBf9exqX87Ha?=
 =?us-ascii?Q?7Fs+graBoK6o/VLe9ldGjwti7W/xLZqng4nCLPic1+vIE3WAbnIt4QCqCVQV?=
 =?us-ascii?Q?kSxNDrYRJlt4GkxN8k3etsUjt2HouVBbYHzYdBpvohivwUDfPW76nCtR4W9v?=
 =?us-ascii?Q?/8WUcNVEWMMywqsAW+5zqqS0cp3dbzyeP4dxKXxQmfWQBHkAbpYVhBXZdtTv?=
 =?us-ascii?Q?/rhZ70GYRMkFQjbUVGg8JE791rU73rMjaaZGCWX9avNGDQmqo72XYzSTvZM1?=
 =?us-ascii?Q?38PgiWYM45faAnC0HM5m74WjPGX7j5NN5WfSv5p+oNf2oT0mg3fvm/yZfDg7?=
 =?us-ascii?Q?ZCyLtvSDzyfSldY6RoiX8bP1wZPS3buK6vmsSlh5R7OxdcXKHtChgRvs7gkW?=
 =?us-ascii?Q?yepRIoZHExsdfj8FMKD/iXKyKy5m9alcSopzl/cuybwOsMZ/8OJg5muh3FYp?=
 =?us-ascii?Q?qoYJtyWEQJZO9hHl0Uo0/v40IcjdTlBQShKYHxKIfusAloSeAq3xlZ6q90i7?=
 =?us-ascii?Q?zICdvwosZVYiYSD+ssVRVjGcIuDmPnzpS8MEk6lfGnI6p7+4p5SjN3r59Lvk?=
 =?us-ascii?Q?lMXaC/TG5jWpzYGdCGMcCzMo/REoakgeVhI1DJLTpbvfbFNQjc2lt6jeAX03?=
 =?us-ascii?Q?YLXrrPl95nPohCJsK2GyYd9vf2fhqRF/TURVlzb7NwoH6pfZuxKjameF9AZn?=
 =?us-ascii?Q?4Ihqk/si/YAst5ELK3ZJDzi157xAxEQDFDSDuPRov/m4GK55EPsoIVEAsiXp?=
 =?us-ascii?Q?qAPuTB4wnWMYiTeNd2c1Dgzip7GU6EDRuFe0odNWCeal3CfNo7Mjj+XGxzO4?=
 =?us-ascii?Q?MdAVIU/1HKFT/cstjLqK9u5VABdbrf2YyVFhdSXvN9ddPqTI3ThDoTt9fTid?=
 =?us-ascii?Q?ANqbKBBiqKprba9ABjRvH7irbmHMrKZ3MkMofOTYBevuKyGGx62RzlefMO6D?=
 =?us-ascii?Q?ZnJB1ReCnMOsUSDupwezBevMWSyMf7JZJs6FijZ4eSTup/CeOaRMfnGgf4OT?=
 =?us-ascii?Q?MPxnA0dZLJTaG6BR06q3xuSgad61?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lCVgFc8lCFp9Fch97OIgI0XSzIbLXI9h7ZutmdcpJ8KRBQmTNJ6AG1wCpBuJ?=
 =?us-ascii?Q?3RecRPlh2Bpc260xsoroIdkzrHQ6c9awI90OrGrgA0EY8mLM2rvucI3fZ9bM?=
 =?us-ascii?Q?B82kuDkC7GQAHQIOSildzhqo3xaegRZjGW5L8GiYqhBYQt1Z9L1P3zemH2p7?=
 =?us-ascii?Q?2jcm9dQhe2NnjxGeSOhlrkp9sjuQ8gAyKgIwWKLYiqtDnuquLBQlZ8fLUXK9?=
 =?us-ascii?Q?+ypboMCL8V8aQZFNGXKu/BKkWDzFO0Xg0AgjLpdeXZSeFGk6kUnkSm3I9jHp?=
 =?us-ascii?Q?9JDo6MJ6FPHA02eL9H85jcn4qM3dEdHpNWg4OZvM6MQ2NfBBRIMgBWh14Ffk?=
 =?us-ascii?Q?k8dFXbmVgqjB+6K5ltNjwfMJmrEhtFmpkmNF6x14V0b6E26D4GieuBWDN2tG?=
 =?us-ascii?Q?dvdexUqJs6TU92AhtADh+uFjA7lIn/kUmMwVXDVgfYahVzgdst1yrDMiARoh?=
 =?us-ascii?Q?HvH0P++r/PE5uceK9tSVnKfQ/xRVCJCNwcjtrGeAeEgCx3h+ny3eYOa1bdtd?=
 =?us-ascii?Q?TxI8uau3SOzigGwmqn6BrGEj/1ON2SYze8KwfvU5virwbWNHGA6DRDohyf80?=
 =?us-ascii?Q?w92z5j1zl85klTMjWcvVb5tapdrITHQAG7+k2COt7Q8DfgTqCSgLd+dB6UuN?=
 =?us-ascii?Q?mGRWqPkfI5WiwmhiNcE7pyiUBrjhyYKcysamNQtpVHQGrOdUAGDVg9HpnXjN?=
 =?us-ascii?Q?dEbBQZtdxYzaWMbptivQ+6BLCKMkfZabQotM3IXU0u+IESnNmVuBeTyY71Vd?=
 =?us-ascii?Q?Y/5HymC4sms4ammo5jsW6M01jigN9depfN9MbIWENFWqbb9E9+EqPXGGJ8Xc?=
 =?us-ascii?Q?TN5tyAD1UJIgfBRuF5EoguAwww30nPS395rAcUPYvnF/nPNHnIes/0UshNfB?=
 =?us-ascii?Q?qqWvT9Cy20RUf0ep/IqLA2k0DIDQrOovIb+wApPZ5vHv28fG/s3pSS1R3oRR?=
 =?us-ascii?Q?6prdciyGsjKUT76tayokhv7+0QUQpqkGjTDJIviLP+3X8+AlCo9rXEultbJY?=
 =?us-ascii?Q?GTLMUbBKRHlB0j/PJv2kphI/LgDPz0jlglB6JPk3OJugTwdRX+PEv1zxIvcK?=
 =?us-ascii?Q?RX6CfHgjItpwykoz5PqCo/l+kJItgcnXZZSfHsugiw2Me1Eqv1Z7JWguSVlu?=
 =?us-ascii?Q?nRNx1BkS0RShOlxURW+3IPPJ5KzSnw5cuOq40+QHf5GqYrQ548ieXj6LrYPK?=
 =?us-ascii?Q?324VFnxdlJHWymIFpcV3BYlN2a1MB3VF2pjqWEGJpqdxcgy1+US0WGk6zwxx?=
 =?us-ascii?Q?IxDkMIXSdt28qTpZfOS4B7zWndeJ0FLiXQ0eogFwZF9dqgR18rRkfo5EKBW6?=
 =?us-ascii?Q?tV0WfxBSX0kKN882jgKFlfZ1wIsvHjyLKsGeThsQVmCmo5BYdQHLXyHw7FE3?=
 =?us-ascii?Q?HPyjqS0z41pRq4vHunXsA5KQ1OLN3ZiGdN6nvCYpz/QwAQktpa9GL36cdzC7?=
 =?us-ascii?Q?1K7j9OlYC3lVhDNrO57oeJn27lyZaKOvVeIrUfscCsRjbqzTfHQpTxzYrpyw?=
 =?us-ascii?Q?KQygQJwYYzYIrzMn38ayLHQc5KBk7aWy8MJjM/Lvwm21DLxV7WfscYXeS215?=
 =?us-ascii?Q?7mLAWFkVSyKgbM4IGyDJSn59SRjPnYKQL8efDWOM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16240e62-6565-4b2d-fc7c-08dd5531cbbe
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:17:31.8938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLAkpM0fTQEzC1Kc63UShgPTLnKGXwyheK2t9uxhvz/O9xTvTczl85ekwVyz94bo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6903

On Tue, Feb 18, 2025 at 03:22:04PM -0700, Alex Williamson wrote:
> Page count should more consistently be an unsigned long when passed as
> an argument while functions returning a number of pages should use a
> signed long to allow for -errno.
> 
> vaddr_get_pfns() can therefore be upgraded to return long, though in
> practice it's currently limited by the batch capacity.  In fact, the
> batch indexes are noted to never hold negative values, so while it
> doesn't make sense to bloat the structure with unsigned longs in this
> case, it does make sense to specify these as unsigned.
> 
> No change in behavior expected.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

