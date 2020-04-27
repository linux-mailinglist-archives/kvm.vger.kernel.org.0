Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBC21BA951
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 17:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgD0Pwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 11:52:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726185AbgD0Pwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 11:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588002751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X1xeQ1SUIXCtGDyhahhQll4pogM0arWGY7IUpcCnr/I=;
        b=Dgh58FZYpmpe5xPcpR7V5O2wtb1n2adaiad2bkUXU2ORTh1fQXJ7IYYIKGzor8epiZVbVC
        pUSb874dPYz9k6Ie/T++HNK2LkaR6mTUvz523wrKGpcDMuDVbRCnx+bQqghASIP5f/mais
        3CZb9ISJYJ7mkGkZEvL0V43v2aV/7EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-igYlppHxMSi3xCnoAyftBg-1; Mon, 27 Apr 2020 11:52:29 -0400
X-MC-Unique: igYlppHxMSi3xCnoAyftBg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55657464;
        Mon, 27 Apr 2020 15:52:28 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0859B5D9DA;
        Mon, 27 Apr 2020 15:52:27 +0000 (UTC)
Date:   Mon, 27 Apr 2020 09:52:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yingtai Xie <xieyingtai@huawei.com>
Cc:     <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <wu.wubin@huawei.com>
Subject: Re: [PATCH] vfio/mdev: Add vfio-mdev device request interface
Message-ID: <20200427095226.02f07a53@w520.home>
In-Reply-To: <20200426063542.16548-1-xieyingtai@huawei.com>
References: <20200426063542.16548-1-xieyingtai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 Apr 2020 14:35:42 +0800
Yingtai Xie <xieyingtai@huawei.com> wrote:

> This is setup the same way as vfio-pci to indicate
> userspace that the device should be released.


Is there an in-kernel user?


> Signed-off-by: Yingtai Xie <xieyingtai@huawei.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c | 10 ++++++++++
>  include/linux/mdev.h          |  4 ++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index 30964a4e0..74695c116 100644
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
> +	if (likely(!parent->ops->request))
> +		parent->ops->request(mdev, count);
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
> index 0ce30ca78..1ab0b0b9b 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
>   * @mmap:		mmap callback
>   *			@mdev: mediated device structure
>   *			@vma: vma structure
> + * @request	request callback
> + *			@mdev: mediated device structure
> + *			@count: counter to allow driver to release the device
>   * Parent device that support mediated device should be registered with mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -92,6 +95,7 @@ struct mdev_parent_ops {
>  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>  			 unsigned long arg);
>  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +	int	(*request)(struct mdev_device *mdev, unsigned int count);
>  };
>  
>  /* interface for exporting mdev supported type attributes */

