Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3176D1EE
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 17:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbjHBP2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 11:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbjHBP2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 11:28:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC862D4B;
        Wed,  2 Aug 2023 08:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwSZDI8DLGI315+9xcAOXuMX4eVaSCZPMbyxNF1NTR9A4Y/ilu4Z5KA9g1rUsk/sTZP55z5AtcUobRCQiOEoqO4vgTW23nQadFh/jktw74plyx/oUIgOVYQ0PWc3YyicBPouDNyXfTFJd1Ls6LYxuAP/xmk55kTT/NMEMSvRJQtGGiw47YWQ/559nFsm/7lrFY3C8x5t6Lw3FIbjD07tbpN0YkRuTJ1QWFcT5CLUi4I9jxMGY0kLl8+oNnN9YDMWZdXbcoNWWX71YG6To4Aifj0ULCIFjqybfW0WMRvqY0rWyZy5+ywWRgUL3V1TzHlmEpfY3AbIk+Ct2T6bI+/McQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMVBrZanA6JpkwcClezVZMULxvxMVmUCcDrPdvrsdiw=;
 b=PaG/8sm12zSDCMGPm56FNvOTNFwcFFO12ASQqWVV4aPkbbzACrlDSRoiUXI7d8ZqJBrGI7KlwVDzW8AqrOxDj82OkekYwSmcNK19dxxMJZnKiYozhh91jBuQbfuZOTLKiKncoKW0B1G1cBkSuvjiEnpQLurSn7J8+nSXyvVpgQLSluU4d8j7AEynl+CfA1CElUgMSNtftJ52Vg+8kVHD6KM4d1RMSelBlg1JJDQqYNbytNochjI3C+aBD9Uzg/I73v/tzOLxQghCIkvIzFju4s0i9knFRXBpc/UecpxUdKuW0BBI9GEUuB7j2DlE2LA7sW1GXQHLYEGrgyxidSjQJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMVBrZanA6JpkwcClezVZMULxvxMVmUCcDrPdvrsdiw=;
 b=wQnAEgcjoWmNUz00YddkF67tBYWUAsCxgkK6iosEqsjTqu3mUWtt3h+H8JhdyxQoFz31kgYDSDtz5ukR2dpOo0NLMeKXlz5QkFdIgJ7BHXMZRCaJIgfRc845P3emzsE54RdK0wRMfFkTpsxgpdemJjx0TAoAywSCxP5OXZUwk0o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BL3PR12MB6377.namprd12.prod.outlook.com (2603:10b6:208:3b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 15:26:33 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 15:26:33 +0000
Message-ID: <7b4d5df0-f554-2fc0-5c19-021f8eb3f6aa@amd.com>
Date:   Wed, 2 Aug 2023 10:26:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
 <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ> <ZMphvF+0H9wHQr5B@google.com>
 <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
 <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com> <ZMpwiSw9CBZh9xcc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZMpwiSw9CBZh9xcc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0113.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::27) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BL3PR12MB6377:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c53dc0e-2675-400d-aeff-08db936cda88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpUCluH0b7lB3uLhS+CzFPUcbu7Phqy+7mGpZzBIt7kPgFlBwtNcL+8A648PPqzSjV2Eil9u84L/o86q8Zcu1zNlSiKAyhGYKrEHx5VbN3ha6i4ye4QXbgPe+tFqbY47xunaNUIirnsZSSGcM4REwCTMZyiZqVChhCueqlJ1T1kBAth9umubYcroartB7vads6ba+MVCpR35Cguq+xw1ADZm0/45+0eKx+SK9QLDON0lhiRgwKb76Xi8OLUTx6H500/lAF9GekCILm0fIU++CxjW0hzVqS7JFSKly4PSJyLkdm47I/PRLMG6F6b7PmqbjGEik32SoYkohdM8ShOfYRq1G5fjfUn3lr9Ml9HuqUXmBhLozfAZK3gBVVhQ/4HXTbFeRuxVDTyUrRgj5oN4nkHb2KcVF+cHPP42Hon0TjYAI39SpXHY5wk3plH4BNPI5YqyAzzpXEanc9lBzg3IFRVgNuXCumdR1gjuDZ3qrUY+kUrMibbk4AG482wMl5+pitJGlae/XKC/EG/T2vRSgx/q6A7Ml04be514WXmp3RcI16SlEyJu2pJI8qXs7mtduTMxh0MfUY4tOWEPH9VfQziAVoIOEhFDTTVHgAd5oEXxp7EdpmtFaDu50Mq3rFux+6e25OipVCxItFcoKCFAEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(478600001)(86362001)(31696002)(6512007)(36756003)(6486002)(316002)(8676002)(8936002)(41300700001)(5660300002)(31686004)(6916009)(4326008)(66556008)(66476007)(83380400001)(2906002)(38100700002)(66946007)(26005)(2616005)(186003)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0s0Z0NVZXo1VTA0REk5NFRLaUhNQXF4WlVXaDl5b0JNbGVHL1h1QzEyZlE5?=
 =?utf-8?B?bGZjVmhweVJVQlJ6Q3VLOGJjRmNEVU8rd3pWNE8zL2ZHVitWMTY3R0FMc0tu?=
 =?utf-8?B?NUYwRC9hcU9uRzA5czQ5bkJNbGFNYWZFWWV0a0htb0JLMXljVGsvS1J1aVU1?=
 =?utf-8?B?b0hmaTMwdEYvQ2ZqOUY4d0dOSVZKdVhmc2d4cUlVTUF5UHFxL0dtcGtCR0NU?=
 =?utf-8?B?MWdZTVZTZmJJWm1IR2ZmMjF3LzdBanQxSXR4L1FnTUtZdFVUNlR0UFNpWUVM?=
 =?utf-8?B?eUdRNGd4RXpZUndSREQ4OFJhVGtKblJDb2VyMkpSK0xzdTEwVDFOK1BuanhB?=
 =?utf-8?B?czhrVUg0bFRFWVk3a05vcGNxQjhqdndRZWdDc2ZZd040NlBMNENkNk5VVlpj?=
 =?utf-8?B?THFzV3B6bnEzbEdXSWdvbTRtQ0JxNlBzRE5nQnZMbS9yRTFDUTI4QWZOVFdi?=
 =?utf-8?B?cndJSjY3bVdLajhOWTYvcGFIbit4ajFkcnVOUGJSMnFFbUViS0NnK1dNWlh1?=
 =?utf-8?B?VlJ4THI0TEN0djhMdWJCY1BMOWFrK0E4YkpRNjQ4N1Y3ekJ0UXhtUkwyMTVO?=
 =?utf-8?B?QnVJemZWY3ZINnRWM3J2VnkxOEtaSWN3NTZyZ0RYaUFraUVRQytUa3dsSUtR?=
 =?utf-8?B?ZkV6WkRCVVJ3ZHhMeklkcTBQM1FhUndlbzkyUllTREcyMHg5bXcxSHhwYzhJ?=
 =?utf-8?B?MURhQ0VMTDlQR0NlRnl6eko2MkQ3UERoWUVmU2JXcGM3WVhmdEVDYzF5cUc0?=
 =?utf-8?B?VzZQcGxDQmlsN0kyTGNLQW5mUkRTTmdobDlrZGgwd0JzbW9YZmFFS0NONGRR?=
 =?utf-8?B?OVVIWmpEM0tOT0JmeWhmNXJsd0xrcSs0d1RGNU01cnhVMzY0Zmh2NGJOdVhw?=
 =?utf-8?B?dXA3ZDFPSnE3a1FwUG5HeW5CemlzWlVaOGFmNEJoV2JtN25VK1JnM0M3Y3FP?=
 =?utf-8?B?Ujl1ckhNQkxlblV6Q3Q0QTIzT1JBUVQzMElBWFdsQVk3UDdxRDBnY1Arcm9P?=
 =?utf-8?B?MGlJbjBENUlTMDdEcEQyVWg5TnBWMjNDeWtJVG4rSFo2RmtWQkhhekI2QjlR?=
 =?utf-8?B?TXE3bmNBaU5rUnIxVHlhV1dPVWpHcEg3K0c2VmI5UWdtVFpoWi96dURJb01u?=
 =?utf-8?B?LzBHa2VZR09abncvZ25FaktxVHVDbFpITkhyQnF4SzZvVkVXakhINkZGNnFB?=
 =?utf-8?B?Z1MwTzBmbnpEb2IvVG9RQTcvOUdjUU1iYk1senJNUjBQTUsrcnk3cERQN3lh?=
 =?utf-8?B?VUpYS2E2RjlldlhtdHhXTUZqeFI5b3R3VEdrZUR2T1Vieno3WElkSVdRd3NH?=
 =?utf-8?B?MUthbm1PcEh5TGRGbmovODZoRXZQZkgzcEw4V0NFVWxiejdCaW8wZVhWVkFw?=
 =?utf-8?B?b1BiYVJuTzlkN1daSkpKOXpnUFk0c2ZBWWp6ckI0a25SaVhvcmQxRmpPTGVW?=
 =?utf-8?B?UGVPY2JueS9mMlhXdU51RHAxend6Mncyc05FQlhQaWVoVjZKbGpadUk0MHA4?=
 =?utf-8?B?OFNmTi9jVVRUdEVwS3AwVEU2WTZxVzBaM1d6a0Q5V0gvUE95NFdhQXhLR3dx?=
 =?utf-8?B?NzBvVjROSnBPTng2ejZtb0pLY2U3dHVwdUZ4dEFRZ1IxcVR0cFVBNGx6N1pT?=
 =?utf-8?B?Nkwwdy9udWRidnQ1aWtHV09LNEFadVZjcHNkMVN0RWE5ZnJ6UDhFNmVlU1ox?=
 =?utf-8?B?SEpGazY1cThaMlMxalZoaThkakVQb2YrV3E4V0xIbkdvbjkwNjZTYS9JWTZl?=
 =?utf-8?B?Rm1paEMzMytRREdMZmR5UFhVVWZCeEQzTkphOFp5TWtVSHNIb2dzNlkvbk9B?=
 =?utf-8?B?dG8yUkVoMmRyaGx4dWVWQVhlOUgyeDVZRWhyejlDSFJKbHU3WDlwZEh2cVg0?=
 =?utf-8?B?ekpXc2x3TG5mbjBQMVZqVkM3Y091Z05QaEdMSTA4MDJZWnpYNCtCV1E5bzQx?=
 =?utf-8?B?NVh5dHNHcm5qMjV4RDlaWHQwR3YxdjJyZW5DZjNqYzNxSnVsb3RMa25sQ1V4?=
 =?utf-8?B?em5rczdBUWMyOVBON3l4ZTBGTVo0MSswbVkvR2dPTzFReDI2Mk0rbW5lSU9T?=
 =?utf-8?B?RW9NaVVRSytQSGV4cVhITC92WVMvQjhRT1hDN2JRbng5RU96VjlxM1NVSEtF?=
 =?utf-8?Q?TDr3LsJ93p0zHw7njFegrHk+V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c53dc0e-2675-400d-aeff-08db936cda88
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 15:26:33.6462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L3yh+FLEZHb1bFbB7iqcBOTRrg1aacAy0ax+vpHZyGW+zEBr6MRt6iaCzkXMc15c9ZiAdkdul8PwI6nmKUftRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6377
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/23 10:04, Sean Christopherson wrote:
> On Wed, Aug 02, 2023, Tom Lendacky wrote:
>> On 8/2/23 09:25, Tom Lendacky wrote:
>>> On 8/2/23 09:01, Sean Christopherson wrote:
>>>>> You're right. The #UD is injected by KVM.
>>>>>
>>>>> The path I found is:
>>>>>       svm_vcpu_run
>>>>>           svm_complete_interrupts
>>>>>          kvm_requeue_exception // vector = 3
>>>>>              kvm_make_request
>>>>>
>>>>>       vcpu_enter_guest
>>>>>           kvm_check_and_inject_events
>>>>>          svm_inject_exception
>>>>>              svm_update_soft_interrupt_rip
>>>>>              __svm_skip_emulated_instruction
>>>>>                  x86_emulate_instruction
>>>>>                  svm_can_emulate_instruction
>>>>>                      kvm_queue_exception(vcpu, UD_VECTOR)
>>>>>
>>>>> Does this mean a #PF intercept occur when the guest try to deliver a
>>>>> #BP through the IDT? But why?
>>>>
>>>> I doubt it's a #PF.  A #NPF is much more likely, though it could be
>>>> something
>>>> else entirely, but I'm pretty sure that would require bugs in both
>>>> the host and
>>>> guest.
>>>>
>>>> What is the last exit recorded by trace_kvm_exit() before the #UD is
>>>> injected?
>>>
>>> I'm guessing it was a #NPF, too. Could it be related to the changes that
>>> went in around svm_update_soft_interrupt_rip()?
>>>
>>> 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the
>>> instruction")
>>
>> Sorry, that should have been:
>>
>> 7e5b5ef8dca3 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")
>>
>>>
>>> Before this the !nrips check would prevent the call into
>>> svm_skip_emulated_instruction(). But now, there is a call to:
>>>
>>>     svm_update_soft_interrupt_rip()
>>>       __svm_skip_emulated_instruction()
>>>         kvm_emulate_instruction()
>>>           x86_emulate_instruction() (passed a NULL insn pointer)
>>>             kvm_can_emulate_insn() (passed a NULL insn pointer)
>>>               svm_can_emulate_instruction() (passed NULL insn pointer)
>>>
>>> Because it is an SEV guest, it ends up in the "if (unlikely(!insn))" path
>>> and injects the #UD.
> 
> Yeah, my money is on that too.  I believe this is the least awful solution:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d381ad424554..2eace114a934 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -385,6 +385,9 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>          }
>   
>          if (!svm->next_rip) {
> +               if (sev_guest(vcpu->kvm))
> +                       return 0;
> +
>                  if (unlikely(!commit_side_effects))
>                          old_rflags = svm->vmcb->save.rflags;
>   
> I'll send a formal patch (with a comment) if that solves the problem.
> 
> 
> Side topic, KVM should require nrips for SEV and beyond, I don't see how SEV can
> possibly work if KVM doesn't utilize nrips.  E.g. this
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2eace114a934..43e500503d48 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5111,9 +5111,11 @@ static __init int svm_hardware_setup(void)
>   
>          svm_adjust_mmio_mask();
>   
> +       nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
> +
>          /*
>           * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
> -        * may be modified by svm_adjust_mmio_mask()).
> +        * may be modified by svm_adjust_mmio_mask()), as well as nrips.
>           */
>          sev_hardware_setup();

You moved the setting of nrips up, I'm assuming you then want to add a 
check in sev_hardware_setup() for nrips?

Thanks,
Tom

>   
> @@ -5125,11 +5127,6 @@ static __init int svm_hardware_setup(void)
>                          goto err;
>          }
>   
> -       if (nrips) {
> -               if (!boot_cpu_has(X86_FEATURE_NRIPS))
> -                       nrips = false;
> -       }
> -
>          enable_apicv = avic = avic && avic_hardware_setup();
>   
>          if (!enable_apicv) {
> 
