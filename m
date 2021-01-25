Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5B6302CAC
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 21:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbhAYUh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 15:37:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732199AbhAYUhs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 15:37:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611606980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T99cffXFqt1y8p0ZEUCrfvsnlUJpdUvt2TUG8S4I2vM=;
        b=jWLl+EXFzUuYSc3OHrqzamaN3ZawdW2QmZPqUHaGKg9ZWPTGYGkFKzSBUinMTg1UGbi/f5
        7wNYB7X0DpNp2GtAbvL8tKg3EBunPWHGTWCSfBo1H2auK76W7YHtkmqY2jQB8cqcNiYh1d
        /J6aPXTaAvaCg+omYD7SvFmSAi2gTHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-2Lf8B757M1OXe5MBztYLWA-1; Mon, 25 Jan 2021 15:36:18 -0500
X-MC-Unique: 2Lf8B757M1OXe5MBztYLWA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BEF69CDA0;
        Mon, 25 Jan 2021 20:36:17 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7361B5D9DB;
        Mon, 25 Jan 2021 20:36:11 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:36:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Micah Morton <mortonm@chromium.org>
Cc:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
Message-ID: <20210125133611.703c4b90@omen.home.shazbot.org>
In-Reply-To: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 10:46:47 -0500
Micah Morton <mortonm@chromium.org> wrote:

> Hi Eric,
>=20
> I was recently looking into some vfio-platform passthrough stuff and
> came across a device I wanted to assign to a guest that uses a ONESHOT
> type interrupt (these type of interrupts seem to be quite common, on
> ARM at least). The semantics for ONESHOT interrupts are a bit
> different from regular level triggered interrupts as I'll describe
> here:
>=20
> The normal generic code flow for level-triggered interrupts is as follows:
>=20
> - regular type[1]: mask[2] the irq, then run the handler, then
> unmask[3] the irq and done
>=20
> - fasteoi type[4]: run the handler, then eoi[5] the irq and done
>=20
> Note: IIUC the fasteoi type doesn't do any irq masking/unmasking
> because that is assumed to be handled transparently by "modern forms
> of interrupt handlers, which handle the flow details in hardware"
>=20
> ONESHOT type interrupts are a special case of the fasteoi type
> described above. They rely on the driver registering a threaded
> handler for the interrupt and assume the irq line will remain masked
> until the threaded handler completes, at which time the line will be
> unmasked. TL;DR:
>=20
> - mask[6] the irq, run the handler, and potentially eoi[7] the irq,
> then unmask[8] later when the threaded handler has finished running.

This doesn't seem quite correct to me, it skips the discussion of the
hard vs threaded handler, where the "regular" type would expect the
device interrupt to be masked in the hard handler, such that the
controller line can be unmasked during execution of the threaded handler
(if it exists).  It seems fasteoi is more transactional, ie. rather
than masking around quiescing the device interrupt, we only need to
send an eoi once we're ready for a new interrupt.  ONESHOT, OTOH, is a
means of deferring all device handling to the threaded interrupt,
specifically for cases such as an i2c device where the bus interaction
necessitates non-IRQ-context handling.  Sound right?

>=20
> For vfio-platform irq forwarding, there is no existing function in
> drivers/vfio/platform/vfio_platform_irq.c[9] that is a good candidate
> for registering as the threaded handler for a ONESHOT interrupt in the
> case we want to request the ONESHOT irq with
> request_threaded_irq()[10]. Moreover, we can't just register a
> threaded function that simply immediately returns IRQ_HANDLED (as is
> done in vfio_irq_handler()[11] and vfio_automasked_irq_handler()[12]),
> since that would cause the IRQ to be unmasked[13] immediately, before
> the userspace/guest driver has had any chance to service the
> interrupt.

Are you proposing servicing the device interrupt before it's sent to
userspace?  A ONESHOT irq is going to eoi the interrupt when the thread
exits, before userspace services the interrupt, so this seems like a
case where we'd need to mask the irq regardless of fasteoi handling so
that it cannot re-assert before userspace manages the device.  Our
existing autmasked for level triggered interrupts should handle this.

