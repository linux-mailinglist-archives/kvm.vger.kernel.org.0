Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95E3D3BB4
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbhGWNdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 09:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235351AbhGWNdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 09:33:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CFE260EB4;
        Fri, 23 Jul 2021 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627049628;
        bh=QgLmm2XRufothnct/WX05Q/Y83SO/A7cPrA4WDrlc8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gkDLA6Cvk6Ikx41NWvbc+zbdWRVBk8VvLFaBXxyiWbeU6V+W/u51mmoaZyiylAOtt
         xvJgGQxYOvLwgl5hg/pmU2EYO713wnpWPPc7ArAh+f7NUvjvYsnyEX5/o1feoq2sJk
         mi8ERMg/A8VEI90ErG68hSRqAWyWYor9NxXkEVzPRpIFQJkdoM39jOvkaHRVTqh84g
         YwKFz71FrlZI/kSFBCJnx39SCt1GV8eTCdU5u2MFXi5WozjI3F0xP5jmBqtjPEIQpE
         DIk9jukwFtXmTkclIWzaOF0hbFmdJ9j+NvxgJ+m3o3XJpcqQGqi5hPpKcA6/+PWS9Z
         v7DMl5rYwyzfA==
Date:   Fri, 23 Jul 2021 17:13:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        jgg@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <YPrOmLs9dZaEe7Th@unreal>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <YPhb6o06fX+/FiTY@unreal>
 <0b8db422-749d-9d93-6b3b-957259f3d0cb@nvidia.com>
 <b7c19435-5abb-c5fd-383c-d0ebad11db31@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7c19435-5abb-c5fd-383c-d0ebad11db31@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021 at 12:22:05PM +0300, Max Gurtovoy wrote:
> 
> On 7/22/2021 12:06 PM, Yishai Hadas wrote:
> > On 7/21/2021 8:39 PM, Leon Romanovsky wrote:
> > > On Wed, Jul 21, 2021 at 07:16:09PM +0300, Yishai Hadas wrote:
> > > > From: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > 
> > > > Now that vfio_pci has been split into two source modules, one focusing
> > > > on the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
> > > > (vfio_pci_core.c), complete the split and move them into two different
> > > > kernel modules.
> > > > 
> > > > As before vfio_pci.ko continues to present the same interface under
> > > > sysfs and this change will have no functional impact.
> > > > 
> > > > Splitting into another module and adding exports allows creating new HW
> > > > specific VFIO PCI drivers that can implement device specific
> > > > functionality, such as VFIO migration interfaces or specialized device
> > > > requirements.
> > > > 
> > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > > ---
> > > >   drivers/vfio/pci/Kconfig                      | 30 ++++++++------
> > > >   drivers/vfio/pci/Makefile                     |  8 ++--
> > > >   drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
> > > >   drivers/vfio/pci/vfio_pci_config.c            |  2 +-
> > > >   drivers/vfio/pci/vfio_pci_core.c              | 41
> > > > ++++++++++++++++---
> > > >   drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
> > > >   drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
> > > >   drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
> > > >   drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
> > > >   .../pci => include/linux}/vfio_pci_core.h     |  2 -
> > > >   10 files changed, 66 insertions(+), 39 deletions(-)
> > > >   rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)
> > > <...>
> > > 
> > > > -#include "vfio_pci_core.h"
> > > > +#include <linux/vfio_pci_core.h>
> > > > +
> > > > +#define DRIVER_VERSION  "0.2"
> > > <...>
> > > 
> > > > +MODULE_VERSION(DRIVER_VERSION);
> > > Please don't add driver versions to the upstream kernel, they useless.
> > > 
> > > Thanks
> > 
> > This just preserves the code for driver/module version that was in
> > vfio_pci.ko before the split.
> > 
> > However,  this can be removed in V2 if we may need to have.
> 
> Right, we already agreed to preserve vfio_pci versioning scheme and we'll
> not add it to new mlx5_vfio_pci or future drivers.

There is nothing to preserve, instead of keeping this useless code, just
delete it.

https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/

Thanks

> 
> 
> > 
> > Yishai
> > 
