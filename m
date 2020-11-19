Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4222B9112
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 12:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgKSLai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 06:30:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgKSLah (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 06:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605785436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGRN4UY9mB+JZb0NfSRYVEcCVr604axDbJuKJG4uiDI=;
        b=AeCoYl4xhC7MkqLN2/1EJ/pRc3mmaeYeAd7J+nk8rM/0n9hwe5ydFHN++E2kT0wreSgYbI
        FlHF5iWS/GNPl7PLncazUWSh/ZTkM8M6KmeVSZYxdWhHZd6cXk6mLeJKu8LxPpIoT284Ut
        k1UUGPYOhPLh+FC/o+oQuPt48vQQq6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-NkHZomPROVqV1l_N2OiT5g-1; Thu, 19 Nov 2020 06:30:34 -0500
X-MC-Unique: NkHZomPROVqV1l_N2OiT5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 742F83FDD;
        Thu, 19 Nov 2020 11:30:33 +0000 (UTC)
Received: from gondolin (ovpn-113-214.ams2.redhat.com [10.36.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECBBE1002388;
        Thu, 19 Nov 2020 11:30:28 +0000 (UTC)
Date:   Thu, 19 Nov 2020 12:30:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
Message-ID: <20201119123026.1353cb3c.cohuck@redhat.com>
In-Reply-To: <20201117032139.50988-2-farman@linux.ibm.com>
References: <20201117032139.50988-1-farman@linux.ibm.com>
        <20201117032139.50988-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 04:21:38 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> While performing some destructive tests with vfio-ccw, where the
> paths to a device are forcible removed and thus the device itself
> is unreachable, it is rather easy to end up in an endless loop in
> vfio_del_group_dev() due to the lack of a request callback for the
> associated device.
> 
> In this example, one MDEV (77c) is used by a guest, while another
> (77b) is not. The symptom is that the iommu is detached from the
> mdev for 77b, but not 77c, until that guest is shutdown:
> 
>     [  238.794867] vfio_ccw 0.0.077b: MDEV: Unregistering
>     [  238.794996] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: Removing from iommu group 2
>     [  238.795001] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: MDEV: detaching iommu
>     [  238.795036] vfio_ccw 0.0.077c: MDEV: Unregistering
>     ...silence...
> 
> Let's wire in the request call back to the mdev device, so that a hot
> unplug can be (gracefully?) handled by the parent device at the time
> the device is being removed.

I think it makes a lot of sense to give the vendor driver a way to
handle requests.

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c | 11 +++++++++++
>  include/linux/mdev.h          |  4 ++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index 30964a4e0a28..2dd243f73945 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -98,6 +98,16 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>  	return parent->ops->mmap(mdev, vma);
>  }
>  
> +static void vfio_mdev_request(void *device_data, unsigned int count)
> +{
> +	struct mdev_device *mdev = device_data;
> +	struct mdev_parent *parent = mdev->parent;
> +
> +	if (unlikely(!parent->ops->request))

Hm. Do you think that all drivers should implement a ->request()
callback?

> +		return;
> +	parent->ops->request(mdev, count);
> +}
> +
>  static const struct vfio_device_ops vfio_mdev_dev_ops = {
>  	.name		= "vfio-mdev",
>  	.open		= vfio_mdev_open,

