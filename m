Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD74591A71
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 15:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbiHMNAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 09:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiHMM77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 08:59:59 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFFE18B3E
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 05:59:57 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a9so4570064lfm.12
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 05:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:from:subject:from:to:cc;
        bh=L8ziXu9ly+3MKHOH5iXA6dPwA1N0Xha9BKWeK2g5xtU=;
        b=K8SaeVXbKxuYQHR4FmCnGECTcRdJgi+k2T2G/YdCKm7uIk9Z3VdzB7+TblGp6AiLKz
         HeZwSHvZGwkMKlCxFL4eLkm+DYfZeVxmajHew+10wwiK7Zbcpjjk5ww7L6CSFoHdX5m6
         97pKSAsNsAXTnIxorRaJBOjy9RgZRXUXM6qhqWWiRyrhZXibBQDPlwTUHJZk/ZaD2UXW
         yyFJle+AjnEujcXmzOWQWQd+un+UjYsPyb4Xou7E1ZcSAg7OnZvlc1nR9Gmgf2gTM4LC
         QvtLTl87i5x2edH6Y9qxm4C/KSIevKuyY8//7+KchnYUDL34oxR3xl+IsoIdmDhA7TbP
         PwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:from:subject
         :x-gm-message-state:from:to:cc;
        bh=L8ziXu9ly+3MKHOH5iXA6dPwA1N0Xha9BKWeK2g5xtU=;
        b=EOgjizpSOZECsunLyF4xrvrQydrUOvw8NZtT/ZjDZG61gXx2cEVmOfmcYzzX6RPr7B
         tvXb7nJY+ymL5479RIxY4lTioKONjLNW8Jy76iLq0u6YJ30VYuanEinKljdNbtMYnPbB
         k0tu4Mf6l/p959T6ep/S2tfgtMOpcOy4rIy69poaYr09SO1Bc2Zr0ZAko+K0fWSNowD7
         e54rG0EJzYsyfuQCBNd+JMw8y7DYXdkDbLvUAxcQdo9pN2F68odVi6loIrY50RFS84Wk
         TqyAa9nCyDEiuIzeRb0eOkFDaOZe6RKDM8QEySf1SZCScZutr8rLxfjgC31Uzb99j5jX
         /Q0g==
X-Gm-Message-State: ACgBeo0GbHRGZNdzV1B3OmGjPokl6U0PTepfnbiMzlyL0mlQLHH5mRjj
        msFaCVH1fFpycsxQNkFzIC9SAg==
X-Google-Smtp-Source: AA6agR6aqkCie2vHhZ0d3yeFwbLke0SsLqhiO4mB55AyWadTf7J+w0xSgvEPTzfd/6F2+CzXnLh2Bw==
X-Received: by 2002:a05:6512:12c9:b0:48b:3e0f:7a79 with SMTP id p9-20020a05651212c900b0048b3e0f7a79mr2823807lfg.52.1660395596065;
        Sat, 13 Aug 2022 05:59:56 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id s12-20020a05651c048c00b0025e4ed638dcsm751464ljc.59.2022.08.13.05.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Aug 2022 05:59:55 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger@redhat.com, "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
 <8ff76b5e-ae28-70c8-2ec5-01662874fb15@redhat.com>
 <87r11ouu9y.wl-maz@kernel.org>
 <72e40c17-e5cd-1ffd-9a38-00b47e1cbd8e@semihalf.com>
 <87o7wrug0w.wl-maz@kernel.org>
 <6fef98a0-4cb4-1308-71ba-80a4089c944a@semihalf.com>
