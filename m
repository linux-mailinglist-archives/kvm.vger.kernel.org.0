Return-Path: <kvm+bounces-38846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1516A3F2AB
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 12:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D0147010D9
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 11:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC45208979;
	Fri, 21 Feb 2025 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g9bTJstq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A820F1EB9FD;
	Fri, 21 Feb 2025 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740135970; cv=fail; b=CA7XIfULyizrgpMsl1QsNfc61puURfmEJl0kMZoCilNS6eyLSCMuZ2z+mdgRNW/BawpDyFgnYwSSqXjTkXXb6e4nvul8o0Fl0qHMnA2fsDxBd6GsRCwdyqgb5BqC5WJy6/9dsnomjQdOiwKSRoBKVxAsrbfnIyvUKMo/rWo0wqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740135970; c=relaxed/simple;
	bh=yceoMkv9yQX5SL23+BehHFf5VDm/V+q/99dVWHqYXY8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mP9uWwxsbUnMusNOtRNWRcfNNIkemS6NMpgzLY0Gw70RgpK02UDiahjGV892zh/ebHnMNMcwaJmMDD7SGmN3NFJbgGj7rVGS6JY3pgi0+dzcgeTSMLm5PYpDsFZIfH1BfuEkZO/QxRAml/HucNtOLBLFyAADE5gNHk1jJHR60Fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g9bTJstq; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740135968; x=1771671968;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=yceoMkv9yQX5SL23+BehHFf5VDm/V+q/99dVWHqYXY8=;
  b=g9bTJstqmtOu0Y4t2oPmMto6DpK0ClTbZiAeHemdXexJXevKVdX7S7ts
   dn/2H65AlexQpiJKefJ3GpDoYauF81Zb/C9MPkTQGwCyGbLGiGHBfTOmp
   VGBB0ByWW6N2MF0de6s12k8sBPO4obenFShfoVO+5L2HwCIkHMs9I03qH
   JBM9vkgGbBP/RNE5xAljOEzioDZQxtMGTmd1qn5f4Y63hxVGp+0AfNFUG
   ACagNS2Ike+SNTpYMf3GWMldVTeMd0y8O1uA8x1N4Rrpad0TcwF4rYZOv
   lTVYWBP8jz+7lqTFLiSR8plfjW831gZWUPfQTKMHATYoW+Cre7iQoony4
   Q==;
X-CSE-ConnectionGUID: 8LOXWjOMTCitfL2SdjQ3Qg==
X-CSE-MsgGUID: uQA6no8HSKOkgAGriIqqVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="44596846"
X-IronPort-AV: E=Sophos;i="6.13,304,1732608000"; 
   d="scan'208";a="44596846"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 03:06:08 -0800
