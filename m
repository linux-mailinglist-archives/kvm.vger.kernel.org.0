Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7596C47B342
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 19:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240601AbhLTSyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 13:54:20 -0500
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:16225
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240001AbhLTSyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 13:54:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IafgjFcMPQKMnAtGgHTA0ldtdw6tjg7n1HY87M9B9hiEXX1L461IFx5JjQzOVJO1aowwDVKSbVj/K5YzXxPAWvQfz1/p/HQhqi8GdiVpKTBgxhQ+zEXPRK+/SmjfmmsRj3pKkY387TMYOeOUux+z/BESEfcgk7bZxjRQfYm0yVZimFRouiaTe8UfD5bqr6vEl251EANUu6DKngqHJAIodnCfgibR80ktpa8yGN9/uAkKQiWaB31wHawVFiYMzzXHmxxELKro6bY3YTPdlg4ltz5FkNnQtKwtrBYyUCUHZhRg9fEL4hE/L9yfYENP+bMYJGWWp6yotBfta2MDuIbNpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZKztYSy6whYimuSblE7amRhV99EjWbZm3x3QHu86q4=;
 b=oePbvlaqNzvt/Ro9JSwc3wS4nglEOTg5ZazGVFmPAT4EUeHLg/fkCqXTR/X8KXkhRPdSg1AbAmnCfnF3zvSTS7DTbPP4AjKeLmXiPiHFMkx6ZjX+JQV8YQXWmqFoTJMdJ81ljAdeZAKNZ7bZsKBukGCvDtmFokGgSkSvZU96pg6Rj+eD9vAz83++g21PgxjJMZ51hSEA+kbwu8aijxjrEwvFAEnElklk32YbQVDTfa2qB5+eqpFuWYA8l53Ko9Vi189t8cPQXePwA2H234p5muU4r9AzSTqJWs0/mVnTm5YBoDJLynYbWM2eFc69VpIPk50FDJYaTj7WR68KEQa0gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZKztYSy6whYimuSblE7amRhV99EjWbZm3x3QHu86q4=;
 b=UUHFBGfTCKVGwZWqXCwfbhRgwvsV6EAbKfiZlVVG4XzZkmoJ0GRVslLFsg3jFe5PHt7j5ve+JDtK77dLm5lx3mZbC0sQ+HIgFmbmQXapZ5fJeMqOGsIpTgqnHP8Cvq/jN54PsMivAXfk3/yD8Wjib7CNBUJkrt1XavNmWD72xmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Mon, 20 Dec
 2021 18:54:15 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5%5]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 18:54:15 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
 <20211217110906.5c38fe7b@redhat.com>
 <d4cde50b4aab24612823714dfcbe69bc4bb63b60.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <36cc857b-7331-8305-ee25-55f6ba733ca6@amd.com>
