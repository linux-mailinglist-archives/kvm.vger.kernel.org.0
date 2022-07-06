Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DD8568E13
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiGFPs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiGFPsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:48:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF39B33E2D
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657122056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j2ouW0IJ50/LD/W4uln9u2YiN3e6DrWUMY1mn0yrjIw=;
        b=VmJr/XVWaiNA0kkPGTxTT3dktPtLnK+qStj7Mr610uUFhnPz+bCgsFO4QnDMo3UVY7LxPy
        Glg+8TCEWp3LK5Qc8PuY9ChS5Vb2xQyJoNKbrKbX8NlT7ljSIVPhMnKnuRN9VFjY9ijhZj
        Mgt6JXiaj/tU8uTYFYAq2o4JQq5XLgo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-LvbS3N0tMzWa65cffbqnDA-1; Wed, 06 Jul 2022 11:40:53 -0400
X-MC-Unique: LvbS3N0tMzWa65cffbqnDA-1
Received: by mail-il1-f200.google.com with SMTP id j17-20020a056e02219100b002d955e89a54so7869373ila.11
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:40:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=j2ouW0IJ50/LD/W4uln9u2YiN3e6DrWUMY1mn0yrjIw=;
        b=uh+BmTuQIqbHAqIvGKrC0ul8FXmXJzqtWzbT5IpztXqJIgKCvwuL5nK30D6xQbB1VI
         JIpLPjbI099faXe4t+RAfPcX6eMBaUcuyopQqBPgz8KIIRy12hgcDktRcydq1EAGOqUI
         18NO5qhBcu9Of6XgpHu/YGeSRWwwKQWBC0+M0pWY01btN4I7X9XpXTvupTXHeM+9UNkE
         l9LQ0V4SGlkPEfUNA5LjoKTBXvhKIN0AwbL8aAnzPHvbStrXlMznftNghe1D2zMayWhH
         1fZ3rvW+mpYsVdSLjinjENwR/19aoW0JH/Rh4MFAVDvCvQARqFzAWKvafqnTk2EKKymJ
         B1gA==
X-Gm-Message-State: AJIora8TcxB+0gqAtnJ06lE1B5kXqeR8sN+/M/sDVuTmd9LG8UN+Z0q4
        m/+qYo8R0GNZRBduxnSMFrG3Gm/wHYTNJ2E5O6Pt0gR0GY7mfxLqpIgV0khj9pUdsfTidn1ZACd
        8/JXRE2GmUJTf
X-Received: by 2002:a05:6e02:12ea:b0:2da:bb5b:bcc5 with SMTP id l10-20020a056e0212ea00b002dabb5bbcc5mr23192249iln.173.1657122052909;
        Wed, 06 Jul 2022 08:40:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tcoOJLG0ui9DJlli5fa1i8aU2HEA0SyRv0Q4XlNsbA+kQEcNsL6A+fZcImvzWzfsQBUSpTjg==
X-Received: by 2002:a05:6e02:12ea:b0:2da:bb5b:bcc5 with SMTP id l10-20020a056e0212ea00b002dabb5bbcc5mr23192237iln.173.1657122052658;
        Wed, 06 Jul 2022 08:40:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d12-20020a0566022bec00b0066958ec56d9sm17003884ioy.40.2022.07.06.08.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:40:51 -0700 (PDT)
Date:   Wed, 6 Jul 2022 09:40:07 -0600
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
Subject: Re: [PATCH v4 3/6] vfio: Increment the runtime PM usage count
 during IOCTL call
Message-ID: <20220706094007.12c33d63.alex.williamson@redhat.com>
In-Reply-To: <20220701110814.7310-4-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-4-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Jul 2022 16:38:11 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> The vfio-pci based driver will have runtime power management
> support where the user can put the device into the low power state
> and then PCI devices can go into the D3cold state. If the device is
> in the low power state and the user issues any IOCTL, then the
> device should be moved out of the low power state first. Once
> the IOCTL is serviced, then it can go into the low power state again.
> The runtime PM framework manages this with help of usage count.
> 
> One option was to add the runtime PM related API's inside vfio-pci
> driver but some IOCTL (like VFIO_DEVICE_FEATURE) can follow a
> different path and more IOCTL can be added in the future. Also, the
> runtime PM will be added for vfio-pci based drivers variant currently,
> but the other VFIO based drivers can use the same in the
> future. So, this patch adds the runtime calls runtime-related API in
> the top-level IOCTL function itself.
>
> For the VFIO drivers which do not have runtime power management
> support currently, the runtime PM API's won't be invoked. Only for
> vfio-pci based drivers currently, the runtime PM API's will be invoked
> to increment and decrement the usage count.

Variant drivers can easily opt-out of runtime pm support by performing
a gratuitous pm-get in their device-open function.
 
