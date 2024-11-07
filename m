Return-Path: <kvm+bounces-31051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 834ED9BFC96
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 03:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3921B21C98
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 02:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577E944C94;
	Thu,  7 Nov 2024 02:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DFjELzMg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF1222338;
	Thu,  7 Nov 2024 02:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730946914; cv=fail; b=CA7HgmeH6wiXyOVM0KBGFV0zTgeOImqPBqqwpqX4xUaJDS3DitluyeYFnSNrtZWr7xpH1r/74lYslUhLEPM7qi1q1jhk0gI0qafUSLIWCL618BhycSZTqTLhetIEvNHYw3DF3bWrQXgmz6Hw9EF/jlP007+B5cNeVdTzzkK6uwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730946914; c=relaxed/simple;
	bh=+7g3+tgbr7eHhNwo8bNmD35CojMKqgH98FDE29LJVK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BNyJElL+il71nLUArw33jDvn/ffFj7UMAg6N+qxMKUb1qLKZMBCxjdlmAQJm7GDDigq8xiV/TKOI1QIARPny//qLqpclsFleMs6ZhwNvx8oTZrQr7KIVZ5LKCtixkVUfhDVyK9GGlFko566wb4YIbLBACt8EIEn0CuE3q9ozT+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DFjELzMg; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJHzzo9CZQ4lR0wJJhoyv4ciwzSyX9LQVdspLGK8DG/JeK5nnqS43f3h49xpJL7dxNDi6FXOsdKUeGdiuC3EWrlPErqxYc7kDqOMOBOPwnY2jDWcl/Oy43bxnfP6kS3EemVB2N5mbQwLMrCI9qSc8OEwFyRNeubDDTJnTkcDSyCTSlHp6mWA+VdrMJV8ON3toDklxTXAII9tisql5sSSLNGScidoaqfoq5q4GR0n//Fvxcvvw+7OXwM/CymfKKyvW+SRWQR+e35AWo3R5GYA85heuaMw56hXaLCnkOxqK86uJJNw8jPB9gCcjSGE9wrnIMfUCU7Ftz09R49pzF9kUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4/cTM18zF7Tj52PepiTZVzSOZ4qRJx258zHdVlVRTo=;
 b=J0lqnxQ5DL0TinZQjhwCSvB77YQjTi2Vw8wyqOyG/fwGW4k20St+huc3PSBONSXDViEc9X4KXTQWdlt9CUMOqVSc3Zw5BQ1t9jsta4jrNiWhBPhBmo69N1kEXhKh5KHU+nVsz04/OJlQ77gN1hzKYCCuzDmlu3U+W/75Vatc7tCzJy03k1lBVgubHJhc0HxbBUqjjZDwpLF9TLxJ3C/wpJQLuWVyvzr960Vvd4sMpH7D0imXZ/pnC6iKP7p0DlE2JAS3Jqk0gP5Q/GUn5E1LgKYV3NB27Ek8EDQ/6+Ggsb6ppugvfy6ijuQCwhsrxLPNfBnhroC2PfGIMX2WymY2sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4/cTM18zF7Tj52PepiTZVzSOZ4qRJx258zHdVlVRTo=;
 b=DFjELzMgYBEWSt0S8kXZ3/gELyK9cdTA3glc1BN58AFYRMyLgdcGlTsyMugKls+TXrXZV05svUQsLiEc64paPZT9vqirX2LBg5MJRybbIYdirrGKtBdoP6V+pTSZTotW3/ozx7tIkQdza69gKvUs6VmJFdSVF3WUFCj5rwQtte89mQ+REVvzu65HPIoSw6qs1aeV30QlOXqVdZHFph4x4+hgkp/FdDpcQCcj8CSe42ZhmQTcUXyhISoxMdFp7I72KYtEt0YD2AmfXfmhefauHZ9QGGgwDicQt7V6dfZegu9iNNQbpVf5nAC5IQZa3dDs6+dSjiNe8/bM0ErWeM8OaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6034.namprd12.prod.outlook.com (2603:10b6:930:2e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 02:35:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 02:35:08 +0000
Date: Wed, 6 Nov 2024 22:35:06 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <20241107023506.GC520535@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck>
 <20241104124102.GX10193@nvidia.com>
 <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
 <20241106180531.GA520535@nvidia.com>
 <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
X-ClientProxiedBy: BLAPR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:208:32d::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6034:EE_
X-MS-Office365-Filtering-Correlation-Id: 660a7ea3-b932-4d5e-30ca-08dcfed4cb73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M/KT3p1wPcLfAineckpu3rW25pDxMjHQJ6IxKza3opzvHEXkltfmXKM95ON/?=
 =?us-ascii?Q?OidmFJQa/+mDgvRb+PYvyD0Dq7D0pZbkfWP9pBi53cFy8GAtyabgsG1w/Z5/?=
 =?us-ascii?Q?SxxEg/Gn1Xbtv3vK6ZY2O7kdBvocWBCaUI1sKymIWA84FnpZQLlcxYHAjXuj?=
 =?us-ascii?Q?KJaTC5nHhwRYfm7gWbuA8LuhmBeKaY3oa5r31bXA+Q37ym+6qEk6LNt6JzNG?=
 =?us-ascii?Q?R3WP/1Mw8qkpPzSOC0x8iv3vGIarrwokC5FzC4b37vYZskfNepIw3pwai+eR?=
 =?us-ascii?Q?d2+iX3calB1LvwWpk89kHDitK8RP5TSTHzphAg4Wy3OJ+ude4VL8rX7H2iqw?=
 =?us-ascii?Q?M3wmhU8JZcxpCSylzyqr5loSuOIhDfvVsGtLP0YEfeBLAGjZi9Jhuod/M9Hh?=
 =?us-ascii?Q?kqxyGID0KoZc/WzduRO4ZOm++3sP4LIufHDBwfkLGNFEE4dGU3Zid54W8euD?=
 =?us-ascii?Q?ptlHNi5f3bx1nhL4VyjXBMvfoaiPgDPPT86Uky+23IyRzRu+5AuhKLpZ9PVU?=
 =?us-ascii?Q?AGnqCt4TEhq1Ill5YLbMUbRFNrBYtNWNtkGkJRd/no5QCQxJMTIaczr4hb9y?=
 =?us-ascii?Q?6b2KI+tdDfEdim4U2eQpxznGUt8JwfAO1f1GKJTOtbqXEEwli0AyhjBhOiTq?=
 =?us-ascii?Q?Wan3BmQNUuqc0zJT2s4Zm8Cnk9mZifJsHXBggl/YqWNXBuUoTvMrcBrmmuX+?=
 =?us-ascii?Q?elW4Jwbzn68piHz//7Rug9F8y7RZ9enE/Kv00/1JLed5dh5T5/lk8S/WWUJq?=
 =?us-ascii?Q?1paqInL+jz4NgfBu3zbv+4wClhyTfAuNb5bKAA8IGA+I98n/RkUXLSJAIn5A?=
 =?us-ascii?Q?ns9W/q30p93dku9jJgho6ROer/BMJ+IpOc4Yo4NCXb6d9w5FTwNPvqBBYnyK?=
 =?us-ascii?Q?oEEOr9IienAJl/qMQC78jUh/DaEwravP1EN++OT3LGcazkBXfdAsL/XJ1Pmh?=
 =?us-ascii?Q?+HOo2lJOV6O0jI7ERAn9lxmVDqW7muYv37IXIAh93CO7I21rFvn5Pyq1AKHs?=
 =?us-ascii?Q?0VM7nXufvVtYKcZqZptXIzH9fS2L/R47ulC/PSFKwbqmReoWKk/xVgXZWQNh?=
 =?us-ascii?Q?eAdOwC4rr9xIN7K9qAoGuKb7JUi3hV4dy03YkkA0bv+ixGOT8OE9zHSaWkx5?=
 =?us-ascii?Q?a9YBOJev0iyUdNAJoKraeIzXbQ3GuZ0p1bhmBA7B6CkngkM1hj6+tSOaqaP5?=
 =?us-ascii?Q?CzttPyz6/nLoI+wHEnj/derN0eATfdVeBMqubIMf86FaI6N7HZBPFR68nKrG?=
 =?us-ascii?Q?o9BUUmiW4Xi2YxB2WKK9MHLlklNvqGnL86mxkkKC5dTxiUoHHTc7YBRLaPI0?=
 =?us-ascii?Q?aRU4P4LTPEYyMrshJMR/f0GG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d7SviTQEtXitNW3n+UBSwEj53avW8HRT6G6GlGHhqMhVZXDggJs5ldLUirP/?=
 =?us-ascii?Q?kRrvuOOio12L++9dl+A6VzQjNQAKFnU6NsZdnJx4/1uVFjOXa8rTP62hWxzL?=
 =?us-ascii?Q?93BFYyFyaHK0EnzEL5p+5UJTWDOjojTBtlNAPPjlE8K7bmGpbLVT46p5CBEn?=
 =?us-ascii?Q?pS2RGFMHsR59mvqisMdmF5IAjMSl1dp4TO9ogdohncByuEfVJ+rOyDVleZ3+?=
 =?us-ascii?Q?SCELYQl/cxpVaoydbApuLEG9HrLkRETzgxjAMR1lxmh4aELTp9JOw9Qwh50T?=
 =?us-ascii?Q?uiN4tC2u4CagNkswQJyh0R+RGzvWfOQ13R1xy9qNgh06gaTOq0r2ozoy3jR5?=
 =?us-ascii?Q?7ZraYF8CZVQhnApbXhWgbbDsF8R77ojQqUMo2PlM7pNl3/qFrPaP3qgqk20Q?=
 =?us-ascii?Q?wW+ztRQxZ21s//N0rXyhZXczVDxoIwQ6jdmIpCkZg4t/cWtFWgMd7LIhkMQY?=
 =?us-ascii?Q?lyF0GJPmegAd8L0873uOnmHNT3VvBwJEUprXh7Tl9HnbkFhPPFSZ4jrMuHZi?=
 =?us-ascii?Q?G94yM/DSYmALL0qB0dZX4yubs3imhAeEpmryOr/hUehJm2RGjVR9FzO2XPl6?=
 =?us-ascii?Q?g5ZLK9lGPzmFF6enJA17FIRGOu1dwP9i2GUdMj/8pzqObppSBaXiiE1a5ewV?=
 =?us-ascii?Q?R/apudDe8zH5N4ygDSGrl0JmztVNs6hbJIDI52vr6bElJSmI6EV/R5ZGrnGV?=
 =?us-ascii?Q?AHNxizGsxPYFvPehpHt3wm6ddEp/Qodf6LG/rWeufuV7Ha6B3NFDx8EwNp7v?=
 =?us-ascii?Q?de7uDOGbTrcFFN/fT+zIhj82EEF1r67eCzZd5Hf/k3NPtriYgfED0kCi3BAM?=
 =?us-ascii?Q?EvS5Crh6g4taed36ptbxHkjTVV9grdVuJNpo0FpvePf95dKFpCavAjjS4vEk?=
 =?us-ascii?Q?lBiQD8ZwbjHXYZYCWRE0TalZewK6Ht2qVPnPmi03KFf8juMEyUrIMFwABCsE?=
 =?us-ascii?Q?EgFy6WKcY3NYZl8FKoIoPA7XPgwGiwE4fAMDds5GnYd/bPP8HlIS49S8xgq8?=
 =?us-ascii?Q?aepULOw4stcqiaDunQ1OaBfAD9D+YeOXnsjDAqTm5cgL9tnXnT+chJldqm/i?=
 =?us-ascii?Q?vRdSiiXkkGSN2BhyXuT/yP2o/LUg3/MsTWlF2k2GHZnADkt/BwImZr9chLST?=
 =?us-ascii?Q?az+XHQuOwhGHpyxaqjl4CG2I61X2pD07Cpu2Bfpf8gJO+c7kBrZ6Ngp8xFOz?=
 =?us-ascii?Q?CMTxhBMerMqEg5l0TNVcLPs8YR0S69GxDTqzFpE0aBGjAw8llasbnK4arKLt?=
 =?us-ascii?Q?eyc9cJTpBwUXhCe5oCYryENYiR90qTg7jrDeqWKzxgykBF0/xYI8Dp6naqTG?=
 =?us-ascii?Q?mHct2PkG5D4BTiRig6CVWpYlGsV7iTuOJC8oCeEXGRWhYQD2vDkLkxe+NUNg?=
 =?us-ascii?Q?6slnAHIfXk8aQCcB0jbdbggg8b2FwnpgLQm2iPqVO/9WLyaQDCwnO/YjCm90?=
 =?us-ascii?Q?i0F41Xeuzl7Z2c/6ZP7AjIlPzZdjVEPY09WVFUQsa4zY7g50AD0ZYvqh9/D8?=
 =?us-ascii?Q?xwCF9ffVJuJIoPlmpeBWxCRrAp1w6B8Te7y9Kv7FTKUO/nXLA3t8rXAO/Xlw?=
 =?us-ascii?Q?3fIXrbRcPivHi4Jp2mM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660a7ea3-b932-4d5e-30ca-08dcfed4cb73
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 02:35:08.1720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dlm05OvxGA8hXodRWrSZpPof+kLySC6Tj4EGVT9TaFARvcpESuYIvHd4mh8DDHRn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6034

On Wed, Nov 06, 2024 at 09:05:26PM +0000, Robin Murphy wrote:
> > Each future capability we want to enable at the VMM needs an analysis:
> > 
> >   1) Does it require kernel SW changes, ie like BTM? Then it needs a
> >      kernel_capabilities bit to say the kernel SW exists
> >   2) Does it require data from ACPI/DT/etc? Then it needs a
> >      kernel_capabilities bit
> >   3) Does it need to be "turned on" per VM, ie with a VMS enablement?
> >      Then it needs a new request flag in ALLOC_VIOMMU
> >   4) Otherwise it can be read directly from the idr[] array
> > 
> > This is why the comment above is so stern that the VMM "should only
> > forward bits that it knows it can support".
> 
> So... you're saying this patch is in fact broken, or at least uselessly
> incomplete, since VMMs aren't allowed to emulate a vSMMU at all without
> first consulting some other interface which does not exist? Great.

