Return-Path: <kvm+bounces-10552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B470B86D66A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:54:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 477C5285864
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 21:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D4E74BF0;
	Thu, 29 Feb 2024 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4zH52K4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB5C16FF46;
	Thu, 29 Feb 2024 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709243623; cv=fail; b=sFA4BTRrZ7iXU/Yxj3HzbY3+0Vf6RknX/CCNKUQFZwstF0HiaGCzDY8fb1vY3l7I5/A9TZRWA6U81Fko1MKVaOTencyw4bbdBKVuUDYTG4E4dgFPNF8Fdug+p9Bc1rsqPi71afD5ulHGcWdIOfdJQqMW19PFGQ/YmBRUIN6yWVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709243623; c=relaxed/simple;
	bh=JlGJHlCu+tUosZ4mrlvcq4fRlczkB3DCRankUo+eRrc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R29iNV07yLaGX5NMig0kA2jleKpnogspyRR6iAe8z7/mazPOn7pzog4Bd0OCiAhKioGxMw3S+UE+rbM04YQsGQRdzTu0C4dwi8h/M8diEnB9f4Z0W/VZpJWWRN6SHvffrO5ML1VB7TlyaUXmOt1LNhcFQBfm+1oBVZu5nv1KMpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4zH52K4; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709243622; x=1740779622;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JlGJHlCu+tUosZ4mrlvcq4fRlczkB3DCRankUo+eRrc=;
  b=E4zH52K4xW+moiHKpPUcpj/c1SkI/+2kLufz/my/TQyNvh0TFV9sSp/I
   oag8V5u72UkQotswbvv09ph7rFGyjAJU4RVZtDuJPohkoXplbLPv1K7CP
   Z41m/cI6OEkukY4eufQU6ZKNeN3X9UDk9qSXQV8sJb725QZFvEfa4hA1d
   b962oGdd7o+tN93PMx88/UyVItWw2CzRRpTKl8JkobyBSeDsTvpmbs8Gt
   90yPaJv3yr94rWe6PBeia+Vxp0Vl7v22vZvY9C+Xvo75usQet0nvbWkEb
   Kb5G1mHMshRgnb70kf7NbD7EIRmsyK/PeWm+I/RlKD0iGHJVg5YR9fCEk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3925843"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3925843"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 13:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7923373"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 13:53:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 13:53:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 13:53:32 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 13:53:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=findsTbPmg3LKHtb7z0RYAODs6GjFmBk7ZtDHsxChBbypWmCQ3C5wIG8HCyj7OkfHE2nVI4YK2kR0I39aO9oEZN86mzw7KlD53hd+sjpY+5c74yvWu3sfjVH20f7b01XclqmkVseyALg02bnABzHLw9BOfaJGXpeOqzp/mtQgCpGds1f3JSuP7mznYmzmUYsmDkJFDBmbUovH2/EvCk3KUIl2VlSKQXaMvHHaN/7Z2tpTpauWZca9b5tcAVo86ytQy4AJANELq2v8FkmYwzgXly10fXD8YWePE4qqtk557F/ac++zLweNpolSxqSqbMDj6Dr51lIB7YT4U/m7SWrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11GgY9S8VQm8ns4qdoRkbKKKVdcEz39ytSFHVv+ff+I=;
 b=VRPlns5u7TcGh9lardL7+qYf445ixl2z4fBHHsDrizpfBLwsm12QQU3x+wztC7elwYS/dssamiDZP2iWrXsvQxl5iScku6arIs0ztnS0YywVZ9zEwPues+Ww5L0RDmjbd1FWdnR76vYm3FwosttimV8EFB64E3iQzY8wMB2Tt0GP9pYlz+ABF4HOXgTOAzRXsArssqiJNVLdX8cjd9zUNbk4+OeGiDtTwcUkAWsMHHZHyWM0B1E3ohaZvHl3VdIL/P0PXZJb90wjT4SqS19sx5hRb9j0+EqOyGwrK82PJ8AUgrsgZPantKxyBEGcWb5hnTpUvrQYAvtuz2ycnjCFRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7569.namprd11.prod.outlook.com (2603:10b6:510:273::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.12; Thu, 29 Feb
 2024 21:53:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 21:53:30 +0000
Message-ID: <04398f4e-6098-4559-9604-b9810753801e@intel.com>
Date: Fri, 1 Mar 2024 10:53:22 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: use KVM_HVA_ERR_BAD to check bad hva
Content-Language: en-US
To: Dongli Zhang <dongli.zhang@oracle.com>, <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>
References: <20240229212522.34515-1-dongli.zhang@oracle.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240229212522.34515-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0149.namprd04.prod.outlook.com
 (2603:10b6:303:84::34) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c7df90-fe09-4262-8c70-08dc3970dde8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cJov93Gq0/G23Lya6UhskZoIaYfpvfTMKc/PtKiZL0pjrt6HqvjYaIa9/Uz9i16mjBzNevYTf+q2C4msjNQ1b24a1/AG4hEgZQsuQs5knl+jmoDj72zwjRdY8B1WLb4Gu9Q0svjCPmoin7fJrt+86aDO7rv1CnC7uyfXm17B4qQwiHPfzKdB35slhwSw2YYl+maLdL5f6OkLPCw+8VNE0zxCST6Yh7YWMNvAKfA7j2Sa+AZkHOtRH34mVtRCa/ymxFpL5/KSHx+yscBydzHCkD5A7JviKsRRYkyyr1z7QQxy+sswDoa77EnnVpFXlTox/zwNT0Wkjo3MndEhYja01au5IYaYOgdTGbNE+JQ7e6a+ddSMX4aVAbjsQyM1424ThtizrjyQIC6jHCsOzAfNpHS70H2NitL4kLXOkJNFt3EmaDyewE2P4TGk0ouzfWfq4GK1ZiSqPobit98pmqIaK18AgHgOQMhLYDOyQHonqvvX89D3hjm/j0oTcpDGl1LcXWEWPWhxXiKeAnNoFh+CPa5joqT9HxiZD/Q7Q+muH6i3d767h9xLMbD5AjnmzEEsIvVRFvSzR0B1UGW42Oh10kLm5R5PKHCKZVC9EdtU3mQ0hvSsfzxvhs08KwZD5XpVe2kIvlqHUrLjv/hkgJERQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1d1SnJaSkNBekxGaW02bTdCNE5hbzFFUGY0cGp6dXg0cFNJK3VXTU94UkRT?=
 =?utf-8?B?VWsvRmFsR2Vnc3lFMC8wRUtLVEMrcmJxZk5xeWJpaWtPY3NlMWFsTll0c2h0?=
 =?utf-8?B?VEVFeWtMRUlPd0VIclY0ZXIwdDZxZVErS3grMFAxNlJVcC9TUG9WMkZLU0hl?=
 =?utf-8?B?MVYxS0VBM0QrS2hGTnFaTFlLMVBFWTdPSDh0MlZ5Q0hNK2lkUzdkQi9uQlJp?=
 =?utf-8?B?MmZ6MTc2dmFvcmp1YVMyeHpuZ2JWMnYwaXJxbHU2aW1ERFFBZTJ1YjgyV3Qw?=
 =?utf-8?B?Uk85Y2Z1aEJzTlpLa1IwRE5yUkJhUGdnN0RrcS83WG5tZnlvdUlkakE4bEh6?=
 =?utf-8?B?Ni9iVnN6eFRWRU9BQW8wUzR4dVRIM2Nna0Jzclc4TE91SzNZT1hnalhjZ0Nk?=
 =?utf-8?B?K25iTDdCU09tcTNNc3Q2RDQ3am5IVmZqRS9XUjhvQlJidVlPRjAwL25YWWtT?=
 =?utf-8?B?ZGszK2wwY2lsSTA1TEF0NWtuSEp6bzI0RTFhTW1DTGVIUVc3Umprdm43d3NO?=
 =?utf-8?B?U1ovMkpQR1JoYnpkbVErQlNvc29tQktkYmJ6MTFpVmNiQTU3anVsc20xV2t5?=
 =?utf-8?B?M0hkSU9ibjJyTzBuNy8xbC9GelZsclJGZ3VGcnUwWTA2UjNNUHBFc2o0UUE1?=
 =?utf-8?B?TTlYUDgweHBSenp4L3ZDY1JqNVFLeE56L1pwTFB1RTQrQzhlWG8xT2NCK2JK?=
 =?utf-8?B?K3JJSmFFL2lxeXlmenZnWmVQbUE2NFc2VUZqZzFpMHZrZDhWbDYyM3ViWnFw?=
 =?utf-8?B?eUw0NHZtT1hOWTdFQ213S05IVkQ3bk9yVE9oYXpUQmJqTm9kNmJKa01hMjR5?=
 =?utf-8?B?aEdDQ0h1Nm14cXgycTlBdjFoYlVUSVVjOGxaYVBjNUlMcHRvL21FVittamtG?=
 =?utf-8?B?aGpFTEd5RWUrNmZNb3RHTHZTSXkzZ1djV2FvZ1dEWGdOTXo1ZHBDTmQxeWdE?=
 =?utf-8?B?ZEkxTkZCaU1hQ09xR2Jualp5RE56MXhlYkJtRjhhenRnREtxeWRhdXh0WDRG?=
 =?utf-8?B?WXJMZ2hDQzFrMUd1eUFTeHMzMmFLVmwyWE02S1J4TmxhTFgrMG81Si9IWVcw?=
 =?utf-8?B?UGtJanRmWE5BNElTWXl6YVpVaVdrZGp6ckxEYitXVUVLNnd5eVhnMnN6ZWxS?=
 =?utf-8?B?RW1qakNWUmlBNGdqTjBJcVNodnQrb0krbXB0VitkV2YwdzFWQ2llZnRQdHh3?=
 =?utf-8?B?ZWlnUWRoZkpqcXhGQXVveWxzbWYxN05JOXpsMGJzakxzaHFjKzBROWZoOGIz?=
 =?utf-8?B?VEwxMDA1YnowSjJFejJIRVM3T0p6ZFJoY0RPQlRyOEd5K0FpUjA4UkMvcUtL?=
 =?utf-8?B?V0s4Vk1yQVhxTkd5ek83VHJ2aHBrQi9JcnJ3TmF4UkhsUUJlek9GbWhIall3?=
 =?utf-8?B?Y04yL1hYeVpLamROV3p4NUFmemV0RGJSWTlyUWdqWXRFWHNwejNxYzBZTnN4?=
 =?utf-8?B?ZWhMSHM5N0Q1clJITHBSRkNJeFJ0MWVtSlhFUVdtamk4Yy9ZTFgzTHkwbEZ5?=
 =?utf-8?B?Z0x0Q0NIRHM0Mm90NEZpYjlhcEZWZkI0TWc4REloaUl2UXRUTEJhZGRnM050?=
 =?utf-8?B?UUpvdFFPVDViekd6MDZxR05HMTZvT0JDS0tncExTd2FGb0d3U3YvN3hDclBK?=
 =?utf-8?B?ZG9pK05nUFBJUzhDaDdnUmQvb04rUXk2VmE4QjlkenZMZjdFSDAzeG85blF4?=
 =?utf-8?B?dWZWdHo4dmtBTkMxbFlDcmd1alUxdnV5aW5yamtqN2VXanJkZnRFREIrYzJj?=
 =?utf-8?B?ZktBVk81MEZjUHBqVDVYczhWUkQ1S0FGc1J1R2FYR0xmK3VFMUZodDJMOEJs?=
 =?utf-8?B?aVRoUWtTeTYxWlJPMlNXTmtNK0NGbFBvYmxMY1FDbkhsTVlHMTU3SG9UWS9H?=
 =?utf-8?B?YTFGNGIvemsyZWVkQkNORmNYNG8weC9kdHVqUGtHTFJ4SlZNSGRFbndzTTVn?=
 =?utf-8?B?WDZMbDF6L1JpT2Q2M2VLbUt5TjNKZG9wemRmazcwWkVGdVdmY0tpU04yTmpB?=
 =?utf-8?B?TGN1RjN1MHBiS3BSTDFUQzdyZ3NtREl6RjF2UFR0R21aMTFYbzExeUM4amlP?=
 =?utf-8?B?TmtCR3lSOXBDYjlYV0Z0SVQrVFhiejk5aXF1aUpGQVFhZGVQVG1HNEg3TVBi?=
 =?utf-8?Q?B6aWCH4kVI0SMHNC/RFVBo4y1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c7df90-fe09-4262-8c70-08dc3970dde8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 21:53:30.3337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tRnthajX5vI2XW/HepzhY/s4DZKEbtzb/56FFx+KnsME97c8PmgoGyGQ8dtUqEXaoJmLaPYZqT/g/GR41KOeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7569
X-OriginatorOrg: intel.com



On 1/03/2024 10:25 am, Dongli Zhang wrote:
> Replace PAGE_OFFSET with KVM_HVA_ERR_BAD, to facilitate the cscope when
> looking for where KVM_HVA_ERR_BAD is used.
> 
> Every time I use cscope to query the functions that are impacted by the
> return value (KVM_HVA_ERR_BAD) of __gfn_to_hva_many(), I may miss
> kvm_is_error_hva().

I am not sure "to facilitate cscope" could be a justification to do some 
code change in the kernel.

> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   include/linux/kvm_host.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..4dc0300e7766 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -143,7 +143,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
>   
>   static inline bool kvm_is_error_hva(unsigned long addr)
>   {
> -	return addr >= PAGE_OFFSET;
> +	return addr >= KVM_HVA_ERR_BAD;
>   }
>   
>   #endif


Also, IIUC the KVM_HVA_ERR_BAD _theoretically_ can be any random value 
that can make kvm_is_error_hva() return false, while kvm_is_error_hva() 
must catch all error HVAs.

E.g., if we ever change KVM_HVA_ERR_BAD to use any other value (although 
I don't see why this could ever happen), then using KVM_HVA_ERR_BAD in 
kvm_is_error_hva() would be broken.

In other words, it seems to me we should just use PAGE_OFFSET in 
kvm_is_error_hva().


