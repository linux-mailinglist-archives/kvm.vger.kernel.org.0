Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B9C5A248C
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 11:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343780AbiHZJgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 05:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343989AbiHZJgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 05:36:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B275C4A821;
        Fri, 26 Aug 2022 02:35:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFnZdOcdD9hLOEwWIuq+XdHpX/nidD52praT0p8b0Hv/TMWrfDSljCuhF4Bc+9C31AkxjljTGJcQ8argmItEtUVhEIUMih09wPRlzvCDyztUBc6FsXTqSuydZA4S+kdDTW3V5/+kuSCZds5fEHyJ0zdhscwuACdjpfqba5BapoX3vjDGcPCDqqNWB2Rv1bBPvgwRmvURW1rw+2T/KHVS1guGS+MUy9qbfPqRh+k2f+W/fsT87uOjw1u7HDzyjNEj5bRt6TA4frGjqItmhjX2GY9talzT6upvf/9bbRF8VPLQwtb9MUmGw5qA8WY4roQ1whS7suUIQI9urXScrHiLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LM0DSxi9Swnb+ZBFvUuW7uy/qmYXOWFgi7gNz68gf+4=;
 b=DaZVREeuCtUJ/VcseFittEchyJNC0KkY05Twtc4KlT4vEgm4lYUfdmvem1n+xUOceJq8zA3HiPE+Y5G+J8MiP6ZkGA4eoquXAUMvKPpKOGqhBJB/ucSuAHzVucVam9Q3OgNr6BDXskj/HprA0fSLDo5uTr0TeCsoKov+7uj0zBKPAdfJ/NXWLBdppJoC9aCX+OC+qVbZXy5PEohmhxZm+MlzPvA8gQJTxE170SmQJuX3IohLq106jJ1AOlEWtO6B+DFtTv1kFvP4Z9xFGGtxLrlQaOecwgT6d75XkhmKntvCqp3/ehkJzka4/5M3XqpL4VKH75MLHmzhV6J7vQWgHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LM0DSxi9Swnb+ZBFvUuW7uy/qmYXOWFgi7gNz68gf+4=;
 b=phyQM3nyKkYsYXHzxwRWbqrcxQ2Z7qXktxQ1Wemg9V2ozRmg0EI5NRaVz+TrPaXm63X7PF0KbA98R2EGdbGp3/IYsyyPFQi/OliDwP7kICJDtq3iG0XzqIKNkpRp8dcs8KU160NN89utwFNxXtrStrsiLseBmJv4zirk4nnI5kM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16)
 by BL0PR12MB2340.namprd12.prod.outlook.com (2603:10b6:207:4d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 09:35:57 +0000
Received: from IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::8474:69df:e65a:45e9]) by IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::8474:69df:e65a:45e9%3]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 09:35:57 +0000
Message-ID: <ca464c8c-872f-f86b-6fca-7ef7b374a304@amd.com>
Date:   Fri, 26 Aug 2022 15:05:46 +0530
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
 <ce3c852e-4ee0-36df-383c-0957a6e02a6d@amd.com>
 <ddbb19b8-417f-f839-591d-a0610ea9629b@maciej.szmigiero.name>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <ddbb19b8-417f-f839-591d-a0610ea9629b@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::32)
 To IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6072a13b-e455-4984-d22b-08da874660e9
