Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6605207A7
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 00:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiEIWeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 18:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiEIWeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 18:34:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EDC827E3EE
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 15:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652135406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZA6VNXAM5i4PcwO3aAoa6h2tMmE/5TqVCC2BscCJgw=;
        b=igAGOjWq7e/eZKmQi1k9/H/cZu96i52zK2bAdWDbWwO8K3k8/qua7B3vQxoiovYTWm+LfF
        bCyaOowzZ+6NZVCwl7YvDGwcRQkiXD3oj+Sh8TYeM+yILl7wb9xaQd12SYKdH1xanPk90v
        mVmdFxKWau8tRoioPwScpvg1kcyPb4Y=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-a5SJMn9JNN-xRVSSgQXN2A-1; Mon, 09 May 2022 18:30:05 -0400
X-MC-Unique: a5SJMn9JNN-xRVSSgQXN2A-1
Received: by mail-il1-f197.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so8392863ilu.14
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 15:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZA6VNXAM5i4PcwO3aAoa6h2tMmE/5TqVCC2BscCJgw=;
        b=uPwG+zsf3mhPjnM1hJnLxyDmga/BBTErd1axao/bvuwwgJjWzPd+enL445i3wh2er5
         Y1fn3EnOpXx0tCFHxBpdb2ASNqRJLrQkR3k1rTo1kI/zZpF0PaX6+9bqaC0/BbJeLjUV
         T3RYI/0miGQo5++/Hf6QqVHoka/y3WvD4TA0MM7OCbg3tYUJjNRTbGw/1sT3kQBrfnFu
         QB0pPHiaHu9qDnxDAZCrQse6xjNsTBcDsZqxsnM3mSaWJf54qOAAWovR9/xzJS2M5aE7
         pHWy6iPAnEiPtZYm6xMU8u3+HMfSr1M5i46/7YlHXesTdJNGJbRWb01xwWlzBR9uWyq+
         MaLQ==
X-Gm-Message-State: AOAM5325zX3+KxCq7MIJcpB7yXmq1BJdQabx5ZBOjdrcXCA4v7Ayo8CL
        l9SZxIvc4A6SyC/uuMn4EESFIdxvps3gtbSNCWVE1aHTRfiF26aR8+v1L0k36fqzumeI/M0JT+X
        4cA/h7l7ivQiA
X-Received: by 2002:a05:6e02:1585:b0:2c2:5b2c:e3e5 with SMTP id m5-20020a056e02158500b002c25b2ce3e5mr8000882ilu.76.1652135404644;
        Mon, 09 May 2022 15:30:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/xDm0oeizzFs9OsjgHv5iN7DYQPBrPufu9Ukf8kxzdUFWsryqO/OP8BvcOcM21ir0kbx5eg==
X-Received: by 2002:a05:6e02:1585:b0:2c2:5b2c:e3e5 with SMTP id m5-20020a056e02158500b002c25b2ce3e5mr8000867ilu.76.1652135404331;
        Mon, 09 May 2022 15:30:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q6-20020a056e02096600b002cde6e352ccsm3489431ilt.22.2022.05.09.15.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:30:04 -0700 (PDT)
Date:   Mon, 9 May 2022 16:30:02 -0600
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 6/8] vfio: Invoke runtime PM API for IOCTL request
Message-ID: <20220509163002.57fe44fa.alex.williamson@redhat.com>
In-Reply-To: <0ba3d469-58af-64d3-514c-6d33c483f8fb@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
        <20220425092615.10133-7-abhsahu@nvidia.com>
        <20220504134257.1ecb245b.alex.williamson@redhat.com>
        <0ba3d469-58af-64d3-514c-6d33c483f8fb@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
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

