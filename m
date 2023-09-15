Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E8B7A20D6
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 16:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbjIOO0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 10:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbjIOO0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 10:26:32 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080EF1FD2;
        Fri, 15 Sep 2023 07:26:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRGJJtcyUGxKOUQL6/71e6mNxEpWiUJqujsjNYq4Ld6yAu7pWo1VPF4tQF6Nx2XwZd2ymmRi2nPE/UgxzmYly1oe5WvVooBe9qewxbnDJYT6tLpbHXOn+580Be1LTGVxku+dI79NiUvZ2i8s9gjmYLgvjxM2FmgGwQ3pALDN9myMBSYHA0WteBmYeFRy7OLU0w9+Ya5OGsozB3QFtfNdO8iDOPS5n+JFrmi15CnWM3Xa9c9pLCuaKxGKiaLv/6OKAx9ZuCVAA8/sfQUFhlpqgKhMt82ytDFWDOIX6PC16jG0A9ZV/T9NarWrPktEIiBGcP1jcTn0DPkGzOBZcElaFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVl2sHTUylLVe32EPwOl9aQDDMDafc6Tz/TlUhf+XKU=;
 b=C8jV4hvO9k2I16+3mSsLDAI1qfDLiO/fRKANp/9ThyE4P+kafpYvnL/Cs+nUtZyHRLqUgfRbVRgrUEd1ffthF3IR8K4BGIa0tA0oyl7nGuANyDwjKhH0ytmClXAL4lT4jQx8/lHYq6Ik9lnTTEnl0i6pSXQ4IDatTIPzAJhGCg1GAQObZSDnyZr+MQ789es1153Njr+AWZLouMZ03a1Xf9inQuNohpE5K4xDReRAtRrtwzZRJ+fCMlW4Nq+IjkbTjNGEBxlNaoc+BvIsVd6s/NoGjzZ5G50/fqYcasO7uw8ghFfMs47IVD1sAdyL835ecBtdu6vVLjG3Eai7eHYiMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVl2sHTUylLVe32EPwOl9aQDDMDafc6Tz/TlUhf+XKU=;
 b=s2qtKNl0kWR/M+ewTGBPJ6s/OZw1KD/Bkpq/5oI3yiFfHXGSfri8Vr9uc36+qzz0sLulRuTd5zuHTjwagmvEf+DFPqrUo2pgPgyCQTYlt3TKxEOohe1PkJyprIjk2E3MRgyuV70bG8W/rrZDXVlcVwyYeqEFT9x141hLc6CJeP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY8PR12MB8410.namprd12.prod.outlook.com (2603:10b6:930:6d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 14:26:23 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 14:26:23 +0000
Message-ID: <1e155a46-78f3-51f4-40a0-a94386e8f627@amd.com>
Date:   Fri, 15 Sep 2023 09:26:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
References: <cover.1694721045.git.thomas.lendacky@amd.com>
 <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
 <ZQNs7uo8F62XQawJ@google.com> <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
 <ZQN3Xbi5bEqlSkY3@google.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZQN3Xbi5bEqlSkY3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0075.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::16) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY8PR12MB8410:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a0db2e1-ff3d-4eaa-fc3a-08dbb5f7bcf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7sAeOAgpzx46kUYbT+XC1UHadVkLmmPsJBiFkgN2NcaOWALZz0SGqZb1cLmDbkLEazOEssrja6ljH9GHEJlb1NHP9lZkG7P2mP1bvrzUPEtXTNkUL7ORgJScVpYcp8647G2O+xC6UbxQ4BHfGtk8dYJ8tzXL8QSoUY2Xv7ICS5IGnQ6viQzysd8bt94ytOYc/WPV1bUnLDsJeknFItN3zT/Nw96b6nl7GAvA37TX8oFZXabvoZ6rMSWtWIDSjg2iIuIfYnvKZ2O3g+/lumzV5N+n4cr5v/cVVAxq7foiMbiFI75Bg00QKCCk0OERkfhZYKkjps5VIsxx+XkDjFsx4HmloM/yOWaLIj92eBLynoImjlMVPelOnU6CU9Q+tw1YwLe+78+R8QBlORRYFRgEFFZnJM/wL/olPYANS62QOA5DhM4cbERTa+8L/IrXDH3qM5v68XZkck6BXQK6d9IY/8Z5+ki/tyICGdBvHDQ8Mn9egzEXbTz6UzEXpLqhEL6c8GG2aym02dvGKe+3SiX7o6GQPeWMqRQ9Qs5jdXTWeXvB184N95oeSFYzMkFMdcvKnXH362BwMGr/Zh6qdjzuee6xwtWYFb9PBHATvXbRStKB0iv5/6uWqUU8L5DYyrAz0JF9TX4kCxDuLjoY4JSPxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(186009)(1800799009)(451199024)(6512007)(6506007)(6486002)(53546011)(26005)(83380400001)(38100700002)(31696002)(86362001)(36756003)(2616005)(4326008)(8676002)(41300700001)(5660300002)(66946007)(6916009)(316002)(54906003)(66556008)(66476007)(31686004)(2906002)(478600001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SU5raFg5WitXVkl2TDd2NDRTbTVmV3FQQlRYM0NHWGdGM0JwYmk5MlBiZVlW?=
 =?utf-8?B?ZGt6bG81T3VDNmYwOTlZWW1QRTRXb3JBYmlYVXMxSU1vbmJoTnRFTWhITFM4?=
 =?utf-8?B?OWFnMFFaRXB3WFkzbVhzRHpldExNSGNTRjcvdWFQTEs5WlQwRllmZEwrcys1?=
 =?utf-8?B?UlVvdWF6a2E3aWdJSGVXY3V3RXVlbGxTYlowYzVndVN0VHdpOStLQUIrUWh3?=
 =?utf-8?B?QWlMeXNYdmNjWXJuaXBNeE4xdUhyeVlLcmFpa2NvdHZ4eSt1LzJGQkcyajlr?=
 =?utf-8?B?TGEvWjFRNGw0WEtCeVN1M3JNN092NHRIa1I0ZUNNNFEvNTdRUmRvSVBTRmcy?=
 =?utf-8?B?UnRoV1NhTDhrRUw5Ri9VczQzMXB1TDFvR3ZZRzU4SDJiUEN5ZDRVV1ZWQ21I?=
 =?utf-8?B?TmNVTm9Xa1d1MzVZSlU1cnZUVHVpQ3dnQmg4Mk54UUpVSjZ2bjNLL000Q2J6?=
 =?utf-8?B?eW1GNzVqRVkzZ0hPMkhuVkNQWmVScExIaUNXUitxMnhZZWJSeHlBdlh6TXho?=
 =?utf-8?B?NGp1WDBSVWxuV0VXTkxFWmVFc0pZYzJxVlpsYnRWTjMzWGI4cHdmRVErV3BS?=
 =?utf-8?B?R3pqWUFZdUcvYkVoUGc5RmNYRjF4aVB6MjBjazd1VzE5UEd5YUVKa3ZYYkFK?=
 =?utf-8?B?c3gvZmhBZE05MEtwenh0bHh1TURyNDRFdFQxczUveW5TWXlLWlRvUHJ2b2x0?=
 =?utf-8?B?b1EvQVVIREtmUENyMS90c3BzdTRLejU5NU52T0Exd2FxNHdmbWFYWWhRenhF?=
 =?utf-8?B?elcxU21kaWRodDlNNCtmaWRIMVdxU1B2elpvN0JyR0pVelUwTHRzWG81ZW1O?=
 =?utf-8?B?VG1TTjNZWEh1S3dBaHcvT0svMVhOWmlnRWFOSElVSWcrWUw3NTVSSEYxRGFt?=
 =?utf-8?B?SEllRkU5K01oY01oSytVQU02STFMZmUyY2svQUk3cGtEaVBKbkJCZkNZcGUz?=
 =?utf-8?B?bEdRNm83aHpkRmZZVzdqejF3Nk9QNUJJclZkTjFKUEY5OWZZQXlSVUZ6d3I5?=
 =?utf-8?B?TGxZYjR5dTE5VVFMazE4QWZUTUJpbGdzY1MwWG5wSjRvWnEvMUdDTGtWU05p?=
 =?utf-8?B?b1dYYWpWdnljdTUyekU1RVloNG8raEpoR210MmtpQkNNZThtQjN6d0lLV0k3?=
 =?utf-8?B?ME4wZGlXcEJLaVovdlN6ZnZzMnVJczlwKzlTSTVaT1QyUlRYWXk5cWprVVB6?=
 =?utf-8?B?QUNWajduR3ZpUThlQUNOdTNSdkJBTGFoWjB5L2hCTUc5RmpBOGtaSlEvQU1P?=
 =?utf-8?B?VlJTdDEyRjNGaGZtT1VER0o2N0RVa015L1gxSS9pdmd0UkphUmY0YmI1WHk2?=
 =?utf-8?B?RnBqMHRpWkYxZWxuS1F0VDJwZGxTNTAvVUdsRVBFenhoWW81eWFFT0pPYklX?=
 =?utf-8?B?R3h2OWtJRnRoRUNSRUZDMTltaHBzazdDbU10cEU3T0ZuV0ZZYkwwTHVUNFRz?=
 =?utf-8?B?bmdyQkhwOHlCZHZXQlFMK1pOK3A1SnluY1hLbzFkU2ZaaXk0VC9Uc0E5SnZM?=
 =?utf-8?B?RjJtaXljMjZOS3l4VFd3RlVwZk92eTFSZmlkTkQzbEJTYUdXaEF1QUYvdkhu?=
 =?utf-8?B?Q1B5UDlTMSttbFl0Wkx1emQyVzNLQ2F1N2wrN2VSNWhGWnVQaVAyRzgxaGc3?=
 =?utf-8?B?YmNObXRkaGtYdXQ1SXZDZHlIcVU5dTFaV1I1NlhRNUN2UUJISUxnRHUvSmF3?=
 =?utf-8?B?VUpGUDZNdGtwcTQzL3VBRUNoQ2I5QUorUTVBUlVibjhuTUZCMi9YNXhHdEpt?=
 =?utf-8?B?cWlnb3BSbEhyOTRhWTNFZTRUZjJGWXhiTXpERjVUZmNoY2wvaVJFcTVacGZI?=
 =?utf-8?B?UUtEL005elVnZm9NdE1BMXFyaWxtZU51Z0Ztd1FodXhUeWhEOEFlSzVkdFFU?=
 =?utf-8?B?UE8xNitDQ0FTcVJLbGJqMFVhNndNYXdQVU1NWjBjdGQ0WUZhR25VRXhOM3Jr?=
 =?utf-8?B?ME9MWGJJbVluZEVHOG1FVHo4b01iK3YzeDRQS2s3SHRPWkhEeEJUSGRWWXpu?=
 =?utf-8?B?TDdQMUE1cXZLWmFtbFZ5RWl2UUxUdjQzQXRFT2ZFcUU4cVI0T3lWK25Jcjl4?=
 =?utf-8?B?LzlqaHhLalVwTnhaUkNzeVlUNVVBZjg3S3dSek5iY0ZTY1hFc1VpNzFkMTZU?=
 =?utf-8?Q?1WgHDBoSDB5z8LpHikMPTeqZ7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0db2e1-ff3d-4eaa-fc3a-08dbb5f7bcf4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 14:26:23.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UiOCA6se+fiA1HE2/9n+9jQLa3eFH2B6er0CcM67L6D7qBzZoeNeznGYsE42AiBUJ9J9r+sAJo16O8GL9OF//w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8410
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/23 16:13, Sean Christopherson wrote:
> On Thu, Sep 14, 2023, Tom Lendacky wrote:
>> On 9/14/23 15:28, Sean Christopherson wrote:
>>> On Thu, Sep 14, 2023, Tom Lendacky wrote:
>>>> The checks for virtualizing TSC_AUX occur during the vCPU reset processing
>>>> path. However, at the time of initial vCPU reset processing, when the vCPU
>>>> is first created, not all of the guest CPUID information has been set. In
>>>> this case the RDTSCP and RDPID feature support for the guest is not in
>>>> place and so TSC_AUX virtualization is not established.
>>>>
>>>> This continues for each vCPU created for the guest. On the first boot of
>>>> an AP, vCPU reset processing is executed as a result of an APIC INIT
>>>> event, this time with all of the guest CPUID information set, resulting
>>>> in TSC_AUX virtualization being enabled, but only for the APs. The BSP
>>>> always sees a TSC_AUX value of 0 which probably went unnoticed because,
>>>> at least for Linux, the BSP TSC_AUX value is 0.
>>>>
>>>> Move the TSC_AUX virtualization enablement into the vcpu_after_set_cpuid()
>>>> path to allow for proper initialization of the support after the guest
>>>> CPUID information has been set.
>>>>
>>>> Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>> ---
>>>>    arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++--------
>>>>    arch/x86/kvm/svm/svm.c |  3 +++
>>>>    arch/x86/kvm/svm/svm.h |  1 +
>>>>    3 files changed, 23 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index b9a0a939d59f..565c9de87c6d 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -2962,6 +2962,25 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>>>>    				    count, in);
>>>>    }
>>>> +static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
>>>
>>> I would rather name this sev_es_after_set_cpuid() and call it directly from
>>> svm_vcpu_after_set_cpuid().  Or I suppose bounce through sev_after_set_cpuid(),
>>> but that seems gratuitous.
>>
>> There is a sev_guest() check in svm_vcpu_after_set_cpuid(), so I can move
>> that into sev_vcpu_after_set_cpuid() and keep the separate
>> sev_es_vcpu_after_set_cpuid().
> 
> Works for me.
> 
>> And it looks like you would prefer to not have "vcpu" in the function name?
>> Might be better search-wise if vcpu remains part of the name?
> 
> Oh, that was just a typo/oversight, not intentional.
> 
>>> AFAICT, there's no point in calling this from init_vmcb(); guest_cpuid_has() is
>>> guaranteed to be false when called during vCPU creation and so the intercept
>>> behavior will be correct, and even if SEV-ES called init_vmcb() from
>>> shutdown_interception(), which it doesn't, guest_cpuid_has() wouldn't change,
>>> i.e. the intercepts wouldn't need to be changed.
>>
>> Ok, I thought that's how it worked, but wasn't 100% sure. I'll move it out
>> of the init_vmcb() path.
>>
>>>
>>> init_vmcb_after_set_cpuid() is a special snowflake because it handles both SVM's
>>> true defaults *and* guest CPUID updates.
>>>
>>>> +{
>>>> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>>>> +
>>>> +	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
>>>> +	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
>>>> +	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
>>>> +		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
>>>
>>> This needs to toggled interception back on if RDTSCP and RDPID are hidden from
>>> the guest.  KVM's wonderful ABI doesn't disallow multiple calls to KVM_SET_CPUID2
>>> before KVM_RUN.
>>
>> Do you want that as a separate patch with the first patch purely addressing
>> the current issue? Or combine them?
> 
> Hmm, now that you mention it, probably a seperate patch on top.

This toggling possibility raises a question related to the second patch in 
this series that eliminates the use of the user return MSR for TSC_AUX. 
Depending on when the interfaces are called (set CPUID, host-initiated 
WRMSR of TSC_AUX, set CPUID again), I think we could end up in a state 
where the host TSC_AUX may not get restored properly, not 100% sure at the 
moment, though.

Let me drop that patch from the series for now and just send the fix(es). 
I'll work through the other scenarios and code paths and send the user 
return MSR optimization as a separate series later.

Thanks,
Tom
