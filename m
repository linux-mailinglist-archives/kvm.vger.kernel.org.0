Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07F51A7A5F
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 14:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439906AbgDNMJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 08:09:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47750 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439890AbgDNMIx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 08:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586866132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BICdmTDYO4rOQ/Tod0xREH+kF4MdkX3G6Bj84FXcA2A=;
        b=EDTo166rMiV8sUGNcp2ueAfmN7W3GKhL7ul+S+9h75gN7SApN2jnP6fCXFo5smFBhY+uAW
        McZu3fcJpkZYyxSXBRe4viDLyNxLvTsk7Lnv4qoj08zi2dPnFbpoc9id/9Fr/XF1fIC7xD
        3tGIsRZgMUaCg7TLECvSCm8RGde6NnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-yO-Soot9MZmg4CXOz5LTNg-1; Tue, 14 Apr 2020 08:08:48 -0400
X-MC-Unique: yO-Soot9MZmg4CXOz5LTNg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76A9A800D5C;
        Tue, 14 Apr 2020 12:08:46 +0000 (UTC)
Received: from gondolin (ovpn-113-32.ams2.redhat.com [10.36.113.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D519410013A1;
        Tue, 14 Apr 2020 12:08:40 +0000 (UTC)
Date:   Tue, 14 Apr 2020 14:08:38 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200414140838.54f777b8.cohuck@redhat.com>
In-Reply-To: <20200407192015.19887-4-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-4-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> 
> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
> index 5256e3ce84e5..af15c095e76a 100644
> --- a/drivers/s390/crypto/ap_bus.c
> +++ b/drivers/s390/crypto/ap_bus.c
> @@ -35,6 +35,7 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> +#include <linux/module.h>
>  
>  #include "ap_bus.h"
>  #include "ap_debug.h"
> @@ -995,9 +996,11 @@ int ap_parse_mask_str(const char *str,
>  	newmap = kmalloc(size, GFP_KERNEL);
>  	if (!newmap)
>  		return -ENOMEM;
> -	if (mutex_lock_interruptible(lock)) {
> -		kfree(newmap);
> -		return -ERESTARTSYS;
> +	if (lock) {
> +		if (mutex_lock_interruptible(lock)) {
> +			kfree(newmap);
> +			return -ERESTARTSYS;
> +		}

This whole function is a bit odd. It seems all masks we want to
manipulate are always guarded by the ap_perms_mutex, and the need for
allowing lock == NULL comes from wanting to call this function with the
ap_perms_mutex already held.

That would argue for a locked/unlocked version of this function... but
looking at it, why do we lock the way we do? The one thing this
function (prior to this patch) does outside of the holding of the mutex
is the allocation and freeing of newmap. But with this patch, we do the
allocation and freeing of newmap while holding the mutex. Something
seems a bit weird here.

>  	}
>  
>  	if (*str == '+' || *str == '-') {

