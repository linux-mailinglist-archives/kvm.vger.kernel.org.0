Return-Path: <kvm+bounces-24129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82835951A5D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B030282C21
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 11:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7B81AED5C;
	Wed, 14 Aug 2024 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B8UBd+FD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5F3394
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 11:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723636074; cv=fail; b=P6AenFLxpVN5ls5jNt+aKZwIUZTGgYWYdrjy5RSAhj2TGk1gP6aJZnoWThyVAPNib3vZqlI0VqyGqYPPSaD8Rb6HnOjqazkNZB7TZVpHXRdyblTuQ9XlZcy/mycNI2mhWJWwrFFGBXZz94Zt2QLuKOwC4YAEOOesE2UBZKWTmlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723636074; c=relaxed/simple;
	bh=7L2BRLd8kMWXNwFwW1/Yjdf+FSX99XXog9QPkjt0uA0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D0vzSvaEx1YKTcUeFKARSS/YAFT7ExRujxdDFD5+mvQslGspqH8Ze6mmsv/C82yfMEi+iwMD7jKwjQCUnGrcROHsfCD+5faDj5zEMzNk59rnGizyNFxzYHesNjB/vGBdnXL4ttQmi/spR+AQbBJ1G/Q428GqaGZQOzY6XwL1PbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B8UBd+FD; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723636072; x=1755172072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7L2BRLd8kMWXNwFwW1/Yjdf+FSX99XXog9QPkjt0uA0=;
  b=B8UBd+FD0o4pvsBEWAlTMkERBVg+cZ1XamOxzPQu9u79omercgOu77ZK
   8Cmdly9wGq72ciXB+rNVj7sm8HRlc7yDPch55+sU0Ae5xU5B8Xgeq+b10
   sWQ3T4OmiAaDAarNbiy9g5qcb4oV0BFtPjlJqp5b5h7rmNMD+Phby6xyp
   n98n+kKh5ZI3lhrrcbgm8+Bqsu2aGgkIjw7UU24wJLOpyVlLqmvKUIMWk
   qlnILPHqzQLt6toVdvH/b/ZXriIwEDnkqt1dlQZ9J7+zS58x+tCy85jQy
   gNyFStWFwwOKumMHPZOXSvfP5m6+VPxCRkucFkzEunMqob8p5+KDmXZ9K
   w==;
X-CSE-ConnectionGUID: p9bqwtd8T5OrqH64CI12OQ==
X-CSE-MsgGUID: XDZ8lTc3RjWL0rMWDgJC/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="39295971"
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="39295971"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 04:47:51 -0700
X-CSE-ConnectionGUID: VvE3I9i0QyKikQ6ZTSMHrg==
X-CSE-MsgGUID: CcU+wdGLQg2rSrvWI9pxaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="63861542"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 04:47:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 04:47:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 04:47:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 04:47:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBhHVIy3MUQbUhmInwp+Uh+SL5/e0V60/3EJ1bdaN8nz/F7+XM5hLpC/gH21fwLKyRnkyqQUzyWLktaHqCuNzoOwqeXAbtqv+OrNf34AvZ4mxzebKYYQ+7NQZnZGdmwp39RxzxjeHEGW1XHd890GIjTImKizSoMRMs8TudhLImw71YKxUMSl+6CW/C26X6Rbs8Gy5V6xi30tE5kO/OU48dpJARyC41Da6/FsaIHDDeiXLQesqQVcD6c12omWShOn+aL/CqCzMN17ZYB85L1j+/V6EfKmtgOofc0sHW9oF44vtKVxmVAv47n/CRHm5XcrBOBce0nrxLukgMQYsoi1fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpyGzUbo4DP4OTaWkj8FWw3EH5ws8lyjFzPzzqYoLPE=;
 b=xhKzoj5QG3YxgmL7W7ysHfZbQ3H2naqp9+UhWUe5R9qpoYzsCObvZ8bZmpkWVD2TTb36xqyB20xuRq8ZUcVPGpfuJstyYB1h5okENWgB6+joWZhOHn6mIGxeI+7wUZ4xBiJXhXwkHbqUFT//xHbd+eMUsPr7zoeHGD3lGt6sYKCDYhLx+cFEV+3ybENkSvkIjKrjvKBW8BVnmzsNoqjNlVnyfyorDwW8c+YsysS7YD2qwRSSw9BDwS5bZ4qhGkuYypePLQYCQyRJvyHIRYZ50+UAQqqMJzUCTjYK7KV1DK+Q5vhMwUebvCeTMszKpr+EsgkY5QgLG7r6TDkS0EzItw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by BL1PR11MB5977.namprd11.prod.outlook.com (2603:10b6:208:384::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Wed, 14 Aug
 2024 11:47:48 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%3]) with mapi id 15.20.7828.031; Wed, 14 Aug 2024
 11:47:48 +0000
