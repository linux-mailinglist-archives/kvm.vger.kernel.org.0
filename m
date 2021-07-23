Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EF43D35A9
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 09:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhGWHHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 03:07:20 -0400
Received: from verein.lst.de ([213.95.11.211]:37438 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhGWHHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 03:07:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5CF0167373; Fri, 23 Jul 2021 09:47:49 +0200 (CEST)
Date:   Fri, 23 Jul 2021 09:47:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 08/14] vfio/pci: Move to the device set
 infrastructure
Message-ID: <20210723074749.GC2795@lst.de>
References: <0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com> <8-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021 at 02:42:54PM -0300, Jason Gunthorpe wrote:
> From: Yishai Hadas <yishaih@nvidia.com>
> 
> PCI wants to have the usual open/close_device() logic with the slight
> twist that the open/close_device() must be done under a singelton lock
> shared by all of the vfio_devices that are in the PCI "reset group".
> 
> The reset group, and thus the device set, is determined by what devices
> pci_reset_bus() touches, which is either the entire bus or only the slot.
> 
> Rely on the core code to do everything reflck was doing and delete reflck
> entirely.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 156 ++++++----------------------
>  drivers/vfio/pci/vfio_pci_private.h |   7 --
>  2 files changed, 31 insertions(+), 132 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index fab3715d60d4ba..22774e447b5f4a 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -530,53 +530,40 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
>  	vfio_device_put(&pf_vdev->vdev);
>  }
>  
> -static void vfio_pci_release(struct vfio_device *core_vdev)
> +static void vfio_pci_close_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_device *vdev =
>  		container_of(core_vdev, struct vfio_pci_device, vdev);
>  
> -	mutex_lock(&vdev->reflck->lock);
> -
> -	if (!(--vdev->refcnt)) {
> -		vfio_pci_vf_token_user_add(vdev, -1);
> -		vfio_spapr_pci_eeh_release(vdev->pdev);
> -		vfio_pci_disable(vdev);
> +	vfio_pci_vf_token_user_add(vdev, -1);
> +	vfio_spapr_pci_eeh_release(vdev->pdev);
> +	vfio_pci_disable(vdev);
>  
> -		mutex_lock(&vdev->igate);
> -		if (vdev->err_trigger) {
> -			eventfd_ctx_put(vdev->err_trigger);
> -			vdev->err_trigger = NULL;
> -		}
> -		if (vdev->req_trigger) {
> -			eventfd_ctx_put(vdev->req_trigger);
> -			vdev->req_trigger = NULL;
> -		}
> -		mutex_unlock(&vdev->igate);
> +	mutex_lock(&vdev->igate);
> +	if (vdev->err_trigger) {
> +		eventfd_ctx_put(vdev->err_trigger);
> +		vdev->err_trigger = NULL;
>  	}
> -
> -	mutex_unlock(&vdev->reflck->lock);
> +	if (vdev->req_trigger) {
> +		eventfd_ctx_put(vdev->req_trigger);
> +		vdev->req_trigger = NULL;
> +	}
> +	mutex_unlock(&vdev->igate);
>  }
>  
> -static int vfio_pci_open(struct vfio_device *core_vdev)
> +static int vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_device *vdev =
>  		container_of(core_vdev, struct vfio_pci_device, vdev);
>  	int ret = 0;
>  
> -	mutex_lock(&vdev->reflck->lock);
> -
> -	if (!vdev->refcnt) {
> -		ret = vfio_pci_enable(vdev);
> -		if (ret)
> -			goto error;
> +	ret = vfio_pci_enable(vdev);
> +	if (ret)
> +		return ret;
>  
> -		vfio_spapr_pci_eeh_open(vdev->pdev);
> -		vfio_pci_vf_token_user_add(vdev, 1);
> -	}
> -	vdev->refcnt++;
> -error:
> -	mutex_unlock(&vdev->reflck->lock);
> -	return ret;
> +	vfio_spapr_pci_eeh_open(vdev->pdev);
> +	vfio_pci_vf_token_user_add(vdev, 1);
> +	return 0;
>  }
>  
>  static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
> @@ -1870,8 +1857,8 @@ static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
>  
>  static const struct vfio_device_ops vfio_pci_ops = {
>  	.name		= "vfio-pci",
> -	.open		= vfio_pci_open,
> -	.release	= vfio_pci_release,
> +	.open_device	= vfio_pci_open_device,
> +	.close_device	= vfio_pci_close_device,
>  	.ioctl		= vfio_pci_ioctl,
>  	.read		= vfio_pci_read,
>  	.write		= vfio_pci_write,
> @@ -1880,9 +1867,6 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  	.match		= vfio_pci_match,
>  };
>  
> -static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
> -static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
> -
>  static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  				 unsigned long action, void *data)
>  {
> @@ -2020,12 +2004,17 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	INIT_LIST_HEAD(&vdev->vma_list);
>  	init_rwsem(&vdev->memory_lock);
>  
> -	ret = vfio_pci_reflck_attach(vdev);
> +	if (pci_is_root_bus(pdev->bus))
> +		ret = vfio_assign_device_set(&vdev->vdev, vdev);
> +	else if (!pci_probe_reset_slot(pdev->slot))
> +		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);
> +	else
> +		ret = vfio_assign_device_set(&vdev->vdev, pdev->bus);

Maybe invert this and add a comment:

	if (pci_is_root_bus(pdev->bus))
		ret = vfio_assign_device_set(&vdev->vdev, vdev);
	/*
	 * If there is no slot reset support for this device, the whole
	 * bus needs to be grouped together to support bus-wide resets.
	 */
	else if (pci_probe_reset_slot(pdev->slot) < 0)
		ret = vfio_assign_device_set(&vdev->vdev, pdev->bus);
	else
		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
