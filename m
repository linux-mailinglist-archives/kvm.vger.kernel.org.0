Return-Path: <kvm+bounces-1854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CB57ED949
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:24:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB4E01C2093F
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A42C1384;
	Thu, 16 Nov 2023 02:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dK1GHp4V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6378E;
	Wed, 15 Nov 2023 18:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700101454; x=1731637454;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WZ7sjC60JxWazo9w6rWy4rojn0DdvbA0mWK75J4dc+c=;
  b=dK1GHp4V8ICdxI326LdyLPJSCWhx3oBvDRyQr1RWuv4/0FWvt4/XP355
   Q31mlMsCpyC2JxMk0epyVxVZTl3u6zb/WjzHdtRjq7zc9WFqqL8wRM5/h
   FO9KfbVTCVZlObvPKW69R8pBRLEsDvLLNe21K9aNo2qVbBXa67BLA/IEv
   /0MNzx52T9OrRIgN3m52s0+WprVkMv04kE1xjfPtYzyjb+xZ2TFCPYzM4
   r6vEHaWf4bsc+/oqQTYroHc0N+xwrim4AnR3djAKrA5V7hc+MQOLkwkG6
   386GiEVNSB+NHl+jVVfPzJ6XFaDly19O1B9+fdJLc6wVWHdQM57SqZRW1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="381392884"
X-IronPort-AV: E=Sophos;i="6.03,306,1694761200"; 
   d="scan'208";a="381392884"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:24:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="768778930"
