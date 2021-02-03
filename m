Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4161230DF79
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 17:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhBCQPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 11:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbhBCQPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 11:15:21 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FC3C061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 08:14:40 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id k142so397359oib.7
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 08:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bCfZ/a/6NOr6nE7maD0+c3yfEPShyNSVY7EhDvteykY=;
        b=F30Nrt9vPiAB/zyqMpbpGMCX5+9GbissyHIBmWRmyMfHwYjqRyqHPvGGNSQswndDl8
         ueuYjPhiYQRYrUuuoE2fCSgdN6wSgEVa4WV8ZAaC0Pdwh0MqPavWRi9wHjisevfaVscM
         tKXh1rpbVgrfZgdHoSxmfIAY/17F42+Ith6ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bCfZ/a/6NOr6nE7maD0+c3yfEPShyNSVY7EhDvteykY=;
        b=pZWicmGXDXaXfLQ2YAmTUgmg7N/yrVeYlAfZaku3GuAfoJnfvyOwtKdX/oArDE8QuW
         f6wdICv2UD/ntCIeKptAv4ywH6ry4AiYEZoQvys8C0knA5KmMwrDYBp4HXUjiQA3u24h
         wSzIwjbyNXOWVsPr7w5X1oeN47DbfuqfYoywYCfhzbFXjYPXOwmtjOnjAjmBZjon7QWM
         O3L0U0KmtBtgoZLRA1C/P6umNUeT6Z3svOC7ruyej8sZ60MCwYPcdTUKuC/9Z+z9klnJ
         aegK/+L/f65Mlr5n5CxwbjyrHdyT9tV120GNlDOd11+kaNymTn7Afv0u9/I6BrnY6fQz
         cKTA==
X-Gm-Message-State: AOAM531eNq1N5jOqV8Cjbt9w/TlV1p8BDsWXx9y6HmDL4+UzrF/QO4/m
        SUbB5DPVbXrG/g7KrYLjTbPsudqn0b8coohsujBO+A==
X-Google-Smtp-Source: ABdhPJxC2Hr09yAlU46Rq8Zw9mzo14g2j/8RncSJTzh5gFRD/Uq7tpWlsM64N23HZFbUWxoY/ZCynmvy0uA3EPvqdek=
X-Received: by 2002:aca:1906:: with SMTP id l6mr2422037oii.101.1612368880228;
 Wed, 03 Feb 2021 08:14:40 -0800 (PST)
MIME-Version: 1.0
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
 <20201127164131.2244124-13-daniel.vetter@ffwll.ch> <CAKMK7uGrdDrbtj0OyzqQc0CGrQwc2F3tFJU9vLfm2jjufAZ5YQ@mail.gmail.com>
 <YAbtZBU5PMr68q9E@kroah.com> <CAKMK7uGHSgetm7mDso6_vj+aGrR4u+ChwHb3k0QvgG0K6X2fPg@mail.gmail.com>
 <YAb4yD4IbpQ3qhJG@kroah.com> <CAKMK7uF9RfqhOGzcjgXTY62-dFS7ELr+uHuRDhEjOcO-kSgY+w@mail.gmail.com>
In-Reply-To: <CAKMK7uF9RfqhOGzcjgXTY62-dFS7ELr+uHuRDhEjOcO-kSgY+w@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 3 Feb 2021 17:14:29 +0100
Message-ID: <CAKMK7uG7QiP6m5jfidn7AWVhXp1JUZNpgpNPWOV6bqo9H+7vXA@mail.gmail.com>
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

On Tue, Jan 19, 2021 at 5:03 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> On Tue, Jan 19, 2021 at 4:20 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jan 19, 2021 at 03:34:47PM +0100, Daniel Vetter wrote:
> > > On Tue, Jan 19, 2021 at 3:32 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Jan 19, 2021 at 09:17:55AM +0100, Daniel Vetter wrote:
> > > > > On Fri, Nov 27, 2020 at 5:42 PM Daniel Vetter <daniel.vetter@ffwl=
l.ch> wrote:
> > > > > >
> > > > > > Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver cl=
aims
> > > > > > the region") /dev/kmem zaps ptes when the kernel requests exclu=
sive
> > > > > > acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, t=
his is
> > > > > > the default for all driver uses.
> > > > > >
> > > > > > Except there's two more ways to access PCI BARs: sysfs and proc=
 mmap
> > > > > > support. Let's plug that hole.
> > > > > >
> > > > > > For revoke_devmem() to work we need to link our vma into the sa=
me
> > > > > > address_space, with consistent vma->vm_pgoff. ->pgoff is alread=
y
> > > > > > adjusted, because that's how (io_)remap_pfn_range works, but fo=
r the
> > > > > > mapping we need to adjust vma->vm_file->f_mapping. The cleanest=
 way is
> > > > > > to adjust this at at ->open time:
> > > > > >
> > > > > > - for sysfs this is easy, now that binary attributes support th=
is. We
> > > > > >   just set bin_attr->mapping when mmap is supported
> > > > > > - for procfs it's a bit more tricky, since procfs pci access ha=
s only
> > > > > >   one file per device, and access to a specific resources first=
 needs
> > > > > >   to be set up with some ioctl calls. But mmap is only supporte=
d for
> > > > > >   the same resources as sysfs exposes with mmap support, and ot=
herwise
> > > > > >   rejected, so we can set the mapping unconditionally at open t=
ime
> > > > > >   without harm.
> > > > > >
> > > > > > A special consideration is for arch_can_pci_mmap_io() - we need=
 to
> > > > > > make sure that the ->f_mapping doesn't alias between ioport and=
 iomem
