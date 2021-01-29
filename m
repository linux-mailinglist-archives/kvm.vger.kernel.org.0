Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73490308FBA
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 23:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhA2V6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 16:58:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233484AbhA2V6u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 16:58:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611957443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5YVcOkwFFm48l6Zi4vmCbz0p0EJ/vTLsab5z/Tqy2a0=;
        b=fU6TFm6sv9929oT/r6OgzKzi0RH20/ABswchHR/jrgyBXBOb0haWoE/NzJepAu0S4YfqJw
        H/t+L56tRLCHN/WlPMVPoR61LttA48fMVBT4lTrdkNDekf4CkUSHZhtQ8pGGh4wYBiTAG2
        Zzcrq0uCMuVPUS+9skC3nT6bCC3Pemk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-aNw0tJyBOHW5YkFAuUCwTg-1; Fri, 29 Jan 2021 16:57:21 -0500
X-MC-Unique: aNw0tJyBOHW5YkFAuUCwTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F12228066EC;
        Fri, 29 Jan 2021 21:57:19 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD4BC5C290;
        Fri, 29 Jan 2021 21:57:19 +0000 (UTC)
Date:   Fri, 29 Jan 2021 14:57:19 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 7/9] vfio: iommu driver notify callback
Message-ID: <20210129145719.1b6cbe9c@omen.home.shazbot.org>
In-Reply-To: <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:10 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Define a vfio_iommu_driver_ops notify callback, for sending events to
> the driver.  Drivers are not required to provide the callback, and
> may ignore any events.  The handling of events is driver specific.
> 
> Define the CONTAINER_CLOSE event, called when the container's file
> descriptor is closed.  This event signifies that no further state changes
> will occur via container ioctl's.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio.c  | 5 +++++
>  include/linux/vfio.h | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 262ab0e..99458fc 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1220,6 +1220,11 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
>  static int vfio_fops_release(struct inode *inode, struct file *filep)
>  {
>  	struct vfio_container *container = filep->private_data;
> +	struct vfio_iommu_driver *driver = container->iommu_driver;
> +
> +	if (driver && driver->ops->notify)
> +		driver->ops->notify(container->iommu_data,
> +				    VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE, NULL);
>  
>  	filep->private_data = NULL;
>  
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 38d3c6a..9642579 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -57,6 +57,9 @@ extern int vfio_add_group_dev(struct device *dev,
>  extern void vfio_device_put(struct vfio_device *device);
>  extern void *vfio_device_data(struct vfio_device *device);
>  
> +/* events for the backend driver notify callback */
> +#define VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE	1

We should use an enum for type checking.

> +
>  /**
>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
>   */
> @@ -90,6 +93,8 @@ struct vfio_iommu_driver_ops {
>  					       struct notifier_block *nb);
>  	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
>  				  void *data, size_t count, bool write);
> +	void		(*notify)(void *iommu_data, unsigned int event,
> +				  void *data);

I'm not sure why we're pre-enabling this 3rd arg, do you have some
short term usage in mind that we can't easily add on demand later?
This is an internal API, not one we need to keep stable.  Thanks,

Alex

>  };
>  
>  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);

