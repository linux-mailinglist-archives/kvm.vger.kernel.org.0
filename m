Return-Path: <kvm+bounces-39073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50625A431CC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 01:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25ECC3AE9E3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B4B4C8E;
	Tue, 25 Feb 2025 00:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HZTQpbNm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA4DBE46;
	Tue, 25 Feb 2025 00:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740442683; cv=fail; b=Ro6CDUmPsYwZMPoZ6aWmYEoMcrK6ObKQiO+2M92GLVzOPVPZ+JX98166zOEUGyi7SM44SArYhi8dCJYSbjsGBvHQR0lWBanISvkxwu9sS+GHZPVgaBV9JxU5Un9Jni0pTAoxKQ7Al+O3hiDcpbkVlHgiTCJuq2eZO6kldYU8Bow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740442683; c=relaxed/simple;
	bh=hGKxuXWp2wVYAQObOPXgPoHyphDdhEunmQnk470QvH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I9tg826mqitGWT1Am0sL3FnaVp1VGkHVdClixzDjczAV5kFBvyUZl4pRAwheqTibPWsBKQPExes/OuBi0Nhw5VE6mAZa02csu48ITjTRanmN41gFvpblR5wD3KQNsmG6bZFY33wlvAAGXP4GK6l39z3OGW3IY1/UaWBnFL5WiPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HZTQpbNm; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gFAYjwK9Mejc9XOXeKJtkkGlKAZYwtTJ2AE4540YvZ0L4WWPrmz9Nm3q30DsRrGYhFuzGMUOHmjLoy3BCeCqHocPvL/L0N4mHasVUmPtFUJOqJDHNEoidrJhbSDr7xnWloPBDAIkTw7NmpDIBubPFDFFj2cmZj0yFKkP70pbCjOzkj1W+ROnKDtyd1u/yVoa1Ozjl7zZj7/0qmZW14pLr8dATWnNo1jwqqPs1CLbdja5gyCyPF5HZk/C0P+w+uN8uA7Azbb74cC0ZXnuTinEU9qGQ5fLyUBjPIUq2moIhmCXNOCHHOb5jd6APRaozCfuGKj6DBBCqOMghpUum7/IPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0nVy5sjHDhgwoFDW816oCoslQT84AkHw/8wGUu2iCI=;
 b=rqA3CM3M6G/zto1SilYzTBpBgZ7mYj79CG4bQt5dIBk1Tp2q1Px/866FN5U1ORvmQrQwTxqBWKsmQClTZWoEboZUU7XbwHfWoFeO+Y+AWMH6JsNFncexN8MJhVGVxc3onvDXfC1vSd8mPFYOh6y6LTtQyFXoliiR4XyOaoSeKp7HmM8zCCrFQ1P13yN7PHQFV6rwJNVyOMFbClzt291GJ6xh6cbMbtVx1LngKRMxw5BTuRS8oAuTIZZid1tRH5Any3iAk4KnaxCutHtrtECWMvdF5PBRI0M/M3fNt9gJK3qq2aXRPPC/+L/h1WIKUQ2HiEIAOe0O7BEshOcQHwNpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0nVy5sjHDhgwoFDW816oCoslQT84AkHw/8wGUu2iCI=;
 b=HZTQpbNmmODSMoDp5VkueYuN4zXbNtjzlnWmBRxZMfQfJIhN+RhOPmYS4lzcd6YRd11jMU18HpEy/8Nl0oresVEbE5qKxmrlJj266iYa9hdYfEA6Wuf0n9MTeWEMGc+g6vRrLO+evy4j7ggZ7vuceIc3bNskWDCiAjwIWJ+yH7EdL8F0VnZZ95SgBjBOQKZ6FnDG6k1tQGeBe1IlGIHgxvAdcwFqyoEFfYo+0Ge9r6O0Jc1nO050siUCR67+Hb3chjf87e9p8GyklcJVH9YMOoItWXp84SvNtUECG17jrZcsW4VbnLQ6378i8/xdPRiDP5+w+0remVFm+oHcQqj28A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Tue, 25 Feb
 2025 00:17:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 00:17:54 +0000
