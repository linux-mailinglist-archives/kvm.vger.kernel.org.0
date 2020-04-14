Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5B71A7B8C
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502463AbgDNM7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 08:59:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502442AbgDNM7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 08:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586869145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0fdJexKCJPjvfrLIsyDcvHn2Ex4ChlT7CSP78FqF/p0=;
        b=VnNj778cGKUlivICZIfMFaM8HVcvPy1DHC7xDzuPpnMRdUSsdcsZnQy/ViiTBwvNrpTXLP
        AkctvHSIZXm3mh+lMv+vPWSDyemCjyh8dXiRqn8SQsUYEj0LondzPmov3usGpnI3t6gZUV
        dd8FHLsKw043yc3WnaTYkQoehyXZ3zM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-vOXVWCNXO6iub9T6nt5_og-1; Tue, 14 Apr 2020 08:59:02 -0400
X-MC-Unique: vOXVWCNXO6iub9T6nt5_og-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FD1E13F8;
        Tue, 14 Apr 2020 12:59:00 +0000 (UTC)
Received: from gondolin (ovpn-113-32.ams2.redhat.com [10.36.113.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD8425C1B2;
        Tue, 14 Apr 2020 12:58:54 +0000 (UTC)
Date:   Tue, 14 Apr 2020 14:58:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200414145851.562867ae.cohuck@redhat.com>
In-Reply-To: <20200407192015.19887-4-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-4-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 15:20:03 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Introduces a new driver callback to prevent a root user from unbinding
> an AP queue from its device driver if the queue is in use. The intent of
> this callback is to provide a driver with the means to prevent a root user
> from inadvertently taking a queue away from a guest and giving it to the
> host while the guest is still using it. The callback will
> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> attributes would result in one or more AP queues being removed from its
> driver. If the callback responds in the affirmative for any driver
> queried, the change to the apmask or aqmask will be rejected with a device
> in use error.
> 
> For this patch, only non-default drivers will be queried. Currently,
> there is only one non-default driver, the vfio_ap device driver. The
> vfio_ap device driver manages AP queues passed through to one or more
> guests and we don't want to unexpectedly take AP resources away from
> guests which are most likely independently administered.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/ap_bus.c | 144 +++++++++++++++++++++++++++++++++--
>  drivers/s390/crypto/ap_bus.h |   4 +
>  2 files changed, 142 insertions(+), 6 deletions(-)

(...)

> @@ -1196,12 +1202,75 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>  	return rc;
>  }
>  
> +int __verify_card_reservations(struct device_driver *drv, void *data)
> +{
> +	int rc = 0;
> +	struct ap_driver *ap_drv = to_ap_drv(drv);
> +	unsigned long *newapm = (unsigned long *)data;
> +
> +	/*
> +	 * If the reserved bits do not identify cards reserved for use by the
> +	 * non-default driver, there is no need to verify the driver is using
> +	 * the queues.

I had to read that one several times... what about

"No need to verify whether the driver is using the queues if it is the
default driver."

?

> +	 */
> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
> +		return 0;
> +
> +	/* The non-default driver's module must be loaded */
> +	if (!try_module_get(drv->owner))
> +		return 0;

Is that really needed? I would have thought that the driver core's
klist usage would make sure that the callback would not be invoked for
drivers that are not registered anymore. Or am I missing a window?

> +
> +	if (ap_drv->in_use)
> +		if (ap_drv->in_use(newapm, ap_perms.aqm))

Can we log the offending apm somewhere, preferably with additional info
that allows the admin to figure out why an error was returned?

> +			rc = -EADDRINUSE;
> +
> +	module_put(drv->owner);
> +
> +	return rc;
> +}

(Same comments for the other changes further along in this patch.)

