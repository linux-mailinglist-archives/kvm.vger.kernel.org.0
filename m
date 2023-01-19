Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E7367364D
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjASLD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjASLDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:03:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDEE71781
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674126134;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k0C/HtEob/1oAd5ytm41MO4vaCSKLv4Oq14Cyy/bw2U=;
        b=L6/a8A7+xrlh1wMOUeVSqn5jz3XHh5pzAG32+tp02lpTc5KZsj9ggCRqhJZAHy/P+aHa+s
        UjEQ2D6QSU0vaf86wfox+j+KWeVSR/xF99Jxxdz32CIJTY6pdiospjX9nSGHZGYK87SZCj
        qfkjt73FMF/AhQ8PSHSLexKlSGol/E4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-QBIiQgtNO8ih7lJqLv1bcw-1; Thu, 19 Jan 2023 06:02:11 -0500
X-MC-Unique: QBIiQgtNO8ih7lJqLv1bcw-1
Received: by mail-qk1-f197.google.com with SMTP id bs44-20020a05620a472c00b0070673cd1b05so1129463qkb.22
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:02:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k0C/HtEob/1oAd5ytm41MO4vaCSKLv4Oq14Cyy/bw2U=;
        b=xF7nfJzVI0k0WF+URFhpDS9pBx7C212Npu/0oiwamXS0ioOK+0UMLcHA5jdkjRGv8j
         V/7c4ZKEn7gkFwtjgV6We4NKzPV0uHK4MbwpH7ey5S3x1/z99CLzHRPGf2k0xG8+U3Tg
         18Vkwdv8mw0OIIXMbwUO+0UXMzFuKOrSRi0tnHVA1mvCcVocoIvIW5f1QpBFAONSlZfa
         wjfxw7TmpyZXpsNxvXUig2rlxCrdpWOwAUqP+iBGWEn19zx1K6b9+fy2eTHvV8Or94z2
         cyVCF9T+0f4U00WJsh4ceunQjRFFndglHvgZoaguReehxq1S45i2S8Y2asbAktpzWarX
         0wEg==
X-Gm-Message-State: AFqh2kqSlmZIqOtf62lA9HWbil1i4pM3VZFG8kH8z8ARZZZhyKqXFQCd
        9tBxBTPo0WBpfsTGAkpLAOAHe1wNw4Xkx299X1Om5/ztU/x5pSRzzi1PXO2m3r1d/dlkfMx5P7a
        09A3am5may8I7
X-Received: by 2002:ac8:71c8:0:b0:3af:b6bd:aba7 with SMTP id i8-20020ac871c8000000b003afb6bdaba7mr14148429qtp.43.1674126125917;
        Thu, 19 Jan 2023 03:02:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuNjgtg0JqJEV+rxRkWTxbBj5fQftEz5zbS31cgmvbXd0BNYvoF9mLE++iwFMfYLa+fW5gBZA==
X-Received: by 2002:ac8:71c8:0:b0:3af:b6bd:aba7 with SMTP id i8-20020ac871c8000000b003afb6bdaba7mr14148401qtp.43.1674126125590;
        Thu, 19 Jan 2023 03:02:05 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id e25-20020ac86719000000b003b2d890752dsm3371429qtp.88.2023.01.19.03.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 03:02:04 -0800 (PST)
