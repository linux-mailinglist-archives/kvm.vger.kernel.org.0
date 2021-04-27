Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1C536C615
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 14:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhD0MdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 08:33:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235410AbhD0MdY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 08:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619526760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uD+dfFLq7YLHiJhFYup2fr0QjlX385E8xYG7uQWWaho=;
        b=LzFv7pb2aHbCgX9BjijAHN/NuJx8hxqeN2hxgwzPLxWWfW4v3d7CYXT/OcIUGaQnka4g5A
        C18M2TA9m3YbTzl3X4KPvO8a7opzYVDZuXq4/4ubkqy4sdydqPXIBjDt4vPCQQuOb4Jhbq
        x2cb2HkkrdBOcnCXSlc6HjJjlVmK1NU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-vbJGX1YkP3aS1A8kdXkUEA-1; Tue, 27 Apr 2021 08:32:38 -0400
X-MC-Unique: vbJGX1YkP3aS1A8kdXkUEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4204650202;
        Tue, 27 Apr 2021 12:32:36 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2699E6ACED;
        Tue, 27 Apr 2021 12:32:29 +0000 (UTC)
Date:   Tue, 27 Apr 2021 14:32:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to
 specify the device driver to bind
Message-ID: <20210427143227.62f304fd.cohuck@redhat.com>
In-Reply-To: <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Apr 2021 17:00:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This allows a mdev driver to opt out of using vfio_mdev.c, instead the
> driver will provide a 'struct mdev_driver' and register directly with the
> driver core.
> 
> Much of mdev_parent_ops becomes unused in this mode:
> - create()/remove() are done via the mdev_driver probe()/remove()
> - mdev_attr_groups becomes mdev_driver driver.dev_groups
> - Wrapper function callbacks are replaced with the same ones from
>   struct vfio_device_ops
> 
> Following patches convert all the drivers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c   | 64 ++++++++++++++++++++++++++++-----
>  drivers/vfio/mdev/mdev_driver.c | 17 ++++++++-
>  include/linux/mdev.h            |  3 ++
>  3 files changed, 75 insertions(+), 9 deletions(-)
> 

(...)

> +/*
> + * mdev drivers can refuse to bind during probe(), in this case we want to fail
> + * the creation of the mdev all the way back to sysfs. This is a weird model
> + * that doesn't fit in the driver core well, nor does it seem to appear any
> + * place else in the kernel, so use a simple hack.
> + */
> +static int mdev_bind_driver(struct mdev_device *mdev)
> +{
> +	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
> +	int ret;
> +
> +	if (!drv)
> +		drv = &vfio_mdev_driver;
> +
> +	while (1) {
> +		device_lock(&mdev->dev);
> +		if (mdev->dev.driver == &drv->driver) {
> +			ret = 0;
> +			goto out_unlock;
> +		}
> +		if (mdev->probe_err) {
> +			ret = mdev->probe_err;
> +			goto out_unlock;
> +		}
> +		device_unlock(&mdev->dev);
> +		ret = device_attach(&mdev->dev);
> +		if (ret)
> +			return ret;

device_attach() can return 0 (no driver), 1 (bound), or -ENODEV (device
not registered). I would expect mdev_bind_driver() to return 0 in case
of success and !0 otherwise, and I think the calling code does so as
well?

> +		mdev->probe_err = -EINVAL;
> +	}
> +	return 0;
> +
> +out_unlock:
> +	device_unlock(&mdev->dev);
> +	return ret;
> +}
> +

(...)

Rest of the patch looks good to me.

