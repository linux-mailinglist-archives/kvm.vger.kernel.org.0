Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5199868EC2E
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 10:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBHJwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 04:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjBHJwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 04:52:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53509305CA;
        Wed,  8 Feb 2023 01:52:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fy3OX5hXQqSl2XLplPaVYzLsXwIj7Ql8Ky/VM/jzpAom55yu33XP8V1jDQj4KrCIm7SI2/zCFX5bj9KKjjy4siD2W2c4RmxvjA6eJPuLi0ughiyeksbi/mIqNT7GZzAKSs9d7vJWtvYg3lHgPbLd13Y/A9EEfZFXvNGTFnwCMrGPman+IGdGP7jstRUNbXg+7BY3DEEFGxKiodgf6xBXOE7FJHUISUWwk6wVlRPq6seKo3NObY+1BDnplBpHU7KIIImUMjwQ3M8eeWq4JaWHpkzHWfNJHdRVv4WC4h0FgAJD5ZFY6cLnuSyyPUyrTb/A+PIOHlOEVy0bnOvf1hX5GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9hgdHJOU/jjCO7hGPT9D9K5DzRQU9wN5xOTmk8Poi0=;
 b=nmDhDQmXnx9FT6KY89d7Myb0hm/F8YvNBz33fFOd0zJNYcipu+EzI5uEMubbaJ8b2KpiKrSgUZsrHibHFpHsFKoRZunqtDxiHFzGmHnFodpy0DkvL4YHvkFbGZ4b8oSkWnb5Bc6tgrAt7rFUYwaE4SqCKCmGjvyX90Fq1dYIskF2DD0lBHKsOqmcj72rEze8HdfnqJD1DCcN66A7fT8cYSKeYN7gVVrAUylP/ZcCT2f05zVwKEPA8Hmw86NcplyIe5RTxAg6N/9b1ENeVrD6xSV0FogrQ5AwrqrQMYTpZxDQuRM5gdO90VJ3sdJc78AolBYt0foS8+IcBxuqH6cANg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9hgdHJOU/jjCO7hGPT9D9K5DzRQU9wN5xOTmk8Poi0=;
 b=Ru2PXQz9nVLYha0HrBXN1TmJ4CXKPxzXfNpriSQxzbblK5buJzlKVXAuJvQGUjaPmufI5VVyER0Qi62m7QLJw4UC17gN974GDn9aSmpVLKoFiTXj7YySMGP0c+URbedDciK/Vev+fBZ4CqQWITPXvuMVoqhRPZtID5HUWA9TtYo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN2PR12MB4486.namprd12.prod.outlook.com (2603:10b6:208:263::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 09:52:16 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%2]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 09:52:16 +0000
