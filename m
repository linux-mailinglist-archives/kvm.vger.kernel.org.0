Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB04E3D1538
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 19:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGUQ7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 12:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhGUQ7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 12:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CCB960BD3;
        Wed, 21 Jul 2021 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626889198;
        bh=vxkURe61iwE39hj0EF+5bZCTtjoEwnhfxCFjfgtQ36o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdtxAIqyvftI0HvvwlX5/SxdplcftLcb7cHzSZzSBeVa053tupBtoEUKK+jimZAgJ
         tkbIIqTOuadoy+qdAfeIwXRtAxi/Kj5wQCCqhizUXhqKy2B82y+oLePK4giBu6pt6R
         T0KR7cKCQR7Nx7Pkp10A6FaE9CpMSnwN1fCoT0xROCJANG6NU+Yks+lR9+4zDGz9Ho
         I9SrNfzJZbdDUxQYd1jQXzdOHKC1/tvvCPf8Ahi7a6lhaFHer4LpllGZif9PS8einL
         3MruM1W5dRoxn6n0H6TMJSVkAdtto1AscM8fUMR60Z/NVHZqCzbZVYB/YJupz86Ask
         /e+RQ5VmxKTTQ==
Date:   Wed, 21 Jul 2021 20:39:54 +0300
From:   Leon Romanovsky <leonro@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     bhelgaas@google.com, corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, jgg@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <YPhb6o06fX+/FiTY@unreal>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721161609.68223-13-yishaih@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021 at 07:16:09PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> Now that vfio_pci has been split into two source modules, one focusing
> on the "struct pci_driver" (vfio_pci.c) and a toolbox library of code
> (vfio_pci_core.c), complete the split and move them into two different
> kernel modules.
> 
> As before vfio_pci.ko continues to present the same interface under
> sysfs and this change will have no functional impact.
> 
> Splitting into another module and adding exports allows creating new HW
> specific VFIO PCI drivers that can implement device specific
> functionality, such as VFIO migration interfaces or specialized device
> requirements.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig                      | 30 ++++++++------
>  drivers/vfio/pci/Makefile                     |  8 ++--
>  drivers/vfio/pci/vfio_pci.c                   | 14 ++-----
>  drivers/vfio/pci/vfio_pci_config.c            |  2 +-
>  drivers/vfio/pci/vfio_pci_core.c              | 41 ++++++++++++++++---
>  drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c             |  2 +-
>  drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
>  drivers/vfio/pci/vfio_pci_zdev.c              |  2 +-
>  .../pci => include/linux}/vfio_pci_core.h     |  2 -
>  10 files changed, 66 insertions(+), 39 deletions(-)
>  rename {drivers/vfio/pci => include/linux}/vfio_pci_core.h (99%)

<...>

> -#include "vfio_pci_core.h"
> +#include <linux/vfio_pci_core.h>
> +
> +#define DRIVER_VERSION  "0.2"

<...>

> +MODULE_VERSION(DRIVER_VERSION);

Please don't add driver versions to the upstream kernel, they useless.

Thanks
