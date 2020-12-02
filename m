Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C572CC7D1
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 21:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgLBUa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 15:30:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727322AbgLBUa0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 15:30:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606940940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fCxAKSCZe5m5KQLZ03JszdsFqurd7mJTU7sYz3VIef4=;
        b=c79t2vmH9JxAmlyN+5P7DlhinPRm1tUIfHF9WyLUmvSJomKWwkZEWzM0TmZ/CAKyNRb2eg
        EAm7C+eK62yzwXwo++d6DtkPSmrbrr5mY5TkjQasuXlMzIS0/qScHHU5DVF1vbh+UIhvFj
        g3INUlWsFHNyIS3tW9hR8rC/DGEdGr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-L_iiw6j8ObGjXtYHOHaNaQ-1; Wed, 02 Dec 2020 15:28:58 -0500
X-MC-Unique: L_iiw6j8ObGjXtYHOHaNaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18F54803F57;
        Wed,  2 Dec 2020 20:28:39 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93F8F60854;
        Wed,  2 Dec 2020 20:28:38 +0000 (UTC)
Date:   Wed, 2 Dec 2020 13:28:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
Message-ID: <20201202132838.6a872c17@w520.home>
In-Reply-To: <20201120180740.87837-2-farman@linux.ibm.com>
References: <20201120180740.87837-1-farman@linux.ibm.com>
        <20201120180740.87837-2-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Nov 2020 19:07:39 +0100
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
> Let's wire in the request call back to the mdev device, so that a
> device being physically removed from the host can be (gracefully?)
> handled by the parent device at the time the device is removed.
> 
> Add a message when registering the device if a driver doesn't
> provide this callback, so a clue is given that this same loop
> may be encountered in a similar situation.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/vfio/mdev/mdev_core.c |  4 ++++
>  drivers/vfio/mdev/vfio_mdev.c | 10 ++++++++++
>  include/linux/mdev.h          |  4 ++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b558d4cfd082..6de97d25a3f8 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -154,6 +154,10 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>  	if (!dev)
>  		return -EINVAL;
>  
> +	/* Not mandatory, but its absence could be a problem */
> +	if (!ops->request)
> +		dev_info(dev, "Driver cannot be asked to release device\n");
> +
>  	mutex_lock(&parent_list_lock);
>  
>  	/* Check for duplicate */
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index 30964a4e0a28..06d8fc4a6d72 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -98,6 +98,15 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>  	return parent->ops->mmap(mdev, vma);
>  }
>  
> +static void vfio_mdev_request(void *device_data, unsigned int count)
> +{
> +	struct mdev_device *mdev = device_data;
> +	struct mdev_parent *parent = mdev->parent;
> +
> +	if (parent->ops->request)
> +		parent->ops->request(mdev, count);

What do you think about duplicating the count==0 notice in the else
case here?  ie.

	else if (count == 0)
		dev_notice(mdev_dev(mdev), "No mdev vendor driver	request callback support, blocked until released by user\n");

This at least puts something in the log a bit closer to the timeframe
of a possible issue versus the registration nag.  vfio-core could do
this too, but vfio-mdev registers a request callback on behalf of all
mdev devices, so vfio-core would no longer have visibility for this
case.

Otherwise this series looks fine to me and I can take it through the
vfio tree.  Thanks,

Alex

> +}
> +
>  static const struct vfio_device_ops vfio_mdev_dev_ops = {
>  	.name		= "vfio-mdev",
>  	.open		= vfio_mdev_open,
> @@ -106,6 +115,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
>  	.read		= vfio_mdev_read,
>  	.write		= vfio_mdev_write,
>  	.mmap		= vfio_mdev_mmap,
> +	.request	= vfio_mdev_request,
>  };
>  
>  static int vfio_mdev_probe(struct device *dev)
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..9004375c462e 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
>   * @mmap:		mmap callback
>   *			@mdev: mediated device structure
>   *			@vma: vma structure
> + * @request:		request callback to release device
> + *			@mdev: mediated device structure
> + *			@count: request sequence number
>   * Parent device that support mediated device should be registered with mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -92,6 +95,7 @@ struct mdev_parent_ops {
>  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>  			 unsigned long arg);
>  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +	void	(*request)(struct mdev_device *mdev, unsigned int count);
>  };
>  
>  /* interface for exporting mdev supported type attributes */

