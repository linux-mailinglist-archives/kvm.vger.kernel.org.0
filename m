Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1374439EFA3
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 09:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhFHHhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 03:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHHhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 03:37:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED6B61287;
        Tue,  8 Jun 2021 07:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623137719;
        bh=2006A+/OxY4fItYSMZBiWPqyZNtUKmp8lJdQSRjk1Vg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZYFtMPtoz7DZIIgNgRCfkBIZPlBJwGtSy9ELzzO8s2KyNZrKlCvDRUt9AmvHyPMR/
         +1nsaXSCokzL7JMEY3hZ3CIlMQkH4cssht9+SjKlFo8NgaCKsBTxHWAkgXIgERW4c9
         DQl89zgkGYNzr5ftlQ4PG2k9Lk3S+ARgRmDdiwAY=
Date:   Tue, 8 Jun 2021 09:35:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 01/10] driver core: Do not continue searching for drivers
 if deferred probe is used
Message-ID: <YL8dtaVoNGFo9PwU@kroah.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 09:55:43PM -0300, Jason Gunthorpe wrote:
> Once a driver has been matched and probe() returns with -EPROBE_DEFER the
> device is added to a deferred list and will be retried later.
> 
> At this point __device_attach_driver() should stop trying other drivers as
> we have "matched" this driver and already scheduled another probe to
> happen later.
> 
> Return the -EPROBE_DEFER from really_probe() instead of squashing it to
> zero. This is similar to the code at the top of the function which
> directly returns -EPROBE_DEFER.
> 
> It is not really a bug as, AFAIK, we don't actually have cases where
> multiple drivers can bind.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/base/dd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index ecd7cf848daff7..9d79a139290271 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -656,7 +656,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  		/* Driver requested deferred probing */
>  		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
>  		driver_deferred_probe_add_trigger(dev, local_trigger_count);
> -		break;
> +		goto done;
>  	case -ENODEV:
>  	case -ENXIO:
>  		pr_debug("%s: probe of %s rejects match %d\n",
> -- 
> 2.31.1
> 

Why is lkml not cc:ed on driver core changes like get_maintainer.pl will
say?

thanks,

greg k-h
