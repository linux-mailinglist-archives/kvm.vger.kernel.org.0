Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687621AADBE
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 18:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415567AbgDOQUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 12:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1415555AbgDOQUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 12:20:38 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5012208FE
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586967637;
        bh=xiWRRWSIiNJkZgzN/gsKBCqoW4ucuqZrzCPF+0y0s3Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lVfxioqDtBIDtVZe6p4owl9oThM2453JiNHQbwWgv5H2Ku3OmoNzoaCU7Llce8caI
         Iq3sIzpUGf33c90jVVyF6LgwZBQz+Piuxk4ujkuuj3qsmCR7EEe0Pf1TcghTMTbl6j
         2YyERQYlRv0hXfx0ndDZPXN+coDC0EX9BoUi2pGc=
Received: by mail-io1-f50.google.com with SMTP id w20so17731698iob.2
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 09:20:37 -0700 (PDT)
X-Gm-Message-State: AGi0PuZnmu3OH3ZYFGSNcUOr6JmqujXXTEPwftx/xdVOXC7rzJgvBJ+6
        tpFqtsY2jmieKf2v46cl2WsknzpIRJx70L4nR+A=
X-Google-Smtp-Source: APiQypLgOSRPv1bC/QOZQLEX3sYcp6ObUrfMGehj4hFMujnG8x8tCvW9SfKpInZF6hOzPUdOrer1k5rTNzt4nm6uAo8=
X-Received: by 2002:a02:6a1e:: with SMTP id l30mr25608981jac.98.1586967636895;
 Wed, 15 Apr 2020 09:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com> <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
 <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com> <d9ae6d29-c2c5-6aa7-15b6-6549fc89c043@arm.com>
In-Reply-To: <d9ae6d29-c2c5-6aa7-15b6-6549fc89c043@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 15 Apr 2020 18:20:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
Message-ID: <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
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

On Wed, 15 Apr 2020 at 18:11, Andr=C3=A9 Przywara <andre.przywara@arm.com> =
wrote:
>
> On 15/04/2020 16:55, Ard Biesheuvel wrote:
> > On Wed, 15 Apr 2020 at 17:43, Ard Biesheuvel <ardb@kernel.org> wrote:
> >>
> >> On Tue, 7 Apr 2020 at 17:15, Alexandru Elisei <alexandru.elisei@arm.co=
m> wrote:
> >>>
> >>> Hi,
> >>>
> >>> I've tested this patch by running badblocks and fio on a flash device=
 inside a
> >>> guest, everything worked as expected.
> >>>
> >>> I've also looked at the flowcharts for device operation from Intel Ap=
plication
> >>> Note 646, pages 12-21, and they seem implemented correctly.
> >>>
> >>> A few minor issues below.
> >>>
> >>> On 2/21/20 4:55 PM, Andre Przywara wrote:
> >>>> From: Raphael Gault <raphael.gault@arm.com>
> >>>>
> >>>> The EDK II UEFI firmware implementation requires some storage for th=
e EFI
> >>>> variables, which is typically some flash storage.
> >>>> Since this is already supported on the EDK II side, we add a CFI fla=
sh
> >>>> emulation to kvmtool.
> >>>> This is backed by a file, specified via the --flash or -F command li=
ne
> >>>> option. Any flash writes done by the guest will immediately be refle=
cted
> >>>> into this file (kvmtool mmap's the file).
> >>>> The flash will be limited to the nearest power-of-2 size, so only th=
e
> >>>> first 2 MB of a 3 MB file will be used.
> >>>>
> >>>> This implements a CFI flash using the "Intel/Sharp extended command
> >>>> set", as specified in:
> >>>> - JEDEC JESD68.01
> >>>> - JEDEC JEP137B
> >>>> - Intel Application Note 646
> >>>> Some gaps in those specs have been filled by looking at real devices=
 and
> >>>> other implementations (QEMU, Linux kernel driver).
> >>>>
> >>>> At the moment this relies on DT to advertise the base address of the
> >>>> flash memory (mapped into the MMIO address space) and is only enable=
d
> >>>> for ARM/ARM64. The emulation itself is architecture agnostic, though=
.
> >>>>
> >>>> This is one missing piece toward a working UEFI boot with kvmtool on
> >>>> ARM guests, the other is to provide writable PCI BARs, which is WIP.
> >>>>
> >>
> >> I have given this a spin with UEFI built for kvmtool, and it appears
> >> to be working correctly. However, I noticed that it is intolerably
> >> slow, which seems to be caused by the fact that both array mode and
> >> command mode (or whatever it is called in the CFI spec) are fully
> >> emulated, whereas in the QEMU implementation (for instance), the
> >> region is actually exposed to the guest using a read-only KVM memslot
> >> in array mode, and so the read accesses are made natively.
> >>
> >> It is also causing problems in the UEFI implementation, as we can no
> >> longer use unaligned accesses to read from the region, which is
> >> something the code currently relies on (and which works fine on actual
> >> hardware as long as you use normal non-cacheable mappings)
> >>
> >
> > Actually, the issue is not alignment. The issue is with instructions
> > with multiple outputs, which means you cannot do an ordinary memcpy()
> > from the NOR region using ldp instructions, aligned or not.
>
> Yes, we traced that down to an "ldrb with post-inc", in the memcpy code.
> My suggestion was to provide a version of memcpy_{from,to}_io(), as
> Linux does, which only uses MMIO accessors to avoid "fancy" instructions.
>

That is possible, and the impact on the code is manageable, given the
modular nature of EDK2.

> Back at this point I was challenging the idea of accessing a flash
> device with a normal memory mapping, because of it failing when being in
> some query mode. Do you know of any best practices for flash mappings?
> Are two mappings common?
>

In the QEMU port of EDK2, we use normal non-cacheable for the first
flash device, which contains the executable image, and is not
updatable by the guest. The second flash bank is used for the variable
store, and is actually mapped as a device all the time.

Another thing I just realized is that you cannot fetch instructions
from an emulated flash device either, so to execute from NOR flash,
you will need a true memory mapping as well.

So in summary, I think the mode switch is needed to be generally
useful, even if the current approach is sufficient for (slow)
read/write using special memory accessors.
