Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BF35A12F9
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 16:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbiHYOGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 10:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiHYOGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 10:06:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9212ED45;
        Thu, 25 Aug 2022 07:05:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXfv2K6lKh+1UmhOn4UQvwB5QKfbSBHaXtcM43w4j/93pTEh0ms9WU1M9dwxzczgF5d92nI92flY+xN3hfi4lCsIeodGRHL+8dZA3aJGvQ3MhEr/oW29xzl6ZkLw8S640hWdwJ2qNP3tsfFTCxvoOwhXKnv1D92Zzho0xc+h9SlH+1s1aNMRpcd9vDK3s7OnNKaeSZGTgWHXSeplf2KMkmqRiLVJLdINcyhmfKF+pMSDipXUAzxCBMSiifE1X5pnf6t2QHKUYZpO53DOKvJ82MXZ/kdbe0MKp0A4c7dCtHWL6qE/66TQ66xgy98LQ3xlwMvk4BnwNKWIfis1QtsArg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgLyhespL61LQTUeDfsQWWmHVsQj4Y3hiZvbeqhbi5w=;
 b=WzRxCzm0ZdpLKE2qtt1Q5zFhJOsuwrNYlVs6Wl4LfjCyQQZ27/oCvw46eWsxSRlyM7fPpriw8nGqJRmS5VCP3xIBix0CTra4ICFyHE81Op5RKLp1en8fXFFRWhfCh2yFW6HMuVimNpumtuzUmJYvPSwXhQ0lD7Xh9K8OcgjhQ0wq2/iahN+uA128PzpJcXIOGPvgsV+sG0nx9d4XDBC9UptK+iY3DonzP4KSMWbXVJDYcJ8kMp4TRYLIiDCIMTUew+xjtXDVLvrJqlfBjm1AuWWeGjMviZY9QOeLniV4GETIlcWlHooWKc+nKJKQHKwu8Sf1NEEO91tg9OobIMIfpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgLyhespL61LQTUeDfsQWWmHVsQj4Y3hiZvbeqhbi5w=;
 b=NHoUfutoOGfMMaSN5bT/9LIdzf3j96X4qbfQR9itq5I7IsZZJInND9zsn82MTMonowcApEYnXyXPL8O9cVHcjaUgnubIAGxzi1qadqDja1gH30xFbW45RN8KROOBywTUCXCjPdrpDycBHh6IoJIAOIK2XtLDN9GWZcTkOf63Xos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by DM5PR12MB2552.namprd12.prod.outlook.com (2603:10b6:4:b5::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 14:05:53 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::1901:1d1e:a186:b37a%8]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 14:05:52 +0000
Message-ID: <ce3c852e-4ee0-36df-383c-0957a6e02a6d@amd.com>
Date:   Thu, 25 Aug 2022 19:35:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        "Shukla, Santosh" <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com
References: <20220810061226.1286-1-santosh.shukla@amd.com>
 <20220810061226.1286-6-santosh.shukla@amd.com>
 <bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name>
 <e10b3de6-2df0-1339-4574-8477a924b78e@amd.com>
 <f96b867f-4c32-4950-8508-234fe2cda7b9@maciej.szmigiero.name>
 <1062bf85-0d44-011b-2377-d6be1485ce65@amd.com>
 <3752b74b-74e1-00fd-d80d-41104e07fe95@maciej.szmigiero.name>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <3752b74b-74e1-00fd-d80d-41104e07fe95@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0085.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::30) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1d95860-d0c7-4a24-1010-08da86a2ebac
