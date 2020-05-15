Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75DC1D5647
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgEOQj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 12:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgEOQj0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 12:39:26 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7797C061A0C
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 09:39:25 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s19so2722043edt.12
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 09:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W1eI7hr2VIDDc4ATooUIAp1rBOOi5eFHAl4kh1rS/pU=;
        b=oR8Wdrd0UY5t9Bs8lVzP6Ar4n/DHQkX16gNYexCBR5lp+PRg7dhR0KcTdk9tuuALNg
         BlBnD+EEYxNiWUcOcIb1L9jm2ybAwV1OIs/HC9l6Y9nr4pUKRSMd/By+73+8CEPc8VWZ
         08wG5vFHJcSjy47rcq/3Q7CmLg62FyAqSlA+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W1eI7hr2VIDDc4ATooUIAp1rBOOi5eFHAl4kh1rS/pU=;
        b=sBPRlFsJ47/vvalsZ8FCqcv8rufzCgqO8xh8NkEBqgVy24gEqUuo3eS37+8Pfdfjlc
         jAyPNNdtWLdnXwRqAfnFlOnnkehEs4SnhD6DjSU1dpDFihmK54cMKfgmBaTEcjJvThf0
         zya657bRTDhWvOXhEAu1KwxZsAnG9rF4GJkOB46khTdB5dGmOziEkCm1puJqCqY+z5TM
         S++S9nWvLRXb8r928xwFpB24geukf26A9GCkeNU26w/5KppHikEH+5wGu1p2wNG0JxM0
         pgvk4wpFz5OQz8fww6slTsIBuXX8TGMqElm/Ch8wnno1cAFrNfr7yd7WQQ1HaILTq1HA
         H0ug==
X-Gm-Message-State: AOAM532oojxZr0abJjAbZq5LzKxYmQIJkFWOVjn8x+KZYrlOKVZ20/oq
        nMIXH6qugmjriKPRWsQ8qalVIe3RLY0cPmKWOElsrw==
X-Google-Smtp-Source: ABdhPJwsWk0fuSf1wIDXODjZBDzz4MwGkf19GRRMdj1xEMPHcwdVuCP56PbvrIaLwfMetEuhxgQsX665yOfVCB9AFVs=
X-Received: by 2002:aa7:ca48:: with SMTP id j8mr3522911edt.328.1589560764255;
 Fri, 15 May 2020 09:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200511220046.120206-1-mortonm@chromium.org> <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com> <20200513083401.11e761a7@x1.home>
 <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com> <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
 <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com> <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
 <7f4c8f6c-ff33-d574-855a-eb8b312019af@redhat.com>
