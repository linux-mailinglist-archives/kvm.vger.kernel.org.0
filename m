Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE939EEEF
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFHGtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhFHGtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4B461027;
        Tue,  8 Jun 2021 06:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623134844;
        bh=kaTVq/Hk7NJvoFOUhEQDxznkWNHv5MDOC1NPOGM5UO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cwqQ9x/gtw9V1Om2nM9STs8fV4iVqo8DVR0jGQWgmABbVwXhT70slO/BB0mL4Y4xe
         WRMYKCYb6/bfkfEzyjkHeWyncEYqy2BF+wA3KB7UiEgi9zbr70OPDBsd2p6kZcBn5O
         gkZIGTFsDg93A7XipuHMZ4yjs/XxKulRtSRDLtv4=
Date:   Tue, 8 Jun 2021 08:47:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
Message-ID: <YL8SdymSgn9HHRcw@kroah.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 09:55:45PM -0300, Jason Gunthorpe wrote:
> Currently really_probe() returns 1 on success and 0 if the probe() call
> fails. This return code arrangement is designed to be useful for
> __device_attach_driver() which is walking the device list and trying every
> driver. 0 means to keep trying.
> 
> However, it is not useful for the other places that call through to
> really_probe() that do actually want to see the probe() return code.
> 
> For instance bind_store() would be better to return the actual error code
> from the driver's probe method, not discarding it and returning -ENODEV.

Why does that matter?  Why does it need to know this?

> Reorganize things so that really_probe() always returns an error code on
> failure and 0 on success. Move the special code for device list walking
> into the walker callback __device_attach_driver() and trigger it based on
> an output flag from really_probe(). Update the rest of the API surface to
> return a normal -ERR or 0 on success.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/base/bus.c |  6 +----
>  drivers/base/dd.c  | 61 ++++++++++++++++++++++++++++++----------------
>  2 files changed, 41 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 36d0c654ea6124..03591f82251302 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -212,13 +212,9 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
>  	dev = bus_find_device_by_name(bus, NULL, buf);
>  	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
>  		err = device_driver_attach(drv, dev);
> -
> -		if (err > 0) {
> +		if (!err) {
>  			/* success */
>  			err = count;
> -		} else if (err == 0) {
> -			/* driver didn't accept device */
> -			err = -ENODEV;
>  		}
>  	}
>  	put_device(dev);
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index c1a92cff159873..7fb58e6219b255 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -513,7 +513,13 @@ static ssize_t state_synced_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(state_synced);
>  
> -static int really_probe(struct device *dev, struct device_driver *drv)
> +enum {
> +	/* Set on output if the -ERR has come from a probe() function */
> +	PROBEF_DRV_FAILED = 1 << 0,
> +};
> +
> +static int really_probe(struct device *dev, struct device_driver *drv,
> +			unsigned int *flags)

Ugh, no, please no functions with random "flags" in them, that way lies
madness and unmaintainable code for decades to come.

Especially as I have no idea what this is trying to solve here at all...

greg k-h
