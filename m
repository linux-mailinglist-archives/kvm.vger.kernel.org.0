Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113BB6D9927
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 16:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbjDFOKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 10:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238624AbjDFOJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 10:09:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105679EF9
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 07:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680790108;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nuorJMeQjiUyIkqTHhHSdCCV1DYDfd3mDuw6Harlea0=;
        b=EAJqc5YLaysuXmIK0cCeYUtSZNYZOALZwhbvs+tO2J+C2gDEV4zNpk1mOJYxu2twlfd6kY
        1vZV2yWaL8RQxw6mr7+40fYjRtSPN9ww5Mj2TDKaWd/EWpAP2X5LTa/VxxvHGCftIf9N65
        XA2Q/ZhoXTsxhZ5gy5y+P8JunAZTGVU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-WH2_Q46JMSy-igFan4H8DA-1; Thu, 06 Apr 2023 10:08:27 -0400
X-MC-Unique: WH2_Q46JMSy-igFan4H8DA-1
Received: by mail-qt1-f198.google.com with SMTP id bp42-20020a05622a1baa00b003e6748b05edso3649034qtb.2
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 07:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680790106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuorJMeQjiUyIkqTHhHSdCCV1DYDfd3mDuw6Harlea0=;
        b=FUPeCfjQxwr3WOdO3bI132uQ7fUkyGMvl/DbOI/PxHKQ37eZsntK26DDsuBOd2U1fz
         QLVPykanqIXzecwcHp0K4HvrJnsMba2zdBvTeq+kjX6ZvdE16RLqly104fdpfqtVcNIJ
         DDTqCn6RzFD5S4dvLRxPpUd2DMbqnPQkVkeE7ryAZhrP8Btl//JUu9bu+XYdiTxT4DBZ
         S3wzfW6s9lCOugrYN8wLa0iC1Sgh/awr5ET600E4AQmtCg/fYuvbDCzddhaUnvHokkBh
         /DGEKQXNgt7zvqlDLD3HsTtqsCTRzU+KF18c8oVsMJfWyHvtWmL0r3/QV7U6mQFJwL+p
         NatQ==
X-Gm-Message-State: AAQBX9dnvWjXJaFFmdjDbVgcs7Ibh82CgTlV4xRGIqJEammdytz7UHmf
        dgZLlqxEirmMZ8KoTa6kZTQoOlf5K33H/HBsBfFJ3N+h8H57HdwhuBySRJgadRQsH2DyyQm2Dv5
        CfkosS1N5nE81
X-Received: by 2002:a05:622a:50b:b0:3d5:500a:4819 with SMTP id l11-20020a05622a050b00b003d5500a4819mr11165544qtx.23.1680790106383;
        Thu, 06 Apr 2023 07:08:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350ajobo7QI7nRIx5yFYTGV2QDXpjWJGAtG1+IAaJoyUJxbSIH9U0GyrqWBAhV+FOVFdgT+TmqQ==
X-Received: by 2002:a05:622a:50b:b0:3d5:500a:4819 with SMTP id l11-20020a05622a050b00b003d5500a4819mr11165492qtx.23.1680790105976;
        Thu, 06 Apr 2023 07:08:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id x30-20020a05620a0b5e00b0074a6692c584sm487078qkg.69.2023.04.06.07.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 07:08:24 -0700 (PDT)
Message-ID: <d8ebec5f-1742-2e51-8c6c-f02d46a6685f@redhat.com>
Date:   Thu, 6 Apr 2023 16:08:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 08/25] vfio: Block device access via device fd until
 device is opened
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
 <20230401151833.124749-9-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401151833.124749-9-yi.l.liu@intel.com>
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



On 4/1/23 17:18, Yi Liu wrote:
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device()
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
>
> The reason for the inbetween state is that userspace only gets a FD but
> doesn't gain access permission until binding the FD to an iommufd. So in
> the blocked state, only the bind operation is allowed. Completing bind
> will allow user to further access the device.
>
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
>
> Following this lockless scheme, it can safely handle the device FD
> unbound->bound but it cannot handle bound->unbound. To allow this we'd
> need to add a lock on all the vfio ioctls which seems costly. So once
> device FD is bound, it remains bound until the FD is closed.
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/group.c     | 11 ++++++++++-
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 42 ++++++++++++++++++++++++++++++++++------
>  3 files changed, 47 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 9a7b2765eef6..71f0a9a4016e 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -194,9 +194,18 @@ static int vfio_device_group_open(struct vfio_device_file *df)
>  	df->iommufd = device->group->iommufd;
>  
>  	ret = vfio_device_open(df);
> -	if (ret)
> +	if (ret) {
>  		df->iommufd = NULL;
> +		goto out_put_kvm;
> +	}
> +
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap and vfio_file_has_device_access()
> +	 */
> +	smp_store_release(&df->access_granted, true);
>  
> +out_put_kvm:
>  	if (device->open_count == 0)
>  		vfio_device_put_kvm(device);
>  
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index cffc08f5a6f1..854f2c97cb9a 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,6 +18,7 @@ struct vfio_container;
>  
>  struct vfio_device_file {
>  	struct vfio_device *device;
> +	bool access_granted;
>  	spinlock_t kvm_ref_lock; /* protect kvm field */
>  	struct kvm *kvm;
>  	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 2ea6cb6d03c7..6d5d3c2180c8 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1114,6 +1114,10 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	struct vfio_device *device = df->device;
>  	int ret;
>  
> +	/* Paired with smp_store_release() following vfio_device_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	ret = vfio_device_pm_runtime_get(device);
>  	if (ret)
>  		return ret;
> @@ -1141,6 +1145,10 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> +	/* Paired with smp_store_release() following vfio_device_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->read))
>  		return -EINVAL;
>  
> @@ -1154,6 +1162,10 @@ static ssize_t vfio_device_fops_write(struct file *filep,
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> +	/* Paired with smp_store_release() following vfio_device_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->write))
>  		return -EINVAL;
>  
> @@ -1165,6 +1177,10 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> +	/* Paired with smp_store_release() following vfio_device_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->mmap))
>  		return -EINVAL;
>  
> @@ -1201,6 +1217,25 @@ bool vfio_file_is_valid(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>  
> +/*
> + * Return true if the input file is a vfio device file and has opened
> + * the input device. Otherwise, return false.
> + */
> +static bool vfio_file_has_device_access(struct file *file,
> +					struct vfio_device *device)
> +{
> +	struct vfio_device *vdev = vfio_device_from_file(file);
> +	struct vfio_device_file *df;
> +
> +	if (!vdev || vdev != device)
> +		return false;
> +
> +	df = file->private_data;
> +
> +	/* Paired with smp_store_release() following vfio_device_open() */
> +	return smp_load_acquire(&df->access_granted);
> +}
> +
>  /**
>   * vfio_file_has_dev - True if the VFIO file is a handle for device
>   * @file: VFIO file to check
> @@ -1211,17 +1246,12 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
>  {
>  	struct vfio_group *group;
> -	struct vfio_device *vdev;
>  
>  	group = vfio_group_from_file(file);
>  	if (group)
>  		return vfio_group_has_dev(group, device);
>  
> -	vdev = vfio_device_from_file(file);
> -	if (vdev)
> -		return vdev == device;
> -
> -	return false;
> +	return vfio_file_has_device_access(file, device);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_has_dev);
>  