Message-ID: <e2fea599-9079-59f5-2cdd-26aa018b6633@semihalf.com>
Date:   Sat, 13 Aug 2022 14:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <6fef98a0-4cb4-1308-71ba-80a4089c944a@semihalf.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/22 3:54 PM, Dmytro Maluka wrote:
> Hi Marc,
> 
> On 8/11/22 14:21, Marc Zyngier wrote:
>> Hi Dmytro,
>>
>> On Wed, 10 Aug 2022 18:02:29 +0100,
>> Dmytro Maluka <dmy@semihalf.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On 8/10/22 3:01 PM, Marc Zyngier wrote:
>>>> On Wed, 10 Aug 2022 09:12:18 +0100,
>>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>>>
>>>>> Hi Marc,
>>>>>
>>>>> On 8/10/22 08:51, Marc Zyngier wrote:
>>>>>> On Wed, 10 Aug 2022 00:30:29 +0100,
>>>>>> Dmytro Maluka <dmy@semihalf.com> wrote:
>>>>>>> On 8/9/22 10:01 PM, Dong, Eddie wrote:
>>>>>>>>
>>>>>>>>> -----Original Message-----
>>>>>>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>>>>>>> Sent: Tuesday, August 9, 2022 12:24 AM
>>>>>>>>> To: Dong, Eddie <eddie.dong@intel.com>; Christopherson,, Sean
>>>>>>>>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>>>>>>>>> kvm@vger.kernel.org
>>>>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>;
>>>>>>>>> Borislav Petkov <bp@alien8.de>; Dave Hansen <dave.hansen@linux.intel.com>;
>>>>>>>>> x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; linux-
>>>>>>>>> kernel@vger.kernel.org; Eric Auger <eric.auger@redhat.com>; Alex
>>>>>>>>> Williamson <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
>>>>>>>>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>>>>>>>>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>;
>>>>>>>>> upstream@semihalf.com; Dmitry Torokhov <dtor@google.com>
>>>>>>>>> Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
>>>>>>>>>
>>>>>>>>> On 8/9/22 1:26 AM, Dong, Eddie wrote:
>>>>>>>>>>> The existing KVM mechanism for forwarding of level-triggered
>>>>>>>>>>> interrupts using resample eventfd doesn't work quite correctly in the
>>>>>>>>>>> case of interrupts that are handled in a Linux guest as oneshot
>>>>>>>>>>> interrupts (IRQF_ONESHOT). Such an interrupt is acked to the device
>>>>>>>>>>> in its threaded irq handler, i.e. later than it is acked to the
>>>>>>>>>>> interrupt controller (EOI at the end of hardirq), not earlier. The
>>>>>>>>>>> existing KVM code doesn't take that into account, which results in
>>>>>>>>>>> erroneous extra interrupts in the guest caused by premature re-assert of an
>>>>>>>>> unacknowledged IRQ by the host.
>>>>>>>>>> Interesting...  How it behaviors in native side?
>>>>>>>>> In native it behaves correctly, since Linux masks such a oneshot interrupt at the
>>>>>>>>> beginning of hardirq, so that the EOI at the end of hardirq doesn't result in its
>>>>>>>>> immediate re-assert, and then unmasks it later, after its threaded irq handler
>>>>>>>>> completes.
>>>>>>>>>
>>>>>>>>> In handle_fasteoi_irq():
>>>>>>>>>
>>>>>>>>> 	if (desc->istate & IRQS_ONESHOT)
>>>>>>>>> 		mask_irq(desc);
>>>>>>>>>
>>>>>>>>> 	handle_irq_event(desc);
>>>>>>>>>
>>>>>>>>> 	cond_unmask_eoi_irq(desc, chip);
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> and later in unmask_threaded_irq():
>>>>>>>>>
>>>>>>>>> 	unmask_irq(desc);
>>>>>>>>>
>>>>>>>>> I also mentioned that in patch #3 description:
>>>>>>>>> "Linux keeps such interrupt masked until its threaded handler finishes, to
>>>>>>>>> prevent the EOI from re-asserting an unacknowledged interrupt.
>>>>>>>> That makes sense. Can you include the full story in cover letter too?
>>>>>>> Ok, I will.
>>>>>>>
>>>>>>>>
>>>>>>>>> However, with KVM + vfio (or whatever is listening on the resamplefd) we don't
>>>>>>>>> check that the interrupt is still masked in the guest at the moment of EOI.
>>>>>>>>> Resamplefd is notified regardless, so vfio prematurely unmasks the host
>>>>>>>>> physical IRQ, thus a new (unwanted) physical interrupt is generated in the host
>>>>>>>>> and queued for injection to the guest."
>>>>>> Sorry to barge in pretty late in the conversation (just been Cc'd on
>>>>>> this), but why shouldn't the resamplefd be notified? If there has been
>>>>> yeah sorry to get you involved here ;-)
>>>>
>>>> No problem!
>>>>
>>>>>> an EOI, a new level must be made visible to the guest interrupt
>>>>>> controller, no matter what the state of the interrupt masking is.
>>>>>>
>>>>>> Whether this new level is actually *presented* to a vCPU is another
>>>>>> matter entirely, and is arguably a problem for the interrupt
>>>>>> controller emulation.
>>>>>
>>>>> FWIU on guest EOI the physical line is still asserted so the pIRQ is
>>>>> immediatly re-sampled by the interrupt controller (because the
>>>>> resamplefd unmasked the physical IRQ) and recorded as a guest IRQ
>>>>> (although it is masked at guest level). When the guest actually unmasks
>>>>> the vIRQ we do not get a chance to re-evaluate the physical line level.
>>>>
>>>> Indeed, and maybe this is what should be fixed instead of moving the
>>>> resampling point around (I was suggesting something along these lines
>>>> in [1]).
>>>>
>>>> We already do this on arm64 for the timer, and it should be easy
>>>> enough it generalise to any interrupt backed by the GIC (there is an
>>>> in-kernel API to sample the pending state). No idea how that translate
>>>> for other architectures though.
>>>
>>> Actually I'm now thinking about changing the behavior implemented in my
>>> patchset, which is:
>>>
>>>     1. If vEOI happens for a masked vIRQ, don't notify resamplefd, so
>>>        that no new physical IRQ is generated, and the vIRQ is not set as
>>>        pending.
>>>
>>>     2. After this vIRQ is unmasked by the guest, notify resamplefd.
>>>
>>> to the following one:
>>>
>>>     1. If vEOI happens for a masked vIRQ, notify resamplefd as usual,
>>>        but also remember this vIRQ as, let's call it, "pending oneshot".
>>>
>>>     2. A new physical IRQ is immediately generated, so the vIRQ is
>>>        properly set as pending.
>>>
>>>     3. After the vIRQ is unmasked by the guest, check and find out that
>>>        it is not just pending but also "pending oneshot", so don't
>>>        deliver it to a vCPU. Instead, immediately notify resamplefd once
>>>        again.
>>>
>>> In other words, don't avoid extra physical interrupts in the host
>>> (rather, use those extra interrupts for properly updating the pending
>>> state of the vIRQ) but avoid propagating those extra interrupts to the
>>> guest.
>>>
>>> Does this sound reasonable to you?
>>
>> It does. I'm a bit concerned about the extra state (more state, more
>> problems...), but let's see the implementation.
>>
>>> Your suggestion to sample the pending state of the physical IRQ sounds
>>> interesting too. But as you said, it's yet to be checked how feasible it
>>> would be on architectures other than arm64. Also it assumes that the IRQ
>>> in question is a forwarded physical interrupt, while I can imagine that
>>> KVM's resamplefd could in principle also be useful for implementing
>>> purely emulated interrupts.
>>
>> No, there is no requirement for this being a forwarded interrupt. The
>> vgic code does that for forwarded interrupts, but the core code could
>> do that too if the information is available (irq_get_irqchip_state()
>> was introduced for this exact purpose).
> 
> I meant "forwarding" in a generic sense, not vgic specific. I.e. the
> forwarding itself may be done generically by software, e.g. by vfio, but
> the source is in any case a physical HW interrupt.
> 
> Whereas I have in mind also cases where an irqfd user injects purely
> virtual interrupts, not coming from HW. I don't know any particular use
> case for that, but irqfd doesn't seem to prohibit such use cases. So I
> was thinking that maybe it's better to keep it this way, i.e. not depend
> on reading physical HW state in KVM. Or am I trying to be too generic here?

