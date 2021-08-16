Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C3E3EDC51
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 19:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhHPRWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 13:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhHPRWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 13:22:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3162060F36;
        Mon, 16 Aug 2021 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629134518;
        bh=T95dy8xDwmnj3xMLg+BxdSqSlJdDFxTpNhwOo+ufyxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=q/jcjvQp5u7c4Z4NX4k89/A9rvxJX6opl1ESU8/tEAKSG3pbBYPqGiOXIMIlu7aeE
         VxB6xriFBE2R81fM69E497PuFPIhzmfbR8IJaL4PCQWvpt0eZuUmT1LJ4kqCErljNk
         zsGHB9OhlpB9p7YroNnkFU2bk1LbDQIDxNe03dGq8cfIexMvwpXuyhBOTAXl/lKdz5
         3veEAWdG+/ligzxOf1OyiNQdfIx/6GolN6wr8Eq6Xvf+lrkw+DUbaBaKJfCbRwn7tO
         kEQ/6rMyi+6u2+FXzJh7UzzDGMaC/jXmm6fsFmyAqslon3YLwoivbBgG9ymqyzPzry
         cmmva8bSOKDEA==
Date:   Mon, 16 Aug 2021 12:21:56 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210816172156.GA2928236@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ee30d21-5305-5e58-6fa2-da74b2c8ff5a@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 15, 2021 at 02:27:13AM +0300, Max Gurtovoy wrote:
> On 8/13/2021 8:44 PM, Bjorn Helgaas wrote:
> > On Fri, Aug 13, 2021 at 02:21:41AM +0300, Max Gurtovoy wrote:
> > > On 8/12/2021 11:26 PM, Bjorn Helgaas wrote:
> > > > On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
> > > > > > On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
> > > > > > > On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
> > > > > > > > On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
> > > > > > > > Do the other bus types have a flag analogous to
> > > > > > > > PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
> > > > > > > > other bus types, it'd be nice if the approach were similar.
> > > > > > > They could, this series doesn't attempt it. I expect the approach to
> > > > > > > be similar as driver_override was copied from PCI to other
> > > > > > > busses. When this is completed I hope to take a look at it.
> > > > > > I think this would make more sense as two patches:
> > > > > > 
> > > > > >     - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
> > > > > >       since nothing in PCI depends on the VFIO-ness of drivers that use
> > > > > >       the flag.  The only point here is that driver id_table entries
> > > > > >       with this flag only match when driver_override matches the driver.
> > > > > This would require using two flags, one to indicate the above to the
> > > > > PCI code and another to indicate the vfio_pci string to
> > > > > file2alias. This doesn't seem justified at this point, IMHO.
> > > > I don't think it requires two flags.  do_pci_entry() has:
> > > > 
> > > >     if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> > > >       strcpy(alias, "vfio_pci:");
> > > > 
> > > > I'm just proposing a rename:
> > > > 
> > > > s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/
> > > > 
> > > > > >     - Update file2alias.c to export the flags and the "vfio_pci:" alias.
> > > > > >       This seems to be the only place where VFIO comes into play, and
> > > > > >       putting it in a separate patch will make it much smaller and it
> > > > > >       will be clear how it could be extended for other buses.
> > > > > Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
> > > > > to the string "vfio_pci", that is just really confusing.
> > > > Hahaha, I see, that's fair :)  It confused me for a long time why you
> > > > wanted "VFIO" in the flag name because from the kernel's point of
> > > > view, the flag is not related to any VFIO-ness.  It's only related to
> > > > a special variety of driver_override, and VFIO happens to be one user
> > > > of it.
> > > In my original patch I used
> > > 
> > > #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
> > > 
> > > and in the pci core code I used PCI_ID_DRIVER_OVERRIDE in the "if" clause.
> > > 
> > > So we can maybe do that and leave the option to future update of the define
> > > without changing the core code.
> > > 
> > > In the future we can have something like:
> > > 
> > > #define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
> > > PCI_ID_F_MY_BUS_DRIVER_OVERRIDE)
> > > 
> > > The file2alias.c still have to use the exact PCI_ID_F_VFIO_DRIVER_OVERRIDE
> > > flag to add "vfio_" prefix.
> > > 
> > > Is that better ?
> > I don't think it's worth having two separate #defines.  If we need
> > more in the future, we can add them when we need them.
> 
> I meant 1 #define and 1 enum:
> 
> enum {
>     PCI_ID_F_VFIO_DRIVER_OVERRIDE    = 1 << 0,
> };
> 
> #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE

Basically the same thing.  Doesn't seem worthwhile to me to have both.
When reading the code, it's not at all obvious why you would define a
new name for PCI_ID_F_VFIO_DRIVER_OVERRIDE.

> > What if we renamed "flags" to be specifically for this override case,
> > e.g., "override_only"?  Then the flag could be
> > PCI_ID_F_VFIO_DRIVER_OVERRIDE, which would trigger a "vfio_" prefix in
> > file2alias.c, but pci_match_device() could just check for it being
> > non-zero, without caring whether the reason is VFIO or something else,
> > e.g.,
> > 
> >    pci_match_device(...)
> >    {
> >      ...
> >      if (found_id->override_only) {
> >        if (dev->driver_override)
> >          return found_id;
> >        ...
> 
> Jason suggested something like this:
> 
> static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>                             struct pci_dev *dev)
> {
>     struct pci_dynid *dynid;
>     const struct pci_device_id *found_id = NULL, *ids;
> 
>     /* When driver_override is set, only bind to the matching driver */
>     if (dev->driver_override && strcmp(dev->driver_override, drv->name))
>         return NULL;
> 
>     /* Look at the dynamic ids first, before the static ones */
>     spin_lock(&drv->dynids.lock);
>     list_for_each_entry(dynid, &drv->dynids.list, node) {
>         if (pci_match_one_device(&dynid->id, dev)) {
>             found_id = &dynid->id;
>             break;
>         }
>     }
>     spin_unlock(&drv->dynids.lock);
> 
>     if (found_id)
>         return found_id;
> 
>     for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
>          ids = found_id + 1) {
>         /*
>          * The match table is split based on driver_override. Check the
>          * flags as well so that any matching
>          * PCI_ID_F_VFIO_DRIVER_OVERRIDE entry is returned.
>          */
>         if (!(found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) ||
>             dev->driver_override)
>             return found_id;
>     }
> 
>     /*
>      * if no static match, driver_override will always match, send a dummy
>      * id.
>      */
>     if (dev->driver_override)
>         return &pci_device_id_any;
>     return NULL;
> }
> 
> 
> It looks good to me as well.

I missed your point.  Isn't the above basically the 09/12 patch [1] we're
talking about?

Yes, I see the code structure is slightly different, but the question
we're talking about here is the name of the "flags" field and the enum
or #define for the VFIO bit.

> I prefer the "flags" naming since its more generic and easy to extend.

We don't need to worry about "flags" being generic or extensible until
we need to extend it.  It's easy to fiddle with it at that point.

> can we continue with the above suggestion for V2 ?

I don't see what really changed with the above suggestion.

The point I'm trying to make is that using PCI_ID_F_VFIO_DRIVER_OVERRIDE 
in pci_match_device() suggests that the code there has some connection
or dependency on VFIO, but it does not.

[1] https://lore.kernel.org/r/20210721161609.68223-10-yishaih@nvidia.com
