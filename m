Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4193028FC
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 18:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbhAYReF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 12:34:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731044AbhAYRdP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 12:33:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611595908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+IuZvOqZZWNri4uNKAy+xMBSeTywacBmC+/WqSDrAf0=;
        b=G/W+glVm/9AZ2hBWw1ITpxYbmuUnkRciibyREAeYNECBEnEWC6SomfXMUEhY3R7yy/sNS7
        SkarKB1hw+4wZ/a0pnu6MknPMOKvBajClmfTZY5FDWxLzkiXU2vBc36rvNSgn55dfeEN8X
        JFqq/oTFVIzP++IFw94WkfCP4/n4jNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-5-ml1_94Mn-xSBuh4py7dA-1; Mon, 25 Jan 2021 12:31:42 -0500
X-MC-Unique: 5-ml1_94Mn-xSBuh4py7dA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0DF0107ACE8;
        Mon, 25 Jan 2021 17:31:41 +0000 (UTC)
Received: from [10.36.113.217] (ovpn-113-217.ams2.redhat.com [10.36.113.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC5D75D9DB;
        Mon, 25 Jan 2021 17:31:37 +0000 (UTC)
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
To:     Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <184709d7-03f6-c03d-9afa-c780c4867c18@redhat.com>
Date:   Mon, 25 Jan 2021 18:31:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Micah,

On 1/25/21 4:46 PM, Micah Morton wrote:
> Hi Eric,
> 
> I was recently looking into some vfio-platform passthrough stuff and
> came across a device I wanted to assign to a guest that uses a ONESHOT
> type interrupt (these type of interrupts seem to be quite common, on
> ARM at least). The semantics for ONESHOT interrupts are a bit
> different from regular level triggered interrupts as I'll describe
> here:
> 
> The normal generic code flow for level-triggered interrupts is as follows:
> 
> - regular type[1]: mask[2] the irq, then run the handler, then
> unmask[3] the irq and done

VFIO level sensitive interrupts are "automasked". See slide 10 of
https://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf if this can help.

When the guest deactivates the virtual IRQ, this causes a maintenance
interrupt on host. This occurence causes kvm_notify_acked_irq() to be
called and this latter unmasks the physical IRQ.
> 
> - fasteoi type[4]: run the handler, then eoi[5] the irq and done
> 
> Note: IIUC the fasteoi type doesn't do any irq masking/unmasking
> because that is assumed to be handled transparently by "modern forms
> of interrupt handlers, which handle the flow details in hardware"
> 
> ONESHOT type interrupts are a special case of the fasteoi type
> described above. They rely on the driver registering a threaded
> handler for the interrupt and assume the irq line will remain masked
> until the threaded handler completes, at which time the line will be
> unmasked. TL;DR:
> 
> - mask[6] the irq, run the handler, and potentially eoi[7] the irq,
> then unmask[8] later when the threaded handler has finished running.

could you point me to the exact linux handler (is it
handle_fasteoi_irq?)  or Why do you say "potentially". Given the details
above, the guest EOI would unmask the IRQ at physical level. We do not
have any hook KVM/VFIO on the guest unmap.
> 
> For vfio-platform irq forwarding, there is no existing function in
> drivers/vfio/platform/vfio_platform_irq.c[9] that is a good candidate
> for registering as the threaded handler for a ONESHOT interrupt in the
> case we want to request the ONESHOT irq with
> request_threaded_irq()[10]. Moreover, we can't just register a
> threaded function that simply immediately returns IRQ_HANDLED (as is
> done in vfio_irq_handler()[11] and vfio_automasked_irq_handler()[12]),
> since that would cause the IRQ to be unmasked[13] immediately, before
sorry I know you reworked that several times for style issue but [13]
does not match unmask().
> the userspace/guest driver has had any chance to service the
> interrupt.
> 
> The most obvious way I see to handle this is to add a threaded handler
> to vfio_platform_irq.c that waits until the userspace/guest driver has
> serviced the interrupt and the unmask_handler[14] has been called, at
> which point it returns IRQ_HANDLED so the generic IRQ code in the host
> can finally unmask the interrupt.
this is done on guest EOI at the moment.
> 
> Does this sound like a reasonable approach and something you would be
> fine with adding to vfio-platform?
Well I think it is interesting to do a pre-study and make sure we agree
on the terminology, IRQ flow and problems that would need to be solved.
Then we need to determine if it is worth the candle, if this support
would speed up the vfio-platform usage (I am not sure at this point as I
think there are more important drags like the lack of specification/dt
integration for instance).

Besides we need to make sure we are not launching into a huge effort for
attempting to assign a device that does not fit well into the vfio
platform scope (dma capable, reset, device tree).

 If so I could get started looking
> at the implementation for how to sleep in the threaded handler in
> vfio-platform until the unmask_handler is called. The most tricky/ugly
> part of this is that DT has no knowledge of irq ONESHOT-ness, as it
> only contains info regarding active-low vs active-high and edge vs
> level trigger. That means that vfio-platform can't figure out that a
> device uses a ONESHOT irq in a similar way to how it queries[15] the
> trigger type, and by extension QEMU can't learn this information
> through the VFIO_DEVICE_GET_IRQ_INFO ioctl, but must have another way
> of knowing (i.e. command line option to QEMU).
Indeed that's not really appealing.
> 
> I guess potentially another option would be to treat ONESHOT
> interrupts like regular level triggered interrupts from the
> perspective of vfio-platform, but somehow ensure the interrupt stays
> masked during injection to the guest, rather than just disabled.
I need this to be clarified actually. I am confused by the automasked
terminology now.

Thanks

Eric

 I'm
> not sure whether this could cause legitimate interrupts coming from
> devices to be missed while the injection for an existing interrupt is
> underway, but maybe this is a rare enough scenario that we wouldn't
> care. The main issue with this approach is that handle_level_irq()[16]
> will try to unmask the irq out from under us after we start the
> injection (as it is already masked before
> vfio_automasked_irq_handler[17] runs anyway). Not sure if masking at
> the irqchip level supports nesting or not.
> 
> Let me know if you think either of these are viable options for adding
> ONESHOT interrupt forwarding support to vfio-platform?
> 
> Thanks,
> Micah
> 
> 
> 
> 
> Additional note about level triggered vs ONESHOT irq forwarding:
> For the regular type of level triggered interrupt described above, the
> vfio handler will call disable_irq_nosync()[18] before the
> handle_level_irq() function unmasks the irq and returns. This ensures
> if new interrupts come in on the line while the existing one is being
> handled by the guest (and the irq is therefore disabled), that the
> vfio_automasked_irq_handler() isn’t triggered again until the
> vfio_platform_unmask_handler() function has been triggered by the
> guest (causing the irq to be re-enabled[19]). In other words, the
> purpose of the irq enable/disable that already exists in vfio-platform
> is a higher level concept that delays handling of additional
> level-triggered interrupts in the host until the current one has been
> handled in the guest.
> 
> This means that the existing level triggered interrupt forwarding
> logic in vfio/vfio-platform is not sufficient for handling ONESHOT
> interrupts (i.e. we can’t just treat a ONESHOT interrupt like a
> regular level triggered interrupt in the host and use the existing
> vfio forwarding code). The masking that needs to happen for ONESHOT
> interrupts is at the lower level of the irqchip mask/unmask in that
> the ONESHOT irq needs to remain masked (not just disabled) until the
> driver’s threaded handler has completed.
> 
> 
> 
> 
> [1] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L642
> [2] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L414
> [3] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L619
> [4] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L702
> [5] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L688
> [6] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L724
> [7] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L688
> [8] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L1028
> [9] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c
> [10] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L2038
> [11] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L167
> [12] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L142
> [13] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L1028
> [14] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L94
> [15] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L310
> [16] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L642
> [17] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L142
> [18] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L154
> [19] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/vfio_platform_irq.c#L87
> 

