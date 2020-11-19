Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBC12B916E
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 12:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgKSLnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 06:43:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727424AbgKSLni (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 06:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605786216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WUYap8gY5bjSeoiHXPXEEi4d4ns50LDbxY/EfjLaaTw=;
        b=T9obI0nLj3Mz994wTP4UuNqrG0pJI/picM1+SzA570i8lkVaROeCD7AyAgcn61Q2h+Iv9y
        z685IwFQc0yEYg93dck3mB1ZT5Z6PzJAGQOSGcrn62KKl30NcALF8LrUhxtbevjHNtl3H+
        jRdcC3iBkp7AIKhXI8PbXj3fBurBIyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-tBRmjLqgMGe-jJkxnpeS9w-1; Thu, 19 Nov 2020 06:43:35 -0500
X-MC-Unique: tBRmjLqgMGe-jJkxnpeS9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D6FCE745;
        Thu, 19 Nov 2020 11:43:33 +0000 (UTC)
Received: from gondolin (ovpn-113-214.ams2.redhat.com [10.36.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27CF81001B2C;
        Thu, 19 Nov 2020 11:43:28 +0000 (UTC)
Date:   Thu, 19 Nov 2020 12:43:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] vfio-ccw: Wire in the request callback
Message-ID: <20201119124326.0345a353.cohuck@redhat.com>
In-Reply-To: <20201117032139.50988-3-farman@linux.ibm.com>
References: <20201117032139.50988-1-farman@linux.ibm.com>
        <20201117032139.50988-3-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 04:21:39 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> The device is being unplugged, so pass the request to userspace to
> ask for a graceful cleanup. This should free up the thread that
> would otherwise loop waiting for the device to be fully released.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_ops.c     | 26 ++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_private.h |  4 ++++
>  include/uapi/linux/vfio.h           |  1 +
>  3 files changed, 31 insertions(+)
> 

(...)

> @@ -607,6 +611,27 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
>  	}
>  }
>  
> +/* Request removal of the device*/
> +static void vfio_ccw_mdev_request(struct mdev_device *mdev, unsigned int count)
> +{
> +	struct vfio_ccw_private *private = dev_get_drvdata(mdev_parent_dev(mdev));
> +
> +	if (!private)
> +		return;
> +
> +	if (private->req_trigger) {
> +		if (!(count % 10))
> +			dev_notice_ratelimited(mdev_dev(private->mdev),
> +					       "Relaying device request to user (#%u)\n",
> +					       count);
> +
> +		eventfd_signal(private->req_trigger, 1);
> +	} else if (count == 0) {
> +		dev_notice(mdev_dev(private->mdev),
> +			   "No device request channel registered, blocked until released by user\n");
> +	}
> +}

This looks like the vfio-pci request handler, so probably good :)

Still have to read up on the QEMU side, but a LGTM for now.

