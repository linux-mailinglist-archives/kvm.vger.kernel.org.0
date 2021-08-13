Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE1F3EBBA0
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhHMRp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 13:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHMRp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 13:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E1760F51;
        Fri, 13 Aug 2021 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628876701;
        bh=bjNRxrk7zkv1bWv18PnoYS0DrsVT6mJBjm94a5siq1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=rVmzHkHhe2OWZsF033BKoxTswdFF/eMUxnledbjriHTbCZkWlAHm9HKyLbtF/H1Cl
         5xAQ4w23l1qAcwRIO/lGPTnqceoufh08fatkyeUNJ/YQT+MAMUx417ihiIgBfQba3O
         46gIsPG+vzTsNLCzqq3NdtDyRER2IZa3sBStd0D9D6bf2r7hqOaotOmu1h1cyqoZbo
         5FvEqlpzAR/5EpbuMtsti5xd61YF8HowfVNesn4K/dvpGHf35B36dAwk/iyJCtJqny
         qaLXUKXRQ6u9D9wOKrd8si+ZekC/V/+wBHZFdv4oVAN+RWgdVdtIg7ldyegIMifCSv
         wSVZ2aCkUBgRw==
Date:   Fri, 13 Aug 2021 12:44:59 -0500
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
Message-ID: <20210813174459.GA2594783@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580beaa0-d15d-4e42-5a7b-073885416df9@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021 at 02:21:41AM +0300, Max Gurtovoy wrote:
> 
> On 8/12/2021 11:26 PM, Bjorn Helgaas wrote:
> > On Thu, Aug 12, 2021 at 04:51:26PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
> > > > On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
> > > > > On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
> > > > > > On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
> > > > > > Do the other bus types have a flag analogous to
> > > > > > PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
> > > > > > other bus types, it'd be nice if the approach were similar.
> > > > > They could, this series doesn't attempt it. I expect the approach to
> > > > > be similar as driver_override was copied from PCI to other
> > > > > busses. When this is completed I hope to take a look at it.
> > > > I think this would make more sense as two patches:
> > > > 
> > > >    - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
> > > >      since nothing in PCI depends on the VFIO-ness of drivers that use
> > > >      the flag.  The only point here is that driver id_table entries
> > > >      with this flag only match when driver_override matches the driver.
> > > This would require using two flags, one to indicate the above to the
> > > PCI code and another to indicate the vfio_pci string to
> > > file2alias. This doesn't seem justified at this point, IMHO.
> > I don't think it requires two flags.  do_pci_entry() has:
> > 
> >    if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> >      strcpy(alias, "vfio_pci:");
> > 
> > I'm just proposing a rename:
> > 
> > s/PCI_ID_F_VFIO_DRIVER_OVERRIDE/PCI_ID_DRIVER_OVERRIDE/
> > 
> > > >    - Update file2alias.c to export the flags and the "vfio_pci:" alias.
> > > >      This seems to be the only place where VFIO comes into play, and
> > > >      putting it in a separate patch will make it much smaller and it
> > > >      will be clear how it could be extended for other buses.
> > > Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
> > > to the string "vfio_pci", that is just really confusing.
> > Hahaha, I see, that's fair :)  It confused me for a long time why you
> > wanted "VFIO" in the flag name because from the kernel's point of
> > view, the flag is not related to any VFIO-ness.  It's only related to
> > a special variety of driver_override, and VFIO happens to be one user
> > of it.
> 
> In my original patch I used
> 
> #define PCI_ID_DRIVER_OVERRIDE PCI_ID_F_VFIO_DRIVER_OVERRIDE
> 
> and in the pci core code I used PCI_ID_DRIVER_OVERRIDE in the "if" clause.
> 
> So we can maybe do that and leave the option to future update of the define
> without changing the core code.
> 
> In the future we can have something like:
> 
> #define PCI_ID_DRIVER_OVERRIDE (PCI_ID_F_VFIO_DRIVER_OVERRIDE |
> PCI_ID_F_MY_BUS_DRIVER_OVERRIDE)
> 
> The file2alias.c still have to use the exact PCI_ID_F_VFIO_DRIVER_OVERRIDE
> flag to add "vfio_" prefix.
> 
> Is that better ?

I don't think it's worth having two separate #defines.  If we need
more in the future, we can add them when we need them.

What if we renamed "flags" to be specifically for this override case,
e.g., "override_only"?  Then the flag could be
PCI_ID_F_VFIO_DRIVER_OVERRIDE, which would trigger a "vfio_" prefix in
file2alias.c, but pci_match_device() could just check for it being
non-zero, without caring whether the reason is VFIO or something else,
e.g.,

  pci_match_device(...)
  {
    ...
    if (found_id->override_only) {
      if (dev->driver_override)
        return found_id;
      ...

Bjorn
