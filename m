Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86FF333675
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCJHgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:36:53 -0500
Received: from verein.lst.de ([213.95.11.211]:34937 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhCJHgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:36:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4564E68B05; Wed, 10 Mar 2021 08:36:35 +0100 (CET)
Date:   Wed, 10 Mar 2021 08:36:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 09/10] vfio/pci: Replace uses of vfio_device_data()
 with container_of
Message-ID: <20210310073634.GH2659@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 05:38:51PM -0400, Jason Gunthorpe wrote:
> This tidies a few confused places that think they can have a refcount on
> the vfio_device but the device_data could be NULL, that isn't possible by
> design.
> 
> Most of the change falls out when struct vfio_devices is updated to just
> store the struct vfio_pci_device itself. This wasn't possible before
> because there was no easy way to get from the 'struct vfio_pci_device' to
> the 'struct vfio_device' to put back the refcount.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 45 ++++++++++++-------------------------
>  1 file changed, 14 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index af5696a96a76e0..4b0d60f7602e40 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -534,7 +534,7 @@ static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
>  		return NULL;
>  	}
>  
> -	return vfio_device_data(*pf_dev);
> +	return container_of(*pf_dev, struct vfio_pci_device, vdev);

I think it would be useful to just return the vfio_device and let
the caller do the container_of() here, maybe as a followup.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
