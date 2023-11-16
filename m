Return-Path: <kvm+bounces-1865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B57027ED9ED
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 04:17:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D81DF1C20AB5
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DAA7476;
	Thu, 16 Nov 2023 03:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kuf5nSls"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE2C19B;
	Wed, 15 Nov 2023 19:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700104653; x=1731640653;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mQIz4zZ3lhgmbgyO0lRQkKee29SvdYP/1sVRsmS6p/c=;
  b=Kuf5nSls0+y+nEHCmbZRdVNE2P+/ktSo7x6AVIaqH/ReqnBh5H7klO0b
   bIiawa2Gev8RiEzOFgPJj0t6U9MYvqAaV5p/8+yzGE/MEb+Rwg4dMR2Tz
   Gx/gWjYlBBuRTkhamaKY8hh9jwRtMozMLVHSuE7gYb4bdHEhub8tmRV26
   MIhcqTiEe1FCFb9B4Hs3TPo6SXOjwXPWuD3jKbEBW4XLNZiJCR1NqyFY9
   38VZ9FYHeva9aoKAV9ltZ5OiTndSZ66LXU7Lpax5j8/EHc0MxdKb/Ltqf
   LqSskz1aSIWdnTACTZhFjpLeUss9TG8YSc0VpdAYdslsCGvopc7pcKVEn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="12556192"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="12556192"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 19:16:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="855850779"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="855850779"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 19:16:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 19:16:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 19:16:52 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 19:16:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVRhtooudHEir/M4yS4LEsTxqAP8ef4Iq1a5HtysQ2DAxWMdZaBawuD4UHFkYMM4brd0mqGOhO2hPgAeQcttE0C5XIeFKgrabsAThFWi+ohcVfFCHZNZxI4YCjcoSkburUQEoBDrSf4uel7wB4rTKrKJj7YIZAhSQXA+vIOz3wvn3GX1TrYIrDoamE/YODH90X8YNsV+9U6OZSycpeENSlpc9hqB/rFaoP0vNNXdscKwugQdldYO3QH5PKLOgFzISosWpxfA6Jpd7ifOWGAKsFJPorRDkdBT4pRFQzX3yytDos1OJp3TunbkG4jJ3GuW+eSVihJKxi3A5KW42ZKzGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rH0tw7yscKsbSE3p8IoRz6f2jBlF4SG4btyXcAHAraU=;
 b=AeyHmAWGH2kjeqv1T1cMpSTN3GDH/fPr/KfbJfJY7YZ4OFLC+clkYlRNxWIlvPcu8teaCnEMlZ4MQ0TbkG3fB3Q+hJhTPglDp60z7TrmobXVhpbRnv0XF/C6zhj705k8oQ/+GxpsBuGWCZq2YI2li8QWQ5T9y7aK48TgvukFkhgTZniBO4ErglCsZKiOs3E9KtO5qkz4Vb9jpOjh6wBnqzwSiHEXFvTEqusIxQp1aihLLKajWmOQAm4xm2QYY8ytZF2gZB9dJqeQf7stTxu4c1HmTcUkTdl1AF9J9s0Q8Q4Gj6g5ZXJa2dofIuD3cEZ6+aZt+6ugoeeZAPqFsdUZ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7854.namprd11.prod.outlook.com (2603:10b6:208:3f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.18; Thu, 16 Nov
 2023 03:16:50 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Thu, 16 Nov 2023
 03:16:50 +0000
Message-ID: <c9f65fc1-ab55-4959-a8ec-390aee51ee3a@intel.com>
Date: Thu, 16 Nov 2023 11:16:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] KVM: x86: Initialize guest cpu_caps based on guest
 CPUID
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Maxim Levitsky
	<mlevitsk@redhat.com>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-4-seanjc@google.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20231110235528.1561679-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:3:17::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: da585d2f-c222-4fc7-e0cf-08dbe65278fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eF5wh92YRPYzoJ4O0y94QK7U4NB9+gSbHlqUijuOSCNzSQYnPnFAk8YYqlx8tI+e+EFjbHjvJNchLU8UtUjW0r8GWXh6WhORNWfnlNkBSftiSLjIzEFzRqCr7nucOMejaYcPN4tjtlSFJ7a4EvuM8s6AylK/z1EFQmjfe2u116IQCV7/WAiexJaqZUtsBVWwHDagNMhyz4qqnDS5Xl/m0Angy2Aj02/O0U+F/oDZ/eH5lqnMBdcP4GMpJi2x5cApAm/2RhvL6swrgDce0vX2RkZvwkkHrbowH9ZUNg3fJA10bCnB0kT/p4ZDwGMQ7NFsxQ36Uz37bN+4R25z+lDhslFIyCY6axx18hztMF93/9V9yFr6t8byMoNbW+wOxd1PuWqrE1UmIZOYNOsJJSz0lJoWOS1LdSwi7fzVqc172XVtmkxJc3pPdHyPBmPJO9+dFACbrkO38P7+HkHPpGT5mGCwQGhAFQg/MFzQUysE1Bo8jv4zRFY0IKB6cM2kxtzfVUK1+9MGlR2WvKLzBKKDKoXwkQv0RhC2cXIcRVyrOFUjIX87whIDB5bYXKoLHiraBzIxRdkGLE9nh/ihpVcJXFTjrI3dUOevK835I4tdz5DDMqMNcoP4gakueFZyWHufr0YLJoXvdSIh9lGwEyONyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(38100700002)(83380400001)(110136005)(8936002)(54906003)(66946007)(4326008)(66476007)(66556008)(8676002)(31686004)(36756003)(41300700001)(82960400001)(26005)(31696002)(6506007)(2616005)(53546011)(6512007)(6666004)(478600001)(6486002)(2906002)(316002)(86362001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHRZTk42MmdRQmZJbzE2NG9RejBKV2oxZG9VV0lZdlBYZjcwMSthOXRqcGFa?=
 =?utf-8?B?TUxiTVhlS05CcXJDaktILzA4Nm1Jd2pXekl5STdQb1pFMXNkQTR0NVhrY2hk?=
 =?utf-8?B?UkpteDBvZmtQdWJwaS93ZnFrSTZlNVROblExLzloN1dXTkJJQktxakdiYkJz?=
 =?utf-8?B?WmVLcUJ3YUt3bnJ6ejdkbnFYRG1DaGczSEVPY1ZKVHl6YlovRzcxR1h3ajZv?=
 =?utf-8?B?QVNDYkVGa3ZTOGVMZG1tVzF4aGF0WjFCQWxmU0FNM1VJOHRhcTdXSXpQUlBn?=
 =?utf-8?B?N1NpNHo4MU5DeFVMUFFUOVE1ZTFnTnczOEhIa2wvTnFJQ3VidkgySVZ5aVVr?=
 =?utf-8?B?dEFWQnF4Tjk5SFhaV1Z3QjRSc3lHTVR4WGMwdDRMREN4a0hWVmxwYzRXalhW?=
 =?utf-8?B?UDJCM3ZPMlRiSnVMdXZzQkE3Qk1yckdjQ0xBM3JqOElsZlVEWWtGZFdGUm02?=
 =?utf-8?B?cTBqZWh0em1GV0NzQnNNNXVVUTE2QXEyTzJoVlUzVGVrTllGYlRzc0hiVDhT?=
 =?utf-8?B?RnZUSVA5QVljcXpqcDUrWkhzRUtyZkVoQUdyQ0xyUTFNaUI2WVd6T3E3aHJt?=
 =?utf-8?B?d2FyV2JJaEtzK3BSdHMzZWNUMFRZa1RLWkFkU3lWLzRRN0lldk45QnNvZWRD?=
 =?utf-8?B?UDVlZk1pc2hydzNHTGhtVmN5VTZyVG8vNEFVSkpKTkxwSGV6L1BXK01MMnpm?=
 =?utf-8?B?YWtINS9JdGRLL0J5U3pkcG45dlRwSU1VdSthUVVtUWJqNHdKajBOSUduUlFy?=
 =?utf-8?B?VVNQN1gwU1VIc3VrdVV3Q2RnYm5IU2dnTmQyZDdlSmprWGdqbVUwSHg5NWQz?=
 =?utf-8?B?TWJJMU8rV3EyTG9iT1pEYzAxZnMvOHVLWHFyUVd5SDdxVHJ1S3N2cjZ1MVc5?=
 =?utf-8?B?V0NSR1YvOFlWZHVmQ2JPN3dJdUozTmxQTFdaZmdBa2l4WEdWUkxRZGxDK1pv?=
 =?utf-8?B?MU5nVyt0cGNKcDJ0bDlxOWNuOTNVNkhKa0JkTUdldDU1Tkp3NkFXUmxTYzFl?=
 =?utf-8?B?QlExbndsNll0Rk9YZFJJV1IvaFNxb0E4L1U1UlZUYzlUZTNKSE9oOEtZLzhq?=
 =?utf-8?B?cmdkWnI5VzhJbGs0dW51SWN5S3VmaW9kOFNrdzVxMHFIWnFJTWFDbmhIbmVy?=
 =?utf-8?B?Qk9sYlJKSHpxTlZFSW0zc2gwTDk0OFlLMFl1VFlZWXNBZHRHL2Z1QUVibUFu?=
 =?utf-8?B?aEFjOHJiNXprakJNeUdNL3dCaDhHL0VudjhDbVI0MTZFcXhHbUlFT2JPY3lS?=
 =?utf-8?B?Z0trbWVJZWpkRHpmK1VTV1Z3VnZ4T3JzY3ZUZXFKN3lpVEZ3ZU1HUTZnK2dq?=
 =?utf-8?B?RU9XWS9Vd1A1SDJGZkwvaVNXK2Fhc3gxZytWT3lYQndrSERmNnNxSitGOWtq?=
 =?utf-8?B?SEVWVW1sbkh3b0NGUHRKYm0xb0p2UGNvdllxVjQwb1NoSlplakhTc1FHV0hW?=
 =?utf-8?B?amJpZ3ZIY2dTSVV1cW5JSUJSMjlLaXVBQk1uMTFLOGdGRUNzV0dMODhBa3Ri?=
 =?utf-8?B?bFBla0RwUVFmNHJoVlpxY1g0VENobkRET1lzRTVUTUtSSFRKRUROSUM2ckpY?=
 =?utf-8?B?REx5WURzM0crdnBob3BvYnhOZUhHR3NDU1E3K3ZSQWtlWFYvMGhWVTJUZkZi?=
 =?utf-8?B?eWNhU2k0QVhBMEJlZUlyMktmVFNsR1RZaGdROXRKVFJzdk1lU004bWNsMG5j?=
 =?utf-8?B?ME9ycy9BWWo1bi93ZFpvbzE3V2lwSUxWQmlEVVo0cHk1VFZ4SWhISnQ4NkJP?=
 =?utf-8?B?bkRRTUFzdzcyaCtNTzd6SGs2dEV6dWk4b3RUTExLUk5LczdyL2cremt4TlRu?=
 =?utf-8?B?ajMzd25zVi9BeGJLenkrbW1LWm5zNkRRbmFxS3hydzNXSnY4Qk8vNVFLa1Fl?=
 =?utf-8?B?cDYyUWEwMEhNNEM5SXJmb0NQbjU5YUVDMld2UFFKN1lWaHREelJjaDRGNU9T?=
 =?utf-8?B?bGcvckU5VSt3TlZYUzRlaDRmdXBKcE5CVVAvT3VGNFFncDZ4S3l4bFRJK1Mz?=
 =?utf-8?B?ZWdYZitqU0Izc3FyY0F1ZnEvaUpXMGs5U0cxRmVkSFBUbWFvSUxuamViTTlJ?=
 =?utf-8?B?cSsyQkY2QTN4YytqeXRJOWhEOWdSZ3hCYjVRaUxvWXpJcU1vNnNkeFZ1eDNt?=
 =?utf-8?B?MXViSmxQWHlkUmtCL1BrRmxCR3VaUjdwdjN4WVU1OGlDTWVKcHgzd2dhZ0Nz?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da585d2f-c222-4fc7-e0cf-08dbe65278fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 03:16:49.9426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrJHsW1gvsA3jUij2OaEFCGq7waJPnhFAGdrbD7MfKdnf+qc4ONJcI00XcpGdfUvfYvDALA4DE2iQyrPmHdSYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7854
X-OriginatorOrg: intel.com

On 11/11/2023 7:55 AM, Sean Christopherson wrote:

[...]

> -static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> -							unsigned int x86_feature)
> +static __always_inline void guest_cpu_cap_clear(struct kvm_vcpu *vcpu,
> +						unsigned int x86_feature)
>   {
> -	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
> +
> +	reverse_cpuid_check(x86_leaf);
> +	vcpu->arch.cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
> +}
> +
> +static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
> +						 unsigned int x86_feature,
> +						 bool guest_has_cap)
> +{
> +	if (guest_has_cap)
>   		guest_cpu_cap_set(vcpu, x86_feature);
> +	else
> +		guest_cpu_cap_clear(vcpu, x86_feature);
> +}

