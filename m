Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3FB6D972B
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbjDFMoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 08:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237971AbjDFMoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 08:44:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1975A7DBF
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 05:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680785009;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVBvata7Mm/MkYzuOlGNnL4nXILAvoWW7w+2UKjzgAI=;
        b=W33ovEv/nySsGDF5oqRarzNFYALIo9dw1hl1nuxIek/MdWBnbnWeclZkpLPxUzIyMudk3d
        yfvkzqabrNtXB43fWHI04iVLKXXXMSIitz6GpfnXeTASV3SoAYcIVw1K2kcKI3i4JbmZNe
        ZVFZs+/y3+jx4/R8MAMg3+emIt2rGBg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-6byxkbHEPmCcw5QHjWY3Iw-1; Thu, 06 Apr 2023 08:43:28 -0400
X-MC-Unique: 6byxkbHEPmCcw5QHjWY3Iw-1
Received: by mail-qv1-f70.google.com with SMTP id y19-20020ad445b3000000b005a5123cb627so17789675qvu.20
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 05:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680785007;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zVBvata7Mm/MkYzuOlGNnL4nXILAvoWW7w+2UKjzgAI=;
        b=WXpq1XVVXwAYYjMLEUyn3POe8T4X1xn5J9B+jNvpIZhEuVaaDGuhQHfMRmznu3puik
         uy1E3r8MGb/2oFnzdpApVKUkM6vo+YRzUmy9tAfSrsRIic7lZ+AXEsFTrbura2nW2JON
         toiNqDkVFJ0Ra3CDH/+MwyBRtK6xH4xGdc/njkginjwaHnJRFh/RGiulYuuu7GTYHhL0
         /oOnRDxkS+EQMOLClaA387gJkdkeMmmYBQVyifpiuOlcCyLqmIAzlJf7wLQ6BcqruMZS
         kP63fNNJDQco8ft9d40bM6Y2xsivqQn3nYQ5gkvU3uSX7dmKWIFe+bX/K96oNQrbeb34
         MdFg==
X-Gm-Message-State: AAQBX9dccFyIoItKKizeKD4YVJnY1uGbRHuxYvC+1ZrOTQtCOb8+A0Ov
        AqN5QEtO4hxZ4cWbDPsVMe18P5uuhFEJlwQ1p8DlDSrbLCLPQzlq8Pe75NSPENh2R3Bjsjs3Ff+
        S5lujWjH00WhW
X-Received: by 2002:ad4:5bc8:0:b0:5e0:47aa:40a6 with SMTP id t8-20020ad45bc8000000b005e047aa40a6mr4199251qvt.16.1680785007432;
        Thu, 06 Apr 2023 05:43:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZZZBqkuCClmoQgew7Ga8w32aTpkf+0gTr7Gw2GardEq9kUBzOQNp2reLEna5OkSDHXP104GA==
X-Received: by 2002:ad4:5bc8:0:b0:5e0:47aa:40a6 with SMTP id t8-20020ad45bc8000000b005e047aa40a6mr4199207qvt.16.1680785007046;
        Thu, 06 Apr 2023 05:43:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j5-20020a056214022500b005dd8b93459esm488119qvt.54.2023.04.06.05.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 05:43:25 -0700 (PDT)
