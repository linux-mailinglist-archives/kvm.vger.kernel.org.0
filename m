Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5E8255012
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 22:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgH0Udj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 16:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgH0Udi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 16:33:38 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B08BA20825;
        Thu, 27 Aug 2020 20:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598560417;
        bh=VHsROdKs2GEdTQFMnkMuUYNmQM5R5a6tmWKg4n+BRpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=MYOLYhgB7+6C3asPTPP4/fTyye9AIK1HUr0ELcuS4+6DZiwJjOqeYc6sO0DfTud+6
         sbcmnzXN6aGEIWGJaF3h+yhRZHckW8ylKPUywfBBJh6NXTNbeSFpg5YQf4n5SNNk1d
         RZvwonxTZxp+afPkDp2zdcM9YXA7Chd+QjaPq3WY=
Date:   Thu, 27 Aug 2020 15:33:35 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, bhelgaas@google.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3] PCI: Introduce flag for detached virtual functions
Message-ID: <20200827203335.GA2101829@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827131748.46b3f8bc@x1.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 27, 2020 at 01:17:48PM -0600, Alex Williamson wrote:
> On Thu, 27 Aug 2020 13:31:38 -0500
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
> > Re the subject line, this patch does a lot more than just "introduce a
> > flag"; AFAICT it actually enables important VFIO functionality, e.g.,
> > something like:
> > 
> >   vfio/pci: Enable MMIO access for s390 detached VFs
> > 
> > On Thu, Aug 13, 2020 at 11:40:43AM -0400, Matthew Rosato wrote:
> > > s390x has the notion of providing VFs to the kernel in a manner
> > > where the associated PF is inaccessible other than via firmware.
> > > These are not treated as typical VFs and access to them is emulated
> > > by underlying firmware which can still access the PF.  After
> > > the referened commit however these detached VFs were no longer able
> > > to work with vfio-pci as the firmware does not provide emulation of
> > > the PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
> > > these detached VFs so that vfio-pci can allow memory access to
> > > them again.  
> > 
> > Out of curiosity, in what sense is the PF inaccessible?  Is it
> > *impossible* for Linux to access the PF, or is it just not enumerated
> > by clp_list_pci() so Linux doesn't know about it?
> > 
> > VFs do not implement PCI_COMMAND, so I guess "firmware does not
> > provide emulation of PCI_COMMAND_MEMORY" means something like "we
> > can't access the PF so we can't enable/disable PCI_COMMAND_MEMORY"?
> > 
> > s/referened/referenced/
> > 
> > > Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > ---
> > >  arch/s390/pci/pci_bus.c            | 13 +++++++++++++
> > >  drivers/vfio/pci/vfio_pci_config.c |  8 ++++----
> > >  include/linux/pci.h                |  4 ++++
> > >  3 files changed, 21 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
> > > index 642a993..1b33076 100644
> > > --- a/arch/s390/pci/pci_bus.c
> > > +++ b/arch/s390/pci/pci_bus.c
> > > @@ -184,6 +184,19 @@ static inline int zpci_bus_setup_virtfn(struct zpci_bus *zbus,
> > >  }
> > >  #endif
> > >  
> > > +void pcibios_bus_add_device(struct pci_dev *pdev)
> > > +{
> > > +	struct zpci_dev *zdev = to_zpci(pdev);
> > > +
> > > +	/*
> > > +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
> > > +	 * detached from its parent PF.  We rely on firmware emulation to
> > > +	 * provide underlying PF details.  
> > 
> > What exactly does "multifunction bus" mean?  I'm familiar with
> > multi-function *devices*, but not multi-function buses.
> > 
> > > +	 */
> > > +	if (zdev->vfn && !zdev->zbus->multifunction)
> > > +		pdev->detached_vf = 1;
> > > +}
> > > +
> > >  static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
> > >  {
> > >  	struct pci_bus *bus;
> > > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > > index d98843f..98f93d1 100644
> > > --- a/drivers/vfio/pci/vfio_pci_config.c
> > > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > > @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
> > >  	 * PF SR-IOV capability, there's therefore no need to trigger
> > >  	 * faults based on the virtual value.
> > >  	 */
> > > -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> > > +	return dev_is_vf(&pdev->dev) || (cmd & PCI_COMMAND_MEMORY);  
> > 
> > I'm not super keen on the idea of having two subtly different ways of
> > identifying VFs.  I think that will be confusing.  This seems to be
> > the critical line, so whatever we do here, it will be out of the
> > ordinary and probably deserves a little comment.
> > 
> > If Linux doesn't see the PF, does pci_physfn(VF) return NULL, i.e., is
> > VF->physfn NULL?
> 
> FWIW, pci_physfn() never returns NULL, it returns the provided pdev if
> is_virtfn is not set.  This proposal wouldn't change that return value.
> AIUI pci_physfn(), the caller needs to test that the returned device is
> different from the provided device if there's really code that wants to
> traverse to the PF.

Oh, so this VF has is_virtfn==0.  That seems weird.  There are lots of
other ways that a VF is different: Vendor/Device IDs are 0xffff, BARs
are zeroes, etc.

It sounds like you're sweeping those under the rug by avoiding the
normal enumeration path (e.g., you don't have to size the BARs), but
if it actually is a VF, it seems like there might be fewer surprises
if we treat it as one.

Why don't you just set is_virtfn=1 since it *is* a VF, and then deal
with the special cases where you want to touch the PF?

Bjorn
