Return-Path: <kvm+bounces-5595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D4D8236BA
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 21:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9418BB237F5
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 20:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CE91DA21;
	Wed,  3 Jan 2024 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="viChOyZV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16961D692;
	Wed,  3 Jan 2024 20:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2RlBYihoM+9uaYC9Mli2XMZhRSVFPV+f+HYJjJJz4Gwy000yA28PcYyj5BIxPcYgvW7XMp2ZECzw7pWfz8MvC4iRPJq/IRVufhMrUVUPNarRKBGp66pwzqKCVLZWIB8vBJ7UnaqjgANQn8Mp9+Rz5LZnKnMoK4MoggpxNnTcB2OVqnEs15imkYjfDvyKhIqXffCqCa6rViojMKEZl7oU+1zkwBFfTbvyZSyXN6d0OeJBmL7bBiQ4OxK2ssEpaExWfhNejsu+u7NMmUebfnpF4rrnxkFn5cFHR67cudKVDBDiTYKaT48Eh7IOTyOJTf39HFzzh+yZZa9Z1cpnF2Ang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhrnKZnLSqz8oGrl7er0IyOscE+FqUwjlRkmJF3+z3g=;
 b=WhtYbKBK7He35B/viFtGg1b9rGeZiY/mTwt2iHYiKGbBa7UYDFPjJxKhDeagE9c2kpLCuUqGgekEPG/sKz0PGhtXFkcQNJghBlgED5tRW4zwUztPLMDu5pz0x6pPuUJrYwANRfaBRtW24sha5JDje5AWPMvM51+A6+Cgz/Q7ARbMUUfQqF/86MIOcVwDjbV2zD4dO3YIm4Bq6uxvGeSvWVmNicN31tXuy7Is52m8pX/S/BOwoGomKW638MmtZAGiFcKiHpF8lEeOHdOeIggZXolgy7hksgmvXVofj9DiDWH3YCO7s2t2oiR4Tmd+RwPgAhMEIeDWBcf3L7By4V1LIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhrnKZnLSqz8oGrl7er0IyOscE+FqUwjlRkmJF3+z3g=;
 b=viChOyZV/wyPS6JrnJ/Z4BKPO6+1M62EUcArOva8tW+VH6vOQXU3+zXxokHb956MN8kpOlNT4llEi1cOrwfXrzW+DiYJucDK0PaTDUJrJFsMjChF/1/1ecnaJobGUwpgwFcn9FUQk54gwHVx/A4pDh9IkzqMt6FTLceLFvcegpo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB6837.namprd12.prod.outlook.com (2603:10b6:806:267::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.24; Wed, 3 Jan
 2024 20:41:42 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc71:c26c:a009:49%4]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 20:41:41 +0000