X-CSE-ConnectionGUID: MYJBhGz5Tw2Wr5EUPlyRcA==
X-CSE-MsgGUID: H9nhZG5fTgyqE5nClvcsww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,304,1732608000"; 
   d="scan'208";a="138559621"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Feb 2025 03:06:07 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 21 Feb 2025 03:06:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 21 Feb 2025 03:06:07 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 21 Feb 2025 03:06:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yncOex2vjSbG83rTeRipfHxITA+PsrkIzDPmKpwf3hilnAmUWseiw9muU8gxfNke7a7612nt+gm2zc8+Mz4MmnzvonRH7dJ00eSB3HEdgxbNVNnDCDYLw7s7Yk0yzoKens7lDZM8u794CyG95FkKL5pOwGRO4+RTSGoYyvB+c4IaV9LT35pP5uXNePpMW2/Ufq9U4j2YoYIbirEQTYzBe9Eot8xxn/fHkksNLzcx+ILXTjefzFlJA2YyBrKA14U0KLOACZYd3r2wxSJV+0H/tsHto90WRAzGgNqKGq1sG9g5/Chs6vmbHACfw5eGMCZT6RbmrMl2yX9IFXEgSu16Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVyZN7WQe8JzfY8+gUhrGvV0Mdm+f9QIxhujQU4kCjk=;
 b=obcRVMqPw/9qgjiiz1kyGlLFfWFT7ENiL6s0m3y2MxLodfkWuWYXFQd33SZcSrvCcxjaet9DwP/3m1FVJc66zX8hK1Hz4g2shXISP7FQ+/F0GSMlp34GpGt5JdIQiWWaJzktxFcNWYxwmRt0myLRdvi/XYDmZd4S2LLH+YTIptfdUE/KKZGPx5VU41arJO+GegAuwqzCX60WL6fGw7x4gLAN7gc7EXCxb5zMX7yxIqqP5m6FWLocNbuMzkNrYpbaSPEA5wdoCd0cFhOosB4jQY7Ef8jDGGm1mj0C+a6ckEvttsAEeS0WqPwWWzpskPtEw8TituPe0L7gJlZsOoFb4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5132.namprd11.prod.outlook.com (2603:10b6:806:11a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Fri, 21 Feb
 2025 11:05:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 11:05:23 +0000
Date: Fri, 21 Feb 2025 19:04:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Tony Lindgren
	<tony.lindgren@linux.intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
Message-ID: <Z7hdqCqOLJWcR71K@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
 <20250220170604.2279312-21-pbonzini@redhat.com>
 <Z7fO9gqzgaETeMYB@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z7fO9gqzgaETeMYB@google.com>
X-ClientProxiedBy: SG2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::15)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: c73856fb-f9ec-4ae3-440d-08dd5267a357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gEuJ2is3b5f2Z8ThO1BON+tPYKa7MjXU8PiAGkSDm9wPxN3FcFcSh15HH5rD?=
 =?us-ascii?Q?pOHYcNs/6+pwAI2Hia+HqoYQ2moyNyjlERtOWh7EoQwELhJFE5lvOdHrcjK9?=
 =?us-ascii?Q?ZwHVDVYOMkD6cBsMHKNAW48JhexZXjarXDgcGbWwSgSoI2KigKmp4eIEK5Sy?=
 =?us-ascii?Q?n9OTSvlZFCPN3o+u0nUd/suSNvRHPFV1VGSzCjkRE2/yYavu6VjKQJZigTYw?=
 =?us-ascii?Q?K2YeSUzGyl8+lX8zU+cyNuO1Lb5q6eCf6DwjVsC0LBLYDr4y/6MBBAGpm23b?=
 =?us-ascii?Q?2Uu5iM562M3mOFA6WEywmXWa0rSJA4WmFUVcOz+lcuS8yp/1q9zWdkRl21rU?=
 =?us-ascii?Q?3xuEHEu4Q741xwG3HeDchu6f7tU06rBKu29l7u/xs4b4sEd9Nfnac0j4ogpY?=
 =?us-ascii?Q?d4th6VlRFHtyyhp9FSEIVJV05BHKT5gwxUffVO9n6BoSdPHSHP2ZQmIE/T1d?=
 =?us-ascii?Q?gIlkpS6OegVlpeRn+ON2KqNuHbhCNuVF0ledxJOt2tQsGaDUo9CXYZehLUZP?=
 =?us-ascii?Q?QJbP3QhFfzBjCYxfw4CHGBLjopiLySKSn6eqPsmf0BXk3DlMeI2lPtww0n9J?=
 =?us-ascii?Q?yshU/xOfgOsnvVuvf864xvBqZmGFOhAhrThl+O5REYEph0nL14m76pK5MVBD?=
 =?us-ascii?Q?7abyUK977kqqG36CwDRYAc+Vz2C7JH1M+N3GzFZl8XfpqidyFF4pFyqwj2u3?=
 =?us-ascii?Q?O52c+CR3PHyiicdvjNWDK4W2OFdgJlRgnkf5Kn6RDnmHftB+YhLmGlMas4Qd?=
 =?us-ascii?Q?OqTiR0mEKwVD9lOt5oZiHLERHejDnbarIVzx/UgiNoAAGkXNBQ+FxJtPRu2v?=
 =?us-ascii?Q?kRbiFjrzyXvhR3dr+PTYprRXMdJ2nxpWWY2zZ4CTE0M0jI64Ya7XmPKQgJHu?=
 =?us-ascii?Q?IDJ1aCtqykE3hLbmCypadx8w0pYZgvTtTP/clxC0ruyZf+0fojfh0dbOC6P4?=
 =?us-ascii?Q?bItKQU+R/PCExF+V3ZzZKZ2/aX+8kE8q0OWQP2OEAyuGMxCuypKfsTyBtQbK?=
 =?us-ascii?Q?Bj87atci1aCm8RkpFCun+R+Wym8/GudX518XzG16a5PJf/pQfMM1D4crpIWa?=
 =?us-ascii?Q?eoqVlr4BMyEmDwOVi4usfGqMAK124zyRZIEwbJTLD91EHp5UCF+D/l7O6b0H?=
 =?us-ascii?Q?um/TssGZhNnpjaOGZ5fCZrC0/Y08iPYKfvrZJefjG1fmyIhzKjoLhQ/egVRC?=
 =?us-ascii?Q?ZcqjcL94J7+2rc/V1lvpKqzDeUcNbP8Hj439yxwUNDteNJDD99rXVbE5kz8S?=
 =?us-ascii?Q?cwiD+AAcQlWA22/jUSh23uKH0D3Hn0ENapdGpi4ps9W6cOGDjkHzX9VpW/JG?=
 =?us-ascii?Q?7d+cnA8j3gV3yy4sXnhZx5TAg5kp8C3J4e82ZSkegBkvSfoQkBKONf61Jqtq?=
 =?us-ascii?Q?o4x+mF5Fhs/Q7GVxFCE6vPl2XyZBTvngbCeiaBqpfpRZhoBGKw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+wXRDczH3R0Mq/r6uL5KwejyIyBbBu0l5RC3rmpO54xyFobt95rn8VNtKwQR?=
 =?us-ascii?Q?IfuLqnDVgB1Fqcd040W0tYjpjAGwdQ/9IDLyYTe4oVYX2P3x6ls+IAvLbF7T?=
 =?us-ascii?Q?ZcLczwuXndgUetK++j2use13i4KacGjiPEDAJABit1SXYER/IyMnItC5H7qu?=
 =?us-ascii?Q?RRE2w2GjCw9o17RDUL7b84jTQS3Ihkpk1ZGq+m3ugXBt4xRMDO04iPQ+5aez?=
 =?us-ascii?Q?H5QM5s0ZRDB7uhM2EYF4VhI3fDNecI7mX7Mua9/5nJVRl3Lxp/koUTheiYoJ?=
 =?us-ascii?Q?jK6joBTBzlO/nkuIen0DWDSBgtkU0pKQNCofwQt3yWpODTW8wAQmqL/7hMW+?=
 =?us-ascii?Q?CCwQW5UVBZUFTUNxRaFwgD4ImAm9vrYF98PdVqLrF8ZNrJ2hxx9E6LXl6iq6?=
 =?us-ascii?Q?iOY2u3pBijRrJfaXWGGPPQMn9pkW9eG2NTbw7ZAo6fkoZW2sVZnO5RM+PDbh?=
 =?us-ascii?Q?Y95lhv0DcHZWeZvKK2bxZsZYFD8RDIh9w2RUKDHd5l/w19pisldhZgzN6bfP?=
 =?us-ascii?Q?1S/XJBFwc1hg7OTqcwEUM9/xUh3zYFOqNHQYdAvq1aX9drrHs1axSRNnQ2YS?=
 =?us-ascii?Q?vRiuvqQ7fbo5S0bnKxdElhV9p79P8OfEl4H8B7zL9U0rxdqoE23WBVDQklCn?=
 =?us-ascii?Q?Cgg+LwMHbNImACnzqeBTpgutI/osR96mw3mA7Vlb2GMnstQ3U7HtIIr5S9l+?=
 =?us-ascii?Q?QESpdaGoZIss91UZUtTsxM7YISVYw1NRAI9kRG+ynclxAmN5QfEwvOPhYk0o?=
 =?us-ascii?Q?2bBD1xISyPcR6bTFg9q46wOXjWzcMRMR5Idsm0ojfNFyQ0Jqj4d1cnUz+Vhy?=
 =?us-ascii?Q?cYIFQx5NCNLo/5/YNJkMvAo1ROGYBfH9NiEdYzxB2NgYPy+B5Mx44Iamcsu9?=
 =?us-ascii?Q?D3ifwoq2w65P8B/hXxyKyvJi+RV00jxnGgWJda0UNV4JkW1UGR1Zl8sJvblt?=
 =?us-ascii?Q?HB7CEK7d40zfO9TUB6o0GkR7uzuWS5+vOdD0FTJYZ72jys5vVN3xc26MqWI0?=
 =?us-ascii?Q?EE7IcMR2KuXlx8wrM/hTH2wg1BCLmnp3emvnMfq9N/rFv2vkfAXciF5q8fos?=
 =?us-ascii?Q?ADrB3Q7rnbxfJChoPxG3Uk5nfpQlAf8noLNYwfHxlaMme3konf2z3ImXOTIF?=
 =?us-ascii?Q?2s6LfjIn1CTHnjIdNaE4FrG/IG+8gr8VqwW+xgAJ0Lw+/QdZiPAlR43WPnmx?=
 =?us-ascii?Q?CBDtWilc1Mg9jtEoi6h+njnrKH4yqMeMpffHYCF1IO2ZCHN1IdQg952D+0pd?=
 =?us-ascii?Q?nZNxKPNWtw9VKHF9InOzNFmiqoGNOEj/M1o9jqp51vTdJyexBIt96YxEzHRn?=
 =?us-ascii?Q?IaNVtlIh3611VoqGHZht7GPzj7tmU6fGzqZP4PUvBu/ZsMUnkdrifMjeoJtJ?=
 =?us-ascii?Q?Ag7VMgAGqvfyUDw1gyHL0G38kRyi/jkHC+YbspqV8kjdGQXqHbbv5zVrShqA?=
 =?us-ascii?Q?aadbsIbs3XismMqkfXenvxV8j5KXNcReJWrxj8tBVl1IToAmfn3bt4YWXj5O?=
 =?us-ascii?Q?1u/GKNR9J8VE53pr/tUcSaIYZipzFu1Q5j3sDXOYS4FosewY0euZ9CFGIFxe?=
 =?us-ascii?Q?CGIoSvMP6hL5vHfekQ0I51LxGtOH2R2RWHrmuEpj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c73856fb-f9ec-4ae3-440d-08dd5267a357
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 11:05:23.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HygAmfYGlfhsOadXHU/6SNQOBvNzD3Y3+wN0PCPCECject69I1/Hn13ZVNN9W1nYm/9diII+OvjUUsjdsnvUpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5132
X-OriginatorOrg: intel.com

