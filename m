Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FC41ABEFA
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 13:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632900AbgDPLTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 07:19:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2632869AbgDPLTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 07:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587035939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/can4Mo5wcD8VxSmCD4glckN/kBnBrb4gDabEOaSwyw=;
        b=eH2ppfHNwikK8p9wtPS0CfhoygOl3XuBCy5WHxc9K1dcK4rQTS9reV3tIC6YbJtAYioo75
        +gJgXxuufZFRS7BbatwFhWcz3lWSgeq7gVJ4x3TYm7G9bHjRIOcyAe58rPUqZfMXEC8sMi
        u8KeQQGidqb0+MtrZ0W57hPZbSE3N+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-i6e1aPlgPd6TuQe7djFNRw-1; Thu, 16 Apr 2020 07:18:55 -0400
X-MC-Unique: i6e1aPlgPd6TuQe7djFNRw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FD0F149C3;
        Thu, 16 Apr 2020 11:18:53 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D7FD5D9E2;
        Thu, 16 Apr 2020 11:18:48 +0000 (UTC)
Date:   Thu, 16 Apr 2020 13:18:45 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 04/15] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20200416131845.3ef6b3b5.cohuck@redhat.com>
In-Reply-To: <20200407192015.19887-5-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-5-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 15:20:04 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's implement the callback to indicate when an APQN
> is in use by the vfio_ap device driver. The callback is
> invoked whenever a change to the apmask or aqmask would
> result in one or more queue devices being removed from the driver. The
> vfio_ap device driver will indicate a resource is in use
> if the APQN of any of the queue devices to be removed are assigned to
> any of the matrix mdevs under the driver's control.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c     | 47 +++++++++++++++++----------
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  3 files changed, 33 insertions(+), 17 deletions(-)

> @@ -1369,3 +1371,14 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>  	kfree(q);
>  	mutex_unlock(&matrix_dev->lock);
>  }
> +
> +bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
> +{
> +	bool in_use;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	in_use = vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm) ? true : false;

Maybe

in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);

?

> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return in_use;
> +}

