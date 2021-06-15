Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B593A765B
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 07:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFOFTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 01:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhFOFTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 01:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A4A6140C;
        Tue, 15 Jun 2021 05:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623734267;
        bh=o5H3N+ttWbWHWjYPgpfy4o3PJQZNstkMmkd4t2exljM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dfVQlIxuSd9gn4cLpBWRc70JY9BVo+kBT3kLsMpn640l44DMJOp/FjwervZaIpAcv
         xAcvQdaEqyMEx85dY6PnCde9SRE0MVfPrcS5qBBdfb8TGIaT/RMFIeEu7Yat1tdv/O
         JlLnebQM+AZrIR4ysW8BHmz3OEKi7nb4wp2JtP0Q=
Date:   Tue, 15 Jun 2021 07:17:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 02/10] driver core: Better distinguish probe errors in
 really_probe
Message-ID: <YMg39xWiesZzjVUr@kroah.com>
References: <20210614150846.4111871-1-hch@lst.de>
 <20210614150846.4111871-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614150846.4111871-3-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 05:08:38PM +0200, Christoph Hellwig wrote:
> really_probe tries to special case errors from ->probe, but due to all
> other initialization added to the function over time now a lot of
> internal errors hit that code path as well.  Untangle that by adding
> a new probe_err local variable and apply the special casing only to
> that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/base/dd.c | 72 +++++++++++++++++++++++++++--------------------
>  1 file changed, 41 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 7477d3322b3a..999bc737a8f0 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -513,12 +513,42 @@ static ssize_t state_synced_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(state_synced);
>  
> +
> +static int call_driver_probe(struct device *dev, struct device_driver *drv)
> +{
> +	int ret = 0;
> +
> +	if (dev->bus->probe)
> +		ret = dev->bus->probe(dev);
> +	else if (drv->probe)
> +		ret = drv->probe(dev);
> +
> +	switch (ret) {
> +	case -EPROBE_DEFER:
> +		/* Driver requested deferred probing */
> +		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
> +		break;
> +	case -ENODEV:
> +	case -ENXIO:
> +		pr_debug("%s: probe of %s rejects match %d\n",
> +			 drv->name, dev_name(dev), ret);
> +		break;
> +	default:
> +		/* driver matched but the probe failed */
> +		pr_warn("%s: probe of %s failed with error %d\n",
> +			drv->name, dev_name(dev), ret);
> +		break;
> +	}

Like Kirti said, 0 needs to be handled here.  Did this not spew a lot of
warnings in the logs?

And we can fix up the pr_* calls to use dev_* in the future, shows the
evolution of this code...

thanks,

greg k-h
