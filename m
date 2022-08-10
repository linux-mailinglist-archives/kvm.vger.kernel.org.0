Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8782658F12F
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbiHJRG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiHJRG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:06:58 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9BF6BD68
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:06:56 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id e15so22182836lfs.0
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=DX8A9LAYPQaT+pDFj3ls7KEGaIFSLSAeaLaK317Ao4Y=;
        b=dWAJ0x7KbU1D9EqQwJ+QcUeMFOsk7dKilsQ+Eq+XO+nwqHSwecgVjePSdyA/a79klS
         0iRArOOQl0mo780NdQvgFPpnuy51whrHCVp9lCArKDl+/D8dzF7twXLlUCwS+DUiVc6s
         MJd63x/0xKYruxlgiHZGly2ZXdbzyjXbs8jj+J6Xd8ZDfnIkA0JPBMLpV7azBvtVRzA1
         KG3iVhLg3o/knyAjoygWc12bLfg5uW98VfnWbJB3Zia1jM0bR6V7596ERmmz7xjtwpsP
         KxvL8QSmoEWd1qMU+Tn8im6STY8310h4c4dmqZkrmrbSxkme7CCLf/ZFwb8T9wlXgDes
         rzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=DX8A9LAYPQaT+pDFj3ls7KEGaIFSLSAeaLaK317Ao4Y=;
        b=A+eHOeug40eRzyUK83H2iHo5oY0JP30zAdqams9m035FRbylXfKTQ+a85oZCEB8lub
         1I6wn66qoUR9MGRsmO4rjdCZa8KWJKBntqkeST4a74tysb5VRIeBAO6HCHA4mWmnWLaQ
         Mhot30gRUps0mk8PIBgXyk3718RAGa+34EYGCU4XwAi+j7XsAhYp7zPKKMDSPoe0dlQr
         Mw5J/BA/OFNr2L+rTYiInsBDBF8mUdYU5UUB1iRIsdGTr/slTXSlEaEYmPN8kzifUAkk
         JrgeLvr9oF4PBbqi4YlctK1e4ew33QdM9+fonrNpwwZHMunG40oramPKDxIXyifCgZh1
         S3Ew==
X-Gm-Message-State: ACgBeo1MFnVxBPnuJSImxnav6k3Qep+klJFB3u7311zBFPHVupzIq14j
        ZOt7NqtCcIpde4hgSO3Cm8fqiw==
X-Google-Smtp-Source: AA6agR6paR7zWoZBjwlcfxX6yOMVU9TJ1AW78NT+umn37ZM/ZsFvaCLMD0qNo5hM9yjRJtgiWWuXNg==
X-Received: by 2002:a05:6512:909:b0:48b:954c:8e23 with SMTP id e9-20020a056512090900b0048b954c8e23mr8448208lft.670.1660151215130;
        Wed, 10 Aug 2022 10:06:55 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id i15-20020a2ea36f000000b0025e57e62612sm456887ljn.103.2022.08.10.10.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 10:06:54 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
To:     Marc Zyngier <maz@kernel.org>
Cc:     "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
 <87o7wsbngz.wl-maz@kernel.org>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <3bdcda9f-ac2f-14df-2932-cf16912fe71b@semihalf.com>
Date:   Wed, 10 Aug 2022 19:06:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87o7wsbngz.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/10/22 8:51 AM, Marc Zyngier wrote:
> On Wed, 10 Aug 2022 00:30:29 +0100,
> Dmytro Maluka <dmy@semihalf.com> wrote:
>>
>> On 8/9/22 10:01 PM, Dong, Eddie wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>> Sent: Tuesday, August 9, 2022 12:24 AM
>>>> To: Dong, Eddie <eddie.dong@intel.com>; Christopherson,, Sean
>>>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>>>> kvm@vger.kernel.org
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>;
>>>> Borislav Petkov <bp@alien8.de>; Dave Hansen <dave.hansen@linux.intel.com>;
>>>> x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; linux-
>>>> kernel@vger.kernel.org; Eric Auger <eric.auger@redhat.com>; Alex
>>>> Williamson <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
>>>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>>>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>;
>>>> upstream@semihalf.com; Dmitry Torokhov <dtor@google.com>
>>>> Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
>>>>
>>>> On 8/9/22 1:26 AM, Dong, Eddie wrote:
>>>>>>
>>>>>> The existing KVM mechanism for forwarding of level-triggered
>>>>>> interrupts using resample eventfd doesn't work quite correctly in the
>>>>>> case of interrupts that are handled in a Linux guest as oneshot
>>>>>> interrupts (IRQF_ONESHOT). Such an interrupt is acked to the device
>>>>>> in its threaded irq handler, i.e. later than it is acked to the
>>>>>> interrupt controller (EOI at the end of hardirq), not earlier. The
>>>>>> existing KVM code doesn't take that into account, which results in
>>>>>> erroneous extra interrupts in the guest caused by premature re-assert of an
>>>> unacknowledged IRQ by the host.
>>>>>
>>>>> Interesting...  How it behaviors in native side?
>>>>
>>>> In native it behaves correctly, since Linux masks such a oneshot interrupt at the
>>>> beginning of hardirq, so that the EOI at the end of hardirq doesn't result in its
>>>> immediate re-assert, and then unmasks it later, after its threaded irq handler
>>>> completes.
>>>>
>>>> In handle_fasteoi_irq():
>>>>
>>>> 	if (desc->istate & IRQS_ONESHOT)
>>>> 		mask_irq(desc);
>>>>
>>>> 	handle_irq_event(desc);
>>>>
>>>> 	cond_unmask_eoi_irq(desc, chip);
>>>>
>>>>
>>>> and later in unmask_threaded_irq():
>>>>
>>>> 	unmask_irq(desc);
>>>>
>>>> I also mentioned that in patch #3 description:
>>>> "Linux keeps such interrupt masked until its threaded handler finishes, to
>>>> prevent the EOI from re-asserting an unacknowledged interrupt.
>>>
>>> That makes sense. Can you include the full story in cover letter too?
>>
>> Ok, I will.
>>
>>>
>>>
>>>> However, with KVM + vfio (or whatever is listening on the resamplefd) we don't
>>>> check that the interrupt is still masked in the guest at the moment of EOI.
>>>> Resamplefd is notified regardless, so vfio prematurely unmasks the host
>>>> physical IRQ, thus a new (unwanted) physical interrupt is generated in the host
>>>> and queued for injection to the guest."
> 
> Sorry to barge in pretty late in the conversation (just been Cc'd on
> this), but why shouldn't the resamplefd be notified? If there has been
> an EOI, a new level must be made visible to the guest interrupt
> controller, no matter what the state of the interrupt masking is.
> 
> Whether this new level is actually *presented* to a vCPU is another
> matter entirely, and is arguably a problem for the interrupt
> controller emulation.
> 
> For example on arm64, we expect to be able to read the pending state
> of an interrupt from the guest irrespective of the masking state of
> that interrupt. Any change to the interrupt flow should preserve this.

I'd like to understand the problem better, so could you please give some
examples of cases where it is required/useful/desirable to read the
correct pending state of a guest interrupt?

> 
> Thankfully, we don't have the polarity issue (there is no such thing
> in the GIC architecture) and we only deal with pending/not-pending.
> 
> Thanks,
> 
> 	M.
> 
