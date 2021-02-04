Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16AC30F082
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 11:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhBDKYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 05:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbhBDKYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 05:24:17 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668CBC0613ED
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 02:23:37 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id v1so2842729ott.10
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 02:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XcgEW3mAYPX38OWQ50gNyoqFplO8jrqalewwDA0jJOE=;
        b=YHA9xoBzq1LX0ETuIqq+7M2+Hnbb0ehp2yvYqQb4GOhhJPMSN3U0QTEpDUARMXC1HY
         MXMnQ2EV3hmX4Fu1ljjOugipjxZO2S6o/TlKawHs9SpSwEIB/fWlPLtbEr1PEBTQArwm
         gpsPmYli7yMR11+sEXcxnzrMHqvN3KCEdUpnw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XcgEW3mAYPX38OWQ50gNyoqFplO8jrqalewwDA0jJOE=;
        b=T73Pa6QriRH8ySgsoMStukj3fStRe3/GcpaU1Ryn6gbckqKsg/mLU/wJ+JLHI5qhL8
         gZvykSWBM8ug+DVoro9hyuYnjeCQzDigFTbk8w4nXWh5j6Zp+1er84B3yG6f6/lOY1VO
         JIgCl7WlRirm9fv3R9NxSj4+U5d+NXmpmL8jll1WS7meN3gdokZCl8JALmi87snqke4T
         zY4CJjDRCJZL4+FNRErpsjIrD/6tMGlS6yZvAhrbXyAv4YZGBJ1Jkj7rLMTw5CiGsJP3
         kNKJM2uK7RdzsDUNsCOAesAXYesR+46qd8HWMpIp7sp9Cm7JSB8VT4fyqbruhElzuk8M
         pwag==
X-Gm-Message-State: AOAM531Anw01MXwBUQq5jv0U16j+rNqrvka9S+DTDRGgxEQz/zwYbP6f
        B9cvu1YGorRJvSzniXuWqNTKWb2ViBrxbfz092Hn0A==
X-Google-Smtp-Source: ABdhPJzddeDp5OzUDd1HqtYjqPJri1JJBUg1S8JFKKQ3zalVUTBaKJqBAv/x2Tx9XPv1Q79n65DE9uF+y8y59uO90FY=
X-Received: by 2002:a9d:2265:: with SMTP id o92mr5162902ota.188.1612434216704;
 Thu, 04 Feb 2021 02:23:36 -0800 (PST)
MIME-Version: 1.0
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
 <20201127164131.2244124-13-daniel.vetter@ffwll.ch> <CAKMK7uGrdDrbtj0OyzqQc0CGrQwc2F3tFJU9vLfm2jjufAZ5YQ@mail.gmail.com>
 <YAbtZBU5PMr68q9E@kroah.com> <CAKMK7uGHSgetm7mDso6_vj+aGrR4u+ChwHb3k0QvgG0K6X2fPg@mail.gmail.com>
 <YAb4yD4IbpQ3qhJG@kroah.com> <CAKMK7uF9RfqhOGzcjgXTY62-dFS7ELr+uHuRDhEjOcO-kSgY+w@mail.gmail.com>
 <CAKMK7uG7QiP6m5jfidn7AWVhXp1JUZNpgpNPWOV6bqo9H+7vXA@mail.gmail.com>
In-Reply-To: <CAKMK7uG7QiP6m5jfidn7AWVhXp1JUZNpgpNPWOV6bqo9H+7vXA@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 4 Feb 2021 11:23:25 +0100
Message-ID: <CAKMK7uGbr0BQT65FT5iTBtiuorun+TtJdMyR2p_OAdfpHxCskg@mail.gmail.com>
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