Date: Mon, 24 Feb 2025 20:17:52 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
	mitchell.augustin@canonical.com, clg@redhat.com,
	willy@infradead.org
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <20250225001752.GL520155@nvidia.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-7-alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218222209.1382449-7-alex.williamson@redhat.com>
X-ClientProxiedBy: YQZPR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4356:EE_
X-MS-Office365-Filtering-Correlation-Id: 23ff2ce3-30f8-4f08-424b-08dd5531d954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RJ09rbvxuWkVW3BzEx2Uv/oKEl9twl7geFTrAya3tGE3ij70GYZtjIGIhQn8?=
 =?us-ascii?Q?cE5MP12VtA7VI/uqEUMKxJ9bGt5SE4yX1/GPoZ/UTiBqT0cZ3CfndQeVAMrx?=
 =?us-ascii?Q?PIT5DXoQw90zcomx0BPv9/Fjlp8glURPXv3N/Ng5CTk9Zw+0mMTPzr/x4kKC?=
 =?us-ascii?Q?s3hU0Q1loxUt6kPxt54Ldy2ZZ7Y7XrWh4qX3BYpuB4fqpc6+p8seu+qyQ24y?=
 =?us-ascii?Q?6MZbu1/Byyy+I9DKDxgxJNNWSLKmrORfhmbsLjQYet5yv8AYVZsU8kHs/gaa?=
 =?us-ascii?Q?ElGgu3LfrgqbFUT05e9ltvzjYsfyHv0vWg4HHgFQe+RX3I8uzxL/gYZ4P50d?=
 =?us-ascii?Q?mvWRjTnj68wNvH31ykl0zv7RmKugD++oa52t5bsOPclZha/ZhceU937Nh+J5?=
 =?us-ascii?Q?4ytndKeBwjtlcO8/bq3eBsX/Z31OzhS9yTO0EmXvXG3oU8YP/0gnWJemVDnX?=
 =?us-ascii?Q?1cgKmuMZxttB4Jvn6LHi13at5/TNUaHVOQ8YxC0FFuTlEFcU3fECBPLj8xiM?=
 =?us-ascii?Q?60DrzrVIePQmeK0MfaNH19J6JtuljglWewJ/9eLBw1U4HIVfiZoSA0NLYD0/?=
 =?us-ascii?Q?yqT3rdh4UbU8ezz9OLHMWfi4h27b8O3CE9lki/6RVlNRUtfSikYHsPpwEoFF?=
 =?us-ascii?Q?p7S+dS1at1iqz3+22WSt2fv4Y4uIQcK6gGQ+q1P23D9F3iR7mgYiMNI10qYy?=
 =?us-ascii?Q?ihYRRbtfAqJoXbmNsrnxSzC6hJ7ofqiy4RZSBFkSYKp6p6cnsrqNqOfi1EPM?=
 =?us-ascii?Q?DyiVfTxshPRRDFcinrfEEgJw3eOdx038lvIWZGgn0iLjp6t2oW41Ebn2fAJ6?=
 =?us-ascii?Q?JY/oLZVI4IWje2SloCfehsWoZWk9AA3bnDFJneh2gnWvO3zCN1W/udSyUEq1?=
 =?us-ascii?Q?FKAtkTeHGoJS20w0Pr1EhrcHB/0ldhPzVmyY/aAi9oZOgZ/T1fWvZoT3uR4J?=
 =?us-ascii?Q?nubUgrSO0+qLSpIoA7wRElPQFmmF42kDZicc1CGBxScAMz/no7/RY81o+xaL?=
 =?us-ascii?Q?vP256KOO9BQxrIqWiyKxD2jpz8l79aq/lBX3V8/FNCbi4c9HtfZgO9CfrhPl?=
 =?us-ascii?Q?clIDLjlnAMsmK8Je6FO9odSrbCXpytxRo24u31XM4ZIHnZlZxRbmBh+9q6C1?=
 =?us-ascii?Q?wOf94x3JGlK3JyKKJkymso6LybsrcxSwI9L8iS4c0OYmT2T82CAdNP5GA0zo?=
 =?us-ascii?Q?8MEK0irpMfC02mfWlq2UhEh+LrOlX09jcaNgCSf5UVdJVs9GGywq+VpD8InE?=
 =?us-ascii?Q?PcU1pGaAKJIn+yRJvqymH7mHnUoi/anp29oidwspyccES3NATsVi5t4v5mdb?=
 =?us-ascii?Q?Rvwrv7SVYfMTVUZlbL5P2tsYRJanh5RnRbKDGoWP0XmJYk3TsfjaMdpQAHA4?=
 =?us-ascii?Q?H05PJvklq95LVVpjSGumYoTKtjWT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gnae9ojqL44SHARwN1lV48X1U/wvrz2rEG1JS4OlJkWbXtKXn/PIQQVFxRAJ?=
 =?us-ascii?Q?U6786u8y05Me2/d4sAvawpE069aWXQkYu1Cf4ARroKteX5t1kIyX1oSaAfA7?=
 =?us-ascii?Q?WPjIQIBuHiwBvmAEIk0KUSq5lsIEoN7FD0tSFxZZyGXa2M4B9EqXzQG2B2dW?=
 =?us-ascii?Q?FJhdbdkTom7ODgQQDO2vw3rn/MHWqxBzcL8uamsjkbVEvN3vi9iQBYu5u01i?=
 =?us-ascii?Q?t9IYcea3Y8Xra6oX65nIiJK/ZkPkMKGc39R2MfmOJXAa4iy/QDh3M7SkHuY+?=
 =?us-ascii?Q?6RVD5A0pDmAGCHNTlB6vioOIUn7L6iDy28jRtZGJS4894iS3++Nitxw7hd5j?=
 =?us-ascii?Q?pBwhw6u3ByLvhXx0gV8RbAdCySgFa9QE8cawwSuaueopgylkX7hLfTmzoSfR?=
 =?us-ascii?Q?6TdLOT3Qb9md3UUa0X1rk5VJ0VTlAp1Vp4MHE91NPulIMHReNt2i7JQXXw+U?=
 =?us-ascii?Q?8Of28TO0ogApm9P1GFW1gy2yuetZJo375z3lQ25dlwZakzhAnYUyVPMxEVg/?=
 =?us-ascii?Q?lVcm7irSBZq1GTbT3NbmT+ZTLIjk4/P2VbVTnrHB+DUBm1zH9c1quOEotOqG?=
 =?us-ascii?Q?6XY//tguVp+9vC21ysfrz6KvqixoGg1gc3az8lmnk31rppel1uSwd6xdXOLu?=
 =?us-ascii?Q?uzuvk0GLDsiZ84zMA8ZCOlETTIeyw15zafz82bi7cGRTkQStAtCaL/B7edps?=
 =?us-ascii?Q?2GG5L6efBLZiFMYPw8DYcoO0+eikjxvKVQBg7vqrk49J8hagHOQlARrCO67d?=
 =?us-ascii?Q?2vwcz4OZCiTyetCmsdRo5eRP/TqxIXZjGOf9O286Fk19YjDUBNkYaCwmA4Py?=
 =?us-ascii?Q?WWHNH8OXuh4F/81IC2Uu9MIzmaj8ezvRsDzXMZZzds8godW6Lk8Tpzu3JL+5?=
 =?us-ascii?Q?cU7NsFdZ8cvernpAWwv6XJxicsZFyg+syteQz0RLoMtt3zSWpfEviGzhgprG?=
 =?us-ascii?Q?8R8ifgpHAiM0wJLP/aQPm1PZvzETqw4YfcZ7FSw8Ara6mZuXAbrNTeABdq1w?=
 =?us-ascii?Q?nXFJ9r6cXE//tRhjyrLrdpU52wo1qLBnl1E1czx2yr+CR0RlUuw3Ohmey61W?=
 =?us-ascii?Q?MZbJkc8jxroLdGiJ9rQ+1sa4IHMd2q3k268756/OXMa7vBpmOS+/nvy4SyBT?=
 =?us-ascii?Q?MrBEukx5XaOTN/wU4WFTCrtFPuxg3LTcTFZZyY2KaTJfeIIiyQJq2xu3PzWF?=
 =?us-ascii?Q?T158q8V6/KQsvvLdOEH7b1sQkzVd1dwQO8RpCZ04SzOIePvFS1gKMk6gBYQD?=
 =?us-ascii?Q?1yAWv9Hto2VJGncCGGxa2UTJb7zji+HUIptD+vYpVVu0HfyG7iVB5s7kfry0?=
 =?us-ascii?Q?NGIebY+Ka6jADWzUs0e3thD+i8enWQnQgcqgaEQmPWlgPz6G9un7QXEJJ5BR?=
 =?us-ascii?Q?IJsqT8U36R+SiIie3pFsDa2hn/cKA2anYp9w4cxm3cgzwfdhY8fqoe42XXay?=
 =?us-ascii?Q?3jWxGY2UpcbuVvQo2rSTsEnCgijMNGKdkQU4BJzjYWVdHb7h2/pSAFkw8V5l?=
 =?us-ascii?Q?bsA0Ms4dgfHWuHZHka4GTAbJDjXi6SobTpCBXdrHaYRJ2hAlVMvIWmnJ6uqV?=
 =?us-ascii?Q?a0UlrAre/lyHYuxJt8LwKIQ1xPaPoIIez5VtM+6I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ff2ce3-30f8-4f08-424b-08dd5531d954
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:17:54.6326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E643J65opeV0FzQKmeHfC/nhbau2khBPG7i8hS7dQyiE5t+iqT8Pa8LCuKcRpKTC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4356

On Tue, Feb 18, 2025 at 03:22:06PM -0700, Alex Williamson wrote:
> vfio-pci supports huge_fault for PCI MMIO BARs and will insert pud and
> pmd mappings for well aligned mappings.  follow_pfnmap_start() walks the
> page table and therefore knows the page mask of the level where the
> address is found and returns this through follow_pfnmap_args.pgmask.
> Subsequent pfns from this address until the end of the mapping page are
> necessarily consecutive.  Use this information to retrieve a range of
> pfnmap pfns in a single pass.
> 
> With optimal mappings and alignment on systems with 1GB pud and 4KB
> page size, this reduces iterations for DMA mapping PCI BARs by a
> factor of 256K.  In real world testing, the overhead of iterating
> pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
> sub-millisecond overhead.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

