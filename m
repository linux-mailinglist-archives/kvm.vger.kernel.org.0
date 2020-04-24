Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ADC1B6E67
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgDXGpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgDXGpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 02:45:49 -0400
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DCAD2168B
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 06:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587710748;
        bh=p2q55OLx4UPloM+vgfVQMuUale07BQMtfAZ7tOi6RnU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JSx+T6PtvoWL6GnpDqhKz/MwjKZxO/9BHdc7hOg/ev4nwZ7P+2eTqw+Bk7V9rSzej
         z9yI/xhe6ykQgZSG85qtADknL2sRRw5myyRLI1lmU3k3gmRIPFTqpOIua3M2LloCT+
         YSac4oCFt0ktHk4KQH6htBnfaDhvwfjk7UZTXjhs=
Received: by mail-il1-f172.google.com with SMTP id f82so8253252ilh.8
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 23:45:48 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ93vpOMjPq7h6E6xybmpuJtnNW42N2riZuGmg/bYi/AK7AoYIX
        tW7F+AcqzUAUiUgmjgmMHJ1EeyujIGITpO/fv8U=
X-Google-Smtp-Source: APiQypLtBOfLTUCgAhYdZRnGLbRyu71+dwoV1T4y4Mmeic6g1JZnuZsFCD3CRzF/Ys/eH3kOjeDK4ksjZqc5dzL+Mos=
X-Received: by 2002:a92:607:: with SMTP id x7mr6630624ilg.218.1587710747942;
 Thu, 23 Apr 2020 23:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
 <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com> <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com>
In-Reply-To: <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 24 Apr 2020 08:45:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
Message-ID: <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To:     =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 at 23:32, Andr=C3=A9 Przywara <andre.przywara@arm.com> =
wrote:
>
> On 23/04/2020 21:43, Ard Biesheuvel wrote:
>
> Hi Ard,
>
> > On Thu, 23 Apr 2020 at 19:55, Ard Biesheuvel <ardb@kernel.org> wrote:
> >>
> >> On Thu, 23 Apr 2020 at 19:39, Andre Przywara <andre.przywara@arm.com> =
wrote:
> >>>
> >>> Hi,
> >>>
> >>> an update for the CFI flash emulation, addressing Alex' comments and
> >>> adding direct mapping support.
> >>> The actual code changes to the flash emulation are minimal, mostly th=
is
> >>> is about renaming and cleanups.
> >>> This versions now adds some patches. 1/5 is a required fix, the last
> >>> three patches add mapping support as an extension. See below.
> >>>
> >>> In addition to a branch with this series[1], I also put a git branch =
with
> >>> all the changes compared to v3[2] as separate patches on the server, =
please
> >>> have a look if you want to verify against a previous review.
> >>>
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>> The EDK II UEFI firmware implementation requires some storage for the=
 EFI
> >>> variables, which is typically some flash storage.
> >>> Since this is already supported on the EDK II side, and looks like a
> >>> generic standard, this series adds a CFI flash emulation to kvmtool.
> >>>
> >>> Patch 2/5 is the actual emulation code, patch 1/5 is a bug-fix for
> >>> registering MMIO devices, which is needed for this device.
> >>> Patches 3-5 add support for mapping the flash memory into guest, shou=
ld
> >>> it be in read-array mode. For this to work, patch 3/5 is cherry-picke=
d
> >>> from Alex' PCIe reassignable BAR series, to support removing a memslo=
t
> >>> mapping. Patch 4/5 adds support for read-only mappings, while patch 5=
/5
> >>> adds or removes the mapping based on the current state.
> >>> I am happy to squash 5/5 into 2/5, if we agree that patch 3/5 should =
be
> >>> merged either separately or the PCIe series is actually merged before
> >>> this one.
> >>>
> >>> This is one missing piece towards a working UEFI boot with kvmtool on
> >>> ARM guests, the other is to provide writable PCI BARs, which is WIP.
> >>> This series alone already enables UEFI boot, but only with virtio-mmi=
o.
> >>>
> >>
> >> Excellent! Thanks for taking the time to implement the r/o memslot for
> >> the flash, it really makes the UEFI firmware much more usable.
> >>
> >> I will test this as soon as I get a chance, probably tomorrow.
> >>
> >
> > I tested this on a SynQuacer box as a host, using EFI firmware [0]
> > built from patches provided by Sami.
> >
> > I booted the Debian buster installer, completed the installation, and
> > could boot into the system. The only glitch was the fact that the
> > reboot didn't work, but I suppose we are not preserving the memory the
> > contains the firmware image, so there is nothing to reboot into.
>
> It's even worth, kvmtool does actually not support reset at all:
> https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/tree/kvm=
-cpu.c#n220
>
> And yeah, the UEFI firmware is loaded at the beginning of RAM, so most
> of it is long gone by then.
> kvmtool could reload the image and reset the VCPUs, but every device
> emulation would need to be reset, for which there is no code yet.
>

Fair enough. For my use case, it doesn't really matter anyway.

> > But
> > just restarting kvmtool with the flash image containing the EFI
> > variables got me straight into GRUB and the installed OS.
>
> So, yeah, this is the way to do it ;-)
>
> > Tested-by: Ard Biesheuvel <ardb@kernel.org>
>
> Many thanks for that!
>
> > Thanks again for getting this sorted.
>
> It was actually easier than I thought (see the last patch).
>
> Just curious: the images Sami gave me this morning did not show any
> issues anymore (no no-syndrome fault, no alignment issues), even without
> the mapping [1]. And even though I saw the 800k read traps, I didn't
> notice any real performance difference (on a Juno). The PXE timeout was
> definitely much more noticeable.
>
> So did you see any performance impact with this series?
>

You normally don't PXE boot. There is an issue with the iSCSI driver
as well, which causes a boot delay for some reason, so I disabled that
in my build.

I definitely *feels* faster :-) But in any case, exposing the array
mode as a r/o memslot is definitely the right way to deal with this.
Even if Sami did find a workaround that masks the error, it is no
guarantee that all accesses go through that library.


> > [0] https://people.linaro.org/~ard.biesheuvel/KVMTOOL_EFI.fd
>
> Ah, nice, will this stay there for a while? I can't provide binaries,
> but wanted others to be able to easily test this.
>

Sure, I will leave it up until Linaro decides to take down my account.