On Thu, Feb 20, 2025 at 04:55:18PM -0800, Sean Christopherson wrote:
> TL;DR: Please don't merge this patch to kvm/next or kvm/queue.
> 
> On Thu, Feb 20, 2025, Paolo Bonzini wrote:
> > @@ -72,8 +94,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.has_emulated_msr = vmx_has_emulated_msr,
> >  
> >  	.vm_size = sizeof(struct kvm_vmx),
> > -	.vm_init = vmx_vm_init,
> > -	.vm_destroy = vmx_vm_destroy,
> > +
> > +	.vm_init = vt_vm_init,
> > +	.vm_destroy = vt_vm_destroy,
> > +	.vm_free = vt_vm_free,
> >  
> >  	.vcpu_precreate = vmx_vcpu_precreate,
> >  	.vcpu_create = vmx_vcpu_create,
> 
> ...
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 374d89e6663f..e0b9b845df58 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12884,6 +12884,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >  	kvm_page_track_cleanup(kvm);
> >  	kvm_xen_destroy_vm(kvm);
> >  	kvm_hv_destroy_vm(kvm);
> > +	static_call_cond(kvm_x86_vm_free)(kvm);
> >  }
> 
> Sorry to throw a wrench in things, but I have a fix that I want to send for 6.14[1],
> i.e. before this code, and to land that fix I need/want to destroy vCPUs before
> calling kvm_x86_ops.vm_destroy().  *sigh*
> 
> The underlying issue is that both nVMX and nSVM suck and access all manner of VM-wide
> state when destroying a vCPU that is currently in nested guest mode, and I want
> to fix the most pressing issue of destroying vCPUs at a random time once and for
> all.  nVMX and nSVM also need to be cleaned up to not access so much darn state,
> but I'm worried that "fixing" the nested cases will only whack the biggest mole.
> 
> Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was called")
> papered over an AVIC case, but there are issues, e.g. with the MSR filters[2],
> and the NULL pointer deref that's blocking the aforementioned fix is a nVMX access
> to the PIC.
> 
> I haven't fully tested destroying vCPUs before calling vm_destroy(), but I can't
> see anything in vmx_vm_destroy() or svm_vm_destroy() that expects to run while
> vCPUs are still alive.  If anything, it's opposite, e.g. freeing VMX's IPIv PID
> table before vCPUs are destroyed is blatantly unsafe.
Is it possible to simply move the code like freeing PID table from
vmx_vm_destroy() to static_call_cond(kvm_x86_vm_free)(kvm) ?

