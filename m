Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C284292A8
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhJKO6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:58:04 -0400
Received: from foss.arm.com ([217.140.110.172]:60504 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234554AbhJKO6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 10:58:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3881A101E;
        Mon, 11 Oct 2021 07:56:03 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32B633F694;
        Mon, 11 Oct 2021 07:56:02 -0700 (PDT)
Date:   Mon, 11 Oct 2021 15:57:42 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 7/7] vfio/pci: Align MSIX Table and PBA size
 allocation to 64k
Message-ID: <YWRQ5ho1vbVuPlgY@monolith.localdoman>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
 <20210913154413.14322-8-alexandru.elisei@arm.com>
 <20211006161142.36b5fa41@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006161142.36b5fa41@donnerap.cambridge.arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On Wed, Oct 06, 2021 at 04:11:42PM +0100, Andre Przywara wrote:
> On Mon, 13 Sep 2021 16:44:13 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> Hi,
> 
> > When allocating MMIO space for the MSI-X table, kvmtool rounds the
> > allocation to the host's page size to make it as easy as possible for the
> > guest to map the table to a page, if it wants to (and doesn't do BAR
> > reassignment, like the x86 architecture for example). However, the host's
> > page size can differ from the guest's, for example, if the host is compiled
> > with 4k pages and the guest is using 64k pages.
> > 
> > To make sure the allocation is always aligned to a guest's page size, round
> > it up to the maximum page size, which is 64k. Do the same for the pending
> > bit array if it lives in its own BAR.
> 
> The idea of that looks alright on the first glance, but isn't needed for
> x86, right? So should this be using an arch-specific MAX_PAGE_SIZE instead?

By "not needed for x86", do you mean that 4k is enough and 64k is not needed? Or
that doing any kind of alignment is unnecessary? If it's the latter, Linux on
x86 relies on the BARs being programmed by the BIOS with valid addresses, so I
would rather err on the side of caution and align the BARs to at least 4k.

If it's the former, doing the alignment is not costing kvmtool anything, as the
addreses are just numbers in the PCI memory region, which is not allocated as
userspace memory by kvmtool, and it's about 1GiB, so I don't think 64 - 4 = 60k
will make much of a difference. With 100 devices, each with the MSIX table and
PBA in different BARs, that amounts to 60k * 2 * 100 ~= 12MiB. Out of 1GiB.

But I do agree that using something like MAX_PAGE_SIZE would be the correct way
to do it. I'll have a look at the page sizes for mips and powerpc and create the
define.

Thanks,
Alex

> 
> Cheers,
> Andre
> 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  vfio/pci.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/vfio/pci.c b/vfio/pci.c
> > index a6d0408..7e258a4 100644
> > --- a/vfio/pci.c
> > +++ b/vfio/pci.c
> > @@ -1,3 +1,5 @@
> > +#include "linux/sizes.h"
> > +
> >  #include "kvm/irq.h"
> >  #include "kvm/kvm.h"
> >  #include "kvm/kvm-cpu.h"
> > @@ -929,7 +931,7 @@ static int vfio_pci_create_msix_table(struct kvm
> > *kvm, struct vfio_device *vdev) if (!info.size)
> >  		return -EINVAL;
> >  
> > -	map_size = ALIGN(info.size, PAGE_SIZE);
> > +	map_size = ALIGN(info.size, SZ_64K);
> >  	table->guest_phys_addr = pci_get_mmio_block(map_size);
> >  	if (!table->guest_phys_addr) {
> >  		pr_err("cannot allocate MMIO space");
> > @@ -960,7 +962,7 @@ static int vfio_pci_create_msix_table(struct kvm
> > *kvm, struct vfio_device *vdev) if (!info.size)
> >  			return -EINVAL;
> >  
> > -		map_size = ALIGN(info.size, PAGE_SIZE);
> > +		map_size = ALIGN(info.size, SZ_64K);
> >  		pba->guest_phys_addr = pci_get_mmio_block(map_size);
> >  		if (!pba->guest_phys_addr) {
> >  			pr_err("cannot allocate MMIO space");
> 
