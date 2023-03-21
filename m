Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87066C2AE4
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 07:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCUG5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 02:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCUG5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 02:57:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9153D904;
        Mon, 20 Mar 2023 23:56:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQ3Ir7fbn/1iDD2kq13f1PgRUYqaabAUSKoUGMkSj+q8Mvx9yQGvpRogwyyOJQtfv0IvxT/K1RR37yWpANKGcWSLgupMS+bPCdfGA0dMCRt9ZWx/HDpnohmO22fR0Lcr/vHFg3Z0tEPTFOtpMt6JBUgFZp0wd/yEh6wh4i/3ux7Pq9dg/5VIekKjGFfbZBKXNrtfDnXnsaQ+1JUdTFVYZxd/MNRPTulo7yLYrdOh2t3TkbrqkTL7xxmwD9nDVKRcGA/ADPdIrmEJ32Y2K0PUzf2GDN6m9/vfafypwW2EMkdemqg7qMWikTpXSDVKltwcqB144OX4Ap3/Hm7+2ekqhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHTiiQ9Mn/bq6BTUWXUDwg+RGu7D9u9SyMhWpdeskvw=;
 b=EHBhKJa0LnbO+a/jMRbsX4coefZ3sXUCRLmo0zd/QihgrrOFCRUgoHuFtKI3/GUiIOtPsx8gBp9t9J7crQrlNvXs7S+93qQsrgBv91l0rK4WGDIx8U1/5sfKWH5cmcFNKYVT4pV9OSrXfWt0HEUA3jMv//poq2hqNKT9raR5Gc6qKBCoZUWtWt8cgBXqQ8EBhxoNbeyBNM5McmihrXCCMlgP3vJ2VrdajGfS8/7UywWpjq7fvRTTl0JChxEQIlt3UlLptAcsLZHaaYaF/Y4EVy/G9vbto82RAMvURzWJncLjjEgIpaYubYqfUFrzQu7uMbvfWnVElnNAeLYZ3IFiSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHTiiQ9Mn/bq6BTUWXUDwg+RGu7D9u9SyMhWpdeskvw=;
 b=4OiLTbAasW56DlzVqzlrUqH+pKfYSVPDaOOgppTZi2EkoAqmABbHjDO5gbOqU8Wy5GMkZDSAveszBFKsaPOzPKYm1trTpVquG9g9naNVTko2Gjx5m6d7Q2A4nzZj1BCFpNgZKuY1WxmHhvnT/5nmFyRAb9qHz4jUIEnNzdDckWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 DM8PR12MB5477.namprd12.prod.outlook.com (2603:10b6:8:35::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 06:56:26 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 06:56:25 +0000
Message-ID: <bc5e3e5e-357c-bec0-6916-01932e8f9ac1@amd.com>
Date:   Tue, 21 Mar 2023 17:56:15 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH kernel v4] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
 <20230203051459.1354589-1-aik@amd.com>
 <95c83ff6-0dee-d81d-6a3c-12de24cbbf32@amd.com>
 <318a4c2f-67df-f0ff-c945-327c2e92f9d8@amd.com>
In-Reply-To: <318a4c2f-67df-f0ff-c945-327c2e92f9d8@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY3PR01CA0111.ausprd01.prod.outlook.com
 (2603:10c6:0:1a::20) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|DM8PR12MB5477:EE_