> 
> The good news is, I think it'll lead to a better approach (and naming).  KVM already
> frees MMU state before vCPU state, because while MMUs are largely VM-scoped, all
> of the common MMU state needs to be freed before any one vCPU is freed.
> 
> And so my plan is to carved out a kvm_destroy_mmus() helper, which can then call
> the TDX hook to release/reclaim the HKID, which I assume needs to be done after
> KVM's general MMU destruction, but before vCPUs are freed.
> 
> I'll make sure to Cc y'all on the series (typing and testing furiously to try and
> get it out asap).  But to try and avoid posting code that's not usable for TDX,
> will this work?
> 
> static void kvm_destroy_mmus(struct kvm *kvm)
> {
> 	struct kvm_vcpu *vcpu;
> 	unsigned long i;
> 
> 	if (current->mm == kvm->mm) {
> 		/*
> 		 * Free memory regions allocated on behalf of userspace,
> 		 * unless the memory map has changed due to process exit
> 		 * or fd copying.
> 		 */
> 		mutex_lock(&kvm->slots_lock);
> 		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> 					0, 0);
> 		__x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
> 					0, 0);
> 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
> 		mutex_unlock(&kvm->slots_lock);
> 	}
> 
> 	kvm_for_each_vcpu(i, vcpu, kvm) {
> 		kvm_clear_async_pf_completion_queue(vcpu);
> 		kvm_unload_vcpu_mmu(vcpu);
> 	}
> 
> 	kvm_x86_call(mmu_destroy)(kvm);
I suppose this will hook tdx_mmu_release_hkid() ?

> }
> 
> void kvm_arch_pre_destroy_vm(struct kvm *kvm)
> {
> 	kvm_mmu_pre_destroy_vm(kvm);
> }
> 
> void kvm_arch_destroy_vm(struct kvm *kvm)
> {
> 	/*
> 	 * WARNING!  MMUs must be destroyed before vCPUs, and vCPUs must be
> 	 * destroyed before any VM state.  Most MMU state is VM-wide, but is
> 	 * tracked per-vCPU, and so must be unloaded/freed in its entirety
> 	 * before any one vCPU is destroyed.  For all other VM state, vCPUs
> 	 * expect to be able to access VM state until the vCPU is freed.
> 	 */
> 	kvm_destroy_mmus(kvm);
> 	kvm_destroy_vcpus(kvm);
> 	kvm_x86_call(vm_destroy)(kvm);
> 
> 	...
> }
> 
> [1] https://lore.kernel.org/all/Z66RC673dzlq2YuA@google.com
> [2] https://lore.kernel.org/all/20240703175618.2304869-2-aaronlewis@google.com

