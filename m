Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75DC715939
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 10:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjE3I6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 04:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjE3I6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 04:58:04 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1403BE;
        Tue, 30 May 2023 01:57:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QljTL3N16dG+eJeAtB/HW4VTvM4zZMioiOgzhcN3HkJBgEak1fu7u5VSFuPhmmDdklFT0zOmK2w21LgYEaJXK/ZagO0RzRb1x4l/tPXRLH7ciZCQxKIQJjkXYpXpVY+8RQz758Hi3IV6JPViOtcjlOzGkouhjn2NOqMl+Pgyps9QbaCK9EJMIZ3FfFa/d3h7dQV0nhqr8PmKgeTZTJ6oVeUaqyuH8MT7UBLhDqLiYTxytbvT5nAoxhDod+vwTEJ5d4E+Y9IXns5rrgyOtL86G9MvnEG4T6MXPkISKW+ktzrtFpsS46t8jmN0tigN3br75STpMr0OBBjPdwys9fDTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYyHHvxYCJYCaHE18U+tDhHoHsReyPl/j7KGMuxwRGw=;
 b=UtMoG6RXVtdbjkDcEHxqh0OgDNzHEif5bA6wpaGqKx8WJUYlo5ZNMjKcJXVZB17m9Hma2XhwOoDQnEe07XOQF0ad2+aXEOAyJYZZeAnzNWTaENEmILjCzSznSk3V921wGY1x0iZPVCoylHWG4nXWaESmwVqDRB76XwY+BDhc4/w2rAYtemMUYhMUVktFkxKLKvjLQi4zJQJejzV6mT8zkQEJsQ8pwtdfiySwppzuGcTwTiDrkXTARInCI+vWFrqOpZi94WSKrGNWDHirqVdwRgw/ruLO1lTzvP/E3xblqj8frnw4bmNoSdbRb87xYw6YFKIDaoAh8n0SWIJKMDhSpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYyHHvxYCJYCaHE18U+tDhHoHsReyPl/j7KGMuxwRGw=;
 b=WZJYJowB4RDMN4NwqrTBkaerHTxAI+ienGm20vUhYpMTrwNeIx5mPK2rWmfKdoF/YMr1dNxdh1lqKVdJwzuJ4NqQ4WUKO9H3gwhphe67IO2iP0+J+jVoyHtfpAM5k27/KCNQ5qkzoHHekTnN6wPyYq0+cpfhBvDRgJpdvlucovs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 BN9PR12MB5035.namprd12.prod.outlook.com (2603:10b6:408:134::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.23; Tue, 30 May 2023 08:57:56 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 08:57:56 +0000
Message-ID: <64336829-60c5-afe1-81ad-91b4f354aef3@amd.com>
Date:   Tue, 30 May 2023 18:57:46 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
 <20230411125718.2297768-6-aik@amd.com> <ZGv9Td4p1vtXC0Hy@google.com>
 <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com> <ZGzfWQub4FQOrEtw@google.com>
 <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com> <ZHDEkuaVjs/0kM6t@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZHDEkuaVjs/0kM6t@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0134.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:209::19) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|BN9PR12MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: 4441ea8e-9a3d-4ee6-482d-08db60ebf55e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdkysryKo3h2hr5DBw4ixVRmsso4ZHZgmcK0LCtOt2glSH9RIncupn1eQV8CXaSJYmvK7abQDia5ed+ADLCwZtP784DiNCOUGhGk3BmJOENVzD+AgBkPWmjNhLqCxAhFKxefIPctSfTVgPy7cFG3ZJ5Q4LPFsLrk6OITS1g+xVMrkgqLnvE9t7nQe6RKxQDF7aLooYLL+KcmVy8AWBocNbmMFze6mWTVB3tBZ/6b8qoDqzKUhRFDfbMZ28s0so0usKz7aw2pK73ICffM0TAiEVMi9ivTXmuiVivoZQ0J0J7Rex+2CBXpb22ehNNccVL6nU4t2ERDm6LhdaCHRVTI2GPoewXLHTJFdDHqVA0ojfrHZMhVjQBHiITBPbZlK1reJTaU3IKNhpTgkb1fls2ezSqSUSyEfz9lsjL2zXTPA3aacfuPvu6noaKS5UaiJXWhPThfnlpRnSRhszx4CWnfAkx9usmmEMOSE4E9XjuaJTG7qq/QHjTzkUxT/NXNVWFr8UwDh+oPslD5WWV+hLD7dEFM63Q9jlm1N7oNdXVoupgQBHnXz6A8wPSPF43UG+BcyFcZjmTumcfXUHsqiAlZdpHr/3UbEcfgUALg+j5fKc9uuwA7R3p2S4ZUTpBanaXK9vgr0Co4HX2ZWak2Fw/1mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(451199021)(2906002)(186003)(31686004)(53546011)(6512007)(6506007)(26005)(5660300002)(8936002)(54906003)(8676002)(38100700002)(83380400001)(2616005)(6486002)(31696002)(41300700001)(316002)(66946007)(6666004)(4326008)(36756003)(66476007)(66556008)(6916009)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0ZmUElzQTNORkw5MGpyczVmblNhcDlydEhPemlmSVhQNDRUUjVtZWp1RmdP?=
 =?utf-8?B?MnJpWjlzTjI4Z25FOHE1NFdhR0xrYm91RHlZcHkyNEZBaUkzSkxZL29sYmRt?=
 =?utf-8?B?eEk4RnE4elFwcVRnR1c5YTFOdk1hTER2YWc5dG9XNGs5QnhzYW14cG1WZGN2?=
 =?utf-8?B?aUpvN1RlTDFBVmZ6WmRBaWZhRGpWcTVLTEJnQnB0MTBQVHNNeXhVQVFxY3pN?=
 =?utf-8?B?UjZYMHVFL3BXRGtiQXQ2eDRjc3B1Qjl2SEFCMGVRdkJWL2cwa242cDJCS3py?=
 =?utf-8?B?blJDUi9ZK1ZwaElZTmkycDdUQm1uUHZjWGtVTG51clVaaUdGOVlBR3BLYjgr?=
 =?utf-8?B?N1JWK200Ry8zUDBIZWlNWFhITUpEeXJ6dzRub01qZ1pDRVVYSVlVVHM5V3RK?=
 =?utf-8?B?a3FNSlkxTW9qRG1tR2VzazdvQnNHcjhIWm9heFE2ZmRNOHVsekM0L1k2dC9P?=
 =?utf-8?B?RmRWMTl2dzg5bnJ1aWJyWXpVbHJaR2tHZVVrU3NsRWlITlpLRGJlRzRFZllp?=
 =?utf-8?B?NEZqOHE2TGJlNXIwYk1lMjFzY1pzSll4L0g2NWpTdlJoQ1JzTVZSRWkreHU3?=
 =?utf-8?B?NWZzaWp4aWhrRFJWNEFxbUkwZjdjeTNSa2VQbXoxaUZCb3JNOWYwTE8xRFRl?=
 =?utf-8?B?TS9LQy9nbHQzcjNwdXRBN3k2N1NodnQyanpZaUJ0bXhZTytIK0pGVDJTVkRj?=
 =?utf-8?B?S1lQT0VNSGRGTis0Nk10TDBMZ0pRUjZEN1BRVmoxb3crYlNabXc2ZHlNMVRY?=
 =?utf-8?B?MHpZek5FcmY2UVZjaHVMQ2JvbUd2OVoyZnpUeXZqTEtLZm13QjJ2N09OdUtl?=
 =?utf-8?B?b0RCeUZ6a2Y0SmN3ZUlFb01BZW9TQ2psajJIeWJoYm5xMjNFZFBZdHNzRWJX?=
 =?utf-8?B?dEJacXRYRTBERHpOYTNDSzBBMTJVU3hsZnNRU1lSaVB6clpJT25GYmZKNktU?=
 =?utf-8?B?S05xSklRRWJqeHpyaXlhM1ZyUWhYbDZMTVJkWlZxWU1lM3dsY01ZTWpubjU4?=
 =?utf-8?B?YUxFb2pEdjh0U2tMUElQYXFrV2FUc0s4NFJqYjNld2xuNk4wMDBDN3BRTy9Y?=
 =?utf-8?B?YmhmcXM0RWVRa1dWeHV1TUs4a1h0YTZURTcwVjJlNklvbjZXcXgvZTBLOGpG?=
 =?utf-8?B?NnRXclgvemhuVlo2OWRLeHNEV2M5RDArbCt1ZUpvN2pQZGl1ZU9BSVZwQmlW?=
 =?utf-8?B?Y2N5ZHh1U1FRbllDRldSQVZlVENuRDcwRTFRWjErL1l2b1B3dmY5bnp4RHpN?=
 =?utf-8?B?TDFEdkxXTC9jOXppZU5pamM0a1d1ZmczQndxU1pTbVFRM3lCcnhTN3lZSCt6?=
 =?utf-8?B?THNWOXNqYXhTNTNDS3ZPU0VZd0sxdG40b0Y1MmE0UlJYaDBaY2xyMUFMZVZu?=
 =?utf-8?B?Wjd3UWI2MDlqR1BrdDNwWkFqa2VKVlVyekozWHl4T1liN0h0dFIrSUlTbUd3?=
 =?utf-8?B?cDlTMFU5VUkxQmw0MlFiQnNrS1pENXlldEJObHJDU0t3S09XTG5wekVwMGlI?=
 =?utf-8?B?ZTQ0T0hKK1RRdll3WWNGUEZQbVp4cXlheEJYbVhxWEJSYnE0dzNPY3BYSVd4?=
 =?utf-8?B?ejdyREpKQzBUdlhLOXRQUHIrS0RERnpBZC9RckRBemgyVjVOVTFUaEh3N09z?=
 =?utf-8?B?c25jSWYyZzd2Y3JGWEtNRkJYelJJSnZ2M0hOcElxaUN5NlljQXJqMTZhUTdI?=
 =?utf-8?B?VzVwVHErcGpSdFhFQnF0bnZtSkh6ODZ4N3dwNUtkNDNMc0k3TFNaZy9kMWdk?=
 =?utf-8?B?L2IvZ0NaK21lZjA0V0lGZldITXh6NlhoNThacUgwOE9peWdPMFpDQjlOWlhn?=
 =?utf-8?B?b1EvZjVaQlZRWDdIdHdiMHV2Y3NkeXBFd0U0WENweEhUU0NENE1aQy9sVDVm?=
 =?utf-8?B?RUNyTE9qTDFHRzg0Wm1DTWdleU5qVnIvbDV2M2JLQS9PUmRiMis0UUx0amlI?=
 =?utf-8?B?THpMQVpKWFUvSlhHRHI4VUc3MUtjN2loclRqNVJ4MG56NjNvUTUrYUFJVWpt?=
 =?utf-8?B?b2hGVDJ2RmdVSmdkMDRRY1c0Ui9DODBUVzd3WlFPK0NCd2ljUGJKTXBLUlBB?=
 =?utf-8?B?RnVSdlFHZ1dYQ0k1a0tZWmxMZG5ybHg1dGs0Q3JKS2NkbFEyZ0hnN25iRkta?=
 =?utf-8?Q?ynuz/xslo3VesWYAKnrfdS3pE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4441ea8e-9a3d-4ee6-482d-08db60ebf55e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 08:57:55.6282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un1L9ub+qvApqMSvdiD+XIRPkYUgtDn8czJc9z1ldock1oLK7aXArVRRB2978tdO4qGMsqwn0VFTTrf8JJb27g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5035
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/5/23 00:39, Sean Christopherson wrote:
> On Fri, May 26, 2023, Alexey Kardashevskiy wrote:
>>
>> On 24/5/23 01:44, Sean Christopherson wrote:
>>> On Tue, May 23, 2023, Alexey Kardashevskiy wrote:
>>>>> Actually, can't disabling #DB interception for DebugSwap SEV-ES guests be a
>>>>> separate patch?  KVM can still inject #DBs for SEV-ES guests, no?
>>>>
>>>> Sorry for my ignorance but what is the point of injecting #DB if there is no
>>>> way of changing the guest's DR7?
>>>
>>> Well, _injecting_ the #DB is necessary for correctness from the guest's perspective.
>>> "What's the point of _intercepting_ #DB" is the real question.  And for SEV-ES guests
>>> with DebugSwap, there is no point, which is why I agree that KVM should disable
>>> interception in that case.  What I'm calling out is that disabling #Db interception
>>> isn't _necessary_ for correctness (unless I'm missing something), which means that
>>> it can and should go in a separate patch.
>>
>>
>> About this. Instead of sev_es_init_vmcb(), I can toggle the #DB intercept
>> when toggling guest_debug, see below. This
>> kvm_x86_ops::update_exception_bitmap hook is called on vcpu reset and
>> kvm_arch_vcpu_ioctl_set_guest_debug (which skips this call if
>> guest_state_protected = true).
> 
> KVM also intercepts #DB when single-stepping over IRET to find an NMI window, so
> you'd also have to factor in nmi_singlestep, and update svm_enable_nmi_window()
> and disable_nmi_singlestep() to call svm_update_exception_bitmap().

