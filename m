Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F34B1AAEB4
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410429AbgDOQtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 12:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404333AbgDOQtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 12:49:16 -0400
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0353E20936
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586969355;
        bh=F9GmaurKbAsn0X4HPrA0BeOP+nd3evkoARWIjfwwJ94=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DQV6LM0c01hMnRto0Mkcfdcl6xZX19i1ZkoL8UTdUGBuSTb04GWl2ocPQsaNbOTtb
         C/bR7uu/aqhsOzrQqucI4yCSJwTkKlSwqKW2Ggk6tEQq5hkRhKsLO7mcLRV52syMj6
         vbUaNmBWCNUw6a6iilr8R9WyLNT1KEozy7FBpvv4=
Received: by mail-io1-f46.google.com with SMTP id f19so17828558iog.5
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 09:49:14 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ5OyNCvv4ErYqTPuJXr6R5qHVSr/YOEL/WcRIDDjaXUinTAEMJ
        PbKZjrUEUasvHSKkXtCjbfmUKNKwGJFBB+jCjNA=
X-Google-Smtp-Source: APiQypJWGMRiNduUYPB9oJ7u8KNJwMs3LO6HUvUASLH07gImZaYwmVp66Og1pCmupdLk+f0b5w/3jrmg4Ku7V8LKgKI=
X-Received: by 2002:a5e:8b47:: with SMTP id z7mr26739930iom.16.1586969354138;
 Wed, 15 Apr 2020 09:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com> <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
 <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
 <d9ae6d29-c2c5-6aa7-15b6-6549fc89c043@arm.com> <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
 <32355204-30b1-4615-0d08-b484f0340e82@arm.com>