> The most obvious way I see to handle this is to add a threaded handler
> to vfio_platform_irq.c that waits until the userspace/guest driver has
> serviced the interrupt and the unmask_handler[14] has been called, at
> which point it returns IRQ_HANDLED so the generic IRQ code in the host
> can finally unmask the interrupt.

An interrupt thread with an indeterminate, user controlled runtime
seems bad.  The fact that fasteoi will send an eoi doesn't also mean
that it can't be masked.

> Does this sound like a reasonable approach and something you would be
> fine with adding to vfio-platform? If so I could get started looking
> at the implementation for how to sleep in the threaded handler in
> vfio-platform until the unmask_handler is called. The most tricky/ugly
> part of this is that DT has no knowledge of irq ONESHOT-ness, as it
> only contains info regarding active-low vs active-high and edge vs
> level trigger. That means that vfio-platform can't figure out that a
> device uses a ONESHOT irq in a similar way to how it queries[15] the
> trigger type, and by extension QEMU can't learn this information
> through the VFIO_DEVICE_GET_IRQ_INFO ioctl, but must have another way
> of knowing (i.e. command line option to QEMU).

Seems like existing level handling w/ masking should handle this, imo.

> I guess potentially another option would be to treat ONESHOT
> interrupts like regular level triggered interrupts from the
> perspective of vfio-platform, but somehow ensure the interrupt stays
> masked during injection to the guest, rather than just disabled. I'm
> not sure whether this could cause legitimate interrupts coming from
> devices to be missed while the injection for an existing interrupt is
> underway, but maybe this is a rare enough scenario that we wouldn't
> care. The main issue with this approach is that handle_level_irq()[16]
> will try to unmask the irq out from under us after we start the
> injection (as it is already masked before
> vfio_automasked_irq_handler[17] runs anyway). Not sure if masking at
> the irqchip level supports nesting or not.

I'd expect either an unmask at the controller or eoi to re-evaluate the
interrupt condition and re-assert as needed.  The interrupt will need to
be exclusive to the device so as not to starve other devices.

> Let me know if you think either of these are viable options for adding
> ONESHOT interrupt forwarding support to vfio-platform?
>=20
> Thanks,
> Micah
>=20
>=20
>=20
>=20
> Additional note about level triggered vs ONESHOT irq forwarding:
> For the regular type of level triggered interrupt described above, the
> vfio handler will call disable_irq_nosync()[18] before the
> handle_level_irq() function unmasks the irq and returns. This ensures
> if new interrupts come in on the line while the existing one is being
> handled by the guest (and the irq is therefore disabled), that the
> vfio_automasked_irq_handler() isn=E2=80=99t triggered again until the
> vfio_platform_unmask_handler() function has been triggered by the
> guest (causing the irq to be re-enabled[19]). In other words, the
> purpose of the irq enable/disable that already exists in vfio-platform
> is a higher level concept that delays handling of additional
> level-triggered interrupts in the host until the current one has been
> handled in the guest.

I wouldn't say "delays", the interrupt condition is not re-evaluated
until the interrupt is unmasked, by which point the user has had an
opportunity to service the device, which could de-assert the interrupt
such that there is no pending interrupt on unmask.  It therefore blocks
further interrupts until user serviced and unmasked.
=20
> This means that the existing level triggered interrupt forwarding
> logic in vfio/vfio-platform is not sufficient for handling ONESHOT
> interrupts (i.e. we can=E2=80=99t just treat a ONESHOT interrupt like a
> regular level triggered interrupt in the host and use the existing
> vfio forwarding code). The masking that needs to happen for ONESHOT
> interrupts is at the lower level of the irqchip mask/unmask in that
> the ONESHOT irq needs to remain masked (not just disabled) until the
> driver=E2=80=99s threaded handler has completed.

I don't see that this is true, unmasking the irq should cause the
controller to re-evaluate the irq condition on the device end and issue
a new interrupt as necessary.  Right?  Thanks,

Alex

