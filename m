Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C88728867E
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgJIKBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387473AbgJIKBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 06:01:54 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62733C0613D2
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 03:01:52 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id y127so2231056ooa.5
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 03:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ftHJzNt4bERnNP+SIXIGo56JCvpL8TcP22nYSQKOV5k=;
        b=UzMeV+rwKkunQlHgHNSlVY990btw6GRORlFmsAYBx1gPA8SEXpEqpXIa8uGJFLzTQw
         b8BMC7q8QXr1fDrrdZMhmylgPVoMLs2HnzRpCUYwl2q2F4u0Dr/m3fS3LlJ3o6+Ejdce
         Wcj4zRQKhHrsGCyXRc5pfd4UfW1pvcEdIaWfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ftHJzNt4bERnNP+SIXIGo56JCvpL8TcP22nYSQKOV5k=;
        b=HA+GbCk6Xk82yvDlO3LFVRlnO/gnTQfRcPg5TvxUh6/ZQ8t9sh9tuEQ5kQsDDPD6nK
         xKK6XfBNTJJ7FCZCG1SsW7B4owIOOmSAPTb2R5ckYw8zcmJ9WwWG0oSn5ynE+P4ubB91
         vBbqskvFeEfEc/Dsuy9LVbeCYLxKP2/9aG5pfxULhU9m+gs8IbIVAYcVB4M8U7+mk9hr
         RDZ5A9fSaPSakvGCi7t2MZjwcBmPmVMm9GgfkSMoYTleZNS7DaZLAXcudObM7QOBgE+U
         qzp4+e2I3o+XcN8ePgNzaO2d2DqdM3zB+6HxpJJP+N7yu99RSDaIo+pkRTWKJS+sW28g
         ULog==
X-Gm-Message-State: AOAM532Hu4CN5bm26KjwLYZx5V+EOvJIrq0dfq9AqiuOcRI4mWgP5zj+
        EJjWlSxihh227JzPdALtpTqr4FCNRM2nvruzTE5tRy1u9nbPbA==
X-Google-Smtp-Source: ABdhPJyck/sz2r8nAE1vOQ+mmU8ZRo9mJI1evvAL5G2Nq41icTgyJhGztZHNyIlc3HZk+r5jBb8vWdtCG7CV4AmWN/U=
X-Received: by 2002:a4a:e592:: with SMTP id o18mr8337874oov.28.1602237711175;
 Fri, 09 Oct 2020 03:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-18-daniel.vetter@ffwll.ch> <20201009094750.GQ6112@intel.com>
In-Reply-To: <20201009094750.GQ6112@intel.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 9 Oct 2020 12:01:39 +0200
Message-ID: <CAKMK7uH3o3hnRkTDqr93PR=wuRejpty+AbyMacoEFDDb6OgJeQ@mail.gmail.com>
Subject: Re: [PATCH v2 17/17] drm/i915: Properly request PCI BARs
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Kees Cook <keescook@chromium.org>,
        KVM list <kvm@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 9, 2020 at 11:47 AM Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>
> On Fri, Oct 09, 2020 at 09:59:34AM +0200, Daniel Vetter wrote:
> > When trying to test my CONFIG_IO_STRICT_DEVMEM changes I realized they
> > do nothing for i915. Because i915 doesn't request any regions, like
> > pretty much all drm pci drivers. I guess this is some very old
> > remnants from the userspace modesetting days, when we wanted to
> > co-exist with the fbdev driver. Which usually requested these
> > resources.
> >
> > But makes me wonder why the pci subsystem doesn't just request
> > resource automatically when we map a bar and a pci driver is bound?
> >
> > Knowledge about which pci bars we need kludged together from
> > intel_uncore.c and intel_gtt.c from i915 and intel-gtt.c over in the
> > fake agp driver.
> >
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: linux-pci@vger.kernel.org
> > ---
> >  drivers/gpu/drm/i915/intel_uncore.c | 25 +++++++++++++++++++++++--
> >  1 file changed, 23 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915=
/intel_uncore.c
> > index 54e201fdeba4..ce39049d8919 100644
> > --- a/drivers/gpu/drm/i915/intel_uncore.c
> > +++ b/drivers/gpu/drm/i915/intel_uncore.c
> > @@ -1692,10 +1692,13 @@ static int uncore_mmio_setup(struct intel_uncor=
e *uncore)
> >       struct pci_dev *pdev =3D i915->drm.pdev;
> >       int mmio_bar;
> >       int mmio_size;
> > +     int bar_selection;
>
> Signed bitmasks always make me uneasy. But looks like
> that's what it is in the pci api. So meh.