Message-ID: <b82bb32b-3348-4c18-b07e-34f523ae93b5@amd.com>
Date: Wed, 3 Jan 2024 14:41:39 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/sev: Add support for allowing zero SEV ASIDs.
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 joro@8bytes.org
References: <20240102232136.38778-1-Ashish.Kalra@amd.com>
 <ZZSqkm5WNEUuuA_h@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZZSqkm5WNEUuuA_h@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0054.namprd11.prod.outlook.com
 (2603:10b6:806:d0::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f7e0a2e-486a-4029-3be7-08dc0c9c643c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mlXPp/Og8sWWmUYw6PZYOpWiSErxOGn5OkQfhWuSep9j4NVOe9vBNyTRiLji6ULA7mLcABwPnjOvx/fprjNWnH4ey/JdpepiVkolN1tL9ksyPlsJlfgM69v5WUHleXivrJCDA9pUZL7QK3+YsIhzmeuFqtnzbzdfu9rBVsH25DoKD1knPv3cg9YGPNVWjrr9FXQ+mG3Oii7YKkw8U0pLKEp7mgIRXhGyIW/4bby0DtY5PTfxi4FWuiRST7F4Ep4+TtXtPH7xwldO+d7x5F1vPnlv50S79GRrTRAaQQtSWpvZUhlYfDtdMSkkP4rwqZM4z8MW3z43xy1AZPaFWLyYqEwIhEin+Noxzu3o2N3enO8lu0TmvjWcwsOlKqPhlrBnIjyidyIsfSIFU9egQC46vUrLTE6ui1KLx9jjmgwz+erLHpEhV8s9wEN5JYlrNvU6QATNREbK+YjTTB3WpFFYEA6kJ78I12Gh8/Ll5ZYLu9dKk7DZocO1sx8gbvgJOBUJbOi9ewVi0vMN6UTO3X/jui5MYblXrTBxL8aC3fLi1rXC/Os1ecqBm4bCn2IV2NhPpFM4rXA0+2IKFe+dnqIlpqUgNhR6BEuwd1YiMYoIP20njsiIrUBdEO+xJI9aFFzrbRnWWqSv2v2hICHUq/+3Fw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(346002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(31686004)(26005)(83380400001)(86362001)(31696002)(36756003)(38100700002)(53546011)(6512007)(7416002)(4326008)(5660300002)(41300700001)(316002)(6506007)(66946007)(2616005)(6916009)(66556008)(2906002)(8936002)(66476007)(8676002)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZU40TStQblltbHFleCtFWmx4ZjlEL0prRTBSYWFDTk9XY0ZLSmx3ZURqUUtM?=
 =?utf-8?B?aVg4V3NjUi9IazBVRUl6dlhNWHVlRGdjSm9mNkJVMVZxTGJDcmtKdHNyMDVX?=
 =?utf-8?B?cWswVmVJOVNXZG80RldtRUloMEM5dk9FOUFqVGF5RHRZNVQyejF4Wk9zdWc5?=
 =?utf-8?B?aTU4SVR3cWRPZzREU3VhNFRGSVVBdDNpa3lPaThRQmhBdnJ5dU1TdmxCS1pp?=
 =?utf-8?B?OXdEclFzbUVQajEvRjE4MG1sTE5Ba0R1d2l5U0o3N0hzd2VJVkl2TmZHdEt4?=
 =?utf-8?B?ZnNLSTU3aGxKdlRYTENqSEg0VFgwYlhLWi9Kd0NTZW9UY25icW96b1lvSjZ6?=
 =?utf-8?B?eEpHVkJyWk9rMFhFeHJxbHNuck11Ukx1SE9sQ2ltdFhMdG9sby90ZHR2ejZN?=
 =?utf-8?B?K2IvMFllOGN4blVOcTBwTGtyVzNYZFd2NkwxSVViNlB0ZkxIUFAzYmdoN1pi?=
 =?utf-8?B?SGhEVWVQQk9OMkMyOGZyL1ZTSGVIRnBGN2pSQ0Q0RXp5SThWN0oyTi93a2Rw?=
 =?utf-8?B?WTRkVVpleXZ4V21OS0R4Q0laQ041Q2hhN0ZYQUw3QjZST21kZnJZZ3F3MTd4?=
 =?utf-8?B?RTlta1JKNCtUc084M2Q4Tjl0N1J0THNCVUZyOU1uWUQ1Tm9YbjM5YXZrNHJa?=
 =?utf-8?B?ZnNZcllvUDNocUpZMXJyRFFJcXhkVlRzd3BVQVlTaDlEcjRscEMzUVRyRzBS?=
 =?utf-8?B?U2h1ZmtSeTlERzV6STZkWGdaa2tucFRvUjd0STRVeVBIajNkNlBsWWRXUXQx?=
 =?utf-8?B?MFZGMTU0MVNwRkZRcTJOY2VFZy96QkRFNHA5RFZJK3A1QzFQS3ZYQUY2RUJo?=
 =?utf-8?B?Y3NoZXdXemhGVEExQXIvYkVqUUtidGJNR0Z3dVJpcEZzZ3p2Y0NuSFN4azM0?=
 =?utf-8?B?SjJvR1F3VXFOTGF2WnNVcGZCWTBveEc5cS9YT1RZMUhNQmkwQVh0UlBVZXp1?=
 =?utf-8?B?dTZsNEVkRUlzbXRJbW1OTHhyMmZCVm5XSkJjRGVsWkNlQm1Na3NCMzh5c3hM?=
 =?utf-8?B?TEFKSTZwbFcyY05mcklQYzRML1p6Y29YSlZaNHF2bTJMKzRVOHFaTEd5REU4?=
 =?utf-8?B?YVlsTUF6MllDUk8rZTcxS3lpNlNSMGgvanpRNkpoTGxyaG1nMS90NXg0ME5Q?=
 =?utf-8?B?WmVsRFE3S0R2c2VRUWd3elZoeXRwZkhuL2hnS2xQanB0d2grcnFkMm8rUDlw?=
 =?utf-8?B?TlFydzZYQXdKWC9uY0tRdjg1UTVDS2VVY2J1czZHWkkrLzN0bmd1UDdYTElK?=
 =?utf-8?B?ZWtlb2ZRV25yLzk0dVl1WndRanR0WkdpbkFvUlg0K3pibGl2Ky9La0ErZHBq?=
 =?utf-8?B?MnFXTWJOR0NxdlhJY2Yrc1hreFFNQ254S1VTS09LdFNPWm5PNERHMFoxR2hx?=
 =?utf-8?B?YW5aYVBWU3I2TS9iVlhVaVk5L1I5YjR0NTg1eFhMOEhvU0JyWTFxNjYrb0VC?=
 =?utf-8?B?cGpQVm43SVQwL1JMMGttTEpQTk9FajVBZkxCUXpWMlNzUzdxM3B6U0xBNkRy?=
 =?utf-8?B?aGxlMVhrSzhDY3hkNWxLYUpqSThzbjdCblpvZ0NNQVRQNVZXdjR5MHlmalEx?=
 =?utf-8?B?WXlnR0NKTHBMSmdnRXlZRlYzVUp2UTkrVW1QMTZMMFdhc1ZHeGRHMHUwV1N0?=
 =?utf-8?B?bU90T1hXRVhMcUhHRmJFcWp2cjJKRUc3cDhzeHRPTnpxTVRZS001Tlpic1JN?=
 =?utf-8?B?cDY0TUY2Vkl6OHFRS2Z5VzgrUGF3YkR6RzlYeURBQWlBM0JnTzN4TGZNa2VL?=
 =?utf-8?B?dGpQR2Ywc3NoNjQvT1R5bWFnZzhqMGNKbHdTeW9IeWloM2IvVnM5S01MRy9j?=
 =?utf-8?B?ZnJTQk02eVRwU2RFRnp0bGFQWVVTSjNjazlPY01nQWdZQ2J2V2hoamdTeURD?=
 =?utf-8?B?QTRWK0FmcFhkT2FxeXFpSVViV1NJZ3ZRQ0J0S3lXYnhkcUExd2o0eUZNQXlH?=
 =?utf-8?B?Um5NVkliaTZKY2dRQ2hORjRKRGlGWWgyNW9DejNPUUt3eW1rRWVFNW5QTlFq?=
 =?utf-8?B?YlVwVGwzekFLYlN2NkR4UU9XUlJmcGo3ZUhRNjJiWVRJc0tnZTBGTlp2bUlm?=
 =?utf-8?B?OVh0elBHZEREQVNqUTlsNTlTT0JsazlpbmtHTWhtM2VRRG95UCtkd2YzeWk2?=
 =?utf-8?Q?3K2SAVLHeKe+epq9INjaftLBl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7e0a2e-486a-4029-3be7-08dc0c9c643c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 20:41:41.7445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lWuGO6VQHqCAePDtLxHOwBrpfTs5gWv7G+75oNGkNYaEkv9c2OUPIBuNSBc54dHR2EU+Og5049rDaldmGbu+1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6837

Hello Sean,

On 1/2/2024 6:30 PM, Sean Christopherson wrote:
> On Tue, Jan 02, 2024, Ashish Kalra wrote:
>> @@ -2172,8 +2176,10 @@ void sev_vm_destroy(struct kvm *kvm)
>>   
>>   void __init sev_set_cpu_caps(void)
>>   {
>> -	if (!sev_enabled)
>> +	if (!sev_guests_enabled) {
> Ugh, what a mess.  The module param will show sev_enabled=false, but the caps
> and CPUID will show SEV=true.
>
> And this is doubly silly because "sev_enabled" is never actually checked, e.g.
> if misc cgroup support is disabled, KVM_SEV_INIT will try to reclaim ASIDs and
> eventually fail with -EBUSY, which is super confusing to users.

But this is what we expect that KVM_SEV_INIT will fail. In this case, 
sev_asid_new() will not actually

try to reclaim any ASIDs as sev_misc_cg_try_charge() will fail before 
any ASID bitmap walking/reclamation and

return an error which will eventually return -EBUSY to the user.

>
> The other weirdness is that KVM can cause sev_enabled=false && sev_es_enabled=true,
> but if *userspace* sets sev_enabled=false then sev_es_enabled is also forced off.
But that is already the behavior without this patch applied.
>
> In other words, the least awful option seems to be to keep sev_enabled true :-(
>
>>   		kvm_cpu_cap_clear(X86_FEATURE_SEV);
>> +		return;
> This is blatantly wrong, as it can result in KVM advertising SEV-ES if SEV is
> disabled by the user.
No, this ensures that we don't advertise any SEV capability if neither 
SEV/SEV-ES or in future SNP is enabled.
>
>> +	}
>>   	if (!sev_es_enabled)
>>   		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
>>   }
>> @@ -2229,9 +2235,11 @@ void __init sev_hardware_setup(void)
>>   		goto out;
>>   	}
>>   
>> -	sev_asid_count = max_sev_asid - min_sev_asid + 1;
>> -	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
>> -	sev_supported = true;
>> +	if (min_sev_asid <= max_sev_asid) {
>> +		sev_asid_count = max_sev_asid - min_sev_asid + 1;
>> +		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
>> +		sev_supported = true;
>> +	}
>>   
>>   	/* SEV-ES support requested? */
>>   	if (!sev_es_enabled)
>> @@ -2262,7 +2270,8 @@ void __init sev_hardware_setup(void)
>>   	if (boot_cpu_has(X86_FEATURE_SEV))
>>   		pr_info("SEV %s (ASIDs %u - %u)\n",
>>   			sev_supported ? "enabled" : "disabled",
>> -			min_sev_asid, max_sev_asid);
>> +			sev_supported ? min_sev_asid : 0,
>> +			sev_supported ? max_sev_asid : 0);
> I honestly think we should print the "garbage" values.  The whole point of
> printing the min/max SEV ASIDs was to help users understand why SEV is disabled,
> i.e. printing zeroes is counterproductive.
>
>>   	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>>   		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>>   			sev_es_supported ? "enabled" : "disabled",
> It's all a bit gross, but I think we want something like this (I'm definitely
> open to suggestions though):
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d0c580607f00..bfac6d17462a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -143,8 +143,20 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>   
>   static int sev_asid_new(struct kvm_sev_info *sev)
>   {
> -       int asid, min_asid, max_asid, ret;
> +       /*
> +        * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> +        * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.  Note, the
> +        * min ASID can end up larger than the max if basic SEV support is
> +        * effectively disabled by disallowing use of ASIDs for SEV guests.
> +        */
> +       unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
> +       unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
> +       unsigned int asid;
>          bool retry = true;
> +       int ret;
> +
> +       if (min_asid > max_asid)
> +               return -ENOTTY;
>   

This will still return -EBUSY to user. This check here or the failure 
return from sev_misc_cg_try_charge() are quite similar in that sense.

My point is that the same is achieved quite cleanly with 
sev_misc_cg_try_charge() too.

>          WARN_ON(sev->misc_cg);
>          sev->misc_cg = get_current_misc_cg();
> @@ -157,12 +169,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   
>          mutex_lock(&sev_bitmap_lock);
>   
> -       /*
> -        * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> -        * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> -        */
> -       min_asid = sev->es_active ? 1 : min_sev_asid;
> -       max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>   again:
>          asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
>          if (asid > max_asid) {
> @@ -2232,8 +2238,10 @@ void __init sev_hardware_setup(void)
>                  goto out;
>          }
>   
> -       sev_asid_count = max_sev_asid - min_sev_asid + 1;
> -       WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> +       if (min_sev_asid <= max_sev_asid) {
> +               sev_asid_count = max_sev_asid - min_sev_asid + 1;
> +               WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
> +       }
>          sev_supported = true;
>   
>          /* SEV-ES support requested? */
> @@ -2264,8 +2272,9 @@ void __init sev_hardware_setup(void)
>   out:
>          if (boot_cpu_has(X86_FEATURE_SEV))
>                  pr_info("SEV %s (ASIDs %u - %u)\n",
> -                       sev_supported ? "enabled" : "disabled",
> -                       min_sev_asid, max_sev_asid);
> +                       sev_supported ? (min_sev_asid <= max_sev_asid ? "enabled" : "unusable") : "disabled",
> +                       sev_supported ? min_sev_asid : 0,
> +                       sev_supported ? max_sev_asid : 0);

We are not showing min and max ASIDs for SEV as {0,0} with this patch as 
sev_supported is true ?

Thanks, Ashish

>          if (boot_cpu_has(X86_FEATURE_SEV_ES))
>                  pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>                          sev_es_supported ? "enabled" : "disabled",

