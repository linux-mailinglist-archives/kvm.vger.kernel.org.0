Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD65A666AC2
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 06:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjALFVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 00:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbjALFVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 00:21:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240C74BD7C;
        Wed, 11 Jan 2023 21:21:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N39MfDjrVAZ+as6lWfgR0Uj+GvbU2ORDIBTcB7NlzmXm1Qsj6WS7qHvMCnk4yaZ2Z/SKUEcpe4/S1mh1zeuXLPVQadbsGmrT5VMfGjIGEDfHgUfZHT3HpYoCk8UMi28aXRxGbxTEV4A6Ro1FsvMmaOyQDgeKyTvSr1T3iuxkkSC6M0NutnndoYpS+Qn1VoEx98JlXkpzFOYIRIYK6ZagrDV1KEkCPT23ZcwLff1cZ+qQ5v4Hx1VPcjPAvcqpJ1ntBtpbBkBeaFxsc+usMJ8Uq0+tqcCpzCu+vbVMirdPI8YCmG4C+0kDQAhBNiFQKfxpk/QBKCDXUqDPw2Bd6nCaIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcmB3Th+4SwKwe0zhRg9WN8qTrA2KV54iVIwMCm1I8A=;
 b=YHdY86ARYGMTqRFZU9saX5zwRYjGOjxULxtse1oChrAdpCYELgqKcOiyuBDEi5SPGhzblC4VxmqKgJPhamT9D0yHm8/c79+4y3aJa4vpIcjlzgcDAvlDoKCoRnipOyeCs5X+XKdlQfkRVh5wrfSjDlA4KorwYJvGd8GyWahknSKw8ThFf6pZssrmHSzzcerbzK/7J8cJNCWy5U39Me4vj+2a7euzu5xxFVgZ8ycLZo97iK1Z8xdwfIXwZ7/qV6acD9riMTbVZxUikvBEKZM8EX25LOelxDM4oNBQWYoYCBJYslDJiVNaDVreTA7dV2rUo3Q/rN7XLNMoGILCFk9nhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcmB3Th+4SwKwe0zhRg9WN8qTrA2KV54iVIwMCm1I8A=;
 b=fDbUrAipV8q6u+zdXx53ZDqpnuy4QR3arMWOuXOUlG7n2FIZccGkHbn2NIuVI0s5pLVnGc44LxdLb5wHLrVQP6g4aX/uQdtS4OdGQv+/FDIMRuXqNUQbob1XzYUIpe4kapCwFsCPVE5CgyqsCV4Z5HIipRrUqUkWGMuzPROydME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 PH8PR12MB7304.namprd12.prod.outlook.com (2603:10b6:510:217::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 12 Jan
 2023 05:21:44 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 05:21:44 +0000
Message-ID: <61fde9ac-e24f-c765-a9a8-91fac60b9cb3@amd.com>
Date:   Thu, 12 Jan 2023 16:21:28 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v2 1/3] x86/amd: Cache values in percpu variables
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-2-aik@amd.com> <Y72MwWB+Nsphjqs8@zn.tnic>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y72MwWB+Nsphjqs8@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYXPR01CA0093.ausprd01.prod.outlook.com
 (2603:10c6:0:2e::26) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|PH8PR12MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: 733c5d64-8bcc-4cdc-8e34-08daf45ce46a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ygJ0lvs57DysZUrxPHy4NrjyT6uHlZMkVv0SLmIgUGr0vhy0fajlwECIy7jA8wEd0gLUZy7hlz/v4ZAI/kcFVJxuh+3amspg8k3bjpumSa0q6VFXNjdgmislxN0Ejh26AQDXn3h7U5E1EwY0vRzWhw5aMYT81mqDKIQBeTJxJA/XTf2iuOh2TBtb6nYk8Wkk8xE5+AD7Mn7Xqua94rwg+fV4BJUY/jXQlBA9AIoG2YFfnoqtlR0ixMMVTne+gJaXhryKHWet1D6BJyawWpuDSzcHX8/JVLL2aPJ5KHt/f3pBydZ7NviNHVAcwcyOxthOfaoXkUBlwrNi3LFQNjmEhU3X+FLdi5AHcFd1VX3DZW4z1T29XH6/U+fPFrJeszxDtNWRo5AkgQyWqnlN4WxLwmZJIcmU0Ko9z+1bokxLBUsa8LzLqGb2V6eUBkykldqGxNDRKuJ4xKjg8GVceCovZsrB+agtfJD9gd1Ai3za5g5Nq7JO/C2eTYX/S+t80D8dvWDx67lJURikpCdU1PL+hLTcFwVZB1OwhV2PZ6XwttxcuUchd0Jk603XEXFsHnSafc0tq7funyP8aATlVKtGGd5ZjmIUgxzm1ljOU5I+39oXzH+s5mNxSiMm2qzE2YOWHmvwRl7vTo9erEUrTIqGjS5/Toiw13nP+q1rndrkFpsbE2677SE1bo9Z32HHpN/Q63wkTYyQWtsxz0jpw8uXpqJF1cqpvGj/iXlgRNvdjuA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199015)(2906002)(2616005)(36756003)(66476007)(316002)(5660300002)(66946007)(186003)(66556008)(6486002)(83380400001)(6506007)(478600001)(4326008)(41300700001)(53546011)(6666004)(8936002)(6512007)(26005)(7416002)(6916009)(54906003)(8676002)(31696002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFBCTnFnVG5BNXl6cUJic3JpdTRXZURvdm0rWGpwM1Q4TmJSeVMrWlJzUTBj?=
 =?utf-8?B?ZE9WK3ROSUx6NkhpSnB0cGdtVTVvYVRQNVMzRHFJcDZvbzZxbzI0V0p5WTh1?=
 =?utf-8?B?SXRBei9RTWVJb0JPa25aREJBWm5KWVluNDFWUkovTnZ4eGhUS0FNVjI5TFUz?=
 =?utf-8?B?b2dtK0d3SXhxRDdNTFVJVzlDbWJiUEJWZ2VxYkJEQXRib05sZDhjdmJHWjJM?=
 =?utf-8?B?R0VpTEx1ekJ6KzNPZkwzWGhGRjIrOGNPU3o3YVEzWlZkaFlIWTVGN2cwbEpT?=
 =?utf-8?B?TXkraU9zU1BkZHI2dUp5V2hneGRLbGZqeC90YTRCZzA0RXArdWh0LzJmbUhZ?=
 =?utf-8?B?bHJBSytHWUVEQ1E4NEdEV3BVZGVaTTBDcC8xTXEwYkxHZUpLTG53WjBPMWJ6?=
 =?utf-8?B?dFlrcWhRL1pndVAxNkkvVENUbGtmSFYyTms0UGpveG9wZkxpdnpaZ0VCUUIv?=
 =?utf-8?B?NFdLRmZnYkt6VTNEK0k2TzFyQVBPMHNVQ0hrbU5DRW9KZFJ0M0Fyb0FoVG9C?=
 =?utf-8?B?TFFacm9nNU1hS1FUYjFsdDVLWklDaWFsTm1TaEVvanNmNUk0aHRucEhzSEVs?=
 =?utf-8?B?dHpWZ3AxVlFvbVN4TFJnU1ljZUpMTm52cGcraEJscURqS1Bqb2FYVGlvWThm?=
 =?utf-8?B?a3pxaWMxTUtoSWR3aXhMbVd3UmxrdVdHeFhzbElCQmtvTDZ6YWd2UmNKOWQ5?=
 =?utf-8?B?R2FFd3FRZGMxM0dzc2grUHo0SEEveDdaRldpb0hRS0ZWNVFUdCtaYnFEWkxu?=
 =?utf-8?B?WlRvaHBlTE5BQnAvSG11bUFKajZyYnQxcEdqNnB1Rk5JRmUwVHMzdkV0djIy?=
 =?utf-8?B?Rytxd3FPOG9wdXhWRUs4OFVnR1Vza1dVSEVZZmlQWHp5aFRhQmlWRzdPYnVB?=
 =?utf-8?B?Q3lFTUJLVGpRVlpNMUhWWEFIM1RBNVYyOFlUUEtwbVhkalFMQTlLRVFYcmJq?=
 =?utf-8?B?YTdISHhCNDZkTmRUd3NCSi9xbjVDOVJqOEFLSTNyYVhUT2M1bHo1cGZDcWlV?=
 =?utf-8?B?Y0JsZndsaEhIeWtLamUxcFpiL0Y1aGsycHBzaDRaT0haYWRFM1dHK0Rlbkd4?=
 =?utf-8?B?d28rRFlmdUJzTHZKOW55OHA1WTI0NUQ4bFZodm16c05SeFBKbHptbm1KQnpi?=
 =?utf-8?B?SXJ3WnE1RXJMQ0xRMWVXZkVaaktGU0QyZW1odExhNkc2L1V0UjhmMXIzU1BC?=
 =?utf-8?B?ZHFvbmgwRE5Wb1c0RXdYVHFBU0pzY3Rmb3pCSHlrZHo1MUdFZVlVZGV0SVVL?=
 =?utf-8?B?MEREdHJITGNIc0kzUU1NSkJIWkVPSFd2Y2ZGQUdwMG16cFR0alNuWjZlcXZl?=
 =?utf-8?B?LytzYzhnc2tXN29TcnBRSm8yUnVlZ2d2TU5Fa3RZUXJIYXJKY21GdEEyZDBt?=
 =?utf-8?B?UkhtQzJwZkV6Y0ZqaXYyQ0J4ZDMwT2x5T3R5Uk9lV3kyelhQL1FnRGErc0FX?=
 =?utf-8?B?a1cyTkpBcmRvd2k3RnpvTWFiTDJPbUpqeWUvSlo3TGl2VFNEOFY2emQ5c212?=
 =?utf-8?B?NGE3WnVPUHFUZkIzV2xpL3pTU3pVWTFqbVJxRE1ZOU1JSlBDNlV5enRFdXM0?=
 =?utf-8?B?QmNMd1ZqOUw4TEpJcTlUYUFZMlVsR0p2OWJDSExqRzhnMm44Z0FTeEtwL1N0?=
 =?utf-8?B?dy9qWHBPNGpYY2tpS1grRzNEcjVNYlpnN0VMckdyQ2d5VTM2UDhTd0E5Uk5N?=
 =?utf-8?B?M0dNTDh5elR4UWt2TkxTaktDRFY0dE0rNHBtVkltaytOd3ozcVJiNEw3bjNC?=
 =?utf-8?B?NzlJMEc3blBaZFNxMFpuRUI1NU1Ya2dDMkMwRGNEaDAyNG82RGk4aWdPdlE1?=
 =?utf-8?B?bFhCc2lBNEo2bFVRQU1kcVRxMHpoZHF3eDIwaUhTQlRGK0pkVThDc09aUU8r?=
 =?utf-8?B?cE0wWnRmY0J0N0pkeGxkMHlyRWhUT3g0NVRDc0lWRXBMV2p3Y2x5NG8zS2pF?=
 =?utf-8?B?YmgxcW9RODVtSlBhSjgwdXRDcFVxbFQ5Zmk2M1haSmNvQTl5RDlRSys1VTVC?=
 =?utf-8?B?WFgrUnpHdWZ6TlFhMXNCekpBMW4vbkdjODhCOEY3VXlyaUkxT2RoUmhqeW9n?=
 =?utf-8?B?SER2c25IU0R1U2pNWW9CVWdPU3l5Ynk0VmMrVFIwcjljeXJkUjVEd3NqbDR6?=
 =?utf-8?Q?wevI6UW1ScmbtZYt2w86lwFlg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 733c5d64-8bcc-4cdc-8e34-08daf45ce46a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 05:21:44.3015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rIEvK+jrsWuJU9Y+KvRFbsOaIm4gerR75hOEhT+IqV8STrBCp1GoK3Nr54IYqLC8NIfx00ub3vmiW6r0Z//0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/1/23 03:05, Borislav Petkov wrote:
> On Fri, Dec 09, 2022 at 03:38:02PM +1100, Alexey Kardashevskiy wrote:
> 
> Make that Subject:
> 
> "x86/amd: Cache debug register values in percpu variables"
> 
> to make it less generic and more specific as to what you're doing.
> 
>> Reading DR[0-3]_ADDR_MASK MSRs takes about 250 cycles which is going to
>> be noticeable with the AMD KVM SEV-ES DebugSwap feature enabled.
>> KVM is going to store host's DR[0-3] and DR[0-3]_ADDR_MASK before
>> switching to a guest; the hardware is going to swap these on VMRUN
>> and VMEXIT.
>>
>> Store MSR values passsed to set_dr_addr_mask() in percpu values
> 
> s/values/variables/
> 
> Unknown word [passsed] in commit message.
> 
> Use a spellchecker pls.
> 
>> (when changed) and return them via new amd_get_dr_addr_mask().
>> The gain here is about 10x.
> 
> 10x when reading percpu vars vs MSR reads?
> 
> Oh well.
 >
>> As amd_set_dr_addr_mask() uses the array too, change the @dr type to
>> unsigned to avoid checking for <0.
> 
> I feel ya but that function will warn once, return 0 when the @dr number is
> outta bounds and that 0 will still get used as an address mask.

"that function" is set_dr_addr_mask() (btw should I rename it to start 
with amd_? the commit log uses the wrong&longer name) which does not 
return a mask, amd_get_dr_addr_mask() does.

> I think you really wanna return negative on error and the caller should not
> continue in that case.

If it is out of bounds, it won't neither set or get. And these 2 helpers 
are used only by the kernel and the callers pass 0..3 and nothing else. 
BUG_ON() would do too, for example.


>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index c75d75b9f11a..9ac5a19f89b9 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -1158,24 +1158,41 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
>>   	return false;
>>   }
>>   
>> -void set_dr_addr_mask(unsigned long mask, int dr)
>> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long[4], amd_dr_addr_mask);
> 
> static
> 
>> +
>> +static unsigned int amd_msr_dr_addr_masks[] = {
>> +	MSR_F16H_DR0_ADDR_MASK,
>> +	MSR_F16H_DR1_ADDR_MASK - 1 + 1,
> 
> - 1 + 1 ?
> 
> Why?
> 
> Because of the DR0 and then DR1 being in a different MSR range?

Yup.

> 
> Who cares, make it simple:
> 
> 	MSR_F16H_DR0_ADDR_MASK,
> 	MSR_F16H_DR1_ADDR_MASK,
> 	MSR_F16H_DR1_ADDR_MASK + 1,
> 	MSR_F16H_DR1_ADDR_MASK + 2
> 
> and add a comment if you want to denote the non-contiguous range but meh.

imho having 1,2,3 in the code eliminates the need in a comment and 
produces the exact same end result. But since nobody cares, I'll do it 
the shorter way with just +1 and +2.


> >> +	MSR_F16H_DR1_ADDR_MASK - 1 + 2,
>> +	MSR_F16H_DR1_ADDR_MASK - 1 + 3
>> +};
>> +
>> +void set_dr_addr_mask(unsigned long mask, unsigned int dr)
>>   {
>> -	if (!boot_cpu_has(X86_FEATURE_BPEXT))
>> +	if (!cpu_feature_enabled(X86_FEATURE_BPEXT))
>>   		return;
>>   
>> -	switch (dr) {
>> -	case 0:
>> -		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
>> -		break;
>> -	case 1:
>> -	case 2:
>> -	case 3:
>> -		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
>> -		break;
>> -	default:
>> -		break;
>> -	}
>> +	if (WARN_ON_ONCE(dr >= ARRAY_SIZE(amd_msr_dr_addr_masks)))
>> +		return;
>> +
>> +	if (per_cpu(amd_dr_addr_mask, smp_processor_id())[dr] == mask)
> 
> Do that at function entry:
> 
> 	int cpu = smp_processor_id();
> 
> and use cpu here.

Sure. Out of curiosity - why?^w^w^w^w^  it reduced the vmlinux size by 
48 bytes, nice.

Thanks for the review!


> 
>> +		return;
>> +
>> +	wrmsr(amd_msr_dr_addr_masks[dr], mask, 0);
>> +	per_cpu(amd_dr_addr_mask, smp_processor_id())[dr] = mask;
>> +}
> 
> Thx.
> 

-- 
Alexey
