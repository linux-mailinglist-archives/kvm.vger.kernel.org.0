Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B37C6B8EEE
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 10:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjCNJnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 05:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCNJnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 05:43:49 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E511BAC6;
        Tue, 14 Mar 2023 02:43:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeOcQj8tC73x9HVegdQ2YqY78lfdjoSVexgFu66tLKH/LcL08XGZYM+TGe6c0WhJbPFj/dvF2zg+t0F9ky0ZC2+Aq7KCzOSMSflaQv9jABX1QesIKMLUaGroxS8M9eVRt7u9mAgAm9IXLybKURtkKCK81c5Y6Mw/e9wh/3Su8j3250H3XmsMaXPW8kCaztRl6Chk7tCjFlQcTH1dT/m42PutuMVOFvry7x3Ma8dnbsUvtd1mMt4K6qZ70dfJ7sr8pcIiifDjG1rYEhlPm4GotlQEAGn1OfRXDYi2KLAkG/Y3hUlv96Sy7xkpHwk1u0wtz/Ffguktp2N3/a8hJTFKNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnUHUbkYGC8mnmStzy0fqcFQIvkVcyGTM2nnS9L2NbQ=;
 b=H1wXG4Wgm5QLpYmwho4oISi3pinrqWWb/vb22l4s0zmZ2+z5svXh75yUr15yO4FhihKgFiVBEui4EJpSs0QrhVvlhpJHNKcjf6FJFYKI6oige2n5b4dnQnpK+wBE8A37aVx59hWwcmk5RAdV41he1v6juRDEgR9ZdAzfm2SAem6bIAwJ5MXczCOPpSY33dM8OrffT1u/IeAVXe+TEeDStQrC4qDTcjzK2NMbPeXQZoJd1Mv7fVA8AAabWnEWcQDaGgnqpu7/cOSsm60soR92Q4UgiPd234cgIZ52JdXLIQXbKbansDN5g7oNOoHmoFgtYfc+vbB6+nPUE5r986sfyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnUHUbkYGC8mnmStzy0fqcFQIvkVcyGTM2nnS9L2NbQ=;
 b=nrzMHdEFaUJfFDz+cZJVatKoCEiASK+f36EMUg5lDXDruA1xBtiKh8U7bHGaufLaA2AncVQrqP00gnaAI2bSPEoZVwoTxgHlvIvJrIa/Og09qoZvEmFcZyvQpmaZPbvN/Qza069vm4ZA1vuBu+8OgqtMXdyYw5s03i8qiK1WJW8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SA1PR12MB6869.namprd12.prod.outlook.com (2603:10b6:806:25d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Tue, 14 Mar 2023 09:43:42 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 09:43:42 +0000
Message-ID: <318a4c2f-67df-f0ff-c945-327c2e92f9d8@amd.com>
Date:   Tue, 14 Mar 2023 20:43:32 +1100
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
In-Reply-To: <95c83ff6-0dee-d81d-6a3c-12de24cbbf32@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYCPR01CA0034.ausprd01.prod.outlook.com
 (2603:10c6:10:e::22) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SA1PR12MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ed2430d-3413-4cf9-5dbe-08db247098a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcMM9RUrlfbD2YsmWS7V2TjmpFalcdTV+eTL43ZRlMFsTEUGYXwD5dElsgpU0Kr890bcO9u7CJc/X6/IVCrd0N7+Bb9g1qRN2TbdbUDDov5+fVxDOMS2I/ZDmPwhsVpJtSMfrO1sM8JQS0ODSqBwVfy3lyJZFJbSOfagFY7ISml5+XGH2Po2EMt0ASqNefZ2LLjLu8SkUox8bwTFhr84l1MHGXRu6x45A/64v5JsiPe8HkYos5u1CosMFQkO0528Zke/EhbMolK2jrdjFeY6ExQ4sOjyUa5b78ssYL5RucIYkYvG8u6rYrqoGhYBZE6q8SdGopwCpWP8oqOOhW8rLSIuZYzYhrvhSGGIqi6EL6txth+p8D095Ed67XVU+Df9x5DJ75lzelW4TFR7kePJdqt0eCk+oHHVKvYA+81PxlV5tib8a9RSLVmBChgqXd5OB9SqdN/MSnf5j0xaiDbofUWTLjrVck7pXb0gDh7uUXHid5bCEPDgl5pttMlNoEeaPX3d+m99gostQxbTIb8MpOHUhm3oGnOCH35KURxwg7tKgRGujfMO8bSBel775dyXyL1pX+puG8eKwl4MbRMd4PiffX2BkISr31m3wsUv4rGYUtruNUnlgc347vUEKN6OepZvjePd4hV8sZeRIwDBR3xCoR+z3c6Pad+QvayVS3+irMVEzhQV1aDlGwjXXX5tiuphKlfYXbtUQVfLJrkhbd3znmmpFxPf4dThamjBcUpMkLZ0Y/JbRdfEAPRYl+h9IYR9nMf2XbW6xzzSphtOKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199018)(31696002)(36756003)(38100700002)(110136005)(8676002)(4326008)(66946007)(66476007)(66556008)(8936002)(41300700001)(54906003)(478600001)(316002)(6506007)(7416002)(5660300002)(2906002)(30864003)(2616005)(83380400001)(6666004)(186003)(53546011)(26005)(6512007)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHBJZ3F2TVNoREZCR2dXcXVtL21hOVpiZkk3V2lJUjh2VjVyengwMGZNUUdC?=
 =?utf-8?B?ZlF6dlQzRzRjeEh4OUNhWHltL08wV25XZUlyVS9aMmRTRDJISTM2VFhMYnF4?=
 =?utf-8?B?M01Xekk1SjBUTUN3VXYyRnowUjUxbzcvYlhrWTBON09UemFWMXlQK2IxTHNR?=
 =?utf-8?B?TGxoWkROdEJObG5aUkhFdGk1SjFsR2s5aGMrYTZqWW9QL0Vwa2djVDNoWWFw?=
 =?utf-8?B?elg4dFNCWFZEOXAvRGRHZmo2UEhkZGVROVdJU2xFZXV1TnNNdmVVV3FuUG1o?=
 =?utf-8?B?Y3ZLM1hCbk5nU2RmT1FLMzRwS0tzcGlEbm9Qak1vYXJCWnVYd1p4TEVORDl0?=
 =?utf-8?B?M0t5VmlhUGdMSTgrY09yQ1ZjNklpT2ljS2c0NlZmVFVrK1JXMXdzVTFGcEhw?=
 =?utf-8?B?cG12VzIwd1F3bHE1eG1WWllIVmVkNFNtQmNmOXF1RFdHc2JEK3hWSzBlTUMw?=
 =?utf-8?B?N1R2OG5MUXV0Zi8vV1hQMDk2Q1h4aXZzOTJlY203NW4yUHYzQjl3NFlXb0xp?=
 =?utf-8?B?bzZDaFV5NUNEZUpPaFJXdlEvTDdmMnhiZm44ck8xV2xMQm1XSVhQTHRCT0d0?=
 =?utf-8?B?ZENsL3oyWVVpTDBMMmtwUDN2L1dWNXh5dUZlV0taRHpjcDN0LzRDZE1KbXo0?=
 =?utf-8?B?SmZPM1BHWVFCNVRGRCtCYjNnbDBBV054Zm0xaTRaangxWnUzdEhrNEFzUFNO?=
 =?utf-8?B?eGc5b01ZdFNTdmFWM3NVaE00WnRuWis1N2NDbERlbFBObENTTEFGTzNvTmlS?=
 =?utf-8?B?d2JjT0p5ZzliUWlNT1o5V1NkaXBqMUdMcW9JUTZTNEFQak9kRFpkVHl1azl5?=
 =?utf-8?B?Zk5Zc0Z4ZVVNdTZDTDMzb3JoNmdKNkpxOG9Rd3M1NkNvL1NHc3V4eUxhN3ln?=
 =?utf-8?B?Z09UU2k1Q240R3A5MEduUVk3QndjVUlVZ1ZLRGlJa3hJaGY0aDNEak1iODQz?=
 =?utf-8?B?NTJlZDM4ZEY5S08rdTFXUHZYZHA2SVJNdXM0bHZhSVEvKzJvRGFLc3VKeHoz?=
 =?utf-8?B?QURQd0tsSmtPSU1SKzArbDVTMXVXN1hDaXBjbTlZTGp3UjNJZE9hWWNnekY4?=
 =?utf-8?B?ZmY3aWlyL1JVaHY0aDlRN1laK0lvd3ltZ0tsMWVEclVHSzZEUmRRM2FQb2Jy?=
 =?utf-8?B?cnNmbm1wMGo3THVlcWJ0dlpYZlRNZ2g3aDZINlM4WS96czNVQVZnbFR1MURz?=
 =?utf-8?B?TW96Vk5QUWErU1FoRkdlaWV0Z1c4RjZmc05FNTRIdmpOR3JsYkhYWWNzUTFr?=
 =?utf-8?B?VkRKZjh3TUd0eFVwUXVLcHg1ckJaVjZKelRsaGdnaldjcldReERVemM5enA3?=
 =?utf-8?B?eWlCalhVNG9GaWJHTlR2NlZBYTZYWHJuWjlsWW9weXRkZG9aVWRYSGRyWlk2?=
 =?utf-8?B?RzU3dUZzYkxFT2lVdWhXcFhlZ3VjR00xb3AwWWxlaEFxejVnNW5OUS82NjZS?=
 =?utf-8?B?NWxvczBXYVpicXFwcmJUMTlwY3E0blB1cmZMNXhSZmVxZ0VuQkNSajBFMTdT?=
 =?utf-8?B?azlWRk80MTFNS0ZWNm51QjhuYUJFOTEvL3psOW1ieTJrdko5d3JuM3hOSXNn?=
 =?utf-8?B?ZHhPT20vYWJvT2FBaDdvcFpJNGY3MW0wa2RwN05CYzQweERoTDJQZ0VtdkxB?=
 =?utf-8?B?UUJkdHNXRW16aFRmUGppNVVyVW10UU80Q21VWEZGcWQ0TEpRd05PWGxaL2pY?=
 =?utf-8?B?RUdocEpSTy85ZW5CdGx1YjJxSnRpY0J1N0FjcEpvOC9uUllkMC9yTnVYQWsy?=
 =?utf-8?B?VHNIem1VU0VPOSs4OTM1Zk5rb24vd1Urb1NVaytBNmdmODJhalJiS3ExdWtv?=
 =?utf-8?B?U1VLN3ZJbGtwaVQzWU83UnRMcEFrVU8vNUFqdEhMT2VqRSswQXJMK0JNanFR?=
 =?utf-8?B?ZlVsSHNyTnhYVTF5RjhURTRQSm5QNU4xdzgrUFZHeHNqY3FjQkdlZ002Q2Zn?=
 =?utf-8?B?d0pNOVgyVDZkbzc3NEsxU2RVY2FBLzY3bjgyNzJ3OHVuVk9qd3RpUU1jOCsz?=
 =?utf-8?B?V1RrMFE5YUF2YURtVWtuZGpmTUxnRFpuL2RMS1ZPSW96SDZxYWxBUHFHbi9x?=
 =?utf-8?B?MHQzUVdyVjIycHVrb201RXUvQ0JCdXVIcW5QNENFYm83RDFYeHNZMEtlQVdZ?=
 =?utf-8?Q?R0wWw86efCl6yxhFs5JG2Xt55?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed2430d-3413-4cf9-5dbe-08db247098a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:43:42.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klK7zo/vnJwywNAt/9vJYA/iTccbE0DM3yPXpeo3k1W7B6sMjtobjVc4GlIbQGLBxtSS6lMaMIddgO3RXpYUow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6869
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping? Thanks,


