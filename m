Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B26C1A439B
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 10:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgDJIiV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Apr 2020 04:38:21 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39901 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgDJIiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 04:38:20 -0400
Received: by mail-ot1-f66.google.com with SMTP id x11so1238596otp.6
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 01:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MnkBps5dPQbD4CG4QaaMY0Tz9mlnoTRC3JihBNqhQXY=;
        b=VR6W+kTImnPRI7dT7Xuaw8zF167dsF081h6aPWf8qJebz78TB3VQ+f6CwIO/DWOkMg
         mxV2a/gt4ezl3bQfE/c74lUp/qoEkZ8R74xcnZQluA1vMYE9YinFY7eukBoKWgO5mEaG
         o2vUMBD9D/8wGurE21JjADyGrvAMewoRO/LRtl+H802FHedqY8dO/Cyz/CGqkOMVZikB
         taMKs5bnjGnkBSatORN7+4eWXjaPFMXtAdHCWJQc5KGCxLq6hhTHvlzLekqM4w4EGavk
         wM3Wykp0y9hDJmwTq5mCMJVitdJ9XuMFv14RD3JlwRP+P0pwEao7F0u6jPpwFZpZsYUn
         cXMg==
X-Gm-Message-State: AGi0Pua4sZY2NHoQqu9kMa2kNv1dbmLaoGuU5JarPfU0F+SQt5aV3TsT
        V/JjoLHFdO0HlClFN3LPTgZfG7zZG+UZzRjmL3M=
X-Google-Smtp-Source: APiQypLnP7keBKAvie0PujLeMFsnmkZ0mKJXIJALd/RsE3W5pvReIq2ncUcbVYj/EB8mrfZKOiVOTBLRHrLTrROTy5E=
X-Received: by 2002:a4a:95a9:: with SMTP id o38mr3377628ooi.76.1586507900498;
 Fri, 10 Apr 2020 01:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-20c384f1ea1a0bc7320bc445c72dd02d2970d594@kernel.org>
 <CAMuHMdUkff8XUrbHa90nGxa8Kj3HO9b2CRO57s3YZrSFPM51pg@mail.gmail.com> <f7fc96d4-de8e-cdce-bd98-242cdade2843@redhat.com>
In-Reply-To: <f7fc96d4-de8e-cdce-bd98-242cdade2843@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 10 Apr 2020 10:38:07 +0200
Message-ID: <CAMuHMdWcwtEaY9Dq5wpescGcj0Q1uYL=mg56ZQweXc4=DFXKKg@mail.gmail.com>
Subject: Re: vhost: refine vhost and vringh kconfig
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Fri, Apr 10, 2020 at 10:33 AM Jason Wang <jasowang@redhat.com> wrote:
> On 2020/4/10 下午3:53, Geert Uytterhoeven wrote:
> > On Thu, Apr 9, 2020 at 6:04 AM Linux Kernel Mailing List
> > <linux-kernel@vger.kernel.org> wrote:
> >> Commit:     20c384f1ea1a0bc7320bc445c72dd02d2970d594
> >> Parent:     5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031
> >> Refname:    refs/heads/master
> >> Web:        https://git.kernel.org/torvalds/c/20c384f1ea1a0bc7320bc445c72dd02d2970d594
> >> Author:     Jason Wang <jasowang@redhat.com>
> >> AuthorDate: Thu Mar 26 22:01:17 2020 +0800
> >> Committer:  Michael S. Tsirkin <mst@redhat.com>
> >> CommitDate: Wed Apr 1 12:06:26 2020 -0400
> >>
> >>      vhost: refine vhost and vringh kconfig
> >>
> >>      Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
> >>      not necessarily for VM since it's a generic userspace and kernel
> >>      communication protocol. Such dependency may prevent archs without
> >>      virtualization support from using vhost.
> >>
> >>      To solve this, a dedicated vhost menu is created under drivers so
> >>      CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
> >>
> >>      While at it, also squash Kconfig.vringh into vhost Kconfig file. This
> >>      avoids the trick of conditional inclusion from VOP or CAIF. Then it
> >>      will be easier to introduce new vringh users and common dependency for
> >>      both vringh and vhost.
> >>
> >>      Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>      Link: https://lore.kernel.org/r/20200326140125.19794-2-jasowang@redhat.com
> >>      Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >> ---
> >>   arch/arm/kvm/Kconfig         |  2 --
> >>   arch/arm64/kvm/Kconfig       |  2 --
> >>   arch/mips/kvm/Kconfig        |  2 --
> >>   arch/powerpc/kvm/Kconfig     |  2 --
> >>   arch/s390/kvm/Kconfig        |  4 ----
> >>   arch/x86/kvm/Kconfig         |  4 ----
> >>   drivers/Kconfig              |  2 ++
> >>   drivers/misc/mic/Kconfig     |  4 ----
> >>   drivers/net/caif/Kconfig     |  4 ----
> >>   drivers/vhost/Kconfig        | 28 +++++++++++++++++++++-------
> >>   drivers/vhost/Kconfig.vringh |  6 ------
> >>   11 files changed, 23 insertions(+), 37 deletions(-)
> >> --- a/drivers/vhost/Kconfig
> >> +++ b/drivers/vhost/Kconfig
> >> @@ -1,4 +1,23 @@
> >>   # SPDX-License-Identifier: GPL-2.0-only
> >> +config VHOST_RING
> >> +       tristate
> >> +       help
> >> +         This option is selected by any driver which needs to access
> >> +         the host side of a virtio ring.
> >> +
> >> +config VHOST
> >> +       tristate
> >> +       select VHOST_IOTLB
> >> +       help
> >> +         This option is selected by any driver which needs to access
> >> +         the core of vhost.
> >> +
> >> +menuconfig VHOST_MENU
> >> +       bool "VHOST drivers"
> >> +       default y
> > Please do not use default y. Your subsystem is not special.
>
>
> This is because before this patch VHOST depends on VIRTUALIZATION. So
> the archs whose defconfig that has VIRTUALIZATION can just enable e.g
> VHOST_NET without caring about VHOST_MENU.
>
> If this is not preferable, we can:
>
> 1) modify the defconfig and enable VHOST_MENU there
> 2) switch to use default y if $(all_archs_that_has_VIRTUALIZATION)

I think updating the few (1) defconfigs is preferable.
Else you put the burden on the maintainers of all the other (+400)
defconfigs, which will have to add "CONFIG_VHOST_MENU is not set".

> > I think this deserves a help text, so users know if they want to enable this
> > option or not.
>
> Will add one.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