Uff. New can of worms for me :-/


>> Is there any downside?
> 
> Complexity is the main one.  The complexity is quite low, but the benefit to the
> guest is likely even lower.  A #DB in the guest isn't likely to be performance
> sensitive.  And on the flip side, opening an NMI window would be a tiny bit more
> expensive, though I doubt that would be meaningful either.
> 
> All in all, I think it makes sense to just keep intercepting #DB for non-SEV-ES
> guests.
> 
> Side topic, isn't there an existing bug regarding SEV-ES NMI windows?  KVM can't
> actually single-step an SEV-ES guest, but tries to set RFLAGS.TF anyways. 

Why is it a "bug" and what does the patch fix? Sound to me as it is 
pointless and the guest won't do single stepping and instead will run 
till it exits somehow, what do I miss?

> Blech,
> and suppressing EFER.SVME in efer_trap() is a bit gross,

Why suppressed? svm_set_efer() sets it eventually anyway.

> but I suppose since the
> GHCB doesn't allow for CLGI or STGI it's "fine".

GHCB does not mention this, instead these are always intercepted in 
init_vmcb().

> E.g. shouldn't KVM do this?

It sure can and I am happy to include this into the series, the commit 
log is what I am struggling with :)

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ca32389f3c36..4e4a49031efe 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3784,6 +3784,16 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>          if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
>                  return; /* IRET will cause a vm exit */
>   
> +       /*
> +        * KVM can't single-step SEV-ES guests and instead assumes that IRET
> +        * in the guest will always succeed, 

It relies on GHCB's NMI_COMPLETE (which SVM than handles is it was IRET):

         case SVM_VMGEXIT_NMI_COMPLETE:
                 ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
                 break;


> i.e. clears NMI masking on the
> +        * next VM-Exit.  Note, GIF is guaranteed to be '1' for SEV-ES guests
> +        * as the GHCB doesn't allow for CLGI or STGI (and KVM suppresses
> +        * EFER.SVME for good measure, see efer_trap()).

SVM KVM seems to not enforce EFER.SVME, the guest does what it wants and 
KVM is only told the new value via EFER_WRITE_TRAP. And "writes by 
SEV-ES guests to EFER.SVME are always ignored by hardware" says the APM. 
I must be missing the point here...


> +        */
> +       if (sev_es_guest(vcpu->kvm))
> +               return;
> +
>          if (!gif_set(svm)) {
>                  if (vgif)
>                          svm_set_intercept(svm, INTERCEPT_STGI);

-- 
Alexey
