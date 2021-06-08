Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7632839EE77
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 07:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhFHGB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHGB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:01:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1940C061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 22:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qDK2jrYmj+1pFZYRZJUUFtmlySsQh8iORp+MZzucGsY=; b=HqqSbTPpej1OXrcJnSP4DUZMRk
        787i5EbNFD+VbOaoRG/rLzbBKw6Rp7mGlJK8YIFfNNRG52/Us5p0VcER4pIX2+4XV78H1pr5ssw8J
        MOnAFkRAkGw35ICuWbSj5ODUYZ6MwcoEG/hL5pQ6/wAeZEfDl55HgyXOhHEi2QiKq74n8z1uTYPy0
        dxxcbJi6IzAJuuczOpwcUqd8VcXr7fug4VHVG/es94yUwMKsCGptdgGqLpRWDAGYgPp86xqEykj1f
        iI/SgxxQEmDJtLfuzPel6hGlJfYkv3XaLu2PbgyikX3uehakCI8OOR+5CiEmSWV9BxRaWoQ2ScwN/
        fPowQCsQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqUla-00Gc5N-7p; Tue, 08 Jun 2021 05:59:16 +0000
Date:   Tue, 8 Jun 2021 06:59:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 02/10] driver core: Pull required checks into
 driver_probe_device()
Message-ID: <YL8HLhJNFgIGfEQm@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <2-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This looks good as-is, but a suggestions for incremental improvements
below:

> @@ -1032,10 +1035,10 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
>  	__device_driver_lock(dev, dev->parent);
>  
>  	/*
> -	 * If device has been removed or someone has already successfully
> -	 * bound a driver before us just skip the driver probe call.
> +	 * If device someone has already successfully bound a driver before us
> +	 * just skip the driver probe call.
>  	 */
> -	if (!dev->p->dead && !dev->driver)
> +	if (!dev->driver)
>  		ret = driver_probe_device(drv, dev);
>  
>  	__device_driver_unlock(dev, dev->parent);

It is kinda silly to keep the ->driver check here given that one caller
completely ignores the return value, and the other turns a 0 return into
-ENODEV anyway.  So I think this check can go away, turning
device_driver_attach into a trivial wrapper for driver_probe_device
that adds locking, which might be useful to reflect in the naming.

> @@ -1047,19 +1050,11 @@ static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
>  {
>  	struct device *dev = _dev;
>  	struct device_driver *drv;
> -	int ret = 0;
> +	int ret;
>  
>  	__device_driver_lock(dev, dev->parent);
> -
>  	drv = dev->p->async_driver;
> -
> -	/*
> -	 * If device has been removed or someone has already successfully
> -	 * bound a driver before us just skip the driver probe call.
> -	 */
> -	if (!dev->p->dead && !dev->driver)
> -		ret = driver_probe_device(drv, dev);
> -
> +	ret = driver_probe_device(drv, dev);
>  	__device_driver_unlock(dev, dev->parent);

And that helper could be used here as well.
