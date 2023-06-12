Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C6D72D49C
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 00:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbjFLWn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 18:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjFLWn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 18:43:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30B4171F
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686609752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F75ik3Gqkzq0N+7Vu1ovwO7gqAH3ydx4ZbmNUzc5hkM=;
        b=V9iIHf+a6404Uu9ZkjONngXJT1Fed68So9TW7qpwToRLtts+I7LTRQEsw8e31Y2+LbU/fd
        Mk1SMWSrYbiiT81A4o/QK72E3kk6We8r44YdWAT7ZAVI363CaHCQ1wo8ZqqlQBMI55Aelw
        DbYzV/CDtCg2A8K80TqpC4Weg8faYjA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-UE1qvDRDOROiADtCCe0LEg-1; Mon, 12 Jun 2023 18:42:30 -0400
X-MC-Unique: UE1qvDRDOROiADtCCe0LEg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77ac14e9bc5so589174139f.2
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686609750; x=1689201750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F75ik3Gqkzq0N+7Vu1ovwO7gqAH3ydx4ZbmNUzc5hkM=;
        b=TV9TZt+7PHvfRhiHBun8puwMux74juTuBSM4Qj2P7ICY0A0glJZ0EeosdEEyo07wgF
         oXAMFBewWSFXi7kQMqjCOLqeq++6MdWI6tArG0HuQYxh26BnQ4qbngYoe3o/+FfXShBS
         tQiw5wJ2gps4pq9AoKiB6HFc4vcGFUQhwEACzCXoaqo8fIDqjOEEus+GyKVre5cZ/Wfm
         td0JgXr1QGfEBJsxJdHwim2QDg8xm6HFxo5RtMXHHb6/hv29BIbuyohFT/bBQ8pI9/B6
         oWPG3u8i8oRKq2r6IEoBVOY8v9VFyEZ9wdNOUOn9MOgARSmNanlQ1JQI3xI9ge1W9Ujq
         aq/A==
X-Gm-Message-State: AC+VfDyv8/3Q3OkTFhCSQJ8l0gZ0M5heHwNatsAXvE/xTQtHgCsagc1f
        GZrD0cYwv9AlZGGk6kjcsz8DVvQNBEvRLcEvjeJt3ngn8v5d/utKjnT/5H48GhaIEvaQyQTmjau
        M6KI1L+mHv6bP
X-Received: by 2002:a6b:7b45:0:b0:77a:ec0c:5907 with SMTP id m5-20020a6b7b45000000b0077aec0c5907mr7030174iop.13.1686609750031;
        Mon, 12 Jun 2023 15:42:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ659aPve/JGIQqnJc4um0EzETnEkwaU4sAoCUXmtup2XV1i32AN8041DFRUd8E22BOJmpf8JA==
X-Received: by 2002:a6b:7b45:0:b0:77a:ec0c:5907 with SMTP id m5-20020a6b7b45000000b0077aec0c5907mr7030155iop.13.1686609749769;
        Mon, 12 Jun 2023 15:42:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h19-20020a02c4d3000000b0041f52ea3514sm2963153jaj.158.2023.06.12.15.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 15:42:29 -0700 (PDT)
Date:   Mon, 12 Jun 2023 16:42:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Message-ID: <20230612164228.65b500e0.alex.williamson@redhat.com>
In-Reply-To: <20230602121653.80017-22-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Jun 2023 05:16:50 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This moves the noiommu device determination and noiommu taint out of
> vfio_group_find_or_alloc(). noiommu device is determined in
> __vfio_register_dev() and result is stored in flag vfio_device->noiommu,
> the noiommu taint is added in the end of __vfio_register_dev().
> 
> This is also a preparation for compiling out vfio_group infrastructure
> as it makes the noiommu detection and taint common between the cdev path
> and group path though cdev path does not support noiommu.

Does this really still make sense?  The motivation for the change is
really not clear without cdev support for noiommu.  Thanks,

Alex
 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 15 ---------------
>  drivers/vfio/vfio_main.c | 31 ++++++++++++++++++++++++++++++-
>  include/linux/vfio.h     |  1 +
>  3 files changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 653b62f93474..64cdd0ea8825 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -668,21 +668,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  	struct vfio_group *group;
>  
>  	iommu_group = iommu_group_get(dev);
> -	if (!iommu_group && vfio_noiommu) {
> -		/*
> -		 * With noiommu enabled, create an IOMMU group for devices that
> -		 * don't already have one, implying no IOMMU hardware/driver
> -		 * exists.  Taint the kernel because we're about to give a DMA
> -		 * capable device to a user without IOMMU protection.
> -		 */
> -		group = vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
> -		if (!IS_ERR(group)) {
> -			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> -			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
> -		}
> -		return group;
> -	}
> -
>  	if (!iommu_group)
>  		return ERR_PTR(-EINVAL);
>  
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 6d8f9b0f3637..00a699b9f76b 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -265,6 +265,18 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
>  	return ret;
>  }
>  
> +static int vfio_device_set_noiommu(struct vfio_device *device)
> +{
> +	struct iommu_group *iommu_group = iommu_group_get(device->dev);
> +
> +	if (!iommu_group && !vfio_noiommu)
> +		return -EINVAL;
> +
> +	device->noiommu = !iommu_group;
> +	iommu_group_put(iommu_group); /* Accepts NULL */
> +	return 0;
> +}
> +
>  static int __vfio_register_dev(struct vfio_device *device,
>  			       enum vfio_group_type type)
>  {
> @@ -277,6 +289,13 @@ static int __vfio_register_dev(struct vfio_device *device,
>  		     !device->ops->detach_ioas)))
>  		return -EINVAL;
>  
> +	/* Only physical devices can be noiommu device */
> +	if (type == VFIO_IOMMU) {
> +		ret = vfio_device_set_noiommu(device);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/*
>  	 * If the driver doesn't specify a set then the device is added to a
>  	 * singleton set just for itself.
> @@ -288,7 +307,8 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (ret)
>  		return ret;
>  
> -	ret = vfio_device_set_group(device, type);
> +	ret = vfio_device_set_group(device,
> +				    device->noiommu ? VFIO_NO_IOMMU : type);
>  	if (ret)
>  		return ret;
>  
> @@ -301,6 +321,15 @@ static int __vfio_register_dev(struct vfio_device *device,
>  
>  	vfio_device_group_register(device);
>  
> +	if (device->noiommu) {
> +		/*
> +		 * noiommu deivces have no IOMMU hardware/driver.  Taint the
> +		 * kernel because we're about to give a DMA capable device to
> +		 * a user without IOMMU protection.
> +		 */
> +		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +		dev_warn(device->dev, "Adding kernel taint for vfio-noiommu on device\n");
> +	}
>  	return 0;
>  err_out:
>  	vfio_device_remove_group(device);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e80a8ac86e46..183e620009e7 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -67,6 +67,7 @@ struct vfio_device {
>  	bool iommufd_attached;
>  #endif
>  	bool cdev_opened:1;
> +	bool noiommu:1;
>  };
>  
>  /**