Message-ID: <d3681058-224d-07c7-283f-5f81ab523844@amd.com>
Date:   Wed, 8 Feb 2023 15:21:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com> <Y9mWFlGdzoa8ZDW7@google.com>
 <Y9mtGV+q0P2U9+M1@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9mtGV+q0P2U9+M1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::14) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|MN2PR12MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: e4195b6f-5059-4460-a9c5-08db09ba28eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XV0Pv2dKodXeoKi+u2qtYe7mX/huJsCy3grPZ/gKUuFUPqlyXqK6yxj+cd8c8I2l4xhrf0EA0/DQESKRkhN8XiG64kbIhQN/ZX7S1ErtVbZd5x/7S+KcC7RerxD2oND18RhN/aggpmecWmnAEn2iz87n5gU8RMX4xKaQk2sWcs1hF/Hs+AHpzcb5eiBIPVMtaCCX804ynytyxcvzuhzhPI7IJejQOQsriOlqiJ0Cfg8DwFmkIgOTdacer96lLDTe+zUl6pW3+jl/SDId2zRowbqIYOhphcxHxBsJov+6AWuR+muBWJBSdwlG8Zj1x85vm3lRebjfod0yRkeK+RZEv38AINNEwV6ixQhD/phCBJ8W16GWCd+s+vuMM93ctvh2BOAIVDRIKvy3bfGPznamO68tOW8vks/8X3svyrHjNysX8/k1nD6NhiNeziSO3Fg+XzMqVY1CvnNnWq9WZfXWpPB2lv6hEHu7eoe8SGjHw9ygNprn3EqwnUenk46rUHJh4wd8TegEqiMzLFjshQi3md51e5i56pkSqIzNPbv63hAL7e1SJH0qpBVNlupsjmuKbZPvY/Ocn0Q7DrB57pRFSQKV8I8fWxcXv5vFZCykth69SDHYPOm6JNPxt1DXv1a1dx+fSvauwjYcJTsSArfYowZva2Xs8Bqm4jJUhtF8OWn4xInh5HYcMHZIqlf5iquPh9Of6FwBVxhvVN368YcK/d7eY2GbKqeMUxzf3s96pzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199018)(31686004)(83380400001)(44832011)(36756003)(5660300002)(2906002)(7416002)(186003)(31696002)(6512007)(26005)(6506007)(53546011)(8936002)(6666004)(66556008)(41300700001)(66899018)(478600001)(6486002)(86362001)(38100700002)(2616005)(110136005)(54906003)(66946007)(4326008)(66476007)(316002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bld6RzJBbjVEQWlLNnBYWGxxTkJCak5LSUVTcmw3VkV2OFhWeDkybEVWZDh6?=
 =?utf-8?B?NHZrNDY3a0paTHptZFJ1TUQrVml0QjNjVjcyQmlIVUw5L0VQRys0ZXBaNFBL?=
 =?utf-8?B?dkdWTEpjaXVrQUtMbkxUY3BuRGdTSkJ6bk9jMzcxSW5lRGxnR3RWT0Q0NlZx?=
 =?utf-8?B?cjROY21sN3hzUVg5TTV0RGtVRHp4WnNUNVlmTktaRGpPUFdEeXFrczVkQ1dE?=
 =?utf-8?B?TURmZTVxTnVDTEN2b0pwTTN3d0JDeTFtbGFMUGI2KzUwMzFCT1JlOFhzQzJk?=
 =?utf-8?B?TjJFZ01xOHFHYVF2VE1wWDljUzlMR0pYSGlJNG0zT3lBdUZyQVBZck5DUmJE?=
 =?utf-8?B?QnI1SmJ5R3JxTWdoa0J0TUNCSEIyWEl3UFB1dXBjcTR0Z1EyL2FyWVg5ckU3?=
 =?utf-8?B?dTgrM2NXOVM1YW42bkZJdVp2dThTV2IyQlNvTnRDaVAwMFNSNE5oMFpHdDgy?=
 =?utf-8?B?SkxuMkgrR3p3L2ZySlpOc0J3d2FmNVFCWFo1VGRIUUxiV2xuZ21mN1pmSTB6?=
 =?utf-8?B?b0ZsSmlndkFGTEJBRHpzc05YclB1Z1BrYTNUREVIb3RNbDkrcWoxT1p4ZmVX?=
 =?utf-8?B?Zmx5SE5oTXNlSnZVMThVelFUUUlBV1BCOUhLTTlUNS9PMjMzWm1hVmhsRG9P?=
 =?utf-8?B?aFJQWFJkR3l6NGM5cFdITzVCUG1CVDJNZGRNbGloTFBkaVh2c0lXbnpLVGZC?=
 =?utf-8?B?RDUyKzFhZjdWanVUVFBTbkJ5bkVMUDFUbDJlKy85OE1HWWRLRlRaeFNITVU0?=
 =?utf-8?B?K1BPM0JVTkwyYlIybGVWSFdoYXp0MVZkVktLU0k5cnhaV1dQQktxVm9kQW5P?=
 =?utf-8?B?aVAzN0IrSFN2ajl5L1NWT3hkUXI0ME0vR0F1UW8xYUdoZ08rL0dWS3pDbSsy?=
 =?utf-8?B?SjhHY0ZIS1lXaTMrSEVoZk9xL2pIdk5TeUFuTGhxVVN6ZytWOXhMUzh6aWR1?=
 =?utf-8?B?VXVZNFNWcUNpYUk1MlRtTFNhbFIzTEsyc3hPS3BpN3UySzlUT2QrZlhyWndX?=
 =?utf-8?B?VjBaaW9RNFM2WFZJV3E2bnFDcEowYUFpclF1RmdsZ0R3aVZGKzZ1VTVKNVQ3?=
 =?utf-8?B?ZEhuRCtnZ05OUzlLRVB5SFc2Z3paZkdnamJ6ZmN3SysrS0Zmd1M3Ni9OSGpt?=
 =?utf-8?B?UW5RK3UvOWZFM3lkdGk0eFR3VzU2azZJL3JmUGxsVVNqSUtYbzBaRCtlOFE2?=
 =?utf-8?B?MEpDUWtVSzlTeTgvd3lpMjFHOU44SEYrUkFpektkSmxyektkenFsdVNtdXFl?=
 =?utf-8?B?bEJNTkJRR3pCaUxUSDU4Q0h0UCtYYzkwQldpTktIY3B3eDZpUTU5RXZPaXcy?=
 =?utf-8?B?WkRjWWo1RnlBOHVMMlZwMVh2NXV3VnZHOEFHQkZOMjlteGQxYm1mMndRRUI5?=
 =?utf-8?B?TTlRWS9OWFlFVk5sMUh2MTB1QzdhVWhZbklpWTlmWE5vWEtwbnAzUk5wdVB6?=
 =?utf-8?B?aHhuMWJRT2cvLzZMancxNXZTeGRQS3pzc3ZsV1BqZERCMlhhZkMyazd2L0wx?=
 =?utf-8?B?eWsySkM2SWJZU1pid2ZmWmJQQmViRmtlQXZFaVlObXYxOW1IdjhZVEVvMU8w?=
 =?utf-8?B?THVkaUwyVENNRHBHY01qMXc2b2tDU0xkK2NXRWswYVBMRVIvZDVjYjM2ZXBI?=
 =?utf-8?B?L0xuVU9vS2VxMUZVTC9VaUlBd2VIVUh4SFRiZWFmV1crRklzbFp2R21hWW5m?=
 =?utf-8?B?YnhVQjh6ZVk2UFk5bDNDSE9BRFc3S2NVdkdQaWZRR0dVSjdHTlVmN3ZNUEdi?=
 =?utf-8?B?TjVYSWw2UFpjOFJ6cVZTWWpUdyswOFNFU0NCN1VvNEhmb3EzVzRKaS9jemdK?=
 =?utf-8?B?U1ZQSGp2NWZpYTJISkhXZzlnOTNxZFZ2WEZDNFRmeTZCcW8wcjhzRzJHTnQ5?=
 =?utf-8?B?K0g1RUtJNVZtclREeHZORVFvbUx6M0hiS3Q3UC9TMDFlRU5DUTRnU3RIa2JF?=
 =?utf-8?B?aWpubExpRFh5b2Rlbm9FS09QZTRvdWlTNHNYV3ZuYXFGQjdvLzJTWGx0dUdi?=
 =?utf-8?B?QVkxbjBjUGliUERraEJCWVJWc1Y3MVFPSUZQYzFvZWVDMk5FTEZLZkRQQVRy?=
 =?utf-8?B?eWs5alB6Z2xmTjRrYUhLcFFEeXpUN1pBUHptd2dwazFXckR4KzVLWklwWTNW?=
 =?utf-8?Q?d7+wgi8YDF0LeJ/VotCGU4CJg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4195b6f-5059-4460-a9c5-08db09ba28eb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 09:52:16.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zIHrKzkk6eUyDo4OXBRoMZKd6xJG/5Grop4uWMTdCR9/a1UFj+CfVFPlj+xXr0cBSHvSS7aGuf4LPJiyqv1DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4486
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2023 5:36 AM, Sean Christopherson wrote:
> On Tue, Jan 31, 2023, Sean Christopherson wrote:
>> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>>> @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>>>  	 * Otherwise, allow two (and we'll inject the first one immediately).
>>>  	 */
>>>  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
>>> -		limit = 1;
>>> +		limit--;
>>> +
>>> +	/* Also if there is already a NMI hardware queued to be injected,
>>> +	 * decrease the limit again
>>> +	 */
>>> +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
>>> +		limit--;
>>
>> I don't think this is correct.  If a vNMI is pending and NMIs are blocked, then
>> limit will end up '0' and KVM will fail to pend the additional NMI in software.
> 
> Scratch that, dropping the second NMI in this case is correct.  The "running" part
> of the existing "x86 is limited to one NMI running, and one NMI pending after it"
> confused me.  The "running" thing is really just a variant on NMIs being blocked.
> 
> I'd also like to avoid the double decrement logic.  Accounting the virtual NMI is
> a very different thing than dealing with concurrent NMIs, I'd prefer to reflect
> that in the code.
> 
> Any objection to folding in the below to end up with:
> 
> 	unsigned limit;
> 
> 	/*
> 	 * x86 is limited to one NMI pending, but because KVM can't react to
> 	 * incoming NMIs as quickly as bare metal, e.g. if the vCPU is
> 	 * scheduled out, KVM needs to play nice with two queued NMIs showing
> 	 * up at the same time.  To handle this scenario, allow two NMIs to be
> 	 * (temporarily) pending so long as NMIs are not blocked and KVM is not
> 	 * waiting for a previous NMI injection to complete (which effectively
> 	 * blocks NMIs).  KVM will immediately inject one of the two NMIs, and
> 	 * will request an NMI window to handle the second NMI.
> 	 */
> 	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
> 		limit = 1;
> 	else
> 		limit = 2;
> 
> 	/*
> 	 * Adjust the limit to account for pending virtual NMIs, which aren't
> 	 * tracked in in vcpu->arch.nmi_pending.
> 	 */
> 	if (static_call(kvm_x86_is_vnmi_pending)(vcpu))
> 		limit--;
> 
> 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
> 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
> 

I believe, you missed the function below hunk -

	if (vcpu->arch.nmi_pending &&
	    static_call(kvm_x86_set_vnmi_pending(vcpu)))
		vcpu->arch.nmi_pending--;

Or am I missing something.. please suggest.

> 	if (vcpu->arch.nmi_pending)
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 31 Jan 2023 16:02:21 -0800
> Subject: [PATCH] KVM: x86: Tweak the code and comment related to handling
>  concurrent NMIs
> 
> Tweak the code and comment that deals with concurrent NMIs to explicitly
> call out that x86 allows exactly one pending NMI, but that KVM needs to
> temporarily allow two pending NMIs in order to workaround the fact that
> the target vCPU cannot immediately recognize an incoming NMI, unlike bare
> metal.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 030136b6ebbd..fda09ba48b6b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10122,15 +10122,22 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
>  
>  static void process_nmi(struct kvm_vcpu *vcpu)
>  {
> -	unsigned limit = 2;
> +	unsigned limit;
>  
>  	/*
> -	 * x86 is limited to one NMI running, and one NMI pending after it.
> -	 * If an NMI is already in progress, limit further NMIs to just one.
> -	 * Otherwise, allow two (and we'll inject the first one immediately).
> +	 * x86 is limited to one NMI pending, but because KVM can't react to
> +	 * incoming NMIs as quickly as bare metal, e.g. if the vCPU is
> +	 * scheduled out, KVM needs to play nice with two queued NMIs showing
> +	 * up at the same time.  To handle this scenario, allow two NMIs to be
> +	 * (temporarily) pending so long as NMIs are not blocked and KVM is not
> +	 * waiting for a previous NMI injection to complete (which effectively
> +	 * blocks NMIs).  KVM will immediately inject one of the two NMIs, and
> +	 * will request an NMI window to handle the second NMI.
>  	 */
>  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
>  		limit = 1;
> +	else
> +		limit = 2;
>  
>  	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
>  	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
> 

Looks good to me, will include in v3.

Thanks,
Santosh

