Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B533D3570
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 09:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhGWG6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 02:58:45 -0400
Received: from verein.lst.de ([213.95.11.211]:37361 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhGWG6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 02:58:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BF95067373; Fri, 23 Jul 2021 09:39:14 +0200 (CEST)
Date:   Fri, 23 Jul 2021 09:39:14 +0200
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
Subject: Re: [PATCH v2 04/14] vfio: Provide better generic support for
 open/release vfio_device_ops
Message-ID: <20210723073914.GC864@lst.de>
References: <0-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com> <4-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +int vfio_assign_device_set(struct vfio_device *device, void *set_id)
> +{
> +	struct vfio_device_set *alloc_dev_set = NULL;
> +	struct vfio_device_set *dev_set;
> +
> +	if (WARN_ON(!set_id))
> +		return -EINVAL;
> +
> +	/*
> +	 * Atomically acquire a singleton object in the xarray for this set_id
> +	 */
> +again:
> +	xa_lock(&vfio_device_set_xa);
> +	if (alloc_dev_set) {
> +		dev_set = __xa_cmpxchg(&vfio_device_set_xa,
> +				       (unsigned long)set_id, NULL,
> +				       alloc_dev_set, GFP_KERNEL);
> +		if (xa_is_err(dev_set)) {
> +			xa_unlock(&vfio_device_set_xa);
> +			kfree(alloc_dev_set);
> +			return xa_err(dev_set);
> +		}
> +		if (!dev_set)
> +			dev_set = alloc_dev_set;
> +	} else {
> +		dev_set = xa_load(&vfio_device_set_xa, (unsigned long)set_id);
> +	}
> +
> +	if (dev_set) {
> +		dev_set->device_count++;
> +		xa_unlock(&vfio_device_set_xa);
> +		device->dev_set = dev_set;
> +		if (dev_set != alloc_dev_set)
> +			kfree(alloc_dev_set);
> +		return 0;
> +	}
> +	xa_unlock(&vfio_device_set_xa);
> +
> +	if (WARN_ON(alloc_dev_set))
> +		return -EINVAL;
> +
> +	alloc_dev_set = kzalloc(sizeof(*alloc_dev_set), GFP_KERNEL);
> +	if (!alloc_dev_set)
> +		return -ENOMEM;
> +	mutex_init(&alloc_dev_set->lock);
> +	alloc_dev_set->set_id = set_id;
> +	goto again;
> +}
> +EXPORT_SYMBOL_GPL(vfio_assign_device_set);

This looks unessecarily complicated.  We can just try to load first
and then store it under the same lock, e.g.:

int vfio_assign_device_set(struct vfio_device *device, void *set_id)
{
	unsigned long idx = (unsigned long)set_id;
	struct vfio_device_set *set, *new;
	int err;

	if (WARN_ON(!set_id))
		return -EINVAL;

	xa_lock(&vfio_device_set_xa);
	set = xa_load(&vfio_device_set_xa, idx);
	if (set)
		goto found;
	xa_unlock(&vfio_device_set_xa);

	new = kzalloc(sizeof(*new), GFP_KERNEL);
	if (!new)
		return -ENOMEM;
	mutex_init(&new->lock);
	alloc_dev_set->set_id = set_id;

	xa_lock(&vfio_device_set_xa);
	set = xa_load(&vfio_device_set_xa, idx);
	if (set) {
		kfree(new);
		goto found;
	}
	err = xa_err(__xa_store(&vfio_device_set_xa, idx, new, GFP_KERNEL));
	xa_unlock(&vfio_device_set_xa);
	if (err)
		kfree(new);
	return err;

found:
	set->device_count++;
	xa_unlock(&vfio_device_set_xa);

	device->dev_set = set;
	return 0;
}

> +static void vfio_release_device_set(struct vfio_device *device)
> +{
> +	struct vfio_device_set *dev_set = device->dev_set;
> +
> +	if (!dev_set)
> +		return;
> +
> +	xa_lock(&vfio_device_set_xa);
> +	dev_set->device_count--;
> +	if (!dev_set->device_count) {

Nit, by I'd find

	if (!--dev_set->device_count) {

easier to follow as it clearly documents the dec_and_test pattern.