Yeah it's surprising.

> > +     int ret;
> >
> >       mmio_bar =3D IS_GEN(i915, 2) ? 1 : 0;
> > +     bar_selection =3D BIT (2) | BIT(mmio_bar);
>                            ^
> spurious space
>
> That's also not correct for gen2 I think.
>
> gen2:
> 0 =3D GMADR
> 1 =3D MMADR
> 2 =3D IOBAR
>
> gen3:
> 0 =3D MMADR
> 1 =3D IOBAR
> 2 =3D GMADR
> 3 =3D GTTADR
>
> gen4+:
> 0+1 =3D GTTMMADR
> 2+3 =3D GMADR
> 4 =3D IOBAR
>
> Maybe we should just have an explicit list of bars like that in a
> comment?
>
> I'd also suggest sucking this bitmask calculation into a small helper
> so you can reuse it for the release.

tbh I just hacked this up for testing. Given how almost no other drm
driver does this, I'm wondering whether we should or not.

Also the only reason why I didn't just use the pci_request_regions
helper is to avoid the vga ioport range, since that's managed by
vgaarbiter.

So I think if we go for this for real we should:
- register the vga ioport range in the vgaarbiter
- have a pci_request_iomem_regions helper that grabs all mem bars
- roll that out to all drm pci drivers

Or something like that. The other complication is when we resize the
iobar. So not really sure what to do here.
-Daniel

>
> >       /*
> > -      * Before gen4, the registers and the GTT are behind different BA=
Rs.
> > +      * On gen3 the registers and the GTT are behind different BARs.
> >        * However, from gen4 onwards, the registers and the GTT are shar=
ed
> >        * in the same BAR, so we want to restrict this ioremap from
> >        * clobbering the GTT which we want ioremap_wc instead. Fortunate=
ly,
> > @@ -1703,6 +1706,8 @@ static int uncore_mmio_setup(struct intel_uncore =
*uncore)
> >        * generations up to Ironlake.
> >        * For dgfx chips register range is expanded to 4MB.
> >        */
> > +     if (INTEL_GEN(i915) =3D=3D 3)
> > +             bar_selection |=3D BIT(3);
> >       if (INTEL_GEN(i915) < 5)
> >               mmio_size =3D 512 * 1024;
> >       else if (IS_DGFX(i915))
> > @@ -1710,8 +1715,15 @@ static int uncore_mmio_setup(struct intel_uncore=
 *uncore)
> >       else
> >               mmio_size =3D 2 * 1024 * 1024;
> >
> > +     ret =3D pci_request_selected_regions(pdev, bar_selection, "i915")=
;
> > +     if (ret < 0) {
> > +             drm_err(&i915->drm, "failed to request pci bars\n");
> > +             return ret;
> > +     }
> > +
> >       uncore->regs =3D pci_iomap(pdev, mmio_bar, mmio_size);
> >       if (uncore->regs =3D=3D NULL) {
> > +             pci_release_selected_regions(pdev, bar_selection);
> >               drm_err(&i915->drm, "failed to map registers\n");
> >               return -EIO;
> >       }
> > @@ -1721,9 +1733,18 @@ static int uncore_mmio_setup(struct intel_uncore=
 *uncore)
> >
> >  static void uncore_mmio_cleanup(struct intel_uncore *uncore)
> >  {
> > -     struct pci_dev *pdev =3D uncore->i915->drm.pdev;
> > +     struct drm_i915_private *i915 =3D uncore->i915;
> > +     struct pci_dev *pdev =3D i915->drm.pdev;
> > +     int mmio_bar;
> > +     int bar_selection;
> > +
> > +     mmio_bar =3D IS_GEN(i915, 2) ? 1 : 0;
> > +     bar_selection =3D BIT (2) | BIT(mmio_bar);
> > +     if (INTEL_GEN(i915) =3D=3D 3)
> > +             bar_selection |=3D BIT(3);
> >
> >       pci_iounmap(pdev, uncore->regs);
> > +     pci_release_selected_regions(pdev, bar_selection);
> >  }
> >
> >  void intel_uncore_init_early(struct intel_uncore *uncore,
> > --
> > 2.28.0
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> --
> Ville Syrj=C3=A4l=C3=A4
> Intel



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
