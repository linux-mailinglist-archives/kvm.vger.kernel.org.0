Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A4E3EEE4A
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 16:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240094AbhHQOOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 10:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhHQOOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 10:14:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E9D60F14;
        Tue, 17 Aug 2021 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629209624;
        bh=eDfABMObGc7IM1jgLky5VHsy6jjutbTirChYbr3jPo4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=qY6vEcYgi5FUDe7YtLZd8uEiWa9HxaSzE0WzMvAZGQODXE1/IxjURVlF6JKdnjBeP
         UiEx2lMwk3rtL3fa29IDli0i434bCmWoux8rM33NRdT/rQmRdC2Yv3vgxPCvzqQqCl
         S8jj8hYHTHL4lpvlAa1w8kV7uYR6hteBdbfqUS1CMNQoLDlioK+rf8Ym4eRb9Ce1vd
         sd9VCK77SA/nJAGf4AYt+h33Npbw2sdvviT33hVGkINd2utImzEr54GPOS5jbmZsgz
         np8L12Ktor3rbXgYttZEqxEttVWn668dWU7njcaentaHtvPNnsT7joTtmJFyx/uap3
         9k9WFE92Riphw==
Date:   Tue, 17 Aug 2021 09:13:42 -0500
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
Message-ID: <20210817141342.GA3010409@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <872e77ee-5f6d-af10-805d-4954484e5399@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 04:01:49PM +0300, Max Gurtovoy wrote:
> On 8/16/2021 8:21 PM, Bjorn Helgaas wrote:
> > On Sun, Aug 15, 2021 at 02:27:13AM +0300, Max Gurtovoy wrote:
> > > On 8/13/2021 8:44 PM, Bjorn Helgaas wrote:
> > > > On Fri, Aug 13, 2021 at 02:21:41AM +0300, Max Gurtovoy wrote:
> > > > > On 8/12/2021 11:26 PM, Bjorn Helgaas wrote:
> > > > > > On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
> > > > > > > On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
> > > > > > > > On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
> > > > > > > > > On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
> > > > > > > > > > On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
> > > > > > > > > > Do the other bus types have a flag analogous to
> > > > > > > > > > PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
> > > > > > > > > > other bus types, it'd be nice if the approach were similar.
> > > > > > > > > They could, this series doesn't attempt it. I expect the approach to
> > > > > > > > > be similar as driver_override was copied from PCI to other
> > > > > > > > > busses. When this is completed I hope to take a look at it.
> > > > > > > > I think this would make more sense as two patches:
> > > > > > > > 
> > > > > > > >      - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
> > > > > > > >        since nothing in PCI depends on the VFIO-ness of drivers that use
> > > > > > > >        the flag.  The only point here is that driver id_table entries
> > > > > > > >        with this flag only match when driver_override matches the driver.
> > > > > > > This would require using two flags, one to indicate the above to the
> > > > > > > PCI code and another to indicate the vfio_pci string to
> > > > > > > file2alias. This doesn't seem justified at this point, IMHO.
> > > > > > I don't think it requires two flags.  do_pci_entry() has:
> > > > > > 
> > > > > >      if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> > > > > >        strcpy(alias, "vfio_pci:");
> > > > > > 
> > > > > > I'm just proposing a rename:
> > > > > > 
> > > > > > s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/
> > > > > > 
> > > > > > > >      - Update file2alias.c to export the flags and the "vfio_pci:" alias.
> > > > > > > >        This seems to be the only place where VFIO comes into play, and
> > > > > > > >        putting it in a separate patch will make it much smaller and it
> > > > > > > >        will be clear how it could be extended for other buses.
> > > > > > > Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
> > > > > > > to the string "vfio_pci", that is just really confusing.
> > > > > > Hahaha, I see, that's fair :)  It confused me for a long time why you
> > > > > > wanted "VFIO" in the flag name because from the kernel's point of
> > > > > > view, the flag is not related to any VFIO-ness.  It's only related to
> > > > > > a special variety of driver_override, and VFIO happens to be one user
> > > > > > of it.
> > > > > In my original patch I used
> > > > > 
> > > > > #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
> > > > > 
> > > > > and in the pci core code I used PCI_ID_DRIVER_OVERRIDE in the "if" clause.
> > > > > 
> > > > > So we can maybe do that and leave the option to future update of the define
> > > > > without changing the core code.
> > > > > 
> > > > > In the future we can have something like:
> > > > > 
> > > > > #define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
> > > > > PCI_ID_F_MY_BUS_DRIVER_OVERRIDE)
> > > > > 
> > > > > The file2alias.c still have to use the exact PCI_ID_F_VFIO_DRIVER_OVERRIDE
> > > > > flag to add "vfio_" prefix.
> > > > > 
> > > > > Is that better ?
> > > > I don't think it's worth having two separate #defines.  If we need
> > > > more in the future, we can add them when we need them.
> > > I meant 1 #define and 1 enum:
> > > 
> > > enum {
> > >      PCI_ID_F_VFIO_DRIVER_OVERRIDE    = 1 << 0,
> > > };
> > > 
> > > #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
> > Basically the same thing.  Doesn't seem worthwhile to me to have both.
> > When reading the code, it's not at all obvious why you would define a
> > new name for PCI_ID_F_VFIO_DRIVER_OVERRIDE.
> 
> because we need the "vfio_" prefix in the alias.
> 
> And the match can use PCI_ID_DRIVER_OVERRIDE that in the future cab be
> (#define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
> PCI_ID_F_SOME_OTHER_ALIAS_DRIVER_OVERRIDE)

Read this again:
https://lore.kernel.org/r/20210813174459.GA2594783@bjorn-Precision-5520

That gives you a "vfio_" prefix without the unnecessary VFIO
connection in pci_match_device.