On Wed, Feb 3, 2021 at 5:14 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote=
:
>
> On Tue, Jan 19, 2021 at 5:03 PM Daniel Vetter <daniel.vetter@ffwll.ch> wr=
ote:
> >
> > On Tue, Jan 19, 2021 at 4:20 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jan 19, 2021 at 03:34:47PM +0100, Daniel Vetter wrote:
> > > > On Tue, Jan 19, 2021 at 3:32 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Tue, Jan 19, 2021 at 09:17:55AM +0100, Daniel Vetter wrote:
> > > > > > On Fri, Nov 27, 2020 at 5:42 PM Daniel Vetter <daniel.vetter@ff=
wll.ch> wrote:
> > > > > > >
> > > > > > > Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver =
claims
> > > > > > > the region") /dev/kmem zaps ptes when the kernel requests exc=
lusive
> > > > > > > acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM,=
 this is
> > > > > > > the default for all driver uses.
> > > > > > >
> > > > > > > Except there's two more ways to access PCI BARs: sysfs and pr=
oc mmap
> > > > > > > support. Let's plug that hole.
> > > > > > >
> > > > > > > For revoke_devmem() to work we need to link our vma into the =
same
> > > > > > > address_space, with consistent vma->vm_pgoff. ->pgoff is alre=
ady
> > > > > > > adjusted, because that's how (io_)remap_pfn_range works, but =
for the
> > > > > > > mapping we need to adjust vma->vm_file->f_mapping. The cleane=
st way is
> > > > > > > to adjust this at at ->open time:
> > > > > > >
> > > > > > > - for sysfs this is easy, now that binary attributes support =
this. We
> > > > > > >   just set bin_attr->mapping when mmap is supported
> > > > > > > - for procfs it's a bit more tricky, since procfs pci access =
has only
> > > > > > >   one file per device, and access to a specific resources fir=
st needs
> > > > > > >   to be set up with some ioctl calls. But mmap is only suppor=
ted for
> > > > > > >   the same resources as sysfs exposes with mmap support, and =
otherwise
> > > > > > >   rejected, so we can set the mapping unconditionally at open=
 time
