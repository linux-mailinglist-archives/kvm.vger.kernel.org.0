Return-Path: <kvm+bounces-11233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF1587454F
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93F34288DB1
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6904A1C;
	Thu,  7 Mar 2024 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mA07/b4k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4184689;
	Thu,  7 Mar 2024 00:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709772614; cv=fail; b=tGAhIqe22x0sR9jQV4/LAsMbgnh+GgZT27xR+DyrXFBQYaNQV6/v/xzghWf7y1KdcRE1dG9P9AMccAdUG2C41C/M9J7T3cN3u7K0tEAiBBVTt24XobmObTgq2xfGd6Lookk0R8ydfJtxRw+RgLU+w47tTobx3+1roIecu5cwD9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709772614; c=relaxed/simple;
	bh=iGAeOIC2NAzIrtfb1Ej/jDGRioDn4Wf+HNYoEUYGDGY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BUcihal4dJZ5HjigApoFQIGBslFz0O9wqcajevTJR2m2NIWwhSlNu3OLfD62VbqBnwpwpxTS5TALBsOkhx1YuBjctMZ0ADqQ3Vw8QSdCOTgVJBzgTtkHFZtc7GcdJZTFh+cBCi4pFKCcZGgPX5344S0W15gXMNBFuY06jeQUpTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mA07/b4k; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709772613; x=1741308613;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iGAeOIC2NAzIrtfb1Ej/jDGRioDn4Wf+HNYoEUYGDGY=;
  b=mA07/b4kpG4MN8zNBDuf56lIWtCv1/ucaADsvAkJgiYPugkMzjZc6iDF
   V3fHRF9yxVVR/pfeIL790C1JOvwUA3AGJbNPYdQLye1YiO1wq+28gN4TY
   85llfzzHPDDyq0a7OacEqFqeOw+m5NISLeBE9O2g6a62MejnX67Leh8Uo
   TZduILamMavLrNsn0ni9BD9Tjva85PULPWr66m67Bw5/Cy5sUdtnRMFzi
   4m3RiE9TW61/pdArtW+Rax8mbJBhkk/P3jqPsidgM69lLzeL6RoVvmkoM
   FRTb7FJ3XKFPyXl6P3vDvmStzdtixTUJ4JsAm9mMZ6IJA40m4qJwX1Prh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="7361843"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="7361843"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 16:50:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="14496812"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 16:50:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 16:50:07 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 16:50:07 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 16:50:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7UW2EXDiPwmr3l15x+KFWNP8Qw6+EyQEgEtnNX4/CxXm/aVB11JoaISwy/uqob492vnJ8ixz8yOAGbXGWaU3I8FsjoFGreZwMZzRAMGSbLWxV/YXmgZlox+l4BH9cTeauvCdynMuMA7rdOqvFXGm7V9Yq5mnf/DR4evDbNQdYzoz8a69zujIOKjfs4wSRGk7hdpISxvmh3gz2wsrBrFroKaRi0ABdgg2o+nGPlrzN2HLBK1Oa2un65IkyO3qSbYHdY2lE/coS6NhjuyDgMW+sChMi7nLk/SipqUyQD3X8z0UPn8CSlRp/hqBmw9YxiuWSfHKgv2P/rgXGkHdyUW3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQar9+qmKGaDdcF/WTizUqo9LZByH+sl7NBloutsweI=;
 b=VQjYSr7ernKpA7kfF2njDt8CyDQ4wDujOm+o5VwEOI9QVxxgFftXo1As2TD8niQxutFbk/d2SxMdzKEQzgQrvIBljPSvNzNm0C4TsxLIZ3h/MTp+QNsVesHvFTqAUR4JF2eIyt7MPU7FGC0WOTmOhyS16BIrWtpuA9V9JmYkh+++fXagao8eca/r/gdzyu5rbAvWT4au3943BfHHjMudtoEswYOiueDEfm3yWqbKJTcqA2LnLV16KJl1MrgEpzKHUJq2WD1mubG6ORspc4ofTKKseVq+vbuz8M+9p5HVT0pdzXeD6JQX+2FZRoY8ST+726FGrFKuDdZ4RVRK1K2Rwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6728.namprd11.prod.outlook.com (2603:10b6:806:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 00:50:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 00:50:04 +0000
Message-ID: <57e68a47-42fb-4029-a46a-c81d1522f7ff@intel.com>
Date: Thu, 7 Mar 2024 13:50:00 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/16] KVM: x86/mmu: Set kvm_page_fault.hva to
 KVM_HVA_ERR_BAD for "no slot" faults
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Chao
 Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David
 Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-15-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-15-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::8) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB6728:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c1f0dae-28a6-46a2-2968-08dc3e40873e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOR/DbIrl3anq+mrt+HtEld6NeCYuelLe7tmrloBh7EhXbDTVL82DMOgMOEf/eb0J1NIqBBRzpStGzHFZ3eUsGAr7FM1On8yvBi/bn30ebOz2Tgs9VDDN7OgVCeg2PxsHv20tEEI+kMQbOmyRgPboQQBda3h2p13EorDivED9IJZzA2D8CLypvJj1aRw1IZmyAuPLam1UTGfTBvoO1Bk+h8BHZ2+K/lEhe2WBj/XHa6hPnB7oZt0uuysri4l9eS5AqJxFx7+GNA8EYB+D3bWwrE91uXi1TgeHCdtrBUbnhhW6qg+ewFwl7g/sZnX3utDrKT4PZTHMY940wK3qmX/NvmHVP7pTj8at3/qexrJct63I1tazrWj1tp6gCF8nf4VBvPGoIjzM29Es0vi/dfLbdJ7Rpx8Wd8E+gOVfLJOL84o28reKXAFh/gyTLVuqE/JH3TzYNMs9cB/EDadTrZy+/fJ9OxbOd6n0MDdjkw92MC9hwKo1ZQT4sm20w3t/z6XWrCtbSSMayffc3gPtQHpkqHajZKHY7ObMOGiXcMTH9FJolFuENZNalgAPMnJ5qQhgwy7Mi+zLVQhSF36ReqZ3dFXM22vOTD3GVhRT+PPC34I8jXfItva7AXQDpx3WT9t1kdtuVjSBo5G7Yxp3KhWHGq1+er30QgjZUvdvlGdzz4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTRFeTRpNWhOdVpienRBcWhxYittamtndkJzY0Rhc3M1TDhDQ0JHaFV0U1dv?=
 =?utf-8?B?ZkRPUWlZeEYxT0phd0xZQVFvSTFXa09UNWxZQ2t4cEttUHIrdEs2M0hoZFhO?=
 =?utf-8?B?QjY0L3FkOWlMMDNCQnNJUTJ1QlJSWmpvV1F0TTJ0UzExaHN6OE5EUTdmUEJK?=
 =?utf-8?B?WTJOWWNKWGo3UXlvQXI0ZXFmTlFOUC9PUW5uYjlZci9KejFmdTJySnJmbCtl?=
 =?utf-8?B?bGdLUDVidWs5MCtta2VuUkFOTGM0dEZNdktzMjJoSUErQ3VMM2dzWmR2UXNs?=
 =?utf-8?B?d040TjhKQWRUTzNFSkE2M0FXdDg1KzdTUXFkcitmV3VTR3h1VCs1ak1ianpy?=
 =?utf-8?B?dlZXRG9tR1Y0WTFHWEZXdkk0WTFyeTdDbk5BK2ZjeXR2SEN0eWxFTTJxRkcv?=
 =?utf-8?B?MXpvT2JKQjBPaFdwbTcxazVKa3Ywc2tnYjJBT3V3T20zS08zaG1sTi83Z0pJ?=
 =?utf-8?B?RUhHcXpCcElBZ2xpNHZMekNUSjc0NythMDFwTXpiUGQ3ZGF3cCswbldCMnRK?=
 =?utf-8?B?allBZWVlZFFWVU00dnFsTExpczB5UE11NDNlMVlGN3J2UXk1c2JEZzNCcGNC?=
 =?utf-8?B?bnZ5ZTk0YTlIN1FxaDE4TFZNUjlEWTJBZ0hQTDFOOFRiek9EMDdtR0dWV2I5?=
 =?utf-8?B?YlgzM1JNbnNZNWlxWHVPMTVLRmVuMlduUUlHWjhNK1ppWnR1VldTcVBWbFRz?=
 =?utf-8?B?RGFJc3gxdVYvc29QaVhlSnhHaCtDSTE4UWNRWWJTd2g3VWpIalV0b01YTVR4?=
 =?utf-8?B?eFduWEdTY25ad01ocjhPV0lNVTRYZzQ0b3JzWUNSYUJIY1lvZmc4U1dJM1lj?=
 =?utf-8?B?Mk9sNXVhNjlRbkFVUHFkcEhuTGlOQzJqbmZsZXVNeGxOU0c5MjBxUXFqNjZI?=
 =?utf-8?B?Um56WHpUVHZLblB0alNXaGVoQjd0M1RaN0R6L2FReWtYUCt5RzFYY3htaDVk?=
 =?utf-8?B?UHZlUXdTQVVveUxCQlB5MFZLOHM1bVlzd2R3a3lxZDE3R1dIdTloaGQ4dFpw?=
 =?utf-8?B?S0xtR0hlcWg2Rjl5c3VJNE9lMHlCZ3RMMFJ4K25sdU9FVGYvSHRac1psY3gv?=
 =?utf-8?B?T2ZpT3hvN0xDeWtTREE0REJTK0RHV0RGRlBySS8zcnA5eVpNTEtsK0dWLzFn?=
 =?utf-8?B?VXV6dkVNd1hJOWdYWG1rK1hFbU5WT3B0S0hhVFI0aHltK1E5dVNaMytHTzgr?=
 =?utf-8?B?S1BMdDI1RFVrMENBZHRnVkxlSWVoTjBvT0M3aSsybU15Ym1uK1BYUVNOMG9X?=
 =?utf-8?B?SVYzUWhYZGtOMGdhdFJ1bEd2LzFiRjNNSS9CdjdxYmxGU2tlZ1ZmdFplNXlq?=
 =?utf-8?B?MlV1SE9WWlhJbEJkQklSTUhiMHlaeHpnQUowVTJ4Mkc2eDBpVHhCaldSVmhm?=
 =?utf-8?B?ZGNySWppWnE3YlhvNmg1NHFLWkM5VGJVUU42Mm5sUDJBcXZZSENFUDdJOGpM?=
 =?utf-8?B?d2xQZVVEYndTV3ExTlJqQkNoK0VkR214bWNXYUFVbEFRbGtFZVRCdHoyUTli?=
 =?utf-8?B?V3I4RzZVSjdnYW5JUlN1czk4ODFGN3NxK1MvTFNEVjRCVnI2cFBpZVFRTXB0?=
 =?utf-8?B?aWYrZlVSbVVuclhmdTU0R2g5N3VBYm4rSHZHK2N6aUFSRHdPVVhXZEZaVEdS?=
 =?utf-8?B?dU1WUGhqdGpDWUlJVklValZETlF0V0dKK3BQWWxTY2wveTh4MlNmSXRtZlRK?=
 =?utf-8?B?TlFtcVRGWk1xMjFQL1dYMCtSR2hTK0VsZ21BTUVjb3ZnOWZSUTZJaElyRGJu?=
 =?utf-8?B?bmVISHYxaVJhVTNhM2h4TkduWGp1eFh2OHBlZnhCQTlITEg3YVZIUDd0Zjhz?=
 =?utf-8?B?dFErbkRNOWFuNVNnRHZ2Wmc3UGRlNzExbjRtTDg3R2tWY1F1WGM1elJQaVdx?=
 =?utf-8?B?aHZYUWovOHl3QzN5T1F0QmZmeUtydkgxSkZtTzFSVVl2a0piWlZjYk95S0N1?=
 =?utf-8?B?UlVFaVFKSUVOWGZSZ0pTNFhtU3Q3eWlsM0p2WkFqdGUwMDJNVk5oWDgyd1Yv?=
 =?utf-8?B?VlcxQnlNWkFqc3dHQ1pFTmFneHJYOWo4RXRmdmpXY0FKNkdmRUJiQTFjYTVx?=
 =?utf-8?B?Ly9WaG81WmNtVzBMZng3SWVnL0lUc0ZhckxLbkQ2WlU2YjNTSVBURERRRVB5?=
 =?utf-8?Q?E70/jEk593OTa45F1f2DgiMAV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1f0dae-28a6-46a2-2968-08dc3e40873e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 00:50:04.8954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gO6t/1KcYkPtIdL8zCD6S9LePbeyHD6r7v7z11IRl3nVey7mxS1GlcqYshoLZP8SvCfsyIJxCfibN0SuFUNhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6728
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> Explicitly set fault->hva to KVM_HVA_ERR_BAD when handling a "no slot"
> fault to ensure that KVM doesn't use a bogus virtual address, e.g. if
> there *was* a slot but it's unusable (APIC access page), or if there
> really was no slot, in which case fault->hva will be '0' (which is a
> legal address for x86).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4dee0999a66e..43f24a74571a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3325,6 +3325,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>   	fault->slot = NULL;
>   	fault->pfn = KVM_PFN_NOSLOT;
>   	fault->map_writable = false;
> +	fault->hva = KVM_HVA_ERR_BAD;
>   
>   	/*
>   	 * If MMIO caching is disabled, emulate immediately without

Not sure why this cannot be merged to the previous one?

Anyway,

Reviewed-by: Kai Huang <kai.huang@intel.com>

