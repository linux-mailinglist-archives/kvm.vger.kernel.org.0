Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FB574237B
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 11:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjF2JtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 05:49:11 -0400
Received: from mail-ve1eur01on2059.outbound.protection.outlook.com ([40.107.14.59]:49473
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232006AbjF2JtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 05:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHFzUwBTIfb3K0g8S80Er5PmdH9hTYAws7dawkcgaMtdi8aMscEJYCeaJ6f2TESdT2U5vBOtMFNzXSZMAWQ5HeE5LMdt7c5GhBLtZKyLmc+5hF77bqlq1fQRzJlSGlECcBuzfmvbyrmD2OmLBXu55amTJtGc7DDTz10gzOUgJhgIWk62ER7vSXZBZD01vSe3Rg5/MTR2QP9qUklHLfQpMSJpjTYME6K7UiuMUeeh05il6UW/LQSG1F1aWEVeb3XQlx1qIVALICj5/HmWwOfdGLJTBYfC7H1s/02khxXFqN0Joop8mKTdH/18vM3gWnvj0DoSL2u31yJn+jF8bAjndQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yHWWQbgQgWcPzlLDdB7EqYG+akvH3bsfEQj0TwtkF0=;
 b=W7hI6bcJnowUO10hQDRapNhUlSUFG3xowqceK+2up8C82ZiLUHhkBSX9IKLQ2ruaYLJ74JoendoY8y0nYLJtN6jlOfSexKhCSxMcgAnPnpRL9ogSfdl7tELrYYdos1NbAwGHgUaoChUR5rzAzPFukEgWSuQZlswvA/O4zRsWcwhKHzLU3GbEULJr6T3xfYEXvo6SRFIuxrQSZBSkyEQlENBA7zt3PDklND9O7yr18Tehgz90Pug5/Ao5DzEdKCTdmzH4MKsaUQ5RnSHZsuLq0yNq6XCL07bVjb5wXTzj9zs49mgRinLqbGq+VRBsSrCL8OdAadvdkQCFJGbdVP8vmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yHWWQbgQgWcPzlLDdB7EqYG+akvH3bsfEQj0TwtkF0=;
 b=b1k9xTm+g9Uv5R4YaOFKGVeP6vIO4u41kUcZG0dQcLzuMvekum4NMb6zP5Bq5cqT390tLHHllxgcmYbPedrq+GCgauXzTkBQzh/c/OZeeHvjWvRN3brbaaE5RL0oriJZ/htOCa6SEdlmHofebN2eAv93KCNRMslA8s6xto09cUBvY4GOxxEOrKfuIWmGZgf+s986olVghZD7MnCVQdwf8aF/tfsIF2UriwA0zWXMcoSQOHbYFdUhTCEIBbGzsUuMPC5Y8TQLdly2YyoDfG6vTO9uLAs7s0zRHXlrQDJDs51dkWG8KT11maT0+bV52/hz4h47WL0RwdRvG4e/EzzWRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM8PR04MB7282.eurprd04.prod.outlook.com (2603:10a6:20b:1d9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Thu, 29 Jun
 2023 09:49:03 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 09:49:03 +0000
Message-ID: <655a533d-a3c0-c3b8-0e3b-a0bb1bfa3242@suse.com>
Date:   Thu, 29 Jun 2023 12:48:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Huang, Ying" <ying.huang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1687784645.git.kai.huang@intel.com>
 <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
 <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
 <8a1d39c7641b0ba2be3191599a114bebfa3ffca5.camel@intel.com>
 <3afbb049ba3a848bb0befd7056ced519c7aa8991.camel@intel.com>
 <e093e75f09e738c3b6e28c0f6cec991ecff15243.camel@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <e093e75f09e738c3b6e28c0f6cec991ecff15243.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P195CA0039.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::28) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM8PR04MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: b1e62426-8df6-4066-f3da-08db78861227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uR5NfL3JXl958Zq/oJcFAT4yAioAe0voQ99per97g6BjbKeazp+xDtYZjI14LwbPf8b1bY0osj2EycDcq+UqRlFVrUMr8L/NUFCWHCJm2u2h6AnWurZvTpoCmgK96mHiAowm0qhukSuURKgPmodkDQcvaceiXlNdWauGc5IhKhkCvoI/0r9PCtdoC4/nj91Er1xdmtudwx9aNa61PP+oHDsr7mD77HZuzQnOA379iQYc5cyj4YgOfwikHU153erhlvqW/vhYucLptdFVW/eKXTpjHx7oeABobUYegns0aY13w+2M4qweoKFNq+jKSbCYAn74F8OjCEKeuGj+aT0vx/KWbf5+74Tz58/bQ48XVaoaq2wjtLF8kKHXx2KrvGyhzEoLopNW6r0wYZlMa1qrh+q997eJwNPrKXpSsOEJnJ+0vJSrTFA3umb9vqjD3qoqLqsFmS5OLuEkx68rSI6Sp8tK404Es48dd4lRBiMaMgMOK0+RTi33Zwcu+ri19vO7obqoMOpICfXyOZ1Tq0P3lQBJ8G0YzE6M4ghg0u07uftKh6KCP6aD/QvOP5r2Qt9DH2oWgfMU+xujSA6pmXjq2K9KUxuHtVQbPFIVkS+eX/Q30OfMs0LBlkHS6/x4+c+6PDP7pM9PeaxncJi0CT5mUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199021)(316002)(6512007)(41300700001)(83380400001)(86362001)(186003)(6506007)(7416002)(2616005)(31696002)(2906002)(38100700002)(5660300002)(8676002)(8936002)(36756003)(54906003)(110136005)(6666004)(31686004)(4326008)(6486002)(478600001)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WENlSlREYnd4ZHgzN3Fmc1RlODMxMk5jQlJhYlQxU2xYbDlFMDFyaWV5Q0ow?=
 =?utf-8?B?ZDJ2MGE3SFRBZDVYbVViQ0pFU25HY1RidFQxUTgwRjM5ekNJNkRxOC9Banp3?=
 =?utf-8?B?QVJsbllxUEsrWENhT3FSQUs4VXkwSkpPR21vd21raXRQRlo1eDJMUGNyc28y?=
 =?utf-8?B?TEhpUktPQ1VlVGRLMDZIYjc1UTdjbDlTSXZsYjNzbGhVbExCMWVuWExHejdG?=
 =?utf-8?B?WUZLcythaGtxT1pPOFdIL3pqUlZiUGsxTWJ3MXQ1WTBKRVRSRDBsWC9kT1lk?=
 =?utf-8?B?cU5OZ3VFL3ROOHdqUW1uN0dxemNuS0p0SlNhU0dGRTJrU1VKWDNuc1dyTnpQ?=
 =?utf-8?B?REo2VVNUd1JGM3FPdkdyOXlUZjhXL0FkWExLUTdzcmNjRm9HOU8vYWpaNmV2?=
 =?utf-8?B?WTQxM09VOFN3ZWZja3BQc255SnJta2E4c2xPN0dnVmNvc2c0c1RVeTI5N0gv?=
 =?utf-8?B?NGlDRFRNWWErdjNVUERNWWgxYnp6MzZQRmREQ25LdXE0ZEhvQ0pNZVRUUGM2?=
 =?utf-8?B?UjNJM29XNURBeG5Dbm9rSlNGd25yYU9NTzc5SksvUVpaeDlBV2ZMa256S21y?=
 =?utf-8?B?dHNRYThid2YxejZFdkxMaURsd3BLY1V3VjJSaENOTXV3cTU3L1MxQTI2Smwy?=
 =?utf-8?B?R21sWXVKeDJKU2Rnalg2d3RmOHdBM1hwNjVDbUwvSTByblVyMlJsU1FVN2ht?=
 =?utf-8?B?NlBrcU9IK3J0R2NGMkJMQXZ3blRIV2lna3pCRUdEeFZYMlMxQlBGT3BvMzhC?=
 =?utf-8?B?YjZBaFd6Q3dVeEhGL1BxaWxwSU1lSDZQSXJFNDJrY2FBTUJoR2VDSmJPVEMw?=
 =?utf-8?B?KzBFZGx4MXRmWG1MK0Z4cUJTdmplVU5oRUtMSXB6NWRiNkMyZVJXK1VlSmtV?=
 =?utf-8?B?dmQxdW95a3ErZmgyMmtIMHkwUW5kWFljVmxyOUJaWVQ3ek9pZFFjdUprTFFr?=
 =?utf-8?B?ejdIOUhRUnN0UW9aOWF0WEFzKzNLK0ErQTVyU0lWL0ZkMExDekNyblc1d21o?=
 =?utf-8?B?L1lWeDVUdDJoQjBRTUQwbm11ekltQ1pqSW9FWWphUmxWUzE1dTZPL1R6S1hP?=
 =?utf-8?B?b2UxNzhka3N6Zm1UNXVCQzdyVzE1enhrcEpOVko2R29xK0dTSC9nMFk5eFJV?=
 =?utf-8?B?eWRBMlBYOVEvRlM0bUxlVmtGejNkeEtkTS9NMW1xSEFiTmlFMzFnVW8rMSsz?=
 =?utf-8?B?QXlKZmtlNGo4eWh6VWNCRmp5SHcyaWhTMVFvYmpSQ2RCbzJ2U3RCWm9Fbk5K?=
 =?utf-8?B?OVNTa2dYTnR0dG4yUDN4UDNHZUhSaGIyTDBPUnNIRTVObWhIWEgwTVR2bTZY?=
 =?utf-8?B?bjJiRHRGeFZRUEdUWUJpaGNaYlRWTHNNcFR3SmgrbHlsSlRIRDBUTkdDK1ly?=
 =?utf-8?B?WTJoUWxVK2F4YStqcy9hMjVZSTljcHB4V0pLZE5pQk9VVE4xOVBsWUJwUVV3?=
 =?utf-8?B?cnRITkRieU5uQjN4anpuOUlHaHczY3RjWGlreFlzL0dKUFFwMDhzY2p2MkZp?=
 =?utf-8?B?b2pJei9sNDFyRTFVS3c1SjVTTzdsL3dWemNnTTg3cXh6OXQydnExeFJqVjlh?=
 =?utf-8?B?dHUyNktpOXlpbU5obmVDaGFxdWtGWnl5bmFBbVpDeG5CbnROODNNNVkvSmVW?=
 =?utf-8?B?UUVkOXYwRU91Ujd4VmdWNlhjVkZyaHpZcFdhU0dHM2w4enNxQW01VmwvUXdz?=
 =?utf-8?B?V2V0MDdPZnpDeSs4WldMSGJEYkpwdHhwZFJkMEswb0JXOXp4dGk3OU1odUdo?=
 =?utf-8?B?anNqbVl5SGRVNTFnTlExVndCVkdnUVY3OGUyZ3FxaVJpbE1rYTE0R2kzeGJy?=
 =?utf-8?B?Rjl0NTdMZWxNZi9HWkF6YXNtMHNROVhCMFNJVTYzTW8wTWxQMWllam56KzNW?=
 =?utf-8?B?c0ltazhaWm1uNWQxemdSbURNYk5XamFmQXhNc3Buc3FlUUN2N1BuOVVGTGpI?=
 =?utf-8?B?U1FnNzB4Z1ZZN25aNGJoS0h5Z0xsL24wRWdVYndpQWNSbUNEY2VmQU1DS3h6?=
 =?utf-8?B?REVZeTJGL1F2UGdSVnNDOG5hL0tPSTNOOThxWjFzNmlxZDM5Qkd6VmZ0cjl5?=
 =?utf-8?B?S0h6REU2cFRHdmtsYnBvcU43QXdjV3ZldG5FblVudERhSFdqQVNnSCtZSHl5?=
 =?utf-8?B?TWk4eCtlTUhGZlBFQlY4dnlsMk5aRk5iTlZic1I1bkM3MWZwci80V0ZERTll?=
 =?utf-8?Q?+VvLuZU/ACrAMrF4G1Q0qSTImEh+PV0XIRUvXLS8mSOq?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e62426-8df6-4066-f3da-08db78861227
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 09:49:02.9843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bzIMUhVDdpXORungdbtLFm1kYQVlFwuY4kGlZfxDJlAiIJqjdum1G6lj5zKV/uRvaFYXpUT7tMOqj+eKwTgEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7282
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29.06.23 г. 12:45 ч., Huang, Kai wrote:
> On Thu, 2023-06-29 at 05:38 +0000, Huang, Kai wrote:
>> On Thu, 2023-06-29 at 03:19 +0000, Huang, Kai wrote:
>>> On Wed, 2023-06-28 at 12:20 +0300, Nikolay Borisov wrote:
>>>>> +	atomic_inc_return(&tdx_may_has_private_mem);
>>>>> +
>>>>>     	/* Config the key of global KeyID on all packages */
>>>>>     	ret = config_global_keyid();
>>>>>     	if (ret)
>>>>> @@ -1154,6 +1167,15 @@ static int init_tdx_module(void)
>>>>>     	 * as suggested by the TDX spec.
>>>>>     	 */
>>>>>     	tdmrs_reset_pamt_all(&tdx_tdmr_list);
>>>>> +	/*
>>>>> +	 * No more TDX private pages now, and PAMTs/TDMRs are
>>>>> +	 * going to be freed.  Make this globally visible so
>>>>> +	 * tdx_reset_memory() can read stable TDMRs/PAMTs.
>>>>> +	 *
>>>>> +	 * Note atomic_dec_return(), which is an atomic RMW with
>>>>> +	 * return value, always enforces the memory barrier.
>>>>> +	 */
>>>>> +	atomic_dec_return(&tdx_may_has_private_mem);
>>>>
>>>> Make a comment here which either refers to the comment at the increment
>>>> site.
>>>
>>> I guess I got your point.  Will try to make better comments.
>>>
>>>>
>>>>>     out_free_pamts:
>>>>>     	tdmrs_free_pamt_all(&tdx_tdmr_list);
>>>>>     out_free_tdmrs:
>>>>> @@ -1229,6 +1251,63 @@ int tdx_enable(void)
>>>>>     }
>>>>>     EXPORT_SYMBOL_GPL(tdx_enable);
>>>>>     
>>>>> +/*
>>>>> + * Convert TDX private pages back to normal on platforms with
>>>>> + * "partial write machine check" erratum.
>>>>> + *
>>>>> + * Called from machine_kexec() before booting to the new kernel.
>>>>> + */
>>>>> +void tdx_reset_memory(void)
>>>>> +{
>>>>> +	if (!platform_tdx_enabled())
>>>>> +		return;
>>>>> +
>>>>> +	/*
>>>>> +	 * Kernel read/write to TDX private memory doesn't
>>>>> +	 * cause machine check on hardware w/o this erratum.
>>>>> +	 */
>>>>> +	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
>>>>> +		return;
>>>>> +
>>>>> +	/* Called from kexec() when only rebooting cpu is alive */
>>>>> +	WARN_ON_ONCE(num_online_cpus() != 1);
>>>>> +
>>>>> +	if (!atomic_read(&tdx_may_has_private_mem))
>>>>> +		return;
>>>>
>>>> I think a comment is warranted here explicitly calling our the ordering
>>>> requirement/guarantees. Actually this is a non-rmw operation so it
>>>> doesn't have any bearing on the ordering/implicit mb's achieved at the
>>>> "increment" site.
>>>
>>> We don't need explicit ordering/barrier here, if I am not missing something.
>>> The atomic_{inc/dec}_return() already made sure the memory ordering -- which
>>> guarantees when @tdx_may_has_private_mem reads true _here_, the TDMRs/PAMTs must
>>> be stable.
>>>
>>> Quoted from Documentation/atomic_t.txt:
>>>
>>> "
>>>   - RMW operations that have a return value are fully ordered;
>>>
>>>   ...
>>>
>>> Fully ordered primitives are ordered against everything prior and everything
>>> subsequent. Therefore a fully ordered primitive is like having an smp_mb()
>>> before and an smp_mb() after the primitive.
>>> "
>>>
>>>
>>> Am I missing anything?
>>
>> OK I guess I figured out by myself after more thinking.  Although the
>> atomic_{inc|dec}_return() code path has guaranteed when @tdx_may_has_private_mem
>> is true, TDMRs/PAMTs are stable, but here in the reading path, the code below
>>
>> 	tdmrs_reset_pamt_all(&tdx_tdmr_list);
>>
>> may still be executed speculatively before the if () statement completes
>>
>> 	if (!atomic_read(&tdx_may_has_private_mem))
>> 		return;
>>
>> So we need CPU memory barrier instead of compiler barrier.
>>
> 
> (Sorry for multiple replies)
> 
> Hmm.. reading the SDM more carefully, the speculative execution shouldn't
> matter.  It may cause instruction/data being fetched to the cache, etc, but the
> instruction shouldn't take effort unless the above branch predication truly
> turns out to be the right result.
> 
> What matters is memory reads/writes order.  On x86, per SDM on single processor
> (which is the case here) basically reads/writes are not reordered:
> 
> "
> In a single-processor system for memory regions defined as write-back cacheable,
> the memory-ordering model respects the following principles ...:
> • Reads are not reordered with other reads.
> • Writes are not reordered with older reads.
> • Writes to memory are not reordered with other writes, with the following
>    exceptions:
>    (string operations/non-temporal moves)
> ...
> "
> 
> So in practice there should be no problem.  But I will just use the correct
> atomic_t operations to force a memory barrier here.


as-per memory-barriers.txt there needs to be proper comment explaining a 
particular ordering scenario. Let's not forget that this code will have 
to be maintained for years to come not necessarily by you and the poor 
sod that comes after you should be provided all the help in terms of 
context to understand the code :)
