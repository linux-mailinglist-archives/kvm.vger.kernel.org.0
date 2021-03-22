Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4E3448E8
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhCVPLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:11:36 -0400
Received: from verein.lst.de ([213.95.11.211]:56205 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230129AbhCVPL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:11:29 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CDA3268BFE; Mon, 22 Mar 2021 16:11:25 +0100 (CET)
Date:   Mon, 22 Mar 2021 16:11:25 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210322151125.GA1051@lst.de>
References: <20210309083357.65467-9-mgurtovoy@nvidia.com> <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru> <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com> <20210319092341.14bb179a@omen.home.shazbot.org> <20210319161722.GY2356281@nvidia.com> <20210319162033.GA18218@lst.de> <20210319162848.GZ2356281@nvidia.com> <20210319163449.GA19186@lst.de> <20210319113642.4a9b0be1@omen.home.shazbot.org> <20210319200749.GB2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319200749.GB2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 05:07:49PM -0300, Jason Gunthorpe wrote:
> The way the driver core works is to first match against the already
> loaded driver list, then trigger an event for module loading and when
> new drivers are registered they bind to unbound devices.
> 
> So, the trouble is the event through userspace because the kernel
> can't just go on to use vfio_pci until it knows userspace has failed
> to satisfy the load request.
> 
> One answer is to have userspace udev have the "hook" here and when a
> vfio flavour mod alias is requested on a PCI device it swaps in
> vfio_pci if it can't find an alternative.
> 
> The dream would be a system with no vfio modules loaded could do some
> 
>  echo "vfio" > /sys/bus/pci/xxx/driver_flavour
> 
> And a module would be loaded and a struct vfio_device is created for
> that device. Very easy for the user.

Maybe I did not communicate my suggestion last week very well.  My
idea is that there are no different pci_drivers vs vfio or not,
but different personalities of the same driver.

So the interface would still look somewhat like your suggestion above,
although I'd prefer something like:

   echo 1 > /sys/bus/pci/xxx/use_vfio

How would the flow look like for the various cases?

 a) if a driver is bound, and it supports the enable_vfio method that
    is called, and everything is controller by the driver, which uses
    symbols exorted from vfio/vfio_pci to implement the functionality
 b) if a driver is bound, but does not support the enable_vfio method
    it is unbound and vfio_pci is bound instead, continue at c)
 c) use the normal current vfio flow

do the reverse on a

echo 0 > /sys/bus/pci/xxx/use_vfio
