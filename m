Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEA1304364
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392664AbhAZQHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:07:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404975AbhAZQGq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 11:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611677116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEQfPLsHSFOxcHdfgd8bewwTq6eNKdhpA5i/HTtlolg=;
        b=LWvz5lzWKm72ARXDQYcAYEgjNTBBKYcbV7GkqmqWtb2rlMxRqFaTJ1jsdpdSVh+sid4E+1
        pjuAEgdaqS7+CYXDCCec1aycO9hxeK4MasnA7F8CSb3WVaJfxviVTXe2bVnZPuuqQSncC+
        5YKt5lREdNSZWnUcTb82MjdhWsCV3Io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-dquvUilNP2aiunmsG6Iz6Q-1; Tue, 26 Jan 2021 11:05:11 -0500
X-MC-Unique: dquvUilNP2aiunmsG6Iz6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98080107ACF6;
        Tue, 26 Jan 2021 16:05:10 +0000 (UTC)
Received: from [10.36.113.217] (ovpn-113-217.ams2.redhat.com [10.36.113.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B4115D9DC;
        Tue, 26 Jan 2021 16:05:05 +0000 (UTC)
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
To:     Micah Morton <mortonm@chromium.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <184709d7-03f6-c03d-9afa-c780c4867c18@redhat.com>
 <CAJ-EccOXPAvNmjjqSaraJS1pdi2PuJAbR2=jie6kR6guziVmAA@mail.gmail.com>
 <19315ba9-045e-b05b-6aae-6a3831ae72ed@redhat.com>
 <CAJ-EccPRNfW3hkqoP7Cy-FhHKB9-jJ2ijXEoHVq=jdzKpMFu9A@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <781d30a1-1f2a-9a1d-3426-01ed6ec7ae14@redhat.com>
Date:   Tue, 26 Jan 2021 17:05:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAJ-EccPRNfW3hkqoP7Cy-FhHKB9-jJ2ijXEoHVq=jdzKpMFu9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Micah,

On 1/26/21 4:31 PM, Micah Morton wrote:
> On Tue, Jan 26, 2021 at 3:48 AM Auger Eric <eric.auger@redhat.com> wrote:
>>
>> Hi Micah,
>>
>> On 1/25/21 7:32 PM, Micah Morton wrote:
>>> On Mon, Jan 25, 2021 at 12:31 PM Auger Eric <eric.auger@redhat.com> wrote:
>>>>
>>>> Hi Micah,
>>>>
>>>> On 1/25/21 4:46 PM, Micah Morton wrote:
>>>>> Hi Eric,
>>>>>
>>>>> I was recently looking into some vfio-platform passthrough stuff and
>>>>> came across a device I wanted to assign to a guest that uses a ONESHOT
>>>>> type interrupt (these type of interrupts seem to be quite common, on
>>>>> ARM at least). The semantics for ONESHOT interrupts are a bit
>>>>> different from regular level triggered interrupts as I'll describe
>>>>> here:
>>>>>
>>>>> The normal generic code flow for level-triggered interrupts is as follows:
>>>>>
>>>>> - regular type[1]: mask[2] the irq, then run the handler, then
>>>>> unmask[3] the irq and done
>>>>
>>>> VFIO level sensitive interrupts are "automasked". See slide 10 of
>>>> https://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf if this can help.
>>>
>>> When you say "automasked" / "mask and deactivate" are you referring to
>>> the disable_irq_nosync() call in vfio_platform
>>> (https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L154)?
>> Yes that's what I meant
>>>
>>>>
>>>> When the guest deactivates the virtual IRQ, this causes a maintenance
>>>> interrupt on host. This occurence causes kvm_notify_acked_irq() to be
>>>> called and this latter unmasks the physical IRQ.
>>>
>>> Are you saying kvm_notify_acked_irq() causes
>>> vfio_platform_unmask_handler()
>>> (https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L94)
>>> to be called? Makes sense if so.
>> Yes this ends up calling irqfd_resampler_ack which toggles the virtual
>> irq line down and calls the unmask eventfd
>>>
>>>>>
>>>>> - fasteoi type[4]: run the handler, then eoi[5] the irq and done
>>>>>
>>>>> Note: IIUC the fasteoi type doesn't do any irq masking/unmasking
>>>>> because that is assumed to be handled transparently by "modern forms
>>>>> of interrupt handlers, which handle the flow details in hardware"
>>>>>
>>>>> ONESHOT type interrupts are a special case of the fasteoi type
>>>>> described above. They rely on the driver registering a threaded
>>>>> handler for the interrupt and assume the irq line will remain masked
>>>>> until the threaded handler completes, at which time the line will be
>>>>> unmasked. TL;DR:
>>>>>
>>>>> - mask[6] the irq, run the handler, and potentially eoi[7] the irq,
>>>>> then unmask[8] later when the threaded handler has finished running.
>>>>
>>>> could you point me to the exact linux handler (is it
>>>> handle_fasteoi_irq?)  or Why do you say "potentially". Given the details
>>>> above, the guest EOI would unmask the IRQ at physical level. We do not
>>>> have any hook KVM/VFIO on the guest unmap.
>>>
>>> Yep. handle_fasteoi_irq(). By "potentially" I just meant the eoi is
>>> only called for ONESHOT irqs if this check passes: !(chip->flags &
>>> IRQCHIP_EOI_THREADED). Not actually sure what this check is about
>>> since I didn't look into it.
>> I checked IRQCHIP_EOI_THREADED and it does not seem to be supported by
>> GIC irqchip. so this would mean that the EOI is not called in our case?
> 
> Sounds like it, thanks for looking into that.
> 
>>
>>>
>>> So far I was just talking about irq operations that happen in the
>>> host. Not sure I quite understand your last two sentences about guest
>>> EOI and guest unmap.
>> sorry I meant unmask instead of unmap :-( The closure of the physical
>> IRQ is triggered by the deactivation of the guest virtual IRQ.
>> Let's first assume you keep the existing "auto-masked" level sensitive
>> IRQ on host side (vfio platform driver), on the guest driver side you
>> are going to have a oneshot IRQ. What needs to be understood is when
>> does the deactivation happen on guest side.
> 
> That's a good question, I need to go back and look at that.
> 
>>>
>>>>>
>>>>> For vfio-platform irq forwarding, there is no existing function in
>>>>> drivers/vfio/platform/vfio_platform_irq.c[9] that is a good candidate
>>>>> for registering as the threaded handler for a ONESHOT interrupt in the
>>>>> case we want to request the ONESHOT irq with
>>>>> request_threaded_irq()[10]. Moreover, we can't just register a
>>>>> threaded function that simply immediately returns IRQ_HANDLED (as is
>>>>> done in vfio_irq_handler()[11] and vfio_automasked_irq_handler()[12]),
>>>>> since that would cause the IRQ to be unmasked[13] immediately, before
>>>> sorry I know you reworked that several times for style issue but [13]
>>>> does not match unmask().
>>>
>>> That's actually the link I intended, irq_finalize_oneshot() will be
>>> called after the threaded interrupt handler returns, and that's when
>>> the IRQ will be unmasked.
>> Hum this points to something within irq_thread_check_affinity(). Anyway.
> 
> Sorry I was pointing the URL at a specific line in
> irq_finalize_oneshot() but it was probably confusing.
> https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L984
> is the function I'm talking about.
> 
>>>
>>>>> the userspace/guest driver has had any chance to service the
>>>>> interrupt.
>>>>>
>>>>> The most obvious way I see to handle this is to add a threaded handler
>>>>> to vfio_platform_irq.c that waits until the userspace/guest driver has
>>>>> serviced the interrupt and the unmask_handler[14] has been called, at
>>>>> which point it returns IRQ_HANDLED so the generic IRQ code in the host
>>>>> can finally unmask the interrupt.
>>>> this is done on guest EOI at the moment.
>>>
>>> By "this", I think you mean enable_irq() in vfio_platform_irq.c?
>> right
>>>
>>>>>
>>>>> Does this sound like a reasonable approach and something you would be
>>>>> fine with adding to vfio-platform?
>>>> Well I think it is interesting to do a pre-study and make sure we agree
>>>> on the terminology, IRQ flow and problems that would need to be solved.
>>>> Then we need to determine if it is worth the candle, if this support
>>>> would speed up the vfio-platform usage (I am not sure at this point as I
>>>> think there are more important drags like the lack of specification/dt
>>>> integration for instance).
>>>>
>>>> Besides we need to make sure we are not launching into a huge effort for
>>>> attempting to assign a device that does not fit well into the vfio
>>>> platform scope (dma capable, reset, device tree).
>>>
>>> Yes, agreed.
>>>
>>>>
>>>>  If so I could get started looking
>>>>> at the implementation for how to sleep in the threaded handler in
>>>>> vfio-platform until the unmask_handler is called. The most tricky/ugly
>>>>> part of this is that DT has no knowledge of irq ONESHOT-ness, as it
>>>>> only contains info regarding active-low vs active-high and edge vs
>>>>> level trigger. That means that vfio-platform can't figure out that a
>>>>> device uses a ONESHOT irq in a similar way to how it queries[15] the
>>>>> trigger type, and by extension QEMU can't learn this information
>>>>> through the VFIO_DEVICE_GET_IRQ_INFO ioctl, but must have another way
>>>>> of knowing (i.e. command line option to QEMU).
>>>> Indeed that's not really appealing.
>>>>>
>>>>> I guess potentially another option would be to treat ONESHOT
>>>>> interrupts like regular level triggered interrupts from the
>>>>> perspective of vfio-platform, but somehow ensure the interrupt stays
>>>>> masked during injection to the guest, rather than just disabled.
>>>> I need this to be clarified actually. I am confused by the automasked
>>>> terminology now.
>>>
>>> My note below tries to explain a bit but AFAICT there's some confusion
>>> in the VFIO code (both platform and PCI) mixing the IRQ terms
>>> mask/unmask with disable/enable, which I think are not quite
>>> interchangeable concepts. IIUC irq enable/disable is a high(er) level
>>> concept that means that even if the irqchip HW sees interrupts coming
>>> in, the kernel refrains from calling the interrupt handler for the IRQ
>>> -- but the kernel keeps track of interrupts that come in while an IRQ
>>> is disabled, in order to know (once the IRQ gets enabled again by the
>>> driver) that there are pending interrupts from the HW. On the other
>>> hand, IRQ masking is a lower level irqchip operation that truly masks
>>> the IRQs at the hardware level, so the kernel doesn't even know or
>>> care if the line is being activated/deactivated while the IRQ is
>>> masked.
>>
>> Looking again at the genirq code, irq/chip.c __irq_disable, actual
>> implementation at HW level depends on the irqchip caps. GIC does not
>> implement the irq_enable() cb so this ends up calling mask_irq which
>> eventually calls gic_mask_irq and toggles the enable state for the given
>> IRQ.
> 
> Are you talking about the lazy disable approach
> (https://elixir.bootlin.com/linux/v5.10.10/source/kernel/irq/chip.c#L371)?
> Sounds like you're implying IRQ_DISABLE_UNLAZY will be true for the
> irq when we're doing VFIO forwarding? Or else we would see an extra
> pending interrupt on the line during IRQ forwarding.

I tried to remember the path from __irq_disable SW flow downto the GIC
SPI programming. I was not implying the IRQ_DISABLE_UNLAZY flag.

As fas as I remember lazy disable approach was in use when I did the
integration. But that's just an optimization that avoids to access the
HW unnecessarily (ie. the handler may be invoked even if the irq is
disabled).

Thanks

Eric
> 
> Maybe setting the IRQ_DISABLE_UNLAZY flag is the solution for ONESHOT
> irq forwarding actually, so we guarantee the IRQ is masked immediately
> and avoid the lazy approach that could lead to an erroneous pending
> interrupt?
> 
>>
>> Thanks
>>
>> Eric
>>>
>>> I don't have a great explanation for why ONESHOT interrupts are even a
>>> thing in the first place, maybe the HW design means you're going to
>>> get a bunch of garbage/meaningless ups and downs on the interrupt line
>>> while the interrupt is being serviced and they should never be taken
>>> into consideration in any way by the kernel until the IRQ is unmasked
>>> again?
>>>
>>>>
>>>> Thanks
>>>>
>>>> Eric
>>>>
>>>>  I'm
>>>>> not sure whether this could cause legitimate interrupts coming from
>>>>> devices to be missed while the injection for an existing interrupt is
>>>>> underway, but maybe this is a rare enough scenario that we wouldn't
>>>>> care. The main issue with this approach is that handle_level_irq()[16]
>>>>> will try to unmask the irq out from under us after we start the
>>>>> injection (as it is already masked before
>>>>> vfio_automasked_irq_handler[17] runs anyway). Not sure if masking at
>>>>> the irqchip level supports nesting or not.
>>>>>
>>>>> Let me know if you think either of these are viable options for adding
>>>>> ONESHOT interrupt forwarding support to vfio-platform?
>>>>>
>>>>> Thanks,
>>>>> Micah
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> Additional note about level triggered vs ONESHOT irq forwarding:
>>>>> For the regular type of level triggered interrupt described above, the
>>>>> vfio handler will call disable_irq_nosync()[18] before the
>>>>> handle_level_irq() function unmasks the irq and returns. This ensures
>>>>> if new interrupts come in on the line while the existing one is being
>>>>> handled by the guest (and the irq is therefore disabled), that the
>>>>> vfio_automasked_irq_handler() isn’t triggered again until the
>>>>> vfio_platform_unmask_handler() function has been triggered by the
>>>>> guest (causing the irq to be re-enabled[19]). In other words, the
>>>>> purpose of the irq enable/disable that already exists in vfio-platform
>>>>> is a higher level concept that delays handling of additional
>>>>> level-triggered interrupts in the host until the current one has been
>>>>> handled in the guest.
>>>>>
>>>>> This means that the existing level triggered interrupt forwarding
>>>>> logic in vfio/vfio-platform is not sufficient for handling ONESHOT
>>>>> interrupts (i.e. we can’t just treat a ONESHOT interrupt like a
>>>>> regular level triggered interrupt in the host and use the existing
>>>>> vfio forwarding code). The masking that needs to happen for ONESHOT
>>>>> interrupts is at the lower level of the irqchip mask/unmask in that
>>>>> the ONESHOT irq needs to remain masked (not just disabled) until the
>>>>> driver’s threaded handler has completed.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> [1] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L642
>>>>> [2] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L414
>>>>> [3] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L619
>>>>> [4] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L702
>>>>> [5] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L688
>>>>> [6] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L724
>>>>> [7] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L688
>>>>> [8] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L1028
>>>>> [9] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c
>>>>> [10] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L2038
>>>>> [11] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L167
>>>>> [12] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L142
>>>>> [13] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L1028
>>>>> [14] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L94
>>>>> [15] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L310
>>>>> [16] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L642
>>>>> [17] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L142
>>>>> [18] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L154
>>>>> [19] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L87
>>>>>
>>>>
>>>
>>
> 