X-MS-Office365-Filtering-Correlation-Id: 81324cf8-49cd-498d-0fb4-08db29d96367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmzqyqDvoxoD/TpxjCYAgqJCHEMopK46EFFpU9d74pqIIqXSpNDViyYfB+/qvQTpBoCVVjtGfKFOCeRL0Lp0cLsjh94168NUJUtGNZcrQMtgDJpPjvRTOUme0TaYCr/Mul4CPMq1nJ3W1M6YszH5XB871Oaz/LZsyyemLkw2/pEXTS/aUCgUqJWkOGpEGa75wuArAZLcoqgOakr+7yXrQMey8qtTXkZJKFzl7uKSKmbyEyaeDYoWXw1570GzMdCGHSRU1+B+EkHcYJgZ3BjMmAEUnOE5xAij03/r5jYRjLd51eRDtV52LLcFHyRAAObPCeL1XODko0esaPUZNQ6yI7WSy0KutsNgHzqAxbyih8ixVN3vqseaoSyTL1rLGQGeQS8Gkm0ew1LaF1b9hz+m0ozv9Cx8AImkf6VRsCOjKy1MIaVrp8idtgTBRdM2vcMw6uLVcRMSOSS5f837VvWZgB3lgl/S9SuLMKJS7bXNKZbxIzFT6+VQqi8p6y/CpXVEFU0DlmUN5oOmp8rhqnMc96m/JzoBiNe4fqLT+R7BbCA1DYjnU4+4LcGe+00OJcLlcIZiNsC3BQovqWot8QfF428NXQ00MwhIT+JdDPVB1p95BMP90wLNfyd2DWpyh1Za6X363RDDQ/UY3j+38qGT61fuxtaYeRzQxRD0RP0rF6T3nZV7p3dcGyUreNkpIQlTOHYrO2FoKV9hOWC7ZKmJ8J6WAIX4W2gxlNckQGXRDBg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199018)(8936002)(41300700001)(5660300002)(7416002)(30864003)(4326008)(36756003)(31696002)(38100700002)(2906002)(83380400001)(26005)(53546011)(6506007)(6512007)(478600001)(6666004)(186003)(6486002)(31686004)(66556008)(66946007)(66476007)(8676002)(2616005)(110136005)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmRReGRoYUNYL3V6V2xoMEw2S1QyQ3lsMHF3aG9uTFpvcVRFSXNvTjdIT1hi?=
 =?utf-8?B?Q2lQaDhCR055QUgvVURmbnFubzc0SmpyQldkN3I4aU53UVN1dHh2bTM3Y1FD?=
 =?utf-8?B?STNPZlNIemphc3I4anRzK3RxR2o1YkhYOExQV0pvVEpBZzlSbUxHVkRZdjFF?=
 =?utf-8?B?ZDAwN2lhN2Zja1ZybUtGc0JwRHBWbndIRjFsL3ZEYlA4U1NUUTJBWUZ1QmlM?=
 =?utf-8?B?UFJrMmJFenpIUm0rZzNnN1JLMTdYT2hyd3BWSEcrRTVGcWU0WmpPdkJONEtF?=
 =?utf-8?B?SytIdyswdi9iZ3l5aWM5RkhHK3p1K1NYZm8xRk1pczZ6czVhK0l1bEdaaldQ?=
 =?utf-8?B?b0w0NExMTXczR3BWT2g0QVFFejZ2R0cwZ25QcytWOHlLeDhhOExnTit3YmVI?=
 =?utf-8?B?WVBBWTdEY3J6WUxPT0dOaFNVQ0xvYmZLMjhkSjc2NU1pakJuVWhLRE82blh5?=
 =?utf-8?B?dkJLclRMRlBpOXp1UkhscjcxZmo4Tzg1OXYyb1pHcU83M2tzQzRoemtOZXZB?=
 =?utf-8?B?SFpSSUlzNXNiQ2xYcW1jNTJDeHR5NEU0Z1V1YjdWelJ6VW1maFAwYjRqK1k2?=
 =?utf-8?B?dkZpYzBxU081YnBsY1N4b0ZNd1RrMm1nYjA5TzVZb3M2cjhlUmF6MkY5Z1ln?=
 =?utf-8?B?d3FoVFNmNVowL255Vy8vbVdQUWx6UWhTWDNoNEo0Z0xWMjVqYitWbncvN3dp?=
 =?utf-8?B?MzJ0TGc0RU5aaG5vSDZNY3RwMGwvQVpSNUFoT2pKWms4TDNiM0FGR1o4ZXVk?=
 =?utf-8?B?SEhMTytUUTBKSnJNU1JpbHBWZFFmWjdKYXBBYnJ5a1hBZURGMUd2NjJublZK?=
 =?utf-8?B?ZUFUUTlwc3BiaG1jalVYejRSUkZPdHNXZFNKTEFJa1M3bnFCV0l2VTNLU2c3?=
 =?utf-8?B?aFZDSnR4c2lrK2VjZ1huRjBkNWRyRDZDV1VFWHVrRklMZzVoN2orZ2lSMWxk?=
 =?utf-8?B?M3phVlBlSHoyOGZQZmVjWWRiemJNMEpoRGZtL3YyVWhncStPc0I2MHJUZWVh?=
 =?utf-8?B?RHAwVW53QUpXb2drV3MvcEZvMktKZUNFYWwra3RZeUJtaW53ZVptSG1xRHRl?=
 =?utf-8?B?cnFtckdQUE9adlEvdTV0SHoxSFJNd05TeXBXSEN3MFlZeXdwejkvazZiTUtK?=
 =?utf-8?B?YXBzNTVkWHVLdW4zandOS2xyOTVUaFMwWlZrMG5oNjFyNW9LT0dIOVVWVmxU?=
 =?utf-8?B?bnBnbVpwK2FZS01qaWtFbXJNdis1N1JTc21kTDV6YTJCK2VJdk1TTUtXNFRU?=
 =?utf-8?B?ZzZNdVJKcy9uRk5CWjFHRlZ1YzZ2YjJFUWk3MTJKQU8yUTZhckNwZlJRQWh5?=
 =?utf-8?B?aEs2S0ZESENiMzhnZzhHMm5qYkFrZ2sveGJqSlJNbm1vRXY2UUpjaHZuV2pS?=
 =?utf-8?B?Q0J4eG1pWTNYcGQ3ajJVSzFyOUF2Yk5LZlZCbG92VnR4Zi9HeXBHTUVwd2Ew?=
 =?utf-8?B?UUM0dm1HeHdDNnI5aEswUHhBekI2ZXNkbEk4WTh1Y1JWdDR1T1FxOXJtcDhj?=
 =?utf-8?B?U2UrcUN6VjdxSVBkZUpITUpvenhvRFNPbnBEd3pWNTY1a0tCWGxESS82Rk50?=
 =?utf-8?B?WWFObkFndmhEQ2Q1blViTitrSVVUa3hRSkd3RC9RdlBZa2ovc3EwQU1VTFlS?=
 =?utf-8?B?NDQwWVRxeDVjSzExZmpmSG9RSzlVdUQxQ2wvQzJCT1VHTFp5WmVDUVhBQkk3?=
 =?utf-8?B?ZGpBN1JNLzJlN2tnS1M1QUZvSmdQVlVoRlUxcUwvdjh1dnlVN0JhZmNTMnpJ?=
 =?utf-8?B?VzdKazdPQjlOb2ZMM3RseU9iWThOZFBzTHhOellnTUpJUmR3Y1BmUVhaeFBp?=
 =?utf-8?B?dzNVV2ZzKzA1S2VUNUlkekdXWlR5UTB3VjlTbG9oRm95VXNjNXB6ZGhLcGVG?=
 =?utf-8?B?VzdWWjQ4TG5YbkdBd0FLT096eVF0ZExBMGw2cEFaN0J5YmpyRWtXOGpSRDVp?=
 =?utf-8?B?UjNKVkhheTZZNmlWbWsxWFZlcG4xT2E2S0V6aE5UT1Y0aEsrMlU1WUxiQ014?=
 =?utf-8?B?Tktkbko3UGxpZ2NXS2Q2YmJ3Wjhsd1puUzhLWDNja2duQmZrRDBPaTZkUmtP?=
 =?utf-8?B?V1BmUHhHZUtycW05QWlFTzN5cmppUGQ2S1Qva0VUZ2lnOFY1ZmpIQlh0ZUEz?=
 =?utf-8?Q?Ks/nJZZiM2ILpe0Ki2BGTfKiN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81324cf8-49cd-498d-0fb4-08db29d96367
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 06:56:25.7428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FE4S35eeRs8/FRrfoKj9TX9ImZ8cJXgObRgMHNd2Nbt1Gqg4Qh+7xxk8nhAA0pjND98yxoH/Z/8+mBhfuGfgqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5477
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping? (I am told that pinging once a week is ok) Thanks,

