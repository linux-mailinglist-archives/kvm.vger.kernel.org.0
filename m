Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430562691CF
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgINQlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 12:41:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726036AbgINPaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 11:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AsQvpIFhmm7rdxQQSEFycj3eA12Y+/biDDpofX0AblY=;
        b=VPwFT7w1JM2GaHc7c+MI9rRGXU9BVLUuH0RnxZOEprXRgi74qMcGQeIw2nOQeEJ421aoh5
        nzWlBBIeCnafbjcuFCeukuvlhuLmQym3GcYe48DeRUfGYkCgej8X33EyLsXS9fPlAXl+Ue
        FRhNTxEo8IAIU/5epvd33zsiXnuS2YM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-DCdC4BPTMJ6m8a83aCuvBw-1; Mon, 14 Sep 2020 11:30:08 -0400
X-MC-Unique: DCdC4BPTMJ6m8a83aCuvBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F080801AC2;
        Mon, 14 Sep 2020 15:30:06 +0000 (UTC)
Received: from gondolin (ovpn-112-214.ams2.redhat.com [10.36.112.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1029060BE2;
        Mon, 14 Sep 2020 15:29:49 +0000 (UTC)
Date:   Mon, 14 Sep 2020 17:29:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v10 04/16] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200914172947.533ddf56.cohuck@redhat.com>
In-Reply-To: <20200821195616.13554-5-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-5-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:04 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Introduces a new driver callback to prevent a root user from unbinding
> an AP queue from its device driver if the queue is in use. The intent of
> this callback is to provide a driver with the means to prevent a root user
> from inadvertently taking a queue away from a matrix mdev and giving it to
> the host while it is assigned to the matrix mdev. The callback will
> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> attributes would result in one or more AP queues being removed from its
> driver. If the callback responds in the affirmative for any driver
> queried, the change to the apmask or aqmask will be rejected with a device
> in use error.
> 
> For this patch, only non-default drivers will be queried. Currently,
> there is only one non-default driver, the vfio_ap device driver. The
> vfio_ap device driver facilitates pass-through of an AP queue to a
> guest. The idea here is that a guest may be administered by a different
> sysadmin than the host and we don't want AP resources to unexpectedly
> disappear from a guest's AP configuration (i.e., adapters, domains and
> control domains assigned to the matrix mdev). This will enforce the proper
> procedure for removing AP resources intended for guest usage which is to
> first unassign them from the matrix mdev, then unbind them from the
> vfio_ap device driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reported-by: kernel test robot <lkp@intel.com>

This looks a bit odd...

> ---
>  drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
>  drivers/s390/crypto/ap_bus.h |   4 +
>  2 files changed, 142 insertions(+), 10 deletions(-)
> 

(...)

> @@ -1107,12 +1118,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>  	return rc;
>  }
>  
> +static int __verify_card_reservations(struct device_driver *drv, void *data)
> +{
> +	int rc = 0;
> +	struct ap_driver *ap_drv = to_ap_drv(drv);
> +	unsigned long *newapm = (unsigned long *)data;
> +
> +	/*
> +	 * No need to verify whether the driver is using the queues if it is the
> +	 * default driver.
> +	 */
> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
> +		return 0;
> +
> +	/* The non-default driver's module must be loaded */
> +	if (!try_module_get(drv->owner))
> +		return 0;
> +
> +	if (ap_drv->in_use)
> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
> +			rc = -EADDRINUSE;

ISTR that Christian suggested -EBUSY in a past revision of this series?
I think that would be more appropriate.

Also, I know we have discussed this before, but it is very hard to
figure out the offending device(s) if the sysfs manipulation failed. Can
we at least drop something into the syslog? That would be far from
perfect, but it gives an admin at least a chance to figure out why they
got an error. Some more structured way that would be usable from tools
can still be added later.

> +
> +	module_put(drv->owner);
> +
> +	return rc;
> +}