Message-ID: <537e68ee-6dab-97e0-4797-1ca5cec4c710@redhat.com>
Date:   Thu, 19 Jan 2023 12:01:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-8-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117134942.101112-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 1/17/23 14:49, Yi Liu wrote:
> This avoids passing struct kvm * and struct iommufd_ctx * in multiple
> functions. vfio_device_open() becomes to be a locked helper.
why? because dev_set lock now protects vfio_device_file fields? worth to
explain.
do we need to update the comment in vfio.h related to struct
vfio_device_set?
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 34 +++++++++++++++++++++++++---------
>  drivers/vfio/vfio.h      | 10 +++++-----
>  drivers/vfio/vfio_main.c | 40 ++++++++++++++++++++++++----------------
>  3 files changed, 54 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index d83cf069d290..7200304663e5 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -154,33 +154,49 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  	return ret;
>  }
>  
> -static int vfio_device_group_open(struct vfio_device *device)
> +static int vfio_device_group_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
>  	int ret;
>  
>  	mutex_lock(&device->group->group_lock);
>  	if (!vfio_group_has_iommu(device->group)) {
>  		ret = -EINVAL;
> -		goto out_unlock;
> +		goto err_unlock_group;
>  	}
>  
> +	mutex_lock(&device->dev_set->lock);
is there an explanation somewhere about locking order b/w group_lock,
dev_set lock?
>  	/*
>  	 * Here we pass the KVM pointer with the group under the lock.  If the
>  	 * device driver will use it, it must obtain a reference and release it
>  	 * during close_device.
>  	 */
May be the opportunity to rephrase the above comment. I am not a native
english speaker but the time concordance seems weird + clarify a
reference to what.
> -	ret = vfio_device_open(device, device->group->iommufd,
> -			       device->group->kvm);
> +	df->kvm = device->group->kvm;
> +	df->iommufd = device->group->iommufd;
> +
> +	ret = vfio_device_open(df);
> +	if (ret)
> +		goto err_unlock_device;
> +	mutex_unlock(&device->dev_set->lock);
>  
> -out_unlock:
> +	mutex_unlock(&device->group->group_lock);
> +	return 0;
> +
> +err_unlock_device:
> +	df->kvm = NULL;
> +	df->iommufd = NULL;
> +	mutex_unlock(&device->dev_set->lock);
> +err_unlock_group:
>  	mutex_unlock(&device->group->group_lock);
>  	return ret;
>  }
>  
> -void vfio_device_group_close(struct vfio_device *device)
> +void vfio_device_group_close(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +
>  	mutex_lock(&device->group->group_lock);
> -	vfio_device_close(device, device->group->iommufd);
> +	vfio_device_close(df);
>  	mutex_unlock(&device->group->group_lock);
>  }
>  
> @@ -196,7 +212,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  		goto err_out;
>  	}
>  
> -	ret = vfio_device_group_open(device);
> +	ret = vfio_device_group_open(df);
>  	if (ret)
>  		goto err_free;
>  
> @@ -228,7 +244,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  	return filep;
>  
>  err_close_device:
> -	vfio_device_group_close(device);
> +	vfio_device_group_close(df);
>  err_free:
>  	kfree(df);
>  err_out:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 53af6e3ea214..3d8ba165146c 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -19,14 +19,14 @@ struct vfio_container;
>  struct vfio_device_file {
>  	struct vfio_device *device;
>  	struct kvm *kvm;
> +	struct iommufd_ctx *iommufd;
>  };
>  
>  void vfio_device_put_registration(struct vfio_device *device);
>  bool vfio_device_try_get_registration(struct vfio_device *device);
> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm);
> -void vfio_device_close(struct vfio_device *device,
> -		       struct iommufd_ctx *iommufd);
> +int vfio_device_open(struct vfio_device_file *df);
> +void vfio_device_close(struct vfio_device_file *device);
> +
>  struct vfio_device_file *
>  vfio_allocate_device_file(struct vfio_device *device);
>  
> @@ -90,7 +90,7 @@ void vfio_device_group_register(struct vfio_device *device);
>  void vfio_device_group_unregister(struct vfio_device *device);
>  int vfio_device_group_use_iommu(struct vfio_device *device);
>  void vfio_device_group_unuse_iommu(struct vfio_device *device);
> -void vfio_device_group_close(struct vfio_device *device);
> +void vfio_device_group_close(struct vfio_device_file *df);
>  struct vfio_group *vfio_group_from_file(struct file *file);
>  bool vfio_group_enforced_coherent(struct vfio_group *group);
>  void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index dc08d5dd62cc..3df71bd9cd1e 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -358,9 +358,11 @@ vfio_allocate_device_file(struct vfio_device *device)
>  	return df;
>  }
>  
> -static int vfio_device_first_open(struct vfio_device *device,
> -				  struct iommufd_ctx *iommufd, struct kvm *kvm)
> +static int vfio_device_first_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +	struct iommufd_ctx *iommufd = df->iommufd;
> +	struct kvm *kvm = df->kvm;
>  	int ret;
>  
>  	lockdep_assert_held(&device->dev_set->lock);
> @@ -394,9 +396,11 @@ static int vfio_device_first_open(struct vfio_device *device,
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
> @@ -409,30 +413,34 @@ static void vfio_device_last_close(struct vfio_device *device,
>  	module_put(device->dev->driver->owner);
>  }
>  
> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm)
> +int vfio_device_open(struct vfio_device_file *df)
>  {
> -	int ret = 0;
> +	struct vfio_device *device = df->device;
> +
> +	lockdep_assert_held(&device->dev_set->lock);
>  
> -	mutex_lock(&device->dev_set->lock);
>  	device->open_count++;
>  	if (device->open_count == 1) {
> -		ret = vfio_device_first_open(device, iommufd, kvm);
> -		if (ret)
> +		int ret;
> +
> +		ret = vfio_device_first_open(df);
> +		if (ret) {
>  			device->open_count--;
> +			return ret;
nit: the original ret init and return was good enough, no need to change it?
> +		}
>  	}
> -	mutex_unlock(&device->dev_set->lock);
>  
> -	return ret;
> +	return 0;
>  }
>  
> -void vfio_device_close(struct vfio_device *device,
> -		       struct iommufd_ctx *iommufd)
> +void vfio_device_close(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +
>  	mutex_lock(&device->dev_set->lock);
>  	vfio_assert_device_open(device);
>  	if (device->open_count == 1)
> -		vfio_device_last_close(device, iommufd);
> +		vfio_device_last_close(df);
>  	device->open_count--;
>  	mutex_unlock(&device->dev_set->lock);
>  }
> @@ -478,7 +486,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> -	vfio_device_group_close(device);
> +	vfio_device_group_close(df);
>  
>  	vfio_device_put_registration(device);
>  
Thanks

Eric

