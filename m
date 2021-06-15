Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ED03A8176
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhFON4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:56:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230306AbhFON4M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 09:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623765247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LTPum8fRwPooExg8+HCTnewiRqyT0ffgzpim9aaEyrQ=;
        b=fSo+LlotClQHpZ9ELEc42+jhwfs3bWY2e+7q2Yo4V9Q7wBr4I2+YNKL8r43eWfRUg4Tl6w
        daKWfQv0IYzmclC0GqwbYH3CPiSETLQqGPl4MVHnbC38vU9ikJqBfc+3d2kOipla+SVcHi
        HNAc6CdoPDZQU2a6uD5859uHKxzBxAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-C13r6FEsM8GkbdBbTqx5OQ-1; Tue, 15 Jun 2021 09:54:05 -0400
X-MC-Unique: C13r6FEsM8GkbdBbTqx5OQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36B141084F40;
        Tue, 15 Jun 2021 13:54:03 +0000 (UTC)
Received: from localhost (ovpn-113-156.ams2.redhat.com [10.36.113.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D17571037F22;
        Tue, 15 Jun 2021 13:53:47 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
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
In-Reply-To: <20210615133519.754763-3-hch@lst.de>
Organization: Red Hat GmbH
References: <20210615133519.754763-1-hch@lst.de>
 <20210615133519.754763-3-hch@lst.de>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 15 Jun 2021 15:53:46 +0200
Message-ID: <8735tjxmhh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15 2021, Christoph Hellwig <hch@lst.de> wrote:

> really_probe tries to special case errors from ->probe, but due to all
> other initialization added to the function over time now a lot of
> internal errors hit that code path as well.  Untangle that by adding
> a new probe_err local variable and apply the special casing only to
> that.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/base/dd.c | 72 +++++++++++++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 7477d3322b3a..fd83817240e6 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -513,12 +513,44 @@ static ssize_t state_synced_show(struct device *dev,
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
> +	case 0:
> +		break;
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

Convert these two pr_* to dev_* when touching the code anyway?

> +		break;
> +	}
> +
> +	return ret;
> +}

(...)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

