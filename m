Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4782F372CFC
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhEDPe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 11:34:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230406AbhEDPe2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 11:34:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620142412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HLdHIElXsh+Br5DFDsP1+YjonXAJx6g75JUakM7EhX0=;
        b=W7/bSoaEHRa2sJJsJaigph9G50tS8iwXHGXNMMpGRAvx5RyjkDyGx4crbI5ceD53cIScDv
        liNs6G5shs9tAupqA507dUwvV3vC+8jQTPVvUm8++MfP3VMD3NpnQVYFK03osmOE+aAdcm
        CnRvO6gCkVVktK08sAXf1dCCgXvRbWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-oGqKZBKrOxqxLaLvFcQSeQ-1; Tue, 04 May 2021 11:33:28 -0400
X-MC-Unique: oGqKZBKrOxqxLaLvFcQSeQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C45CF1922039;
        Tue,  4 May 2021 15:33:26 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13D425C230;
        Tue,  4 May 2021 15:33:25 +0000 (UTC)
Date:   Tue, 4 May 2021 09:33:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "Paul Mackerras" <paulus@samba.org>,
        Daniel Vetter <daniel@ffwll.ch>, <linux-api@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <qemu-devel@nongnu.org>,
        <qemu-ppc@nongnu.org>
Subject: Re: remove the nvlink2 pci_vfio subdriver v2
Message-ID: <20210504093324.4f0cafc7@redhat.com>
In-Reply-To: <20210504161131.2ed74d7b@bahia.lan>
References: <20210326061311.1497642-1-hch@lst.de>
        <20210504142236.76994047@bahia.lan>
        <YJFFG1tSP0dUCxcX@kroah.com>
        <20210504152034.18e41ec3@bahia.lan>
        <YJFMZ8KYVCDwUBPU@kroah.com>
        <20210504161131.2ed74d7b@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 May 2021 16:11:31 +0200
Greg Kurz <groug@kaod.org> wrote:

> On Tue, 4 May 2021 15:30:15 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, May 04, 2021 at 03:20:34PM +0200, Greg Kurz wrote:  
> > > On Tue, 4 May 2021 14:59:07 +0200
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > >   
> > > > On Tue, May 04, 2021 at 02:22:36PM +0200, Greg Kurz wrote:  
> > > > > On Fri, 26 Mar 2021 07:13:09 +0100
> > > > > Christoph Hellwig <hch@lst.de> wrote:
> > > > >   
> > > > > > Hi all,
> > > > > > 
> > > > > > the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
> > > > > > feature without any open source component - what would normally be
> > > > > > the normal open source userspace that we require for kernel drivers,
> > > > > > although in this particular case user space could of course be a
> > > > > > kernel driver in a VM.  It also happens to be a complete mess that
> > > > > > does not properly bind to PCI IDs, is hacked into the vfio_pci driver
> > > > > > and also pulles in over 1000 lines of code always build into powerpc
> > > > > > kernels that have Power NV support enabled.  Because of all these
> > > > > > issues and the lack of breaking userspace when it is removed I think
> > > > > > the best idea is to simply kill.
> > > > > > 
> > > > > > Changes since v1:
> > > > > >  - document the removed subtypes as reserved
> > > > > >  - add the ACK from Greg
> > > > > > 
> > > > > > Diffstat:
> > > > > >  arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
> > > > > >  b/arch/powerpc/include/asm/opal.h            |    3 
> > > > > >  b/arch/powerpc/include/asm/pci-bridge.h      |    1 
> > > > > >  b/arch/powerpc/include/asm/pci.h             |    7 
> > > > > >  b/arch/powerpc/platforms/powernv/Makefile    |    2 
> > > > > >  b/arch/powerpc/platforms/powernv/opal-call.c |    2 
> > > > > >  b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
> > > > > >  b/arch/powerpc/platforms/powernv/pci.c       |   11 
> > > > > >  b/arch/powerpc/platforms/powernv/pci.h       |   17 
> > > > > >  b/arch/powerpc/platforms/pseries/pci.c       |   23 
> > > > > >  b/drivers/vfio/pci/Kconfig                   |    6 
> > > > > >  b/drivers/vfio/pci/Makefile                  |    1 
> > > > > >  b/drivers/vfio/pci/vfio_pci.c                |   18 
> > > > > >  b/drivers/vfio/pci/vfio_pci_private.h        |   14 
> > > > > >  b/include/uapi/linux/vfio.h                  |   38 -  
> > > > > 
> > > > > 
> > > > > Hi Christoph,
> > > > > 
> > > > > FYI, these uapi changes break build of QEMU.  
> > > > 
> > > > What uapi changes?
> > > >   
> > > 
> > > All macros and structure definitions that are being removed
> > > from include/uapi/linux/vfio.h by patch 1.
> > >   
> > > > What exactly breaks?
> > > >   
> > > 
> > > These macros and types are used by the current QEMU code base.
> > > Next time the QEMU source tree updates its copy of the kernel
> > > headers, the compilation of affected code will fail.  
> > 
> > So does QEMU use this api that is being removed, or does it just have
> > some odd build artifacts of the uapi things?
> >   
> 
> These are region subtypes definition and associated capabilities.
> QEMU basically gets information on VFIO regions from the kernel
> driver and for those regions with a nvlink2 subtype, it tries
> to extract some more nvlink2 related info.


Urgh, let's put the uapi header back in place with a deprecation
notice.  Userspace should never have a dependency on the existence of a
given region, but clearly will have code to parse the data structure
describing that region.  I'll post a patch.  Thanks,

Alex