X-MS-TrafficTypeDiagnostic: DM5PR12MB2552:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+MNGhjzMEVY7EmQSOSyogDDr5XnUEacalzzR0R4Zs5UZ4KmrkCDJ2Fveh4cdMhXuB27CeVDXpskmWQStdiXnqp7gGfJsh444QYzdIEWtCxbBSS/5ACRVi+QN28H3Sv8zd4o1UrPG3UqNqQ4ENCd9vPM2kFAm+9eeXABMGIpP8FCP0R7ETVDevhI/KAIAiS8wtEtebWt6Gdwk/3+cvbsBs+/mXE6jj1nVgGr3ekUeOntXWQP/jxXRJSLJwGSPi6P+2HcdIIJOcGkcMrydbBuk4mb+Oy8IoGUgCOP+S9xg5SPsonpvIANCzkj0g9t23MLcbA6cJs9B8bL7faIvn+CFfpCLRCV5AXmqh2XwkyU3egSEwF5+sPvud1FkwUCpka0WuTUTNWx2UMQwLBZpqlUpcjx/m7zRawn740D5gqmTQ4IcFnvbbQL/3N+ZyOAMSuiH4qfYKtcmZDjKomOaHgbtmsxUer0wI+/vHN6l2f8Pe17kiYTKMGx6Xn0miMy4fFOLyuMDkdpOolm9kIJgyIw9NLDeO2lljqyjS+n4xDKwUAIRqV/UptUCah+bgxaM8FHaTs3kqJ9/36AGKHkvnGAhpNUr2aF+xfgd7fZ95ZgOTVbmwmDY0TcJ+M3YlyqqZXdIGau0tSPUkgl6hMZkAXnjnppXT/EPEYhRt8hgBpPKnyAQgC+hmMYTVPSihNu7SPF5vuR+ztXtpEmRDUi8g/g/fwpsPsLOT+Ta84AhsgJINE1r/xtLvX+IEhQj+maWxClOAkY669rJU2pGuu2xQhDOO9pK5/bq5CI7h0yzQukbaw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(6666004)(6506007)(186003)(6512007)(478600001)(6486002)(4326008)(83380400001)(41300700001)(66556008)(53546011)(8676002)(2616005)(55236004)(26005)(66946007)(8936002)(2906002)(66476007)(5660300002)(54906003)(36756003)(110136005)(316002)(31686004)(31696002)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEExdWpHNDFqNXVmeC9RWDMxMG1jVy9YS1NOd1ZndlIzQ2FNTSsxTjFsSkVq?=
 =?utf-8?B?bFViYndZbTB0QVlBT2pmS01jV2ZuZmtVVHRPWk9jelViOE1VZFZkRjZoQVp6?=
 =?utf-8?B?aG5ib04vRmlYVkVraHhRQXFxWU0xeHNjdDZoWFRrdXJFS0NabFkrQmlxUlpW?=
 =?utf-8?B?dHB4aHhVVldQK05UcVpKUzJhWTd3QXdwN3dxdy9XNFd2QnMwN0ZCVnY4MDFL?=
 =?utf-8?B?TzBIaWd0RXh6cjJKYVdua25iQXFZTXQ2dFZMZlJVMWtTV3FuRWZKZURCMThG?=
 =?utf-8?B?UEszcHIrOFlRRHVkb2NDcHhhbHl6U0FQQkllUVZ3dGtxMnF0d2hjVWp5V0FW?=
 =?utf-8?B?UVJIT3ZMNG9ubks5TER5VGxOaW5wclJxUXJVUDV0eGZpLzVCM2VGaGV4SEdt?=
 =?utf-8?B?OVAzbjd3R05hY0gxbk10WVpiQ2MybEIxb0tIQWduL0tzYm5KdzhHMWR1NXRm?=
 =?utf-8?B?cmN0clR4WmU1eGFmT2J0U0RRcU1LcFlOVCtBZnI1UnpjeUVBaGhTWldpa242?=
 =?utf-8?B?YmpHYXg3cCs0aUUzMnFYOTdqdW9VNWtxazF2Z1ZvOXkvbWN1d3pxaUY1Zms1?=
 =?utf-8?B?UG9rTExXaU8wdUR1TlpGcDNzZ1R6bnJvdVFxTnVzY3NPT1dVai9BS2FLUm1o?=
 =?utf-8?B?YTI3R0xEQlpaa28zZ0hnUXhleWpHcFh6Rlg3MkxYaEU4K09abXJyTVdpZjBH?=
 =?utf-8?B?RTlkdlJCZXB2UFYzYmZTTHl3ZThiQmtwc0M5djAyU2lXS0lBckloS0N1T3ZK?=
 =?utf-8?B?K01IYmplVzdqZTFhMHZ5bzd0STVNa3lsTHA5ZVpXc3gxZWFsYVhtbmZGVEd1?=
 =?utf-8?B?Y3FOVlJKWWxERktRTkFGNGhSb1cxRzRBaEZWR1hOeVlUcC9sRW9ER3FoWlVx?=
 =?utf-8?B?ZEpYSnlLWXhUbjZZV0xqSWY5U1NtWVNhaHcxaTVNczZTTThNMHBaYkhmUVdW?=
 =?utf-8?B?UGxYcEo1M1d5SGNvc0FPVjFKaVZ4VlBQUVZvZHl1eXZ6OVErQ0k0MC90S0Vz?=
 =?utf-8?B?dktDL0VXMTN3c0tmUkhWQ0R6SHJNalBsQkNzN0hyV0JIQ0dVQ0xNTWtOMEMw?=
 =?utf-8?B?N1c5MVRUblNUOWJRRHJyWW52YTN5VnEvcURkbkRiekIxbWJKcjZEK1BjOTl4?=
 =?utf-8?B?ckpYTUljaWxXc3dnRk9xZklBL0IydEdobUFZTmtQY2FCK1M2bTJaUmtEQkZC?=
 =?utf-8?B?UFlqOTlOM2JLc1Y4MzdkYXNlckN6VCtuVFk1Qmo3VmpMbDREcjdLcVZ0S0dQ?=
 =?utf-8?B?eU9tU1o3bFhabUlVODFTNEJsUFdwYzlMYy9rb3JVVjNNTENVK0JWZ0NRdWZP?=
 =?utf-8?B?QTdNazErVmx3Y002Z2lqOW1Md2ZyTnhxeGlYbW4wYWh0T1BndHFsSjRrOWIr?=
 =?utf-8?B?K1lnSTRlWUFkSnBSaDYxQXhkZHVrSlNXV1V2SDhtbVFNSDZDNXJOVzNsZTVh?=
 =?utf-8?B?d3FiNFE4USsxakMxajNJTkdFMkFMMVl0c0hYdFUzN2FJMnZXSExlTlZKSWlM?=
 =?utf-8?B?OTl1NDNqeUI5S3l6OU8wNFNlNy9nelUwVFVXWCtFU2xWMXd2QkJQcnNZejB4?=
 =?utf-8?B?dVg4VWp0QmsvMW9qcWI1MUhVNElCcnpJY3M3NzU5SGcrN1RTQ2VNcC9lTWNo?=
 =?utf-8?B?enkwcFI2empOUzJjQ2dTR0tqSUk3NHJ3K01UcVhHWEhIb2gzR0o3TDY0ZTJs?=
 =?utf-8?B?OHUzdkxqc28ycU8wMExKc2ltNnRNTDllbWl6L2xZVHJJTHlGb3c0TktQNmxl?=
 =?utf-8?B?b2ZsTVoxQ3BMUm1Sa1IyWk5DaGFHanpqYjhxeEU5anFYbDVRSWI1MGE0bGxY?=
 =?utf-8?B?dk9UTVhHRlZZbnNCanNtdmFVWXV1MDZqZWF6cHdXMGhiZlFiT01kRitYdzB2?=
 =?utf-8?B?NHZCV0l3UWIyQ1JWUkVHc0hKWnozd1FhVVg4T0N6TnBkTGUvSmUwZDN6VUFS?=
 =?utf-8?B?OUY0VG1CajhEWDM1ZG81UFJvcEJEM3lyeW1ENVh1WHFUUEJXSWRYeXZGRUhU?=
 =?utf-8?B?eGtES0RUZ3JnQndVUk5pM3BrMGtYMDJPeUo2VzRNMmxOYmVaN1BTZ3NuL3ha?=
 =?utf-8?B?ZXk3KzJMcFpUSW1PYzlIT0srTVI2K2xPVVhBQWl2ekJ4aWdZYko3ZDNmM2hG?=
 =?utf-8?Q?mi9j016fvKqbGNqdeOj3lfR9u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d95860-d0c7-4a24-1010-08da86a2ebac
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:05:52.8549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMmkVi5YiYlkFZwwaiu+pyHX/rVBds5z/RG6Q4GX0uHbdHC9e5Qg/aXW20uIo3tOL4JQpsJh8TltZnQ5L8KGVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2552
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 6:15 PM, Maciej S. Szmigiero wrote:
> On 25.08.2022 12:56, Shukla, Santosh wrote:
>> On 8/24/2022 6:26 PM, Maciej S. Szmigiero wrote:
>>> On 24.08.2022 14:13, Shukla, Santosh wrote:
>>>> Hi Maciej,
>>>>
>>>> On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
>>>>> On 10.08.2022 08:12, Santosh Shukla wrote:
>>>>>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>>>>>> will clear V_NMI to acknowledge processing has started and will keep the
>>>>>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>>>>>
>>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>>> ---
>>>>>> v3:
>>>>>> - Removed WARN_ON check.
>>>>>>
>>>>>> v2:
>>>>>> - Added WARN_ON check for vnmi pending.
>>>>>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>>>>>
>>>>>>     arch/x86/kvm/svm/svm.c | 7 +++++++
>>>>>>     1 file changed, 7 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>>> index e260e8cb0c81..8c4098b8a63e 100644
>>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>>>>>     static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>>>>     {
>>>>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>>>> +    struct vmcb *vmcb = NULL;
>>>>>>     +    if (is_vnmi_enabled(svm)) {
>>>>>
>>>>> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
>>>>> since if nmi_l1_to_l2 is true then the NMI to be injected originally
>>>>> comes from L1's VMCB12 EVENTINJ field.
>>>>>
>>>>
>>>> Not sure if I understood the case fully.. so trying to sketch scenario here -
>>>> if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
>>>> be one of following case -
>>>> 1) L0 (vnmi enabled) and L1 (vnmi disabled)
>>>
>>> As far as I can see in this case:
>>> is_vnmi_enabled() returns whether VMCB02's int_ctl has V_NMI_ENABLE bit set.
>>>
>>
>> For L1 with vnmi disabled case - is_vnmi_enabled()->get_vnmi_vmcb() will return false so the
>> execution path will opt EVTINJ model for re-injection.
> 
> I guess by "get_vnmi_vmcb() will return false" you mean it will return NULL,
> since this function returns a pointer, not a bool.
> 

Yes, I meant is_vnmi_enabled() will return false if vnmi param is unset.

> I can't see however, how this will happen:
>> static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
>> {
>>     if (!vnmi)
>>         return NULL;
>         ^ "vnmi" variable controls whether L0 uses vNMI,
>        so this variable is true in our case
> 

No.

In L1 case (vnmi disabled) - vnmi param will be false.
In L0 case (vnmi enabled) - vnmi param will be true.

So in L1 case, is_vnmi_enabled() will return false and
in L0 case will return true.

Thanks,
Santosh
>>
>>     if (is_guest_mode(&svm->vcpu))
>>         return svm->nested.vmcb02.ptr;
>         ^ this should be always non-NULL.
> 
> So get_vnmi_vmcb() will return VMCB02 pointer in our case, not NULL...
> 
>>
>> Thanks,
>> Santosh
>>
>>> This field in VMCB02 comes from nested_vmcb02_prepare_control() which
>>> in the !nested_vnmi_enabled() case (L1 is not using vNMI) copies these bits
>>> from VMCB01:
>>>> int_ctl_vmcb01_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
>>>
>>> So in this case (L0 uses vNMI) V_NMI_ENABLE will be set in VMCB01, right?
>>>
>>> This bit will then be copied to VMCB02 
> 
> ... and due to the above is_vnmi_enabled() will return true, so
> re-injection will attempt to use vNMI instead of EVTINJ (wrong).
> 
>>>> 2) L0 & L1 both vnmi disabled.
>>>
>>> This case is ok.
>>>
>>>>
>>>> In both cases the vnmi check will fail for L1 and execution path
>>>> will fall back to default - right?
>>>>
>>>> Thanks,
>>>> Santosh
>>>
> 
> Thanks,
> Maciej