In-Reply-To: <7f4c8f6c-ff33-d574-855a-eb8b312019af@redhat.com>
From:   Micah Morton <mortonm@chromium.org>
Date:   Fri, 15 May 2020 09:39:12 -0700
Message-ID: <CAJ-EccNdQw4K6bDZWr+pgzC1WPcwBy+wTKLVkW58OBhxXFQsSw@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 3:11 AM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Micah,
>
> On 5/14/20 7:44 PM, Micah Morton wrote:
> > On Wed, May 13, 2020 at 3:05 PM Paolo Bonzini <pbonzini@redhat.com> wro=
te:
> >>
> >> On 13/05/20 21:10, Micah Morton wrote:
> >>> * If we only care about the bus controller existing (in an emulated
> >>> fashion) enough for the guest to discover the device in question, thi=
s
> >>> could work. I=E2=80=99m concerned that power management could be an i=
ssue here
> >>> however. For instance, I have a touchscreen device assigned to the
> >>> guest (irq forwarding done with this module) that in response to the
> >>> screen being touched prepares the i2c controller for a transaction by
> >>> calling into the PM system which end up writing to the PCI config
> >>> space** (here https://elixir.bootlin.com/linux/v5.6.12/source/drivers=
/i2c/busses/i2c-designware-master.c#L435).
> >>> It seems like this kind of scenario expands the scope of what would
> >>> need to be supported by the emulated i2c controller, which is less
> >>> ideal. The way I have it currently working, vfio-pci emulates the PCI
> >>> config space so the guest can do power management by accessing that
> >>> space.
> >>
> >> This wouldn't be a problem.  When the emulated i2c controller starts a
> >> transaction on th edevice, it will be performed by the host i2c
> >> controller and this will lead to the same config space write.
> >
> > I guess what you're saying is there would be an i2c controller
> > (emulated PCI device) in the guest and the i2c device driver would
> > still call i2c_dw_xfer as above and the execution in the guest would
> > still continue all the way to pci_write_config_word(). Then when the
> > guest executes the actual config write it would trap to the host,
> > which would need to have the logic that the guest is trying to do
> > runtime PM commands on an emulated PCI device so we need to step in
> > and reset the actual PCI device on the host that backs that emulated
> > device. Is this right?
> >
> > Again, this is assuming we have the infrastructure to pass platform
> > devices on x86 to the guest with vfio-platform, which I don't think is
> > the case. +Auger Eric (not sure why gmail puts your name backwards)
> > would you be able to comment on this based on my previous message?
>
> VFIO_PLATFORM only is compiled on ARM today but that's probably not the
> main issue here. I don't know if the fact the platform devices you want
> to assign are behind this PCI I2C controller does change anything in the
> way we would bind the devices to vfio-platform.
>
> Up to now, in QEMU we have only generated DT bindings for the assigned
> platform devices. Generating AML code has never been experienced.
>
> What I don't get in your existing POC is how your enumerate the platform
> devices resources (regs, IRQs) behing your controller. I understand you
> devised a solution to expose the specific IRQ but what about regs? How
> are they presented to your guest?

For the most part I haven't needed to present any extra regs to the
guest beyond the I/O ports / MMIO regions exposed to the guest through
VFIO. My experimentation with passthrough of platform devices behind
bus controllers has been limited to i2c and LPC so far. I did have one
case where the EC device on my machine is behind the LPC controller
and I also needed to additionally expose some I/O ports for the EC
that VFIO wasn't aware of (this is easy with KVM on x86, the VMCS has
a bit map of what I/O ports the guest is allowed to access). I think
this is the best example of what you're referencing that I've seen.
It's a good point. The fact that I've seen I/O ports that VFIO doesn't
know about that need to be made accessible to the guest probably means
there are similar cases for MMIOs. Then again I got most of the
hardware on my machine working in a guest without hitting that issue,
but that's a small sample size.

>
> Thanks
>
> Eric
>
>
> >
> >>
> >> I have another question: would it be possible to expose this IRQ throu=
gh
> >> /dev/i2c-* instead of messing with VFIO?
> >>
> >> In fact, adding support for /dev/i2c passthrough to QEMU has long been=
 a
> >> pet idea of mine (my usecase was different though: the idea was to wri=
te
> >> programs for a microcontroller on an ARM single board computer and run
> >> them under QEMU in emulation mode).  It's not trivial, because there
> >> could be some impedence mismatch between the guest (which might be
> >> programmed against a low-level controller or might even do bit banging=
)
> >> and the i2c-dev interface which is more high level.  Also QEMU cannot =
do
> >> clock stretching right now.  However, it's certainly doable.
> >
> > I agree that would be a cool thing to have in QEMU. Unfortunately I am
> > interested in assigning other PCI bus controllers to a guest VM and
> > (similar to the i2c example above) in some cases these busses (e.g.
> > LPC, SPI) have devices with arbitrary interrupts that need to be
> > forwarded into the guest for things to work.
> >
> > I realize this may seem like an over-use of VFIO, but I'm actually
> > coming from the angle of wanting to assign _most_ of the important
> > hardware on my device to a VM guest, and I'm looking to avoid
> > emulation wherever possible. Of course there will be devices like the
> > IOAPIC for which emulation is unavoidable, but I think emulation is
> > avoidable here for the busses we've mentioned if there is a way to
> > forward arbitrary interrupts into the guest.
> >
> > Since all these use cases are so close to working with vfio-pci right
> > out of the box, I was really hoping to come up with a simple and
> > generic solution to the arbitrary interrupt problem that can be used
> > for multiple bus types.
> >
> >>
> >>>> (Finally, in the past we were doing device assignment tasks within K=
VM
> >>>> and it was a bad idea.  Anything you want to do within KVM with resp=
ect
> >>>> to device assignment, someone else will want to do it from bare meta=
l.
> >>>
> >>> Are you saying people would want to use this in non-virtualized
> >>> scenarios like running drivers in userspace without any VMM/guest? An=
d
> >>> they could do that if this was part of VFIO and not part of KVM?
> >>
> >> Yes, see above for an example.
> >>
> >> Paolo
> >>
> >
>
