Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6731B874A
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 17:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDYPQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 11:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgDYPQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 11:16:20 -0400
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1242720767
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587827780;
        bh=o0YvFXB0fOhkpMsOYQtyfaC/gbqb1WTOlDnFNBy5vYg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WHljdFkCPrGvMauQcqkQpX5IqC4DgJqxiZXcR9v6QBtR0AoMMqa4UWNnKxqyh39eN
         qMM3xtTEI2bUVsU2OhunkCpogsZJ/JrhiTxAQpLUHxXwPmk9IZQJz/00PDeEZb45+q
         +6LR8xOM4eK+UIoxokqO5i2kvDt2vzHj1NJBBN0s=
Received: by mail-io1-f49.google.com with SMTP id f19so13865636iog.5
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 08:16:20 -0700 (PDT)
X-Gm-Message-State: AGi0PuaM5RcLzw63rd3DPlWDLhIimsitthI6ov/ik5belNEC1xHr0a4F
        lg+oWHrgY3yumwRjO4siY8GkFNQVVHait/wwx7c=
X-Google-Smtp-Source: APiQypKpQLTIEmPBlkNb/mJvpnVtQmj0oSSXVLfzbPQIzljzrUXXxbbXS8vMsiZMRXnwnNWajim3I0mgUTHSAVuXVPs=
X-Received: by 2002:a5d:8b57:: with SMTP id c23mr13684897iot.161.1587827779426;
 Sat, 25 Apr 2020 08:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <20200424084051.GA20801@willie-the-truck> <20200424170315.GH21141@willie-the-truck>
In-Reply-To: <20200424170315.GH21141@willie-the-truck>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 25 Apr 2020 17:16:08 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFGzBvrCr_-+_Gse8kpoPx49iCrLnVpb3JLT=GqaQA5+A@mail.gmail.com>
Message-ID: <CAMj1kXFGzBvrCr_-+_Gse8kpoPx49iCrLnVpb3JLT=GqaQA5+A@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To:     Will Deacon <will@kernel.org>
Cc:     Andre Przywara <andre.przywara@arm.com>,
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

On Fri, 24 Apr 2020 at 19:03, Will Deacon <will@kernel.org> wrote:
>
> On Fri, Apr 24, 2020 at 09:40:51AM +0100, Will Deacon wrote:
> > On Thu, Apr 23, 2020 at 06:38:39PM +0100, Andre Przywara wrote:
> > > an update for the CFI flash emulation, addressing Alex' comments and
> > > adding direct mapping support.
> > > The actual code changes to the flash emulation are minimal, mostly this
> > > is about renaming and cleanups.
> > > This versions now adds some patches. 1/5 is a required fix, the last
> > > three patches add mapping support as an extension. See below.
> >
> > Cheers, this mostly looks good to me. I've left a couple of minor comments,
> > and I'll give Alexandru a chance to have another look, but hopefully we can
> > merge it soon.
>
> Ok, I pushed this out along with the follow-up patch.
>

Cheers for that, this is useful stuff.

For the record, I did a quick benchmark on RPi4 booting Debian in a
VM, and I get the following delays (with GRUB and EFI timeouts both
set to 0)

17:04:58.487065
17:04:58.563700 UEFI firmware (version  built at 22:13:20 on Apr 23 2020)
17:04:58.853653 Welcome to GRUB!
17:04:58.924606 Booting `Debian GNU/Linux'
17:04:58.927835 Loading Linux 5.5.0-2-arm64 ...
17:04:59.063490 Loading initial ramdisk ...
17:05:01.303560 /dev/vda2: recovering journal
17:05:01.408861 /dev/vda2: clean, 37882/500960 files, 457154/2001920 blocks
17:05:09.646023 Debian GNU/Linux bullseye/sid rpi4vm64 ttyS0

So it takes less than 400 ms from starting kvmtool to entering GRUB
when the boot path is set normally. Any other delays you are observing
may be due to the fact that no boot path has been configured yet,
which is why it attempts PXE boot or other things.

Also, note that you can pass the --rng option to kvmtool to get the
EFI_RNG_PROTOCOL to be exposed to the EFI stub, for KASLR and for
seeding the kernel's RNG.
