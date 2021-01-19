Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFAB2FBBEE
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 17:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391654AbhASQFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 11:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391644AbhASQFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 11:05:03 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1097C0613CF
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 08:03:59 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id 9so21680864oiq.3
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 08:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C4caimOCBoyRubav3xXjC9bOO4RtJRj6u6Pl4z9zDK0=;
        b=cRiSq8d643nzO4pMu5DLNNc8vejNL0rftgNwo0bq1cmYKpJ9RQQgeQBcbuFYMe3o7U
         IjjPn5H4rSlj8yVrLsnu9CCjWdcRP3/OLEKSDy6eP6U10ijmYkcVrj25wNwUPXW0QRw4
         MQ9e8vb+z2e/7MBXyzTZLBDCOG8dmK7KmJhfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C4caimOCBoyRubav3xXjC9bOO4RtJRj6u6Pl4z9zDK0=;
        b=c/uSlQCKcEsL/5qdMtuUvgDesaMBx1fifdinhR+3WhzGmvqVUOFig50NQVw2IFtWzh
         10NXYVmUgK4h+YVjVRC5n7eLJcAzcnMNWZSs1BbO8PUc9egXD25BBenxLkF4bm+rvx2Y
         lJAVT2w3OUM1SjDtrhmvUWwAd9FyVw+EvcP7Tl3FwKKuIrbmd9RQClCldAUV4tnV3cT7
         QkkaqE341ckoJj9+Bf7t82dcAimmyJCYDzGuEx2az8E5Fy7bV0jBS3u2vcS9gVX8aLyw
         MR53ZonbfDeMeRWfS29TSF37FbpcsP2qaBdBzCbLG7Ml23D3+XAr+HKH/oYjDe0mAOdj
         gYqg==
X-Gm-Message-State: AOAM530t93ATi/l5Rf7jXtOhqhaWtoN3R9KQ35dXOZkji9uRcJGVYLr1
        2iaN2rElfaCMBoAnbmFPOWhUwgOEeaZhm7zxcqwXWg==
X-Google-Smtp-Source: ABdhPJxoP/1TS61hjYhioQiQadr8vXmUqMbQUDNcQl+sUuH8lnBhXp5oW9ly3n43KoEIPweMIIdCTRX9dP/iNYA5ob0=
X-Received: by 2002:aca:ad92:: with SMTP id w140mr232065oie.128.1611072238805;
 Tue, 19 Jan 2021 08:03:58 -0800 (PST)
MIME-Version: 1.0
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
 <20201127164131.2244124-13-daniel.vetter@ffwll.ch> <CAKMK7uGrdDrbtj0OyzqQc0CGrQwc2F3tFJU9vLfm2jjufAZ5YQ@mail.gmail.com>
 <YAbtZBU5PMr68q9E@kroah.com> <CAKMK7uGHSgetm7mDso6_vj+aGrR4u+ChwHb3k0QvgG0K6X2fPg@mail.gmail.com>
 <YAb4yD4IbpQ3qhJG@kroah.com>
In-Reply-To: <YAb4yD4IbpQ3qhJG@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 19 Jan 2021 17:03:47 +0100
Message-ID: <CAKMK7uF9RfqhOGzcjgXTY62-dFS7ELr+uHuRDhEjOcO-kSgY+w@mail.gmail.com>
Subject: Re: [PATCH v7 12/17] PCI: Revoke mappings like devmem
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 4:20 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 19, 2021 at 03:34:47PM +0100, Daniel Vetter wrote:
> > On Tue, Jan 19, 2021 at 3:32 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jan 19, 2021 at 09:17:55AM +0100, Daniel Vetter wrote:
> > > > On Fri, Nov 27, 2020 at 5:42 PM Daniel Vetter <daniel.vetter@ffwll.=
ch> wrote:
> > > > >
> > > > > Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver clai=
ms
> > > > > the region") /dev/kmem zaps ptes when the kernel requests exclusi=
ve
> > > > > acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, thi=
s is
> > > > > the default for all driver uses.
> > > > >
> > > > > Except there's two more ways to access PCI BARs: sysfs and proc m=
map
> > > > > support. Let's plug that hole.
> > > > >
> > > > > For revoke_devmem() to work we need to link our vma into the same
> > > > > address_space, with consistent vma->vm_pgoff. ->pgoff is already
> > > > > adjusted, because that's how (io_)remap_pfn_range works, but for =
the
> > > > > mapping we need to adjust vma->vm_file->f_mapping. The cleanest w=
ay is
> > > > > to adjust this at at ->open time:
> > > > >
> > > > > - for sysfs this is easy, now that binary attributes support this=
. We
> > > > >   just set bin_attr->mapping when mmap is supported
> > > > > - for procfs it's a bit more tricky, since procfs pci access has =
only
> > > > >   one file per device, and access to a specific resources first n=
eeds
> > > > >   to be set up with some ioctl calls. But mmap is only supported =
for
> > > > >   the same resources as sysfs exposes with mmap support, and othe=
rwise
> > > > >   rejected, so we can set the mapping unconditionally at open tim=
e
> > > > >   without harm.
> > > > >
> > > > > A special consideration is for arch_can_pci_mmap_io() - we need t=
o
> > > > > make sure that the ->f_mapping doesn't alias between ioport and i=
omem
> > > > > space. There's only 2 ways in-tree to support mmap of ioports: ge=
neric
> > > > > pci mmap (ARCH_GENERIC_PCI_MMAP_RESOURCE), and sparc as the singl=
e
> > > > > architecture hand-rolling. Both approach support ioport mmap thro=
ugh a
> > > > > special pfn range and not through magic pte attributes. Aliasing =
is
> > > > > therefore not a problem.
> > > > >
> > > > > The only difference in access checks left is that sysfs PCI mmap =
does
> > > > > not check for CAP_RAWIO. I'm not really sure whether that should =
be
> > > > > added or not.
> > > > >
> > > > > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > > > Cc: Kees Cook <keescook@chromium.org>
> > > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > > > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > > > Cc: Jan Kara <jack@suse.cz>
> > > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Cc: linux-mm@kvack.org
> > > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > > Cc: linux-samsung-soc@vger.kernel.org
> > > > > Cc: linux-media@vger.kernel.org
> > > > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > > > Cc: linux-pci@vger.kernel.org
> > > > > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > > --
> > > > > v2:
> > > > > - Totally new approach: Adjust filp->f_mapping at open time. Note=
 that