On 21/2/23 16:19, Alexey Kardashevskiy wrote:
> Ping? Thanks,
> 
> On 3/2/23 16:14, Alexey Kardashevskiy wrote:
>> Prior to SEV-ES, KVM stored/loaded host debug registers upon switching
>> to/from a VM. Changing those registers inside a running SEV VM
>> triggered #VC exit to KVM.
>>
>> SEV-ES added the encrypted state (ES) which uses an encrypted guest page
>> for the VM state (VMSA). The hardware saves/restores certain registers on
>> VMRUN/VMEXIT according to a swap type (A, B, C), see
>> "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
>> volume 2.
>>
>> AMD Milan (Fam 19h) introduces support for the debug registers swapping.
>> DR6 and DR7 are always swapped. DR[0-3] and DR[0-3]_ADDR_MASK are swapped
>> a type B when SEV_FEATURES[5] ("DebugSwap") is set.
>>
>> Enable DebugSwap in VMSA. But only do so if CPUID Fn80000021_EAX[0]
>> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
>> supported by the SOC as otherwise a malicious SEV-ES guest can set up
>> data breakpoints on the #VC IDT entry/stack and cause an infinite loop.
>>
>> Eliminate DR7 and #DB intercepts as:
>> - they are not needed when DebugSwap is supported;
>> - #VC for these intercepts is most likely not supported anyway and
>> kills the VM.
>> Keep DR7 intercepted unless DebugSwap enabled to prevent the infinite #DB
>> loop DoS.
>>
>> While at this, move set_/clr_dr_intercepts to .c and move #DB intercept
>> next to DR7 intercept.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>> Changes:
>> v4:
>> * removed sev_es_is_debug_swap_enabled() helper
>> * made sev_es_debug_swap_enabled (module param) static
>> * set sev_feature early in sev_es_init_vmcb() and made intercepts
>>    dependend on it vs. module param
>> * move set_/clr_dr_intercepts to .c
>>
>> v3:
>> * rewrote the commit log again
>> * rebased on tip/master to use recently defined 
>> X86_FEATURE_NO_NESTED_DATA_BP
>> * s/boot_cpu_has/cpu_feature_enabled/
>>
>> v2:
>> * debug_swap moved from vcpu to module_param
>> * rewrote commit log
>>
>> ---
>> Tested with:
>> ===
>> int x;
>> int main(int argc, char *argv[])
>> {
>>          x = 1;
>>          return 0;
>> }
>> ===
>> gcc -g a.c
>> rsync a.out ruby-954vm:~/
>> ssh -t ruby-954vm 'gdb -ex "file a.out" -ex "watch x" -ex r'
>>
>> where ruby-954vm is a VM.
>>
>> With "/sys/module/kvm_amd/parameters/debug_swap = 0", gdb does not stop
>> on the watchpoint, with "= 1" - gdb does.
>> ---
>>   arch/x86/include/asm/svm.h |  1 +
>>   arch/x86/kvm/svm/svm.h     | 42 -------------
>>   arch/x86/kvm/svm/sev.c     | 24 ++++++++
>>   arch/x86/kvm/svm/svm.c     | 65 +++++++++++++++++++-
>>   4 files changed, 87 insertions(+), 45 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index cb1ee53ad3b1..665515c7edae 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -278,6 +278,7 @@ enum avic_ipi_failure_cause {
>>   #define AVIC_HPA_MASK    ~((0xFFFULL << 52) | 0xFFF)
>>   #define VMCB_AVIC_APIC_BAR_MASK        0xFFFFFFFFFF000ULL
>> +#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>>   struct vmcb_seg {
>>       u16 selector;
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 4826e6cc611b..653fd09929df 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -389,48 +389,6 @@ static inline bool vmcb12_is_intercept(struct 
>> vmcb_ctrl_area_cached *control, u3
>>       return test_bit(bit, (unsigned long *)&control->intercepts);
>>   }
>> -static inline void set_dr_intercepts(struct vcpu_svm *svm)
>> -{
>> -    struct vmcb *vmcb = svm->vmcb01.ptr;
>> -
>> -    if (!sev_es_guest(svm->vcpu.kvm)) {
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>> -    }
>> -
>> -    vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> -    vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> -
>> -    recalc_intercepts(svm);
>> -}
>> -
>> -static inline void clr_dr_intercepts(struct vcpu_svm *svm)
>> -{
>> -    struct vmcb *vmcb = svm->vmcb01.ptr;
>> -
>> -    vmcb->control.intercepts[INTERCEPT_DR] = 0;
>> -
>> -    /* DR7 access must remain intercepted for an SEV-ES guest */
>> -    if (sev_es_guest(svm->vcpu.kvm)) {
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> -        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> -    }
>> -
>> -    recalc_intercepts(svm);
>> -}
>> -
>>   static inline void set_exception_intercept(struct vcpu_svm *svm, u32 
>> bit)
>>   {
>>       struct vmcb *vmcb = svm->vmcb01.ptr;
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 86d6897f4806..af775410c5eb 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -21,6 +21,7 @@
>>   #include <asm/pkru.h>
>>   #include <asm/trapnr.h>
>>   #include <asm/fpu/xcr.h>
>> +#include <asm/debugreg.h>
>>   #include "mmu.h"
>>   #include "x86.h"
>> @@ -52,9 +53,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
>>   /* enable/disable SEV-ES support */
>>   static bool sev_es_enabled = true;
>>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>> +
>> +/* enable/disable SEV-ES DebugSwap support */
>> +static bool sev_es_debug_swap_enabled = true;
>> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
>>   #else
>>   #define sev_enabled false
>>   #define sev_es_enabled false
>> +#define sev_es_debug_swap false
>>   #endif /* CONFIG_KVM_AMD_SEV */
>>   static u8 sev_enc_bit;
>> @@ -2249,6 +2255,8 @@ void __init sev_hardware_setup(void)
>>   out:
>>       sev_enabled = sev_supported;
>>       sev_es_enabled = sev_es_supported;
>> +    if (!sev_es_enabled || 
>> !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>> +        sev_es_debug_swap_enabled = false;
>>   #endif
>>   }
>> @@ -2940,6 +2948,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int 
>> size, unsigned int port, int in)
>>   static void sev_es_init_vmcb(struct vcpu_svm *svm)
>>   {
>>       struct kvm_vcpu *vcpu = &svm->vcpu;
>> +    struct sev_es_save_area *save = svm->sev_es.vmsa;
>>       svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
>>       svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
>> @@ -2988,6 +2997,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>>           if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
>>               svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>>       }
>> +
>> +    if (sev_es_debug_swap_enabled)
>> +        save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>>   }
>>   void sev_init_vmcb(struct vcpu_svm *svm)
>> @@ -3027,6 +3039,18 @@ void sev_es_prepare_switch_to_guest(struct 
>> sev_es_save_area *hostsa)
>>       /* MSR_IA32_XSS is restored on VMEXIT, save the currnet host 
>> value */
>>       hostsa->xss = host_xss;
>> +
>> +    /* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
>> +    if (sev_es_debug_swap_enabled) {
>> +        hostsa->dr0 = native_get_debugreg(0);
>> +        hostsa->dr1 = native_get_debugreg(1);
>> +        hostsa->dr2 = native_get_debugreg(2);
>> +        hostsa->dr3 = native_get_debugreg(3);
>> +        hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
>> +        hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
>> +        hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
>> +        hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
>> +    }
>>   }
>>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 60c7c880266b..f8e222bee22a 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -671,6 +671,65 @@ static int svm_cpu_init(int cpu)
>>   }
>> +static void set_dr_intercepts(struct vcpu_svm *svm)
>> +{
>> +    struct vmcb *vmcb = svm->vmcb01.ptr;
>> +    bool intercept;
>> +
>> +    if (!sev_es_guest(svm->vcpu.kvm)) {
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>> +    }
>> +
>> +    if (sev_es_guest(svm->vcpu.kvm)) {
>> +        struct sev_es_save_area *save = svm->sev_es.vmsa;
>> +
>> +        intercept = !(save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP);
>> +    } else {
>> +        intercept = true;
>> +    }
>> +
>> +    if (intercept) {
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> +        set_exception_intercept(svm, DB_VECTOR);
>> +    }
>> +
>> +    recalc_intercepts(svm);
>> +}
>> +
>> +static void clr_dr_intercepts(struct vcpu_svm *svm)
>> +{
>> +    struct vmcb *vmcb = svm->vmcb01.ptr;
>> +    struct sev_es_save_area *save = svm->sev_es.vmsa;
>> +
>> +    vmcb->control.intercepts[INTERCEPT_DR] = 0;
>> +
>> +    /*
>> +     * DR7 access must remain intercepted for an SEV-ES guest unless 
>> DebugSwap
>> +     * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM 
>> writing to DR7
>> +     * from the #DB handler may trigger infinite loop of #DB's.
>> +     */
>> +    if (sev_es_guest(svm->vcpu.kvm) && (save->sev_features & 
>> SVM_SEV_FEAT_DEBUG_SWAP)) {
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> +        vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> +    }
>> +
>> +    recalc_intercepts(svm);
>> +}
>> +
>>   static int direct_access_msr_slot(u32 msr)
>>   {
>>       u32 i;
>> @@ -1184,13 +1243,11 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>       if (!kvm_vcpu_apicv_active(vcpu))
>>           svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
>> -    set_dr_intercepts(svm);
>> -
>>       set_exception_intercept(svm, PF_VECTOR);
>>       set_exception_intercept(svm, UD_VECTOR);
>>       set_exception_intercept(svm, MC_VECTOR);
>>       set_exception_intercept(svm, AC_VECTOR);
>> -    set_exception_intercept(svm, DB_VECTOR);
>> +
>>       /*
>>        * Guest access to VMware backdoor ports could legitimately
>>        * trigger #GP because of TSS I/O permission bitmap.
>> @@ -1308,6 +1365,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>       if (sev_guest(vcpu->kvm))
>>           sev_init_vmcb(svm);
>> +    set_dr_intercepts(svm);
>> +
>>       svm_hv_init_vmcb(vmcb);
>>       init_vmcb_after_set_cpuid(vcpu);
> 

-- 
Alexey
