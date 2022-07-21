Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9441C57C7A5
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbiGUJb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiGUJbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:31:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE9B80528;
        Thu, 21 Jul 2022 02:31:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htV6wCz6vPOf8iCED7frvmZouJPJHysvxuUJwYCheufvK3J2pFfhzVYt5fjWAtjhlMrD92Sg9Mqt3r6BBxrSAnzKBMiX+jLdkpvfoZ0jxwAMGTIW+E3xX1OjsnCBvWBltpXJsQNfFxpDL1PwzRBYTg2CY7CVe4iVQe0wco6BeNzrXF+WJwBcifwRqTqu5V86NlucFCER9uCCi8SyQgmNiY7EHk2dBFkCv94gnOJPPBkTt6w/6xZC7wAyhTQ5PsPNqitqskoi6EtfXZGkGxP6rY6h13ept2tcfZNl3/I31vclFiOL/sUGD1DVn+V95kGN6KUny+4ppfEQoF51wObmBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Om0zh3sbvaSs9ipSD23tpEal96/8+GfFwQih/65FMY=;
 b=dhgNzDBveL9HRjxgh5isiYQ0fXHidYd3Okuq7G/cfbwwHxV7oWz1oBAGGj+b8+p0vbZo/VlXCy4ak3xBHiKGWjiLiNXI4vuncdLHYL0iQsiHKEsBSHi0WveEHyb/DMEH0EdXEmOBZw90cicF2S5sizCevZjmTYR1ff7dpwDERM7Z0HqNH0Sa+XSgJ1Divf02DjMu8lwiPwz+EouZ0xOGMRICCsVyfb3NskYoqPKazZ5eumlJXB5eSpE+7dih2XG71f0L1kdRnr5rUT/Fez0eyH77o7k63I58l8QWP6N8VoO+dHk03Fv43zhayN/2dOgRUIUUZHDFTtX2cI6rkTgxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Om0zh3sbvaSs9ipSD23tpEal96/8+GfFwQih/65FMY=;
 b=R1UZE4P8FMleUblKpHqideav+ASjPvJv0UPCf1OjWsjnW2aI24p3ba2AuMgQ0Y7mtJuU3AAe56eWXnDITbWdyNlMJotBCy64SIjLPCJ2idi7sFR7KBIPLhhnSKMJ4/Gnx4LNRlvkOaS71v3m3sr0ugsHE/Bdd6odrpYDe9AdhZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM8PR12MB5461.namprd12.prod.outlook.com (2603:10b6:8:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 09:31:14 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 09:31:14 +0000
Message-ID: <ca108529-9252-5f1d-cbd1-51a43b476ce9@amd.com>
Date:   Thu, 21 Jul 2022 15:01:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220602142620.3196-1-santosh.shukla@amd.com>
 <20220602142620.3196-5-santosh.shukla@amd.com>
 <da6e0e9375d1286d3d9d4b6ab669d234850261eb.camel@redhat.com>
 <45e9ccafcdb48c7521b697b41e849dab98a7a76c.camel@redhat.com>
 <ac67da62-a0c0-27a4-df81-90734382ffdf@amd.com>
 <76e007d7fc7af0629279f2563f8d0c48274bc774.camel@redhat.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <76e007d7fc7af0629279f2563f8d0c48274bc774.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::10) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e51e4cd3-d8a4-4b30-6145-08da6afbc165