Aren't for example Virtio interrupts a real existing use case for that
(KVM irqfd used for completely virtual interrupts not coming from HW)?

Perhaps this itself is not a problem. I guess that for sampling physical
IRQ state we'd need to extend KVM_IRQFD ioctl interface anyway, to
provide KVM with the information about the host IRQ number, at least. So
we then could also tell KVM that there is no host IRQ at all, i.e. the
given IRQ is a pure virtual interrupt like virtio, so that KVM would not
use physical sampling in this case.

> 
>>
>>> Do you see any advantages of sampling the physical IRQ pending state
>>> over remembering the "pending oneshot" state as described above?
>>
>> The advantage is to not maintain some extra state, as this is usually
>> a source of problem, but to get to the source (the HW pending state).
>>
>> It also solves the "pending in the vgic but not pending in the HW"
>> problem, as reading the pending state causes an exit (the register is
>> emulated), and as part of the exit handling we already perform the
>> resample. We just need to extend this to check the HW state, and
>> correct the pending state if required, making sure that the emulation
>> will return an accurate view.
> 
> BTW, it seems that besides this "pending in the guest but not in the
> host" issue, we also already have an opposite issue ("pending in the
> host but not in the guest"): upon the guest EOI, we unconditionally
> deassert the vIRQ in irqfd_resampler_ack() before notifying resamplefd,
> even if the pIRQ is still asserted. So there is a time window (before
> the new pIRQ trigger event makes it to KVM) when the IRQ may be pending
> in the host but not in the guest.
> 
> Am I right that this is actually an issue, and that sampling the
> physical state could help with this issue too?

So perhaps there is another possibility (to avoid this particular issue,
as we don't implement physical sampling yet): postpone notifying
resamplefd like in this patch series, but also postpone changing the
vIRQ state from pending to not pending. I'm not sure it's a better
option though.