Message-ID: <1520dad3-6858-28c4-08d0-503905a9933e@redhat.com>
Date:   Thu, 6 Apr 2023 14:43:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 07/25] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-8-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401151833.124749-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/1/23 17:18, Yi Liu wrote:
> This avoids passing too much parameters in multiple functions.
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 20 ++++++++++++++------
>  drivers/vfio/vfio.h      |  8 ++++----
>  drivers/vfio/vfio_main.c | 25 +++++++++++++++----------
>  3 files changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 4f937ebaf6f7..9a7b2765eef6 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -169,8 +169,9 @@ static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
>  	spin_unlock(&device->group->kvm_ref_lock);
>  }
>  
> -static int vfio_device_group_open(struct vfio_device *device)
> +static int vfio_device_group_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
>  	int ret;
>  
>  	mutex_lock(&device->group->group_lock);
> @@ -190,7 +191,11 @@ static int vfio_device_group_open(struct vfio_device *device)
>  	if (device->open_count == 0)
>  		vfio_device_group_get_kvm_safe(device);
>  
> -	ret = vfio_device_open(device, device->group->iommufd);
> +	df->iommufd = device->group->iommufd;
> +
> +	ret = vfio_device_open(df);
> +	if (ret)
> +		df->iommufd = NULL;
>  
>  	if (device->open_count == 0)
>  		vfio_device_put_kvm(device);
> @@ -202,12 +207,15 @@ static int vfio_device_group_open(struct vfio_device *device)
>  	return ret;
>  }
>  
> -void vfio_device_group_close(struct vfio_device *device)
> +void vfio_device_group_close(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +
>  	mutex_lock(&device->group->group_lock);
>  	mutex_lock(&device->dev_set->lock);
>  
> -	vfio_device_close(device, device->group->iommufd);
> +	vfio_device_close(df);
> +	df->iommufd = NULL; 
>  	if (device->open_count == 0)
>  		vfio_device_put_kvm(device);
> @@ -228,7 +236,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  		goto err_out;
>  	}
>  
> -	ret = vfio_device_group_open(device);
> +	ret = vfio_device_group_open(df);
>  	if (ret)
>  		goto err_free;
>  
> @@ -260,7 +268,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  	return filep;
>  
>  err_close_device:
> -	vfio_device_group_close(device);
> +	vfio_device_group_close(df);
>  err_free:
>  	kfree(df);
>  err_out:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index e4672d91a6f7..cffc08f5a6f1 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -20,13 +20,13 @@ struct vfio_device_file {
>  	struct vfio_device *device;
>  	spinlock_t kvm_ref_lock; /* protect kvm field */
>  	struct kvm *kvm;
> +	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
>  };
>  
>  void vfio_device_put_registration(struct vfio_device *device);
>  bool vfio_device_try_get_registration(struct vfio_device *device);
> -int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd);
> -void vfio_device_close(struct vfio_device *device,
> -		       struct iommufd_ctx *iommufd);
> +int vfio_device_open(struct vfio_device_file *df);
> +void vfio_device_close(struct vfio_device_file *df);
>  struct vfio_device_file *
>  vfio_allocate_device_file(struct vfio_device *device);
>  
> @@ -91,7 +91,7 @@ void vfio_device_group_register(struct vfio_device *device);
>  void vfio_device_group_unregister(struct vfio_device *device);
>  int vfio_device_group_use_iommu(struct vfio_device *device);
>  void vfio_device_group_unuse_iommu(struct vfio_device *device);
> -void vfio_device_group_close(struct vfio_device *device);
> +void vfio_device_group_close(struct vfio_device_file *df);
>  struct vfio_group *vfio_group_from_file(struct file *file);
>  bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
>  bool vfio_group_enforced_coherent(struct vfio_group *group);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index cb543791b28b..2ea6cb6d03c7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -419,9 +419,10 @@ vfio_allocate_device_file(struct vfio_device *device)
>  	return df;
>  }
>  
> -static int vfio_device_first_open(struct vfio_device *device,
> -				  struct iommufd_ctx *iommufd)
> +static int vfio_device_first_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +	struct iommufd_ctx *iommufd = df->iommufd;
>  	int ret;
>  
>  	lockdep_assert_held(&device->dev_set->lock);
> @@ -453,9 +454,11 @@ static int vfio_device_first_open(struct vfio_device *device,
>  	return ret;
>  }
>  
> -static void vfio_device_last_close(struct vfio_device *device,
> -				   struct iommufd_ctx *iommufd)
> +static void vfio_device_last_close(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +	struct iommufd_ctx *iommufd = df->iommufd;
> +
>  	lockdep_assert_held(&device->dev_set->lock);
>  
>  	if (device->ops->close_device)
> @@ -467,15 +470,16 @@ static void vfio_device_last_close(struct vfio_device *device,
>  	module_put(device->dev->driver->owner);
>  }
>  
> -int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
> +int vfio_device_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
>  	int ret = 0;
>  
>  	lockdep_assert_held(&device->dev_set->lock);
>  
>  	device->open_count++;
>  	if (device->open_count == 1) {
> -		ret = vfio_device_first_open(device, iommufd);
> +		ret = vfio_device_first_open(df);
>  		if (ret)
>  			device->open_count--;
>  	}
> @@ -483,14 +487,15 @@ int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
>  	return ret;
>  }
>  
> -void vfio_device_close(struct vfio_device *device,
> -		       struct iommufd_ctx *iommufd)
> +void vfio_device_close(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +
>  	lockdep_assert_held(&device->dev_set->lock);
>  
>  	vfio_assert_device_open(device);
>  	if (device->open_count == 1)
> -		vfio_device_last_close(device, iommufd);
> +		vfio_device_last_close(df);
>  	device->open_count--;
>  }
>  
> @@ -535,7 +540,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> -	vfio_device_group_close(device);
> +	vfio_device_group_close(df);
>  
>  	vfio_device_put_registration(device);
>  


Maybe it reduces the number of parameters but the diffstat shows it does
not really simplify the code overall. I am not really sure it was worth
and the df->iommufd pre and post-setting is not really nice looking to me.

But well it others are OK ...

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


