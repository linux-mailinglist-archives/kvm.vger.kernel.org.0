Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74DD302731
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 16:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbhAYPsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 10:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730449AbhAYPrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 10:47:39 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B44AC06178C
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 07:46:59 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id r12so18655323ejb.9
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 07:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=TBR2K4bVvs2paM8ICSn5HiZVL7k6Bw67nshWobZ6CUo=;
        b=navmzKi6X2+53RHrTwLrOl6lJm2XzYmtCpQsPgkao1JvhALfwlHyBiZIB2TZUUhrzy
         ClvJF1fyL1c4hOalwqduNwJs3sgO0FrG0oF3O12MX0Br1CRSue1bNGNHzSGvAVMkaGOV
         0T0dX+aX8vziZwyy7gmXAzkeXvyZhH8X2dYLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=TBR2K4bVvs2paM8ICSn5HiZVL7k6Bw67nshWobZ6CUo=;
        b=ABeIMTdOr/mGDlHvfrepjQG3haY5rgL03OMt6Mj4aEejbBlXE9RNqWv4e13l8699vS
         oiUtctqxR1EJiKYfTN+p3AgLWe7Ok7xkvcsdrMrSID9RUqTzeZSERDeJ0yhermoOWgJS
         SiOlpUHKT61Tat1oOkIDyBlO881uC6YtAlpe/BoHPy9PyH0FISNp3P3cWEeoXsO3HSam
         Cf3uggbi1HZ9AIan3fNuwN5qssErm2RncGQ5pydjRzRbUbBVkdasl/GW30h0azqp1SNO
         0wtmtsOJLqdjHXNG3mu0ujMHtXpSIIgdUnE186nPhvgB2foFyoGgWadEzlcN9wxU6q0k
         NvHw==
X-Gm-Message-State: AOAM5338WN0RqeUISQVW7WSnSdYSAfbimq6e1f+RLiqClxLEepiWkn/J
        KDelz8YvuzlhovaEQVb5Eyng9BxLJgLXqDLaewhDyQ==
X-Google-Smtp-Source: ABdhPJwGdFXwBNLpcOziYKv1Iw4b+o1qQUyA8WtEFiTfpyTdNhzeKjhKmHtsSI+VYVd+iXITfvwO8hiCSZSBK7Qnbz4=
X-Received: by 2002:a17:906:1302:: with SMTP id w2mr786639ejb.413.1611589617851;
 Mon, 25 Jan 2021 07:46:57 -0800 (PST)
MIME-Version: 1.0
From:   Micah Morton <mortonm@chromium.org>
Date:   Mon, 25 Jan 2021 10:46:47 -0500
Message-ID: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
Subject: Add vfio-platform support for ONESHOT irq forwarding?
To:     Auger Eric <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

I was recently looking into some vfio-platform passthrough stuff and
came across a device I wanted to assign to a guest that uses a ONESHOT
type interrupt (these type of interrupts seem to be quite common, on
ARM at least). The semantics for ONESHOT interrupts are a bit
different from regular level triggered interrupts as I'll describe
here:

The normal generic code flow for level-triggered interrupts is as follows:

- regular type[1]: mask[2] the irq, then run the handler, then
unmask[3] the irq and done

- fasteoi type[4]: run the handler, then eoi[5] the irq and done

Note: IIUC the fasteoi type doesn't do any irq masking/unmasking
because that is assumed to be handled transparently by "modern forms
of interrupt handlers, which handle the flow details in hardware"

ONESHOT type interrupts are a special case of the fasteoi type
described above. They rely on the driver registering a threaded
handler for the interrupt and assume the irq line will remain masked
until the threaded handler completes, at which time the line will be
unmasked. TL;DR:

- mask[6] the irq, run the handler, and potentially eoi[7] the irq,
then unmask[8] later when the threaded handler has finished running.

