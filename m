Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A191B65AE
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 22:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgDWUnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 16:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgDWUnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 16:43:25 -0400
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B904720781
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 20:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587674604;
        bh=oBeoK4Ts3IjHpqjL3Ti09H4JuJ5fGBnvc+ezg8vGLNc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sXc1zu2TDsoqGPTCxhtIfoNhzQHTCy7bryxDNjg1HyYofvm9WLE7Qus38k6TowZSe
         hkYSDqEYPQVeaRAxVBWNdmFPhEAMgHnX95sf3ZZDSaSoTkhNrDicBmVFoeZzXXLeMh
         YpAac62GrTdBGUawenLqox6DR3H5PwHyUWE4vr2U=
Received: by mail-il1-f181.google.com with SMTP id f82so7148174ilh.8
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 13:43:24 -0700 (PDT)
X-Gm-Message-State: AGi0PuaPE3cGbX+bfqHYC9KSp1VsyL2/PbtCBU/S/eXDwDhsAElL91IN
        CRJqLWzBLGAW2lwk/gatW9Y919fnPAClHXFtiwc=
X-Google-Smtp-Source: APiQypJLC2CAavFDx79KAiO8cUtXdB0gEzPkwZwLp7ZAajg4puIj8+tl3c9epWApmzwlYc1NSji9g7BPXZPG4SJNh9E=
X-Received: by 2002:a92:405:: with SMTP id 5mr5113914ile.279.1587674604087;
 Thu, 23 Apr 2020 13:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com> <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
In-Reply-To: <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 23 Apr 2020 22:43:13 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
Message-ID: <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 at 19:55, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 23 Apr 2020 at 19:39, Andre Przywara <andre.przywara@arm.com> wrote:
> >
> > Hi,
> >
> > an update for the CFI flash emulation, addressing Alex' comments and
> > adding direct mapping support.
> > The actual code changes to the flash emulation are minimal, mostly this
> > is about renaming and cleanups.
> > This versions now adds some patches. 1/5 is a required fix, the last
> > three patches add mapping support as an extension. See below.
> >
> > In addition to a branch with this series[1], I also put a git branch with
> > all the changes compared to v3[2] as separate patches on the server, please
> > have a look if you want to verify against a previous review.
> >
> > ===============
> > The EDK II UEFI firmware implementation requires some storage for the EFI
> > variables, which is typically some flash storage.
> > Since this is already supported on the EDK II side, and looks like a
> > generic standard, this series adds a CFI flash emulation to kvmtool.
> >
> > Patch 2/5 is the actual emulation code, patch 1/5 is a bug-fix for
> > registering MMIO devices, which is needed for this device.
> > Patches 3-5 add support for mapping the flash memory into guest, should
> > it be in read-array mode. For this to work, patch 3/5 is cherry-picked
> > from Alex' PCIe reassignable BAR series, to support removing a memslot
> > mapping. Patch 4/5 adds support for read-only mappings, while patch 5/5
> > adds or removes the mapping based on the current state.
> > I am happy to squash 5/5 into 2/5, if we agree that patch 3/5 should be
> > merged either separately or the PCIe series is actually merged before
> > this one.
> >
> > This is one missing piece towards a working UEFI boot with kvmtool on
> > ARM guests, the other is to provide writable PCI BARs, which is WIP.
> > This series alone already enables UEFI boot, but only with virtio-mmio.
> >
>
> Excellent! Thanks for taking the time to implement the r/o memslot for
> the flash, it really makes the UEFI firmware much more usable.
>
> I will test this as soon as I get a chance, probably tomorrow.
>

I tested this on a SynQuacer box as a host, using EFI firmware [0]
built from patches provided by Sami.

I booted the Debian buster installer, completed the installation, and
could boot into the system. The only glitch was the fact that the
reboot didn't work, but I suppose we are not preserving the memory the
contains the firmware image, so there is nothing to reboot into. But
just restarting kvmtool with the flash image containing the EFI
variables got me straight into GRUB and the installed OS.

Tested-by: Ard Biesheuvel <ardb@kernel.org>

Thanks again for getting this sorted.


[0] https://people.linaro.org/~ard.biesheuvel/KVMTOOL_EFI.fd