That is too far, there is nothing fundamentally broken here.

This does not enable every SMMU feature in the architecture. It
implements a basic baseline and no more. The VMMs are only permitted
to read bits in that baseline. VMMs that want to go beyond that have
to go through the 4 steps above.

Fundamentally all we are arguing about here is if bits the VMM
shouldn't even read should be forced to zero by the kernel.

If the bits are forced to zero then perhaps they could be used as a
future SW feature negotiation, and maybe that would be better, or
maybe not. See below about BTM for a counter example.

I agree the kdoc does not describe what the baseline actually is.

> We know about that in the kernel, but all a VMM sees is
> iommu_hw_info_arm_smmuv3.idr[0] indicating HTTU=2. If it is "broken" to take
> the only information available at face value, assume HTTU is available, and
> reflect that in a vSMMU interface, then what is the correct thing to do,
> other than to not dare emulate a vSMMU at all, in fear of a sternly worded
> comment?

These patches support a baseline feature set. They do not support the
entire SMMU architecture. They do not support vHTTU.

Things are going step by step because this is a huge project. HTTU is
not in the baseline, so it is definitely wrong for any VMM working on
these patches to advertise support to the VM! The VMM *MUST* ignore
such bits in the IDR report.

The correct thing is the 4 steps I outlined above. When a VMM author
wants to go beyond the baseline they have to determine what kernel and
VMM software is required and implement the missing parts.

