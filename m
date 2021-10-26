Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C7D43BB13
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 21:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbhJZTlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 15:41:47 -0400
Received: from ssh.movementarian.org ([139.162.205.133]:34924 "EHLO
        movementarian.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231182AbhJZTlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 15:41:46 -0400
X-Greylist: delayed 2261 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2021 15:41:46 EDT
Received: from movement by movementarian.org with local (Exim 4.94)
        (envelope-from <movement@movementarian.org>)
        id 1mfRhb-0027Fj-Gr; Tue, 26 Oct 2021 20:01:39 +0100
Date:   Tue, 26 Oct 2021 20:01:39 +0100
From:   John Levon <levon@movementarian.org>
To:     Elena <elena.ufimtseva@oracle.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, jasowang@redhat.com,
        felipe@nutanix.com, jag.raman@oracle.com, eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <YXhQk/Sh0nLOmA2n@movementarian.org>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <YWUeZVnTVI7M/Psr@heatpipe>
 <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
 <20211025152122.GA25901@nuker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025152122.GA25901@nuker>
X-Url:  http://www.movementarian.org/
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 08:21:22AM -0700, Elena wrote:

> > I'm curious what approach you want to propose for QEMU integration. A
> > while back I thought about the QEMU API. It's possible to implement it
> > along the lines of the memory_region_add_eventfd() API where each
> > ioregionfd is explicitly added by device emulation code. An advantage of
> > this approach is that a MemoryRegion can have multiple ioregionfds, but
> > I'm not sure if that is a useful feature.
> >
> 
> This is the approach that is currently in the works. Agree, I dont see
> much of the application here at this point to have multiple ioregions
> per MemoryRegion.
> I added Memory API/eventfd approach to the vfio-user as well to try
> things out.
> 
> > An alternative is to cover the entire MemoryRegion with one ioregionfd.
> > That way the device emulation code can use ioregionfd without much fuss
> > since there is a 1:1 mapping between MemoryRegions, which are already
> > there in existing devices. There is no need to think deeply about which
> > ioregionfds to create for a device.
> >
> > A new API called memory_region_set_aio_context(MemoryRegion *mr,
> > AioContext *ctx) would cause ioregionfd (or a userspace fallback for
> > non-KVM cases) to execute the MemoryRegion->read/write() accessors from
> > the given AioContext. The details of ioregionfd are hidden behind the
> > memory_region_set_aio_context() API, so the device emulation code
> > doesn't need to know the capabilities of ioregionfd.
> 
> > 
> > The second approach seems promising if we want more devices to use
> > ioregionfd inside QEMU because it requires less ioregionfd-specific
> > code.
> > 
> I like this approach as well.
> As you have mentioned, the device emulation code with first approach
> does have to how to handle the region accesses. The second approach will
> make things more transparent. Let me see how can I modify what there is
> there now and may ask further questions.

Sorry I'm a bit late to this discussion, I'm not clear on the above WRT
vfio-user. If an ioregionfd has to cover a whole BAR0 (?), how would this
interact with partly-mmap()able regions like we do with SPDK/vfio-user/NVMe?

thanks
john