On 14/3/23 20:43, Alexey Kardashevskiy wrote:
> Ping? Thanks,
> 
> 
> On 21/2/23 16:19, Alexey Kardashevskiy wrote:
>> Ping? Thanks,
>>
>> On 3/2/23 16:14, Alexey Kardashevskiy wrote:
>>> Prior to SEV-ES, KVM stored/loaded host debug registers upon switching
>>> to/from a VM. Changing those registers inside a running SEV VM
>>> triggered #VC exit to KVM.
>>>
>>> SEV-ES added the encrypted state (ES) which uses an encrypted guest page
>>> for the VM state (VMSA). The hardware saves/restores certain 
>>> registers on
>>> VMRUN/VMEXIT according to a swap type (A, B, C), see
>>> "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
>>> volume 2.
>>>
>>> AMD Milan (Fam 19h) introduces support for the debug registers swapping.
>>> DR6 and DR7 are always swapped. DR[0-3] and DR[0-3]_ADDR_MASK are 
>>> swapped
>>> a type B when SEV_FEATURES[5] ("DebugSwap") is set.
>>>
>>> Enable DebugSwap in VMSA. But only do so if CPUID Fn80000021_EAX[0]
>>> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
>>> supported by the SOC as otherwise a malicious SEV-ES guest can set up
>>> data breakpoints on the #VC IDT entry/stack and cause an infinite loop.
>>>
>>> Eliminate DR7 and #DB intercepts as:
>>> - they are not needed when DebugSwap is supported;
>>> - #VC for these intercepts is most likely not supported anyway and
>>> kills the VM.
>>> Keep DR7 intercepted unless DebugSwap enabled to prevent the infinite 
>>> #DB
>>> loop DoS.
>>>
>>> While at this, move set_/clr_dr_intercepts to .c and move #DB intercept
>>> next to DR7 intercept.
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>> ---
>>> Changes:
>>> v4:
>>> * removed sev_es_is_debug_swap_enabled() helper
>>> * made sev_es_debug_swap_enabled (module param) static
>>> * set sev_feature early in sev_es_init_vmcb() and made intercepts
>>>    dependend on it vs. module param
>>> * move set_/clr_dr_intercepts to .c
>>>
>>> v3:
>>> * rewrote the commit log again
>>> * rebased on tip/master to use recently defined 
>>> X86_FEATURE_NO_NESTED_DATA_BP
>>> * s/boot_cpu_has/cpu_feature_enabled/
>>>
>>> v2:
>>> * debug_swap moved from vcpu to module_param
>>> * rewrote commit log
>>>
>>> ---
>>> Tested with:
>>> ===
>>> int x;
>>> int main(int argc, char *argv[])
>>> {
>>>          x = 1;
>>>          return 0;
>>> }
>>> ===
>>> gcc -g a.c
>>> rsync a.out ruby-954vm:~/
>>> ssh -t ruby-954vm 'gdb -ex "file a.out" -ex "watch x" -ex r'
>>>
>>> where ruby-954vm is a VM.
>>>
>>> With "/sys/module/kvm_amd/parameters/debug_swap = 0", gdb does not stop
>>> on the watchpoint, with "= 1" - gdb does.
>>> ---
>>>   arch/x86/include/asm/svm.h |  1 +
>>>   arch/x86/kvm/svm/svm.h     | 42 -------------
>>>   arch/x86/kvm/svm/sev.c     | 24 ++++++++
>>>   arch/x86/kvm/svm/svm.c     | 65 +++++++++++++++++++-
>>>   4 files changed, 87 insertions(+), 45 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>>> index cb1ee53ad3b1..665515c7edae 100644
>>> --- a/arch/x86/include/asm/svm.h
>>> +++ b/arch/x86/include/asm/svm.h
>>> @@ -278,6 +278,7 @@ enum avic_ipi_failure_cause {
>>>   #define AVIC_HPA_MASK    ~((0xFFFULL << 52) | 0xFFF)
>>>   #define VMCB_AVIC_APIC_BAR_MASK        0xFFFFFFFFFF000ULL
>>> +#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>>>   struct vmcb_seg {
>>>       u16 selector;
>>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>>> index 4826e6cc611b..653fd09929df 100644
>>> --- a/arch/x86/kvm/svm/svm.h
>>> +++ b/arch/x86/kvm/svm/svm.h
>>> @@ -389,48 +389,6 @@ static inline bool vmcb12_is_intercept(struct 
>>> vmcb_ctrl_area_cached *control, u3
>>>       return test_bit(bit, (unsigned long *)&control->intercepts);
>>>   }
>>> -static inline void set_dr_intercepts(struct vcpu_svm *svm)
>>> -{
>>> -    struct vmcb *vmcb = svm->vmcb01.ptr;
>>> -
>>> -    if (!sev_es_guest(svm->vcpu.kvm)) {
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>>> -    }
>>> -
>>> -    vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>>> -    vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>>> -
>>> -    recalc_intercepts(svm);
>>> -}
>>> -
>>> -static inline void clr_dr_intercepts(struct vcpu_svm *svm)
>>> -{
>>> -    struct vmcb *vmcb = svm->vmcb01.ptr;
>>> -
>>> -    vmcb->control.intercepts[INTERCEPT_DR] = 0;
>>> -
>>> -    /* DR7 access must remain intercepted for an SEV-ES guest */
>>> -    if (sev_es_guest(svm->vcpu.kvm)) {
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>>> -    }
>>> -
>>> -    recalc_intercepts(svm);
>>> -}
>>> -
>>>   static inline void set_exception_intercept(struct vcpu_svm *svm, 
>>> u32 bit)
>>>   {
>>>       struct vmcb *vmcb = svm->vmcb01.ptr;
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 86d6897f4806..af775410c5eb 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -21,6 +21,7 @@
>>>   #include <asm/pkru.h>
>>>   #include <asm/trapnr.h>
>>>   #include <asm/fpu/xcr.h>
>>> +#include <asm/debugreg.h>
>>>   #include "mmu.h"
>>>   #include "x86.h"
>>> @@ -52,9 +53,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
>>>   /* enable/disable SEV-ES support */
>>>   static bool sev_es_enabled = true;
>>>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>>> +
>>> +/* enable/disable SEV-ES DebugSwap support */
>>> +static bool sev_es_debug_swap_enabled = true;
>>> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
>>>   #else
>>>   #define sev_enabled false
>>>   #define sev_es_enabled false
>>> +#define sev_es_debug_swap false
>>>   #endif /* CONFIG_KVM_AMD_SEV */
>>>   static u8 sev_enc_bit;
>>> @@ -2249,6 +2255,8 @@ void __init sev_hardware_setup(void)
>>>   out:
>>>       sev_enabled = sev_supported;
>>>       sev_es_enabled = sev_es_supported;
>>> +    if (!sev_es_enabled || 
>>> !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>>> +        sev_es_debug_swap_enabled = false;
>>>   #endif
>>>   }
>>> @@ -2940,6 +2948,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int 
>>> size, unsigned int port, int in)
>>>   static void sev_es_init_vmcb(struct vcpu_svm *svm)
>>>   {
>>>       struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +    struct sev_es_save_area *save = svm->sev_es.vmsa;
>>>       svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
>>>       svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
>>> @@ -2988,6 +2997,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>>>           if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
>>>               svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>>>       }
>>> +
>>> +    if (sev_es_debug_swap_enabled)
>>> +        save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>>>   }
>>>   void sev_init_vmcb(struct vcpu_svm *svm)
>>> @@ -3027,6 +3039,18 @@ void sev_es_prepare_switch_to_guest(struct 
>>> sev_es_save_area *hostsa)
>>>       /* MSR_IA32_XSS is restored on VMEXIT, save the currnet host 
>>> value */
>>>       hostsa->xss = host_xss;
>>> +
>>> +    /* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
>>> +    if (sev_es_debug_swap_enabled) {
>>> +        hostsa->dr0 = native_get_debugreg(0);
>>> +        hostsa->dr1 = native_get_debugreg(1);
>>> +        hostsa->dr2 = native_get_debugreg(2);
>>> +        hostsa->dr3 = native_get_debugreg(3);
>>> +        hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
>>> +        hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
>>> +        hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
>>> +        hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
>>> +    }
>>>   }
>>>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 60c7c880266b..f8e222bee22a 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -671,6 +671,65 @@ static int svm_cpu_init(int cpu)
>>>   }
>>> +static void set_dr_intercepts(struct vcpu_svm *svm)
>>> +{
>>> +    struct vmcb *vmcb = svm->vmcb01.ptr;
>>> +    bool intercept;
>>> +
>>> +    if (!sev_es_guest(svm->vcpu.kvm)) {
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>>> +    }
>>> +
>>> +    if (sev_es_guest(svm->vcpu.kvm)) {
>>> +        struct sev_es_save_area *save = svm->sev_es.vmsa;
>>> +
>>> +        intercept = !(save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP);
>>> +    } else {
>>> +        intercept = true;
>>> +    }
>>> +
>>> +    if (intercept) {
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>>> +        set_exception_intercept(svm, DB_VECTOR);
>>> +    }
>>> +
>>> +    recalc_intercepts(svm);
>>> +}
>>> +
>>> +static void clr_dr_intercepts(struct vcpu_svm *svm)
>>> +{
>>> +    struct vmcb *vmcb = svm->vmcb01.ptr;
>>> +    struct sev_es_save_area *save = svm->sev_es.vmsa;
>>> +
>>> +    vmcb->control.intercepts[INTERCEPT_DR] = 0;
>>> +
>>> +    /*
>>> +     * DR7 access must remain intercepted for an SEV-ES guest unless 
>>> DebugSwap
>>> +     * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM 
>>> writing to DR7
>>> +     * from the #DB handler may trigger infinite loop of #DB's.
>>> +     */
>>> +    if (sev_es_guest(svm->vcpu.kvm) && (save->sev_features & 
>>> SVM_SEV_FEAT_DEBUG_SWAP)) {
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>>> +    }
>>> +
>>> +    recalc_intercepts(svm);
>>> +}
>>> +
>>>   static int direct_access_msr_slot(u32 msr)
>>>   {
>>>       u32 i;
>>> @@ -1184,13 +1243,11 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>>       if (!kvm_vcpu_apicv_active(vcpu))
>>>           svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
>>> -    set_dr_intercepts(svm);
>>> -
>>>       set_exception_intercept(svm, PF_VECTOR);
>>>       set_exception_intercept(svm, UD_VECTOR);
>>>       set_exception_intercept(svm, MC_VECTOR);
>>>       set_exception_intercept(svm, AC_VECTOR);
>>> -    set_exception_intercept(svm, DB_VECTOR);
>>> +
>>>       /*
>>>        * Guest access to VMware backdoor ports could legitimately
>>>        * trigger #GP because of TSS I/O permission bitmap.
>>> @@ -1308,6 +1365,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>>       if (sev_guest(vcpu->kvm))
>>>           sev_init_vmcb(svm);
>>> +    set_dr_intercepts(svm);
>>> +
>>>       svm_hv_init_vmcb(vmcb);
>>>       init_vmcb_after_set_cpuid(vcpu);
>>
> 

-- 
Alexey