> Your tautology still does not offer any reasoning against doing the logical
> thing and following the same basic pattern: the kernel uses the ID register
> mechanism itself to advertise the set of features it's able/willing to
> support, by sanitising the values it offers to the VMM, combining the
> notions of hardware and kernel support where the distinction is irrelevant
> anyway.

Even with your plan the VMM can not pass the kernel's IDR register
into the VM unprotected. It must always sanitize it against the
features that the VMM supports.

Let's consider vBTM support. This requires kernel support to enable
the global BTM register *AND* a new VMM ioctl flow with iommufd to
link to KVM's VMID.

You are suggesting that the old kernel should wire IDR BTM to 0 and
the new kernel will set it to 1. However the VMM cannot just forward
this bit to the VM! A old VMM that does not do the KVM flow does NOT
support BTM.

All VMM's must mask the BTM bit from day 0, or we can never set it to
1 in a future kernel. Which is exactly the same plan as this patch!

> You should take "We discussed this already"
> as more of a clue to yourself than to me - if 4 different people have all
> said the exact same thing in so many words, perhaps there's something in
> it...

And all seemed to agree it was not a big deal after the discussion.

I think Mostafa was driving in a direction that we break up the IDR
into explicit fields and thus be explicit about what information the
VMM is able to access. This would effectively document and enforce
what the baseline is.

