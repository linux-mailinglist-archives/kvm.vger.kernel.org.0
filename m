Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD0997E4D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfHUPNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 11:13:21 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:45022 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbfHUPNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 11:13:21 -0400
Received: by mail-vk1-f195.google.com with SMTP id 82so629725vkf.11;
        Wed, 21 Aug 2019 08:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jwGiMo+O0R1n33o38YZSlBCw9qrUKcNVmQ8Fpu4M47Q=;
        b=EQfRAFasLHyB52Xeg3H2BuQC55nTDJ12s3INgRKvDbvbAayJt1KH+Cm3uuxXGzsjoh
         IAIkBTdgVsWkwwrH7H28uDBoVqJDfDBlQkNjq6dGUUyarZJqU7aADamGAXQTAvjagURR
         D8Wxg5mDKiJJS3aDMGNHq0cauST/2W5jDnxogYE0llcgVKVHDBCWiZTZVcWRed6XzDWT
         ZyQLVT+e5X+Jew/2cQk+03fZ89U7S6Q71Fslbg3CeoZb594vhvCWdE5i0UxB4tY75/2R
         fXeEK2iDjnJjcASUNjStQAtINYh8x2Soxcz3A1PJbU4jSGtSzX2JqtOUvfoLvBMWRB+M
         mhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jwGiMo+O0R1n33o38YZSlBCw9qrUKcNVmQ8Fpu4M47Q=;
        b=ZpxE4OVV/u44YPgny9kx5IVdQLC/niN2BzQcaNKjYf2rRd85u/RxOWpW3xxn10r8k7
         09UA4dxqa5IvGoX7EpaypCI7OMootNGvx/UlUHl3EVdpRflHRPGbVHXCoHo4FALFhHVK
         PrS857KF5OgwOinOwi9CcHI+v2AeXWn1AbKSnMeiWsNtV4byY1JZT0dWRafnj2RKjm7H
         ufYwNiDfQeJHQ5U3cBCSyRSMe0R7ZuwgxG7IG+GQv9zFJJRNid9cZWDmUK7Kq7WO0Ojd
         U0CYYl+JEzjKJHf1FPR+/kWGq1FPl+voJRzRgkEU1tnAw8eOAv+Szaq9mQKaj5briCX4
         Lsfw==
X-Gm-Message-State: APjAAAUi/UFGa/ersID0Mo4HZfLhDrR37PnaumglDZ+4CinY5PUANNSJ
        Fcr4/WJRtS5hKGmqKaxrBKtQ9g0LA2CKF+d5qT4=
X-Google-Smtp-Source: APXvYqzYtms+BzTDyssdmKVF9MZHjSB7I37OzbD7+bX41f7u/F7vl3LogYbDFB3NGk4yjxQakq+w8b38L97NS4th6z8=
X-Received: by 2002:a1f:2192:: with SMTP id h140mr12759993vkh.6.1566400399975;
 Wed, 21 Aug 2019 08:13:19 -0700 (PDT)
MIME-Version: 1.0
References: <1566042663-16694-1-git-send-email-hexin15@baidu.com> <20190819135318.72f64e0d@x1.home>
In-Reply-To: <20190819135318.72f64e0d@x1.home>
From:   hexin <hexin.op@gmail.com>
Date:   Wed, 21 Aug 2019 23:13:08 +0800
Message-ID: <CAB_WELYZ80FHyjkcXj4WvBVx-N-3ZMURN3OXTqqbELVn90157g@mail.gmail.com>
Subject: Re: [PATCH v2] vfio_pci: Replace pci_try_reset_function() with
 __pci_reset_function_locked() to ensure that the pci device configuration
 space is restored to its original state
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, hexin <hexin15@baidu.com>,
        Liu Qi <liuqi16@baidu.com>, Zhang Yu <zhangyu31@baidu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> =E4=BA=8E2019=E5=B9=B48=E6=9C=
=8820=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=883:53=E5=86=99=E9=81=93=
=EF=BC=9A
>
> On Sat, 17 Aug 2019 19:51:03 +0800
> hexin <hexin.op@gmail.com> wrote:
>
> > In vfio_pci_enable(), save the device's initial configuration informati=
on
> > and then restore the configuration in vfio_pci_disable(). However, the
> > execution result is not the same. Since the pci_try_reset_function()
> > function saves the current state before resetting, the configuration
> > information restored by pci_load_and_free_saved_state() will be
> > overwritten. The __pci_reset_function_locked() function can be used
> > to prevent the configuration space from being overwritten.
> >
> > Fixes: 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
> > Signed-off-by: hexin <hexin15@baidu.com>
> > Signed-off-by: Liu Qi <liuqi16@baidu.com>
> > Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
>
> This looks good, but the subject is too long and I find the commit log
> somewhat confusing.  May I update these as follows?
>
>     vfio_pci: Restore original state on release
>
>     vfio_pci_enable() saves the device's initial configuration informatio=
n
>     with the intent that it is restored in vfio_pci_disable().  However,
>     commit 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
>     replaced the call to __pci_reset_function_locked(), which is not wrap=
ped
>     in a state save and restore, with pci_try_reset_function(), which
>     overwrites the restored device state with the current state before
>     applying it to the device.  Restore use of __pci_reset_function_locke=
d()
>     to return to the desired behavior.
>
> Thanks,
> Alex
>
>

Thanks for your update, the updated commit log is clearer than before.
At the same time, when I use checkpatch.pl to detect the patch, there
will be the
following error:

ERROR: Please use git commit description style 'commit <12+ chars of
sha1> ("<title line>")'
- ie: 'commit 890ed578df82 ("vfio-pci: Use pci "try" reset interface")'

Line 2785 ~ 2801 in checkpatch.pl, the script can't handle the commit messa=
ge
which contains double quotes because of the expression `([^"]+)`. Like
the "try" above.
Maybe checkpatch.pl needs to be modified.

Thanks=EF=BC=8C
HeXin


> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 703948c..0220616 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -438,11 +438,20 @@ static void vfio_pci_disable(struct vfio_pci_devi=
ce *vdev)
> >       pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE=
);
> >
> >       /*
> > -      * Try to reset the device.  The success of this is dependent on
> > -      * being able to lock the device, which is not always possible.
> > +      * Try to get the locks ourselves to prevent a deadlock. The
> > +      * success of this is dependent on being able to lock the device,
> > +      * which is not always possible.
> > +      * We can not use the "try" reset interface here, which will
> > +      * overwrite the previously restored configuration information.
> >        */
> > -     if (vdev->reset_works && !pci_try_reset_function(pdev))
> > -             vdev->needs_reset =3D false;
> > +     if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
> > +             if (device_trylock(&pdev->dev)) {
> > +                     if (!__pci_reset_function_locked(pdev))
> > +                             vdev->needs_reset =3D false;
> > +                     device_unlock(&pdev->dev);
> > +             }
> > +             pci_cfg_access_unlock(pdev);
> > +     }
> >
> >       pci_restore_state(pdev);
> >  out:
>
