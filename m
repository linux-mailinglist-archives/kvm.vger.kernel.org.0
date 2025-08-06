Return-Path: <kvm+bounces-54111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7DE8B1C6AC
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 15:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67B2118C027A
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 13:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC3523C38C;
	Wed,  6 Aug 2025 13:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tPwPiZW1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8085661
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 13:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754486192; cv=fail; b=K7EYJ9U0UT4M7kmrfH+6R3k7vkKLUiT0wO+9OJGGkhP4VsMUo8SJK01HIatDJ5JpERwLVgtyhSyQsf9691hV0h8pOuOFoEpq6h9xPaZWkwho12URk5Yj8VbHKYpZxAhz+OypPw7BA2RuLCgUN/dKkyTLllwZGTWgpClMY2Y2VpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754486192; c=relaxed/simple;
	bh=rjPgL2ctVvHkfOz4NrNin3KE+m54u7H7GEB6J4FtyOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M8aRhhTfwsnOKs2yBEpz7mUGCNu5VW+CCXacfpTNtDw52ztVQLVfvlRHmRJC2R11PfEKUV1Z/1hpNZMN8koGV67/D9+MHO/xhN/m0lr2NfNxTb7EReh9RnZx0f+Ps3QZ8DkQpAg1aNXIt/gGP1vpJkO/MLxXvoIV+rtmrw6xeG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tPwPiZW1; arc=fail smtp.client-ip=40.107.93.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZIdoEWO6LpJ/XfaAbzQvraRMq82/42fBhcjiTI8JlWIze+y91qOhcfEyYTIdSZXLYyO1LAzeBLU3i+fOd1XegFa4W50+zTicmsZlgeseWF11vGnn1Y0g2sUhrERQ3AFeui6AzK3gUvNJnLNkmmXF8BTYGx/l5feY7DtbRfnXo4ayCKgigAQ8/IV2fO3DnGChtodWIg+qbXGgJrdSoL9xJVnQZBrUxPTKSYQPyaoa/b/ITJBa8oPj+mGmCwdQMDjXjkAZj/mwSo/LA8+nnw3IGlo5wj01TnSRiuY8zKEQtkacPIkkrjMjND2IWtH01s7BCO+Kln6X+OvPo9hIufb+Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZ00h/QGX78vUZ3NerYCg7DRIoai9JNgSRKoFBqqhUA=;
 b=JOA9MVPhMCvxqRyXpWTmD3BBvZ9MlfnzWNgjkEzB2T8uUcDbh3kjoozES/uOJnls/SyyYrYZceBCNM+iOSsberDDBkYnqHcOuHyMv3jDOw6LcTbZDog6fXjaetfQ7VlBo4WGI9fvtFkrviySHE8GrB4J85KOdYVryipxdgUZLX0JdlLbVDQB2Kh9vFidRO4Y5AYvV8QylSrBJAu860uA+zOnHfvnbM/jApaeriJdqqDmqVpdMYvrH3gud3aRajp0oKOI2ZQKZbMU97t6pyCCUHqAzSAHj7PVkIyW4AhWyhGVtUj5vhEtYRhoTMZMy4wvVXFIG9O5ee5zEW/Wv1qJ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZ00h/QGX78vUZ3NerYCg7DRIoai9JNgSRKoFBqqhUA=;
 b=tPwPiZW19h5MEH54E30RMAKHGFOasUnIgVpVhzY/Z0MCbOAsO5CNPJcsFDoVl8DeEvmnJshVHqExZV1I1PzSedG7gUshB9aPQYzfdcRCgg888LuPxqJjCtqla6G10lPwL9dn4NJ4mCJcf9PTn7PRZDzdbGL0WyVaW7CFgChRgzM2udIxy2UogCqm+XK23w3orOf0kiyjd16/RxXd1zKrGIeuUvYQmcjOVsAnO6p0X8+tK1b4lWIt3Q3bFJXwDoGH3lpXnnb79IblSh73cZmfUv0Nj8csrDqnPXd22tUj5iycJrGJ0e2kRF9XE4S2TvcaD114P+73rYXSkOrMZknMUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB9466.namprd12.prod.outlook.com (2603:10b6:208:595::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 13:16:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 13:16:26 +0000
Date: Wed, 6 Aug 2025 10:16:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	Li Zhe <lizhe.67@bytedance.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Message-ID: <20250806131625.GQ184255@nvidia.com>
References: <20250805012442.3285276-1-alex.williamson@redhat.com>
 <f4c464d0-2a98-4c17-8b56-abf86fd15215@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4c464d0-2a98-4c17-8b56-abf86fd15215@redhat.com>
X-ClientProxiedBy: MN2PR12CA0004.namprd12.prod.outlook.com
 (2603:10b6:208:a8::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB9466:EE_
X-MS-Office365-Filtering-Correlation-Id: cdd9fc11-d693-42a2-db96-08ddd4eb729d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P+ugPji0hG33hdlYicye7e1JIoIuZI8C9Rivlw1HxVXHo4EPi4Et+fbAYxt2?=
 =?us-ascii?Q?uLAI/A8dD0DJah1mqRD66ETdUFWpUBiXhLt/p4U6Y2XZ8bw2BpTfBBhdDblf?=
 =?us-ascii?Q?C9CzYojJDKTQ9VrIsROMjORwo7VYVnAGjYCjlAQl100Df6bRuLy4pybyInkj?=
 =?us-ascii?Q?bM3MzbdoLrVCkyzjQEhdLRAOHSZrDXVvHIgRswrSuNFrVzjuG8zr+pAK43Tx?=
 =?us-ascii?Q?MFq2yTsqXcemeRQ5cAn1wCxIR/W2wG0Osigo5ENlNoqFMuasIvNM8eNmsLWt?=
 =?us-ascii?Q?X9YmfHKmVBCGMxh0okbsOp/uDxrNcHDSVOcFtuYeuwR7Tlmd1NwuLvTAxmZI?=
 =?us-ascii?Q?JMrG16jRLbX8GyDV4FxkBBNzwGmUV3KUPIdQRK8PgHMT0/oVEtnadlROIdRh?=
 =?us-ascii?Q?7VcYnoTsxNIHWsEdUZ7f6noBS7X+207F37phpI1YptRg39wpsLdbmL76q+nW?=
 =?us-ascii?Q?Iq0NXBpqAe/YE6qdpBIQiCoutMzOZKKIdZEv+m2KZlDem2kWVembIpuCiQHv?=
 =?us-ascii?Q?gnNvzFwrZMDPL+C/PVo3qIr3RDBWmRS88ySY17K+a+ExUUelAjJLrId18+lm?=
 =?us-ascii?Q?EOgLnFgQoc9TZRbhYuQENuEWdleNxbU0mhLlT0NL8k10j07urTPhpBUi/e4f?=
 =?us-ascii?Q?b5VW2kjRd9pYYSXuncamQBYlqNLGkZnO1s24Ahm7dlcwP+pf7XBlMWBXSqmS?=
 =?us-ascii?Q?2Qo267lpkiTHdku3O0YFX03Z328izkET66hU/STy67HS3yADrRyBOlT6EpeP?=
 =?us-ascii?Q?+lA5184uHG168eP4wVHe5cSNEZtIG2oYxb62aXO7LuWBvrikxr47ofncrrSi?=
 =?us-ascii?Q?dyIVMOmq+7NEGABwRuVvOfVJvVX9iPZGV0pMvq24/bc/i+zOnAKEkT4jZ+Gt?=
 =?us-ascii?Q?HGw2KqgoBK0foeUoDhl7i2CXXIIDcg5muSYHWS/BrksXwr5F1TKNDxRfBx8x?=
 =?us-ascii?Q?q3Nyp3A9cpPZU1a/paKZIstg/zExVQ5ZwmOz2PpiZJxK/5DJcSQAz/9QM5rK?=
 =?us-ascii?Q?xkD3fTtdvkmwPr8B1SATl/oVCm1ruNTReVfpo2fjZGbxc/IRVbgFUaudYhin?=
 =?us-ascii?Q?Gy+uHavqL163EuG3enj351/6NTR0br8dS3bT8Atzp1oTpfPgiU4KT58K8u76?=
 =?us-ascii?Q?OeRnrq5uJUjrE+L+YUGmCyRhvwHYpd2SC9PHmpr0LX7i+woW6eZbZNZHHSLn?=
 =?us-ascii?Q?VvrcdTwzoFwk3pbzNfpSlUECaEJ2Ggg7I6elTbQR4e49X3a9p585w6FDMXPh?=
 =?us-ascii?Q?81xXDqPw+s71Xayjbi8O2CqVgdv/J7Zt2UtaaPcgVG+iFcJ9KBkF14jWyV8a?=
 =?us-ascii?Q?wJoTU3MdSGoGqpoSWQV6/RPO7CcB6Cszr8plYtoYIjpzbTw7+dXtWGJx1G/s?=
 =?us-ascii?Q?j5/WViSXsNJMthtZBj0W6XhWczlMYu2oRF0wRyv+7cRlDd1igBOwPejGb4hI?=
 =?us-ascii?Q?5OrvVlEse+I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uAKJSMtakCCjcSJjDcuw84lajCX0Vi/Qxw/j4XxGOqJGbCwPkWyRJAZ2d/Cf?=
 =?us-ascii?Q?jZ4Ur4jEzahCl7K++glj/KixWDyi2mEYG3OXhKW69RKWrKvBt/lmTuFbvoXc?=
 =?us-ascii?Q?iPahpCB9nWZjyviLsGusUF2lyOV1oAb6+KljU5A/m8IsxMNlv+g8ZwwJHpiK?=
 =?us-ascii?Q?r+b0onswG7e8OiQgHIoTLchHsCvXci79YXpucW1L6n+ZxNE1YciWnq+yncsA?=
 =?us-ascii?Q?1L2i1nN0KHuCDFIU633VwENEH2Rrp84cxcgNAvKeYNeL5IKzvoIuJ+hPenz3?=
 =?us-ascii?Q?PIrXH/txqPCcjqrfcHVbAgnDT8A6dMSfPmMmlQxae8GGg5/xKpknXWD1zBwP?=
 =?us-ascii?Q?D4dUNMrjhKwiGi5wGXq24aGvLMu4aMgj/hoE1xKQoGzW6yz/wRUJc52gZWbs?=
 =?us-ascii?Q?6T1bLa5DUW8VSCqjRv/z+eVDhALFRJIWycYyEaDQiSffRW7orC14lzB2pOoV?=
 =?us-ascii?Q?XhXlRTXa1YV7JryYAfA1vTfj8Yul+vkKF3MMxaDy9e2oWWVFv3mUsJ97FJKL?=
 =?us-ascii?Q?3BluMqDhx99oLBUQq+3OU/uWbVmB1167tPovEJNDIyHvFMaWEEskhS40TVdD?=
 =?us-ascii?Q?RDoUlWfKZXjGv534dvcJWX6wq9fM9s2gK6lVfHcV0AT+OJ20q6CzSZpIhRt0?=
 =?us-ascii?Q?yrP0w+dyoZ/rO42j8hEG+8WmtWN2p/toowcLD5a1OHwueGWll3BbwXKe6E7O?=
 =?us-ascii?Q?+7CQ3e68HkuRZvNvDQMgz6yFSIWC/sYU6VMI2P77DNU0izaUVfp7nLRtoB5R?=
 =?us-ascii?Q?2sC5KCO6+G2qDMupaexpKhRK2rp4uHbMXGANdnnjT57ekG2ohkVOaUdPyV6H?=
 =?us-ascii?Q?vVW3hM75EAP0nqCmscjUNTM/wmInXzfx2dyw5A+4fRvNkFKFPXy+osKMC+hR?=
 =?us-ascii?Q?6ZEWtjtQvQzrqNUwECQs3hjccitJOGbxpDuAUQInpg09cuTrNggmUHGNO7Lk?=
 =?us-ascii?Q?TuaRmUtD3zjTOrEKzsa70Vhgrt0Qo47r1Bcqpkb9q59o53uUG9xFQMT+S/p+?=
 =?us-ascii?Q?Y1ZshNTWm7yLj2sjtUyCkEItDFIgbkTSdbgQAOt1c9XZhWucUrHix3tbStVg?=
 =?us-ascii?Q?CAaGtg3G3tZvUzrfh9+fmnIgHwfTXDnTxubB2xwKZa3pD+DiQNM2hZxCNVLM?=
 =?us-ascii?Q?THe1XjpFlO0bChL3GPhYgNch6BN5Cx79Mfgms/tdqGDhU8asKNxRCNpir26O?=
 =?us-ascii?Q?InqlkGI41XSwLUmjMbJXpo4xGYFkIXC2r3qAX2zFMeZeLpB3+gRfGsREJVAH?=
 =?us-ascii?Q?jSkwdW2Wo0UqFD6wr1u/IJTx/pW4oEpwoj7J62ai1Wm2qSn2ak48o4QVPZ7w?=
 =?us-ascii?Q?G/bU692OHsTGaSahUdQV6qt8UapMSioZwtV9kdWj+5Vo5KZ/rqwKBo3C0kk5?=
 =?us-ascii?Q?BCsVar/Krbd7II8oXjLiIHwYw9c3Sbz0QUQXCnqdEGegsWTGKCn9R4okXyAl?=
 =?us-ascii?Q?L33dRWNUIm/ZXYC9Rnc3zV3OX30ms1P/G7mPHID5a04sTrdzR7ssZd3C3oOf?=
 =?us-ascii?Q?wqmCT4FL8nvUP7gy1pfaAufS5KCxgZHWNZXhhUzTtsGYlj2/HJ5wBf/coYxh?=
 =?us-ascii?Q?JTBMQohJLSvx5HcHRzQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd9fc11-d693-42a2-db96-08ddd4eb729d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 13:16:26.3857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4nuZxkjrKsW3SZFROxLBL6iYYpj6KQmBmFMfhfNzJTJNELnR5xNMHOKLgckid+5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9466

On Wed, Aug 06, 2025 at 02:35:15PM +0200, David Hildenbrand wrote:
> On 05.08.25 03:24, Alex Williamson wrote:
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *                          that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In kernel configs where contiguous pages might not imply contiguous PFNs
> + * over memory section boundaries, this function will stop at the memory
> + * section boundary.

Maybe:

In some kernel configs contiguous PFNs will not have contiguous struct
pages. In these configurations num_pages_contiguous() will return a
smaller than ideal number. The caller should continue to check for pfn
contiguity after each call to num_pages_contiguous().

Jason