> Taking this usage count incremented while servicing IOCTL will make
> sure that the user won't put the device into low power state when any
> other IOCTL is being serviced in parallel. Let's consider the
> following scenario:
> 
>  1. Some other IOCTL is called.
>  2. The user has opened another device instance and called the power
>     management IOCTL for the low power entry.
>  3. The power management IOCTL moves the device into the low power state.
>  4. The other IOCTL finishes.
> 
> If we don't keep the usage count incremented then the device
> access will happen between step 3 and 4 while the device has already
> gone into the low power state.
> 
> The runtime PM API's should not be invoked for
> VFIO_DEVICE_FEATURE_POWER_MANAGEMENT since this IOCTL itself performs
> the runtime power management entry and exit for the VFIO device.

I think the one-shot interface I proposed in the previous patch avoids
the need for special handling for these feature ioctls.  Thanks,

Alex
 
> The pm_runtime_resume_and_get() will be the first call so its error
> should not be propagated to user space directly. For example, if
> pm_runtime_resume_and_get() can return -EINVAL for the cases where the
> user has passed the correct argument. So the
> pm_runtime_resume_and_get() errors have been masked behind -EIO.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 82 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 74 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..61a8d9f7629a 100644
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
> @@ -1333,6 +1334,39 @@ static const struct file_operations vfio_group_fops = {
>  	.release	= vfio_group_fops_release,
>  };
>  
> +/*
> + * Wrapper around pm_runtime_resume_and_get().
> + * Return error code on failure or 0 on success.
> + */
> +static inline int vfio_device_pm_runtime_get(struct vfio_device *device)
> +{
> +	struct device *dev = device->dev;
> +
> +	if (dev->driver && dev->driver->pm) {
> +		int ret;
> +
> +		ret = pm_runtime_resume_and_get(dev);
> +		if (ret < 0) {
> +			dev_info_ratelimited(dev,
> +				"vfio: runtime resume failed %d\n", ret);
> +			return -EIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Wrapper around pm_runtime_put().
> + */
> +static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
> +{
> +	struct device *dev = device->dev;
> +
> +	if (dev->driver && dev->driver->pm)
> +		pm_runtime_put(dev);
> +}
> +
>  /*
>   * VFIO Device fd
>   */
> @@ -1607,6 +1641,8 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  {
>  	size_t minsz = offsetofend(struct vfio_device_feature, flags);
>  	struct vfio_device_feature feature;
> +	int ret = 0;
> +	u16 feature_cmd;
>  
>  	if (copy_from_user(&feature, arg, minsz))
>  		return -EFAULT;
> @@ -1626,28 +1662,51 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  	    (feature.flags & VFIO_DEVICE_FEATURE_GET))
>  		return -EINVAL;
>  
> -	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
> +	feature_cmd = feature.flags & VFIO_DEVICE_FEATURE_MASK;
> +
> +	/*
> +	 * The VFIO_DEVICE_FEATURE_POWER_MANAGEMENT itself performs the runtime
> +	 * power management entry and exit for the VFIO device, so the runtime
> +	 * PM API's should not be called for this feature.
> +	 */
> +	if (feature_cmd != VFIO_DEVICE_FEATURE_POWER_MANAGEMENT) {
> +		ret = vfio_device_pm_runtime_get(device);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	switch (feature_cmd) {
>  	case VFIO_DEVICE_FEATURE_MIGRATION:
> -		return vfio_ioctl_device_feature_migration(
> +		ret = vfio_ioctl_device_feature_migration(
>  			device, feature.flags, arg->data,
>  			feature.argsz - minsz);
> +		break;
>  	case VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE:
> -		return vfio_ioctl_device_feature_mig_device_state(
> +		ret = vfio_ioctl_device_feature_mig_device_state(
>  			device, feature.flags, arg->data,
>  			feature.argsz - minsz);
> +		break;
>  	default:
>  		if (unlikely(!device->ops->device_feature))
> -			return -EINVAL;
> -		return device->ops->device_feature(device, feature.flags,
> -						   arg->data,
> -						   feature.argsz - minsz);
> +			ret = -EINVAL;
> +		else
> +			ret = device->ops->device_feature(
> +				device, feature.flags, arg->data,
> +				feature.argsz - minsz);
> +		break;
>  	}
> +
> +	if (feature_cmd != VFIO_DEVICE_FEATURE_POWER_MANAGEMENT)
> +		vfio_device_pm_runtime_put(device);
> +
> +	return ret;
>  }
>  
>  static long vfio_device_fops_unl_ioctl(struct file *filep,
>  				       unsigned int cmd, unsigned long arg)
>  {
>  	struct vfio_device *device = filep->private_data;
> +	int ret;
>  
>  	switch (cmd) {
>  	case VFIO_DEVICE_FEATURE:
> @@ -1655,7 +1714,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	default:
>  		if (unlikely(!device->ops->ioctl))
>  			return -EINVAL;
> -		return device->ops->ioctl(device, cmd, arg);
> +
> +		ret = vfio_device_pm_runtime_get(device);
> +		if (ret)
> +			return ret;
> +
> +		ret = device->ops->ioctl(device, cmd, arg);
> +		vfio_device_pm_runtime_put(device);
> +		return ret;
>  	}
>  }
>  