For vfio-platform irq forwarding, there is no existing function in
drivers/vfio/platform/vfio_platform_irq.c[9] that is a good candidate
for registering as the threaded handler for a ONESHOT interrupt in the
case we want to request the ONESHOT irq with
request_threaded_irq()[10]. Moreover, we can't just register a
threaded function that simply immediately returns IRQ_HANDLED (as is
done in vfio_irq_handler()[11] and vfio_automasked_irq_handler()[12]),
since that would cause the IRQ to be unmasked[13] immediately, before
the userspace/guest driver has had any chance to service the
interrupt.

The most obvious way I see to handle this is to add a threaded handler
to vfio_platform_irq.c that waits until the userspace/guest driver has
serviced the interrupt and the unmask_handler[14] has been called, at
which point it returns IRQ_HANDLED so the generic IRQ code in the host
can finally unmask the interrupt.

Does this sound like a reasonable approach and something you would be
fine with adding to vfio-platform? If so I could get started looking
at the implementation for how to sleep in the threaded handler in
vfio-platform until the unmask_handler is called. The most tricky/ugly
part of this is that DT has no knowledge of irq ONESHOT-ness, as it
only contains info regarding active-low vs active-high and edge vs
level trigger. That means that vfio-platform can't figure out that a
device uses a ONESHOT irq in a similar way to how it queries[15] the
trigger type, and by extension QEMU can't learn this information
through the VFIO_DEVICE_GET_IRQ_INFO ioctl, but must have another way
of knowing (i.e. command line option to QEMU).

I guess potentially another option would be to treat ONESHOT
interrupts like regular level triggered interrupts from the
perspective of vfio-platform, but somehow ensure the interrupt stays
masked during injection to the guest, rather than just disabled. I'm
not sure whether this could cause legitimate interrupts coming from
devices to be missed while the injection for an existing interrupt is
underway, but maybe this is a rare enough scenario that we wouldn't
care. The main issue with this approach is that handle_level_irq()[16]
will try to unmask the irq out from under us after we start the
injection (as it is already masked before
vfio_automasked_irq_handler[17] runs anyway). Not sure if masking at
the irqchip level supports nesting or not.

Let me know if you think either of these are viable options for adding
ONESHOT interrupt forwarding support to vfio-platform?

Thanks,
Micah




Additional note about level triggered vs ONESHOT irq forwarding:
For the regular type of level triggered interrupt described above, the
vfio handler will call disable_irq_nosync()[18] before the
handle_level_irq() function unmasks the irq and returns. This ensures
if new interrupts come in on the line while the existing one is being
handled by the guest (and the irq is therefore disabled), that the
vfio_automasked_irq_handler() isn=E2=80=99t triggered again until the
vfio_platform_unmask_handler() function has been triggered by the
guest (causing the irq to be re-enabled[19]). In other words, the
purpose of the irq enable/disable that already exists in vfio-platform
is a higher level concept that delays handling of additional
level-triggered interrupts in the host until the current one has been
handled in the guest.

This means that the existing level triggered interrupt forwarding
logic in vfio/vfio-platform is not sufficient for handling ONESHOT
interrupts (i.e. we can=E2=80=99t just treat a ONESHOT interrupt like a
regular level triggered interrupt in the host and use the existing
vfio forwarding code). The masking that needs to happen for ONESHOT
interrupts is at the lower level of the irqchip mask/unmask in that
the ONESHOT irq needs to remain masked (not just disabled) until the
driver=E2=80=99s threaded handler has completed.




[1] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L642
[2] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L414
[3] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L619
[4] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L702
[5] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L688
[6] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L724
[7] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L688
[8] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L10=
28
[9] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/v=
fio_platform_irq.c
[10] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L2=
038
[11] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/=
vfio_platform_irq.c#L167
[12] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/=
vfio_platform_irq.c#L142
[13] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/manage.c#L1=
028
[14] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/=
vfio_platform_irq.c#L94
[15] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/=
vfio_platform_irq.c#L310
[16] https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L642
[17] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/=
vfio_platform_irq.c#L142
[18] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/=
vfio_platform_irq.c#L154
[19] https://elixir.bootlin.com/linux/v5.10.7/source/drivers/vfio/platform/=
vfio_platform_irq.c#L87