X-MS-TrafficTypeDiagnostic: DM8PR12MB5461:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ENUcOYtdWtE8n6HuQWfrPPTbRE3Okn0RIlHomtdyWMkHo+mzbvJ9qNF+2qP2LBzLIv4rBLJsRsHOPgz5HLBaq7HJu8RxHeaS0XFZR3Y1L1XNU+YLT8fVQf+ITPot0QuRvziAMOYxtxBAyjFd0Ny8trL89BB8hNXjdpV3GnWPTW3uT1CIWP8OoeD2BFi8CtTOPomE8t4MCRBtaiBgL9nmBpEYClUrm/CpKaQOdTVULG4WEHG8lgP0ouz6UzLqJ11qbLcRmaHKrqzmoSvIM13Vd127WsJgBa2l2Mn4doYwUHE8DNrUkwkvz5hCWkffx7OvRQ0T3wMs7YOrsMKd3AHZGUjSxFa7yVazRnzJJm8qLWBtOKiwz8KuCWiLfi9MS88yyd0gtDkGtFHB9/vp0/u+xNPSAxbeRTJx6NnE91shSkDiUzSkw/d8AGukJO1GH4Q4fOo6lI1RyujlkH6bH5pght8TYoGRRhSYQBP9BYUcJaL/3cajh40huVqFYajAXeL337CK8tMq5S6fCtPFEK7xWakQrEET668Nb4mM+u7FUzOI2MQe1ST52l7Nvp0HIrWPtzsRYFShD7404v4ng3dndjpv59mQdVIv1vcH/gEx5p3cpIoOXkIbMu2+aGku4aLR2VcwvLs/JHQZrqSLtiarGi5jzvwMzOHUEXoWOaFof4sJcYq3V/iN20ODe8s20oUXK/ZUWKUHr+GBEEGNcyfJJS2PXlALtnSztzrCZqsW2zzsruoTn/sx7K0p7GkIBJNSqHyAsf7c7yNSAbfLXbnSrWQYJdQEkvEvfkhKtBNvBtqoF+SMd/SPujXCyrrGrGCCi/rWZBgjsgxtI0G+9qaZPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(8936002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(54906003)(2906002)(83380400001)(31696002)(86362001)(36756003)(38100700002)(6512007)(110136005)(26005)(316002)(53546011)(6486002)(6666004)(2616005)(478600001)(41300700001)(6506007)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1NSUDlCV0trSWovd1h2WEhjTXBjcTZDZHR6OFpxU1JLanFaSFdmRGdka1VP?=
 =?utf-8?B?V2NtS1dSY2J6YW9OYnZDdFhlb1NCQXdIZ0ZLdnVKOWUzRlFXaWhHTlV4RHBu?=
 =?utf-8?B?dy9ZUmgyalVROElHY3ppNk9YVXNxSC9vQUhtdGdPcXVWYTNnY08vWDFmRkd5?=
 =?utf-8?B?Y0ZrQjlpeGxiRVhRNFhGREQwZmRsTkthVFE5UDg2Yy9uc0F3eFRzeUlOajRx?=
 =?utf-8?B?aENPeXJ6VE9HTkFycmVkZDlkVzZBS3dBRWpyd2VCY3Bhd0dBNFVlQW8wM1Bx?=
 =?utf-8?B?Ulh2UVJvZjd1MnQydFdYSnNrWC9hL0Zhb2M1Smc2Y0M3MENqTGwwWFk3QmQ1?=
 =?utf-8?B?a1pUQVZCcHZnNEZzNDJqOTlCQkU3VWY1NmxmTDkrcENHMzlwMG9IMkRVaXVl?=
 =?utf-8?B?a3dmNTRMQ2NmVmRrWW9SZFVjTGpZbkd2WmZVV0V3T000NVI0aUs0c2IyQnh4?=
 =?utf-8?B?UFRNbU1FOEc5d0FBSVNjV1p1OHNZblBqQitTWTFkT0doWlZHdmdsc2hJa3ZK?=
 =?utf-8?B?MndhQm95UWVpUm5aMXp1VlA4aW42QmI0QmU5Mlo3Q0w4eGdzd3Byb2RzMUxq?=
 =?utf-8?B?M2JUaktEV0RONFBDcE9Xb1V3WXhBOHE5elpsZlZBUnEyTDlJVjhqRlh1Wk15?=
 =?utf-8?B?bE10eHlpVytUdTJQdVNHamhuc1ZXemN5dTVEOXNESk5QVldyMkZMcWkwbHFj?=
 =?utf-8?B?NzNJT0xrQncwNVF0VE1Jc0FqT0F2R3dLSmMrTXdVOG9TbXU2bmU1OXpkV0Va?=
 =?utf-8?B?VEY4WXNnWXZMRDA3WHNRamkvaW5ldll3UXNJOUFZTERONnYwMU1vazI1cnBz?=
 =?utf-8?B?L2lFRlJBcUVpbDJPaGtERlBSSk1HN1c0cE9hSlFlRm9jTFZnNkw3ZUhMTGJy?=
 =?utf-8?B?L3FJNUlINDR6WDBzUTU0dlVjWW0xVlBHTUprUTl4dmc5OGhxMHdlSFg2c0Iv?=
 =?utf-8?B?WUhNSjJkMTd6QkhXWUVCdVZ6U0w1Wm9GY0FZbHpadmJIM2xvellOY1p0VzNL?=
 =?utf-8?B?SUxFYkVpOW96WHlmaC9YRERidUlJSWpwQXdOek5rQmcxTTNMTmFxSlVvUjVQ?=
 =?utf-8?B?MVRCMDNvaFdxdS94K21kVHZ6Z1VJOUt1UjIvTmZxc2hjb21uZk5PdHdNb0Nj?=
 =?utf-8?B?NzVLSDl3eEI0MHBPang5QW03MFVuS00vZ210VnhOVTZJVzN3alFieXBFSVVF?=
 =?utf-8?B?T1VkZHUralpmVm00SmdwcksxUHZHeWRBbXhIM3hPeFIxaFl1ZjQ0MU12NjBW?=
 =?utf-8?B?STd1SGJGT0Q3NWw0QnovUGRGQzRUUU94M0ZGRFcwV0EwcUU4T3ZhalZMOWpI?=
 =?utf-8?B?aFphVlJnSUM1RnVsK1dUeGNKUjFTZ1VoQmpRRkhWcXpBK0o2dUtwLzV5QkEr?=
 =?utf-8?B?aVlJMGFld09VUkJaMDNHSVV5c2RqL1VKU1RZcDNsRUg5cCtMczQ5Wll3VTRG?=
 =?utf-8?B?NEhjOE55T3ptVWZpdHMwd2FpaHQySXY2QjgxdWJKUzBubCtHTjRPRjU2WmpI?=
 =?utf-8?B?NUd0YUJEd1VjckRHM2lWTjJRRHVJWllkTHFJQkdSTXhnSFBRdXBOaTE5OXpM?=
 =?utf-8?B?d1VNZ0lkODRKVVRpbFRrQUsxb3FDRi9TbjJvZUdOVzRNNDJ4Rk9iaW9VUEFw?=
 =?utf-8?B?RlBxOW12c3hxLzFoTTZkZ1doSFVia3ZncFZ6aVl0VjlQN2NmUUhmcktRdnVm?=
 =?utf-8?B?WlYyWDREbHh6Nk5OSlBPNGdBSk40K3U3eTZqNk1xa1hkaVpObXVPZTlwa25I?=
 =?utf-8?B?MjhLNU9ObWZ6Um1CakF3THF1WUVwSmxySU9sQXRwSTNOS3hBVy9pbEh3aXRZ?=
 =?utf-8?B?TElDQmloSW1SWXR0ZnRUTXE4QUpzT3pVcVBjOW4ybFMxUXNHa2pQREIyVVpM?=
 =?utf-8?B?QVJCSHdmM2NmVHhXZ1pRZmFnUktkUjdVRDhpdGZXM2cwY1NkZUQrV2h4SFlC?=
 =?utf-8?B?cmNESzVUVmJOSVlEdDRvcWxKMzhLOTBsb2R3M3ZtMm5sVTJrUGdXQjh5SkJw?=
 =?utf-8?B?SG5lTW4wZ1JWWUlkZmJ2ek04Q3ZkalNHN0YzcGRDU3ZXRjZYblN6ZkRZZmZp?=
 =?utf-8?B?eUFJSFRlbUtTT0VyZmpqRU5sYUU3V3cvVHgwUGszczVmWVdtcVZaeWQ4eDE1?=
 =?utf-8?Q?hhl8kLXrPD95b4OIq3XA4mfm6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51e4cd3-d8a4-4b30-6145-08da6afbc165
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 09:31:14.3609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51JWGOEfmosut1MCV1woLDVgdwgkfaJfZeBzR23qdvACoAYnD6dvbzSxM/jIOIOsFs18peK0xz4UehnMKqvZfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/10/2022 9:38 PM, Maxim Levitsky wrote:
> On Fri, 2022-06-17 at 20:29 +0530, Shukla, Santosh wrote:
>>
>> On 6/7/2022 6:42 PM, Maxim Levitsky wrote:
>>> On Tue, 2022-06-07 at 16:10 +0300, Maxim Levitsky wrote:
>>>> On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
>>>>> In the VNMI case, Report NMI is not allowed when the processor set the
>>>>> V_NMI_MASK to 1 which means the Guest is busy handling VNMI.
>>>>>
>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>> ---
>>>>>  arch/x86/kvm/svm/svm.c | 6 ++++++
>>>>>  1 file changed, 6 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>> index d67a54517d95..a405e414cae4 100644
>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>> @@ -3483,6 +3483,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>>>>>         struct vmcb *vmcb = svm->vmcb;
>>>>>         bool ret;
>>>>>  
>>>>> +       if (is_vnmi_enabled(vmcb) && is_vnmi_mask_set(vmcb))
>>>>> +               return true;
>>>>
>>>> How does this interact with GIF? if the guest does clgi, will the
>>>> CPU update the V_NMI_MASK on its own If vGIF is enabled?
>>>>
>> Yes.
>>
>>>> What happens if vGIF is disabled and vNMI is enabled? KVM then intercepts
>>>> the stgi/clgi, and it should then update the V_NMI_MASK?
>>>>
>> No.
>>
>> For both case - HW takes the V_NMI event at the boundary of VMRUN instruction.
> 
> How that is possible? if vGIF is disabled in L1, then L1 can't execute STGI/CLGI - 
> that means that the CPU can't update the V_NMI, as it never sees the STGI/CLGI
> beeing executed.
> 

If vGIF is disabled then HW will take the vnmi event at the boundary of vmrun instruction.

Thanks,
Santosh

> Best regards,
> 	Maxim Levitsky
> 
>>
>>>>
>>>>
>>>>> +
>>>>>         if (!gif_set(svm))
>>>>>                 return true;
>>>>>  
>>>>> @@ -3618,6 +3621,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>>>  
>>>>> +       if (is_vnmi_enabled(svm->vmcb) && is_vnmi_mask_set(svm->vmcb))
>>>>> +               return;
>>>>
>>>> This might have hidden assumption that we will only enable NMI window when vNMI is masked.
>>>
>>> Also what if vNMI is already pending?
>>>
>> If V_NMI_MASK set, that means V_NMI is pending, if so then inject another V_NMI in next VMRUN.
>>
>> Thanks,
>> Santosh
>>
>>> Best regards,
>>> 	Maxim Levitsky
>>>>
>>>>
>>>>> +
>>>>>         if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
>>>>>                 return; /* IRET will cause a vm exit */
>>>>>  
>>>>
>>>> Best regards,
>>>>         Maxim Levitsky
> 
> 
