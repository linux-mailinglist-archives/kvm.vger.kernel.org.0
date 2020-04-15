Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22701AAC6B
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414997AbgDOP4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1414995AbgDOP4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 11:56:04 -0400
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E822420936
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586966164;
        bh=n4WL1T858zal6SWux0kcghyeb03YcdCK83LPyQqpmOU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A1oPX8cw/GBfeqsSqfJWwnUqaNepW5N3J3c8E6pL3YrdAmZdGj7lvsosC336DLx5T
         EIiSp6KVtiNjUoeranx2ginsDWs4z1plednhoQ7mqRDTmJNJNGRJffVwlRYXjQRhtk
         kOu2RXyffokxLfokO7VLXXOYB79kDXGPJyS5ayRE=
Received: by mail-il1-f179.google.com with SMTP id f82so3771529ilh.8
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 08:56:03 -0700 (PDT)
X-Gm-Message-State: AGi0PuYfyZES413EyhHOGp11hYRgzGcjNJU/V4IceRpB2fvFnOZV0G1e
        xabWeTOS63kd4MS7yUxv7e3LJJrO7q3k3gYF60c=
X-Google-Smtp-Source: APiQypJO2rcsOAPOZwNgYyBGwSD18Rro24rIIN5xJo2IrgJIuBFWlXuwcbqq2VlhdS3Pf3dN91LZUXXkZ6WIB4fz4EM=
X-Received: by 2002:a92:5a4c:: with SMTP id o73mr5693957ilb.218.1586966163228;
 Wed, 15 Apr 2020 08:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com> <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
In-Reply-To: <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 15 Apr 2020 17:55:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
Message-ID: <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To:     Alexandru Elisei <alexandru.elisei@arm.com>, sami.mujawar@arm.com
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Apr 2020 at 17:43, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 7 Apr 2020 at 17:15, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> > I've tested this patch by running badblocks and fio on a flash device inside a
> > guest, everything worked as expected.
> >
> > I've also looked at the flowcharts for device operation from Intel Application
> > Note 646, pages 12-21, and they seem implemented correctly.
> >
> > A few minor issues below.
> >
> > On 2/21/20 4:55 PM, Andre Przywara wrote:
> > > From: Raphael Gault <raphael.gault@arm.com>
> > >
> > > The EDK II UEFI firmware implementation requires some storage for the EFI
> > > variables, which is typically some flash storage.
> > > Since this is already supported on the EDK II side, we add a CFI flash
> > > emulation to kvmtool.
> > > This is backed by a file, specified via the --flash or -F command line
> > > option. Any flash writes done by the guest will immediately be reflected
> > > into this file (kvmtool mmap's the file).
> > > The flash will be limited to the nearest power-of-2 size, so only the
> > > first 2 MB of a 3 MB file will be used.
> > >
> > > This implements a CFI flash using the "Intel/Sharp extended command
> > > set", as specified in:
> > > - JEDEC JESD68.01
> > > - JEDEC JEP137B
> > > - Intel Application Note 646
> > > Some gaps in those specs have been filled by looking at real devices and
> > > other implementations (QEMU, Linux kernel driver).
> > >
> > > At the moment this relies on DT to advertise the base address of the
> > > flash memory (mapped into the MMIO address space) and is only enabled
> > > for ARM/ARM64. The emulation itself is architecture agnostic, though.
> > >
> > > This is one missing piece toward a working UEFI boot with kvmtool on
> > > ARM guests, the other is to provide writable PCI BARs, which is WIP.
> > >
>
> I have given this a spin with UEFI built for kvmtool, and it appears
> to be working correctly. However, I noticed that it is intolerably
> slow, which seems to be caused by the fact that both array mode and
> command mode (or whatever it is called in the CFI spec) are fully
> emulated, whereas in the QEMU implementation (for instance), the
> region is actually exposed to the guest using a read-only KVM memslot
> in array mode, and so the read accesses are made natively.
>
> It is also causing problems in the UEFI implementation, as we can no
> longer use unaligned accesses to read from the region, which is
> something the code currently relies on (and which works fine on actual
> hardware as long as you use normal non-cacheable mappings)
>

Actually, the issue is not alignment. The issue is with instructions
with multiple outputs, which means you cannot do an ordinary memcpy()
from the NOR region using ldp instructions, aligned or not.
