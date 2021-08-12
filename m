Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8D3EABC3
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 22:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhHLU1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 16:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhHLU07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 16:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E738460C3F;
        Thu, 12 Aug 2021 20:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628799994;
        bh=gCEp159FxcYRrujxKawE9sngnP7fwMT//Cws8omxxXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Rlk/u6kQYLNpFKp8UJoMnJ47Gbu/5kTeNIql9WNhUq8z14w6/CePlVBh2xFgaNzNy
         JEeHenkeXihHz8fTtvPcrBLgUtLmLnrUuyCSQUFw9s48Tpr0MOA3XGeC7lWhHDpp95
         GDfiIpF6EtiY5RkNguRglHyxmYgdWLtVr5yVI4xzgV6GAulNFSUPx8vwoi5a8bcBSR
         k+caNmWAej31OGt5WsodKzUWNs/Kwc50GQkUFhI4t3zmlJ0v+1/imuH4BtOR4qdggN
         kxT9EF+Z5j4GS9Lc+eDJXAwfqRvlJovKk+UBYtNA/0Kk0TGY6b4alp0jgmV0gbd1TH
         5E4Boix3cf8Ow==
Date:   Thu, 12 Aug 2021 15:26:32 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210812202632.GA2504075@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812195126.GA4026@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
> > On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
> > > > On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
> > 
> > > > Do the other bus types have a flag analogous to
> > > > PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
> > > > other bus types, it'd be nice if the approach were similar.
> > > 
> > > They could, this series doesn't attempt it. I expect the approach to
> > > be similar as driver_override was copied from PCI to other
> > > busses. When this is completed I hope to take a look at it.
> > 
> > I think this would make more sense as two patches:
> > 
> >   - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
> >     since nothing in PCI depends on the VFIO-ness of drivers that use
> >     the flag.  The only point here is that driver id_table entries
> >     with this flag only match when driver_override matches the driver.
> 
> This would require using two flags, one to indicate the above to the
> PCI code and another to indicate the vfio_pci string to
> file2alias. This doesn't seem justified at this point, IMHO.

I don't think it requires two flags.  do_pci_entry() has:

  if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
    strcpy(alias, "vfio_pci:");

I'm just proposing a rename:

s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/

> >   - Update file2alias.c to export the flags and the "vfio_pci:" alias.
> >     This seems to be the only place where VFIO comes into play, and
> >     putting it in a separate patch will make it much smaller and it
> >     will be clear how it could be extended for other buses.
> 
> Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
> to the string "vfio_pci", that is just really confusing.

Hahaha, I see, that's fair :)  It confused me for a long time why you
wanted "VFIO" in the flag name because from the kernel's point of
view, the flag is not related to any VFIO-ness.  It's only related to
a special variety of driver_override, and VFIO happens to be one user
of it.

I think a separate patch that maps the flag to "vfio_pci" would be
less confusing because without the distractions of the PCI core
changes, it will be obvious that "vfio_" is a file2alias thing that's
there for userspace convenience, not for kernel reasons.

Do you envision any other prefixes in the future?  I hope we don't
have to clutter pci_match_device() with checking multiple flags.
Maybe the problem is that the modules.alias entry includes "vfio_" --
maybe we need a more generic prefix with just the idea of an
"alternate" driver.

Bjorn