Message-ID: <79809388-e441-4dd8-ae71-58405511d029@intel.com>
Date: Wed, 14 Aug 2024 19:47:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] i386/cpu: Set topology info in 0x80000008.ECX only
 for AMD CPUs
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
 <20240814075431.339209-7-xiaoyao.li@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20240814075431.339209-7-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::19) To CYXPR11MB8729.namprd11.prod.outlook.com
 (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|BL1PR11MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ad4a05-331a-4693-4321-08dcbc56eb37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: yrZSUhNjlM8Bt1JpISOLPkMhe0PWtvYx2AwYAq3S+6L6VAcYdfW3lWtlCNYdwgXZthtsk21d5cxI7INkE2u+JqAEnzsLDsh5mLTtMiSclMPEw8v/VWd7HuKoUcsylw9viiUh++hRoACIZC4heRebv24TflIVLN//O5ru3n84XZeGxyFZnEvrPbarnnPgsQn76itAFsGWdu7wnFcrQ/dTUqEqq3i4ulgr8HSgeYlO8RvXiHBClUvTgD3OkIdn62qRclXf1k50jf2MPVTLyOEDOrVYNOGEYS14F+oQbNRBVFhhHXJcOIbgj/htYsOl3TaJEk4xj6OImsnoYBKbuAY8fvnnietPNfrz76AdM1I72rUxRNoddZ11Vd+DvjaaNLRbh+XhIY9oN1FxhBAZ0eNJyzHiTkixIrnPj4AI0l8DYlhtAbWfgpx4IqxMA48HixckhR+CC7Je9/OtxS5MgqzwozsQvHLKmUXcQimpIsvbyv5DRLwAuZRxfomz0e8b+SZW+BR3ioYv8uoJGvILG/18A/rkM4TXA3fYASrFRo0B8pLiUJr/ZoLdoOYLilzjq0Sptcg1YXC8Zl0OsDiqVVqlLx4IiwpWQ56TM0EtwcYDfJoW0Tj9jHtk9iBkRiXWFOR/1CN4oej0/pHC+JAUZiAIPtkdhXByX+ExspFKuyeXFtE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Szd5bWdXTC9YbHhlYml6UkZxSWxLb2RyKzNrTDJidnNCMDVVaFNxUXlMcEdm?=
 =?utf-8?B?ZU5Qei9MMkd6VHVrbjZJYUIxNlNid2N3Tm9ydS9JdFBYMzJUVG94RHlqQ2dx?=
 =?utf-8?B?MmVjZzdYQithZmloNllkT0FQTUoxTk9wZ3llRkUwcFFtckt2SHBzckplMHBn?=
 =?utf-8?B?NUZIcklDUVpzV2JWN1YxVndydDdlU0xFT01wTXB1WG4wVVdESis3d0FXK1Ru?=
 =?utf-8?B?RzBlTnJ4MWk3elVxblB1bVVOZlRpNU5ZZHIxWS9oOTFBdFc4TTFiRzgzd1ZF?=
 =?utf-8?B?OENBeXlRVkljaUZRc0Q5aUNFY01YNFlUMzl4S3dZSFZJZWpmMHd5ZTNteG9w?=
 =?utf-8?B?WTRSZEJFV0JHUUc2WnpGbUdUUi85aHovanE0M1NBTnVuWFhmd1Q1REV4L0V2?=
 =?utf-8?B?SmlVMElmU3N4SEFWRDg5L1Y3c3FpWjBVbElzeEQ4eS9qRHF5NGFqY1phWHA5?=
 =?utf-8?B?WmZuV3J3ZENJRDluVEdqWnRnc1Rva093L1hrd1Z6QXZINFZPNWZiMVJTa0NR?=
 =?utf-8?B?cnNDc05FV05nUVdOQzRJbFNSYjNNQkNodlJEOXF1NnNlRll0aUJFVzMremZ6?=
 =?utf-8?B?ZFFsTGJZOUN0UjQzT0l6VVBnMWFLNG41enZCRlNVWTR1bDQyNXdtejArK1Jt?=
 =?utf-8?B?VCtiTlAvT0FHVStzSVN0T3pUYmhiU3hMMnFrMUx2VzJIdWJVZk03aDZrcHJB?=
 =?utf-8?B?cjVzbHN0SFgyUlNDVUhHdWxWZjgxQkVTTitzcm92L2h4NVBxS0FhVUtwSGtx?=
 =?utf-8?B?MXF2VkMxQ1hLV0dMMFRVRlgvcHptRXBjWG1jNkREdFlBOXhHMmZ1aUgzU2Z6?=
 =?utf-8?B?ZWRHcHdWc3lnZjcwVEVrQkJNbVVNcWhWTE9mb3plbFhjK2t6SFNNU1M2TXBX?=
 =?utf-8?B?NDZGSVlVRnd6ZG1QM1NWNnIwNlRCWUtPMkVNUGRpRzM0RjkvS0xKUlBSZWF5?=
 =?utf-8?B?UXlkaDE1a21GeTVBelF6NXBweDVnMTFxT1JqOWdZRUtPYkg5SkJiN3VuU0NZ?=
 =?utf-8?B?MDhlMnhvcUNqeXlER29SbDdGNjNKVW0zMWs2TGpTQVluUy9xaVVrYTZTTUtN?=
 =?utf-8?B?TkZDK3lWY3FLNXVUTElBaHFteCtHdjJrZTBIWFVuS0RQdUo4T1dZQTlVbWR0?=
 =?utf-8?B?eVVOdUFvYWVYNWZjNGplNDdhQmxNWlBRdHZsN2ZoZktvZmMwRkJGWk0za3Ew?=
 =?utf-8?B?SWYxYnF4dE5kcGdxVERFYjJiZ2k3S0FxQXlMRy9SbjlRZGpSTjUvaEoyWWIw?=
 =?utf-8?B?b3M5cWhjT3g2UVlSMUZvdW1pbnNlMjd4azhMaGZ2SGdPejBBcHVXLzdhUXlD?=
 =?utf-8?B?SDVVSUQ0aVlnbDZuMVVBKzVaYWNwMHFkejdQUGExRUVsekR6SXBuWFVjMEU3?=
 =?utf-8?B?Y213VzdML1NkZzlvM3NFOWovUjlzRmh1Y3FucWpmTlp3bGd0Yk93czl4dVNT?=
 =?utf-8?B?SlNidytrazBWVk1uN1RrVWw1Qk1yd1M0S1ZScGlDK3ZMK3dyWXVQeDREbUtv?=
 =?utf-8?B?d1NYNTY3am5aUnZWMFlRYTlpZkZJSitVNjBKK3R2Wm15ZTM5STdCVTExRmJw?=
 =?utf-8?B?V2YwWHF1dDZwajdjQUtGMzRvUWlsTkpFaEI1bmxRdDNPMWFrZXVGdFpNaWM3?=
 =?utf-8?B?MEZiYjBZclhCemJPRlBMVzRRWlhOc29oMzk5YTQyN0VLMGkvT1p0OUM1WXhj?=
 =?utf-8?B?YTFQNnJJZ3JidzVjK2MrZGJEOEMrdlNyTllKcU5ib1YzN3lqRWhobXVrMDVs?=
 =?utf-8?B?V0RHWjJKQUZ4KzdjMXkzTkEycXo1b3BwNzgycHg3dkQrVUhKblh2ZjFvK2hX?=
 =?utf-8?B?dzhQVmpRbk4wVzFJVXNWRE9YZE9HSDkvb2dPR1Q4OXRrajZxZXBQRnhtVVFX?=
 =?utf-8?B?Q1lnMk03bHAxMWxZZ0RTZFRsNG8yWnU0MkpJVFM3UTlLRlNvRW02UzVLS3F2?=
 =?utf-8?B?YitDUXNXUk5QWEcxZ0p1aHllWFdNakZObC91a01LczNoSlAxd0dTSkh6V3FV?=
 =?utf-8?B?L09FU2EzMWJjdHJUUUVHLzRUaFRiZVAzd0xCK3p4NFd2Ny8zMHJuMnoyaUhw?=
 =?utf-8?B?bVNJNzRtNEdPOVM3Yk5LQWtDcnRxT2ZXM2RqM3BValExTDVmUTZWTFRac0tL?=
 =?utf-8?Q?gLZJeBJUlGHX6wThwmw+jrHB8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ad4a05-331a-4693-4321-08dcbc56eb37
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 11:47:48.1964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLj/VrIfw+qtGnsp9Y8zvp9j6l/xLJJCOmd6tqZoF/3iEWTzkyrPAZM2Qf82RKjutB2C8eJ8vk/bBeqNBmvIGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5977
X-OriginatorOrg: intel.com



On 8/14/2024 3:54 PM, Xiaoyao Li wrote:
> The whole ECX of CPUID 0x80000008 is reserved for Intel.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 5bee84333089..7a4835289760 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6944,7 +6944,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               *eax |= (cpu->guest_phys_bits << 16);
>          }
>          *ebx = env->features[FEAT_8000_0008_EBX];
> -        if (threads_per_pkg > 1) {
> +        if (threads_per_pkg > 1 && IS_AMD_CPU(env)) {

Is it necessary to add the check like:

if (thread_per_pkg > 1 &&
    (IS_AMD_CPU(env) || !cpu->vendor_cpuid_only))

for compatibility with older machine types?

>              /*
>               * Bits 15:12 is "The number of bits in the initial
>               * Core::X86::Apic::ApicId[ApicId] value that indicate