X-MS-TrafficTypeDiagnostic: BL0PR12MB2340:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQaHHUK3GBCb7DEyKjWU3OPKYDTVzVcP9moA+xNpUpOhB5wMNph0isS+u/b4i3My9JCUihsU8YP+u6T3BqBVZR+66gTYUShLiaY3mD7gqEkv4nBdsn4vtqHR0Zv/G5jqJbTS1EsgVdN1UEt+6XFirwnIGhF1I8mIoAu5OXCb364SDkaag6BwrI+K5qXkH9pZb3YggyAuNytHAouAUMxZt8fCG8U5f6I3AU67AQ+6Urm8JwGUb0ndWNyeozc3OVYKYpcFx0bpX8mWOjFE2i7SJeN9FJJs6ExjpgiAahwuFQZHs+6isuMBcCTxMJyeFT4Bgo8McaCmMi5lAZwmtkjXHYNN/SNVtPHqcmHNanAb+Hi2BIG+vle7IIku+qD9hbAQTArJMJVS15YPT2vQg8kS0hVZNxvugKtGckatZKfUrrf8Pc39YZzp5bL8NGuNU0u9BR1wqN9EVfyI9cJ6wkSUh8Dqa/XxeupxzC7vldj/sdgCanOh5lZgZlnJiot0qPwPCEXGRgKq34nhayjRZ6daTZP0S0gjlw1Pr3aX4Tn4jPQQnIxZdKeogBhNb1TEZ+u4bQ6JEesdHcRYkeQqwtmGevThy1robeeCWja6EUTmCVuIwM9u4MNn/xpLJ5kNJ+lWKwmdxpWAymN5bbKVU1L+0jBvNE04MCqyetB56hwRFY/nxewbOPV9CTxK87pdD8JMiUWhM8IzU7JpHwKgfHzT2cbeYwNw0eQsO/pUp8dGyeAszMQX0SEm2vQ8ZrcgmuZ/C2GUHaYsRa8aAOdwqaZJbY7Ov+vu2RrwUVJCGE+xeYQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6305.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(2906002)(66476007)(8676002)(5660300002)(8936002)(66946007)(83380400001)(6666004)(36756003)(478600001)(66556008)(6486002)(31686004)(316002)(110136005)(41300700001)(54906003)(6506007)(53546011)(26005)(186003)(86362001)(2616005)(6512007)(4326008)(38100700002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU5NdElGeE1wRGNRVEQ2Q3d2c1JGSWRqcHJWY015cTJYRXFlU09CK3lnNStM?=
 =?utf-8?B?RGUxd0g2L1pDUkNsWXp4UVY5NHNuUDhtaEw4cjFURFJDUUQwVVdnYVR3cGJt?=
 =?utf-8?B?R1VCSzdTWXpsTHpiM2FickJQZHE2RjJsT0lUdFVZbElmVnJuOXBCb0Fkemp5?=
 =?utf-8?B?aDVKMVdVQ2VlTnd2RVRLeVowZFVSaVplaGVXS1ZNYVpUOWdhbDIvb0Vrc2Uw?=
 =?utf-8?B?Qmd1NnFMMUMwVGtXODMwWmFoT3pmUzVvVzVROXU4alRVbzJqWkI5bVdnQ0N3?=
 =?utf-8?B?ZnFSV1JwemJmdXNtM0ZLdXU0ekNhbStIbCtUNHBpelNOY3FpMGNJdmVuMDZk?=
 =?utf-8?B?SENkKzZkL1hEbmZ6Skl6QmJSUUhrUUYva0cvWEZGVzZUb3ZBYUxiL1NscmJO?=
 =?utf-8?B?SFJvNllTdnJtZ3JEVVdOSnJpYWxRNEYwcU9LRWhncXJPU0prWFVlbVE4dWF4?=
 =?utf-8?B?VnQ3WmM0ZHl6ZHRXZ0x5S1VxZlZHQ3NGWXJaRUxoYkVNZkpJVExUbnEzOFUw?=
 =?utf-8?B?S09zOFdFQjdLeG9MSzFYUW9hTHVSWWNGTkh5enNkS01GZWFiY1RaWW9DQ2dQ?=
 =?utf-8?B?aitTc2FpQVIybUVxSlVsbCtFRXZzdU8zZDN2ekZXekc4VVZSVjY0STB1V1Rr?=
 =?utf-8?B?QU83VjVyemlGd2FqbFEvNFh0d0JmOWlvMnEwemdCR0k5cDIzVUcvbk96NGlU?=
 =?utf-8?B?WmJXQjRqSm9Kb1BhSzRKSU1CME95bEhTSXBKbjlkR1RWRmRsZjM0eUxtZk1P?=
 =?utf-8?B?NElQd2daS2RySS9QeGlab0MwTUU3WG5DeG43UEkwcmFmUlJHV0MvcndBNWtu?=
 =?utf-8?B?dzV3VmhzQXh4NUZia0tsQUhzWnh2a25lZFlyU3dWc2wvUGhzeGwyay9xL3Ez?=
 =?utf-8?B?Y2MxRkM2MzkrZUZlTzdKZzZTeUVTemorRWpTc2lFdXdQeW1lTzFINWRiang0?=
 =?utf-8?B?NlBGek5IUnJvTUZIb0ZTZm1CT0paQXNBRnk5bjhRcjNyVUZNNEtUQUx5eU52?=
 =?utf-8?B?dDZUNjVjcWNkMTlDZENXemNqeGU3NFhhdXUrL2gvcW9WbjhQUkhwSVJQUUNn?=
 =?utf-8?B?WmhrWmZlVm1tUWFEMkk1MStocWkwZU9zU3NPU09BbDh0MWcyQnhDR2lldm9m?=
 =?utf-8?B?cFZRUWpLSW4zaGxkUVlvTmtxKzY4UVZpcWQydCtmdUJwTURHRHJGeHpzcXFs?=
 =?utf-8?B?Y3drSmx1MW1VRFZkT2Q3STlnNUVXakM0OGQwenNsdDQ3c0xIMExGTEs1SjlO?=
 =?utf-8?B?RHhSeno0ZGhVSnE0TVExeDVldW93VDBMV0Rvb0xmcldUL0h3WW9GU0tmejZy?=
 =?utf-8?B?V1NlNXBoT1VaWGJKcG9TT29rK1c0b2pNd1N6aWVNVGg4QlJZR3pJN1lNVzIv?=
 =?utf-8?B?a1I3KzRpbzBoUG5GMVBHN2FxbWVza0RwdndRbnZsT2plTjg4aStGUUF3NGJt?=
 =?utf-8?B?OTkwQnl0QnRHbmtBKzJXbklaR0J6MVFPWHdZZU1oUDNFbDNTRWNYOHBhVlNh?=
 =?utf-8?B?VnlKanpDM21GaXJ0TGVzOHRvblNUNmx2M1ZWSHROQ0ZER05SUU5EcmhaWTg2?=
 =?utf-8?B?RmdRR3FRTzJCNVZxSm9KQTZOZVRkZ3ZZOElpMkhiNTBTZ1Z5dDZKdTdYUVRI?=
 =?utf-8?B?S3oreXFIRXgzdkhxbzJ3VGloTTA1bUhtdWVLWnNPN042YVozWjhvTmdQMVcz?=
 =?utf-8?B?cStYWDJkMmZZMEZTeHNpWHQvWE9WOUltdFV3NHJ0QnV0K2RBTEtSTzdHeDk2?=
 =?utf-8?B?RUZmeXR1dWxXSktaOE9NbXVhNWFhYVMzM0o4R1NtcjZRK0VsUkZ6c0wyNk55?=
 =?utf-8?B?YmdnOEdZV3VPUDVaWlhrK3k5Ny9tdXZuWmlleVd5Y3RwU0x6OGtXU3hrNnUv?=
 =?utf-8?B?RDUxSzJnSTlCQksxVnR5Y1NhMVpLY2pWTmZLV2s2OTJYK0M1b1pNQmJxRjd4?=
 =?utf-8?B?LzBBRUdHYXRKTTRUUWcySG5sQTZaeXFkeENFaStaTnJkL3orSWF1NDllQkFo?=
 =?utf-8?B?WWwxTE5LVk1pVnR5aGF4K1BMcFlpOGdCNVFCQkRyMjRhNWQyTEJGaTRaTzA0?=
 =?utf-8?B?Vm0rRUMvUURyR0R3N1BSZFZyeHFBWFQ5emw1VVRyRzlKYjRDNzl4dDNja3lD?=
 =?utf-8?Q?aiUDkwCmCdrADUcDB5KiXi9ib?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6072a13b-e455-4984-d22b-08da874660e9
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6305.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 09:35:57.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uig2xgi3Nyuk6GyamHxJwu7TRaX6kX/96VUXkMPmL3OACPilYMR6F7xLu7/1apZM69Z3wBC83WhvCr5s/iQGGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2340
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 7:46 PM, Maciej S. Szmigiero wrote:
> On 25.08.2022 16:05, Shukla, Santosh wrote:
>> On 8/25/2022 6:15 PM, Maciej S. Szmigiero wrote:
>>> On 25.08.2022 12:56, Shukla, Santosh wrote:
>>>> On 8/24/2022 6:26 PM, Maciej S. Szmigiero wrote:
>>>>> On 24.08.2022 14:13, Shukla, Santosh wrote:
>>>>>> Hi Maciej,
>>>>>>
>>>>>> On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
>>>>>>> On 10.08.2022 08:12, Santosh Shukla wrote:
>>>>>>>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>>>>>>>> will clear V_NMI to acknowledge processing has started and will keep the
>>>>>>>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>>>>>>>
>>>>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>>>>> ---
>>>>>>>> v3:
>>>>>>>> - Removed WARN_ON check.
>>>>>>>>
>>>>>>>> v2:
>>>>>>>> - Added WARN_ON check for vnmi pending.
>>>>>>>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>>>>>>>
>>>>>>>>      arch/x86/kvm/svm/svm.c | 7 +++++++
>>>>>>>>      1 file changed, 7 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>>>>> index e260e8cb0c81..8c4098b8a63e 100644
>>>>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>>>>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>>>>>>>      static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>>>>>>      {
>>>>>>>>          struct vcpu_svm *svm = to_svm(vcpu);
>>>>>>>> +    struct vmcb *vmcb = NULL;
>>>>>>>>      +    if (is_vnmi_enabled(svm)) {
>>>>>>>
>>>>>>> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
>>>>>>> since if nmi_l1_to_l2 is true then the NMI to be injected originally
>>>>>>> comes from L1's VMCB12 EVENTINJ field.
>>>>>>>
>>>>>>
>>>>>> Not sure if I understood the case fully.. so trying to sketch scenario here -
>>>>>> if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
>>>>>> be one of following case -
>>>>>> 1) L0 (vnmi enabled) and L1 (vnmi disabled)
>>>>>
>>>>> As far as I can see in this case:
>>>>> is_vnmi_enabled() returns whether VMCB02's int_ctl has V_NMI_ENABLE bit set.
>>>>>
>>>>
>>>> For L1 with vnmi disabled case - is_vnmi_enabled()->get_vnmi_vmcb() will return false so the
>>>> execution path will opt EVTINJ model for re-injection.
>>>
>>> I guess by "get_vnmi_vmcb() will return false" you mean it will return NULL,
>>> since this function returns a pointer, not a bool.
>>>
>>
>> Yes, I meant is_vnmi_enabled() will return false if vnmi param is unset.
>>
>>> I can't see however, how this will happen:
>>>> static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
>>>> {
>>>>      if (!vnmi)
>>>>          return NULL;
>>>          ^ "vnmi" variable controls whether L0 uses vNMI,
>>>         so this variable is true in our case
>>>
>>
>> No.
>>
>> In L1 case (vnmi disabled) - vnmi param will be false.
> 
> Perhaps there was a misunderstanding here - the case here
> isn't the code under discussion running as L1, but as L0
> where L1 not using vNMI - L1 here can be an old version of KVM,
> or Hyper-V, or any other hypervisor.
> 

Ok.

> In this case L0 is re-injecting an EVENTINJ NMI into L2 on
> the behalf of L1.
> That's when "nmi_l1_to_l2" is true.
 
hmm,. trying to understand the event re-injection flow -
First L1 (non-vnmi) injecting event to L2 guest, in-turn
intercepted by L0, L0 sees event injection through EVTINJ
so sets the 'nmi_l1_to_l2' var and then L0 calls svm_inject_nmi()
to re-inject event in L2 - is that correct (nmi_l1_to_l2) flow?

Thanks,.
Santosh
> Since the code is physically running on L0 (which makes use of vNMI)
> it has the "vnmi" param set.
> 
> So is_vnmi_enabled() will return true and vNMI will be used
> for the re-injection instead of the required EVENTINJ.
> 
>> In L0 case (vnmi enabled) - vnmi param will be true.
>>
>> So in L1 case, is_vnmi_enabled() will return false and
>> in L0 case will return true.
>>
>> Thanks,
>> Santosh
> 
> Thanks,
> Maciej

