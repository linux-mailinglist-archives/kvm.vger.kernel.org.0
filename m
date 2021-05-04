Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B814372A82
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 14:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhEDNAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 09:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhEDNAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 09:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E030613B4;
        Tue,  4 May 2021 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620133150;
        bh=VKrAeZZpludZjTm6WuzJcgg7371nyGiXlt3bsLCkX3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1RVOhA+xUnttg6X+/OXWdWei9lFiPRvoAUP4JZ66jwCl3Fwz8Y9JcIZ2dWfl4AXDh
         Mg7CS6WUOwTfkw4umLIPAtPqY5sJ9P6hfLWa3HEE2n4liAZAnteKFXFxaUW5xREyNd
         jljZ143srAqD73QuO6fQW2meQYvxR3Y6pcFbbX8Q=
Date:   Tue, 4 May 2021 14:59:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Greg Kurz <groug@kaod.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        Daniel Vetter <daniel@ffwll.ch>, linux-api@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, qemu-devel@nongnu.org,
        qemu-ppc@nongnu.org
Subject: Re: remove the nvlink2 pci_vfio subdriver v2
Message-ID: <YJFFG1tSP0dUCxcX@kroah.com>
References: <20210326061311.1497642-1-hch@lst.de>
 <20210504142236.76994047@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504142236.76994047@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021 at 02:22:36PM +0200, Greg Kurz wrote:
> On Fri, 26 Mar 2021 07:13:09 +0100
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Hi all,
> > 
> > the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
> > feature without any open source component - what would normally be
> > the normal open source userspace that we require for kernel drivers,
> > although in this particular case user space could of course be a
> > kernel driver in a VM.  It also happens to be a complete mess that
> > does not properly bind to PCI IDs, is hacked into the vfio_pci driver
> > and also pulles in over 1000 lines of code always build into powerpc
> > kernels that have Power NV support enabled.  Because of all these
> > issues and the lack of breaking userspace when it is removed I think
> > the best idea is to simply kill.
> > 
> > Changes since v1:
> >  - document the removed subtypes as reserved
> >  - add the ACK from Greg
> > 
> > Diffstat:
> >  arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
> >  b/arch/powerpc/include/asm/opal.h            |    3 
> >  b/arch/powerpc/include/asm/pci-bridge.h      |    1 
> >  b/arch/powerpc/include/asm/pci.h             |    7 
> >  b/arch/powerpc/platforms/powernv/Makefile    |    2 
> >  b/arch/powerpc/platforms/powernv/opal-call.c |    2 
> >  b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
> >  b/arch/powerpc/platforms/powernv/pci.c       |   11 
> >  b/arch/powerpc/platforms/powernv/pci.h       |   17 
> >  b/arch/powerpc/platforms/pseries/pci.c       |   23 
> >  b/drivers/vfio/pci/Kconfig                   |    6 
> >  b/drivers/vfio/pci/Makefile                  |    1 
> >  b/drivers/vfio/pci/vfio_pci.c                |   18 
> >  b/drivers/vfio/pci/vfio_pci_private.h        |   14 
> >  b/include/uapi/linux/vfio.h                  |   38 -
> 
> 
> Hi Christoph,
> 
> FYI, these uapi changes break build of QEMU.

What uapi changes?

What exactly breaks?

Why does QEMU require kernel driver stuff?

thanks,

greg k-h