I don't see any necessity to add 3 functions, i.e., guest_cpu_cap_{set, clear, change}, for
guest_cpu_cap update. IMHO one function is enough, e.g,:

static __always_inline void guest_cpu_cap_update(struct kvm_vcpu *vcpu,
                                                  unsigned int x86_feature,
                                                  bool guest_has_cap)
{
         unsigned int x86_leaf = __feature_leaf(x86_feature);

reverse_cpuid_check(x86_leaf);
         if (guest_has_cap)
                 vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
else
                 vcpu->arch.cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
}

> +
> +static __always_inline void guest_cpu_cap_restrict(struct kvm_vcpu *vcpu,
> +						   unsigned int x86_feature)
> +{
> +	if (!kvm_cpu_cap_has(x86_feature))
> +		guest_cpu_cap_clear(vcpu, x86_feature);
>   }

_restrict is not clear to me for what the function actually does -- it conditionally clears
guest cap depending on KVM support of the feature.

How about renaming it to guest_cpu_cap_sync()?

>   
>   static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8a99a73b6ee5..5827328e30f1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4315,14 +4315,14 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
>   	 * the guest read/write access to the host's XSS.
>   	 */
> -	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> -	    boot_cpu_has(X86_FEATURE_XSAVES) &&
> -	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
> +	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
> +			     boot_cpu_has(X86_FEATURE_XSAVE) &&
> +			     boot_cpu_has(X86_FEATURE_XSAVES) &&
> +			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
>   
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_NRIPS);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_TSCRATEMSR);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_LBRV);
>   
>   	/*
>   	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
> @@ -4330,12 +4330,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 * SVM on Intel is bonkers and extremely unlikely to work).
>   	 */
>   	if (!guest_cpuid_is_intel(vcpu))
> -		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> +		guest_cpu_cap_restrict(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>   
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VGIF);
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VNMI);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_PAUSEFILTER);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_PFTHRESHOLD);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_VGIF);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_VNMI);
>   
>   	svm_recalc_instruction_intercepts(vcpu, svm);
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6328f0d47c64..5a056ad1ae55 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7757,9 +7757,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 */
>   	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
>   	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_XSAVES);
> +		guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVES);
> +	else
> +		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
>   
> -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VMX);
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_VMX);
>   
>   	vmx_setup_uret_msrs(vmx);
>   