In-Reply-To: <32355204-30b1-4615-0d08-b484f0340e82@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 15 Apr 2020 18:49:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG5aE9AjpKG28Ftsta6hOrP3aHMMYLvmVNUkRYsSeBfGg@mail.gmail.com>
Message-ID: <CAMj1kXG5aE9AjpKG28Ftsta6hOrP3aHMMYLvmVNUkRYsSeBfGg@mail.gmail.com>
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To:     =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, sami.mujawar@arm.com,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Apr 2020 at 18:36, Andr=C3=A9 Przywara <andre.przywara@arm.com> =
wrote:
>
> On 15/04/2020 17:20, Ard Biesheuvel wrote:
> > On Wed, 15 Apr 2020 at 18:11, Andr=C3=A9 Przywara <andre.przywara@arm.c=
om> wrote:
> >>
> >> On 15/04/2020 16:55, Ard Biesheuvel wrote:
> >>> On Wed, 15 Apr 2020 at 17:43, Ard Biesheuvel <ardb@kernel.org> wrote:
> >>>>
> >>>> On Tue, 7 Apr 2020 at 17:15, Alexandru Elisei <alexandru.elisei@arm.=
com> wrote:
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>> I've tested this patch by running badblocks and fio on a flash devi=
ce inside a
> >>>>> guest, everything worked as expected.
> >>>>>
> >>>>> I've also looked at the flowcharts for device operation from Intel =
Application
> >>>>> Note 646, pages 12-21, and they seem implemented correctly.
> >>>>>
> >>>>> A few minor issues below.
> >>>>>
> >>>>> On 2/21/20 4:55 PM, Andre Przywara wrote:
> >>>>>> From: Raphael Gault <raphael.gault@arm.com>
> >>>>>>
> >>>>>> The EDK II UEFI firmware implementation requires some storage for =
the EFI
> >>>>>> variables, which is typically some flash storage.
> >>>>>> Since this is already supported on the EDK II side, we add a CFI f=
lash
> >>>>>> emulation to kvmtool.
> >>>>>> This is backed by a file, specified via the --flash or -F command =
line
> >>>>>> option. Any flash writes done by the guest will immediately be ref=
lected
> >>>>>> into this file (kvmtool mmap's the file).
> >>>>>> The flash will be limited to the nearest power-of-2 size, so only =
the
> >>>>>> first 2 MB of a 3 MB file will be used.
> >>>>>>
> >>>>>> This implements a CFI flash using the "Intel/Sharp extended comman=
d
> >>>>>> set", as specified in:
> >>>>>> - JEDEC JESD68.01
> >>>>>> - JEDEC JEP137B
> >>>>>> - Intel Application Note 646
> >>>>>> Some gaps in those specs have been filled by looking at real devic=
es and
> >>>>>> other implementations (QEMU, Linux kernel driver).
> >>>>>>
> >>>>>> At the moment this relies on DT to advertise the base address of t=
he
> >>>>>> flash memory (mapped into the MMIO address space) and is only enab=
led
> >>>>>> for ARM/ARM64. The emulation itself is architecture agnostic, thou=
gh.
> >>>>>>
> >>>>>> This is one missing piece toward a working UEFI boot with kvmtool =
on
> >>>>>> ARM guests, the other is to provide writable PCI BARs, which is WI=
P.
> >>>>>>
> >>>>
> >>>> I have given this a spin with UEFI built for kvmtool, and it appears
> >>>> to be working correctly. However, I noticed that it is intolerably
> >>>> slow, which seems to be caused by the fact that both array mode and
> >>>> command mode (or whatever it is called in the CFI spec) are fully
> >>>> emulated, whereas in the QEMU implementation (for instance), the
> >>>> region is actually exposed to the guest using a read-only KVM memslo=
t
> >>>> in array mode, and so the read accesses are made natively.
> >>>>
> >>>> It is also causing problems in the UEFI implementation, as we can no
> >>>> longer use unaligned accesses to read from the region, which is
> >>>> something the code currently relies on (and which works fine on actu=
al
> >>>> hardware as long as you use normal non-cacheable mappings)
> >>>>
> >>>
> >>> Actually, the issue is not alignment. The issue is with instructions
> >>> with multiple outputs, which means you cannot do an ordinary memcpy()
> >>> from the NOR region using ldp instructions, aligned or not.
> >>
> >> Yes, we traced that down to an "ldrb with post-inc", in the memcpy cod=
e.
> >> My suggestion was to provide a version of memcpy_{from,to}_io(), as
> >> Linux does, which only uses MMIO accessors to avoid "fancy" instructio=
ns.
> >>
> >
> > That is possible, and the impact on the code is manageable, given the
> > modular nature of EDK2.
> >
> >> Back at this point I was challenging the idea of accessing a flash
> >> device with a normal memory mapping, because of it failing when being =
in
> >> some query mode. Do you know of any best practices for flash mappings?
> >> Are two mappings common?
> >>
> >
> > In the QEMU port of EDK2, we use normal non-cacheable for the first
> > flash device, which contains the executable image, and is not
> > updatable by the guest. The second flash bank is used for the variable
> > store, and is actually mapped as a device all the time.
> >
> > Another thing I just realized is that you cannot fetch instructions
> > from an emulated flash device either, so to execute from NOR flash,
> > you will need a true memory mapping as well.
>
> Wait, did you put the whole of EDK-2 image in the flash?

No, my point is that you cannot actually do that, since I don't think
you can fetch instructions using MMIO emulation.

> My assumption
> (and testing) was to use
>
> $ lkvm run -f KVMTOOL_EFI.fd --flash just_the_variables.img
>
> Hence my ignorance about performance, because it would just be a few
> bytes written/read. -f loads the firmware image into guest RAM.
>

No, the performance impact is due to the numerous variable accesses
done by UEFI during boot.

> > So in summary, I think the mode switch is needed to be generally
> > useful, even if the current approach is sufficient for (slow)
> > read/write using special memory accessors.
>
> Well,in hindsight I regret pursuing this whole flash emulation approach
> in kvmtool in the first place. Just some magic "this memory region is
> persistent" (mmapping a file and presenting as a memslot) would be
> *much* easier on the kvmtool side. It just seems that there wasn't any
> good DT binding or existing device class for this (to my surprise), or
> at least not one without issues. And then EDK-2 had this CFI flash
> support already, so we figured this should be the way to go. We just
> need some emulation code ... months later ...
>
> So do you know of some persistent storage device we could use? This
> would come at the cost of adding support to EDK-2, but I guess it should
> be straight-forward given the simple semantic?
>

I think emulating CFI is still the right approach, since it gives us
parity with QEMU and actual hardware. Alternatively, we could explore
paravirtualization of the secure UEFI variable store implementation
using the standalone MM stack (which runs at S-EL0 but could easily
run at NS-EL0 as well) and an implementation of the secure partition
manager interface inside kvmtool. This would actually give us an
implementation of UEFI secure boot that actually makes sense, since
the guest would not be able to manipulate the backing store directly.

But this is a whole other project ...