Date:   Mon, 20 Dec 2021 12:54:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <d4cde50b4aab24612823714dfcbe69bc4bb63b60.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a06be61-d729-4c62-4b59-08d9c3ea1e98
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55492D4A2F752D33842585ABEC7B9@DM6PR12MB5549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRgtXWJCOwvPtn54RsQ+zuq1xCvtcq+/1AQu8+n3ZbsNMPvZ06A2we61OQvP0lP9kn+nedfI+FlkirlKdZLznUlG8MOc6pyA03IwuhtNuxtGYVmlTlhwGfnvlVyf3Ccrq6pv1tDjGE60ZNf7K4N14KcqOLu9jQaRnoUlfACk/9uag56NdyqQEyqUxqCUfqKsiB2vqECQVQBX4tDzUe64Qc/jf8z/X5xFnfHcSbhcdFjYKOIrd1RYx25icICh6gTItap28DZWHcLH2gR+XLe5m+CAybB+2GWD7uJtRPVl0Hi0dlEbk2kQ3iUedhQxeNEI0HXtEXDQqhEpTsQnoExYSGLM+pfRJN4Qg35D1+hrWRyXScAHK5pFWVPZ6DoT34bdt2whqE2mh9cvLOyMVTWcm3ySC38QN/8zeqf0+Vd+L3jkRHBGO4L1QPl3w6GxMUEheDSQeny19m7yxbFAnDxwe+B8AJQ88NDYfbnaqnYqS9wT90bBA+9BLrvj2IBlJrmqK/YOn9fDQvul3o4A/7VhLaXv+Z4b4LL8SVa7qo7Hnb0uoEXWmP1FimHQoU1VVd3Se7qJj5uQgYaToLzjbn1mfU1BcgSK3TpGs30qZpIovjYfkhW8vZCgAmEEj6FJ9RMTpFhOQMThAU0NWAx7R5CJjKWRfTjUuG9zb2u4KODjQAg6Qx3jjego5rnaxZFskjDUAxqJWv0KoDhZBRXPt998hnRH2WFMVW3VekMzDjNj1z81aqdpmG7uRvMIxkqJn5TJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(31696002)(186003)(6486002)(83380400001)(5660300002)(54906003)(110136005)(316002)(26005)(2906002)(53546011)(8676002)(6512007)(8936002)(4326008)(38100700002)(6506007)(66556008)(66476007)(66946007)(31686004)(36756003)(7416002)(6666004)(2616005)(4001150100001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzVaeitEc1lxQmk3bk1rYzlIeFRrbFFoNWsyMEh5cW51MjkrMzhLNkFwVTlJ?=
 =?utf-8?B?dExzNFRIM2wxeGdicHF2d3Fodnd6d0JudnRwK1RneFhidjZZOG93RGJ3ZG8z?=
 =?utf-8?B?VUlxeHZnMTlEODV4SzBxWXVRNnlYK3dtWGJSVG0ydFlscTdnZWp3MkNYMlB1?=
 =?utf-8?B?bjBjZHBrQXBUTEE2MmtNNGx5bnBHdExlc29CUm1FVjlEam0ybnROZDNpcnZ3?=
 =?utf-8?B?UWkreU04SkFoK1poYkMyY1JDRzJsc2VoVlRiSUQyZWdWUUxoWlZlb0Z4UGxP?=
 =?utf-8?B?NnNUV0R5eUtHTzhqNUhQSnM5YWJJNXpBald4ZUk5LzFnRHpScUVtR1QxUVlI?=
 =?utf-8?B?OXYwc2xJNnI5dXhINEFnSlppb2x4ZW5RdC8va3Y5aWJ0YXZQS041eDVyZXBp?=
 =?utf-8?B?R3AxSVVQQ2dobnVXWC95N3RuaCtRSUhDUDZOa2hSbUE0QmJlSTdGSExLSTFO?=
 =?utf-8?B?cmliK1NZQVlCdm9TT3lvaEE1dUNqZklnQkVta21mWlZkSGl5YitpakZaRy9x?=
 =?utf-8?B?eUFEellOc25DVCtSbkI5T21RTEVDTE0vQ1FoZEIzYUJ1R3VObWgycFhocTMv?=
 =?utf-8?B?MkRGeWk1bW5Xb2hLbHJnRXBUcG5VWk9nT2Q4ZkxGcFBXMlV4M21yWC9XaUhX?=
 =?utf-8?B?VXBzSks4c3BjdmdBYlFhQmU1OHhkMEdGRzF3MU55ZmVFZEJMWlQvL0FDS2Zu?=
 =?utf-8?B?RWVQaDE0WXQzL1NHMStuc1poNHEyTUZENU5pU1NJL2ZoeG1ZMUovbDg4dllH?=
 =?utf-8?B?NVQ2YUs5dmF1V2Y0QkxMNXFrYlpZQU5HeVRzRW5hNjNkaWJVYWtqZ3d4OHRl?=
 =?utf-8?B?NFZxSjZsYkd6RFZhZXFYbzM0V0V2a1VLWW1WMDlCeVNEYS9qZ21OVWd3bUV3?=
 =?utf-8?B?TVFWbmZKUkYwemtmQmpFM0JzR1VCclV5bzVqOXZjdEZmT0NaeU1sS2xFaThL?=
 =?utf-8?B?WkxlekhNanV2SGtzT3IwVkZmVmpkbHVCUzI0WTkwUzNCdWt6VlRoVnNnelNh?=
 =?utf-8?B?WHBBZlpPbllVNkpZeS85NVRoNFBDeVdYbkJWNUJHU2tKWU1OOTJEQU9IT1VV?=
 =?utf-8?B?ZkJlamJwRWNMRmVreGJhclNpS1ZYTXFTbHpYTm1QL1VMSG9rQ05qdUk5VHZi?=
 =?utf-8?B?dGpwQlg0Yk9wR3BINDZJa3VIL1pjM2tQMGdUY0dMQzM5N2NIdFpxanJSc1R6?=
 =?utf-8?B?Yk0yc2tvTjNjaXZ4N1pMWjBidEd3NkVGQXY5UG5Jd0I3YmY2UjRoeEEwYmQw?=
 =?utf-8?B?bHA3a3dnYWVMWnEzbFpIOUJZZExUREtvblhIaXk5ZHlkNHllaDVxSFgyUXQ4?=
 =?utf-8?B?OWJrUG85T0pTZ29kYS9VTzk1aEhPQzluYW5pTk9WYTk2cURHUVM5aE9FK3RS?=
 =?utf-8?B?dkRscitqd05jamdCdDZDRFFkNzlsWkp1dEN3ZmxXVHR2WTNNNUh1OEVQRmhX?=
 =?utf-8?B?b1cvOE85M1Z6OCt5T2hlSDlHMkNHTm5GZG5nTFUvcEpQZ2hER0NldXVwcVNm?=
 =?utf-8?B?UndwZnliZzA4dDBEMXh2bDRsYStFRmpLV1dCVTl4L0RKSVhKQzJIY0tMWFJ6?=
 =?utf-8?B?allKWEV6Yjl5ckg3TlhkREF1YkFEZzlqWEZvUkJEK2Z3aFI1WXN0ZW5rUWx3?=
 =?utf-8?B?c3hpVzlxWmpMOE1DM2FqMkJYVE5TWHBrNUw2ektxeXRTclRPZXhQV25NZFhz?=
 =?utf-8?B?QStOUk56NjNLRXI3Q3JjVTY1UHk4eXkvSlNZRUY0dHlKRzNENXBGaCsvREUr?=
 =?utf-8?B?eGUvcGFFWHZTa043ZlpvbitPanBUMDIzenRkYVZldjcvV0doS0hhZWpsbjQ3?=
 =?utf-8?B?ZlcvMGJZbUJnSVBIcC9PSXBzaS9DNW5CdFJSWU0vNi93ODBkR212L3FMMGdD?=
 =?utf-8?B?aDJvNU5QMTQxU1hwT0N1dVkzczJ0dWswOFJnVU1uOC9MK1NYcDBGbFNCRnlQ?=
 =?utf-8?B?a1JGTXdzSVlNZk1HUTE0SjNwRlhNQWVMdlk0TkNYRS9kL2NtMmFDSWdSNjEv?=
 =?utf-8?B?emdmN0JzRkV1UXBVN3o4UXJUWGdqNFNFUHEycVE2QVRhRkRPOVpxZDA4R2Va?=
 =?utf-8?B?N0ZaZE52MTVXc3ZKMFlSU1BNVHN3TDlxVWFhM0RheU94SEhzZlFrRGpqNEd3?=
 =?utf-8?B?bDdRMU16MUMvWDMxTTNwRUc3clU0QnJIcFoyQW1hdXdvUDdiaTlrZ28xSUVX?=
 =?utf-8?Q?+KwQmdVkv/7xY+TcM+1gs9E=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a06be61-d729-4c62-4b59-08d9c3ea1e98
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:54:15.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m68zIk3lnLdvsDWEJIQF3g4jORCpHbFHzhEO/r8wRHcfeAT+0JhiRJ/j++M1z3j0fF+V6PDsgbHLdf66B26AKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5549
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 11:10 AM, David Woodhouse wrote:
> On Fri, 2021-12-17 at 11:09 +0100, Igor Mammedov wrote:
>> On Fri, 17 Dec 2021 00:13:16 +0000
>> David Woodhouse <dwmw2@infradead.org> wrote:
>>
>>> On Thu, 2021-12-16 at 16:52 -0600, Tom Lendacky wrote:
>>>> On baremetal, I haven't seen an issue. This only seems to have a problem
>>>> with Qemu/KVM.
>>>>
>>>> With 191f08997577 I could boot without issues with and without the
>>>> no_parallel_bringup. Only after I applied e78fa57dd642 did the failure happen.
>>>>
>>>> With e78fa57dd642 I could boot 64 vCPUs pretty consistently, but when I
>>>> jumped to 128 vCPUs it failed again. When I moved the series to
>>>> df9726cb7178, then 64 vCPUs also failed pretty consistently.
>>>>
>>>> Strange thing is it is random. Sometimes (rarely) it works on the first
>>>> boot and then sometimes it doesn't, at which point it will reset and
>>>> reboot 3 or 4 times and then make it past the failure and fully boot.
>>>
>>> Hm, some of that is just artifacts of timing, I'm sure. But now I'm
>>
>> that's most likely the case (there is a race somewhere left).
>> To trigger CPU bringup (hotplug) races, I used to run QEMU guest with
>> heavy vCPU overcommit. It helps to induce unexpected delays at CPU bringup
>> time.
> 
> That last commit which actually enables parallel bringup does *two*
> things. It makes the generic cpuhp code bring all the CPUs through all
> the CPUHP_*_PREPARE stages and then actually brings them up. With that
> test patch I sent, the bringup basically *wasn't* parallel any more;
> they were using the trampoline lock all the way to the point where they
> start waiting on cpu_callin_mask.
> 
> So maybe it's the 'prepare' ordering, like the x2apic one I already
> fixed... but some weirdness that only triggers on some CPUs. Can we
> back out the actual pseudo-parallel bringup and do *only* the prepare
> part, by doing something like this on top...
> 
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1337,7 +1337,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
>          int ret;
>   
>          /* If parallel AP bringup isn't enabled, perform the first steps now. */
> -       if (!do_parallel_bringup) {
> +       if (1 || !do_parallel_bringup) {
>                  ret = do_cpu_up(cpu, tidle);
>                  if (ret)
>                          return ret;
> @@ -1366,7 +1366,8 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
>   /* Bringup step one: Send INIT/SIPI to the target AP */
>   static int native_cpu_kick(unsigned int cpu)
>   {
> -       return do_cpu_up(cpu, idle_thread_get(cpu));
> +       return 0;
> +       //      return do_cpu_up(cpu, idle_thread_get(cpu));
>   }

Took the tree back to commit df9726cb7178 and then applied this change. 
I'm unable to trigger any kind of failure with this change.

Thanks,
Tom

>   
>   /**
> 
> 