X-IronPort-AV: E=Sophos;i="6.03,306,1694761200"; 
   d="scan'208";a="768778930"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 18:24:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 18:24:13 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 18:24:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 18:24:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a40rlE0+dz753oPuamPwrJjJRIijV97MG76Fwgh1+e8cDkcFooLPh/9XXGMnVfWXzyZsCz1deahst+qE6q5ICzH6ySb966A/Toe1VF/f3XH3RoEFK7UzKe+qt/lAoLTwVWogHipq+kYD328f0HASEWGPAFIYa1nSRF3oPs6uS8okwcmUdvIpd3brdgkbPaR67t4tY+cDPl2DbWH6XdDHjSC2nKx4jlUlB9CtBxUbq0OnKA4Egw+Dg9HQDgtlezdB8RrjbKhLRE4rzh2VBB+CwFsK6PZYvdcnngo0I1o1DmY3cYWlU631ldTpoA6GFAdV5oyJNFKhA2utfTS+7x5/Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31jXo/b+rA/CVISAgdebuaNor7Nce4Ke8IauHsf6m60=;
 b=f94H7B2NHm7iUks1gOD5uYtAOnHxAAJv5rpEb4/Hjx0nsoM773ME657wgjHiefEbAbJqQawqpo7zj6AEkrfrMSBx0LXB5xYcXlzoA6p+GQwPiG2Bs6DK/4TtlZQEGbQBncgzDLflIEnbaA2zHAxvEYdRhjAlUqLClcyAD18jCu4QA66da1YT1TzV93tQ+/b35EZ9OXUct6/mcBLdQz0bveiJy/09qOEhWWuAGT8LHQ7SdlETNnZ86hL1iiCabdWkxQ02jQIeAErvGOSGXzs66o3uUT8svLV69KACQ6f3ZrijWgNkEnBrhD4irT5c5wgzEC1gV2lyhlywWFbyHSYkIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA2PR11MB4924.namprd11.prod.outlook.com (2603:10b6:806:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Thu, 16 Nov
 2023 02:24:11 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Thu, 16 Nov 2023
 02:24:11 +0000
Message-ID: <bc2534fe-ade3-496e-a1be-bb2196fb2003@intel.com>
Date: Thu, 16 Nov 2023 10:24:02 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Maxim Levitsky
	<mlevitsk@redhat.com>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-7-seanjc@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20231110235528.1561679-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0200.apcprd06.prod.outlook.com (2603:1096:4:1::32)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA2PR11MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 710cd090-d8d8-4dc3-4119-08dbe64b1e62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwGryUrSILY5kq/2k/2JFQ9ilRo5GYrnUTMxCvm5RMm4my/qYAARnwzGjV3YqQCPUzYXL2LjlV0N7+b4PTKYC16c1NSxrUYun8SV18FD0YUlXsJeqyTAW274sTCgn02vtDGrt6PVZ/YDUyoIdCzl4LhUprjr3HEXszkX/uiUI+/oLF1ETsbsDtfums/a+cjPM+cLtEM6ikqn9N8b4RyvcaBKGlnRPAZSo2C2zRZEldUy7lSUEOfNq5O+FCGpmZeQ/FLJKeg869TYGmZHV9M+J9uTw3h0/pTbkQzliRkAiLA5shBJiHijom8RxHmKqg6yNeGYDJ3Rm8JvwPdqo2TcnFLLPGTE81zXy0jk2hP5Zpd0awskClKhZgUyOUBosal7ePZlT/J9F4KZ6MPfhbkgm/jET038k8P7v/68uwXn1+0fRycOWZXHsfakuUcvHOcPIZyedrBhQgt0/w+w/YuJSJgJJcpSfOUvmIxLSWShx3rcSAXqFm46l1be8BXTMA2bd+Wb96xf6BkWe1QMOt+enujaju/5J9FbNZ0tGpAyN+B1RPxNNa5M3BRZsHqA0cRy7uPeHzF0hwBgMZGVpq/44ibq6Kvx1Kpo45oPbg6nNV0Au0svlSHRxlESMtxsngBc9tZB33XsbYzytXCA2V5IYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(346002)(39860400002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(31686004)(38100700002)(66556008)(66476007)(54906003)(110136005)(66946007)(316002)(26005)(31696002)(86362001)(36756003)(83380400001)(6512007)(53546011)(82960400001)(6666004)(6506007)(2616005)(2906002)(478600001)(15650500001)(6486002)(5660300002)(41300700001)(4326008)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnAzd2t0aFppOHdyV1RjUHBmdmEzVFJkVlhYRy82U1lvK3JkWVFxZ0xZUTVZ?=
 =?utf-8?B?V3RTTHhMdFB5YWhUc3Fkci9KVWNKN0JmRldlc3RyVUZkZVpkSjhRU0xhSEh1?=
 =?utf-8?B?NUxrWFhQaHNNQW8yTVJXNjVha3dYQzdYR2lRYlpEbVFVSTF3YVI0MEx1Nlg0?=
 =?utf-8?B?ZXA1V1FZTEY0cnVhV0xLL01vUlpEU05NYmxHVThTWEFNUGorMGVOVW1tRzBv?=
 =?utf-8?B?RlBUVjBzUW1yM1NTRkNTRjRSbzRMdTk1NmNYbTdJRk1VZmx1TVhDWUdYMEVa?=
 =?utf-8?B?YmMzZjY1YmF3Rm1HR0EvVnpOWThGRjVudmk3R0JIME9TdWtFem81aUIyVFVV?=
 =?utf-8?B?bU96Q1BxbTZtRFdWc0pQZHhZOURwTnYyekZaRVNqV2JHTFh4QlEwOU4zcVRC?=
 =?utf-8?B?SEtPSk9rZm1XdE03REhVSWR3eVFFUXpLTlMra1pkNlZLYlYraVc3WW9MTFNV?=
 =?utf-8?B?SDZMc2hZdEhZTEdyMUR0WDBodTkvOUFrQVRHaG84ZlJGMjVwTExoMFdVMy9a?=
 =?utf-8?B?RGp5clArT0M4RXNTVTVvWHptRWw5TzRiT2Nvek44UGRtY1ZPNlBnVEEyRThU?=
 =?utf-8?B?S1l2NVR2QjFGQUJxN28reUtaSzVNTmhwQkFhdCtTejR6anNxak1IcDBwU2FH?=
 =?utf-8?B?WEJFeGExMk1lMG1LYmpacjNUcms5SnA0YnorYmFIT0MyL2xzSnZ2SzUrUnlJ?=
 =?utf-8?B?U2Npdk9jWFZMT2xVUTJVVGkzelBGWVR4VUN0cjZTY01LSzAzdGRZNTlXMGxE?=
 =?utf-8?B?dkdWVUV1a2QvSEJBY1ZWL0RSWnp4cFNSY2JEbnNQKzB1Sjc3NysvVGM3Nis4?=
 =?utf-8?B?TDM5WkNJSG90a0xNM0ltRXB5ZjhVT3djNWRMVWp5aGlDNWk0K3N5MTE2aVJj?=
 =?utf-8?B?a3RqamM4eWVGM2dWL0RPKzhrVDZTbXk3VlFsbUxRUHVvTlhEODVSMGh2cDhp?=
 =?utf-8?B?NXhOaEVtdGg3RHI2Ym5mSWk0UUU3TEJiR1FZLzdsRlBBMEJoQVpCZElPYmFj?=
 =?utf-8?B?RkJ6TWJTaVhNRy8zdldxaFVIeHNBZ0k5V0V0bVNLZy9kUDI4ODI0Wk1mcmJp?=
 =?utf-8?B?Si9FblMvNElSZDVQK05sSWVsa2FiSFU5d2ZiRUx3ejlIaEY1L2pKK0tHQTMz?=
 =?utf-8?B?TVBCY2dvOTlkVXdXTk1ITXBxaExDVHNhMGp3VzZVZ2NsYytmeENwSHhXcFJS?=
 =?utf-8?B?d3pLMWE1ekVBY3c1TFBsTnFKSFp0NjQ1U2ZCdTZOQkwrQVJzbkFrT29LSkRM?=
 =?utf-8?B?QXdZOUhxeEFUVXJVdjNuZ0ozWG5mSDFBR2tlTzNYcXhpaENvc1RlWGVYK0hY?=
 =?utf-8?B?Ym1aVUhFVmdsQUFMSGNGUGJRMDRzNDJ0OVZNTnVveGFwdmVScXlnQlVFb1VR?=
 =?utf-8?B?WHdWN0J6RWl4WCtsMEN4STlSSEpwM1QyZjhmREdrNERFamo5V3N6Rkp2aUNh?=
 =?utf-8?B?eEFYMEg5WVFzenRPMlB6bkFVcENrdThXK1VIdXdrOU9GTi9uUmZrQTRxck9Z?=
 =?utf-8?B?OGc4STZ0WVZyMWk0d3BTaTNqYkJwUWpNbEJrazVXdExBVnhFTTJjV3dEV01Z?=
 =?utf-8?B?MjdRTVZMS0c3K3Vsc21MN3orV0sxVlBVcXNLUXMrUHZJQldGWUdxd25veGcr?=
 =?utf-8?B?VGEwRXlxVEZscjF6bVEvQ1Q0MmNuUmdUMXFEMVdmOUM2czZJZzhvWnRyNXE0?=
 =?utf-8?B?UnRMQjVlNlRJMTBpRmNxUWtaZFJ6ZVppRVZjUFNNaEZhY0EyRmdGcDhiLy9Q?=
 =?utf-8?B?djhJUzBPOGlWY2Jwb3VQWkhnSHRnVFV6aGRCYjlncHhZTVpBazY0WFJ4M2dY?=
 =?utf-8?B?dTVYRk00cGx3bElFRlJ1U0JaQ1BMS2FuSFVIenUyRXdjb25wcVoxaXRNY3Zu?=
 =?utf-8?B?ck8rUW14QndMcGQ2RlFDRHRyWVVvdkFOOHM3Y3dubndxZFg5bGY2SHBFWmJz?=
 =?utf-8?B?RWcvZjVFeHNDZWxXQ0Iza0E3S1hZd0xXNVFqT1g2dW8rQW9BOENTV1VrdFBS?=
 =?utf-8?B?TkZTYUw2MlhwSjBpLy9zSTlvcVFrL3FkNUpoMHB1dUpwcy9yQWRQNGpCOGpu?=
 =?utf-8?B?NXBhUHZiUUVZbENWOXNlN3oyNWRIcmZyUGpMbDBhVVQwanlGdXg1VDFrRnI4?=
 =?utf-8?B?a0s3OTl0SkxwTE84akNDaFJJNS9GcnJ6MzhoK2RNZWJSeHcwSVFxa2JBNFl6?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 710cd090-d8d8-4dc3-4119-08dbe64b1e62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 02:24:11.3671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LX5wiwbJpwzWSZG4UC8SNt8d6ecAsYz94UkvwDZeHlRni7dOIUU0yrhhWayTll3Gy2gAcocroZqX6IdISMDJEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4924
X-OriginatorOrg: intel.com

On 11/11/2023 7:55 AM, Sean Christopherson wrote:
> When updating guest CPUID entries to emulate runtime behavior, e.g. when
> the guest enables a CR4-based feature that is tied to a CPUID flag, also
> update the vCPU's cpu_caps accordingly.  This will allow replacing all
> usage of guest_cpuid_has() with guest_cpu_cap_has().
>
> Take care not to update guest capabilities when KVM is updating CPUID
> entries that *may* become the vCPU's CPUID, e.g. if userspace tries to set
> bogus CPUID information.  No extra call to update cpu_caps is needed as
> the cpu_caps are initialized from the incoming guest CPUID, i.e. will
> automatically get the updated values.
>
> Note, none of the features in question use guest_cpu_cap_has() at this
> time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 48 +++++++++++++++++++++++++++++++-------------
>   1 file changed, 34 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 36bd04030989..37a991439fe6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -262,31 +262,48 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
>   	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>   }
>   
> +static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
> +						       struct kvm_cpuid_entry2 *entry,
> +						       unsigned int x86_feature,
> +						       bool has_feature)
> +{
> +	if (entry)
> +		cpuid_entry_change(entry, x86_feature, has_feature);
> +
> +	if (vcpu)
> +		guest_cpu_cap_change(vcpu, x86_feature, has_feature);
> +}
> +
>   static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
>   				       int nent)
>   {
>   	struct kvm_cpuid_entry2 *best;
> +	struct kvm_vcpu *caps = vcpu;
> +
> +	/*
> +	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
> +	 * are coming in from userspace!
> +	 */
> +	if (entries != vcpu->arch.cpuid_entries)
> +		caps = NULL;

Nit, why here we use caps instead of vcpu? Looks a bit weird.

>   
>   	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> -	if (best) {
> -		/* Update OSXSAVE bit */
> -		if (boot_cpu_has(X86_FEATURE_XSAVE))
> -			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> +
> +	if (boot_cpu_has(X86_FEATURE_XSAVE))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSXSAVE,
>   					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
>   
> -		cpuid_entry_change(best, X86_FEATURE_APIC,
> -			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> +	kvm_update_feature_runtime(caps, best, X86_FEATURE_APIC,
> +				   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>   
> -		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> -					   vcpu->arch.ia32_misc_enable_msr &
> -					   MSR_IA32_MISC_ENABLE_MWAIT);
> -	}
> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_MWAIT,
> +					   vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT);

 > 80 characters?

>   
>   	best = cpuid_entry2_find(entries, nent, 7, 0);
> -	if (best && boot_cpu_has(X86_FEATURE_PKU))
> -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> +	if (boot_cpu_has(X86_FEATURE_PKU))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSPKE,
> +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>   
>   	best = cpuid_entry2_find(entries, nent, 0xD, 0);
>   	if (best)
> @@ -353,6 +370,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
>   	 * honor userspace's definition for features that don't require KVM or
>   	 * hardware management/support (or that KVM simply doesn't care about).
> +	 *
> +	 * Note, KVM has already done runtime updates on guest CPUID, i.e. this
> +	 * will also correctly set runtime features in guest CPU capabilities.
>   	 */
>   	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
>   		const struct cpuid_reg cpuid = reverse_cpuid[i];
Reviewed-by: Yang Weijiang <weijiang.yang@intel.com>


