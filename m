Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7526851AE38
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377633AbiEDTqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377596AbiEDTqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:46:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09CA04D9EE
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651693381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YraIWaagOO06xPNgZtGKgCndWhzj8vDJW92q5HYE0L4=;
        b=fKVAPckK0QFLl5rXpUg8Jwe+m9jch/CiGH6KJ4LaPNleIG6l0ffIBIhopVYxawXHY/h46T
        FFfxSY3sqN1CHCs/mTxKgFXPaQv62X5ZmvTynqGlHHEE8rIAvgh0x2MuLXWDBtoIhVImcb
        UZEvY2Z7ARhhWqU7F1uu78reXgdvtmU=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-bp3sKvpNPYCrlUmNTx2wJw-1; Wed, 04 May 2022 15:43:00 -0400
X-MC-Unique: bp3sKvpNPYCrlUmNTx2wJw-1
Received: by mail-il1-f200.google.com with SMTP id w14-20020a056e021c8e00b002cf20eefac2so1231664ill.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 12:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YraIWaagOO06xPNgZtGKgCndWhzj8vDJW92q5HYE0L4=;
        b=asgNR5sBjCaYe+mKiHMiem5RF6VVhFvkkhjjGPaT8qjo7rYuGHUF4O1Q/kA+FudaWl
         gSpbqPjuU1oGRRJ1pXBwpVmivKMcVciA8BYGLP2jrecC5iiLhJULxRCEk2ZH0jnXIuUK
         ONyy6hwNKygZ69joiXvMdrd3CkseHQQAspwm0OZUKzfFJ0BjEpT+QsxEQarPaW6WCEt9
         5HxAq0EVBoOxRGqv5YbAB04GUm8ogj4hTSolb7NyyTYfwKe+9jwRuArMznPvkkSs+vSb
         gyMlSwDk952xZYp0dj0mO06E1tK2NYjmnPlmKDzLMiD/LuLPRc82mbtmqf3zPjTOI5cV
         n+tg==
X-Gm-Message-State: AOAM532Aho+jgUudhB9BLfUvTdNjVmgWk77Zg/Sso5sDbB7JANJ8cRNZ
        oNJnVL+CsNRUBfu0b9I6IuqzBc0+wVzR/HBkKPYIhLJdap5j3p7T29mjCYyq+JS3ZD5XOz9zDuF
        nOfbbSIslSgH7
X-Received: by 2002:a05:6638:1487:b0:328:6e36:39e4 with SMTP id j7-20020a056638148700b003286e3639e4mr9226523jak.202.1651693379404;
        Wed, 04 May 2022 12:42:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5f9immlHyzBqIUrpHpAD3biNv0bRhBLYdXjGCMKhkLU56cjYHUnrvS4jjbi+c9bbHM7txdA==
X-Received: by 2002:a05:6638:1487:b0:328:6e36:39e4 with SMTP id j7-20020a056638148700b003286e3639e4mr9226506jak.202.1651693379138;
        Wed, 04 May 2022 12:42:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t17-20020a6b0911000000b0065a47e16f61sm3960876ioi.51.2022.05.04.12.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 12:42:58 -0700 (PDT)
Date:   Wed, 4 May 2022 13:42:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 6/8] vfio: Invoke runtime PM API for IOCTL request
Message-ID: <20220504134257.1ecb245b.alex.williamson@redhat.com>
In-Reply-To: <20220425092615.10133-7-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
        <20220425092615.10133-7-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Apr 2022 14:56:13 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> The vfio/pci driver will have runtime power management support where the
> user can put the device low power state and then PCI devices can go into
> the D3cold state. If the device is in low power state and user issues any
> IOCTL, then the device should be moved out of low power state first. Once
> the IOCTL is serviced, then it can go into low power state again. The
> runtime PM framework manages this with help of usage count. One option
> was to add the runtime PM related API's inside vfio/pci driver but some
> IOCTL (like VFIO_DEVICE_FEATURE) can follow a different path and more
> IOCTL can be added in the future. Also, the runtime PM will be
> added for vfio/pci based drivers variant currently but the other vfio
> based drivers can use the same in the future. So, this patch adds the
> runtime calls runtime related API in the top level IOCTL function itself.
> 
> For the vfio drivers which do not have runtime power management support
> currently, the runtime PM API's won't be invoked. Only for vfio/pci
> based drivers currently, the runtime PM API's will be invoked to increment
> and decrement the usage count. Taking this usage count incremented while
> servicing IOCTL will make sure that user won't put the device into low
> power state when any other IOCTL is being serviced in parallel.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 44 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a4555014bd1e..4e65a127744e 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -32,6 +32,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/sched/signal.h>
> +#include <linux/pm_runtime.h>
>  #include "vfio.h"
>  
>  #define DRIVER_VERSION	"0.3"
> @@ -1536,6 +1537,30 @@ static const struct file_operations vfio_group_fops = {
>  	.release	= vfio_group_fops_release,
>  };
>  
> +/*
> + * Wrapper around pm_runtime_resume_and_get().
> + * Return 0, if driver power management callbacks are not present i.e. the driver is not

Mind the gratuitous long comment line here.

> + * using runtime power management.
> + * Return 1 upon success, otherwise -errno

Changing semantics vs the thing we're wrapping, why not provide a
wrapper for the `put` as well to avoid?  The only cases where we return
zero are just as easy to detect on the other side.

> + */
> +static inline int vfio_device_pm_runtime_get(struct device *dev)

Given some of Jason's recent series, this should probably just accept a
vfio_device.

> +{
> +#ifdef CONFIG_PM
> +	int ret;
> +
> +	if (!dev->driver || !dev->driver->pm)
> +		return 0;
> +
> +	ret = pm_runtime_resume_and_get(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 1;
> +#else
> +	return 0;
> +#endif
> +}
> +
>  /*
>   * VFIO Device fd
>   */
> @@ -1845,15 +1870,28 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  				       unsigned int cmd, unsigned long arg)
>  {
>  	struct vfio_device *device = filep->private_data;
> +	int pm_ret, ret = 0;
> +
> +	pm_ret = vfio_device_pm_runtime_get(device->dev);
> +	if (pm_ret < 0)
> +		return pm_ret;

I wonder if we might simply want to mask pm errors behind -EIO, maybe
with a rate limited dev_info().  My concern would be that we might mask
errnos that userspace has come to expect for certain ioctls.  Thanks,

Alex

>  
>  	switch (cmd) {
>  	case VFIO_DEVICE_FEATURE:
> -		return vfio_ioctl_device_feature(device, (void __user *)arg);
> +		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
> +		break;
>  	default:
>  		if (unlikely(!device->ops->ioctl))
> -			return -EINVAL;
> -		return device->ops->ioctl(device, cmd, arg);
> +			ret = -EINVAL;
> +		else
> +			ret = device->ops->ioctl(device, cmd, arg);
> +		break;
>  	}
> +
> +	if (pm_ret)
> +		pm_runtime_put(device->dev);
> +
> +	return ret;
>  }
>  
>  static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,