> > > > >   this now works on all architectures, not just those support
> > > > >   ARCH_GENERIC_PCI_MMAP_RESOURCE
> > > > > ---
> > > > >  drivers/pci/pci-sysfs.c | 4 ++++
> > > > >  drivers/pci/proc.c      | 1 +
> > > > >  2 files changed, 5 insertions(+)
> > > > >
> > > > > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > > > > index d15c881e2e7e..3f1c31bc0b7c 100644
> > > > > --- a/drivers/pci/pci-sysfs.c
> > > > > +++ b/drivers/pci/pci-sysfs.c
> > > > > @@ -929,6 +929,7 @@ void pci_create_legacy_files(struct pci_bus *=
b)
> > > > >         b->legacy_io->read =3D pci_read_legacy_io;
> > > > >         b->legacy_io->write =3D pci_write_legacy_io;
> > > > >         b->legacy_io->mmap =3D pci_mmap_legacy_io;
> > > > > +       b->legacy_io->mapping =3D iomem_get_mapping();
> > > > >         pci_adjust_legacy_attr(b, pci_mmap_io);
> > > > >         error =3D device_create_bin_file(&b->dev, b->legacy_io);
> > > > >         if (error)
> > > > > @@ -941,6 +942,7 @@ void pci_create_legacy_files(struct pci_bus *=
b)
> > > > >         b->legacy_mem->size =3D 1024*1024;
> > > > >         b->legacy_mem->attr.mode =3D 0600;
> > > > >         b->legacy_mem->mmap =3D pci_mmap_legacy_mem;
> > > > > +       b->legacy_io->mapping =3D iomem_get_mapping();
> > > >
> > > > Unlike the normal pci stuff below, the legacy files here go boom
> > > > because they're set up much earlier in the boot sequence. This only
> > > > affects HAVE_PCI_LEGACY architectures, which aren't that many. So w=
hat
> > > > should we do here now:
> > > > - drop the devmem revoke for these
> > > > - rework the init sequence somehow to set up these files a lot late=
r
> > > > - redo the sysfs patch so that it doesn't take an address_space
> > > > pointer, but instead a callback to get at that (since at open time
> > > > everything is set up). Imo rather ugly
> > > > - ditch this part of the series (since there's not really any taker=
s
> > > > for the latter parts it might just not make sense to push for this)
> > > > - something else?
> > > >
> > > > Bjorn, Greg, thoughts?
> > >
> > > What sysfs patch are you referring to here?
> >
> > Currently in linux-next:
> >
> > commit 74b30195395c406c787280a77ae55aed82dbbfc7 (HEAD ->
> > topic/iomem-mmap-vs-gup, drm/topic/iomem-mmap-vs-gup)
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Fri Nov 27 17:41:25 2020 +0100
> >
> >    sysfs: Support zapping of binary attr mmaps
> >
> > Or the patch right before this one in this submission here:
> >
> > https://lore.kernel.org/dri-devel/20201127164131.2244124-12-daniel.vett=
er@ffwll.ch/
>
> Ah.  Hm, a callback in the sysfs file logic seems really hairy, so I
> would prefer that not happen.  If no one really needs this stuff, why
> not just drop it like you mention?

Well it is needed, but just on architectures I don't care about much.
Most relevant is perhaps powerpc (that's where Stephen hit the issue).
I do wonder whether we could move the legacy pci files setup to where
the modern stuff is set up from pci_create_resource_files() or maybe
pci_create_sysfs_dev_files() even for HAVE_PCI_LEGACY. I think that
might work, but since it's legacy flow on some funny architectures
(alpha, itanium, that kind of stuff) I have no idea what kind of
monsters I'm going to anger :-)
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
