Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BC633371B
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhCJIPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:15:33 -0500
Received: from verein.lst.de ([213.95.11.211]:35068 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCJIPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:15:14 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C83AB68B05; Wed, 10 Mar 2021 09:15:09 +0100 (CET)
Date:   Wed, 10 Mar 2021 09:15:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     jgg@nvidia.com, alex.williamson@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com, aik@ozlabs.ru, hch@lst.de
Subject: Re: [PATCH 9/9] vfio/pci: export igd support into vendor vfio_pci
 driver
Message-ID: <20210310081508.GB4364@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com> <20210309083357.65467-10-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309083357.65467-10-mgurtovoy@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The terminology is all weird here.  You don't export functionality
you move it.  And this is not a "vendor" driver, but just a device
specific one.

> +struct igd_vfio_pci_device {
> +	struct vfio_pci_core_device	vdev;
> +};

Why do you need this separate structure?  You could just use
vfio_pci_core_device directly.

> +static void igd_vfio_pci_release(void *device_data)
> +{
> +	struct vfio_pci_core_device *vdev = device_data;
> +
> +	mutex_lock(&vdev->reflck->lock);
> +	if (!(--vdev->refcnt)) {

No need for the braces here.

> +		vfio_pci_vf_token_user_add(vdev, -1);
> +		vfio_pci_core_spapr_eeh_release(vdev);
> +		vfio_pci_core_disable(vdev);
> +	}
> +	mutex_unlock(&vdev->reflck->lock);

But more importantly all this code should be in a helper exported
from the core code.

> +
> +	module_put(THIS_MODULE);

This looks bogus - the module reference is now gone while
igd_vfio_pci_release is still running.  Module refcounting always
need to be done by the caller, not the individual driver.

> +static int igd_vfio_pci_open(void *device_data)
> +{
> +	struct vfio_pci_core_device *vdev = device_data;
> +	int ret = 0;
> +
> +	if (!try_module_get(THIS_MODULE))
> +		return -ENODEV;

Same here - thi is something the caller needs to do.

> +	mutex_lock(&vdev->reflck->lock);
> +
> +	if (!vdev->refcnt) {
> +		ret = vfio_pci_core_enable(vdev);
> +		if (ret)
> +			goto error;
> +
> +		ret = vfio_pci_igd_init(vdev);
> +		if (ret && ret != -ENODEV) {
> +			pci_warn(vdev->pdev, "Failed to setup Intel IGD regions\n");
> +			vfio_pci_core_disable(vdev);
> +			goto error;
> +		}
> +		ret = 0;
> +		vfio_pci_probe_mmaps(vdev);
> +		vfio_pci_core_spapr_eeh_open(vdev);
> +		vfio_pci_vf_token_user_add(vdev, 1);

Way to much boilerplate.  Why doesn't the core only call a function
that does the vfio_pci_igd_init?

> +static const struct pci_device_id igd_vfio_pci_table[] = {
> +	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xff0000, 0 },

Please avoid the overly long line.  And a match as big as any Intel
graphics at very least needs a comment documenting why this is safe
and will perpetually remain safe.

> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
> +struct pci_driver *get_igd_vfio_pci_driver(struct pci_dev *pdev)
> +{
> +	if (pci_match_id(igd_vfio_pci_driver.id_table, pdev))
> +		return &igd_vfio_pci_driver;
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(get_igd_vfio_pci_driver);
> +#endif

> +	case PCI_VENDOR_ID_INTEL:
> +		if (pdev->class == PCI_CLASS_DISPLAY_VGA << 8)
> +			return get_igd_vfio_pci_driver(pdev);

And this now means that the core code has a dependency on the igd
one, making the whole split rather pointless.
