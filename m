Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35392A6A91
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbgKDQvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 11:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731683AbgKDQuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 11:50:20 -0500
Received: from localhost (230.sub-72-107-127.myvzw.com [72.107.127.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01712206CA;
        Wed,  4 Nov 2020 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604508619;
        bh=KzXcQsv6oXQiPT6pQbTFR35Ks2A09AmGg4NdOMxDZU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=C3pX6cmo6q8mwyEj5GO30o1K3DmrMhjsd197OHFiySwAIRZVIm3gcmWDrE+eCPQYz
         sPh4rcY/+zTADvqe8t10fQKgN6B/uva7r/Rm33jjbBhTlqD9gCI3SGCFFhZSFec0de
         QvdkQtLCYpZ8r9E77lkRpGYf+6s0+xBDMYsFK0NQ=
Date:   Wed, 4 Nov 2020 10:50:17 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v5 11/15] PCI: Obey iomem restrictions for procfs mmap
Message-ID: <20201104165017.GA352206@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uF0QjesaNs97N-G8cZkXuAmFgcmTfHvoCP94br_WVcV6Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 09:44:04AM +0100, Daniel Vetter wrote:
> On Tue, Nov 3, 2020 at 11:09 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > On Tue, Nov 3, 2020 at 1:28 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > On Fri, Oct 30, 2020 at 11:08:11AM +0100, Daniel Vetter wrote:
> > > > There's three ways to access PCI BARs from userspace: /dev/mem, sysfs
> > > > files, and the old proc interface. Two check against
> > > > iomem_is_exclusive, proc never did. And with CONFIG_IO_STRICT_DEVMEM,
> > > > this starts to matter, since we don't want random userspace having
> > > > access to PCI BARs while a driver is loaded and using it.
> > > >
> > > > Fix this by adding the same iomem_is_exclusive() check we already have
> > > > on the sysfs side in pci_mmap_resource().
> > > >
> > > > References: 90a545e98126 ("restrict /dev/mem to idle io memory ranges")
> > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > >
> > > This is OK with me but it looks like IORESOURCE_EXCLUSIVE is currently
> > > only used in a few places:
> > >
> > >   e1000_probe() calls pci_request_selected_regions_exclusive(),
> > >   ne_pci_probe() calls pci_request_regions_exclusive(),
> > >   vmbus_allocate_mmio() calls request_mem_region_exclusive()
> > >
> > > which raises the question of whether it's worth keeping
> > > IORESOURCE_EXCLUSIVE at all.  I'm totally fine with removing it
> > > completely.
> >
> > Now that CONFIG_IO_STRICT_DEVMEM upgrades IORESOURCE_BUSY to
> > IORESOURCE_EXCLUSIVE semantics the latter has lost its meaning so I'd
> > be in favor of removing it as well.
> 
> Still has some value since it enforces exclusive access even if the
> config isn't enabled, and iirc e1000 had some fun with userspace tools
> clobbering the firmware and bricking the chip.

There's *some* value; I'm just skeptical since only three drivers use
it.

IORESOURCE_EXCLUSIVE is from e8de1481fd71 ("resource: allow MMIO
exclusivity for device drivers"), and the commit message says this is
only active when CONFIG_STRICT_DEVMEM is set.  I didn't check to see
whether that's still true.

That commit adds a bunch of wrappers and "__"-prefixed functions to
pass the IORESOURCE_EXCLUSIVE flag around.  That's a fair bit of
uglification for three drivers.

> Another thing I kinda wondered, since pci maintainer is here: At least
> in drivers/gpu I see very few drivers explicitly requestion regions
> (this might be a historical artifact due to the shadow attach stuff
> before we had real modesetting drivers). And pci core doesn't do that
> either, even when a driver is bound. Is this intentional, or
> should/could we do better? Since drivers work happily without
> reserving regions I don't think "the drivers need to remember to do
> this" will ever really work out well.

You're right, many drivers don't call pci_request_regions().  Maybe we
could do better, but I haven't looked into that recently.  There is a
related note in Documentation/PCI/pci.rst that's been there for a long
time (it refers to "pci_request_resources()", which has never existed
AFAICT).  I'm certainly open to proposals.
