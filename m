Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBE9337111
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 12:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhCKLVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 06:21:39 -0500
Received: from verein.lst.de ([213.95.11.211]:40502 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232606AbhCKLV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 06:21:27 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 895E368B05; Thu, 11 Mar 2021 12:21:24 +0100 (CET)
Date:   Thu, 11 Mar 2021 12:21:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 09/10] vfio/pci: Replace uses of vfio_device_data()
 with container_of
Message-ID: <20210311112124.GA17183@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <20210310073634.GH2659@lst.de> <20210310195941.GE2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310195941.GE2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 03:59:41PM -0400, Jason Gunthorpe wrote:
> > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > > index af5696a96a76e0..4b0d60f7602e40 100644
> > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > @@ -534,7 +534,7 @@ static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
> > >  		return NULL;
> > >  	}
> > >  
> > > -	return vfio_device_data(*pf_dev);
> > > +	return container_of(*pf_dev, struct vfio_pci_device, vdev);
> > 
> > I think it would be useful to just return the vfio_device and let
> > the caller do the container_of() here, maybe as a followup.
> 
> The callers seem to need the vfio_pci_device *?

Yes.  But the container_of is trivial arithmetics, no need to waste
an indirect argument for that.

> In a later series this function gets transformed into this:
> 
> 	device_lock(&physfn->dev);
> 	vdev = vfio_pci_get_drvdata(physfn);
> 	if (!vdev) {
> 		device_unlock(&physfn->dev);
> 		return NULL;
> 	}
> 	vfio_device_get(&vdev->vdev);
> 	device_unlock(&physfn->dev);
> 
> There is no container_of here because the drvdata now points at the
> struct vfio_pci_device

Ok, so discard my comment then.