> And in case I need to spell it out with less sarcasm, "we'll get masking
> wrong in the kernel" only implies "we'll get kernel_capabilities wrong in
> the kernel (and elsewhere)",

Less sarcasm and hyperbole would be nice.

> > If you still feel strongly about this please let me know by Friday and
> > I will drop the idr[] array from this cycle. We can continue to
> > discuss a solution for the next cycle.
> 
> It already can't work as-is, 

As above, this is not true.

> I don't see how making it even more broken
> would help. IMO it doesn't seem like a good idea to be merging UAPI at all
> while it's still clearly incomplete and by its own definition unusable.

I agree that removing the idr would make it definitely unusable. There
is quite a bit of essential information in there the VMM
needs. However, the uAPI is extensible so adding a new field in the
next cycle is not breaking.

I'm trying to offer you an olive branch so we can have this discussion
with time instead of urgently at the 11th hour and derailing the
series. This exact topic has been discussed already two months ago,
and is, IMHO, mostly a style choice not an urgent technical matter.

If you have another option we can conclude in the next few days then
I'm happy to hear it.

If we focus only on the baseline functionality Nicolin can come up
with a list of fields and we can write it very explicitly in the kdoc
that the VMM can only read those fields.

I could also reluctantly agree to permanent masking to report only the
above kdoc bits in the kernel. Noting if you want this because you
don't trust the VMM authors to follow an explicit kdoc, then we likely
also cannot ever set some bits to 1. Eg BTM would be permanently 0.

Regards,
Jason

