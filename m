Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44860372B08
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhEDNbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 09:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhEDNbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 09:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0354A611AC;
        Tue,  4 May 2021 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620135017;
        bh=K7jOMW5zxYrXVgqj4YX3jlgoXwGfte8Q1gPc0IQQxmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rtsctj9Ov4ebaVfqmb8gRZiVYEWb9O63QSOpgigHe4Bfem/KRiz924DWKfJrXCA1x
         W4d/PdSPAuO3zWlqN2xdW0Ro5Srwxz2EwzPkSRaNhB9OEvbctTVDx4HN9Behn8Fwwp
         nhrWTmovaEXCGQD5zqQXRd2b0oKZ8L3sVy0jARV8=
Date:   Tue, 4 May 2021 15:30:15 +0200
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
Message-ID: <YJFMZ8KYVCDwUBPU@kroah.com>
References: <20210326061311.1497642-1-hch@lst.de>
 <20210504142236.76994047@bahia.lan>
 <YJFFG1tSP0dUCxcX@kroah.com>
 <20210504152034.18e41ec3@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504152034.18e41ec3@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021 at 03:20:34PM +0200, Greg Kurz wrote:
> On Tue, 4 May 2021 14:59:07 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, May 04, 2021 at 02:22:36PM +0200, Greg Kurz wrote:
> > > On Fri, 26 Mar 2021 07:13:09 +0100
> > > Christoph Hellwig <hch@lst.de> wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
> > > > feature without any open source component - what would normally be
> > > > the normal open source userspace that we require for kernel drivers,
> > > > although in this particular case user space could of course be a
> > > > kernel driver in a VM.  It also happens to be a complete mess that
> > > > does not properly bind to PCI IDs, is hacked into the vfio_pci driver
> > > > and also pulles in over 1000 lines of code always build into powerpc
> > > > kernels that have Power NV support enabled.  Because of all these
> > > > issues and the lack of breaking userspace when it is removed I think
> > > > the best idea is to simply kill.
> > > > 
> > > > Changes since v1:
> > > >  - document the removed subtypes as reserved
> > > >  - add the ACK from Greg
> > > > 
> > > > Diffstat:
> > > >  arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
> > > >  b/arch/powerpc/include/asm/opal.h            |    3 
> > > >  b/arch/powerpc/include/asm/pci-bridge.h      |    1 
> > > >  b/arch/powerpc/include/asm/pci.h             |    7 
> > > >  b/arch/powerpc/platforms/powernv/Makefile    |    2 
> > > >  b/arch/powerpc/platforms/powernv/opal-call.c |    2 
> > > >  b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
> > > >  b/arch/powerpc/platforms/powernv/pci.c       |   11 
> > > >  b/arch/powerpc/platforms/powernv/pci.h       |   17 
> > > >  b/arch/powerpc/platforms/pseries/pci.c       |   23 
> > > >  b/drivers/vfio/pci/Kconfig                   |    6 
> > > >  b/drivers/vfio/pci/Makefile                  |    1 
> > > >  b/drivers/vfio/pci/vfio_pci.c                |   18 
> > > >  b/drivers/vfio/pci/vfio_pci_private.h        |   14 
> > > >  b/include/uapi/linux/vfio.h                  |   38 -
> > > 
> > > 
> > > Hi Christoph,
> > > 
> > > FYI, these uapi changes break build of QEMU.
> > 
> > What uapi changes?
> > 
> 
> All macros and structure definitions that are being removed
> from include/uapi/linux/vfio.h by patch 1.
> 
> > What exactly breaks?
> > 
> 
> These macros and types are used by the current QEMU code base.
> Next time the QEMU source tree updates its copy of the kernel
> headers, the compilation of affected code will fail.

So does QEMU use this api that is being removed, or does it just have
some odd build artifacts of the uapi things?

What exactly is the error messages here?

And if we put the uapi .h file stuff back, is that sufficient for qemu
to work, as it should be checking at runtime what the kernel has / has
not anyway, right?

thanks,

greg k-h