> > > > > > space. There's only 2 ways in-tree to support mmap of ioports: =
generic
> > > > > > pci mmap (ARCH_GENERIC_PCI_MMAP_RESOURCE), and sparc as the sin=
gle
> > > > > > architecture hand-rolling. Both approach support ioport mmap th=
rough a
> > > > > > special pfn range and not through magic pte attributes. Aliasin=
g is
> > > > > > therefore not a problem.
> > > > > >
> > > > > > The only difference in access checks left is that sysfs PCI mma=
p does
> > > > > > not check for CAP_RAWIO. I'm not really sure whether that shoul=
d be
> > > > > > added or not.
> > > > > >
> > > > > > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > > > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > > > > Cc: Kees Cook <keescook@chromium.org>
> > > > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > > > > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > > > > Cc: Jan Kara <jack@suse.cz>
> > > > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > Cc: linux-mm@kvack.org
> > > > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > > > Cc: linux-samsung-soc@vger.kernel.org
> > > > > > Cc: linux-media@vger.kernel.org
> > > > > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > > > > Cc: linux-pci@vger.kernel.org
> > > > > > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > > > --
> > > > > > v2:
> > > > > > - Totally new approach: Adjust filp->f_mapping at open time. No=
te that
> > > > > >   this now works on all architectures, not just those support
> > > > > >   ARCH_GENERIC_PCI_MMAP_RESOURCE
> > > > > > ---
> > > > > >  drivers/pci/pci-sysfs.c | 4 ++++
> > > > > >  drivers/pci/proc.c      | 1 +
> > > > > >  2 files changed, 5 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > > > > > index d15c881e2e7e..3f1c31bc0b7c 100644
> > > > > > --- a/drivers/pci/pci-sysfs.c
> > > > > > +++ b/drivers/pci/pci-sysfs.c
> > > > > > @@ -929,6 +929,7 @@ void pci_create_legacy_files(struct pci_bus=
 *b)
> > > > > >         b->legacy_io->read =3D pci_read_legacy_io;
> > > > > >         b->legacy_io->write =3D pci_write_legacy_io;
> > > > > >         b->legacy_io->mmap =3D pci_mmap_legacy_io;
> > > > > > +       b->legacy_io->mapping =3D iomem_get_mapping();
> > > > > >         pci_adjust_legacy_attr(b, pci_mmap_io);
> > > > > >         error =3D device_create_bin_file(&b->dev, b->legacy_io)=
;
> > > > > >         if (error)
> > > > > > @@ -941,6 +942,7 @@ void pci_create_legacy_files(struct pci_bus=
 *b)
> > > > > >         b->legacy_mem->size =3D 1024*1024;
> > > > > >         b->legacy_mem->attr.mode =3D 0600;
> > > > > >         b->legacy_mem->mmap =3D pci_mmap_legacy_mem;
> > > > > > +       b->legacy_io->mapping =3D iomem_get_mapping();
> > > > >
> > > > > Unlike the normal pci stuff below, the legacy files here go boom
> > > > > because they're set up much earlier in the boot sequence. This on=
ly
> > > > > affects HAVE_PCI_LEGACY architectures, which aren't that many. So=
 what
> > > > > should we do here now:
> > > > > - drop the devmem revoke for these
> > > > > - rework the init sequence somehow to set up these files a lot la=
ter
> > > > > - redo the sysfs patch so that it doesn't take an address_space
> > > > > pointer, but instead a callback to get at that (since at open tim=
e
> > > > > everything is set up). Imo rather ugly
> > > > > - ditch this part of the series (since there's not really any tak=
ers
> > > > > for the latter parts it might just not make sense to push for thi=
s)
> > > > > - something else?
> > > > >
> > > > > Bjorn, Greg, thoughts?
> > > >
> > > > What sysfs patch are you referring to here?
> > >
> > > Currently in linux-next:
> > >
> > > commit 74b30195395c406c787280a77ae55aed82dbbfc7 (HEAD ->
> > > topic/iomem-mmap-vs-gup, drm/topic/iomem-mmap-vs-gup)
> > > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > Date:   Fri Nov 27 17:41:25 2020 +0100
> > >
> > >    sysfs: Support zapping of binary attr mmaps
> > >
> > > Or the patch right before this one in this submission here:
> > >
> > > https://lore.kernel.org/dri-devel/20201127164131.2244124-12-daniel.ve=
tter@ffwll.ch/
> >
> > Ah.  Hm, a callback in the sysfs file logic seems really hairy, so I
> > would prefer that not happen.  If no one really needs this stuff, why
> > not just drop it like you mention?
>
> Well it is needed, but just on architectures I don't care about much.
> Most relevant is perhaps powerpc (that's where Stephen hit the issue).
> I do wonder whether we could move the legacy pci files setup to where
> the modern stuff is set up from pci_create_resource_files() or maybe
> pci_create_sysfs_dev_files() even for HAVE_PCI_LEGACY. I think that
> might work, but since it's legacy flow on some funny architectures
> (alpha, itanium, that kind of stuff) I have no idea what kind of
> monsters I'm going to anger :-)

Back from a week of vacation, I looked at this again and I think
shouldn't be hard to fix this with the sam trick
pci_create_sysfs_dev_files() uses: As long as sysfs_initialized isn't
set we skip, and then later on when the vfs is up&running we can
initialize everything.

To be able to apply the same thing to pci_create_legacy_files() I
think all I need is to iterate overa all struct pci_bus in
pci_sysfs_init() and we're good. Unfortunately I didn't find any
for_each_pci_bus(), so how do I do that?

Thanks, Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
