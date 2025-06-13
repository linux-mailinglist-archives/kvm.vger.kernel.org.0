Return-Path: <kvm+bounces-49430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9AE2AD8F8F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 908D23A5DD3
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1EC18F2DF;
	Fri, 13 Jun 2025 14:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y8UdeDbC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0969B2AE68;
	Fri, 13 Jun 2025 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749824952; cv=fail; b=XesvzwWoQYd8G8MskZ82j0X2AGEYbDCmeUNC/HoltAvvNUiaCF1b8MUHKOMXO0cs/kwcR8iYYjFaT8+BygdH6TRiAyKBH32J8GcKVFzJPbRieShBMJlf1jUgb3c0Mm7JUqspc+WI0Skn9SP7n8LU5+dSYq4BV127E5+wLTiBWWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749824952; c=relaxed/simple;
	bh=W7C/JTGwv1NBfY9Og+nRBN9p8wrwr4JsU3xqSRxGlQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZJuaXTYaXzVrb7vouC4OYjrjQHA2tc8z/xJgrXdvfzaX9p4N3DrS8MFh8Va0s3nLgwHnwnNJBh+7hAvWiHGzKWwoYWt4Q+Z/71CQLGg0YrsWI1nmwZYPskHjb9aSpQ+dRMtnI3VUTvgXbjUf3lythT9kat/v5eNsQfohBjO86Cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y8UdeDbC; arc=fail smtp.client-ip=40.107.236.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DjR07n6t34uU39gDSuFbNqA+X+TUC5mKFLRpEqsNH16ot5AaL9xgU2jx4EseU/38QTS67Q22MEmB1hRv+SKxfuLrf7cjJyb1dbg33CvQkZO9vyUDp/1n5nBYhxYDeVee8XNyKfNocb41Jrn5eL5+b2sXpi6us/RsTo7Ig+1p5Oal4aIu9P/TkKLYlznRBktTzBvSsqF8jqJ9J5H5Agnq7Frn6QgGwl/j1CehgL8C16Gdma0TQNT6slCfKqZdwuL99wVlrVqkv0meYBBRgDUk+G+CYxwFu37bmnf+1FofsW6/V7tVcwXgpFzktYsG5dD83ijQhMrzkvUww4+KceH6Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaLro947FhZvN9H1vtOxdsB/KYG9OTwRtFp58Bg/+s0=;
 b=yyjH0/qd0hTk56Mh2YuVsLsJCc3uVr4xzXDPtQoq8LYRPEUOSS/uyUGA0UZXfFmhnMLvn8Nqlj8SfBfSKTVR9oASfU+ivcWkEZUeX/YUUtLaspoOWxMqqtvgS7xV39DKE1RvmJTfAE6QAaITuQH5pZHu0op+HaDPmYEXylPtaHDU3hxkDZZuQZX+SRoRqD4VzC4znDRjm8Vfer7vIlBcyv1J9Bdf/aBj1c4pVFeg0K7h8Tq9pFwFDuWt2XPxiOB5fRfWSswWGYbV6hPe2aXwDfbKc3fus4bo0HSwLRKtAB2e0GmxZXaaqb0526IR8AnSKCMyc3ZqOIXembU3qnU9lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaLro947FhZvN9H1vtOxdsB/KYG9OTwRtFp58Bg/+s0=;
 b=Y8UdeDbCVSkBePJvYhY1LYgDLjJnxwB8sZcvI2eQrzh3nci4ltmmPgQR7wn/y5aRzNqCMXK+16YKZyZTTHDIeysHfcH2WMZErgZ03HorS2UnueeAUqv0xk/G3x1uVR45MBM3IPQv9yujMMVsH2NWzisHPIOcEdfxbP0eDNFtXkwxaxFr8SpR1h4OY2AOjNpGmf8Ly+jgZqsD8FMRZzQkcxselAd4YzpO/yQ9GtdBysaUNc1ffs1Rxlr6RiUhZGcFX3C0Pi1Rx8N26B2SeWZLBc5XjOi/mULM9cmham8Nc9KW6nbqj1dSErIY+e/suVjmjiaITsUM6FfRdOXM4rkSuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8086.namprd12.prod.outlook.com (2603:10b6:208:403::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.22; Fri, 13 Jun
 2025 14:29:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 14:29:05 +0000
Date: Fri, 13 Jun 2025 11:29:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <20250613142903.GL1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-6-peterx@redhat.com>
X-ClientProxiedBy: YT1PR01CA0153.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: 402358ad-5833-4753-e214-08ddaa86a639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mXXXzO+raK/b65sTDbxZCErkg/9V7DGakbZBScSFg8HafHmIQu/hWKjYGsa7?=
 =?us-ascii?Q?Edr71Jrl1zNwCJwBbuefKVIClS/QriGQS7HMQZF7Kw2OrZvVkROuD67Eae3h?=
 =?us-ascii?Q?JXDqnRzKFywjxlMlJI3/AinylvMmICxSnuew8XxalwaQnedCslUUvNIAL0GH?=
 =?us-ascii?Q?4mKkg8TY65NzuiWsmDd7quw6RYeGC+ATUdowulsiAuqSOUAFZEEo+B1PF/iy?=
 =?us-ascii?Q?7auBkE4xjL+9dthy/TrDlNjLSF59UX9eOm7igbjEbatGIrIywqXIJItkM++B?=
 =?us-ascii?Q?/o4+kRXn4gIifUgti/EuhlHHlwcaGRPX3S0boAv6kZyYqAYZ8KT4FCEqTT9H?=
 =?us-ascii?Q?nRTV9RKrXHe+HAplW9VhZcyqqfxmNodQiMBR/YOby/M9MO0djTkIvcZQcCCr?=
 =?us-ascii?Q?3gEu86CLL8/44WMpQX5c2XLtaEjzEtcT4Y77QLmCGK3yvGSTgpkWwMgwoy3i?=
 =?us-ascii?Q?G5vuIzjhdJpWGiYchmzPCO8z6uciT7yJC1dowZcGKnSpfdxjYnvAuhveV/tI?=
 =?us-ascii?Q?NetkhsCRPIxcrFyT9QGx3TEToSxaE1gZg2o+m7hJKhAwYNqgN5+aMulIh0/Z?=
 =?us-ascii?Q?LLjWNzmSgaVI2cnyp/CIMxECG8QkbZn3AuQSSeeY4iIgPMfaUZJT8CAJqFkF?=
 =?us-ascii?Q?QKSym6L8lxgP9FyE/HXTvTxg0O8eEgyHac50J4aoiVL8Z6sal5L/YK9jkUVB?=
 =?us-ascii?Q?wD8LzVNEy5gv8tgvvu1VOh+TnmTumPlgPb8V4LmvXPdCcuER/EpT25fbkbnl?=
 =?us-ascii?Q?Rzz4fqDnpdAW373+54cGbDV0/e4Gq4rfTmZMzrghLHN4cScjidztLNmgKBqR?=
 =?us-ascii?Q?H9Oqlehlbf27EB9jx/nivqLWAgujnJngbI2hxjdKF/dWNhWtffPSxP+oabYa?=
 =?us-ascii?Q?RFU7UWzr80ZmRQyVkyLhLrquagSYf4IwqYk4ngxmT0qh3X+9KKvpfu11cFta?=
 =?us-ascii?Q?UkcnIJaH14ImxyJk8eVZ+p8HlsRjdiArxonTjBQ0GnN43ppvANSqTC4Jdm29?=
 =?us-ascii?Q?OhJcbk1OydiHtBNxozdhz2fo0XNQBqtmwd4Ak7PbEcppmpBpdT3to3CYJzQQ?=
 =?us-ascii?Q?tz5WgNHeG0I3T86WTYEKjdI4aNNGF9uRZXfK4JjeUL+o6sEBwmibDdJ/bhcI?=
 =?us-ascii?Q?gQ+GGxqMUuy94i7vjHTfqwEnGDlkuKR06iSYGaRLjSWNFnVOMtAGXOlcY+15?=
 =?us-ascii?Q?Ct4cuXV3hCDo51jmbLqiIPs/jkUu9T7XI98NMdBHYrqE2KS0IjlC1HGOuLjT?=
 =?us-ascii?Q?vdnkwPtgZcmVXBQ4FA4gJdMEb8ixq48AYLhD6AlB+YbLXup1YK8395rIWliT?=
 =?us-ascii?Q?VZcnF+FABFxjZB3zuTFNIlonnd486r0/IGWeKw0yHVvXPlcNeSTcqGG1KfFj?=
 =?us-ascii?Q?tlohOpjm8KSZiBm6O60yht2miUMfjYOBPNmjIPnT/WJOC+Zl9h6nJNt7YcB5?=
 =?us-ascii?Q?TN8hDK/+w8E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HqW4yW3xjAq1Nz20rTArnYGIqQfbJMLm2NszzBE3XH5D5ZGQiHeui1WX7D++?=
 =?us-ascii?Q?hbQFhzyr2IE0zm/Lxk1ekvyCHwzSdY2on4mU8cOu2r/9EsivUL5+6DOGaTa+?=
 =?us-ascii?Q?HfpUyNun3V8Swlqj0n4Dc+ExDsFNOPjVuyD13dJgij08Wti6Nro8zry5kq9+?=
 =?us-ascii?Q?aql69n0Og8ipV9mUXNN7wnHjHhtFjyNYfTNrg2PwAt0TBiMayho6+LIeocqH?=
 =?us-ascii?Q?JK1P3QDHilkAXi97DsCnNtY8mG4lfMdvrsQ+x1BElhmYepjR9zZigEw4ekF7?=
 =?us-ascii?Q?tzX4s4GkhWM3rkfKLVoP9urUnNxlcNzkA3/odDCEZnvFUFmtGsBf710kxWTC?=
 =?us-ascii?Q?PEYy/7nBqjZnC5oBggfRWsUQrQ+aBJcB5Zr06tQG7RRuqg2+jronyCh8HPvi?=
 =?us-ascii?Q?IGKYMP9WZdXkSLJJVnoBHIMZZKnUJVzIA4AZONboQgJFmlGDCiKt90F/FhIF?=
 =?us-ascii?Q?r2nWJo4nJLSPnZp1dFeaTZIaSI7nq7V3kQlo+Giy3q9q4KgAau8u8dybi7yJ?=
 =?us-ascii?Q?JAp18gjwYE4TRXI4p08C31UCmig876O/X2ibKW88O3hbbMLUw6eqYYIBI60n?=
 =?us-ascii?Q?xh3fdTA3hCSwbgWTs9mjsEFAn+XkF7xkRdrpqtcLo1YnohPF3L6dG+i6U24P?=
 =?us-ascii?Q?/uJ+LL/e7YYHb1k8pRt415Ej8eaWCoiMwRw2Wkn8MNrVso1fuOgynpHGcvtt?=
 =?us-ascii?Q?CvuI0u7y4enUB9Q1Cmb23D6jZeug+9WMVQ2xVmwT4VPQErLWfpYH+OBLUDpT?=
 =?us-ascii?Q?V7suRCK3MQ2ljK/ykA30cdKbssa++VpjWCSXY8VsUb8Fe/QDaIKkJcRJjMhZ?=
 =?us-ascii?Q?Ih4HSEQ6Y8Uw90XwL1iDyNNSNhePRBvnSEi63Vg3CP3Kmp6dTYzeYCdkfB34?=
 =?us-ascii?Q?MSaW0a7XxiKuS7/bhT16964kKO/XCnkLkW4Vr/k7SqfTFk7v66tvAhdaLL0G?=
 =?us-ascii?Q?7mm5nDn3v3PM+l+YuTA21F3ArO+C3EAKHysFUhtuyh3HsfO014IlZuk79YuF?=
 =?us-ascii?Q?hWXgrggd1Cx2/yLRLpm+Nt1/9QHgmB9UtJUEWBxPqyDiL/jV2h3JAV/HMd66?=
 =?us-ascii?Q?Zy/6KJKO1EkDsCTVCVp4Sc4vbwLXw1PlkKBG5qrRKlfB+kCRTBnJe8QgIDJa?=
 =?us-ascii?Q?FulEfkDbelhDUB4a897Y1XM3a7KMSpLSUz/1JA3XCMkprAWgMx08jfmY/7ac?=
 =?us-ascii?Q?YRZ2AOhPPK91sCFhd7QxNCpWHQ0YfLgL5w/caRyz8IUzrIUXOu3E5zIdHbCy?=
 =?us-ascii?Q?O5/bbfnSIQXnXuv4pe8XLAWvPIQwSroBdGITBIT1kHLtjymXvgQfswBipMKv?=
 =?us-ascii?Q?OEt1OH0TgbMyWs8aSKQ1HzoZLw3PQvQOYSQ5JgGX5jf46gatdfstKhfeEHy9?=
 =?us-ascii?Q?Rm7HXRFRI5Gs9K+KlAHkMmRF7om7Z4XaQsWC7G2ioXeltb1g1XeKkD+EN1ER?=
 =?us-ascii?Q?Evgo2lR+H8/UaSWW8gjt9JUpMUevlYmSIOJJB4SGkIgFyISqZNQbvDJA9TX5?=
 =?us-ascii?Q?V6NwI+ZHe/N+DDoTedvW0S51VAWNJXXH1/VN1wtl6Z75p41zmp88yoyUfnri?=
 =?us-ascii?Q?BwjVZaqIRsHOug3OFIuiIsQraLL11AujPeS82dyP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402358ad-5833-4753-e214-08ddaa86a639
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:29:05.1079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmH7jlgfbnMSK67orY8JF7PwLfH5gnW7lOZ/DEJ/aDGydlQBNvgQELdqE4UTE1uF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8086

On Fri, Jun 13, 2025 at 09:41:11AM -0400, Peter Xu wrote:

> +	/* Choose the alignment */
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE) {
> +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> +						   flags, PUD_SIZE, 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (phys_len >= PMD_SIZE) {
> +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> +						   flags, PMD_SIZE, 0);
> +		if (ret)
> +			return ret;
> +	}

Hurm, we have contiguous pages now, so PMD_SIZE is not so great, eg on
4k ARM with we can have a 16*2M=32MB contiguity, and 16k ARM uses
contiguity to get a 32*16k=1GB option.

Forcing to only align to the PMD or PUD seems suboptimal..

> +fallback:
> +	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);

Why not put this into mm_get_unmapped_area_vmflags() and get rid of
thp_get_unmapped_area_vmflags() too?

Is there any reason the caller should have to do a retry?

Jason

