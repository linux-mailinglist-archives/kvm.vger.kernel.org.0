Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF85B39EE85
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFHGJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhFHGJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:09:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C0FC061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 23:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X12rlbwr+ZiImMvNMBsP9R0OHLG3IQDhAtyOjkYUUrM=; b=k3GWirfzzr4oo3GKWNUv4aMzLT
        Sf17GIDFVJUah+jVyhsu/uQPCKGNl9+mgbppTRcNNk4sMw9WlEyVrgRprYGQ/C3BDGUSY0SxcoiBy
        vBiCcDA3gZcemt+rLl3ezv3sZ5oHbkC+hTusvF5SUkgM0czfX0NV68l47mmkR9ODeNI53uqnZYQU/
        B93vlpdQHLbyYeuCpuP0WS45XZi7BaNMZ5e+fvNYpmxBoC14XFG/qhDFKDe51Npii9mHbUTG9RBKO
        qCLeFYxQq07LN1seH+z/go6QUrirGeZ51jewzKQwWBOfDSOz4TWxK1aZG3ekuyPey9flB/RrJN08x
        uqQDSBTQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqUtx-00GcQx-T9; Tue, 08 Jun 2021 06:07:52 +0000
Date:   Tue, 8 Jun 2021 07:07:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
Message-ID: <YL8JNWJeh6JSB/DS@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

I think we can also drop the dev->driver == NULL check above given
that device_driver_attach covers it now.