> > > > > > >   without harm.
> > > > > > >
> > > > > > > A special consideration is for arch_can_pci_mmap_io() - we ne=
ed to
> > > > > > > make sure that the ->f_mapping doesn't alias between ioport a=
nd iomem
> > > > > > > space. There's only 2 ways in-tree to support mmap of ioports=
: generic
> > > > > > > pci mmap (ARCH_GENERIC_PCI_MMAP_RESOURCE), and sparc as the s=
ingle
> > > > > > > architecture hand-rolling. Both approach support ioport mmap =
through a
> > > > > > > special pfn range and not through magic pte attributes. Alias=
ing is
> > > > > > > therefore not a problem.
> > > > > > >
> > > > > > > The only difference in access checks left is that sysfs PCI m=
map does
> > > > > > > not check for CAP_RAWIO. I'm not really sure whether that sho=
uld be
> > > > > > > added or not.
> > > > > > >
> > > > > > > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > > > > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > > > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > > > > > Cc: Kees Cook <keescook@chromium.org>
> > > > > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > > > > > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > > > > > Cc: Jan Kara <jack@suse.cz>
> > > > > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > > Cc: linux-mm@kvack.org
> > > > > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > > > > Cc: linux-samsung-soc@vger.kernel.org
> > > > > > > Cc: linux-media@vger.kernel.org
> > > > > > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > > > > > Cc: linux-pci@vger.kernel.org
> > > > > > > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > > > > --
> > > > > > > v2:
> > > > > > > - Totally new approach: Adjust filp->f_mapping at open time. =
Note that
> > > > > > >   this now works on all architectures, not just those support
> > > > > > >   ARCH_GENERIC_PCI_MMAP_RESOURCE
> > > > > > > ---
> > > > > > >  drivers/pci/pci-sysfs.c | 4 ++++
> > > > > > >  drivers/pci/proc.c      | 1 +
> > > > > > >  2 files changed, 5 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.=
c
> > > > > > > index d15c881e2e7e..3f1c31bc0b7c 100644
> > > > > > > --- a/drivers/pci/pci-sysfs.c
> > > > > > > +++ b/drivers/pci/pci-sysfs.c
> > > > > > > @@ -929,6 +929,7 @@ void pci_create_legacy_files(struct pci_b=
us *b)
> > > > > > >         b->legacy_io->read =3D pci_read_legacy_io;
> > > > > > >         b->legacy_io->write =3D pci_write_legacy_io;
> > > > > > >         b->legacy_io->mmap =3D pci_mmap_legacy_io;
> > > > > > > +       b->legacy_io->mapping =3D iomem_get_mapping();
> > > > > > >         pci_adjust_legacy_attr(b, pci_mmap_io);
> > > > > > >         error =3D device_create_bin_file(&b->dev, b->legacy_i=
o);
> > > > > > >         if (error)
> > > > > > > @@ -941,6 +942,7 @@ void pci_create_legacy_files(struct pci_b=
us *b)
> > > > > > >         b->legacy_mem->size =3D 1024*1024;
> > > > > > >         b->legacy_mem->attr.mode =3D 0600;
> > > > > > >         b->legacy_mem->mmap =3D pci_mmap_legacy_mem;
> > > > > > > +       b->legacy_io->mapping =3D iomem_get_mapping();
> > > > > >
> > > > > > Unlike the normal pci stuff below, the legacy files here go boo=
m
> > > > > > because they're set up much earlier in the boot sequence. This =
only
> > > > > > affects HAVE_PCI_LEGACY architectures, which aren't that many. =
So what
> > > > > > should we do here now:
> > > > > > - drop the devmem revoke for these
> > > > > > - rework the init sequence somehow to set up these files a lot =
later
> > > > > > - redo the sysfs patch so that it doesn't take an address_space
> > > > > > pointer, but instead a callback to get at that (since at open t=
ime
> > > > > > everything is set up). Imo rather ugly
> > > > > > - ditch this part of the series (since there's not really any t=
akers
> > > > > > for the latter parts it might just not make sense to push for t=
his)
> > > > > > - something else?
> > > > > >
> > > > > > Bjorn, Greg, thoughts?
> > > > >
> > > > > What sysfs patch are you referring to here?
> > > >
> > > > Currently in linux-next:
> > > >
> > > > commit 74b30195395c406c787280a77ae55aed82dbbfc7 (HEAD ->
> > > > topic/iomem-mmap-vs-gup, drm/topic/iomem-mmap-vs-gup)
> > > > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > Date:   Fri Nov 27 17:41:25 2020 +0100
> > > >
> > > >    sysfs: Support zapping of binary attr mmaps
> > > >
> > > > Or the patch right before this one in this submission here:
> > > >
> > > > https://lore.kernel.org/dri-devel/20201127164131.2244124-12-daniel.=
vetter@ffwll.ch/
> > >
> > > Ah.  Hm, a callback in the sysfs file logic seems really hairy, so I
> > > would prefer that not happen.  If no one really needs this stuff, why
> > > not just drop it like you mention?
> >
> > Well it is needed, but just on architectures I don't care about much.
> > Most relevant is perhaps powerpc (that's where Stephen hit the issue).
> > I do wonder whether we could move the legacy pci files setup to where
> > the modern stuff is set up from pci_create_resource_files() or maybe
> > pci_create_sysfs_dev_files() even for HAVE_PCI_LEGACY. I think that
> > might work, but since it's legacy flow on some funny architectures
> > (alpha, itanium, that kind of stuff) I have no idea what kind of
> > monsters I'm going to anger :-)
>
> Back from a week of vacation, I looked at this again and I think
> shouldn't be hard to fix this with the sam trick
> pci_create_sysfs_dev_files() uses: As long as sysfs_initialized isn't
> set we skip, and then later on when the vfs is up&running we can
> initialize everything.
>
> To be able to apply the same thing to pci_create_legacy_files() I
> think all I need is to iterate overa all struct pci_bus in
> pci_sysfs_init() and we're good. Unfortunately I didn't find any
> for_each_pci_bus(), so how do I do that?

pci_find_next_bus() seems to be the answer I want. I'll see whether
that works and then send out new patches.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