On Thu, 5 May 2022 15:10:43 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 5/5/2022 1:12 AM, Alex Williamson wrote:
> > On Mon, 25 Apr 2022 14:56:13 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >   
> >> The vfio/pci driver will have runtime power management support where the
> >> user can put the device low power state and then PCI devices can go into
> >> the D3cold state. If the device is in low power state and user issues any
> >> IOCTL, then the device should be moved out of low power state first. Once
> >> the IOCTL is serviced, then it can go into low power state again. The
> >> runtime PM framework manages this with help of usage count. One option
> >> was to add the runtime PM related API's inside vfio/pci driver but some
> >> IOCTL (like VFIO_DEVICE_FEATURE) can follow a different path and more
> >> IOCTL can be added in the future. Also, the runtime PM will be
> >> added for vfio/pci based drivers variant currently but the other vfio
> >> based drivers can use the same in the future. So, this patch adds the
> >> runtime calls runtime related API in the top level IOCTL function itself.
> >>
> >> For the vfio drivers which do not have runtime power management support
> >> currently, the runtime PM API's won't be invoked. Only for vfio/pci
> >> based drivers currently, the runtime PM API's will be invoked to increment
> >> and decrement the usage count. Taking this usage count incremented while
> >> servicing IOCTL will make sure that user won't put the device into low
> >> power state when any other IOCTL is being serviced in parallel.
> >>
> >> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >> ---
> >>  drivers/vfio/vfio.c | 44 +++++++++++++++++++++++++++++++++++++++++---
> >>  1 file changed, 41 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >> index a4555014bd1e..4e65a127744e 100644
> >> --- a/drivers/vfio/vfio.c
> >> +++ b/drivers/vfio/vfio.c
> >> @@ -32,6 +32,7 @@
> >>  #include <linux/vfio.h>
> >>  #include <linux/wait.h>
> >>  #include <linux/sched/signal.h>
> >> +#include <linux/pm_runtime.h>
> >>  #include "vfio.h"
> >>  
> >>  #define DRIVER_VERSION	"0.3"
> >> @@ -1536,6 +1537,30 @@ static const struct file_operations vfio_group_fops = {
> >>  	.release	= vfio_group_fops_release,
> >>  };
> >>  
> >> +/*
> >> + * Wrapper around pm_runtime_resume_and_get().
> >> + * Return 0, if driver power management callbacks are not present i.e. the driver is not  
> > 
> > Mind the gratuitous long comment line here.
> >   
>  
>  Thanks Alex.
>  
>  That was a miss. I will fix this.
>  
> >> + * using runtime power management.
> >> + * Return 1 upon success, otherwise -errno  
> > 
> > Changing semantics vs the thing we're wrapping, why not provide a
> > wrapper for the `put` as well to avoid?  The only cases where we return
> > zero are just as easy to detect on the other side.
> >   
> 
>  Yes. Using wrapper function for put is better option.
>  I will make the changes.
> 
> >> + */
> >> +static inline int vfio_device_pm_runtime_get(struct device *dev)  
> > 
> > Given some of Jason's recent series, this should probably just accept a
> > vfio_device.
> >   
> 
>  Sorry. I didn't get this part.
> 
>  Do I need to change it to
> 
>  static inline int vfio_device_pm_runtime_get(struct vfio_device *device)
>  {
>     struct device *dev = device->dev;
>     ...
>  }

Yes.

> >> +{
> >> +#ifdef CONFIG_PM
> >> +	int ret;
> >> +
> >> +	if (!dev->driver || !dev->driver->pm)
> >> +		return 0;

I'm also wondering how we could ever get here with dev->driver == NULL.
If that were actually possible, the above would at best be racy.  It
also really seems like there ought to be a better test than the
driver->pm pointer to check if runtime pm is enabled, but I haven't
spotted it yet.

> >> +
> >> +	ret = pm_runtime_resume_and_get(dev);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	return 1;
> >> +#else
> >> +	return 0;
> >> +#endif
> >> +}
> >> +
> >>  /*
> >>   * VFIO Device fd
> >>   */
> >> @@ -1845,15 +1870,28 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> >>  				       unsigned int cmd, unsigned long arg)
> >>  {
> >>  	struct vfio_device *device = filep->private_data;
> >> +	int pm_ret, ret = 0;
> >> +
> >> +	pm_ret = vfio_device_pm_runtime_get(device->dev);
> >> +	if (pm_ret < 0)
> >> +		return pm_ret;  
> > 
> > I wonder if we might simply want to mask pm errors behind -EIO, maybe
> > with a rate limited dev_info().  My concern would be that we might mask
> > errnos that userspace has come to expect for certain ioctls.  Thanks,
> > 
> > Alex
> >   
> 
>   I need to do something like following. Correct ?
> 
>   ret = vfio_device_pm_runtime_get(device);
>   if (ret < 0) {
>      dev_info_ratelimited(device->dev, "vfio: runtime resume failed %d\n", ret);
>      return -EIO;
>   }

Yeah, though I'd welcome other thoughts here.  I don't necessarily like
the idea of squashing the errno, but at the same time, if
pm_runtime_resume_and_get() returns -EINVAL on user ioctl, that's not
really describing an invalid parameter relative to the ioctl itself.
Thanks,

Alex

