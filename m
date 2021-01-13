Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DC82F436B
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 05:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbhAME4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 23:56:33 -0500
Received: from mail-eopbgr690042.outbound.protection.outlook.com ([40.107.69.42]:12578
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbhAME4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 23:56:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyeAbEO+UsoNaWnE2xHCEV4pDzwkcGTiudKDKlQ52QeF6bTPadTzf7DgiWUdnWMNOW0UhJBsy0CJZsu0cMk6qQOx2EOX8lwZajU3u7wwXQsA9OlJ+GoOT4yod1zeSCHhArf4uHana/99Qom1T+voKrz4QNMOVlTeh8SNKmJ+PRwDxxFTMNc1GJ0Dq6COe37x1YS0jjrAAavWM6ldagET9avOh3fFOqOKl+B7b/7yC8WU0biU0njDM4j4LmvD+GRr16xJ6HHLXhMig1zJlkRvhJIdTXeAGR4XInmnvEPmWNQZ18DbAZfqp3QoBdv3dXOvx/orGyp3tqkqs89Gf4EDHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=El8SAMhbM+uzfbmXAc6qrXp3sVP5MSyxglbXJnm1UCE=;
 b=Phme0EgXGRY6JctSYyvqBX4yzTjMm6vsSnJ0Y6N/tv3f5rlzUlvAD/nlih9q6aZFA/IcQdFCjYBvnZYysOMe2v8JSna2wbNipjJ4a19hndDveVGGgclBxiI9BmI6Bsn9S7qVH2Q6kvNYm/HNE5HtYCJS5hJImD0NDcK8lNT/gQbFoGXHvLi/Oj1mPosvydzKJQYvADKM2F01y+IujhbrxA+/5eulo6ydUyZDESLMdJBZRXUubIY7IkI7LGO+6enVsJO3rkLcFdALWy+PTaNSgw/V+PTm/xINAlQ6WgtgbymXrY3zDLwfqkRa6RU1gkvQAIUUmXpvg5grb31BBuwmlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=El8SAMhbM+uzfbmXAc6qrXp3sVP5MSyxglbXJnm1UCE=;
 b=UHv2mIa1jSY/ACzAXILiotEUNJX42aFU/fA6pEfQg58tEoxhxPNVso8Qz/KzmSPQR4m5xI+CFvln1+ImXueMe3Os7cGGV0t4S+1hsVGJ2G8VpgDZEjz0SG1X9oBc2J4hrWy2PZVH4PWg6/NiPqOlXVFQUwmIpvg9ylp2XUBS0j8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB2487.namprd12.prod.outlook.com (2603:10b6:903:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Wed, 13 Jan
 2021 04:55:43 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 04:55:42 +0000
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
To:     Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Bandan Das <bsd@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, dgilbert@redhat.com
References: <jpgturmgnu6.fsf@linux.bootlegged.copy>
 <8FAC639B-5EC6-42EE-B886-33AEF3CD5E26@amacapital.net>
 <X/3i5Pjg1gEwupJD@google.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <551670d3-3a0b-1a70-c586-6ab41b83094f@amd.com>
Date:   Tue, 12 Jan 2021 22:55:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <X/3i5Pjg1gEwupJD@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SN6PR2101CA0027.namprd21.prod.outlook.com
 (2603:10b6:805:106::37) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.38] (70.113.46.183) by SN6PR2101CA0027.namprd21.prod.outlook.com (2603:10b6:805:106::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.0 via Frontend Transport; Wed, 13 Jan 2021 04:55:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e04b7f8-55c0-4a60-555e-08d8b77f7b45
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2487:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB248770B699DC88E6A20B5426CFA90@CY4PR1201MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMpO3gGB1uXDttcWOZYx2Rc/bZvyDVVSba9k54c5+dmeJziQUTwXnPCRrfzev1P1puff5BaRy6QvP5tcNNpQSLFd2YNFKC+lUyQG+N6xaBGBd5gPa4Fy0dtIPrYZm6+yS/rs+gHuhM/nVMUt06kZA1M+khubLKfxSI+JvFd20TKKjlMSMyjvz56/KNN0ZFarE5BIo7UQHib9yTcfAO2ICn/TYocjfY/1HWb3xnqc2KGUkuLzNajlrrBVNF+DjToiEJiG5sv5tKwn4CgFnvHtpwwZ4TNYd3FlroB1ykLhTNNzz63+xE0DVEsOjL5echIB4+6r074UFzrBgx4t4FeBdqfsLla8Y+rVo0Zx2YqkjI/AJhJRcfplqOrKvwwZeDU9JyxPRmFKizvrjvMTS6ztlrHR3r893tKEsHhGu807n/Nq2NbiBTbw57ADBG74RjPRV1bAqU2zMBxmrwmqjFan4GN7Yvh5sOEDsjfq9Z8HzzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(26005)(16526019)(6486002)(53546011)(2906002)(86362001)(4326008)(186003)(316002)(52116002)(8676002)(2616005)(16576012)(110136005)(478600001)(83380400001)(31696002)(31686004)(36756003)(66946007)(5660300002)(8936002)(66556008)(7416002)(956004)(66476007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dG5WVG0yVm9WQ3VxZUtJRFhLemR3YTdjYW9JMlZIZTBtVkpqSndvMHBBMUJi?=
 =?utf-8?B?V1RQVy9rWm5kajZaTURGSVRRL3ZPQWdqVTFrVFdkMnBVMjZITFc1eVp4cDNQ?=
 =?utf-8?B?UzV6c3NrUFFwNUt6cTdpamsyNjRLeXpHSUVVc3B6V0RJZ0Q0V3puRXYyZzFl?=
 =?utf-8?B?NnZTenpILzdGSXROREdYSnJyQis2K2ZNSnpTVEhzQWhGWVBtdjh0dlBGNXVt?=
 =?utf-8?B?VjdPRkxpd0czN01KcE9EYmZEVW1INjFVSi9kM2VqQWpGN1BGSGF4QW5pK20z?=
 =?utf-8?B?VS91M3RCd0xCbGZXd2FCZjVGZ2lVcGwyemg4cEhKQnlod0pxeEVYdGtLU1N3?=
 =?utf-8?B?WGptRHZ0WVlnNHljQ1h0WkdLN0RrQXdlbmNiakJuVHAzemRuTjUxZEhvTFlR?=
 =?utf-8?B?VUJ5T1d0VkNuTHFkZ0ZOR1FrSHpReVM4eWVTc1BpSFlvTDdVREFEQVBkQzR0?=
 =?utf-8?B?NHk3cUluRTU2NXBqM1BqSytNazVuRXltVGhtMHk2WnpWWlJCV1Y5dlFudkp5?=
 =?utf-8?B?Q0VzRFNpWTJWS3N4SzY5NUxwTWdDM0xxUU94STUrb21zVjdmWGpST0NjL0FG?=
 =?utf-8?B?K3hnWG1kb3g2WEVGU0lOUGlnN2xXWHV5WlFnZXd6ejFDVDFvRnpIRWRpWGxw?=
 =?utf-8?B?T05Qc2dwT2p4cEExNXloRk1LYzcycHVaTHVVY3Bwb1hIbk1xRWFqMWlDUGxh?=
 =?utf-8?B?Vkd6MzJqdi96bDU3Y2JtajVFNnNLWHFLQ2tTMXozdllrc2UwK1djaXdnL3Uz?=
 =?utf-8?B?alZhSzFWdlVQTzRQWE4zRGpRS3Jmai8yVGFLUVcxNnR5VmJSbjhJUnljTUd2?=
 =?utf-8?B?M1RSaWtsVmRkQS95Mm5jNy9DZnFqeTJzNzNXWEdEOGJuczE2TDZuT0tDTWM4?=
 =?utf-8?B?UUVNcFl3V0xOQ0hNTTEvaHpQdDJkbDRHeGo4NUgrcTFINHBZaHhnazB0UTRr?=
 =?utf-8?B?MHIwbitCWXRBaHRHNGlNeS9PRE1QK1g0VTZHOSs5Z2s1aU9Ia1RNY0JpbGxi?=
 =?utf-8?B?MzVRNHg4MGxQYU9qYW9yM0R2TFBqVnBCSlU2cnQrcmdaVkl4eG9NVzFCNXhq?=
 =?utf-8?B?eFM2K3Y0dEZJWFhMV1h6Z1Z0YkttdzJTTXVaTUVsbEVuK1ptOHhZNjlZWDdT?=
 =?utf-8?B?MklKbjd3Vk9rNGt5U0FPZndOSW5EbnIxUmsrY3lOVW9PQVpYTTB3SmY3b0Vj?=
 =?utf-8?B?VGpGeDg2ZXJIV01VSXdVRFpnUm84YVZIbVNqVzhFaWtHTDEwQzRKak82YTNs?=
 =?utf-8?B?RmF3ZVJhRHFTeVNWN2NUQTNleVh6VGp1UUJLeG10TG1PbUFURkUrWTNxUUxj?=
 =?utf-8?Q?j6Z0K11r1oc5yypXG3ELbWH69ICAIDo+Cz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 04:55:42.8746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e04b7f8-55c0-4a60-555e-08d8b77f7b45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8AluK6OPh29JCiLOX5KYbnPQ/eYo6IUdU7cHUSfS4es4usFEs2Zz0pZK15C4a+W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2487
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/21 11:56 AM, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Andy Lutomirski wrote:
>>
>>> On Jan 12, 2021, at 7:46 AM, Bandan Das <bsd@redhat.com> wrote:
>>>
>>> ﻿Andy Lutomirski <luto@amacapital.net> writes:
>>> ...
>>>>>>>> #endif diff --git a/arch/x86/kvm/mmu/mmu.c
>>>>>>>> b/arch/x86/kvm/mmu/mmu.c index 6d16481aa29d..c5c4aaf01a1a 100644
>>>>>>>> --- a/arch/x86/kvm/mmu/mmu.c +++ b/arch/x86/kvm/mmu/mmu.c @@
>>>>>>>> -50,6 +50,7 @@ #include <asm/io.h> #include <asm/vmx.h> #include
>>>>>>>> <asm/kvm_page_track.h> +#include <asm/e820/api.h> #include
>>>>>>>> "trace.h"
>>>>>>>>
>>>>>>>> extern bool itlb_multihit_kvm_mitigation; @@ -5675,6 +5676,12 @@
>>>>>>>> void kvm_mmu_slot_set_dirty(struct kvm *kvm, }
>>>>>>>> EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>>>>>>>>
>>>>>>>> +bool kvm_is_host_reserved_region(u64 gpa) +{ + return
>>>>>>>> e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED); +}
>>>>>>> While _e820__mapped_any()'s doc says '..  checks if any part of
>>>>>>> the range <start,end> is mapped ..' it seems to me that the real
>>>>>>> check is [start, end) so we should use 'gpa' instead of 'gpa-1',
>>>>>>> no?
>>>>>> Why do you need to check GPA at all?
>>>>>>
>>>>> To reduce the scope of the workaround.
>>>>>
>>>>> The errata only happens when you use one of SVM instructions in the
>>>>> guest with EAX that happens to be inside one of the host reserved
>>>>> memory regions (for example SMM).
>>>>
>>>> This code reduces the scope of the workaround at the cost of
>>>> increasing the complexity of the workaround and adding a nonsensical
>>>> coupling between KVM and host details and adding an export that really
>>>> doesn’t deserve to be exported.
>>>>
>>>> Is there an actual concrete benefit to this check?
>>>
>>> Besides reducing the scope, my intention for the check was that we should
>>> know if such exceptions occur for any other undiscovered reasons with other
>>> memory types rather than hiding them under this workaround.
>>
>> Ask AMD?

There are several checking before VMRUN launch. The function, 
e820__mapped_raw_any(), was definitely one of the easies way to figure 
out the problematic regions we had.

>>
>> I would also believe that someone somewhere has a firmware that simply omits
>> the problematic region instead of listing it as reserved.
> 
> I agree with Andy, odds are very good that attempting to be precise will lead to
> pain due to false negatives.
> 
> And, KVM's SVM instruction emulation needs to be be rock solid regardless of
> this behavior since KVM unconditionally intercepts the instruction, i.e. there's
> basically zero risk to KVM.
> 

Are you saying that the instruction decode before 
kvm_is_host_reserved_region() already guarantee the instructions #GP hit 
are SVM execution instructions (see below)? If so, I think this argument 
is fair.

+	switch (ctxt->modrm) {
+	case 0xd8: /* VMRUN */
+	case 0xda: /* VMLOAD */
+	case 0xdb: /* VMSAVE */

Bandan: What is your thoughts about removing kvm_is_host_reserved_region()?

